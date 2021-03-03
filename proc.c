#include "types.h"
#include "defs.h"
#include "param.h"
#include "memlayout.h"
#include "mmu.h"
#include "x86.h"
#include "proc.h"
#include "spinlock.h"
#include "aio.h"
#include "sleeplock.h"
#include "file.h"

struct {
  struct spinlock lock;
  struct proc proc[NPROC];
} ptable;

static struct proc *initproc;

int nextpid = 1;
extern void forkret(void);
extern void syscall_trapret(void);

static void wakeup1(void *chan);

void
pinit(void)
{
  initlock(&ptable.lock, "ptable");
}

//PAGEBREAK: 32
// Look in the process table for an UNUSED proc.
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
    if(p->state == UNUSED)
      goto found;

  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
  p->pid = nextpid++;

  release(&ptable.lock);

  p->is_process = 1; // regular process
  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
    p->state = UNUSED;
    return 0;
  }
  sp = p->kstack + KSTACKSIZE;

  // Leave room for trap frame.
  sp -= sizeof *p->tf;
  p->tf = (struct trapframe*)sp;

  // Set up new context to start executing at forkret,
  // which returns to trapret.
  sp -= sizeof(addr_t);
  *(addr_t*)sp = (addr_t)syscall_trapret;

  sp -= sizeof *p->context;
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
  p->context->rip = (addr_t)forkret;

  return p;
}

//PAGEBREAK: 32
// Set up first user process.
void
userinit(void)
{
  struct proc *p;
  extern char _binary_initcode_start[], _binary_initcode_size[];
  p = allocproc();

  initproc = p;
  if((p->pgdir = setupkvm()) == 0)
    panic("userinit: out of memory?");

  inituvm(p->pgdir, _binary_initcode_start,
          (addr_t)_binary_initcode_size);
  p->sz = PGSIZE * 2;
  memset(p->tf, 0, sizeof(*p->tf));

  p->tf->r11 = FL_IF;  // with SYSRET, EFLAGS is in R11
  p->tf->rsp = p->sz;
  p->tf->rcx = PGSIZE;  // with SYSRET, RIP is in RCX

  safestrcpy(p->name, "initcode", sizeof(p->name));
  p->cwd = namei("/");

  __sync_synchronize();
  p->state = RUNNABLE;
}

// Grow current process's memory by n bytes.
// Return 0 on success, -1 on failure.
int
growproc(int64 n)
{
  addr_t sz;

  sz = proc->sz;
  if(n > 0){
    if((sz = allocuvm(proc->pgdir, sz, sz + n)) == 0)
      return -1;
  } else if(n < 0){
    if((sz = deallocuvm(proc->pgdir, sz, sz + n)) == 0)
      return -1;
  }
  proc->sz = sz;
  switchuvm(proc);
  return 0;
}
//PAGEBREAK!

// Create a new process copying p as the parent.
// Sets up stack to return as if from system call.
// Caller must set state of returned proc to RUNNABLE.
int
fork(void)
{
  int i, pid;
  struct proc *np;

  // Allocate process.
  if((np = allocproc()) == 0)
    return -1;

  // Copy process state from p.
  if((np->pgdir = copyuvm(proc->pgdir, proc->sz)) == 0){
    kfree(np->kstack);
    np->kstack = 0;
    np->state = UNUSED;
    return -1;
  }
  np->sz = proc->sz;
  np->parent = proc;
  *np->tf = *proc->tf;

  // Clear %rax so that fork returns 0 in the child.
  np->tf->rax = 0;

  for(i = 0; i < NOFILE; i++)
    if(proc->ofile[i])
      np->ofile[i] = filedup(proc->ofile[i]);
  np->cwd = idup(proc->cwd);

  safestrcpy(np->name, proc->name, sizeof(proc->name));

  pid = np->pid;

  __sync_synchronize();
  np->state = RUNNABLE;

  return pid;
}

