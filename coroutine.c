#include "coroutine.h"
#include "types.h"
#include "stat.h"
#include "user.h"
#include "param.h"
typedef unsigned long u64;
struct co_context {
  addr_t r15;
  addr_t r14;
  addr_t r13;
  addr_t r12;
  addr_t rbx;
  addr_t rbp;
  addr_t rip;
};

struct coroutine {
  struct co_context * context; // points to the co_context constructed on stack
  struct coroutine * next; // the next coroutine on the list
  char * stack; // remember where is the allocated stack memory. Use this to free the stack in co_destroy()
};

//// global variables
// the host thread has a dedicated context
static struct co_context * host_context = 0;

// the current coroutine;
// 0 (NULL): not running a coroutine
static struct coroutine * co_current = 0;

// a list of live coroutines
// co_new() adds a coroutine to the list
// co_exit() removes a coroutine from the list
static struct coroutine * co_list = 0;

// The swtch() function is implemented in swtch.S
// you need to call swtch() from co_yield() and co_run()
extern void swtch(struct co_context ** pp_old, struct co_context * p_new);

  struct coroutine *
co_new(void (*func)(void))
{
  struct coroutine * co1 = malloc(sizeof(*co1));
  if (co1 == 0)
    return 0;

  // prepare the context
  co1->stack = malloc(8192);
  if (co1->stack == 0) {
    free(co1);
    return 0;
  }
  u64 * ptr = co1->stack + 1000;
  ptr[6] = (u64)func;
  ptr[7] = (u64)co_exit;
  co1->context = (void*) ptr;
  
  if(co_list == 0)
  {
  	co_list = co1;
  }else{
	struct coroutine * head = co_list;
	while(head->next != 0)
	{
		head = head->next;
	}
	head = co1;
  }
  
  // done
  return co1;
}

  int
co_run(void)
{
	if(co_list != 0)
	{
		co_current = co_list;
		swtch(&host_context,co_current->context);
		return 1;
	}
	return 0;
}

  int
co_run_all(void)
{
	if(co_list == 0){
		return 0;
	}else{
		struct coroutine * tmp = co_list;
		while(tmp != 0){
			co_run();
			tmp = tmp->next;
		}
		return 1;
	}
}

  void
co_yield()
{
  // TODO: your code here
  // it must be safe to call co_yield() from a host context (or any non-coroutine)
  struct coroutine * tmp = co_current;
  if(tmp->next != 0)
  {
  	co_current = co_current->next;
  	swtch(&tmp->context,co_current->context);
  }else{
	co_current = 0;
	swtch(&tmp->context,host_context);
  }
}

  void
co_exit(void)
{
  // TODO: your code here
  // it makes no sense to co_exit from non-coroutine.
	if(!co_current)
		return;
	struct coroutine *tmp = co_list;
	struct coroutine *prev;

	while(tmp){
		if(tmp == co_current)
		{
			if(tmp->next)
			{
				if(prev)
				{
					prev->next = tmp->next;
				}
				co_list = tmp->next;
				swtch(&co_current->context,tmp->context);
			}else{
				co_list = 0;
				swtch(&co_current->context,host_context);
			}
		}
		prev = tmp;
		tmp = tmp->next;
	}
}

  void
co_destroy(struct coroutine * const co)
{
  if (co) {
    if (co->stack)
      free(co->stack);
    free(co);
  }
}