//PAGEBREAK!
// Exit the current process.  Does not return.
// An exited process remains in the zombie state
// until its parent calls wait() to find out it exited.
void
exit(void)
{
  struct proc *p;
  int fd;

  if(proc == initproc)
    panic("init exiting");

  // Close all open files.
  for(fd = 0; fd < NOFILE; fd++){
    if(proc->ofile[fd]){
      fileclose(proc->ofile[fd]);
      proc->ofile[fd] = 0;
    }
  }

  begin_op();
  iput(proc->cwd);
  end_op();
  proc->cwd = 0;

  acquire(&ptable.lock);

  // Parent might be sleeping in wait().
  wakeup1(proc->parent);

  // Pass abandoned children to init.
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->parent == proc){
      p->parent = initproc;
      if(p->state == ZOMBIE)
        wakeup1(initproc);
    }
  }

  // Jump into the scheduler, never to return.
  proc->state = ZOMBIE;
  sched();
  panic("zombie exit");
}

//PAGEBREAK!
// Wait for a child process to exit and return its pid.
// Return -1 if this process has no children.
int
wait(void)
{
  struct proc *p;
  int havekids, pid;

  acquire(&ptable.lock);
  for(;;){
    // Scan through table looking for exited children.
    havekids = 0;
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
      if(p->parent != proc)
        continue;
      havekids = 1;
      if(p->state == ZOMBIE){
        // Found one.
        pid = p->pid;
        kfree(p->kstack);
        p->kstack = 0;
        freevm(p->pgdir);
        p->pid = 0;
        p->parent = 0;
        p->name[0] = 0;
        p->killed = 0;
        p->state = UNUSED;
        release(&ptable.lock);
        return pid;
      }
    }

    // No point waiting if we don't have any children.
    if(!havekids || proc->killed){
      release(&ptable.lock);
      return -1;
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(proc, &ptable.lock);  //DOC: wait-sleep
  }
}

//PAGEBREAK: 42
// Per-CPU process scheduler.
// Each CPU calls scheduler() after setting itself up.
// Scheduler never returns.  It loops, doing:
//  - choose a process to run
//  - swtch to start running that process
//  - eventually that process transfers control
//      via swtch back to the scheduler.
void
scheduler(void)
{
  int i = 0;
  struct proc *p;
  int skipped = 0;
  for(;;){
    ++i;
    // Enable interrupts on this processor.
    sti();
    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
      if(p->state != RUNNABLE) {
        skipped++;
        continue;
      }
      skipped = 0;

      // Switch to chosen process.  It is the process's job
      // to release ptable.lock and then reacquire it
      // before jumping back to us.
      proc = p;
      if (p->is_process) {
        switchuvm(p);
      }
      p->state = RUNNING;
      swtch(&cpu->scheduler, p->context);
      switchkvm();

      // clean-up kthread
      if (proc->state == KZOMBIE) {
        kfree(proc->kstack);
        proc->kstack = 0;
        proc->pid = 0;
        proc->state = UNUSED;
      }

      // Process is done running for now.
      // It should have changed its p->state before coming back.
      proc = 0;
    }
    release(&ptable.lock);
    if (skipped > (2*NPROC)) {
      hlt();
      skipped = 0;
    }
  }
}

// Enter scheduler.  Must hold only ptable.lock
// and have changed proc->state. Saves and restores
// intena because intena is a property of this
// kernel thread, not this CPU. It should
// be proc->intena and proc->ncli, but that would
// break in the few places where a lock is held but
// there's no process.
void
sched(void)
{
  int intena;


  if(!holding(&ptable.lock))
    panic("sched ptable.lock");
  if(cpu->ncli != 1)
    panic("sched locks");
  if(proc->state == RUNNING)
    panic("sched running");
  if(readeflags()&FL_IF)
    panic("sched interruptible");
  intena = cpu->intena;

  swtch(&proc->context, cpu->scheduler);
  cpu->intena = intena;
}

// Give up the CPU for one scheduling round.
void
yield(void)
{
  acquire(&ptable.lock);  //DOC: yieldlock
  proc->state = RUNNABLE;
  sched();
  release(&ptable.lock);
}



// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);

  if (first && proc->is_process) {
    // Some initialization functions must be run in the context
    // of a regular process (e.g., they call sleep), and thus cannot
    // be run from main().
    first = 0;
    iinit(ROOTDEV);
    initlog(ROOTDEV);
  }

  // Return to "caller", actually trapret (see allocproc).
}

//PAGEBREAK!
// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
  if(proc == 0)
    panic("sleep");

  if(lk == 0)
    panic("sleep without lk");

  // Must acquire ptable.lock in order to
  // change p->state and then call sched.
  // Once we hold ptable.lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup runs with ptable.lock locked),
  // so it's okay to release lk.
  if(lk != &ptable.lock){  //DOC: sleeplock0
    acquire(&ptable.lock);  //DOC: sleeplock1
    release(lk);
  }

  // Go to sleep.
  proc->chan = chan;
  proc->state = SLEEPING;
  sched();

  // Tidy up.
  proc->chan = 0;

  // Reacquire original lock.
  if(lk != &ptable.lock){  //DOC: sleeplock2
    release(&ptable.lock);
    acquire(lk);
  }
}

//PAGEBREAK!
// Wake up all processes sleeping on chan.
// The ptable lock must be held.
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
    if(p->state == SLEEPING && p->chan == chan)
      p->state = RUNNABLE;
}

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
  acquire(&ptable.lock);
  wakeup1(chan);
  release(&ptable.lock);
}

// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
  struct proc *p;

  acquire(&ptable.lock);
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->pid == pid){
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
        p->state = RUNNABLE;
      release(&ptable.lock);
      return 0;
    }
  }
  release(&ptable.lock);
  return -1;
}

//PAGEBREAK: 36
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
  static char *states[] = {
  [UNUSED]    "unused",
  [EMBRYO]    "embryo",
  [SLEEPING]  "sleep ",
  [RUNNABLE]  "runble",
  [RUNNING]   "run   ",
  [ZOMBIE]    "zombie",
  [KZOMBIE]   "kzombie",
  };
  int i;
  struct proc *p;
  char *state;
  addr_t pc[10];

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
      state = states[p->state];
    else
      state = "???";
    cprintf("%d %s %s", p->pid, state, p->name);
    if(p->state == SLEEPING){
      getstackpcs((addr_t*)p->context->rbp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
  }
}

static void
exitkth(void)
{
  acquire(&ptable.lock);
  proc->state = KZOMBIE;
  sched();
  panic("zombie kth_exit");
}

  int
startkth(addr_t kroutine)
{
  // reuse the code in allocproc. startkth requires the following changes for kernel threads (kth):
  // (1) a kth is not a process
  // (2) it does not need a trapframe since it does not run in the user space
  // (3) it does not need a private page table
  // (4) its execution will make the following calls: forkret(), then kroutine(), then exitkth()
  // (5) it should be ready to execute when startkth returns
  // (6) it has a name "kthread" (for "CTRL+p" in the xv6 shell, see procdump() above)
  // TODO: Your code here
  struct proc *p;
  char *sp;
  //p->is_process = 0;
  acquire(&ptable.lock);

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
    if(p->state == UNUSED)
      goto found;

  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
  p->pid = nextpid++;
  release(&ptable.lock);
  p->is_process = 1; // regular process
  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
    p->state = UNUSED;
    return 0;
  }
  sp = p->kstack + KSTACKSIZE;
  // Leave room for trap frame.
  //sp -= sizeof *p->tf;

  // Set up new context to start executing at forkret,
  // which returns to trapret.
  
  sp -= sizeof(addr_t);
  *(addr_t*)sp = (addr_t)exitkth;
  
  sp -= sizeof(addr_t);
  *(addr_t*)sp = (addr_t)kroutine;
  
  sp -= sizeof *p->context;
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
  p->context->rip = (addr_t)forkret;
  
  p->name[0] = 'k';
  p->name[1] = 't';
  p->name[2] = 'h';
  p->name[3] = 'r';
  p->name[4] = 'e';
  p->name[5] = 'a';
  p->name[6] = 'd';
  p->is_process = 0;
  __sync_synchronize();
  p->state = RUNNABLE;
  return p;
}


/*void
this_forkret(void){
	forkret();
	proc->kth_route;
	exitkth();
}*/


dummy_kth(void)
{
  cprintf("%s is running\n", __func__);
  for (int i = 0; i < 3; i++) {
    acquire(&tickslock);
    uint ticks0 = ticks;
    do {
      sleep(&ticks, &tickslock);
    } while (ticks - ticks0 < 100);
    release(&tickslock);
  }
  cprintf("%s will now stop\n", __func__);
}

struct aio_task {
  volatile int * status; // this must be a kernel address; updated after completion
  pde_t * pgdir; // the page table of the target process
  struct inode * ip;
  void * buffer;
  int offset;
  int nbytes;
};

static struct aio_task aio_tasks[64] = {};
static volatile int num_tasks = 0; // <= 64

static struct spinlock aio_lock;

  static void
aread_consume_one_task(struct aio_task * t)
{
  // execute the task t
  // use the tmp as a buffer for file I/O
  // use copyout() to copy the data in tmp to the user-provided buffer
  // finally, update the execution status to the user process
  // TODO: Your code here
int count = 0;
//cprintf("IP SIZe: %d\n", t->ip->size);
//cprintf("Nbytes: %d\n", t->nbytes);
int sizeofinput = t->ip->size;
int offset = t->offset;
static char tmp[4096];
while(0 < sizeofinput){

	if(t->ip->size > PGSIZE){
		readi(t->ip, tmp,t->offset,PGSIZE);
		offset += PGSIZE;
		sizeofinput-= PGSIZE;
	}else{
		readi(t->ip, tmp, t->offset, sizeofinput);
		offset += sizeofinput;
		sizeofinput = 0;
	}
	if(copyout(t->pgdir,(addr_t)t->buffer,&tmp, t->nbytes) == -1){
		cprintf("copyout failed!!\n");
		break;
	}
}

if(copyout(t->pgdir,(addr_t) t->status, &t->nbytes, sizeof(int)) == -1){
                cprintf("copyout2 failed!!\n");
}
memset(tmp,0,PGSIZE);
}

  static void
aread_kth(void)
{
  cprintf("%s is running at %p\n", __func__, proc->kstack);
  do {
    // don't need the lock
    while (num_tasks) {
      aread_consume_one_task(&aio_tasks[0]);
      // remove the task from the queue
      acquire(&aio_lock);
      memmove(aio_tasks, aio_tasks+1, sizeof(aio_tasks[0]) * (num_tasks-1));
      num_tasks--;
      release(&aio_lock);
    }

    acquire(&tickslock);
    sleep(&ticks, &tickslock);
    release(&tickslock);
  } while (1);
}

  void
kthinit(void)
{
  if (!startkth((addr_t)dummy_kth))
    cprintf("start dummy_kth failed\n");
  initlock(&aio_lock, "aio");
  if (!startkth((addr_t)aread_kth))
    cprintf("start aread_kth failed\n");
}

  int
sys_aread(void)
{
  struct file *file;
  int offset, nbytes;
  char *buffer;
  volatile int * status;

  argint(2, &offset);
  argint(3, &nbytes);
  if (nbytes <= 0)
    return -1;
  if (argfd(0, 0, &file) < 0 || argptr(1, &buffer, nbytes) < 0 || argptr(4, (char **)&status, sizeof(int)) < 0)
    return -1;

  *status = 0; // processing

  // nothing to copy
  if (file->ip->size <= offset)
    return 0; // no I/O required

  // maybe we will only get fewer bytes
  if (offset + nbytes > file->ip->size)
    nbytes = file->ip->size - offset;

  // append the task to the aio queue
  // TODO: Your code here
  acquire(&aio_lock);

  aio_tasks[num_tasks].status = status;
  aio_tasks[num_tasks].pgdir = proc->pgdir;
  aio_tasks[num_tasks].ip = file->ip;
  aio_tasks[num_tasks].buffer = buffer;
  aio_tasks[num_tasks].offset = offset;
  aio_tasks[num_tasks].nbytes = nbytes; 
  num_tasks++;
  release(&aio_lock);
  
  // return how many bytes to expect (> 0)
  return nbytes;
}
