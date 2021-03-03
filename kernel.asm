
kernel:     file format elf64-x86-64


Disassembly of section .text:

ffff800000100000 <begin>:
ffff800000100000:	02 b0 ad 1b 00 00    	add    0x1bad(%rax),%dh
ffff800000100006:	01 00                	add    %eax,(%rax)
ffff800000100008:	fe 4f 51             	decb   0x51(%rdi)
ffff80000010000b:	e4 00                	in     $0x0,%al
ffff80000010000d:	00 10                	add    %dl,(%rax)
ffff80000010000f:	00 00                	add    %al,(%rax)
ffff800000100011:	00 10                	add    %dl,(%rax)
ffff800000100013:	00 00                	add    %al,(%rax)
ffff800000100015:	e0 10                	loopne ffff800000100027 <mboot_entry+0x7>
ffff800000100017:	00 00                	add    %al,(%rax)
ffff800000100019:	d0 11                	rclb   (%rcx)
ffff80000010001b:	00 20                	add    %ah,(%rax)
ffff80000010001d:	00 10                	add    %dl,(%rax)
	...

ffff800000100020 <mboot_entry>:
  .long mboot_entry_addr

.code32
mboot_entry:
# zero 2 pages for our bootstrap page tables
  xor     %eax, %eax    # value=0
ffff800000100020:	31 c0                	xor    %eax,%eax
  mov     $0x1000, %edi # starting at 4096
ffff800000100022:	bf 00 10 00 00       	mov    $0x1000,%edi
  mov     $0x2000, %ecx # size=8192
ffff800000100027:	b9 00 20 00 00       	mov    $0x2000,%ecx
  rep     stosb         # memset(4096, 0, 8192)
ffff80000010002c:	f3 aa                	rep stos %al,%es:(%rdi)

# map both virtual address 0 and KERNBASE to the same PDPT
# PML4T[0] -> 0x2000 (PDPT)
# PML4T[256] -> 0x2000 (PDPT)
  mov     $(0x2000 | PTE_P | PTE_W), %eax
ffff80000010002e:	b8 03 20 00 00       	mov    $0x2003,%eax
  mov     %eax, 0x1000  # PML4T[0]
ffff800000100033:	a3 00 10 00 00 a3 00 	movabs %eax,0x1800a300001000
ffff80000010003a:	18 00 
  mov     %eax, 0x1800  # PML4T[512]
ffff80000010003c:	00 b8 83 00 00 00    	add    %bh,0x83(%rax)

# PDPT[0] -> 0x0 (1 GB flat map page)
  mov     $(0x0 | PTE_P | PTE_PS | PTE_W), %eax
  mov     %eax, 0x2000  # PDPT[0]
ffff800000100042:	a3                   	.byte 0xa3
ffff800000100043:	00 20                	add    %ah,(%rax)
ffff800000100045:	00 00                	add    %al,(%rax)

# Clear ebx for initial processor boot.
# When secondary processors boot, they'll call through
# entry32mp (from entryother), but with a nonzero ebx.
# We'll reuse these bootstrap pagetables and GDT.
  xor     %ebx, %ebx
ffff800000100047:	31 db                	xor    %ebx,%ebx

ffff800000100049 <entry32mp>:

.global entry32mp
entry32mp:
# CR3 -> 0x1000 (PML4T)
  mov     $0x1000, %eax
ffff800000100049:	b8 00 10 00 00       	mov    $0x1000,%eax
  mov     %eax, %cr3
ffff80000010004e:	0f 22 d8             	mov    %rax,%cr3

  lgdt    (gdtr64 - mboot_header + mboot_load_addr)
ffff800000100051:	0f 01 15 90 00 10 00 	lgdt   0x100090(%rip)        # ffff8000002000e8 <end+0xe30e8>

# PAE is required for 64-bit paging: CR4.PAE=1
  mov     %cr4, %eax
ffff800000100058:	0f 20 e0             	mov    %cr4,%rax
  bts     $5, %eax
ffff80000010005b:	0f ba e8 05          	bts    $0x5,%eax
  mov     %eax, %cr4
ffff80000010005f:	0f 22 e0             	mov    %rax,%cr4

# access EFER Model specific register
  mov     $MSR_EFER, %ecx
ffff800000100062:	b9 80 00 00 c0       	mov    $0xc0000080,%ecx
  rdmsr
ffff800000100067:	0f 32                	rdmsr  
  bts     $0, %eax #enable system call extentions
ffff800000100069:	0f ba e8 00          	bts    $0x0,%eax
  bts     $8, %eax #enable long mode
ffff80000010006d:	0f ba e8 08          	bts    $0x8,%eax
  wrmsr
ffff800000100071:	0f 30                	wrmsr  

# enable paging
  mov     %cr0, %eax
ffff800000100073:	0f 20 c0             	mov    %cr0,%rax
  orl     $(CR0_PG | CR0_WP | CR0_MP), %eax
ffff800000100076:	0d 02 00 01 80       	or     $0x80010002,%eax
  mov     %eax, %cr0
ffff80000010007b:	0f 22 c0             	mov    %rax,%cr0

# shift to 64bit segment
  ljmp    $8, $(entry64low - mboot_header + mboot_load_addr)
ffff80000010007e:	ea                   	(bad)  
ffff80000010007f:	c0 00 10             	rolb   $0x10,(%rax)
ffff800000100082:	00 08                	add    %cl,(%rax)
ffff800000100084:	00 66 66             	add    %ah,0x66(%rsi)
ffff800000100087:	2e 0f 1f 84 00 00 00 	nopl   %cs:0x0(%rax,%rax,1)
ffff80000010008e:	00 00 

ffff800000100090 <gdtr64>:
ffff800000100090:	17                   	(bad)  
ffff800000100091:	00 a0 00 10 00 00    	add    %ah,0x1000(%rax)
ffff800000100097:	00 00                	add    %al,(%rax)
ffff800000100099:	00 66 0f             	add    %ah,0xf(%rsi)
ffff80000010009c:	1f                   	(bad)  
ffff80000010009d:	44 00 00             	add    %r8b,(%rax)

ffff8000001000a0 <gdt64_begin>:
	...
ffff8000001000ac:	00 98 20 00 00 00    	add    %bl,0x20(%rax)
ffff8000001000b2:	00 00                	add    %al,(%rax)
ffff8000001000b4:	00                   	.byte 0x0
ffff8000001000b5:	90                   	nop
	...

ffff8000001000b8 <gdt64_end>:
ffff8000001000b8:	0f 1f 84 00 00 00 00 	nopl   0x0(%rax,%rax,1)
ffff8000001000bf:	00 

ffff8000001000c0 <entry64low>:
gdt64_end:

.align 16
.code64
entry64low:
  movabs  $entry64high, %rax
ffff8000001000c0:	48 b8 cc 00 10 00 00 	movabs $0xffff8000001000cc,%rax
ffff8000001000c7:	80 ff ff 
  jmp     *%rax
ffff8000001000ca:	ff e0                	jmpq   *%rax

ffff8000001000cc <_start>:
.global _start
_start:
entry64high:

# ensure data segment registers are sane
  xor     %rax, %rax
ffff8000001000cc:	48 31 c0             	xor    %rax,%rax
  mov     %ax, %ss
ffff8000001000cf:	8e d0                	mov    %eax,%ss
  mov     %ax, %ds
ffff8000001000d1:	8e d8                	mov    %eax,%ds
  mov     %ax, %es
ffff8000001000d3:	8e c0                	mov    %eax,%es
  mov     %ax, %fs
ffff8000001000d5:	8e e0                	mov    %eax,%fs
  mov     %ax, %gs
ffff8000001000d7:	8e e8                	mov    %eax,%gs
  # mov     %cr4, %rax
  # or      $(CR4_PAE | CR4_OSXFSR | CR4_OSXMMEXCPT) , %rax
  # mov     %rax, %cr4

# check to see if we're booting a secondary core
  test    %ebx, %ebx
ffff8000001000d9:	85 db                	test   %ebx,%ebx
  jnz     entry64mp  # jump if booting a secondary code
ffff8000001000db:	75 14                	jne    ffff8000001000f1 <entry64mp>
# setup initial stack
  movabs  $0xFFFF800000010000, %rax
ffff8000001000dd:	48 b8 00 00 01 00 00 	movabs $0xffff800000010000,%rax
ffff8000001000e4:	80 ff ff 
  mov     %rax, %rsp
ffff8000001000e7:	48 89 c4             	mov    %rax,%rsp

# enter main()
  jmp     main  # end of initial (the first) core ASM
ffff8000001000ea:	e9 a5 53 00 00       	jmpq   ffff800000105494 <main>

ffff8000001000ef <__deadloop>:

.global __deadloop
__deadloop:
# we should never return here...
  jmp     .
ffff8000001000ef:	eb fe                	jmp    ffff8000001000ef <__deadloop>

ffff8000001000f1 <entry64mp>:

entry64mp:
# obtain kstack from data block before entryother
  mov     $0x7000, %rax
ffff8000001000f1:	48 c7 c0 00 70 00 00 	mov    $0x7000,%rax
  mov     -16(%rax), %rsp
ffff8000001000f8:	48 8b 60 f0          	mov    -0x10(%rax),%rsp
  jmp     mpenter  # end of secondary code ASM
ffff8000001000fc:	e9 d0 54 00 00       	jmpq   ffff8000001055d1 <mpenter>

ffff800000100101 <wrmsr>:

.global wrmsr
wrmsr:
  mov     %rdi, %rcx     # arg0 -> msrnum
ffff800000100101:	48 89 f9             	mov    %rdi,%rcx
  mov     %rsi, %rax     # val.low -> eax
ffff800000100104:	48 89 f0             	mov    %rsi,%rax
  shr     $32, %rsi
ffff800000100107:	48 c1 ee 20          	shr    $0x20,%rsi
  mov     %rsi, %rdx     # val.high -> edx
ffff80000010010b:	48 89 f2             	mov    %rsi,%rdx
  wrmsr
ffff80000010010e:	0f 30                	wrmsr  
  retq
ffff800000100110:	c3                   	retq   

ffff800000100111 <ignore_sysret>:

.global ignore_sysret
ignore_sysret: #return error code 38, meaning function unimplemented
  mov     $-38, %rax
ffff800000100111:	48 c7 c0 da ff ff ff 	mov    $0xffffffffffffffda,%rax
  sysret
ffff800000100118:	0f 07                	sysret 

ffff80000010011a <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
ffff80000010011a:	f3 0f 1e fa          	endbr64 
ffff80000010011e:	55                   	push   %rbp
ffff80000010011f:	48 89 e5             	mov    %rsp,%rbp
ffff800000100122:	48 83 ec 10          	sub    $0x10,%rsp
  struct buf *b;

  initlock(&bcache.lock, "bcache");
ffff800000100126:	48 be c0 c7 10 00 00 	movabs $0xffff80000010c7c0,%rsi
ffff80000010012d:	80 ff ff 
ffff800000100130:	48 bf 00 e0 10 00 00 	movabs $0xffff80000010e000,%rdi
ffff800000100137:	80 ff ff 
ffff80000010013a:	48 b8 de 7e 10 00 00 	movabs $0xffff800000107ede,%rax
ffff800000100141:	80 ff ff 
ffff800000100144:	ff d0                	callq  *%rax
//PAGEBREAK!

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
ffff800000100146:	48 b8 00 e0 10 00 00 	movabs $0xffff80000010e000,%rax
ffff80000010014d:	80 ff ff 
ffff800000100150:	48 b9 08 31 11 00 00 	movabs $0xffff800000113108,%rcx
ffff800000100157:	80 ff ff 
ffff80000010015a:	48 89 88 a0 51 00 00 	mov    %rcx,0x51a0(%rax)
  bcache.head.next = &bcache.head;
ffff800000100161:	48 b8 00 e0 10 00 00 	movabs $0xffff80000010e000,%rax
ffff800000100168:	80 ff ff 
ffff80000010016b:	48 89 88 a8 51 00 00 	mov    %rcx,0x51a8(%rax)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
ffff800000100172:	48 b8 68 e0 10 00 00 	movabs $0xffff80000010e068,%rax
ffff800000100179:	80 ff ff 
ffff80000010017c:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
ffff800000100180:	e9 8b 00 00 00       	jmpq   ffff800000100210 <binit+0xf6>
    b->next = bcache.head.next;
ffff800000100185:	48 b8 00 e0 10 00 00 	movabs $0xffff80000010e000,%rax
ffff80000010018c:	80 ff ff 
ffff80000010018f:	48 8b 90 a8 51 00 00 	mov    0x51a8(%rax),%rdx
ffff800000100196:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff80000010019a:	48 89 90 a0 00 00 00 	mov    %rdx,0xa0(%rax)
    b->prev = &bcache.head;
ffff8000001001a1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff8000001001a5:	48 be 08 31 11 00 00 	movabs $0xffff800000113108,%rsi
ffff8000001001ac:	80 ff ff 
ffff8000001001af:	48 89 b0 98 00 00 00 	mov    %rsi,0x98(%rax)
    initsleeplock(&b->lock, "buffer");
ffff8000001001b6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff8000001001ba:	48 83 c0 10          	add    $0x10,%rax
ffff8000001001be:	48 be c7 c7 10 00 00 	movabs $0xffff80000010c7c7,%rsi
ffff8000001001c5:	80 ff ff 
ffff8000001001c8:	48 89 c7             	mov    %rax,%rdi
ffff8000001001cb:	48 b8 eb 7c 10 00 00 	movabs $0xffff800000107ceb,%rax
ffff8000001001d2:	80 ff ff 
ffff8000001001d5:	ff d0                	callq  *%rax
    bcache.head.next->prev = b;
ffff8000001001d7:	48 b8 00 e0 10 00 00 	movabs $0xffff80000010e000,%rax
ffff8000001001de:	80 ff ff 
ffff8000001001e1:	48 8b 80 a8 51 00 00 	mov    0x51a8(%rax),%rax
ffff8000001001e8:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
ffff8000001001ec:	48 89 90 98 00 00 00 	mov    %rdx,0x98(%rax)
    bcache.head.next = b;
ffff8000001001f3:	48 ba 00 e0 10 00 00 	movabs $0xffff80000010e000,%rdx
ffff8000001001fa:	80 ff ff 
ffff8000001001fd:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000100201:	48 89 82 a8 51 00 00 	mov    %rax,0x51a8(%rdx)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
ffff800000100208:	48 81 45 f8 b0 02 00 	addq   $0x2b0,-0x8(%rbp)
ffff80000010020f:	00 
ffff800000100210:	48 b8 08 31 11 00 00 	movabs $0xffff800000113108,%rax
ffff800000100217:	80 ff ff 
ffff80000010021a:	48 39 45 f8          	cmp    %rax,-0x8(%rbp)
ffff80000010021e:	0f 82 61 ff ff ff    	jb     ffff800000100185 <binit+0x6b>
  }
}
ffff800000100224:	90                   	nop
ffff800000100225:	90                   	nop
ffff800000100226:	c9                   	leaveq 
ffff800000100227:	c3                   	retq   

ffff800000100228 <bget>:
// Look through buffer cache for block on device dev.
// If not found, allocate a buffer.
// In either case, return locked buffer.
static struct buf*
bget(uint dev, uint blockno)
{
ffff800000100228:	f3 0f 1e fa          	endbr64 
ffff80000010022c:	55                   	push   %rbp
ffff80000010022d:	48 89 e5             	mov    %rsp,%rbp
ffff800000100230:	48 83 ec 20          	sub    $0x20,%rsp
ffff800000100234:	89 7d ec             	mov    %edi,-0x14(%rbp)
ffff800000100237:	89 75 e8             	mov    %esi,-0x18(%rbp)
  struct buf *b;

  acquire(&bcache.lock);
ffff80000010023a:	48 bf 00 e0 10 00 00 	movabs $0xffff80000010e000,%rdi
ffff800000100241:	80 ff ff 
ffff800000100244:	48 b8 17 7f 10 00 00 	movabs $0xffff800000107f17,%rax
ffff80000010024b:	80 ff ff 
ffff80000010024e:	ff d0                	callq  *%rax

  // Is the block already cached?
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
ffff800000100250:	48 b8 00 e0 10 00 00 	movabs $0xffff80000010e000,%rax
ffff800000100257:	80 ff ff 
ffff80000010025a:	48 8b 80 a8 51 00 00 	mov    0x51a8(%rax),%rax
ffff800000100261:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
ffff800000100265:	eb 74                	jmp    ffff8000001002db <bget+0xb3>
    if(b->dev == dev && b->blockno == blockno){
ffff800000100267:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff80000010026b:	8b 40 04             	mov    0x4(%rax),%eax
ffff80000010026e:	39 45 ec             	cmp    %eax,-0x14(%rbp)
ffff800000100271:	75 59                	jne    ffff8000001002cc <bget+0xa4>
ffff800000100273:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000100277:	8b 40 08             	mov    0x8(%rax),%eax
ffff80000010027a:	39 45 e8             	cmp    %eax,-0x18(%rbp)
ffff80000010027d:	75 4d                	jne    ffff8000001002cc <bget+0xa4>
      b->refcnt++;
ffff80000010027f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000100283:	8b 80 90 00 00 00    	mov    0x90(%rax),%eax
ffff800000100289:	8d 50 01             	lea    0x1(%rax),%edx
ffff80000010028c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000100290:	89 90 90 00 00 00    	mov    %edx,0x90(%rax)
      release(&bcache.lock);
ffff800000100296:	48 bf 00 e0 10 00 00 	movabs $0xffff80000010e000,%rdi
ffff80000010029d:	80 ff ff 
ffff8000001002a0:	48 b8 b4 7f 10 00 00 	movabs $0xffff800000107fb4,%rax
ffff8000001002a7:	80 ff ff 
ffff8000001002aa:	ff d0                	callq  *%rax
      acquiresleep(&b->lock);
ffff8000001002ac:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff8000001002b0:	48 83 c0 10          	add    $0x10,%rax
ffff8000001002b4:	48 89 c7             	mov    %rax,%rdi
ffff8000001002b7:	48 b8 44 7d 10 00 00 	movabs $0xffff800000107d44,%rax
ffff8000001002be:	80 ff ff 
ffff8000001002c1:	ff d0                	callq  *%rax
      return b;
ffff8000001002c3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff8000001002c7:	e9 f0 00 00 00       	jmpq   ffff8000001003bc <bget+0x194>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
ffff8000001002cc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff8000001002d0:	48 8b 80 a0 00 00 00 	mov    0xa0(%rax),%rax
ffff8000001002d7:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
ffff8000001002db:	48 b8 08 31 11 00 00 	movabs $0xffff800000113108,%rax
ffff8000001002e2:	80 ff ff 
ffff8000001002e5:	48 39 45 f8          	cmp    %rax,-0x8(%rbp)
ffff8000001002e9:	0f 85 78 ff ff ff    	jne    ffff800000100267 <bget+0x3f>
  }

  // Not cached; recycle some unused buffer and clean buffer
  // "clean" because B_DIRTY and not locked means log.c
  // hasn't yet committed the changes to the buffer.
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
ffff8000001002ef:	48 b8 00 e0 10 00 00 	movabs $0xffff80000010e000,%rax
ffff8000001002f6:	80 ff ff 
ffff8000001002f9:	48 8b 80 a0 51 00 00 	mov    0x51a0(%rax),%rax
ffff800000100300:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
ffff800000100304:	e9 89 00 00 00       	jmpq   ffff800000100392 <bget+0x16a>
    if(b->refcnt == 0 && (b->flags & B_DIRTY) == 0) {
ffff800000100309:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff80000010030d:	8b 80 90 00 00 00    	mov    0x90(%rax),%eax
ffff800000100313:	85 c0                	test   %eax,%eax
ffff800000100315:	75 6c                	jne    ffff800000100383 <bget+0x15b>
ffff800000100317:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff80000010031b:	8b 00                	mov    (%rax),%eax
ffff80000010031d:	83 e0 04             	and    $0x4,%eax
ffff800000100320:	85 c0                	test   %eax,%eax
ffff800000100322:	75 5f                	jne    ffff800000100383 <bget+0x15b>
      b->dev = dev;
ffff800000100324:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000100328:	8b 55 ec             	mov    -0x14(%rbp),%edx
ffff80000010032b:	89 50 04             	mov    %edx,0x4(%rax)
      b->blockno = blockno;
ffff80000010032e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000100332:	8b 55 e8             	mov    -0x18(%rbp),%edx
ffff800000100335:	89 50 08             	mov    %edx,0x8(%rax)
      b->flags = 0;
ffff800000100338:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff80000010033c:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
      b->refcnt = 1;
ffff800000100342:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000100346:	c7 80 90 00 00 00 01 	movl   $0x1,0x90(%rax)
ffff80000010034d:	00 00 00 
      release(&bcache.lock);
ffff800000100350:	48 bf 00 e0 10 00 00 	movabs $0xffff80000010e000,%rdi
ffff800000100357:	80 ff ff 
ffff80000010035a:	48 b8 b4 7f 10 00 00 	movabs $0xffff800000107fb4,%rax
ffff800000100361:	80 ff ff 
ffff800000100364:	ff d0                	callq  *%rax
      acquiresleep(&b->lock);
ffff800000100366:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff80000010036a:	48 83 c0 10          	add    $0x10,%rax
ffff80000010036e:	48 89 c7             	mov    %rax,%rdi
ffff800000100371:	48 b8 44 7d 10 00 00 	movabs $0xffff800000107d44,%rax
ffff800000100378:	80 ff ff 
ffff80000010037b:	ff d0                	callq  *%rax
      return b;
ffff80000010037d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000100381:	eb 39                	jmp    ffff8000001003bc <bget+0x194>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
ffff800000100383:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000100387:	48 8b 80 98 00 00 00 	mov    0x98(%rax),%rax
ffff80000010038e:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
ffff800000100392:	48 b8 08 31 11 00 00 	movabs $0xffff800000113108,%rax
ffff800000100399:	80 ff ff 
ffff80000010039c:	48 39 45 f8          	cmp    %rax,-0x8(%rbp)
ffff8000001003a0:	0f 85 63 ff ff ff    	jne    ffff800000100309 <bget+0xe1>
    }
  }
  panic("bget: no buffers");
ffff8000001003a6:	48 bf ce c7 10 00 00 	movabs $0xffff80000010c7ce,%rdi
ffff8000001003ad:	80 ff ff 
ffff8000001003b0:	48 b8 f9 0b 10 00 00 	movabs $0xffff800000100bf9,%rax
ffff8000001003b7:	80 ff ff 
ffff8000001003ba:	ff d0                	callq  *%rax
}
ffff8000001003bc:	c9                   	leaveq 
ffff8000001003bd:	c3                   	retq   

ffff8000001003be <bread>:

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
ffff8000001003be:	f3 0f 1e fa          	endbr64 
ffff8000001003c2:	55                   	push   %rbp
ffff8000001003c3:	48 89 e5             	mov    %rsp,%rbp
ffff8000001003c6:	48 83 ec 20          	sub    $0x20,%rsp
ffff8000001003ca:	89 7d ec             	mov    %edi,-0x14(%rbp)
ffff8000001003cd:	89 75 e8             	mov    %esi,-0x18(%rbp)
  struct buf *b;

  b = bget(dev, blockno);
ffff8000001003d0:	8b 55 e8             	mov    -0x18(%rbp),%edx
ffff8000001003d3:	8b 45 ec             	mov    -0x14(%rbp),%eax
ffff8000001003d6:	89 d6                	mov    %edx,%esi
ffff8000001003d8:	89 c7                	mov    %eax,%edi
ffff8000001003da:	48 b8 28 02 10 00 00 	movabs $0xffff800000100228,%rax
ffff8000001003e1:	80 ff ff 
ffff8000001003e4:	ff d0                	callq  *%rax
ffff8000001003e6:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  if(!(b->flags & B_VALID)) {
ffff8000001003ea:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff8000001003ee:	8b 00                	mov    (%rax),%eax
ffff8000001003f0:	83 e0 02             	and    $0x2,%eax
ffff8000001003f3:	85 c0                	test   %eax,%eax
ffff8000001003f5:	75 13                	jne    ffff80000010040a <bread+0x4c>
    iderw(b);
ffff8000001003f7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff8000001003fb:	48 89 c7             	mov    %rax,%rdi
ffff8000001003fe:	48 b8 37 3d 10 00 00 	movabs $0xffff800000103d37,%rax
ffff800000100405:	80 ff ff 
ffff800000100408:	ff d0                	callq  *%rax
  }
  return b;
ffff80000010040a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
ffff80000010040e:	c9                   	leaveq 
ffff80000010040f:	c3                   	retq   

ffff800000100410 <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
ffff800000100410:	f3 0f 1e fa          	endbr64 
ffff800000100414:	55                   	push   %rbp
ffff800000100415:	48 89 e5             	mov    %rsp,%rbp
ffff800000100418:	48 83 ec 10          	sub    $0x10,%rsp
ffff80000010041c:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  if(!holdingsleep(&b->lock))
ffff800000100420:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000100424:	48 83 c0 10          	add    $0x10,%rax
ffff800000100428:	48 89 c7             	mov    %rax,%rdi
ffff80000010042b:	48 b8 37 7e 10 00 00 	movabs $0xffff800000107e37,%rax
ffff800000100432:	80 ff ff 
ffff800000100435:	ff d0                	callq  *%rax
ffff800000100437:	85 c0                	test   %eax,%eax
ffff800000100439:	75 16                	jne    ffff800000100451 <bwrite+0x41>
    panic("bwrite");
ffff80000010043b:	48 bf df c7 10 00 00 	movabs $0xffff80000010c7df,%rdi
ffff800000100442:	80 ff ff 
ffff800000100445:	48 b8 f9 0b 10 00 00 	movabs $0xffff800000100bf9,%rax
ffff80000010044c:	80 ff ff 
ffff80000010044f:	ff d0                	callq  *%rax
  b->flags |= B_DIRTY;
ffff800000100451:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000100455:	8b 00                	mov    (%rax),%eax
ffff800000100457:	83 c8 04             	or     $0x4,%eax
ffff80000010045a:	89 c2                	mov    %eax,%edx
ffff80000010045c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000100460:	89 10                	mov    %edx,(%rax)
  iderw(b);
ffff800000100462:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000100466:	48 89 c7             	mov    %rax,%rdi
ffff800000100469:	48 b8 37 3d 10 00 00 	movabs $0xffff800000103d37,%rax
ffff800000100470:	80 ff ff 
ffff800000100473:	ff d0                	callq  *%rax
}
ffff800000100475:	90                   	nop
ffff800000100476:	c9                   	leaveq 
ffff800000100477:	c3                   	retq   

ffff800000100478 <brelse>:

// Release a locked buffer.
// Move to the head of the MRU list.
void
brelse(struct buf *b)
{
ffff800000100478:	f3 0f 1e fa          	endbr64 
ffff80000010047c:	55                   	push   %rbp
ffff80000010047d:	48 89 e5             	mov    %rsp,%rbp
ffff800000100480:	48 83 ec 10          	sub    $0x10,%rsp
ffff800000100484:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  if(!holdingsleep(&b->lock))
ffff800000100488:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff80000010048c:	48 83 c0 10          	add    $0x10,%rax
ffff800000100490:	48 89 c7             	mov    %rax,%rdi
ffff800000100493:	48 b8 37 7e 10 00 00 	movabs $0xffff800000107e37,%rax
ffff80000010049a:	80 ff ff 
ffff80000010049d:	ff d0                	callq  *%rax
ffff80000010049f:	85 c0                	test   %eax,%eax
ffff8000001004a1:	75 16                	jne    ffff8000001004b9 <brelse+0x41>
    panic("brelse");
ffff8000001004a3:	48 bf e6 c7 10 00 00 	movabs $0xffff80000010c7e6,%rdi
ffff8000001004aa:	80 ff ff 
ffff8000001004ad:	48 b8 f9 0b 10 00 00 	movabs $0xffff800000100bf9,%rax
ffff8000001004b4:	80 ff ff 
ffff8000001004b7:	ff d0                	callq  *%rax

  releasesleep(&b->lock);
ffff8000001004b9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff8000001004bd:	48 83 c0 10          	add    $0x10,%rax
ffff8000001004c1:	48 89 c7             	mov    %rax,%rdi
ffff8000001004c4:	48 b8 ce 7d 10 00 00 	movabs $0xffff800000107dce,%rax
ffff8000001004cb:	80 ff ff 
ffff8000001004ce:	ff d0                	callq  *%rax

  acquire(&bcache.lock);
ffff8000001004d0:	48 bf 00 e0 10 00 00 	movabs $0xffff80000010e000,%rdi
ffff8000001004d7:	80 ff ff 
ffff8000001004da:	48 b8 17 7f 10 00 00 	movabs $0xffff800000107f17,%rax
ffff8000001004e1:	80 ff ff 
ffff8000001004e4:	ff d0                	callq  *%rax
  b->refcnt--;
ffff8000001004e6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff8000001004ea:	8b 80 90 00 00 00    	mov    0x90(%rax),%eax
ffff8000001004f0:	8d 50 ff             	lea    -0x1(%rax),%edx
ffff8000001004f3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff8000001004f7:	89 90 90 00 00 00    	mov    %edx,0x90(%rax)
  if (b->refcnt == 0) {
ffff8000001004fd:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000100501:	8b 80 90 00 00 00    	mov    0x90(%rax),%eax
ffff800000100507:	85 c0                	test   %eax,%eax
ffff800000100509:	0f 85 9c 00 00 00    	jne    ffff8000001005ab <brelse+0x133>
    // no one is waiting for it.
    b->next->prev = b->prev;
ffff80000010050f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000100513:	48 8b 80 a0 00 00 00 	mov    0xa0(%rax),%rax
ffff80000010051a:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
ffff80000010051e:	48 8b 92 98 00 00 00 	mov    0x98(%rdx),%rdx
ffff800000100525:	48 89 90 98 00 00 00 	mov    %rdx,0x98(%rax)
    b->prev->next = b->next;
ffff80000010052c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000100530:	48 8b 80 98 00 00 00 	mov    0x98(%rax),%rax
ffff800000100537:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
ffff80000010053b:	48 8b 92 a0 00 00 00 	mov    0xa0(%rdx),%rdx
ffff800000100542:	48 89 90 a0 00 00 00 	mov    %rdx,0xa0(%rax)
    b->next = bcache.head.next;
ffff800000100549:	48 b8 00 e0 10 00 00 	movabs $0xffff80000010e000,%rax
ffff800000100550:	80 ff ff 
ffff800000100553:	48 8b 90 a8 51 00 00 	mov    0x51a8(%rax),%rdx
ffff80000010055a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff80000010055e:	48 89 90 a0 00 00 00 	mov    %rdx,0xa0(%rax)
    b->prev = &bcache.head;
ffff800000100565:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000100569:	48 b9 08 31 11 00 00 	movabs $0xffff800000113108,%rcx
ffff800000100570:	80 ff ff 
ffff800000100573:	48 89 88 98 00 00 00 	mov    %rcx,0x98(%rax)
    bcache.head.next->prev = b;
ffff80000010057a:	48 b8 00 e0 10 00 00 	movabs $0xffff80000010e000,%rax
ffff800000100581:	80 ff ff 
ffff800000100584:	48 8b 80 a8 51 00 00 	mov    0x51a8(%rax),%rax
ffff80000010058b:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
ffff80000010058f:	48 89 90 98 00 00 00 	mov    %rdx,0x98(%rax)
    bcache.head.next = b;
ffff800000100596:	48 ba 00 e0 10 00 00 	movabs $0xffff80000010e000,%rdx
ffff80000010059d:	80 ff ff 
ffff8000001005a0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff8000001005a4:	48 89 82 a8 51 00 00 	mov    %rax,0x51a8(%rdx)
  }

  release(&bcache.lock);
ffff8000001005ab:	48 bf 00 e0 10 00 00 	movabs $0xffff80000010e000,%rdi
ffff8000001005b2:	80 ff ff 
ffff8000001005b5:	48 b8 b4 7f 10 00 00 	movabs $0xffff800000107fb4,%rax
ffff8000001005bc:	80 ff ff 
ffff8000001005bf:	ff d0                	callq  *%rax
}
ffff8000001005c1:	90                   	nop
ffff8000001005c2:	c9                   	leaveq 
ffff8000001005c3:	c3                   	retq   

ffff8000001005c4 <inb>:
// Routines to let C code use special x86 instructions.

static inline uchar
inb(ushort port)
{
ffff8000001005c4:	f3 0f 1e fa          	endbr64 
ffff8000001005c8:	55                   	push   %rbp
ffff8000001005c9:	48 89 e5             	mov    %rsp,%rbp
ffff8000001005cc:	48 83 ec 18          	sub    $0x18,%rsp
ffff8000001005d0:	89 f8                	mov    %edi,%eax
ffff8000001005d2:	66 89 45 ec          	mov    %ax,-0x14(%rbp)
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
ffff8000001005d6:	0f b7 45 ec          	movzwl -0x14(%rbp),%eax
ffff8000001005da:	89 c2                	mov    %eax,%edx
ffff8000001005dc:	ec                   	in     (%dx),%al
ffff8000001005dd:	88 45 ff             	mov    %al,-0x1(%rbp)
  return data;
ffff8000001005e0:	0f b6 45 ff          	movzbl -0x1(%rbp),%eax
}
ffff8000001005e4:	c9                   	leaveq 
ffff8000001005e5:	c3                   	retq   

ffff8000001005e6 <outb>:
               "memory", "cc");
}

static inline void
outb(ushort port, uchar data)
{
ffff8000001005e6:	f3 0f 1e fa          	endbr64 
ffff8000001005ea:	55                   	push   %rbp
ffff8000001005eb:	48 89 e5             	mov    %rsp,%rbp
ffff8000001005ee:	48 83 ec 08          	sub    $0x8,%rsp
ffff8000001005f2:	89 f8                	mov    %edi,%eax
ffff8000001005f4:	89 f2                	mov    %esi,%edx
ffff8000001005f6:	66 89 45 fc          	mov    %ax,-0x4(%rbp)
ffff8000001005fa:	89 d0                	mov    %edx,%eax
ffff8000001005fc:	88 45 f8             	mov    %al,-0x8(%rbp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
ffff8000001005ff:	0f b6 45 f8          	movzbl -0x8(%rbp),%eax
ffff800000100603:	0f b7 55 fc          	movzwl -0x4(%rbp),%edx
ffff800000100607:	ee                   	out    %al,(%dx)
}
ffff800000100608:	90                   	nop
ffff800000100609:	c9                   	leaveq 
ffff80000010060a:	c3                   	retq   

ffff80000010060b <lidt>:

struct gatedesc;

static inline void
lidt(struct gatedesc *p, int size)
{
ffff80000010060b:	f3 0f 1e fa          	endbr64 
ffff80000010060f:	55                   	push   %rbp
ffff800000100610:	48 89 e5             	mov    %rsp,%rbp
ffff800000100613:	48 83 ec 30          	sub    $0x30,%rsp
ffff800000100617:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
ffff80000010061b:	89 75 d4             	mov    %esi,-0x2c(%rbp)
  volatile ushort pd[5];
  addr_t addr = (addr_t)p;
ffff80000010061e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
ffff800000100622:	48 89 45 f8          	mov    %rax,-0x8(%rbp)

  pd[0] = size-1;
ffff800000100626:	8b 45 d4             	mov    -0x2c(%rbp),%eax
ffff800000100629:	83 e8 01             	sub    $0x1,%eax
ffff80000010062c:	66 89 45 ee          	mov    %ax,-0x12(%rbp)
  pd[1] = addr;
ffff800000100630:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000100634:	66 89 45 f0          	mov    %ax,-0x10(%rbp)
  pd[2] = addr >> 16;
ffff800000100638:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff80000010063c:	48 c1 e8 10          	shr    $0x10,%rax
ffff800000100640:	66 89 45 f2          	mov    %ax,-0xe(%rbp)
  pd[3] = addr >> 32;
ffff800000100644:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000100648:	48 c1 e8 20          	shr    $0x20,%rax
ffff80000010064c:	66 89 45 f4          	mov    %ax,-0xc(%rbp)
  pd[4] = addr >> 48;
ffff800000100650:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000100654:	48 c1 e8 30          	shr    $0x30,%rax
ffff800000100658:	66 89 45 f6          	mov    %ax,-0xa(%rbp)

  asm volatile("lidt (%0)" : : "r" (pd));
ffff80000010065c:	48 8d 45 ee          	lea    -0x12(%rbp),%rax
ffff800000100660:	0f 01 18             	lidt   (%rax)
}
ffff800000100663:	90                   	nop
ffff800000100664:	c9                   	leaveq 
ffff800000100665:	c3                   	retq   

ffff800000100666 <cli>:
  return eflags;
}

static inline void
cli(void)
{
ffff800000100666:	f3 0f 1e fa          	endbr64 
ffff80000010066a:	55                   	push   %rbp
ffff80000010066b:	48 89 e5             	mov    %rsp,%rbp
  asm volatile("cli");
ffff80000010066e:	fa                   	cli    
}
ffff80000010066f:	90                   	nop
ffff800000100670:	5d                   	pop    %rbp
ffff800000100671:	c3                   	retq   

ffff800000100672 <hlt>:
  asm volatile("sti");
}

static inline void
hlt(void)
{
ffff800000100672:	f3 0f 1e fa          	endbr64 
ffff800000100676:	55                   	push   %rbp
ffff800000100677:	48 89 e5             	mov    %rsp,%rbp
  asm volatile("hlt");
ffff80000010067a:	f4                   	hlt    
}
ffff80000010067b:	90                   	nop
ffff80000010067c:	5d                   	pop    %rbp
ffff80000010067d:	c3                   	retq   

ffff80000010067e <print_x64>:

static char digits[] = "0123456789abcdef";

  static void
print_x64(addr_t x)
{
ffff80000010067e:	f3 0f 1e fa          	endbr64 
ffff800000100682:	55                   	push   %rbp
ffff800000100683:	48 89 e5             	mov    %rsp,%rbp
ffff800000100686:	48 83 ec 20          	sub    $0x20,%rsp
ffff80000010068a:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  int i;
  for (i = 0; i < (sizeof(addr_t) * 2); i++, x <<= 4)
ffff80000010068e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
ffff800000100695:	eb 30                	jmp    ffff8000001006c7 <print_x64+0x49>
    consputc(digits[x >> (sizeof(addr_t) * 8 - 4)]);
ffff800000100697:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff80000010069b:	48 c1 e8 3c          	shr    $0x3c,%rax
ffff80000010069f:	48 ba 00 d0 10 00 00 	movabs $0xffff80000010d000,%rdx
ffff8000001006a6:	80 ff ff 
ffff8000001006a9:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax
ffff8000001006ad:	0f be c0             	movsbl %al,%eax
ffff8000001006b0:	89 c7                	mov    %eax,%edi
ffff8000001006b2:	48 b8 e7 0e 10 00 00 	movabs $0xffff800000100ee7,%rax
ffff8000001006b9:	80 ff ff 
ffff8000001006bc:	ff d0                	callq  *%rax
  for (i = 0; i < (sizeof(addr_t) * 2); i++, x <<= 4)
ffff8000001006be:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
ffff8000001006c2:	48 c1 65 e8 04       	shlq   $0x4,-0x18(%rbp)
ffff8000001006c7:	8b 45 fc             	mov    -0x4(%rbp),%eax
ffff8000001006ca:	83 f8 0f             	cmp    $0xf,%eax
ffff8000001006cd:	76 c8                	jbe    ffff800000100697 <print_x64+0x19>
}
ffff8000001006cf:	90                   	nop
ffff8000001006d0:	90                   	nop
ffff8000001006d1:	c9                   	leaveq 
ffff8000001006d2:	c3                   	retq   

ffff8000001006d3 <print_x32>:

  static void
print_x32(uint x)
{
ffff8000001006d3:	f3 0f 1e fa          	endbr64 
ffff8000001006d7:	55                   	push   %rbp
ffff8000001006d8:	48 89 e5             	mov    %rsp,%rbp
ffff8000001006db:	48 83 ec 20          	sub    $0x20,%rsp
ffff8000001006df:	89 7d ec             	mov    %edi,-0x14(%rbp)
  int i;
  for (i = 0; i < (sizeof(uint) * 2); i++, x <<= 4)
ffff8000001006e2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
ffff8000001006e9:	eb 31                	jmp    ffff80000010071c <print_x32+0x49>
    consputc(digits[x >> (sizeof(uint) * 8 - 4)]);
ffff8000001006eb:	8b 45 ec             	mov    -0x14(%rbp),%eax
ffff8000001006ee:	c1 e8 1c             	shr    $0x1c,%eax
ffff8000001006f1:	89 c2                	mov    %eax,%edx
ffff8000001006f3:	48 b8 00 d0 10 00 00 	movabs $0xffff80000010d000,%rax
ffff8000001006fa:	80 ff ff 
ffff8000001006fd:	89 d2                	mov    %edx,%edx
ffff8000001006ff:	0f b6 04 10          	movzbl (%rax,%rdx,1),%eax
ffff800000100703:	0f be c0             	movsbl %al,%eax
ffff800000100706:	89 c7                	mov    %eax,%edi
ffff800000100708:	48 b8 e7 0e 10 00 00 	movabs $0xffff800000100ee7,%rax
ffff80000010070f:	80 ff ff 
ffff800000100712:	ff d0                	callq  *%rax
  for (i = 0; i < (sizeof(uint) * 2); i++, x <<= 4)
ffff800000100714:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
ffff800000100718:	c1 65 ec 04          	shll   $0x4,-0x14(%rbp)
ffff80000010071c:	8b 45 fc             	mov    -0x4(%rbp),%eax
ffff80000010071f:	83 f8 07             	cmp    $0x7,%eax
ffff800000100722:	76 c7                	jbe    ffff8000001006eb <print_x32+0x18>
}
ffff800000100724:	90                   	nop
ffff800000100725:	90                   	nop
ffff800000100726:	c9                   	leaveq 
ffff800000100727:	c3                   	retq   

ffff800000100728 <print_d>:

  static void
print_d(int v)
{
ffff800000100728:	f3 0f 1e fa          	endbr64 
ffff80000010072c:	55                   	push   %rbp
ffff80000010072d:	48 89 e5             	mov    %rsp,%rbp
ffff800000100730:	48 83 ec 30          	sub    $0x30,%rsp
ffff800000100734:	89 7d dc             	mov    %edi,-0x24(%rbp)
  char buf[16];
  int64 x = v;
ffff800000100737:	8b 45 dc             	mov    -0x24(%rbp),%eax
ffff80000010073a:	48 98                	cltq   
ffff80000010073c:	48 89 45 f8          	mov    %rax,-0x8(%rbp)

  if (v < 0)
ffff800000100740:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
ffff800000100744:	79 04                	jns    ffff80000010074a <print_d+0x22>
    x = -x;
ffff800000100746:	48 f7 5d f8          	negq   -0x8(%rbp)

  int i = 0;
ffff80000010074a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%rbp)
  do {
    buf[i++] = digits[x % 10];
ffff800000100751:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
ffff800000100755:	48 ba 67 66 66 66 66 	movabs $0x6666666666666667,%rdx
ffff80000010075c:	66 66 66 
ffff80000010075f:	48 89 c8             	mov    %rcx,%rax
ffff800000100762:	48 f7 ea             	imul   %rdx
ffff800000100765:	48 c1 fa 02          	sar    $0x2,%rdx
ffff800000100769:	48 89 c8             	mov    %rcx,%rax
ffff80000010076c:	48 c1 f8 3f          	sar    $0x3f,%rax
ffff800000100770:	48 29 c2             	sub    %rax,%rdx
ffff800000100773:	48 89 d0             	mov    %rdx,%rax
ffff800000100776:	48 c1 e0 02          	shl    $0x2,%rax
ffff80000010077a:	48 01 d0             	add    %rdx,%rax
ffff80000010077d:	48 01 c0             	add    %rax,%rax
ffff800000100780:	48 29 c1             	sub    %rax,%rcx
ffff800000100783:	48 89 ca             	mov    %rcx,%rdx
ffff800000100786:	8b 45 f4             	mov    -0xc(%rbp),%eax
ffff800000100789:	8d 48 01             	lea    0x1(%rax),%ecx
ffff80000010078c:	89 4d f4             	mov    %ecx,-0xc(%rbp)
ffff80000010078f:	48 b9 00 d0 10 00 00 	movabs $0xffff80000010d000,%rcx
ffff800000100796:	80 ff ff 
ffff800000100799:	0f b6 14 11          	movzbl (%rcx,%rdx,1),%edx
ffff80000010079d:	48 98                	cltq   
ffff80000010079f:	88 54 05 e0          	mov    %dl,-0x20(%rbp,%rax,1)
    x /= 10;
ffff8000001007a3:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
ffff8000001007a7:	48 ba 67 66 66 66 66 	movabs $0x6666666666666667,%rdx
ffff8000001007ae:	66 66 66 
ffff8000001007b1:	48 89 c8             	mov    %rcx,%rax
ffff8000001007b4:	48 f7 ea             	imul   %rdx
ffff8000001007b7:	48 c1 fa 02          	sar    $0x2,%rdx
ffff8000001007bb:	48 89 c8             	mov    %rcx,%rax
ffff8000001007be:	48 c1 f8 3f          	sar    $0x3f,%rax
ffff8000001007c2:	48 29 c2             	sub    %rax,%rdx
ffff8000001007c5:	48 89 d0             	mov    %rdx,%rax
ffff8000001007c8:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  } while(x != 0);
ffff8000001007cc:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
ffff8000001007d1:	0f 85 7a ff ff ff    	jne    ffff800000100751 <print_d+0x29>

  if (v < 0)
ffff8000001007d7:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
ffff8000001007db:	79 2d                	jns    ffff80000010080a <print_d+0xe2>
    buf[i++] = '-';
ffff8000001007dd:	8b 45 f4             	mov    -0xc(%rbp),%eax
ffff8000001007e0:	8d 50 01             	lea    0x1(%rax),%edx
ffff8000001007e3:	89 55 f4             	mov    %edx,-0xc(%rbp)
ffff8000001007e6:	48 98                	cltq   
ffff8000001007e8:	c6 44 05 e0 2d       	movb   $0x2d,-0x20(%rbp,%rax,1)

  while (--i >= 0)
ffff8000001007ed:	eb 1b                	jmp    ffff80000010080a <print_d+0xe2>
    consputc(buf[i]);
ffff8000001007ef:	8b 45 f4             	mov    -0xc(%rbp),%eax
ffff8000001007f2:	48 98                	cltq   
ffff8000001007f4:	0f b6 44 05 e0       	movzbl -0x20(%rbp,%rax,1),%eax
ffff8000001007f9:	0f be c0             	movsbl %al,%eax
ffff8000001007fc:	89 c7                	mov    %eax,%edi
ffff8000001007fe:	48 b8 e7 0e 10 00 00 	movabs $0xffff800000100ee7,%rax
ffff800000100805:	80 ff ff 
ffff800000100808:	ff d0                	callq  *%rax
  while (--i >= 0)
ffff80000010080a:	83 6d f4 01          	subl   $0x1,-0xc(%rbp)
ffff80000010080e:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
ffff800000100812:	79 db                	jns    ffff8000001007ef <print_d+0xc7>
}
ffff800000100814:	90                   	nop
ffff800000100815:	90                   	nop
ffff800000100816:	c9                   	leaveq 
ffff800000100817:	c3                   	retq   

ffff800000100818 <cprintf>:
//PAGEBREAK: 50

// Print to the console. only understands %d, %x, %p, %s.
  void
cprintf(char *fmt, ...)
{
ffff800000100818:	f3 0f 1e fa          	endbr64 
ffff80000010081c:	55                   	push   %rbp
ffff80000010081d:	48 89 e5             	mov    %rsp,%rbp
ffff800000100820:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
ffff800000100827:	48 89 bd 18 ff ff ff 	mov    %rdi,-0xe8(%rbp)
ffff80000010082e:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
ffff800000100835:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
ffff80000010083c:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
ffff800000100843:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
ffff80000010084a:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
ffff800000100851:	84 c0                	test   %al,%al
ffff800000100853:	74 20                	je     ffff800000100875 <cprintf+0x5d>
ffff800000100855:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
ffff800000100859:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
ffff80000010085d:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
ffff800000100861:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
ffff800000100865:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
ffff800000100869:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
ffff80000010086d:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
ffff800000100871:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  va_list ap;
  int i, c, locking;
  char *s;

  va_start(ap, fmt);
ffff800000100875:	c7 85 20 ff ff ff 08 	movl   $0x8,-0xe0(%rbp)
ffff80000010087c:	00 00 00 
ffff80000010087f:	c7 85 24 ff ff ff 30 	movl   $0x30,-0xdc(%rbp)
ffff800000100886:	00 00 00 
ffff800000100889:	48 8d 45 10          	lea    0x10(%rbp),%rax
ffff80000010088d:	48 89 85 28 ff ff ff 	mov    %rax,-0xd8(%rbp)
ffff800000100894:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
ffff80000010089b:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)

  locking = cons.locking;
ffff8000001008a2:	48 b8 c0 34 11 00 00 	movabs $0xffff8000001134c0,%rax
ffff8000001008a9:	80 ff ff 
ffff8000001008ac:	8b 40 68             	mov    0x68(%rax),%eax
ffff8000001008af:	89 85 3c ff ff ff    	mov    %eax,-0xc4(%rbp)
  if (locking)
ffff8000001008b5:	83 bd 3c ff ff ff 00 	cmpl   $0x0,-0xc4(%rbp)
ffff8000001008bc:	74 16                	je     ffff8000001008d4 <cprintf+0xbc>
    acquire(&cons.lock);
ffff8000001008be:	48 bf c0 34 11 00 00 	movabs $0xffff8000001134c0,%rdi
ffff8000001008c5:	80 ff ff 
ffff8000001008c8:	48 b8 17 7f 10 00 00 	movabs $0xffff800000107f17,%rax
ffff8000001008cf:	80 ff ff 
ffff8000001008d2:	ff d0                	callq  *%rax

  if (fmt == 0)
ffff8000001008d4:	48 83 bd 18 ff ff ff 	cmpq   $0x0,-0xe8(%rbp)
ffff8000001008db:	00 
ffff8000001008dc:	75 16                	jne    ffff8000001008f4 <cprintf+0xdc>
    panic("null fmt");
ffff8000001008de:	48 bf ed c7 10 00 00 	movabs $0xffff80000010c7ed,%rdi
ffff8000001008e5:	80 ff ff 
ffff8000001008e8:	48 b8 f9 0b 10 00 00 	movabs $0xffff800000100bf9,%rax
ffff8000001008ef:	80 ff ff 
ffff8000001008f2:	ff d0                	callq  *%rax

  for (i = 0; (c = fmt[i] & 0xff) != 0; i++) {
ffff8000001008f4:	c7 85 4c ff ff ff 00 	movl   $0x0,-0xb4(%rbp)
ffff8000001008fb:	00 00 00 
ffff8000001008fe:	e9 a0 02 00 00       	jmpq   ffff800000100ba3 <cprintf+0x38b>
    if (c != '%') {
ffff800000100903:	83 bd 38 ff ff ff 25 	cmpl   $0x25,-0xc8(%rbp)
ffff80000010090a:	74 19                	je     ffff800000100925 <cprintf+0x10d>
      consputc(c);
ffff80000010090c:	8b 85 38 ff ff ff    	mov    -0xc8(%rbp),%eax
ffff800000100912:	89 c7                	mov    %eax,%edi
ffff800000100914:	48 b8 e7 0e 10 00 00 	movabs $0xffff800000100ee7,%rax
ffff80000010091b:	80 ff ff 
ffff80000010091e:	ff d0                	callq  *%rax
      continue;
ffff800000100920:	e9 77 02 00 00       	jmpq   ffff800000100b9c <cprintf+0x384>
    }
    c = fmt[++i] & 0xff;
ffff800000100925:	83 85 4c ff ff ff 01 	addl   $0x1,-0xb4(%rbp)
ffff80000010092c:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
ffff800000100932:	48 63 d0             	movslq %eax,%rdx
ffff800000100935:	48 8b 85 18 ff ff ff 	mov    -0xe8(%rbp),%rax
ffff80000010093c:	48 01 d0             	add    %rdx,%rax
ffff80000010093f:	0f b6 00             	movzbl (%rax),%eax
ffff800000100942:	0f be c0             	movsbl %al,%eax
ffff800000100945:	25 ff 00 00 00       	and    $0xff,%eax
ffff80000010094a:	89 85 38 ff ff ff    	mov    %eax,-0xc8(%rbp)
    if (c == 0)
ffff800000100950:	83 bd 38 ff ff ff 00 	cmpl   $0x0,-0xc8(%rbp)
ffff800000100957:	0f 84 79 02 00 00    	je     ffff800000100bd6 <cprintf+0x3be>
      break;
    switch(c) {
ffff80000010095d:	83 bd 38 ff ff ff 78 	cmpl   $0x78,-0xc8(%rbp)
ffff800000100964:	0f 84 b0 00 00 00    	je     ffff800000100a1a <cprintf+0x202>
ffff80000010096a:	83 bd 38 ff ff ff 78 	cmpl   $0x78,-0xc8(%rbp)
ffff800000100971:	0f 8f ff 01 00 00    	jg     ffff800000100b76 <cprintf+0x35e>
ffff800000100977:	83 bd 38 ff ff ff 73 	cmpl   $0x73,-0xc8(%rbp)
ffff80000010097e:	0f 84 42 01 00 00    	je     ffff800000100ac6 <cprintf+0x2ae>
ffff800000100984:	83 bd 38 ff ff ff 73 	cmpl   $0x73,-0xc8(%rbp)
ffff80000010098b:	0f 8f e5 01 00 00    	jg     ffff800000100b76 <cprintf+0x35e>
ffff800000100991:	83 bd 38 ff ff ff 70 	cmpl   $0x70,-0xc8(%rbp)
ffff800000100998:	0f 84 d1 00 00 00    	je     ffff800000100a6f <cprintf+0x257>
ffff80000010099e:	83 bd 38 ff ff ff 70 	cmpl   $0x70,-0xc8(%rbp)
ffff8000001009a5:	0f 8f cb 01 00 00    	jg     ffff800000100b76 <cprintf+0x35e>
ffff8000001009ab:	83 bd 38 ff ff ff 25 	cmpl   $0x25,-0xc8(%rbp)
ffff8000001009b2:	0f 84 ab 01 00 00    	je     ffff800000100b63 <cprintf+0x34b>
ffff8000001009b8:	83 bd 38 ff ff ff 64 	cmpl   $0x64,-0xc8(%rbp)
ffff8000001009bf:	0f 85 b1 01 00 00    	jne    ffff800000100b76 <cprintf+0x35e>
    case 'd':
      print_d(va_arg(ap, int));
ffff8000001009c5:	8b 85 20 ff ff ff    	mov    -0xe0(%rbp),%eax
ffff8000001009cb:	83 f8 2f             	cmp    $0x2f,%eax
ffff8000001009ce:	77 23                	ja     ffff8000001009f3 <cprintf+0x1db>
ffff8000001009d0:	48 8b 85 30 ff ff ff 	mov    -0xd0(%rbp),%rax
ffff8000001009d7:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
ffff8000001009dd:	89 d2                	mov    %edx,%edx
ffff8000001009df:	48 01 d0             	add    %rdx,%rax
ffff8000001009e2:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
ffff8000001009e8:	83 c2 08             	add    $0x8,%edx
ffff8000001009eb:	89 95 20 ff ff ff    	mov    %edx,-0xe0(%rbp)
ffff8000001009f1:	eb 12                	jmp    ffff800000100a05 <cprintf+0x1ed>
ffff8000001009f3:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
ffff8000001009fa:	48 8d 50 08          	lea    0x8(%rax),%rdx
ffff8000001009fe:	48 89 95 28 ff ff ff 	mov    %rdx,-0xd8(%rbp)
ffff800000100a05:	8b 00                	mov    (%rax),%eax
ffff800000100a07:	89 c7                	mov    %eax,%edi
ffff800000100a09:	48 b8 28 07 10 00 00 	movabs $0xffff800000100728,%rax
ffff800000100a10:	80 ff ff 
ffff800000100a13:	ff d0                	callq  *%rax
      break;
ffff800000100a15:	e9 82 01 00 00       	jmpq   ffff800000100b9c <cprintf+0x384>
    case 'x':
      print_x32(va_arg(ap, uint));
ffff800000100a1a:	8b 85 20 ff ff ff    	mov    -0xe0(%rbp),%eax
ffff800000100a20:	83 f8 2f             	cmp    $0x2f,%eax
ffff800000100a23:	77 23                	ja     ffff800000100a48 <cprintf+0x230>
ffff800000100a25:	48 8b 85 30 ff ff ff 	mov    -0xd0(%rbp),%rax
ffff800000100a2c:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
ffff800000100a32:	89 d2                	mov    %edx,%edx
ffff800000100a34:	48 01 d0             	add    %rdx,%rax
ffff800000100a37:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
ffff800000100a3d:	83 c2 08             	add    $0x8,%edx
ffff800000100a40:	89 95 20 ff ff ff    	mov    %edx,-0xe0(%rbp)
ffff800000100a46:	eb 12                	jmp    ffff800000100a5a <cprintf+0x242>
ffff800000100a48:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
ffff800000100a4f:	48 8d 50 08          	lea    0x8(%rax),%rdx
ffff800000100a53:	48 89 95 28 ff ff ff 	mov    %rdx,-0xd8(%rbp)
ffff800000100a5a:	8b 00                	mov    (%rax),%eax
ffff800000100a5c:	89 c7                	mov    %eax,%edi
ffff800000100a5e:	48 b8 d3 06 10 00 00 	movabs $0xffff8000001006d3,%rax
ffff800000100a65:	80 ff ff 
ffff800000100a68:	ff d0                	callq  *%rax
      break;
ffff800000100a6a:	e9 2d 01 00 00       	jmpq   ffff800000100b9c <cprintf+0x384>
    case 'p':
      print_x64(va_arg(ap, addr_t));
ffff800000100a6f:	8b 85 20 ff ff ff    	mov    -0xe0(%rbp),%eax
ffff800000100a75:	83 f8 2f             	cmp    $0x2f,%eax
ffff800000100a78:	77 23                	ja     ffff800000100a9d <cprintf+0x285>
ffff800000100a7a:	48 8b 85 30 ff ff ff 	mov    -0xd0(%rbp),%rax
ffff800000100a81:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
ffff800000100a87:	89 d2                	mov    %edx,%edx
ffff800000100a89:	48 01 d0             	add    %rdx,%rax
ffff800000100a8c:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
ffff800000100a92:	83 c2 08             	add    $0x8,%edx
ffff800000100a95:	89 95 20 ff ff ff    	mov    %edx,-0xe0(%rbp)
ffff800000100a9b:	eb 12                	jmp    ffff800000100aaf <cprintf+0x297>
ffff800000100a9d:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
ffff800000100aa4:	48 8d 50 08          	lea    0x8(%rax),%rdx
ffff800000100aa8:	48 89 95 28 ff ff ff 	mov    %rdx,-0xd8(%rbp)
ffff800000100aaf:	48 8b 00             	mov    (%rax),%rax
ffff800000100ab2:	48 89 c7             	mov    %rax,%rdi
ffff800000100ab5:	48 b8 7e 06 10 00 00 	movabs $0xffff80000010067e,%rax
ffff800000100abc:	80 ff ff 
ffff800000100abf:	ff d0                	callq  *%rax
      break;
ffff800000100ac1:	e9 d6 00 00 00       	jmpq   ffff800000100b9c <cprintf+0x384>
    case 's':
      if ((s = va_arg(ap, char*)) == 0)
ffff800000100ac6:	8b 85 20 ff ff ff    	mov    -0xe0(%rbp),%eax
ffff800000100acc:	83 f8 2f             	cmp    $0x2f,%eax
ffff800000100acf:	77 23                	ja     ffff800000100af4 <cprintf+0x2dc>
ffff800000100ad1:	48 8b 85 30 ff ff ff 	mov    -0xd0(%rbp),%rax
ffff800000100ad8:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
ffff800000100ade:	89 d2                	mov    %edx,%edx
ffff800000100ae0:	48 01 d0             	add    %rdx,%rax
ffff800000100ae3:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
ffff800000100ae9:	83 c2 08             	add    $0x8,%edx
ffff800000100aec:	89 95 20 ff ff ff    	mov    %edx,-0xe0(%rbp)
ffff800000100af2:	eb 12                	jmp    ffff800000100b06 <cprintf+0x2ee>
ffff800000100af4:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
ffff800000100afb:	48 8d 50 08          	lea    0x8(%rax),%rdx
ffff800000100aff:	48 89 95 28 ff ff ff 	mov    %rdx,-0xd8(%rbp)
ffff800000100b06:	48 8b 00             	mov    (%rax),%rax
ffff800000100b09:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
ffff800000100b10:	48 83 bd 40 ff ff ff 	cmpq   $0x0,-0xc0(%rbp)
ffff800000100b17:	00 
ffff800000100b18:	75 39                	jne    ffff800000100b53 <cprintf+0x33b>
        s = "(null)";
ffff800000100b1a:	48 b8 f6 c7 10 00 00 	movabs $0xffff80000010c7f6,%rax
ffff800000100b21:	80 ff ff 
ffff800000100b24:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
      while (*s)
ffff800000100b2b:	eb 26                	jmp    ffff800000100b53 <cprintf+0x33b>
        consputc(*(s++));
ffff800000100b2d:	48 8b 85 40 ff ff ff 	mov    -0xc0(%rbp),%rax
ffff800000100b34:	48 8d 50 01          	lea    0x1(%rax),%rdx
ffff800000100b38:	48 89 95 40 ff ff ff 	mov    %rdx,-0xc0(%rbp)
ffff800000100b3f:	0f b6 00             	movzbl (%rax),%eax
ffff800000100b42:	0f be c0             	movsbl %al,%eax
ffff800000100b45:	89 c7                	mov    %eax,%edi
ffff800000100b47:	48 b8 e7 0e 10 00 00 	movabs $0xffff800000100ee7,%rax
ffff800000100b4e:	80 ff ff 
ffff800000100b51:	ff d0                	callq  *%rax
      while (*s)
ffff800000100b53:	48 8b 85 40 ff ff ff 	mov    -0xc0(%rbp),%rax
ffff800000100b5a:	0f b6 00             	movzbl (%rax),%eax
ffff800000100b5d:	84 c0                	test   %al,%al
ffff800000100b5f:	75 cc                	jne    ffff800000100b2d <cprintf+0x315>
      break;
ffff800000100b61:	eb 39                	jmp    ffff800000100b9c <cprintf+0x384>
    case '%':
      consputc('%');
ffff800000100b63:	bf 25 00 00 00       	mov    $0x25,%edi
ffff800000100b68:	48 b8 e7 0e 10 00 00 	movabs $0xffff800000100ee7,%rax
ffff800000100b6f:	80 ff ff 
ffff800000100b72:	ff d0                	callq  *%rax
      break;
ffff800000100b74:	eb 26                	jmp    ffff800000100b9c <cprintf+0x384>
    default:
      // Print unknown % sequence to draw attention.
      consputc('%');
ffff800000100b76:	bf 25 00 00 00       	mov    $0x25,%edi
ffff800000100b7b:	48 b8 e7 0e 10 00 00 	movabs $0xffff800000100ee7,%rax
ffff800000100b82:	80 ff ff 
ffff800000100b85:	ff d0                	callq  *%rax
      consputc(c);
ffff800000100b87:	8b 85 38 ff ff ff    	mov    -0xc8(%rbp),%eax
ffff800000100b8d:	89 c7                	mov    %eax,%edi
ffff800000100b8f:	48 b8 e7 0e 10 00 00 	movabs $0xffff800000100ee7,%rax
ffff800000100b96:	80 ff ff 
ffff800000100b99:	ff d0                	callq  *%rax
      break;
ffff800000100b9b:	90                   	nop
  for (i = 0; (c = fmt[i] & 0xff) != 0; i++) {
ffff800000100b9c:	83 85 4c ff ff ff 01 	addl   $0x1,-0xb4(%rbp)
ffff800000100ba3:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
ffff800000100ba9:	48 63 d0             	movslq %eax,%rdx
ffff800000100bac:	48 8b 85 18 ff ff ff 	mov    -0xe8(%rbp),%rax
ffff800000100bb3:	48 01 d0             	add    %rdx,%rax
ffff800000100bb6:	0f b6 00             	movzbl (%rax),%eax
ffff800000100bb9:	0f be c0             	movsbl %al,%eax
ffff800000100bbc:	25 ff 00 00 00       	and    $0xff,%eax
ffff800000100bc1:	89 85 38 ff ff ff    	mov    %eax,-0xc8(%rbp)
ffff800000100bc7:	83 bd 38 ff ff ff 00 	cmpl   $0x0,-0xc8(%rbp)
ffff800000100bce:	0f 85 2f fd ff ff    	jne    ffff800000100903 <cprintf+0xeb>
ffff800000100bd4:	eb 01                	jmp    ffff800000100bd7 <cprintf+0x3bf>
      break;
ffff800000100bd6:	90                   	nop
    }
  }

  if (locking)
ffff800000100bd7:	83 bd 3c ff ff ff 00 	cmpl   $0x0,-0xc4(%rbp)
ffff800000100bde:	74 16                	je     ffff800000100bf6 <cprintf+0x3de>
    release(&cons.lock);
ffff800000100be0:	48 bf c0 34 11 00 00 	movabs $0xffff8000001134c0,%rdi
ffff800000100be7:	80 ff ff 
ffff800000100bea:	48 b8 b4 7f 10 00 00 	movabs $0xffff800000107fb4,%rax
ffff800000100bf1:	80 ff ff 
ffff800000100bf4:	ff d0                	callq  *%rax
}
ffff800000100bf6:	90                   	nop
ffff800000100bf7:	c9                   	leaveq 
ffff800000100bf8:	c3                   	retq   

ffff800000100bf9 <panic>:

__attribute__((noreturn))
  void
panic(char *s)
{
ffff800000100bf9:	f3 0f 1e fa          	endbr64 
ffff800000100bfd:	55                   	push   %rbp
ffff800000100bfe:	48 89 e5             	mov    %rsp,%rbp
ffff800000100c01:	48 83 ec 70          	sub    $0x70,%rsp
ffff800000100c05:	48 89 7d 98          	mov    %rdi,-0x68(%rbp)
  int i;
  addr_t pcs[10];

  cli();
ffff800000100c09:	48 b8 66 06 10 00 00 	movabs $0xffff800000100666,%rax
ffff800000100c10:	80 ff ff 
ffff800000100c13:	ff d0                	callq  *%rax
  cons.locking = 0;
ffff800000100c15:	48 b8 c0 34 11 00 00 	movabs $0xffff8000001134c0,%rax
ffff800000100c1c:	80 ff ff 
ffff800000100c1f:	c7 40 68 00 00 00 00 	movl   $0x0,0x68(%rax)
  cprintf("cpu%d: panic: ", cpu->id);
ffff800000100c26:	48 c7 c0 f0 ff ff ff 	mov    $0xfffffffffffffff0,%rax
ffff800000100c2d:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffff800000100c31:	0f b6 00             	movzbl (%rax),%eax
ffff800000100c34:	0f b6 c0             	movzbl %al,%eax
ffff800000100c37:	89 c6                	mov    %eax,%esi
ffff800000100c39:	48 bf fd c7 10 00 00 	movabs $0xffff80000010c7fd,%rdi
ffff800000100c40:	80 ff ff 
ffff800000100c43:	b8 00 00 00 00       	mov    $0x0,%eax
ffff800000100c48:	48 ba 18 08 10 00 00 	movabs $0xffff800000100818,%rdx
ffff800000100c4f:	80 ff ff 
ffff800000100c52:	ff d2                	callq  *%rdx
  cprintf(s);
ffff800000100c54:	48 8b 45 98          	mov    -0x68(%rbp),%rax
ffff800000100c58:	48 89 c7             	mov    %rax,%rdi
ffff800000100c5b:	b8 00 00 00 00       	mov    $0x0,%eax
ffff800000100c60:	48 ba 18 08 10 00 00 	movabs $0xffff800000100818,%rdx
ffff800000100c67:	80 ff ff 
ffff800000100c6a:	ff d2                	callq  *%rdx
  cprintf("\n");
ffff800000100c6c:	48 bf 0c c8 10 00 00 	movabs $0xffff80000010c80c,%rdi
ffff800000100c73:	80 ff ff 
ffff800000100c76:	b8 00 00 00 00       	mov    $0x0,%eax
ffff800000100c7b:	48 ba 18 08 10 00 00 	movabs $0xffff800000100818,%rdx
ffff800000100c82:	80 ff ff 
ffff800000100c85:	ff d2                	callq  *%rdx
  getcallerpcs(&s, pcs);
ffff800000100c87:	48 8d 55 a0          	lea    -0x60(%rbp),%rdx
ffff800000100c8b:	48 8d 45 98          	lea    -0x68(%rbp),%rax
ffff800000100c8f:	48 89 d6             	mov    %rdx,%rsi
ffff800000100c92:	48 89 c7             	mov    %rax,%rdi
ffff800000100c95:	48 b8 29 80 10 00 00 	movabs $0xffff800000108029,%rax
ffff800000100c9c:	80 ff ff 
ffff800000100c9f:	ff d0                	callq  *%rax
  for (i=0; i<10; i++)
ffff800000100ca1:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
ffff800000100ca8:	eb 2c                	jmp    ffff800000100cd6 <panic+0xdd>
    cprintf(" %p\n", pcs[i]);
ffff800000100caa:	8b 45 fc             	mov    -0x4(%rbp),%eax
ffff800000100cad:	48 98                	cltq   
ffff800000100caf:	48 8b 44 c5 a0       	mov    -0x60(%rbp,%rax,8),%rax
ffff800000100cb4:	48 89 c6             	mov    %rax,%rsi
ffff800000100cb7:	48 bf 0e c8 10 00 00 	movabs $0xffff80000010c80e,%rdi
ffff800000100cbe:	80 ff ff 
ffff800000100cc1:	b8 00 00 00 00       	mov    $0x0,%eax
ffff800000100cc6:	48 ba 18 08 10 00 00 	movabs $0xffff800000100818,%rdx
ffff800000100ccd:	80 ff ff 
ffff800000100cd0:	ff d2                	callq  *%rdx
  for (i=0; i<10; i++)
ffff800000100cd2:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
ffff800000100cd6:	83 7d fc 09          	cmpl   $0x9,-0x4(%rbp)
ffff800000100cda:	7e ce                	jle    ffff800000100caa <panic+0xb1>
  panicked = 1; // freeze other CPU
ffff800000100cdc:	48 b8 b8 34 11 00 00 	movabs $0xffff8000001134b8,%rax
ffff800000100ce3:	80 ff ff 
ffff800000100ce6:	c7 00 01 00 00 00    	movl   $0x1,(%rax)
  for (;;)
    hlt();
ffff800000100cec:	48 b8 72 06 10 00 00 	movabs $0xffff800000100672,%rax
ffff800000100cf3:	80 ff ff 
ffff800000100cf6:	ff d0                	callq  *%rax
ffff800000100cf8:	eb f2                	jmp    ffff800000100cec <panic+0xf3>

ffff800000100cfa <cgaputc>:
#define CRTPORT 0x3d4
static ushort *crt = (ushort*)P2V(0xb8000);  // CGA memory

  static void
cgaputc(int c)
{
ffff800000100cfa:	f3 0f 1e fa          	endbr64 
ffff800000100cfe:	55                   	push   %rbp
ffff800000100cff:	48 89 e5             	mov    %rsp,%rbp
ffff800000100d02:	48 83 ec 20          	sub    $0x20,%rsp
ffff800000100d06:	89 7d ec             	mov    %edi,-0x14(%rbp)
  int pos;

  // Cursor position: col + 80*row.
  outb(CRTPORT, 14);
ffff800000100d09:	be 0e 00 00 00       	mov    $0xe,%esi
ffff800000100d0e:	bf d4 03 00 00       	mov    $0x3d4,%edi
ffff800000100d13:	48 b8 e6 05 10 00 00 	movabs $0xffff8000001005e6,%rax
ffff800000100d1a:	80 ff ff 
ffff800000100d1d:	ff d0                	callq  *%rax
  pos = inb(CRTPORT+1) << 8;
ffff800000100d1f:	bf d5 03 00 00       	mov    $0x3d5,%edi
ffff800000100d24:	48 b8 c4 05 10 00 00 	movabs $0xffff8000001005c4,%rax
ffff800000100d2b:	80 ff ff 
ffff800000100d2e:	ff d0                	callq  *%rax
ffff800000100d30:	0f b6 c0             	movzbl %al,%eax
ffff800000100d33:	c1 e0 08             	shl    $0x8,%eax
ffff800000100d36:	89 45 fc             	mov    %eax,-0x4(%rbp)
  outb(CRTPORT, 15);
ffff800000100d39:	be 0f 00 00 00       	mov    $0xf,%esi
ffff800000100d3e:	bf d4 03 00 00       	mov    $0x3d4,%edi
ffff800000100d43:	48 b8 e6 05 10 00 00 	movabs $0xffff8000001005e6,%rax
ffff800000100d4a:	80 ff ff 
ffff800000100d4d:	ff d0                	callq  *%rax
  pos |= inb(CRTPORT+1);
ffff800000100d4f:	bf d5 03 00 00       	mov    $0x3d5,%edi
ffff800000100d54:	48 b8 c4 05 10 00 00 	movabs $0xffff8000001005c4,%rax
ffff800000100d5b:	80 ff ff 
ffff800000100d5e:	ff d0                	callq  *%rax
ffff800000100d60:	0f b6 c0             	movzbl %al,%eax
ffff800000100d63:	09 45 fc             	or     %eax,-0x4(%rbp)

  if (c == '\n')
ffff800000100d66:	83 7d ec 0a          	cmpl   $0xa,-0x14(%rbp)
ffff800000100d6a:	75 37                	jne    ffff800000100da3 <cgaputc+0xa9>
    pos += 80 - pos%80;
ffff800000100d6c:	8b 4d fc             	mov    -0x4(%rbp),%ecx
ffff800000100d6f:	48 63 c1             	movslq %ecx,%rax
ffff800000100d72:	48 69 c0 67 66 66 66 	imul   $0x66666667,%rax,%rax
ffff800000100d79:	48 c1 e8 20          	shr    $0x20,%rax
ffff800000100d7d:	89 c2                	mov    %eax,%edx
ffff800000100d7f:	c1 fa 05             	sar    $0x5,%edx
ffff800000100d82:	89 c8                	mov    %ecx,%eax
ffff800000100d84:	c1 f8 1f             	sar    $0x1f,%eax
ffff800000100d87:	29 c2                	sub    %eax,%edx
ffff800000100d89:	89 d0                	mov    %edx,%eax
ffff800000100d8b:	c1 e0 02             	shl    $0x2,%eax
ffff800000100d8e:	01 d0                	add    %edx,%eax
ffff800000100d90:	c1 e0 04             	shl    $0x4,%eax
ffff800000100d93:	29 c1                	sub    %eax,%ecx
ffff800000100d95:	89 ca                	mov    %ecx,%edx
ffff800000100d97:	b8 50 00 00 00       	mov    $0x50,%eax
ffff800000100d9c:	29 d0                	sub    %edx,%eax
ffff800000100d9e:	01 45 fc             	add    %eax,-0x4(%rbp)
ffff800000100da1:	eb 43                	jmp    ffff800000100de6 <cgaputc+0xec>
  else if (c == BACKSPACE) {
ffff800000100da3:	81 7d ec 00 01 00 00 	cmpl   $0x100,-0x14(%rbp)
ffff800000100daa:	75 0c                	jne    ffff800000100db8 <cgaputc+0xbe>
    if (pos > 0) --pos;
ffff800000100dac:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
ffff800000100db0:	7e 34                	jle    ffff800000100de6 <cgaputc+0xec>
ffff800000100db2:	83 6d fc 01          	subl   $0x1,-0x4(%rbp)
ffff800000100db6:	eb 2e                	jmp    ffff800000100de6 <cgaputc+0xec>
  } else
    crt[pos++] = (c&0xff) | 0x0700;  // black on white
ffff800000100db8:	8b 45 ec             	mov    -0x14(%rbp),%eax
ffff800000100dbb:	0f b6 c0             	movzbl %al,%eax
ffff800000100dbe:	80 cc 07             	or     $0x7,%ah
ffff800000100dc1:	89 c6                	mov    %eax,%esi
ffff800000100dc3:	48 b8 18 d0 10 00 00 	movabs $0xffff80000010d018,%rax
ffff800000100dca:	80 ff ff 
ffff800000100dcd:	48 8b 08             	mov    (%rax),%rcx
ffff800000100dd0:	8b 45 fc             	mov    -0x4(%rbp),%eax
ffff800000100dd3:	8d 50 01             	lea    0x1(%rax),%edx
ffff800000100dd6:	89 55 fc             	mov    %edx,-0x4(%rbp)
ffff800000100dd9:	48 98                	cltq   
ffff800000100ddb:	48 01 c0             	add    %rax,%rax
ffff800000100dde:	48 01 c8             	add    %rcx,%rax
ffff800000100de1:	89 f2                	mov    %esi,%edx
ffff800000100de3:	66 89 10             	mov    %dx,(%rax)

  if ((pos/80) >= 24){  // Scroll up.
ffff800000100de6:	81 7d fc 7f 07 00 00 	cmpl   $0x77f,-0x4(%rbp)
ffff800000100ded:	7e 76                	jle    ffff800000100e65 <cgaputc+0x16b>
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
ffff800000100def:	48 b8 18 d0 10 00 00 	movabs $0xffff80000010d018,%rax
ffff800000100df6:	80 ff ff 
ffff800000100df9:	48 8b 00             	mov    (%rax),%rax
ffff800000100dfc:	48 8d 88 a0 00 00 00 	lea    0xa0(%rax),%rcx
ffff800000100e03:	48 b8 18 d0 10 00 00 	movabs $0xffff80000010d018,%rax
ffff800000100e0a:	80 ff ff 
ffff800000100e0d:	48 8b 00             	mov    (%rax),%rax
ffff800000100e10:	ba 60 0e 00 00       	mov    $0xe60,%edx
ffff800000100e15:	48 89 ce             	mov    %rcx,%rsi
ffff800000100e18:	48 89 c7             	mov    %rax,%rdi
ffff800000100e1b:	48 b8 ca 83 10 00 00 	movabs $0xffff8000001083ca,%rax
ffff800000100e22:	80 ff ff 
ffff800000100e25:	ff d0                	callq  *%rax
    pos -= 80;
ffff800000100e27:	83 6d fc 50          	subl   $0x50,-0x4(%rbp)
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
ffff800000100e2b:	b8 80 07 00 00       	mov    $0x780,%eax
ffff800000100e30:	2b 45 fc             	sub    -0x4(%rbp),%eax
ffff800000100e33:	48 98                	cltq   
ffff800000100e35:	8d 14 00             	lea    (%rax,%rax,1),%edx
ffff800000100e38:	48 b8 18 d0 10 00 00 	movabs $0xffff80000010d018,%rax
ffff800000100e3f:	80 ff ff 
ffff800000100e42:	48 8b 00             	mov    (%rax),%rax
ffff800000100e45:	8b 4d fc             	mov    -0x4(%rbp),%ecx
ffff800000100e48:	48 63 c9             	movslq %ecx,%rcx
ffff800000100e4b:	48 01 c9             	add    %rcx,%rcx
ffff800000100e4e:	48 01 c8             	add    %rcx,%rax
ffff800000100e51:	be 00 00 00 00       	mov    $0x0,%esi
ffff800000100e56:	48 89 c7             	mov    %rax,%rdi
ffff800000100e59:	48 b8 bd 82 10 00 00 	movabs $0xffff8000001082bd,%rax
ffff800000100e60:	80 ff ff 
ffff800000100e63:	ff d0                	callq  *%rax
  }

  outb(CRTPORT, 14);
ffff800000100e65:	be 0e 00 00 00       	mov    $0xe,%esi
ffff800000100e6a:	bf d4 03 00 00       	mov    $0x3d4,%edi
ffff800000100e6f:	48 b8 e6 05 10 00 00 	movabs $0xffff8000001005e6,%rax
ffff800000100e76:	80 ff ff 
ffff800000100e79:	ff d0                	callq  *%rax
  outb(CRTPORT+1, pos>>8);
ffff800000100e7b:	8b 45 fc             	mov    -0x4(%rbp),%eax
ffff800000100e7e:	c1 f8 08             	sar    $0x8,%eax
ffff800000100e81:	0f b6 c0             	movzbl %al,%eax
ffff800000100e84:	89 c6                	mov    %eax,%esi
ffff800000100e86:	bf d5 03 00 00       	mov    $0x3d5,%edi
ffff800000100e8b:	48 b8 e6 05 10 00 00 	movabs $0xffff8000001005e6,%rax
ffff800000100e92:	80 ff ff 
ffff800000100e95:	ff d0                	callq  *%rax
  outb(CRTPORT, 15);
ffff800000100e97:	be 0f 00 00 00       	mov    $0xf,%esi
ffff800000100e9c:	bf d4 03 00 00       	mov    $0x3d4,%edi
ffff800000100ea1:	48 b8 e6 05 10 00 00 	movabs $0xffff8000001005e6,%rax
ffff800000100ea8:	80 ff ff 
ffff800000100eab:	ff d0                	callq  *%rax
  outb(CRTPORT+1, pos);
ffff800000100ead:	8b 45 fc             	mov    -0x4(%rbp),%eax
ffff800000100eb0:	0f b6 c0             	movzbl %al,%eax
ffff800000100eb3:	89 c6                	mov    %eax,%esi
ffff800000100eb5:	bf d5 03 00 00       	mov    $0x3d5,%edi
ffff800000100eba:	48 b8 e6 05 10 00 00 	movabs $0xffff8000001005e6,%rax
ffff800000100ec1:	80 ff ff 
ffff800000100ec4:	ff d0                	callq  *%rax
  crt[pos] = ' ' | 0x0700;
ffff800000100ec6:	48 b8 18 d0 10 00 00 	movabs $0xffff80000010d018,%rax
ffff800000100ecd:	80 ff ff 
ffff800000100ed0:	48 8b 00             	mov    (%rax),%rax
ffff800000100ed3:	8b 55 fc             	mov    -0x4(%rbp),%edx
ffff800000100ed6:	48 63 d2             	movslq %edx,%rdx
ffff800000100ed9:	48 01 d2             	add    %rdx,%rdx
ffff800000100edc:	48 01 d0             	add    %rdx,%rax
ffff800000100edf:	66 c7 00 20 07       	movw   $0x720,(%rax)
}
ffff800000100ee4:	90                   	nop
ffff800000100ee5:	c9                   	leaveq 
ffff800000100ee6:	c3                   	retq   

ffff800000100ee7 <consputc>:

  void
consputc(int c)
{
ffff800000100ee7:	f3 0f 1e fa          	endbr64 
ffff800000100eeb:	55                   	push   %rbp
ffff800000100eec:	48 89 e5             	mov    %rsp,%rbp
ffff800000100eef:	48 83 ec 10          	sub    $0x10,%rsp
ffff800000100ef3:	89 7d fc             	mov    %edi,-0x4(%rbp)
  if (panicked) {
ffff800000100ef6:	48 b8 b8 34 11 00 00 	movabs $0xffff8000001134b8,%rax
ffff800000100efd:	80 ff ff 
ffff800000100f00:	8b 00                	mov    (%rax),%eax
ffff800000100f02:	85 c0                	test   %eax,%eax
ffff800000100f04:	74 1a                	je     ffff800000100f20 <consputc+0x39>
    cli();
ffff800000100f06:	48 b8 66 06 10 00 00 	movabs $0xffff800000100666,%rax
ffff800000100f0d:	80 ff ff 
ffff800000100f10:	ff d0                	callq  *%rax
    for(;;)
      hlt();
ffff800000100f12:	48 b8 72 06 10 00 00 	movabs $0xffff800000100672,%rax
ffff800000100f19:	80 ff ff 
ffff800000100f1c:	ff d0                	callq  *%rax
ffff800000100f1e:	eb f2                	jmp    ffff800000100f12 <consputc+0x2b>
  }

  if (c == BACKSPACE) {
ffff800000100f20:	81 7d fc 00 01 00 00 	cmpl   $0x100,-0x4(%rbp)
ffff800000100f27:	75 35                	jne    ffff800000100f5e <consputc+0x77>
    uartputc('\b'); uartputc(' '); uartputc('\b');
ffff800000100f29:	bf 08 00 00 00       	mov    $0x8,%edi
ffff800000100f2e:	48 b8 94 a7 10 00 00 	movabs $0xffff80000010a794,%rax
ffff800000100f35:	80 ff ff 
ffff800000100f38:	ff d0                	callq  *%rax
ffff800000100f3a:	bf 20 00 00 00       	mov    $0x20,%edi
ffff800000100f3f:	48 b8 94 a7 10 00 00 	movabs $0xffff80000010a794,%rax
ffff800000100f46:	80 ff ff 
ffff800000100f49:	ff d0                	callq  *%rax
ffff800000100f4b:	bf 08 00 00 00       	mov    $0x8,%edi
ffff800000100f50:	48 b8 94 a7 10 00 00 	movabs $0xffff80000010a794,%rax
ffff800000100f57:	80 ff ff 
ffff800000100f5a:	ff d0                	callq  *%rax
ffff800000100f5c:	eb 11                	jmp    ffff800000100f6f <consputc+0x88>
  } else
    uartputc(c);
ffff800000100f5e:	8b 45 fc             	mov    -0x4(%rbp),%eax
ffff800000100f61:	89 c7                	mov    %eax,%edi
ffff800000100f63:	48 b8 94 a7 10 00 00 	movabs $0xffff80000010a794,%rax
ffff800000100f6a:	80 ff ff 
ffff800000100f6d:	ff d0                	callq  *%rax
  cgaputc(c);
ffff800000100f6f:	8b 45 fc             	mov    -0x4(%rbp),%eax
ffff800000100f72:	89 c7                	mov    %eax,%edi
ffff800000100f74:	48 b8 fa 0c 10 00 00 	movabs $0xffff800000100cfa,%rax
ffff800000100f7b:	80 ff ff 
ffff800000100f7e:	ff d0                	callq  *%rax
}
ffff800000100f80:	90                   	nop
ffff800000100f81:	c9                   	leaveq 
ffff800000100f82:	c3                   	retq   

ffff800000100f83 <consoleintr>:

#define C(x)  ((x)-'@')  // Control-x

  void
consoleintr(int (*getc)(void))
{
ffff800000100f83:	f3 0f 1e fa          	endbr64 
ffff800000100f87:	55                   	push   %rbp
ffff800000100f88:	48 89 e5             	mov    %rsp,%rbp
ffff800000100f8b:	48 83 ec 20          	sub    $0x20,%rsp
ffff800000100f8f:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  int c;

  acquire(&input.lock);
ffff800000100f93:	48 bf c0 33 11 00 00 	movabs $0xffff8000001133c0,%rdi
ffff800000100f9a:	80 ff ff 
ffff800000100f9d:	48 b8 17 7f 10 00 00 	movabs $0xffff800000107f17,%rax
ffff800000100fa4:	80 ff ff 
ffff800000100fa7:	ff d0                	callq  *%rax
  while((c = getc()) >= 0){
ffff800000100fa9:	e9 6a 02 00 00       	jmpq   ffff800000101218 <consoleintr+0x295>
    switch(c){
ffff800000100fae:	83 7d fc 7f          	cmpl   $0x7f,-0x4(%rbp)
ffff800000100fb2:	0f 84 fd 00 00 00    	je     ffff8000001010b5 <consoleintr+0x132>
ffff800000100fb8:	83 7d fc 7f          	cmpl   $0x7f,-0x4(%rbp)
ffff800000100fbc:	0f 8f 54 01 00 00    	jg     ffff800000101116 <consoleintr+0x193>
ffff800000100fc2:	83 7d fc 1a          	cmpl   $0x1a,-0x4(%rbp)
ffff800000100fc6:	74 2f                	je     ffff800000100ff7 <consoleintr+0x74>
ffff800000100fc8:	83 7d fc 1a          	cmpl   $0x1a,-0x4(%rbp)
ffff800000100fcc:	0f 8f 44 01 00 00    	jg     ffff800000101116 <consoleintr+0x193>
ffff800000100fd2:	83 7d fc 15          	cmpl   $0x15,-0x4(%rbp)
ffff800000100fd6:	74 7f                	je     ffff800000101057 <consoleintr+0xd4>
ffff800000100fd8:	83 7d fc 15          	cmpl   $0x15,-0x4(%rbp)
ffff800000100fdc:	0f 8f 34 01 00 00    	jg     ffff800000101116 <consoleintr+0x193>
ffff800000100fe2:	83 7d fc 08          	cmpl   $0x8,-0x4(%rbp)
ffff800000100fe6:	0f 84 c9 00 00 00    	je     ffff8000001010b5 <consoleintr+0x132>
ffff800000100fec:	83 7d fc 10          	cmpl   $0x10,-0x4(%rbp)
ffff800000100ff0:	74 20                	je     ffff800000101012 <consoleintr+0x8f>
ffff800000100ff2:	e9 1f 01 00 00       	jmpq   ffff800000101116 <consoleintr+0x193>
    case C('Z'): // reboot
      lidt(0,0);
ffff800000100ff7:	be 00 00 00 00       	mov    $0x0,%esi
ffff800000100ffc:	bf 00 00 00 00       	mov    $0x0,%edi
ffff800000101001:	48 b8 0b 06 10 00 00 	movabs $0xffff80000010060b,%rax
ffff800000101008:	80 ff ff 
ffff80000010100b:	ff d0                	callq  *%rax
      break;
ffff80000010100d:	e9 06 02 00 00       	jmpq   ffff800000101218 <consoleintr+0x295>
    case C('P'):  // Process listing.
      procdump();
ffff800000101012:	48 b8 35 72 10 00 00 	movabs $0xffff800000107235,%rax
ffff800000101019:	80 ff ff 
ffff80000010101c:	ff d0                	callq  *%rax
      break;
ffff80000010101e:	e9 f5 01 00 00       	jmpq   ffff800000101218 <consoleintr+0x295>
    case C('U'):  // Kill line.
      while(input.e != input.w &&
          input.buf[(input.e-1) % INPUT_BUF] != '\n'){
        input.e--;
ffff800000101023:	48 b8 c0 33 11 00 00 	movabs $0xffff8000001133c0,%rax
ffff80000010102a:	80 ff ff 
ffff80000010102d:	8b 80 f0 00 00 00    	mov    0xf0(%rax),%eax
ffff800000101033:	8d 50 ff             	lea    -0x1(%rax),%edx
ffff800000101036:	48 b8 c0 33 11 00 00 	movabs $0xffff8000001133c0,%rax
ffff80000010103d:	80 ff ff 
ffff800000101040:	89 90 f0 00 00 00    	mov    %edx,0xf0(%rax)
        consputc(BACKSPACE);
ffff800000101046:	bf 00 01 00 00       	mov    $0x100,%edi
ffff80000010104b:	48 b8 e7 0e 10 00 00 	movabs $0xffff800000100ee7,%rax
ffff800000101052:	80 ff ff 
ffff800000101055:	ff d0                	callq  *%rax
      while(input.e != input.w &&
ffff800000101057:	48 b8 c0 33 11 00 00 	movabs $0xffff8000001133c0,%rax
ffff80000010105e:	80 ff ff 
ffff800000101061:	8b 90 f0 00 00 00    	mov    0xf0(%rax),%edx
ffff800000101067:	48 b8 c0 33 11 00 00 	movabs $0xffff8000001133c0,%rax
ffff80000010106e:	80 ff ff 
ffff800000101071:	8b 80 ec 00 00 00    	mov    0xec(%rax),%eax
ffff800000101077:	39 c2                	cmp    %eax,%edx
ffff800000101079:	0f 84 99 01 00 00    	je     ffff800000101218 <consoleintr+0x295>
          input.buf[(input.e-1) % INPUT_BUF] != '\n'){
ffff80000010107f:	48 b8 c0 33 11 00 00 	movabs $0xffff8000001133c0,%rax
ffff800000101086:	80 ff ff 
ffff800000101089:	8b 80 f0 00 00 00    	mov    0xf0(%rax),%eax
ffff80000010108f:	83 e8 01             	sub    $0x1,%eax
ffff800000101092:	83 e0 7f             	and    $0x7f,%eax
ffff800000101095:	89 c2                	mov    %eax,%edx
ffff800000101097:	48 b8 c0 33 11 00 00 	movabs $0xffff8000001133c0,%rax
ffff80000010109e:	80 ff ff 
ffff8000001010a1:	89 d2                	mov    %edx,%edx
ffff8000001010a3:	0f b6 44 10 68       	movzbl 0x68(%rax,%rdx,1),%eax
      while(input.e != input.w &&
ffff8000001010a8:	3c 0a                	cmp    $0xa,%al
ffff8000001010aa:	0f 85 73 ff ff ff    	jne    ffff800000101023 <consoleintr+0xa0>
      }
      break;
ffff8000001010b0:	e9 63 01 00 00       	jmpq   ffff800000101218 <consoleintr+0x295>
    case C('H'): case '\x7f':  // Backspace
      if (input.e != input.w) {
ffff8000001010b5:	48 b8 c0 33 11 00 00 	movabs $0xffff8000001133c0,%rax
ffff8000001010bc:	80 ff ff 
ffff8000001010bf:	8b 90 f0 00 00 00    	mov    0xf0(%rax),%edx
ffff8000001010c5:	48 b8 c0 33 11 00 00 	movabs $0xffff8000001133c0,%rax
ffff8000001010cc:	80 ff ff 
ffff8000001010cf:	8b 80 ec 00 00 00    	mov    0xec(%rax),%eax
ffff8000001010d5:	39 c2                	cmp    %eax,%edx
ffff8000001010d7:	0f 84 3b 01 00 00    	je     ffff800000101218 <consoleintr+0x295>
        input.e--;
ffff8000001010dd:	48 b8 c0 33 11 00 00 	movabs $0xffff8000001133c0,%rax
ffff8000001010e4:	80 ff ff 
ffff8000001010e7:	8b 80 f0 00 00 00    	mov    0xf0(%rax),%eax
ffff8000001010ed:	8d 50 ff             	lea    -0x1(%rax),%edx
ffff8000001010f0:	48 b8 c0 33 11 00 00 	movabs $0xffff8000001133c0,%rax
ffff8000001010f7:	80 ff ff 
ffff8000001010fa:	89 90 f0 00 00 00    	mov    %edx,0xf0(%rax)
        consputc(BACKSPACE);
ffff800000101100:	bf 00 01 00 00       	mov    $0x100,%edi
ffff800000101105:	48 b8 e7 0e 10 00 00 	movabs $0xffff800000100ee7,%rax
ffff80000010110c:	80 ff ff 
ffff80000010110f:	ff d0                	callq  *%rax
      }
      break;
ffff800000101111:	e9 02 01 00 00       	jmpq   ffff800000101218 <consoleintr+0x295>
    default:
      if (c != 0 && input.e-input.r < INPUT_BUF) {
ffff800000101116:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
ffff80000010111a:	0f 84 f7 00 00 00    	je     ffff800000101217 <consoleintr+0x294>
ffff800000101120:	48 b8 c0 33 11 00 00 	movabs $0xffff8000001133c0,%rax
ffff800000101127:	80 ff ff 
ffff80000010112a:	8b 90 f0 00 00 00    	mov    0xf0(%rax),%edx
ffff800000101130:	48 b8 c0 33 11 00 00 	movabs $0xffff8000001133c0,%rax
ffff800000101137:	80 ff ff 
ffff80000010113a:	8b 80 e8 00 00 00    	mov    0xe8(%rax),%eax
ffff800000101140:	29 c2                	sub    %eax,%edx
ffff800000101142:	89 d0                	mov    %edx,%eax
ffff800000101144:	83 f8 7f             	cmp    $0x7f,%eax
ffff800000101147:	0f 87 ca 00 00 00    	ja     ffff800000101217 <consoleintr+0x294>
        c = (c == '\r') ? '\n' : c;
ffff80000010114d:	83 7d fc 0d          	cmpl   $0xd,-0x4(%rbp)
ffff800000101151:	74 05                	je     ffff800000101158 <consoleintr+0x1d5>
ffff800000101153:	8b 45 fc             	mov    -0x4(%rbp),%eax
ffff800000101156:	eb 05                	jmp    ffff80000010115d <consoleintr+0x1da>
ffff800000101158:	b8 0a 00 00 00       	mov    $0xa,%eax
ffff80000010115d:	89 45 fc             	mov    %eax,-0x4(%rbp)
        input.buf[input.e++ % INPUT_BUF] = c;
ffff800000101160:	48 b8 c0 33 11 00 00 	movabs $0xffff8000001133c0,%rax
ffff800000101167:	80 ff ff 
ffff80000010116a:	8b 80 f0 00 00 00    	mov    0xf0(%rax),%eax
ffff800000101170:	8d 50 01             	lea    0x1(%rax),%edx
ffff800000101173:	48 b9 c0 33 11 00 00 	movabs $0xffff8000001133c0,%rcx
ffff80000010117a:	80 ff ff 
ffff80000010117d:	89 91 f0 00 00 00    	mov    %edx,0xf0(%rcx)
ffff800000101183:	83 e0 7f             	and    $0x7f,%eax
ffff800000101186:	89 c2                	mov    %eax,%edx
ffff800000101188:	8b 45 fc             	mov    -0x4(%rbp),%eax
ffff80000010118b:	89 c1                	mov    %eax,%ecx
ffff80000010118d:	48 b8 c0 33 11 00 00 	movabs $0xffff8000001133c0,%rax
ffff800000101194:	80 ff ff 
ffff800000101197:	89 d2                	mov    %edx,%edx
ffff800000101199:	88 4c 10 68          	mov    %cl,0x68(%rax,%rdx,1)
        consputc(c);
ffff80000010119d:	8b 45 fc             	mov    -0x4(%rbp),%eax
ffff8000001011a0:	89 c7                	mov    %eax,%edi
ffff8000001011a2:	48 b8 e7 0e 10 00 00 	movabs $0xffff800000100ee7,%rax
ffff8000001011a9:	80 ff ff 
ffff8000001011ac:	ff d0                	callq  *%rax
        if (c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF) {
ffff8000001011ae:	83 7d fc 0a          	cmpl   $0xa,-0x4(%rbp)
ffff8000001011b2:	74 2d                	je     ffff8000001011e1 <consoleintr+0x25e>
ffff8000001011b4:	83 7d fc 04          	cmpl   $0x4,-0x4(%rbp)
ffff8000001011b8:	74 27                	je     ffff8000001011e1 <consoleintr+0x25e>
ffff8000001011ba:	48 b8 c0 33 11 00 00 	movabs $0xffff8000001133c0,%rax
ffff8000001011c1:	80 ff ff 
ffff8000001011c4:	8b 80 f0 00 00 00    	mov    0xf0(%rax),%eax
ffff8000001011ca:	48 ba c0 33 11 00 00 	movabs $0xffff8000001133c0,%rdx
ffff8000001011d1:	80 ff ff 
ffff8000001011d4:	8b 92 e8 00 00 00    	mov    0xe8(%rdx),%edx
ffff8000001011da:	83 ea 80             	sub    $0xffffff80,%edx
ffff8000001011dd:	39 d0                	cmp    %edx,%eax
ffff8000001011df:	75 36                	jne    ffff800000101217 <consoleintr+0x294>
          input.w = input.e;
ffff8000001011e1:	48 b8 c0 33 11 00 00 	movabs $0xffff8000001133c0,%rax
ffff8000001011e8:	80 ff ff 
ffff8000001011eb:	8b 80 f0 00 00 00    	mov    0xf0(%rax),%eax
ffff8000001011f1:	48 ba c0 33 11 00 00 	movabs $0xffff8000001133c0,%rdx
ffff8000001011f8:	80 ff ff 
ffff8000001011fb:	89 82 ec 00 00 00    	mov    %eax,0xec(%rdx)
          wakeup(&input.r);
ffff800000101201:	48 bf a8 34 11 00 00 	movabs $0xffff8000001134a8,%rdi
ffff800000101208:	80 ff ff 
ffff80000010120b:	48 b8 2e 71 10 00 00 	movabs $0xffff80000010712e,%rax
ffff800000101212:	80 ff ff 
ffff800000101215:	ff d0                	callq  *%rax
        }
      }
      break;
ffff800000101217:	90                   	nop
  while((c = getc()) >= 0){
ffff800000101218:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff80000010121c:	ff d0                	callq  *%rax
ffff80000010121e:	89 45 fc             	mov    %eax,-0x4(%rbp)
ffff800000101221:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
ffff800000101225:	0f 89 83 fd ff ff    	jns    ffff800000100fae <consoleintr+0x2b>
    }
  }
  release(&input.lock);
ffff80000010122b:	48 bf c0 33 11 00 00 	movabs $0xffff8000001133c0,%rdi
ffff800000101232:	80 ff ff 
ffff800000101235:	48 b8 b4 7f 10 00 00 	movabs $0xffff800000107fb4,%rax
ffff80000010123c:	80 ff ff 
ffff80000010123f:	ff d0                	callq  *%rax
}
ffff800000101241:	90                   	nop
ffff800000101242:	c9                   	leaveq 
ffff800000101243:	c3                   	retq   

ffff800000101244 <consoleread>:

  int
consoleread(struct inode *ip, uint off, char *dst, int n)
{
ffff800000101244:	f3 0f 1e fa          	endbr64 
ffff800000101248:	55                   	push   %rbp
ffff800000101249:	48 89 e5             	mov    %rsp,%rbp
ffff80000010124c:	48 83 ec 30          	sub    $0x30,%rsp
ffff800000101250:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
ffff800000101254:	89 75 e4             	mov    %esi,-0x1c(%rbp)
ffff800000101257:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
ffff80000010125b:	89 4d e0             	mov    %ecx,-0x20(%rbp)
  uint target;
  int c;

  iunlock(ip);
ffff80000010125e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000101262:	48 89 c7             	mov    %rax,%rdi
ffff800000101265:	48 b8 7d 2a 10 00 00 	movabs $0xffff800000102a7d,%rax
ffff80000010126c:	80 ff ff 
ffff80000010126f:	ff d0                	callq  *%rax
  target = n;
ffff800000101271:	8b 45 e0             	mov    -0x20(%rbp),%eax
ffff800000101274:	89 45 fc             	mov    %eax,-0x4(%rbp)
  acquire(&input.lock);
ffff800000101277:	48 bf c0 33 11 00 00 	movabs $0xffff8000001133c0,%rdi
ffff80000010127e:	80 ff ff 
ffff800000101281:	48 b8 17 7f 10 00 00 	movabs $0xffff800000107f17,%rax
ffff800000101288:	80 ff ff 
ffff80000010128b:	ff d0                	callq  *%rax
  while(n > 0){
ffff80000010128d:	e9 1a 01 00 00       	jmpq   ffff8000001013ac <consoleread+0x168>
    while(input.r == input.w){
      if (proc->killed) {
ffff800000101292:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffff800000101299:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffff80000010129d:	8b 40 40             	mov    0x40(%rax),%eax
ffff8000001012a0:	85 c0                	test   %eax,%eax
ffff8000001012a2:	74 33                	je     ffff8000001012d7 <consoleread+0x93>
        release(&input.lock);
ffff8000001012a4:	48 bf c0 33 11 00 00 	movabs $0xffff8000001133c0,%rdi
ffff8000001012ab:	80 ff ff 
ffff8000001012ae:	48 b8 b4 7f 10 00 00 	movabs $0xffff800000107fb4,%rax
ffff8000001012b5:	80 ff ff 
ffff8000001012b8:	ff d0                	callq  *%rax
        ilock(ip);
ffff8000001012ba:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff8000001012be:	48 89 c7             	mov    %rax,%rdi
ffff8000001012c1:	48 b8 e8 28 10 00 00 	movabs $0xffff8000001028e8,%rax
ffff8000001012c8:	80 ff ff 
ffff8000001012cb:	ff d0                	callq  *%rax
        return -1;
ffff8000001012cd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
ffff8000001012d2:	e9 18 01 00 00       	jmpq   ffff8000001013ef <consoleread+0x1ab>
      }
      sleep(&input.r, &input.lock);
ffff8000001012d7:	48 be c0 33 11 00 00 	movabs $0xffff8000001133c0,%rsi
ffff8000001012de:	80 ff ff 
ffff8000001012e1:	48 bf a8 34 11 00 00 	movabs $0xffff8000001134a8,%rdi
ffff8000001012e8:	80 ff ff 
ffff8000001012eb:	48 b8 bd 6f 10 00 00 	movabs $0xffff800000106fbd,%rax
ffff8000001012f2:	80 ff ff 
ffff8000001012f5:	ff d0                	callq  *%rax
    while(input.r == input.w){
ffff8000001012f7:	48 b8 c0 33 11 00 00 	movabs $0xffff8000001133c0,%rax
ffff8000001012fe:	80 ff ff 
ffff800000101301:	8b 90 e8 00 00 00    	mov    0xe8(%rax),%edx
ffff800000101307:	48 b8 c0 33 11 00 00 	movabs $0xffff8000001133c0,%rax
ffff80000010130e:	80 ff ff 
ffff800000101311:	8b 80 ec 00 00 00    	mov    0xec(%rax),%eax
ffff800000101317:	39 c2                	cmp    %eax,%edx
ffff800000101319:	0f 84 73 ff ff ff    	je     ffff800000101292 <consoleread+0x4e>
    }
    c = input.buf[input.r++ % INPUT_BUF];
ffff80000010131f:	48 b8 c0 33 11 00 00 	movabs $0xffff8000001133c0,%rax
ffff800000101326:	80 ff ff 
ffff800000101329:	8b 80 e8 00 00 00    	mov    0xe8(%rax),%eax
ffff80000010132f:	8d 50 01             	lea    0x1(%rax),%edx
ffff800000101332:	48 b9 c0 33 11 00 00 	movabs $0xffff8000001133c0,%rcx
ffff800000101339:	80 ff ff 
ffff80000010133c:	89 91 e8 00 00 00    	mov    %edx,0xe8(%rcx)
ffff800000101342:	83 e0 7f             	and    $0x7f,%eax
ffff800000101345:	89 c2                	mov    %eax,%edx
ffff800000101347:	48 b8 c0 33 11 00 00 	movabs $0xffff8000001133c0,%rax
ffff80000010134e:	80 ff ff 
ffff800000101351:	89 d2                	mov    %edx,%edx
ffff800000101353:	0f b6 44 10 68       	movzbl 0x68(%rax,%rdx,1),%eax
ffff800000101358:	0f be c0             	movsbl %al,%eax
ffff80000010135b:	89 45 f8             	mov    %eax,-0x8(%rbp)
    if (c == C('D')) {  // EOF
ffff80000010135e:	83 7d f8 04          	cmpl   $0x4,-0x8(%rbp)
ffff800000101362:	75 2d                	jne    ffff800000101391 <consoleread+0x14d>
      if (n < target) {
ffff800000101364:	8b 45 e0             	mov    -0x20(%rbp),%eax
ffff800000101367:	39 45 fc             	cmp    %eax,-0x4(%rbp)
ffff80000010136a:	76 4c                	jbe    ffff8000001013b8 <consoleread+0x174>
        // Save ^D for next time, to make sure
        // caller gets a 0-byte result.
        input.r--;
ffff80000010136c:	48 b8 c0 33 11 00 00 	movabs $0xffff8000001133c0,%rax
ffff800000101373:	80 ff ff 
ffff800000101376:	8b 80 e8 00 00 00    	mov    0xe8(%rax),%eax
ffff80000010137c:	8d 50 ff             	lea    -0x1(%rax),%edx
ffff80000010137f:	48 b8 c0 33 11 00 00 	movabs $0xffff8000001133c0,%rax
ffff800000101386:	80 ff ff 
ffff800000101389:	89 90 e8 00 00 00    	mov    %edx,0xe8(%rax)
      }
      break;
ffff80000010138f:	eb 27                	jmp    ffff8000001013b8 <consoleread+0x174>
    }
    *dst++ = c;
ffff800000101391:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
ffff800000101395:	48 8d 50 01          	lea    0x1(%rax),%rdx
ffff800000101399:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
ffff80000010139d:	8b 55 f8             	mov    -0x8(%rbp),%edx
ffff8000001013a0:	88 10                	mov    %dl,(%rax)
    --n;
ffff8000001013a2:	83 6d e0 01          	subl   $0x1,-0x20(%rbp)
    if (c == '\n')
ffff8000001013a6:	83 7d f8 0a          	cmpl   $0xa,-0x8(%rbp)
ffff8000001013aa:	74 0f                	je     ffff8000001013bb <consoleread+0x177>
  while(n > 0){
ffff8000001013ac:	83 7d e0 00          	cmpl   $0x0,-0x20(%rbp)
ffff8000001013b0:	0f 8f 41 ff ff ff    	jg     ffff8000001012f7 <consoleread+0xb3>
ffff8000001013b6:	eb 04                	jmp    ffff8000001013bc <consoleread+0x178>
      break;
ffff8000001013b8:	90                   	nop
ffff8000001013b9:	eb 01                	jmp    ffff8000001013bc <consoleread+0x178>
      break;
ffff8000001013bb:	90                   	nop
  }
  release(&input.lock);
ffff8000001013bc:	48 bf c0 33 11 00 00 	movabs $0xffff8000001133c0,%rdi
ffff8000001013c3:	80 ff ff 
ffff8000001013c6:	48 b8 b4 7f 10 00 00 	movabs $0xffff800000107fb4,%rax
ffff8000001013cd:	80 ff ff 
ffff8000001013d0:	ff d0                	callq  *%rax
  ilock(ip);
ffff8000001013d2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff8000001013d6:	48 89 c7             	mov    %rax,%rdi
ffff8000001013d9:	48 b8 e8 28 10 00 00 	movabs $0xffff8000001028e8,%rax
ffff8000001013e0:	80 ff ff 
ffff8000001013e3:	ff d0                	callq  *%rax

  return target - n;
ffff8000001013e5:	8b 45 e0             	mov    -0x20(%rbp),%eax
ffff8000001013e8:	8b 55 fc             	mov    -0x4(%rbp),%edx
ffff8000001013eb:	29 c2                	sub    %eax,%edx
ffff8000001013ed:	89 d0                	mov    %edx,%eax
}
ffff8000001013ef:	c9                   	leaveq 
ffff8000001013f0:	c3                   	retq   

ffff8000001013f1 <consolewrite>:

  int
consolewrite(struct inode *ip, uint off, char *buf, int n)
{
ffff8000001013f1:	f3 0f 1e fa          	endbr64 
ffff8000001013f5:	55                   	push   %rbp
ffff8000001013f6:	48 89 e5             	mov    %rsp,%rbp
ffff8000001013f9:	48 83 ec 30          	sub    $0x30,%rsp
ffff8000001013fd:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
ffff800000101401:	89 75 e4             	mov    %esi,-0x1c(%rbp)
ffff800000101404:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
ffff800000101408:	89 4d e0             	mov    %ecx,-0x20(%rbp)
  int i;

  iunlock(ip);
ffff80000010140b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff80000010140f:	48 89 c7             	mov    %rax,%rdi
ffff800000101412:	48 b8 7d 2a 10 00 00 	movabs $0xffff800000102a7d,%rax
ffff800000101419:	80 ff ff 
ffff80000010141c:	ff d0                	callq  *%rax
  acquire(&cons.lock);
ffff80000010141e:	48 bf c0 34 11 00 00 	movabs $0xffff8000001134c0,%rdi
ffff800000101425:	80 ff ff 
ffff800000101428:	48 b8 17 7f 10 00 00 	movabs $0xffff800000107f17,%rax
ffff80000010142f:	80 ff ff 
ffff800000101432:	ff d0                	callq  *%rax
  for(i = 0; i < n; i++)
ffff800000101434:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
ffff80000010143b:	eb 28                	jmp    ffff800000101465 <consolewrite+0x74>
    consputc(buf[i] & 0xff);
ffff80000010143d:	8b 45 fc             	mov    -0x4(%rbp),%eax
ffff800000101440:	48 63 d0             	movslq %eax,%rdx
ffff800000101443:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
ffff800000101447:	48 01 d0             	add    %rdx,%rax
ffff80000010144a:	0f b6 00             	movzbl (%rax),%eax
ffff80000010144d:	0f be c0             	movsbl %al,%eax
ffff800000101450:	0f b6 c0             	movzbl %al,%eax
ffff800000101453:	89 c7                	mov    %eax,%edi
ffff800000101455:	48 b8 e7 0e 10 00 00 	movabs $0xffff800000100ee7,%rax
ffff80000010145c:	80 ff ff 
ffff80000010145f:	ff d0                	callq  *%rax
  for(i = 0; i < n; i++)
ffff800000101461:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
ffff800000101465:	8b 45 fc             	mov    -0x4(%rbp),%eax
ffff800000101468:	3b 45 e0             	cmp    -0x20(%rbp),%eax
ffff80000010146b:	7c d0                	jl     ffff80000010143d <consolewrite+0x4c>
  release(&cons.lock);
ffff80000010146d:	48 bf c0 34 11 00 00 	movabs $0xffff8000001134c0,%rdi
ffff800000101474:	80 ff ff 
ffff800000101477:	48 b8 b4 7f 10 00 00 	movabs $0xffff800000107fb4,%rax
ffff80000010147e:	80 ff ff 
ffff800000101481:	ff d0                	callq  *%rax
  ilock(ip);
ffff800000101483:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000101487:	48 89 c7             	mov    %rax,%rdi
ffff80000010148a:	48 b8 e8 28 10 00 00 	movabs $0xffff8000001028e8,%rax
ffff800000101491:	80 ff ff 
ffff800000101494:	ff d0                	callq  *%rax

  return n;
ffff800000101496:	8b 45 e0             	mov    -0x20(%rbp),%eax
}
ffff800000101499:	c9                   	leaveq 
ffff80000010149a:	c3                   	retq   

ffff80000010149b <consoleinit>:

  void
consoleinit(void)
{
ffff80000010149b:	f3 0f 1e fa          	endbr64 
ffff80000010149f:	55                   	push   %rbp
ffff8000001014a0:	48 89 e5             	mov    %rsp,%rbp
  initlock(&cons.lock, "console");
ffff8000001014a3:	48 be 13 c8 10 00 00 	movabs $0xffff80000010c813,%rsi
ffff8000001014aa:	80 ff ff 
ffff8000001014ad:	48 bf c0 34 11 00 00 	movabs $0xffff8000001134c0,%rdi
ffff8000001014b4:	80 ff ff 
ffff8000001014b7:	48 b8 de 7e 10 00 00 	movabs $0xffff800000107ede,%rax
ffff8000001014be:	80 ff ff 
ffff8000001014c1:	ff d0                	callq  *%rax
  initlock(&input.lock, "input");
ffff8000001014c3:	48 be 1b c8 10 00 00 	movabs $0xffff80000010c81b,%rsi
ffff8000001014ca:	80 ff ff 
ffff8000001014cd:	48 bf c0 33 11 00 00 	movabs $0xffff8000001133c0,%rdi
ffff8000001014d4:	80 ff ff 
ffff8000001014d7:	48 b8 de 7e 10 00 00 	movabs $0xffff800000107ede,%rax
ffff8000001014de:	80 ff ff 
ffff8000001014e1:	ff d0                	callq  *%rax

  devsw[CONSOLE].write = consolewrite;
ffff8000001014e3:	48 b8 40 35 11 00 00 	movabs $0xffff800000113540,%rax
ffff8000001014ea:	80 ff ff 
ffff8000001014ed:	48 ba f1 13 10 00 00 	movabs $0xffff8000001013f1,%rdx
ffff8000001014f4:	80 ff ff 
ffff8000001014f7:	48 89 50 18          	mov    %rdx,0x18(%rax)
  devsw[CONSOLE].read = consoleread;
ffff8000001014fb:	48 b8 40 35 11 00 00 	movabs $0xffff800000113540,%rax
ffff800000101502:	80 ff ff 
ffff800000101505:	48 b9 44 12 10 00 00 	movabs $0xffff800000101244,%rcx
ffff80000010150c:	80 ff ff 
ffff80000010150f:	48 89 48 10          	mov    %rcx,0x10(%rax)
  cons.locking = 1;
ffff800000101513:	48 b8 c0 34 11 00 00 	movabs $0xffff8000001134c0,%rax
ffff80000010151a:	80 ff ff 
ffff80000010151d:	c7 40 68 01 00 00 00 	movl   $0x1,0x68(%rax)

  ioapicenable(IRQ_KBD, 0);
ffff800000101524:	be 00 00 00 00       	mov    $0x0,%esi
ffff800000101529:	bf 01 00 00 00       	mov    $0x1,%edi
ffff80000010152e:	48 b8 e5 3f 10 00 00 	movabs $0xffff800000103fe5,%rax
ffff800000101535:	80 ff ff 
ffff800000101538:	ff d0                	callq  *%rax
}
ffff80000010153a:	90                   	nop
ffff80000010153b:	5d                   	pop    %rbp
ffff80000010153c:	c3                   	retq   

ffff80000010153d <exec>:
#include "x86.h"
#include "elf.h"

int
exec(char *path, char **argv)
{
ffff80000010153d:	f3 0f 1e fa          	endbr64 
ffff800000101541:	55                   	push   %rbp
ffff800000101542:	48 89 e5             	mov    %rsp,%rbp
ffff800000101545:	48 81 ec 00 02 00 00 	sub    $0x200,%rsp
ffff80000010154c:	48 89 bd 08 fe ff ff 	mov    %rdi,-0x1f8(%rbp)
ffff800000101553:	48 89 b5 00 fe ff ff 	mov    %rsi,-0x200(%rbp)
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pde_t *pgdir, *oldpgdir;

  oldpgdir = proc->pgdir;
ffff80000010155a:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffff800000101561:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffff800000101565:	48 8b 40 08          	mov    0x8(%rax),%rax
ffff800000101569:	48 89 45 b8          	mov    %rax,-0x48(%rbp)

  begin_op();
ffff80000010156d:	b8 00 00 00 00       	mov    $0x0,%eax
ffff800000101572:	48 ba 79 4f 10 00 00 	movabs $0xffff800000104f79,%rdx
ffff800000101579:	80 ff ff 
ffff80000010157c:	ff d2                	callq  *%rdx

  if((ip = namei(path)) == 0){
ffff80000010157e:	48 8b 85 08 fe ff ff 	mov    -0x1f8(%rbp),%rax
ffff800000101585:	48 89 c7             	mov    %rax,%rdi
ffff800000101588:	48 b8 ff 37 10 00 00 	movabs $0xffff8000001037ff,%rax
ffff80000010158f:	80 ff ff 
ffff800000101592:	ff d0                	callq  *%rax
ffff800000101594:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
ffff800000101598:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
ffff80000010159d:	75 1b                	jne    ffff8000001015ba <exec+0x7d>
    end_op();
ffff80000010159f:	b8 00 00 00 00       	mov    $0x0,%eax
ffff8000001015a4:	48 ba 53 50 10 00 00 	movabs $0xffff800000105053,%rdx
ffff8000001015ab:	80 ff ff 
ffff8000001015ae:	ff d2                	callq  *%rdx
    return -1;
ffff8000001015b0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
ffff8000001015b5:	e9 9d 05 00 00       	jmpq   ffff800000101b57 <exec+0x61a>
  }
  ilock(ip);
ffff8000001015ba:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
ffff8000001015be:	48 89 c7             	mov    %rax,%rdi
ffff8000001015c1:	48 b8 e8 28 10 00 00 	movabs $0xffff8000001028e8,%rax
ffff8000001015c8:	80 ff ff 
ffff8000001015cb:	ff d0                	callq  *%rax
  pgdir = 0;
ffff8000001015cd:	48 c7 45 c0 00 00 00 	movq   $0x0,-0x40(%rbp)
ffff8000001015d4:	00 

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) != sizeof(elf))
ffff8000001015d5:	48 8d b5 50 fe ff ff 	lea    -0x1b0(%rbp),%rsi
ffff8000001015dc:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
ffff8000001015e0:	b9 40 00 00 00       	mov    $0x40,%ecx
ffff8000001015e5:	ba 00 00 00 00       	mov    $0x0,%edx
ffff8000001015ea:	48 89 c7             	mov    %rax,%rdi
ffff8000001015ed:	48 b8 51 2f 10 00 00 	movabs $0xffff800000102f51,%rax
ffff8000001015f4:	80 ff ff 
ffff8000001015f7:	ff d0                	callq  *%rax
ffff8000001015f9:	83 f8 40             	cmp    $0x40,%eax
ffff8000001015fc:	0f 85 e6 04 00 00    	jne    ffff800000101ae8 <exec+0x5ab>
    goto bad;
  if(elf.magic != ELF_MAGIC)
ffff800000101602:	8b 85 50 fe ff ff    	mov    -0x1b0(%rbp),%eax
ffff800000101608:	3d 7f 45 4c 46       	cmp    $0x464c457f,%eax
ffff80000010160d:	0f 85 d8 04 00 00    	jne    ffff800000101aeb <exec+0x5ae>
    goto bad;

  if((pgdir = setupkvm()) == 0)
ffff800000101613:	48 b8 7c b8 10 00 00 	movabs $0xffff80000010b87c,%rax
ffff80000010161a:	80 ff ff 
ffff80000010161d:	ff d0                	callq  *%rax
ffff80000010161f:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
ffff800000101623:	48 83 7d c0 00       	cmpq   $0x0,-0x40(%rbp)
ffff800000101628:	0f 84 c0 04 00 00    	je     ffff800000101aee <exec+0x5b1>
    goto bad;

  // Load program into memory.
  sz = PGSIZE; // skip the first page
ffff80000010162e:	48 c7 45 d8 00 10 00 	movq   $0x1000,-0x28(%rbp)
ffff800000101635:	00 
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
ffff800000101636:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%rbp)
ffff80000010163d:	48 8b 85 70 fe ff ff 	mov    -0x190(%rbp),%rax
ffff800000101644:	89 45 e8             	mov    %eax,-0x18(%rbp)
ffff800000101647:	e9 0f 01 00 00       	jmpq   ffff80000010175b <exec+0x21e>
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
ffff80000010164c:	8b 55 e8             	mov    -0x18(%rbp),%edx
ffff80000010164f:	48 8d b5 10 fe ff ff 	lea    -0x1f0(%rbp),%rsi
ffff800000101656:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
ffff80000010165a:	b9 38 00 00 00       	mov    $0x38,%ecx
ffff80000010165f:	48 89 c7             	mov    %rax,%rdi
ffff800000101662:	48 b8 51 2f 10 00 00 	movabs $0xffff800000102f51,%rax
ffff800000101669:	80 ff ff 
ffff80000010166c:	ff d0                	callq  *%rax
ffff80000010166e:	83 f8 38             	cmp    $0x38,%eax
ffff800000101671:	0f 85 7a 04 00 00    	jne    ffff800000101af1 <exec+0x5b4>
      goto bad;
    if(ph.type != ELF_PROG_LOAD)
ffff800000101677:	8b 85 10 fe ff ff    	mov    -0x1f0(%rbp),%eax
ffff80000010167d:	83 f8 01             	cmp    $0x1,%eax
ffff800000101680:	0f 85 c7 00 00 00    	jne    ffff80000010174d <exec+0x210>
      continue;
    if(ph.memsz < ph.filesz)
ffff800000101686:	48 8b 95 38 fe ff ff 	mov    -0x1c8(%rbp),%rdx
ffff80000010168d:	48 8b 85 30 fe ff ff 	mov    -0x1d0(%rbp),%rax
ffff800000101694:	48 39 c2             	cmp    %rax,%rdx
ffff800000101697:	0f 82 57 04 00 00    	jb     ffff800000101af4 <exec+0x5b7>
      goto bad;
    if(ph.vaddr + ph.memsz < ph.vaddr)
ffff80000010169d:	48 8b 95 20 fe ff ff 	mov    -0x1e0(%rbp),%rdx
ffff8000001016a4:	48 8b 85 38 fe ff ff 	mov    -0x1c8(%rbp),%rax
ffff8000001016ab:	48 01 c2             	add    %rax,%rdx
ffff8000001016ae:	48 8b 85 20 fe ff ff 	mov    -0x1e0(%rbp),%rax
ffff8000001016b5:	48 39 c2             	cmp    %rax,%rdx
ffff8000001016b8:	0f 82 39 04 00 00    	jb     ffff800000101af7 <exec+0x5ba>
      goto bad;
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
ffff8000001016be:	48 8b 95 20 fe ff ff 	mov    -0x1e0(%rbp),%rdx
ffff8000001016c5:	48 8b 85 38 fe ff ff 	mov    -0x1c8(%rbp),%rax
ffff8000001016cc:	48 01 c2             	add    %rax,%rdx
ffff8000001016cf:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
ffff8000001016d3:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
ffff8000001016d7:	48 89 ce             	mov    %rcx,%rsi
ffff8000001016da:	48 89 c7             	mov    %rax,%rdi
ffff8000001016dd:	48 b8 e4 bf 10 00 00 	movabs $0xffff80000010bfe4,%rax
ffff8000001016e4:	80 ff ff 
ffff8000001016e7:	ff d0                	callq  *%rax
ffff8000001016e9:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
ffff8000001016ed:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
ffff8000001016f2:	0f 84 02 04 00 00    	je     ffff800000101afa <exec+0x5bd>
      goto bad;
    if(ph.vaddr % PGSIZE != 0)
ffff8000001016f8:	48 8b 85 20 fe ff ff 	mov    -0x1e0(%rbp),%rax
ffff8000001016ff:	25 ff 0f 00 00       	and    $0xfff,%eax
ffff800000101704:	48 85 c0             	test   %rax,%rax
ffff800000101707:	0f 85 f0 03 00 00    	jne    ffff800000101afd <exec+0x5c0>
      goto bad;
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
ffff80000010170d:	48 8b 85 30 fe ff ff 	mov    -0x1d0(%rbp),%rax
ffff800000101714:	89 c7                	mov    %eax,%edi
ffff800000101716:	48 8b 85 18 fe ff ff 	mov    -0x1e8(%rbp),%rax
ffff80000010171d:	89 c1                	mov    %eax,%ecx
ffff80000010171f:	48 8b 85 20 fe ff ff 	mov    -0x1e0(%rbp),%rax
ffff800000101726:	48 89 c6             	mov    %rax,%rsi
ffff800000101729:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
ffff80000010172d:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
ffff800000101731:	41 89 f8             	mov    %edi,%r8d
ffff800000101734:	48 89 c7             	mov    %rax,%rdi
ffff800000101737:	48 b8 be be 10 00 00 	movabs $0xffff80000010bebe,%rax
ffff80000010173e:	80 ff ff 
ffff800000101741:	ff d0                	callq  *%rax
ffff800000101743:	85 c0                	test   %eax,%eax
ffff800000101745:	0f 88 b5 03 00 00    	js     ffff800000101b00 <exec+0x5c3>
ffff80000010174b:	eb 01                	jmp    ffff80000010174e <exec+0x211>
      continue;
ffff80000010174d:	90                   	nop
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
ffff80000010174e:	83 45 ec 01          	addl   $0x1,-0x14(%rbp)
ffff800000101752:	8b 45 e8             	mov    -0x18(%rbp),%eax
ffff800000101755:	83 c0 38             	add    $0x38,%eax
ffff800000101758:	89 45 e8             	mov    %eax,-0x18(%rbp)
ffff80000010175b:	0f b7 85 88 fe ff ff 	movzwl -0x178(%rbp),%eax
ffff800000101762:	0f b7 c0             	movzwl %ax,%eax
ffff800000101765:	39 45 ec             	cmp    %eax,-0x14(%rbp)
ffff800000101768:	0f 8c de fe ff ff    	jl     ffff80000010164c <exec+0x10f>
      goto bad;
  }
  iunlockput(ip);
ffff80000010176e:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
ffff800000101772:	48 89 c7             	mov    %rax,%rdi
ffff800000101775:	48 b8 d8 2b 10 00 00 	movabs $0xffff800000102bd8,%rax
ffff80000010177c:	80 ff ff 
ffff80000010177f:	ff d0                	callq  *%rax
  end_op();
ffff800000101781:	b8 00 00 00 00       	mov    $0x0,%eax
ffff800000101786:	48 ba 53 50 10 00 00 	movabs $0xffff800000105053,%rdx
ffff80000010178d:	80 ff ff 
ffff800000101790:	ff d2                	callq  *%rdx
  ip = 0;
ffff800000101792:	48 c7 45 c8 00 00 00 	movq   $0x0,-0x38(%rbp)
ffff800000101799:	00 

  // Allocate two pages at the next page boundary.
  // Make the first inaccessible.  Use the second as the user stack.
  sz = PGROUNDUP(sz);
ffff80000010179a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
ffff80000010179e:	48 05 ff 0f 00 00    	add    $0xfff,%rax
ffff8000001017a4:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
ffff8000001017aa:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
ffff8000001017ae:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
ffff8000001017b2:	48 8d 90 00 20 00 00 	lea    0x2000(%rax),%rdx
ffff8000001017b9:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
ffff8000001017bd:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
ffff8000001017c1:	48 89 ce             	mov    %rcx,%rsi
ffff8000001017c4:	48 89 c7             	mov    %rax,%rdi
ffff8000001017c7:	48 b8 e4 bf 10 00 00 	movabs $0xffff80000010bfe4,%rax
ffff8000001017ce:	80 ff ff 
ffff8000001017d1:	ff d0                	callq  *%rax
ffff8000001017d3:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
ffff8000001017d7:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
ffff8000001017dc:	0f 84 21 03 00 00    	je     ffff800000101b03 <exec+0x5c6>
    goto bad;
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
ffff8000001017e2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
ffff8000001017e6:	48 2d 00 20 00 00    	sub    $0x2000,%rax
ffff8000001017ec:	48 89 c2             	mov    %rax,%rdx
ffff8000001017ef:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
ffff8000001017f3:	48 89 d6             	mov    %rdx,%rsi
ffff8000001017f6:	48 89 c7             	mov    %rax,%rdi
ffff8000001017f9:	48 b8 5e c4 10 00 00 	movabs $0xffff80000010c45e,%rax
ffff800000101800:	80 ff ff 
ffff800000101803:	ff d0                	callq  *%rax
  sp = sz;
ffff800000101805:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
ffff800000101809:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
ffff80000010180d:	48 c7 45 e0 00 00 00 	movq   $0x0,-0x20(%rbp)
ffff800000101814:	00 
ffff800000101815:	e9 c9 00 00 00       	jmpq   ffff8000001018e3 <exec+0x3a6>
    if(argc >= MAXARG)
ffff80000010181a:	48 83 7d e0 1f       	cmpq   $0x1f,-0x20(%rbp)
ffff80000010181f:	0f 87 e1 02 00 00    	ja     ffff800000101b06 <exec+0x5c9>
      goto bad;
    sp = (sp - (strlen(argv[argc]) + 1)) & ~(sizeof(addr_t)-1);
ffff800000101825:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
ffff800000101829:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
ffff800000101830:	00 
ffff800000101831:	48 8b 85 00 fe ff ff 	mov    -0x200(%rbp),%rax
ffff800000101838:	48 01 d0             	add    %rdx,%rax
ffff80000010183b:	48 8b 00             	mov    (%rax),%rax
ffff80000010183e:	48 89 c7             	mov    %rax,%rdi
ffff800000101841:	48 b8 f3 85 10 00 00 	movabs $0xffff8000001085f3,%rax
ffff800000101848:	80 ff ff 
ffff80000010184b:	ff d0                	callq  *%rax
ffff80000010184d:	83 c0 01             	add    $0x1,%eax
ffff800000101850:	48 98                	cltq   
ffff800000101852:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
ffff800000101856:	48 29 c2             	sub    %rax,%rdx
ffff800000101859:	48 89 d0             	mov    %rdx,%rax
ffff80000010185c:	48 83 e0 f8          	and    $0xfffffffffffffff8,%rax
ffff800000101860:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
ffff800000101864:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
ffff800000101868:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
ffff80000010186f:	00 
ffff800000101870:	48 8b 85 00 fe ff ff 	mov    -0x200(%rbp),%rax
ffff800000101877:	48 01 d0             	add    %rdx,%rax
ffff80000010187a:	48 8b 00             	mov    (%rax),%rax
ffff80000010187d:	48 89 c7             	mov    %rax,%rdi
ffff800000101880:	48 b8 f3 85 10 00 00 	movabs $0xffff8000001085f3,%rax
ffff800000101887:	80 ff ff 
ffff80000010188a:	ff d0                	callq  *%rax
ffff80000010188c:	83 c0 01             	add    $0x1,%eax
ffff80000010188f:	48 63 c8             	movslq %eax,%rcx
ffff800000101892:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
ffff800000101896:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
ffff80000010189d:	00 
ffff80000010189e:	48 8b 85 00 fe ff ff 	mov    -0x200(%rbp),%rax
ffff8000001018a5:	48 01 d0             	add    %rdx,%rax
ffff8000001018a8:	48 8b 10             	mov    (%rax),%rdx
ffff8000001018ab:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
ffff8000001018af:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
ffff8000001018b3:	48 89 c7             	mov    %rax,%rdi
ffff8000001018b6:	48 b8 d3 c6 10 00 00 	movabs $0xffff80000010c6d3,%rax
ffff8000001018bd:	80 ff ff 
ffff8000001018c0:	ff d0                	callq  *%rax
ffff8000001018c2:	85 c0                	test   %eax,%eax
ffff8000001018c4:	0f 88 3f 02 00 00    	js     ffff800000101b09 <exec+0x5cc>
      goto bad;
    ustack[3+argc] = sp;
ffff8000001018ca:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
ffff8000001018ce:	48 8d 50 03          	lea    0x3(%rax),%rdx
ffff8000001018d2:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
ffff8000001018d6:	48 89 84 d5 90 fe ff 	mov    %rax,-0x170(%rbp,%rdx,8)
ffff8000001018dd:	ff 
  for(argc = 0; argv[argc]; argc++) {
ffff8000001018de:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
ffff8000001018e3:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
ffff8000001018e7:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
ffff8000001018ee:	00 
ffff8000001018ef:	48 8b 85 00 fe ff ff 	mov    -0x200(%rbp),%rax
ffff8000001018f6:	48 01 d0             	add    %rdx,%rax
ffff8000001018f9:	48 8b 00             	mov    (%rax),%rax
ffff8000001018fc:	48 85 c0             	test   %rax,%rax
ffff8000001018ff:	0f 85 15 ff ff ff    	jne    ffff80000010181a <exec+0x2dd>
  }
  ustack[3+argc] = 0;
ffff800000101905:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
ffff800000101909:	48 83 c0 03          	add    $0x3,%rax
ffff80000010190d:	48 c7 84 c5 90 fe ff 	movq   $0x0,-0x170(%rbp,%rax,8)
ffff800000101914:	ff 00 00 00 00 

  ustack[0] = 0xffffffff;  // fake return PC
ffff800000101919:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
ffff80000010191e:	48 89 85 90 fe ff ff 	mov    %rax,-0x170(%rbp)
  ustack[1] = argc;
ffff800000101925:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
ffff800000101929:	48 89 85 98 fe ff ff 	mov    %rax,-0x168(%rbp)
  ustack[2] = sp - (argc+1)*sizeof(addr_t);  // argv pointer
ffff800000101930:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
ffff800000101934:	48 83 c0 01          	add    $0x1,%rax
ffff800000101938:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
ffff80000010193f:	00 
ffff800000101940:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
ffff800000101944:	48 29 d0             	sub    %rdx,%rax
ffff800000101947:	48 89 85 a0 fe ff ff 	mov    %rax,-0x160(%rbp)

  proc->tf->rdi = argc;
ffff80000010194e:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffff800000101955:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffff800000101959:	48 8b 40 28          	mov    0x28(%rax),%rax
ffff80000010195d:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
ffff800000101961:	48 89 50 30          	mov    %rdx,0x30(%rax)
  proc->tf->rsi = sp - (argc+1)*sizeof(addr_t);
ffff800000101965:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
ffff800000101969:	48 83 c0 01          	add    $0x1,%rax
ffff80000010196d:	48 8d 0c c5 00 00 00 	lea    0x0(,%rax,8),%rcx
ffff800000101974:	00 
ffff800000101975:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffff80000010197c:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffff800000101980:	48 8b 40 28          	mov    0x28(%rax),%rax
ffff800000101984:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
ffff800000101988:	48 29 ca             	sub    %rcx,%rdx
ffff80000010198b:	48 89 50 28          	mov    %rdx,0x28(%rax)


  sp -= (3+argc+1) * sizeof(addr_t);
ffff80000010198f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
ffff800000101993:	48 83 c0 04          	add    $0x4,%rax
ffff800000101997:	48 c1 e0 03          	shl    $0x3,%rax
ffff80000010199b:	48 29 45 d0          	sub    %rax,-0x30(%rbp)
  if(copyout(pgdir, sp, ustack, (3+argc+1)*sizeof(addr_t)) < 0)
ffff80000010199f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
ffff8000001019a3:	48 83 c0 04          	add    $0x4,%rax
ffff8000001019a7:	48 8d 0c c5 00 00 00 	lea    0x0(,%rax,8),%rcx
ffff8000001019ae:	00 
ffff8000001019af:	48 8d 95 90 fe ff ff 	lea    -0x170(%rbp),%rdx
ffff8000001019b6:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
ffff8000001019ba:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
ffff8000001019be:	48 89 c7             	mov    %rax,%rdi
ffff8000001019c1:	48 b8 d3 c6 10 00 00 	movabs $0xffff80000010c6d3,%rax
ffff8000001019c8:	80 ff ff 
ffff8000001019cb:	ff d0                	callq  *%rax
ffff8000001019cd:	85 c0                	test   %eax,%eax
ffff8000001019cf:	0f 88 37 01 00 00    	js     ffff800000101b0c <exec+0x5cf>
    goto bad;

  // Save program name for debugging.
  for(last=s=path; *s; s++)
ffff8000001019d5:	48 8b 85 08 fe ff ff 	mov    -0x1f8(%rbp),%rax
ffff8000001019dc:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
ffff8000001019e0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff8000001019e4:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
ffff8000001019e8:	eb 1c                	jmp    ffff800000101a06 <exec+0x4c9>
    if(*s == '/')
ffff8000001019ea:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff8000001019ee:	0f b6 00             	movzbl (%rax),%eax
ffff8000001019f1:	3c 2f                	cmp    $0x2f,%al
ffff8000001019f3:	75 0c                	jne    ffff800000101a01 <exec+0x4c4>
      last = s+1;
ffff8000001019f5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff8000001019f9:	48 83 c0 01          	add    $0x1,%rax
ffff8000001019fd:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
  for(last=s=path; *s; s++)
ffff800000101a01:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
ffff800000101a06:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000101a0a:	0f b6 00             	movzbl (%rax),%eax
ffff800000101a0d:	84 c0                	test   %al,%al
ffff800000101a0f:	75 d9                	jne    ffff8000001019ea <exec+0x4ad>
  safestrcpy(proc->name, last, sizeof(proc->name));
ffff800000101a11:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffff800000101a18:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffff800000101a1c:	48 8d 88 d4 00 00 00 	lea    0xd4(%rax),%rcx
ffff800000101a23:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff800000101a27:	ba 10 00 00 00       	mov    $0x10,%edx
ffff800000101a2c:	48 89 c6             	mov    %rax,%rsi
ffff800000101a2f:	48 89 cf             	mov    %rcx,%rdi
ffff800000101a32:	48 b8 8d 85 10 00 00 	movabs $0xffff80000010858d,%rax
ffff800000101a39:	80 ff ff 
ffff800000101a3c:	ff d0                	callq  *%rax

  // Commit to the user image.
  proc->pgdir = pgdir;
ffff800000101a3e:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffff800000101a45:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffff800000101a49:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
ffff800000101a4d:	48 89 50 08          	mov    %rdx,0x8(%rax)
  proc->sz = sz;
ffff800000101a51:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffff800000101a58:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffff800000101a5c:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
ffff800000101a60:	48 89 10             	mov    %rdx,(%rax)
  proc->tf->rip = elf.entry;  // main
ffff800000101a63:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffff800000101a6a:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffff800000101a6e:	48 8b 40 28          	mov    0x28(%rax),%rax
ffff800000101a72:	48 8b 95 68 fe ff ff 	mov    -0x198(%rbp),%rdx
ffff800000101a79:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
  proc->tf->rcx = elf.entry;
ffff800000101a80:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffff800000101a87:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffff800000101a8b:	48 8b 40 28          	mov    0x28(%rax),%rax
ffff800000101a8f:	48 8b 95 68 fe ff ff 	mov    -0x198(%rbp),%rdx
ffff800000101a96:	48 89 50 10          	mov    %rdx,0x10(%rax)
  proc->tf->rsp = sp;
ffff800000101a9a:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffff800000101aa1:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffff800000101aa5:	48 8b 40 28          	mov    0x28(%rax),%rax
ffff800000101aa9:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
ffff800000101aad:	48 89 90 a0 00 00 00 	mov    %rdx,0xa0(%rax)
  switchuvm(proc);
ffff800000101ab4:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffff800000101abb:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffff800000101abf:	48 89 c7             	mov    %rax,%rdi
ffff800000101ac2:	48 b8 e2 b9 10 00 00 	movabs $0xffff80000010b9e2,%rax
ffff800000101ac9:	80 ff ff 
ffff800000101acc:	ff d0                	callq  *%rax
  freevm(oldpgdir);
ffff800000101ace:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
ffff800000101ad2:	48 89 c7             	mov    %rax,%rdi
ffff800000101ad5:	48 b8 26 c2 10 00 00 	movabs $0xffff80000010c226,%rax
ffff800000101adc:	80 ff ff 
ffff800000101adf:	ff d0                	callq  *%rax
  return 0;
ffff800000101ae1:	b8 00 00 00 00       	mov    $0x0,%eax
ffff800000101ae6:	eb 6f                	jmp    ffff800000101b57 <exec+0x61a>
    goto bad;
ffff800000101ae8:	90                   	nop
ffff800000101ae9:	eb 22                	jmp    ffff800000101b0d <exec+0x5d0>
    goto bad;
ffff800000101aeb:	90                   	nop
ffff800000101aec:	eb 1f                	jmp    ffff800000101b0d <exec+0x5d0>
    goto bad;
ffff800000101aee:	90                   	nop
ffff800000101aef:	eb 1c                	jmp    ffff800000101b0d <exec+0x5d0>
      goto bad;
ffff800000101af1:	90                   	nop
ffff800000101af2:	eb 19                	jmp    ffff800000101b0d <exec+0x5d0>
      goto bad;
ffff800000101af4:	90                   	nop
ffff800000101af5:	eb 16                	jmp    ffff800000101b0d <exec+0x5d0>
      goto bad;
ffff800000101af7:	90                   	nop
ffff800000101af8:	eb 13                	jmp    ffff800000101b0d <exec+0x5d0>
      goto bad;
ffff800000101afa:	90                   	nop
ffff800000101afb:	eb 10                	jmp    ffff800000101b0d <exec+0x5d0>
      goto bad;
ffff800000101afd:	90                   	nop
ffff800000101afe:	eb 0d                	jmp    ffff800000101b0d <exec+0x5d0>
      goto bad;
ffff800000101b00:	90                   	nop
ffff800000101b01:	eb 0a                	jmp    ffff800000101b0d <exec+0x5d0>
    goto bad;
ffff800000101b03:	90                   	nop
ffff800000101b04:	eb 07                	jmp    ffff800000101b0d <exec+0x5d0>
      goto bad;
ffff800000101b06:	90                   	nop
ffff800000101b07:	eb 04                	jmp    ffff800000101b0d <exec+0x5d0>
      goto bad;
ffff800000101b09:	90                   	nop
ffff800000101b0a:	eb 01                	jmp    ffff800000101b0d <exec+0x5d0>
    goto bad;
ffff800000101b0c:	90                   	nop

 bad:
  if(pgdir)
ffff800000101b0d:	48 83 7d c0 00       	cmpq   $0x0,-0x40(%rbp)
ffff800000101b12:	74 13                	je     ffff800000101b27 <exec+0x5ea>
    freevm(pgdir);
ffff800000101b14:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
ffff800000101b18:	48 89 c7             	mov    %rax,%rdi
ffff800000101b1b:	48 b8 26 c2 10 00 00 	movabs $0xffff80000010c226,%rax
ffff800000101b22:	80 ff ff 
ffff800000101b25:	ff d0                	callq  *%rax
  if(ip){
ffff800000101b27:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
ffff800000101b2c:	74 24                	je     ffff800000101b52 <exec+0x615>
    iunlockput(ip);
ffff800000101b2e:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
ffff800000101b32:	48 89 c7             	mov    %rax,%rdi
ffff800000101b35:	48 b8 d8 2b 10 00 00 	movabs $0xffff800000102bd8,%rax
ffff800000101b3c:	80 ff ff 
ffff800000101b3f:	ff d0                	callq  *%rax
    end_op();
ffff800000101b41:	b8 00 00 00 00       	mov    $0x0,%eax
ffff800000101b46:	48 ba 53 50 10 00 00 	movabs $0xffff800000105053,%rdx
ffff800000101b4d:	80 ff ff 
ffff800000101b50:	ff d2                	callq  *%rdx
  }
  return -1;
ffff800000101b52:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
ffff800000101b57:	c9                   	leaveq 
ffff800000101b58:	c3                   	retq   

ffff800000101b59 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
ffff800000101b59:	f3 0f 1e fa          	endbr64 
ffff800000101b5d:	55                   	push   %rbp
ffff800000101b5e:	48 89 e5             	mov    %rsp,%rbp
  initlock(&ftable.lock, "ftable");
ffff800000101b61:	48 be 21 c8 10 00 00 	movabs $0xffff80000010c821,%rsi
ffff800000101b68:	80 ff ff 
ffff800000101b6b:	48 bf e0 35 11 00 00 	movabs $0xffff8000001135e0,%rdi
ffff800000101b72:	80 ff ff 
ffff800000101b75:	48 b8 de 7e 10 00 00 	movabs $0xffff800000107ede,%rax
ffff800000101b7c:	80 ff ff 
ffff800000101b7f:	ff d0                	callq  *%rax
}
ffff800000101b81:	90                   	nop
ffff800000101b82:	5d                   	pop    %rbp
ffff800000101b83:	c3                   	retq   

ffff800000101b84 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
ffff800000101b84:	f3 0f 1e fa          	endbr64 
ffff800000101b88:	55                   	push   %rbp
ffff800000101b89:	48 89 e5             	mov    %rsp,%rbp
ffff800000101b8c:	48 83 ec 10          	sub    $0x10,%rsp
  struct file *f;

  acquire(&ftable.lock);
ffff800000101b90:	48 bf e0 35 11 00 00 	movabs $0xffff8000001135e0,%rdi
ffff800000101b97:	80 ff ff 
ffff800000101b9a:	48 b8 17 7f 10 00 00 	movabs $0xffff800000107f17,%rax
ffff800000101ba1:	80 ff ff 
ffff800000101ba4:	ff d0                	callq  *%rax
  for(f = ftable.file; f < ftable.file + NFILE; f++){
ffff800000101ba6:	48 b8 48 36 11 00 00 	movabs $0xffff800000113648,%rax
ffff800000101bad:	80 ff ff 
ffff800000101bb0:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
ffff800000101bb4:	eb 37                	jmp    ffff800000101bed <filealloc+0x69>
    if(f->ref == 0){
ffff800000101bb6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000101bba:	8b 40 04             	mov    0x4(%rax),%eax
ffff800000101bbd:	85 c0                	test   %eax,%eax
ffff800000101bbf:	75 27                	jne    ffff800000101be8 <filealloc+0x64>
      f->ref = 1;
ffff800000101bc1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000101bc5:	c7 40 04 01 00 00 00 	movl   $0x1,0x4(%rax)
      release(&ftable.lock);
ffff800000101bcc:	48 bf e0 35 11 00 00 	movabs $0xffff8000001135e0,%rdi
ffff800000101bd3:	80 ff ff 
ffff800000101bd6:	48 b8 b4 7f 10 00 00 	movabs $0xffff800000107fb4,%rax
ffff800000101bdd:	80 ff ff 
ffff800000101be0:	ff d0                	callq  *%rax
      return f;
ffff800000101be2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000101be6:	eb 30                	jmp    ffff800000101c18 <filealloc+0x94>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
ffff800000101be8:	48 83 45 f8 28       	addq   $0x28,-0x8(%rbp)
ffff800000101bed:	48 b8 e8 45 11 00 00 	movabs $0xffff8000001145e8,%rax
ffff800000101bf4:	80 ff ff 
ffff800000101bf7:	48 39 45 f8          	cmp    %rax,-0x8(%rbp)
ffff800000101bfb:	72 b9                	jb     ffff800000101bb6 <filealloc+0x32>
    }
  }
  release(&ftable.lock);
ffff800000101bfd:	48 bf e0 35 11 00 00 	movabs $0xffff8000001135e0,%rdi
ffff800000101c04:	80 ff ff 
ffff800000101c07:	48 b8 b4 7f 10 00 00 	movabs $0xffff800000107fb4,%rax
ffff800000101c0e:	80 ff ff 
ffff800000101c11:	ff d0                	callq  *%rax
  return 0;
ffff800000101c13:	b8 00 00 00 00       	mov    $0x0,%eax
}
ffff800000101c18:	c9                   	leaveq 
ffff800000101c19:	c3                   	retq   

ffff800000101c1a <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
ffff800000101c1a:	f3 0f 1e fa          	endbr64 
ffff800000101c1e:	55                   	push   %rbp
ffff800000101c1f:	48 89 e5             	mov    %rsp,%rbp
ffff800000101c22:	48 83 ec 10          	sub    $0x10,%rsp
ffff800000101c26:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  acquire(&ftable.lock);
ffff800000101c2a:	48 bf e0 35 11 00 00 	movabs $0xffff8000001135e0,%rdi
ffff800000101c31:	80 ff ff 
ffff800000101c34:	48 b8 17 7f 10 00 00 	movabs $0xffff800000107f17,%rax
ffff800000101c3b:	80 ff ff 
ffff800000101c3e:	ff d0                	callq  *%rax
  if(f->ref < 1)
ffff800000101c40:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000101c44:	8b 40 04             	mov    0x4(%rax),%eax
ffff800000101c47:	85 c0                	test   %eax,%eax
ffff800000101c49:	7f 16                	jg     ffff800000101c61 <filedup+0x47>
    panic("filedup");
ffff800000101c4b:	48 bf 28 c8 10 00 00 	movabs $0xffff80000010c828,%rdi
ffff800000101c52:	80 ff ff 
ffff800000101c55:	48 b8 f9 0b 10 00 00 	movabs $0xffff800000100bf9,%rax
ffff800000101c5c:	80 ff ff 
ffff800000101c5f:	ff d0                	callq  *%rax
  f->ref++;
ffff800000101c61:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000101c65:	8b 40 04             	mov    0x4(%rax),%eax
ffff800000101c68:	8d 50 01             	lea    0x1(%rax),%edx
ffff800000101c6b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000101c6f:	89 50 04             	mov    %edx,0x4(%rax)
  release(&ftable.lock);
ffff800000101c72:	48 bf e0 35 11 00 00 	movabs $0xffff8000001135e0,%rdi
ffff800000101c79:	80 ff ff 
ffff800000101c7c:	48 b8 b4 7f 10 00 00 	movabs $0xffff800000107fb4,%rax
ffff800000101c83:	80 ff ff 
ffff800000101c86:	ff d0                	callq  *%rax
  return f;
ffff800000101c88:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
ffff800000101c8c:	c9                   	leaveq 
ffff800000101c8d:	c3                   	retq   

ffff800000101c8e <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
ffff800000101c8e:	f3 0f 1e fa          	endbr64 
ffff800000101c92:	55                   	push   %rbp
ffff800000101c93:	48 89 e5             	mov    %rsp,%rbp
ffff800000101c96:	53                   	push   %rbx
ffff800000101c97:	48 83 ec 48          	sub    $0x48,%rsp
ffff800000101c9b:	48 89 7d b8          	mov    %rdi,-0x48(%rbp)
  struct file ff;

  acquire(&ftable.lock);
ffff800000101c9f:	48 bf e0 35 11 00 00 	movabs $0xffff8000001135e0,%rdi
ffff800000101ca6:	80 ff ff 
ffff800000101ca9:	48 b8 17 7f 10 00 00 	movabs $0xffff800000107f17,%rax
ffff800000101cb0:	80 ff ff 
ffff800000101cb3:	ff d0                	callq  *%rax
  if(f->ref < 1)
ffff800000101cb5:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
ffff800000101cb9:	8b 40 04             	mov    0x4(%rax),%eax
ffff800000101cbc:	85 c0                	test   %eax,%eax
ffff800000101cbe:	7f 16                	jg     ffff800000101cd6 <fileclose+0x48>
    panic("fileclose");
ffff800000101cc0:	48 bf 30 c8 10 00 00 	movabs $0xffff80000010c830,%rdi
ffff800000101cc7:	80 ff ff 
ffff800000101cca:	48 b8 f9 0b 10 00 00 	movabs $0xffff800000100bf9,%rax
ffff800000101cd1:	80 ff ff 
ffff800000101cd4:	ff d0                	callq  *%rax
  if(--f->ref > 0){
ffff800000101cd6:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
ffff800000101cda:	8b 40 04             	mov    0x4(%rax),%eax
ffff800000101cdd:	8d 50 ff             	lea    -0x1(%rax),%edx
ffff800000101ce0:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
ffff800000101ce4:	89 50 04             	mov    %edx,0x4(%rax)
ffff800000101ce7:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
ffff800000101ceb:	8b 40 04             	mov    0x4(%rax),%eax
ffff800000101cee:	85 c0                	test   %eax,%eax
ffff800000101cf0:	7e 1b                	jle    ffff800000101d0d <fileclose+0x7f>
    release(&ftable.lock);
ffff800000101cf2:	48 bf e0 35 11 00 00 	movabs $0xffff8000001135e0,%rdi
ffff800000101cf9:	80 ff ff 
ffff800000101cfc:	48 b8 b4 7f 10 00 00 	movabs $0xffff800000107fb4,%rax
ffff800000101d03:	80 ff ff 
ffff800000101d06:	ff d0                	callq  *%rax
ffff800000101d08:	e9 b9 00 00 00       	jmpq   ffff800000101dc6 <fileclose+0x138>
    return;
  }
  ff = *f;
ffff800000101d0d:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
ffff800000101d11:	48 8b 08             	mov    (%rax),%rcx
ffff800000101d14:	48 8b 58 08          	mov    0x8(%rax),%rbx
ffff800000101d18:	48 89 4d c0          	mov    %rcx,-0x40(%rbp)
ffff800000101d1c:	48 89 5d c8          	mov    %rbx,-0x38(%rbp)
ffff800000101d20:	48 8b 48 10          	mov    0x10(%rax),%rcx
ffff800000101d24:	48 8b 58 18          	mov    0x18(%rax),%rbx
ffff800000101d28:	48 89 4d d0          	mov    %rcx,-0x30(%rbp)
ffff800000101d2c:	48 89 5d d8          	mov    %rbx,-0x28(%rbp)
ffff800000101d30:	48 8b 40 20          	mov    0x20(%rax),%rax
ffff800000101d34:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
  f->ref = 0;
ffff800000101d38:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
ffff800000101d3c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%rax)
  f->type = FD_NONE;
ffff800000101d43:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
ffff800000101d47:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
  release(&ftable.lock);
ffff800000101d4d:	48 bf e0 35 11 00 00 	movabs $0xffff8000001135e0,%rdi
ffff800000101d54:	80 ff ff 
ffff800000101d57:	48 b8 b4 7f 10 00 00 	movabs $0xffff800000107fb4,%rax
ffff800000101d5e:	80 ff ff 
ffff800000101d61:	ff d0                	callq  *%rax

  if(ff.type == FD_PIPE)
ffff800000101d63:	8b 45 c0             	mov    -0x40(%rbp),%eax
ffff800000101d66:	83 f8 01             	cmp    $0x1,%eax
ffff800000101d69:	75 1e                	jne    ffff800000101d89 <fileclose+0xfb>
    pipeclose(ff.pipe, ff.writable);
ffff800000101d6b:	0f b6 45 c9          	movzbl -0x37(%rbp),%eax
ffff800000101d6f:	0f be d0             	movsbl %al,%edx
ffff800000101d72:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
ffff800000101d76:	89 d6                	mov    %edx,%esi
ffff800000101d78:	48 89 c7             	mov    %rax,%rdi
ffff800000101d7b:	48 b8 91 5e 10 00 00 	movabs $0xffff800000105e91,%rax
ffff800000101d82:	80 ff ff 
ffff800000101d85:	ff d0                	callq  *%rax
ffff800000101d87:	eb 3d                	jmp    ffff800000101dc6 <fileclose+0x138>
  else if(ff.type == FD_INODE){
ffff800000101d89:	8b 45 c0             	mov    -0x40(%rbp),%eax
ffff800000101d8c:	83 f8 02             	cmp    $0x2,%eax
ffff800000101d8f:	75 35                	jne    ffff800000101dc6 <fileclose+0x138>
    begin_op();
ffff800000101d91:	b8 00 00 00 00       	mov    $0x0,%eax
ffff800000101d96:	48 ba 79 4f 10 00 00 	movabs $0xffff800000104f79,%rdx
ffff800000101d9d:	80 ff ff 
ffff800000101da0:	ff d2                	callq  *%rdx
    iput(ff.ip);
ffff800000101da2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
ffff800000101da6:	48 89 c7             	mov    %rax,%rdi
ffff800000101da9:	48 b8 ea 2a 10 00 00 	movabs $0xffff800000102aea,%rax
ffff800000101db0:	80 ff ff 
ffff800000101db3:	ff d0                	callq  *%rax
    end_op();
ffff800000101db5:	b8 00 00 00 00       	mov    $0x0,%eax
ffff800000101dba:	48 ba 53 50 10 00 00 	movabs $0xffff800000105053,%rdx
ffff800000101dc1:	80 ff ff 
ffff800000101dc4:	ff d2                	callq  *%rdx
  }
}
ffff800000101dc6:	48 83 c4 48          	add    $0x48,%rsp
ffff800000101dca:	5b                   	pop    %rbx
ffff800000101dcb:	5d                   	pop    %rbp
ffff800000101dcc:	c3                   	retq   

ffff800000101dcd <filestat>:

// Get metadata about file f.
int
filestat(struct file *f, struct stat *st)
{
ffff800000101dcd:	f3 0f 1e fa          	endbr64 
ffff800000101dd1:	55                   	push   %rbp
ffff800000101dd2:	48 89 e5             	mov    %rsp,%rbp
ffff800000101dd5:	48 83 ec 10          	sub    $0x10,%rsp
ffff800000101dd9:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
ffff800000101ddd:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  if(f->type == FD_INODE){
ffff800000101de1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000101de5:	8b 00                	mov    (%rax),%eax
ffff800000101de7:	83 f8 02             	cmp    $0x2,%eax
ffff800000101dea:	75 53                	jne    ffff800000101e3f <filestat+0x72>
    ilock(f->ip);
ffff800000101dec:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000101df0:	48 8b 40 18          	mov    0x18(%rax),%rax
ffff800000101df4:	48 89 c7             	mov    %rax,%rdi
ffff800000101df7:	48 b8 e8 28 10 00 00 	movabs $0xffff8000001028e8,%rax
ffff800000101dfe:	80 ff ff 
ffff800000101e01:	ff d0                	callq  *%rax
    stati(f->ip, st);
ffff800000101e03:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000101e07:	48 8b 40 18          	mov    0x18(%rax),%rax
ffff800000101e0b:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
ffff800000101e0f:	48 89 d6             	mov    %rdx,%rsi
ffff800000101e12:	48 89 c7             	mov    %rax,%rdi
ffff800000101e15:	48 b8 e7 2e 10 00 00 	movabs $0xffff800000102ee7,%rax
ffff800000101e1c:	80 ff ff 
ffff800000101e1f:	ff d0                	callq  *%rax
    iunlock(f->ip);
ffff800000101e21:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000101e25:	48 8b 40 18          	mov    0x18(%rax),%rax
ffff800000101e29:	48 89 c7             	mov    %rax,%rdi
ffff800000101e2c:	48 b8 7d 2a 10 00 00 	movabs $0xffff800000102a7d,%rax
ffff800000101e33:	80 ff ff 
ffff800000101e36:	ff d0                	callq  *%rax
    return 0;
ffff800000101e38:	b8 00 00 00 00       	mov    $0x0,%eax
ffff800000101e3d:	eb 05                	jmp    ffff800000101e44 <filestat+0x77>
  }
  return -1;
ffff800000101e3f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
ffff800000101e44:	c9                   	leaveq 
ffff800000101e45:	c3                   	retq   

ffff800000101e46 <fileread>:

// Read from file f.
int
fileread(struct file *f, char *addr, int n)
{
ffff800000101e46:	f3 0f 1e fa          	endbr64 
ffff800000101e4a:	55                   	push   %rbp
ffff800000101e4b:	48 89 e5             	mov    %rsp,%rbp
ffff800000101e4e:	48 83 ec 30          	sub    $0x30,%rsp
ffff800000101e52:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
ffff800000101e56:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
ffff800000101e5a:	89 55 dc             	mov    %edx,-0x24(%rbp)
  int r;

  if(f->readable == 0)
ffff800000101e5d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000101e61:	0f b6 40 08          	movzbl 0x8(%rax),%eax
ffff800000101e65:	84 c0                	test   %al,%al
ffff800000101e67:	75 0a                	jne    ffff800000101e73 <fileread+0x2d>
    return -1;
ffff800000101e69:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
ffff800000101e6e:	e9 c6 00 00 00       	jmpq   ffff800000101f39 <fileread+0xf3>
  if(f->type == FD_PIPE)
ffff800000101e73:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000101e77:	8b 00                	mov    (%rax),%eax
ffff800000101e79:	83 f8 01             	cmp    $0x1,%eax
ffff800000101e7c:	75 26                	jne    ffff800000101ea4 <fileread+0x5e>
    return piperead(f->pipe, addr, n);
ffff800000101e7e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000101e82:	48 8b 40 10          	mov    0x10(%rax),%rax
ffff800000101e86:	8b 55 dc             	mov    -0x24(%rbp),%edx
ffff800000101e89:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
ffff800000101e8d:	48 89 ce             	mov    %rcx,%rsi
ffff800000101e90:	48 89 c7             	mov    %rax,%rdi
ffff800000101e93:	48 b8 ac 60 10 00 00 	movabs $0xffff8000001060ac,%rax
ffff800000101e9a:	80 ff ff 
ffff800000101e9d:	ff d0                	callq  *%rax
ffff800000101e9f:	e9 95 00 00 00       	jmpq   ffff800000101f39 <fileread+0xf3>
  if(f->type == FD_INODE){
ffff800000101ea4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000101ea8:	8b 00                	mov    (%rax),%eax
ffff800000101eaa:	83 f8 02             	cmp    $0x2,%eax
ffff800000101ead:	75 74                	jne    ffff800000101f23 <fileread+0xdd>
    ilock(f->ip);
ffff800000101eaf:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000101eb3:	48 8b 40 18          	mov    0x18(%rax),%rax
ffff800000101eb7:	48 89 c7             	mov    %rax,%rdi
ffff800000101eba:	48 b8 e8 28 10 00 00 	movabs $0xffff8000001028e8,%rax
ffff800000101ec1:	80 ff ff 
ffff800000101ec4:	ff d0                	callq  *%rax
    if((r = readi(f->ip, addr, f->off, n)) > 0)
ffff800000101ec6:	8b 4d dc             	mov    -0x24(%rbp),%ecx
ffff800000101ec9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000101ecd:	8b 50 20             	mov    0x20(%rax),%edx
ffff800000101ed0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000101ed4:	48 8b 40 18          	mov    0x18(%rax),%rax
ffff800000101ed8:	48 8b 75 e0          	mov    -0x20(%rbp),%rsi
ffff800000101edc:	48 89 c7             	mov    %rax,%rdi
ffff800000101edf:	48 b8 51 2f 10 00 00 	movabs $0xffff800000102f51,%rax
ffff800000101ee6:	80 ff ff 
ffff800000101ee9:	ff d0                	callq  *%rax
ffff800000101eeb:	89 45 fc             	mov    %eax,-0x4(%rbp)
ffff800000101eee:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
ffff800000101ef2:	7e 13                	jle    ffff800000101f07 <fileread+0xc1>
      f->off += r;
ffff800000101ef4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000101ef8:	8b 50 20             	mov    0x20(%rax),%edx
ffff800000101efb:	8b 45 fc             	mov    -0x4(%rbp),%eax
ffff800000101efe:	01 c2                	add    %eax,%edx
ffff800000101f00:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000101f04:	89 50 20             	mov    %edx,0x20(%rax)
    iunlock(f->ip);
ffff800000101f07:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000101f0b:	48 8b 40 18          	mov    0x18(%rax),%rax
ffff800000101f0f:	48 89 c7             	mov    %rax,%rdi
ffff800000101f12:	48 b8 7d 2a 10 00 00 	movabs $0xffff800000102a7d,%rax
ffff800000101f19:	80 ff ff 
ffff800000101f1c:	ff d0                	callq  *%rax
    return r;
ffff800000101f1e:	8b 45 fc             	mov    -0x4(%rbp),%eax
ffff800000101f21:	eb 16                	jmp    ffff800000101f39 <fileread+0xf3>
  }
  panic("fileread");
ffff800000101f23:	48 bf 3a c8 10 00 00 	movabs $0xffff80000010c83a,%rdi
ffff800000101f2a:	80 ff ff 
ffff800000101f2d:	48 b8 f9 0b 10 00 00 	movabs $0xffff800000100bf9,%rax
ffff800000101f34:	80 ff ff 
ffff800000101f37:	ff d0                	callq  *%rax
}
ffff800000101f39:	c9                   	leaveq 
ffff800000101f3a:	c3                   	retq   

ffff800000101f3b <filewrite>:

//PAGEBREAK!
// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
ffff800000101f3b:	f3 0f 1e fa          	endbr64 
ffff800000101f3f:	55                   	push   %rbp
ffff800000101f40:	48 89 e5             	mov    %rsp,%rbp
ffff800000101f43:	48 83 ec 30          	sub    $0x30,%rsp
ffff800000101f47:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
ffff800000101f4b:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
ffff800000101f4f:	89 55 dc             	mov    %edx,-0x24(%rbp)
  int r;

  if(f->writable == 0)
ffff800000101f52:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000101f56:	0f b6 40 09          	movzbl 0x9(%rax),%eax
ffff800000101f5a:	84 c0                	test   %al,%al
ffff800000101f5c:	75 0a                	jne    ffff800000101f68 <filewrite+0x2d>
    return -1;
ffff800000101f5e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
ffff800000101f63:	e9 67 01 00 00       	jmpq   ffff8000001020cf <filewrite+0x194>
  if(f->type == FD_PIPE)
ffff800000101f68:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000101f6c:	8b 00                	mov    (%rax),%eax
ffff800000101f6e:	83 f8 01             	cmp    $0x1,%eax
ffff800000101f71:	75 26                	jne    ffff800000101f99 <filewrite+0x5e>
    return pipewrite(f->pipe, addr, n);
ffff800000101f73:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000101f77:	48 8b 40 10          	mov    0x10(%rax),%rax
ffff800000101f7b:	8b 55 dc             	mov    -0x24(%rbp),%edx
ffff800000101f7e:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
ffff800000101f82:	48 89 ce             	mov    %rcx,%rsi
ffff800000101f85:	48 89 c7             	mov    %rax,%rdi
ffff800000101f88:	48 b8 68 5f 10 00 00 	movabs $0xffff800000105f68,%rax
ffff800000101f8f:	80 ff ff 
ffff800000101f92:	ff d0                	callq  *%rax
ffff800000101f94:	e9 36 01 00 00       	jmpq   ffff8000001020cf <filewrite+0x194>
  if(f->type == FD_INODE){
ffff800000101f99:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000101f9d:	8b 00                	mov    (%rax),%eax
ffff800000101f9f:	83 f8 02             	cmp    $0x2,%eax
ffff800000101fa2:	0f 85 11 01 00 00    	jne    ffff8000001020b9 <filewrite+0x17e>
    // the maximum log transaction size, including
    // i-node, indirect block, allocation blocks,
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((LOGSIZE-1-1-2) / 2) * 512;
ffff800000101fa8:	c7 45 f4 00 1a 00 00 	movl   $0x1a00,-0xc(%rbp)
    int i = 0;
ffff800000101faf:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
    while(i < n){
ffff800000101fb6:	e9 db 00 00 00       	jmpq   ffff800000102096 <filewrite+0x15b>
      int n1 = n - i;
ffff800000101fbb:	8b 45 dc             	mov    -0x24(%rbp),%eax
ffff800000101fbe:	2b 45 fc             	sub    -0x4(%rbp),%eax
ffff800000101fc1:	89 45 f8             	mov    %eax,-0x8(%rbp)
      if(n1 > max)
ffff800000101fc4:	8b 45 f8             	mov    -0x8(%rbp),%eax
ffff800000101fc7:	3b 45 f4             	cmp    -0xc(%rbp),%eax
ffff800000101fca:	7e 06                	jle    ffff800000101fd2 <filewrite+0x97>
        n1 = max;
ffff800000101fcc:	8b 45 f4             	mov    -0xc(%rbp),%eax
ffff800000101fcf:	89 45 f8             	mov    %eax,-0x8(%rbp)

      begin_op();
ffff800000101fd2:	b8 00 00 00 00       	mov    $0x0,%eax
ffff800000101fd7:	48 ba 79 4f 10 00 00 	movabs $0xffff800000104f79,%rdx
ffff800000101fde:	80 ff ff 
ffff800000101fe1:	ff d2                	callq  *%rdx
      ilock(f->ip);
ffff800000101fe3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000101fe7:	48 8b 40 18          	mov    0x18(%rax),%rax
ffff800000101feb:	48 89 c7             	mov    %rax,%rdi
ffff800000101fee:	48 b8 e8 28 10 00 00 	movabs $0xffff8000001028e8,%rax
ffff800000101ff5:	80 ff ff 
ffff800000101ff8:	ff d0                	callq  *%rax
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
ffff800000101ffa:	8b 4d f8             	mov    -0x8(%rbp),%ecx
ffff800000101ffd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000102001:	8b 50 20             	mov    0x20(%rax),%edx
ffff800000102004:	8b 45 fc             	mov    -0x4(%rbp),%eax
ffff800000102007:	48 63 f0             	movslq %eax,%rsi
ffff80000010200a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
ffff80000010200e:	48 01 c6             	add    %rax,%rsi
ffff800000102011:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000102015:	48 8b 40 18          	mov    0x18(%rax),%rax
ffff800000102019:	48 89 c7             	mov    %rax,%rdi
ffff80000010201c:	48 b8 22 31 10 00 00 	movabs $0xffff800000103122,%rax
ffff800000102023:	80 ff ff 
ffff800000102026:	ff d0                	callq  *%rax
ffff800000102028:	89 45 f0             	mov    %eax,-0x10(%rbp)
ffff80000010202b:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
ffff80000010202f:	7e 13                	jle    ffff800000102044 <filewrite+0x109>
        f->off += r;
ffff800000102031:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000102035:	8b 50 20             	mov    0x20(%rax),%edx
ffff800000102038:	8b 45 f0             	mov    -0x10(%rbp),%eax
ffff80000010203b:	01 c2                	add    %eax,%edx
ffff80000010203d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000102041:	89 50 20             	mov    %edx,0x20(%rax)
      iunlock(f->ip);
ffff800000102044:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000102048:	48 8b 40 18          	mov    0x18(%rax),%rax
ffff80000010204c:	48 89 c7             	mov    %rax,%rdi
ffff80000010204f:	48 b8 7d 2a 10 00 00 	movabs $0xffff800000102a7d,%rax
ffff800000102056:	80 ff ff 
ffff800000102059:	ff d0                	callq  *%rax
      end_op();
ffff80000010205b:	b8 00 00 00 00       	mov    $0x0,%eax
ffff800000102060:	48 ba 53 50 10 00 00 	movabs $0xffff800000105053,%rdx
ffff800000102067:	80 ff ff 
ffff80000010206a:	ff d2                	callq  *%rdx

      if(r < 0)
ffff80000010206c:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
ffff800000102070:	78 32                	js     ffff8000001020a4 <filewrite+0x169>
        break;
      if(r != n1)
ffff800000102072:	8b 45 f0             	mov    -0x10(%rbp),%eax
ffff800000102075:	3b 45 f8             	cmp    -0x8(%rbp),%eax
ffff800000102078:	74 16                	je     ffff800000102090 <filewrite+0x155>
        panic("short filewrite");
ffff80000010207a:	48 bf 43 c8 10 00 00 	movabs $0xffff80000010c843,%rdi
ffff800000102081:	80 ff ff 
ffff800000102084:	48 b8 f9 0b 10 00 00 	movabs $0xffff800000100bf9,%rax
ffff80000010208b:	80 ff ff 
ffff80000010208e:	ff d0                	callq  *%rax
      i += r;
ffff800000102090:	8b 45 f0             	mov    -0x10(%rbp),%eax
ffff800000102093:	01 45 fc             	add    %eax,-0x4(%rbp)
    while(i < n){
ffff800000102096:	8b 45 fc             	mov    -0x4(%rbp),%eax
ffff800000102099:	3b 45 dc             	cmp    -0x24(%rbp),%eax
ffff80000010209c:	0f 8c 19 ff ff ff    	jl     ffff800000101fbb <filewrite+0x80>
ffff8000001020a2:	eb 01                	jmp    ffff8000001020a5 <filewrite+0x16a>
        break;
ffff8000001020a4:	90                   	nop
    }
    return i == n ? n : -1;
ffff8000001020a5:	8b 45 fc             	mov    -0x4(%rbp),%eax
ffff8000001020a8:	3b 45 dc             	cmp    -0x24(%rbp),%eax
ffff8000001020ab:	75 05                	jne    ffff8000001020b2 <filewrite+0x177>
ffff8000001020ad:	8b 45 dc             	mov    -0x24(%rbp),%eax
ffff8000001020b0:	eb 1d                	jmp    ffff8000001020cf <filewrite+0x194>
ffff8000001020b2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
ffff8000001020b7:	eb 16                	jmp    ffff8000001020cf <filewrite+0x194>
  }
  panic("filewrite");
ffff8000001020b9:	48 bf 53 c8 10 00 00 	movabs $0xffff80000010c853,%rdi
ffff8000001020c0:	80 ff ff 
ffff8000001020c3:	48 b8 f9 0b 10 00 00 	movabs $0xffff800000100bf9,%rax
ffff8000001020ca:	80 ff ff 
ffff8000001020cd:	ff d0                	callq  *%rax
}
ffff8000001020cf:	c9                   	leaveq 
ffff8000001020d0:	c3                   	retq   

ffff8000001020d1 <readsb>:
struct superblock sb;

// Read the super block.
void
readsb(int dev, struct superblock *sb)
{
ffff8000001020d1:	f3 0f 1e fa          	endbr64 
ffff8000001020d5:	55                   	push   %rbp
ffff8000001020d6:	48 89 e5             	mov    %rsp,%rbp
ffff8000001020d9:	48 83 ec 20          	sub    $0x20,%rsp
ffff8000001020dd:	89 7d ec             	mov    %edi,-0x14(%rbp)
ffff8000001020e0:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  struct buf *bp = bread(dev, 1);
ffff8000001020e4:	8b 45 ec             	mov    -0x14(%rbp),%eax
ffff8000001020e7:	be 01 00 00 00       	mov    $0x1,%esi
ffff8000001020ec:	89 c7                	mov    %eax,%edi
ffff8000001020ee:	48 b8 be 03 10 00 00 	movabs $0xffff8000001003be,%rax
ffff8000001020f5:	80 ff ff 
ffff8000001020f8:	ff d0                	callq  *%rax
ffff8000001020fa:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  memmove(sb, bp->data, sizeof(*sb));
ffff8000001020fe:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000102102:	48 8d 88 b0 00 00 00 	lea    0xb0(%rax),%rcx
ffff800000102109:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
ffff80000010210d:	ba 1c 00 00 00       	mov    $0x1c,%edx
ffff800000102112:	48 89 ce             	mov    %rcx,%rsi
ffff800000102115:	48 89 c7             	mov    %rax,%rdi
ffff800000102118:	48 b8 ca 83 10 00 00 	movabs $0xffff8000001083ca,%rax
ffff80000010211f:	80 ff ff 
ffff800000102122:	ff d0                	callq  *%rax
  brelse(bp);
ffff800000102124:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000102128:	48 89 c7             	mov    %rax,%rdi
ffff80000010212b:	48 b8 78 04 10 00 00 	movabs $0xffff800000100478,%rax
ffff800000102132:	80 ff ff 
ffff800000102135:	ff d0                	callq  *%rax
}
ffff800000102137:	90                   	nop
ffff800000102138:	c9                   	leaveq 
ffff800000102139:	c3                   	retq   

ffff80000010213a <bzero>:

// Zero a block.
static void
bzero(int dev, int bno)
{
ffff80000010213a:	f3 0f 1e fa          	endbr64 
ffff80000010213e:	55                   	push   %rbp
ffff80000010213f:	48 89 e5             	mov    %rsp,%rbp
ffff800000102142:	48 83 ec 20          	sub    $0x20,%rsp
ffff800000102146:	89 7d ec             	mov    %edi,-0x14(%rbp)
ffff800000102149:	89 75 e8             	mov    %esi,-0x18(%rbp)
  struct buf *bp = bread(dev, bno);
ffff80000010214c:	8b 55 e8             	mov    -0x18(%rbp),%edx
ffff80000010214f:	8b 45 ec             	mov    -0x14(%rbp),%eax
ffff800000102152:	89 d6                	mov    %edx,%esi
ffff800000102154:	89 c7                	mov    %eax,%edi
ffff800000102156:	48 b8 be 03 10 00 00 	movabs $0xffff8000001003be,%rax
ffff80000010215d:	80 ff ff 
ffff800000102160:	ff d0                	callq  *%rax
ffff800000102162:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  memset(bp->data, 0, BSIZE);
ffff800000102166:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff80000010216a:	48 05 b0 00 00 00    	add    $0xb0,%rax
ffff800000102170:	ba 00 02 00 00       	mov    $0x200,%edx
ffff800000102175:	be 00 00 00 00       	mov    $0x0,%esi
ffff80000010217a:	48 89 c7             	mov    %rax,%rdi
ffff80000010217d:	48 b8 bd 82 10 00 00 	movabs $0xffff8000001082bd,%rax
ffff800000102184:	80 ff ff 
ffff800000102187:	ff d0                	callq  *%rax
  log_write(bp);
ffff800000102189:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff80000010218d:	48 89 c7             	mov    %rax,%rdi
ffff800000102190:	48 b8 ef 52 10 00 00 	movabs $0xffff8000001052ef,%rax
ffff800000102197:	80 ff ff 
ffff80000010219a:	ff d0                	callq  *%rax
  brelse(bp);
ffff80000010219c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff8000001021a0:	48 89 c7             	mov    %rax,%rdi
ffff8000001021a3:	48 b8 78 04 10 00 00 	movabs $0xffff800000100478,%rax
ffff8000001021aa:	80 ff ff 
ffff8000001021ad:	ff d0                	callq  *%rax
}
ffff8000001021af:	90                   	nop
ffff8000001021b0:	c9                   	leaveq 
ffff8000001021b1:	c3                   	retq   

ffff8000001021b2 <balloc>:
// Blocks.

// Allocate a zeroed disk block.
static uint
balloc(uint dev)
{
ffff8000001021b2:	f3 0f 1e fa          	endbr64 
ffff8000001021b6:	55                   	push   %rbp
ffff8000001021b7:	48 89 e5             	mov    %rsp,%rbp
ffff8000001021ba:	48 83 ec 30          	sub    $0x30,%rsp
ffff8000001021be:	89 7d dc             	mov    %edi,-0x24(%rbp)
  int b, bi, m;
  struct buf *bp;
  for(b = 0; b < sb.size; b += BPB){
ffff8000001021c1:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
ffff8000001021c8:	e9 52 01 00 00       	jmpq   ffff80000010231f <balloc+0x16d>
    bp = bread(dev, BBLOCK(b, sb));
ffff8000001021cd:	8b 45 fc             	mov    -0x4(%rbp),%eax
ffff8000001021d0:	8d 90 ff 0f 00 00    	lea    0xfff(%rax),%edx
ffff8000001021d6:	85 c0                	test   %eax,%eax
ffff8000001021d8:	0f 48 c2             	cmovs  %edx,%eax
ffff8000001021db:	c1 f8 0c             	sar    $0xc,%eax
ffff8000001021de:	89 c2                	mov    %eax,%edx
ffff8000001021e0:	48 b8 00 46 11 00 00 	movabs $0xffff800000114600,%rax
ffff8000001021e7:	80 ff ff 
ffff8000001021ea:	8b 40 18             	mov    0x18(%rax),%eax
ffff8000001021ed:	01 c2                	add    %eax,%edx
ffff8000001021ef:	8b 45 dc             	mov    -0x24(%rbp),%eax
ffff8000001021f2:	89 d6                	mov    %edx,%esi
ffff8000001021f4:	89 c7                	mov    %eax,%edi
ffff8000001021f6:	48 b8 be 03 10 00 00 	movabs $0xffff8000001003be,%rax
ffff8000001021fd:	80 ff ff 
ffff800000102200:	ff d0                	callq  *%rax
ffff800000102202:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
ffff800000102206:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%rbp)
ffff80000010220d:	e9 cc 00 00 00       	jmpq   ffff8000001022de <balloc+0x12c>
      m = 1 << (bi % 8);
ffff800000102212:	8b 45 f8             	mov    -0x8(%rbp),%eax
ffff800000102215:	99                   	cltd   
ffff800000102216:	c1 ea 1d             	shr    $0x1d,%edx
ffff800000102219:	01 d0                	add    %edx,%eax
ffff80000010221b:	83 e0 07             	and    $0x7,%eax
ffff80000010221e:	29 d0                	sub    %edx,%eax
ffff800000102220:	ba 01 00 00 00       	mov    $0x1,%edx
ffff800000102225:	89 c1                	mov    %eax,%ecx
ffff800000102227:	d3 e2                	shl    %cl,%edx
ffff800000102229:	89 d0                	mov    %edx,%eax
ffff80000010222b:	89 45 ec             	mov    %eax,-0x14(%rbp)
      if((bp->data[bi/8] & m) == 0){  // Is block free?
ffff80000010222e:	8b 45 f8             	mov    -0x8(%rbp),%eax
ffff800000102231:	8d 50 07             	lea    0x7(%rax),%edx
ffff800000102234:	85 c0                	test   %eax,%eax
ffff800000102236:	0f 48 c2             	cmovs  %edx,%eax
ffff800000102239:	c1 f8 03             	sar    $0x3,%eax
ffff80000010223c:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
ffff800000102240:	48 98                	cltq   
ffff800000102242:	0f b6 84 02 b0 00 00 	movzbl 0xb0(%rdx,%rax,1),%eax
ffff800000102249:	00 
ffff80000010224a:	0f b6 c0             	movzbl %al,%eax
ffff80000010224d:	23 45 ec             	and    -0x14(%rbp),%eax
ffff800000102250:	85 c0                	test   %eax,%eax
ffff800000102252:	0f 85 82 00 00 00    	jne    ffff8000001022da <balloc+0x128>
        bp->data[bi/8] |= m;  // Mark block in use.
ffff800000102258:	8b 45 f8             	mov    -0x8(%rbp),%eax
ffff80000010225b:	8d 50 07             	lea    0x7(%rax),%edx
ffff80000010225e:	85 c0                	test   %eax,%eax
ffff800000102260:	0f 48 c2             	cmovs  %edx,%eax
ffff800000102263:	c1 f8 03             	sar    $0x3,%eax
ffff800000102266:	89 c1                	mov    %eax,%ecx
ffff800000102268:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
ffff80000010226c:	48 63 c1             	movslq %ecx,%rax
ffff80000010226f:	0f b6 84 02 b0 00 00 	movzbl 0xb0(%rdx,%rax,1),%eax
ffff800000102276:	00 
ffff800000102277:	89 c2                	mov    %eax,%edx
ffff800000102279:	8b 45 ec             	mov    -0x14(%rbp),%eax
ffff80000010227c:	09 d0                	or     %edx,%eax
ffff80000010227e:	89 c6                	mov    %eax,%esi
ffff800000102280:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
ffff800000102284:	48 63 c1             	movslq %ecx,%rax
ffff800000102287:	40 88 b4 02 b0 00 00 	mov    %sil,0xb0(%rdx,%rax,1)
ffff80000010228e:	00 
        log_write(bp);
ffff80000010228f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff800000102293:	48 89 c7             	mov    %rax,%rdi
ffff800000102296:	48 b8 ef 52 10 00 00 	movabs $0xffff8000001052ef,%rax
ffff80000010229d:	80 ff ff 
ffff8000001022a0:	ff d0                	callq  *%rax
        brelse(bp);
ffff8000001022a2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff8000001022a6:	48 89 c7             	mov    %rax,%rdi
ffff8000001022a9:	48 b8 78 04 10 00 00 	movabs $0xffff800000100478,%rax
ffff8000001022b0:	80 ff ff 
ffff8000001022b3:	ff d0                	callq  *%rax
        bzero(dev, b + bi);
ffff8000001022b5:	8b 55 fc             	mov    -0x4(%rbp),%edx
ffff8000001022b8:	8b 45 f8             	mov    -0x8(%rbp),%eax
ffff8000001022bb:	01 c2                	add    %eax,%edx
ffff8000001022bd:	8b 45 dc             	mov    -0x24(%rbp),%eax
ffff8000001022c0:	89 d6                	mov    %edx,%esi
ffff8000001022c2:	89 c7                	mov    %eax,%edi
ffff8000001022c4:	48 b8 3a 21 10 00 00 	movabs $0xffff80000010213a,%rax
ffff8000001022cb:	80 ff ff 
ffff8000001022ce:	ff d0                	callq  *%rax
        return b + bi;
ffff8000001022d0:	8b 55 fc             	mov    -0x4(%rbp),%edx
ffff8000001022d3:	8b 45 f8             	mov    -0x8(%rbp),%eax
ffff8000001022d6:	01 d0                	add    %edx,%eax
ffff8000001022d8:	eb 72                	jmp    ffff80000010234c <balloc+0x19a>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
ffff8000001022da:	83 45 f8 01          	addl   $0x1,-0x8(%rbp)
ffff8000001022de:	81 7d f8 ff 0f 00 00 	cmpl   $0xfff,-0x8(%rbp)
ffff8000001022e5:	7f 1e                	jg     ffff800000102305 <balloc+0x153>
ffff8000001022e7:	8b 55 fc             	mov    -0x4(%rbp),%edx
ffff8000001022ea:	8b 45 f8             	mov    -0x8(%rbp),%eax
ffff8000001022ed:	01 d0                	add    %edx,%eax
ffff8000001022ef:	89 c2                	mov    %eax,%edx
ffff8000001022f1:	48 b8 00 46 11 00 00 	movabs $0xffff800000114600,%rax
ffff8000001022f8:	80 ff ff 
ffff8000001022fb:	8b 00                	mov    (%rax),%eax
ffff8000001022fd:	39 c2                	cmp    %eax,%edx
ffff8000001022ff:	0f 82 0d ff ff ff    	jb     ffff800000102212 <balloc+0x60>
      }
    }
    brelse(bp);
ffff800000102305:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff800000102309:	48 89 c7             	mov    %rax,%rdi
ffff80000010230c:	48 b8 78 04 10 00 00 	movabs $0xffff800000100478,%rax
ffff800000102313:	80 ff ff 
ffff800000102316:	ff d0                	callq  *%rax
  for(b = 0; b < sb.size; b += BPB){
ffff800000102318:	81 45 fc 00 10 00 00 	addl   $0x1000,-0x4(%rbp)
ffff80000010231f:	48 b8 00 46 11 00 00 	movabs $0xffff800000114600,%rax
ffff800000102326:	80 ff ff 
ffff800000102329:	8b 10                	mov    (%rax),%edx
ffff80000010232b:	8b 45 fc             	mov    -0x4(%rbp),%eax
ffff80000010232e:	39 c2                	cmp    %eax,%edx
ffff800000102330:	0f 87 97 fe ff ff    	ja     ffff8000001021cd <balloc+0x1b>
  }
  panic("balloc: out of blocks");
ffff800000102336:	48 bf 5d c8 10 00 00 	movabs $0xffff80000010c85d,%rdi
ffff80000010233d:	80 ff ff 
ffff800000102340:	48 b8 f9 0b 10 00 00 	movabs $0xffff800000100bf9,%rax
ffff800000102347:	80 ff ff 
ffff80000010234a:	ff d0                	callq  *%rax
}
ffff80000010234c:	c9                   	leaveq 
ffff80000010234d:	c3                   	retq   

ffff80000010234e <bfree>:

// Free a disk block.
static void
bfree(int dev, uint b)
{
ffff80000010234e:	f3 0f 1e fa          	endbr64 
ffff800000102352:	55                   	push   %rbp
ffff800000102353:	48 89 e5             	mov    %rsp,%rbp
ffff800000102356:	48 83 ec 20          	sub    $0x20,%rsp
ffff80000010235a:	89 7d ec             	mov    %edi,-0x14(%rbp)
ffff80000010235d:	89 75 e8             	mov    %esi,-0x18(%rbp)
  int bi, m;

  readsb(dev, &sb);
ffff800000102360:	8b 45 ec             	mov    -0x14(%rbp),%eax
ffff800000102363:	48 be 00 46 11 00 00 	movabs $0xffff800000114600,%rsi
ffff80000010236a:	80 ff ff 
ffff80000010236d:	89 c7                	mov    %eax,%edi
ffff80000010236f:	48 b8 d1 20 10 00 00 	movabs $0xffff8000001020d1,%rax
ffff800000102376:	80 ff ff 
ffff800000102379:	ff d0                	callq  *%rax
  struct buf *bp = bread(dev, BBLOCK(b, sb));
ffff80000010237b:	8b 45 e8             	mov    -0x18(%rbp),%eax
ffff80000010237e:	c1 e8 0c             	shr    $0xc,%eax
ffff800000102381:	89 c2                	mov    %eax,%edx
ffff800000102383:	48 b8 00 46 11 00 00 	movabs $0xffff800000114600,%rax
ffff80000010238a:	80 ff ff 
ffff80000010238d:	8b 40 18             	mov    0x18(%rax),%eax
ffff800000102390:	01 c2                	add    %eax,%edx
ffff800000102392:	8b 45 ec             	mov    -0x14(%rbp),%eax
ffff800000102395:	89 d6                	mov    %edx,%esi
ffff800000102397:	89 c7                	mov    %eax,%edi
ffff800000102399:	48 b8 be 03 10 00 00 	movabs $0xffff8000001003be,%rax
ffff8000001023a0:	80 ff ff 
ffff8000001023a3:	ff d0                	callq  *%rax
ffff8000001023a5:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  bi = b % BPB;
ffff8000001023a9:	8b 45 e8             	mov    -0x18(%rbp),%eax
ffff8000001023ac:	25 ff 0f 00 00       	and    $0xfff,%eax
ffff8000001023b1:	89 45 f4             	mov    %eax,-0xc(%rbp)
  m = 1 << (bi % 8);
ffff8000001023b4:	8b 45 f4             	mov    -0xc(%rbp),%eax
ffff8000001023b7:	99                   	cltd   
ffff8000001023b8:	c1 ea 1d             	shr    $0x1d,%edx
ffff8000001023bb:	01 d0                	add    %edx,%eax
ffff8000001023bd:	83 e0 07             	and    $0x7,%eax
ffff8000001023c0:	29 d0                	sub    %edx,%eax
ffff8000001023c2:	ba 01 00 00 00       	mov    $0x1,%edx
ffff8000001023c7:	89 c1                	mov    %eax,%ecx
ffff8000001023c9:	d3 e2                	shl    %cl,%edx
ffff8000001023cb:	89 d0                	mov    %edx,%eax
ffff8000001023cd:	89 45 f0             	mov    %eax,-0x10(%rbp)
  if((bp->data[bi/8] & m) == 0)
ffff8000001023d0:	8b 45 f4             	mov    -0xc(%rbp),%eax
ffff8000001023d3:	8d 50 07             	lea    0x7(%rax),%edx
ffff8000001023d6:	85 c0                	test   %eax,%eax
ffff8000001023d8:	0f 48 c2             	cmovs  %edx,%eax
ffff8000001023db:	c1 f8 03             	sar    $0x3,%eax
ffff8000001023de:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
ffff8000001023e2:	48 98                	cltq   
ffff8000001023e4:	0f b6 84 02 b0 00 00 	movzbl 0xb0(%rdx,%rax,1),%eax
ffff8000001023eb:	00 
ffff8000001023ec:	0f b6 c0             	movzbl %al,%eax
ffff8000001023ef:	23 45 f0             	and    -0x10(%rbp),%eax
ffff8000001023f2:	85 c0                	test   %eax,%eax
ffff8000001023f4:	75 16                	jne    ffff80000010240c <bfree+0xbe>
    panic("freeing free block");
ffff8000001023f6:	48 bf 73 c8 10 00 00 	movabs $0xffff80000010c873,%rdi
ffff8000001023fd:	80 ff ff 
ffff800000102400:	48 b8 f9 0b 10 00 00 	movabs $0xffff800000100bf9,%rax
ffff800000102407:	80 ff ff 
ffff80000010240a:	ff d0                	callq  *%rax
  bp->data[bi/8] &= ~m;
ffff80000010240c:	8b 45 f4             	mov    -0xc(%rbp),%eax
ffff80000010240f:	8d 50 07             	lea    0x7(%rax),%edx
ffff800000102412:	85 c0                	test   %eax,%eax
ffff800000102414:	0f 48 c2             	cmovs  %edx,%eax
ffff800000102417:	c1 f8 03             	sar    $0x3,%eax
ffff80000010241a:	89 c1                	mov    %eax,%ecx
ffff80000010241c:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
ffff800000102420:	48 63 c1             	movslq %ecx,%rax
ffff800000102423:	0f b6 84 02 b0 00 00 	movzbl 0xb0(%rdx,%rax,1),%eax
ffff80000010242a:	00 
ffff80000010242b:	89 c2                	mov    %eax,%edx
ffff80000010242d:	8b 45 f0             	mov    -0x10(%rbp),%eax
ffff800000102430:	f7 d0                	not    %eax
ffff800000102432:	21 d0                	and    %edx,%eax
ffff800000102434:	89 c6                	mov    %eax,%esi
ffff800000102436:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
ffff80000010243a:	48 63 c1             	movslq %ecx,%rax
ffff80000010243d:	40 88 b4 02 b0 00 00 	mov    %sil,0xb0(%rdx,%rax,1)
ffff800000102444:	00 
  log_write(bp);
ffff800000102445:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000102449:	48 89 c7             	mov    %rax,%rdi
ffff80000010244c:	48 b8 ef 52 10 00 00 	movabs $0xffff8000001052ef,%rax
ffff800000102453:	80 ff ff 
ffff800000102456:	ff d0                	callq  *%rax
  brelse(bp);
ffff800000102458:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff80000010245c:	48 89 c7             	mov    %rax,%rdi
ffff80000010245f:	48 b8 78 04 10 00 00 	movabs $0xffff800000100478,%rax
ffff800000102466:	80 ff ff 
ffff800000102469:	ff d0                	callq  *%rax
}
ffff80000010246b:	90                   	nop
ffff80000010246c:	c9                   	leaveq 
ffff80000010246d:	c3                   	retq   

ffff80000010246e <iinit>:
  struct inode inode[NINODE];
} icache;

void
iinit(int dev)
{
ffff80000010246e:	f3 0f 1e fa          	endbr64 
ffff800000102472:	55                   	push   %rbp
ffff800000102473:	48 89 e5             	mov    %rsp,%rbp
ffff800000102476:	48 83 ec 20          	sub    $0x20,%rsp
ffff80000010247a:	89 7d ec             	mov    %edi,-0x14(%rbp)
  int i = 0;
ffff80000010247d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)

  initlock(&icache.lock, "icache");
ffff800000102484:	48 be 86 c8 10 00 00 	movabs $0xffff80000010c886,%rsi
ffff80000010248b:	80 ff ff 
ffff80000010248e:	48 bf 20 46 11 00 00 	movabs $0xffff800000114620,%rdi
ffff800000102495:	80 ff ff 
ffff800000102498:	48 b8 de 7e 10 00 00 	movabs $0xffff800000107ede,%rax
ffff80000010249f:	80 ff ff 
ffff8000001024a2:	ff d0                	callq  *%rax
  for(i = 0; i < NINODE; i++) {
ffff8000001024a4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
ffff8000001024ab:	eb 50                	jmp    ffff8000001024fd <iinit+0x8f>
    initsleeplock(&icache.inode[i].lock, "inode");
ffff8000001024ad:	8b 45 fc             	mov    -0x4(%rbp),%eax
ffff8000001024b0:	48 63 d0             	movslq %eax,%rdx
ffff8000001024b3:	48 89 d0             	mov    %rdx,%rax
ffff8000001024b6:	48 01 c0             	add    %rax,%rax
ffff8000001024b9:	48 01 d0             	add    %rdx,%rax
ffff8000001024bc:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
ffff8000001024c3:	00 
ffff8000001024c4:	48 01 d0             	add    %rdx,%rax
ffff8000001024c7:	48 c1 e0 03          	shl    $0x3,%rax
ffff8000001024cb:	48 8d 50 70          	lea    0x70(%rax),%rdx
ffff8000001024cf:	48 b8 20 46 11 00 00 	movabs $0xffff800000114620,%rax
ffff8000001024d6:	80 ff ff 
ffff8000001024d9:	48 01 d0             	add    %rdx,%rax
ffff8000001024dc:	48 83 c0 08          	add    $0x8,%rax
ffff8000001024e0:	48 be 8d c8 10 00 00 	movabs $0xffff80000010c88d,%rsi
ffff8000001024e7:	80 ff ff 
ffff8000001024ea:	48 89 c7             	mov    %rax,%rdi
ffff8000001024ed:	48 b8 eb 7c 10 00 00 	movabs $0xffff800000107ceb,%rax
ffff8000001024f4:	80 ff ff 
ffff8000001024f7:	ff d0                	callq  *%rax
  for(i = 0; i < NINODE; i++) {
ffff8000001024f9:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
ffff8000001024fd:	83 7d fc 31          	cmpl   $0x31,-0x4(%rbp)
ffff800000102501:	7e aa                	jle    ffff8000001024ad <iinit+0x3f>
  }

  readsb(dev, &sb);
ffff800000102503:	8b 45 ec             	mov    -0x14(%rbp),%eax
ffff800000102506:	48 be 00 46 11 00 00 	movabs $0xffff800000114600,%rsi
ffff80000010250d:	80 ff ff 
ffff800000102510:	89 c7                	mov    %eax,%edi
ffff800000102512:	48 b8 d1 20 10 00 00 	movabs $0xffff8000001020d1,%rax
ffff800000102519:	80 ff ff 
ffff80000010251c:	ff d0                	callq  *%rax
  /*cprintf("sb: size %d nblocks %d ninodes %d nlog %d logstart %d\
 inodestart %d bmap start %d\n", sb.size, sb.nblocks,
          sb.ninodes, sb.nlog, sb.logstart, sb.inodestart,
          sb.bmapstart);*/
}
ffff80000010251e:	90                   	nop
ffff80000010251f:	c9                   	leaveq 
ffff800000102520:	c3                   	retq   

ffff800000102521 <ialloc>:

// Allocate a new inode with the given type on device dev.
// A free inode has a type of zero.
struct inode*
ialloc(uint dev, short type)
{
ffff800000102521:	f3 0f 1e fa          	endbr64 
ffff800000102525:	55                   	push   %rbp
ffff800000102526:	48 89 e5             	mov    %rsp,%rbp
ffff800000102529:	48 83 ec 30          	sub    $0x30,%rsp
ffff80000010252d:	89 7d dc             	mov    %edi,-0x24(%rbp)
ffff800000102530:	89 f0                	mov    %esi,%eax
ffff800000102532:	66 89 45 d8          	mov    %ax,-0x28(%rbp)
  int inum;
  struct buf *bp;
  struct dinode *dip;

  for(inum = 1; inum < sb.ninodes; inum++){
ffff800000102536:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)
ffff80000010253d:	e9 d8 00 00 00       	jmpq   ffff80000010261a <ialloc+0xf9>
    bp = bread(dev, IBLOCK(inum, sb));
ffff800000102542:	8b 45 fc             	mov    -0x4(%rbp),%eax
ffff800000102545:	48 98                	cltq   
ffff800000102547:	48 c1 e8 03          	shr    $0x3,%rax
ffff80000010254b:	89 c2                	mov    %eax,%edx
ffff80000010254d:	48 b8 00 46 11 00 00 	movabs $0xffff800000114600,%rax
ffff800000102554:	80 ff ff 
ffff800000102557:	8b 40 14             	mov    0x14(%rax),%eax
ffff80000010255a:	01 c2                	add    %eax,%edx
ffff80000010255c:	8b 45 dc             	mov    -0x24(%rbp),%eax
ffff80000010255f:	89 d6                	mov    %edx,%esi
ffff800000102561:	89 c7                	mov    %eax,%edi
ffff800000102563:	48 b8 be 03 10 00 00 	movabs $0xffff8000001003be,%rax
ffff80000010256a:	80 ff ff 
ffff80000010256d:	ff d0                	callq  *%rax
ffff80000010256f:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
    dip = (struct dinode*)bp->data + inum%IPB;
ffff800000102573:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff800000102577:	48 8d 90 b0 00 00 00 	lea    0xb0(%rax),%rdx
ffff80000010257e:	8b 45 fc             	mov    -0x4(%rbp),%eax
ffff800000102581:	48 98                	cltq   
ffff800000102583:	83 e0 07             	and    $0x7,%eax
ffff800000102586:	48 c1 e0 06          	shl    $0x6,%rax
ffff80000010258a:	48 01 d0             	add    %rdx,%rax
ffff80000010258d:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
    if(dip->type == 0){  // a free inode
ffff800000102591:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000102595:	0f b7 00             	movzwl (%rax),%eax
ffff800000102598:	66 85 c0             	test   %ax,%ax
ffff80000010259b:	75 66                	jne    ffff800000102603 <ialloc+0xe2>
      memset(dip, 0, sizeof(*dip));
ffff80000010259d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff8000001025a1:	ba 40 00 00 00       	mov    $0x40,%edx
ffff8000001025a6:	be 00 00 00 00       	mov    $0x0,%esi
ffff8000001025ab:	48 89 c7             	mov    %rax,%rdi
ffff8000001025ae:	48 b8 bd 82 10 00 00 	movabs $0xffff8000001082bd,%rax
ffff8000001025b5:	80 ff ff 
ffff8000001025b8:	ff d0                	callq  *%rax
      dip->type = type;
ffff8000001025ba:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff8000001025be:	0f b7 55 d8          	movzwl -0x28(%rbp),%edx
ffff8000001025c2:	66 89 10             	mov    %dx,(%rax)
      log_write(bp);   // mark it allocated on the disk
ffff8000001025c5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff8000001025c9:	48 89 c7             	mov    %rax,%rdi
ffff8000001025cc:	48 b8 ef 52 10 00 00 	movabs $0xffff8000001052ef,%rax
ffff8000001025d3:	80 ff ff 
ffff8000001025d6:	ff d0                	callq  *%rax
      brelse(bp);
ffff8000001025d8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff8000001025dc:	48 89 c7             	mov    %rax,%rdi
ffff8000001025df:	48 b8 78 04 10 00 00 	movabs $0xffff800000100478,%rax
ffff8000001025e6:	80 ff ff 
ffff8000001025e9:	ff d0                	callq  *%rax
      return iget(dev, inum);
ffff8000001025eb:	8b 55 fc             	mov    -0x4(%rbp),%edx
ffff8000001025ee:	8b 45 dc             	mov    -0x24(%rbp),%eax
ffff8000001025f1:	89 d6                	mov    %edx,%esi
ffff8000001025f3:	89 c7                	mov    %eax,%edi
ffff8000001025f5:	48 b8 60 27 10 00 00 	movabs $0xffff800000102760,%rax
ffff8000001025fc:	80 ff ff 
ffff8000001025ff:	ff d0                	callq  *%rax
ffff800000102601:	eb 45                	jmp    ffff800000102648 <ialloc+0x127>
    }
    brelse(bp);
ffff800000102603:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff800000102607:	48 89 c7             	mov    %rax,%rdi
ffff80000010260a:	48 b8 78 04 10 00 00 	movabs $0xffff800000100478,%rax
ffff800000102611:	80 ff ff 
ffff800000102614:	ff d0                	callq  *%rax
  for(inum = 1; inum < sb.ninodes; inum++){
ffff800000102616:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
ffff80000010261a:	48 b8 00 46 11 00 00 	movabs $0xffff800000114600,%rax
ffff800000102621:	80 ff ff 
ffff800000102624:	8b 50 08             	mov    0x8(%rax),%edx
ffff800000102627:	8b 45 fc             	mov    -0x4(%rbp),%eax
ffff80000010262a:	39 c2                	cmp    %eax,%edx
ffff80000010262c:	0f 87 10 ff ff ff    	ja     ffff800000102542 <ialloc+0x21>
  }
  panic("ialloc: no inodes");
ffff800000102632:	48 bf 93 c8 10 00 00 	movabs $0xffff80000010c893,%rdi
ffff800000102639:	80 ff ff 
ffff80000010263c:	48 b8 f9 0b 10 00 00 	movabs $0xffff800000100bf9,%rax
ffff800000102643:	80 ff ff 
ffff800000102646:	ff d0                	callq  *%rax
}
ffff800000102648:	c9                   	leaveq 
ffff800000102649:	c3                   	retq   

ffff80000010264a <iupdate>:

// Copy a modified in-memory inode to disk.
void
iupdate(struct inode *ip)
{
ffff80000010264a:	f3 0f 1e fa          	endbr64 
ffff80000010264e:	55                   	push   %rbp
ffff80000010264f:	48 89 e5             	mov    %rsp,%rbp
ffff800000102652:	48 83 ec 20          	sub    $0x20,%rsp
ffff800000102656:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  struct buf *bp;
  struct dinode *dip;

  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
ffff80000010265a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff80000010265e:	8b 40 04             	mov    0x4(%rax),%eax
ffff800000102661:	c1 e8 03             	shr    $0x3,%eax
ffff800000102664:	89 c2                	mov    %eax,%edx
ffff800000102666:	48 b8 00 46 11 00 00 	movabs $0xffff800000114600,%rax
ffff80000010266d:	80 ff ff 
ffff800000102670:	8b 40 14             	mov    0x14(%rax),%eax
ffff800000102673:	01 c2                	add    %eax,%edx
ffff800000102675:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000102679:	8b 00                	mov    (%rax),%eax
ffff80000010267b:	89 d6                	mov    %edx,%esi
ffff80000010267d:	89 c7                	mov    %eax,%edi
ffff80000010267f:	48 b8 be 03 10 00 00 	movabs $0xffff8000001003be,%rax
ffff800000102686:	80 ff ff 
ffff800000102689:	ff d0                	callq  *%rax
ffff80000010268b:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  dip = (struct dinode*)bp->data + ip->inum%IPB;
ffff80000010268f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000102693:	48 8d 90 b0 00 00 00 	lea    0xb0(%rax),%rdx
ffff80000010269a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff80000010269e:	8b 40 04             	mov    0x4(%rax),%eax
ffff8000001026a1:	89 c0                	mov    %eax,%eax
ffff8000001026a3:	83 e0 07             	and    $0x7,%eax
ffff8000001026a6:	48 c1 e0 06          	shl    $0x6,%rax
ffff8000001026aa:	48 01 d0             	add    %rdx,%rax
ffff8000001026ad:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
  dip->type = ip->type;
ffff8000001026b1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff8000001026b5:	0f b7 90 94 00 00 00 	movzwl 0x94(%rax),%edx
ffff8000001026bc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff8000001026c0:	66 89 10             	mov    %dx,(%rax)
  dip->major = ip->major;
ffff8000001026c3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff8000001026c7:	0f b7 90 96 00 00 00 	movzwl 0x96(%rax),%edx
ffff8000001026ce:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff8000001026d2:	66 89 50 02          	mov    %dx,0x2(%rax)
  dip->minor = ip->minor;
ffff8000001026d6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff8000001026da:	0f b7 90 98 00 00 00 	movzwl 0x98(%rax),%edx
ffff8000001026e1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff8000001026e5:	66 89 50 04          	mov    %dx,0x4(%rax)
  dip->nlink = ip->nlink;
ffff8000001026e9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff8000001026ed:	0f b7 90 9a 00 00 00 	movzwl 0x9a(%rax),%edx
ffff8000001026f4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff8000001026f8:	66 89 50 06          	mov    %dx,0x6(%rax)
  dip->size = ip->size;
ffff8000001026fc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000102700:	8b 90 9c 00 00 00    	mov    0x9c(%rax),%edx
ffff800000102706:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff80000010270a:	89 50 08             	mov    %edx,0x8(%rax)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
ffff80000010270d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000102711:	48 8d 88 a0 00 00 00 	lea    0xa0(%rax),%rcx
ffff800000102718:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff80000010271c:	48 83 c0 0c          	add    $0xc,%rax
ffff800000102720:	ba 34 00 00 00       	mov    $0x34,%edx
ffff800000102725:	48 89 ce             	mov    %rcx,%rsi
ffff800000102728:	48 89 c7             	mov    %rax,%rdi
ffff80000010272b:	48 b8 ca 83 10 00 00 	movabs $0xffff8000001083ca,%rax
ffff800000102732:	80 ff ff 
ffff800000102735:	ff d0                	callq  *%rax
  log_write(bp);
ffff800000102737:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff80000010273b:	48 89 c7             	mov    %rax,%rdi
ffff80000010273e:	48 b8 ef 52 10 00 00 	movabs $0xffff8000001052ef,%rax
ffff800000102745:	80 ff ff 
ffff800000102748:	ff d0                	callq  *%rax
  brelse(bp);
ffff80000010274a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff80000010274e:	48 89 c7             	mov    %rax,%rdi
ffff800000102751:	48 b8 78 04 10 00 00 	movabs $0xffff800000100478,%rax
ffff800000102758:	80 ff ff 
ffff80000010275b:	ff d0                	callq  *%rax
}
ffff80000010275d:	90                   	nop
ffff80000010275e:	c9                   	leaveq 
ffff80000010275f:	c3                   	retq   

ffff800000102760 <iget>:
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
ffff800000102760:	f3 0f 1e fa          	endbr64 
ffff800000102764:	55                   	push   %rbp
ffff800000102765:	48 89 e5             	mov    %rsp,%rbp
ffff800000102768:	48 83 ec 20          	sub    $0x20,%rsp
ffff80000010276c:	89 7d ec             	mov    %edi,-0x14(%rbp)
ffff80000010276f:	89 75 e8             	mov    %esi,-0x18(%rbp)
  struct inode *ip, *empty;

  acquire(&icache.lock);
ffff800000102772:	48 bf 20 46 11 00 00 	movabs $0xffff800000114620,%rdi
ffff800000102779:	80 ff ff 
ffff80000010277c:	48 b8 17 7f 10 00 00 	movabs $0xffff800000107f17,%rax
ffff800000102783:	80 ff ff 
ffff800000102786:	ff d0                	callq  *%rax

  // Is the inode already cached?
  empty = 0;
ffff800000102788:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
ffff80000010278f:	00 
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
ffff800000102790:	48 b8 88 46 11 00 00 	movabs $0xffff800000114688,%rax
ffff800000102797:	80 ff ff 
ffff80000010279a:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
ffff80000010279e:	eb 74                	jmp    ffff800000102814 <iget+0xb4>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
ffff8000001027a0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff8000001027a4:	8b 40 08             	mov    0x8(%rax),%eax
ffff8000001027a7:	85 c0                	test   %eax,%eax
ffff8000001027a9:	7e 47                	jle    ffff8000001027f2 <iget+0x92>
ffff8000001027ab:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff8000001027af:	8b 00                	mov    (%rax),%eax
ffff8000001027b1:	39 45 ec             	cmp    %eax,-0x14(%rbp)
ffff8000001027b4:	75 3c                	jne    ffff8000001027f2 <iget+0x92>
ffff8000001027b6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff8000001027ba:	8b 40 04             	mov    0x4(%rax),%eax
ffff8000001027bd:	39 45 e8             	cmp    %eax,-0x18(%rbp)
ffff8000001027c0:	75 30                	jne    ffff8000001027f2 <iget+0x92>
      ip->ref++;
ffff8000001027c2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff8000001027c6:	8b 40 08             	mov    0x8(%rax),%eax
ffff8000001027c9:	8d 50 01             	lea    0x1(%rax),%edx
ffff8000001027cc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff8000001027d0:	89 50 08             	mov    %edx,0x8(%rax)
      release(&icache.lock);
ffff8000001027d3:	48 bf 20 46 11 00 00 	movabs $0xffff800000114620,%rdi
ffff8000001027da:	80 ff ff 
ffff8000001027dd:	48 b8 b4 7f 10 00 00 	movabs $0xffff800000107fb4,%rax
ffff8000001027e4:	80 ff ff 
ffff8000001027e7:	ff d0                	callq  *%rax
      return ip;
ffff8000001027e9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff8000001027ed:	e9 a1 00 00 00       	jmpq   ffff800000102893 <iget+0x133>
    }
    if(empty == 0 && ip->ref == 0) // Remember empty slot.
ffff8000001027f2:	48 83 7d f0 00       	cmpq   $0x0,-0x10(%rbp)
ffff8000001027f7:	75 13                	jne    ffff80000010280c <iget+0xac>
ffff8000001027f9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff8000001027fd:	8b 40 08             	mov    0x8(%rax),%eax
ffff800000102800:	85 c0                	test   %eax,%eax
ffff800000102802:	75 08                	jne    ffff80000010280c <iget+0xac>
      empty = ip;
ffff800000102804:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000102808:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
ffff80000010280c:	48 81 45 f8 d8 00 00 	addq   $0xd8,-0x8(%rbp)
ffff800000102813:	00 
ffff800000102814:	48 b8 b8 70 11 00 00 	movabs $0xffff8000001170b8,%rax
ffff80000010281b:	80 ff ff 
ffff80000010281e:	48 39 45 f8          	cmp    %rax,-0x8(%rbp)
ffff800000102822:	0f 82 78 ff ff ff    	jb     ffff8000001027a0 <iget+0x40>
  }

  // Recycle an inode cache entry.
  if(empty == 0)
ffff800000102828:	48 83 7d f0 00       	cmpq   $0x0,-0x10(%rbp)
ffff80000010282d:	75 16                	jne    ffff800000102845 <iget+0xe5>
    panic("iget: no inodes");
ffff80000010282f:	48 bf a5 c8 10 00 00 	movabs $0xffff80000010c8a5,%rdi
ffff800000102836:	80 ff ff 
ffff800000102839:	48 b8 f9 0b 10 00 00 	movabs $0xffff800000100bf9,%rax
ffff800000102840:	80 ff ff 
ffff800000102843:	ff d0                	callq  *%rax

  ip = empty;
ffff800000102845:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff800000102849:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  ip->dev = dev;
ffff80000010284d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000102851:	8b 55 ec             	mov    -0x14(%rbp),%edx
ffff800000102854:	89 10                	mov    %edx,(%rax)
  ip->inum = inum;
ffff800000102856:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff80000010285a:	8b 55 e8             	mov    -0x18(%rbp),%edx
ffff80000010285d:	89 50 04             	mov    %edx,0x4(%rax)
  ip->ref = 1;
ffff800000102860:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000102864:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)
  ip->flags = 0;
ffff80000010286b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff80000010286f:	c7 80 90 00 00 00 00 	movl   $0x0,0x90(%rax)
ffff800000102876:	00 00 00 
  release(&icache.lock);
ffff800000102879:	48 bf 20 46 11 00 00 	movabs $0xffff800000114620,%rdi
ffff800000102880:	80 ff ff 
ffff800000102883:	48 b8 b4 7f 10 00 00 	movabs $0xffff800000107fb4,%rax
ffff80000010288a:	80 ff ff 
ffff80000010288d:	ff d0                	callq  *%rax

  return ip;
ffff80000010288f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
ffff800000102893:	c9                   	leaveq 
ffff800000102894:	c3                   	retq   

ffff800000102895 <idup>:

// Increment reference count for ip.
// Returns ip to enable ip = idup(ip1) idiom.
struct inode*
idup(struct inode *ip)
{
ffff800000102895:	f3 0f 1e fa          	endbr64 
ffff800000102899:	55                   	push   %rbp
ffff80000010289a:	48 89 e5             	mov    %rsp,%rbp
ffff80000010289d:	48 83 ec 10          	sub    $0x10,%rsp
ffff8000001028a1:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  acquire(&icache.lock);
ffff8000001028a5:	48 bf 20 46 11 00 00 	movabs $0xffff800000114620,%rdi
ffff8000001028ac:	80 ff ff 
ffff8000001028af:	48 b8 17 7f 10 00 00 	movabs $0xffff800000107f17,%rax
ffff8000001028b6:	80 ff ff 
ffff8000001028b9:	ff d0                	callq  *%rax
  ip->ref++;
ffff8000001028bb:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff8000001028bf:	8b 40 08             	mov    0x8(%rax),%eax
ffff8000001028c2:	8d 50 01             	lea    0x1(%rax),%edx
ffff8000001028c5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff8000001028c9:	89 50 08             	mov    %edx,0x8(%rax)
  release(&icache.lock);
ffff8000001028cc:	48 bf 20 46 11 00 00 	movabs $0xffff800000114620,%rdi
ffff8000001028d3:	80 ff ff 
ffff8000001028d6:	48 b8 b4 7f 10 00 00 	movabs $0xffff800000107fb4,%rax
ffff8000001028dd:	80 ff ff 
ffff8000001028e0:	ff d0                	callq  *%rax
  return ip;
ffff8000001028e2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
ffff8000001028e6:	c9                   	leaveq 
ffff8000001028e7:	c3                   	retq   

ffff8000001028e8 <ilock>:

// Lock the given inode.
// Reads the inode from disk if necessary.
void
ilock(struct inode *ip)
{
ffff8000001028e8:	f3 0f 1e fa          	endbr64 
ffff8000001028ec:	55                   	push   %rbp
ffff8000001028ed:	48 89 e5             	mov    %rsp,%rbp
ffff8000001028f0:	48 83 ec 20          	sub    $0x20,%rsp
ffff8000001028f4:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  struct buf *bp;
  struct dinode *dip;

  if(ip == 0 || ip->ref < 1)
ffff8000001028f8:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
ffff8000001028fd:	74 0b                	je     ffff80000010290a <ilock+0x22>
ffff8000001028ff:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000102903:	8b 40 08             	mov    0x8(%rax),%eax
ffff800000102906:	85 c0                	test   %eax,%eax
ffff800000102908:	7f 16                	jg     ffff800000102920 <ilock+0x38>
    panic("ilock");
ffff80000010290a:	48 bf b5 c8 10 00 00 	movabs $0xffff80000010c8b5,%rdi
ffff800000102911:	80 ff ff 
ffff800000102914:	48 b8 f9 0b 10 00 00 	movabs $0xffff800000100bf9,%rax
ffff80000010291b:	80 ff ff 
ffff80000010291e:	ff d0                	callq  *%rax

  acquiresleep(&ip->lock);
ffff800000102920:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000102924:	48 83 c0 10          	add    $0x10,%rax
ffff800000102928:	48 89 c7             	mov    %rax,%rdi
ffff80000010292b:	48 b8 44 7d 10 00 00 	movabs $0xffff800000107d44,%rax
ffff800000102932:	80 ff ff 
ffff800000102935:	ff d0                	callq  *%rax

  if(!(ip->flags & I_VALID)){
ffff800000102937:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff80000010293b:	8b 80 90 00 00 00    	mov    0x90(%rax),%eax
ffff800000102941:	83 e0 02             	and    $0x2,%eax
ffff800000102944:	85 c0                	test   %eax,%eax
ffff800000102946:	0f 85 2e 01 00 00    	jne    ffff800000102a7a <ilock+0x192>
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
ffff80000010294c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000102950:	8b 40 04             	mov    0x4(%rax),%eax
ffff800000102953:	c1 e8 03             	shr    $0x3,%eax
ffff800000102956:	89 c2                	mov    %eax,%edx
ffff800000102958:	48 b8 00 46 11 00 00 	movabs $0xffff800000114600,%rax
ffff80000010295f:	80 ff ff 
ffff800000102962:	8b 40 14             	mov    0x14(%rax),%eax
ffff800000102965:	01 c2                	add    %eax,%edx
ffff800000102967:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff80000010296b:	8b 00                	mov    (%rax),%eax
ffff80000010296d:	89 d6                	mov    %edx,%esi
ffff80000010296f:	89 c7                	mov    %eax,%edi
ffff800000102971:	48 b8 be 03 10 00 00 	movabs $0xffff8000001003be,%rax
ffff800000102978:	80 ff ff 
ffff80000010297b:	ff d0                	callq  *%rax
ffff80000010297d:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
    dip = (struct dinode*)bp->data + ip->inum%IPB;
ffff800000102981:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000102985:	48 8d 90 b0 00 00 00 	lea    0xb0(%rax),%rdx
ffff80000010298c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000102990:	8b 40 04             	mov    0x4(%rax),%eax
ffff800000102993:	89 c0                	mov    %eax,%eax
ffff800000102995:	83 e0 07             	and    $0x7,%eax
ffff800000102998:	48 c1 e0 06          	shl    $0x6,%rax
ffff80000010299c:	48 01 d0             	add    %rdx,%rax
ffff80000010299f:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
    ip->type = dip->type;
ffff8000001029a3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff8000001029a7:	0f b7 10             	movzwl (%rax),%edx
ffff8000001029aa:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff8000001029ae:	66 89 90 94 00 00 00 	mov    %dx,0x94(%rax)
    ip->major = dip->major;
ffff8000001029b5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff8000001029b9:	0f b7 50 02          	movzwl 0x2(%rax),%edx
ffff8000001029bd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff8000001029c1:	66 89 90 96 00 00 00 	mov    %dx,0x96(%rax)
    ip->minor = dip->minor;
ffff8000001029c8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff8000001029cc:	0f b7 50 04          	movzwl 0x4(%rax),%edx
ffff8000001029d0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff8000001029d4:	66 89 90 98 00 00 00 	mov    %dx,0x98(%rax)
    ip->nlink = dip->nlink;
ffff8000001029db:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff8000001029df:	0f b7 50 06          	movzwl 0x6(%rax),%edx
ffff8000001029e3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff8000001029e7:	66 89 90 9a 00 00 00 	mov    %dx,0x9a(%rax)
    ip->size = dip->size;
ffff8000001029ee:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff8000001029f2:	8b 50 08             	mov    0x8(%rax),%edx
ffff8000001029f5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff8000001029f9:	89 90 9c 00 00 00    	mov    %edx,0x9c(%rax)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
ffff8000001029ff:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff800000102a03:	48 8d 48 0c          	lea    0xc(%rax),%rcx
ffff800000102a07:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000102a0b:	48 05 a0 00 00 00    	add    $0xa0,%rax
ffff800000102a11:	ba 34 00 00 00       	mov    $0x34,%edx
ffff800000102a16:	48 89 ce             	mov    %rcx,%rsi
ffff800000102a19:	48 89 c7             	mov    %rax,%rdi
ffff800000102a1c:	48 b8 ca 83 10 00 00 	movabs $0xffff8000001083ca,%rax
ffff800000102a23:	80 ff ff 
ffff800000102a26:	ff d0                	callq  *%rax
    brelse(bp);
ffff800000102a28:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000102a2c:	48 89 c7             	mov    %rax,%rdi
ffff800000102a2f:	48 b8 78 04 10 00 00 	movabs $0xffff800000100478,%rax
ffff800000102a36:	80 ff ff 
ffff800000102a39:	ff d0                	callq  *%rax
    ip->flags |= I_VALID;
ffff800000102a3b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000102a3f:	8b 80 90 00 00 00    	mov    0x90(%rax),%eax
ffff800000102a45:	83 c8 02             	or     $0x2,%eax
ffff800000102a48:	89 c2                	mov    %eax,%edx
ffff800000102a4a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000102a4e:	89 90 90 00 00 00    	mov    %edx,0x90(%rax)
    if(ip->type == 0)
ffff800000102a54:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000102a58:	0f b7 80 94 00 00 00 	movzwl 0x94(%rax),%eax
ffff800000102a5f:	66 85 c0             	test   %ax,%ax
ffff800000102a62:	75 16                	jne    ffff800000102a7a <ilock+0x192>
      panic("ilock: no type");
ffff800000102a64:	48 bf bb c8 10 00 00 	movabs $0xffff80000010c8bb,%rdi
ffff800000102a6b:	80 ff ff 
ffff800000102a6e:	48 b8 f9 0b 10 00 00 	movabs $0xffff800000100bf9,%rax
ffff800000102a75:	80 ff ff 
ffff800000102a78:	ff d0                	callq  *%rax
  }
}
ffff800000102a7a:	90                   	nop
ffff800000102a7b:	c9                   	leaveq 
ffff800000102a7c:	c3                   	retq   

ffff800000102a7d <iunlock>:

// Unlock the given inode.
void
iunlock(struct inode *ip)
{
ffff800000102a7d:	f3 0f 1e fa          	endbr64 
ffff800000102a81:	55                   	push   %rbp
ffff800000102a82:	48 89 e5             	mov    %rsp,%rbp
ffff800000102a85:	48 83 ec 10          	sub    $0x10,%rsp
ffff800000102a89:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
ffff800000102a8d:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
ffff800000102a92:	74 26                	je     ffff800000102aba <iunlock+0x3d>
ffff800000102a94:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000102a98:	48 83 c0 10          	add    $0x10,%rax
ffff800000102a9c:	48 89 c7             	mov    %rax,%rdi
ffff800000102a9f:	48 b8 37 7e 10 00 00 	movabs $0xffff800000107e37,%rax
ffff800000102aa6:	80 ff ff 
ffff800000102aa9:	ff d0                	callq  *%rax
ffff800000102aab:	85 c0                	test   %eax,%eax
ffff800000102aad:	74 0b                	je     ffff800000102aba <iunlock+0x3d>
ffff800000102aaf:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000102ab3:	8b 40 08             	mov    0x8(%rax),%eax
ffff800000102ab6:	85 c0                	test   %eax,%eax
ffff800000102ab8:	7f 16                	jg     ffff800000102ad0 <iunlock+0x53>
    panic("iunlock");
ffff800000102aba:	48 bf ca c8 10 00 00 	movabs $0xffff80000010c8ca,%rdi
ffff800000102ac1:	80 ff ff 
ffff800000102ac4:	48 b8 f9 0b 10 00 00 	movabs $0xffff800000100bf9,%rax
ffff800000102acb:	80 ff ff 
ffff800000102ace:	ff d0                	callq  *%rax

  releasesleep(&ip->lock);
ffff800000102ad0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000102ad4:	48 83 c0 10          	add    $0x10,%rax
ffff800000102ad8:	48 89 c7             	mov    %rax,%rdi
ffff800000102adb:	48 b8 ce 7d 10 00 00 	movabs $0xffff800000107dce,%rax
ffff800000102ae2:	80 ff ff 
ffff800000102ae5:	ff d0                	callq  *%rax
}
ffff800000102ae7:	90                   	nop
ffff800000102ae8:	c9                   	leaveq 
ffff800000102ae9:	c3                   	retq   

ffff800000102aea <iput>:
// to it, free the inode (and its content) on disk.
// All calls to iput() must be inside a transaction in
// case it has to free the inode.
void
iput(struct inode *ip)
{
ffff800000102aea:	f3 0f 1e fa          	endbr64 
ffff800000102aee:	55                   	push   %rbp
ffff800000102aef:	48 89 e5             	mov    %rsp,%rbp
ffff800000102af2:	48 83 ec 10          	sub    $0x10,%rsp
ffff800000102af6:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  acquire(&icache.lock);
ffff800000102afa:	48 bf 20 46 11 00 00 	movabs $0xffff800000114620,%rdi
ffff800000102b01:	80 ff ff 
ffff800000102b04:	48 b8 17 7f 10 00 00 	movabs $0xffff800000107f17,%rax
ffff800000102b0b:	80 ff ff 
ffff800000102b0e:	ff d0                	callq  *%rax
  if(ip->ref == 1 && (ip->flags & I_VALID) && ip->nlink == 0){
ffff800000102b10:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000102b14:	8b 40 08             	mov    0x8(%rax),%eax
ffff800000102b17:	83 f8 01             	cmp    $0x1,%eax
ffff800000102b1a:	0f 85 8e 00 00 00    	jne    ffff800000102bae <iput+0xc4>
ffff800000102b20:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000102b24:	8b 80 90 00 00 00    	mov    0x90(%rax),%eax
ffff800000102b2a:	83 e0 02             	and    $0x2,%eax
ffff800000102b2d:	85 c0                	test   %eax,%eax
ffff800000102b2f:	74 7d                	je     ffff800000102bae <iput+0xc4>
ffff800000102b31:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000102b35:	0f b7 80 9a 00 00 00 	movzwl 0x9a(%rax),%eax
ffff800000102b3c:	66 85 c0             	test   %ax,%ax
ffff800000102b3f:	75 6d                	jne    ffff800000102bae <iput+0xc4>
    // inode has no links and no other references: truncate and free.
    release(&icache.lock);
ffff800000102b41:	48 bf 20 46 11 00 00 	movabs $0xffff800000114620,%rdi
ffff800000102b48:	80 ff ff 
ffff800000102b4b:	48 b8 b4 7f 10 00 00 	movabs $0xffff800000107fb4,%rax
ffff800000102b52:	80 ff ff 
ffff800000102b55:	ff d0                	callq  *%rax
    itrunc(ip);
ffff800000102b57:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000102b5b:	48 89 c7             	mov    %rax,%rdi
ffff800000102b5e:	48 b8 6f 2d 10 00 00 	movabs $0xffff800000102d6f,%rax
ffff800000102b65:	80 ff ff 
ffff800000102b68:	ff d0                	callq  *%rax
    ip->type = 0;
ffff800000102b6a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000102b6e:	66 c7 80 94 00 00 00 	movw   $0x0,0x94(%rax)
ffff800000102b75:	00 00 
    iupdate(ip);
ffff800000102b77:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000102b7b:	48 89 c7             	mov    %rax,%rdi
ffff800000102b7e:	48 b8 4a 26 10 00 00 	movabs $0xffff80000010264a,%rax
ffff800000102b85:	80 ff ff 
ffff800000102b88:	ff d0                	callq  *%rax
    acquire(&icache.lock);
ffff800000102b8a:	48 bf 20 46 11 00 00 	movabs $0xffff800000114620,%rdi
ffff800000102b91:	80 ff ff 
ffff800000102b94:	48 b8 17 7f 10 00 00 	movabs $0xffff800000107f17,%rax
ffff800000102b9b:	80 ff ff 
ffff800000102b9e:	ff d0                	callq  *%rax
    ip->flags = 0;
ffff800000102ba0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000102ba4:	c7 80 90 00 00 00 00 	movl   $0x0,0x90(%rax)
ffff800000102bab:	00 00 00 
  }
  ip->ref--;
ffff800000102bae:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000102bb2:	8b 40 08             	mov    0x8(%rax),%eax
ffff800000102bb5:	8d 50 ff             	lea    -0x1(%rax),%edx
ffff800000102bb8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000102bbc:	89 50 08             	mov    %edx,0x8(%rax)
  release(&icache.lock);
ffff800000102bbf:	48 bf 20 46 11 00 00 	movabs $0xffff800000114620,%rdi
ffff800000102bc6:	80 ff ff 
ffff800000102bc9:	48 b8 b4 7f 10 00 00 	movabs $0xffff800000107fb4,%rax
ffff800000102bd0:	80 ff ff 
ffff800000102bd3:	ff d0                	callq  *%rax
}
ffff800000102bd5:	90                   	nop
ffff800000102bd6:	c9                   	leaveq 
ffff800000102bd7:	c3                   	retq   

ffff800000102bd8 <iunlockput>:

// Common idiom: unlock, then put.
void
iunlockput(struct inode *ip)
{
ffff800000102bd8:	f3 0f 1e fa          	endbr64 
ffff800000102bdc:	55                   	push   %rbp
ffff800000102bdd:	48 89 e5             	mov    %rsp,%rbp
ffff800000102be0:	48 83 ec 10          	sub    $0x10,%rsp
ffff800000102be4:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  iunlock(ip);
ffff800000102be8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000102bec:	48 89 c7             	mov    %rax,%rdi
ffff800000102bef:	48 b8 7d 2a 10 00 00 	movabs $0xffff800000102a7d,%rax
ffff800000102bf6:	80 ff ff 
ffff800000102bf9:	ff d0                	callq  *%rax
  iput(ip);
ffff800000102bfb:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000102bff:	48 89 c7             	mov    %rax,%rdi
ffff800000102c02:	48 b8 ea 2a 10 00 00 	movabs $0xffff800000102aea,%rax
ffff800000102c09:	80 ff ff 
ffff800000102c0c:	ff d0                	callq  *%rax
}
ffff800000102c0e:	90                   	nop
ffff800000102c0f:	c9                   	leaveq 
ffff800000102c10:	c3                   	retq   

ffff800000102c11 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
ffff800000102c11:	f3 0f 1e fa          	endbr64 
ffff800000102c15:	55                   	push   %rbp
ffff800000102c16:	48 89 e5             	mov    %rsp,%rbp
ffff800000102c19:	48 83 ec 30          	sub    $0x30,%rsp
ffff800000102c1d:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
ffff800000102c21:	89 75 d4             	mov    %esi,-0x2c(%rbp)
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
ffff800000102c24:	83 7d d4 0b          	cmpl   $0xb,-0x2c(%rbp)
ffff800000102c28:	77 47                	ja     ffff800000102c71 <bmap+0x60>
    if((addr = ip->addrs[bn]) == 0)
ffff800000102c2a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
ffff800000102c2e:	8b 55 d4             	mov    -0x2c(%rbp),%edx
ffff800000102c31:	48 83 c2 28          	add    $0x28,%rdx
ffff800000102c35:	8b 04 90             	mov    (%rax,%rdx,4),%eax
ffff800000102c38:	89 45 fc             	mov    %eax,-0x4(%rbp)
ffff800000102c3b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
ffff800000102c3f:	75 28                	jne    ffff800000102c69 <bmap+0x58>
      ip->addrs[bn] = addr = balloc(ip->dev);
ffff800000102c41:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
ffff800000102c45:	8b 00                	mov    (%rax),%eax
ffff800000102c47:	89 c7                	mov    %eax,%edi
ffff800000102c49:	48 b8 b2 21 10 00 00 	movabs $0xffff8000001021b2,%rax
ffff800000102c50:	80 ff ff 
ffff800000102c53:	ff d0                	callq  *%rax
ffff800000102c55:	89 45 fc             	mov    %eax,-0x4(%rbp)
ffff800000102c58:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
ffff800000102c5c:	8b 55 d4             	mov    -0x2c(%rbp),%edx
ffff800000102c5f:	48 8d 4a 28          	lea    0x28(%rdx),%rcx
ffff800000102c63:	8b 55 fc             	mov    -0x4(%rbp),%edx
ffff800000102c66:	89 14 88             	mov    %edx,(%rax,%rcx,4)
    return addr;
ffff800000102c69:	8b 45 fc             	mov    -0x4(%rbp),%eax
ffff800000102c6c:	e9 fc 00 00 00       	jmpq   ffff800000102d6d <bmap+0x15c>
  }
  bn -= NDIRECT;
ffff800000102c71:	83 6d d4 0c          	subl   $0xc,-0x2c(%rbp)

  if(bn < NINDIRECT){
ffff800000102c75:	83 7d d4 7f          	cmpl   $0x7f,-0x2c(%rbp)
ffff800000102c79:	0f 87 d8 00 00 00    	ja     ffff800000102d57 <bmap+0x146>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
ffff800000102c7f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
ffff800000102c83:	8b 80 d0 00 00 00    	mov    0xd0(%rax),%eax
ffff800000102c89:	89 45 fc             	mov    %eax,-0x4(%rbp)
ffff800000102c8c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
ffff800000102c90:	75 24                	jne    ffff800000102cb6 <bmap+0xa5>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
ffff800000102c92:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
ffff800000102c96:	8b 00                	mov    (%rax),%eax
ffff800000102c98:	89 c7                	mov    %eax,%edi
ffff800000102c9a:	48 b8 b2 21 10 00 00 	movabs $0xffff8000001021b2,%rax
ffff800000102ca1:	80 ff ff 
ffff800000102ca4:	ff d0                	callq  *%rax
ffff800000102ca6:	89 45 fc             	mov    %eax,-0x4(%rbp)
ffff800000102ca9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
ffff800000102cad:	8b 55 fc             	mov    -0x4(%rbp),%edx
ffff800000102cb0:	89 90 d0 00 00 00    	mov    %edx,0xd0(%rax)
    bp = bread(ip->dev, addr);
ffff800000102cb6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
ffff800000102cba:	8b 00                	mov    (%rax),%eax
ffff800000102cbc:	8b 55 fc             	mov    -0x4(%rbp),%edx
ffff800000102cbf:	89 d6                	mov    %edx,%esi
ffff800000102cc1:	89 c7                	mov    %eax,%edi
ffff800000102cc3:	48 b8 be 03 10 00 00 	movabs $0xffff8000001003be,%rax
ffff800000102cca:	80 ff ff 
ffff800000102ccd:	ff d0                	callq  *%rax
ffff800000102ccf:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
    a = (uint*)bp->data;
ffff800000102cd3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff800000102cd7:	48 05 b0 00 00 00    	add    $0xb0,%rax
ffff800000102cdd:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
    if((addr = a[bn]) == 0){
ffff800000102ce1:	8b 45 d4             	mov    -0x2c(%rbp),%eax
ffff800000102ce4:	48 8d 14 85 00 00 00 	lea    0x0(,%rax,4),%rdx
ffff800000102ceb:	00 
ffff800000102cec:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000102cf0:	48 01 d0             	add    %rdx,%rax
ffff800000102cf3:	8b 00                	mov    (%rax),%eax
ffff800000102cf5:	89 45 fc             	mov    %eax,-0x4(%rbp)
ffff800000102cf8:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
ffff800000102cfc:	75 41                	jne    ffff800000102d3f <bmap+0x12e>
      a[bn] = addr = balloc(ip->dev);
ffff800000102cfe:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
ffff800000102d02:	8b 00                	mov    (%rax),%eax
ffff800000102d04:	89 c7                	mov    %eax,%edi
ffff800000102d06:	48 b8 b2 21 10 00 00 	movabs $0xffff8000001021b2,%rax
ffff800000102d0d:	80 ff ff 
ffff800000102d10:	ff d0                	callq  *%rax
ffff800000102d12:	89 45 fc             	mov    %eax,-0x4(%rbp)
ffff800000102d15:	8b 45 d4             	mov    -0x2c(%rbp),%eax
ffff800000102d18:	48 8d 14 85 00 00 00 	lea    0x0(,%rax,4),%rdx
ffff800000102d1f:	00 
ffff800000102d20:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000102d24:	48 01 c2             	add    %rax,%rdx
ffff800000102d27:	8b 45 fc             	mov    -0x4(%rbp),%eax
ffff800000102d2a:	89 02                	mov    %eax,(%rdx)
      log_write(bp);
ffff800000102d2c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff800000102d30:	48 89 c7             	mov    %rax,%rdi
ffff800000102d33:	48 b8 ef 52 10 00 00 	movabs $0xffff8000001052ef,%rax
ffff800000102d3a:	80 ff ff 
ffff800000102d3d:	ff d0                	callq  *%rax
    }
    brelse(bp);
ffff800000102d3f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff800000102d43:	48 89 c7             	mov    %rax,%rdi
ffff800000102d46:	48 b8 78 04 10 00 00 	movabs $0xffff800000100478,%rax
ffff800000102d4d:	80 ff ff 
ffff800000102d50:	ff d0                	callq  *%rax
    return addr;
ffff800000102d52:	8b 45 fc             	mov    -0x4(%rbp),%eax
ffff800000102d55:	eb 16                	jmp    ffff800000102d6d <bmap+0x15c>
  }

  panic("bmap: out of range");
ffff800000102d57:	48 bf d2 c8 10 00 00 	movabs $0xffff80000010c8d2,%rdi
ffff800000102d5e:	80 ff ff 
ffff800000102d61:	48 b8 f9 0b 10 00 00 	movabs $0xffff800000100bf9,%rax
ffff800000102d68:	80 ff ff 
ffff800000102d6b:	ff d0                	callq  *%rax
}
ffff800000102d6d:	c9                   	leaveq 
ffff800000102d6e:	c3                   	retq   

ffff800000102d6f <itrunc>:
// to it (no directory entries referring to it)
// and has no in-memory reference to it (is
// not an open file or current directory).
static void
itrunc(struct inode *ip)
{
ffff800000102d6f:	f3 0f 1e fa          	endbr64 
ffff800000102d73:	55                   	push   %rbp
ffff800000102d74:	48 89 e5             	mov    %rsp,%rbp
ffff800000102d77:	48 83 ec 30          	sub    $0x30,%rsp
ffff800000102d7b:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
ffff800000102d7f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
ffff800000102d86:	eb 55                	jmp    ffff800000102ddd <itrunc+0x6e>
    if(ip->addrs[i]){
ffff800000102d88:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
ffff800000102d8c:	8b 55 fc             	mov    -0x4(%rbp),%edx
ffff800000102d8f:	48 63 d2             	movslq %edx,%rdx
ffff800000102d92:	48 83 c2 28          	add    $0x28,%rdx
ffff800000102d96:	8b 04 90             	mov    (%rax,%rdx,4),%eax
ffff800000102d99:	85 c0                	test   %eax,%eax
ffff800000102d9b:	74 3c                	je     ffff800000102dd9 <itrunc+0x6a>
      bfree(ip->dev, ip->addrs[i]);
ffff800000102d9d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
ffff800000102da1:	8b 55 fc             	mov    -0x4(%rbp),%edx
ffff800000102da4:	48 63 d2             	movslq %edx,%rdx
ffff800000102da7:	48 83 c2 28          	add    $0x28,%rdx
ffff800000102dab:	8b 04 90             	mov    (%rax,%rdx,4),%eax
ffff800000102dae:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
ffff800000102db2:	8b 12                	mov    (%rdx),%edx
ffff800000102db4:	89 c6                	mov    %eax,%esi
ffff800000102db6:	89 d7                	mov    %edx,%edi
ffff800000102db8:	48 b8 4e 23 10 00 00 	movabs $0xffff80000010234e,%rax
ffff800000102dbf:	80 ff ff 
ffff800000102dc2:	ff d0                	callq  *%rax
      ip->addrs[i] = 0;
ffff800000102dc4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
ffff800000102dc8:	8b 55 fc             	mov    -0x4(%rbp),%edx
ffff800000102dcb:	48 63 d2             	movslq %edx,%rdx
ffff800000102dce:	48 83 c2 28          	add    $0x28,%rdx
ffff800000102dd2:	c7 04 90 00 00 00 00 	movl   $0x0,(%rax,%rdx,4)
  for(i = 0; i < NDIRECT; i++){
ffff800000102dd9:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
ffff800000102ddd:	83 7d fc 0b          	cmpl   $0xb,-0x4(%rbp)
ffff800000102de1:	7e a5                	jle    ffff800000102d88 <itrunc+0x19>
    }
  }

  if(ip->addrs[NDIRECT]){
ffff800000102de3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
ffff800000102de7:	8b 80 d0 00 00 00    	mov    0xd0(%rax),%eax
ffff800000102ded:	85 c0                	test   %eax,%eax
ffff800000102def:	0f 84 ce 00 00 00    	je     ffff800000102ec3 <itrunc+0x154>
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
ffff800000102df5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
ffff800000102df9:	8b 90 d0 00 00 00    	mov    0xd0(%rax),%edx
ffff800000102dff:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
ffff800000102e03:	8b 00                	mov    (%rax),%eax
ffff800000102e05:	89 d6                	mov    %edx,%esi
ffff800000102e07:	89 c7                	mov    %eax,%edi
ffff800000102e09:	48 b8 be 03 10 00 00 	movabs $0xffff8000001003be,%rax
ffff800000102e10:	80 ff ff 
ffff800000102e13:	ff d0                	callq  *%rax
ffff800000102e15:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
    a = (uint*)bp->data;
ffff800000102e19:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff800000102e1d:	48 05 b0 00 00 00    	add    $0xb0,%rax
ffff800000102e23:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
    for(j = 0; j < NINDIRECT; j++){
ffff800000102e27:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%rbp)
ffff800000102e2e:	eb 4a                	jmp    ffff800000102e7a <itrunc+0x10b>
      if(a[j])
ffff800000102e30:	8b 45 f8             	mov    -0x8(%rbp),%eax
ffff800000102e33:	48 98                	cltq   
ffff800000102e35:	48 8d 14 85 00 00 00 	lea    0x0(,%rax,4),%rdx
ffff800000102e3c:	00 
ffff800000102e3d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000102e41:	48 01 d0             	add    %rdx,%rax
ffff800000102e44:	8b 00                	mov    (%rax),%eax
ffff800000102e46:	85 c0                	test   %eax,%eax
ffff800000102e48:	74 2c                	je     ffff800000102e76 <itrunc+0x107>
        bfree(ip->dev, a[j]);
ffff800000102e4a:	8b 45 f8             	mov    -0x8(%rbp),%eax
ffff800000102e4d:	48 98                	cltq   
ffff800000102e4f:	48 8d 14 85 00 00 00 	lea    0x0(,%rax,4),%rdx
ffff800000102e56:	00 
ffff800000102e57:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000102e5b:	48 01 d0             	add    %rdx,%rax
ffff800000102e5e:	8b 00                	mov    (%rax),%eax
ffff800000102e60:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
ffff800000102e64:	8b 12                	mov    (%rdx),%edx
ffff800000102e66:	89 c6                	mov    %eax,%esi
ffff800000102e68:	89 d7                	mov    %edx,%edi
ffff800000102e6a:	48 b8 4e 23 10 00 00 	movabs $0xffff80000010234e,%rax
ffff800000102e71:	80 ff ff 
ffff800000102e74:	ff d0                	callq  *%rax
    for(j = 0; j < NINDIRECT; j++){
ffff800000102e76:	83 45 f8 01          	addl   $0x1,-0x8(%rbp)
ffff800000102e7a:	8b 45 f8             	mov    -0x8(%rbp),%eax
ffff800000102e7d:	83 f8 7f             	cmp    $0x7f,%eax
ffff800000102e80:	76 ae                	jbe    ffff800000102e30 <itrunc+0xc1>
    }
    brelse(bp);
ffff800000102e82:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff800000102e86:	48 89 c7             	mov    %rax,%rdi
ffff800000102e89:	48 b8 78 04 10 00 00 	movabs $0xffff800000100478,%rax
ffff800000102e90:	80 ff ff 
ffff800000102e93:	ff d0                	callq  *%rax
    bfree(ip->dev, ip->addrs[NDIRECT]);
ffff800000102e95:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
ffff800000102e99:	8b 80 d0 00 00 00    	mov    0xd0(%rax),%eax
ffff800000102e9f:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
ffff800000102ea3:	8b 12                	mov    (%rdx),%edx
ffff800000102ea5:	89 c6                	mov    %eax,%esi
ffff800000102ea7:	89 d7                	mov    %edx,%edi
ffff800000102ea9:	48 b8 4e 23 10 00 00 	movabs $0xffff80000010234e,%rax
ffff800000102eb0:	80 ff ff 
ffff800000102eb3:	ff d0                	callq  *%rax
    ip->addrs[NDIRECT] = 0;
ffff800000102eb5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
ffff800000102eb9:	c7 80 d0 00 00 00 00 	movl   $0x0,0xd0(%rax)
ffff800000102ec0:	00 00 00 
  }

  ip->size = 0;
ffff800000102ec3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
ffff800000102ec7:	c7 80 9c 00 00 00 00 	movl   $0x0,0x9c(%rax)
ffff800000102ece:	00 00 00 
  iupdate(ip);
ffff800000102ed1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
ffff800000102ed5:	48 89 c7             	mov    %rax,%rdi
ffff800000102ed8:	48 b8 4a 26 10 00 00 	movabs $0xffff80000010264a,%rax
ffff800000102edf:	80 ff ff 
ffff800000102ee2:	ff d0                	callq  *%rax
}
ffff800000102ee4:	90                   	nop
ffff800000102ee5:	c9                   	leaveq 
ffff800000102ee6:	c3                   	retq   

ffff800000102ee7 <stati>:

// Copy stat information from inode.
void
stati(struct inode *ip, struct stat *st)
{
ffff800000102ee7:	f3 0f 1e fa          	endbr64 
ffff800000102eeb:	55                   	push   %rbp
ffff800000102eec:	48 89 e5             	mov    %rsp,%rbp
ffff800000102eef:	48 83 ec 10          	sub    $0x10,%rsp
ffff800000102ef3:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
ffff800000102ef7:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  st->dev = ip->dev;
ffff800000102efb:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000102eff:	8b 00                	mov    (%rax),%eax
ffff800000102f01:	89 c2                	mov    %eax,%edx
ffff800000102f03:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff800000102f07:	89 50 04             	mov    %edx,0x4(%rax)
  st->ino = ip->inum;
ffff800000102f0a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000102f0e:	8b 50 04             	mov    0x4(%rax),%edx
ffff800000102f11:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff800000102f15:	89 50 08             	mov    %edx,0x8(%rax)
  st->type = ip->type;
ffff800000102f18:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000102f1c:	0f b7 90 94 00 00 00 	movzwl 0x94(%rax),%edx
ffff800000102f23:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff800000102f27:	66 89 10             	mov    %dx,(%rax)
  st->nlink = ip->nlink;
ffff800000102f2a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000102f2e:	0f b7 90 9a 00 00 00 	movzwl 0x9a(%rax),%edx
ffff800000102f35:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff800000102f39:	66 89 50 0c          	mov    %dx,0xc(%rax)
  st->size = ip->size;
ffff800000102f3d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000102f41:	8b 90 9c 00 00 00    	mov    0x9c(%rax),%edx
ffff800000102f47:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff800000102f4b:	89 50 10             	mov    %edx,0x10(%rax)
}
ffff800000102f4e:	90                   	nop
ffff800000102f4f:	c9                   	leaveq 
ffff800000102f50:	c3                   	retq   

ffff800000102f51 <readi>:

//PAGEBREAK!
// Read data from inode.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
ffff800000102f51:	f3 0f 1e fa          	endbr64 
ffff800000102f55:	55                   	push   %rbp
ffff800000102f56:	48 89 e5             	mov    %rsp,%rbp
ffff800000102f59:	48 83 ec 40          	sub    $0x40,%rsp
ffff800000102f5d:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
ffff800000102f61:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
ffff800000102f65:	89 55 cc             	mov    %edx,-0x34(%rbp)
ffff800000102f68:	89 4d c8             	mov    %ecx,-0x38(%rbp)
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
ffff800000102f6b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
ffff800000102f6f:	0f b7 80 94 00 00 00 	movzwl 0x94(%rax),%eax
ffff800000102f76:	66 83 f8 03          	cmp    $0x3,%ax
ffff800000102f7a:	0f 85 8d 00 00 00    	jne    ffff80000010300d <readi+0xbc>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
ffff800000102f80:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
ffff800000102f84:	0f b7 80 96 00 00 00 	movzwl 0x96(%rax),%eax
ffff800000102f8b:	66 85 c0             	test   %ax,%ax
ffff800000102f8e:	78 38                	js     ffff800000102fc8 <readi+0x77>
ffff800000102f90:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
ffff800000102f94:	0f b7 80 96 00 00 00 	movzwl 0x96(%rax),%eax
ffff800000102f9b:	66 83 f8 09          	cmp    $0x9,%ax
ffff800000102f9f:	7f 27                	jg     ffff800000102fc8 <readi+0x77>
ffff800000102fa1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
ffff800000102fa5:	0f b7 80 96 00 00 00 	movzwl 0x96(%rax),%eax
ffff800000102fac:	98                   	cwtl   
ffff800000102fad:	48 ba 40 35 11 00 00 	movabs $0xffff800000113540,%rdx
ffff800000102fb4:	80 ff ff 
ffff800000102fb7:	48 98                	cltq   
ffff800000102fb9:	48 c1 e0 04          	shl    $0x4,%rax
ffff800000102fbd:	48 01 d0             	add    %rdx,%rax
ffff800000102fc0:	48 8b 00             	mov    (%rax),%rax
ffff800000102fc3:	48 85 c0             	test   %rax,%rax
ffff800000102fc6:	75 0a                	jne    ffff800000102fd2 <readi+0x81>
      return -1;
ffff800000102fc8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
ffff800000102fcd:	e9 4e 01 00 00       	jmpq   ffff800000103120 <readi+0x1cf>
    return devsw[ip->major].read(ip, off, dst, n);
ffff800000102fd2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
ffff800000102fd6:	0f b7 80 96 00 00 00 	movzwl 0x96(%rax),%eax
ffff800000102fdd:	98                   	cwtl   
ffff800000102fde:	48 ba 40 35 11 00 00 	movabs $0xffff800000113540,%rdx
ffff800000102fe5:	80 ff ff 
ffff800000102fe8:	48 98                	cltq   
ffff800000102fea:	48 c1 e0 04          	shl    $0x4,%rax
ffff800000102fee:	48 01 d0             	add    %rdx,%rax
ffff800000102ff1:	4c 8b 00             	mov    (%rax),%r8
ffff800000102ff4:	8b 4d c8             	mov    -0x38(%rbp),%ecx
ffff800000102ff7:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
ffff800000102ffb:	8b 75 cc             	mov    -0x34(%rbp),%esi
ffff800000102ffe:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
ffff800000103002:	48 89 c7             	mov    %rax,%rdi
ffff800000103005:	41 ff d0             	callq  *%r8
ffff800000103008:	e9 13 01 00 00       	jmpq   ffff800000103120 <readi+0x1cf>
  }

  if(off > ip->size || off + n < off)
ffff80000010300d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
ffff800000103011:	8b 80 9c 00 00 00    	mov    0x9c(%rax),%eax
ffff800000103017:	39 45 cc             	cmp    %eax,-0x34(%rbp)
ffff80000010301a:	77 0d                	ja     ffff800000103029 <readi+0xd8>
ffff80000010301c:	8b 55 cc             	mov    -0x34(%rbp),%edx
ffff80000010301f:	8b 45 c8             	mov    -0x38(%rbp),%eax
ffff800000103022:	01 d0                	add    %edx,%eax
ffff800000103024:	39 45 cc             	cmp    %eax,-0x34(%rbp)
ffff800000103027:	76 0a                	jbe    ffff800000103033 <readi+0xe2>
    return -1;
ffff800000103029:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
ffff80000010302e:	e9 ed 00 00 00       	jmpq   ffff800000103120 <readi+0x1cf>
  if(off + n > ip->size)
ffff800000103033:	8b 55 cc             	mov    -0x34(%rbp),%edx
ffff800000103036:	8b 45 c8             	mov    -0x38(%rbp),%eax
ffff800000103039:	01 c2                	add    %eax,%edx
ffff80000010303b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
ffff80000010303f:	8b 80 9c 00 00 00    	mov    0x9c(%rax),%eax
ffff800000103045:	39 c2                	cmp    %eax,%edx
ffff800000103047:	76 10                	jbe    ffff800000103059 <readi+0x108>
    n = ip->size - off;
ffff800000103049:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
ffff80000010304d:	8b 80 9c 00 00 00    	mov    0x9c(%rax),%eax
ffff800000103053:	2b 45 cc             	sub    -0x34(%rbp),%eax
ffff800000103056:	89 45 c8             	mov    %eax,-0x38(%rbp)

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
ffff800000103059:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
ffff800000103060:	e9 ac 00 00 00       	jmpq   ffff800000103111 <readi+0x1c0>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
ffff800000103065:	8b 45 cc             	mov    -0x34(%rbp),%eax
ffff800000103068:	c1 e8 09             	shr    $0x9,%eax
ffff80000010306b:	89 c2                	mov    %eax,%edx
ffff80000010306d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
ffff800000103071:	89 d6                	mov    %edx,%esi
ffff800000103073:	48 89 c7             	mov    %rax,%rdi
ffff800000103076:	48 b8 11 2c 10 00 00 	movabs $0xffff800000102c11,%rax
ffff80000010307d:	80 ff ff 
ffff800000103080:	ff d0                	callq  *%rax
ffff800000103082:	89 c2                	mov    %eax,%edx
ffff800000103084:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
ffff800000103088:	8b 00                	mov    (%rax),%eax
ffff80000010308a:	89 d6                	mov    %edx,%esi
ffff80000010308c:	89 c7                	mov    %eax,%edi
ffff80000010308e:	48 b8 be 03 10 00 00 	movabs $0xffff8000001003be,%rax
ffff800000103095:	80 ff ff 
ffff800000103098:	ff d0                	callq  *%rax
ffff80000010309a:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
    m = min(n - tot, BSIZE - off%BSIZE);
ffff80000010309e:	8b 45 cc             	mov    -0x34(%rbp),%eax
ffff8000001030a1:	25 ff 01 00 00       	and    $0x1ff,%eax
ffff8000001030a6:	ba 00 02 00 00       	mov    $0x200,%edx
ffff8000001030ab:	29 c2                	sub    %eax,%edx
ffff8000001030ad:	8b 45 c8             	mov    -0x38(%rbp),%eax
ffff8000001030b0:	2b 45 fc             	sub    -0x4(%rbp),%eax
ffff8000001030b3:	39 c2                	cmp    %eax,%edx
ffff8000001030b5:	0f 46 c2             	cmovbe %edx,%eax
ffff8000001030b8:	89 45 ec             	mov    %eax,-0x14(%rbp)
    memmove(dst, bp->data + off%BSIZE, m);
ffff8000001030bb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff8000001030bf:	48 8d 90 b0 00 00 00 	lea    0xb0(%rax),%rdx
ffff8000001030c6:	8b 45 cc             	mov    -0x34(%rbp),%eax
ffff8000001030c9:	25 ff 01 00 00       	and    $0x1ff,%eax
ffff8000001030ce:	48 8d 0c 02          	lea    (%rdx,%rax,1),%rcx
ffff8000001030d2:	8b 55 ec             	mov    -0x14(%rbp),%edx
ffff8000001030d5:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
ffff8000001030d9:	48 89 ce             	mov    %rcx,%rsi
ffff8000001030dc:	48 89 c7             	mov    %rax,%rdi
ffff8000001030df:	48 b8 ca 83 10 00 00 	movabs $0xffff8000001083ca,%rax
ffff8000001030e6:	80 ff ff 
ffff8000001030e9:	ff d0                	callq  *%rax
    brelse(bp);
ffff8000001030eb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff8000001030ef:	48 89 c7             	mov    %rax,%rdi
ffff8000001030f2:	48 b8 78 04 10 00 00 	movabs $0xffff800000100478,%rax
ffff8000001030f9:	80 ff ff 
ffff8000001030fc:	ff d0                	callq  *%rax
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
ffff8000001030fe:	8b 45 ec             	mov    -0x14(%rbp),%eax
ffff800000103101:	01 45 fc             	add    %eax,-0x4(%rbp)
ffff800000103104:	8b 45 ec             	mov    -0x14(%rbp),%eax
ffff800000103107:	01 45 cc             	add    %eax,-0x34(%rbp)
ffff80000010310a:	8b 45 ec             	mov    -0x14(%rbp),%eax
ffff80000010310d:	48 01 45 d0          	add    %rax,-0x30(%rbp)
ffff800000103111:	8b 45 fc             	mov    -0x4(%rbp),%eax
ffff800000103114:	3b 45 c8             	cmp    -0x38(%rbp),%eax
ffff800000103117:	0f 82 48 ff ff ff    	jb     ffff800000103065 <readi+0x114>
  }
  return n;
ffff80000010311d:	8b 45 c8             	mov    -0x38(%rbp),%eax
}
ffff800000103120:	c9                   	leaveq 
ffff800000103121:	c3                   	retq   

ffff800000103122 <writei>:

// PAGEBREAK!
// Write data to inode.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
ffff800000103122:	f3 0f 1e fa          	endbr64 
ffff800000103126:	55                   	push   %rbp
ffff800000103127:	48 89 e5             	mov    %rsp,%rbp
ffff80000010312a:	48 83 ec 40          	sub    $0x40,%rsp
ffff80000010312e:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
ffff800000103132:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
ffff800000103136:	89 55 cc             	mov    %edx,-0x34(%rbp)
ffff800000103139:	89 4d c8             	mov    %ecx,-0x38(%rbp)
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
ffff80000010313c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
ffff800000103140:	0f b7 80 94 00 00 00 	movzwl 0x94(%rax),%eax
ffff800000103147:	66 83 f8 03          	cmp    $0x3,%ax
ffff80000010314b:	0f 85 95 00 00 00    	jne    ffff8000001031e6 <writei+0xc4>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
ffff800000103151:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
ffff800000103155:	0f b7 80 96 00 00 00 	movzwl 0x96(%rax),%eax
ffff80000010315c:	66 85 c0             	test   %ax,%ax
ffff80000010315f:	78 3c                	js     ffff80000010319d <writei+0x7b>
ffff800000103161:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
ffff800000103165:	0f b7 80 96 00 00 00 	movzwl 0x96(%rax),%eax
ffff80000010316c:	66 83 f8 09          	cmp    $0x9,%ax
ffff800000103170:	7f 2b                	jg     ffff80000010319d <writei+0x7b>
ffff800000103172:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
ffff800000103176:	0f b7 80 96 00 00 00 	movzwl 0x96(%rax),%eax
ffff80000010317d:	98                   	cwtl   
ffff80000010317e:	48 ba 40 35 11 00 00 	movabs $0xffff800000113540,%rdx
ffff800000103185:	80 ff ff 
ffff800000103188:	48 98                	cltq   
ffff80000010318a:	48 c1 e0 04          	shl    $0x4,%rax
ffff80000010318e:	48 01 d0             	add    %rdx,%rax
ffff800000103191:	48 83 c0 08          	add    $0x8,%rax
ffff800000103195:	48 8b 00             	mov    (%rax),%rax
ffff800000103198:	48 85 c0             	test   %rax,%rax
ffff80000010319b:	75 0a                	jne    ffff8000001031a7 <writei+0x85>
      return -1;
ffff80000010319d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
ffff8000001031a2:	e9 8d 01 00 00       	jmpq   ffff800000103334 <writei+0x212>
    return devsw[ip->major].write(ip, off, src, n);
ffff8000001031a7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
ffff8000001031ab:	0f b7 80 96 00 00 00 	movzwl 0x96(%rax),%eax
ffff8000001031b2:	98                   	cwtl   
ffff8000001031b3:	48 ba 40 35 11 00 00 	movabs $0xffff800000113540,%rdx
ffff8000001031ba:	80 ff ff 
ffff8000001031bd:	48 98                	cltq   
ffff8000001031bf:	48 c1 e0 04          	shl    $0x4,%rax
ffff8000001031c3:	48 01 d0             	add    %rdx,%rax
ffff8000001031c6:	48 83 c0 08          	add    $0x8,%rax
ffff8000001031ca:	4c 8b 00             	mov    (%rax),%r8
ffff8000001031cd:	8b 4d c8             	mov    -0x38(%rbp),%ecx
ffff8000001031d0:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
ffff8000001031d4:	8b 75 cc             	mov    -0x34(%rbp),%esi
ffff8000001031d7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
ffff8000001031db:	48 89 c7             	mov    %rax,%rdi
ffff8000001031de:	41 ff d0             	callq  *%r8
ffff8000001031e1:	e9 4e 01 00 00       	jmpq   ffff800000103334 <writei+0x212>
  }

  if(off > ip->size || off + n < off)
ffff8000001031e6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
ffff8000001031ea:	8b 80 9c 00 00 00    	mov    0x9c(%rax),%eax
ffff8000001031f0:	39 45 cc             	cmp    %eax,-0x34(%rbp)
ffff8000001031f3:	77 0d                	ja     ffff800000103202 <writei+0xe0>
ffff8000001031f5:	8b 55 cc             	mov    -0x34(%rbp),%edx
ffff8000001031f8:	8b 45 c8             	mov    -0x38(%rbp),%eax
ffff8000001031fb:	01 d0                	add    %edx,%eax
ffff8000001031fd:	39 45 cc             	cmp    %eax,-0x34(%rbp)
ffff800000103200:	76 0a                	jbe    ffff80000010320c <writei+0xea>
    return -1;
ffff800000103202:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
ffff800000103207:	e9 28 01 00 00       	jmpq   ffff800000103334 <writei+0x212>
  if(off + n > MAXFILE*BSIZE)
ffff80000010320c:	8b 55 cc             	mov    -0x34(%rbp),%edx
ffff80000010320f:	8b 45 c8             	mov    -0x38(%rbp),%eax
ffff800000103212:	01 d0                	add    %edx,%eax
ffff800000103214:	3d 00 18 01 00       	cmp    $0x11800,%eax
ffff800000103219:	76 0a                	jbe    ffff800000103225 <writei+0x103>
    return -1;
ffff80000010321b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
ffff800000103220:	e9 0f 01 00 00       	jmpq   ffff800000103334 <writei+0x212>

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
ffff800000103225:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
ffff80000010322c:	e9 bf 00 00 00       	jmpq   ffff8000001032f0 <writei+0x1ce>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
ffff800000103231:	8b 45 cc             	mov    -0x34(%rbp),%eax
ffff800000103234:	c1 e8 09             	shr    $0x9,%eax
ffff800000103237:	89 c2                	mov    %eax,%edx
ffff800000103239:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
ffff80000010323d:	89 d6                	mov    %edx,%esi
ffff80000010323f:	48 89 c7             	mov    %rax,%rdi
ffff800000103242:	48 b8 11 2c 10 00 00 	movabs $0xffff800000102c11,%rax
ffff800000103249:	80 ff ff 
ffff80000010324c:	ff d0                	callq  *%rax
ffff80000010324e:	89 c2                	mov    %eax,%edx
ffff800000103250:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
ffff800000103254:	8b 00                	mov    (%rax),%eax
ffff800000103256:	89 d6                	mov    %edx,%esi
ffff800000103258:	89 c7                	mov    %eax,%edi
ffff80000010325a:	48 b8 be 03 10 00 00 	movabs $0xffff8000001003be,%rax
ffff800000103261:	80 ff ff 
ffff800000103264:	ff d0                	callq  *%rax
ffff800000103266:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
    m = min(n - tot, BSIZE - off%BSIZE);
ffff80000010326a:	8b 45 cc             	mov    -0x34(%rbp),%eax
ffff80000010326d:	25 ff 01 00 00       	and    $0x1ff,%eax
ffff800000103272:	ba 00 02 00 00       	mov    $0x200,%edx
ffff800000103277:	29 c2                	sub    %eax,%edx
ffff800000103279:	8b 45 c8             	mov    -0x38(%rbp),%eax
ffff80000010327c:	2b 45 fc             	sub    -0x4(%rbp),%eax
ffff80000010327f:	39 c2                	cmp    %eax,%edx
ffff800000103281:	0f 46 c2             	cmovbe %edx,%eax
ffff800000103284:	89 45 ec             	mov    %eax,-0x14(%rbp)
    memmove(bp->data + off%BSIZE, src, m);
ffff800000103287:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff80000010328b:	48 8d 90 b0 00 00 00 	lea    0xb0(%rax),%rdx
ffff800000103292:	8b 45 cc             	mov    -0x34(%rbp),%eax
ffff800000103295:	25 ff 01 00 00       	and    $0x1ff,%eax
ffff80000010329a:	48 8d 0c 02          	lea    (%rdx,%rax,1),%rcx
ffff80000010329e:	8b 55 ec             	mov    -0x14(%rbp),%edx
ffff8000001032a1:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
ffff8000001032a5:	48 89 c6             	mov    %rax,%rsi
ffff8000001032a8:	48 89 cf             	mov    %rcx,%rdi
ffff8000001032ab:	48 b8 ca 83 10 00 00 	movabs $0xffff8000001083ca,%rax
ffff8000001032b2:	80 ff ff 
ffff8000001032b5:	ff d0                	callq  *%rax
    log_write(bp);
ffff8000001032b7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff8000001032bb:	48 89 c7             	mov    %rax,%rdi
ffff8000001032be:	48 b8 ef 52 10 00 00 	movabs $0xffff8000001052ef,%rax
ffff8000001032c5:	80 ff ff 
ffff8000001032c8:	ff d0                	callq  *%rax
    brelse(bp);
ffff8000001032ca:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff8000001032ce:	48 89 c7             	mov    %rax,%rdi
ffff8000001032d1:	48 b8 78 04 10 00 00 	movabs $0xffff800000100478,%rax
ffff8000001032d8:	80 ff ff 
ffff8000001032db:	ff d0                	callq  *%rax
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
ffff8000001032dd:	8b 45 ec             	mov    -0x14(%rbp),%eax
ffff8000001032e0:	01 45 fc             	add    %eax,-0x4(%rbp)
ffff8000001032e3:	8b 45 ec             	mov    -0x14(%rbp),%eax
ffff8000001032e6:	01 45 cc             	add    %eax,-0x34(%rbp)
ffff8000001032e9:	8b 45 ec             	mov    -0x14(%rbp),%eax
ffff8000001032ec:	48 01 45 d0          	add    %rax,-0x30(%rbp)
ffff8000001032f0:	8b 45 fc             	mov    -0x4(%rbp),%eax
ffff8000001032f3:	3b 45 c8             	cmp    -0x38(%rbp),%eax
ffff8000001032f6:	0f 82 35 ff ff ff    	jb     ffff800000103231 <writei+0x10f>
  }

  if(n > 0 && off > ip->size){
ffff8000001032fc:	83 7d c8 00          	cmpl   $0x0,-0x38(%rbp)
ffff800000103300:	74 2f                	je     ffff800000103331 <writei+0x20f>
ffff800000103302:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
ffff800000103306:	8b 80 9c 00 00 00    	mov    0x9c(%rax),%eax
ffff80000010330c:	39 45 cc             	cmp    %eax,-0x34(%rbp)
ffff80000010330f:	76 20                	jbe    ffff800000103331 <writei+0x20f>
    ip->size = off;
ffff800000103311:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
ffff800000103315:	8b 55 cc             	mov    -0x34(%rbp),%edx
ffff800000103318:	89 90 9c 00 00 00    	mov    %edx,0x9c(%rax)
    iupdate(ip);
ffff80000010331e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
ffff800000103322:	48 89 c7             	mov    %rax,%rdi
ffff800000103325:	48 b8 4a 26 10 00 00 	movabs $0xffff80000010264a,%rax
ffff80000010332c:	80 ff ff 
ffff80000010332f:	ff d0                	callq  *%rax
  }
  return n;
ffff800000103331:	8b 45 c8             	mov    -0x38(%rbp),%eax
}
ffff800000103334:	c9                   	leaveq 
ffff800000103335:	c3                   	retq   

ffff800000103336 <namecmp>:
//PAGEBREAK!
// Directories

int
namecmp(const char *s, const char *t)
{
ffff800000103336:	f3 0f 1e fa          	endbr64 
ffff80000010333a:	55                   	push   %rbp
ffff80000010333b:	48 89 e5             	mov    %rsp,%rbp
ffff80000010333e:	48 83 ec 10          	sub    $0x10,%rsp
ffff800000103342:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
ffff800000103346:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  return strncmp(s, t, DIRSIZ);
ffff80000010334a:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
ffff80000010334e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000103352:	ba 0e 00 00 00       	mov    $0xe,%edx
ffff800000103357:	48 89 ce             	mov    %rcx,%rsi
ffff80000010335a:	48 89 c7             	mov    %rax,%rdi
ffff80000010335d:	48 b8 a7 84 10 00 00 	movabs $0xffff8000001084a7,%rax
ffff800000103364:	80 ff ff 
ffff800000103367:	ff d0                	callq  *%rax
}
ffff800000103369:	c9                   	leaveq 
ffff80000010336a:	c3                   	retq   

ffff80000010336b <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
ffff80000010336b:	f3 0f 1e fa          	endbr64 
ffff80000010336f:	55                   	push   %rbp
ffff800000103370:	48 89 e5             	mov    %rsp,%rbp
ffff800000103373:	48 83 ec 40          	sub    $0x40,%rsp
ffff800000103377:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
ffff80000010337b:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
ffff80000010337f:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
ffff800000103383:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
ffff800000103387:	0f b7 80 94 00 00 00 	movzwl 0x94(%rax),%eax
ffff80000010338e:	66 83 f8 01          	cmp    $0x1,%ax
ffff800000103392:	74 16                	je     ffff8000001033aa <dirlookup+0x3f>
    panic("dirlookup not DIR");
ffff800000103394:	48 bf e5 c8 10 00 00 	movabs $0xffff80000010c8e5,%rdi
ffff80000010339b:	80 ff ff 
ffff80000010339e:	48 b8 f9 0b 10 00 00 	movabs $0xffff800000100bf9,%rax
ffff8000001033a5:	80 ff ff 
ffff8000001033a8:	ff d0                	callq  *%rax

  for(off = 0; off < dp->size; off += sizeof(de)){
ffff8000001033aa:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
ffff8000001033b1:	e9 9f 00 00 00       	jmpq   ffff800000103455 <dirlookup+0xea>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
ffff8000001033b6:	8b 55 fc             	mov    -0x4(%rbp),%edx
ffff8000001033b9:	48 8d 75 e0          	lea    -0x20(%rbp),%rsi
ffff8000001033bd:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
ffff8000001033c1:	b9 10 00 00 00       	mov    $0x10,%ecx
ffff8000001033c6:	48 89 c7             	mov    %rax,%rdi
ffff8000001033c9:	48 b8 51 2f 10 00 00 	movabs $0xffff800000102f51,%rax
ffff8000001033d0:	80 ff ff 
ffff8000001033d3:	ff d0                	callq  *%rax
ffff8000001033d5:	83 f8 10             	cmp    $0x10,%eax
ffff8000001033d8:	74 16                	je     ffff8000001033f0 <dirlookup+0x85>
      panic("dirlookup read");
ffff8000001033da:	48 bf f7 c8 10 00 00 	movabs $0xffff80000010c8f7,%rdi
ffff8000001033e1:	80 ff ff 
ffff8000001033e4:	48 b8 f9 0b 10 00 00 	movabs $0xffff800000100bf9,%rax
ffff8000001033eb:	80 ff ff 
ffff8000001033ee:	ff d0                	callq  *%rax
    if(de.inum == 0)
ffff8000001033f0:	0f b7 45 e0          	movzwl -0x20(%rbp),%eax
ffff8000001033f4:	66 85 c0             	test   %ax,%ax
ffff8000001033f7:	74 57                	je     ffff800000103450 <dirlookup+0xe5>
      continue;
    if(namecmp(name, de.name) == 0){
ffff8000001033f9:	48 8d 45 e0          	lea    -0x20(%rbp),%rax
ffff8000001033fd:	48 8d 50 02          	lea    0x2(%rax),%rdx
ffff800000103401:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
ffff800000103405:	48 89 d6             	mov    %rdx,%rsi
ffff800000103408:	48 89 c7             	mov    %rax,%rdi
ffff80000010340b:	48 b8 36 33 10 00 00 	movabs $0xffff800000103336,%rax
ffff800000103412:	80 ff ff 
ffff800000103415:	ff d0                	callq  *%rax
ffff800000103417:	85 c0                	test   %eax,%eax
ffff800000103419:	75 36                	jne    ffff800000103451 <dirlookup+0xe6>
      // entry matches path element
      if(poff)
ffff80000010341b:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
ffff800000103420:	74 09                	je     ffff80000010342b <dirlookup+0xc0>
        *poff = off;
ffff800000103422:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
ffff800000103426:	8b 55 fc             	mov    -0x4(%rbp),%edx
ffff800000103429:	89 10                	mov    %edx,(%rax)
      inum = de.inum;
ffff80000010342b:	0f b7 45 e0          	movzwl -0x20(%rbp),%eax
ffff80000010342f:	0f b7 c0             	movzwl %ax,%eax
ffff800000103432:	89 45 f8             	mov    %eax,-0x8(%rbp)
      return iget(dp->dev, inum);
ffff800000103435:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
ffff800000103439:	8b 00                	mov    (%rax),%eax
ffff80000010343b:	8b 55 f8             	mov    -0x8(%rbp),%edx
ffff80000010343e:	89 d6                	mov    %edx,%esi
ffff800000103440:	89 c7                	mov    %eax,%edi
ffff800000103442:	48 b8 60 27 10 00 00 	movabs $0xffff800000102760,%rax
ffff800000103449:	80 ff ff 
ffff80000010344c:	ff d0                	callq  *%rax
ffff80000010344e:	eb 1d                	jmp    ffff80000010346d <dirlookup+0x102>
      continue;
ffff800000103450:	90                   	nop
  for(off = 0; off < dp->size; off += sizeof(de)){
ffff800000103451:	83 45 fc 10          	addl   $0x10,-0x4(%rbp)
ffff800000103455:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
ffff800000103459:	8b 80 9c 00 00 00    	mov    0x9c(%rax),%eax
ffff80000010345f:	39 45 fc             	cmp    %eax,-0x4(%rbp)
ffff800000103462:	0f 82 4e ff ff ff    	jb     ffff8000001033b6 <dirlookup+0x4b>
    }
  }

  return 0;
ffff800000103468:	b8 00 00 00 00       	mov    $0x0,%eax
}
ffff80000010346d:	c9                   	leaveq 
ffff80000010346e:	c3                   	retq   

ffff80000010346f <dirlink>:

// Write a new directory entry (name, inum) into the directory dp.
int
dirlink(struct inode *dp, char *name, uint inum)
{
ffff80000010346f:	f3 0f 1e fa          	endbr64 
ffff800000103473:	55                   	push   %rbp
ffff800000103474:	48 89 e5             	mov    %rsp,%rbp
ffff800000103477:	48 83 ec 40          	sub    $0x40,%rsp
ffff80000010347b:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
ffff80000010347f:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
ffff800000103483:	89 55 cc             	mov    %edx,-0x34(%rbp)
  int off;
  struct dirent de;
  struct inode *ip;

  // Check that name is not present.
  if((ip = dirlookup(dp, name, 0)) != 0){
ffff800000103486:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
ffff80000010348a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
ffff80000010348e:	ba 00 00 00 00       	mov    $0x0,%edx
ffff800000103493:	48 89 ce             	mov    %rcx,%rsi
ffff800000103496:	48 89 c7             	mov    %rax,%rdi
ffff800000103499:	48 b8 6b 33 10 00 00 	movabs $0xffff80000010336b,%rax
ffff8000001034a0:	80 ff ff 
ffff8000001034a3:	ff d0                	callq  *%rax
ffff8000001034a5:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
ffff8000001034a9:	48 83 7d f0 00       	cmpq   $0x0,-0x10(%rbp)
ffff8000001034ae:	74 1d                	je     ffff8000001034cd <dirlink+0x5e>
    iput(ip);
ffff8000001034b0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff8000001034b4:	48 89 c7             	mov    %rax,%rdi
ffff8000001034b7:	48 b8 ea 2a 10 00 00 	movabs $0xffff800000102aea,%rax
ffff8000001034be:	80 ff ff 
ffff8000001034c1:	ff d0                	callq  *%rax
    return -1;
ffff8000001034c3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
ffff8000001034c8:	e9 d2 00 00 00       	jmpq   ffff80000010359f <dirlink+0x130>
  }

  // Look for an empty dirent.
  for(off = 0; off < dp->size; off += sizeof(de)){
ffff8000001034cd:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
ffff8000001034d4:	eb 4c                	jmp    ffff800000103522 <dirlink+0xb3>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
ffff8000001034d6:	8b 55 fc             	mov    -0x4(%rbp),%edx
ffff8000001034d9:	48 8d 75 e0          	lea    -0x20(%rbp),%rsi
ffff8000001034dd:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
ffff8000001034e1:	b9 10 00 00 00       	mov    $0x10,%ecx
ffff8000001034e6:	48 89 c7             	mov    %rax,%rdi
ffff8000001034e9:	48 b8 51 2f 10 00 00 	movabs $0xffff800000102f51,%rax
ffff8000001034f0:	80 ff ff 
ffff8000001034f3:	ff d0                	callq  *%rax
ffff8000001034f5:	83 f8 10             	cmp    $0x10,%eax
ffff8000001034f8:	74 16                	je     ffff800000103510 <dirlink+0xa1>
      panic("dirlink read");
ffff8000001034fa:	48 bf 06 c9 10 00 00 	movabs $0xffff80000010c906,%rdi
ffff800000103501:	80 ff ff 
ffff800000103504:	48 b8 f9 0b 10 00 00 	movabs $0xffff800000100bf9,%rax
ffff80000010350b:	80 ff ff 
ffff80000010350e:	ff d0                	callq  *%rax
    if(de.inum == 0)
ffff800000103510:	0f b7 45 e0          	movzwl -0x20(%rbp),%eax
ffff800000103514:	66 85 c0             	test   %ax,%ax
ffff800000103517:	74 1c                	je     ffff800000103535 <dirlink+0xc6>
  for(off = 0; off < dp->size; off += sizeof(de)){
ffff800000103519:	8b 45 fc             	mov    -0x4(%rbp),%eax
ffff80000010351c:	83 c0 10             	add    $0x10,%eax
ffff80000010351f:	89 45 fc             	mov    %eax,-0x4(%rbp)
ffff800000103522:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
ffff800000103526:	8b 90 9c 00 00 00    	mov    0x9c(%rax),%edx
ffff80000010352c:	8b 45 fc             	mov    -0x4(%rbp),%eax
ffff80000010352f:	39 c2                	cmp    %eax,%edx
ffff800000103531:	77 a3                	ja     ffff8000001034d6 <dirlink+0x67>
ffff800000103533:	eb 01                	jmp    ffff800000103536 <dirlink+0xc7>
      break;
ffff800000103535:	90                   	nop
  }

  strncpy(de.name, name, DIRSIZ);
ffff800000103536:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
ffff80000010353a:	48 8d 55 e0          	lea    -0x20(%rbp),%rdx
ffff80000010353e:	48 8d 4a 02          	lea    0x2(%rdx),%rcx
ffff800000103542:	ba 0e 00 00 00       	mov    $0xe,%edx
ffff800000103547:	48 89 c6             	mov    %rax,%rsi
ffff80000010354a:	48 89 cf             	mov    %rcx,%rdi
ffff80000010354d:	48 b8 18 85 10 00 00 	movabs $0xffff800000108518,%rax
ffff800000103554:	80 ff ff 
ffff800000103557:	ff d0                	callq  *%rax
  de.inum = inum;
ffff800000103559:	8b 45 cc             	mov    -0x34(%rbp),%eax
ffff80000010355c:	66 89 45 e0          	mov    %ax,-0x20(%rbp)
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
ffff800000103560:	8b 55 fc             	mov    -0x4(%rbp),%edx
ffff800000103563:	48 8d 75 e0          	lea    -0x20(%rbp),%rsi
ffff800000103567:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
ffff80000010356b:	b9 10 00 00 00       	mov    $0x10,%ecx
ffff800000103570:	48 89 c7             	mov    %rax,%rdi
ffff800000103573:	48 b8 22 31 10 00 00 	movabs $0xffff800000103122,%rax
ffff80000010357a:	80 ff ff 
ffff80000010357d:	ff d0                	callq  *%rax
ffff80000010357f:	83 f8 10             	cmp    $0x10,%eax
ffff800000103582:	74 16                	je     ffff80000010359a <dirlink+0x12b>
    panic("dirlink");
ffff800000103584:	48 bf 13 c9 10 00 00 	movabs $0xffff80000010c913,%rdi
ffff80000010358b:	80 ff ff 
ffff80000010358e:	48 b8 f9 0b 10 00 00 	movabs $0xffff800000100bf9,%rax
ffff800000103595:	80 ff ff 
ffff800000103598:	ff d0                	callq  *%rax

  return 0;
ffff80000010359a:	b8 00 00 00 00       	mov    $0x0,%eax
}
ffff80000010359f:	c9                   	leaveq 
ffff8000001035a0:	c3                   	retq   

ffff8000001035a1 <skipelem>:
//   skipelem("a", name) = "", setting name = "a"
//   skipelem("", name) = skipelem("////", name) = 0
//
static char*
skipelem(char *path, char *name)
{
ffff8000001035a1:	f3 0f 1e fa          	endbr64 
ffff8000001035a5:	55                   	push   %rbp
ffff8000001035a6:	48 89 e5             	mov    %rsp,%rbp
ffff8000001035a9:	48 83 ec 20          	sub    $0x20,%rsp
ffff8000001035ad:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
ffff8000001035b1:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  char *s;
  int len;

  while(*path == '/')
ffff8000001035b5:	eb 05                	jmp    ffff8000001035bc <skipelem+0x1b>
    path++;
ffff8000001035b7:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  while(*path == '/')
ffff8000001035bc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff8000001035c0:	0f b6 00             	movzbl (%rax),%eax
ffff8000001035c3:	3c 2f                	cmp    $0x2f,%al
ffff8000001035c5:	74 f0                	je     ffff8000001035b7 <skipelem+0x16>
  if(*path == 0)
ffff8000001035c7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff8000001035cb:	0f b6 00             	movzbl (%rax),%eax
ffff8000001035ce:	84 c0                	test   %al,%al
ffff8000001035d0:	75 0a                	jne    ffff8000001035dc <skipelem+0x3b>
    return 0;
ffff8000001035d2:	b8 00 00 00 00       	mov    $0x0,%eax
ffff8000001035d7:	e9 9a 00 00 00       	jmpq   ffff800000103676 <skipelem+0xd5>
  s = path;
ffff8000001035dc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff8000001035e0:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  while(*path != '/' && *path != 0)
ffff8000001035e4:	eb 05                	jmp    ffff8000001035eb <skipelem+0x4a>
    path++;
ffff8000001035e6:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  while(*path != '/' && *path != 0)
ffff8000001035eb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff8000001035ef:	0f b6 00             	movzbl (%rax),%eax
ffff8000001035f2:	3c 2f                	cmp    $0x2f,%al
ffff8000001035f4:	74 0b                	je     ffff800000103601 <skipelem+0x60>
ffff8000001035f6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff8000001035fa:	0f b6 00             	movzbl (%rax),%eax
ffff8000001035fd:	84 c0                	test   %al,%al
ffff8000001035ff:	75 e5                	jne    ffff8000001035e6 <skipelem+0x45>
  len = path - s;
ffff800000103601:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000103605:	48 2b 45 f8          	sub    -0x8(%rbp),%rax
ffff800000103609:	89 45 f4             	mov    %eax,-0xc(%rbp)
  if(len >= DIRSIZ)
ffff80000010360c:	83 7d f4 0d          	cmpl   $0xd,-0xc(%rbp)
ffff800000103610:	7e 21                	jle    ffff800000103633 <skipelem+0x92>
    memmove(name, s, DIRSIZ);
ffff800000103612:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
ffff800000103616:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
ffff80000010361a:	ba 0e 00 00 00       	mov    $0xe,%edx
ffff80000010361f:	48 89 ce             	mov    %rcx,%rsi
ffff800000103622:	48 89 c7             	mov    %rax,%rdi
ffff800000103625:	48 b8 ca 83 10 00 00 	movabs $0xffff8000001083ca,%rax
ffff80000010362c:	80 ff ff 
ffff80000010362f:	ff d0                	callq  *%rax
ffff800000103631:	eb 34                	jmp    ffff800000103667 <skipelem+0xc6>
  else {
    memmove(name, s, len);
ffff800000103633:	8b 55 f4             	mov    -0xc(%rbp),%edx
ffff800000103636:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
ffff80000010363a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
ffff80000010363e:	48 89 ce             	mov    %rcx,%rsi
ffff800000103641:	48 89 c7             	mov    %rax,%rdi
ffff800000103644:	48 b8 ca 83 10 00 00 	movabs $0xffff8000001083ca,%rax
ffff80000010364b:	80 ff ff 
ffff80000010364e:	ff d0                	callq  *%rax
    name[len] = 0;
ffff800000103650:	8b 45 f4             	mov    -0xc(%rbp),%eax
ffff800000103653:	48 63 d0             	movslq %eax,%rdx
ffff800000103656:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
ffff80000010365a:	48 01 d0             	add    %rdx,%rax
ffff80000010365d:	c6 00 00             	movb   $0x0,(%rax)
  }
  while(*path == '/')
ffff800000103660:	eb 05                	jmp    ffff800000103667 <skipelem+0xc6>
    path++;
ffff800000103662:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  while(*path == '/')
ffff800000103667:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff80000010366b:	0f b6 00             	movzbl (%rax),%eax
ffff80000010366e:	3c 2f                	cmp    $0x2f,%al
ffff800000103670:	74 f0                	je     ffff800000103662 <skipelem+0xc1>
  return path;
ffff800000103672:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
ffff800000103676:	c9                   	leaveq 
ffff800000103677:	c3                   	retq   

ffff800000103678 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
ffff800000103678:	f3 0f 1e fa          	endbr64 
ffff80000010367c:	55                   	push   %rbp
ffff80000010367d:	48 89 e5             	mov    %rsp,%rbp
ffff800000103680:	48 83 ec 30          	sub    $0x30,%rsp
ffff800000103684:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
ffff800000103688:	89 75 e4             	mov    %esi,-0x1c(%rbp)
ffff80000010368b:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  struct inode *ip, *next;

  if(*path == '/')
ffff80000010368f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000103693:	0f b6 00             	movzbl (%rax),%eax
ffff800000103696:	3c 2f                	cmp    $0x2f,%al
ffff800000103698:	75 1f                	jne    ffff8000001036b9 <namex+0x41>
    ip = iget(ROOTDEV, ROOTINO);
ffff80000010369a:	be 01 00 00 00       	mov    $0x1,%esi
ffff80000010369f:	bf 01 00 00 00       	mov    $0x1,%edi
ffff8000001036a4:	48 b8 60 27 10 00 00 	movabs $0xffff800000102760,%rax
ffff8000001036ab:	80 ff ff 
ffff8000001036ae:	ff d0                	callq  *%rax
ffff8000001036b0:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
ffff8000001036b4:	e9 f7 00 00 00       	jmpq   ffff8000001037b0 <namex+0x138>
  else
    ip = idup(proc->cwd);
ffff8000001036b9:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffff8000001036c0:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffff8000001036c4:	48 8b 80 c8 00 00 00 	mov    0xc8(%rax),%rax
ffff8000001036cb:	48 89 c7             	mov    %rax,%rdi
ffff8000001036ce:	48 b8 95 28 10 00 00 	movabs $0xffff800000102895,%rax
ffff8000001036d5:	80 ff ff 
ffff8000001036d8:	ff d0                	callq  *%rax
ffff8000001036da:	48 89 45 f8          	mov    %rax,-0x8(%rbp)

  while((path = skipelem(path, name)) != 0){
ffff8000001036de:	e9 cd 00 00 00       	jmpq   ffff8000001037b0 <namex+0x138>
    ilock(ip);
ffff8000001036e3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff8000001036e7:	48 89 c7             	mov    %rax,%rdi
ffff8000001036ea:	48 b8 e8 28 10 00 00 	movabs $0xffff8000001028e8,%rax
ffff8000001036f1:	80 ff ff 
ffff8000001036f4:	ff d0                	callq  *%rax
    if(ip->type != T_DIR){
ffff8000001036f6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff8000001036fa:	0f b7 80 94 00 00 00 	movzwl 0x94(%rax),%eax
ffff800000103701:	66 83 f8 01          	cmp    $0x1,%ax
ffff800000103705:	74 1d                	je     ffff800000103724 <namex+0xac>
      iunlockput(ip);
ffff800000103707:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff80000010370b:	48 89 c7             	mov    %rax,%rdi
ffff80000010370e:	48 b8 d8 2b 10 00 00 	movabs $0xffff800000102bd8,%rax
ffff800000103715:	80 ff ff 
ffff800000103718:	ff d0                	callq  *%rax
      return 0;
ffff80000010371a:	b8 00 00 00 00       	mov    $0x0,%eax
ffff80000010371f:	e9 d9 00 00 00       	jmpq   ffff8000001037fd <namex+0x185>
    }
    if(nameiparent && *path == '\0'){
ffff800000103724:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
ffff800000103728:	74 27                	je     ffff800000103751 <namex+0xd9>
ffff80000010372a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff80000010372e:	0f b6 00             	movzbl (%rax),%eax
ffff800000103731:	84 c0                	test   %al,%al
ffff800000103733:	75 1c                	jne    ffff800000103751 <namex+0xd9>
      iunlock(ip);  // Stop one level early.
ffff800000103735:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000103739:	48 89 c7             	mov    %rax,%rdi
ffff80000010373c:	48 b8 7d 2a 10 00 00 	movabs $0xffff800000102a7d,%rax
ffff800000103743:	80 ff ff 
ffff800000103746:	ff d0                	callq  *%rax
      return ip;
ffff800000103748:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff80000010374c:	e9 ac 00 00 00       	jmpq   ffff8000001037fd <namex+0x185>
    }
    if((next = dirlookup(ip, name, 0)) == 0){
ffff800000103751:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
ffff800000103755:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000103759:	ba 00 00 00 00       	mov    $0x0,%edx
ffff80000010375e:	48 89 ce             	mov    %rcx,%rsi
ffff800000103761:	48 89 c7             	mov    %rax,%rdi
ffff800000103764:	48 b8 6b 33 10 00 00 	movabs $0xffff80000010336b,%rax
ffff80000010376b:	80 ff ff 
ffff80000010376e:	ff d0                	callq  *%rax
ffff800000103770:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
ffff800000103774:	48 83 7d f0 00       	cmpq   $0x0,-0x10(%rbp)
ffff800000103779:	75 1a                	jne    ffff800000103795 <namex+0x11d>
      iunlockput(ip);
ffff80000010377b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff80000010377f:	48 89 c7             	mov    %rax,%rdi
ffff800000103782:	48 b8 d8 2b 10 00 00 	movabs $0xffff800000102bd8,%rax
ffff800000103789:	80 ff ff 
ffff80000010378c:	ff d0                	callq  *%rax
      return 0;
ffff80000010378e:	b8 00 00 00 00       	mov    $0x0,%eax
ffff800000103793:	eb 68                	jmp    ffff8000001037fd <namex+0x185>
    }
    iunlockput(ip);
ffff800000103795:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000103799:	48 89 c7             	mov    %rax,%rdi
ffff80000010379c:	48 b8 d8 2b 10 00 00 	movabs $0xffff800000102bd8,%rax
ffff8000001037a3:	80 ff ff 
ffff8000001037a6:	ff d0                	callq  *%rax
    ip = next;
ffff8000001037a8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff8000001037ac:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  while((path = skipelem(path, name)) != 0){
ffff8000001037b0:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
ffff8000001037b4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff8000001037b8:	48 89 d6             	mov    %rdx,%rsi
ffff8000001037bb:	48 89 c7             	mov    %rax,%rdi
ffff8000001037be:	48 b8 a1 35 10 00 00 	movabs $0xffff8000001035a1,%rax
ffff8000001037c5:	80 ff ff 
ffff8000001037c8:	ff d0                	callq  *%rax
ffff8000001037ca:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
ffff8000001037ce:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
ffff8000001037d3:	0f 85 0a ff ff ff    	jne    ffff8000001036e3 <namex+0x6b>
  }
  if(nameiparent){
ffff8000001037d9:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
ffff8000001037dd:	74 1a                	je     ffff8000001037f9 <namex+0x181>
    iput(ip);
ffff8000001037df:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff8000001037e3:	48 89 c7             	mov    %rax,%rdi
ffff8000001037e6:	48 b8 ea 2a 10 00 00 	movabs $0xffff800000102aea,%rax
ffff8000001037ed:	80 ff ff 
ffff8000001037f0:	ff d0                	callq  *%rax
    return 0;
ffff8000001037f2:	b8 00 00 00 00       	mov    $0x0,%eax
ffff8000001037f7:	eb 04                	jmp    ffff8000001037fd <namex+0x185>
  }
  return ip;
ffff8000001037f9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
ffff8000001037fd:	c9                   	leaveq 
ffff8000001037fe:	c3                   	retq   

ffff8000001037ff <namei>:

struct inode*
namei(char *path)
{
ffff8000001037ff:	f3 0f 1e fa          	endbr64 
ffff800000103803:	55                   	push   %rbp
ffff800000103804:	48 89 e5             	mov    %rsp,%rbp
ffff800000103807:	48 83 ec 20          	sub    $0x20,%rsp
ffff80000010380b:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  char name[DIRSIZ];
  return namex(path, 0, name);
ffff80000010380f:	48 8d 55 f2          	lea    -0xe(%rbp),%rdx
ffff800000103813:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000103817:	be 00 00 00 00       	mov    $0x0,%esi
ffff80000010381c:	48 89 c7             	mov    %rax,%rdi
ffff80000010381f:	48 b8 78 36 10 00 00 	movabs $0xffff800000103678,%rax
ffff800000103826:	80 ff ff 
ffff800000103829:	ff d0                	callq  *%rax
}
ffff80000010382b:	c9                   	leaveq 
ffff80000010382c:	c3                   	retq   

ffff80000010382d <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
ffff80000010382d:	f3 0f 1e fa          	endbr64 
ffff800000103831:	55                   	push   %rbp
ffff800000103832:	48 89 e5             	mov    %rsp,%rbp
ffff800000103835:	48 83 ec 10          	sub    $0x10,%rsp
ffff800000103839:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
ffff80000010383d:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  return namex(path, 1, name);
ffff800000103841:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
ffff800000103845:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000103849:	be 01 00 00 00       	mov    $0x1,%esi
ffff80000010384e:	48 89 c7             	mov    %rax,%rdi
ffff800000103851:	48 b8 78 36 10 00 00 	movabs $0xffff800000103678,%rax
ffff800000103858:	80 ff ff 
ffff80000010385b:	ff d0                	callq  *%rax
}
ffff80000010385d:	c9                   	leaveq 
ffff80000010385e:	c3                   	retq   

ffff80000010385f <inb>:
{
ffff80000010385f:	f3 0f 1e fa          	endbr64 
ffff800000103863:	55                   	push   %rbp
ffff800000103864:	48 89 e5             	mov    %rsp,%rbp
ffff800000103867:	48 83 ec 18          	sub    $0x18,%rsp
ffff80000010386b:	89 f8                	mov    %edi,%eax
ffff80000010386d:	66 89 45 ec          	mov    %ax,-0x14(%rbp)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
ffff800000103871:	0f b7 45 ec          	movzwl -0x14(%rbp),%eax
ffff800000103875:	89 c2                	mov    %eax,%edx
ffff800000103877:	ec                   	in     (%dx),%al
ffff800000103878:	88 45 ff             	mov    %al,-0x1(%rbp)
  return data;
ffff80000010387b:	0f b6 45 ff          	movzbl -0x1(%rbp),%eax
}
ffff80000010387f:	c9                   	leaveq 
ffff800000103880:	c3                   	retq   

ffff800000103881 <insl>:
{
ffff800000103881:	f3 0f 1e fa          	endbr64 
ffff800000103885:	55                   	push   %rbp
ffff800000103886:	48 89 e5             	mov    %rsp,%rbp
ffff800000103889:	48 83 ec 10          	sub    $0x10,%rsp
ffff80000010388d:	89 7d fc             	mov    %edi,-0x4(%rbp)
ffff800000103890:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
ffff800000103894:	89 55 f8             	mov    %edx,-0x8(%rbp)
  asm volatile("cld; rep insl" :
ffff800000103897:	8b 55 fc             	mov    -0x4(%rbp),%edx
ffff80000010389a:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
ffff80000010389e:	8b 45 f8             	mov    -0x8(%rbp),%eax
ffff8000001038a1:	48 89 ce             	mov    %rcx,%rsi
ffff8000001038a4:	48 89 f7             	mov    %rsi,%rdi
ffff8000001038a7:	89 c1                	mov    %eax,%ecx
ffff8000001038a9:	fc                   	cld    
ffff8000001038aa:	f3 6d                	rep insl (%dx),%es:(%rdi)
ffff8000001038ac:	89 c8                	mov    %ecx,%eax
ffff8000001038ae:	48 89 fe             	mov    %rdi,%rsi
ffff8000001038b1:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
ffff8000001038b5:	89 45 f8             	mov    %eax,-0x8(%rbp)
}
ffff8000001038b8:	90                   	nop
ffff8000001038b9:	c9                   	leaveq 
ffff8000001038ba:	c3                   	retq   

ffff8000001038bb <outb>:
{
ffff8000001038bb:	f3 0f 1e fa          	endbr64 
ffff8000001038bf:	55                   	push   %rbp
ffff8000001038c0:	48 89 e5             	mov    %rsp,%rbp
ffff8000001038c3:	48 83 ec 08          	sub    $0x8,%rsp
ffff8000001038c7:	89 f8                	mov    %edi,%eax
ffff8000001038c9:	89 f2                	mov    %esi,%edx
ffff8000001038cb:	66 89 45 fc          	mov    %ax,-0x4(%rbp)
ffff8000001038cf:	89 d0                	mov    %edx,%eax
ffff8000001038d1:	88 45 f8             	mov    %al,-0x8(%rbp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
ffff8000001038d4:	0f b6 45 f8          	movzbl -0x8(%rbp),%eax
ffff8000001038d8:	0f b7 55 fc          	movzwl -0x4(%rbp),%edx
ffff8000001038dc:	ee                   	out    %al,(%dx)
}
ffff8000001038dd:	90                   	nop
ffff8000001038de:	c9                   	leaveq 
ffff8000001038df:	c3                   	retq   

ffff8000001038e0 <outsl>:
{
ffff8000001038e0:	f3 0f 1e fa          	endbr64 
ffff8000001038e4:	55                   	push   %rbp
ffff8000001038e5:	48 89 e5             	mov    %rsp,%rbp
ffff8000001038e8:	48 83 ec 10          	sub    $0x10,%rsp
ffff8000001038ec:	89 7d fc             	mov    %edi,-0x4(%rbp)
ffff8000001038ef:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
ffff8000001038f3:	89 55 f8             	mov    %edx,-0x8(%rbp)
  asm volatile("cld; rep outsl" :
ffff8000001038f6:	8b 55 fc             	mov    -0x4(%rbp),%edx
ffff8000001038f9:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
ffff8000001038fd:	8b 45 f8             	mov    -0x8(%rbp),%eax
ffff800000103900:	48 89 ce             	mov    %rcx,%rsi
ffff800000103903:	89 c1                	mov    %eax,%ecx
ffff800000103905:	fc                   	cld    
ffff800000103906:	f3 6f                	rep outsl %ds:(%rsi),(%dx)
ffff800000103908:	89 c8                	mov    %ecx,%eax
ffff80000010390a:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
ffff80000010390e:	89 45 f8             	mov    %eax,-0x8(%rbp)
}
ffff800000103911:	90                   	nop
ffff800000103912:	c9                   	leaveq 
ffff800000103913:	c3                   	retq   

ffff800000103914 <idewait>:
static void idestart(struct buf*);

// Wait for IDE disk to become ready.
static int
idewait(int checkerr)
{
ffff800000103914:	f3 0f 1e fa          	endbr64 
ffff800000103918:	55                   	push   %rbp
ffff800000103919:	48 89 e5             	mov    %rsp,%rbp
ffff80000010391c:	48 83 ec 18          	sub    $0x18,%rsp
ffff800000103920:	89 7d ec             	mov    %edi,-0x14(%rbp)
  int r;

  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
ffff800000103923:	90                   	nop
ffff800000103924:	bf f7 01 00 00       	mov    $0x1f7,%edi
ffff800000103929:	48 b8 5f 38 10 00 00 	movabs $0xffff80000010385f,%rax
ffff800000103930:	80 ff ff 
ffff800000103933:	ff d0                	callq  *%rax
ffff800000103935:	0f b6 c0             	movzbl %al,%eax
ffff800000103938:	89 45 fc             	mov    %eax,-0x4(%rbp)
ffff80000010393b:	8b 45 fc             	mov    -0x4(%rbp),%eax
ffff80000010393e:	25 c0 00 00 00       	and    $0xc0,%eax
ffff800000103943:	83 f8 40             	cmp    $0x40,%eax
ffff800000103946:	75 dc                	jne    ffff800000103924 <idewait+0x10>
    ;
  if(checkerr && (r & (IDE_DF|IDE_ERR)) != 0)
ffff800000103948:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
ffff80000010394c:	74 11                	je     ffff80000010395f <idewait+0x4b>
ffff80000010394e:	8b 45 fc             	mov    -0x4(%rbp),%eax
ffff800000103951:	83 e0 21             	and    $0x21,%eax
ffff800000103954:	85 c0                	test   %eax,%eax
ffff800000103956:	74 07                	je     ffff80000010395f <idewait+0x4b>
    return -1;
ffff800000103958:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
ffff80000010395d:	eb 05                	jmp    ffff800000103964 <idewait+0x50>
  return 0;
ffff80000010395f:	b8 00 00 00 00       	mov    $0x0,%eax
}
ffff800000103964:	c9                   	leaveq 
ffff800000103965:	c3                   	retq   

ffff800000103966 <ideinit>:

void
ideinit(void)
{
ffff800000103966:	f3 0f 1e fa          	endbr64 
ffff80000010396a:	55                   	push   %rbp
ffff80000010396b:	48 89 e5             	mov    %rsp,%rbp
ffff80000010396e:	48 83 ec 10          	sub    $0x10,%rsp
  initlock(&idelock, "ide");
ffff800000103972:	48 be 1b c9 10 00 00 	movabs $0xffff80000010c91b,%rsi
ffff800000103979:	80 ff ff 
ffff80000010397c:	48 bf c0 70 11 00 00 	movabs $0xffff8000001170c0,%rdi
ffff800000103983:	80 ff ff 
ffff800000103986:	48 b8 de 7e 10 00 00 	movabs $0xffff800000107ede,%rax
ffff80000010398d:	80 ff ff 
ffff800000103990:	ff d0                	callq  *%rax
  ioapicenable(IRQ_IDE, ncpu - 1);
ffff800000103992:	48 b8 20 74 11 00 00 	movabs $0xffff800000117420,%rax
ffff800000103999:	80 ff ff 
ffff80000010399c:	8b 00                	mov    (%rax),%eax
ffff80000010399e:	83 e8 01             	sub    $0x1,%eax
ffff8000001039a1:	89 c6                	mov    %eax,%esi
ffff8000001039a3:	bf 0e 00 00 00       	mov    $0xe,%edi
ffff8000001039a8:	48 b8 e5 3f 10 00 00 	movabs $0xffff800000103fe5,%rax
ffff8000001039af:	80 ff ff 
ffff8000001039b2:	ff d0                	callq  *%rax
  idewait(0);
ffff8000001039b4:	bf 00 00 00 00       	mov    $0x0,%edi
ffff8000001039b9:	48 b8 14 39 10 00 00 	movabs $0xffff800000103914,%rax
ffff8000001039c0:	80 ff ff 
ffff8000001039c3:	ff d0                	callq  *%rax

  // Check if disk 1 is present
  outb(0x1f6, 0xe0 | (1<<4));
ffff8000001039c5:	be f0 00 00 00       	mov    $0xf0,%esi
ffff8000001039ca:	bf f6 01 00 00       	mov    $0x1f6,%edi
ffff8000001039cf:	48 b8 bb 38 10 00 00 	movabs $0xffff8000001038bb,%rax
ffff8000001039d6:	80 ff ff 
ffff8000001039d9:	ff d0                	callq  *%rax
  for(int i=0; i<1000; i++){
ffff8000001039db:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
ffff8000001039e2:	eb 2b                	jmp    ffff800000103a0f <ideinit+0xa9>
    if(inb(0x1f7) != 0){
ffff8000001039e4:	bf f7 01 00 00       	mov    $0x1f7,%edi
ffff8000001039e9:	48 b8 5f 38 10 00 00 	movabs $0xffff80000010385f,%rax
ffff8000001039f0:	80 ff ff 
ffff8000001039f3:	ff d0                	callq  *%rax
ffff8000001039f5:	84 c0                	test   %al,%al
ffff8000001039f7:	74 12                	je     ffff800000103a0b <ideinit+0xa5>
      havedisk1 = 1;
ffff8000001039f9:	48 b8 30 71 11 00 00 	movabs $0xffff800000117130,%rax
ffff800000103a00:	80 ff ff 
ffff800000103a03:	c7 00 01 00 00 00    	movl   $0x1,(%rax)
      break;
ffff800000103a09:	eb 0d                	jmp    ffff800000103a18 <ideinit+0xb2>
  for(int i=0; i<1000; i++){
ffff800000103a0b:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
ffff800000103a0f:	81 7d fc e7 03 00 00 	cmpl   $0x3e7,-0x4(%rbp)
ffff800000103a16:	7e cc                	jle    ffff8000001039e4 <ideinit+0x7e>
    }
  }

  // Switch back to disk 0.
  outb(0x1f6, 0xe0 | (0<<4));
ffff800000103a18:	be e0 00 00 00       	mov    $0xe0,%esi
ffff800000103a1d:	bf f6 01 00 00       	mov    $0x1f6,%edi
ffff800000103a22:	48 b8 bb 38 10 00 00 	movabs $0xffff8000001038bb,%rax
ffff800000103a29:	80 ff ff 
ffff800000103a2c:	ff d0                	callq  *%rax
}
ffff800000103a2e:	90                   	nop
ffff800000103a2f:	c9                   	leaveq 
ffff800000103a30:	c3                   	retq   

ffff800000103a31 <idestart>:

// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
ffff800000103a31:	f3 0f 1e fa          	endbr64 
ffff800000103a35:	55                   	push   %rbp
ffff800000103a36:	48 89 e5             	mov    %rsp,%rbp
ffff800000103a39:	48 83 ec 20          	sub    $0x20,%rsp
ffff800000103a3d:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  if(b == 0)
ffff800000103a41:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
ffff800000103a46:	75 16                	jne    ffff800000103a5e <idestart+0x2d>
    panic("idestart");
ffff800000103a48:	48 bf 1f c9 10 00 00 	movabs $0xffff80000010c91f,%rdi
ffff800000103a4f:	80 ff ff 
ffff800000103a52:	48 b8 f9 0b 10 00 00 	movabs $0xffff800000100bf9,%rax
ffff800000103a59:	80 ff ff 
ffff800000103a5c:	ff d0                	callq  *%rax
  if(b->blockno >= FSSIZE)
ffff800000103a5e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000103a62:	8b 40 08             	mov    0x8(%rax),%eax
ffff800000103a65:	3d e7 03 00 00       	cmp    $0x3e7,%eax
ffff800000103a6a:	76 16                	jbe    ffff800000103a82 <idestart+0x51>
    panic("incorrect blockno");
ffff800000103a6c:	48 bf 28 c9 10 00 00 	movabs $0xffff80000010c928,%rdi
ffff800000103a73:	80 ff ff 
ffff800000103a76:	48 b8 f9 0b 10 00 00 	movabs $0xffff800000100bf9,%rax
ffff800000103a7d:	80 ff ff 
ffff800000103a80:	ff d0                	callq  *%rax
  int sector_per_block =  BSIZE/SECTOR_SIZE;
ffff800000103a82:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)
  int sector = b->blockno * sector_per_block;
ffff800000103a89:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000103a8d:	8b 50 08             	mov    0x8(%rax),%edx
ffff800000103a90:	8b 45 fc             	mov    -0x4(%rbp),%eax
ffff800000103a93:	0f af c2             	imul   %edx,%eax
ffff800000103a96:	89 45 f8             	mov    %eax,-0x8(%rbp)
  int read_cmd = (sector_per_block == 1) ? IDE_CMD_READ :  IDE_CMD_RDMUL;
ffff800000103a99:	83 7d fc 01          	cmpl   $0x1,-0x4(%rbp)
ffff800000103a9d:	75 07                	jne    ffff800000103aa6 <idestart+0x75>
ffff800000103a9f:	b8 20 00 00 00       	mov    $0x20,%eax
ffff800000103aa4:	eb 05                	jmp    ffff800000103aab <idestart+0x7a>
ffff800000103aa6:	b8 c4 00 00 00       	mov    $0xc4,%eax
ffff800000103aab:	89 45 f4             	mov    %eax,-0xc(%rbp)
  int write_cmd = (sector_per_block == 1) ? IDE_CMD_WRITE : IDE_CMD_WRMUL;
ffff800000103aae:	83 7d fc 01          	cmpl   $0x1,-0x4(%rbp)
ffff800000103ab2:	75 07                	jne    ffff800000103abb <idestart+0x8a>
ffff800000103ab4:	b8 30 00 00 00       	mov    $0x30,%eax
ffff800000103ab9:	eb 05                	jmp    ffff800000103ac0 <idestart+0x8f>
ffff800000103abb:	b8 c5 00 00 00       	mov    $0xc5,%eax
ffff800000103ac0:	89 45 f0             	mov    %eax,-0x10(%rbp)

  if (sector_per_block > 7) panic("idestart");
ffff800000103ac3:	83 7d fc 07          	cmpl   $0x7,-0x4(%rbp)
ffff800000103ac7:	7e 16                	jle    ffff800000103adf <idestart+0xae>
ffff800000103ac9:	48 bf 1f c9 10 00 00 	movabs $0xffff80000010c91f,%rdi
ffff800000103ad0:	80 ff ff 
ffff800000103ad3:	48 b8 f9 0b 10 00 00 	movabs $0xffff800000100bf9,%rax
ffff800000103ada:	80 ff ff 
ffff800000103add:	ff d0                	callq  *%rax

  idewait(0);
ffff800000103adf:	bf 00 00 00 00       	mov    $0x0,%edi
ffff800000103ae4:	48 b8 14 39 10 00 00 	movabs $0xffff800000103914,%rax
ffff800000103aeb:	80 ff ff 
ffff800000103aee:	ff d0                	callq  *%rax
  outb(0x3f6, 0);  // generate interrupt
ffff800000103af0:	be 00 00 00 00       	mov    $0x0,%esi
ffff800000103af5:	bf f6 03 00 00       	mov    $0x3f6,%edi
ffff800000103afa:	48 b8 bb 38 10 00 00 	movabs $0xffff8000001038bb,%rax
ffff800000103b01:	80 ff ff 
ffff800000103b04:	ff d0                	callq  *%rax
  outb(0x1f2, sector_per_block);  // number of sectors
ffff800000103b06:	8b 45 fc             	mov    -0x4(%rbp),%eax
ffff800000103b09:	0f b6 c0             	movzbl %al,%eax
ffff800000103b0c:	89 c6                	mov    %eax,%esi
ffff800000103b0e:	bf f2 01 00 00       	mov    $0x1f2,%edi
ffff800000103b13:	48 b8 bb 38 10 00 00 	movabs $0xffff8000001038bb,%rax
ffff800000103b1a:	80 ff ff 
ffff800000103b1d:	ff d0                	callq  *%rax
  outb(0x1f3, sector & 0xff);
ffff800000103b1f:	8b 45 f8             	mov    -0x8(%rbp),%eax
ffff800000103b22:	0f b6 c0             	movzbl %al,%eax
ffff800000103b25:	89 c6                	mov    %eax,%esi
ffff800000103b27:	bf f3 01 00 00       	mov    $0x1f3,%edi
ffff800000103b2c:	48 b8 bb 38 10 00 00 	movabs $0xffff8000001038bb,%rax
ffff800000103b33:	80 ff ff 
ffff800000103b36:	ff d0                	callq  *%rax
  outb(0x1f4, (sector >> 8) & 0xff);
ffff800000103b38:	8b 45 f8             	mov    -0x8(%rbp),%eax
ffff800000103b3b:	c1 f8 08             	sar    $0x8,%eax
ffff800000103b3e:	0f b6 c0             	movzbl %al,%eax
ffff800000103b41:	89 c6                	mov    %eax,%esi
ffff800000103b43:	bf f4 01 00 00       	mov    $0x1f4,%edi
ffff800000103b48:	48 b8 bb 38 10 00 00 	movabs $0xffff8000001038bb,%rax
ffff800000103b4f:	80 ff ff 
ffff800000103b52:	ff d0                	callq  *%rax
  outb(0x1f5, (sector >> 16) & 0xff);
ffff800000103b54:	8b 45 f8             	mov    -0x8(%rbp),%eax
ffff800000103b57:	c1 f8 10             	sar    $0x10,%eax
ffff800000103b5a:	0f b6 c0             	movzbl %al,%eax
ffff800000103b5d:	89 c6                	mov    %eax,%esi
ffff800000103b5f:	bf f5 01 00 00       	mov    $0x1f5,%edi
ffff800000103b64:	48 b8 bb 38 10 00 00 	movabs $0xffff8000001038bb,%rax
ffff800000103b6b:	80 ff ff 
ffff800000103b6e:	ff d0                	callq  *%rax
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
ffff800000103b70:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000103b74:	8b 40 04             	mov    0x4(%rax),%eax
ffff800000103b77:	c1 e0 04             	shl    $0x4,%eax
ffff800000103b7a:	83 e0 10             	and    $0x10,%eax
ffff800000103b7d:	89 c2                	mov    %eax,%edx
ffff800000103b7f:	8b 45 f8             	mov    -0x8(%rbp),%eax
ffff800000103b82:	c1 f8 18             	sar    $0x18,%eax
ffff800000103b85:	83 e0 0f             	and    $0xf,%eax
ffff800000103b88:	09 d0                	or     %edx,%eax
ffff800000103b8a:	83 c8 e0             	or     $0xffffffe0,%eax
ffff800000103b8d:	0f b6 c0             	movzbl %al,%eax
ffff800000103b90:	89 c6                	mov    %eax,%esi
ffff800000103b92:	bf f6 01 00 00       	mov    $0x1f6,%edi
ffff800000103b97:	48 b8 bb 38 10 00 00 	movabs $0xffff8000001038bb,%rax
ffff800000103b9e:	80 ff ff 
ffff800000103ba1:	ff d0                	callq  *%rax
  if(b->flags & B_DIRTY){
ffff800000103ba3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000103ba7:	8b 00                	mov    (%rax),%eax
ffff800000103ba9:	83 e0 04             	and    $0x4,%eax
ffff800000103bac:	85 c0                	test   %eax,%eax
ffff800000103bae:	74 3e                	je     ffff800000103bee <idestart+0x1bd>
    outb(0x1f7, write_cmd);
ffff800000103bb0:	8b 45 f0             	mov    -0x10(%rbp),%eax
ffff800000103bb3:	0f b6 c0             	movzbl %al,%eax
ffff800000103bb6:	89 c6                	mov    %eax,%esi
ffff800000103bb8:	bf f7 01 00 00       	mov    $0x1f7,%edi
ffff800000103bbd:	48 b8 bb 38 10 00 00 	movabs $0xffff8000001038bb,%rax
ffff800000103bc4:	80 ff ff 
ffff800000103bc7:	ff d0                	callq  *%rax
    outsl(0x1f0, b->data, BSIZE/4);
ffff800000103bc9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000103bcd:	48 05 b0 00 00 00    	add    $0xb0,%rax
ffff800000103bd3:	ba 80 00 00 00       	mov    $0x80,%edx
ffff800000103bd8:	48 89 c6             	mov    %rax,%rsi
ffff800000103bdb:	bf f0 01 00 00       	mov    $0x1f0,%edi
ffff800000103be0:	48 b8 e0 38 10 00 00 	movabs $0xffff8000001038e0,%rax
ffff800000103be7:	80 ff ff 
ffff800000103bea:	ff d0                	callq  *%rax
  } else {
    outb(0x1f7, read_cmd);
  }
}
ffff800000103bec:	eb 19                	jmp    ffff800000103c07 <idestart+0x1d6>
    outb(0x1f7, read_cmd);
ffff800000103bee:	8b 45 f4             	mov    -0xc(%rbp),%eax
ffff800000103bf1:	0f b6 c0             	movzbl %al,%eax
ffff800000103bf4:	89 c6                	mov    %eax,%esi
ffff800000103bf6:	bf f7 01 00 00       	mov    $0x1f7,%edi
ffff800000103bfb:	48 b8 bb 38 10 00 00 	movabs $0xffff8000001038bb,%rax
ffff800000103c02:	80 ff ff 
ffff800000103c05:	ff d0                	callq  *%rax
}
ffff800000103c07:	90                   	nop
ffff800000103c08:	c9                   	leaveq 
ffff800000103c09:	c3                   	retq   

ffff800000103c0a <ideintr>:

// Interrupt handler.
void
ideintr(void)
{
ffff800000103c0a:	f3 0f 1e fa          	endbr64 
ffff800000103c0e:	55                   	push   %rbp
ffff800000103c0f:	48 89 e5             	mov    %rsp,%rbp
ffff800000103c12:	48 83 ec 10          	sub    $0x10,%rsp
  struct buf *b;

  // First queued buffer is the active request.
  acquire(&idelock);
ffff800000103c16:	48 bf c0 70 11 00 00 	movabs $0xffff8000001170c0,%rdi
ffff800000103c1d:	80 ff ff 
ffff800000103c20:	48 b8 17 7f 10 00 00 	movabs $0xffff800000107f17,%rax
ffff800000103c27:	80 ff ff 
ffff800000103c2a:	ff d0                	callq  *%rax
  if((b = idequeue) == 0){
ffff800000103c2c:	48 b8 28 71 11 00 00 	movabs $0xffff800000117128,%rax
ffff800000103c33:	80 ff ff 
ffff800000103c36:	48 8b 00             	mov    (%rax),%rax
ffff800000103c39:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
ffff800000103c3d:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
ffff800000103c42:	75 1b                	jne    ffff800000103c5f <ideintr+0x55>
    release(&idelock);
ffff800000103c44:	48 bf c0 70 11 00 00 	movabs $0xffff8000001170c0,%rdi
ffff800000103c4b:	80 ff ff 
ffff800000103c4e:	48 b8 b4 7f 10 00 00 	movabs $0xffff800000107fb4,%rax
ffff800000103c55:	80 ff ff 
ffff800000103c58:	ff d0                	callq  *%rax
    // cprintf("spurious IDE interrupt\n");
    return;
ffff800000103c5a:	e9 d6 00 00 00       	jmpq   ffff800000103d35 <ideintr+0x12b>
  }
  idequeue = b->qnext;
ffff800000103c5f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000103c63:	48 8b 80 a8 00 00 00 	mov    0xa8(%rax),%rax
ffff800000103c6a:	48 ba 28 71 11 00 00 	movabs $0xffff800000117128,%rdx
ffff800000103c71:	80 ff ff 
ffff800000103c74:	48 89 02             	mov    %rax,(%rdx)

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
ffff800000103c77:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000103c7b:	8b 00                	mov    (%rax),%eax
ffff800000103c7d:	83 e0 04             	and    $0x4,%eax
ffff800000103c80:	85 c0                	test   %eax,%eax
ffff800000103c82:	75 38                	jne    ffff800000103cbc <ideintr+0xb2>
ffff800000103c84:	bf 01 00 00 00       	mov    $0x1,%edi
ffff800000103c89:	48 b8 14 39 10 00 00 	movabs $0xffff800000103914,%rax
ffff800000103c90:	80 ff ff 
ffff800000103c93:	ff d0                	callq  *%rax
ffff800000103c95:	85 c0                	test   %eax,%eax
ffff800000103c97:	78 23                	js     ffff800000103cbc <ideintr+0xb2>
    insl(0x1f0, b->data, BSIZE/4);
ffff800000103c99:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000103c9d:	48 05 b0 00 00 00    	add    $0xb0,%rax
ffff800000103ca3:	ba 80 00 00 00       	mov    $0x80,%edx
ffff800000103ca8:	48 89 c6             	mov    %rax,%rsi
ffff800000103cab:	bf f0 01 00 00       	mov    $0x1f0,%edi
ffff800000103cb0:	48 b8 81 38 10 00 00 	movabs $0xffff800000103881,%rax
ffff800000103cb7:	80 ff ff 
ffff800000103cba:	ff d0                	callq  *%rax

  // Wake process waiting for this buf.
  b->flags |= B_VALID;
ffff800000103cbc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000103cc0:	8b 00                	mov    (%rax),%eax
ffff800000103cc2:	83 c8 02             	or     $0x2,%eax
ffff800000103cc5:	89 c2                	mov    %eax,%edx
ffff800000103cc7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000103ccb:	89 10                	mov    %edx,(%rax)
  b->flags &= ~B_DIRTY;
ffff800000103ccd:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000103cd1:	8b 00                	mov    (%rax),%eax
ffff800000103cd3:	83 e0 fb             	and    $0xfffffffb,%eax
ffff800000103cd6:	89 c2                	mov    %eax,%edx
ffff800000103cd8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000103cdc:	89 10                	mov    %edx,(%rax)
  wakeup(b);
ffff800000103cde:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000103ce2:	48 89 c7             	mov    %rax,%rdi
ffff800000103ce5:	48 b8 2e 71 10 00 00 	movabs $0xffff80000010712e,%rax
ffff800000103cec:	80 ff ff 
ffff800000103cef:	ff d0                	callq  *%rax

  // Start disk on next buf in queue.
  if(idequeue != 0)
ffff800000103cf1:	48 b8 28 71 11 00 00 	movabs $0xffff800000117128,%rax
ffff800000103cf8:	80 ff ff 
ffff800000103cfb:	48 8b 00             	mov    (%rax),%rax
ffff800000103cfe:	48 85 c0             	test   %rax,%rax
ffff800000103d01:	74 1c                	je     ffff800000103d1f <ideintr+0x115>
    idestart(idequeue);
ffff800000103d03:	48 b8 28 71 11 00 00 	movabs $0xffff800000117128,%rax
ffff800000103d0a:	80 ff ff 
ffff800000103d0d:	48 8b 00             	mov    (%rax),%rax
ffff800000103d10:	48 89 c7             	mov    %rax,%rdi
ffff800000103d13:	48 b8 31 3a 10 00 00 	movabs $0xffff800000103a31,%rax
ffff800000103d1a:	80 ff ff 
ffff800000103d1d:	ff d0                	callq  *%rax

  release(&idelock);
ffff800000103d1f:	48 bf c0 70 11 00 00 	movabs $0xffff8000001170c0,%rdi
ffff800000103d26:	80 ff ff 
ffff800000103d29:	48 b8 b4 7f 10 00 00 	movabs $0xffff800000107fb4,%rax
ffff800000103d30:	80 ff ff 
ffff800000103d33:	ff d0                	callq  *%rax
}
ffff800000103d35:	c9                   	leaveq 
ffff800000103d36:	c3                   	retq   

ffff800000103d37 <iderw>:
// Sync buf with disk.
// If B_DIRTY is set, write buf to disk, clear B_DIRTY, set B_VALID.
// Else if B_VALID is not set, read buf from disk, set B_VALID.
void
iderw(struct buf *b)
{
ffff800000103d37:	f3 0f 1e fa          	endbr64 
ffff800000103d3b:	55                   	push   %rbp
ffff800000103d3c:	48 89 e5             	mov    %rsp,%rbp
ffff800000103d3f:	48 83 ec 20          	sub    $0x20,%rsp
ffff800000103d43:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  struct buf **pp;

  if(!holdingsleep(&b->lock))
ffff800000103d47:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000103d4b:	48 83 c0 10          	add    $0x10,%rax
ffff800000103d4f:	48 89 c7             	mov    %rax,%rdi
ffff800000103d52:	48 b8 37 7e 10 00 00 	movabs $0xffff800000107e37,%rax
ffff800000103d59:	80 ff ff 
ffff800000103d5c:	ff d0                	callq  *%rax
ffff800000103d5e:	85 c0                	test   %eax,%eax
ffff800000103d60:	75 16                	jne    ffff800000103d78 <iderw+0x41>
    panic("iderw: buf not locked");
ffff800000103d62:	48 bf 3a c9 10 00 00 	movabs $0xffff80000010c93a,%rdi
ffff800000103d69:	80 ff ff 
ffff800000103d6c:	48 b8 f9 0b 10 00 00 	movabs $0xffff800000100bf9,%rax
ffff800000103d73:	80 ff ff 
ffff800000103d76:	ff d0                	callq  *%rax
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
ffff800000103d78:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000103d7c:	8b 00                	mov    (%rax),%eax
ffff800000103d7e:	83 e0 06             	and    $0x6,%eax
ffff800000103d81:	83 f8 02             	cmp    $0x2,%eax
ffff800000103d84:	75 16                	jne    ffff800000103d9c <iderw+0x65>
    panic("iderw: nothing to do");
ffff800000103d86:	48 bf 50 c9 10 00 00 	movabs $0xffff80000010c950,%rdi
ffff800000103d8d:	80 ff ff 
ffff800000103d90:	48 b8 f9 0b 10 00 00 	movabs $0xffff800000100bf9,%rax
ffff800000103d97:	80 ff ff 
ffff800000103d9a:	ff d0                	callq  *%rax
  if(b->dev != 0 && !havedisk1)
ffff800000103d9c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000103da0:	8b 40 04             	mov    0x4(%rax),%eax
ffff800000103da3:	85 c0                	test   %eax,%eax
ffff800000103da5:	74 26                	je     ffff800000103dcd <iderw+0x96>
ffff800000103da7:	48 b8 30 71 11 00 00 	movabs $0xffff800000117130,%rax
ffff800000103dae:	80 ff ff 
ffff800000103db1:	8b 00                	mov    (%rax),%eax
ffff800000103db3:	85 c0                	test   %eax,%eax
ffff800000103db5:	75 16                	jne    ffff800000103dcd <iderw+0x96>
    panic("iderw: ide disk 1 not present");
ffff800000103db7:	48 bf 65 c9 10 00 00 	movabs $0xffff80000010c965,%rdi
ffff800000103dbe:	80 ff ff 
ffff800000103dc1:	48 b8 f9 0b 10 00 00 	movabs $0xffff800000100bf9,%rax
ffff800000103dc8:	80 ff ff 
ffff800000103dcb:	ff d0                	callq  *%rax

  acquire(&idelock);  //DOC:acquire-lock
ffff800000103dcd:	48 bf c0 70 11 00 00 	movabs $0xffff8000001170c0,%rdi
ffff800000103dd4:	80 ff ff 
ffff800000103dd7:	48 b8 17 7f 10 00 00 	movabs $0xffff800000107f17,%rax
ffff800000103dde:	80 ff ff 
ffff800000103de1:	ff d0                	callq  *%rax

  // Append b to idequeue.
  b->qnext = 0;
ffff800000103de3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000103de7:	48 c7 80 a8 00 00 00 	movq   $0x0,0xa8(%rax)
ffff800000103dee:	00 00 00 00 
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
ffff800000103df2:	48 b8 28 71 11 00 00 	movabs $0xffff800000117128,%rax
ffff800000103df9:	80 ff ff 
ffff800000103dfc:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
ffff800000103e00:	eb 11                	jmp    ffff800000103e13 <iderw+0xdc>
ffff800000103e02:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000103e06:	48 8b 00             	mov    (%rax),%rax
ffff800000103e09:	48 05 a8 00 00 00    	add    $0xa8,%rax
ffff800000103e0f:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
ffff800000103e13:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000103e17:	48 8b 00             	mov    (%rax),%rax
ffff800000103e1a:	48 85 c0             	test   %rax,%rax
ffff800000103e1d:	75 e3                	jne    ffff800000103e02 <iderw+0xcb>
    ;
  *pp = b;
ffff800000103e1f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000103e23:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
ffff800000103e27:	48 89 10             	mov    %rdx,(%rax)

  // Start disk if necessary.
  if(idequeue == b)
ffff800000103e2a:	48 b8 28 71 11 00 00 	movabs $0xffff800000117128,%rax
ffff800000103e31:	80 ff ff 
ffff800000103e34:	48 8b 00             	mov    (%rax),%rax
ffff800000103e37:	48 39 45 e8          	cmp    %rax,-0x18(%rbp)
ffff800000103e3b:	75 32                	jne    ffff800000103e6f <iderw+0x138>
    idestart(b);
ffff800000103e3d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000103e41:	48 89 c7             	mov    %rax,%rdi
ffff800000103e44:	48 b8 31 3a 10 00 00 	movabs $0xffff800000103a31,%rax
ffff800000103e4b:	80 ff ff 
ffff800000103e4e:	ff d0                	callq  *%rax

  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
ffff800000103e50:	eb 1d                	jmp    ffff800000103e6f <iderw+0x138>
    sleep(b, &idelock);
ffff800000103e52:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000103e56:	48 be c0 70 11 00 00 	movabs $0xffff8000001170c0,%rsi
ffff800000103e5d:	80 ff ff 
ffff800000103e60:	48 89 c7             	mov    %rax,%rdi
ffff800000103e63:	48 b8 bd 6f 10 00 00 	movabs $0xffff800000106fbd,%rax
ffff800000103e6a:	80 ff ff 
ffff800000103e6d:	ff d0                	callq  *%rax
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
ffff800000103e6f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000103e73:	8b 00                	mov    (%rax),%eax
ffff800000103e75:	83 e0 06             	and    $0x6,%eax
ffff800000103e78:	83 f8 02             	cmp    $0x2,%eax
ffff800000103e7b:	75 d5                	jne    ffff800000103e52 <iderw+0x11b>
  }

  release(&idelock);
ffff800000103e7d:	48 bf c0 70 11 00 00 	movabs $0xffff8000001170c0,%rdi
ffff800000103e84:	80 ff ff 
ffff800000103e87:	48 b8 b4 7f 10 00 00 	movabs $0xffff800000107fb4,%rax
ffff800000103e8e:	80 ff ff 
ffff800000103e91:	ff d0                	callq  *%rax
}
ffff800000103e93:	90                   	nop
ffff800000103e94:	c9                   	leaveq 
ffff800000103e95:	c3                   	retq   

ffff800000103e96 <ioapicread>:
  uint data;
};

static uint
ioapicread(int reg)
{
ffff800000103e96:	f3 0f 1e fa          	endbr64 
ffff800000103e9a:	55                   	push   %rbp
ffff800000103e9b:	48 89 e5             	mov    %rsp,%rbp
ffff800000103e9e:	48 83 ec 08          	sub    $0x8,%rsp
ffff800000103ea2:	89 7d fc             	mov    %edi,-0x4(%rbp)
  ioapic->reg = reg;
ffff800000103ea5:	48 b8 38 71 11 00 00 	movabs $0xffff800000117138,%rax
ffff800000103eac:	80 ff ff 
ffff800000103eaf:	48 8b 00             	mov    (%rax),%rax
ffff800000103eb2:	8b 55 fc             	mov    -0x4(%rbp),%edx
ffff800000103eb5:	89 10                	mov    %edx,(%rax)
  return ioapic->data;
ffff800000103eb7:	48 b8 38 71 11 00 00 	movabs $0xffff800000117138,%rax
ffff800000103ebe:	80 ff ff 
ffff800000103ec1:	48 8b 00             	mov    (%rax),%rax
ffff800000103ec4:	8b 40 10             	mov    0x10(%rax),%eax
}
ffff800000103ec7:	c9                   	leaveq 
ffff800000103ec8:	c3                   	retq   

ffff800000103ec9 <ioapicwrite>:

static void
ioapicwrite(int reg, uint data)
{
ffff800000103ec9:	f3 0f 1e fa          	endbr64 
ffff800000103ecd:	55                   	push   %rbp
ffff800000103ece:	48 89 e5             	mov    %rsp,%rbp
ffff800000103ed1:	48 83 ec 08          	sub    $0x8,%rsp
ffff800000103ed5:	89 7d fc             	mov    %edi,-0x4(%rbp)
ffff800000103ed8:	89 75 f8             	mov    %esi,-0x8(%rbp)
  ioapic->reg = reg;
ffff800000103edb:	48 b8 38 71 11 00 00 	movabs $0xffff800000117138,%rax
ffff800000103ee2:	80 ff ff 
ffff800000103ee5:	48 8b 00             	mov    (%rax),%rax
ffff800000103ee8:	8b 55 fc             	mov    -0x4(%rbp),%edx
ffff800000103eeb:	89 10                	mov    %edx,(%rax)
  ioapic->data = data;
ffff800000103eed:	48 b8 38 71 11 00 00 	movabs $0xffff800000117138,%rax
ffff800000103ef4:	80 ff ff 
ffff800000103ef7:	48 8b 00             	mov    (%rax),%rax
ffff800000103efa:	8b 55 f8             	mov    -0x8(%rbp),%edx
ffff800000103efd:	89 50 10             	mov    %edx,0x10(%rax)
}
ffff800000103f00:	90                   	nop
ffff800000103f01:	c9                   	leaveq 
ffff800000103f02:	c3                   	retq   

ffff800000103f03 <ioapicinit>:

void
ioapicinit(void)
{
ffff800000103f03:	f3 0f 1e fa          	endbr64 
ffff800000103f07:	55                   	push   %rbp
ffff800000103f08:	48 89 e5             	mov    %rsp,%rbp
ffff800000103f0b:	48 83 ec 10          	sub    $0x10,%rsp
  int i, id, maxintr;

  ioapic = P2V((volatile struct ioapic*)IOAPIC);
ffff800000103f0f:	48 b8 38 71 11 00 00 	movabs $0xffff800000117138,%rax
ffff800000103f16:	80 ff ff 
ffff800000103f19:	48 b9 00 00 c0 fe 00 	movabs $0xffff8000fec00000,%rcx
ffff800000103f20:	80 ff ff 
ffff800000103f23:	48 89 08             	mov    %rcx,(%rax)
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
ffff800000103f26:	bf 01 00 00 00       	mov    $0x1,%edi
ffff800000103f2b:	48 b8 96 3e 10 00 00 	movabs $0xffff800000103e96,%rax
ffff800000103f32:	80 ff ff 
ffff800000103f35:	ff d0                	callq  *%rax
ffff800000103f37:	c1 e8 10             	shr    $0x10,%eax
ffff800000103f3a:	25 ff 00 00 00       	and    $0xff,%eax
ffff800000103f3f:	89 45 f8             	mov    %eax,-0x8(%rbp)
  id = ioapicread(REG_ID) >> 24;
ffff800000103f42:	bf 00 00 00 00       	mov    $0x0,%edi
ffff800000103f47:	48 b8 96 3e 10 00 00 	movabs $0xffff800000103e96,%rax
ffff800000103f4e:	80 ff ff 
ffff800000103f51:	ff d0                	callq  *%rax
ffff800000103f53:	c1 e8 18             	shr    $0x18,%eax
ffff800000103f56:	89 45 f4             	mov    %eax,-0xc(%rbp)
  if(id != ioapicid)
ffff800000103f59:	48 b8 24 74 11 00 00 	movabs $0xffff800000117424,%rax
ffff800000103f60:	80 ff ff 
ffff800000103f63:	0f b6 00             	movzbl (%rax),%eax
ffff800000103f66:	0f b6 c0             	movzbl %al,%eax
ffff800000103f69:	39 45 f4             	cmp    %eax,-0xc(%rbp)
ffff800000103f6c:	74 1b                	je     ffff800000103f89 <ioapicinit+0x86>
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");
ffff800000103f6e:	48 bf 88 c9 10 00 00 	movabs $0xffff80000010c988,%rdi
ffff800000103f75:	80 ff ff 
ffff800000103f78:	b8 00 00 00 00       	mov    $0x0,%eax
ffff800000103f7d:	48 ba 18 08 10 00 00 	movabs $0xffff800000100818,%rdx
ffff800000103f84:	80 ff ff 
ffff800000103f87:	ff d2                	callq  *%rdx

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
ffff800000103f89:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
ffff800000103f90:	eb 47                	jmp    ffff800000103fd9 <ioapicinit+0xd6>
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
ffff800000103f92:	8b 45 fc             	mov    -0x4(%rbp),%eax
ffff800000103f95:	83 c0 20             	add    $0x20,%eax
ffff800000103f98:	0d 00 00 01 00       	or     $0x10000,%eax
ffff800000103f9d:	89 c2                	mov    %eax,%edx
ffff800000103f9f:	8b 45 fc             	mov    -0x4(%rbp),%eax
ffff800000103fa2:	83 c0 08             	add    $0x8,%eax
ffff800000103fa5:	01 c0                	add    %eax,%eax
ffff800000103fa7:	89 d6                	mov    %edx,%esi
ffff800000103fa9:	89 c7                	mov    %eax,%edi
ffff800000103fab:	48 b8 c9 3e 10 00 00 	movabs $0xffff800000103ec9,%rax
ffff800000103fb2:	80 ff ff 
ffff800000103fb5:	ff d0                	callq  *%rax
    ioapicwrite(REG_TABLE+2*i+1, 0);
ffff800000103fb7:	8b 45 fc             	mov    -0x4(%rbp),%eax
ffff800000103fba:	83 c0 08             	add    $0x8,%eax
ffff800000103fbd:	01 c0                	add    %eax,%eax
ffff800000103fbf:	83 c0 01             	add    $0x1,%eax
ffff800000103fc2:	be 00 00 00 00       	mov    $0x0,%esi
ffff800000103fc7:	89 c7                	mov    %eax,%edi
ffff800000103fc9:	48 b8 c9 3e 10 00 00 	movabs $0xffff800000103ec9,%rax
ffff800000103fd0:	80 ff ff 
ffff800000103fd3:	ff d0                	callq  *%rax
  for(i = 0; i <= maxintr; i++){
ffff800000103fd5:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
ffff800000103fd9:	8b 45 fc             	mov    -0x4(%rbp),%eax
ffff800000103fdc:	3b 45 f8             	cmp    -0x8(%rbp),%eax
ffff800000103fdf:	7e b1                	jle    ffff800000103f92 <ioapicinit+0x8f>
  }
}
ffff800000103fe1:	90                   	nop
ffff800000103fe2:	90                   	nop
ffff800000103fe3:	c9                   	leaveq 
ffff800000103fe4:	c3                   	retq   

ffff800000103fe5 <ioapicenable>:

void
ioapicenable(int irq, int cpunum)
{
ffff800000103fe5:	f3 0f 1e fa          	endbr64 
ffff800000103fe9:	55                   	push   %rbp
ffff800000103fea:	48 89 e5             	mov    %rsp,%rbp
ffff800000103fed:	48 83 ec 08          	sub    $0x8,%rsp
ffff800000103ff1:	89 7d fc             	mov    %edi,-0x4(%rbp)
ffff800000103ff4:	89 75 f8             	mov    %esi,-0x8(%rbp)
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
ffff800000103ff7:	8b 45 fc             	mov    -0x4(%rbp),%eax
ffff800000103ffa:	83 c0 20             	add    $0x20,%eax
ffff800000103ffd:	89 c2                	mov    %eax,%edx
ffff800000103fff:	8b 45 fc             	mov    -0x4(%rbp),%eax
ffff800000104002:	83 c0 08             	add    $0x8,%eax
ffff800000104005:	01 c0                	add    %eax,%eax
ffff800000104007:	89 d6                	mov    %edx,%esi
ffff800000104009:	89 c7                	mov    %eax,%edi
ffff80000010400b:	48 b8 c9 3e 10 00 00 	movabs $0xffff800000103ec9,%rax
ffff800000104012:	80 ff ff 
ffff800000104015:	ff d0                	callq  *%rax
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
ffff800000104017:	8b 45 f8             	mov    -0x8(%rbp),%eax
ffff80000010401a:	c1 e0 18             	shl    $0x18,%eax
ffff80000010401d:	89 c2                	mov    %eax,%edx
ffff80000010401f:	8b 45 fc             	mov    -0x4(%rbp),%eax
ffff800000104022:	83 c0 08             	add    $0x8,%eax
ffff800000104025:	01 c0                	add    %eax,%eax
ffff800000104027:	83 c0 01             	add    $0x1,%eax
ffff80000010402a:	89 d6                	mov    %edx,%esi
ffff80000010402c:	89 c7                	mov    %eax,%edi
ffff80000010402e:	48 b8 c9 3e 10 00 00 	movabs $0xffff800000103ec9,%rax
ffff800000104035:	80 ff ff 
ffff800000104038:	ff d0                	callq  *%rax
}
ffff80000010403a:	90                   	nop
ffff80000010403b:	c9                   	leaveq 
ffff80000010403c:	c3                   	retq   

ffff80000010403d <kinit1>:
// the pages mapped by entrypgdir on free list.
// 2. main() calls kinit2() with the rest of the physical pages
// after installing a full page table that maps them on all cores.
void
kinit1(void *vstart, void *vend)
{
ffff80000010403d:	f3 0f 1e fa          	endbr64 
ffff800000104041:	55                   	push   %rbp
ffff800000104042:	48 89 e5             	mov    %rsp,%rbp
ffff800000104045:	48 83 ec 10          	sub    $0x10,%rsp
ffff800000104049:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
ffff80000010404d:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  initlock(&kmem.lock, "kmem");
ffff800000104051:	48 be ba c9 10 00 00 	movabs $0xffff80000010c9ba,%rsi
ffff800000104058:	80 ff ff 
ffff80000010405b:	48 bf 40 71 11 00 00 	movabs $0xffff800000117140,%rdi
ffff800000104062:	80 ff ff 
ffff800000104065:	48 b8 de 7e 10 00 00 	movabs $0xffff800000107ede,%rax
ffff80000010406c:	80 ff ff 
ffff80000010406f:	ff d0                	callq  *%rax
  kmem.use_lock = 0;
ffff800000104071:	48 b8 40 71 11 00 00 	movabs $0xffff800000117140,%rax
ffff800000104078:	80 ff ff 
ffff80000010407b:	c7 40 68 00 00 00 00 	movl   $0x0,0x68(%rax)
  freerange(vstart, vend);
ffff800000104082:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
ffff800000104086:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff80000010408a:	48 89 d6             	mov    %rdx,%rsi
ffff80000010408d:	48 89 c7             	mov    %rax,%rdi
ffff800000104090:	48 b8 e1 40 10 00 00 	movabs $0xffff8000001040e1,%rax
ffff800000104097:	80 ff ff 
ffff80000010409a:	ff d0                	callq  *%rax
}
ffff80000010409c:	90                   	nop
ffff80000010409d:	c9                   	leaveq 
ffff80000010409e:	c3                   	retq   

ffff80000010409f <kinit2>:

void
kinit2(void *vstart, void *vend)
{
ffff80000010409f:	f3 0f 1e fa          	endbr64 
ffff8000001040a3:	55                   	push   %rbp
ffff8000001040a4:	48 89 e5             	mov    %rsp,%rbp
ffff8000001040a7:	48 83 ec 10          	sub    $0x10,%rsp
ffff8000001040ab:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
ffff8000001040af:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  freerange(vstart, vend);
ffff8000001040b3:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
ffff8000001040b7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff8000001040bb:	48 89 d6             	mov    %rdx,%rsi
ffff8000001040be:	48 89 c7             	mov    %rax,%rdi
ffff8000001040c1:	48 b8 e1 40 10 00 00 	movabs $0xffff8000001040e1,%rax
ffff8000001040c8:	80 ff ff 
ffff8000001040cb:	ff d0                	callq  *%rax
  kmem.use_lock = 1;
ffff8000001040cd:	48 b8 40 71 11 00 00 	movabs $0xffff800000117140,%rax
ffff8000001040d4:	80 ff ff 
ffff8000001040d7:	c7 40 68 01 00 00 00 	movl   $0x1,0x68(%rax)
}
ffff8000001040de:	90                   	nop
ffff8000001040df:	c9                   	leaveq 
ffff8000001040e0:	c3                   	retq   

ffff8000001040e1 <freerange>:

void
freerange(void *vstart, void *vend)
{
ffff8000001040e1:	f3 0f 1e fa          	endbr64 
ffff8000001040e5:	55                   	push   %rbp
ffff8000001040e6:	48 89 e5             	mov    %rsp,%rbp
ffff8000001040e9:	48 83 ec 20          	sub    $0x20,%rsp
ffff8000001040ed:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
ffff8000001040f1:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  char *p;
  p = (char*)PGROUNDUP((addr_t)vstart);
ffff8000001040f5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff8000001040f9:	48 05 ff 0f 00 00    	add    $0xfff,%rax
ffff8000001040ff:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
ffff800000104105:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
ffff800000104109:	eb 1b                	jmp    ffff800000104126 <freerange+0x45>
    kfree(p);
ffff80000010410b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff80000010410f:	48 89 c7             	mov    %rax,%rdi
ffff800000104112:	48 b8 3a 41 10 00 00 	movabs $0xffff80000010413a,%rax
ffff800000104119:	80 ff ff 
ffff80000010411c:	ff d0                	callq  *%rax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
ffff80000010411e:	48 81 45 f8 00 10 00 	addq   $0x1000,-0x8(%rbp)
ffff800000104125:	00 
ffff800000104126:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff80000010412a:	48 05 00 10 00 00    	add    $0x1000,%rax
ffff800000104130:	48 39 45 e0          	cmp    %rax,-0x20(%rbp)
ffff800000104134:	73 d5                	jae    ffff80000010410b <freerange+0x2a>
}
ffff800000104136:	90                   	nop
ffff800000104137:	90                   	nop
ffff800000104138:	c9                   	leaveq 
ffff800000104139:	c3                   	retq   

ffff80000010413a <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(char *v)
{
ffff80000010413a:	f3 0f 1e fa          	endbr64 
ffff80000010413e:	55                   	push   %rbp
ffff80000010413f:	48 89 e5             	mov    %rsp,%rbp
ffff800000104142:	48 83 ec 20          	sub    $0x20,%rsp
ffff800000104146:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  struct run *r;

  if((addr_t)v % PGSIZE || v < end || V2P(v) >= PHYSTOP)
ffff80000010414a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff80000010414e:	25 ff 0f 00 00       	and    $0xfff,%eax
ffff800000104153:	48 85 c0             	test   %rax,%rax
ffff800000104156:	75 29                	jne    ffff800000104181 <kfree+0x47>
ffff800000104158:	48 b8 00 d0 11 00 00 	movabs $0xffff80000011d000,%rax
ffff80000010415f:	80 ff ff 
ffff800000104162:	48 39 45 e8          	cmp    %rax,-0x18(%rbp)
ffff800000104166:	72 19                	jb     ffff800000104181 <kfree+0x47>
ffff800000104168:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff80000010416c:	48 ba 00 00 00 00 00 	movabs $0x800000000000,%rdx
ffff800000104173:	80 00 00 
ffff800000104176:	48 01 d0             	add    %rdx,%rax
ffff800000104179:	48 3d ff ff ff 0d    	cmp    $0xdffffff,%rax
ffff80000010417f:	76 16                	jbe    ffff800000104197 <kfree+0x5d>
    panic("kfree");
ffff800000104181:	48 bf bf c9 10 00 00 	movabs $0xffff80000010c9bf,%rdi
ffff800000104188:	80 ff ff 
ffff80000010418b:	48 b8 f9 0b 10 00 00 	movabs $0xffff800000100bf9,%rax
ffff800000104192:	80 ff ff 
ffff800000104195:	ff d0                	callq  *%rax

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);
ffff800000104197:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff80000010419b:	ba 00 10 00 00       	mov    $0x1000,%edx
ffff8000001041a0:	be 01 00 00 00       	mov    $0x1,%esi
ffff8000001041a5:	48 89 c7             	mov    %rax,%rdi
ffff8000001041a8:	48 b8 bd 82 10 00 00 	movabs $0xffff8000001082bd,%rax
ffff8000001041af:	80 ff ff 
ffff8000001041b2:	ff d0                	callq  *%rax

  if(kmem.use_lock)
ffff8000001041b4:	48 b8 40 71 11 00 00 	movabs $0xffff800000117140,%rax
ffff8000001041bb:	80 ff ff 
ffff8000001041be:	8b 40 68             	mov    0x68(%rax),%eax
ffff8000001041c1:	85 c0                	test   %eax,%eax
ffff8000001041c3:	74 16                	je     ffff8000001041db <kfree+0xa1>
    acquire(&kmem.lock);
ffff8000001041c5:	48 bf 40 71 11 00 00 	movabs $0xffff800000117140,%rdi
ffff8000001041cc:	80 ff ff 
ffff8000001041cf:	48 b8 17 7f 10 00 00 	movabs $0xffff800000107f17,%rax
ffff8000001041d6:	80 ff ff 
ffff8000001041d9:	ff d0                	callq  *%rax
  r = (struct run*)v;
ffff8000001041db:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff8000001041df:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  r->next = kmem.freelist;
ffff8000001041e3:	48 b8 40 71 11 00 00 	movabs $0xffff800000117140,%rax
ffff8000001041ea:	80 ff ff 
ffff8000001041ed:	48 8b 50 70          	mov    0x70(%rax),%rdx
ffff8000001041f1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff8000001041f5:	48 89 10             	mov    %rdx,(%rax)
  kmem.freelist = r;
ffff8000001041f8:	48 ba 40 71 11 00 00 	movabs $0xffff800000117140,%rdx
ffff8000001041ff:	80 ff ff 
ffff800000104202:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000104206:	48 89 42 70          	mov    %rax,0x70(%rdx)
  if(kmem.use_lock)
ffff80000010420a:	48 b8 40 71 11 00 00 	movabs $0xffff800000117140,%rax
ffff800000104211:	80 ff ff 
ffff800000104214:	8b 40 68             	mov    0x68(%rax),%eax
ffff800000104217:	85 c0                	test   %eax,%eax
ffff800000104219:	74 16                	je     ffff800000104231 <kfree+0xf7>
    release(&kmem.lock);
ffff80000010421b:	48 bf 40 71 11 00 00 	movabs $0xffff800000117140,%rdi
ffff800000104222:	80 ff ff 
ffff800000104225:	48 b8 b4 7f 10 00 00 	movabs $0xffff800000107fb4,%rax
ffff80000010422c:	80 ff ff 
ffff80000010422f:	ff d0                	callq  *%rax
}
ffff800000104231:	90                   	nop
ffff800000104232:	c9                   	leaveq 
ffff800000104233:	c3                   	retq   

ffff800000104234 <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
char*
kalloc(void)
{
ffff800000104234:	f3 0f 1e fa          	endbr64 
ffff800000104238:	55                   	push   %rbp
ffff800000104239:	48 89 e5             	mov    %rsp,%rbp
ffff80000010423c:	48 83 ec 10          	sub    $0x10,%rsp
  struct run *r;

  if(kmem.use_lock)
ffff800000104240:	48 b8 40 71 11 00 00 	movabs $0xffff800000117140,%rax
ffff800000104247:	80 ff ff 
ffff80000010424a:	8b 40 68             	mov    0x68(%rax),%eax
ffff80000010424d:	85 c0                	test   %eax,%eax
ffff80000010424f:	74 16                	je     ffff800000104267 <kalloc+0x33>
    acquire(&kmem.lock);
ffff800000104251:	48 bf 40 71 11 00 00 	movabs $0xffff800000117140,%rdi
ffff800000104258:	80 ff ff 
ffff80000010425b:	48 b8 17 7f 10 00 00 	movabs $0xffff800000107f17,%rax
ffff800000104262:	80 ff ff 
ffff800000104265:	ff d0                	callq  *%rax
  r = kmem.freelist;
ffff800000104267:	48 b8 40 71 11 00 00 	movabs $0xffff800000117140,%rax
ffff80000010426e:	80 ff ff 
ffff800000104271:	48 8b 40 70          	mov    0x70(%rax),%rax
ffff800000104275:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  if(r)
ffff800000104279:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
ffff80000010427e:	74 15                	je     ffff800000104295 <kalloc+0x61>
    kmem.freelist = r->next;
ffff800000104280:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000104284:	48 8b 00             	mov    (%rax),%rax
ffff800000104287:	48 ba 40 71 11 00 00 	movabs $0xffff800000117140,%rdx
ffff80000010428e:	80 ff ff 
ffff800000104291:	48 89 42 70          	mov    %rax,0x70(%rdx)
  if(kmem.use_lock)
ffff800000104295:	48 b8 40 71 11 00 00 	movabs $0xffff800000117140,%rax
ffff80000010429c:	80 ff ff 
ffff80000010429f:	8b 40 68             	mov    0x68(%rax),%eax
ffff8000001042a2:	85 c0                	test   %eax,%eax
ffff8000001042a4:	74 16                	je     ffff8000001042bc <kalloc+0x88>
    release(&kmem.lock);
ffff8000001042a6:	48 bf 40 71 11 00 00 	movabs $0xffff800000117140,%rdi
ffff8000001042ad:	80 ff ff 
ffff8000001042b0:	48 b8 b4 7f 10 00 00 	movabs $0xffff800000107fb4,%rax
ffff8000001042b7:	80 ff ff 
ffff8000001042ba:	ff d0                	callq  *%rax
  return (char*)r;
ffff8000001042bc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
ffff8000001042c0:	c9                   	leaveq 
ffff8000001042c1:	c3                   	retq   

ffff8000001042c2 <inb>:
{
ffff8000001042c2:	f3 0f 1e fa          	endbr64 
ffff8000001042c6:	55                   	push   %rbp
ffff8000001042c7:	48 89 e5             	mov    %rsp,%rbp
ffff8000001042ca:	48 83 ec 18          	sub    $0x18,%rsp
ffff8000001042ce:	89 f8                	mov    %edi,%eax
ffff8000001042d0:	66 89 45 ec          	mov    %ax,-0x14(%rbp)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
ffff8000001042d4:	0f b7 45 ec          	movzwl -0x14(%rbp),%eax
ffff8000001042d8:	89 c2                	mov    %eax,%edx
ffff8000001042da:	ec                   	in     (%dx),%al
ffff8000001042db:	88 45 ff             	mov    %al,-0x1(%rbp)
  return data;
ffff8000001042de:	0f b6 45 ff          	movzbl -0x1(%rbp),%eax
}
ffff8000001042e2:	c9                   	leaveq 
ffff8000001042e3:	c3                   	retq   

ffff8000001042e4 <kbdgetc>:
#include "defs.h"
#include "kbd.h"

int
kbdgetc(void)
{
ffff8000001042e4:	f3 0f 1e fa          	endbr64 
ffff8000001042e8:	55                   	push   %rbp
ffff8000001042e9:	48 89 e5             	mov    %rsp,%rbp
ffff8000001042ec:	48 83 ec 10          	sub    $0x10,%rsp
  static uchar *charcode[4] = {
    normalmap, shiftmap, ctlmap, ctlmap
  };
  uint st, data, c;

  st = inb(KBSTATP);
ffff8000001042f0:	bf 64 00 00 00       	mov    $0x64,%edi
ffff8000001042f5:	48 b8 c2 42 10 00 00 	movabs $0xffff8000001042c2,%rax
ffff8000001042fc:	80 ff ff 
ffff8000001042ff:	ff d0                	callq  *%rax
ffff800000104301:	0f b6 c0             	movzbl %al,%eax
ffff800000104304:	89 45 f4             	mov    %eax,-0xc(%rbp)
  if((st & KBS_DIB) == 0)
ffff800000104307:	8b 45 f4             	mov    -0xc(%rbp),%eax
ffff80000010430a:	83 e0 01             	and    $0x1,%eax
ffff80000010430d:	85 c0                	test   %eax,%eax
ffff80000010430f:	75 0a                	jne    ffff80000010431b <kbdgetc+0x37>
    return -1;
ffff800000104311:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
ffff800000104316:	e9 ae 01 00 00       	jmpq   ffff8000001044c9 <kbdgetc+0x1e5>
  data = inb(KBDATAP);
ffff80000010431b:	bf 60 00 00 00       	mov    $0x60,%edi
ffff800000104320:	48 b8 c2 42 10 00 00 	movabs $0xffff8000001042c2,%rax
ffff800000104327:	80 ff ff 
ffff80000010432a:	ff d0                	callq  *%rax
ffff80000010432c:	0f b6 c0             	movzbl %al,%eax
ffff80000010432f:	89 45 fc             	mov    %eax,-0x4(%rbp)

  if(data == 0xE0){
ffff800000104332:	81 7d fc e0 00 00 00 	cmpl   $0xe0,-0x4(%rbp)
ffff800000104339:	75 27                	jne    ffff800000104362 <kbdgetc+0x7e>
    shift |= E0ESC;
ffff80000010433b:	48 b8 b8 71 11 00 00 	movabs $0xffff8000001171b8,%rax
ffff800000104342:	80 ff ff 
ffff800000104345:	8b 00                	mov    (%rax),%eax
ffff800000104347:	83 c8 40             	or     $0x40,%eax
ffff80000010434a:	89 c2                	mov    %eax,%edx
ffff80000010434c:	48 b8 b8 71 11 00 00 	movabs $0xffff8000001171b8,%rax
ffff800000104353:	80 ff ff 
ffff800000104356:	89 10                	mov    %edx,(%rax)
    return 0;
ffff800000104358:	b8 00 00 00 00       	mov    $0x0,%eax
ffff80000010435d:	e9 67 01 00 00       	jmpq   ffff8000001044c9 <kbdgetc+0x1e5>
  } else if(data & 0x80){
ffff800000104362:	8b 45 fc             	mov    -0x4(%rbp),%eax
ffff800000104365:	25 80 00 00 00       	and    $0x80,%eax
ffff80000010436a:	85 c0                	test   %eax,%eax
ffff80000010436c:	74 60                	je     ffff8000001043ce <kbdgetc+0xea>
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
ffff80000010436e:	48 b8 b8 71 11 00 00 	movabs $0xffff8000001171b8,%rax
ffff800000104375:	80 ff ff 
ffff800000104378:	8b 00                	mov    (%rax),%eax
ffff80000010437a:	83 e0 40             	and    $0x40,%eax
ffff80000010437d:	85 c0                	test   %eax,%eax
ffff80000010437f:	75 08                	jne    ffff800000104389 <kbdgetc+0xa5>
ffff800000104381:	8b 45 fc             	mov    -0x4(%rbp),%eax
ffff800000104384:	83 e0 7f             	and    $0x7f,%eax
ffff800000104387:	eb 03                	jmp    ffff80000010438c <kbdgetc+0xa8>
ffff800000104389:	8b 45 fc             	mov    -0x4(%rbp),%eax
ffff80000010438c:	89 45 fc             	mov    %eax,-0x4(%rbp)
    shift &= ~(shiftcode[data] | E0ESC);
ffff80000010438f:	48 ba 20 d0 10 00 00 	movabs $0xffff80000010d020,%rdx
ffff800000104396:	80 ff ff 
ffff800000104399:	8b 45 fc             	mov    -0x4(%rbp),%eax
ffff80000010439c:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax
ffff8000001043a0:	83 c8 40             	or     $0x40,%eax
ffff8000001043a3:	0f b6 c0             	movzbl %al,%eax
ffff8000001043a6:	f7 d0                	not    %eax
ffff8000001043a8:	89 c2                	mov    %eax,%edx
ffff8000001043aa:	48 b8 b8 71 11 00 00 	movabs $0xffff8000001171b8,%rax
ffff8000001043b1:	80 ff ff 
ffff8000001043b4:	8b 00                	mov    (%rax),%eax
ffff8000001043b6:	21 c2                	and    %eax,%edx
ffff8000001043b8:	48 b8 b8 71 11 00 00 	movabs $0xffff8000001171b8,%rax
ffff8000001043bf:	80 ff ff 
ffff8000001043c2:	89 10                	mov    %edx,(%rax)
    return 0;
ffff8000001043c4:	b8 00 00 00 00       	mov    $0x0,%eax
ffff8000001043c9:	e9 fb 00 00 00       	jmpq   ffff8000001044c9 <kbdgetc+0x1e5>
  } else if(shift & E0ESC){
ffff8000001043ce:	48 b8 b8 71 11 00 00 	movabs $0xffff8000001171b8,%rax
ffff8000001043d5:	80 ff ff 
ffff8000001043d8:	8b 00                	mov    (%rax),%eax
ffff8000001043da:	83 e0 40             	and    $0x40,%eax
ffff8000001043dd:	85 c0                	test   %eax,%eax
ffff8000001043df:	74 24                	je     ffff800000104405 <kbdgetc+0x121>
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
ffff8000001043e1:	81 4d fc 80 00 00 00 	orl    $0x80,-0x4(%rbp)
    shift &= ~E0ESC;
ffff8000001043e8:	48 b8 b8 71 11 00 00 	movabs $0xffff8000001171b8,%rax
ffff8000001043ef:	80 ff ff 
ffff8000001043f2:	8b 00                	mov    (%rax),%eax
ffff8000001043f4:	83 e0 bf             	and    $0xffffffbf,%eax
ffff8000001043f7:	89 c2                	mov    %eax,%edx
ffff8000001043f9:	48 b8 b8 71 11 00 00 	movabs $0xffff8000001171b8,%rax
ffff800000104400:	80 ff ff 
ffff800000104403:	89 10                	mov    %edx,(%rax)
  }

  shift |= shiftcode[data];
ffff800000104405:	48 ba 20 d0 10 00 00 	movabs $0xffff80000010d020,%rdx
ffff80000010440c:	80 ff ff 
ffff80000010440f:	8b 45 fc             	mov    -0x4(%rbp),%eax
ffff800000104412:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax
ffff800000104416:	0f b6 d0             	movzbl %al,%edx
ffff800000104419:	48 b8 b8 71 11 00 00 	movabs $0xffff8000001171b8,%rax
ffff800000104420:	80 ff ff 
ffff800000104423:	8b 00                	mov    (%rax),%eax
ffff800000104425:	09 c2                	or     %eax,%edx
ffff800000104427:	48 b8 b8 71 11 00 00 	movabs $0xffff8000001171b8,%rax
ffff80000010442e:	80 ff ff 
ffff800000104431:	89 10                	mov    %edx,(%rax)
  shift ^= togglecode[data];
ffff800000104433:	48 ba 20 d1 10 00 00 	movabs $0xffff80000010d120,%rdx
ffff80000010443a:	80 ff ff 
ffff80000010443d:	8b 45 fc             	mov    -0x4(%rbp),%eax
ffff800000104440:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax
ffff800000104444:	0f b6 d0             	movzbl %al,%edx
ffff800000104447:	48 b8 b8 71 11 00 00 	movabs $0xffff8000001171b8,%rax
ffff80000010444e:	80 ff ff 
ffff800000104451:	8b 00                	mov    (%rax),%eax
ffff800000104453:	31 c2                	xor    %eax,%edx
ffff800000104455:	48 b8 b8 71 11 00 00 	movabs $0xffff8000001171b8,%rax
ffff80000010445c:	80 ff ff 
ffff80000010445f:	89 10                	mov    %edx,(%rax)
  c = charcode[shift & (CTL | SHIFT)][data];
ffff800000104461:	48 b8 b8 71 11 00 00 	movabs $0xffff8000001171b8,%rax
ffff800000104468:	80 ff ff 
ffff80000010446b:	8b 00                	mov    (%rax),%eax
ffff80000010446d:	83 e0 03             	and    $0x3,%eax
ffff800000104470:	89 c2                	mov    %eax,%edx
ffff800000104472:	48 b8 20 d5 10 00 00 	movabs $0xffff80000010d520,%rax
ffff800000104479:	80 ff ff 
ffff80000010447c:	89 d2                	mov    %edx,%edx
ffff80000010447e:	48 8b 14 d0          	mov    (%rax,%rdx,8),%rdx
ffff800000104482:	8b 45 fc             	mov    -0x4(%rbp),%eax
ffff800000104485:	48 01 d0             	add    %rdx,%rax
ffff800000104488:	0f b6 00             	movzbl (%rax),%eax
ffff80000010448b:	0f b6 c0             	movzbl %al,%eax
ffff80000010448e:	89 45 f8             	mov    %eax,-0x8(%rbp)
  if(shift & CAPSLOCK){
ffff800000104491:	48 b8 b8 71 11 00 00 	movabs $0xffff8000001171b8,%rax
ffff800000104498:	80 ff ff 
ffff80000010449b:	8b 00                	mov    (%rax),%eax
ffff80000010449d:	83 e0 08             	and    $0x8,%eax
ffff8000001044a0:	85 c0                	test   %eax,%eax
ffff8000001044a2:	74 22                	je     ffff8000001044c6 <kbdgetc+0x1e2>
    if('a' <= c && c <= 'z')
ffff8000001044a4:	83 7d f8 60          	cmpl   $0x60,-0x8(%rbp)
ffff8000001044a8:	76 0c                	jbe    ffff8000001044b6 <kbdgetc+0x1d2>
ffff8000001044aa:	83 7d f8 7a          	cmpl   $0x7a,-0x8(%rbp)
ffff8000001044ae:	77 06                	ja     ffff8000001044b6 <kbdgetc+0x1d2>
      c += 'A' - 'a';
ffff8000001044b0:	83 6d f8 20          	subl   $0x20,-0x8(%rbp)
ffff8000001044b4:	eb 10                	jmp    ffff8000001044c6 <kbdgetc+0x1e2>
    else if('A' <= c && c <= 'Z')
ffff8000001044b6:	83 7d f8 40          	cmpl   $0x40,-0x8(%rbp)
ffff8000001044ba:	76 0a                	jbe    ffff8000001044c6 <kbdgetc+0x1e2>
ffff8000001044bc:	83 7d f8 5a          	cmpl   $0x5a,-0x8(%rbp)
ffff8000001044c0:	77 04                	ja     ffff8000001044c6 <kbdgetc+0x1e2>
      c += 'a' - 'A';
ffff8000001044c2:	83 45 f8 20          	addl   $0x20,-0x8(%rbp)
  }
  return c;
ffff8000001044c6:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
ffff8000001044c9:	c9                   	leaveq 
ffff8000001044ca:	c3                   	retq   

ffff8000001044cb <kbdintr>:

void
kbdintr(void)
{
ffff8000001044cb:	f3 0f 1e fa          	endbr64 
ffff8000001044cf:	55                   	push   %rbp
ffff8000001044d0:	48 89 e5             	mov    %rsp,%rbp
  consoleintr(kbdgetc);
ffff8000001044d3:	48 bf e4 42 10 00 00 	movabs $0xffff8000001042e4,%rdi
ffff8000001044da:	80 ff ff 
ffff8000001044dd:	48 b8 83 0f 10 00 00 	movabs $0xffff800000100f83,%rax
ffff8000001044e4:	80 ff ff 
ffff8000001044e7:	ff d0                	callq  *%rax
}
ffff8000001044e9:	90                   	nop
ffff8000001044ea:	5d                   	pop    %rbp
ffff8000001044eb:	c3                   	retq   

ffff8000001044ec <inb>:
{
ffff8000001044ec:	f3 0f 1e fa          	endbr64 
ffff8000001044f0:	55                   	push   %rbp
ffff8000001044f1:	48 89 e5             	mov    %rsp,%rbp
ffff8000001044f4:	48 83 ec 18          	sub    $0x18,%rsp
ffff8000001044f8:	89 f8                	mov    %edi,%eax
ffff8000001044fa:	66 89 45 ec          	mov    %ax,-0x14(%rbp)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
ffff8000001044fe:	0f b7 45 ec          	movzwl -0x14(%rbp),%eax
ffff800000104502:	89 c2                	mov    %eax,%edx
ffff800000104504:	ec                   	in     (%dx),%al
ffff800000104505:	88 45 ff             	mov    %al,-0x1(%rbp)
  return data;
ffff800000104508:	0f b6 45 ff          	movzbl -0x1(%rbp),%eax
}
ffff80000010450c:	c9                   	leaveq 
ffff80000010450d:	c3                   	retq   

ffff80000010450e <outb>:
{
ffff80000010450e:	f3 0f 1e fa          	endbr64 
ffff800000104512:	55                   	push   %rbp
ffff800000104513:	48 89 e5             	mov    %rsp,%rbp
ffff800000104516:	48 83 ec 08          	sub    $0x8,%rsp
ffff80000010451a:	89 f8                	mov    %edi,%eax
ffff80000010451c:	89 f2                	mov    %esi,%edx
ffff80000010451e:	66 89 45 fc          	mov    %ax,-0x4(%rbp)
ffff800000104522:	89 d0                	mov    %edx,%eax
ffff800000104524:	88 45 f8             	mov    %al,-0x8(%rbp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
ffff800000104527:	0f b6 45 f8          	movzbl -0x8(%rbp),%eax
ffff80000010452b:	0f b7 55 fc          	movzwl -0x4(%rbp),%edx
ffff80000010452f:	ee                   	out    %al,(%dx)
}
ffff800000104530:	90                   	nop
ffff800000104531:	c9                   	leaveq 
ffff800000104532:	c3                   	retq   

ffff800000104533 <readeflags>:
{
ffff800000104533:	f3 0f 1e fa          	endbr64 
ffff800000104537:	55                   	push   %rbp
ffff800000104538:	48 89 e5             	mov    %rsp,%rbp
ffff80000010453b:	48 83 ec 10          	sub    $0x10,%rsp
  asm volatile("pushf; pop %0" : "=r" (eflags));
ffff80000010453f:	9c                   	pushfq 
ffff800000104540:	58                   	pop    %rax
ffff800000104541:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  return eflags;
ffff800000104545:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
ffff800000104549:	c9                   	leaveq 
ffff80000010454a:	c3                   	retq   

ffff80000010454b <lapicw>:

volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
ffff80000010454b:	f3 0f 1e fa          	endbr64 
ffff80000010454f:	55                   	push   %rbp
ffff800000104550:	48 89 e5             	mov    %rsp,%rbp
ffff800000104553:	48 83 ec 08          	sub    $0x8,%rsp
ffff800000104557:	89 7d fc             	mov    %edi,-0x4(%rbp)
ffff80000010455a:	89 75 f8             	mov    %esi,-0x8(%rbp)
  lapic[index] = value;
ffff80000010455d:	48 b8 c0 71 11 00 00 	movabs $0xffff8000001171c0,%rax
ffff800000104564:	80 ff ff 
ffff800000104567:	48 8b 00             	mov    (%rax),%rax
ffff80000010456a:	8b 55 fc             	mov    -0x4(%rbp),%edx
ffff80000010456d:	48 63 d2             	movslq %edx,%rdx
ffff800000104570:	48 c1 e2 02          	shl    $0x2,%rdx
ffff800000104574:	48 01 c2             	add    %rax,%rdx
ffff800000104577:	8b 45 f8             	mov    -0x8(%rbp),%eax
ffff80000010457a:	89 02                	mov    %eax,(%rdx)
  lapic[ID];  // wait for write to finish, by reading
ffff80000010457c:	48 b8 c0 71 11 00 00 	movabs $0xffff8000001171c0,%rax
ffff800000104583:	80 ff ff 
ffff800000104586:	48 8b 00             	mov    (%rax),%rax
ffff800000104589:	48 83 c0 20          	add    $0x20,%rax
ffff80000010458d:	8b 00                	mov    (%rax),%eax
}
ffff80000010458f:	90                   	nop
ffff800000104590:	c9                   	leaveq 
ffff800000104591:	c3                   	retq   

ffff800000104592 <lapicinit>:

void
lapicinit(void)
{
ffff800000104592:	f3 0f 1e fa          	endbr64 
ffff800000104596:	55                   	push   %rbp
ffff800000104597:	48 89 e5             	mov    %rsp,%rbp
  if(!lapic)
ffff80000010459a:	48 b8 c0 71 11 00 00 	movabs $0xffff8000001171c0,%rax
ffff8000001045a1:	80 ff ff 
ffff8000001045a4:	48 8b 00             	mov    (%rax),%rax
ffff8000001045a7:	48 85 c0             	test   %rax,%rax
ffff8000001045aa:	0f 84 74 01 00 00    	je     ffff800000104724 <lapicinit+0x192>
    return;

  // Enable local APIC; set spurious interrupt vector.
  lapicw(SVR, ENABLE | (T_IRQ0 + IRQ_SPURIOUS));
ffff8000001045b0:	be 3f 01 00 00       	mov    $0x13f,%esi
ffff8000001045b5:	bf 3c 00 00 00       	mov    $0x3c,%edi
ffff8000001045ba:	48 b8 4b 45 10 00 00 	movabs $0xffff80000010454b,%rax
ffff8000001045c1:	80 ff ff 
ffff8000001045c4:	ff d0                	callq  *%rax

  // The timer repeatedly counts down at bus frequency
  // from lapic[TICR] and then issues an interrupt.
  // If xv6 cared more about precise timekeeping,
  // TICR would be calibrated using an external time source.
  lapicw(TDCR, X1);
ffff8000001045c6:	be 0b 00 00 00       	mov    $0xb,%esi
ffff8000001045cb:	bf f8 00 00 00       	mov    $0xf8,%edi
ffff8000001045d0:	48 b8 4b 45 10 00 00 	movabs $0xffff80000010454b,%rax
ffff8000001045d7:	80 ff ff 
ffff8000001045da:	ff d0                	callq  *%rax
  lapicw(TIMER, PERIODIC | (T_IRQ0 + IRQ_TIMER));
ffff8000001045dc:	be 20 00 02 00       	mov    $0x20020,%esi
ffff8000001045e1:	bf c8 00 00 00       	mov    $0xc8,%edi
ffff8000001045e6:	48 b8 4b 45 10 00 00 	movabs $0xffff80000010454b,%rax
ffff8000001045ed:	80 ff ff 
ffff8000001045f0:	ff d0                	callq  *%rax
  lapicw(TICR, 10000000);
ffff8000001045f2:	be 80 96 98 00       	mov    $0x989680,%esi
ffff8000001045f7:	bf e0 00 00 00       	mov    $0xe0,%edi
ffff8000001045fc:	48 b8 4b 45 10 00 00 	movabs $0xffff80000010454b,%rax
ffff800000104603:	80 ff ff 
ffff800000104606:	ff d0                	callq  *%rax

  // Disable logical interrupt lines.
  lapicw(LINT0, MASKED);
ffff800000104608:	be 00 00 01 00       	mov    $0x10000,%esi
ffff80000010460d:	bf d4 00 00 00       	mov    $0xd4,%edi
ffff800000104612:	48 b8 4b 45 10 00 00 	movabs $0xffff80000010454b,%rax
ffff800000104619:	80 ff ff 
ffff80000010461c:	ff d0                	callq  *%rax
  lapicw(LINT1, MASKED);
ffff80000010461e:	be 00 00 01 00       	mov    $0x10000,%esi
ffff800000104623:	bf d8 00 00 00       	mov    $0xd8,%edi
ffff800000104628:	48 b8 4b 45 10 00 00 	movabs $0xffff80000010454b,%rax
ffff80000010462f:	80 ff ff 
ffff800000104632:	ff d0                	callq  *%rax

  // Disable performance counter overflow interrupts
  // on machines that provide that interrupt entry.
  if(((lapic[VER]>>16) & 0xFF) >= 4)
ffff800000104634:	48 b8 c0 71 11 00 00 	movabs $0xffff8000001171c0,%rax
ffff80000010463b:	80 ff ff 
ffff80000010463e:	48 8b 00             	mov    (%rax),%rax
ffff800000104641:	48 83 c0 30          	add    $0x30,%rax
ffff800000104645:	8b 00                	mov    (%rax),%eax
ffff800000104647:	c1 e8 10             	shr    $0x10,%eax
ffff80000010464a:	25 fc 00 00 00       	and    $0xfc,%eax
ffff80000010464f:	85 c0                	test   %eax,%eax
ffff800000104651:	74 16                	je     ffff800000104669 <lapicinit+0xd7>
    lapicw(PCINT, MASKED);
ffff800000104653:	be 00 00 01 00       	mov    $0x10000,%esi
ffff800000104658:	bf d0 00 00 00       	mov    $0xd0,%edi
ffff80000010465d:	48 b8 4b 45 10 00 00 	movabs $0xffff80000010454b,%rax
ffff800000104664:	80 ff ff 
ffff800000104667:	ff d0                	callq  *%rax

  // Map error interrupt to IRQ_ERROR.
  lapicw(ERROR, T_IRQ0 + IRQ_ERROR);
ffff800000104669:	be 33 00 00 00       	mov    $0x33,%esi
ffff80000010466e:	bf dc 00 00 00       	mov    $0xdc,%edi
ffff800000104673:	48 b8 4b 45 10 00 00 	movabs $0xffff80000010454b,%rax
ffff80000010467a:	80 ff ff 
ffff80000010467d:	ff d0                	callq  *%rax

  // Clear error status register (requires back-to-back writes).
  lapicw(ESR, 0);
ffff80000010467f:	be 00 00 00 00       	mov    $0x0,%esi
ffff800000104684:	bf a0 00 00 00       	mov    $0xa0,%edi
ffff800000104689:	48 b8 4b 45 10 00 00 	movabs $0xffff80000010454b,%rax
ffff800000104690:	80 ff ff 
ffff800000104693:	ff d0                	callq  *%rax
  lapicw(ESR, 0);
ffff800000104695:	be 00 00 00 00       	mov    $0x0,%esi
ffff80000010469a:	bf a0 00 00 00       	mov    $0xa0,%edi
ffff80000010469f:	48 b8 4b 45 10 00 00 	movabs $0xffff80000010454b,%rax
ffff8000001046a6:	80 ff ff 
ffff8000001046a9:	ff d0                	callq  *%rax

  // Ack any outstanding interrupts.
  lapicw(EOI, 0);
ffff8000001046ab:	be 00 00 00 00       	mov    $0x0,%esi
ffff8000001046b0:	bf 2c 00 00 00       	mov    $0x2c,%edi
ffff8000001046b5:	48 b8 4b 45 10 00 00 	movabs $0xffff80000010454b,%rax
ffff8000001046bc:	80 ff ff 
ffff8000001046bf:	ff d0                	callq  *%rax

  // Send an Init Level De-Assert to synchronise arbitration ID's.
  lapicw(ICRHI, 0);
ffff8000001046c1:	be 00 00 00 00       	mov    $0x0,%esi
ffff8000001046c6:	bf c4 00 00 00       	mov    $0xc4,%edi
ffff8000001046cb:	48 b8 4b 45 10 00 00 	movabs $0xffff80000010454b,%rax
ffff8000001046d2:	80 ff ff 
ffff8000001046d5:	ff d0                	callq  *%rax
  lapicw(ICRLO, BCAST | INIT | LEVEL);
ffff8000001046d7:	be 00 85 08 00       	mov    $0x88500,%esi
ffff8000001046dc:	bf c0 00 00 00       	mov    $0xc0,%edi
ffff8000001046e1:	48 b8 4b 45 10 00 00 	movabs $0xffff80000010454b,%rax
ffff8000001046e8:	80 ff ff 
ffff8000001046eb:	ff d0                	callq  *%rax
  while(lapic[ICRLO] & DELIVS)
ffff8000001046ed:	90                   	nop
ffff8000001046ee:	48 b8 c0 71 11 00 00 	movabs $0xffff8000001171c0,%rax
ffff8000001046f5:	80 ff ff 
ffff8000001046f8:	48 8b 00             	mov    (%rax),%rax
ffff8000001046fb:	48 05 00 03 00 00    	add    $0x300,%rax
ffff800000104701:	8b 00                	mov    (%rax),%eax
ffff800000104703:	25 00 10 00 00       	and    $0x1000,%eax
ffff800000104708:	85 c0                	test   %eax,%eax
ffff80000010470a:	75 e2                	jne    ffff8000001046ee <lapicinit+0x15c>
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
ffff80000010470c:	be 00 00 00 00       	mov    $0x0,%esi
ffff800000104711:	bf 20 00 00 00       	mov    $0x20,%edi
ffff800000104716:	48 b8 4b 45 10 00 00 	movabs $0xffff80000010454b,%rax
ffff80000010471d:	80 ff ff 
ffff800000104720:	ff d0                	callq  *%rax
ffff800000104722:	eb 01                	jmp    ffff800000104725 <lapicinit+0x193>
    return;
ffff800000104724:	90                   	nop
}
ffff800000104725:	5d                   	pop    %rbp
ffff800000104726:	c3                   	retq   

ffff800000104727 <cpunum>:

int
cpunum(void)
{
ffff800000104727:	f3 0f 1e fa          	endbr64 
ffff80000010472b:	55                   	push   %rbp
ffff80000010472c:	48 89 e5             	mov    %rsp,%rbp
ffff80000010472f:	48 83 ec 10          	sub    $0x10,%rsp
  // Cannot call cpu when interrupts are enabled:
  // result not guaranteed to last long enough to be used!
  // Would prefer to panic but even printing is chancy here:
  // almost everything, including cprintf and panic, calls cpu,
  // often indirectly through acquire and release.
  if(readeflags()&FL_IF){
ffff800000104733:	48 b8 33 45 10 00 00 	movabs $0xffff800000104533,%rax
ffff80000010473a:	80 ff ff 
ffff80000010473d:	ff d0                	callq  *%rax
ffff80000010473f:	25 00 02 00 00       	and    $0x200,%eax
ffff800000104744:	48 85 c0             	test   %rax,%rax
ffff800000104747:	74 41                	je     ffff80000010478a <cpunum+0x63>
    static int n;
    if(n++ == 0)
ffff800000104749:	48 b8 c8 71 11 00 00 	movabs $0xffff8000001171c8,%rax
ffff800000104750:	80 ff ff 
ffff800000104753:	8b 00                	mov    (%rax),%eax
ffff800000104755:	8d 50 01             	lea    0x1(%rax),%edx
ffff800000104758:	48 b9 c8 71 11 00 00 	movabs $0xffff8000001171c8,%rcx
ffff80000010475f:	80 ff ff 
ffff800000104762:	89 11                	mov    %edx,(%rcx)
ffff800000104764:	85 c0                	test   %eax,%eax
ffff800000104766:	75 22                	jne    ffff80000010478a <cpunum+0x63>
      cprintf("cpu called from %x with interrupts enabled\n",
ffff800000104768:	48 8b 45 08          	mov    0x8(%rbp),%rax
ffff80000010476c:	48 89 c6             	mov    %rax,%rsi
ffff80000010476f:	48 bf c8 c9 10 00 00 	movabs $0xffff80000010c9c8,%rdi
ffff800000104776:	80 ff ff 
ffff800000104779:	b8 00 00 00 00       	mov    $0x0,%eax
ffff80000010477e:	48 ba 18 08 10 00 00 	movabs $0xffff800000100818,%rdx
ffff800000104785:	80 ff ff 
ffff800000104788:	ff d2                	callq  *%rdx
        __builtin_return_address(0));
  }

  if (!lapic)
ffff80000010478a:	48 b8 c0 71 11 00 00 	movabs $0xffff8000001171c0,%rax
ffff800000104791:	80 ff ff 
ffff800000104794:	48 8b 00             	mov    (%rax),%rax
ffff800000104797:	48 85 c0             	test   %rax,%rax
ffff80000010479a:	75 0a                	jne    ffff8000001047a6 <cpunum+0x7f>
    return 0;
ffff80000010479c:	b8 00 00 00 00       	mov    $0x0,%eax
ffff8000001047a1:	e9 82 00 00 00       	jmpq   ffff800000104828 <cpunum+0x101>

  apicid = lapic[ID] >> 24;
ffff8000001047a6:	48 b8 c0 71 11 00 00 	movabs $0xffff8000001171c0,%rax
ffff8000001047ad:	80 ff ff 
ffff8000001047b0:	48 8b 00             	mov    (%rax),%rax
ffff8000001047b3:	48 83 c0 20          	add    $0x20,%rax
ffff8000001047b7:	8b 00                	mov    (%rax),%eax
ffff8000001047b9:	c1 e8 18             	shr    $0x18,%eax
ffff8000001047bc:	89 45 f8             	mov    %eax,-0x8(%rbp)
  for (i = 0; i < ncpu; ++i) {
ffff8000001047bf:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
ffff8000001047c6:	eb 39                	jmp    ffff800000104801 <cpunum+0xda>
    if (cpus[i].apicid == apicid)
ffff8000001047c8:	48 b9 e0 72 11 00 00 	movabs $0xffff8000001172e0,%rcx
ffff8000001047cf:	80 ff ff 
ffff8000001047d2:	8b 45 fc             	mov    -0x4(%rbp),%eax
ffff8000001047d5:	48 63 d0             	movslq %eax,%rdx
ffff8000001047d8:	48 89 d0             	mov    %rdx,%rax
ffff8000001047db:	48 c1 e0 02          	shl    $0x2,%rax
ffff8000001047df:	48 01 d0             	add    %rdx,%rax
ffff8000001047e2:	48 c1 e0 03          	shl    $0x3,%rax
ffff8000001047e6:	48 01 c8             	add    %rcx,%rax
ffff8000001047e9:	48 83 c0 01          	add    $0x1,%rax
ffff8000001047ed:	0f b6 00             	movzbl (%rax),%eax
ffff8000001047f0:	0f b6 c0             	movzbl %al,%eax
ffff8000001047f3:	39 45 f8             	cmp    %eax,-0x8(%rbp)
ffff8000001047f6:	75 05                	jne    ffff8000001047fd <cpunum+0xd6>
      return i;
ffff8000001047f8:	8b 45 fc             	mov    -0x4(%rbp),%eax
ffff8000001047fb:	eb 2b                	jmp    ffff800000104828 <cpunum+0x101>
  for (i = 0; i < ncpu; ++i) {
ffff8000001047fd:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
ffff800000104801:	48 b8 20 74 11 00 00 	movabs $0xffff800000117420,%rax
ffff800000104808:	80 ff ff 
ffff80000010480b:	8b 00                	mov    (%rax),%eax
ffff80000010480d:	39 45 fc             	cmp    %eax,-0x4(%rbp)
ffff800000104810:	7c b6                	jl     ffff8000001047c8 <cpunum+0xa1>
  }
  panic("unknown apicid\n");
ffff800000104812:	48 bf f4 c9 10 00 00 	movabs $0xffff80000010c9f4,%rdi
ffff800000104819:	80 ff ff 
ffff80000010481c:	48 b8 f9 0b 10 00 00 	movabs $0xffff800000100bf9,%rax
ffff800000104823:	80 ff ff 
ffff800000104826:	ff d0                	callq  *%rax
}
ffff800000104828:	c9                   	leaveq 
ffff800000104829:	c3                   	retq   

ffff80000010482a <lapiceoi>:

// Acknowledge interrupt.
void
lapiceoi(void)
{
ffff80000010482a:	f3 0f 1e fa          	endbr64 
ffff80000010482e:	55                   	push   %rbp
ffff80000010482f:	48 89 e5             	mov    %rsp,%rbp
  if(lapic)
ffff800000104832:	48 b8 c0 71 11 00 00 	movabs $0xffff8000001171c0,%rax
ffff800000104839:	80 ff ff 
ffff80000010483c:	48 8b 00             	mov    (%rax),%rax
ffff80000010483f:	48 85 c0             	test   %rax,%rax
ffff800000104842:	74 16                	je     ffff80000010485a <lapiceoi+0x30>
    lapicw(EOI, 0);
ffff800000104844:	be 00 00 00 00       	mov    $0x0,%esi
ffff800000104849:	bf 2c 00 00 00       	mov    $0x2c,%edi
ffff80000010484e:	48 b8 4b 45 10 00 00 	movabs $0xffff80000010454b,%rax
ffff800000104855:	80 ff ff 
ffff800000104858:	ff d0                	callq  *%rax
}
ffff80000010485a:	90                   	nop
ffff80000010485b:	5d                   	pop    %rbp
ffff80000010485c:	c3                   	retq   

ffff80000010485d <microdelay>:

// Spin for a given number of microseconds.
// On real hardware would want to tune this dynamically.
void
microdelay(int us)
{
ffff80000010485d:	f3 0f 1e fa          	endbr64 
ffff800000104861:	55                   	push   %rbp
ffff800000104862:	48 89 e5             	mov    %rsp,%rbp
ffff800000104865:	48 83 ec 08          	sub    $0x8,%rsp
ffff800000104869:	89 7d fc             	mov    %edi,-0x4(%rbp)
}
ffff80000010486c:	90                   	nop
ffff80000010486d:	c9                   	leaveq 
ffff80000010486e:	c3                   	retq   

ffff80000010486f <lapicstartap>:

// Start additional processor running entry code at addr.
// See Appendix B of MultiProcessor Specification.
void
lapicstartap(uchar apicid, uint addr)
{
ffff80000010486f:	f3 0f 1e fa          	endbr64 
ffff800000104873:	55                   	push   %rbp
ffff800000104874:	48 89 e5             	mov    %rsp,%rbp
ffff800000104877:	48 83 ec 18          	sub    $0x18,%rsp
ffff80000010487b:	89 f8                	mov    %edi,%eax
ffff80000010487d:	89 75 e8             	mov    %esi,-0x18(%rbp)
ffff800000104880:	88 45 ec             	mov    %al,-0x14(%rbp)
  ushort *wrv;

  // "The BSP must initialize CMOS shutdown code to 0AH
  // and the warm reset vector (DWORD based at 40:67) to point at
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
ffff800000104883:	be 0f 00 00 00       	mov    $0xf,%esi
ffff800000104888:	bf 70 00 00 00       	mov    $0x70,%edi
ffff80000010488d:	48 b8 0e 45 10 00 00 	movabs $0xffff80000010450e,%rax
ffff800000104894:	80 ff ff 
ffff800000104897:	ff d0                	callq  *%rax
  outb(CMOS_PORT+1, 0x0A);
ffff800000104899:	be 0a 00 00 00       	mov    $0xa,%esi
ffff80000010489e:	bf 71 00 00 00       	mov    $0x71,%edi
ffff8000001048a3:	48 b8 0e 45 10 00 00 	movabs $0xffff80000010450e,%rax
ffff8000001048aa:	80 ff ff 
ffff8000001048ad:	ff d0                	callq  *%rax
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
ffff8000001048af:	48 b8 67 04 00 00 00 	movabs $0xffff800000000467,%rax
ffff8000001048b6:	80 ff ff 
ffff8000001048b9:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
  wrv[0] = 0;
ffff8000001048bd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff8000001048c1:	66 c7 00 00 00       	movw   $0x0,(%rax)
  wrv[1] = addr >> 4;
ffff8000001048c6:	8b 45 e8             	mov    -0x18(%rbp),%eax
ffff8000001048c9:	c1 e8 04             	shr    $0x4,%eax
ffff8000001048cc:	89 c2                	mov    %eax,%edx
ffff8000001048ce:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff8000001048d2:	48 83 c0 02          	add    $0x2,%rax
ffff8000001048d6:	66 89 10             	mov    %dx,(%rax)

  // "Universal startup algorithm."
  // Send INIT (level-triggered) interrupt to reset other CPU.
  lapicw(ICRHI, apicid<<24);
ffff8000001048d9:	0f b6 45 ec          	movzbl -0x14(%rbp),%eax
ffff8000001048dd:	c1 e0 18             	shl    $0x18,%eax
ffff8000001048e0:	89 c6                	mov    %eax,%esi
ffff8000001048e2:	bf c4 00 00 00       	mov    $0xc4,%edi
ffff8000001048e7:	48 b8 4b 45 10 00 00 	movabs $0xffff80000010454b,%rax
ffff8000001048ee:	80 ff ff 
ffff8000001048f1:	ff d0                	callq  *%rax
  lapicw(ICRLO, INIT | LEVEL | ASSERT);
ffff8000001048f3:	be 00 c5 00 00       	mov    $0xc500,%esi
ffff8000001048f8:	bf c0 00 00 00       	mov    $0xc0,%edi
ffff8000001048fd:	48 b8 4b 45 10 00 00 	movabs $0xffff80000010454b,%rax
ffff800000104904:	80 ff ff 
ffff800000104907:	ff d0                	callq  *%rax
  microdelay(200);
ffff800000104909:	bf c8 00 00 00       	mov    $0xc8,%edi
ffff80000010490e:	48 b8 5d 48 10 00 00 	movabs $0xffff80000010485d,%rax
ffff800000104915:	80 ff ff 
ffff800000104918:	ff d0                	callq  *%rax
  lapicw(ICRLO, INIT | LEVEL);
ffff80000010491a:	be 00 85 00 00       	mov    $0x8500,%esi
ffff80000010491f:	bf c0 00 00 00       	mov    $0xc0,%edi
ffff800000104924:	48 b8 4b 45 10 00 00 	movabs $0xffff80000010454b,%rax
ffff80000010492b:	80 ff ff 
ffff80000010492e:	ff d0                	callq  *%rax
  microdelay(100);    // should be 10ms, but too slow in Bochs!
ffff800000104930:	bf 64 00 00 00       	mov    $0x64,%edi
ffff800000104935:	48 b8 5d 48 10 00 00 	movabs $0xffff80000010485d,%rax
ffff80000010493c:	80 ff ff 
ffff80000010493f:	ff d0                	callq  *%rax
  // Send startup IPI (twice!) to enter code.
  // Regular hardware is supposed to only accept a STARTUP
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
ffff800000104941:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
ffff800000104948:	eb 4b                	jmp    ffff800000104995 <lapicstartap+0x126>
    lapicw(ICRHI, apicid<<24);
ffff80000010494a:	0f b6 45 ec          	movzbl -0x14(%rbp),%eax
ffff80000010494e:	c1 e0 18             	shl    $0x18,%eax
ffff800000104951:	89 c6                	mov    %eax,%esi
ffff800000104953:	bf c4 00 00 00       	mov    $0xc4,%edi
ffff800000104958:	48 b8 4b 45 10 00 00 	movabs $0xffff80000010454b,%rax
ffff80000010495f:	80 ff ff 
ffff800000104962:	ff d0                	callq  *%rax
    lapicw(ICRLO, STARTUP | (addr>>12));
ffff800000104964:	8b 45 e8             	mov    -0x18(%rbp),%eax
ffff800000104967:	c1 e8 0c             	shr    $0xc,%eax
ffff80000010496a:	80 cc 06             	or     $0x6,%ah
ffff80000010496d:	89 c6                	mov    %eax,%esi
ffff80000010496f:	bf c0 00 00 00       	mov    $0xc0,%edi
ffff800000104974:	48 b8 4b 45 10 00 00 	movabs $0xffff80000010454b,%rax
ffff80000010497b:	80 ff ff 
ffff80000010497e:	ff d0                	callq  *%rax
    microdelay(200);
ffff800000104980:	bf c8 00 00 00       	mov    $0xc8,%edi
ffff800000104985:	48 b8 5d 48 10 00 00 	movabs $0xffff80000010485d,%rax
ffff80000010498c:	80 ff ff 
ffff80000010498f:	ff d0                	callq  *%rax
  for(i = 0; i < 2; i++){
ffff800000104991:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
ffff800000104995:	83 7d fc 01          	cmpl   $0x1,-0x4(%rbp)
ffff800000104999:	7e af                	jle    ffff80000010494a <lapicstartap+0xdb>
  }
}
ffff80000010499b:	90                   	nop
ffff80000010499c:	90                   	nop
ffff80000010499d:	c9                   	leaveq 
ffff80000010499e:	c3                   	retq   

ffff80000010499f <cmos_read>:
#define DAY     0x07
#define MONTH   0x08
#define YEAR    0x09

static uint cmos_read(uint reg)
{
ffff80000010499f:	f3 0f 1e fa          	endbr64 
ffff8000001049a3:	55                   	push   %rbp
ffff8000001049a4:	48 89 e5             	mov    %rsp,%rbp
ffff8000001049a7:	48 83 ec 08          	sub    $0x8,%rsp
ffff8000001049ab:	89 7d fc             	mov    %edi,-0x4(%rbp)
  outb(CMOS_PORT,  reg);
ffff8000001049ae:	8b 45 fc             	mov    -0x4(%rbp),%eax
ffff8000001049b1:	0f b6 c0             	movzbl %al,%eax
ffff8000001049b4:	89 c6                	mov    %eax,%esi
ffff8000001049b6:	bf 70 00 00 00       	mov    $0x70,%edi
ffff8000001049bb:	48 b8 0e 45 10 00 00 	movabs $0xffff80000010450e,%rax
ffff8000001049c2:	80 ff ff 
ffff8000001049c5:	ff d0                	callq  *%rax
  microdelay(200);
ffff8000001049c7:	bf c8 00 00 00       	mov    $0xc8,%edi
ffff8000001049cc:	48 b8 5d 48 10 00 00 	movabs $0xffff80000010485d,%rax
ffff8000001049d3:	80 ff ff 
ffff8000001049d6:	ff d0                	callq  *%rax

  return inb(CMOS_RETURN);
ffff8000001049d8:	bf 71 00 00 00       	mov    $0x71,%edi
ffff8000001049dd:	48 b8 ec 44 10 00 00 	movabs $0xffff8000001044ec,%rax
ffff8000001049e4:	80 ff ff 
ffff8000001049e7:	ff d0                	callq  *%rax
ffff8000001049e9:	0f b6 c0             	movzbl %al,%eax
}
ffff8000001049ec:	c9                   	leaveq 
ffff8000001049ed:	c3                   	retq   

ffff8000001049ee <fill_rtcdate>:

static void fill_rtcdate(struct rtcdate *r)
{
ffff8000001049ee:	f3 0f 1e fa          	endbr64 
ffff8000001049f2:	55                   	push   %rbp
ffff8000001049f3:	48 89 e5             	mov    %rsp,%rbp
ffff8000001049f6:	48 83 ec 08          	sub    $0x8,%rsp
ffff8000001049fa:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  r->second = cmos_read(SECS);
ffff8000001049fe:	bf 00 00 00 00       	mov    $0x0,%edi
ffff800000104a03:	48 b8 9f 49 10 00 00 	movabs $0xffff80000010499f,%rax
ffff800000104a0a:	80 ff ff 
ffff800000104a0d:	ff d0                	callq  *%rax
ffff800000104a0f:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
ffff800000104a13:	89 02                	mov    %eax,(%rdx)
  r->minute = cmos_read(MINS);
ffff800000104a15:	bf 02 00 00 00       	mov    $0x2,%edi
ffff800000104a1a:	48 b8 9f 49 10 00 00 	movabs $0xffff80000010499f,%rax
ffff800000104a21:	80 ff ff 
ffff800000104a24:	ff d0                	callq  *%rax
ffff800000104a26:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
ffff800000104a2a:	89 42 04             	mov    %eax,0x4(%rdx)
  r->hour   = cmos_read(HOURS);
ffff800000104a2d:	bf 04 00 00 00       	mov    $0x4,%edi
ffff800000104a32:	48 b8 9f 49 10 00 00 	movabs $0xffff80000010499f,%rax
ffff800000104a39:	80 ff ff 
ffff800000104a3c:	ff d0                	callq  *%rax
ffff800000104a3e:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
ffff800000104a42:	89 42 08             	mov    %eax,0x8(%rdx)
  r->day    = cmos_read(DAY);
ffff800000104a45:	bf 07 00 00 00       	mov    $0x7,%edi
ffff800000104a4a:	48 b8 9f 49 10 00 00 	movabs $0xffff80000010499f,%rax
ffff800000104a51:	80 ff ff 
ffff800000104a54:	ff d0                	callq  *%rax
ffff800000104a56:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
ffff800000104a5a:	89 42 0c             	mov    %eax,0xc(%rdx)
  r->month  = cmos_read(MONTH);
ffff800000104a5d:	bf 08 00 00 00       	mov    $0x8,%edi
ffff800000104a62:	48 b8 9f 49 10 00 00 	movabs $0xffff80000010499f,%rax
ffff800000104a69:	80 ff ff 
ffff800000104a6c:	ff d0                	callq  *%rax
ffff800000104a6e:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
ffff800000104a72:	89 42 10             	mov    %eax,0x10(%rdx)
  r->year   = cmos_read(YEAR);
ffff800000104a75:	bf 09 00 00 00       	mov    $0x9,%edi
ffff800000104a7a:	48 b8 9f 49 10 00 00 	movabs $0xffff80000010499f,%rax
ffff800000104a81:	80 ff ff 
ffff800000104a84:	ff d0                	callq  *%rax
ffff800000104a86:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
ffff800000104a8a:	89 42 14             	mov    %eax,0x14(%rdx)
}
ffff800000104a8d:	90                   	nop
ffff800000104a8e:	c9                   	leaveq 
ffff800000104a8f:	c3                   	retq   

ffff800000104a90 <cmostime>:
//PAGEBREAK!

// qemu seems to use 24-hour GWT and the values are BCD encoded
void cmostime(struct rtcdate *r)
{
ffff800000104a90:	f3 0f 1e fa          	endbr64 
ffff800000104a94:	55                   	push   %rbp
ffff800000104a95:	48 89 e5             	mov    %rsp,%rbp
ffff800000104a98:	48 83 ec 50          	sub    $0x50,%rsp
ffff800000104a9c:	48 89 7d b8          	mov    %rdi,-0x48(%rbp)
  struct rtcdate t1, t2;
  int sb, bcd;

  sb = cmos_read(CMOS_STATB);
ffff800000104aa0:	bf 0b 00 00 00       	mov    $0xb,%edi
ffff800000104aa5:	48 b8 9f 49 10 00 00 	movabs $0xffff80000010499f,%rax
ffff800000104aac:	80 ff ff 
ffff800000104aaf:	ff d0                	callq  *%rax
ffff800000104ab1:	89 45 fc             	mov    %eax,-0x4(%rbp)

  bcd = (sb & (1 << 2)) == 0;
ffff800000104ab4:	8b 45 fc             	mov    -0x4(%rbp),%eax
ffff800000104ab7:	83 e0 04             	and    $0x4,%eax
ffff800000104aba:	85 c0                	test   %eax,%eax
ffff800000104abc:	0f 94 c0             	sete   %al
ffff800000104abf:	0f b6 c0             	movzbl %al,%eax
ffff800000104ac2:	89 45 f8             	mov    %eax,-0x8(%rbp)

  // make sure CMOS doesn't modify time while we read it
  for(;;) {
    fill_rtcdate(&t1);
ffff800000104ac5:	48 8d 45 e0          	lea    -0x20(%rbp),%rax
ffff800000104ac9:	48 89 c7             	mov    %rax,%rdi
ffff800000104acc:	48 b8 ee 49 10 00 00 	movabs $0xffff8000001049ee,%rax
ffff800000104ad3:	80 ff ff 
ffff800000104ad6:	ff d0                	callq  *%rax
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
ffff800000104ad8:	bf 0a 00 00 00       	mov    $0xa,%edi
ffff800000104add:	48 b8 9f 49 10 00 00 	movabs $0xffff80000010499f,%rax
ffff800000104ae4:	80 ff ff 
ffff800000104ae7:	ff d0                	callq  *%rax
ffff800000104ae9:	25 80 00 00 00       	and    $0x80,%eax
ffff800000104aee:	85 c0                	test   %eax,%eax
ffff800000104af0:	75 38                	jne    ffff800000104b2a <cmostime+0x9a>
        continue;
    fill_rtcdate(&t2);
ffff800000104af2:	48 8d 45 c0          	lea    -0x40(%rbp),%rax
ffff800000104af6:	48 89 c7             	mov    %rax,%rdi
ffff800000104af9:	48 b8 ee 49 10 00 00 	movabs $0xffff8000001049ee,%rax
ffff800000104b00:	80 ff ff 
ffff800000104b03:	ff d0                	callq  *%rax
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
ffff800000104b05:	48 8d 4d c0          	lea    -0x40(%rbp),%rcx
ffff800000104b09:	48 8d 45 e0          	lea    -0x20(%rbp),%rax
ffff800000104b0d:	ba 18 00 00 00       	mov    $0x18,%edx
ffff800000104b12:	48 89 ce             	mov    %rcx,%rsi
ffff800000104b15:	48 89 c7             	mov    %rax,%rdi
ffff800000104b18:	48 b8 57 83 10 00 00 	movabs $0xffff800000108357,%rax
ffff800000104b1f:	80 ff ff 
ffff800000104b22:	ff d0                	callq  *%rax
ffff800000104b24:	85 c0                	test   %eax,%eax
ffff800000104b26:	74 05                	je     ffff800000104b2d <cmostime+0x9d>
ffff800000104b28:	eb 9b                	jmp    ffff800000104ac5 <cmostime+0x35>
        continue;
ffff800000104b2a:	90                   	nop
    fill_rtcdate(&t1);
ffff800000104b2b:	eb 98                	jmp    ffff800000104ac5 <cmostime+0x35>
      break;
ffff800000104b2d:	90                   	nop
  }

  // convert
  if(bcd) {
ffff800000104b2e:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
ffff800000104b32:	0f 84 b4 00 00 00    	je     ffff800000104bec <cmostime+0x15c>
#define    CONV(x)     (t1.x = ((t1.x >> 4) * 10) + (t1.x & 0xf))
    CONV(second);
ffff800000104b38:	8b 45 e0             	mov    -0x20(%rbp),%eax
ffff800000104b3b:	c1 e8 04             	shr    $0x4,%eax
ffff800000104b3e:	89 c2                	mov    %eax,%edx
ffff800000104b40:	89 d0                	mov    %edx,%eax
ffff800000104b42:	c1 e0 02             	shl    $0x2,%eax
ffff800000104b45:	01 d0                	add    %edx,%eax
ffff800000104b47:	01 c0                	add    %eax,%eax
ffff800000104b49:	89 c2                	mov    %eax,%edx
ffff800000104b4b:	8b 45 e0             	mov    -0x20(%rbp),%eax
ffff800000104b4e:	83 e0 0f             	and    $0xf,%eax
ffff800000104b51:	01 d0                	add    %edx,%eax
ffff800000104b53:	89 45 e0             	mov    %eax,-0x20(%rbp)
    CONV(minute);
ffff800000104b56:	8b 45 e4             	mov    -0x1c(%rbp),%eax
ffff800000104b59:	c1 e8 04             	shr    $0x4,%eax
ffff800000104b5c:	89 c2                	mov    %eax,%edx
ffff800000104b5e:	89 d0                	mov    %edx,%eax
ffff800000104b60:	c1 e0 02             	shl    $0x2,%eax
ffff800000104b63:	01 d0                	add    %edx,%eax
ffff800000104b65:	01 c0                	add    %eax,%eax
ffff800000104b67:	89 c2                	mov    %eax,%edx
ffff800000104b69:	8b 45 e4             	mov    -0x1c(%rbp),%eax
ffff800000104b6c:	83 e0 0f             	and    $0xf,%eax
ffff800000104b6f:	01 d0                	add    %edx,%eax
ffff800000104b71:	89 45 e4             	mov    %eax,-0x1c(%rbp)
    CONV(hour  );
ffff800000104b74:	8b 45 e8             	mov    -0x18(%rbp),%eax
ffff800000104b77:	c1 e8 04             	shr    $0x4,%eax
ffff800000104b7a:	89 c2                	mov    %eax,%edx
ffff800000104b7c:	89 d0                	mov    %edx,%eax
ffff800000104b7e:	c1 e0 02             	shl    $0x2,%eax
ffff800000104b81:	01 d0                	add    %edx,%eax
ffff800000104b83:	01 c0                	add    %eax,%eax
ffff800000104b85:	89 c2                	mov    %eax,%edx
ffff800000104b87:	8b 45 e8             	mov    -0x18(%rbp),%eax
ffff800000104b8a:	83 e0 0f             	and    $0xf,%eax
ffff800000104b8d:	01 d0                	add    %edx,%eax
ffff800000104b8f:	89 45 e8             	mov    %eax,-0x18(%rbp)
    CONV(day   );
ffff800000104b92:	8b 45 ec             	mov    -0x14(%rbp),%eax
ffff800000104b95:	c1 e8 04             	shr    $0x4,%eax
ffff800000104b98:	89 c2                	mov    %eax,%edx
ffff800000104b9a:	89 d0                	mov    %edx,%eax
ffff800000104b9c:	c1 e0 02             	shl    $0x2,%eax
ffff800000104b9f:	01 d0                	add    %edx,%eax
ffff800000104ba1:	01 c0                	add    %eax,%eax
ffff800000104ba3:	89 c2                	mov    %eax,%edx
ffff800000104ba5:	8b 45 ec             	mov    -0x14(%rbp),%eax
ffff800000104ba8:	83 e0 0f             	and    $0xf,%eax
ffff800000104bab:	01 d0                	add    %edx,%eax
ffff800000104bad:	89 45 ec             	mov    %eax,-0x14(%rbp)
    CONV(month );
ffff800000104bb0:	8b 45 f0             	mov    -0x10(%rbp),%eax
ffff800000104bb3:	c1 e8 04             	shr    $0x4,%eax
ffff800000104bb6:	89 c2                	mov    %eax,%edx
ffff800000104bb8:	89 d0                	mov    %edx,%eax
ffff800000104bba:	c1 e0 02             	shl    $0x2,%eax
ffff800000104bbd:	01 d0                	add    %edx,%eax
ffff800000104bbf:	01 c0                	add    %eax,%eax
ffff800000104bc1:	89 c2                	mov    %eax,%edx
ffff800000104bc3:	8b 45 f0             	mov    -0x10(%rbp),%eax
ffff800000104bc6:	83 e0 0f             	and    $0xf,%eax
ffff800000104bc9:	01 d0                	add    %edx,%eax
ffff800000104bcb:	89 45 f0             	mov    %eax,-0x10(%rbp)
    CONV(year  );
ffff800000104bce:	8b 45 f4             	mov    -0xc(%rbp),%eax
ffff800000104bd1:	c1 e8 04             	shr    $0x4,%eax
ffff800000104bd4:	89 c2                	mov    %eax,%edx
ffff800000104bd6:	89 d0                	mov    %edx,%eax
ffff800000104bd8:	c1 e0 02             	shl    $0x2,%eax
ffff800000104bdb:	01 d0                	add    %edx,%eax
ffff800000104bdd:	01 c0                	add    %eax,%eax
ffff800000104bdf:	89 c2                	mov    %eax,%edx
ffff800000104be1:	8b 45 f4             	mov    -0xc(%rbp),%eax
ffff800000104be4:	83 e0 0f             	and    $0xf,%eax
ffff800000104be7:	01 d0                	add    %edx,%eax
ffff800000104be9:	89 45 f4             	mov    %eax,-0xc(%rbp)
#undef     CONV
  }

  *r = t1;
ffff800000104bec:	48 8b 4d b8          	mov    -0x48(%rbp),%rcx
ffff800000104bf0:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
ffff800000104bf4:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
ffff800000104bf8:	48 89 01             	mov    %rax,(%rcx)
ffff800000104bfb:	48 89 51 08          	mov    %rdx,0x8(%rcx)
ffff800000104bff:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff800000104c03:	48 89 41 10          	mov    %rax,0x10(%rcx)
  r->year += 2000;
ffff800000104c07:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
ffff800000104c0b:	8b 40 14             	mov    0x14(%rax),%eax
ffff800000104c0e:	8d 90 d0 07 00 00    	lea    0x7d0(%rax),%edx
ffff800000104c14:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
ffff800000104c18:	89 50 14             	mov    %edx,0x14(%rax)
}
ffff800000104c1b:	90                   	nop
ffff800000104c1c:	c9                   	leaveq 
ffff800000104c1d:	c3                   	retq   

ffff800000104c1e <initlog>:
static void recover_from_log(void);
static void commit();

void
initlog(int dev)
{
ffff800000104c1e:	f3 0f 1e fa          	endbr64 
ffff800000104c22:	55                   	push   %rbp
ffff800000104c23:	48 89 e5             	mov    %rsp,%rbp
ffff800000104c26:	48 83 ec 30          	sub    $0x30,%rsp
ffff800000104c2a:	89 7d dc             	mov    %edi,-0x24(%rbp)
  if (sizeof(struct logheader) >= BSIZE)
    panic("initlog: too big logheader");

  struct superblock sb;
  initlock(&log.lock, "log");
ffff800000104c2d:	48 be 04 ca 10 00 00 	movabs $0xffff80000010ca04,%rsi
ffff800000104c34:	80 ff ff 
ffff800000104c37:	48 bf e0 71 11 00 00 	movabs $0xffff8000001171e0,%rdi
ffff800000104c3e:	80 ff ff 
ffff800000104c41:	48 b8 de 7e 10 00 00 	movabs $0xffff800000107ede,%rax
ffff800000104c48:	80 ff ff 
ffff800000104c4b:	ff d0                	callq  *%rax
  readsb(dev, &sb);
ffff800000104c4d:	48 8d 55 e0          	lea    -0x20(%rbp),%rdx
ffff800000104c51:	8b 45 dc             	mov    -0x24(%rbp),%eax
ffff800000104c54:	48 89 d6             	mov    %rdx,%rsi
ffff800000104c57:	89 c7                	mov    %eax,%edi
ffff800000104c59:	48 b8 d1 20 10 00 00 	movabs $0xffff8000001020d1,%rax
ffff800000104c60:	80 ff ff 
ffff800000104c63:	ff d0                	callq  *%rax
  log.start = sb.logstart;
ffff800000104c65:	8b 45 f0             	mov    -0x10(%rbp),%eax
ffff800000104c68:	89 c2                	mov    %eax,%edx
ffff800000104c6a:	48 b8 e0 71 11 00 00 	movabs $0xffff8000001171e0,%rax
ffff800000104c71:	80 ff ff 
ffff800000104c74:	89 50 68             	mov    %edx,0x68(%rax)
  log.size = sb.nlog;
ffff800000104c77:	8b 45 ec             	mov    -0x14(%rbp),%eax
ffff800000104c7a:	89 c2                	mov    %eax,%edx
ffff800000104c7c:	48 b8 e0 71 11 00 00 	movabs $0xffff8000001171e0,%rax
ffff800000104c83:	80 ff ff 
ffff800000104c86:	89 50 6c             	mov    %edx,0x6c(%rax)
  log.dev = dev;
ffff800000104c89:	48 ba e0 71 11 00 00 	movabs $0xffff8000001171e0,%rdx
ffff800000104c90:	80 ff ff 
ffff800000104c93:	8b 45 dc             	mov    -0x24(%rbp),%eax
ffff800000104c96:	89 42 78             	mov    %eax,0x78(%rdx)
  recover_from_log();
ffff800000104c99:	48 b8 39 4f 10 00 00 	movabs $0xffff800000104f39,%rax
ffff800000104ca0:	80 ff ff 
ffff800000104ca3:	ff d0                	callq  *%rax
}
ffff800000104ca5:	90                   	nop
ffff800000104ca6:	c9                   	leaveq 
ffff800000104ca7:	c3                   	retq   

ffff800000104ca8 <install_trans>:

// Copy committed blocks from log to their home location
static void
install_trans(void)
{
ffff800000104ca8:	f3 0f 1e fa          	endbr64 
ffff800000104cac:	55                   	push   %rbp
ffff800000104cad:	48 89 e5             	mov    %rsp,%rbp
ffff800000104cb0:	48 83 ec 20          	sub    $0x20,%rsp
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
ffff800000104cb4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
ffff800000104cbb:	e9 dc 00 00 00       	jmpq   ffff800000104d9c <install_trans+0xf4>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
ffff800000104cc0:	48 b8 e0 71 11 00 00 	movabs $0xffff8000001171e0,%rax
ffff800000104cc7:	80 ff ff 
ffff800000104cca:	8b 50 68             	mov    0x68(%rax),%edx
ffff800000104ccd:	8b 45 fc             	mov    -0x4(%rbp),%eax
ffff800000104cd0:	01 d0                	add    %edx,%eax
ffff800000104cd2:	83 c0 01             	add    $0x1,%eax
ffff800000104cd5:	89 c2                	mov    %eax,%edx
ffff800000104cd7:	48 b8 e0 71 11 00 00 	movabs $0xffff8000001171e0,%rax
ffff800000104cde:	80 ff ff 
ffff800000104ce1:	8b 40 78             	mov    0x78(%rax),%eax
ffff800000104ce4:	89 d6                	mov    %edx,%esi
ffff800000104ce6:	89 c7                	mov    %eax,%edi
ffff800000104ce8:	48 b8 be 03 10 00 00 	movabs $0xffff8000001003be,%rax
ffff800000104cef:	80 ff ff 
ffff800000104cf2:	ff d0                	callq  *%rax
ffff800000104cf4:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
ffff800000104cf8:	48 b8 e0 71 11 00 00 	movabs $0xffff8000001171e0,%rax
ffff800000104cff:	80 ff ff 
ffff800000104d02:	8b 55 fc             	mov    -0x4(%rbp),%edx
ffff800000104d05:	48 63 d2             	movslq %edx,%rdx
ffff800000104d08:	48 83 c2 1c          	add    $0x1c,%rdx
ffff800000104d0c:	8b 44 90 10          	mov    0x10(%rax,%rdx,4),%eax
ffff800000104d10:	89 c2                	mov    %eax,%edx
ffff800000104d12:	48 b8 e0 71 11 00 00 	movabs $0xffff8000001171e0,%rax
ffff800000104d19:	80 ff ff 
ffff800000104d1c:	8b 40 78             	mov    0x78(%rax),%eax
ffff800000104d1f:	89 d6                	mov    %edx,%esi
ffff800000104d21:	89 c7                	mov    %eax,%edi
ffff800000104d23:	48 b8 be 03 10 00 00 	movabs $0xffff8000001003be,%rax
ffff800000104d2a:	80 ff ff 
ffff800000104d2d:	ff d0                	callq  *%rax
ffff800000104d2f:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
ffff800000104d33:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff800000104d37:	48 8d 88 b0 00 00 00 	lea    0xb0(%rax),%rcx
ffff800000104d3e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000104d42:	48 05 b0 00 00 00    	add    $0xb0,%rax
ffff800000104d48:	ba 00 02 00 00       	mov    $0x200,%edx
ffff800000104d4d:	48 89 ce             	mov    %rcx,%rsi
ffff800000104d50:	48 89 c7             	mov    %rax,%rdi
ffff800000104d53:	48 b8 ca 83 10 00 00 	movabs $0xffff8000001083ca,%rax
ffff800000104d5a:	80 ff ff 
ffff800000104d5d:	ff d0                	callq  *%rax
    bwrite(dbuf);  // write dst to disk
ffff800000104d5f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000104d63:	48 89 c7             	mov    %rax,%rdi
ffff800000104d66:	48 b8 10 04 10 00 00 	movabs $0xffff800000100410,%rax
ffff800000104d6d:	80 ff ff 
ffff800000104d70:	ff d0                	callq  *%rax
    brelse(lbuf);
ffff800000104d72:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff800000104d76:	48 89 c7             	mov    %rax,%rdi
ffff800000104d79:	48 b8 78 04 10 00 00 	movabs $0xffff800000100478,%rax
ffff800000104d80:	80 ff ff 
ffff800000104d83:	ff d0                	callq  *%rax
    brelse(dbuf);
ffff800000104d85:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000104d89:	48 89 c7             	mov    %rax,%rdi
ffff800000104d8c:	48 b8 78 04 10 00 00 	movabs $0xffff800000100478,%rax
ffff800000104d93:	80 ff ff 
ffff800000104d96:	ff d0                	callq  *%rax
  for (tail = 0; tail < log.lh.n; tail++) {
ffff800000104d98:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
ffff800000104d9c:	48 b8 e0 71 11 00 00 	movabs $0xffff8000001171e0,%rax
ffff800000104da3:	80 ff ff 
ffff800000104da6:	8b 40 7c             	mov    0x7c(%rax),%eax
ffff800000104da9:	39 45 fc             	cmp    %eax,-0x4(%rbp)
ffff800000104dac:	0f 8c 0e ff ff ff    	jl     ffff800000104cc0 <install_trans+0x18>
  }
}
ffff800000104db2:	90                   	nop
ffff800000104db3:	90                   	nop
ffff800000104db4:	c9                   	leaveq 
ffff800000104db5:	c3                   	retq   

ffff800000104db6 <read_head>:

// Read the log header from disk into the in-memory log header
static void
read_head(void)
{
ffff800000104db6:	f3 0f 1e fa          	endbr64 
ffff800000104dba:	55                   	push   %rbp
ffff800000104dbb:	48 89 e5             	mov    %rsp,%rbp
ffff800000104dbe:	48 83 ec 20          	sub    $0x20,%rsp
  struct buf *buf = bread(log.dev, log.start);
ffff800000104dc2:	48 b8 e0 71 11 00 00 	movabs $0xffff8000001171e0,%rax
ffff800000104dc9:	80 ff ff 
ffff800000104dcc:	8b 40 68             	mov    0x68(%rax),%eax
ffff800000104dcf:	89 c2                	mov    %eax,%edx
ffff800000104dd1:	48 b8 e0 71 11 00 00 	movabs $0xffff8000001171e0,%rax
ffff800000104dd8:	80 ff ff 
ffff800000104ddb:	8b 40 78             	mov    0x78(%rax),%eax
ffff800000104dde:	89 d6                	mov    %edx,%esi
ffff800000104de0:	89 c7                	mov    %eax,%edi
ffff800000104de2:	48 b8 be 03 10 00 00 	movabs $0xffff8000001003be,%rax
ffff800000104de9:	80 ff ff 
ffff800000104dec:	ff d0                	callq  *%rax
ffff800000104dee:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
  struct logheader *lh = (struct logheader *) (buf->data);
ffff800000104df2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff800000104df6:	48 05 b0 00 00 00    	add    $0xb0,%rax
ffff800000104dfc:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
  int i;
  log.lh.n = lh->n;
ffff800000104e00:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000104e04:	8b 00                	mov    (%rax),%eax
ffff800000104e06:	48 ba e0 71 11 00 00 	movabs $0xffff8000001171e0,%rdx
ffff800000104e0d:	80 ff ff 
ffff800000104e10:	89 42 7c             	mov    %eax,0x7c(%rdx)
  for (i = 0; i < log.lh.n; i++) {
ffff800000104e13:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
ffff800000104e1a:	eb 2a                	jmp    ffff800000104e46 <read_head+0x90>
    log.lh.block[i] = lh->block[i];
ffff800000104e1c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000104e20:	8b 55 fc             	mov    -0x4(%rbp),%edx
ffff800000104e23:	48 63 d2             	movslq %edx,%rdx
ffff800000104e26:	8b 44 90 04          	mov    0x4(%rax,%rdx,4),%eax
ffff800000104e2a:	48 ba e0 71 11 00 00 	movabs $0xffff8000001171e0,%rdx
ffff800000104e31:	80 ff ff 
ffff800000104e34:	8b 4d fc             	mov    -0x4(%rbp),%ecx
ffff800000104e37:	48 63 c9             	movslq %ecx,%rcx
ffff800000104e3a:	48 83 c1 1c          	add    $0x1c,%rcx
ffff800000104e3e:	89 44 8a 10          	mov    %eax,0x10(%rdx,%rcx,4)
  for (i = 0; i < log.lh.n; i++) {
ffff800000104e42:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
ffff800000104e46:	48 b8 e0 71 11 00 00 	movabs $0xffff8000001171e0,%rax
ffff800000104e4d:	80 ff ff 
ffff800000104e50:	8b 40 7c             	mov    0x7c(%rax),%eax
ffff800000104e53:	39 45 fc             	cmp    %eax,-0x4(%rbp)
ffff800000104e56:	7c c4                	jl     ffff800000104e1c <read_head+0x66>
  }
  brelse(buf);
ffff800000104e58:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff800000104e5c:	48 89 c7             	mov    %rax,%rdi
ffff800000104e5f:	48 b8 78 04 10 00 00 	movabs $0xffff800000100478,%rax
ffff800000104e66:	80 ff ff 
ffff800000104e69:	ff d0                	callq  *%rax
}
ffff800000104e6b:	90                   	nop
ffff800000104e6c:	c9                   	leaveq 
ffff800000104e6d:	c3                   	retq   

ffff800000104e6e <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
ffff800000104e6e:	f3 0f 1e fa          	endbr64 
ffff800000104e72:	55                   	push   %rbp
ffff800000104e73:	48 89 e5             	mov    %rsp,%rbp
ffff800000104e76:	48 83 ec 20          	sub    $0x20,%rsp
  struct buf *buf = bread(log.dev, log.start);
ffff800000104e7a:	48 b8 e0 71 11 00 00 	movabs $0xffff8000001171e0,%rax
ffff800000104e81:	80 ff ff 
ffff800000104e84:	8b 40 68             	mov    0x68(%rax),%eax
ffff800000104e87:	89 c2                	mov    %eax,%edx
ffff800000104e89:	48 b8 e0 71 11 00 00 	movabs $0xffff8000001171e0,%rax
ffff800000104e90:	80 ff ff 
ffff800000104e93:	8b 40 78             	mov    0x78(%rax),%eax
ffff800000104e96:	89 d6                	mov    %edx,%esi
ffff800000104e98:	89 c7                	mov    %eax,%edi
ffff800000104e9a:	48 b8 be 03 10 00 00 	movabs $0xffff8000001003be,%rax
ffff800000104ea1:	80 ff ff 
ffff800000104ea4:	ff d0                	callq  *%rax
ffff800000104ea6:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
  struct logheader *hb = (struct logheader *) (buf->data);
ffff800000104eaa:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff800000104eae:	48 05 b0 00 00 00    	add    $0xb0,%rax
ffff800000104eb4:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
  int i;
  hb->n = log.lh.n;
ffff800000104eb8:	48 b8 e0 71 11 00 00 	movabs $0xffff8000001171e0,%rax
ffff800000104ebf:	80 ff ff 
ffff800000104ec2:	8b 50 7c             	mov    0x7c(%rax),%edx
ffff800000104ec5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000104ec9:	89 10                	mov    %edx,(%rax)
  for (i = 0; i < log.lh.n; i++) {
ffff800000104ecb:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
ffff800000104ed2:	eb 2a                	jmp    ffff800000104efe <write_head+0x90>
    hb->block[i] = log.lh.block[i];
ffff800000104ed4:	48 b8 e0 71 11 00 00 	movabs $0xffff8000001171e0,%rax
ffff800000104edb:	80 ff ff 
ffff800000104ede:	8b 55 fc             	mov    -0x4(%rbp),%edx
ffff800000104ee1:	48 63 d2             	movslq %edx,%rdx
ffff800000104ee4:	48 83 c2 1c          	add    $0x1c,%rdx
ffff800000104ee8:	8b 4c 90 10          	mov    0x10(%rax,%rdx,4),%ecx
ffff800000104eec:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000104ef0:	8b 55 fc             	mov    -0x4(%rbp),%edx
ffff800000104ef3:	48 63 d2             	movslq %edx,%rdx
ffff800000104ef6:	89 4c 90 04          	mov    %ecx,0x4(%rax,%rdx,4)
  for (i = 0; i < log.lh.n; i++) {
ffff800000104efa:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
ffff800000104efe:	48 b8 e0 71 11 00 00 	movabs $0xffff8000001171e0,%rax
ffff800000104f05:	80 ff ff 
ffff800000104f08:	8b 40 7c             	mov    0x7c(%rax),%eax
ffff800000104f0b:	39 45 fc             	cmp    %eax,-0x4(%rbp)
ffff800000104f0e:	7c c4                	jl     ffff800000104ed4 <write_head+0x66>
  }
  bwrite(buf);
ffff800000104f10:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff800000104f14:	48 89 c7             	mov    %rax,%rdi
ffff800000104f17:	48 b8 10 04 10 00 00 	movabs $0xffff800000100410,%rax
ffff800000104f1e:	80 ff ff 
ffff800000104f21:	ff d0                	callq  *%rax
  brelse(buf);
ffff800000104f23:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff800000104f27:	48 89 c7             	mov    %rax,%rdi
ffff800000104f2a:	48 b8 78 04 10 00 00 	movabs $0xffff800000100478,%rax
ffff800000104f31:	80 ff ff 
ffff800000104f34:	ff d0                	callq  *%rax
}
ffff800000104f36:	90                   	nop
ffff800000104f37:	c9                   	leaveq 
ffff800000104f38:	c3                   	retq   

ffff800000104f39 <recover_from_log>:

static void
recover_from_log(void)
{
ffff800000104f39:	f3 0f 1e fa          	endbr64 
ffff800000104f3d:	55                   	push   %rbp
ffff800000104f3e:	48 89 e5             	mov    %rsp,%rbp
  read_head();
ffff800000104f41:	48 b8 b6 4d 10 00 00 	movabs $0xffff800000104db6,%rax
ffff800000104f48:	80 ff ff 
ffff800000104f4b:	ff d0                	callq  *%rax
  install_trans(); // if committed, copy from log to disk
ffff800000104f4d:	48 b8 a8 4c 10 00 00 	movabs $0xffff800000104ca8,%rax
ffff800000104f54:	80 ff ff 
ffff800000104f57:	ff d0                	callq  *%rax
  log.lh.n = 0;
ffff800000104f59:	48 b8 e0 71 11 00 00 	movabs $0xffff8000001171e0,%rax
ffff800000104f60:	80 ff ff 
ffff800000104f63:	c7 40 7c 00 00 00 00 	movl   $0x0,0x7c(%rax)
  write_head(); // clear the log
ffff800000104f6a:	48 b8 6e 4e 10 00 00 	movabs $0xffff800000104e6e,%rax
ffff800000104f71:	80 ff ff 
ffff800000104f74:	ff d0                	callq  *%rax
}
ffff800000104f76:	90                   	nop
ffff800000104f77:	5d                   	pop    %rbp
ffff800000104f78:	c3                   	retq   

ffff800000104f79 <begin_op>:

// called at the start of each FS system call.
void
begin_op(void)
{
ffff800000104f79:	f3 0f 1e fa          	endbr64 
ffff800000104f7d:	55                   	push   %rbp
ffff800000104f7e:	48 89 e5             	mov    %rsp,%rbp
  acquire(&log.lock);
ffff800000104f81:	48 bf e0 71 11 00 00 	movabs $0xffff8000001171e0,%rdi
ffff800000104f88:	80 ff ff 
ffff800000104f8b:	48 b8 17 7f 10 00 00 	movabs $0xffff800000107f17,%rax
ffff800000104f92:	80 ff ff 
ffff800000104f95:	ff d0                	callq  *%rax
  while(1){
    if(log.committing){
ffff800000104f97:	48 b8 e0 71 11 00 00 	movabs $0xffff8000001171e0,%rax
ffff800000104f9e:	80 ff ff 
ffff800000104fa1:	8b 40 74             	mov    0x74(%rax),%eax
ffff800000104fa4:	85 c0                	test   %eax,%eax
ffff800000104fa6:	74 22                	je     ffff800000104fca <begin_op+0x51>
      sleep(&log, &log.lock);
ffff800000104fa8:	48 be e0 71 11 00 00 	movabs $0xffff8000001171e0,%rsi
ffff800000104faf:	80 ff ff 
ffff800000104fb2:	48 bf e0 71 11 00 00 	movabs $0xffff8000001171e0,%rdi
ffff800000104fb9:	80 ff ff 
ffff800000104fbc:	48 b8 bd 6f 10 00 00 	movabs $0xffff800000106fbd,%rax
ffff800000104fc3:	80 ff ff 
ffff800000104fc6:	ff d0                	callq  *%rax
ffff800000104fc8:	eb cd                	jmp    ffff800000104f97 <begin_op+0x1e>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
ffff800000104fca:	48 b8 e0 71 11 00 00 	movabs $0xffff8000001171e0,%rax
ffff800000104fd1:	80 ff ff 
ffff800000104fd4:	8b 48 7c             	mov    0x7c(%rax),%ecx
ffff800000104fd7:	48 b8 e0 71 11 00 00 	movabs $0xffff8000001171e0,%rax
ffff800000104fde:	80 ff ff 
ffff800000104fe1:	8b 40 70             	mov    0x70(%rax),%eax
ffff800000104fe4:	8d 50 01             	lea    0x1(%rax),%edx
ffff800000104fe7:	89 d0                	mov    %edx,%eax
ffff800000104fe9:	c1 e0 02             	shl    $0x2,%eax
ffff800000104fec:	01 d0                	add    %edx,%eax
ffff800000104fee:	01 c0                	add    %eax,%eax
ffff800000104ff0:	01 c8                	add    %ecx,%eax
ffff800000104ff2:	83 f8 1e             	cmp    $0x1e,%eax
ffff800000104ff5:	7e 25                	jle    ffff80000010501c <begin_op+0xa3>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
ffff800000104ff7:	48 be e0 71 11 00 00 	movabs $0xffff8000001171e0,%rsi
ffff800000104ffe:	80 ff ff 
ffff800000105001:	48 bf e0 71 11 00 00 	movabs $0xffff8000001171e0,%rdi
ffff800000105008:	80 ff ff 
ffff80000010500b:	48 b8 bd 6f 10 00 00 	movabs $0xffff800000106fbd,%rax
ffff800000105012:	80 ff ff 
ffff800000105015:	ff d0                	callq  *%rax
ffff800000105017:	e9 7b ff ff ff       	jmpq   ffff800000104f97 <begin_op+0x1e>
    } else {
      log.outstanding += 1;
ffff80000010501c:	48 b8 e0 71 11 00 00 	movabs $0xffff8000001171e0,%rax
ffff800000105023:	80 ff ff 
ffff800000105026:	8b 40 70             	mov    0x70(%rax),%eax
ffff800000105029:	8d 50 01             	lea    0x1(%rax),%edx
ffff80000010502c:	48 b8 e0 71 11 00 00 	movabs $0xffff8000001171e0,%rax
ffff800000105033:	80 ff ff 
ffff800000105036:	89 50 70             	mov    %edx,0x70(%rax)
      release(&log.lock);
ffff800000105039:	48 bf e0 71 11 00 00 	movabs $0xffff8000001171e0,%rdi
ffff800000105040:	80 ff ff 
ffff800000105043:	48 b8 b4 7f 10 00 00 	movabs $0xffff800000107fb4,%rax
ffff80000010504a:	80 ff ff 
ffff80000010504d:	ff d0                	callq  *%rax
      break;
ffff80000010504f:	90                   	nop
    }
  }
}
ffff800000105050:	90                   	nop
ffff800000105051:	5d                   	pop    %rbp
ffff800000105052:	c3                   	retq   

ffff800000105053 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
ffff800000105053:	f3 0f 1e fa          	endbr64 
ffff800000105057:	55                   	push   %rbp
ffff800000105058:	48 89 e5             	mov    %rsp,%rbp
ffff80000010505b:	48 83 ec 10          	sub    $0x10,%rsp
  int do_commit = 0;
ffff80000010505f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)

  acquire(&log.lock);
ffff800000105066:	48 bf e0 71 11 00 00 	movabs $0xffff8000001171e0,%rdi
ffff80000010506d:	80 ff ff 
ffff800000105070:	48 b8 17 7f 10 00 00 	movabs $0xffff800000107f17,%rax
ffff800000105077:	80 ff ff 
ffff80000010507a:	ff d0                	callq  *%rax
  log.outstanding -= 1;
ffff80000010507c:	48 b8 e0 71 11 00 00 	movabs $0xffff8000001171e0,%rax
ffff800000105083:	80 ff ff 
ffff800000105086:	8b 40 70             	mov    0x70(%rax),%eax
ffff800000105089:	8d 50 ff             	lea    -0x1(%rax),%edx
ffff80000010508c:	48 b8 e0 71 11 00 00 	movabs $0xffff8000001171e0,%rax
ffff800000105093:	80 ff ff 
ffff800000105096:	89 50 70             	mov    %edx,0x70(%rax)
  if(log.committing)
ffff800000105099:	48 b8 e0 71 11 00 00 	movabs $0xffff8000001171e0,%rax
ffff8000001050a0:	80 ff ff 
ffff8000001050a3:	8b 40 74             	mov    0x74(%rax),%eax
ffff8000001050a6:	85 c0                	test   %eax,%eax
ffff8000001050a8:	74 16                	je     ffff8000001050c0 <end_op+0x6d>
    panic("log.committing");
ffff8000001050aa:	48 bf 08 ca 10 00 00 	movabs $0xffff80000010ca08,%rdi
ffff8000001050b1:	80 ff ff 
ffff8000001050b4:	48 b8 f9 0b 10 00 00 	movabs $0xffff800000100bf9,%rax
ffff8000001050bb:	80 ff ff 
ffff8000001050be:	ff d0                	callq  *%rax
  if(log.outstanding == 0){
ffff8000001050c0:	48 b8 e0 71 11 00 00 	movabs $0xffff8000001171e0,%rax
ffff8000001050c7:	80 ff ff 
ffff8000001050ca:	8b 40 70             	mov    0x70(%rax),%eax
ffff8000001050cd:	85 c0                	test   %eax,%eax
ffff8000001050cf:	75 1a                	jne    ffff8000001050eb <end_op+0x98>
    do_commit = 1;
ffff8000001050d1:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)
    log.committing = 1;
ffff8000001050d8:	48 b8 e0 71 11 00 00 	movabs $0xffff8000001171e0,%rax
ffff8000001050df:	80 ff ff 
ffff8000001050e2:	c7 40 74 01 00 00 00 	movl   $0x1,0x74(%rax)
ffff8000001050e9:	eb 16                	jmp    ffff800000105101 <end_op+0xae>
  } else {
    // begin_op() may be waiting for log space.
    wakeup(&log);
ffff8000001050eb:	48 bf e0 71 11 00 00 	movabs $0xffff8000001171e0,%rdi
ffff8000001050f2:	80 ff ff 
ffff8000001050f5:	48 b8 2e 71 10 00 00 	movabs $0xffff80000010712e,%rax
ffff8000001050fc:	80 ff ff 
ffff8000001050ff:	ff d0                	callq  *%rax
  }
  release(&log.lock);
ffff800000105101:	48 bf e0 71 11 00 00 	movabs $0xffff8000001171e0,%rdi
ffff800000105108:	80 ff ff 
ffff80000010510b:	48 b8 b4 7f 10 00 00 	movabs $0xffff800000107fb4,%rax
ffff800000105112:	80 ff ff 
ffff800000105115:	ff d0                	callq  *%rax

  if(do_commit){
ffff800000105117:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
ffff80000010511b:	74 64                	je     ffff800000105181 <end_op+0x12e>
    // call commit w/o holding locks, since not allowed
    // to sleep with locks.
    commit();
ffff80000010511d:	b8 00 00 00 00       	mov    $0x0,%eax
ffff800000105122:	48 ba 92 52 10 00 00 	movabs $0xffff800000105292,%rdx
ffff800000105129:	80 ff ff 
ffff80000010512c:	ff d2                	callq  *%rdx
    acquire(&log.lock);
ffff80000010512e:	48 bf e0 71 11 00 00 	movabs $0xffff8000001171e0,%rdi
ffff800000105135:	80 ff ff 
ffff800000105138:	48 b8 17 7f 10 00 00 	movabs $0xffff800000107f17,%rax
ffff80000010513f:	80 ff ff 
ffff800000105142:	ff d0                	callq  *%rax
    log.committing = 0;
ffff800000105144:	48 b8 e0 71 11 00 00 	movabs $0xffff8000001171e0,%rax
ffff80000010514b:	80 ff ff 
ffff80000010514e:	c7 40 74 00 00 00 00 	movl   $0x0,0x74(%rax)
    wakeup(&log);
ffff800000105155:	48 bf e0 71 11 00 00 	movabs $0xffff8000001171e0,%rdi
ffff80000010515c:	80 ff ff 
ffff80000010515f:	48 b8 2e 71 10 00 00 	movabs $0xffff80000010712e,%rax
ffff800000105166:	80 ff ff 
ffff800000105169:	ff d0                	callq  *%rax
    release(&log.lock);
ffff80000010516b:	48 bf e0 71 11 00 00 	movabs $0xffff8000001171e0,%rdi
ffff800000105172:	80 ff ff 
ffff800000105175:	48 b8 b4 7f 10 00 00 	movabs $0xffff800000107fb4,%rax
ffff80000010517c:	80 ff ff 
ffff80000010517f:	ff d0                	callq  *%rax
  }
}
ffff800000105181:	90                   	nop
ffff800000105182:	c9                   	leaveq 
ffff800000105183:	c3                   	retq   

ffff800000105184 <write_log>:

// Copy modified blocks from cache to log.
static void
write_log(void)
{
ffff800000105184:	f3 0f 1e fa          	endbr64 
ffff800000105188:	55                   	push   %rbp
ffff800000105189:	48 89 e5             	mov    %rsp,%rbp
ffff80000010518c:	48 83 ec 20          	sub    $0x20,%rsp
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
ffff800000105190:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
ffff800000105197:	e9 dc 00 00 00       	jmpq   ffff800000105278 <write_log+0xf4>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
ffff80000010519c:	48 b8 e0 71 11 00 00 	movabs $0xffff8000001171e0,%rax
ffff8000001051a3:	80 ff ff 
ffff8000001051a6:	8b 50 68             	mov    0x68(%rax),%edx
ffff8000001051a9:	8b 45 fc             	mov    -0x4(%rbp),%eax
ffff8000001051ac:	01 d0                	add    %edx,%eax
ffff8000001051ae:	83 c0 01             	add    $0x1,%eax
ffff8000001051b1:	89 c2                	mov    %eax,%edx
ffff8000001051b3:	48 b8 e0 71 11 00 00 	movabs $0xffff8000001171e0,%rax
ffff8000001051ba:	80 ff ff 
ffff8000001051bd:	8b 40 78             	mov    0x78(%rax),%eax
ffff8000001051c0:	89 d6                	mov    %edx,%esi
ffff8000001051c2:	89 c7                	mov    %eax,%edi
ffff8000001051c4:	48 b8 be 03 10 00 00 	movabs $0xffff8000001003be,%rax
ffff8000001051cb:	80 ff ff 
ffff8000001051ce:	ff d0                	callq  *%rax
ffff8000001051d0:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
ffff8000001051d4:	48 b8 e0 71 11 00 00 	movabs $0xffff8000001171e0,%rax
ffff8000001051db:	80 ff ff 
ffff8000001051de:	8b 55 fc             	mov    -0x4(%rbp),%edx
ffff8000001051e1:	48 63 d2             	movslq %edx,%rdx
ffff8000001051e4:	48 83 c2 1c          	add    $0x1c,%rdx
ffff8000001051e8:	8b 44 90 10          	mov    0x10(%rax,%rdx,4),%eax
ffff8000001051ec:	89 c2                	mov    %eax,%edx
ffff8000001051ee:	48 b8 e0 71 11 00 00 	movabs $0xffff8000001171e0,%rax
ffff8000001051f5:	80 ff ff 
ffff8000001051f8:	8b 40 78             	mov    0x78(%rax),%eax
ffff8000001051fb:	89 d6                	mov    %edx,%esi
ffff8000001051fd:	89 c7                	mov    %eax,%edi
ffff8000001051ff:	48 b8 be 03 10 00 00 	movabs $0xffff8000001003be,%rax
ffff800000105206:	80 ff ff 
ffff800000105209:	ff d0                	callq  *%rax
ffff80000010520b:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
    memmove(to->data, from->data, BSIZE);
ffff80000010520f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000105213:	48 8d 88 b0 00 00 00 	lea    0xb0(%rax),%rcx
ffff80000010521a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff80000010521e:	48 05 b0 00 00 00    	add    $0xb0,%rax
ffff800000105224:	ba 00 02 00 00       	mov    $0x200,%edx
ffff800000105229:	48 89 ce             	mov    %rcx,%rsi
ffff80000010522c:	48 89 c7             	mov    %rax,%rdi
ffff80000010522f:	48 b8 ca 83 10 00 00 	movabs $0xffff8000001083ca,%rax
ffff800000105236:	80 ff ff 
ffff800000105239:	ff d0                	callq  *%rax
    bwrite(to);  // write the log
ffff80000010523b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff80000010523f:	48 89 c7             	mov    %rax,%rdi
ffff800000105242:	48 b8 10 04 10 00 00 	movabs $0xffff800000100410,%rax
ffff800000105249:	80 ff ff 
ffff80000010524c:	ff d0                	callq  *%rax
    brelse(from);
ffff80000010524e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000105252:	48 89 c7             	mov    %rax,%rdi
ffff800000105255:	48 b8 78 04 10 00 00 	movabs $0xffff800000100478,%rax
ffff80000010525c:	80 ff ff 
ffff80000010525f:	ff d0                	callq  *%rax
    brelse(to);
ffff800000105261:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff800000105265:	48 89 c7             	mov    %rax,%rdi
ffff800000105268:	48 b8 78 04 10 00 00 	movabs $0xffff800000100478,%rax
ffff80000010526f:	80 ff ff 
ffff800000105272:	ff d0                	callq  *%rax
  for (tail = 0; tail < log.lh.n; tail++) {
ffff800000105274:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
ffff800000105278:	48 b8 e0 71 11 00 00 	movabs $0xffff8000001171e0,%rax
ffff80000010527f:	80 ff ff 
ffff800000105282:	8b 40 7c             	mov    0x7c(%rax),%eax
ffff800000105285:	39 45 fc             	cmp    %eax,-0x4(%rbp)
ffff800000105288:	0f 8c 0e ff ff ff    	jl     ffff80000010519c <write_log+0x18>
  }
}
ffff80000010528e:	90                   	nop
ffff80000010528f:	90                   	nop
ffff800000105290:	c9                   	leaveq 
ffff800000105291:	c3                   	retq   

ffff800000105292 <commit>:

static void
commit()
{
ffff800000105292:	f3 0f 1e fa          	endbr64 
ffff800000105296:	55                   	push   %rbp
ffff800000105297:	48 89 e5             	mov    %rsp,%rbp
  if (log.lh.n > 0) {
ffff80000010529a:	48 b8 e0 71 11 00 00 	movabs $0xffff8000001171e0,%rax
ffff8000001052a1:	80 ff ff 
ffff8000001052a4:	8b 40 7c             	mov    0x7c(%rax),%eax
ffff8000001052a7:	85 c0                	test   %eax,%eax
ffff8000001052a9:	7e 41                	jle    ffff8000001052ec <commit+0x5a>
    write_log();     // Write modified blocks from cache to log
ffff8000001052ab:	48 b8 84 51 10 00 00 	movabs $0xffff800000105184,%rax
ffff8000001052b2:	80 ff ff 
ffff8000001052b5:	ff d0                	callq  *%rax
    write_head();    // Write header to disk -- the real commit
ffff8000001052b7:	48 b8 6e 4e 10 00 00 	movabs $0xffff800000104e6e,%rax
ffff8000001052be:	80 ff ff 
ffff8000001052c1:	ff d0                	callq  *%rax
    install_trans(); // Now install writes to home locations
ffff8000001052c3:	48 b8 a8 4c 10 00 00 	movabs $0xffff800000104ca8,%rax
ffff8000001052ca:	80 ff ff 
ffff8000001052cd:	ff d0                	callq  *%rax
    log.lh.n = 0;
ffff8000001052cf:	48 b8 e0 71 11 00 00 	movabs $0xffff8000001171e0,%rax
ffff8000001052d6:	80 ff ff 
ffff8000001052d9:	c7 40 7c 00 00 00 00 	movl   $0x0,0x7c(%rax)
    write_head();    // Erase the transaction from the log
ffff8000001052e0:	48 b8 6e 4e 10 00 00 	movabs $0xffff800000104e6e,%rax
ffff8000001052e7:	80 ff ff 
ffff8000001052ea:	ff d0                	callq  *%rax
  }
}
ffff8000001052ec:	90                   	nop
ffff8000001052ed:	5d                   	pop    %rbp
ffff8000001052ee:	c3                   	retq   

ffff8000001052ef <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
ffff8000001052ef:	f3 0f 1e fa          	endbr64 
ffff8000001052f3:	55                   	push   %rbp
ffff8000001052f4:	48 89 e5             	mov    %rsp,%rbp
ffff8000001052f7:	48 83 ec 20          	sub    $0x20,%rsp
ffff8000001052fb:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
ffff8000001052ff:	48 b8 e0 71 11 00 00 	movabs $0xffff8000001171e0,%rax
ffff800000105306:	80 ff ff 
ffff800000105309:	8b 40 7c             	mov    0x7c(%rax),%eax
ffff80000010530c:	83 f8 1d             	cmp    $0x1d,%eax
ffff80000010530f:	7f 21                	jg     ffff800000105332 <log_write+0x43>
ffff800000105311:	48 b8 e0 71 11 00 00 	movabs $0xffff8000001171e0,%rax
ffff800000105318:	80 ff ff 
ffff80000010531b:	8b 40 7c             	mov    0x7c(%rax),%eax
ffff80000010531e:	48 ba e0 71 11 00 00 	movabs $0xffff8000001171e0,%rdx
ffff800000105325:	80 ff ff 
ffff800000105328:	8b 52 6c             	mov    0x6c(%rdx),%edx
ffff80000010532b:	83 ea 01             	sub    $0x1,%edx
ffff80000010532e:	39 d0                	cmp    %edx,%eax
ffff800000105330:	7c 16                	jl     ffff800000105348 <log_write+0x59>
    panic("too big a transaction");
ffff800000105332:	48 bf 17 ca 10 00 00 	movabs $0xffff80000010ca17,%rdi
ffff800000105339:	80 ff ff 
ffff80000010533c:	48 b8 f9 0b 10 00 00 	movabs $0xffff800000100bf9,%rax
ffff800000105343:	80 ff ff 
ffff800000105346:	ff d0                	callq  *%rax
  if (log.outstanding < 1)
ffff800000105348:	48 b8 e0 71 11 00 00 	movabs $0xffff8000001171e0,%rax
ffff80000010534f:	80 ff ff 
ffff800000105352:	8b 40 70             	mov    0x70(%rax),%eax
ffff800000105355:	85 c0                	test   %eax,%eax
ffff800000105357:	7f 16                	jg     ffff80000010536f <log_write+0x80>
    panic("log_write outside of trans");
ffff800000105359:	48 bf 2d ca 10 00 00 	movabs $0xffff80000010ca2d,%rdi
ffff800000105360:	80 ff ff 
ffff800000105363:	48 b8 f9 0b 10 00 00 	movabs $0xffff800000100bf9,%rax
ffff80000010536a:	80 ff ff 
ffff80000010536d:	ff d0                	callq  *%rax

  acquire(&log.lock);
ffff80000010536f:	48 bf e0 71 11 00 00 	movabs $0xffff8000001171e0,%rdi
ffff800000105376:	80 ff ff 
ffff800000105379:	48 b8 17 7f 10 00 00 	movabs $0xffff800000107f17,%rax
ffff800000105380:	80 ff ff 
ffff800000105383:	ff d0                	callq  *%rax
  for (i = 0; i < log.lh.n; i++) {
ffff800000105385:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
ffff80000010538c:	eb 29                	jmp    ffff8000001053b7 <log_write+0xc8>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
ffff80000010538e:	48 b8 e0 71 11 00 00 	movabs $0xffff8000001171e0,%rax
ffff800000105395:	80 ff ff 
ffff800000105398:	8b 55 fc             	mov    -0x4(%rbp),%edx
ffff80000010539b:	48 63 d2             	movslq %edx,%rdx
ffff80000010539e:	48 83 c2 1c          	add    $0x1c,%rdx
ffff8000001053a2:	8b 44 90 10          	mov    0x10(%rax,%rdx,4),%eax
ffff8000001053a6:	89 c2                	mov    %eax,%edx
ffff8000001053a8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff8000001053ac:	8b 40 08             	mov    0x8(%rax),%eax
ffff8000001053af:	39 c2                	cmp    %eax,%edx
ffff8000001053b1:	74 18                	je     ffff8000001053cb <log_write+0xdc>
  for (i = 0; i < log.lh.n; i++) {
ffff8000001053b3:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
ffff8000001053b7:	48 b8 e0 71 11 00 00 	movabs $0xffff8000001171e0,%rax
ffff8000001053be:	80 ff ff 
ffff8000001053c1:	8b 40 7c             	mov    0x7c(%rax),%eax
ffff8000001053c4:	39 45 fc             	cmp    %eax,-0x4(%rbp)
ffff8000001053c7:	7c c5                	jl     ffff80000010538e <log_write+0x9f>
ffff8000001053c9:	eb 01                	jmp    ffff8000001053cc <log_write+0xdd>
      break;
ffff8000001053cb:	90                   	nop
  }
  log.lh.block[i] = b->blockno;
ffff8000001053cc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff8000001053d0:	8b 40 08             	mov    0x8(%rax),%eax
ffff8000001053d3:	89 c1                	mov    %eax,%ecx
ffff8000001053d5:	48 b8 e0 71 11 00 00 	movabs $0xffff8000001171e0,%rax
ffff8000001053dc:	80 ff ff 
ffff8000001053df:	8b 55 fc             	mov    -0x4(%rbp),%edx
ffff8000001053e2:	48 63 d2             	movslq %edx,%rdx
ffff8000001053e5:	48 83 c2 1c          	add    $0x1c,%rdx
ffff8000001053e9:	89 4c 90 10          	mov    %ecx,0x10(%rax,%rdx,4)
  if (i == log.lh.n)
ffff8000001053ed:	48 b8 e0 71 11 00 00 	movabs $0xffff8000001171e0,%rax
ffff8000001053f4:	80 ff ff 
ffff8000001053f7:	8b 40 7c             	mov    0x7c(%rax),%eax
ffff8000001053fa:	39 45 fc             	cmp    %eax,-0x4(%rbp)
ffff8000001053fd:	75 1d                	jne    ffff80000010541c <log_write+0x12d>
    log.lh.n++;
ffff8000001053ff:	48 b8 e0 71 11 00 00 	movabs $0xffff8000001171e0,%rax
ffff800000105406:	80 ff ff 
ffff800000105409:	8b 40 7c             	mov    0x7c(%rax),%eax
ffff80000010540c:	8d 50 01             	lea    0x1(%rax),%edx
ffff80000010540f:	48 b8 e0 71 11 00 00 	movabs $0xffff8000001171e0,%rax
ffff800000105416:	80 ff ff 
ffff800000105419:	89 50 7c             	mov    %edx,0x7c(%rax)
  b->flags |= B_DIRTY; // prevent eviction
ffff80000010541c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000105420:	8b 00                	mov    (%rax),%eax
ffff800000105422:	83 c8 04             	or     $0x4,%eax
ffff800000105425:	89 c2                	mov    %eax,%edx
ffff800000105427:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff80000010542b:	89 10                	mov    %edx,(%rax)
  release(&log.lock);
ffff80000010542d:	48 bf e0 71 11 00 00 	movabs $0xffff8000001171e0,%rdi
ffff800000105434:	80 ff ff 
ffff800000105437:	48 b8 b4 7f 10 00 00 	movabs $0xffff800000107fb4,%rax
ffff80000010543e:	80 ff ff 
ffff800000105441:	ff d0                	callq  *%rax
}
ffff800000105443:	90                   	nop
ffff800000105444:	c9                   	leaveq 
ffff800000105445:	c3                   	retq   

ffff800000105446 <v2p>:
#define KERNBASE 0xFFFF800000000000 // First kernel virtual address

#define KERNLINK (KERNBASE+EXTMEM)  // Address where kernel is linked

#ifndef __ASSEMBLER__
static inline addr_t v2p(void *a) {
ffff800000105446:	f3 0f 1e fa          	endbr64 
ffff80000010544a:	55                   	push   %rbp
ffff80000010544b:	48 89 e5             	mov    %rsp,%rbp
ffff80000010544e:	48 83 ec 08          	sub    $0x8,%rsp
ffff800000105452:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  return ((addr_t) (a)) - ((addr_t)KERNBASE);
ffff800000105456:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff80000010545a:	48 ba 00 00 00 00 00 	movabs $0x800000000000,%rdx
ffff800000105461:	80 00 00 
ffff800000105464:	48 01 d0             	add    %rdx,%rax
}
ffff800000105467:	c9                   	leaveq 
ffff800000105468:	c3                   	retq   

ffff800000105469 <xchg>:

static inline uint
xchg(volatile uint *addr, addr_t newval)
{
ffff800000105469:	f3 0f 1e fa          	endbr64 
ffff80000010546d:	55                   	push   %rbp
ffff80000010546e:	48 89 e5             	mov    %rsp,%rbp
ffff800000105471:	48 83 ec 20          	sub    $0x20,%rsp
ffff800000105475:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
ffff800000105479:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
ffff80000010547d:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
ffff800000105481:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
ffff800000105485:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
ffff800000105489:	f0 87 02             	lock xchg %eax,(%rdx)
ffff80000010548c:	89 45 fc             	mov    %eax,-0x4(%rbp)
               "+m" (*addr), "=a" (result) :
               "1" (newval) :
               "cc");
  return result;
ffff80000010548f:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
ffff800000105492:	c9                   	leaveq 
ffff800000105493:	c3                   	retq   

ffff800000105494 <main>:
// Bootstrap processor starts running C code here.
// Allocate a real stack and switch to it, first
// doing some setup required for memory allocator to work.
int
main(void)
{
ffff800000105494:	f3 0f 1e fa          	endbr64 
ffff800000105498:	55                   	push   %rbp
ffff800000105499:	48 89 e5             	mov    %rsp,%rbp
  uartearlyinit();
ffff80000010549c:	48 b8 37 a6 10 00 00 	movabs $0xffff80000010a637,%rax
ffff8000001054a3:	80 ff ff 
ffff8000001054a6:	ff d0                	callq  *%rax
  kinit1(end, P2V(4*1024*1024)); // phys page allocator
ffff8000001054a8:	48 be 00 00 40 00 00 	movabs $0xffff800000400000,%rsi
ffff8000001054af:	80 ff ff 
ffff8000001054b2:	48 bf 00 d0 11 00 00 	movabs $0xffff80000011d000,%rdi
ffff8000001054b9:	80 ff ff 
ffff8000001054bc:	48 b8 3d 40 10 00 00 	movabs $0xffff80000010403d,%rax
ffff8000001054c3:	80 ff ff 
ffff8000001054c6:	ff d0                	callq  *%rax
  kvmalloc();      // kernel page table
ffff8000001054c8:	48 b8 e9 b8 10 00 00 	movabs $0xffff80000010b8e9,%rax
ffff8000001054cf:	80 ff ff 
ffff8000001054d2:	ff d0                	callq  *%rax
  mpinit();        // detect other processors
ffff8000001054d4:	48 b8 c3 5a 10 00 00 	movabs $0xffff800000105ac3,%rax
ffff8000001054db:	80 ff ff 
ffff8000001054de:	ff d0                	callq  *%rax
  lapicinit();     // interrupt controller
ffff8000001054e0:	48 b8 92 45 10 00 00 	movabs $0xffff800000104592,%rax
ffff8000001054e7:	80 ff ff 
ffff8000001054ea:	ff d0                	callq  *%rax
  tvinit();        // trap vectors
ffff8000001054ec:	48 b8 ab a1 10 00 00 	movabs $0xffff80000010a1ab,%rax
ffff8000001054f3:	80 ff ff 
ffff8000001054f6:	ff d0                	callq  *%rax
  seginit();       // segment descriptors
ffff8000001054f8:	48 b8 26 b4 10 00 00 	movabs $0xffff80000010b426,%rax
ffff8000001054ff:	80 ff ff 
ffff800000105502:	ff d0                	callq  *%rax
  cprintf("\ncpu%d: starting xv6\n\n", cpunum());
ffff800000105504:	48 b8 27 47 10 00 00 	movabs $0xffff800000104727,%rax
ffff80000010550b:	80 ff ff 
ffff80000010550e:	ff d0                	callq  *%rax
ffff800000105510:	89 c6                	mov    %eax,%esi
ffff800000105512:	48 bf 48 ca 10 00 00 	movabs $0xffff80000010ca48,%rdi
ffff800000105519:	80 ff ff 
ffff80000010551c:	b8 00 00 00 00       	mov    $0x0,%eax
ffff800000105521:	48 ba 18 08 10 00 00 	movabs $0xffff800000100818,%rdx
ffff800000105528:	80 ff ff 
ffff80000010552b:	ff d2                	callq  *%rdx
  ioapicinit();    // another interrupt controller
ffff80000010552d:	48 b8 03 3f 10 00 00 	movabs $0xffff800000103f03,%rax
ffff800000105534:	80 ff ff 
ffff800000105537:	ff d0                	callq  *%rax
  consoleinit();   // console hardware
ffff800000105539:	48 b8 9b 14 10 00 00 	movabs $0xffff80000010149b,%rax
ffff800000105540:	80 ff ff 
ffff800000105543:	ff d0                	callq  *%rax
  uartinit();      // serial port
ffff800000105545:	48 b8 3f a7 10 00 00 	movabs $0xffff80000010a73f,%rax
ffff80000010554c:	80 ff ff 
ffff80000010554f:	ff d0                	callq  *%rax
  pinit();         // process table
ffff800000105551:	48 b8 17 62 10 00 00 	movabs $0xffff800000106217,%rax
ffff800000105558:	80 ff ff 
ffff80000010555b:	ff d0                	callq  *%rax
  binit();         // buffer cache
ffff80000010555d:	48 b8 1a 01 10 00 00 	movabs $0xffff80000010011a,%rax
ffff800000105564:	80 ff ff 
ffff800000105567:	ff d0                	callq  *%rax
  fileinit();      // file table
ffff800000105569:	48 b8 59 1b 10 00 00 	movabs $0xffff800000101b59,%rax
ffff800000105570:	80 ff ff 
ffff800000105573:	ff d0                	callq  *%rax
  ideinit();       // disk
ffff800000105575:	48 b8 66 39 10 00 00 	movabs $0xffff800000103966,%rax
ffff80000010557c:	80 ff ff 
ffff80000010557f:	ff d0                	callq  *%rax
  startothers();   // start other processors
ffff800000105581:	48 b8 81 56 10 00 00 	movabs $0xffff800000105681,%rax
ffff800000105588:	80 ff ff 
ffff80000010558b:	ff d0                	callq  *%rax
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers()
ffff80000010558d:	48 be 00 00 00 0e 00 	movabs $0xffff80000e000000,%rsi
ffff800000105594:	80 ff ff 
ffff800000105597:	48 bf 00 00 40 00 00 	movabs $0xffff800000400000,%rdi
ffff80000010559e:	80 ff ff 
ffff8000001055a1:	48 b8 9f 40 10 00 00 	movabs $0xffff80000010409f,%rax
ffff8000001055a8:	80 ff ff 
ffff8000001055ab:	ff d0                	callq  *%rax
  kthinit();       // start kernel threads
ffff8000001055ad:	48 b8 ac 79 10 00 00 	movabs $0xffff8000001079ac,%rax
ffff8000001055b4:	80 ff ff 
ffff8000001055b7:	ff d0                	callq  *%rax
  userinit();      // first user process
ffff8000001055b9:	48 b8 cd 63 10 00 00 	movabs $0xffff8000001063cd,%rax
ffff8000001055c0:	80 ff ff 
ffff8000001055c3:	ff d0                	callq  *%rax
  mpmain();        // finish this processor's setup
ffff8000001055c5:	48 b8 09 56 10 00 00 	movabs $0xffff800000105609,%rax
ffff8000001055cc:	80 ff ff 
ffff8000001055cf:	ff d0                	callq  *%rax

ffff8000001055d1 <mpenter>:
}

// Other CPUs jump here from entryother.S.
void
mpenter(void)
{
ffff8000001055d1:	f3 0f 1e fa          	endbr64 
ffff8000001055d5:	55                   	push   %rbp
ffff8000001055d6:	48 89 e5             	mov    %rsp,%rbp
  switchkvm();
ffff8000001055d9:	48 b8 f3 bc 10 00 00 	movabs $0xffff80000010bcf3,%rax
ffff8000001055e0:	80 ff ff 
ffff8000001055e3:	ff d0                	callq  *%rax
  seginit();
ffff8000001055e5:	48 b8 26 b4 10 00 00 	movabs $0xffff80000010b426,%rax
ffff8000001055ec:	80 ff ff 
ffff8000001055ef:	ff d0                	callq  *%rax
  lapicinit();
ffff8000001055f1:	48 b8 92 45 10 00 00 	movabs $0xffff800000104592,%rax
ffff8000001055f8:	80 ff ff 
ffff8000001055fb:	ff d0                	callq  *%rax
  mpmain();
ffff8000001055fd:	48 b8 09 56 10 00 00 	movabs $0xffff800000105609,%rax
ffff800000105604:	80 ff ff 
ffff800000105607:	ff d0                	callq  *%rax

ffff800000105609 <mpmain>:
}

// Common CPU setup code.
static void
mpmain(void)
{
ffff800000105609:	f3 0f 1e fa          	endbr64 
ffff80000010560d:	55                   	push   %rbp
ffff80000010560e:	48 89 e5             	mov    %rsp,%rbp
  cprintf("cpu%d: starting\n", cpunum());
ffff800000105611:	48 b8 27 47 10 00 00 	movabs $0xffff800000104727,%rax
ffff800000105618:	80 ff ff 
ffff80000010561b:	ff d0                	callq  *%rax
ffff80000010561d:	89 c6                	mov    %eax,%esi
ffff80000010561f:	48 bf 5f ca 10 00 00 	movabs $0xffff80000010ca5f,%rdi
ffff800000105626:	80 ff ff 
ffff800000105629:	b8 00 00 00 00       	mov    $0x0,%eax
ffff80000010562e:	48 ba 18 08 10 00 00 	movabs $0xffff800000100818,%rdx
ffff800000105635:	80 ff ff 
ffff800000105638:	ff d2                	callq  *%rdx
  idtinit();       // load idt register
ffff80000010563a:	48 b8 7f a1 10 00 00 	movabs $0xffff80000010a17f,%rax
ffff800000105641:	80 ff ff 
ffff800000105644:	ff d0                	callq  *%rax
  syscallinit();   // syscall set up
ffff800000105646:	48 b8 ae b3 10 00 00 	movabs $0xffff80000010b3ae,%rax
ffff80000010564d:	80 ff ff 
ffff800000105650:	ff d0                	callq  *%rax
  xchg(&cpu->started, 1); // tell startothers() we're up
ffff800000105652:	48 c7 c0 f0 ff ff ff 	mov    $0xfffffffffffffff0,%rax
ffff800000105659:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffff80000010565d:	48 83 c0 10          	add    $0x10,%rax
ffff800000105661:	be 01 00 00 00       	mov    $0x1,%esi
ffff800000105666:	48 89 c7             	mov    %rax,%rdi
ffff800000105669:	48 b8 69 54 10 00 00 	movabs $0xffff800000105469,%rax
ffff800000105670:	80 ff ff 
ffff800000105673:	ff d0                	callq  *%rax
  scheduler();     // start running processes
ffff800000105675:	48 b8 34 6c 10 00 00 	movabs $0xffff800000106c34,%rax
ffff80000010567c:	80 ff ff 
ffff80000010567f:	ff d0                	callq  *%rax

ffff800000105681 <startothers>:
void entry32mp(void);

// Start the non-boot (AP) processors.
static void
startothers(void)
{
ffff800000105681:	f3 0f 1e fa          	endbr64 
ffff800000105685:	55                   	push   %rbp
ffff800000105686:	48 89 e5             	mov    %rsp,%rbp
ffff800000105689:	48 83 ec 20          	sub    $0x20,%rsp
  char *stack;

  // Write entry code to unused memory at 0x7000.
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
ffff80000010568d:	48 b8 00 70 00 00 00 	movabs $0xffff800000007000,%rax
ffff800000105694:	80 ff ff 
ffff800000105697:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
  memmove(code, _binary_entryother_start,
ffff80000010569b:	48 b8 72 00 00 00 00 	movabs $0x72,%rax
ffff8000001056a2:	00 00 00 
ffff8000001056a5:	89 c2                	mov    %eax,%edx
ffff8000001056a7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff8000001056ab:	48 be 94 de 10 00 00 	movabs $0xffff80000010de94,%rsi
ffff8000001056b2:	80 ff ff 
ffff8000001056b5:	48 89 c7             	mov    %rax,%rdi
ffff8000001056b8:	48 b8 ca 83 10 00 00 	movabs $0xffff8000001083ca,%rax
ffff8000001056bf:	80 ff ff 
ffff8000001056c2:	ff d0                	callq  *%rax
          (addr_t)_binary_entryother_size);

  for(c = cpus; c < cpus+ncpu; c++){
ffff8000001056c4:	48 b8 e0 72 11 00 00 	movabs $0xffff8000001172e0,%rax
ffff8000001056cb:	80 ff ff 
ffff8000001056ce:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
ffff8000001056d2:	e9 c0 00 00 00       	jmpq   ffff800000105797 <startothers+0x116>
    if(c == cpus+cpunum())  // We've started already.
ffff8000001056d7:	48 b8 27 47 10 00 00 	movabs $0xffff800000104727,%rax
ffff8000001056de:	80 ff ff 
ffff8000001056e1:	ff d0                	callq  *%rax
ffff8000001056e3:	48 63 d0             	movslq %eax,%rdx
ffff8000001056e6:	48 89 d0             	mov    %rdx,%rax
ffff8000001056e9:	48 c1 e0 02          	shl    $0x2,%rax
ffff8000001056ed:	48 01 d0             	add    %rdx,%rax
ffff8000001056f0:	48 c1 e0 03          	shl    $0x3,%rax
ffff8000001056f4:	48 89 c2             	mov    %rax,%rdx
ffff8000001056f7:	48 b8 e0 72 11 00 00 	movabs $0xffff8000001172e0,%rax
ffff8000001056fe:	80 ff ff 
ffff800000105701:	48 01 d0             	add    %rdx,%rax
ffff800000105704:	48 39 45 f8          	cmp    %rax,-0x8(%rbp)
ffff800000105708:	0f 84 83 00 00 00    	je     ffff800000105791 <startothers+0x110>
      continue;

    // Tell entryother.S what stack to use, where to enter, and what
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
ffff80000010570e:	48 b8 34 42 10 00 00 	movabs $0xffff800000104234,%rax
ffff800000105715:	80 ff ff 
ffff800000105718:	ff d0                	callq  *%rax
ffff80000010571a:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
    *(uint32*)(code-4) = 0x8000; // enough stack to get us to entry64mp
ffff80000010571e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff800000105722:	48 83 e8 04          	sub    $0x4,%rax
ffff800000105726:	c7 00 00 80 00 00    	movl   $0x8000,(%rax)
    *(uint32*)(code-8) = v2p(entry32mp);
ffff80000010572c:	48 bf 49 00 10 00 00 	movabs $0xffff800000100049,%rdi
ffff800000105733:	80 ff ff 
ffff800000105736:	48 b8 46 54 10 00 00 	movabs $0xffff800000105446,%rax
ffff80000010573d:	80 ff ff 
ffff800000105740:	ff d0                	callq  *%rax
ffff800000105742:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
ffff800000105746:	48 83 ea 08          	sub    $0x8,%rdx
ffff80000010574a:	89 02                	mov    %eax,(%rdx)
    *(uint64*)(code-16) = (uint64) (stack + KSTACKSIZE);
ffff80000010574c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000105750:	48 8d 90 00 10 00 00 	lea    0x1000(%rax),%rdx
ffff800000105757:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff80000010575b:	48 83 e8 10          	sub    $0x10,%rax
ffff80000010575f:	48 89 10             	mov    %rdx,(%rax)

    lapicstartap(c->apicid, V2P(code));
ffff800000105762:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff800000105766:	89 c2                	mov    %eax,%edx
ffff800000105768:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff80000010576c:	0f b6 40 01          	movzbl 0x1(%rax),%eax
ffff800000105770:	0f b6 c0             	movzbl %al,%eax
ffff800000105773:	89 d6                	mov    %edx,%esi
ffff800000105775:	89 c7                	mov    %eax,%edi
ffff800000105777:	48 b8 6f 48 10 00 00 	movabs $0xffff80000010486f,%rax
ffff80000010577e:	80 ff ff 
ffff800000105781:	ff d0                	callq  *%rax

    // wait for cpu to finish mpmain()
    while(c->started == 0)
ffff800000105783:	90                   	nop
ffff800000105784:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000105788:	8b 40 10             	mov    0x10(%rax),%eax
ffff80000010578b:	85 c0                	test   %eax,%eax
ffff80000010578d:	74 f5                	je     ffff800000105784 <startothers+0x103>
ffff80000010578f:	eb 01                	jmp    ffff800000105792 <startothers+0x111>
      continue;
ffff800000105791:	90                   	nop
  for(c = cpus; c < cpus+ncpu; c++){
ffff800000105792:	48 83 45 f8 28       	addq   $0x28,-0x8(%rbp)
ffff800000105797:	48 b8 20 74 11 00 00 	movabs $0xffff800000117420,%rax
ffff80000010579e:	80 ff ff 
ffff8000001057a1:	8b 00                	mov    (%rax),%eax
ffff8000001057a3:	48 63 d0             	movslq %eax,%rdx
ffff8000001057a6:	48 89 d0             	mov    %rdx,%rax
ffff8000001057a9:	48 c1 e0 02          	shl    $0x2,%rax
ffff8000001057ad:	48 01 d0             	add    %rdx,%rax
ffff8000001057b0:	48 c1 e0 03          	shl    $0x3,%rax
ffff8000001057b4:	48 89 c2             	mov    %rax,%rdx
ffff8000001057b7:	48 b8 e0 72 11 00 00 	movabs $0xffff8000001172e0,%rax
ffff8000001057be:	80 ff ff 
ffff8000001057c1:	48 01 d0             	add    %rdx,%rax
ffff8000001057c4:	48 39 45 f8          	cmp    %rax,-0x8(%rbp)
ffff8000001057c8:	0f 82 09 ff ff ff    	jb     ffff8000001056d7 <startothers+0x56>
      ;
  }
}
ffff8000001057ce:	90                   	nop
ffff8000001057cf:	90                   	nop
ffff8000001057d0:	c9                   	leaveq 
ffff8000001057d1:	c3                   	retq   

ffff8000001057d2 <inb>:
{
ffff8000001057d2:	f3 0f 1e fa          	endbr64 
ffff8000001057d6:	55                   	push   %rbp
ffff8000001057d7:	48 89 e5             	mov    %rsp,%rbp
ffff8000001057da:	48 83 ec 18          	sub    $0x18,%rsp
ffff8000001057de:	89 f8                	mov    %edi,%eax
ffff8000001057e0:	66 89 45 ec          	mov    %ax,-0x14(%rbp)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
ffff8000001057e4:	0f b7 45 ec          	movzwl -0x14(%rbp),%eax
ffff8000001057e8:	89 c2                	mov    %eax,%edx
ffff8000001057ea:	ec                   	in     (%dx),%al
ffff8000001057eb:	88 45 ff             	mov    %al,-0x1(%rbp)
  return data;
ffff8000001057ee:	0f b6 45 ff          	movzbl -0x1(%rbp),%eax
}
ffff8000001057f2:	c9                   	leaveq 
ffff8000001057f3:	c3                   	retq   

ffff8000001057f4 <outb>:
{
ffff8000001057f4:	f3 0f 1e fa          	endbr64 
ffff8000001057f8:	55                   	push   %rbp
ffff8000001057f9:	48 89 e5             	mov    %rsp,%rbp
ffff8000001057fc:	48 83 ec 08          	sub    $0x8,%rsp
ffff800000105800:	89 f8                	mov    %edi,%eax
ffff800000105802:	89 f2                	mov    %esi,%edx
ffff800000105804:	66 89 45 fc          	mov    %ax,-0x4(%rbp)
ffff800000105808:	89 d0                	mov    %edx,%eax
ffff80000010580a:	88 45 f8             	mov    %al,-0x8(%rbp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
ffff80000010580d:	0f b6 45 f8          	movzbl -0x8(%rbp),%eax
ffff800000105811:	0f b7 55 fc          	movzwl -0x4(%rbp),%edx
ffff800000105815:	ee                   	out    %al,(%dx)
}
ffff800000105816:	90                   	nop
ffff800000105817:	c9                   	leaveq 
ffff800000105818:	c3                   	retq   

ffff800000105819 <sum>:
int ncpu;
uchar ioapicid;

static uchar
sum(uchar *addr, int len)
{
ffff800000105819:	f3 0f 1e fa          	endbr64 
ffff80000010581d:	55                   	push   %rbp
ffff80000010581e:	48 89 e5             	mov    %rsp,%rbp
ffff800000105821:	48 83 ec 20          	sub    $0x20,%rsp
ffff800000105825:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
ffff800000105829:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  int i, sum;

  sum = 0;
ffff80000010582c:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%rbp)
  for(i=0; i<len; i++)
ffff800000105833:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
ffff80000010583a:	eb 1a                	jmp    ffff800000105856 <sum+0x3d>
    sum += addr[i];
ffff80000010583c:	8b 45 fc             	mov    -0x4(%rbp),%eax
ffff80000010583f:	48 63 d0             	movslq %eax,%rdx
ffff800000105842:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000105846:	48 01 d0             	add    %rdx,%rax
ffff800000105849:	0f b6 00             	movzbl (%rax),%eax
ffff80000010584c:	0f b6 c0             	movzbl %al,%eax
ffff80000010584f:	01 45 f8             	add    %eax,-0x8(%rbp)
  for(i=0; i<len; i++)
ffff800000105852:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
ffff800000105856:	8b 45 fc             	mov    -0x4(%rbp),%eax
ffff800000105859:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
ffff80000010585c:	7c de                	jl     ffff80000010583c <sum+0x23>
  return sum;
ffff80000010585e:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
ffff800000105861:	c9                   	leaveq 
ffff800000105862:	c3                   	retq   

ffff800000105863 <mpsearch1>:

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(addr_t a, int len)
{
ffff800000105863:	f3 0f 1e fa          	endbr64 
ffff800000105867:	55                   	push   %rbp
ffff800000105868:	48 89 e5             	mov    %rsp,%rbp
ffff80000010586b:	48 83 ec 30          	sub    $0x30,%rsp
ffff80000010586f:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
ffff800000105873:	89 75 d4             	mov    %esi,-0x2c(%rbp)
  uchar *e, *p, *addr;
  addr = P2V(a);
ffff800000105876:	48 ba 00 00 00 00 00 	movabs $0xffff800000000000,%rdx
ffff80000010587d:	80 ff ff 
ffff800000105880:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
ffff800000105884:	48 01 d0             	add    %rdx,%rax
ffff800000105887:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
  e = addr+len;
ffff80000010588b:	8b 45 d4             	mov    -0x2c(%rbp),%eax
ffff80000010588e:	48 63 d0             	movslq %eax,%rdx
ffff800000105891:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff800000105895:	48 01 d0             	add    %rdx,%rax
ffff800000105898:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
  for(p = addr; p < e; p += sizeof(struct mp))
ffff80000010589c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff8000001058a0:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
ffff8000001058a4:	eb 4d                	jmp    ffff8000001058f3 <mpsearch1+0x90>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
ffff8000001058a6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff8000001058aa:	ba 04 00 00 00       	mov    $0x4,%edx
ffff8000001058af:	48 be 70 ca 10 00 00 	movabs $0xffff80000010ca70,%rsi
ffff8000001058b6:	80 ff ff 
ffff8000001058b9:	48 89 c7             	mov    %rax,%rdi
ffff8000001058bc:	48 b8 57 83 10 00 00 	movabs $0xffff800000108357,%rax
ffff8000001058c3:	80 ff ff 
ffff8000001058c6:	ff d0                	callq  *%rax
ffff8000001058c8:	85 c0                	test   %eax,%eax
ffff8000001058ca:	75 22                	jne    ffff8000001058ee <mpsearch1+0x8b>
ffff8000001058cc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff8000001058d0:	be 10 00 00 00       	mov    $0x10,%esi
ffff8000001058d5:	48 89 c7             	mov    %rax,%rdi
ffff8000001058d8:	48 b8 19 58 10 00 00 	movabs $0xffff800000105819,%rax
ffff8000001058df:	80 ff ff 
ffff8000001058e2:	ff d0                	callq  *%rax
ffff8000001058e4:	84 c0                	test   %al,%al
ffff8000001058e6:	75 06                	jne    ffff8000001058ee <mpsearch1+0x8b>
      return (struct mp*)p;
ffff8000001058e8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff8000001058ec:	eb 14                	jmp    ffff800000105902 <mpsearch1+0x9f>
  for(p = addr; p < e; p += sizeof(struct mp))
ffff8000001058ee:	48 83 45 f8 10       	addq   $0x10,-0x8(%rbp)
ffff8000001058f3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff8000001058f7:	48 3b 45 e8          	cmp    -0x18(%rbp),%rax
ffff8000001058fb:	72 a9                	jb     ffff8000001058a6 <mpsearch1+0x43>
  return 0;
ffff8000001058fd:	b8 00 00 00 00       	mov    $0x0,%eax
}
ffff800000105902:	c9                   	leaveq 
ffff800000105903:	c3                   	retq   

ffff800000105904 <mpsearch>:
// 1) in the first KB of the EBDA;
// 2) in the last KB of system base memory;
// 3) in the BIOS ROM between 0xE0000 and 0xFFFFF.
static struct mp*
mpsearch(void)
{
ffff800000105904:	f3 0f 1e fa          	endbr64 
ffff800000105908:	55                   	push   %rbp
ffff800000105909:	48 89 e5             	mov    %rsp,%rbp
ffff80000010590c:	48 83 ec 20          	sub    $0x20,%rsp
  uchar *bda;
  uint p;
  struct mp *mp;

  bda = (uchar *) P2V(0x400);
ffff800000105910:	48 b8 00 04 00 00 00 	movabs $0xffff800000000400,%rax
ffff800000105917:	80 ff ff 
ffff80000010591a:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
ffff80000010591e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000105922:	48 83 c0 0f          	add    $0xf,%rax
ffff800000105926:	0f b6 00             	movzbl (%rax),%eax
ffff800000105929:	0f b6 c0             	movzbl %al,%eax
ffff80000010592c:	c1 e0 08             	shl    $0x8,%eax
ffff80000010592f:	89 c2                	mov    %eax,%edx
ffff800000105931:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000105935:	48 83 c0 0e          	add    $0xe,%rax
ffff800000105939:	0f b6 00             	movzbl (%rax),%eax
ffff80000010593c:	0f b6 c0             	movzbl %al,%eax
ffff80000010593f:	09 d0                	or     %edx,%eax
ffff800000105941:	c1 e0 04             	shl    $0x4,%eax
ffff800000105944:	89 45 f4             	mov    %eax,-0xc(%rbp)
ffff800000105947:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
ffff80000010594b:	74 28                	je     ffff800000105975 <mpsearch+0x71>
    if((mp = mpsearch1(p, 1024)))
ffff80000010594d:	8b 45 f4             	mov    -0xc(%rbp),%eax
ffff800000105950:	be 00 04 00 00       	mov    $0x400,%esi
ffff800000105955:	48 89 c7             	mov    %rax,%rdi
ffff800000105958:	48 b8 63 58 10 00 00 	movabs $0xffff800000105863,%rax
ffff80000010595f:	80 ff ff 
ffff800000105962:	ff d0                	callq  *%rax
ffff800000105964:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
ffff800000105968:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
ffff80000010596d:	74 5e                	je     ffff8000001059cd <mpsearch+0xc9>
      return mp;
ffff80000010596f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000105973:	eb 6e                	jmp    ffff8000001059e3 <mpsearch+0xdf>
  } else {
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
ffff800000105975:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000105979:	48 83 c0 14          	add    $0x14,%rax
ffff80000010597d:	0f b6 00             	movzbl (%rax),%eax
ffff800000105980:	0f b6 c0             	movzbl %al,%eax
ffff800000105983:	c1 e0 08             	shl    $0x8,%eax
ffff800000105986:	89 c2                	mov    %eax,%edx
ffff800000105988:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff80000010598c:	48 83 c0 13          	add    $0x13,%rax
ffff800000105990:	0f b6 00             	movzbl (%rax),%eax
ffff800000105993:	0f b6 c0             	movzbl %al,%eax
ffff800000105996:	09 d0                	or     %edx,%eax
ffff800000105998:	c1 e0 0a             	shl    $0xa,%eax
ffff80000010599b:	89 45 f4             	mov    %eax,-0xc(%rbp)
    if((mp = mpsearch1(p-1024, 1024)))
ffff80000010599e:	8b 45 f4             	mov    -0xc(%rbp),%eax
ffff8000001059a1:	2d 00 04 00 00       	sub    $0x400,%eax
ffff8000001059a6:	89 c0                	mov    %eax,%eax
ffff8000001059a8:	be 00 04 00 00       	mov    $0x400,%esi
ffff8000001059ad:	48 89 c7             	mov    %rax,%rdi
ffff8000001059b0:	48 b8 63 58 10 00 00 	movabs $0xffff800000105863,%rax
ffff8000001059b7:	80 ff ff 
ffff8000001059ba:	ff d0                	callq  *%rax
ffff8000001059bc:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
ffff8000001059c0:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
ffff8000001059c5:	74 06                	je     ffff8000001059cd <mpsearch+0xc9>
      return mp;
ffff8000001059c7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff8000001059cb:	eb 16                	jmp    ffff8000001059e3 <mpsearch+0xdf>
  }
  return mpsearch1(0xF0000, 0x10000);
ffff8000001059cd:	be 00 00 01 00       	mov    $0x10000,%esi
ffff8000001059d2:	bf 00 00 0f 00       	mov    $0xf0000,%edi
ffff8000001059d7:	48 b8 63 58 10 00 00 	movabs $0xffff800000105863,%rax
ffff8000001059de:	80 ff ff 
ffff8000001059e1:	ff d0                	callq  *%rax
}
ffff8000001059e3:	c9                   	leaveq 
ffff8000001059e4:	c3                   	retq   

ffff8000001059e5 <mpconfig>:
// Check for correct signature, calculate the checksum and,
// if correct, check the version.
// To do: check extended table checksum.
static struct mpconf*
mpconfig(struct mp **pmp)
{
ffff8000001059e5:	f3 0f 1e fa          	endbr64 
ffff8000001059e9:	55                   	push   %rbp
ffff8000001059ea:	48 89 e5             	mov    %rsp,%rbp
ffff8000001059ed:	48 83 ec 20          	sub    $0x20,%rsp
ffff8000001059f1:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  struct mpconf *conf;
  struct mp *mp;

  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
ffff8000001059f5:	48 b8 04 59 10 00 00 	movabs $0xffff800000105904,%rax
ffff8000001059fc:	80 ff ff 
ffff8000001059ff:	ff d0                	callq  *%rax
ffff800000105a01:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
ffff800000105a05:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
ffff800000105a0a:	74 0b                	je     ffff800000105a17 <mpconfig+0x32>
ffff800000105a0c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000105a10:	8b 40 04             	mov    0x4(%rax),%eax
ffff800000105a13:	85 c0                	test   %eax,%eax
ffff800000105a15:	75 0a                	jne    ffff800000105a21 <mpconfig+0x3c>
    return 0;
ffff800000105a17:	b8 00 00 00 00       	mov    $0x0,%eax
ffff800000105a1c:	e9 a0 00 00 00       	jmpq   ffff800000105ac1 <mpconfig+0xdc>
  conf = (struct mpconf*) P2V((addr_t) mp->physaddr);
ffff800000105a21:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000105a25:	8b 40 04             	mov    0x4(%rax),%eax
ffff800000105a28:	89 c2                	mov    %eax,%edx
ffff800000105a2a:	48 b8 00 00 00 00 00 	movabs $0xffff800000000000,%rax
ffff800000105a31:	80 ff ff 
ffff800000105a34:	48 01 d0             	add    %rdx,%rax
ffff800000105a37:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
  if(memcmp(conf, "PCMP", 4) != 0)
ffff800000105a3b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff800000105a3f:	ba 04 00 00 00       	mov    $0x4,%edx
ffff800000105a44:	48 be 75 ca 10 00 00 	movabs $0xffff80000010ca75,%rsi
ffff800000105a4b:	80 ff ff 
ffff800000105a4e:	48 89 c7             	mov    %rax,%rdi
ffff800000105a51:	48 b8 57 83 10 00 00 	movabs $0xffff800000108357,%rax
ffff800000105a58:	80 ff ff 
ffff800000105a5b:	ff d0                	callq  *%rax
ffff800000105a5d:	85 c0                	test   %eax,%eax
ffff800000105a5f:	74 07                	je     ffff800000105a68 <mpconfig+0x83>
    return 0;
ffff800000105a61:	b8 00 00 00 00       	mov    $0x0,%eax
ffff800000105a66:	eb 59                	jmp    ffff800000105ac1 <mpconfig+0xdc>
  if(conf->version != 1 && conf->version != 4)
ffff800000105a68:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff800000105a6c:	0f b6 40 06          	movzbl 0x6(%rax),%eax
ffff800000105a70:	3c 01                	cmp    $0x1,%al
ffff800000105a72:	74 13                	je     ffff800000105a87 <mpconfig+0xa2>
ffff800000105a74:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff800000105a78:	0f b6 40 06          	movzbl 0x6(%rax),%eax
ffff800000105a7c:	3c 04                	cmp    $0x4,%al
ffff800000105a7e:	74 07                	je     ffff800000105a87 <mpconfig+0xa2>
    return 0;
ffff800000105a80:	b8 00 00 00 00       	mov    $0x0,%eax
ffff800000105a85:	eb 3a                	jmp    ffff800000105ac1 <mpconfig+0xdc>
  if(sum((uchar*)conf, conf->length) != 0)
ffff800000105a87:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff800000105a8b:	0f b7 40 04          	movzwl 0x4(%rax),%eax
ffff800000105a8f:	0f b7 d0             	movzwl %ax,%edx
ffff800000105a92:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff800000105a96:	89 d6                	mov    %edx,%esi
ffff800000105a98:	48 89 c7             	mov    %rax,%rdi
ffff800000105a9b:	48 b8 19 58 10 00 00 	movabs $0xffff800000105819,%rax
ffff800000105aa2:	80 ff ff 
ffff800000105aa5:	ff d0                	callq  *%rax
ffff800000105aa7:	84 c0                	test   %al,%al
ffff800000105aa9:	74 07                	je     ffff800000105ab2 <mpconfig+0xcd>
    return 0;
ffff800000105aab:	b8 00 00 00 00       	mov    $0x0,%eax
ffff800000105ab0:	eb 0f                	jmp    ffff800000105ac1 <mpconfig+0xdc>
  *pmp = mp;
ffff800000105ab2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000105ab6:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
ffff800000105aba:	48 89 10             	mov    %rdx,(%rax)
  return conf;
ffff800000105abd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
ffff800000105ac1:	c9                   	leaveq 
ffff800000105ac2:	c3                   	retq   

ffff800000105ac3 <mpinit>:

void
mpinit(void)
{
ffff800000105ac3:	f3 0f 1e fa          	endbr64 
ffff800000105ac7:	55                   	push   %rbp
ffff800000105ac8:	48 89 e5             	mov    %rsp,%rbp
ffff800000105acb:	48 83 ec 30          	sub    $0x30,%rsp
  struct mp *mp;
  struct mpconf *conf;
  struct mpproc *proc;
  struct mpioapic *ioapic;

  if((conf = mpconfig(&mp)) == 0) {
ffff800000105acf:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
ffff800000105ad3:	48 89 c7             	mov    %rax,%rdi
ffff800000105ad6:	48 b8 e5 59 10 00 00 	movabs $0xffff8000001059e5,%rax
ffff800000105add:	80 ff ff 
ffff800000105ae0:	ff d0                	callq  *%rax
ffff800000105ae2:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
ffff800000105ae6:	48 83 7d f0 00       	cmpq   $0x0,-0x10(%rbp)
ffff800000105aeb:	75 20                	jne    ffff800000105b0d <mpinit+0x4a>
    cprintf("No other CPUs found.\n");
ffff800000105aed:	48 bf 7a ca 10 00 00 	movabs $0xffff80000010ca7a,%rdi
ffff800000105af4:	80 ff ff 
ffff800000105af7:	b8 00 00 00 00       	mov    $0x0,%eax
ffff800000105afc:	48 ba 18 08 10 00 00 	movabs $0xffff800000100818,%rdx
ffff800000105b03:	80 ff ff 
ffff800000105b06:	ff d2                	callq  *%rdx
ffff800000105b08:	e9 c3 01 00 00       	jmpq   ffff800000105cd0 <mpinit+0x20d>
    return;
  }
  lapic = P2V((addr_t)conf->lapicaddr_p);
ffff800000105b0d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff800000105b11:	8b 40 24             	mov    0x24(%rax),%eax
ffff800000105b14:	89 c2                	mov    %eax,%edx
ffff800000105b16:	48 b8 00 00 00 00 00 	movabs $0xffff800000000000,%rax
ffff800000105b1d:	80 ff ff 
ffff800000105b20:	48 01 d0             	add    %rdx,%rax
ffff800000105b23:	48 89 c2             	mov    %rax,%rdx
ffff800000105b26:	48 b8 c0 71 11 00 00 	movabs $0xffff8000001171c0,%rax
ffff800000105b2d:	80 ff ff 
ffff800000105b30:	48 89 10             	mov    %rdx,(%rax)
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
ffff800000105b33:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff800000105b37:	48 83 c0 2c          	add    $0x2c,%rax
ffff800000105b3b:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
ffff800000105b3f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff800000105b43:	0f b7 40 04          	movzwl 0x4(%rax),%eax
ffff800000105b47:	0f b7 d0             	movzwl %ax,%edx
ffff800000105b4a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff800000105b4e:	48 01 d0             	add    %rdx,%rax
ffff800000105b51:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
ffff800000105b55:	e9 f3 00 00 00       	jmpq   ffff800000105c4d <mpinit+0x18a>
    switch(*p){
ffff800000105b5a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000105b5e:	0f b6 00             	movzbl (%rax),%eax
ffff800000105b61:	0f b6 c0             	movzbl %al,%eax
ffff800000105b64:	83 f8 04             	cmp    $0x4,%eax
ffff800000105b67:	0f 8f ca 00 00 00    	jg     ffff800000105c37 <mpinit+0x174>
ffff800000105b6d:	83 f8 03             	cmp    $0x3,%eax
ffff800000105b70:	0f 8d ba 00 00 00    	jge    ffff800000105c30 <mpinit+0x16d>
ffff800000105b76:	83 f8 02             	cmp    $0x2,%eax
ffff800000105b79:	0f 84 8e 00 00 00    	je     ffff800000105c0d <mpinit+0x14a>
ffff800000105b7f:	83 f8 02             	cmp    $0x2,%eax
ffff800000105b82:	0f 8f af 00 00 00    	jg     ffff800000105c37 <mpinit+0x174>
ffff800000105b88:	85 c0                	test   %eax,%eax
ffff800000105b8a:	74 0e                	je     ffff800000105b9a <mpinit+0xd7>
ffff800000105b8c:	83 f8 01             	cmp    $0x1,%eax
ffff800000105b8f:	0f 84 9b 00 00 00    	je     ffff800000105c30 <mpinit+0x16d>
ffff800000105b95:	e9 9d 00 00 00       	jmpq   ffff800000105c37 <mpinit+0x174>
    case MPPROC:
      proc = (struct mpproc*)p;
ffff800000105b9a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000105b9e:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
      if(ncpu < NCPU) {
ffff800000105ba2:	48 b8 20 74 11 00 00 	movabs $0xffff800000117420,%rax
ffff800000105ba9:	80 ff ff 
ffff800000105bac:	8b 00                	mov    (%rax),%eax
ffff800000105bae:	83 f8 07             	cmp    $0x7,%eax
ffff800000105bb1:	7f 53                	jg     ffff800000105c06 <mpinit+0x143>
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
ffff800000105bb3:	48 b8 20 74 11 00 00 	movabs $0xffff800000117420,%rax
ffff800000105bba:	80 ff ff 
ffff800000105bbd:	8b 10                	mov    (%rax),%edx
ffff800000105bbf:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
ffff800000105bc3:	0f b6 48 01          	movzbl 0x1(%rax),%ecx
ffff800000105bc7:	48 be e0 72 11 00 00 	movabs $0xffff8000001172e0,%rsi
ffff800000105bce:	80 ff ff 
ffff800000105bd1:	48 63 d2             	movslq %edx,%rdx
ffff800000105bd4:	48 89 d0             	mov    %rdx,%rax
ffff800000105bd7:	48 c1 e0 02          	shl    $0x2,%rax
ffff800000105bdb:	48 01 d0             	add    %rdx,%rax
ffff800000105bde:	48 c1 e0 03          	shl    $0x3,%rax
ffff800000105be2:	48 01 f0             	add    %rsi,%rax
ffff800000105be5:	48 83 c0 01          	add    $0x1,%rax
ffff800000105be9:	88 08                	mov    %cl,(%rax)
        ncpu++;
ffff800000105beb:	48 b8 20 74 11 00 00 	movabs $0xffff800000117420,%rax
ffff800000105bf2:	80 ff ff 
ffff800000105bf5:	8b 00                	mov    (%rax),%eax
ffff800000105bf7:	8d 50 01             	lea    0x1(%rax),%edx
ffff800000105bfa:	48 b8 20 74 11 00 00 	movabs $0xffff800000117420,%rax
ffff800000105c01:	80 ff ff 
ffff800000105c04:	89 10                	mov    %edx,(%rax)
      }
      p += sizeof(struct mpproc);
ffff800000105c06:	48 83 45 f8 14       	addq   $0x14,-0x8(%rbp)
      continue;
ffff800000105c0b:	eb 40                	jmp    ffff800000105c4d <mpinit+0x18a>
    case MPIOAPIC:
      ioapic = (struct mpioapic*)p;
ffff800000105c0d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000105c11:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
      ioapicid = ioapic->apicno;
ffff800000105c15:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
ffff800000105c19:	0f b6 40 01          	movzbl 0x1(%rax),%eax
ffff800000105c1d:	48 ba 24 74 11 00 00 	movabs $0xffff800000117424,%rdx
ffff800000105c24:	80 ff ff 
ffff800000105c27:	88 02                	mov    %al,(%rdx)
      p += sizeof(struct mpioapic);
ffff800000105c29:	48 83 45 f8 08       	addq   $0x8,-0x8(%rbp)
      continue;
ffff800000105c2e:	eb 1d                	jmp    ffff800000105c4d <mpinit+0x18a>
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
ffff800000105c30:	48 83 45 f8 08       	addq   $0x8,-0x8(%rbp)
      continue;
ffff800000105c35:	eb 16                	jmp    ffff800000105c4d <mpinit+0x18a>
    default:
      panic("Major problem parsing mp config.");
ffff800000105c37:	48 bf 90 ca 10 00 00 	movabs $0xffff80000010ca90,%rdi
ffff800000105c3e:	80 ff ff 
ffff800000105c41:	48 b8 f9 0b 10 00 00 	movabs $0xffff800000100bf9,%rax
ffff800000105c48:	80 ff ff 
ffff800000105c4b:	ff d0                	callq  *%rax
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
ffff800000105c4d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000105c51:	48 3b 45 e8          	cmp    -0x18(%rbp),%rax
ffff800000105c55:	0f 82 ff fe ff ff    	jb     ffff800000105b5a <mpinit+0x97>
      break;
    }
  }
  cprintf("Seems we are SMP, ncpu = %d\n",ncpu);
ffff800000105c5b:	48 b8 20 74 11 00 00 	movabs $0xffff800000117420,%rax
ffff800000105c62:	80 ff ff 
ffff800000105c65:	8b 00                	mov    (%rax),%eax
ffff800000105c67:	89 c6                	mov    %eax,%esi
ffff800000105c69:	48 bf b1 ca 10 00 00 	movabs $0xffff80000010cab1,%rdi
ffff800000105c70:	80 ff ff 
ffff800000105c73:	b8 00 00 00 00       	mov    $0x0,%eax
ffff800000105c78:	48 ba 18 08 10 00 00 	movabs $0xffff800000100818,%rdx
ffff800000105c7f:	80 ff ff 
ffff800000105c82:	ff d2                	callq  *%rdx
  if(mp->imcrp){
ffff800000105c84:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
ffff800000105c88:	0f b6 40 0c          	movzbl 0xc(%rax),%eax
ffff800000105c8c:	84 c0                	test   %al,%al
ffff800000105c8e:	74 40                	je     ffff800000105cd0 <mpinit+0x20d>
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
ffff800000105c90:	be 70 00 00 00       	mov    $0x70,%esi
ffff800000105c95:	bf 22 00 00 00       	mov    $0x22,%edi
ffff800000105c9a:	48 b8 f4 57 10 00 00 	movabs $0xffff8000001057f4,%rax
ffff800000105ca1:	80 ff ff 
ffff800000105ca4:	ff d0                	callq  *%rax
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
ffff800000105ca6:	bf 23 00 00 00       	mov    $0x23,%edi
ffff800000105cab:	48 b8 d2 57 10 00 00 	movabs $0xffff8000001057d2,%rax
ffff800000105cb2:	80 ff ff 
ffff800000105cb5:	ff d0                	callq  *%rax
ffff800000105cb7:	83 c8 01             	or     $0x1,%eax
ffff800000105cba:	0f b6 c0             	movzbl %al,%eax
ffff800000105cbd:	89 c6                	mov    %eax,%esi
ffff800000105cbf:	bf 23 00 00 00       	mov    $0x23,%edi
ffff800000105cc4:	48 b8 f4 57 10 00 00 	movabs $0xffff8000001057f4,%rax
ffff800000105ccb:	80 ff ff 
ffff800000105cce:	ff d0                	callq  *%rax
  }
}
ffff800000105cd0:	c9                   	leaveq 
ffff800000105cd1:	c3                   	retq   

ffff800000105cd2 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
ffff800000105cd2:	f3 0f 1e fa          	endbr64 
ffff800000105cd6:	55                   	push   %rbp
ffff800000105cd7:	48 89 e5             	mov    %rsp,%rbp
ffff800000105cda:	48 83 ec 20          	sub    $0x20,%rsp
ffff800000105cde:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
ffff800000105ce2:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  struct pipe *p;

  p = 0;
ffff800000105ce6:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
ffff800000105ced:	00 
  *f0 = *f1 = 0;
ffff800000105cee:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
ffff800000105cf2:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
ffff800000105cf9:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
ffff800000105cfd:	48 8b 10             	mov    (%rax),%rdx
ffff800000105d00:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000105d04:	48 89 10             	mov    %rdx,(%rax)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
ffff800000105d07:	48 b8 84 1b 10 00 00 	movabs $0xffff800000101b84,%rax
ffff800000105d0e:	80 ff ff 
ffff800000105d11:	ff d0                	callq  *%rax
ffff800000105d13:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
ffff800000105d17:	48 89 02             	mov    %rax,(%rdx)
ffff800000105d1a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000105d1e:	48 8b 00             	mov    (%rax),%rax
ffff800000105d21:	48 85 c0             	test   %rax,%rax
ffff800000105d24:	0f 84 fe 00 00 00    	je     ffff800000105e28 <pipealloc+0x156>
ffff800000105d2a:	48 b8 84 1b 10 00 00 	movabs $0xffff800000101b84,%rax
ffff800000105d31:	80 ff ff 
ffff800000105d34:	ff d0                	callq  *%rax
ffff800000105d36:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
ffff800000105d3a:	48 89 02             	mov    %rax,(%rdx)
ffff800000105d3d:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
ffff800000105d41:	48 8b 00             	mov    (%rax),%rax
ffff800000105d44:	48 85 c0             	test   %rax,%rax
ffff800000105d47:	0f 84 db 00 00 00    	je     ffff800000105e28 <pipealloc+0x156>
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
ffff800000105d4d:	48 b8 34 42 10 00 00 	movabs $0xffff800000104234,%rax
ffff800000105d54:	80 ff ff 
ffff800000105d57:	ff d0                	callq  *%rax
ffff800000105d59:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
ffff800000105d5d:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
ffff800000105d62:	0f 84 c3 00 00 00    	je     ffff800000105e2b <pipealloc+0x159>
    goto bad;
  p->readopen = 1;
ffff800000105d68:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000105d6c:	c7 80 70 02 00 00 01 	movl   $0x1,0x270(%rax)
ffff800000105d73:	00 00 00 
  p->writeopen = 1;
ffff800000105d76:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000105d7a:	c7 80 74 02 00 00 01 	movl   $0x1,0x274(%rax)
ffff800000105d81:	00 00 00 
  p->nwrite = 0;
ffff800000105d84:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000105d88:	c7 80 6c 02 00 00 00 	movl   $0x0,0x26c(%rax)
ffff800000105d8f:	00 00 00 
  p->nread = 0;
ffff800000105d92:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000105d96:	c7 80 68 02 00 00 00 	movl   $0x0,0x268(%rax)
ffff800000105d9d:	00 00 00 
  initlock(&p->lock, "pipe");
ffff800000105da0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000105da4:	48 be ce ca 10 00 00 	movabs $0xffff80000010cace,%rsi
ffff800000105dab:	80 ff ff 
ffff800000105dae:	48 89 c7             	mov    %rax,%rdi
ffff800000105db1:	48 b8 de 7e 10 00 00 	movabs $0xffff800000107ede,%rax
ffff800000105db8:	80 ff ff 
ffff800000105dbb:	ff d0                	callq  *%rax
  (*f0)->type = FD_PIPE;
ffff800000105dbd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000105dc1:	48 8b 00             	mov    (%rax),%rax
ffff800000105dc4:	c7 00 01 00 00 00    	movl   $0x1,(%rax)
  (*f0)->readable = 1;
ffff800000105dca:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000105dce:	48 8b 00             	mov    (%rax),%rax
ffff800000105dd1:	c6 40 08 01          	movb   $0x1,0x8(%rax)
  (*f0)->writable = 0;
ffff800000105dd5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000105dd9:	48 8b 00             	mov    (%rax),%rax
ffff800000105ddc:	c6 40 09 00          	movb   $0x0,0x9(%rax)
  (*f0)->pipe = p;
ffff800000105de0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000105de4:	48 8b 00             	mov    (%rax),%rax
ffff800000105de7:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
ffff800000105deb:	48 89 50 10          	mov    %rdx,0x10(%rax)
  (*f1)->type = FD_PIPE;
ffff800000105def:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
ffff800000105df3:	48 8b 00             	mov    (%rax),%rax
ffff800000105df6:	c7 00 01 00 00 00    	movl   $0x1,(%rax)
  (*f1)->readable = 0;
ffff800000105dfc:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
ffff800000105e00:	48 8b 00             	mov    (%rax),%rax
ffff800000105e03:	c6 40 08 00          	movb   $0x0,0x8(%rax)
  (*f1)->writable = 1;
ffff800000105e07:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
ffff800000105e0b:	48 8b 00             	mov    (%rax),%rax
ffff800000105e0e:	c6 40 09 01          	movb   $0x1,0x9(%rax)
  (*f1)->pipe = p;
ffff800000105e12:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
ffff800000105e16:	48 8b 00             	mov    (%rax),%rax
ffff800000105e19:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
ffff800000105e1d:	48 89 50 10          	mov    %rdx,0x10(%rax)
  return 0;
ffff800000105e21:	b8 00 00 00 00       	mov    $0x0,%eax
ffff800000105e26:	eb 67                	jmp    ffff800000105e8f <pipealloc+0x1bd>
    goto bad;
ffff800000105e28:	90                   	nop
ffff800000105e29:	eb 01                	jmp    ffff800000105e2c <pipealloc+0x15a>
    goto bad;
ffff800000105e2b:	90                   	nop

//PAGEBREAK: 20
 bad:
  if(p)
ffff800000105e2c:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
ffff800000105e31:	74 13                	je     ffff800000105e46 <pipealloc+0x174>
    kfree((char*)p);
ffff800000105e33:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000105e37:	48 89 c7             	mov    %rax,%rdi
ffff800000105e3a:	48 b8 3a 41 10 00 00 	movabs $0xffff80000010413a,%rax
ffff800000105e41:	80 ff ff 
ffff800000105e44:	ff d0                	callq  *%rax
  if(*f0)
ffff800000105e46:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000105e4a:	48 8b 00             	mov    (%rax),%rax
ffff800000105e4d:	48 85 c0             	test   %rax,%rax
ffff800000105e50:	74 16                	je     ffff800000105e68 <pipealloc+0x196>
    fileclose(*f0);
ffff800000105e52:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000105e56:	48 8b 00             	mov    (%rax),%rax
ffff800000105e59:	48 89 c7             	mov    %rax,%rdi
ffff800000105e5c:	48 b8 8e 1c 10 00 00 	movabs $0xffff800000101c8e,%rax
ffff800000105e63:	80 ff ff 
ffff800000105e66:	ff d0                	callq  *%rax
  if(*f1)
ffff800000105e68:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
ffff800000105e6c:	48 8b 00             	mov    (%rax),%rax
ffff800000105e6f:	48 85 c0             	test   %rax,%rax
ffff800000105e72:	74 16                	je     ffff800000105e8a <pipealloc+0x1b8>
    fileclose(*f1);
ffff800000105e74:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
ffff800000105e78:	48 8b 00             	mov    (%rax),%rax
ffff800000105e7b:	48 89 c7             	mov    %rax,%rdi
ffff800000105e7e:	48 b8 8e 1c 10 00 00 	movabs $0xffff800000101c8e,%rax
ffff800000105e85:	80 ff ff 
ffff800000105e88:	ff d0                	callq  *%rax
  return -1;
ffff800000105e8a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
ffff800000105e8f:	c9                   	leaveq 
ffff800000105e90:	c3                   	retq   

ffff800000105e91 <pipeclose>:

void
pipeclose(struct pipe *p, int writable)
{
ffff800000105e91:	f3 0f 1e fa          	endbr64 
ffff800000105e95:	55                   	push   %rbp
ffff800000105e96:	48 89 e5             	mov    %rsp,%rbp
ffff800000105e99:	48 83 ec 10          	sub    $0x10,%rsp
ffff800000105e9d:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
ffff800000105ea1:	89 75 f4             	mov    %esi,-0xc(%rbp)
  acquire(&p->lock);
ffff800000105ea4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000105ea8:	48 89 c7             	mov    %rax,%rdi
ffff800000105eab:	48 b8 17 7f 10 00 00 	movabs $0xffff800000107f17,%rax
ffff800000105eb2:	80 ff ff 
ffff800000105eb5:	ff d0                	callq  *%rax
  if(writable){
ffff800000105eb7:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
ffff800000105ebb:	74 29                	je     ffff800000105ee6 <pipeclose+0x55>
    p->writeopen = 0;
ffff800000105ebd:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000105ec1:	c7 80 74 02 00 00 00 	movl   $0x0,0x274(%rax)
ffff800000105ec8:	00 00 00 
    wakeup(&p->nread);
ffff800000105ecb:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000105ecf:	48 05 68 02 00 00    	add    $0x268,%rax
ffff800000105ed5:	48 89 c7             	mov    %rax,%rdi
ffff800000105ed8:	48 b8 2e 71 10 00 00 	movabs $0xffff80000010712e,%rax
ffff800000105edf:	80 ff ff 
ffff800000105ee2:	ff d0                	callq  *%rax
ffff800000105ee4:	eb 27                	jmp    ffff800000105f0d <pipeclose+0x7c>
  } else {
    p->readopen = 0;
ffff800000105ee6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000105eea:	c7 80 70 02 00 00 00 	movl   $0x0,0x270(%rax)
ffff800000105ef1:	00 00 00 
    wakeup(&p->nwrite);
ffff800000105ef4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000105ef8:	48 05 6c 02 00 00    	add    $0x26c,%rax
ffff800000105efe:	48 89 c7             	mov    %rax,%rdi
ffff800000105f01:	48 b8 2e 71 10 00 00 	movabs $0xffff80000010712e,%rax
ffff800000105f08:	80 ff ff 
ffff800000105f0b:	ff d0                	callq  *%rax
  }
  if(p->readopen == 0 && p->writeopen == 0){
ffff800000105f0d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000105f11:	8b 80 70 02 00 00    	mov    0x270(%rax),%eax
ffff800000105f17:	85 c0                	test   %eax,%eax
ffff800000105f19:	75 36                	jne    ffff800000105f51 <pipeclose+0xc0>
ffff800000105f1b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000105f1f:	8b 80 74 02 00 00    	mov    0x274(%rax),%eax
ffff800000105f25:	85 c0                	test   %eax,%eax
ffff800000105f27:	75 28                	jne    ffff800000105f51 <pipeclose+0xc0>
    release(&p->lock);
ffff800000105f29:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000105f2d:	48 89 c7             	mov    %rax,%rdi
ffff800000105f30:	48 b8 b4 7f 10 00 00 	movabs $0xffff800000107fb4,%rax
ffff800000105f37:	80 ff ff 
ffff800000105f3a:	ff d0                	callq  *%rax
    kfree((char*)p);
ffff800000105f3c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000105f40:	48 89 c7             	mov    %rax,%rdi
ffff800000105f43:	48 b8 3a 41 10 00 00 	movabs $0xffff80000010413a,%rax
ffff800000105f4a:	80 ff ff 
ffff800000105f4d:	ff d0                	callq  *%rax
ffff800000105f4f:	eb 14                	jmp    ffff800000105f65 <pipeclose+0xd4>
  } else
    release(&p->lock);
ffff800000105f51:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000105f55:	48 89 c7             	mov    %rax,%rdi
ffff800000105f58:	48 b8 b4 7f 10 00 00 	movabs $0xffff800000107fb4,%rax
ffff800000105f5f:	80 ff ff 
ffff800000105f62:	ff d0                	callq  *%rax
}
ffff800000105f64:	90                   	nop
ffff800000105f65:	90                   	nop
ffff800000105f66:	c9                   	leaveq 
ffff800000105f67:	c3                   	retq   

ffff800000105f68 <pipewrite>:

//PAGEBREAK: 40
int
pipewrite(struct pipe *p, char *addr, int n)
{
ffff800000105f68:	f3 0f 1e fa          	endbr64 
ffff800000105f6c:	55                   	push   %rbp
ffff800000105f6d:	48 89 e5             	mov    %rsp,%rbp
ffff800000105f70:	48 83 ec 30          	sub    $0x30,%rsp
ffff800000105f74:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
ffff800000105f78:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
ffff800000105f7c:	89 55 dc             	mov    %edx,-0x24(%rbp)
  int i;

  acquire(&p->lock);
ffff800000105f7f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000105f83:	48 89 c7             	mov    %rax,%rdi
ffff800000105f86:	48 b8 17 7f 10 00 00 	movabs $0xffff800000107f17,%rax
ffff800000105f8d:	80 ff ff 
ffff800000105f90:	ff d0                	callq  *%rax
  for(i = 0; i < n; i++){
ffff800000105f92:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
ffff800000105f99:	e9 d5 00 00 00       	jmpq   ffff800000106073 <pipewrite+0x10b>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
      if(p->readopen == 0 || proc->killed){
ffff800000105f9e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000105fa2:	8b 80 70 02 00 00    	mov    0x270(%rax),%eax
ffff800000105fa8:	85 c0                	test   %eax,%eax
ffff800000105faa:	74 12                	je     ffff800000105fbe <pipewrite+0x56>
ffff800000105fac:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffff800000105fb3:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffff800000105fb7:	8b 40 40             	mov    0x40(%rax),%eax
ffff800000105fba:	85 c0                	test   %eax,%eax
ffff800000105fbc:	74 1d                	je     ffff800000105fdb <pipewrite+0x73>
        release(&p->lock);
ffff800000105fbe:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000105fc2:	48 89 c7             	mov    %rax,%rdi
ffff800000105fc5:	48 b8 b4 7f 10 00 00 	movabs $0xffff800000107fb4,%rax
ffff800000105fcc:	80 ff ff 
ffff800000105fcf:	ff d0                	callq  *%rax
        return -1;
ffff800000105fd1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
ffff800000105fd6:	e9 cf 00 00 00       	jmpq   ffff8000001060aa <pipewrite+0x142>
      }
      wakeup(&p->nread);
ffff800000105fdb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000105fdf:	48 05 68 02 00 00    	add    $0x268,%rax
ffff800000105fe5:	48 89 c7             	mov    %rax,%rdi
ffff800000105fe8:	48 b8 2e 71 10 00 00 	movabs $0xffff80000010712e,%rax
ffff800000105fef:	80 ff ff 
ffff800000105ff2:	ff d0                	callq  *%rax
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
ffff800000105ff4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000105ff8:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
ffff800000105ffc:	48 81 c2 6c 02 00 00 	add    $0x26c,%rdx
ffff800000106003:	48 89 c6             	mov    %rax,%rsi
ffff800000106006:	48 89 d7             	mov    %rdx,%rdi
ffff800000106009:	48 b8 bd 6f 10 00 00 	movabs $0xffff800000106fbd,%rax
ffff800000106010:	80 ff ff 
ffff800000106013:	ff d0                	callq  *%rax
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
ffff800000106015:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000106019:	8b 90 6c 02 00 00    	mov    0x26c(%rax),%edx
ffff80000010601f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000106023:	8b 80 68 02 00 00    	mov    0x268(%rax),%eax
ffff800000106029:	05 00 02 00 00       	add    $0x200,%eax
ffff80000010602e:	39 c2                	cmp    %eax,%edx
ffff800000106030:	0f 84 68 ff ff ff    	je     ffff800000105f9e <pipewrite+0x36>
    }
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
ffff800000106036:	8b 45 fc             	mov    -0x4(%rbp),%eax
ffff800000106039:	48 63 d0             	movslq %eax,%rdx
ffff80000010603c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
ffff800000106040:	48 8d 34 02          	lea    (%rdx,%rax,1),%rsi
ffff800000106044:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000106048:	8b 80 6c 02 00 00    	mov    0x26c(%rax),%eax
ffff80000010604e:	8d 48 01             	lea    0x1(%rax),%ecx
ffff800000106051:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
ffff800000106055:	89 8a 6c 02 00 00    	mov    %ecx,0x26c(%rdx)
ffff80000010605b:	25 ff 01 00 00       	and    $0x1ff,%eax
ffff800000106060:	89 c1                	mov    %eax,%ecx
ffff800000106062:	0f b6 16             	movzbl (%rsi),%edx
ffff800000106065:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000106069:	89 c9                	mov    %ecx,%ecx
ffff80000010606b:	88 54 08 68          	mov    %dl,0x68(%rax,%rcx,1)
  for(i = 0; i < n; i++){
ffff80000010606f:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
ffff800000106073:	8b 45 fc             	mov    -0x4(%rbp),%eax
ffff800000106076:	3b 45 dc             	cmp    -0x24(%rbp),%eax
ffff800000106079:	7c 9a                	jl     ffff800000106015 <pipewrite+0xad>
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
ffff80000010607b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff80000010607f:	48 05 68 02 00 00    	add    $0x268,%rax
ffff800000106085:	48 89 c7             	mov    %rax,%rdi
ffff800000106088:	48 b8 2e 71 10 00 00 	movabs $0xffff80000010712e,%rax
ffff80000010608f:	80 ff ff 
ffff800000106092:	ff d0                	callq  *%rax
  release(&p->lock);
ffff800000106094:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000106098:	48 89 c7             	mov    %rax,%rdi
ffff80000010609b:	48 b8 b4 7f 10 00 00 	movabs $0xffff800000107fb4,%rax
ffff8000001060a2:	80 ff ff 
ffff8000001060a5:	ff d0                	callq  *%rax
  return n;
ffff8000001060a7:	8b 45 dc             	mov    -0x24(%rbp),%eax
}
ffff8000001060aa:	c9                   	leaveq 
ffff8000001060ab:	c3                   	retq   

ffff8000001060ac <piperead>:

int
piperead(struct pipe *p, char *addr, int n)
{
ffff8000001060ac:	f3 0f 1e fa          	endbr64 
ffff8000001060b0:	55                   	push   %rbp
ffff8000001060b1:	48 89 e5             	mov    %rsp,%rbp
ffff8000001060b4:	48 83 ec 30          	sub    $0x30,%rsp
ffff8000001060b8:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
ffff8000001060bc:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
ffff8000001060c0:	89 55 dc             	mov    %edx,-0x24(%rbp)
  int i;

  acquire(&p->lock);
ffff8000001060c3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff8000001060c7:	48 89 c7             	mov    %rax,%rdi
ffff8000001060ca:	48 b8 17 7f 10 00 00 	movabs $0xffff800000107f17,%rax
ffff8000001060d1:	80 ff ff 
ffff8000001060d4:	ff d0                	callq  *%rax
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
ffff8000001060d6:	eb 50                	jmp    ffff800000106128 <piperead+0x7c>
    if(proc->killed){
ffff8000001060d8:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffff8000001060df:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffff8000001060e3:	8b 40 40             	mov    0x40(%rax),%eax
ffff8000001060e6:	85 c0                	test   %eax,%eax
ffff8000001060e8:	74 1d                	je     ffff800000106107 <piperead+0x5b>
      release(&p->lock);
ffff8000001060ea:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff8000001060ee:	48 89 c7             	mov    %rax,%rdi
ffff8000001060f1:	48 b8 b4 7f 10 00 00 	movabs $0xffff800000107fb4,%rax
ffff8000001060f8:	80 ff ff 
ffff8000001060fb:	ff d0                	callq  *%rax
      return -1;
ffff8000001060fd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
ffff800000106102:	e9 de 00 00 00       	jmpq   ffff8000001061e5 <piperead+0x139>
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
ffff800000106107:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff80000010610b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
ffff80000010610f:	48 81 c2 68 02 00 00 	add    $0x268,%rdx
ffff800000106116:	48 89 c6             	mov    %rax,%rsi
ffff800000106119:	48 89 d7             	mov    %rdx,%rdi
ffff80000010611c:	48 b8 bd 6f 10 00 00 	movabs $0xffff800000106fbd,%rax
ffff800000106123:	80 ff ff 
ffff800000106126:	ff d0                	callq  *%rax
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
ffff800000106128:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff80000010612c:	8b 90 68 02 00 00    	mov    0x268(%rax),%edx
ffff800000106132:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000106136:	8b 80 6c 02 00 00    	mov    0x26c(%rax),%eax
ffff80000010613c:	39 c2                	cmp    %eax,%edx
ffff80000010613e:	75 0e                	jne    ffff80000010614e <piperead+0xa2>
ffff800000106140:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000106144:	8b 80 74 02 00 00    	mov    0x274(%rax),%eax
ffff80000010614a:	85 c0                	test   %eax,%eax
ffff80000010614c:	75 8a                	jne    ffff8000001060d8 <piperead+0x2c>
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
ffff80000010614e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
ffff800000106155:	eb 54                	jmp    ffff8000001061ab <piperead+0xff>
    if(p->nread == p->nwrite)
ffff800000106157:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff80000010615b:	8b 90 68 02 00 00    	mov    0x268(%rax),%edx
ffff800000106161:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000106165:	8b 80 6c 02 00 00    	mov    0x26c(%rax),%eax
ffff80000010616b:	39 c2                	cmp    %eax,%edx
ffff80000010616d:	74 46                	je     ffff8000001061b5 <piperead+0x109>
      break;
    addr[i] = p->data[p->nread++ % PIPESIZE];
ffff80000010616f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000106173:	8b 80 68 02 00 00    	mov    0x268(%rax),%eax
ffff800000106179:	8d 48 01             	lea    0x1(%rax),%ecx
ffff80000010617c:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
ffff800000106180:	89 8a 68 02 00 00    	mov    %ecx,0x268(%rdx)
ffff800000106186:	25 ff 01 00 00       	and    $0x1ff,%eax
ffff80000010618b:	89 c1                	mov    %eax,%ecx
ffff80000010618d:	8b 45 fc             	mov    -0x4(%rbp),%eax
ffff800000106190:	48 63 d0             	movslq %eax,%rdx
ffff800000106193:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
ffff800000106197:	48 01 c2             	add    %rax,%rdx
ffff80000010619a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff80000010619e:	89 c9                	mov    %ecx,%ecx
ffff8000001061a0:	0f b6 44 08 68       	movzbl 0x68(%rax,%rcx,1),%eax
ffff8000001061a5:	88 02                	mov    %al,(%rdx)
  for(i = 0; i < n; i++){  //DOC: piperead-copy
ffff8000001061a7:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
ffff8000001061ab:	8b 45 fc             	mov    -0x4(%rbp),%eax
ffff8000001061ae:	3b 45 dc             	cmp    -0x24(%rbp),%eax
ffff8000001061b1:	7c a4                	jl     ffff800000106157 <piperead+0xab>
ffff8000001061b3:	eb 01                	jmp    ffff8000001061b6 <piperead+0x10a>
      break;
ffff8000001061b5:	90                   	nop
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
ffff8000001061b6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff8000001061ba:	48 05 6c 02 00 00    	add    $0x26c,%rax
ffff8000001061c0:	48 89 c7             	mov    %rax,%rdi
ffff8000001061c3:	48 b8 2e 71 10 00 00 	movabs $0xffff80000010712e,%rax
ffff8000001061ca:	80 ff ff 
ffff8000001061cd:	ff d0                	callq  *%rax
  release(&p->lock);
ffff8000001061cf:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff8000001061d3:	48 89 c7             	mov    %rax,%rdi
ffff8000001061d6:	48 b8 b4 7f 10 00 00 	movabs $0xffff800000107fb4,%rax
ffff8000001061dd:	80 ff ff 
ffff8000001061e0:	ff d0                	callq  *%rax
  return i;
ffff8000001061e2:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
ffff8000001061e5:	c9                   	leaveq 
ffff8000001061e6:	c3                   	retq   

ffff8000001061e7 <readeflags>:
{
ffff8000001061e7:	f3 0f 1e fa          	endbr64 
ffff8000001061eb:	55                   	push   %rbp
ffff8000001061ec:	48 89 e5             	mov    %rsp,%rbp
ffff8000001061ef:	48 83 ec 10          	sub    $0x10,%rsp
  asm volatile("pushf; pop %0" : "=r" (eflags));
ffff8000001061f3:	9c                   	pushfq 
ffff8000001061f4:	58                   	pop    %rax
ffff8000001061f5:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  return eflags;
ffff8000001061f9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
ffff8000001061fd:	c9                   	leaveq 
ffff8000001061fe:	c3                   	retq   

ffff8000001061ff <sti>:
{
ffff8000001061ff:	f3 0f 1e fa          	endbr64 
ffff800000106203:	55                   	push   %rbp
ffff800000106204:	48 89 e5             	mov    %rsp,%rbp
  asm volatile("sti");
ffff800000106207:	fb                   	sti    
}
ffff800000106208:	90                   	nop
ffff800000106209:	5d                   	pop    %rbp
ffff80000010620a:	c3                   	retq   

ffff80000010620b <hlt>:
{
ffff80000010620b:	f3 0f 1e fa          	endbr64 
ffff80000010620f:	55                   	push   %rbp
ffff800000106210:	48 89 e5             	mov    %rsp,%rbp
  asm volatile("hlt");
ffff800000106213:	f4                   	hlt    
}
ffff800000106214:	90                   	nop
ffff800000106215:	5d                   	pop    %rbp
ffff800000106216:	c3                   	retq   

ffff800000106217 <pinit>:

static void wakeup1(void *chan);

void
pinit(void)
{
ffff800000106217:	f3 0f 1e fa          	endbr64 
ffff80000010621b:	55                   	push   %rbp
ffff80000010621c:	48 89 e5             	mov    %rsp,%rbp
  initlock(&ptable.lock, "ptable");
ffff80000010621f:	48 be d8 ca 10 00 00 	movabs $0xffff80000010cad8,%rsi
ffff800000106226:	80 ff ff 
ffff800000106229:	48 bf 40 74 11 00 00 	movabs $0xffff800000117440,%rdi
ffff800000106230:	80 ff ff 
ffff800000106233:	48 b8 de 7e 10 00 00 	movabs $0xffff800000107ede,%rax
ffff80000010623a:	80 ff ff 
ffff80000010623d:	ff d0                	callq  *%rax
}
ffff80000010623f:	90                   	nop
ffff800000106240:	5d                   	pop    %rbp
ffff800000106241:	c3                   	retq   

ffff800000106242 <allocproc>:
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
ffff800000106242:	f3 0f 1e fa          	endbr64 
ffff800000106246:	55                   	push   %rbp
ffff800000106247:	48 89 e5             	mov    %rsp,%rbp
ffff80000010624a:	48 83 ec 10          	sub    $0x10,%rsp
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);
ffff80000010624e:	48 bf 40 74 11 00 00 	movabs $0xffff800000117440,%rdi
ffff800000106255:	80 ff ff 
ffff800000106258:	48 b8 17 7f 10 00 00 	movabs $0xffff800000107f17,%rax
ffff80000010625f:	80 ff ff 
ffff800000106262:	ff d0                	callq  *%rax

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
ffff800000106264:	48 b8 a8 74 11 00 00 	movabs $0xffff8000001174a8,%rax
ffff80000010626b:	80 ff ff 
ffff80000010626e:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
ffff800000106272:	eb 13                	jmp    ffff800000106287 <allocproc+0x45>
    if(p->state == UNUSED)
ffff800000106274:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000106278:	8b 40 18             	mov    0x18(%rax),%eax
ffff80000010627b:	85 c0                	test   %eax,%eax
ffff80000010627d:	74 38                	je     ffff8000001062b7 <allocproc+0x75>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
ffff80000010627f:	48 81 45 f8 e8 00 00 	addq   $0xe8,-0x8(%rbp)
ffff800000106286:	00 
ffff800000106287:	48 b8 a8 ae 11 00 00 	movabs $0xffff80000011aea8,%rax
ffff80000010628e:	80 ff ff 
ffff800000106291:	48 39 45 f8          	cmp    %rax,-0x8(%rbp)
ffff800000106295:	72 dd                	jb     ffff800000106274 <allocproc+0x32>
      goto found;

  release(&ptable.lock);
ffff800000106297:	48 bf 40 74 11 00 00 	movabs $0xffff800000117440,%rdi
ffff80000010629e:	80 ff ff 
ffff8000001062a1:	48 b8 b4 7f 10 00 00 	movabs $0xffff800000107fb4,%rax
ffff8000001062a8:	80 ff ff 
ffff8000001062ab:	ff d0                	callq  *%rax
  return 0;
ffff8000001062ad:	b8 00 00 00 00       	mov    $0x0,%eax
ffff8000001062b2:	e9 14 01 00 00       	jmpq   ffff8000001063cb <allocproc+0x189>
      goto found;
ffff8000001062b7:	90                   	nop
ffff8000001062b8:	f3 0f 1e fa          	endbr64 

found:
  p->state = EMBRYO;
ffff8000001062bc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff8000001062c0:	c7 40 18 01 00 00 00 	movl   $0x1,0x18(%rax)
  p->pid = nextpid++;
ffff8000001062c7:	48 b8 40 d5 10 00 00 	movabs $0xffff80000010d540,%rax
ffff8000001062ce:	80 ff ff 
ffff8000001062d1:	8b 00                	mov    (%rax),%eax
ffff8000001062d3:	8d 50 01             	lea    0x1(%rax),%edx
ffff8000001062d6:	48 b9 40 d5 10 00 00 	movabs $0xffff80000010d540,%rcx
ffff8000001062dd:	80 ff ff 
ffff8000001062e0:	89 11                	mov    %edx,(%rcx)
ffff8000001062e2:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
ffff8000001062e6:	89 42 1c             	mov    %eax,0x1c(%rdx)

  release(&ptable.lock);
ffff8000001062e9:	48 bf 40 74 11 00 00 	movabs $0xffff800000117440,%rdi
ffff8000001062f0:	80 ff ff 
ffff8000001062f3:	48 b8 b4 7f 10 00 00 	movabs $0xffff800000107fb4,%rax
ffff8000001062fa:	80 ff ff 
ffff8000001062fd:	ff d0                	callq  *%rax

  p->is_process = 1; // regular process
ffff8000001062ff:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000106303:	c7 80 d0 00 00 00 01 	movl   $0x1,0xd0(%rax)
ffff80000010630a:	00 00 00 
  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
ffff80000010630d:	48 b8 34 42 10 00 00 	movabs $0xffff800000104234,%rax
ffff800000106314:	80 ff ff 
ffff800000106317:	ff d0                	callq  *%rax
ffff800000106319:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
ffff80000010631d:	48 89 42 10          	mov    %rax,0x10(%rdx)
ffff800000106321:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000106325:	48 8b 40 10          	mov    0x10(%rax),%rax
ffff800000106329:	48 85 c0             	test   %rax,%rax
ffff80000010632c:	75 15                	jne    ffff800000106343 <allocproc+0x101>
    p->state = UNUSED;
ffff80000010632e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000106332:	c7 40 18 00 00 00 00 	movl   $0x0,0x18(%rax)
    return 0;
ffff800000106339:	b8 00 00 00 00       	mov    $0x0,%eax
ffff80000010633e:	e9 88 00 00 00       	jmpq   ffff8000001063cb <allocproc+0x189>
  }
  sp = p->kstack + KSTACKSIZE;
ffff800000106343:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000106347:	48 8b 40 10          	mov    0x10(%rax),%rax
ffff80000010634b:	48 05 00 10 00 00    	add    $0x1000,%rax
ffff800000106351:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

  // Leave room for trap frame.
  sp -= sizeof *p->tf;
ffff800000106355:	48 81 6d f0 b0 00 00 	subq   $0xb0,-0x10(%rbp)
ffff80000010635c:	00 
  p->tf = (struct trapframe*)sp;
ffff80000010635d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000106361:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
ffff800000106365:	48 89 50 28          	mov    %rdx,0x28(%rax)

  // Set up new context to start executing at forkret,
  // which returns to trapret.
  sp -= sizeof(addr_t);
ffff800000106369:	48 83 6d f0 08       	subq   $0x8,-0x10(%rbp)
  *(addr_t*)sp = (addr_t)syscall_trapret;
ffff80000010636e:	48 ba 2a a0 10 00 00 	movabs $0xffff80000010a02a,%rdx
ffff800000106375:	80 ff ff 
ffff800000106378:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff80000010637c:	48 89 10             	mov    %rdx,(%rax)

  sp -= sizeof *p->context;
ffff80000010637f:	48 83 6d f0 38       	subq   $0x38,-0x10(%rbp)
  p->context = (struct context*)sp;
ffff800000106384:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000106388:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
ffff80000010638c:	48 89 50 30          	mov    %rdx,0x30(%rax)
  memset(p->context, 0, sizeof *p->context);
ffff800000106390:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000106394:	48 8b 40 30          	mov    0x30(%rax),%rax
ffff800000106398:	ba 38 00 00 00       	mov    $0x38,%edx
ffff80000010639d:	be 00 00 00 00       	mov    $0x0,%esi
ffff8000001063a2:	48 89 c7             	mov    %rax,%rdi
ffff8000001063a5:	48 b8 bd 82 10 00 00 	movabs $0xffff8000001082bd,%rax
ffff8000001063ac:	80 ff ff 
ffff8000001063af:	ff d0                	callq  *%rax
  p->context->rip = (addr_t)forkret;
ffff8000001063b1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff8000001063b5:	48 8b 40 30          	mov    0x30(%rax),%rax
ffff8000001063b9:	48 ba 45 6f 10 00 00 	movabs $0xffff800000106f45,%rdx
ffff8000001063c0:	80 ff ff 
ffff8000001063c3:	48 89 50 30          	mov    %rdx,0x30(%rax)

  return p;
ffff8000001063c7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
ffff8000001063cb:	c9                   	leaveq 
ffff8000001063cc:	c3                   	retq   

ffff8000001063cd <userinit>:

//PAGEBREAK: 32
// Set up first user process.
void
userinit(void)
{
ffff8000001063cd:	f3 0f 1e fa          	endbr64 
ffff8000001063d1:	55                   	push   %rbp
ffff8000001063d2:	48 89 e5             	mov    %rsp,%rbp
ffff8000001063d5:	48 83 ec 10          	sub    $0x10,%rsp
  struct proc *p;
  extern char _binary_initcode_start[], _binary_initcode_size[];
  p = allocproc();
ffff8000001063d9:	48 b8 42 62 10 00 00 	movabs $0xffff800000106242,%rax
ffff8000001063e0:	80 ff ff 
ffff8000001063e3:	ff d0                	callq  *%rax
ffff8000001063e5:	48 89 45 f8          	mov    %rax,-0x8(%rbp)

  initproc = p;
ffff8000001063e9:	48 ba a8 ae 11 00 00 	movabs $0xffff80000011aea8,%rdx
ffff8000001063f0:	80 ff ff 
ffff8000001063f3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff8000001063f7:	48 89 02             	mov    %rax,(%rdx)
  if((p->pgdir = setupkvm()) == 0)
ffff8000001063fa:	48 b8 7c b8 10 00 00 	movabs $0xffff80000010b87c,%rax
ffff800000106401:	80 ff ff 
ffff800000106404:	ff d0                	callq  *%rax
ffff800000106406:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
ffff80000010640a:	48 89 42 08          	mov    %rax,0x8(%rdx)
ffff80000010640e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000106412:	48 8b 40 08          	mov    0x8(%rax),%rax
ffff800000106416:	48 85 c0             	test   %rax,%rax
ffff800000106419:	75 16                	jne    ffff800000106431 <userinit+0x64>
    panic("userinit: out of memory?");
ffff80000010641b:	48 bf df ca 10 00 00 	movabs $0xffff80000010cadf,%rdi
ffff800000106422:	80 ff ff 
ffff800000106425:	48 b8 f9 0b 10 00 00 	movabs $0xffff800000100bf9,%rax
ffff80000010642c:	80 ff ff 
ffff80000010642f:	ff d0                	callq  *%rax

  inituvm(p->pgdir, _binary_initcode_start,
ffff800000106431:	48 b8 3c 00 00 00 00 	movabs $0x3c,%rax
ffff800000106438:	00 00 00 
ffff80000010643b:	89 c2                	mov    %eax,%edx
ffff80000010643d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000106441:	48 8b 40 08          	mov    0x8(%rax),%rax
ffff800000106445:	48 be 58 de 10 00 00 	movabs $0xffff80000010de58,%rsi
ffff80000010644c:	80 ff ff 
ffff80000010644f:	48 89 c7             	mov    %rax,%rdi
ffff800000106452:	48 b8 04 be 10 00 00 	movabs $0xffff80000010be04,%rax
ffff800000106459:	80 ff ff 
ffff80000010645c:	ff d0                	callq  *%rax
          (addr_t)_binary_initcode_size);
  p->sz = PGSIZE * 2;
ffff80000010645e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000106462:	48 c7 00 00 20 00 00 	movq   $0x2000,(%rax)
  memset(p->tf, 0, sizeof(*p->tf));
ffff800000106469:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff80000010646d:	48 8b 40 28          	mov    0x28(%rax),%rax
ffff800000106471:	ba b0 00 00 00       	mov    $0xb0,%edx
ffff800000106476:	be 00 00 00 00       	mov    $0x0,%esi
ffff80000010647b:	48 89 c7             	mov    %rax,%rdi
ffff80000010647e:	48 b8 bd 82 10 00 00 	movabs $0xffff8000001082bd,%rax
ffff800000106485:	80 ff ff 
ffff800000106488:	ff d0                	callq  *%rax

  p->tf->r11 = FL_IF;  // with SYSRET, EFLAGS is in R11
ffff80000010648a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff80000010648e:	48 8b 40 28          	mov    0x28(%rax),%rax
ffff800000106492:	48 c7 40 50 00 02 00 	movq   $0x200,0x50(%rax)
ffff800000106499:	00 
  p->tf->rsp = p->sz;
ffff80000010649a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff80000010649e:	48 8b 40 28          	mov    0x28(%rax),%rax
ffff8000001064a2:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
ffff8000001064a6:	48 8b 12             	mov    (%rdx),%rdx
ffff8000001064a9:	48 89 90 a0 00 00 00 	mov    %rdx,0xa0(%rax)
  p->tf->rcx = PGSIZE;  // with SYSRET, RIP is in RCX
ffff8000001064b0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff8000001064b4:	48 8b 40 28          	mov    0x28(%rax),%rax
ffff8000001064b8:	48 c7 40 10 00 10 00 	movq   $0x1000,0x10(%rax)
ffff8000001064bf:	00 

  safestrcpy(p->name, "initcode", sizeof(p->name));
ffff8000001064c0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff8000001064c4:	48 05 d4 00 00 00    	add    $0xd4,%rax
ffff8000001064ca:	ba 10 00 00 00       	mov    $0x10,%edx
ffff8000001064cf:	48 be f8 ca 10 00 00 	movabs $0xffff80000010caf8,%rsi
ffff8000001064d6:	80 ff ff 
ffff8000001064d9:	48 89 c7             	mov    %rax,%rdi
ffff8000001064dc:	48 b8 8d 85 10 00 00 	movabs $0xffff80000010858d,%rax
ffff8000001064e3:	80 ff ff 
ffff8000001064e6:	ff d0                	callq  *%rax
  p->cwd = namei("/");
ffff8000001064e8:	48 bf 01 cb 10 00 00 	movabs $0xffff80000010cb01,%rdi
ffff8000001064ef:	80 ff ff 
ffff8000001064f2:	48 b8 ff 37 10 00 00 	movabs $0xffff8000001037ff,%rax
ffff8000001064f9:	80 ff ff 
ffff8000001064fc:	ff d0                	callq  *%rax
ffff8000001064fe:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
ffff800000106502:	48 89 82 c8 00 00 00 	mov    %rax,0xc8(%rdx)

  __sync_synchronize();
ffff800000106509:	0f ae f0             	mfence 
  p->state = RUNNABLE;
ffff80000010650c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000106510:	c7 40 18 03 00 00 00 	movl   $0x3,0x18(%rax)
}
ffff800000106517:	90                   	nop
ffff800000106518:	c9                   	leaveq 
ffff800000106519:	c3                   	retq   

ffff80000010651a <growproc>:

// Grow current process's memory by n bytes.
// Return 0 on success, -1 on failure.
int
growproc(int64 n)
{
ffff80000010651a:	f3 0f 1e fa          	endbr64 
ffff80000010651e:	55                   	push   %rbp
ffff80000010651f:	48 89 e5             	mov    %rsp,%rbp
ffff800000106522:	48 83 ec 20          	sub    $0x20,%rsp
ffff800000106526:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  addr_t sz;

  sz = proc->sz;
ffff80000010652a:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffff800000106531:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffff800000106535:	48 8b 00             	mov    (%rax),%rax
ffff800000106538:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  if(n > 0){
ffff80000010653c:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
ffff800000106541:	7e 42                	jle    ffff800000106585 <growproc+0x6b>
    if((sz = allocuvm(proc->pgdir, sz, sz + n)) == 0)
ffff800000106543:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
ffff800000106547:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff80000010654b:	48 01 c2             	add    %rax,%rdx
ffff80000010654e:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffff800000106555:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffff800000106559:	48 8b 40 08          	mov    0x8(%rax),%rax
ffff80000010655d:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
ffff800000106561:	48 89 ce             	mov    %rcx,%rsi
ffff800000106564:	48 89 c7             	mov    %rax,%rdi
ffff800000106567:	48 b8 e4 bf 10 00 00 	movabs $0xffff80000010bfe4,%rax
ffff80000010656e:	80 ff ff 
ffff800000106571:	ff d0                	callq  *%rax
ffff800000106573:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
ffff800000106577:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
ffff80000010657c:	75 50                	jne    ffff8000001065ce <growproc+0xb4>
      return -1;
ffff80000010657e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
ffff800000106583:	eb 7a                	jmp    ffff8000001065ff <growproc+0xe5>
  } else if(n < 0){
ffff800000106585:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
ffff80000010658a:	79 42                	jns    ffff8000001065ce <growproc+0xb4>
    if((sz = deallocuvm(proc->pgdir, sz, sz + n)) == 0)
ffff80000010658c:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
ffff800000106590:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000106594:	48 01 c2             	add    %rax,%rdx
ffff800000106597:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffff80000010659e:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffff8000001065a2:	48 8b 40 08          	mov    0x8(%rax),%rax
ffff8000001065a6:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
ffff8000001065aa:	48 89 ce             	mov    %rcx,%rsi
ffff8000001065ad:	48 89 c7             	mov    %rax,%rdi
ffff8000001065b0:	48 b8 2c c1 10 00 00 	movabs $0xffff80000010c12c,%rax
ffff8000001065b7:	80 ff ff 
ffff8000001065ba:	ff d0                	callq  *%rax
ffff8000001065bc:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
ffff8000001065c0:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
ffff8000001065c5:	75 07                	jne    ffff8000001065ce <growproc+0xb4>
      return -1;
ffff8000001065c7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
ffff8000001065cc:	eb 31                	jmp    ffff8000001065ff <growproc+0xe5>
  }
  proc->sz = sz;
ffff8000001065ce:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffff8000001065d5:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffff8000001065d9:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
ffff8000001065dd:	48 89 10             	mov    %rdx,(%rax)
  switchuvm(proc);
ffff8000001065e0:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffff8000001065e7:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffff8000001065eb:	48 89 c7             	mov    %rax,%rdi
ffff8000001065ee:	48 b8 e2 b9 10 00 00 	movabs $0xffff80000010b9e2,%rax
ffff8000001065f5:	80 ff ff 
ffff8000001065f8:	ff d0                	callq  *%rax
  return 0;
ffff8000001065fa:	b8 00 00 00 00       	mov    $0x0,%eax
}
ffff8000001065ff:	c9                   	leaveq 
ffff800000106600:	c3                   	retq   

ffff800000106601 <fork>:
// Create a new process copying p as the parent.
// Sets up stack to return as if from system call.
// Caller must set state of returned proc to RUNNABLE.
int
fork(void)
{
ffff800000106601:	f3 0f 1e fa          	endbr64 
ffff800000106605:	55                   	push   %rbp
ffff800000106606:	48 89 e5             	mov    %rsp,%rbp
ffff800000106609:	53                   	push   %rbx
ffff80000010660a:	48 83 ec 28          	sub    $0x28,%rsp
  int i, pid;
  struct proc *np;

  // Allocate process.
  if((np = allocproc()) == 0)
ffff80000010660e:	48 b8 42 62 10 00 00 	movabs $0xffff800000106242,%rax
ffff800000106615:	80 ff ff 
ffff800000106618:	ff d0                	callq  *%rax
ffff80000010661a:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
ffff80000010661e:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
ffff800000106623:	75 0a                	jne    ffff80000010662f <fork+0x2e>
    return -1;
ffff800000106625:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
ffff80000010662a:	e9 85 02 00 00       	jmpq   ffff8000001068b4 <fork+0x2b3>

  // Copy process state from p.
  if((np->pgdir = copyuvm(proc->pgdir, proc->sz)) == 0){
ffff80000010662f:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffff800000106636:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffff80000010663a:	48 8b 00             	mov    (%rax),%rax
ffff80000010663d:	89 c2                	mov    %eax,%edx
ffff80000010663f:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffff800000106646:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffff80000010664a:	48 8b 40 08          	mov    0x8(%rax),%rax
ffff80000010664e:	89 d6                	mov    %edx,%esi
ffff800000106650:	48 89 c7             	mov    %rax,%rdi
ffff800000106653:	48 b8 ca c4 10 00 00 	movabs $0xffff80000010c4ca,%rax
ffff80000010665a:	80 ff ff 
ffff80000010665d:	ff d0                	callq  *%rax
ffff80000010665f:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
ffff800000106663:	48 89 42 08          	mov    %rax,0x8(%rdx)
ffff800000106667:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
ffff80000010666b:	48 8b 40 08          	mov    0x8(%rax),%rax
ffff80000010666f:	48 85 c0             	test   %rax,%rax
ffff800000106672:	75 38                	jne    ffff8000001066ac <fork+0xab>
    kfree(np->kstack);
ffff800000106674:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
ffff800000106678:	48 8b 40 10          	mov    0x10(%rax),%rax
ffff80000010667c:	48 89 c7             	mov    %rax,%rdi
ffff80000010667f:	48 b8 3a 41 10 00 00 	movabs $0xffff80000010413a,%rax
ffff800000106686:	80 ff ff 
ffff800000106689:	ff d0                	callq  *%rax
    np->kstack = 0;
ffff80000010668b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
ffff80000010668f:	48 c7 40 10 00 00 00 	movq   $0x0,0x10(%rax)
ffff800000106696:	00 
    np->state = UNUSED;
ffff800000106697:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
ffff80000010669b:	c7 40 18 00 00 00 00 	movl   $0x0,0x18(%rax)
    return -1;
ffff8000001066a2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
ffff8000001066a7:	e9 08 02 00 00       	jmpq   ffff8000001068b4 <fork+0x2b3>
  }
  np->sz = proc->sz;
ffff8000001066ac:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffff8000001066b3:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffff8000001066b7:	48 8b 10             	mov    (%rax),%rdx
ffff8000001066ba:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
ffff8000001066be:	48 89 10             	mov    %rdx,(%rax)
  np->parent = proc;
ffff8000001066c1:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffff8000001066c8:	64 48 8b 10          	mov    %fs:(%rax),%rdx
ffff8000001066cc:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
ffff8000001066d0:	48 89 50 20          	mov    %rdx,0x20(%rax)
  *np->tf = *proc->tf;
ffff8000001066d4:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffff8000001066db:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffff8000001066df:	48 8b 50 28          	mov    0x28(%rax),%rdx
ffff8000001066e3:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
ffff8000001066e7:	48 8b 40 28          	mov    0x28(%rax),%rax
ffff8000001066eb:	48 8b 0a             	mov    (%rdx),%rcx
ffff8000001066ee:	48 8b 5a 08          	mov    0x8(%rdx),%rbx
ffff8000001066f2:	48 89 08             	mov    %rcx,(%rax)
ffff8000001066f5:	48 89 58 08          	mov    %rbx,0x8(%rax)
ffff8000001066f9:	48 8b 4a 10          	mov    0x10(%rdx),%rcx
ffff8000001066fd:	48 8b 5a 18          	mov    0x18(%rdx),%rbx
ffff800000106701:	48 89 48 10          	mov    %rcx,0x10(%rax)
ffff800000106705:	48 89 58 18          	mov    %rbx,0x18(%rax)
ffff800000106709:	48 8b 4a 20          	mov    0x20(%rdx),%rcx
ffff80000010670d:	48 8b 5a 28          	mov    0x28(%rdx),%rbx
ffff800000106711:	48 89 48 20          	mov    %rcx,0x20(%rax)
ffff800000106715:	48 89 58 28          	mov    %rbx,0x28(%rax)
ffff800000106719:	48 8b 4a 30          	mov    0x30(%rdx),%rcx
ffff80000010671d:	48 8b 5a 38          	mov    0x38(%rdx),%rbx
ffff800000106721:	48 89 48 30          	mov    %rcx,0x30(%rax)
ffff800000106725:	48 89 58 38          	mov    %rbx,0x38(%rax)
ffff800000106729:	48 8b 4a 40          	mov    0x40(%rdx),%rcx
ffff80000010672d:	48 8b 5a 48          	mov    0x48(%rdx),%rbx
ffff800000106731:	48 89 48 40          	mov    %rcx,0x40(%rax)
ffff800000106735:	48 89 58 48          	mov    %rbx,0x48(%rax)
ffff800000106739:	48 8b 4a 50          	mov    0x50(%rdx),%rcx
ffff80000010673d:	48 8b 5a 58          	mov    0x58(%rdx),%rbx
ffff800000106741:	48 89 48 50          	mov    %rcx,0x50(%rax)
ffff800000106745:	48 89 58 58          	mov    %rbx,0x58(%rax)
ffff800000106749:	48 8b 4a 60          	mov    0x60(%rdx),%rcx
ffff80000010674d:	48 8b 5a 68          	mov    0x68(%rdx),%rbx
ffff800000106751:	48 89 48 60          	mov    %rcx,0x60(%rax)
ffff800000106755:	48 89 58 68          	mov    %rbx,0x68(%rax)
ffff800000106759:	48 8b 4a 70          	mov    0x70(%rdx),%rcx
ffff80000010675d:	48 8b 5a 78          	mov    0x78(%rdx),%rbx
ffff800000106761:	48 89 48 70          	mov    %rcx,0x70(%rax)
ffff800000106765:	48 89 58 78          	mov    %rbx,0x78(%rax)
ffff800000106769:	48 8b 8a 80 00 00 00 	mov    0x80(%rdx),%rcx
ffff800000106770:	48 8b 9a 88 00 00 00 	mov    0x88(%rdx),%rbx
ffff800000106777:	48 89 88 80 00 00 00 	mov    %rcx,0x80(%rax)
ffff80000010677e:	48 89 98 88 00 00 00 	mov    %rbx,0x88(%rax)
ffff800000106785:	48 8b 8a 90 00 00 00 	mov    0x90(%rdx),%rcx
ffff80000010678c:	48 8b 9a 98 00 00 00 	mov    0x98(%rdx),%rbx
ffff800000106793:	48 89 88 90 00 00 00 	mov    %rcx,0x90(%rax)
ffff80000010679a:	48 89 98 98 00 00 00 	mov    %rbx,0x98(%rax)
ffff8000001067a1:	48 8b 8a a0 00 00 00 	mov    0xa0(%rdx),%rcx
ffff8000001067a8:	48 8b 9a a8 00 00 00 	mov    0xa8(%rdx),%rbx
ffff8000001067af:	48 89 88 a0 00 00 00 	mov    %rcx,0xa0(%rax)
ffff8000001067b6:	48 89 98 a8 00 00 00 	mov    %rbx,0xa8(%rax)

  // Clear %rax so that fork returns 0 in the child.
  np->tf->rax = 0;
ffff8000001067bd:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
ffff8000001067c1:	48 8b 40 28          	mov    0x28(%rax),%rax
ffff8000001067c5:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)

  for(i = 0; i < NOFILE; i++)
ffff8000001067cc:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%rbp)
ffff8000001067d3:	eb 5f                	jmp    ffff800000106834 <fork+0x233>
    if(proc->ofile[i])
ffff8000001067d5:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffff8000001067dc:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffff8000001067e0:	8b 55 ec             	mov    -0x14(%rbp),%edx
ffff8000001067e3:	48 63 d2             	movslq %edx,%rdx
ffff8000001067e6:	48 83 c2 08          	add    $0x8,%rdx
ffff8000001067ea:	48 8b 44 d0 08       	mov    0x8(%rax,%rdx,8),%rax
ffff8000001067ef:	48 85 c0             	test   %rax,%rax
ffff8000001067f2:	74 3c                	je     ffff800000106830 <fork+0x22f>
      np->ofile[i] = filedup(proc->ofile[i]);
ffff8000001067f4:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffff8000001067fb:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffff8000001067ff:	8b 55 ec             	mov    -0x14(%rbp),%edx
ffff800000106802:	48 63 d2             	movslq %edx,%rdx
ffff800000106805:	48 83 c2 08          	add    $0x8,%rdx
ffff800000106809:	48 8b 44 d0 08       	mov    0x8(%rax,%rdx,8),%rax
ffff80000010680e:	48 89 c7             	mov    %rax,%rdi
ffff800000106811:	48 b8 1a 1c 10 00 00 	movabs $0xffff800000101c1a,%rax
ffff800000106818:	80 ff ff 
ffff80000010681b:	ff d0                	callq  *%rax
ffff80000010681d:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
ffff800000106821:	8b 4d ec             	mov    -0x14(%rbp),%ecx
ffff800000106824:	48 63 c9             	movslq %ecx,%rcx
ffff800000106827:	48 83 c1 08          	add    $0x8,%rcx
ffff80000010682b:	48 89 44 ca 08       	mov    %rax,0x8(%rdx,%rcx,8)
  for(i = 0; i < NOFILE; i++)
ffff800000106830:	83 45 ec 01          	addl   $0x1,-0x14(%rbp)
ffff800000106834:	83 7d ec 0f          	cmpl   $0xf,-0x14(%rbp)
ffff800000106838:	7e 9b                	jle    ffff8000001067d5 <fork+0x1d4>
  np->cwd = idup(proc->cwd);
ffff80000010683a:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffff800000106841:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffff800000106845:	48 8b 80 c8 00 00 00 	mov    0xc8(%rax),%rax
ffff80000010684c:	48 89 c7             	mov    %rax,%rdi
ffff80000010684f:	48 b8 95 28 10 00 00 	movabs $0xffff800000102895,%rax
ffff800000106856:	80 ff ff 
ffff800000106859:	ff d0                	callq  *%rax
ffff80000010685b:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
ffff80000010685f:	48 89 82 c8 00 00 00 	mov    %rax,0xc8(%rdx)

  safestrcpy(np->name, proc->name, sizeof(proc->name));
ffff800000106866:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffff80000010686d:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffff800000106871:	48 8d 88 d4 00 00 00 	lea    0xd4(%rax),%rcx
ffff800000106878:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
ffff80000010687c:	48 05 d4 00 00 00    	add    $0xd4,%rax
ffff800000106882:	ba 10 00 00 00       	mov    $0x10,%edx
ffff800000106887:	48 89 ce             	mov    %rcx,%rsi
ffff80000010688a:	48 89 c7             	mov    %rax,%rdi
ffff80000010688d:	48 b8 8d 85 10 00 00 	movabs $0xffff80000010858d,%rax
ffff800000106894:	80 ff ff 
ffff800000106897:	ff d0                	callq  *%rax

  pid = np->pid;
ffff800000106899:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
ffff80000010689d:	8b 40 1c             	mov    0x1c(%rax),%eax
ffff8000001068a0:	89 45 dc             	mov    %eax,-0x24(%rbp)

  __sync_synchronize();
ffff8000001068a3:	0f ae f0             	mfence 
  np->state = RUNNABLE;
ffff8000001068a6:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
ffff8000001068aa:	c7 40 18 03 00 00 00 	movl   $0x3,0x18(%rax)

  return pid;
ffff8000001068b1:	8b 45 dc             	mov    -0x24(%rbp),%eax
}
ffff8000001068b4:	48 83 c4 28          	add    $0x28,%rsp
ffff8000001068b8:	5b                   	pop    %rbx
ffff8000001068b9:	5d                   	pop    %rbp
ffff8000001068ba:	c3                   	retq   

ffff8000001068bb <exit>:
// Exit the current process.  Does not return.
// An exited process remains in the zombie state
// until its parent calls wait() to find out it exited.
void
exit(void)
{
ffff8000001068bb:	f3 0f 1e fa          	endbr64 
ffff8000001068bf:	55                   	push   %rbp
ffff8000001068c0:	48 89 e5             	mov    %rsp,%rbp
ffff8000001068c3:	48 83 ec 10          	sub    $0x10,%rsp
  struct proc *p;
  int fd;

  if(proc == initproc)
ffff8000001068c7:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffff8000001068ce:	64 48 8b 10          	mov    %fs:(%rax),%rdx
ffff8000001068d2:	48 b8 a8 ae 11 00 00 	movabs $0xffff80000011aea8,%rax
ffff8000001068d9:	80 ff ff 
ffff8000001068dc:	48 8b 00             	mov    (%rax),%rax
ffff8000001068df:	48 39 c2             	cmp    %rax,%rdx
ffff8000001068e2:	75 16                	jne    ffff8000001068fa <exit+0x3f>
    panic("init exiting");
ffff8000001068e4:	48 bf 03 cb 10 00 00 	movabs $0xffff80000010cb03,%rdi
ffff8000001068eb:	80 ff ff 
ffff8000001068ee:	48 b8 f9 0b 10 00 00 	movabs $0xffff800000100bf9,%rax
ffff8000001068f5:	80 ff ff 
ffff8000001068f8:	ff d0                	callq  *%rax

  // Close all open files.
  for(fd = 0; fd < NOFILE; fd++){
ffff8000001068fa:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%rbp)
ffff800000106901:	eb 6a                	jmp    ffff80000010696d <exit+0xb2>
    if(proc->ofile[fd]){
ffff800000106903:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffff80000010690a:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffff80000010690e:	8b 55 f4             	mov    -0xc(%rbp),%edx
ffff800000106911:	48 63 d2             	movslq %edx,%rdx
ffff800000106914:	48 83 c2 08          	add    $0x8,%rdx
ffff800000106918:	48 8b 44 d0 08       	mov    0x8(%rax,%rdx,8),%rax
ffff80000010691d:	48 85 c0             	test   %rax,%rax
ffff800000106920:	74 47                	je     ffff800000106969 <exit+0xae>
      fileclose(proc->ofile[fd]);
ffff800000106922:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffff800000106929:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffff80000010692d:	8b 55 f4             	mov    -0xc(%rbp),%edx
ffff800000106930:	48 63 d2             	movslq %edx,%rdx
ffff800000106933:	48 83 c2 08          	add    $0x8,%rdx
ffff800000106937:	48 8b 44 d0 08       	mov    0x8(%rax,%rdx,8),%rax
ffff80000010693c:	48 89 c7             	mov    %rax,%rdi
ffff80000010693f:	48 b8 8e 1c 10 00 00 	movabs $0xffff800000101c8e,%rax
ffff800000106946:	80 ff ff 
ffff800000106949:	ff d0                	callq  *%rax
      proc->ofile[fd] = 0;
ffff80000010694b:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffff800000106952:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffff800000106956:	8b 55 f4             	mov    -0xc(%rbp),%edx
ffff800000106959:	48 63 d2             	movslq %edx,%rdx
ffff80000010695c:	48 83 c2 08          	add    $0x8,%rdx
ffff800000106960:	48 c7 44 d0 08 00 00 	movq   $0x0,0x8(%rax,%rdx,8)
ffff800000106967:	00 00 
  for(fd = 0; fd < NOFILE; fd++){
ffff800000106969:	83 45 f4 01          	addl   $0x1,-0xc(%rbp)
ffff80000010696d:	83 7d f4 0f          	cmpl   $0xf,-0xc(%rbp)
ffff800000106971:	7e 90                	jle    ffff800000106903 <exit+0x48>
    }
  }

  begin_op();
ffff800000106973:	b8 00 00 00 00       	mov    $0x0,%eax
ffff800000106978:	48 ba 79 4f 10 00 00 	movabs $0xffff800000104f79,%rdx
ffff80000010697f:	80 ff ff 
ffff800000106982:	ff d2                	callq  *%rdx
  iput(proc->cwd);
ffff800000106984:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffff80000010698b:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffff80000010698f:	48 8b 80 c8 00 00 00 	mov    0xc8(%rax),%rax
ffff800000106996:	48 89 c7             	mov    %rax,%rdi
ffff800000106999:	48 b8 ea 2a 10 00 00 	movabs $0xffff800000102aea,%rax
ffff8000001069a0:	80 ff ff 
ffff8000001069a3:	ff d0                	callq  *%rax
  end_op();
ffff8000001069a5:	b8 00 00 00 00       	mov    $0x0,%eax
ffff8000001069aa:	48 ba 53 50 10 00 00 	movabs $0xffff800000105053,%rdx
ffff8000001069b1:	80 ff ff 
ffff8000001069b4:	ff d2                	callq  *%rdx
  proc->cwd = 0;
ffff8000001069b6:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffff8000001069bd:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffff8000001069c1:	48 c7 80 c8 00 00 00 	movq   $0x0,0xc8(%rax)
ffff8000001069c8:	00 00 00 00 

  acquire(&ptable.lock);
ffff8000001069cc:	48 bf 40 74 11 00 00 	movabs $0xffff800000117440,%rdi
ffff8000001069d3:	80 ff ff 
ffff8000001069d6:	48 b8 17 7f 10 00 00 	movabs $0xffff800000107f17,%rax
ffff8000001069dd:	80 ff ff 
ffff8000001069e0:	ff d0                	callq  *%rax

  // Parent might be sleeping in wait().
  wakeup1(proc->parent);
ffff8000001069e2:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffff8000001069e9:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffff8000001069ed:	48 8b 40 20          	mov    0x20(%rax),%rax
ffff8000001069f1:	48 89 c7             	mov    %rax,%rdi
ffff8000001069f4:	48 b8 cd 70 10 00 00 	movabs $0xffff8000001070cd,%rax
ffff8000001069fb:	80 ff ff 
ffff8000001069fe:	ff d0                	callq  *%rax

  // Pass abandoned children to init.
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
ffff800000106a00:	48 b8 a8 74 11 00 00 	movabs $0xffff8000001174a8,%rax
ffff800000106a07:	80 ff ff 
ffff800000106a0a:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
ffff800000106a0e:	eb 5d                	jmp    ffff800000106a6d <exit+0x1b2>
    if(p->parent == proc){
ffff800000106a10:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000106a14:	48 8b 50 20          	mov    0x20(%rax),%rdx
ffff800000106a18:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffff800000106a1f:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffff800000106a23:	48 39 c2             	cmp    %rax,%rdx
ffff800000106a26:	75 3d                	jne    ffff800000106a65 <exit+0x1aa>
      p->parent = initproc;
ffff800000106a28:	48 b8 a8 ae 11 00 00 	movabs $0xffff80000011aea8,%rax
ffff800000106a2f:	80 ff ff 
ffff800000106a32:	48 8b 10             	mov    (%rax),%rdx
ffff800000106a35:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000106a39:	48 89 50 20          	mov    %rdx,0x20(%rax)
      if(p->state == ZOMBIE)
ffff800000106a3d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000106a41:	8b 40 18             	mov    0x18(%rax),%eax
ffff800000106a44:	83 f8 05             	cmp    $0x5,%eax
ffff800000106a47:	75 1c                	jne    ffff800000106a65 <exit+0x1aa>
        wakeup1(initproc);
ffff800000106a49:	48 b8 a8 ae 11 00 00 	movabs $0xffff80000011aea8,%rax
ffff800000106a50:	80 ff ff 
ffff800000106a53:	48 8b 00             	mov    (%rax),%rax
ffff800000106a56:	48 89 c7             	mov    %rax,%rdi
ffff800000106a59:	48 b8 cd 70 10 00 00 	movabs $0xffff8000001070cd,%rax
ffff800000106a60:	80 ff ff 
ffff800000106a63:	ff d0                	callq  *%rax
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
ffff800000106a65:	48 81 45 f8 e8 00 00 	addq   $0xe8,-0x8(%rbp)
ffff800000106a6c:	00 
ffff800000106a6d:	48 b8 a8 ae 11 00 00 	movabs $0xffff80000011aea8,%rax
ffff800000106a74:	80 ff ff 
ffff800000106a77:	48 39 45 f8          	cmp    %rax,-0x8(%rbp)
ffff800000106a7b:	72 93                	jb     ffff800000106a10 <exit+0x155>
    }
  }

  // Jump into the scheduler, never to return.
  proc->state = ZOMBIE;
ffff800000106a7d:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffff800000106a84:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffff800000106a88:	c7 40 18 05 00 00 00 	movl   $0x5,0x18(%rax)
  sched();
ffff800000106a8f:	48 b8 e1 6d 10 00 00 	movabs $0xffff800000106de1,%rax
ffff800000106a96:	80 ff ff 
ffff800000106a99:	ff d0                	callq  *%rax
  panic("zombie exit");
ffff800000106a9b:	48 bf 10 cb 10 00 00 	movabs $0xffff80000010cb10,%rdi
ffff800000106aa2:	80 ff ff 
ffff800000106aa5:	48 b8 f9 0b 10 00 00 	movabs $0xffff800000100bf9,%rax
ffff800000106aac:	80 ff ff 
ffff800000106aaf:	ff d0                	callq  *%rax

ffff800000106ab1 <wait>:
//PAGEBREAK!
// Wait for a child process to exit and return its pid.
// Return -1 if this process has no children.
int
wait(void)
{
ffff800000106ab1:	f3 0f 1e fa          	endbr64 
ffff800000106ab5:	55                   	push   %rbp
ffff800000106ab6:	48 89 e5             	mov    %rsp,%rbp
ffff800000106ab9:	48 83 ec 10          	sub    $0x10,%rsp
  struct proc *p;
  int havekids, pid;

  acquire(&ptable.lock);
ffff800000106abd:	48 bf 40 74 11 00 00 	movabs $0xffff800000117440,%rdi
ffff800000106ac4:	80 ff ff 
ffff800000106ac7:	48 b8 17 7f 10 00 00 	movabs $0xffff800000107f17,%rax
ffff800000106ace:	80 ff ff 
ffff800000106ad1:	ff d0                	callq  *%rax
  for(;;){
    // Scan through table looking for exited children.
    havekids = 0;
ffff800000106ad3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%rbp)
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
ffff800000106ada:	48 b8 a8 74 11 00 00 	movabs $0xffff8000001174a8,%rax
ffff800000106ae1:	80 ff ff 
ffff800000106ae4:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
ffff800000106ae8:	e9 d3 00 00 00       	jmpq   ffff800000106bc0 <wait+0x10f>
      if(p->parent != proc)
ffff800000106aed:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000106af1:	48 8b 50 20          	mov    0x20(%rax),%rdx
ffff800000106af5:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffff800000106afc:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffff800000106b00:	48 39 c2             	cmp    %rax,%rdx
ffff800000106b03:	0f 85 ae 00 00 00    	jne    ffff800000106bb7 <wait+0x106>
        continue;
      havekids = 1;
ffff800000106b09:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%rbp)
      if(p->state == ZOMBIE){
ffff800000106b10:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000106b14:	8b 40 18             	mov    0x18(%rax),%eax
ffff800000106b17:	83 f8 05             	cmp    $0x5,%eax
ffff800000106b1a:	0f 85 98 00 00 00    	jne    ffff800000106bb8 <wait+0x107>
        // Found one.
        pid = p->pid;
ffff800000106b20:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000106b24:	8b 40 1c             	mov    0x1c(%rax),%eax
ffff800000106b27:	89 45 f0             	mov    %eax,-0x10(%rbp)
        kfree(p->kstack);
ffff800000106b2a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000106b2e:	48 8b 40 10          	mov    0x10(%rax),%rax
ffff800000106b32:	48 89 c7             	mov    %rax,%rdi
ffff800000106b35:	48 b8 3a 41 10 00 00 	movabs $0xffff80000010413a,%rax
ffff800000106b3c:	80 ff ff 
ffff800000106b3f:	ff d0                	callq  *%rax
        p->kstack = 0;
ffff800000106b41:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000106b45:	48 c7 40 10 00 00 00 	movq   $0x0,0x10(%rax)
ffff800000106b4c:	00 
        freevm(p->pgdir);
ffff800000106b4d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000106b51:	48 8b 40 08          	mov    0x8(%rax),%rax
ffff800000106b55:	48 89 c7             	mov    %rax,%rdi
ffff800000106b58:	48 b8 26 c2 10 00 00 	movabs $0xffff80000010c226,%rax
ffff800000106b5f:	80 ff ff 
ffff800000106b62:	ff d0                	callq  *%rax
        p->pid = 0;
ffff800000106b64:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000106b68:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%rax)
        p->parent = 0;
ffff800000106b6f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000106b73:	48 c7 40 20 00 00 00 	movq   $0x0,0x20(%rax)
ffff800000106b7a:	00 
        p->name[0] = 0;
ffff800000106b7b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000106b7f:	c6 80 d4 00 00 00 00 	movb   $0x0,0xd4(%rax)
        p->killed = 0;
ffff800000106b86:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000106b8a:	c7 40 40 00 00 00 00 	movl   $0x0,0x40(%rax)
        p->state = UNUSED;
ffff800000106b91:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000106b95:	c7 40 18 00 00 00 00 	movl   $0x0,0x18(%rax)
        release(&ptable.lock);
ffff800000106b9c:	48 bf 40 74 11 00 00 	movabs $0xffff800000117440,%rdi
ffff800000106ba3:	80 ff ff 
ffff800000106ba6:	48 b8 b4 7f 10 00 00 	movabs $0xffff800000107fb4,%rax
ffff800000106bad:	80 ff ff 
ffff800000106bb0:	ff d0                	callq  *%rax
        return pid;
ffff800000106bb2:	8b 45 f0             	mov    -0x10(%rbp),%eax
ffff800000106bb5:	eb 7b                	jmp    ffff800000106c32 <wait+0x181>
        continue;
ffff800000106bb7:	90                   	nop
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
ffff800000106bb8:	48 81 45 f8 e8 00 00 	addq   $0xe8,-0x8(%rbp)
ffff800000106bbf:	00 
ffff800000106bc0:	48 b8 a8 ae 11 00 00 	movabs $0xffff80000011aea8,%rax
ffff800000106bc7:	80 ff ff 
ffff800000106bca:	48 39 45 f8          	cmp    %rax,-0x8(%rbp)
ffff800000106bce:	0f 82 19 ff ff ff    	jb     ffff800000106aed <wait+0x3c>
      }
    }

    // No point waiting if we don't have any children.
    if(!havekids || proc->killed){
ffff800000106bd4:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
ffff800000106bd8:	74 12                	je     ffff800000106bec <wait+0x13b>
ffff800000106bda:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffff800000106be1:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffff800000106be5:	8b 40 40             	mov    0x40(%rax),%eax
ffff800000106be8:	85 c0                	test   %eax,%eax
ffff800000106bea:	74 1d                	je     ffff800000106c09 <wait+0x158>
      release(&ptable.lock);
ffff800000106bec:	48 bf 40 74 11 00 00 	movabs $0xffff800000117440,%rdi
ffff800000106bf3:	80 ff ff 
ffff800000106bf6:	48 b8 b4 7f 10 00 00 	movabs $0xffff800000107fb4,%rax
ffff800000106bfd:	80 ff ff 
ffff800000106c00:	ff d0                	callq  *%rax
      return -1;
ffff800000106c02:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
ffff800000106c07:	eb 29                	jmp    ffff800000106c32 <wait+0x181>
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(proc, &ptable.lock);  //DOC: wait-sleep
ffff800000106c09:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffff800000106c10:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffff800000106c14:	48 be 40 74 11 00 00 	movabs $0xffff800000117440,%rsi
ffff800000106c1b:	80 ff ff 
ffff800000106c1e:	48 89 c7             	mov    %rax,%rdi
ffff800000106c21:	48 b8 bd 6f 10 00 00 	movabs $0xffff800000106fbd,%rax
ffff800000106c28:	80 ff ff 
ffff800000106c2b:	ff d0                	callq  *%rax
    havekids = 0;
ffff800000106c2d:	e9 a1 fe ff ff       	jmpq   ffff800000106ad3 <wait+0x22>
  }
}
ffff800000106c32:	c9                   	leaveq 
ffff800000106c33:	c3                   	retq   

ffff800000106c34 <scheduler>:
//  - swtch to start running that process
//  - eventually that process transfers control
//      via swtch back to the scheduler.
void
scheduler(void)
{
ffff800000106c34:	f3 0f 1e fa          	endbr64 
ffff800000106c38:	55                   	push   %rbp
ffff800000106c39:	48 89 e5             	mov    %rsp,%rbp
ffff800000106c3c:	48 83 ec 20          	sub    $0x20,%rsp
  int i = 0;
ffff800000106c40:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  struct proc *p;
  int skipped = 0;
ffff800000106c47:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%rbp)
  for(;;){
    ++i;
ffff800000106c4e:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
    // Enable interrupts on this processor.
    sti();
ffff800000106c52:	48 b8 ff 61 10 00 00 	movabs $0xffff8000001061ff,%rax
ffff800000106c59:	80 ff ff 
ffff800000106c5c:	ff d0                	callq  *%rax
    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
ffff800000106c5e:	48 bf 40 74 11 00 00 	movabs $0xffff800000117440,%rdi
ffff800000106c65:	80 ff ff 
ffff800000106c68:	48 b8 17 7f 10 00 00 	movabs $0xffff800000107f17,%rax
ffff800000106c6f:	80 ff ff 
ffff800000106c72:	ff d0                	callq  *%rax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
ffff800000106c74:	48 b8 a8 74 11 00 00 	movabs $0xffff8000001174a8,%rax
ffff800000106c7b:	80 ff ff 
ffff800000106c7e:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
ffff800000106c82:	e9 0b 01 00 00       	jmpq   ffff800000106d92 <scheduler+0x15e>
      if(p->state != RUNNABLE) {
ffff800000106c87:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff800000106c8b:	8b 40 18             	mov    0x18(%rax),%eax
ffff800000106c8e:	83 f8 03             	cmp    $0x3,%eax
ffff800000106c91:	74 09                	je     ffff800000106c9c <scheduler+0x68>
        skipped++;
ffff800000106c93:	83 45 ec 01          	addl   $0x1,-0x14(%rbp)
        continue;
ffff800000106c97:	e9 ee 00 00 00       	jmpq   ffff800000106d8a <scheduler+0x156>
      }
      skipped = 0;
ffff800000106c9c:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%rbp)

      // Switch to chosen process.  It is the process's job
      // to release ptable.lock and then reacquire it
      // before jumping back to us.
      proc = p;
ffff800000106ca3:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffff800000106caa:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
ffff800000106cae:	64 48 89 10          	mov    %rdx,%fs:(%rax)
      if (p->is_process) {
ffff800000106cb2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff800000106cb6:	8b 80 d0 00 00 00    	mov    0xd0(%rax),%eax
ffff800000106cbc:	85 c0                	test   %eax,%eax
ffff800000106cbe:	74 13                	je     ffff800000106cd3 <scheduler+0x9f>
        switchuvm(p);
ffff800000106cc0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff800000106cc4:	48 89 c7             	mov    %rax,%rdi
ffff800000106cc7:	48 b8 e2 b9 10 00 00 	movabs $0xffff80000010b9e2,%rax
ffff800000106cce:	80 ff ff 
ffff800000106cd1:	ff d0                	callq  *%rax
      }
      p->state = RUNNING;
ffff800000106cd3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff800000106cd7:	c7 40 18 04 00 00 00 	movl   $0x4,0x18(%rax)
      swtch(&cpu->scheduler, p->context);
ffff800000106cde:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff800000106ce2:	48 8b 40 30          	mov    0x30(%rax),%rax
ffff800000106ce6:	48 c7 c2 f0 ff ff ff 	mov    $0xfffffffffffffff0,%rdx
ffff800000106ced:	64 48 8b 12          	mov    %fs:(%rdx),%rdx
ffff800000106cf1:	48 83 c2 08          	add    $0x8,%rdx
ffff800000106cf5:	48 89 c6             	mov    %rax,%rsi
ffff800000106cf8:	48 89 d7             	mov    %rdx,%rdi
ffff800000106cfb:	48 b8 29 86 10 00 00 	movabs $0xffff800000108629,%rax
ffff800000106d02:	80 ff ff 
ffff800000106d05:	ff d0                	callq  *%rax
      switchkvm();
ffff800000106d07:	48 b8 f3 bc 10 00 00 	movabs $0xffff80000010bcf3,%rax
ffff800000106d0e:	80 ff ff 
ffff800000106d11:	ff d0                	callq  *%rax

      // clean-up kthread
      if (proc->state == KZOMBIE) {
ffff800000106d13:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffff800000106d1a:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffff800000106d1e:	8b 40 18             	mov    0x18(%rax),%eax
ffff800000106d21:	83 f8 06             	cmp    $0x6,%eax
ffff800000106d24:	75 55                	jne    ffff800000106d7b <scheduler+0x147>
        kfree(proc->kstack);
ffff800000106d26:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffff800000106d2d:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffff800000106d31:	48 8b 40 10          	mov    0x10(%rax),%rax
ffff800000106d35:	48 89 c7             	mov    %rax,%rdi
ffff800000106d38:	48 b8 3a 41 10 00 00 	movabs $0xffff80000010413a,%rax
ffff800000106d3f:	80 ff ff 
ffff800000106d42:	ff d0                	callq  *%rax
        proc->kstack = 0;
ffff800000106d44:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffff800000106d4b:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffff800000106d4f:	48 c7 40 10 00 00 00 	movq   $0x0,0x10(%rax)
ffff800000106d56:	00 
        proc->pid = 0;
ffff800000106d57:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffff800000106d5e:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffff800000106d62:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%rax)
        proc->state = UNUSED;
ffff800000106d69:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffff800000106d70:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffff800000106d74:	c7 40 18 00 00 00 00 	movl   $0x0,0x18(%rax)
      }

      // Process is done running for now.
      // It should have changed its p->state before coming back.
      proc = 0;
ffff800000106d7b:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffff800000106d82:	64 48 c7 00 00 00 00 	movq   $0x0,%fs:(%rax)
ffff800000106d89:	00 
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
ffff800000106d8a:	48 81 45 f0 e8 00 00 	addq   $0xe8,-0x10(%rbp)
ffff800000106d91:	00 
ffff800000106d92:	48 b8 a8 ae 11 00 00 	movabs $0xffff80000011aea8,%rax
ffff800000106d99:	80 ff ff 
ffff800000106d9c:	48 39 45 f0          	cmp    %rax,-0x10(%rbp)
ffff800000106da0:	0f 82 e1 fe ff ff    	jb     ffff800000106c87 <scheduler+0x53>
    }
    release(&ptable.lock);
ffff800000106da6:	48 bf 40 74 11 00 00 	movabs $0xffff800000117440,%rdi
ffff800000106dad:	80 ff ff 
ffff800000106db0:	48 b8 b4 7f 10 00 00 	movabs $0xffff800000107fb4,%rax
ffff800000106db7:	80 ff ff 
ffff800000106dba:	ff d0                	callq  *%rax
    if (skipped > (2*NPROC)) {
ffff800000106dbc:	81 7d ec 80 00 00 00 	cmpl   $0x80,-0x14(%rbp)
ffff800000106dc3:	0f 8e 85 fe ff ff    	jle    ffff800000106c4e <scheduler+0x1a>
      hlt();
ffff800000106dc9:	48 b8 0b 62 10 00 00 	movabs $0xffff80000010620b,%rax
ffff800000106dd0:	80 ff ff 
ffff800000106dd3:	ff d0                	callq  *%rax
      skipped = 0;
ffff800000106dd5:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%rbp)
    ++i;
ffff800000106ddc:	e9 6d fe ff ff       	jmpq   ffff800000106c4e <scheduler+0x1a>

ffff800000106de1 <sched>:
// be proc->intena and proc->ncli, but that would
// break in the few places where a lock is held but
// there's no process.
void
sched(void)
{
ffff800000106de1:	f3 0f 1e fa          	endbr64 
ffff800000106de5:	55                   	push   %rbp
ffff800000106de6:	48 89 e5             	mov    %rsp,%rbp
ffff800000106de9:	48 83 ec 10          	sub    $0x10,%rsp
  int intena;


  if(!holding(&ptable.lock))
ffff800000106ded:	48 bf 40 74 11 00 00 	movabs $0xffff800000117440,%rdi
ffff800000106df4:	80 ff ff 
ffff800000106df7:	48 b8 ff 80 10 00 00 	movabs $0xffff8000001080ff,%rax
ffff800000106dfe:	80 ff ff 
ffff800000106e01:	ff d0                	callq  *%rax
ffff800000106e03:	85 c0                	test   %eax,%eax
ffff800000106e05:	75 16                	jne    ffff800000106e1d <sched+0x3c>
    panic("sched ptable.lock");
ffff800000106e07:	48 bf 1c cb 10 00 00 	movabs $0xffff80000010cb1c,%rdi
ffff800000106e0e:	80 ff ff 
ffff800000106e11:	48 b8 f9 0b 10 00 00 	movabs $0xffff800000100bf9,%rax
ffff800000106e18:	80 ff ff 
ffff800000106e1b:	ff d0                	callq  *%rax
  if(cpu->ncli != 1)
ffff800000106e1d:	48 c7 c0 f0 ff ff ff 	mov    $0xfffffffffffffff0,%rax
ffff800000106e24:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffff800000106e28:	8b 40 14             	mov    0x14(%rax),%eax
ffff800000106e2b:	83 f8 01             	cmp    $0x1,%eax
ffff800000106e2e:	74 16                	je     ffff800000106e46 <sched+0x65>
    panic("sched locks");
ffff800000106e30:	48 bf 2e cb 10 00 00 	movabs $0xffff80000010cb2e,%rdi
ffff800000106e37:	80 ff ff 
ffff800000106e3a:	48 b8 f9 0b 10 00 00 	movabs $0xffff800000100bf9,%rax
ffff800000106e41:	80 ff ff 
ffff800000106e44:	ff d0                	callq  *%rax
  if(proc->state == RUNNING)
ffff800000106e46:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffff800000106e4d:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffff800000106e51:	8b 40 18             	mov    0x18(%rax),%eax
ffff800000106e54:	83 f8 04             	cmp    $0x4,%eax
ffff800000106e57:	75 16                	jne    ffff800000106e6f <sched+0x8e>
    panic("sched running");
ffff800000106e59:	48 bf 3a cb 10 00 00 	movabs $0xffff80000010cb3a,%rdi
ffff800000106e60:	80 ff ff 
ffff800000106e63:	48 b8 f9 0b 10 00 00 	movabs $0xffff800000100bf9,%rax
ffff800000106e6a:	80 ff ff 
ffff800000106e6d:	ff d0                	callq  *%rax
  if(readeflags()&FL_IF)
ffff800000106e6f:	48 b8 e7 61 10 00 00 	movabs $0xffff8000001061e7,%rax
ffff800000106e76:	80 ff ff 
ffff800000106e79:	ff d0                	callq  *%rax
ffff800000106e7b:	25 00 02 00 00       	and    $0x200,%eax
ffff800000106e80:	48 85 c0             	test   %rax,%rax
ffff800000106e83:	74 16                	je     ffff800000106e9b <sched+0xba>
    panic("sched interruptible");
ffff800000106e85:	48 bf 48 cb 10 00 00 	movabs $0xffff80000010cb48,%rdi
ffff800000106e8c:	80 ff ff 
ffff800000106e8f:	48 b8 f9 0b 10 00 00 	movabs $0xffff800000100bf9,%rax
ffff800000106e96:	80 ff ff 
ffff800000106e99:	ff d0                	callq  *%rax
  intena = cpu->intena;
ffff800000106e9b:	48 c7 c0 f0 ff ff ff 	mov    $0xfffffffffffffff0,%rax
ffff800000106ea2:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffff800000106ea6:	8b 40 18             	mov    0x18(%rax),%eax
ffff800000106ea9:	89 45 fc             	mov    %eax,-0x4(%rbp)

  swtch(&proc->context, cpu->scheduler);
ffff800000106eac:	48 c7 c0 f0 ff ff ff 	mov    $0xfffffffffffffff0,%rax
ffff800000106eb3:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffff800000106eb7:	48 8b 40 08          	mov    0x8(%rax),%rax
ffff800000106ebb:	48 c7 c2 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rdx
ffff800000106ec2:	64 48 8b 12          	mov    %fs:(%rdx),%rdx
ffff800000106ec6:	48 83 c2 30          	add    $0x30,%rdx
ffff800000106eca:	48 89 c6             	mov    %rax,%rsi
ffff800000106ecd:	48 89 d7             	mov    %rdx,%rdi
ffff800000106ed0:	48 b8 29 86 10 00 00 	movabs $0xffff800000108629,%rax
ffff800000106ed7:	80 ff ff 
ffff800000106eda:	ff d0                	callq  *%rax
  cpu->intena = intena;
ffff800000106edc:	48 c7 c0 f0 ff ff ff 	mov    $0xfffffffffffffff0,%rax
ffff800000106ee3:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffff800000106ee7:	8b 55 fc             	mov    -0x4(%rbp),%edx
ffff800000106eea:	89 50 18             	mov    %edx,0x18(%rax)
}
ffff800000106eed:	90                   	nop
ffff800000106eee:	c9                   	leaveq 
ffff800000106eef:	c3                   	retq   

ffff800000106ef0 <yield>:

// Give up the CPU for one scheduling round.
void
yield(void)
{
ffff800000106ef0:	f3 0f 1e fa          	endbr64 
ffff800000106ef4:	55                   	push   %rbp
ffff800000106ef5:	48 89 e5             	mov    %rsp,%rbp
  acquire(&ptable.lock);  //DOC: yieldlock
ffff800000106ef8:	48 bf 40 74 11 00 00 	movabs $0xffff800000117440,%rdi
ffff800000106eff:	80 ff ff 
ffff800000106f02:	48 b8 17 7f 10 00 00 	movabs $0xffff800000107f17,%rax
ffff800000106f09:	80 ff ff 
ffff800000106f0c:	ff d0                	callq  *%rax
  proc->state = RUNNABLE;
ffff800000106f0e:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffff800000106f15:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffff800000106f19:	c7 40 18 03 00 00 00 	movl   $0x3,0x18(%rax)
  sched();
ffff800000106f20:	48 b8 e1 6d 10 00 00 	movabs $0xffff800000106de1,%rax
ffff800000106f27:	80 ff ff 
ffff800000106f2a:	ff d0                	callq  *%rax
  release(&ptable.lock);
ffff800000106f2c:	48 bf 40 74 11 00 00 	movabs $0xffff800000117440,%rdi
ffff800000106f33:	80 ff ff 
ffff800000106f36:	48 b8 b4 7f 10 00 00 	movabs $0xffff800000107fb4,%rax
ffff800000106f3d:	80 ff ff 
ffff800000106f40:	ff d0                	callq  *%rax
}
ffff800000106f42:	90                   	nop
ffff800000106f43:	5d                   	pop    %rbp
ffff800000106f44:	c3                   	retq   

ffff800000106f45 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
ffff800000106f45:	f3 0f 1e fa          	endbr64 
ffff800000106f49:	55                   	push   %rbp
ffff800000106f4a:	48 89 e5             	mov    %rsp,%rbp
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);
ffff800000106f4d:	48 bf 40 74 11 00 00 	movabs $0xffff800000117440,%rdi
ffff800000106f54:	80 ff ff 
ffff800000106f57:	48 b8 b4 7f 10 00 00 	movabs $0xffff800000107fb4,%rax
ffff800000106f5e:	80 ff ff 
ffff800000106f61:	ff d0                	callq  *%rax

  if (first && proc->is_process) {
ffff800000106f63:	48 b8 44 d5 10 00 00 	movabs $0xffff80000010d544,%rax
ffff800000106f6a:	80 ff ff 
ffff800000106f6d:	8b 00                	mov    (%rax),%eax
ffff800000106f6f:	85 c0                	test   %eax,%eax
ffff800000106f71:	74 47                	je     ffff800000106fba <forkret+0x75>
ffff800000106f73:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffff800000106f7a:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffff800000106f7e:	8b 80 d0 00 00 00    	mov    0xd0(%rax),%eax
ffff800000106f84:	85 c0                	test   %eax,%eax
ffff800000106f86:	74 32                	je     ffff800000106fba <forkret+0x75>
    // Some initialization functions must be run in the context
    // of a regular process (e.g., they call sleep), and thus cannot
    // be run from main().
    first = 0;
ffff800000106f88:	48 b8 44 d5 10 00 00 	movabs $0xffff80000010d544,%rax
ffff800000106f8f:	80 ff ff 
ffff800000106f92:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
    iinit(ROOTDEV);
ffff800000106f98:	bf 01 00 00 00       	mov    $0x1,%edi
ffff800000106f9d:	48 b8 6e 24 10 00 00 	movabs $0xffff80000010246e,%rax
ffff800000106fa4:	80 ff ff 
ffff800000106fa7:	ff d0                	callq  *%rax
    initlog(ROOTDEV);
ffff800000106fa9:	bf 01 00 00 00       	mov    $0x1,%edi
ffff800000106fae:	48 b8 1e 4c 10 00 00 	movabs $0xffff800000104c1e,%rax
ffff800000106fb5:	80 ff ff 
ffff800000106fb8:	ff d0                	callq  *%rax
  }

  // Return to "caller", actually trapret (see allocproc).
}
ffff800000106fba:	90                   	nop
ffff800000106fbb:	5d                   	pop    %rbp
ffff800000106fbc:	c3                   	retq   

ffff800000106fbd <sleep>:
//PAGEBREAK!
// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
ffff800000106fbd:	f3 0f 1e fa          	endbr64 
ffff800000106fc1:	55                   	push   %rbp
ffff800000106fc2:	48 89 e5             	mov    %rsp,%rbp
ffff800000106fc5:	48 83 ec 10          	sub    $0x10,%rsp
ffff800000106fc9:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
ffff800000106fcd:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  if(proc == 0)
ffff800000106fd1:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffff800000106fd8:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffff800000106fdc:	48 85 c0             	test   %rax,%rax
ffff800000106fdf:	75 16                	jne    ffff800000106ff7 <sleep+0x3a>
    panic("sleep");
ffff800000106fe1:	48 bf 5c cb 10 00 00 	movabs $0xffff80000010cb5c,%rdi
ffff800000106fe8:	80 ff ff 
ffff800000106feb:	48 b8 f9 0b 10 00 00 	movabs $0xffff800000100bf9,%rax
ffff800000106ff2:	80 ff ff 
ffff800000106ff5:	ff d0                	callq  *%rax

  if(lk == 0)
ffff800000106ff7:	48 83 7d f0 00       	cmpq   $0x0,-0x10(%rbp)
ffff800000106ffc:	75 16                	jne    ffff800000107014 <sleep+0x57>
    panic("sleep without lk");
ffff800000106ffe:	48 bf 62 cb 10 00 00 	movabs $0xffff80000010cb62,%rdi
ffff800000107005:	80 ff ff 
ffff800000107008:	48 b8 f9 0b 10 00 00 	movabs $0xffff800000100bf9,%rax
ffff80000010700f:	80 ff ff 
ffff800000107012:	ff d0                	callq  *%rax
  // change p->state and then call sched.
  // Once we hold ptable.lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup runs with ptable.lock locked),
  // so it's okay to release lk.
  if(lk != &ptable.lock){  //DOC: sleeplock0
ffff800000107014:	48 b8 40 74 11 00 00 	movabs $0xffff800000117440,%rax
ffff80000010701b:	80 ff ff 
ffff80000010701e:	48 39 45 f0          	cmp    %rax,-0x10(%rbp)
ffff800000107022:	74 29                	je     ffff80000010704d <sleep+0x90>
    acquire(&ptable.lock);  //DOC: sleeplock1
ffff800000107024:	48 bf 40 74 11 00 00 	movabs $0xffff800000117440,%rdi
ffff80000010702b:	80 ff ff 
ffff80000010702e:	48 b8 17 7f 10 00 00 	movabs $0xffff800000107f17,%rax
ffff800000107035:	80 ff ff 
ffff800000107038:	ff d0                	callq  *%rax
    release(lk);
ffff80000010703a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff80000010703e:	48 89 c7             	mov    %rax,%rdi
ffff800000107041:	48 b8 b4 7f 10 00 00 	movabs $0xffff800000107fb4,%rax
ffff800000107048:	80 ff ff 
ffff80000010704b:	ff d0                	callq  *%rax
  }

  // Go to sleep.
  proc->chan = chan;
ffff80000010704d:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffff800000107054:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffff800000107058:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
ffff80000010705c:	48 89 50 38          	mov    %rdx,0x38(%rax)
  proc->state = SLEEPING;
ffff800000107060:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffff800000107067:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffff80000010706b:	c7 40 18 02 00 00 00 	movl   $0x2,0x18(%rax)
  sched();
ffff800000107072:	48 b8 e1 6d 10 00 00 	movabs $0xffff800000106de1,%rax
ffff800000107079:	80 ff ff 
ffff80000010707c:	ff d0                	callq  *%rax

  // Tidy up.
  proc->chan = 0;
ffff80000010707e:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffff800000107085:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffff800000107089:	48 c7 40 38 00 00 00 	movq   $0x0,0x38(%rax)
ffff800000107090:	00 

  // Reacquire original lock.
  if(lk != &ptable.lock){  //DOC: sleeplock2
ffff800000107091:	48 b8 40 74 11 00 00 	movabs $0xffff800000117440,%rax
ffff800000107098:	80 ff ff 
ffff80000010709b:	48 39 45 f0          	cmp    %rax,-0x10(%rbp)
ffff80000010709f:	74 29                	je     ffff8000001070ca <sleep+0x10d>
    release(&ptable.lock);
ffff8000001070a1:	48 bf 40 74 11 00 00 	movabs $0xffff800000117440,%rdi
ffff8000001070a8:	80 ff ff 
ffff8000001070ab:	48 b8 b4 7f 10 00 00 	movabs $0xffff800000107fb4,%rax
ffff8000001070b2:	80 ff ff 
ffff8000001070b5:	ff d0                	callq  *%rax
    acquire(lk);
ffff8000001070b7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff8000001070bb:	48 89 c7             	mov    %rax,%rdi
ffff8000001070be:	48 b8 17 7f 10 00 00 	movabs $0xffff800000107f17,%rax
ffff8000001070c5:	80 ff ff 
ffff8000001070c8:	ff d0                	callq  *%rax
  }
}
ffff8000001070ca:	90                   	nop
ffff8000001070cb:	c9                   	leaveq 
ffff8000001070cc:	c3                   	retq   

ffff8000001070cd <wakeup1>:
//PAGEBREAK!
// Wake up all processes sleeping on chan.
// The ptable lock must be held.
static void
wakeup1(void *chan)
{
ffff8000001070cd:	f3 0f 1e fa          	endbr64 
ffff8000001070d1:	55                   	push   %rbp
ffff8000001070d2:	48 89 e5             	mov    %rsp,%rbp
ffff8000001070d5:	48 83 ec 18          	sub    $0x18,%rsp
ffff8000001070d9:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
ffff8000001070dd:	48 b8 a8 74 11 00 00 	movabs $0xffff8000001174a8,%rax
ffff8000001070e4:	80 ff ff 
ffff8000001070e7:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
ffff8000001070eb:	eb 2d                	jmp    ffff80000010711a <wakeup1+0x4d>
    if(p->state == SLEEPING && p->chan == chan)
ffff8000001070ed:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff8000001070f1:	8b 40 18             	mov    0x18(%rax),%eax
ffff8000001070f4:	83 f8 02             	cmp    $0x2,%eax
ffff8000001070f7:	75 19                	jne    ffff800000107112 <wakeup1+0x45>
ffff8000001070f9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff8000001070fd:	48 8b 40 38          	mov    0x38(%rax),%rax
ffff800000107101:	48 39 45 e8          	cmp    %rax,-0x18(%rbp)
ffff800000107105:	75 0b                	jne    ffff800000107112 <wakeup1+0x45>
      p->state = RUNNABLE;
ffff800000107107:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff80000010710b:	c7 40 18 03 00 00 00 	movl   $0x3,0x18(%rax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
ffff800000107112:	48 81 45 f8 e8 00 00 	addq   $0xe8,-0x8(%rbp)
ffff800000107119:	00 
ffff80000010711a:	48 b8 a8 ae 11 00 00 	movabs $0xffff80000011aea8,%rax
ffff800000107121:	80 ff ff 
ffff800000107124:	48 39 45 f8          	cmp    %rax,-0x8(%rbp)
ffff800000107128:	72 c3                	jb     ffff8000001070ed <wakeup1+0x20>
}
ffff80000010712a:	90                   	nop
ffff80000010712b:	90                   	nop
ffff80000010712c:	c9                   	leaveq 
ffff80000010712d:	c3                   	retq   

ffff80000010712e <wakeup>:

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
ffff80000010712e:	f3 0f 1e fa          	endbr64 
ffff800000107132:	55                   	push   %rbp
ffff800000107133:	48 89 e5             	mov    %rsp,%rbp
ffff800000107136:	48 83 ec 10          	sub    $0x10,%rsp
ffff80000010713a:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  acquire(&ptable.lock);
ffff80000010713e:	48 bf 40 74 11 00 00 	movabs $0xffff800000117440,%rdi
ffff800000107145:	80 ff ff 
ffff800000107148:	48 b8 17 7f 10 00 00 	movabs $0xffff800000107f17,%rax
ffff80000010714f:	80 ff ff 
ffff800000107152:	ff d0                	callq  *%rax
  wakeup1(chan);
ffff800000107154:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000107158:	48 89 c7             	mov    %rax,%rdi
ffff80000010715b:	48 b8 cd 70 10 00 00 	movabs $0xffff8000001070cd,%rax
ffff800000107162:	80 ff ff 
ffff800000107165:	ff d0                	callq  *%rax
  release(&ptable.lock);
ffff800000107167:	48 bf 40 74 11 00 00 	movabs $0xffff800000117440,%rdi
ffff80000010716e:	80 ff ff 
ffff800000107171:	48 b8 b4 7f 10 00 00 	movabs $0xffff800000107fb4,%rax
ffff800000107178:	80 ff ff 
ffff80000010717b:	ff d0                	callq  *%rax
}
ffff80000010717d:	90                   	nop
ffff80000010717e:	c9                   	leaveq 
ffff80000010717f:	c3                   	retq   

ffff800000107180 <kill>:
// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
ffff800000107180:	f3 0f 1e fa          	endbr64 
ffff800000107184:	55                   	push   %rbp
ffff800000107185:	48 89 e5             	mov    %rsp,%rbp
ffff800000107188:	48 83 ec 20          	sub    $0x20,%rsp
ffff80000010718c:	89 7d ec             	mov    %edi,-0x14(%rbp)
  struct proc *p;

  acquire(&ptable.lock);
ffff80000010718f:	48 bf 40 74 11 00 00 	movabs $0xffff800000117440,%rdi
ffff800000107196:	80 ff ff 
ffff800000107199:	48 b8 17 7f 10 00 00 	movabs $0xffff800000107f17,%rax
ffff8000001071a0:	80 ff ff 
ffff8000001071a3:	ff d0                	callq  *%rax
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
ffff8000001071a5:	48 b8 a8 74 11 00 00 	movabs $0xffff8000001174a8,%rax
ffff8000001071ac:	80 ff ff 
ffff8000001071af:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
ffff8000001071b3:	eb 53                	jmp    ffff800000107208 <kill+0x88>
    if(p->pid == pid){
ffff8000001071b5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff8000001071b9:	8b 40 1c             	mov    0x1c(%rax),%eax
ffff8000001071bc:	39 45 ec             	cmp    %eax,-0x14(%rbp)
ffff8000001071bf:	75 3f                	jne    ffff800000107200 <kill+0x80>
      p->killed = 1;
ffff8000001071c1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff8000001071c5:	c7 40 40 01 00 00 00 	movl   $0x1,0x40(%rax)
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
ffff8000001071cc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff8000001071d0:	8b 40 18             	mov    0x18(%rax),%eax
ffff8000001071d3:	83 f8 02             	cmp    $0x2,%eax
ffff8000001071d6:	75 0b                	jne    ffff8000001071e3 <kill+0x63>
        p->state = RUNNABLE;
ffff8000001071d8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff8000001071dc:	c7 40 18 03 00 00 00 	movl   $0x3,0x18(%rax)
      release(&ptable.lock);
ffff8000001071e3:	48 bf 40 74 11 00 00 	movabs $0xffff800000117440,%rdi
ffff8000001071ea:	80 ff ff 
ffff8000001071ed:	48 b8 b4 7f 10 00 00 	movabs $0xffff800000107fb4,%rax
ffff8000001071f4:	80 ff ff 
ffff8000001071f7:	ff d0                	callq  *%rax
      return 0;
ffff8000001071f9:	b8 00 00 00 00       	mov    $0x0,%eax
ffff8000001071fe:	eb 33                	jmp    ffff800000107233 <kill+0xb3>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
ffff800000107200:	48 81 45 f8 e8 00 00 	addq   $0xe8,-0x8(%rbp)
ffff800000107207:	00 
ffff800000107208:	48 b8 a8 ae 11 00 00 	movabs $0xffff80000011aea8,%rax
ffff80000010720f:	80 ff ff 
ffff800000107212:	48 39 45 f8          	cmp    %rax,-0x8(%rbp)
ffff800000107216:	72 9d                	jb     ffff8000001071b5 <kill+0x35>
    }
  }
  release(&ptable.lock);
ffff800000107218:	48 bf 40 74 11 00 00 	movabs $0xffff800000117440,%rdi
ffff80000010721f:	80 ff ff 
ffff800000107222:	48 b8 b4 7f 10 00 00 	movabs $0xffff800000107fb4,%rax
ffff800000107229:	80 ff ff 
ffff80000010722c:	ff d0                	callq  *%rax
  return -1;
ffff80000010722e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
ffff800000107233:	c9                   	leaveq 
ffff800000107234:	c3                   	retq   

ffff800000107235 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
ffff800000107235:	f3 0f 1e fa          	endbr64 
ffff800000107239:	55                   	push   %rbp
ffff80000010723a:	48 89 e5             	mov    %rsp,%rbp
ffff80000010723d:	48 83 ec 70          	sub    $0x70,%rsp
  int i;
  struct proc *p;
  char *state;
  addr_t pc[10];

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
ffff800000107241:	48 b8 a8 74 11 00 00 	movabs $0xffff8000001174a8,%rax
ffff800000107248:	80 ff ff 
ffff80000010724b:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
ffff80000010724f:	e9 3b 01 00 00       	jmpq   ffff80000010738f <procdump+0x15a>
    if(p->state == UNUSED)
ffff800000107254:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff800000107258:	8b 40 18             	mov    0x18(%rax),%eax
ffff80000010725b:	85 c0                	test   %eax,%eax
ffff80000010725d:	0f 84 23 01 00 00    	je     ffff800000107386 <procdump+0x151>
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
ffff800000107263:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff800000107267:	8b 40 18             	mov    0x18(%rax),%eax
ffff80000010726a:	83 f8 06             	cmp    $0x6,%eax
ffff80000010726d:	77 39                	ja     ffff8000001072a8 <procdump+0x73>
ffff80000010726f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff800000107273:	8b 50 18             	mov    0x18(%rax),%edx
ffff800000107276:	48 b8 60 d5 10 00 00 	movabs $0xffff80000010d560,%rax
ffff80000010727d:	80 ff ff 
ffff800000107280:	89 d2                	mov    %edx,%edx
ffff800000107282:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
ffff800000107286:	48 85 c0             	test   %rax,%rax
ffff800000107289:	74 1d                	je     ffff8000001072a8 <procdump+0x73>
      state = states[p->state];
ffff80000010728b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff80000010728f:	8b 50 18             	mov    0x18(%rax),%edx
ffff800000107292:	48 b8 60 d5 10 00 00 	movabs $0xffff80000010d560,%rax
ffff800000107299:	80 ff ff 
ffff80000010729c:	89 d2                	mov    %edx,%edx
ffff80000010729e:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
ffff8000001072a2:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
ffff8000001072a6:	eb 0e                	jmp    ffff8000001072b6 <procdump+0x81>
    else
      state = "???";
ffff8000001072a8:	48 b8 73 cb 10 00 00 	movabs $0xffff80000010cb73,%rax
ffff8000001072af:	80 ff ff 
ffff8000001072b2:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
    cprintf("%d %s %s", p->pid, state, p->name);
ffff8000001072b6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff8000001072ba:	48 8d 88 d4 00 00 00 	lea    0xd4(%rax),%rcx
ffff8000001072c1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff8000001072c5:	8b 40 1c             	mov    0x1c(%rax),%eax
ffff8000001072c8:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
ffff8000001072cc:	89 c6                	mov    %eax,%esi
ffff8000001072ce:	48 bf 77 cb 10 00 00 	movabs $0xffff80000010cb77,%rdi
ffff8000001072d5:	80 ff ff 
ffff8000001072d8:	b8 00 00 00 00       	mov    $0x0,%eax
ffff8000001072dd:	49 b8 18 08 10 00 00 	movabs $0xffff800000100818,%r8
ffff8000001072e4:	80 ff ff 
ffff8000001072e7:	41 ff d0             	callq  *%r8
    if(p->state == SLEEPING){
ffff8000001072ea:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff8000001072ee:	8b 40 18             	mov    0x18(%rax),%eax
ffff8000001072f1:	83 f8 02             	cmp    $0x2,%eax
ffff8000001072f4:	75 73                	jne    ffff800000107369 <procdump+0x134>
      getstackpcs((addr_t*)p->context->rbp+2, pc);
ffff8000001072f6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff8000001072fa:	48 8b 40 30          	mov    0x30(%rax),%rax
ffff8000001072fe:	48 8b 40 28          	mov    0x28(%rax),%rax
ffff800000107302:	48 83 c0 10          	add    $0x10,%rax
ffff800000107306:	48 89 c2             	mov    %rax,%rdx
ffff800000107309:	48 8d 45 90          	lea    -0x70(%rbp),%rax
ffff80000010730d:	48 89 c6             	mov    %rax,%rsi
ffff800000107310:	48 89 d7             	mov    %rdx,%rdi
ffff800000107313:	48 b8 61 80 10 00 00 	movabs $0xffff800000108061,%rax
ffff80000010731a:	80 ff ff 
ffff80000010731d:	ff d0                	callq  *%rax
      for(i=0; i<10 && pc[i] != 0; i++)
ffff80000010731f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
ffff800000107326:	eb 2c                	jmp    ffff800000107354 <procdump+0x11f>
        cprintf(" %p", pc[i]);
ffff800000107328:	8b 45 fc             	mov    -0x4(%rbp),%eax
ffff80000010732b:	48 98                	cltq   
ffff80000010732d:	48 8b 44 c5 90       	mov    -0x70(%rbp,%rax,8),%rax
ffff800000107332:	48 89 c6             	mov    %rax,%rsi
ffff800000107335:	48 bf 80 cb 10 00 00 	movabs $0xffff80000010cb80,%rdi
ffff80000010733c:	80 ff ff 
ffff80000010733f:	b8 00 00 00 00       	mov    $0x0,%eax
ffff800000107344:	48 ba 18 08 10 00 00 	movabs $0xffff800000100818,%rdx
ffff80000010734b:	80 ff ff 
ffff80000010734e:	ff d2                	callq  *%rdx
      for(i=0; i<10 && pc[i] != 0; i++)
ffff800000107350:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
ffff800000107354:	83 7d fc 09          	cmpl   $0x9,-0x4(%rbp)
ffff800000107358:	7f 0f                	jg     ffff800000107369 <procdump+0x134>
ffff80000010735a:	8b 45 fc             	mov    -0x4(%rbp),%eax
ffff80000010735d:	48 98                	cltq   
ffff80000010735f:	48 8b 44 c5 90       	mov    -0x70(%rbp,%rax,8),%rax
ffff800000107364:	48 85 c0             	test   %rax,%rax
ffff800000107367:	75 bf                	jne    ffff800000107328 <procdump+0xf3>
    }
    cprintf("\n");
ffff800000107369:	48 bf 84 cb 10 00 00 	movabs $0xffff80000010cb84,%rdi
ffff800000107370:	80 ff ff 
ffff800000107373:	b8 00 00 00 00       	mov    $0x0,%eax
ffff800000107378:	48 ba 18 08 10 00 00 	movabs $0xffff800000100818,%rdx
ffff80000010737f:	80 ff ff 
ffff800000107382:	ff d2                	callq  *%rdx
ffff800000107384:	eb 01                	jmp    ffff800000107387 <procdump+0x152>
      continue;
ffff800000107386:	90                   	nop
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
ffff800000107387:	48 81 45 f0 e8 00 00 	addq   $0xe8,-0x10(%rbp)
ffff80000010738e:	00 
ffff80000010738f:	48 b8 a8 ae 11 00 00 	movabs $0xffff80000011aea8,%rax
ffff800000107396:	80 ff ff 
ffff800000107399:	48 39 45 f0          	cmp    %rax,-0x10(%rbp)
ffff80000010739d:	0f 82 b1 fe ff ff    	jb     ffff800000107254 <procdump+0x1f>
  }
}
ffff8000001073a3:	90                   	nop
ffff8000001073a4:	90                   	nop
ffff8000001073a5:	c9                   	leaveq 
ffff8000001073a6:	c3                   	retq   

ffff8000001073a7 <exitkth>:

static void
exitkth(void)
{
ffff8000001073a7:	f3 0f 1e fa          	endbr64 
ffff8000001073ab:	55                   	push   %rbp
ffff8000001073ac:	48 89 e5             	mov    %rsp,%rbp
  acquire(&ptable.lock);
ffff8000001073af:	48 bf 40 74 11 00 00 	movabs $0xffff800000117440,%rdi
ffff8000001073b6:	80 ff ff 
ffff8000001073b9:	48 b8 17 7f 10 00 00 	movabs $0xffff800000107f17,%rax
ffff8000001073c0:	80 ff ff 
ffff8000001073c3:	ff d0                	callq  *%rax
  proc->state = KZOMBIE;
ffff8000001073c5:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffff8000001073cc:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffff8000001073d0:	c7 40 18 06 00 00 00 	movl   $0x6,0x18(%rax)
  sched();
ffff8000001073d7:	48 b8 e1 6d 10 00 00 	movabs $0xffff800000106de1,%rax
ffff8000001073de:	80 ff ff 
ffff8000001073e1:	ff d0                	callq  *%rax
  panic("zombie kth_exit");
ffff8000001073e3:	48 bf 86 cb 10 00 00 	movabs $0xffff80000010cb86,%rdi
ffff8000001073ea:	80 ff ff 
ffff8000001073ed:	48 b8 f9 0b 10 00 00 	movabs $0xffff800000100bf9,%rax
ffff8000001073f4:	80 ff ff 
ffff8000001073f7:	ff d0                	callq  *%rax

ffff8000001073f9 <startkth>:
}

  int
startkth(addr_t kroutine)
{
ffff8000001073f9:	f3 0f 1e fa          	endbr64 
ffff8000001073fd:	55                   	push   %rbp
ffff8000001073fe:	48 89 e5             	mov    %rsp,%rbp
ffff800000107401:	48 83 ec 20          	sub    $0x20,%rsp
ffff800000107405:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  // (6) it has a name "kthread" (for "CTRL+p" in the xv6 shell, see procdump() above)
  // TODO: Your code here
  struct proc *p;
  char *sp;
  //p->is_process = 0;
  acquire(&ptable.lock);
ffff800000107409:	48 bf 40 74 11 00 00 	movabs $0xffff800000117440,%rdi
ffff800000107410:	80 ff ff 
ffff800000107413:	48 b8 17 7f 10 00 00 	movabs $0xffff800000107f17,%rax
ffff80000010741a:	80 ff ff 
ffff80000010741d:	ff d0                	callq  *%rax

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
ffff80000010741f:	48 b8 a8 74 11 00 00 	movabs $0xffff8000001174a8,%rax
ffff800000107426:	80 ff ff 
ffff800000107429:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
ffff80000010742d:	eb 13                	jmp    ffff800000107442 <startkth+0x49>
    if(p->state == UNUSED)
ffff80000010742f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000107433:	8b 40 18             	mov    0x18(%rax),%eax
ffff800000107436:	85 c0                	test   %eax,%eax
ffff800000107438:	74 38                	je     ffff800000107472 <startkth+0x79>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
ffff80000010743a:	48 81 45 f8 e8 00 00 	addq   $0xe8,-0x8(%rbp)
ffff800000107441:	00 
ffff800000107442:	48 b8 a8 ae 11 00 00 	movabs $0xffff80000011aea8,%rax
ffff800000107449:	80 ff ff 
ffff80000010744c:	48 39 45 f8          	cmp    %rax,-0x8(%rbp)
ffff800000107450:	72 dd                	jb     ffff80000010742f <startkth+0x36>
      goto found;

  release(&ptable.lock);
ffff800000107452:	48 bf 40 74 11 00 00 	movabs $0xffff800000117440,%rdi
ffff800000107459:	80 ff ff 
ffff80000010745c:	48 b8 b4 7f 10 00 00 	movabs $0xffff800000107fb4,%rax
ffff800000107463:	80 ff ff 
ffff800000107466:	ff d0                	callq  *%rax
  return 0;
ffff800000107468:	b8 00 00 00 00       	mov    $0x0,%eax
ffff80000010746d:	e9 79 01 00 00       	jmpq   ffff8000001075eb <startkth+0x1f2>
      goto found;
ffff800000107472:	90                   	nop
ffff800000107473:	f3 0f 1e fa          	endbr64 

found:
  p->state = EMBRYO;
ffff800000107477:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff80000010747b:	c7 40 18 01 00 00 00 	movl   $0x1,0x18(%rax)
  p->pid = nextpid++;
ffff800000107482:	48 b8 40 d5 10 00 00 	movabs $0xffff80000010d540,%rax
ffff800000107489:	80 ff ff 
ffff80000010748c:	8b 00                	mov    (%rax),%eax
ffff80000010748e:	8d 50 01             	lea    0x1(%rax),%edx
ffff800000107491:	48 b9 40 d5 10 00 00 	movabs $0xffff80000010d540,%rcx
ffff800000107498:	80 ff ff 
ffff80000010749b:	89 11                	mov    %edx,(%rcx)
ffff80000010749d:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
ffff8000001074a1:	89 42 1c             	mov    %eax,0x1c(%rdx)
  release(&ptable.lock);
ffff8000001074a4:	48 bf 40 74 11 00 00 	movabs $0xffff800000117440,%rdi
ffff8000001074ab:	80 ff ff 
ffff8000001074ae:	48 b8 b4 7f 10 00 00 	movabs $0xffff800000107fb4,%rax
ffff8000001074b5:	80 ff ff 
ffff8000001074b8:	ff d0                	callq  *%rax
  p->is_process = 1; // regular process
ffff8000001074ba:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff8000001074be:	c7 80 d0 00 00 00 01 	movl   $0x1,0xd0(%rax)
ffff8000001074c5:	00 00 00 
  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
ffff8000001074c8:	48 b8 34 42 10 00 00 	movabs $0xffff800000104234,%rax
ffff8000001074cf:	80 ff ff 
ffff8000001074d2:	ff d0                	callq  *%rax
ffff8000001074d4:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
ffff8000001074d8:	48 89 42 10          	mov    %rax,0x10(%rdx)
ffff8000001074dc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff8000001074e0:	48 8b 40 10          	mov    0x10(%rax),%rax
ffff8000001074e4:	48 85 c0             	test   %rax,%rax
ffff8000001074e7:	75 15                	jne    ffff8000001074fe <startkth+0x105>
    p->state = UNUSED;
ffff8000001074e9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff8000001074ed:	c7 40 18 00 00 00 00 	movl   $0x0,0x18(%rax)
    return 0;
ffff8000001074f4:	b8 00 00 00 00       	mov    $0x0,%eax
ffff8000001074f9:	e9 ed 00 00 00       	jmpq   ffff8000001075eb <startkth+0x1f2>
  }
  sp = p->kstack + KSTACKSIZE;
ffff8000001074fe:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000107502:	48 8b 40 10          	mov    0x10(%rax),%rax
ffff800000107506:	48 05 00 10 00 00    	add    $0x1000,%rax
ffff80000010750c:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
  //sp -= sizeof *p->tf;

  // Set up new context to start executing at forkret,
  // which returns to trapret.
  
  sp -= sizeof(addr_t);
ffff800000107510:	48 83 6d f0 08       	subq   $0x8,-0x10(%rbp)
  *(addr_t*)sp = (addr_t)exitkth;
ffff800000107515:	48 ba a7 73 10 00 00 	movabs $0xffff8000001073a7,%rdx
ffff80000010751c:	80 ff ff 
ffff80000010751f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff800000107523:	48 89 10             	mov    %rdx,(%rax)
  
  sp -= sizeof(addr_t);
ffff800000107526:	48 83 6d f0 08       	subq   $0x8,-0x10(%rbp)
  *(addr_t*)sp = (addr_t)kroutine;
ffff80000010752b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff80000010752f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
ffff800000107533:	48 89 10             	mov    %rdx,(%rax)
  
  sp -= sizeof *p->context;
ffff800000107536:	48 83 6d f0 38       	subq   $0x38,-0x10(%rbp)
  p->context = (struct context*)sp;
ffff80000010753b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff80000010753f:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
ffff800000107543:	48 89 50 30          	mov    %rdx,0x30(%rax)
  memset(p->context, 0, sizeof *p->context);
ffff800000107547:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff80000010754b:	48 8b 40 30          	mov    0x30(%rax),%rax
ffff80000010754f:	ba 38 00 00 00       	mov    $0x38,%edx
ffff800000107554:	be 00 00 00 00       	mov    $0x0,%esi
ffff800000107559:	48 89 c7             	mov    %rax,%rdi
ffff80000010755c:	48 b8 bd 82 10 00 00 	movabs $0xffff8000001082bd,%rax
ffff800000107563:	80 ff ff 
ffff800000107566:	ff d0                	callq  *%rax
  p->context->rip = (addr_t)forkret;
ffff800000107568:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff80000010756c:	48 8b 40 30          	mov    0x30(%rax),%rax
ffff800000107570:	48 ba 45 6f 10 00 00 	movabs $0xffff800000106f45,%rdx
ffff800000107577:	80 ff ff 
ffff80000010757a:	48 89 50 30          	mov    %rdx,0x30(%rax)
  
  p->name[0] = 'k';
ffff80000010757e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000107582:	c6 80 d4 00 00 00 6b 	movb   $0x6b,0xd4(%rax)
  p->name[1] = 't';
ffff800000107589:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff80000010758d:	c6 80 d5 00 00 00 74 	movb   $0x74,0xd5(%rax)
  p->name[2] = 'h';
ffff800000107594:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000107598:	c6 80 d6 00 00 00 68 	movb   $0x68,0xd6(%rax)
  p->name[3] = 'r';
ffff80000010759f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff8000001075a3:	c6 80 d7 00 00 00 72 	movb   $0x72,0xd7(%rax)
  p->name[4] = 'e';
ffff8000001075aa:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff8000001075ae:	c6 80 d8 00 00 00 65 	movb   $0x65,0xd8(%rax)
  p->name[5] = 'a';
ffff8000001075b5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff8000001075b9:	c6 80 d9 00 00 00 61 	movb   $0x61,0xd9(%rax)
  p->name[6] = 'd';
ffff8000001075c0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff8000001075c4:	c6 80 da 00 00 00 64 	movb   $0x64,0xda(%rax)
  p->is_process = 0;
ffff8000001075cb:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff8000001075cf:	c7 80 d0 00 00 00 00 	movl   $0x0,0xd0(%rax)
ffff8000001075d6:	00 00 00 
  __sync_synchronize();
ffff8000001075d9:	0f ae f0             	mfence 
  p->state = RUNNABLE;
ffff8000001075dc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff8000001075e0:	c7 40 18 03 00 00 00 	movl   $0x3,0x18(%rax)
  return p;
ffff8000001075e7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
ffff8000001075eb:	c9                   	leaveq 
ffff8000001075ec:	c3                   	retq   

ffff8000001075ed <dummy_kth>:
	exitkth();
}*/


dummy_kth(void)
{
ffff8000001075ed:	f3 0f 1e fa          	endbr64 
ffff8000001075f1:	55                   	push   %rbp
ffff8000001075f2:	48 89 e5             	mov    %rsp,%rbp
ffff8000001075f5:	48 83 ec 10          	sub    $0x10,%rsp
  cprintf("%s is running\n", __func__);
ffff8000001075f9:	48 be 58 cc 10 00 00 	movabs $0xffff80000010cc58,%rsi
ffff800000107600:	80 ff ff 
ffff800000107603:	48 bf 96 cb 10 00 00 	movabs $0xffff80000010cb96,%rdi
ffff80000010760a:	80 ff ff 
ffff80000010760d:	b8 00 00 00 00       	mov    $0x0,%eax
ffff800000107612:	48 ba 18 08 10 00 00 	movabs $0xffff800000100818,%rdx
ffff800000107619:	80 ff ff 
ffff80000010761c:	ff d2                	callq  *%rdx
  for (int i = 0; i < 3; i++) {
ffff80000010761e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
ffff800000107625:	eb 73                	jmp    ffff80000010769a <dummy_kth+0xad>
    acquire(&tickslock);
ffff800000107627:	48 bf 80 c9 11 00 00 	movabs $0xffff80000011c980,%rdi
ffff80000010762e:	80 ff ff 
ffff800000107631:	48 b8 17 7f 10 00 00 	movabs $0xffff800000107f17,%rax
ffff800000107638:	80 ff ff 
ffff80000010763b:	ff d0                	callq  *%rax
    uint ticks0 = ticks;
ffff80000010763d:	48 b8 e8 c9 11 00 00 	movabs $0xffff80000011c9e8,%rax
ffff800000107644:	80 ff ff 
ffff800000107647:	8b 00                	mov    (%rax),%eax
ffff800000107649:	89 45 f8             	mov    %eax,-0x8(%rbp)
    do {
      sleep(&ticks, &tickslock);
ffff80000010764c:	48 be 80 c9 11 00 00 	movabs $0xffff80000011c980,%rsi
ffff800000107653:	80 ff ff 
ffff800000107656:	48 bf e8 c9 11 00 00 	movabs $0xffff80000011c9e8,%rdi
ffff80000010765d:	80 ff ff 
ffff800000107660:	48 b8 bd 6f 10 00 00 	movabs $0xffff800000106fbd,%rax
ffff800000107667:	80 ff ff 
ffff80000010766a:	ff d0                	callq  *%rax
    } while (ticks - ticks0 < 100);
ffff80000010766c:	48 b8 e8 c9 11 00 00 	movabs $0xffff80000011c9e8,%rax
ffff800000107673:	80 ff ff 
ffff800000107676:	8b 00                	mov    (%rax),%eax
ffff800000107678:	2b 45 f8             	sub    -0x8(%rbp),%eax
ffff80000010767b:	83 f8 63             	cmp    $0x63,%eax
ffff80000010767e:	76 cc                	jbe    ffff80000010764c <dummy_kth+0x5f>
    release(&tickslock);
ffff800000107680:	48 bf 80 c9 11 00 00 	movabs $0xffff80000011c980,%rdi
ffff800000107687:	80 ff ff 
ffff80000010768a:	48 b8 b4 7f 10 00 00 	movabs $0xffff800000107fb4,%rax
ffff800000107691:	80 ff ff 
ffff800000107694:	ff d0                	callq  *%rax
  for (int i = 0; i < 3; i++) {
ffff800000107696:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
ffff80000010769a:	83 7d fc 02          	cmpl   $0x2,-0x4(%rbp)
ffff80000010769e:	7e 87                	jle    ffff800000107627 <dummy_kth+0x3a>
  }
  cprintf("%s will now stop\n", __func__);
ffff8000001076a0:	48 be 58 cc 10 00 00 	movabs $0xffff80000010cc58,%rsi
ffff8000001076a7:	80 ff ff 
ffff8000001076aa:	48 bf a5 cb 10 00 00 	movabs $0xffff80000010cba5,%rdi
ffff8000001076b1:	80 ff ff 
ffff8000001076b4:	b8 00 00 00 00       	mov    $0x0,%eax
ffff8000001076b9:	48 ba 18 08 10 00 00 	movabs $0xffff800000100818,%rdx
ffff8000001076c0:	80 ff ff 
ffff8000001076c3:	ff d2                	callq  *%rdx
}
ffff8000001076c5:	90                   	nop
ffff8000001076c6:	c9                   	leaveq 
ffff8000001076c7:	c3                   	retq   

ffff8000001076c8 <aread_consume_one_task>:

static struct spinlock aio_lock;

  static void
aread_consume_one_task(struct aio_task * t)
{
ffff8000001076c8:	f3 0f 1e fa          	endbr64 
ffff8000001076cc:	55                   	push   %rbp
ffff8000001076cd:	48 89 e5             	mov    %rsp,%rbp
ffff8000001076d0:	48 83 ec 20          	sub    $0x20,%rsp
ffff8000001076d4:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  // execute the task t
  // use the tmp as a buffer for file I/O
  // use copyout() to copy the data in tmp to the user-provided buffer
  // finally, update the execution status to the user process
  // TODO: Your code here
int count = 0;
ffff8000001076d8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%rbp)
//cprintf("IP SIZe: %d\n", t->ip->size);
//cprintf("Nbytes: %d\n", t->nbytes);
int sizeofinput = t->ip->size;
ffff8000001076df:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff8000001076e3:	48 8b 40 10          	mov    0x10(%rax),%rax
ffff8000001076e7:	8b 80 9c 00 00 00    	mov    0x9c(%rax),%eax
ffff8000001076ed:	89 45 fc             	mov    %eax,-0x4(%rbp)
int offset = t->offset;
ffff8000001076f0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff8000001076f4:	8b 40 20             	mov    0x20(%rax),%eax
ffff8000001076f7:	89 45 f8             	mov    %eax,-0x8(%rbp)
static char tmp[4096];
while(0 < sizeofinput){
ffff8000001076fa:	e9 ed 00 00 00       	jmpq   ffff8000001077ec <aread_consume_one_task+0x124>

	if(t->ip->size > PGSIZE){
ffff8000001076ff:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000107703:	48 8b 40 10          	mov    0x10(%rax),%rax
ffff800000107707:	8b 80 9c 00 00 00    	mov    0x9c(%rax),%eax
ffff80000010770d:	3d 00 10 00 00       	cmp    $0x1000,%eax
ffff800000107712:	76 3f                	jbe    ffff800000107753 <aread_consume_one_task+0x8b>
		readi(t->ip, tmp,t->offset,PGSIZE);
ffff800000107714:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000107718:	8b 40 20             	mov    0x20(%rax),%eax
ffff80000010771b:	89 c2                	mov    %eax,%edx
ffff80000010771d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000107721:	48 8b 40 10          	mov    0x10(%rax),%rax
ffff800000107725:	b9 00 10 00 00       	mov    $0x1000,%ecx
ffff80000010772a:	48 be 60 b9 11 00 00 	movabs $0xffff80000011b960,%rsi
ffff800000107731:	80 ff ff 
ffff800000107734:	48 89 c7             	mov    %rax,%rdi
ffff800000107737:	48 b8 51 2f 10 00 00 	movabs $0xffff800000102f51,%rax
ffff80000010773e:	80 ff ff 
ffff800000107741:	ff d0                	callq  *%rax
		offset += PGSIZE;
ffff800000107743:	81 45 f8 00 10 00 00 	addl   $0x1000,-0x8(%rbp)
		sizeofinput-= PGSIZE;
ffff80000010774a:	81 6d fc 00 10 00 00 	subl   $0x1000,-0x4(%rbp)
ffff800000107751:	eb 3e                	jmp    ffff800000107791 <aread_consume_one_task+0xc9>
	}else{
		readi(t->ip, tmp, t->offset, sizeofinput);
ffff800000107753:	8b 55 fc             	mov    -0x4(%rbp),%edx
ffff800000107756:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff80000010775a:	8b 40 20             	mov    0x20(%rax),%eax
ffff80000010775d:	89 c6                	mov    %eax,%esi
ffff80000010775f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000107763:	48 8b 40 10          	mov    0x10(%rax),%rax
ffff800000107767:	89 d1                	mov    %edx,%ecx
ffff800000107769:	89 f2                	mov    %esi,%edx
ffff80000010776b:	48 be 60 b9 11 00 00 	movabs $0xffff80000011b960,%rsi
ffff800000107772:	80 ff ff 
ffff800000107775:	48 89 c7             	mov    %rax,%rdi
ffff800000107778:	48 b8 51 2f 10 00 00 	movabs $0xffff800000102f51,%rax
ffff80000010777f:	80 ff ff 
ffff800000107782:	ff d0                	callq  *%rax
		offset += sizeofinput;
ffff800000107784:	8b 45 fc             	mov    -0x4(%rbp),%eax
ffff800000107787:	01 45 f8             	add    %eax,-0x8(%rbp)
		sizeofinput = 0;
ffff80000010778a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	}
	if(copyout(t->pgdir,(addr_t)t->buffer,&tmp, t->nbytes) == -1){
ffff800000107791:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000107795:	8b 40 24             	mov    0x24(%rax),%eax
ffff800000107798:	48 63 d0             	movslq %eax,%rdx
ffff80000010779b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff80000010779f:	48 8b 40 18          	mov    0x18(%rax),%rax
ffff8000001077a3:	48 89 c6             	mov    %rax,%rsi
ffff8000001077a6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff8000001077aa:	48 8b 40 08          	mov    0x8(%rax),%rax
ffff8000001077ae:	48 89 d1             	mov    %rdx,%rcx
ffff8000001077b1:	48 ba 60 b9 11 00 00 	movabs $0xffff80000011b960,%rdx
ffff8000001077b8:	80 ff ff 
ffff8000001077bb:	48 89 c7             	mov    %rax,%rdi
ffff8000001077be:	48 b8 d3 c6 10 00 00 	movabs $0xffff80000010c6d3,%rax
ffff8000001077c5:	80 ff ff 
ffff8000001077c8:	ff d0                	callq  *%rax
ffff8000001077ca:	83 f8 ff             	cmp    $0xffffffff,%eax
ffff8000001077cd:	75 1d                	jne    ffff8000001077ec <aread_consume_one_task+0x124>
		cprintf("copyout failed!!\n");
ffff8000001077cf:	48 bf b7 cb 10 00 00 	movabs $0xffff80000010cbb7,%rdi
ffff8000001077d6:	80 ff ff 
ffff8000001077d9:	b8 00 00 00 00       	mov    $0x0,%eax
ffff8000001077de:	48 ba 18 08 10 00 00 	movabs $0xffff800000100818,%rdx
ffff8000001077e5:	80 ff ff 
ffff8000001077e8:	ff d2                	callq  *%rdx
		break;
ffff8000001077ea:	eb 0a                	jmp    ffff8000001077f6 <aread_consume_one_task+0x12e>
while(0 < sizeofinput){
ffff8000001077ec:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
ffff8000001077f0:	0f 8f 09 ff ff ff    	jg     ffff8000001076ff <aread_consume_one_task+0x37>
	}
}

if(copyout(t->pgdir,(addr_t) t->status, &t->nbytes, sizeof(int)) == -1){
ffff8000001077f6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff8000001077fa:	48 8d 50 24          	lea    0x24(%rax),%rdx
ffff8000001077fe:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000107802:	48 8b 00             	mov    (%rax),%rax
ffff800000107805:	48 89 c6             	mov    %rax,%rsi
ffff800000107808:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff80000010780c:	48 8b 40 08          	mov    0x8(%rax),%rax
ffff800000107810:	b9 04 00 00 00       	mov    $0x4,%ecx
ffff800000107815:	48 89 c7             	mov    %rax,%rdi
ffff800000107818:	48 b8 d3 c6 10 00 00 	movabs $0xffff80000010c6d3,%rax
ffff80000010781f:	80 ff ff 
ffff800000107822:	ff d0                	callq  *%rax
ffff800000107824:	83 f8 ff             	cmp    $0xffffffff,%eax
ffff800000107827:	75 1b                	jne    ffff800000107844 <aread_consume_one_task+0x17c>
                cprintf("copyout2 failed!!\n");
ffff800000107829:	48 bf c9 cb 10 00 00 	movabs $0xffff80000010cbc9,%rdi
ffff800000107830:	80 ff ff 
ffff800000107833:	b8 00 00 00 00       	mov    $0x0,%eax
ffff800000107838:	48 ba 18 08 10 00 00 	movabs $0xffff800000100818,%rdx
ffff80000010783f:	80 ff ff 
ffff800000107842:	ff d2                	callq  *%rdx
}
memset(tmp,0,PGSIZE);
ffff800000107844:	ba 00 10 00 00       	mov    $0x1000,%edx
ffff800000107849:	be 00 00 00 00       	mov    $0x0,%esi
ffff80000010784e:	48 bf 60 b9 11 00 00 	movabs $0xffff80000011b960,%rdi
ffff800000107855:	80 ff ff 
ffff800000107858:	48 b8 bd 82 10 00 00 	movabs $0xffff8000001082bd,%rax
ffff80000010785f:	80 ff ff 
ffff800000107862:	ff d0                	callq  *%rax
}
ffff800000107864:	90                   	nop
ffff800000107865:	c9                   	leaveq 
ffff800000107866:	c3                   	retq   

ffff800000107867 <aread_kth>:

  static void
aread_kth(void)
{
ffff800000107867:	f3 0f 1e fa          	endbr64 
ffff80000010786b:	55                   	push   %rbp
ffff80000010786c:	48 89 e5             	mov    %rsp,%rbp
  cprintf("%s is running at %p\n", __func__, proc->kstack);
ffff80000010786f:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffff800000107876:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffff80000010787a:	48 8b 40 10          	mov    0x10(%rax),%rax
ffff80000010787e:	48 89 c2             	mov    %rax,%rdx
ffff800000107881:	48 be 68 cc 10 00 00 	movabs $0xffff80000010cc68,%rsi
ffff800000107888:	80 ff ff 
ffff80000010788b:	48 bf dc cb 10 00 00 	movabs $0xffff80000010cbdc,%rdi
ffff800000107892:	80 ff ff 
ffff800000107895:	b8 00 00 00 00       	mov    $0x0,%eax
ffff80000010789a:	48 b9 18 08 10 00 00 	movabs $0xffff800000100818,%rcx
ffff8000001078a1:	80 ff ff 
ffff8000001078a4:	ff d1                	callq  *%rcx
  do {
    // don't need the lock
    while (num_tasks) {
ffff8000001078a6:	e9 9f 00 00 00       	jmpq   ffff80000010794a <aread_kth+0xe3>
      aread_consume_one_task(&aio_tasks[0]);
ffff8000001078ab:	48 bf c0 ae 11 00 00 	movabs $0xffff80000011aec0,%rdi
ffff8000001078b2:	80 ff ff 
ffff8000001078b5:	48 b8 c8 76 10 00 00 	movabs $0xffff8000001076c8,%rax
ffff8000001078bc:	80 ff ff 
ffff8000001078bf:	ff d0                	callq  *%rax
      // remove the task from the queue
      acquire(&aio_lock);
ffff8000001078c1:	48 bf e0 b8 11 00 00 	movabs $0xffff80000011b8e0,%rdi
ffff8000001078c8:	80 ff ff 
ffff8000001078cb:	48 b8 17 7f 10 00 00 	movabs $0xffff800000107f17,%rax
ffff8000001078d2:	80 ff ff 
ffff8000001078d5:	ff d0                	callq  *%rax
      memmove(aio_tasks, aio_tasks+1, sizeof(aio_tasks[0]) * (num_tasks-1));
ffff8000001078d7:	48 b8 c0 b8 11 00 00 	movabs $0xffff80000011b8c0,%rax
ffff8000001078de:	80 ff ff 
ffff8000001078e1:	8b 00                	mov    (%rax),%eax
ffff8000001078e3:	83 e8 01             	sub    $0x1,%eax
ffff8000001078e6:	48 98                	cltq   
ffff8000001078e8:	89 c2                	mov    %eax,%edx
ffff8000001078ea:	89 d0                	mov    %edx,%eax
ffff8000001078ec:	c1 e0 02             	shl    $0x2,%eax
ffff8000001078ef:	01 d0                	add    %edx,%eax
ffff8000001078f1:	c1 e0 03             	shl    $0x3,%eax
ffff8000001078f4:	89 c2                	mov    %eax,%edx
ffff8000001078f6:	48 b8 e8 ae 11 00 00 	movabs $0xffff80000011aee8,%rax
ffff8000001078fd:	80 ff ff 
ffff800000107900:	48 89 c6             	mov    %rax,%rsi
ffff800000107903:	48 bf c0 ae 11 00 00 	movabs $0xffff80000011aec0,%rdi
ffff80000010790a:	80 ff ff 
ffff80000010790d:	48 b8 ca 83 10 00 00 	movabs $0xffff8000001083ca,%rax
ffff800000107914:	80 ff ff 
ffff800000107917:	ff d0                	callq  *%rax
      num_tasks--;
ffff800000107919:	48 b8 c0 b8 11 00 00 	movabs $0xffff80000011b8c0,%rax
ffff800000107920:	80 ff ff 
ffff800000107923:	8b 00                	mov    (%rax),%eax
ffff800000107925:	8d 50 ff             	lea    -0x1(%rax),%edx
ffff800000107928:	48 b8 c0 b8 11 00 00 	movabs $0xffff80000011b8c0,%rax
ffff80000010792f:	80 ff ff 
ffff800000107932:	89 10                	mov    %edx,(%rax)
      release(&aio_lock);
ffff800000107934:	48 bf e0 b8 11 00 00 	movabs $0xffff80000011b8e0,%rdi
ffff80000010793b:	80 ff ff 
ffff80000010793e:	48 b8 b4 7f 10 00 00 	movabs $0xffff800000107fb4,%rax
ffff800000107945:	80 ff ff 
ffff800000107948:	ff d0                	callq  *%rax
    while (num_tasks) {
ffff80000010794a:	48 b8 c0 b8 11 00 00 	movabs $0xffff80000011b8c0,%rax
ffff800000107951:	80 ff ff 
ffff800000107954:	8b 00                	mov    (%rax),%eax
ffff800000107956:	85 c0                	test   %eax,%eax
ffff800000107958:	0f 85 4d ff ff ff    	jne    ffff8000001078ab <aread_kth+0x44>
    }

    acquire(&tickslock);
ffff80000010795e:	48 bf 80 c9 11 00 00 	movabs $0xffff80000011c980,%rdi
ffff800000107965:	80 ff ff 
ffff800000107968:	48 b8 17 7f 10 00 00 	movabs $0xffff800000107f17,%rax
ffff80000010796f:	80 ff ff 
ffff800000107972:	ff d0                	callq  *%rax
    sleep(&ticks, &tickslock);
ffff800000107974:	48 be 80 c9 11 00 00 	movabs $0xffff80000011c980,%rsi
ffff80000010797b:	80 ff ff 
ffff80000010797e:	48 bf e8 c9 11 00 00 	movabs $0xffff80000011c9e8,%rdi
ffff800000107985:	80 ff ff 
ffff800000107988:	48 b8 bd 6f 10 00 00 	movabs $0xffff800000106fbd,%rax
ffff80000010798f:	80 ff ff 
ffff800000107992:	ff d0                	callq  *%rax
    release(&tickslock);
ffff800000107994:	48 bf 80 c9 11 00 00 	movabs $0xffff80000011c980,%rdi
ffff80000010799b:	80 ff ff 
ffff80000010799e:	48 b8 b4 7f 10 00 00 	movabs $0xffff800000107fb4,%rax
ffff8000001079a5:	80 ff ff 
ffff8000001079a8:	ff d0                	callq  *%rax
    while (num_tasks) {
ffff8000001079aa:	eb 9e                	jmp    ffff80000010794a <aread_kth+0xe3>

ffff8000001079ac <kthinit>:
  } while (1);
}

  void
kthinit(void)
{
ffff8000001079ac:	f3 0f 1e fa          	endbr64 
ffff8000001079b0:	55                   	push   %rbp
ffff8000001079b1:	48 89 e5             	mov    %rsp,%rbp
  if (!startkth((addr_t)dummy_kth))
ffff8000001079b4:	48 b8 ed 75 10 00 00 	movabs $0xffff8000001075ed,%rax
ffff8000001079bb:	80 ff ff 
ffff8000001079be:	48 89 c7             	mov    %rax,%rdi
ffff8000001079c1:	48 b8 f9 73 10 00 00 	movabs $0xffff8000001073f9,%rax
ffff8000001079c8:	80 ff ff 
ffff8000001079cb:	ff d0                	callq  *%rax
ffff8000001079cd:	85 c0                	test   %eax,%eax
ffff8000001079cf:	75 1b                	jne    ffff8000001079ec <kthinit+0x40>
    cprintf("start dummy_kth failed\n");
ffff8000001079d1:	48 bf f1 cb 10 00 00 	movabs $0xffff80000010cbf1,%rdi
ffff8000001079d8:	80 ff ff 
ffff8000001079db:	b8 00 00 00 00       	mov    $0x0,%eax
ffff8000001079e0:	48 ba 18 08 10 00 00 	movabs $0xffff800000100818,%rdx
ffff8000001079e7:	80 ff ff 
ffff8000001079ea:	ff d2                	callq  *%rdx
  initlock(&aio_lock, "aio");
ffff8000001079ec:	48 be 09 cc 10 00 00 	movabs $0xffff80000010cc09,%rsi
ffff8000001079f3:	80 ff ff 
ffff8000001079f6:	48 bf e0 b8 11 00 00 	movabs $0xffff80000011b8e0,%rdi
ffff8000001079fd:	80 ff ff 
ffff800000107a00:	48 b8 de 7e 10 00 00 	movabs $0xffff800000107ede,%rax
ffff800000107a07:	80 ff ff 
ffff800000107a0a:	ff d0                	callq  *%rax
  if (!startkth((addr_t)aread_kth))
ffff800000107a0c:	48 b8 67 78 10 00 00 	movabs $0xffff800000107867,%rax
ffff800000107a13:	80 ff ff 
ffff800000107a16:	48 89 c7             	mov    %rax,%rdi
ffff800000107a19:	48 b8 f9 73 10 00 00 	movabs $0xffff8000001073f9,%rax
ffff800000107a20:	80 ff ff 
ffff800000107a23:	ff d0                	callq  *%rax
ffff800000107a25:	85 c0                	test   %eax,%eax
ffff800000107a27:	75 1b                	jne    ffff800000107a44 <kthinit+0x98>
    cprintf("start aread_kth failed\n");
ffff800000107a29:	48 bf 0d cc 10 00 00 	movabs $0xffff80000010cc0d,%rdi
ffff800000107a30:	80 ff ff 
ffff800000107a33:	b8 00 00 00 00       	mov    $0x0,%eax
ffff800000107a38:	48 ba 18 08 10 00 00 	movabs $0xffff800000100818,%rdx
ffff800000107a3f:	80 ff ff 
ffff800000107a42:	ff d2                	callq  *%rdx
}
ffff800000107a44:	90                   	nop
ffff800000107a45:	5d                   	pop    %rbp
ffff800000107a46:	c3                   	retq   

ffff800000107a47 <sys_aread>:

  int
sys_aread(void)
{
ffff800000107a47:	f3 0f 1e fa          	endbr64 
ffff800000107a4b:	55                   	push   %rbp
ffff800000107a4c:	48 89 e5             	mov    %rsp,%rbp
ffff800000107a4f:	48 83 ec 20          	sub    $0x20,%rsp
  struct file *file;
  int offset, nbytes;
  char *buffer;
  volatile int * status;

  argint(2, &offset);
ffff800000107a53:	48 8d 45 f4          	lea    -0xc(%rbp),%rax
ffff800000107a57:	48 89 c6             	mov    %rax,%rsi
ffff800000107a5a:	bf 02 00 00 00       	mov    $0x2,%edi
ffff800000107a5f:	48 b8 5a 88 10 00 00 	movabs $0xffff80000010885a,%rax
ffff800000107a66:	80 ff ff 
ffff800000107a69:	ff d0                	callq  *%rax
  argint(3, &nbytes);
ffff800000107a6b:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
ffff800000107a6f:	48 89 c6             	mov    %rax,%rsi
ffff800000107a72:	bf 03 00 00 00       	mov    $0x3,%edi
ffff800000107a77:	48 b8 5a 88 10 00 00 	movabs $0xffff80000010885a,%rax
ffff800000107a7e:	80 ff ff 
ffff800000107a81:	ff d0                	callq  *%rax
  if (nbytes <= 0)
ffff800000107a83:	8b 45 f0             	mov    -0x10(%rbp),%eax
ffff800000107a86:	85 c0                	test   %eax,%eax
ffff800000107a88:	7f 0a                	jg     ffff800000107a94 <sys_aread+0x4d>
    return -1;
ffff800000107a8a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
ffff800000107a8f:	e9 55 02 00 00       	jmpq   ffff800000107ce9 <sys_aread+0x2a2>
  if (argfd(0, 0, &file) < 0 || argptr(1, &buffer, nbytes) < 0 || argptr(4, (char **)&status, sizeof(int)) < 0)
ffff800000107a94:	48 8d 45 f8          	lea    -0x8(%rbp),%rax
ffff800000107a98:	48 89 c2             	mov    %rax,%rdx
ffff800000107a9b:	be 00 00 00 00       	mov    $0x0,%esi
ffff800000107aa0:	bf 00 00 00 00       	mov    $0x0,%edi
ffff800000107aa5:	48 b8 b3 8a 10 00 00 	movabs $0xffff800000108ab3,%rax
ffff800000107aac:	80 ff ff 
ffff800000107aaf:	ff d0                	callq  *%rax
ffff800000107ab1:	85 c0                	test   %eax,%eax
ffff800000107ab3:	78 40                	js     ffff800000107af5 <sys_aread+0xae>
ffff800000107ab5:	8b 55 f0             	mov    -0x10(%rbp),%edx
ffff800000107ab8:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
ffff800000107abc:	48 89 c6             	mov    %rax,%rsi
ffff800000107abf:	bf 01 00 00 00       	mov    $0x1,%edi
ffff800000107ac4:	48 b8 bf 88 10 00 00 	movabs $0xffff8000001088bf,%rax
ffff800000107acb:	80 ff ff 
ffff800000107ace:	ff d0                	callq  *%rax
ffff800000107ad0:	85 c0                	test   %eax,%eax
ffff800000107ad2:	78 21                	js     ffff800000107af5 <sys_aread+0xae>
ffff800000107ad4:	48 8d 45 e0          	lea    -0x20(%rbp),%rax
ffff800000107ad8:	ba 04 00 00 00       	mov    $0x4,%edx
ffff800000107add:	48 89 c6             	mov    %rax,%rsi
ffff800000107ae0:	bf 04 00 00 00       	mov    $0x4,%edi
ffff800000107ae5:	48 b8 bf 88 10 00 00 	movabs $0xffff8000001088bf,%rax
ffff800000107aec:	80 ff ff 
ffff800000107aef:	ff d0                	callq  *%rax
ffff800000107af1:	85 c0                	test   %eax,%eax
ffff800000107af3:	79 0a                	jns    ffff800000107aff <sys_aread+0xb8>
    return -1;
ffff800000107af5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
ffff800000107afa:	e9 ea 01 00 00       	jmpq   ffff800000107ce9 <sys_aread+0x2a2>

  *status = 0; // processing
ffff800000107aff:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
ffff800000107b03:	c7 00 00 00 00 00    	movl   $0x0,(%rax)

  // nothing to copy
  if (file->ip->size <= offset)
ffff800000107b09:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000107b0d:	48 8b 40 18          	mov    0x18(%rax),%rax
ffff800000107b11:	8b 80 9c 00 00 00    	mov    0x9c(%rax),%eax
ffff800000107b17:	8b 55 f4             	mov    -0xc(%rbp),%edx
ffff800000107b1a:	39 d0                	cmp    %edx,%eax
ffff800000107b1c:	77 0a                	ja     ffff800000107b28 <sys_aread+0xe1>
    return 0; // no I/O required
ffff800000107b1e:	b8 00 00 00 00       	mov    $0x0,%eax
ffff800000107b23:	e9 c1 01 00 00       	jmpq   ffff800000107ce9 <sys_aread+0x2a2>

  // maybe we will only get fewer bytes
  if (offset + nbytes > file->ip->size)
ffff800000107b28:	8b 55 f4             	mov    -0xc(%rbp),%edx
ffff800000107b2b:	8b 45 f0             	mov    -0x10(%rbp),%eax
ffff800000107b2e:	01 d0                	add    %edx,%eax
ffff800000107b30:	89 c2                	mov    %eax,%edx
ffff800000107b32:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000107b36:	48 8b 40 18          	mov    0x18(%rax),%rax
ffff800000107b3a:	8b 80 9c 00 00 00    	mov    0x9c(%rax),%eax
ffff800000107b40:	39 c2                	cmp    %eax,%edx
ffff800000107b42:	76 16                	jbe    ffff800000107b5a <sys_aread+0x113>
    nbytes = file->ip->size - offset;
ffff800000107b44:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000107b48:	48 8b 40 18          	mov    0x18(%rax),%rax
ffff800000107b4c:	8b 80 9c 00 00 00    	mov    0x9c(%rax),%eax
ffff800000107b52:	8b 55 f4             	mov    -0xc(%rbp),%edx
ffff800000107b55:	29 d0                	sub    %edx,%eax
ffff800000107b57:	89 45 f0             	mov    %eax,-0x10(%rbp)

  // append the task to the aio queue
  // TODO: Your code here
  acquire(&aio_lock);
ffff800000107b5a:	48 bf e0 b8 11 00 00 	movabs $0xffff80000011b8e0,%rdi
ffff800000107b61:	80 ff ff 
ffff800000107b64:	48 b8 17 7f 10 00 00 	movabs $0xffff800000107f17,%rax
ffff800000107b6b:	80 ff ff 
ffff800000107b6e:	ff d0                	callq  *%rax

  aio_tasks[num_tasks].status = status;
ffff800000107b70:	48 b8 c0 b8 11 00 00 	movabs $0xffff80000011b8c0,%rax
ffff800000107b77:	80 ff ff 
ffff800000107b7a:	8b 00                	mov    (%rax),%eax
ffff800000107b7c:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
ffff800000107b80:	48 be c0 ae 11 00 00 	movabs $0xffff80000011aec0,%rsi
ffff800000107b87:	80 ff ff 
ffff800000107b8a:	48 63 d0             	movslq %eax,%rdx
ffff800000107b8d:	48 89 d0             	mov    %rdx,%rax
ffff800000107b90:	48 c1 e0 02          	shl    $0x2,%rax
ffff800000107b94:	48 01 d0             	add    %rdx,%rax
ffff800000107b97:	48 c1 e0 03          	shl    $0x3,%rax
ffff800000107b9b:	48 01 f0             	add    %rsi,%rax
ffff800000107b9e:	48 89 08             	mov    %rcx,(%rax)
  aio_tasks[num_tasks].pgdir = proc->pgdir;
ffff800000107ba1:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffff800000107ba8:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffff800000107bac:	48 ba c0 b8 11 00 00 	movabs $0xffff80000011b8c0,%rdx
ffff800000107bb3:	80 ff ff 
ffff800000107bb6:	8b 12                	mov    (%rdx),%edx
ffff800000107bb8:	48 8b 48 08          	mov    0x8(%rax),%rcx
ffff800000107bbc:	48 be c0 ae 11 00 00 	movabs $0xffff80000011aec0,%rsi
ffff800000107bc3:	80 ff ff 
ffff800000107bc6:	48 63 d2             	movslq %edx,%rdx
ffff800000107bc9:	48 89 d0             	mov    %rdx,%rax
ffff800000107bcc:	48 c1 e0 02          	shl    $0x2,%rax
ffff800000107bd0:	48 01 d0             	add    %rdx,%rax
ffff800000107bd3:	48 c1 e0 03          	shl    $0x3,%rax
ffff800000107bd7:	48 01 f0             	add    %rsi,%rax
ffff800000107bda:	48 83 c0 08          	add    $0x8,%rax
ffff800000107bde:	48 89 08             	mov    %rcx,(%rax)
  aio_tasks[num_tasks].ip = file->ip;
ffff800000107be1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000107be5:	48 ba c0 b8 11 00 00 	movabs $0xffff80000011b8c0,%rdx
ffff800000107bec:	80 ff ff 
ffff800000107bef:	8b 12                	mov    (%rdx),%edx
ffff800000107bf1:	48 8b 48 18          	mov    0x18(%rax),%rcx
ffff800000107bf5:	48 be c0 ae 11 00 00 	movabs $0xffff80000011aec0,%rsi
ffff800000107bfc:	80 ff ff 
ffff800000107bff:	48 63 d2             	movslq %edx,%rdx
ffff800000107c02:	48 89 d0             	mov    %rdx,%rax
ffff800000107c05:	48 c1 e0 02          	shl    $0x2,%rax
ffff800000107c09:	48 01 d0             	add    %rdx,%rax
ffff800000107c0c:	48 c1 e0 03          	shl    $0x3,%rax
ffff800000107c10:	48 01 f0             	add    %rsi,%rax
ffff800000107c13:	48 83 c0 10          	add    $0x10,%rax
ffff800000107c17:	48 89 08             	mov    %rcx,(%rax)
  aio_tasks[num_tasks].buffer = buffer;
ffff800000107c1a:	48 b8 c0 b8 11 00 00 	movabs $0xffff80000011b8c0,%rax
ffff800000107c21:	80 ff ff 
ffff800000107c24:	8b 00                	mov    (%rax),%eax
ffff800000107c26:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
ffff800000107c2a:	48 be c0 ae 11 00 00 	movabs $0xffff80000011aec0,%rsi
ffff800000107c31:	80 ff ff 
ffff800000107c34:	48 63 d0             	movslq %eax,%rdx
ffff800000107c37:	48 89 d0             	mov    %rdx,%rax
ffff800000107c3a:	48 c1 e0 02          	shl    $0x2,%rax
ffff800000107c3e:	48 01 d0             	add    %rdx,%rax
ffff800000107c41:	48 c1 e0 03          	shl    $0x3,%rax
ffff800000107c45:	48 01 f0             	add    %rsi,%rax
ffff800000107c48:	48 83 c0 18          	add    $0x18,%rax
ffff800000107c4c:	48 89 08             	mov    %rcx,(%rax)
  aio_tasks[num_tasks].offset = offset;
ffff800000107c4f:	48 b8 c0 b8 11 00 00 	movabs $0xffff80000011b8c0,%rax
ffff800000107c56:	80 ff ff 
ffff800000107c59:	8b 00                	mov    (%rax),%eax
ffff800000107c5b:	8b 4d f4             	mov    -0xc(%rbp),%ecx
ffff800000107c5e:	48 be c0 ae 11 00 00 	movabs $0xffff80000011aec0,%rsi
ffff800000107c65:	80 ff ff 
ffff800000107c68:	48 63 d0             	movslq %eax,%rdx
ffff800000107c6b:	48 89 d0             	mov    %rdx,%rax
ffff800000107c6e:	48 c1 e0 02          	shl    $0x2,%rax
ffff800000107c72:	48 01 d0             	add    %rdx,%rax
ffff800000107c75:	48 c1 e0 03          	shl    $0x3,%rax
ffff800000107c79:	48 01 f0             	add    %rsi,%rax
ffff800000107c7c:	48 83 c0 20          	add    $0x20,%rax
ffff800000107c80:	89 08                	mov    %ecx,(%rax)
  aio_tasks[num_tasks].nbytes = nbytes; 
ffff800000107c82:	48 b8 c0 b8 11 00 00 	movabs $0xffff80000011b8c0,%rax
ffff800000107c89:	80 ff ff 
ffff800000107c8c:	8b 00                	mov    (%rax),%eax
ffff800000107c8e:	8b 4d f0             	mov    -0x10(%rbp),%ecx
ffff800000107c91:	48 be c0 ae 11 00 00 	movabs $0xffff80000011aec0,%rsi
ffff800000107c98:	80 ff ff 
ffff800000107c9b:	48 63 d0             	movslq %eax,%rdx
ffff800000107c9e:	48 89 d0             	mov    %rdx,%rax
ffff800000107ca1:	48 c1 e0 02          	shl    $0x2,%rax
ffff800000107ca5:	48 01 d0             	add    %rdx,%rax
ffff800000107ca8:	48 c1 e0 03          	shl    $0x3,%rax
ffff800000107cac:	48 01 f0             	add    %rsi,%rax
ffff800000107caf:	48 83 c0 24          	add    $0x24,%rax
ffff800000107cb3:	89 08                	mov    %ecx,(%rax)
  num_tasks++;
ffff800000107cb5:	48 b8 c0 b8 11 00 00 	movabs $0xffff80000011b8c0,%rax
ffff800000107cbc:	80 ff ff 
ffff800000107cbf:	8b 00                	mov    (%rax),%eax
ffff800000107cc1:	8d 50 01             	lea    0x1(%rax),%edx
ffff800000107cc4:	48 b8 c0 b8 11 00 00 	movabs $0xffff80000011b8c0,%rax
ffff800000107ccb:	80 ff ff 
ffff800000107cce:	89 10                	mov    %edx,(%rax)
  release(&aio_lock);
ffff800000107cd0:	48 bf e0 b8 11 00 00 	movabs $0xffff80000011b8e0,%rdi
ffff800000107cd7:	80 ff ff 
ffff800000107cda:	48 b8 b4 7f 10 00 00 	movabs $0xffff800000107fb4,%rax
ffff800000107ce1:	80 ff ff 
ffff800000107ce4:	ff d0                	callq  *%rax
  
  // return how many bytes to expect (> 0)
  return nbytes;
ffff800000107ce6:	8b 45 f0             	mov    -0x10(%rbp),%eax
}
ffff800000107ce9:	c9                   	leaveq 
ffff800000107cea:	c3                   	retq   

ffff800000107ceb <initsleeplock>:
#include "spinlock.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
ffff800000107ceb:	f3 0f 1e fa          	endbr64 
ffff800000107cef:	55                   	push   %rbp
ffff800000107cf0:	48 89 e5             	mov    %rsp,%rbp
ffff800000107cf3:	48 83 ec 10          	sub    $0x10,%rsp
ffff800000107cf7:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
ffff800000107cfb:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  initlock(&lk->lk, "sleep lock");
ffff800000107cff:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000107d03:	48 83 c0 08          	add    $0x8,%rax
ffff800000107d07:	48 be 72 cc 10 00 00 	movabs $0xffff80000010cc72,%rsi
ffff800000107d0e:	80 ff ff 
ffff800000107d11:	48 89 c7             	mov    %rax,%rdi
ffff800000107d14:	48 b8 de 7e 10 00 00 	movabs $0xffff800000107ede,%rax
ffff800000107d1b:	80 ff ff 
ffff800000107d1e:	ff d0                	callq  *%rax
  lk->name = name;
ffff800000107d20:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000107d24:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
ffff800000107d28:	48 89 50 70          	mov    %rdx,0x70(%rax)
  lk->locked = 0;
ffff800000107d2c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000107d30:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
  lk->pid = 0;
ffff800000107d36:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000107d3a:	c7 40 78 00 00 00 00 	movl   $0x0,0x78(%rax)
}
ffff800000107d41:	90                   	nop
ffff800000107d42:	c9                   	leaveq 
ffff800000107d43:	c3                   	retq   

ffff800000107d44 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
ffff800000107d44:	f3 0f 1e fa          	endbr64 
ffff800000107d48:	55                   	push   %rbp
ffff800000107d49:	48 89 e5             	mov    %rsp,%rbp
ffff800000107d4c:	48 83 ec 10          	sub    $0x10,%rsp
ffff800000107d50:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  acquire(&lk->lk);
ffff800000107d54:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000107d58:	48 83 c0 08          	add    $0x8,%rax
ffff800000107d5c:	48 89 c7             	mov    %rax,%rdi
ffff800000107d5f:	48 b8 17 7f 10 00 00 	movabs $0xffff800000107f17,%rax
ffff800000107d66:	80 ff ff 
ffff800000107d69:	ff d0                	callq  *%rax
  while (lk->locked)
ffff800000107d6b:	eb 1e                	jmp    ffff800000107d8b <acquiresleep+0x47>
    sleep(lk, &lk->lk);
ffff800000107d6d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000107d71:	48 8d 50 08          	lea    0x8(%rax),%rdx
ffff800000107d75:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000107d79:	48 89 d6             	mov    %rdx,%rsi
ffff800000107d7c:	48 89 c7             	mov    %rax,%rdi
ffff800000107d7f:	48 b8 bd 6f 10 00 00 	movabs $0xffff800000106fbd,%rax
ffff800000107d86:	80 ff ff 
ffff800000107d89:	ff d0                	callq  *%rax
  while (lk->locked)
ffff800000107d8b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000107d8f:	8b 00                	mov    (%rax),%eax
ffff800000107d91:	85 c0                	test   %eax,%eax
ffff800000107d93:	75 d8                	jne    ffff800000107d6d <acquiresleep+0x29>
  lk->locked = 1;
ffff800000107d95:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000107d99:	c7 00 01 00 00 00    	movl   $0x1,(%rax)
  lk->pid = proc->pid;
ffff800000107d9f:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffff800000107da6:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffff800000107daa:	8b 50 1c             	mov    0x1c(%rax),%edx
ffff800000107dad:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000107db1:	89 50 78             	mov    %edx,0x78(%rax)
  release(&lk->lk);
ffff800000107db4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000107db8:	48 83 c0 08          	add    $0x8,%rax
ffff800000107dbc:	48 89 c7             	mov    %rax,%rdi
ffff800000107dbf:	48 b8 b4 7f 10 00 00 	movabs $0xffff800000107fb4,%rax
ffff800000107dc6:	80 ff ff 
ffff800000107dc9:	ff d0                	callq  *%rax
}
ffff800000107dcb:	90                   	nop
ffff800000107dcc:	c9                   	leaveq 
ffff800000107dcd:	c3                   	retq   

ffff800000107dce <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
ffff800000107dce:	f3 0f 1e fa          	endbr64 
ffff800000107dd2:	55                   	push   %rbp
ffff800000107dd3:	48 89 e5             	mov    %rsp,%rbp
ffff800000107dd6:	48 83 ec 10          	sub    $0x10,%rsp
ffff800000107dda:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  acquire(&lk->lk);
ffff800000107dde:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000107de2:	48 83 c0 08          	add    $0x8,%rax
ffff800000107de6:	48 89 c7             	mov    %rax,%rdi
ffff800000107de9:	48 b8 17 7f 10 00 00 	movabs $0xffff800000107f17,%rax
ffff800000107df0:	80 ff ff 
ffff800000107df3:	ff d0                	callq  *%rax
  lk->locked = 0;
ffff800000107df5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000107df9:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
  lk->pid = 0;
ffff800000107dff:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000107e03:	c7 40 78 00 00 00 00 	movl   $0x0,0x78(%rax)
  wakeup(lk);
ffff800000107e0a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000107e0e:	48 89 c7             	mov    %rax,%rdi
ffff800000107e11:	48 b8 2e 71 10 00 00 	movabs $0xffff80000010712e,%rax
ffff800000107e18:	80 ff ff 
ffff800000107e1b:	ff d0                	callq  *%rax
  release(&lk->lk);
ffff800000107e1d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000107e21:	48 83 c0 08          	add    $0x8,%rax
ffff800000107e25:	48 89 c7             	mov    %rax,%rdi
ffff800000107e28:	48 b8 b4 7f 10 00 00 	movabs $0xffff800000107fb4,%rax
ffff800000107e2f:	80 ff ff 
ffff800000107e32:	ff d0                	callq  *%rax
}
ffff800000107e34:	90                   	nop
ffff800000107e35:	c9                   	leaveq 
ffff800000107e36:	c3                   	retq   

ffff800000107e37 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
ffff800000107e37:	f3 0f 1e fa          	endbr64 
ffff800000107e3b:	55                   	push   %rbp
ffff800000107e3c:	48 89 e5             	mov    %rsp,%rbp
ffff800000107e3f:	48 83 ec 20          	sub    $0x20,%rsp
ffff800000107e43:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  acquire(&lk->lk);
ffff800000107e47:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000107e4b:	48 83 c0 08          	add    $0x8,%rax
ffff800000107e4f:	48 89 c7             	mov    %rax,%rdi
ffff800000107e52:	48 b8 17 7f 10 00 00 	movabs $0xffff800000107f17,%rax
ffff800000107e59:	80 ff ff 
ffff800000107e5c:	ff d0                	callq  *%rax
  int r = lk->locked;
ffff800000107e5e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000107e62:	8b 00                	mov    (%rax),%eax
ffff800000107e64:	89 45 fc             	mov    %eax,-0x4(%rbp)
  release(&lk->lk);
ffff800000107e67:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000107e6b:	48 83 c0 08          	add    $0x8,%rax
ffff800000107e6f:	48 89 c7             	mov    %rax,%rdi
ffff800000107e72:	48 b8 b4 7f 10 00 00 	movabs $0xffff800000107fb4,%rax
ffff800000107e79:	80 ff ff 
ffff800000107e7c:	ff d0                	callq  *%rax
  return r;
ffff800000107e7e:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
ffff800000107e81:	c9                   	leaveq 
ffff800000107e82:	c3                   	retq   

ffff800000107e83 <readeflags>:
{
ffff800000107e83:	f3 0f 1e fa          	endbr64 
ffff800000107e87:	55                   	push   %rbp
ffff800000107e88:	48 89 e5             	mov    %rsp,%rbp
ffff800000107e8b:	48 83 ec 10          	sub    $0x10,%rsp
  asm volatile("pushf; pop %0" : "=r" (eflags));
ffff800000107e8f:	9c                   	pushfq 
ffff800000107e90:	58                   	pop    %rax
ffff800000107e91:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  return eflags;
ffff800000107e95:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
ffff800000107e99:	c9                   	leaveq 
ffff800000107e9a:	c3                   	retq   

ffff800000107e9b <cli>:
{
ffff800000107e9b:	f3 0f 1e fa          	endbr64 
ffff800000107e9f:	55                   	push   %rbp
ffff800000107ea0:	48 89 e5             	mov    %rsp,%rbp
  asm volatile("cli");
ffff800000107ea3:	fa                   	cli    
}
ffff800000107ea4:	90                   	nop
ffff800000107ea5:	5d                   	pop    %rbp
ffff800000107ea6:	c3                   	retq   

ffff800000107ea7 <sti>:
{
ffff800000107ea7:	f3 0f 1e fa          	endbr64 
ffff800000107eab:	55                   	push   %rbp
ffff800000107eac:	48 89 e5             	mov    %rsp,%rbp
  asm volatile("sti");
ffff800000107eaf:	fb                   	sti    
}
ffff800000107eb0:	90                   	nop
ffff800000107eb1:	5d                   	pop    %rbp
ffff800000107eb2:	c3                   	retq   

ffff800000107eb3 <xchg>:
{
ffff800000107eb3:	f3 0f 1e fa          	endbr64 
ffff800000107eb7:	55                   	push   %rbp
ffff800000107eb8:	48 89 e5             	mov    %rsp,%rbp
ffff800000107ebb:	48 83 ec 20          	sub    $0x20,%rsp
ffff800000107ebf:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
ffff800000107ec3:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  asm volatile("lock; xchgl %0, %1" :
ffff800000107ec7:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
ffff800000107ecb:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
ffff800000107ecf:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
ffff800000107ed3:	f0 87 02             	lock xchg %eax,(%rdx)
ffff800000107ed6:	89 45 fc             	mov    %eax,-0x4(%rbp)
  return result;
ffff800000107ed9:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
ffff800000107edc:	c9                   	leaveq 
ffff800000107edd:	c3                   	retq   

ffff800000107ede <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
ffff800000107ede:	f3 0f 1e fa          	endbr64 
ffff800000107ee2:	55                   	push   %rbp
ffff800000107ee3:	48 89 e5             	mov    %rsp,%rbp
ffff800000107ee6:	48 83 ec 10          	sub    $0x10,%rsp
ffff800000107eea:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
ffff800000107eee:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  lk->name = name;
ffff800000107ef2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000107ef6:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
ffff800000107efa:	48 89 50 08          	mov    %rdx,0x8(%rax)
  lk->locked = 0;
ffff800000107efe:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000107f02:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
  lk->cpu = 0;
ffff800000107f08:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000107f0c:	48 c7 40 10 00 00 00 	movq   $0x0,0x10(%rax)
ffff800000107f13:	00 
}
ffff800000107f14:	90                   	nop
ffff800000107f15:	c9                   	leaveq 
ffff800000107f16:	c3                   	retq   

ffff800000107f17 <acquire>:
// Loops (spins) until the lock is acquired.
// Holding a lock for a long time may cause
// other CPUs to waste time spinning to acquire it.
void
acquire(struct spinlock *lk)
{
ffff800000107f17:	f3 0f 1e fa          	endbr64 
ffff800000107f1b:	55                   	push   %rbp
ffff800000107f1c:	48 89 e5             	mov    %rsp,%rbp
ffff800000107f1f:	48 83 ec 10          	sub    $0x10,%rsp
ffff800000107f23:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  pushcli(); // disable interrupts to avoid deadlock.
ffff800000107f27:	48 b8 3f 81 10 00 00 	movabs $0xffff80000010813f,%rax
ffff800000107f2e:	80 ff ff 
ffff800000107f31:	ff d0                	callq  *%rax
  if(holding(lk))
ffff800000107f33:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000107f37:	48 89 c7             	mov    %rax,%rdi
ffff800000107f3a:	48 b8 ff 80 10 00 00 	movabs $0xffff8000001080ff,%rax
ffff800000107f41:	80 ff ff 
ffff800000107f44:	ff d0                	callq  *%rax
ffff800000107f46:	85 c0                	test   %eax,%eax
ffff800000107f48:	74 16                	je     ffff800000107f60 <acquire+0x49>
    panic("acquire");
ffff800000107f4a:	48 bf 7d cc 10 00 00 	movabs $0xffff80000010cc7d,%rdi
ffff800000107f51:	80 ff ff 
ffff800000107f54:	48 b8 f9 0b 10 00 00 	movabs $0xffff800000100bf9,%rax
ffff800000107f5b:	80 ff ff 
ffff800000107f5e:	ff d0                	callq  *%rax

  // The xchg is atomic.
  while(xchg(&lk->locked, 1) != 0)
ffff800000107f60:	90                   	nop
ffff800000107f61:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000107f65:	be 01 00 00 00       	mov    $0x1,%esi
ffff800000107f6a:	48 89 c7             	mov    %rax,%rdi
ffff800000107f6d:	48 b8 b3 7e 10 00 00 	movabs $0xffff800000107eb3,%rax
ffff800000107f74:	80 ff ff 
ffff800000107f77:	ff d0                	callq  *%rax
ffff800000107f79:	85 c0                	test   %eax,%eax
ffff800000107f7b:	75 e4                	jne    ffff800000107f61 <acquire+0x4a>
    ;

  // Tell the C compiler and the processor to not move loads or stores
  // past this point, to ensure that the critical section's memory
  // references happen after the lock is acquired.
  __sync_synchronize();
ffff800000107f7d:	0f ae f0             	mfence 

  // Record info about lock acquisition for debugging.
  lk->cpu = cpu;
ffff800000107f80:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000107f84:	48 c7 c2 f0 ff ff ff 	mov    $0xfffffffffffffff0,%rdx
ffff800000107f8b:	64 48 8b 12          	mov    %fs:(%rdx),%rdx
ffff800000107f8f:	48 89 50 10          	mov    %rdx,0x10(%rax)
  getcallerpcs(&lk, lk->pcs);
ffff800000107f93:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000107f97:	48 8d 50 18          	lea    0x18(%rax),%rdx
ffff800000107f9b:	48 8d 45 f8          	lea    -0x8(%rbp),%rax
ffff800000107f9f:	48 89 d6             	mov    %rdx,%rsi
ffff800000107fa2:	48 89 c7             	mov    %rax,%rdi
ffff800000107fa5:	48 b8 29 80 10 00 00 	movabs $0xffff800000108029,%rax
ffff800000107fac:	80 ff ff 
ffff800000107faf:	ff d0                	callq  *%rax
}
ffff800000107fb1:	90                   	nop
ffff800000107fb2:	c9                   	leaveq 
ffff800000107fb3:	c3                   	retq   

ffff800000107fb4 <release>:

// Release the lock.
void
release(struct spinlock *lk)
{
ffff800000107fb4:	f3 0f 1e fa          	endbr64 
ffff800000107fb8:	55                   	push   %rbp
ffff800000107fb9:	48 89 e5             	mov    %rsp,%rbp
ffff800000107fbc:	48 83 ec 10          	sub    $0x10,%rsp
ffff800000107fc0:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  if(!holding(lk))
ffff800000107fc4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000107fc8:	48 89 c7             	mov    %rax,%rdi
ffff800000107fcb:	48 b8 ff 80 10 00 00 	movabs $0xffff8000001080ff,%rax
ffff800000107fd2:	80 ff ff 
ffff800000107fd5:	ff d0                	callq  *%rax
ffff800000107fd7:	85 c0                	test   %eax,%eax
ffff800000107fd9:	75 16                	jne    ffff800000107ff1 <release+0x3d>
    panic("release");
ffff800000107fdb:	48 bf 85 cc 10 00 00 	movabs $0xffff80000010cc85,%rdi
ffff800000107fe2:	80 ff ff 
ffff800000107fe5:	48 b8 f9 0b 10 00 00 	movabs $0xffff800000100bf9,%rax
ffff800000107fec:	80 ff ff 
ffff800000107fef:	ff d0                	callq  *%rax

  lk->pcs[0] = 0;
ffff800000107ff1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000107ff5:	48 c7 40 18 00 00 00 	movq   $0x0,0x18(%rax)
ffff800000107ffc:	00 
  lk->cpu = 0;
ffff800000107ffd:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000108001:	48 c7 40 10 00 00 00 	movq   $0x0,0x10(%rax)
ffff800000108008:	00 
  // Tell the C compiler and the processor to not move loads or stores
  // past this point, to ensure that all the stores in the critical
  // section are visible to other cores before the lock is released.
  // Both the C compiler and the hardware may re-order loads and
  // stores; __sync_synchronize() tells them both not to.
  __sync_synchronize();
ffff800000108009:	0f ae f0             	mfence 

  // Release the lock, equivalent to lk->locked = 0.
  // This code can't use a C assignment, since it might
  // not be atomic. A real OS would use C atomics here.
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );
ffff80000010800c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000108010:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
ffff800000108014:	c7 00 00 00 00 00    	movl   $0x0,(%rax)

  popcli();
ffff80000010801a:	48 b8 b1 81 10 00 00 	movabs $0xffff8000001081b1,%rax
ffff800000108021:	80 ff ff 
ffff800000108024:	ff d0                	callq  *%rax
}
ffff800000108026:	90                   	nop
ffff800000108027:	c9                   	leaveq 
ffff800000108028:	c3                   	retq   

ffff800000108029 <getcallerpcs>:

// Record the current call stack in pcs[] by following the %rbp chain.
void
getcallerpcs(void *v, addr_t pcs[])
{
ffff800000108029:	f3 0f 1e fa          	endbr64 
ffff80000010802d:	55                   	push   %rbp
ffff80000010802e:	48 89 e5             	mov    %rsp,%rbp
ffff800000108031:	48 83 ec 20          	sub    $0x20,%rsp
ffff800000108035:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
ffff800000108039:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  addr_t *rbp;

  asm volatile("mov %%rbp, %0" : "=r" (rbp));
ffff80000010803d:	48 89 e8             	mov    %rbp,%rax
ffff800000108040:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  getstackpcs(rbp, pcs);
ffff800000108044:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
ffff800000108048:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff80000010804c:	48 89 d6             	mov    %rdx,%rsi
ffff80000010804f:	48 89 c7             	mov    %rax,%rdi
ffff800000108052:	48 b8 61 80 10 00 00 	movabs $0xffff800000108061,%rax
ffff800000108059:	80 ff ff 
ffff80000010805c:	ff d0                	callq  *%rax
}
ffff80000010805e:	90                   	nop
ffff80000010805f:	c9                   	leaveq 
ffff800000108060:	c3                   	retq   

ffff800000108061 <getstackpcs>:

void
getstackpcs(addr_t *rbp, addr_t pcs[])
{
ffff800000108061:	f3 0f 1e fa          	endbr64 
ffff800000108065:	55                   	push   %rbp
ffff800000108066:	48 89 e5             	mov    %rsp,%rbp
ffff800000108069:	48 83 ec 20          	sub    $0x20,%rsp
ffff80000010806d:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
ffff800000108071:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  int i;

  for(i = 0; i < 10; i++){
ffff800000108075:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
ffff80000010807c:	eb 50                	jmp    ffff8000001080ce <getstackpcs+0x6d>
    if(rbp == 0 || rbp < (addr_t*)KERNBASE || rbp == (addr_t*)0xffffffff)
ffff80000010807e:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
ffff800000108083:	74 70                	je     ffff8000001080f5 <getstackpcs+0x94>
ffff800000108085:	48 b8 ff ff ff ff ff 	movabs $0xffff7fffffffffff,%rax
ffff80000010808c:	7f ff ff 
ffff80000010808f:	48 39 45 e8          	cmp    %rax,-0x18(%rbp)
ffff800000108093:	76 60                	jbe    ffff8000001080f5 <getstackpcs+0x94>
ffff800000108095:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
ffff80000010809a:	48 39 45 e8          	cmp    %rax,-0x18(%rbp)
ffff80000010809e:	74 55                	je     ffff8000001080f5 <getstackpcs+0x94>
      break;
    pcs[i] = rbp[1];     // saved %rip
ffff8000001080a0:	8b 45 fc             	mov    -0x4(%rbp),%eax
ffff8000001080a3:	48 98                	cltq   
ffff8000001080a5:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
ffff8000001080ac:	00 
ffff8000001080ad:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
ffff8000001080b1:	48 01 c2             	add    %rax,%rdx
ffff8000001080b4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff8000001080b8:	48 8b 40 08          	mov    0x8(%rax),%rax
ffff8000001080bc:	48 89 02             	mov    %rax,(%rdx)
    rbp = (addr_t*)rbp[0]; // saved %rbp
ffff8000001080bf:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff8000001080c3:	48 8b 00             	mov    (%rax),%rax
ffff8000001080c6:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
  for(i = 0; i < 10; i++){
ffff8000001080ca:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
ffff8000001080ce:	83 7d fc 09          	cmpl   $0x9,-0x4(%rbp)
ffff8000001080d2:	7e aa                	jle    ffff80000010807e <getstackpcs+0x1d>
  }
  for(; i < 10; i++)
ffff8000001080d4:	eb 1f                	jmp    ffff8000001080f5 <getstackpcs+0x94>
    pcs[i] = 0;
ffff8000001080d6:	8b 45 fc             	mov    -0x4(%rbp),%eax
ffff8000001080d9:	48 98                	cltq   
ffff8000001080db:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
ffff8000001080e2:	00 
ffff8000001080e3:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
ffff8000001080e7:	48 01 d0             	add    %rdx,%rax
ffff8000001080ea:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
  for(; i < 10; i++)
ffff8000001080f1:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
ffff8000001080f5:	83 7d fc 09          	cmpl   $0x9,-0x4(%rbp)
ffff8000001080f9:	7e db                	jle    ffff8000001080d6 <getstackpcs+0x75>
}
ffff8000001080fb:	90                   	nop
ffff8000001080fc:	90                   	nop
ffff8000001080fd:	c9                   	leaveq 
ffff8000001080fe:	c3                   	retq   

ffff8000001080ff <holding>:

// Check whether this cpu is holding the lock.
int
holding(struct spinlock *lock)
{
ffff8000001080ff:	f3 0f 1e fa          	endbr64 
ffff800000108103:	55                   	push   %rbp
ffff800000108104:	48 89 e5             	mov    %rsp,%rbp
ffff800000108107:	48 83 ec 08          	sub    $0x8,%rsp
ffff80000010810b:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  return lock->locked && lock->cpu == cpu;
ffff80000010810f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000108113:	8b 00                	mov    (%rax),%eax
ffff800000108115:	85 c0                	test   %eax,%eax
ffff800000108117:	74 1f                	je     ffff800000108138 <holding+0x39>
ffff800000108119:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff80000010811d:	48 8b 50 10          	mov    0x10(%rax),%rdx
ffff800000108121:	48 c7 c0 f0 ff ff ff 	mov    $0xfffffffffffffff0,%rax
ffff800000108128:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffff80000010812c:	48 39 c2             	cmp    %rax,%rdx
ffff80000010812f:	75 07                	jne    ffff800000108138 <holding+0x39>
ffff800000108131:	b8 01 00 00 00       	mov    $0x1,%eax
ffff800000108136:	eb 05                	jmp    ffff80000010813d <holding+0x3e>
ffff800000108138:	b8 00 00 00 00       	mov    $0x0,%eax
}
ffff80000010813d:	c9                   	leaveq 
ffff80000010813e:	c3                   	retq   

ffff80000010813f <pushcli>:
// Pushcli/popcli are like cli/sti except that they are matched:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.
void
pushcli(void)
{
ffff80000010813f:	f3 0f 1e fa          	endbr64 
ffff800000108143:	55                   	push   %rbp
ffff800000108144:	48 89 e5             	mov    %rsp,%rbp
ffff800000108147:	48 83 ec 10          	sub    $0x10,%rsp
  int eflags;

  eflags = readeflags();
ffff80000010814b:	48 b8 83 7e 10 00 00 	movabs $0xffff800000107e83,%rax
ffff800000108152:	80 ff ff 
ffff800000108155:	ff d0                	callq  *%rax
ffff800000108157:	89 45 fc             	mov    %eax,-0x4(%rbp)
  cli();
ffff80000010815a:	48 b8 9b 7e 10 00 00 	movabs $0xffff800000107e9b,%rax
ffff800000108161:	80 ff ff 
ffff800000108164:	ff d0                	callq  *%rax
  if(cpu->ncli == 0)
ffff800000108166:	48 c7 c0 f0 ff ff ff 	mov    $0xfffffffffffffff0,%rax
ffff80000010816d:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffff800000108171:	8b 40 14             	mov    0x14(%rax),%eax
ffff800000108174:	85 c0                	test   %eax,%eax
ffff800000108176:	75 17                	jne    ffff80000010818f <pushcli+0x50>
    cpu->intena = eflags & FL_IF;
ffff800000108178:	48 c7 c0 f0 ff ff ff 	mov    $0xfffffffffffffff0,%rax
ffff80000010817f:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffff800000108183:	8b 55 fc             	mov    -0x4(%rbp),%edx
ffff800000108186:	81 e2 00 02 00 00    	and    $0x200,%edx
ffff80000010818c:	89 50 18             	mov    %edx,0x18(%rax)
  cpu->ncli += 1;
ffff80000010818f:	48 c7 c0 f0 ff ff ff 	mov    $0xfffffffffffffff0,%rax
ffff800000108196:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffff80000010819a:	8b 50 14             	mov    0x14(%rax),%edx
ffff80000010819d:	48 c7 c0 f0 ff ff ff 	mov    $0xfffffffffffffff0,%rax
ffff8000001081a4:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffff8000001081a8:	83 c2 01             	add    $0x1,%edx
ffff8000001081ab:	89 50 14             	mov    %edx,0x14(%rax)
}
ffff8000001081ae:	90                   	nop
ffff8000001081af:	c9                   	leaveq 
ffff8000001081b0:	c3                   	retq   

ffff8000001081b1 <popcli>:

void
popcli(void)
{
ffff8000001081b1:	f3 0f 1e fa          	endbr64 
ffff8000001081b5:	55                   	push   %rbp
ffff8000001081b6:	48 89 e5             	mov    %rsp,%rbp
  if(readeflags()&FL_IF)
ffff8000001081b9:	48 b8 83 7e 10 00 00 	movabs $0xffff800000107e83,%rax
ffff8000001081c0:	80 ff ff 
ffff8000001081c3:	ff d0                	callq  *%rax
ffff8000001081c5:	25 00 02 00 00       	and    $0x200,%eax
ffff8000001081ca:	48 85 c0             	test   %rax,%rax
ffff8000001081cd:	74 16                	je     ffff8000001081e5 <popcli+0x34>
    panic("popcli - interruptible");
ffff8000001081cf:	48 bf 8d cc 10 00 00 	movabs $0xffff80000010cc8d,%rdi
ffff8000001081d6:	80 ff ff 
ffff8000001081d9:	48 b8 f9 0b 10 00 00 	movabs $0xffff800000100bf9,%rax
ffff8000001081e0:	80 ff ff 
ffff8000001081e3:	ff d0                	callq  *%rax
  if(--cpu->ncli < 0)
ffff8000001081e5:	48 c7 c0 f0 ff ff ff 	mov    $0xfffffffffffffff0,%rax
ffff8000001081ec:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffff8000001081f0:	8b 50 14             	mov    0x14(%rax),%edx
ffff8000001081f3:	83 ea 01             	sub    $0x1,%edx
ffff8000001081f6:	89 50 14             	mov    %edx,0x14(%rax)
ffff8000001081f9:	8b 40 14             	mov    0x14(%rax),%eax
ffff8000001081fc:	85 c0                	test   %eax,%eax
ffff8000001081fe:	79 16                	jns    ffff800000108216 <popcli+0x65>
    panic("popcli");
ffff800000108200:	48 bf a4 cc 10 00 00 	movabs $0xffff80000010cca4,%rdi
ffff800000108207:	80 ff ff 
ffff80000010820a:	48 b8 f9 0b 10 00 00 	movabs $0xffff800000100bf9,%rax
ffff800000108211:	80 ff ff 
ffff800000108214:	ff d0                	callq  *%rax
  if(cpu->ncli == 0 && cpu->intena)
ffff800000108216:	48 c7 c0 f0 ff ff ff 	mov    $0xfffffffffffffff0,%rax
ffff80000010821d:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffff800000108221:	8b 40 14             	mov    0x14(%rax),%eax
ffff800000108224:	85 c0                	test   %eax,%eax
ffff800000108226:	75 1e                	jne    ffff800000108246 <popcli+0x95>
ffff800000108228:	48 c7 c0 f0 ff ff ff 	mov    $0xfffffffffffffff0,%rax
ffff80000010822f:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffff800000108233:	8b 40 18             	mov    0x18(%rax),%eax
ffff800000108236:	85 c0                	test   %eax,%eax
ffff800000108238:	74 0c                	je     ffff800000108246 <popcli+0x95>
    sti();
ffff80000010823a:	48 b8 a7 7e 10 00 00 	movabs $0xffff800000107ea7,%rax
ffff800000108241:	80 ff ff 
ffff800000108244:	ff d0                	callq  *%rax
}
ffff800000108246:	90                   	nop
ffff800000108247:	5d                   	pop    %rbp
ffff800000108248:	c3                   	retq   

ffff800000108249 <stosb>:
{
ffff800000108249:	f3 0f 1e fa          	endbr64 
ffff80000010824d:	55                   	push   %rbp
ffff80000010824e:	48 89 e5             	mov    %rsp,%rbp
ffff800000108251:	48 83 ec 10          	sub    $0x10,%rsp
ffff800000108255:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
ffff800000108259:	89 75 f4             	mov    %esi,-0xc(%rbp)
ffff80000010825c:	89 55 f0             	mov    %edx,-0x10(%rbp)
  asm volatile("cld; rep stosb" :
ffff80000010825f:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
ffff800000108263:	8b 55 f0             	mov    -0x10(%rbp),%edx
ffff800000108266:	8b 45 f4             	mov    -0xc(%rbp),%eax
ffff800000108269:	48 89 ce             	mov    %rcx,%rsi
ffff80000010826c:	48 89 f7             	mov    %rsi,%rdi
ffff80000010826f:	89 d1                	mov    %edx,%ecx
ffff800000108271:	fc                   	cld    
ffff800000108272:	f3 aa                	rep stos %al,%es:(%rdi)
ffff800000108274:	89 ca                	mov    %ecx,%edx
ffff800000108276:	48 89 fe             	mov    %rdi,%rsi
ffff800000108279:	48 89 75 f8          	mov    %rsi,-0x8(%rbp)
ffff80000010827d:	89 55 f0             	mov    %edx,-0x10(%rbp)
}
ffff800000108280:	90                   	nop
ffff800000108281:	c9                   	leaveq 
ffff800000108282:	c3                   	retq   

ffff800000108283 <stosl>:
{
ffff800000108283:	f3 0f 1e fa          	endbr64 
ffff800000108287:	55                   	push   %rbp
ffff800000108288:	48 89 e5             	mov    %rsp,%rbp
ffff80000010828b:	48 83 ec 10          	sub    $0x10,%rsp
ffff80000010828f:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
ffff800000108293:	89 75 f4             	mov    %esi,-0xc(%rbp)
ffff800000108296:	89 55 f0             	mov    %edx,-0x10(%rbp)
  asm volatile("cld; rep stosl" :
ffff800000108299:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
ffff80000010829d:	8b 55 f0             	mov    -0x10(%rbp),%edx
ffff8000001082a0:	8b 45 f4             	mov    -0xc(%rbp),%eax
ffff8000001082a3:	48 89 ce             	mov    %rcx,%rsi
ffff8000001082a6:	48 89 f7             	mov    %rsi,%rdi
ffff8000001082a9:	89 d1                	mov    %edx,%ecx
ffff8000001082ab:	fc                   	cld    
ffff8000001082ac:	f3 ab                	rep stos %eax,%es:(%rdi)
ffff8000001082ae:	89 ca                	mov    %ecx,%edx
ffff8000001082b0:	48 89 fe             	mov    %rdi,%rsi
ffff8000001082b3:	48 89 75 f8          	mov    %rsi,-0x8(%rbp)
ffff8000001082b7:	89 55 f0             	mov    %edx,-0x10(%rbp)
}
ffff8000001082ba:	90                   	nop
ffff8000001082bb:	c9                   	leaveq 
ffff8000001082bc:	c3                   	retq   

ffff8000001082bd <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint64 n)
{
ffff8000001082bd:	f3 0f 1e fa          	endbr64 
ffff8000001082c1:	55                   	push   %rbp
ffff8000001082c2:	48 89 e5             	mov    %rsp,%rbp
ffff8000001082c5:	48 83 ec 18          	sub    $0x18,%rsp
ffff8000001082c9:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
ffff8000001082cd:	89 75 f4             	mov    %esi,-0xc(%rbp)
ffff8000001082d0:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  if ((addr_t)dst%4 == 0 && n%4 == 0){
ffff8000001082d4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff8000001082d8:	83 e0 03             	and    $0x3,%eax
ffff8000001082db:	48 85 c0             	test   %rax,%rax
ffff8000001082de:	75 53                	jne    ffff800000108333 <memset+0x76>
ffff8000001082e0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff8000001082e4:	83 e0 03             	and    $0x3,%eax
ffff8000001082e7:	48 85 c0             	test   %rax,%rax
ffff8000001082ea:	75 47                	jne    ffff800000108333 <memset+0x76>
    c &= 0xFF;
ffff8000001082ec:	81 65 f4 ff 00 00 00 	andl   $0xff,-0xc(%rbp)
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
ffff8000001082f3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff8000001082f7:	48 c1 e8 02          	shr    $0x2,%rax
ffff8000001082fb:	89 c6                	mov    %eax,%esi
ffff8000001082fd:	8b 45 f4             	mov    -0xc(%rbp),%eax
ffff800000108300:	c1 e0 18             	shl    $0x18,%eax
ffff800000108303:	89 c2                	mov    %eax,%edx
ffff800000108305:	8b 45 f4             	mov    -0xc(%rbp),%eax
ffff800000108308:	c1 e0 10             	shl    $0x10,%eax
ffff80000010830b:	09 c2                	or     %eax,%edx
ffff80000010830d:	8b 45 f4             	mov    -0xc(%rbp),%eax
ffff800000108310:	c1 e0 08             	shl    $0x8,%eax
ffff800000108313:	09 d0                	or     %edx,%eax
ffff800000108315:	0b 45 f4             	or     -0xc(%rbp),%eax
ffff800000108318:	89 c1                	mov    %eax,%ecx
ffff80000010831a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff80000010831e:	89 f2                	mov    %esi,%edx
ffff800000108320:	89 ce                	mov    %ecx,%esi
ffff800000108322:	48 89 c7             	mov    %rax,%rdi
ffff800000108325:	48 b8 83 82 10 00 00 	movabs $0xffff800000108283,%rax
ffff80000010832c:	80 ff ff 
ffff80000010832f:	ff d0                	callq  *%rax
ffff800000108331:	eb 1e                	jmp    ffff800000108351 <memset+0x94>
  } else
    stosb(dst, c, n);
ffff800000108333:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000108337:	89 c2                	mov    %eax,%edx
ffff800000108339:	8b 4d f4             	mov    -0xc(%rbp),%ecx
ffff80000010833c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000108340:	89 ce                	mov    %ecx,%esi
ffff800000108342:	48 89 c7             	mov    %rax,%rdi
ffff800000108345:	48 b8 49 82 10 00 00 	movabs $0xffff800000108249,%rax
ffff80000010834c:	80 ff ff 
ffff80000010834f:	ff d0                	callq  *%rax
  return dst;
ffff800000108351:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
ffff800000108355:	c9                   	leaveq 
ffff800000108356:	c3                   	retq   

ffff800000108357 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
ffff800000108357:	f3 0f 1e fa          	endbr64 
ffff80000010835b:	55                   	push   %rbp
ffff80000010835c:	48 89 e5             	mov    %rsp,%rbp
ffff80000010835f:	48 83 ec 28          	sub    $0x28,%rsp
ffff800000108363:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
ffff800000108367:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
ffff80000010836b:	89 55 dc             	mov    %edx,-0x24(%rbp)
  const uchar *s1, *s2;

  s1 = v1;
ffff80000010836e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000108372:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  s2 = v2;
ffff800000108376:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
ffff80000010837a:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
  while(n-- > 0){
ffff80000010837e:	eb 36                	jmp    ffff8000001083b6 <memcmp+0x5f>
    if(*s1 != *s2)
ffff800000108380:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000108384:	0f b6 10             	movzbl (%rax),%edx
ffff800000108387:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff80000010838b:	0f b6 00             	movzbl (%rax),%eax
ffff80000010838e:	38 c2                	cmp    %al,%dl
ffff800000108390:	74 1a                	je     ffff8000001083ac <memcmp+0x55>
      return *s1 - *s2;
ffff800000108392:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000108396:	0f b6 00             	movzbl (%rax),%eax
ffff800000108399:	0f b6 d0             	movzbl %al,%edx
ffff80000010839c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff8000001083a0:	0f b6 00             	movzbl (%rax),%eax
ffff8000001083a3:	0f b6 c0             	movzbl %al,%eax
ffff8000001083a6:	29 c2                	sub    %eax,%edx
ffff8000001083a8:	89 d0                	mov    %edx,%eax
ffff8000001083aa:	eb 1c                	jmp    ffff8000001083c8 <memcmp+0x71>
    s1++, s2++;
ffff8000001083ac:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
ffff8000001083b1:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
  while(n-- > 0){
ffff8000001083b6:	8b 45 dc             	mov    -0x24(%rbp),%eax
ffff8000001083b9:	8d 50 ff             	lea    -0x1(%rax),%edx
ffff8000001083bc:	89 55 dc             	mov    %edx,-0x24(%rbp)
ffff8000001083bf:	85 c0                	test   %eax,%eax
ffff8000001083c1:	75 bd                	jne    ffff800000108380 <memcmp+0x29>
  }

  return 0;
ffff8000001083c3:	b8 00 00 00 00       	mov    $0x0,%eax
}
ffff8000001083c8:	c9                   	leaveq 
ffff8000001083c9:	c3                   	retq   

ffff8000001083ca <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
ffff8000001083ca:	f3 0f 1e fa          	endbr64 
ffff8000001083ce:	55                   	push   %rbp
ffff8000001083cf:	48 89 e5             	mov    %rsp,%rbp
ffff8000001083d2:	48 83 ec 28          	sub    $0x28,%rsp
ffff8000001083d6:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
ffff8000001083da:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
ffff8000001083de:	89 55 dc             	mov    %edx,-0x24(%rbp)
  const char *s;
  char *d;

  s = src;
ffff8000001083e1:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
ffff8000001083e5:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  d = dst;
ffff8000001083e9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff8000001083ed:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
  if(s < d && s + n > d){
ffff8000001083f1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff8000001083f5:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
ffff8000001083f9:	73 63                	jae    ffff80000010845e <memmove+0x94>
ffff8000001083fb:	8b 55 dc             	mov    -0x24(%rbp),%edx
ffff8000001083fe:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000108402:	48 01 d0             	add    %rdx,%rax
ffff800000108405:	48 39 45 f0          	cmp    %rax,-0x10(%rbp)
ffff800000108409:	73 53                	jae    ffff80000010845e <memmove+0x94>
    s += n;
ffff80000010840b:	8b 45 dc             	mov    -0x24(%rbp),%eax
ffff80000010840e:	48 01 45 f8          	add    %rax,-0x8(%rbp)
    d += n;
ffff800000108412:	8b 45 dc             	mov    -0x24(%rbp),%eax
ffff800000108415:	48 01 45 f0          	add    %rax,-0x10(%rbp)
    while(n-- > 0)
ffff800000108419:	eb 17                	jmp    ffff800000108432 <memmove+0x68>
      *--d = *--s;
ffff80000010841b:	48 83 6d f8 01       	subq   $0x1,-0x8(%rbp)
ffff800000108420:	48 83 6d f0 01       	subq   $0x1,-0x10(%rbp)
ffff800000108425:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000108429:	0f b6 10             	movzbl (%rax),%edx
ffff80000010842c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff800000108430:	88 10                	mov    %dl,(%rax)
    while(n-- > 0)
ffff800000108432:	8b 45 dc             	mov    -0x24(%rbp),%eax
ffff800000108435:	8d 50 ff             	lea    -0x1(%rax),%edx
ffff800000108438:	89 55 dc             	mov    %edx,-0x24(%rbp)
ffff80000010843b:	85 c0                	test   %eax,%eax
ffff80000010843d:	75 dc                	jne    ffff80000010841b <memmove+0x51>
  if(s < d && s + n > d){
ffff80000010843f:	eb 2a                	jmp    ffff80000010846b <memmove+0xa1>
  } else
    while(n-- > 0)
      *d++ = *s++;
ffff800000108441:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
ffff800000108445:	48 8d 42 01          	lea    0x1(%rdx),%rax
ffff800000108449:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
ffff80000010844d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff800000108451:	48 8d 48 01          	lea    0x1(%rax),%rcx
ffff800000108455:	48 89 4d f0          	mov    %rcx,-0x10(%rbp)
ffff800000108459:	0f b6 12             	movzbl (%rdx),%edx
ffff80000010845c:	88 10                	mov    %dl,(%rax)
    while(n-- > 0)
ffff80000010845e:	8b 45 dc             	mov    -0x24(%rbp),%eax
ffff800000108461:	8d 50 ff             	lea    -0x1(%rax),%edx
ffff800000108464:	89 55 dc             	mov    %edx,-0x24(%rbp)
ffff800000108467:	85 c0                	test   %eax,%eax
ffff800000108469:	75 d6                	jne    ffff800000108441 <memmove+0x77>

  return dst;
ffff80000010846b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
ffff80000010846f:	c9                   	leaveq 
ffff800000108470:	c3                   	retq   

ffff800000108471 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
ffff800000108471:	f3 0f 1e fa          	endbr64 
ffff800000108475:	55                   	push   %rbp
ffff800000108476:	48 89 e5             	mov    %rsp,%rbp
ffff800000108479:	48 83 ec 18          	sub    $0x18,%rsp
ffff80000010847d:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
ffff800000108481:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
ffff800000108485:	89 55 ec             	mov    %edx,-0x14(%rbp)
  return memmove(dst, src, n);
ffff800000108488:	8b 55 ec             	mov    -0x14(%rbp),%edx
ffff80000010848b:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
ffff80000010848f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000108493:	48 89 ce             	mov    %rcx,%rsi
ffff800000108496:	48 89 c7             	mov    %rax,%rdi
ffff800000108499:	48 b8 ca 83 10 00 00 	movabs $0xffff8000001083ca,%rax
ffff8000001084a0:	80 ff ff 
ffff8000001084a3:	ff d0                	callq  *%rax
}
ffff8000001084a5:	c9                   	leaveq 
ffff8000001084a6:	c3                   	retq   

ffff8000001084a7 <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
ffff8000001084a7:	f3 0f 1e fa          	endbr64 
ffff8000001084ab:	55                   	push   %rbp
ffff8000001084ac:	48 89 e5             	mov    %rsp,%rbp
ffff8000001084af:	48 83 ec 18          	sub    $0x18,%rsp
ffff8000001084b3:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
ffff8000001084b7:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
ffff8000001084bb:	89 55 ec             	mov    %edx,-0x14(%rbp)
  while(n > 0 && *p && *p == *q)
ffff8000001084be:	eb 0e                	jmp    ffff8000001084ce <strncmp+0x27>
    n--, p++, q++;
ffff8000001084c0:	83 6d ec 01          	subl   $0x1,-0x14(%rbp)
ffff8000001084c4:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
ffff8000001084c9:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
  while(n > 0 && *p && *p == *q)
ffff8000001084ce:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
ffff8000001084d2:	74 1d                	je     ffff8000001084f1 <strncmp+0x4a>
ffff8000001084d4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff8000001084d8:	0f b6 00             	movzbl (%rax),%eax
ffff8000001084db:	84 c0                	test   %al,%al
ffff8000001084dd:	74 12                	je     ffff8000001084f1 <strncmp+0x4a>
ffff8000001084df:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff8000001084e3:	0f b6 10             	movzbl (%rax),%edx
ffff8000001084e6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff8000001084ea:	0f b6 00             	movzbl (%rax),%eax
ffff8000001084ed:	38 c2                	cmp    %al,%dl
ffff8000001084ef:	74 cf                	je     ffff8000001084c0 <strncmp+0x19>
  if(n == 0)
ffff8000001084f1:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
ffff8000001084f5:	75 07                	jne    ffff8000001084fe <strncmp+0x57>
    return 0;
ffff8000001084f7:	b8 00 00 00 00       	mov    $0x0,%eax
ffff8000001084fc:	eb 18                	jmp    ffff800000108516 <strncmp+0x6f>
  return (uchar)*p - (uchar)*q;
ffff8000001084fe:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000108502:	0f b6 00             	movzbl (%rax),%eax
ffff800000108505:	0f b6 d0             	movzbl %al,%edx
ffff800000108508:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff80000010850c:	0f b6 00             	movzbl (%rax),%eax
ffff80000010850f:	0f b6 c0             	movzbl %al,%eax
ffff800000108512:	29 c2                	sub    %eax,%edx
ffff800000108514:	89 d0                	mov    %edx,%eax
}
ffff800000108516:	c9                   	leaveq 
ffff800000108517:	c3                   	retq   

ffff800000108518 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
ffff800000108518:	f3 0f 1e fa          	endbr64 
ffff80000010851c:	55                   	push   %rbp
ffff80000010851d:	48 89 e5             	mov    %rsp,%rbp
ffff800000108520:	48 83 ec 28          	sub    $0x28,%rsp
ffff800000108524:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
ffff800000108528:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
ffff80000010852c:	89 55 dc             	mov    %edx,-0x24(%rbp)
  char *os = s;
ffff80000010852f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000108533:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  while(n-- > 0 && (*s++ = *t++) != 0)
ffff800000108537:	90                   	nop
ffff800000108538:	8b 45 dc             	mov    -0x24(%rbp),%eax
ffff80000010853b:	8d 50 ff             	lea    -0x1(%rax),%edx
ffff80000010853e:	89 55 dc             	mov    %edx,-0x24(%rbp)
ffff800000108541:	85 c0                	test   %eax,%eax
ffff800000108543:	7e 35                	jle    ffff80000010857a <strncpy+0x62>
ffff800000108545:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
ffff800000108549:	48 8d 42 01          	lea    0x1(%rdx),%rax
ffff80000010854d:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
ffff800000108551:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000108555:	48 8d 48 01          	lea    0x1(%rax),%rcx
ffff800000108559:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
ffff80000010855d:	0f b6 12             	movzbl (%rdx),%edx
ffff800000108560:	88 10                	mov    %dl,(%rax)
ffff800000108562:	0f b6 00             	movzbl (%rax),%eax
ffff800000108565:	84 c0                	test   %al,%al
ffff800000108567:	75 cf                	jne    ffff800000108538 <strncpy+0x20>
    ;
  while(n-- > 0)
ffff800000108569:	eb 0f                	jmp    ffff80000010857a <strncpy+0x62>
    *s++ = 0;
ffff80000010856b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff80000010856f:	48 8d 50 01          	lea    0x1(%rax),%rdx
ffff800000108573:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
ffff800000108577:	c6 00 00             	movb   $0x0,(%rax)
  while(n-- > 0)
ffff80000010857a:	8b 45 dc             	mov    -0x24(%rbp),%eax
ffff80000010857d:	8d 50 ff             	lea    -0x1(%rax),%edx
ffff800000108580:	89 55 dc             	mov    %edx,-0x24(%rbp)
ffff800000108583:	85 c0                	test   %eax,%eax
ffff800000108585:	7f e4                	jg     ffff80000010856b <strncpy+0x53>
  return os;
ffff800000108587:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
ffff80000010858b:	c9                   	leaveq 
ffff80000010858c:	c3                   	retq   

ffff80000010858d <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
ffff80000010858d:	f3 0f 1e fa          	endbr64 
ffff800000108591:	55                   	push   %rbp
ffff800000108592:	48 89 e5             	mov    %rsp,%rbp
ffff800000108595:	48 83 ec 28          	sub    $0x28,%rsp
ffff800000108599:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
ffff80000010859d:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
ffff8000001085a1:	89 55 dc             	mov    %edx,-0x24(%rbp)
  char *os = s;
ffff8000001085a4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff8000001085a8:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  if(n <= 0)
ffff8000001085ac:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
ffff8000001085b0:	7f 06                	jg     ffff8000001085b8 <safestrcpy+0x2b>
    return os;
ffff8000001085b2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff8000001085b6:	eb 39                	jmp    ffff8000001085f1 <safestrcpy+0x64>
  while(--n > 0 && (*s++ = *t++) != 0)
ffff8000001085b8:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
ffff8000001085bc:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
ffff8000001085c0:	7e 24                	jle    ffff8000001085e6 <safestrcpy+0x59>
ffff8000001085c2:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
ffff8000001085c6:	48 8d 42 01          	lea    0x1(%rdx),%rax
ffff8000001085ca:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
ffff8000001085ce:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff8000001085d2:	48 8d 48 01          	lea    0x1(%rax),%rcx
ffff8000001085d6:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
ffff8000001085da:	0f b6 12             	movzbl (%rdx),%edx
ffff8000001085dd:	88 10                	mov    %dl,(%rax)
ffff8000001085df:	0f b6 00             	movzbl (%rax),%eax
ffff8000001085e2:	84 c0                	test   %al,%al
ffff8000001085e4:	75 d2                	jne    ffff8000001085b8 <safestrcpy+0x2b>
    ;
  *s = 0;
ffff8000001085e6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff8000001085ea:	c6 00 00             	movb   $0x0,(%rax)
  return os;
ffff8000001085ed:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
ffff8000001085f1:	c9                   	leaveq 
ffff8000001085f2:	c3                   	retq   

ffff8000001085f3 <strlen>:

int
strlen(const char *s)
{
ffff8000001085f3:	f3 0f 1e fa          	endbr64 
ffff8000001085f7:	55                   	push   %rbp
ffff8000001085f8:	48 89 e5             	mov    %rsp,%rbp
ffff8000001085fb:	48 83 ec 18          	sub    $0x18,%rsp
ffff8000001085ff:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  int n;

  for(n = 0; s[n]; n++)
ffff800000108603:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
ffff80000010860a:	eb 04                	jmp    ffff800000108610 <strlen+0x1d>
ffff80000010860c:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
ffff800000108610:	8b 45 fc             	mov    -0x4(%rbp),%eax
ffff800000108613:	48 63 d0             	movslq %eax,%rdx
ffff800000108616:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff80000010861a:	48 01 d0             	add    %rdx,%rax
ffff80000010861d:	0f b6 00             	movzbl (%rax),%eax
ffff800000108620:	84 c0                	test   %al,%al
ffff800000108622:	75 e8                	jne    ffff80000010860c <strlen+0x19>
    ;
  return n;
ffff800000108624:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
ffff800000108627:	c9                   	leaveq 
ffff800000108628:	c3                   	retq   

ffff800000108629 <swtch>:
# and then load register context from new.

.global swtch
swtch:
  # Save old callee-save registers
  pushq   %rbp
ffff800000108629:	55                   	push   %rbp
  pushq   %rbx
ffff80000010862a:	53                   	push   %rbx
  pushq   %r12
ffff80000010862b:	41 54                	push   %r12
  pushq   %r13
ffff80000010862d:	41 55                	push   %r13
  pushq   %r14
ffff80000010862f:	41 56                	push   %r14
  pushq   %r15
ffff800000108631:	41 57                	push   %r15

  # Switch stacks
  movq    %rsp, (%rdi)
ffff800000108633:	48 89 27             	mov    %rsp,(%rdi)
  movq    %rsi, %rsp
ffff800000108636:	48 89 f4             	mov    %rsi,%rsp

  # Load new callee-save registers
  popq    %r15
ffff800000108639:	41 5f                	pop    %r15
  popq    %r14
ffff80000010863b:	41 5e                	pop    %r14
  popq    %r13
ffff80000010863d:	41 5d                	pop    %r13
  popq    %r12
ffff80000010863f:	41 5c                	pop    %r12
  popq    %rbx
ffff800000108641:	5b                   	pop    %rbx
  popq    %rbp
ffff800000108642:	5d                   	pop    %rbp

  retq #??
ffff800000108643:	c3                   	retq   

ffff800000108644 <fetchint>:
#include "syscall.h"

// Fetch the int at addr from the current process.
int
fetchint(addr_t addr, int *ip)
{
ffff800000108644:	f3 0f 1e fa          	endbr64 
ffff800000108648:	55                   	push   %rbp
ffff800000108649:	48 89 e5             	mov    %rsp,%rbp
ffff80000010864c:	48 83 ec 10          	sub    $0x10,%rsp
ffff800000108650:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
ffff800000108654:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  if(addr >= proc->sz || addr+sizeof(int) > proc->sz)
ffff800000108658:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffff80000010865f:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffff800000108663:	48 8b 00             	mov    (%rax),%rax
ffff800000108666:	48 39 45 f8          	cmp    %rax,-0x8(%rbp)
ffff80000010866a:	73 1b                	jae    ffff800000108687 <fetchint+0x43>
ffff80000010866c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000108670:	48 8d 50 04          	lea    0x4(%rax),%rdx
ffff800000108674:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffff80000010867b:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffff80000010867f:	48 8b 00             	mov    (%rax),%rax
ffff800000108682:	48 39 c2             	cmp    %rax,%rdx
ffff800000108685:	76 07                	jbe    ffff80000010868e <fetchint+0x4a>
    return -1;
ffff800000108687:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
ffff80000010868c:	eb 11                	jmp    ffff80000010869f <fetchint+0x5b>
  *ip = *(int*)(addr);
ffff80000010868e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000108692:	8b 10                	mov    (%rax),%edx
ffff800000108694:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff800000108698:	89 10                	mov    %edx,(%rax)
  return 0;
ffff80000010869a:	b8 00 00 00 00       	mov    $0x0,%eax
}
ffff80000010869f:	c9                   	leaveq 
ffff8000001086a0:	c3                   	retq   

ffff8000001086a1 <fetchaddr>:

int
fetchaddr(addr_t addr, addr_t *ip)
{
ffff8000001086a1:	f3 0f 1e fa          	endbr64 
ffff8000001086a5:	55                   	push   %rbp
ffff8000001086a6:	48 89 e5             	mov    %rsp,%rbp
ffff8000001086a9:	48 83 ec 10          	sub    $0x10,%rsp
ffff8000001086ad:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
ffff8000001086b1:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  if(addr >= proc->sz || addr+sizeof(addr_t) > proc->sz)
ffff8000001086b5:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffff8000001086bc:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffff8000001086c0:	48 8b 00             	mov    (%rax),%rax
ffff8000001086c3:	48 39 45 f8          	cmp    %rax,-0x8(%rbp)
ffff8000001086c7:	73 1b                	jae    ffff8000001086e4 <fetchaddr+0x43>
ffff8000001086c9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff8000001086cd:	48 8d 50 08          	lea    0x8(%rax),%rdx
ffff8000001086d1:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffff8000001086d8:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffff8000001086dc:	48 8b 00             	mov    (%rax),%rax
ffff8000001086df:	48 39 c2             	cmp    %rax,%rdx
ffff8000001086e2:	76 07                	jbe    ffff8000001086eb <fetchaddr+0x4a>
    return -1;
ffff8000001086e4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
ffff8000001086e9:	eb 13                	jmp    ffff8000001086fe <fetchaddr+0x5d>
  *ip = *(addr_t*)(addr);
ffff8000001086eb:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff8000001086ef:	48 8b 10             	mov    (%rax),%rdx
ffff8000001086f2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff8000001086f6:	48 89 10             	mov    %rdx,(%rax)
  return 0;
ffff8000001086f9:	b8 00 00 00 00       	mov    $0x0,%eax
}
ffff8000001086fe:	c9                   	leaveq 
ffff8000001086ff:	c3                   	retq   

ffff800000108700 <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(addr_t addr, char **pp)
{
ffff800000108700:	f3 0f 1e fa          	endbr64 
ffff800000108704:	55                   	push   %rbp
ffff800000108705:	48 89 e5             	mov    %rsp,%rbp
ffff800000108708:	48 83 ec 20          	sub    $0x20,%rsp
ffff80000010870c:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
ffff800000108710:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  char *s, *ep;

  if(addr >= proc->sz)
ffff800000108714:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffff80000010871b:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffff80000010871f:	48 8b 00             	mov    (%rax),%rax
ffff800000108722:	48 39 45 e8          	cmp    %rax,-0x18(%rbp)
ffff800000108726:	72 07                	jb     ffff80000010872f <fetchstr+0x2f>
    return -1;
ffff800000108728:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
ffff80000010872d:	eb 5c                	jmp    ffff80000010878b <fetchstr+0x8b>
  *pp = (char*)addr;
ffff80000010872f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
ffff800000108733:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
ffff800000108737:	48 89 10             	mov    %rdx,(%rax)
  ep = (char*)proc->sz;
ffff80000010873a:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffff800000108741:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffff800000108745:	48 8b 00             	mov    (%rax),%rax
ffff800000108748:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
  for(s = *pp; s < ep; s++)
ffff80000010874c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
ffff800000108750:	48 8b 00             	mov    (%rax),%rax
ffff800000108753:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
ffff800000108757:	eb 23                	jmp    ffff80000010877c <fetchstr+0x7c>
    if(*s == 0)
ffff800000108759:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff80000010875d:	0f b6 00             	movzbl (%rax),%eax
ffff800000108760:	84 c0                	test   %al,%al
ffff800000108762:	75 13                	jne    ffff800000108777 <fetchstr+0x77>
      return s - *pp;
ffff800000108764:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
ffff800000108768:	48 8b 00             	mov    (%rax),%rax
ffff80000010876b:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
ffff80000010876f:	48 29 c2             	sub    %rax,%rdx
ffff800000108772:	48 89 d0             	mov    %rdx,%rax
ffff800000108775:	eb 14                	jmp    ffff80000010878b <fetchstr+0x8b>
  for(s = *pp; s < ep; s++)
ffff800000108777:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
ffff80000010877c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000108780:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
ffff800000108784:	72 d3                	jb     ffff800000108759 <fetchstr+0x59>
  return -1;
ffff800000108786:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
ffff80000010878b:	c9                   	leaveq 
ffff80000010878c:	c3                   	retq   

ffff80000010878d <fetcharg>:

static addr_t
fetcharg(int n)
{
ffff80000010878d:	f3 0f 1e fa          	endbr64 
ffff800000108791:	55                   	push   %rbp
ffff800000108792:	48 89 e5             	mov    %rsp,%rbp
ffff800000108795:	48 83 ec 10          	sub    $0x10,%rsp
ffff800000108799:	89 7d fc             	mov    %edi,-0x4(%rbp)
ffff80000010879c:	83 7d fc 05          	cmpl   $0x5,-0x4(%rbp)
ffff8000001087a0:	0f 87 9c 00 00 00    	ja     ffff800000108842 <fetcharg+0xb5>
ffff8000001087a6:	8b 45 fc             	mov    -0x4(%rbp),%eax
ffff8000001087a9:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
ffff8000001087b0:	00 
ffff8000001087b1:	48 b8 c0 cc 10 00 00 	movabs $0xffff80000010ccc0,%rax
ffff8000001087b8:	80 ff ff 
ffff8000001087bb:	48 01 d0             	add    %rdx,%rax
ffff8000001087be:	48 8b 00             	mov    (%rax),%rax
ffff8000001087c1:	3e ff e0             	notrack jmpq *%rax
  switch (n) {
  case 0: return proc->tf->rdi;
ffff8000001087c4:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffff8000001087cb:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffff8000001087cf:	48 8b 40 28          	mov    0x28(%rax),%rax
ffff8000001087d3:	48 8b 40 30          	mov    0x30(%rax),%rax
ffff8000001087d7:	eb 7f                	jmp    ffff800000108858 <fetcharg+0xcb>
  case 1: return proc->tf->rsi;
ffff8000001087d9:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffff8000001087e0:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffff8000001087e4:	48 8b 40 28          	mov    0x28(%rax),%rax
ffff8000001087e8:	48 8b 40 28          	mov    0x28(%rax),%rax
ffff8000001087ec:	eb 6a                	jmp    ffff800000108858 <fetcharg+0xcb>
  case 2: return proc->tf->rdx;
ffff8000001087ee:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffff8000001087f5:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffff8000001087f9:	48 8b 40 28          	mov    0x28(%rax),%rax
ffff8000001087fd:	48 8b 40 18          	mov    0x18(%rax),%rax
ffff800000108801:	eb 55                	jmp    ffff800000108858 <fetcharg+0xcb>
  case 3: return proc->tf->r10;
ffff800000108803:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffff80000010880a:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffff80000010880e:	48 8b 40 28          	mov    0x28(%rax),%rax
ffff800000108812:	48 8b 40 48          	mov    0x48(%rax),%rax
ffff800000108816:	eb 40                	jmp    ffff800000108858 <fetcharg+0xcb>
  case 4: return proc->tf->r8;
ffff800000108818:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffff80000010881f:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffff800000108823:	48 8b 40 28          	mov    0x28(%rax),%rax
ffff800000108827:	48 8b 40 38          	mov    0x38(%rax),%rax
ffff80000010882b:	eb 2b                	jmp    ffff800000108858 <fetcharg+0xcb>
  case 5: return proc->tf->r9;
ffff80000010882d:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffff800000108834:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffff800000108838:	48 8b 40 28          	mov    0x28(%rax),%rax
ffff80000010883c:	48 8b 40 40          	mov    0x40(%rax),%rax
ffff800000108840:	eb 16                	jmp    ffff800000108858 <fetcharg+0xcb>
  }
  panic("failed fetch");
ffff800000108842:	48 bf b0 cc 10 00 00 	movabs $0xffff80000010ccb0,%rdi
ffff800000108849:	80 ff ff 
ffff80000010884c:	48 b8 f9 0b 10 00 00 	movabs $0xffff800000100bf9,%rax
ffff800000108853:	80 ff ff 
ffff800000108856:	ff d0                	callq  *%rax
}
ffff800000108858:	c9                   	leaveq 
ffff800000108859:	c3                   	retq   

ffff80000010885a <argint>:

int
argint(int n, int *ip)
{
ffff80000010885a:	f3 0f 1e fa          	endbr64 
ffff80000010885e:	55                   	push   %rbp
ffff80000010885f:	48 89 e5             	mov    %rsp,%rbp
ffff800000108862:	48 83 ec 10          	sub    $0x10,%rsp
ffff800000108866:	89 7d fc             	mov    %edi,-0x4(%rbp)
ffff800000108869:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  *ip = fetcharg(n);
ffff80000010886d:	8b 45 fc             	mov    -0x4(%rbp),%eax
ffff800000108870:	89 c7                	mov    %eax,%edi
ffff800000108872:	48 b8 8d 87 10 00 00 	movabs $0xffff80000010878d,%rax
ffff800000108879:	80 ff ff 
ffff80000010887c:	ff d0                	callq  *%rax
ffff80000010887e:	89 c2                	mov    %eax,%edx
ffff800000108880:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff800000108884:	89 10                	mov    %edx,(%rax)
  return 0;
ffff800000108886:	b8 00 00 00 00       	mov    $0x0,%eax
}
ffff80000010888b:	c9                   	leaveq 
ffff80000010888c:	c3                   	retq   

ffff80000010888d <argaddr>:

int
argaddr(int n, addr_t *ip)
{
ffff80000010888d:	f3 0f 1e fa          	endbr64 
ffff800000108891:	55                   	push   %rbp
ffff800000108892:	48 89 e5             	mov    %rsp,%rbp
ffff800000108895:	48 83 ec 10          	sub    $0x10,%rsp
ffff800000108899:	89 7d fc             	mov    %edi,-0x4(%rbp)
ffff80000010889c:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  *ip = fetcharg(n);
ffff8000001088a0:	8b 45 fc             	mov    -0x4(%rbp),%eax
ffff8000001088a3:	89 c7                	mov    %eax,%edi
ffff8000001088a5:	48 b8 8d 87 10 00 00 	movabs $0xffff80000010878d,%rax
ffff8000001088ac:	80 ff ff 
ffff8000001088af:	ff d0                	callq  *%rax
ffff8000001088b1:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
ffff8000001088b5:	48 89 02             	mov    %rax,(%rdx)
  return 0;
ffff8000001088b8:	b8 00 00 00 00       	mov    $0x0,%eax
}
ffff8000001088bd:	c9                   	leaveq 
ffff8000001088be:	c3                   	retq   

ffff8000001088bf <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
ffff8000001088bf:	f3 0f 1e fa          	endbr64 
ffff8000001088c3:	55                   	push   %rbp
ffff8000001088c4:	48 89 e5             	mov    %rsp,%rbp
ffff8000001088c7:	48 83 ec 20          	sub    $0x20,%rsp
ffff8000001088cb:	89 7d ec             	mov    %edi,-0x14(%rbp)
ffff8000001088ce:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
ffff8000001088d2:	89 55 e8             	mov    %edx,-0x18(%rbp)
  addr_t i;

  if(argaddr(n, &i) < 0)
ffff8000001088d5:	48 8d 55 f8          	lea    -0x8(%rbp),%rdx
ffff8000001088d9:	8b 45 ec             	mov    -0x14(%rbp),%eax
ffff8000001088dc:	48 89 d6             	mov    %rdx,%rsi
ffff8000001088df:	89 c7                	mov    %eax,%edi
ffff8000001088e1:	48 b8 8d 88 10 00 00 	movabs $0xffff80000010888d,%rax
ffff8000001088e8:	80 ff ff 
ffff8000001088eb:	ff d0                	callq  *%rax
ffff8000001088ed:	85 c0                	test   %eax,%eax
ffff8000001088ef:	79 07                	jns    ffff8000001088f8 <argptr+0x39>
    return -1;
ffff8000001088f1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
ffff8000001088f6:	eb 59                	jmp    ffff800000108951 <argptr+0x92>
  if(size < 0 || (uint)i >= proc->sz || (uint)i+size > proc->sz)
ffff8000001088f8:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
ffff8000001088fc:	78 39                	js     ffff800000108937 <argptr+0x78>
ffff8000001088fe:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000108902:	89 c2                	mov    %eax,%edx
ffff800000108904:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffff80000010890b:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffff80000010890f:	48 8b 00             	mov    (%rax),%rax
ffff800000108912:	48 39 c2             	cmp    %rax,%rdx
ffff800000108915:	73 20                	jae    ffff800000108937 <argptr+0x78>
ffff800000108917:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff80000010891b:	89 c2                	mov    %eax,%edx
ffff80000010891d:	8b 45 e8             	mov    -0x18(%rbp),%eax
ffff800000108920:	01 d0                	add    %edx,%eax
ffff800000108922:	89 c2                	mov    %eax,%edx
ffff800000108924:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffff80000010892b:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffff80000010892f:	48 8b 00             	mov    (%rax),%rax
ffff800000108932:	48 39 c2             	cmp    %rax,%rdx
ffff800000108935:	76 07                	jbe    ffff80000010893e <argptr+0x7f>
    return -1;
ffff800000108937:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
ffff80000010893c:	eb 13                	jmp    ffff800000108951 <argptr+0x92>
  *pp = (char*)i;
ffff80000010893e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000108942:	48 89 c2             	mov    %rax,%rdx
ffff800000108945:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
ffff800000108949:	48 89 10             	mov    %rdx,(%rax)
  return 0;
ffff80000010894c:	b8 00 00 00 00       	mov    $0x0,%eax
}
ffff800000108951:	c9                   	leaveq 
ffff800000108952:	c3                   	retq   

ffff800000108953 <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
ffff800000108953:	f3 0f 1e fa          	endbr64 
ffff800000108957:	55                   	push   %rbp
ffff800000108958:	48 89 e5             	mov    %rsp,%rbp
ffff80000010895b:	48 83 ec 20          	sub    $0x20,%rsp
ffff80000010895f:	89 7d ec             	mov    %edi,-0x14(%rbp)
ffff800000108962:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  int addr;
  if(argint(n, &addr) < 0)
ffff800000108966:	48 8d 55 fc          	lea    -0x4(%rbp),%rdx
ffff80000010896a:	8b 45 ec             	mov    -0x14(%rbp),%eax
ffff80000010896d:	48 89 d6             	mov    %rdx,%rsi
ffff800000108970:	89 c7                	mov    %eax,%edi
ffff800000108972:	48 b8 5a 88 10 00 00 	movabs $0xffff80000010885a,%rax
ffff800000108979:	80 ff ff 
ffff80000010897c:	ff d0                	callq  *%rax
ffff80000010897e:	85 c0                	test   %eax,%eax
ffff800000108980:	79 07                	jns    ffff800000108989 <argstr+0x36>
    return -1;
ffff800000108982:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
ffff800000108987:	eb 1b                	jmp    ffff8000001089a4 <argstr+0x51>
  return fetchstr(addr, pp);
ffff800000108989:	8b 45 fc             	mov    -0x4(%rbp),%eax
ffff80000010898c:	48 98                	cltq   
ffff80000010898e:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
ffff800000108992:	48 89 d6             	mov    %rdx,%rsi
ffff800000108995:	48 89 c7             	mov    %rax,%rdi
ffff800000108998:	48 b8 00 87 10 00 00 	movabs $0xffff800000108700,%rax
ffff80000010899f:	80 ff ff 
ffff8000001089a2:	ff d0                	callq  *%rax
}
ffff8000001089a4:	c9                   	leaveq 
ffff8000001089a5:	c3                   	retq   

ffff8000001089a6 <syscall>:
[SYS_aread]   sys_aread,
};

void
syscall(struct trapframe *tf)
{
ffff8000001089a6:	f3 0f 1e fa          	endbr64 
ffff8000001089aa:	55                   	push   %rbp
ffff8000001089ab:	48 89 e5             	mov    %rsp,%rbp
ffff8000001089ae:	48 83 ec 20          	sub    $0x20,%rsp
ffff8000001089b2:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  if (proc->killed)
ffff8000001089b6:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffff8000001089bd:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffff8000001089c1:	8b 40 40             	mov    0x40(%rax),%eax
ffff8000001089c4:	85 c0                	test   %eax,%eax
ffff8000001089c6:	74 0c                	je     ffff8000001089d4 <syscall+0x2e>
    exit();
ffff8000001089c8:	48 b8 bb 68 10 00 00 	movabs $0xffff8000001068bb,%rax
ffff8000001089cf:	80 ff ff 
ffff8000001089d2:	ff d0                	callq  *%rax
  proc->tf = tf;
ffff8000001089d4:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffff8000001089db:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffff8000001089df:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
ffff8000001089e3:	48 89 50 28          	mov    %rdx,0x28(%rax)
  uint64 num = proc->tf->rax;
ffff8000001089e7:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffff8000001089ee:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffff8000001089f2:	48 8b 40 28          	mov    0x28(%rax),%rax
ffff8000001089f6:	48 8b 00             	mov    (%rax),%rax
ffff8000001089f9:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  if (num > 0 && num < NELEM(syscalls) && syscalls[num]) {
ffff8000001089fd:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
ffff800000108a02:	74 3b                	je     ffff800000108a3f <syscall+0x99>
ffff800000108a04:	48 83 7d f8 16       	cmpq   $0x16,-0x8(%rbp)
ffff800000108a09:	77 34                	ja     ffff800000108a3f <syscall+0x99>
ffff800000108a0b:	48 ba a0 d5 10 00 00 	movabs $0xffff80000010d5a0,%rdx
ffff800000108a12:	80 ff ff 
ffff800000108a15:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000108a19:	48 8b 04 c2          	mov    (%rdx,%rax,8),%rax
ffff800000108a1d:	48 85 c0             	test   %rax,%rax
ffff800000108a20:	74 1d                	je     ffff800000108a3f <syscall+0x99>
    tf->rax = syscalls[num]();
ffff800000108a22:	48 ba a0 d5 10 00 00 	movabs $0xffff80000010d5a0,%rdx
ffff800000108a29:	80 ff ff 
ffff800000108a2c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000108a30:	48 8b 04 c2          	mov    (%rdx,%rax,8),%rax
ffff800000108a34:	ff d0                	callq  *%rax
ffff800000108a36:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
ffff800000108a3a:	48 89 02             	mov    %rax,(%rdx)
ffff800000108a3d:	eb 53                	jmp    ffff800000108a92 <syscall+0xec>
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            proc->pid, proc->name, num);
ffff800000108a3f:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffff800000108a46:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffff800000108a4a:	48 8d b0 d4 00 00 00 	lea    0xd4(%rax),%rsi
ffff800000108a51:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffff800000108a58:	64 48 8b 00          	mov    %fs:(%rax),%rax
    cprintf("%d %s: unknown sys call %d\n",
ffff800000108a5c:	8b 40 1c             	mov    0x1c(%rax),%eax
ffff800000108a5f:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
ffff800000108a63:	48 89 d1             	mov    %rdx,%rcx
ffff800000108a66:	48 89 f2             	mov    %rsi,%rdx
ffff800000108a69:	89 c6                	mov    %eax,%esi
ffff800000108a6b:	48 bf f0 cc 10 00 00 	movabs $0xffff80000010ccf0,%rdi
ffff800000108a72:	80 ff ff 
ffff800000108a75:	b8 00 00 00 00       	mov    $0x0,%eax
ffff800000108a7a:	49 b8 18 08 10 00 00 	movabs $0xffff800000100818,%r8
ffff800000108a81:	80 ff ff 
ffff800000108a84:	41 ff d0             	callq  *%r8
    tf->rax = -1;
ffff800000108a87:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000108a8b:	48 c7 00 ff ff ff ff 	movq   $0xffffffffffffffff,(%rax)
  }
  if (proc->killed)
ffff800000108a92:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffff800000108a99:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffff800000108a9d:	8b 40 40             	mov    0x40(%rax),%eax
ffff800000108aa0:	85 c0                	test   %eax,%eax
ffff800000108aa2:	74 0c                	je     ffff800000108ab0 <syscall+0x10a>
    exit();
ffff800000108aa4:	48 b8 bb 68 10 00 00 	movabs $0xffff8000001068bb,%rax
ffff800000108aab:	80 ff ff 
ffff800000108aae:	ff d0                	callq  *%rax
}
ffff800000108ab0:	90                   	nop
ffff800000108ab1:	c9                   	leaveq 
ffff800000108ab2:	c3                   	retq   

ffff800000108ab3 <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
int
argfd(int n, int *pfd, struct file **pf)
{
ffff800000108ab3:	f3 0f 1e fa          	endbr64 
ffff800000108ab7:	55                   	push   %rbp
ffff800000108ab8:	48 89 e5             	mov    %rsp,%rbp
ffff800000108abb:	48 83 ec 30          	sub    $0x30,%rsp
ffff800000108abf:	89 7d ec             	mov    %edi,-0x14(%rbp)
ffff800000108ac2:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
ffff800000108ac6:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
ffff800000108aca:	48 8d 55 f4          	lea    -0xc(%rbp),%rdx
ffff800000108ace:	8b 45 ec             	mov    -0x14(%rbp),%eax
ffff800000108ad1:	48 89 d6             	mov    %rdx,%rsi
ffff800000108ad4:	89 c7                	mov    %eax,%edi
ffff800000108ad6:	48 b8 5a 88 10 00 00 	movabs $0xffff80000010885a,%rax
ffff800000108add:	80 ff ff 
ffff800000108ae0:	ff d0                	callq  *%rax
ffff800000108ae2:	85 c0                	test   %eax,%eax
ffff800000108ae4:	79 07                	jns    ffff800000108aed <argfd+0x3a>
    return -1;
ffff800000108ae6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
ffff800000108aeb:	eb 62                	jmp    ffff800000108b4f <argfd+0x9c>
  if(fd < 0 || fd >= NOFILE || (f=proc->ofile[fd]) == 0)
ffff800000108aed:	8b 45 f4             	mov    -0xc(%rbp),%eax
ffff800000108af0:	85 c0                	test   %eax,%eax
ffff800000108af2:	78 2d                	js     ffff800000108b21 <argfd+0x6e>
ffff800000108af4:	8b 45 f4             	mov    -0xc(%rbp),%eax
ffff800000108af7:	83 f8 0f             	cmp    $0xf,%eax
ffff800000108afa:	7f 25                	jg     ffff800000108b21 <argfd+0x6e>
ffff800000108afc:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffff800000108b03:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffff800000108b07:	8b 55 f4             	mov    -0xc(%rbp),%edx
ffff800000108b0a:	48 63 d2             	movslq %edx,%rdx
ffff800000108b0d:	48 83 c2 08          	add    $0x8,%rdx
ffff800000108b11:	48 8b 44 d0 08       	mov    0x8(%rax,%rdx,8),%rax
ffff800000108b16:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
ffff800000108b1a:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
ffff800000108b1f:	75 07                	jne    ffff800000108b28 <argfd+0x75>
    return -1;
ffff800000108b21:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
ffff800000108b26:	eb 27                	jmp    ffff800000108b4f <argfd+0x9c>
  if(pfd)
ffff800000108b28:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
ffff800000108b2d:	74 09                	je     ffff800000108b38 <argfd+0x85>
    *pfd = fd;
ffff800000108b2f:	8b 55 f4             	mov    -0xc(%rbp),%edx
ffff800000108b32:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
ffff800000108b36:	89 10                	mov    %edx,(%rax)
  if(pf)
ffff800000108b38:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
ffff800000108b3d:	74 0b                	je     ffff800000108b4a <argfd+0x97>
    *pf = f;
ffff800000108b3f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
ffff800000108b43:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
ffff800000108b47:	48 89 10             	mov    %rdx,(%rax)
  return 0;
ffff800000108b4a:	b8 00 00 00 00       	mov    $0x0,%eax
}
ffff800000108b4f:	c9                   	leaveq 
ffff800000108b50:	c3                   	retq   

ffff800000108b51 <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
ffff800000108b51:	f3 0f 1e fa          	endbr64 
ffff800000108b55:	55                   	push   %rbp
ffff800000108b56:	48 89 e5             	mov    %rsp,%rbp
ffff800000108b59:	48 83 ec 18          	sub    $0x18,%rsp
ffff800000108b5d:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  int fd;

  for(fd = 0; fd < NOFILE; fd++){
ffff800000108b61:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
ffff800000108b68:	eb 46                	jmp    ffff800000108bb0 <fdalloc+0x5f>
    if(proc->ofile[fd] == 0){
ffff800000108b6a:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffff800000108b71:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffff800000108b75:	8b 55 fc             	mov    -0x4(%rbp),%edx
ffff800000108b78:	48 63 d2             	movslq %edx,%rdx
ffff800000108b7b:	48 83 c2 08          	add    $0x8,%rdx
ffff800000108b7f:	48 8b 44 d0 08       	mov    0x8(%rax,%rdx,8),%rax
ffff800000108b84:	48 85 c0             	test   %rax,%rax
ffff800000108b87:	75 23                	jne    ffff800000108bac <fdalloc+0x5b>
      proc->ofile[fd] = f;
ffff800000108b89:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffff800000108b90:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffff800000108b94:	8b 55 fc             	mov    -0x4(%rbp),%edx
ffff800000108b97:	48 63 d2             	movslq %edx,%rdx
ffff800000108b9a:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
ffff800000108b9e:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
ffff800000108ba2:	48 89 54 c8 08       	mov    %rdx,0x8(%rax,%rcx,8)
      return fd;
ffff800000108ba7:	8b 45 fc             	mov    -0x4(%rbp),%eax
ffff800000108baa:	eb 0f                	jmp    ffff800000108bbb <fdalloc+0x6a>
  for(fd = 0; fd < NOFILE; fd++){
ffff800000108bac:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
ffff800000108bb0:	83 7d fc 0f          	cmpl   $0xf,-0x4(%rbp)
ffff800000108bb4:	7e b4                	jle    ffff800000108b6a <fdalloc+0x19>
    }
  }
  return -1;
ffff800000108bb6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
ffff800000108bbb:	c9                   	leaveq 
ffff800000108bbc:	c3                   	retq   

ffff800000108bbd <sys_dup>:

int
sys_dup(void)
{
ffff800000108bbd:	f3 0f 1e fa          	endbr64 
ffff800000108bc1:	55                   	push   %rbp
ffff800000108bc2:	48 89 e5             	mov    %rsp,%rbp
ffff800000108bc5:	48 83 ec 10          	sub    $0x10,%rsp
  struct file *f;
  int fd;

  if(argfd(0, 0, &f) < 0)
ffff800000108bc9:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
ffff800000108bcd:	48 89 c2             	mov    %rax,%rdx
ffff800000108bd0:	be 00 00 00 00       	mov    $0x0,%esi
ffff800000108bd5:	bf 00 00 00 00       	mov    $0x0,%edi
ffff800000108bda:	48 b8 b3 8a 10 00 00 	movabs $0xffff800000108ab3,%rax
ffff800000108be1:	80 ff ff 
ffff800000108be4:	ff d0                	callq  *%rax
ffff800000108be6:	85 c0                	test   %eax,%eax
ffff800000108be8:	79 07                	jns    ffff800000108bf1 <sys_dup+0x34>
    return -1;
ffff800000108bea:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
ffff800000108bef:	eb 39                	jmp    ffff800000108c2a <sys_dup+0x6d>
  if((fd=fdalloc(f)) < 0)
ffff800000108bf1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff800000108bf5:	48 89 c7             	mov    %rax,%rdi
ffff800000108bf8:	48 b8 51 8b 10 00 00 	movabs $0xffff800000108b51,%rax
ffff800000108bff:	80 ff ff 
ffff800000108c02:	ff d0                	callq  *%rax
ffff800000108c04:	89 45 fc             	mov    %eax,-0x4(%rbp)
ffff800000108c07:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
ffff800000108c0b:	79 07                	jns    ffff800000108c14 <sys_dup+0x57>
    return -1;
ffff800000108c0d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
ffff800000108c12:	eb 16                	jmp    ffff800000108c2a <sys_dup+0x6d>
  filedup(f);
ffff800000108c14:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff800000108c18:	48 89 c7             	mov    %rax,%rdi
ffff800000108c1b:	48 b8 1a 1c 10 00 00 	movabs $0xffff800000101c1a,%rax
ffff800000108c22:	80 ff ff 
ffff800000108c25:	ff d0                	callq  *%rax
  return fd;
ffff800000108c27:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
ffff800000108c2a:	c9                   	leaveq 
ffff800000108c2b:	c3                   	retq   

ffff800000108c2c <sys_read>:

int
sys_read(void)
{
ffff800000108c2c:	f3 0f 1e fa          	endbr64 
ffff800000108c30:	55                   	push   %rbp
ffff800000108c31:	48 89 e5             	mov    %rsp,%rbp
ffff800000108c34:	48 83 ec 20          	sub    $0x20,%rsp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
ffff800000108c38:	48 8d 45 f8          	lea    -0x8(%rbp),%rax
ffff800000108c3c:	48 89 c2             	mov    %rax,%rdx
ffff800000108c3f:	be 00 00 00 00       	mov    $0x0,%esi
ffff800000108c44:	bf 00 00 00 00       	mov    $0x0,%edi
ffff800000108c49:	48 b8 b3 8a 10 00 00 	movabs $0xffff800000108ab3,%rax
ffff800000108c50:	80 ff ff 
ffff800000108c53:	ff d0                	callq  *%rax
ffff800000108c55:	85 c0                	test   %eax,%eax
ffff800000108c57:	78 3b                	js     ffff800000108c94 <sys_read+0x68>
ffff800000108c59:	48 8d 45 f4          	lea    -0xc(%rbp),%rax
ffff800000108c5d:	48 89 c6             	mov    %rax,%rsi
ffff800000108c60:	bf 02 00 00 00       	mov    $0x2,%edi
ffff800000108c65:	48 b8 5a 88 10 00 00 	movabs $0xffff80000010885a,%rax
ffff800000108c6c:	80 ff ff 
ffff800000108c6f:	ff d0                	callq  *%rax
ffff800000108c71:	85 c0                	test   %eax,%eax
ffff800000108c73:	78 1f                	js     ffff800000108c94 <sys_read+0x68>
ffff800000108c75:	8b 55 f4             	mov    -0xc(%rbp),%edx
ffff800000108c78:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
ffff800000108c7c:	48 89 c6             	mov    %rax,%rsi
ffff800000108c7f:	bf 01 00 00 00       	mov    $0x1,%edi
ffff800000108c84:	48 b8 bf 88 10 00 00 	movabs $0xffff8000001088bf,%rax
ffff800000108c8b:	80 ff ff 
ffff800000108c8e:	ff d0                	callq  *%rax
ffff800000108c90:	85 c0                	test   %eax,%eax
ffff800000108c92:	79 07                	jns    ffff800000108c9b <sys_read+0x6f>
    return -1;
ffff800000108c94:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
ffff800000108c99:	eb 1d                	jmp    ffff800000108cb8 <sys_read+0x8c>
  return fileread(f, p, n);
ffff800000108c9b:	8b 55 f4             	mov    -0xc(%rbp),%edx
ffff800000108c9e:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
ffff800000108ca2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000108ca6:	48 89 ce             	mov    %rcx,%rsi
ffff800000108ca9:	48 89 c7             	mov    %rax,%rdi
ffff800000108cac:	48 b8 46 1e 10 00 00 	movabs $0xffff800000101e46,%rax
ffff800000108cb3:	80 ff ff 
ffff800000108cb6:	ff d0                	callq  *%rax
}
ffff800000108cb8:	c9                   	leaveq 
ffff800000108cb9:	c3                   	retq   

ffff800000108cba <sys_write>:

int
sys_write(void)
{
ffff800000108cba:	f3 0f 1e fa          	endbr64 
ffff800000108cbe:	55                   	push   %rbp
ffff800000108cbf:	48 89 e5             	mov    %rsp,%rbp
ffff800000108cc2:	48 83 ec 20          	sub    $0x20,%rsp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
ffff800000108cc6:	48 8d 45 f8          	lea    -0x8(%rbp),%rax
ffff800000108cca:	48 89 c2             	mov    %rax,%rdx
ffff800000108ccd:	be 00 00 00 00       	mov    $0x0,%esi
ffff800000108cd2:	bf 00 00 00 00       	mov    $0x0,%edi
ffff800000108cd7:	48 b8 b3 8a 10 00 00 	movabs $0xffff800000108ab3,%rax
ffff800000108cde:	80 ff ff 
ffff800000108ce1:	ff d0                	callq  *%rax
ffff800000108ce3:	85 c0                	test   %eax,%eax
ffff800000108ce5:	78 3b                	js     ffff800000108d22 <sys_write+0x68>
ffff800000108ce7:	48 8d 45 f4          	lea    -0xc(%rbp),%rax
ffff800000108ceb:	48 89 c6             	mov    %rax,%rsi
ffff800000108cee:	bf 02 00 00 00       	mov    $0x2,%edi
ffff800000108cf3:	48 b8 5a 88 10 00 00 	movabs $0xffff80000010885a,%rax
ffff800000108cfa:	80 ff ff 
ffff800000108cfd:	ff d0                	callq  *%rax
ffff800000108cff:	85 c0                	test   %eax,%eax
ffff800000108d01:	78 1f                	js     ffff800000108d22 <sys_write+0x68>
ffff800000108d03:	8b 55 f4             	mov    -0xc(%rbp),%edx
ffff800000108d06:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
ffff800000108d0a:	48 89 c6             	mov    %rax,%rsi
ffff800000108d0d:	bf 01 00 00 00       	mov    $0x1,%edi
ffff800000108d12:	48 b8 bf 88 10 00 00 	movabs $0xffff8000001088bf,%rax
ffff800000108d19:	80 ff ff 
ffff800000108d1c:	ff d0                	callq  *%rax
ffff800000108d1e:	85 c0                	test   %eax,%eax
ffff800000108d20:	79 07                	jns    ffff800000108d29 <sys_write+0x6f>
    return -1;
ffff800000108d22:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
ffff800000108d27:	eb 1d                	jmp    ffff800000108d46 <sys_write+0x8c>
  return filewrite(f, p, n);
ffff800000108d29:	8b 55 f4             	mov    -0xc(%rbp),%edx
ffff800000108d2c:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
ffff800000108d30:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000108d34:	48 89 ce             	mov    %rcx,%rsi
ffff800000108d37:	48 89 c7             	mov    %rax,%rdi
ffff800000108d3a:	48 b8 3b 1f 10 00 00 	movabs $0xffff800000101f3b,%rax
ffff800000108d41:	80 ff ff 
ffff800000108d44:	ff d0                	callq  *%rax
}
ffff800000108d46:	c9                   	leaveq 
ffff800000108d47:	c3                   	retq   

ffff800000108d48 <sys_close>:

int
sys_close(void)
{
ffff800000108d48:	f3 0f 1e fa          	endbr64 
ffff800000108d4c:	55                   	push   %rbp
ffff800000108d4d:	48 89 e5             	mov    %rsp,%rbp
ffff800000108d50:	48 83 ec 10          	sub    $0x10,%rsp
  int fd;
  struct file *f;

  if(argfd(0, &fd, &f) < 0)
ffff800000108d54:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
ffff800000108d58:	48 8d 45 fc          	lea    -0x4(%rbp),%rax
ffff800000108d5c:	48 89 c6             	mov    %rax,%rsi
ffff800000108d5f:	bf 00 00 00 00       	mov    $0x0,%edi
ffff800000108d64:	48 b8 b3 8a 10 00 00 	movabs $0xffff800000108ab3,%rax
ffff800000108d6b:	80 ff ff 
ffff800000108d6e:	ff d0                	callq  *%rax
ffff800000108d70:	85 c0                	test   %eax,%eax
ffff800000108d72:	79 07                	jns    ffff800000108d7b <sys_close+0x33>
    return -1;
ffff800000108d74:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
ffff800000108d79:	eb 36                	jmp    ffff800000108db1 <sys_close+0x69>
  proc->ofile[fd] = 0;
ffff800000108d7b:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffff800000108d82:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffff800000108d86:	8b 55 fc             	mov    -0x4(%rbp),%edx
ffff800000108d89:	48 63 d2             	movslq %edx,%rdx
ffff800000108d8c:	48 83 c2 08          	add    $0x8,%rdx
ffff800000108d90:	48 c7 44 d0 08 00 00 	movq   $0x0,0x8(%rax,%rdx,8)
ffff800000108d97:	00 00 
  fileclose(f);
ffff800000108d99:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff800000108d9d:	48 89 c7             	mov    %rax,%rdi
ffff800000108da0:	48 b8 8e 1c 10 00 00 	movabs $0xffff800000101c8e,%rax
ffff800000108da7:	80 ff ff 
ffff800000108daa:	ff d0                	callq  *%rax
  return 0;
ffff800000108dac:	b8 00 00 00 00       	mov    $0x0,%eax
}
ffff800000108db1:	c9                   	leaveq 
ffff800000108db2:	c3                   	retq   

ffff800000108db3 <sys_fstat>:

int
sys_fstat(void)
{
ffff800000108db3:	f3 0f 1e fa          	endbr64 
ffff800000108db7:	55                   	push   %rbp
ffff800000108db8:	48 89 e5             	mov    %rsp,%rbp
ffff800000108dbb:	48 83 ec 10          	sub    $0x10,%rsp
  struct file *f;
  struct stat *st;

  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
ffff800000108dbf:	48 8d 45 f8          	lea    -0x8(%rbp),%rax
ffff800000108dc3:	48 89 c2             	mov    %rax,%rdx
ffff800000108dc6:	be 00 00 00 00       	mov    $0x0,%esi
ffff800000108dcb:	bf 00 00 00 00       	mov    $0x0,%edi
ffff800000108dd0:	48 b8 b3 8a 10 00 00 	movabs $0xffff800000108ab3,%rax
ffff800000108dd7:	80 ff ff 
ffff800000108dda:	ff d0                	callq  *%rax
ffff800000108ddc:	85 c0                	test   %eax,%eax
ffff800000108dde:	78 21                	js     ffff800000108e01 <sys_fstat+0x4e>
ffff800000108de0:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
ffff800000108de4:	ba 14 00 00 00       	mov    $0x14,%edx
ffff800000108de9:	48 89 c6             	mov    %rax,%rsi
ffff800000108dec:	bf 01 00 00 00       	mov    $0x1,%edi
ffff800000108df1:	48 b8 bf 88 10 00 00 	movabs $0xffff8000001088bf,%rax
ffff800000108df8:	80 ff ff 
ffff800000108dfb:	ff d0                	callq  *%rax
ffff800000108dfd:	85 c0                	test   %eax,%eax
ffff800000108dff:	79 07                	jns    ffff800000108e08 <sys_fstat+0x55>
    return -1;
ffff800000108e01:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
ffff800000108e06:	eb 1a                	jmp    ffff800000108e22 <sys_fstat+0x6f>
  return filestat(f, st);
ffff800000108e08:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
ffff800000108e0c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000108e10:	48 89 d6             	mov    %rdx,%rsi
ffff800000108e13:	48 89 c7             	mov    %rax,%rdi
ffff800000108e16:	48 b8 cd 1d 10 00 00 	movabs $0xffff800000101dcd,%rax
ffff800000108e1d:	80 ff ff 
ffff800000108e20:	ff d0                	callq  *%rax
}
ffff800000108e22:	c9                   	leaveq 
ffff800000108e23:	c3                   	retq   

ffff800000108e24 <isdirempty>:

static int
isdirempty(struct inode *dp)
{
ffff800000108e24:	f3 0f 1e fa          	endbr64 
ffff800000108e28:	55                   	push   %rbp
ffff800000108e29:	48 89 e5             	mov    %rsp,%rbp
ffff800000108e2c:	48 83 ec 30          	sub    $0x30,%rsp
ffff800000108e30:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  int off;
  struct dirent de;
  // Is the directory dp empty except for "." and ".." ?
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
ffff800000108e34:	c7 45 fc 20 00 00 00 	movl   $0x20,-0x4(%rbp)
ffff800000108e3b:	eb 53                	jmp    ffff800000108e90 <isdirempty+0x6c>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
ffff800000108e3d:	8b 55 fc             	mov    -0x4(%rbp),%edx
ffff800000108e40:	48 8d 75 e0          	lea    -0x20(%rbp),%rsi
ffff800000108e44:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
ffff800000108e48:	b9 10 00 00 00       	mov    $0x10,%ecx
ffff800000108e4d:	48 89 c7             	mov    %rax,%rdi
ffff800000108e50:	48 b8 51 2f 10 00 00 	movabs $0xffff800000102f51,%rax
ffff800000108e57:	80 ff ff 
ffff800000108e5a:	ff d0                	callq  *%rax
ffff800000108e5c:	83 f8 10             	cmp    $0x10,%eax
ffff800000108e5f:	74 16                	je     ffff800000108e77 <isdirempty+0x53>
      panic("isdirempty: readi");
ffff800000108e61:	48 bf 0c cd 10 00 00 	movabs $0xffff80000010cd0c,%rdi
ffff800000108e68:	80 ff ff 
ffff800000108e6b:	48 b8 f9 0b 10 00 00 	movabs $0xffff800000100bf9,%rax
ffff800000108e72:	80 ff ff 
ffff800000108e75:	ff d0                	callq  *%rax
    if(de.inum != 0)
ffff800000108e77:	0f b7 45 e0          	movzwl -0x20(%rbp),%eax
ffff800000108e7b:	66 85 c0             	test   %ax,%ax
ffff800000108e7e:	74 07                	je     ffff800000108e87 <isdirempty+0x63>
      return 0;
ffff800000108e80:	b8 00 00 00 00       	mov    $0x0,%eax
ffff800000108e85:	eb 1f                	jmp    ffff800000108ea6 <isdirempty+0x82>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
ffff800000108e87:	8b 45 fc             	mov    -0x4(%rbp),%eax
ffff800000108e8a:	83 c0 10             	add    $0x10,%eax
ffff800000108e8d:	89 45 fc             	mov    %eax,-0x4(%rbp)
ffff800000108e90:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
ffff800000108e94:	8b 90 9c 00 00 00    	mov    0x9c(%rax),%edx
ffff800000108e9a:	8b 45 fc             	mov    -0x4(%rbp),%eax
ffff800000108e9d:	39 c2                	cmp    %eax,%edx
ffff800000108e9f:	77 9c                	ja     ffff800000108e3d <isdirempty+0x19>
  }
  return 1;
ffff800000108ea1:	b8 01 00 00 00       	mov    $0x1,%eax
}
ffff800000108ea6:	c9                   	leaveq 
ffff800000108ea7:	c3                   	retq   

ffff800000108ea8 <sys_link>:

// Create the path new as a link to the same inode as old.
int
sys_link(void)
{
ffff800000108ea8:	f3 0f 1e fa          	endbr64 
ffff800000108eac:	55                   	push   %rbp
ffff800000108ead:	48 89 e5             	mov    %rsp,%rbp
ffff800000108eb0:	48 83 ec 30          	sub    $0x30,%rsp
  char name[DIRSIZ], *new, *old;
  struct inode *dp, *ip;

  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
ffff800000108eb4:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
ffff800000108eb8:	48 89 c6             	mov    %rax,%rsi
ffff800000108ebb:	bf 00 00 00 00       	mov    $0x0,%edi
ffff800000108ec0:	48 b8 53 89 10 00 00 	movabs $0xffff800000108953,%rax
ffff800000108ec7:	80 ff ff 
ffff800000108eca:	ff d0                	callq  *%rax
ffff800000108ecc:	85 c0                	test   %eax,%eax
ffff800000108ece:	78 1c                	js     ffff800000108eec <sys_link+0x44>
ffff800000108ed0:	48 8d 45 d8          	lea    -0x28(%rbp),%rax
ffff800000108ed4:	48 89 c6             	mov    %rax,%rsi
ffff800000108ed7:	bf 01 00 00 00       	mov    $0x1,%edi
ffff800000108edc:	48 b8 53 89 10 00 00 	movabs $0xffff800000108953,%rax
ffff800000108ee3:	80 ff ff 
ffff800000108ee6:	ff d0                	callq  *%rax
ffff800000108ee8:	85 c0                	test   %eax,%eax
ffff800000108eea:	79 0a                	jns    ffff800000108ef6 <sys_link+0x4e>
    return -1;
ffff800000108eec:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
ffff800000108ef1:	e9 0c 02 00 00       	jmpq   ffff800000109102 <sys_link+0x25a>

  begin_op();
ffff800000108ef6:	b8 00 00 00 00       	mov    $0x0,%eax
ffff800000108efb:	48 ba 79 4f 10 00 00 	movabs $0xffff800000104f79,%rdx
ffff800000108f02:	80 ff ff 
ffff800000108f05:	ff d2                	callq  *%rdx
  if((ip = namei(old)) == 0){
ffff800000108f07:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
ffff800000108f0b:	48 89 c7             	mov    %rax,%rdi
ffff800000108f0e:	48 b8 ff 37 10 00 00 	movabs $0xffff8000001037ff,%rax
ffff800000108f15:	80 ff ff 
ffff800000108f18:	ff d0                	callq  *%rax
ffff800000108f1a:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
ffff800000108f1e:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
ffff800000108f23:	75 1b                	jne    ffff800000108f40 <sys_link+0x98>
    end_op();
ffff800000108f25:	b8 00 00 00 00       	mov    $0x0,%eax
ffff800000108f2a:	48 ba 53 50 10 00 00 	movabs $0xffff800000105053,%rdx
ffff800000108f31:	80 ff ff 
ffff800000108f34:	ff d2                	callq  *%rdx
    return -1;
ffff800000108f36:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
ffff800000108f3b:	e9 c2 01 00 00       	jmpq   ffff800000109102 <sys_link+0x25a>
  }

  ilock(ip);
ffff800000108f40:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000108f44:	48 89 c7             	mov    %rax,%rdi
ffff800000108f47:	48 b8 e8 28 10 00 00 	movabs $0xffff8000001028e8,%rax
ffff800000108f4e:	80 ff ff 
ffff800000108f51:	ff d0                	callq  *%rax
  if(ip->type == T_DIR){
ffff800000108f53:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000108f57:	0f b7 80 94 00 00 00 	movzwl 0x94(%rax),%eax
ffff800000108f5e:	66 83 f8 01          	cmp    $0x1,%ax
ffff800000108f62:	75 2e                	jne    ffff800000108f92 <sys_link+0xea>
    iunlockput(ip);
ffff800000108f64:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000108f68:	48 89 c7             	mov    %rax,%rdi
ffff800000108f6b:	48 b8 d8 2b 10 00 00 	movabs $0xffff800000102bd8,%rax
ffff800000108f72:	80 ff ff 
ffff800000108f75:	ff d0                	callq  *%rax
    end_op();
ffff800000108f77:	b8 00 00 00 00       	mov    $0x0,%eax
ffff800000108f7c:	48 ba 53 50 10 00 00 	movabs $0xffff800000105053,%rdx
ffff800000108f83:	80 ff ff 
ffff800000108f86:	ff d2                	callq  *%rdx
    return -1;
ffff800000108f88:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
ffff800000108f8d:	e9 70 01 00 00       	jmpq   ffff800000109102 <sys_link+0x25a>
  }

  ip->nlink++;
ffff800000108f92:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000108f96:	0f b7 80 9a 00 00 00 	movzwl 0x9a(%rax),%eax
ffff800000108f9d:	83 c0 01             	add    $0x1,%eax
ffff800000108fa0:	89 c2                	mov    %eax,%edx
ffff800000108fa2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000108fa6:	66 89 90 9a 00 00 00 	mov    %dx,0x9a(%rax)
  iupdate(ip);
ffff800000108fad:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000108fb1:	48 89 c7             	mov    %rax,%rdi
ffff800000108fb4:	48 b8 4a 26 10 00 00 	movabs $0xffff80000010264a,%rax
ffff800000108fbb:	80 ff ff 
ffff800000108fbe:	ff d0                	callq  *%rax
  iunlock(ip);
ffff800000108fc0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000108fc4:	48 89 c7             	mov    %rax,%rdi
ffff800000108fc7:	48 b8 7d 2a 10 00 00 	movabs $0xffff800000102a7d,%rax
ffff800000108fce:	80 ff ff 
ffff800000108fd1:	ff d0                	callq  *%rax

  if((dp = nameiparent(new, name)) == 0)
ffff800000108fd3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
ffff800000108fd7:	48 8d 55 e2          	lea    -0x1e(%rbp),%rdx
ffff800000108fdb:	48 89 d6             	mov    %rdx,%rsi
ffff800000108fde:	48 89 c7             	mov    %rax,%rdi
ffff800000108fe1:	48 b8 2d 38 10 00 00 	movabs $0xffff80000010382d,%rax
ffff800000108fe8:	80 ff ff 
ffff800000108feb:	ff d0                	callq  *%rax
ffff800000108fed:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
ffff800000108ff1:	48 83 7d f0 00       	cmpq   $0x0,-0x10(%rbp)
ffff800000108ff6:	0f 84 9b 00 00 00    	je     ffff800000109097 <sys_link+0x1ef>
    goto bad;
  ilock(dp);
ffff800000108ffc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff800000109000:	48 89 c7             	mov    %rax,%rdi
ffff800000109003:	48 b8 e8 28 10 00 00 	movabs $0xffff8000001028e8,%rax
ffff80000010900a:	80 ff ff 
ffff80000010900d:	ff d0                	callq  *%rax
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
ffff80000010900f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff800000109013:	8b 10                	mov    (%rax),%edx
ffff800000109015:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000109019:	8b 00                	mov    (%rax),%eax
ffff80000010901b:	39 c2                	cmp    %eax,%edx
ffff80000010901d:	75 25                	jne    ffff800000109044 <sys_link+0x19c>
ffff80000010901f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000109023:	8b 50 04             	mov    0x4(%rax),%edx
ffff800000109026:	48 8d 4d e2          	lea    -0x1e(%rbp),%rcx
ffff80000010902a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff80000010902e:	48 89 ce             	mov    %rcx,%rsi
ffff800000109031:	48 89 c7             	mov    %rax,%rdi
ffff800000109034:	48 b8 6f 34 10 00 00 	movabs $0xffff80000010346f,%rax
ffff80000010903b:	80 ff ff 
ffff80000010903e:	ff d0                	callq  *%rax
ffff800000109040:	85 c0                	test   %eax,%eax
ffff800000109042:	79 15                	jns    ffff800000109059 <sys_link+0x1b1>
    iunlockput(dp);
ffff800000109044:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff800000109048:	48 89 c7             	mov    %rax,%rdi
ffff80000010904b:	48 b8 d8 2b 10 00 00 	movabs $0xffff800000102bd8,%rax
ffff800000109052:	80 ff ff 
ffff800000109055:	ff d0                	callq  *%rax
    goto bad;
ffff800000109057:	eb 3f                	jmp    ffff800000109098 <sys_link+0x1f0>
  }
  iunlockput(dp);
ffff800000109059:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff80000010905d:	48 89 c7             	mov    %rax,%rdi
ffff800000109060:	48 b8 d8 2b 10 00 00 	movabs $0xffff800000102bd8,%rax
ffff800000109067:	80 ff ff 
ffff80000010906a:	ff d0                	callq  *%rax
  iput(ip);
ffff80000010906c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000109070:	48 89 c7             	mov    %rax,%rdi
ffff800000109073:	48 b8 ea 2a 10 00 00 	movabs $0xffff800000102aea,%rax
ffff80000010907a:	80 ff ff 
ffff80000010907d:	ff d0                	callq  *%rax

  end_op();
ffff80000010907f:	b8 00 00 00 00       	mov    $0x0,%eax
ffff800000109084:	48 ba 53 50 10 00 00 	movabs $0xffff800000105053,%rdx
ffff80000010908b:	80 ff ff 
ffff80000010908e:	ff d2                	callq  *%rdx

  return 0;
ffff800000109090:	b8 00 00 00 00       	mov    $0x0,%eax
ffff800000109095:	eb 6b                	jmp    ffff800000109102 <sys_link+0x25a>
    goto bad;
ffff800000109097:	90                   	nop

bad:
  ilock(ip);
ffff800000109098:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff80000010909c:	48 89 c7             	mov    %rax,%rdi
ffff80000010909f:	48 b8 e8 28 10 00 00 	movabs $0xffff8000001028e8,%rax
ffff8000001090a6:	80 ff ff 
ffff8000001090a9:	ff d0                	callq  *%rax
  ip->nlink--;
ffff8000001090ab:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff8000001090af:	0f b7 80 9a 00 00 00 	movzwl 0x9a(%rax),%eax
ffff8000001090b6:	83 e8 01             	sub    $0x1,%eax
ffff8000001090b9:	89 c2                	mov    %eax,%edx
ffff8000001090bb:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff8000001090bf:	66 89 90 9a 00 00 00 	mov    %dx,0x9a(%rax)
  iupdate(ip);
ffff8000001090c6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff8000001090ca:	48 89 c7             	mov    %rax,%rdi
ffff8000001090cd:	48 b8 4a 26 10 00 00 	movabs $0xffff80000010264a,%rax
ffff8000001090d4:	80 ff ff 
ffff8000001090d7:	ff d0                	callq  *%rax
  iunlockput(ip);
ffff8000001090d9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff8000001090dd:	48 89 c7             	mov    %rax,%rdi
ffff8000001090e0:	48 b8 d8 2b 10 00 00 	movabs $0xffff800000102bd8,%rax
ffff8000001090e7:	80 ff ff 
ffff8000001090ea:	ff d0                	callq  *%rax
  end_op();
ffff8000001090ec:	b8 00 00 00 00       	mov    $0x0,%eax
ffff8000001090f1:	48 ba 53 50 10 00 00 	movabs $0xffff800000105053,%rdx
ffff8000001090f8:	80 ff ff 
ffff8000001090fb:	ff d2                	callq  *%rdx
  return -1;
ffff8000001090fd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
ffff800000109102:	c9                   	leaveq 
ffff800000109103:	c3                   	retq   

ffff800000109104 <sys_unlink>:
//PAGEBREAK!

int
sys_unlink(void)
{
ffff800000109104:	f3 0f 1e fa          	endbr64 
ffff800000109108:	55                   	push   %rbp
ffff800000109109:	48 89 e5             	mov    %rsp,%rbp
ffff80000010910c:	48 83 ec 40          	sub    $0x40,%rsp
  struct inode *ip, *dp;
  struct dirent de;
  char name[DIRSIZ], *path;
  uint off;

  if(argstr(0, &path) < 0)
ffff800000109110:	48 8d 45 c8          	lea    -0x38(%rbp),%rax
ffff800000109114:	48 89 c6             	mov    %rax,%rsi
ffff800000109117:	bf 00 00 00 00       	mov    $0x0,%edi
ffff80000010911c:	48 b8 53 89 10 00 00 	movabs $0xffff800000108953,%rax
ffff800000109123:	80 ff ff 
ffff800000109126:	ff d0                	callq  *%rax
ffff800000109128:	85 c0                	test   %eax,%eax
ffff80000010912a:	79 0a                	jns    ffff800000109136 <sys_unlink+0x32>
    return -1;
ffff80000010912c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
ffff800000109131:	e9 83 02 00 00       	jmpq   ffff8000001093b9 <sys_unlink+0x2b5>

  begin_op();
ffff800000109136:	b8 00 00 00 00       	mov    $0x0,%eax
ffff80000010913b:	48 ba 79 4f 10 00 00 	movabs $0xffff800000104f79,%rdx
ffff800000109142:	80 ff ff 
ffff800000109145:	ff d2                	callq  *%rdx
  if((dp = nameiparent(path, name)) == 0){
ffff800000109147:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
ffff80000010914b:	48 8d 55 d2          	lea    -0x2e(%rbp),%rdx
ffff80000010914f:	48 89 d6             	mov    %rdx,%rsi
ffff800000109152:	48 89 c7             	mov    %rax,%rdi
ffff800000109155:	48 b8 2d 38 10 00 00 	movabs $0xffff80000010382d,%rax
ffff80000010915c:	80 ff ff 
ffff80000010915f:	ff d0                	callq  *%rax
ffff800000109161:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
ffff800000109165:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
ffff80000010916a:	75 1b                	jne    ffff800000109187 <sys_unlink+0x83>
    end_op();
ffff80000010916c:	b8 00 00 00 00       	mov    $0x0,%eax
ffff800000109171:	48 ba 53 50 10 00 00 	movabs $0xffff800000105053,%rdx
ffff800000109178:	80 ff ff 
ffff80000010917b:	ff d2                	callq  *%rdx
    return -1;
ffff80000010917d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
ffff800000109182:	e9 32 02 00 00       	jmpq   ffff8000001093b9 <sys_unlink+0x2b5>
  }

  ilock(dp);
ffff800000109187:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff80000010918b:	48 89 c7             	mov    %rax,%rdi
ffff80000010918e:	48 b8 e8 28 10 00 00 	movabs $0xffff8000001028e8,%rax
ffff800000109195:	80 ff ff 
ffff800000109198:	ff d0                	callq  *%rax

  // Cannot unlink "." or "..".
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
ffff80000010919a:	48 8d 45 d2          	lea    -0x2e(%rbp),%rax
ffff80000010919e:	48 be 1e cd 10 00 00 	movabs $0xffff80000010cd1e,%rsi
ffff8000001091a5:	80 ff ff 
ffff8000001091a8:	48 89 c7             	mov    %rax,%rdi
ffff8000001091ab:	48 b8 36 33 10 00 00 	movabs $0xffff800000103336,%rax
ffff8000001091b2:	80 ff ff 
ffff8000001091b5:	ff d0                	callq  *%rax
ffff8000001091b7:	85 c0                	test   %eax,%eax
ffff8000001091b9:	0f 84 cd 01 00 00    	je     ffff80000010938c <sys_unlink+0x288>
ffff8000001091bf:	48 8d 45 d2          	lea    -0x2e(%rbp),%rax
ffff8000001091c3:	48 be 20 cd 10 00 00 	movabs $0xffff80000010cd20,%rsi
ffff8000001091ca:	80 ff ff 
ffff8000001091cd:	48 89 c7             	mov    %rax,%rdi
ffff8000001091d0:	48 b8 36 33 10 00 00 	movabs $0xffff800000103336,%rax
ffff8000001091d7:	80 ff ff 
ffff8000001091da:	ff d0                	callq  *%rax
ffff8000001091dc:	85 c0                	test   %eax,%eax
ffff8000001091de:	0f 84 a8 01 00 00    	je     ffff80000010938c <sys_unlink+0x288>
    goto bad;

  if((ip = dirlookup(dp, name, &off)) == 0)
ffff8000001091e4:	48 8d 55 c4          	lea    -0x3c(%rbp),%rdx
ffff8000001091e8:	48 8d 4d d2          	lea    -0x2e(%rbp),%rcx
ffff8000001091ec:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff8000001091f0:	48 89 ce             	mov    %rcx,%rsi
ffff8000001091f3:	48 89 c7             	mov    %rax,%rdi
ffff8000001091f6:	48 b8 6b 33 10 00 00 	movabs $0xffff80000010336b,%rax
ffff8000001091fd:	80 ff ff 
ffff800000109200:	ff d0                	callq  *%rax
ffff800000109202:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
ffff800000109206:	48 83 7d f0 00       	cmpq   $0x0,-0x10(%rbp)
ffff80000010920b:	0f 84 7e 01 00 00    	je     ffff80000010938f <sys_unlink+0x28b>
    goto bad;
  ilock(ip);
ffff800000109211:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff800000109215:	48 89 c7             	mov    %rax,%rdi
ffff800000109218:	48 b8 e8 28 10 00 00 	movabs $0xffff8000001028e8,%rax
ffff80000010921f:	80 ff ff 
ffff800000109222:	ff d0                	callq  *%rax

  if(ip->nlink < 1)
ffff800000109224:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff800000109228:	0f b7 80 9a 00 00 00 	movzwl 0x9a(%rax),%eax
ffff80000010922f:	66 85 c0             	test   %ax,%ax
ffff800000109232:	7f 16                	jg     ffff80000010924a <sys_unlink+0x146>
    panic("unlink: nlink < 1");
ffff800000109234:	48 bf 23 cd 10 00 00 	movabs $0xffff80000010cd23,%rdi
ffff80000010923b:	80 ff ff 
ffff80000010923e:	48 b8 f9 0b 10 00 00 	movabs $0xffff800000100bf9,%rax
ffff800000109245:	80 ff ff 
ffff800000109248:	ff d0                	callq  *%rax
  if(ip->type == T_DIR && !isdirempty(ip)){
ffff80000010924a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff80000010924e:	0f b7 80 94 00 00 00 	movzwl 0x94(%rax),%eax
ffff800000109255:	66 83 f8 01          	cmp    $0x1,%ax
ffff800000109259:	75 2f                	jne    ffff80000010928a <sys_unlink+0x186>
ffff80000010925b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff80000010925f:	48 89 c7             	mov    %rax,%rdi
ffff800000109262:	48 b8 24 8e 10 00 00 	movabs $0xffff800000108e24,%rax
ffff800000109269:	80 ff ff 
ffff80000010926c:	ff d0                	callq  *%rax
ffff80000010926e:	85 c0                	test   %eax,%eax
ffff800000109270:	75 18                	jne    ffff80000010928a <sys_unlink+0x186>
    iunlockput(ip);
ffff800000109272:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff800000109276:	48 89 c7             	mov    %rax,%rdi
ffff800000109279:	48 b8 d8 2b 10 00 00 	movabs $0xffff800000102bd8,%rax
ffff800000109280:	80 ff ff 
ffff800000109283:	ff d0                	callq  *%rax
    goto bad;
ffff800000109285:	e9 06 01 00 00       	jmpq   ffff800000109390 <sys_unlink+0x28c>
  }

  memset(&de, 0, sizeof(de));
ffff80000010928a:	48 8d 45 e0          	lea    -0x20(%rbp),%rax
ffff80000010928e:	ba 10 00 00 00       	mov    $0x10,%edx
ffff800000109293:	be 00 00 00 00       	mov    $0x0,%esi
ffff800000109298:	48 89 c7             	mov    %rax,%rdi
ffff80000010929b:	48 b8 bd 82 10 00 00 	movabs $0xffff8000001082bd,%rax
ffff8000001092a2:	80 ff ff 
ffff8000001092a5:	ff d0                	callq  *%rax
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
ffff8000001092a7:	8b 55 c4             	mov    -0x3c(%rbp),%edx
ffff8000001092aa:	48 8d 75 e0          	lea    -0x20(%rbp),%rsi
ffff8000001092ae:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff8000001092b2:	b9 10 00 00 00       	mov    $0x10,%ecx
ffff8000001092b7:	48 89 c7             	mov    %rax,%rdi
ffff8000001092ba:	48 b8 22 31 10 00 00 	movabs $0xffff800000103122,%rax
ffff8000001092c1:	80 ff ff 
ffff8000001092c4:	ff d0                	callq  *%rax
ffff8000001092c6:	83 f8 10             	cmp    $0x10,%eax
ffff8000001092c9:	74 16                	je     ffff8000001092e1 <sys_unlink+0x1dd>
    panic("unlink: writei");
ffff8000001092cb:	48 bf 35 cd 10 00 00 	movabs $0xffff80000010cd35,%rdi
ffff8000001092d2:	80 ff ff 
ffff8000001092d5:	48 b8 f9 0b 10 00 00 	movabs $0xffff800000100bf9,%rax
ffff8000001092dc:	80 ff ff 
ffff8000001092df:	ff d0                	callq  *%rax
  if(ip->type == T_DIR){
ffff8000001092e1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff8000001092e5:	0f b7 80 94 00 00 00 	movzwl 0x94(%rax),%eax
ffff8000001092ec:	66 83 f8 01          	cmp    $0x1,%ax
ffff8000001092f0:	75 2e                	jne    ffff800000109320 <sys_unlink+0x21c>
    dp->nlink--;
ffff8000001092f2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff8000001092f6:	0f b7 80 9a 00 00 00 	movzwl 0x9a(%rax),%eax
ffff8000001092fd:	83 e8 01             	sub    $0x1,%eax
ffff800000109300:	89 c2                	mov    %eax,%edx
ffff800000109302:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000109306:	66 89 90 9a 00 00 00 	mov    %dx,0x9a(%rax)
    iupdate(dp);
ffff80000010930d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000109311:	48 89 c7             	mov    %rax,%rdi
ffff800000109314:	48 b8 4a 26 10 00 00 	movabs $0xffff80000010264a,%rax
ffff80000010931b:	80 ff ff 
ffff80000010931e:	ff d0                	callq  *%rax
  }
  iunlockput(dp);
ffff800000109320:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000109324:	48 89 c7             	mov    %rax,%rdi
ffff800000109327:	48 b8 d8 2b 10 00 00 	movabs $0xffff800000102bd8,%rax
ffff80000010932e:	80 ff ff 
ffff800000109331:	ff d0                	callq  *%rax

  ip->nlink--;
ffff800000109333:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff800000109337:	0f b7 80 9a 00 00 00 	movzwl 0x9a(%rax),%eax
ffff80000010933e:	83 e8 01             	sub    $0x1,%eax
ffff800000109341:	89 c2                	mov    %eax,%edx
ffff800000109343:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff800000109347:	66 89 90 9a 00 00 00 	mov    %dx,0x9a(%rax)
  iupdate(ip);
ffff80000010934e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff800000109352:	48 89 c7             	mov    %rax,%rdi
ffff800000109355:	48 b8 4a 26 10 00 00 	movabs $0xffff80000010264a,%rax
ffff80000010935c:	80 ff ff 
ffff80000010935f:	ff d0                	callq  *%rax
  iunlockput(ip);
ffff800000109361:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff800000109365:	48 89 c7             	mov    %rax,%rdi
ffff800000109368:	48 b8 d8 2b 10 00 00 	movabs $0xffff800000102bd8,%rax
ffff80000010936f:	80 ff ff 
ffff800000109372:	ff d0                	callq  *%rax

  end_op();
ffff800000109374:	b8 00 00 00 00       	mov    $0x0,%eax
ffff800000109379:	48 ba 53 50 10 00 00 	movabs $0xffff800000105053,%rdx
ffff800000109380:	80 ff ff 
ffff800000109383:	ff d2                	callq  *%rdx

  return 0;
ffff800000109385:	b8 00 00 00 00       	mov    $0x0,%eax
ffff80000010938a:	eb 2d                	jmp    ffff8000001093b9 <sys_unlink+0x2b5>
    goto bad;
ffff80000010938c:	90                   	nop
ffff80000010938d:	eb 01                	jmp    ffff800000109390 <sys_unlink+0x28c>
    goto bad;
ffff80000010938f:	90                   	nop

bad:
  iunlockput(dp);
ffff800000109390:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000109394:	48 89 c7             	mov    %rax,%rdi
ffff800000109397:	48 b8 d8 2b 10 00 00 	movabs $0xffff800000102bd8,%rax
ffff80000010939e:	80 ff ff 
ffff8000001093a1:	ff d0                	callq  *%rax
  end_op();
ffff8000001093a3:	b8 00 00 00 00       	mov    $0x0,%eax
ffff8000001093a8:	48 ba 53 50 10 00 00 	movabs $0xffff800000105053,%rdx
ffff8000001093af:	80 ff ff 
ffff8000001093b2:	ff d2                	callq  *%rdx
  return -1;
ffff8000001093b4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
ffff8000001093b9:	c9                   	leaveq 
ffff8000001093ba:	c3                   	retq   

ffff8000001093bb <create>:

static struct inode*
create(char *path, short type, short major, short minor)
{
ffff8000001093bb:	f3 0f 1e fa          	endbr64 
ffff8000001093bf:	55                   	push   %rbp
ffff8000001093c0:	48 89 e5             	mov    %rsp,%rbp
ffff8000001093c3:	48 83 ec 50          	sub    $0x50,%rsp
ffff8000001093c7:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
ffff8000001093cb:	89 c8                	mov    %ecx,%eax
ffff8000001093cd:	89 f1                	mov    %esi,%ecx
ffff8000001093cf:	66 89 4d c4          	mov    %cx,-0x3c(%rbp)
ffff8000001093d3:	66 89 55 c0          	mov    %dx,-0x40(%rbp)
ffff8000001093d7:	66 89 45 bc          	mov    %ax,-0x44(%rbp)
  uint off;
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
ffff8000001093db:	48 8d 55 de          	lea    -0x22(%rbp),%rdx
ffff8000001093df:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
ffff8000001093e3:	48 89 d6             	mov    %rdx,%rsi
ffff8000001093e6:	48 89 c7             	mov    %rax,%rdi
ffff8000001093e9:	48 b8 2d 38 10 00 00 	movabs $0xffff80000010382d,%rax
ffff8000001093f0:	80 ff ff 
ffff8000001093f3:	ff d0                	callq  *%rax
ffff8000001093f5:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
ffff8000001093f9:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
ffff8000001093fe:	75 0a                	jne    ffff80000010940a <create+0x4f>
    return 0;
ffff800000109400:	b8 00 00 00 00       	mov    $0x0,%eax
ffff800000109405:	e9 1d 02 00 00       	jmpq   ffff800000109627 <create+0x26c>
  ilock(dp);
ffff80000010940a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff80000010940e:	48 89 c7             	mov    %rax,%rdi
ffff800000109411:	48 b8 e8 28 10 00 00 	movabs $0xffff8000001028e8,%rax
ffff800000109418:	80 ff ff 
ffff80000010941b:	ff d0                	callq  *%rax

  if((ip = dirlookup(dp, name, &off)) != 0){
ffff80000010941d:	48 8d 55 ec          	lea    -0x14(%rbp),%rdx
ffff800000109421:	48 8d 4d de          	lea    -0x22(%rbp),%rcx
ffff800000109425:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000109429:	48 89 ce             	mov    %rcx,%rsi
ffff80000010942c:	48 89 c7             	mov    %rax,%rdi
ffff80000010942f:	48 b8 6b 33 10 00 00 	movabs $0xffff80000010336b,%rax
ffff800000109436:	80 ff ff 
ffff800000109439:	ff d0                	callq  *%rax
ffff80000010943b:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
ffff80000010943f:	48 83 7d f0 00       	cmpq   $0x0,-0x10(%rbp)
ffff800000109444:	74 64                	je     ffff8000001094aa <create+0xef>
    iunlockput(dp);
ffff800000109446:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff80000010944a:	48 89 c7             	mov    %rax,%rdi
ffff80000010944d:	48 b8 d8 2b 10 00 00 	movabs $0xffff800000102bd8,%rax
ffff800000109454:	80 ff ff 
ffff800000109457:	ff d0                	callq  *%rax
    ilock(ip);
ffff800000109459:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff80000010945d:	48 89 c7             	mov    %rax,%rdi
ffff800000109460:	48 b8 e8 28 10 00 00 	movabs $0xffff8000001028e8,%rax
ffff800000109467:	80 ff ff 
ffff80000010946a:	ff d0                	callq  *%rax
    if(type == T_FILE && ip->type == T_FILE)
ffff80000010946c:	66 83 7d c4 02       	cmpw   $0x2,-0x3c(%rbp)
ffff800000109471:	75 1a                	jne    ffff80000010948d <create+0xd2>
ffff800000109473:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff800000109477:	0f b7 80 94 00 00 00 	movzwl 0x94(%rax),%eax
ffff80000010947e:	66 83 f8 02          	cmp    $0x2,%ax
ffff800000109482:	75 09                	jne    ffff80000010948d <create+0xd2>
      return ip;
ffff800000109484:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff800000109488:	e9 9a 01 00 00       	jmpq   ffff800000109627 <create+0x26c>
    iunlockput(ip);
ffff80000010948d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff800000109491:	48 89 c7             	mov    %rax,%rdi
ffff800000109494:	48 b8 d8 2b 10 00 00 	movabs $0xffff800000102bd8,%rax
ffff80000010949b:	80 ff ff 
ffff80000010949e:	ff d0                	callq  *%rax
    return 0;
ffff8000001094a0:	b8 00 00 00 00       	mov    $0x0,%eax
ffff8000001094a5:	e9 7d 01 00 00       	jmpq   ffff800000109627 <create+0x26c>
  }

  if((ip = ialloc(dp->dev, type)) == 0)
ffff8000001094aa:	0f bf 55 c4          	movswl -0x3c(%rbp),%edx
ffff8000001094ae:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff8000001094b2:	8b 00                	mov    (%rax),%eax
ffff8000001094b4:	89 d6                	mov    %edx,%esi
ffff8000001094b6:	89 c7                	mov    %eax,%edi
ffff8000001094b8:	48 b8 21 25 10 00 00 	movabs $0xffff800000102521,%rax
ffff8000001094bf:	80 ff ff 
ffff8000001094c2:	ff d0                	callq  *%rax
ffff8000001094c4:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
ffff8000001094c8:	48 83 7d f0 00       	cmpq   $0x0,-0x10(%rbp)
ffff8000001094cd:	75 16                	jne    ffff8000001094e5 <create+0x12a>
    panic("create: ialloc");
ffff8000001094cf:	48 bf 44 cd 10 00 00 	movabs $0xffff80000010cd44,%rdi
ffff8000001094d6:	80 ff ff 
ffff8000001094d9:	48 b8 f9 0b 10 00 00 	movabs $0xffff800000100bf9,%rax
ffff8000001094e0:	80 ff ff 
ffff8000001094e3:	ff d0                	callq  *%rax

  ilock(ip);
ffff8000001094e5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff8000001094e9:	48 89 c7             	mov    %rax,%rdi
ffff8000001094ec:	48 b8 e8 28 10 00 00 	movabs $0xffff8000001028e8,%rax
ffff8000001094f3:	80 ff ff 
ffff8000001094f6:	ff d0                	callq  *%rax
  ip->major = major;
ffff8000001094f8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff8000001094fc:	0f b7 55 c0          	movzwl -0x40(%rbp),%edx
ffff800000109500:	66 89 90 96 00 00 00 	mov    %dx,0x96(%rax)
  ip->minor = minor;
ffff800000109507:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff80000010950b:	0f b7 55 bc          	movzwl -0x44(%rbp),%edx
ffff80000010950f:	66 89 90 98 00 00 00 	mov    %dx,0x98(%rax)
  ip->nlink = 1;
ffff800000109516:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff80000010951a:	66 c7 80 9a 00 00 00 	movw   $0x1,0x9a(%rax)
ffff800000109521:	01 00 
  iupdate(ip);
ffff800000109523:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff800000109527:	48 89 c7             	mov    %rax,%rdi
ffff80000010952a:	48 b8 4a 26 10 00 00 	movabs $0xffff80000010264a,%rax
ffff800000109531:	80 ff ff 
ffff800000109534:	ff d0                	callq  *%rax

  if(type == T_DIR){  // Create . and .. entries.
ffff800000109536:	66 83 7d c4 01       	cmpw   $0x1,-0x3c(%rbp)
ffff80000010953b:	0f 85 94 00 00 00    	jne    ffff8000001095d5 <create+0x21a>
    dp->nlink++;  // for ".."
ffff800000109541:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000109545:	0f b7 80 9a 00 00 00 	movzwl 0x9a(%rax),%eax
ffff80000010954c:	83 c0 01             	add    $0x1,%eax
ffff80000010954f:	89 c2                	mov    %eax,%edx
ffff800000109551:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000109555:	66 89 90 9a 00 00 00 	mov    %dx,0x9a(%rax)
    iupdate(dp);
ffff80000010955c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000109560:	48 89 c7             	mov    %rax,%rdi
ffff800000109563:	48 b8 4a 26 10 00 00 	movabs $0xffff80000010264a,%rax
ffff80000010956a:	80 ff ff 
ffff80000010956d:	ff d0                	callq  *%rax
    // No ip->nlink++ for ".": avoid cyclic ref count.
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
ffff80000010956f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff800000109573:	8b 50 04             	mov    0x4(%rax),%edx
ffff800000109576:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff80000010957a:	48 be 1e cd 10 00 00 	movabs $0xffff80000010cd1e,%rsi
ffff800000109581:	80 ff ff 
ffff800000109584:	48 89 c7             	mov    %rax,%rdi
ffff800000109587:	48 b8 6f 34 10 00 00 	movabs $0xffff80000010346f,%rax
ffff80000010958e:	80 ff ff 
ffff800000109591:	ff d0                	callq  *%rax
ffff800000109593:	85 c0                	test   %eax,%eax
ffff800000109595:	78 28                	js     ffff8000001095bf <create+0x204>
ffff800000109597:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff80000010959b:	8b 50 04             	mov    0x4(%rax),%edx
ffff80000010959e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff8000001095a2:	48 be 20 cd 10 00 00 	movabs $0xffff80000010cd20,%rsi
ffff8000001095a9:	80 ff ff 
ffff8000001095ac:	48 89 c7             	mov    %rax,%rdi
ffff8000001095af:	48 b8 6f 34 10 00 00 	movabs $0xffff80000010346f,%rax
ffff8000001095b6:	80 ff ff 
ffff8000001095b9:	ff d0                	callq  *%rax
ffff8000001095bb:	85 c0                	test   %eax,%eax
ffff8000001095bd:	79 16                	jns    ffff8000001095d5 <create+0x21a>
      panic("create dots");
ffff8000001095bf:	48 bf 53 cd 10 00 00 	movabs $0xffff80000010cd53,%rdi
ffff8000001095c6:	80 ff ff 
ffff8000001095c9:	48 b8 f9 0b 10 00 00 	movabs $0xffff800000100bf9,%rax
ffff8000001095d0:	80 ff ff 
ffff8000001095d3:	ff d0                	callq  *%rax
  }

  if(dirlink(dp, name, ip->inum) < 0)
ffff8000001095d5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff8000001095d9:	8b 50 04             	mov    0x4(%rax),%edx
ffff8000001095dc:	48 8d 4d de          	lea    -0x22(%rbp),%rcx
ffff8000001095e0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff8000001095e4:	48 89 ce             	mov    %rcx,%rsi
ffff8000001095e7:	48 89 c7             	mov    %rax,%rdi
ffff8000001095ea:	48 b8 6f 34 10 00 00 	movabs $0xffff80000010346f,%rax
ffff8000001095f1:	80 ff ff 
ffff8000001095f4:	ff d0                	callq  *%rax
ffff8000001095f6:	85 c0                	test   %eax,%eax
ffff8000001095f8:	79 16                	jns    ffff800000109610 <create+0x255>
    panic("create: dirlink");
ffff8000001095fa:	48 bf 5f cd 10 00 00 	movabs $0xffff80000010cd5f,%rdi
ffff800000109601:	80 ff ff 
ffff800000109604:	48 b8 f9 0b 10 00 00 	movabs $0xffff800000100bf9,%rax
ffff80000010960b:	80 ff ff 
ffff80000010960e:	ff d0                	callq  *%rax

  iunlockput(dp);
ffff800000109610:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000109614:	48 89 c7             	mov    %rax,%rdi
ffff800000109617:	48 b8 d8 2b 10 00 00 	movabs $0xffff800000102bd8,%rax
ffff80000010961e:	80 ff ff 
ffff800000109621:	ff d0                	callq  *%rax

  return ip;
ffff800000109623:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
ffff800000109627:	c9                   	leaveq 
ffff800000109628:	c3                   	retq   

ffff800000109629 <sys_open>:

int
sys_open(void)
{
ffff800000109629:	f3 0f 1e fa          	endbr64 
ffff80000010962d:	55                   	push   %rbp
ffff80000010962e:	48 89 e5             	mov    %rsp,%rbp
ffff800000109631:	48 83 ec 30          	sub    $0x30,%rsp
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
ffff800000109635:	48 8d 45 e0          	lea    -0x20(%rbp),%rax
ffff800000109639:	48 89 c6             	mov    %rax,%rsi
ffff80000010963c:	bf 00 00 00 00       	mov    $0x0,%edi
ffff800000109641:	48 b8 53 89 10 00 00 	movabs $0xffff800000108953,%rax
ffff800000109648:	80 ff ff 
ffff80000010964b:	ff d0                	callq  *%rax
ffff80000010964d:	85 c0                	test   %eax,%eax
ffff80000010964f:	78 1c                	js     ffff80000010966d <sys_open+0x44>
ffff800000109651:	48 8d 45 dc          	lea    -0x24(%rbp),%rax
ffff800000109655:	48 89 c6             	mov    %rax,%rsi
ffff800000109658:	bf 01 00 00 00       	mov    $0x1,%edi
ffff80000010965d:	48 b8 5a 88 10 00 00 	movabs $0xffff80000010885a,%rax
ffff800000109664:	80 ff ff 
ffff800000109667:	ff d0                	callq  *%rax
ffff800000109669:	85 c0                	test   %eax,%eax
ffff80000010966b:	79 0a                	jns    ffff800000109677 <sys_open+0x4e>
    return -1;
ffff80000010966d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
ffff800000109672:	e9 fb 01 00 00       	jmpq   ffff800000109872 <sys_open+0x249>

  begin_op();
ffff800000109677:	b8 00 00 00 00       	mov    $0x0,%eax
ffff80000010967c:	48 ba 79 4f 10 00 00 	movabs $0xffff800000104f79,%rdx
ffff800000109683:	80 ff ff 
ffff800000109686:	ff d2                	callq  *%rdx

  if(omode & O_CREATE){
ffff800000109688:	8b 45 dc             	mov    -0x24(%rbp),%eax
ffff80000010968b:	25 00 02 00 00       	and    $0x200,%eax
ffff800000109690:	85 c0                	test   %eax,%eax
ffff800000109692:	74 4c                	je     ffff8000001096e0 <sys_open+0xb7>
    ip = create(path, T_FILE, 0, 0);
ffff800000109694:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
ffff800000109698:	b9 00 00 00 00       	mov    $0x0,%ecx
ffff80000010969d:	ba 00 00 00 00       	mov    $0x0,%edx
ffff8000001096a2:	be 02 00 00 00       	mov    $0x2,%esi
ffff8000001096a7:	48 89 c7             	mov    %rax,%rdi
ffff8000001096aa:	48 b8 bb 93 10 00 00 	movabs $0xffff8000001093bb,%rax
ffff8000001096b1:	80 ff ff 
ffff8000001096b4:	ff d0                	callq  *%rax
ffff8000001096b6:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
    if(ip == 0){
ffff8000001096ba:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
ffff8000001096bf:	0f 85 ad 00 00 00    	jne    ffff800000109772 <sys_open+0x149>
      end_op();
ffff8000001096c5:	b8 00 00 00 00       	mov    $0x0,%eax
ffff8000001096ca:	48 ba 53 50 10 00 00 	movabs $0xffff800000105053,%rdx
ffff8000001096d1:	80 ff ff 
ffff8000001096d4:	ff d2                	callq  *%rdx
      return -1;
ffff8000001096d6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
ffff8000001096db:	e9 92 01 00 00       	jmpq   ffff800000109872 <sys_open+0x249>
    }
  } else {
    if((ip = namei(path)) == 0){
ffff8000001096e0:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
ffff8000001096e4:	48 89 c7             	mov    %rax,%rdi
ffff8000001096e7:	48 b8 ff 37 10 00 00 	movabs $0xffff8000001037ff,%rax
ffff8000001096ee:	80 ff ff 
ffff8000001096f1:	ff d0                	callq  *%rax
ffff8000001096f3:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
ffff8000001096f7:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
ffff8000001096fc:	75 1b                	jne    ffff800000109719 <sys_open+0xf0>
      end_op();
ffff8000001096fe:	b8 00 00 00 00       	mov    $0x0,%eax
ffff800000109703:	48 ba 53 50 10 00 00 	movabs $0xffff800000105053,%rdx
ffff80000010970a:	80 ff ff 
ffff80000010970d:	ff d2                	callq  *%rdx
      return -1;
ffff80000010970f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
ffff800000109714:	e9 59 01 00 00       	jmpq   ffff800000109872 <sys_open+0x249>
    }
    ilock(ip);
ffff800000109719:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff80000010971d:	48 89 c7             	mov    %rax,%rdi
ffff800000109720:	48 b8 e8 28 10 00 00 	movabs $0xffff8000001028e8,%rax
ffff800000109727:	80 ff ff 
ffff80000010972a:	ff d0                	callq  *%rax
    if(ip->type == T_DIR && omode != O_RDONLY){
ffff80000010972c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000109730:	0f b7 80 94 00 00 00 	movzwl 0x94(%rax),%eax
ffff800000109737:	66 83 f8 01          	cmp    $0x1,%ax
ffff80000010973b:	75 35                	jne    ffff800000109772 <sys_open+0x149>
ffff80000010973d:	8b 45 dc             	mov    -0x24(%rbp),%eax
ffff800000109740:	85 c0                	test   %eax,%eax
ffff800000109742:	74 2e                	je     ffff800000109772 <sys_open+0x149>
      iunlockput(ip);
ffff800000109744:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000109748:	48 89 c7             	mov    %rax,%rdi
ffff80000010974b:	48 b8 d8 2b 10 00 00 	movabs $0xffff800000102bd8,%rax
ffff800000109752:	80 ff ff 
ffff800000109755:	ff d0                	callq  *%rax
      end_op();
ffff800000109757:	b8 00 00 00 00       	mov    $0x0,%eax
ffff80000010975c:	48 ba 53 50 10 00 00 	movabs $0xffff800000105053,%rdx
ffff800000109763:	80 ff ff 
ffff800000109766:	ff d2                	callq  *%rdx
      return -1;
ffff800000109768:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
ffff80000010976d:	e9 00 01 00 00       	jmpq   ffff800000109872 <sys_open+0x249>
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
ffff800000109772:	48 b8 84 1b 10 00 00 	movabs $0xffff800000101b84,%rax
ffff800000109779:	80 ff ff 
ffff80000010977c:	ff d0                	callq  *%rax
ffff80000010977e:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
ffff800000109782:	48 83 7d f0 00       	cmpq   $0x0,-0x10(%rbp)
ffff800000109787:	74 1c                	je     ffff8000001097a5 <sys_open+0x17c>
ffff800000109789:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff80000010978d:	48 89 c7             	mov    %rax,%rdi
ffff800000109790:	48 b8 51 8b 10 00 00 	movabs $0xffff800000108b51,%rax
ffff800000109797:	80 ff ff 
ffff80000010979a:	ff d0                	callq  *%rax
ffff80000010979c:	89 45 ec             	mov    %eax,-0x14(%rbp)
ffff80000010979f:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
ffff8000001097a3:	79 48                	jns    ffff8000001097ed <sys_open+0x1c4>
    if(f)
ffff8000001097a5:	48 83 7d f0 00       	cmpq   $0x0,-0x10(%rbp)
ffff8000001097aa:	74 13                	je     ffff8000001097bf <sys_open+0x196>
      fileclose(f);
ffff8000001097ac:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff8000001097b0:	48 89 c7             	mov    %rax,%rdi
ffff8000001097b3:	48 b8 8e 1c 10 00 00 	movabs $0xffff800000101c8e,%rax
ffff8000001097ba:	80 ff ff 
ffff8000001097bd:	ff d0                	callq  *%rax
    iunlockput(ip);
ffff8000001097bf:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff8000001097c3:	48 89 c7             	mov    %rax,%rdi
ffff8000001097c6:	48 b8 d8 2b 10 00 00 	movabs $0xffff800000102bd8,%rax
ffff8000001097cd:	80 ff ff 
ffff8000001097d0:	ff d0                	callq  *%rax
    end_op();
ffff8000001097d2:	b8 00 00 00 00       	mov    $0x0,%eax
ffff8000001097d7:	48 ba 53 50 10 00 00 	movabs $0xffff800000105053,%rdx
ffff8000001097de:	80 ff ff 
ffff8000001097e1:	ff d2                	callq  *%rdx
    return -1;
ffff8000001097e3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
ffff8000001097e8:	e9 85 00 00 00       	jmpq   ffff800000109872 <sys_open+0x249>
  }
  iunlock(ip);
ffff8000001097ed:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff8000001097f1:	48 89 c7             	mov    %rax,%rdi
ffff8000001097f4:	48 b8 7d 2a 10 00 00 	movabs $0xffff800000102a7d,%rax
ffff8000001097fb:	80 ff ff 
ffff8000001097fe:	ff d0                	callq  *%rax
  end_op();
ffff800000109800:	b8 00 00 00 00       	mov    $0x0,%eax
ffff800000109805:	48 ba 53 50 10 00 00 	movabs $0xffff800000105053,%rdx
ffff80000010980c:	80 ff ff 
ffff80000010980f:	ff d2                	callq  *%rdx

  f->type = FD_INODE;
ffff800000109811:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff800000109815:	c7 00 02 00 00 00    	movl   $0x2,(%rax)
  f->ip = ip;
ffff80000010981b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff80000010981f:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
ffff800000109823:	48 89 50 18          	mov    %rdx,0x18(%rax)
  f->off = 0;
ffff800000109827:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff80000010982b:	c7 40 20 00 00 00 00 	movl   $0x0,0x20(%rax)
  f->readable = !(omode & O_WRONLY);
ffff800000109832:	8b 45 dc             	mov    -0x24(%rbp),%eax
ffff800000109835:	83 e0 01             	and    $0x1,%eax
ffff800000109838:	85 c0                	test   %eax,%eax
ffff80000010983a:	0f 94 c0             	sete   %al
ffff80000010983d:	89 c2                	mov    %eax,%edx
ffff80000010983f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff800000109843:	88 50 08             	mov    %dl,0x8(%rax)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
ffff800000109846:	8b 45 dc             	mov    -0x24(%rbp),%eax
ffff800000109849:	83 e0 01             	and    $0x1,%eax
ffff80000010984c:	85 c0                	test   %eax,%eax
ffff80000010984e:	75 0a                	jne    ffff80000010985a <sys_open+0x231>
ffff800000109850:	8b 45 dc             	mov    -0x24(%rbp),%eax
ffff800000109853:	83 e0 02             	and    $0x2,%eax
ffff800000109856:	85 c0                	test   %eax,%eax
ffff800000109858:	74 07                	je     ffff800000109861 <sys_open+0x238>
ffff80000010985a:	b8 01 00 00 00       	mov    $0x1,%eax
ffff80000010985f:	eb 05                	jmp    ffff800000109866 <sys_open+0x23d>
ffff800000109861:	b8 00 00 00 00       	mov    $0x0,%eax
ffff800000109866:	89 c2                	mov    %eax,%edx
ffff800000109868:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff80000010986c:	88 50 09             	mov    %dl,0x9(%rax)
  return fd;
ffff80000010986f:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
ffff800000109872:	c9                   	leaveq 
ffff800000109873:	c3                   	retq   

ffff800000109874 <sys_mkdir>:

int
sys_mkdir(void)
{
ffff800000109874:	f3 0f 1e fa          	endbr64 
ffff800000109878:	55                   	push   %rbp
ffff800000109879:	48 89 e5             	mov    %rsp,%rbp
ffff80000010987c:	48 83 ec 10          	sub    $0x10,%rsp
  char *path;
  struct inode *ip;

  begin_op();
ffff800000109880:	b8 00 00 00 00       	mov    $0x0,%eax
ffff800000109885:	48 ba 79 4f 10 00 00 	movabs $0xffff800000104f79,%rdx
ffff80000010988c:	80 ff ff 
ffff80000010988f:	ff d2                	callq  *%rdx
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
ffff800000109891:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
ffff800000109895:	48 89 c6             	mov    %rax,%rsi
ffff800000109898:	bf 00 00 00 00       	mov    $0x0,%edi
ffff80000010989d:	48 b8 53 89 10 00 00 	movabs $0xffff800000108953,%rax
ffff8000001098a4:	80 ff ff 
ffff8000001098a7:	ff d0                	callq  *%rax
ffff8000001098a9:	85 c0                	test   %eax,%eax
ffff8000001098ab:	78 2d                	js     ffff8000001098da <sys_mkdir+0x66>
ffff8000001098ad:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff8000001098b1:	b9 00 00 00 00       	mov    $0x0,%ecx
ffff8000001098b6:	ba 00 00 00 00       	mov    $0x0,%edx
ffff8000001098bb:	be 01 00 00 00       	mov    $0x1,%esi
ffff8000001098c0:	48 89 c7             	mov    %rax,%rdi
ffff8000001098c3:	48 b8 bb 93 10 00 00 	movabs $0xffff8000001093bb,%rax
ffff8000001098ca:	80 ff ff 
ffff8000001098cd:	ff d0                	callq  *%rax
ffff8000001098cf:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
ffff8000001098d3:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
ffff8000001098d8:	75 18                	jne    ffff8000001098f2 <sys_mkdir+0x7e>
    end_op();
ffff8000001098da:	b8 00 00 00 00       	mov    $0x0,%eax
ffff8000001098df:	48 ba 53 50 10 00 00 	movabs $0xffff800000105053,%rdx
ffff8000001098e6:	80 ff ff 
ffff8000001098e9:	ff d2                	callq  *%rdx
    return -1;
ffff8000001098eb:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
ffff8000001098f0:	eb 29                	jmp    ffff80000010991b <sys_mkdir+0xa7>
  }
  iunlockput(ip);
ffff8000001098f2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff8000001098f6:	48 89 c7             	mov    %rax,%rdi
ffff8000001098f9:	48 b8 d8 2b 10 00 00 	movabs $0xffff800000102bd8,%rax
ffff800000109900:	80 ff ff 
ffff800000109903:	ff d0                	callq  *%rax
  end_op();
ffff800000109905:	b8 00 00 00 00       	mov    $0x0,%eax
ffff80000010990a:	48 ba 53 50 10 00 00 	movabs $0xffff800000105053,%rdx
ffff800000109911:	80 ff ff 
ffff800000109914:	ff d2                	callq  *%rdx
  return 0;
ffff800000109916:	b8 00 00 00 00       	mov    $0x0,%eax
}
ffff80000010991b:	c9                   	leaveq 
ffff80000010991c:	c3                   	retq   

ffff80000010991d <sys_mknod>:

int
sys_mknod(void)
{
ffff80000010991d:	f3 0f 1e fa          	endbr64 
ffff800000109921:	55                   	push   %rbp
ffff800000109922:	48 89 e5             	mov    %rsp,%rbp
ffff800000109925:	48 83 ec 20          	sub    $0x20,%rsp
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
ffff800000109929:	b8 00 00 00 00       	mov    $0x0,%eax
ffff80000010992e:	48 ba 79 4f 10 00 00 	movabs $0xffff800000104f79,%rdx
ffff800000109935:	80 ff ff 
ffff800000109938:	ff d2                	callq  *%rdx
  if((argstr(0, &path)) < 0 ||
ffff80000010993a:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
ffff80000010993e:	48 89 c6             	mov    %rax,%rsi
ffff800000109941:	bf 00 00 00 00       	mov    $0x0,%edi
ffff800000109946:	48 b8 53 89 10 00 00 	movabs $0xffff800000108953,%rax
ffff80000010994d:	80 ff ff 
ffff800000109950:	ff d0                	callq  *%rax
ffff800000109952:	85 c0                	test   %eax,%eax
ffff800000109954:	78 67                	js     ffff8000001099bd <sys_mknod+0xa0>
     argint(1, &major) < 0 ||
ffff800000109956:	48 8d 45 ec          	lea    -0x14(%rbp),%rax
ffff80000010995a:	48 89 c6             	mov    %rax,%rsi
ffff80000010995d:	bf 01 00 00 00       	mov    $0x1,%edi
ffff800000109962:	48 b8 5a 88 10 00 00 	movabs $0xffff80000010885a,%rax
ffff800000109969:	80 ff ff 
ffff80000010996c:	ff d0                	callq  *%rax
  if((argstr(0, &path)) < 0 ||
ffff80000010996e:	85 c0                	test   %eax,%eax
ffff800000109970:	78 4b                	js     ffff8000001099bd <sys_mknod+0xa0>
     argint(2, &minor) < 0 ||
ffff800000109972:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
ffff800000109976:	48 89 c6             	mov    %rax,%rsi
ffff800000109979:	bf 02 00 00 00       	mov    $0x2,%edi
ffff80000010997e:	48 b8 5a 88 10 00 00 	movabs $0xffff80000010885a,%rax
ffff800000109985:	80 ff ff 
ffff800000109988:	ff d0                	callq  *%rax
     argint(1, &major) < 0 ||
ffff80000010998a:	85 c0                	test   %eax,%eax
ffff80000010998c:	78 2f                	js     ffff8000001099bd <sys_mknod+0xa0>
     (ip = create(path, T_DEV, major, minor)) == 0){
ffff80000010998e:	8b 45 e8             	mov    -0x18(%rbp),%eax
ffff800000109991:	0f bf c8             	movswl %ax,%ecx
ffff800000109994:	8b 45 ec             	mov    -0x14(%rbp),%eax
ffff800000109997:	0f bf d0             	movswl %ax,%edx
ffff80000010999a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff80000010999e:	be 03 00 00 00       	mov    $0x3,%esi
ffff8000001099a3:	48 89 c7             	mov    %rax,%rdi
ffff8000001099a6:	48 b8 bb 93 10 00 00 	movabs $0xffff8000001093bb,%rax
ffff8000001099ad:	80 ff ff 
ffff8000001099b0:	ff d0                	callq  *%rax
ffff8000001099b2:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
     argint(2, &minor) < 0 ||
ffff8000001099b6:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
ffff8000001099bb:	75 18                	jne    ffff8000001099d5 <sys_mknod+0xb8>
    end_op();
ffff8000001099bd:	b8 00 00 00 00       	mov    $0x0,%eax
ffff8000001099c2:	48 ba 53 50 10 00 00 	movabs $0xffff800000105053,%rdx
ffff8000001099c9:	80 ff ff 
ffff8000001099cc:	ff d2                	callq  *%rdx
    return -1;
ffff8000001099ce:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
ffff8000001099d3:	eb 29                	jmp    ffff8000001099fe <sys_mknod+0xe1>
  }
  iunlockput(ip);
ffff8000001099d5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff8000001099d9:	48 89 c7             	mov    %rax,%rdi
ffff8000001099dc:	48 b8 d8 2b 10 00 00 	movabs $0xffff800000102bd8,%rax
ffff8000001099e3:	80 ff ff 
ffff8000001099e6:	ff d0                	callq  *%rax
  end_op();
ffff8000001099e8:	b8 00 00 00 00       	mov    $0x0,%eax
ffff8000001099ed:	48 ba 53 50 10 00 00 	movabs $0xffff800000105053,%rdx
ffff8000001099f4:	80 ff ff 
ffff8000001099f7:	ff d2                	callq  *%rdx
  return 0;
ffff8000001099f9:	b8 00 00 00 00       	mov    $0x0,%eax
}
ffff8000001099fe:	c9                   	leaveq 
ffff8000001099ff:	c3                   	retq   

ffff800000109a00 <sys_chdir>:

int
sys_chdir(void)
{
ffff800000109a00:	f3 0f 1e fa          	endbr64 
ffff800000109a04:	55                   	push   %rbp
ffff800000109a05:	48 89 e5             	mov    %rsp,%rbp
ffff800000109a08:	48 83 ec 10          	sub    $0x10,%rsp
  char *path;
  struct inode *ip;

  begin_op();
ffff800000109a0c:	b8 00 00 00 00       	mov    $0x0,%eax
ffff800000109a11:	48 ba 79 4f 10 00 00 	movabs $0xffff800000104f79,%rdx
ffff800000109a18:	80 ff ff 
ffff800000109a1b:	ff d2                	callq  *%rdx
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
ffff800000109a1d:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
ffff800000109a21:	48 89 c6             	mov    %rax,%rsi
ffff800000109a24:	bf 00 00 00 00       	mov    $0x0,%edi
ffff800000109a29:	48 b8 53 89 10 00 00 	movabs $0xffff800000108953,%rax
ffff800000109a30:	80 ff ff 
ffff800000109a33:	ff d0                	callq  *%rax
ffff800000109a35:	85 c0                	test   %eax,%eax
ffff800000109a37:	78 1e                	js     ffff800000109a57 <sys_chdir+0x57>
ffff800000109a39:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff800000109a3d:	48 89 c7             	mov    %rax,%rdi
ffff800000109a40:	48 b8 ff 37 10 00 00 	movabs $0xffff8000001037ff,%rax
ffff800000109a47:	80 ff ff 
ffff800000109a4a:	ff d0                	callq  *%rax
ffff800000109a4c:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
ffff800000109a50:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
ffff800000109a55:	75 1b                	jne    ffff800000109a72 <sys_chdir+0x72>
    end_op();
ffff800000109a57:	b8 00 00 00 00       	mov    $0x0,%eax
ffff800000109a5c:	48 ba 53 50 10 00 00 	movabs $0xffff800000105053,%rdx
ffff800000109a63:	80 ff ff 
ffff800000109a66:	ff d2                	callq  *%rdx
    return -1;
ffff800000109a68:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
ffff800000109a6d:	e9 af 00 00 00       	jmpq   ffff800000109b21 <sys_chdir+0x121>
  }
  ilock(ip);
ffff800000109a72:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000109a76:	48 89 c7             	mov    %rax,%rdi
ffff800000109a79:	48 b8 e8 28 10 00 00 	movabs $0xffff8000001028e8,%rax
ffff800000109a80:	80 ff ff 
ffff800000109a83:	ff d0                	callq  *%rax
  if(ip->type != T_DIR){
ffff800000109a85:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000109a89:	0f b7 80 94 00 00 00 	movzwl 0x94(%rax),%eax
ffff800000109a90:	66 83 f8 01          	cmp    $0x1,%ax
ffff800000109a94:	74 2b                	je     ffff800000109ac1 <sys_chdir+0xc1>
    iunlockput(ip);
ffff800000109a96:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000109a9a:	48 89 c7             	mov    %rax,%rdi
ffff800000109a9d:	48 b8 d8 2b 10 00 00 	movabs $0xffff800000102bd8,%rax
ffff800000109aa4:	80 ff ff 
ffff800000109aa7:	ff d0                	callq  *%rax
    end_op();
ffff800000109aa9:	b8 00 00 00 00       	mov    $0x0,%eax
ffff800000109aae:	48 ba 53 50 10 00 00 	movabs $0xffff800000105053,%rdx
ffff800000109ab5:	80 ff ff 
ffff800000109ab8:	ff d2                	callq  *%rdx
    return -1;
ffff800000109aba:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
ffff800000109abf:	eb 60                	jmp    ffff800000109b21 <sys_chdir+0x121>
  }
  iunlock(ip);
ffff800000109ac1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000109ac5:	48 89 c7             	mov    %rax,%rdi
ffff800000109ac8:	48 b8 7d 2a 10 00 00 	movabs $0xffff800000102a7d,%rax
ffff800000109acf:	80 ff ff 
ffff800000109ad2:	ff d0                	callq  *%rax
  iput(proc->cwd);
ffff800000109ad4:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffff800000109adb:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffff800000109adf:	48 8b 80 c8 00 00 00 	mov    0xc8(%rax),%rax
ffff800000109ae6:	48 89 c7             	mov    %rax,%rdi
ffff800000109ae9:	48 b8 ea 2a 10 00 00 	movabs $0xffff800000102aea,%rax
ffff800000109af0:	80 ff ff 
ffff800000109af3:	ff d0                	callq  *%rax
  end_op();
ffff800000109af5:	b8 00 00 00 00       	mov    $0x0,%eax
ffff800000109afa:	48 ba 53 50 10 00 00 	movabs $0xffff800000105053,%rdx
ffff800000109b01:	80 ff ff 
ffff800000109b04:	ff d2                	callq  *%rdx
  proc->cwd = ip;
ffff800000109b06:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffff800000109b0d:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffff800000109b11:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
ffff800000109b15:	48 89 90 c8 00 00 00 	mov    %rdx,0xc8(%rax)
  return 0;
ffff800000109b1c:	b8 00 00 00 00       	mov    $0x0,%eax
}
ffff800000109b21:	c9                   	leaveq 
ffff800000109b22:	c3                   	retq   

ffff800000109b23 <sys_exec>:

int
sys_exec(void)
{
ffff800000109b23:	f3 0f 1e fa          	endbr64 
ffff800000109b27:	55                   	push   %rbp
ffff800000109b28:	48 89 e5             	mov    %rsp,%rbp
ffff800000109b2b:	48 81 ec 20 01 00 00 	sub    $0x120,%rsp
  char *path, *argv[MAXARG];
  int i;
  addr_t uargv, uarg;

  if(argstr(0, &path) < 0 || argaddr(1, &uargv) < 0){
ffff800000109b32:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
ffff800000109b36:	48 89 c6             	mov    %rax,%rsi
ffff800000109b39:	bf 00 00 00 00       	mov    $0x0,%edi
ffff800000109b3e:	48 b8 53 89 10 00 00 	movabs $0xffff800000108953,%rax
ffff800000109b45:	80 ff ff 
ffff800000109b48:	ff d0                	callq  *%rax
ffff800000109b4a:	85 c0                	test   %eax,%eax
ffff800000109b4c:	78 1f                	js     ffff800000109b6d <sys_exec+0x4a>
ffff800000109b4e:	48 8d 85 e8 fe ff ff 	lea    -0x118(%rbp),%rax
ffff800000109b55:	48 89 c6             	mov    %rax,%rsi
ffff800000109b58:	bf 01 00 00 00       	mov    $0x1,%edi
ffff800000109b5d:	48 b8 8d 88 10 00 00 	movabs $0xffff80000010888d,%rax
ffff800000109b64:	80 ff ff 
ffff800000109b67:	ff d0                	callq  *%rax
ffff800000109b69:	85 c0                	test   %eax,%eax
ffff800000109b6b:	79 0a                	jns    ffff800000109b77 <sys_exec+0x54>
    return -1;
ffff800000109b6d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
ffff800000109b72:	e9 f2 00 00 00       	jmpq   ffff800000109c69 <sys_exec+0x146>
  }
  memset(argv, 0, sizeof(argv));
ffff800000109b77:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
ffff800000109b7e:	ba 00 01 00 00       	mov    $0x100,%edx
ffff800000109b83:	be 00 00 00 00       	mov    $0x0,%esi
ffff800000109b88:	48 89 c7             	mov    %rax,%rdi
ffff800000109b8b:	48 b8 bd 82 10 00 00 	movabs $0xffff8000001082bd,%rax
ffff800000109b92:	80 ff ff 
ffff800000109b95:	ff d0                	callq  *%rax
  for(i=0;; i++){
ffff800000109b97:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
    if(i >= NELEM(argv))
ffff800000109b9e:	8b 45 fc             	mov    -0x4(%rbp),%eax
ffff800000109ba1:	83 f8 1f             	cmp    $0x1f,%eax
ffff800000109ba4:	76 0a                	jbe    ffff800000109bb0 <sys_exec+0x8d>
      return -1;
ffff800000109ba6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
ffff800000109bab:	e9 b9 00 00 00       	jmpq   ffff800000109c69 <sys_exec+0x146>
    if(fetchaddr(uargv+(sizeof(addr_t))*i, (addr_t*)&uarg) < 0)
ffff800000109bb0:	8b 45 fc             	mov    -0x4(%rbp),%eax
ffff800000109bb3:	48 98                	cltq   
ffff800000109bb5:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
ffff800000109bbc:	00 
ffff800000109bbd:	48 8b 85 e8 fe ff ff 	mov    -0x118(%rbp),%rax
ffff800000109bc4:	48 01 c2             	add    %rax,%rdx
ffff800000109bc7:	48 8d 85 e0 fe ff ff 	lea    -0x120(%rbp),%rax
ffff800000109bce:	48 89 c6             	mov    %rax,%rsi
ffff800000109bd1:	48 89 d7             	mov    %rdx,%rdi
ffff800000109bd4:	48 b8 a1 86 10 00 00 	movabs $0xffff8000001086a1,%rax
ffff800000109bdb:	80 ff ff 
ffff800000109bde:	ff d0                	callq  *%rax
ffff800000109be0:	85 c0                	test   %eax,%eax
ffff800000109be2:	79 07                	jns    ffff800000109beb <sys_exec+0xc8>
      return -1;
ffff800000109be4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
ffff800000109be9:	eb 7e                	jmp    ffff800000109c69 <sys_exec+0x146>
    if(uarg == 0){
ffff800000109beb:	48 8b 85 e0 fe ff ff 	mov    -0x120(%rbp),%rax
ffff800000109bf2:	48 85 c0             	test   %rax,%rax
ffff800000109bf5:	75 31                	jne    ffff800000109c28 <sys_exec+0x105>
      argv[i] = 0;
ffff800000109bf7:	8b 45 fc             	mov    -0x4(%rbp),%eax
ffff800000109bfa:	48 98                	cltq   
ffff800000109bfc:	48 c7 84 c5 f0 fe ff 	movq   $0x0,-0x110(%rbp,%rax,8)
ffff800000109c03:	ff 00 00 00 00 
      break;
ffff800000109c08:	90                   	nop
    }
    if(fetchstr(uarg, &argv[i]) < 0)
      return -1;
  }
  return exec(path, argv);
ffff800000109c09:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff800000109c0d:	48 8d 95 f0 fe ff ff 	lea    -0x110(%rbp),%rdx
ffff800000109c14:	48 89 d6             	mov    %rdx,%rsi
ffff800000109c17:	48 89 c7             	mov    %rax,%rdi
ffff800000109c1a:	48 b8 3d 15 10 00 00 	movabs $0xffff80000010153d,%rax
ffff800000109c21:	80 ff ff 
ffff800000109c24:	ff d0                	callq  *%rax
ffff800000109c26:	eb 41                	jmp    ffff800000109c69 <sys_exec+0x146>
    if(fetchstr(uarg, &argv[i]) < 0)
ffff800000109c28:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
ffff800000109c2f:	8b 55 fc             	mov    -0x4(%rbp),%edx
ffff800000109c32:	48 63 d2             	movslq %edx,%rdx
ffff800000109c35:	48 c1 e2 03          	shl    $0x3,%rdx
ffff800000109c39:	48 01 c2             	add    %rax,%rdx
ffff800000109c3c:	48 8b 85 e0 fe ff ff 	mov    -0x120(%rbp),%rax
ffff800000109c43:	48 89 d6             	mov    %rdx,%rsi
ffff800000109c46:	48 89 c7             	mov    %rax,%rdi
ffff800000109c49:	48 b8 00 87 10 00 00 	movabs $0xffff800000108700,%rax
ffff800000109c50:	80 ff ff 
ffff800000109c53:	ff d0                	callq  *%rax
ffff800000109c55:	85 c0                	test   %eax,%eax
ffff800000109c57:	79 07                	jns    ffff800000109c60 <sys_exec+0x13d>
      return -1;
ffff800000109c59:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
ffff800000109c5e:	eb 09                	jmp    ffff800000109c69 <sys_exec+0x146>
  for(i=0;; i++){
ffff800000109c60:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
    if(i >= NELEM(argv))
ffff800000109c64:	e9 35 ff ff ff       	jmpq   ffff800000109b9e <sys_exec+0x7b>
}
ffff800000109c69:	c9                   	leaveq 
ffff800000109c6a:	c3                   	retq   

ffff800000109c6b <sys_pipe>:

int
sys_pipe(void)
{
ffff800000109c6b:	f3 0f 1e fa          	endbr64 
ffff800000109c6f:	55                   	push   %rbp
ffff800000109c70:	48 89 e5             	mov    %rsp,%rbp
ffff800000109c73:	48 83 ec 20          	sub    $0x20,%rsp
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
ffff800000109c77:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
ffff800000109c7b:	ba 08 00 00 00       	mov    $0x8,%edx
ffff800000109c80:	48 89 c6             	mov    %rax,%rsi
ffff800000109c83:	bf 00 00 00 00       	mov    $0x0,%edi
ffff800000109c88:	48 b8 bf 88 10 00 00 	movabs $0xffff8000001088bf,%rax
ffff800000109c8f:	80 ff ff 
ffff800000109c92:	ff d0                	callq  *%rax
ffff800000109c94:	85 c0                	test   %eax,%eax
ffff800000109c96:	79 0a                	jns    ffff800000109ca2 <sys_pipe+0x37>
    return -1;
ffff800000109c98:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
ffff800000109c9d:	e9 d3 00 00 00       	jmpq   ffff800000109d75 <sys_pipe+0x10a>
  if(pipealloc(&rf, &wf) < 0)
ffff800000109ca2:	48 8d 55 e0          	lea    -0x20(%rbp),%rdx
ffff800000109ca6:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
ffff800000109caa:	48 89 d6             	mov    %rdx,%rsi
ffff800000109cad:	48 89 c7             	mov    %rax,%rdi
ffff800000109cb0:	48 b8 d2 5c 10 00 00 	movabs $0xffff800000105cd2,%rax
ffff800000109cb7:	80 ff ff 
ffff800000109cba:	ff d0                	callq  *%rax
ffff800000109cbc:	85 c0                	test   %eax,%eax
ffff800000109cbe:	79 0a                	jns    ffff800000109cca <sys_pipe+0x5f>
    return -1;
ffff800000109cc0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
ffff800000109cc5:	e9 ab 00 00 00       	jmpq   ffff800000109d75 <sys_pipe+0x10a>
  fd0 = -1;
ffff800000109cca:	c7 45 fc ff ff ff ff 	movl   $0xffffffff,-0x4(%rbp)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
ffff800000109cd1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000109cd5:	48 89 c7             	mov    %rax,%rdi
ffff800000109cd8:	48 b8 51 8b 10 00 00 	movabs $0xffff800000108b51,%rax
ffff800000109cdf:	80 ff ff 
ffff800000109ce2:	ff d0                	callq  *%rax
ffff800000109ce4:	89 45 fc             	mov    %eax,-0x4(%rbp)
ffff800000109ce7:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
ffff800000109ceb:	78 1c                	js     ffff800000109d09 <sys_pipe+0x9e>
ffff800000109ced:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
ffff800000109cf1:	48 89 c7             	mov    %rax,%rdi
ffff800000109cf4:	48 b8 51 8b 10 00 00 	movabs $0xffff800000108b51,%rax
ffff800000109cfb:	80 ff ff 
ffff800000109cfe:	ff d0                	callq  *%rax
ffff800000109d00:	89 45 f8             	mov    %eax,-0x8(%rbp)
ffff800000109d03:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
ffff800000109d07:	79 51                	jns    ffff800000109d5a <sys_pipe+0xef>
    if(fd0 >= 0)
ffff800000109d09:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
ffff800000109d0d:	78 1e                	js     ffff800000109d2d <sys_pipe+0xc2>
      proc->ofile[fd0] = 0;
ffff800000109d0f:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffff800000109d16:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffff800000109d1a:	8b 55 fc             	mov    -0x4(%rbp),%edx
ffff800000109d1d:	48 63 d2             	movslq %edx,%rdx
ffff800000109d20:	48 83 c2 08          	add    $0x8,%rdx
ffff800000109d24:	48 c7 44 d0 08 00 00 	movq   $0x0,0x8(%rax,%rdx,8)
ffff800000109d2b:	00 00 
    fileclose(rf);
ffff800000109d2d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000109d31:	48 89 c7             	mov    %rax,%rdi
ffff800000109d34:	48 b8 8e 1c 10 00 00 	movabs $0xffff800000101c8e,%rax
ffff800000109d3b:	80 ff ff 
ffff800000109d3e:	ff d0                	callq  *%rax
    fileclose(wf);
ffff800000109d40:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
ffff800000109d44:	48 89 c7             	mov    %rax,%rdi
ffff800000109d47:	48 b8 8e 1c 10 00 00 	movabs $0xffff800000101c8e,%rax
ffff800000109d4e:	80 ff ff 
ffff800000109d51:	ff d0                	callq  *%rax
    return -1;
ffff800000109d53:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
ffff800000109d58:	eb 1b                	jmp    ffff800000109d75 <sys_pipe+0x10a>
  }
  fd[0] = fd0;
ffff800000109d5a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff800000109d5e:	8b 55 fc             	mov    -0x4(%rbp),%edx
ffff800000109d61:	89 10                	mov    %edx,(%rax)
  fd[1] = fd1;
ffff800000109d63:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff800000109d67:	48 8d 50 04          	lea    0x4(%rax),%rdx
ffff800000109d6b:	8b 45 f8             	mov    -0x8(%rbp),%eax
ffff800000109d6e:	89 02                	mov    %eax,(%rdx)
  return 0;
ffff800000109d70:	b8 00 00 00 00       	mov    $0x0,%eax
}
ffff800000109d75:	c9                   	leaveq 
ffff800000109d76:	c3                   	retq   

ffff800000109d77 <sys_fork>:
#include "mmu.h"
#include "proc.h"

int
sys_fork(void)
{
ffff800000109d77:	f3 0f 1e fa          	endbr64 
ffff800000109d7b:	55                   	push   %rbp
ffff800000109d7c:	48 89 e5             	mov    %rsp,%rbp
  return fork();
ffff800000109d7f:	48 b8 01 66 10 00 00 	movabs $0xffff800000106601,%rax
ffff800000109d86:	80 ff ff 
ffff800000109d89:	ff d0                	callq  *%rax
}
ffff800000109d8b:	5d                   	pop    %rbp
ffff800000109d8c:	c3                   	retq   

ffff800000109d8d <sys_exit>:

int
sys_exit(void)
{
ffff800000109d8d:	f3 0f 1e fa          	endbr64 
ffff800000109d91:	55                   	push   %rbp
ffff800000109d92:	48 89 e5             	mov    %rsp,%rbp
  exit();
ffff800000109d95:	48 b8 bb 68 10 00 00 	movabs $0xffff8000001068bb,%rax
ffff800000109d9c:	80 ff ff 
ffff800000109d9f:	ff d0                	callq  *%rax
  return 0;  // not reached
ffff800000109da1:	b8 00 00 00 00       	mov    $0x0,%eax
}
ffff800000109da6:	5d                   	pop    %rbp
ffff800000109da7:	c3                   	retq   

ffff800000109da8 <sys_wait>:

int
sys_wait(void)
{
ffff800000109da8:	f3 0f 1e fa          	endbr64 
ffff800000109dac:	55                   	push   %rbp
ffff800000109dad:	48 89 e5             	mov    %rsp,%rbp
  return wait();
ffff800000109db0:	48 b8 b1 6a 10 00 00 	movabs $0xffff800000106ab1,%rax
ffff800000109db7:	80 ff ff 
ffff800000109dba:	ff d0                	callq  *%rax
}
ffff800000109dbc:	5d                   	pop    %rbp
ffff800000109dbd:	c3                   	retq   

ffff800000109dbe <sys_kill>:

int
sys_kill(void)
{
ffff800000109dbe:	f3 0f 1e fa          	endbr64 
ffff800000109dc2:	55                   	push   %rbp
ffff800000109dc3:	48 89 e5             	mov    %rsp,%rbp
ffff800000109dc6:	48 83 ec 10          	sub    $0x10,%rsp
  int pid;

  if(argint(0, &pid) < 0)
ffff800000109dca:	48 8d 45 fc          	lea    -0x4(%rbp),%rax
ffff800000109dce:	48 89 c6             	mov    %rax,%rsi
ffff800000109dd1:	bf 00 00 00 00       	mov    $0x0,%edi
ffff800000109dd6:	48 b8 5a 88 10 00 00 	movabs $0xffff80000010885a,%rax
ffff800000109ddd:	80 ff ff 
ffff800000109de0:	ff d0                	callq  *%rax
ffff800000109de2:	85 c0                	test   %eax,%eax
ffff800000109de4:	79 07                	jns    ffff800000109ded <sys_kill+0x2f>
    return -1;
ffff800000109de6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
ffff800000109deb:	eb 11                	jmp    ffff800000109dfe <sys_kill+0x40>
  return kill(pid);
ffff800000109ded:	8b 45 fc             	mov    -0x4(%rbp),%eax
ffff800000109df0:	89 c7                	mov    %eax,%edi
ffff800000109df2:	48 b8 80 71 10 00 00 	movabs $0xffff800000107180,%rax
ffff800000109df9:	80 ff ff 
ffff800000109dfc:	ff d0                	callq  *%rax
}
ffff800000109dfe:	c9                   	leaveq 
ffff800000109dff:	c3                   	retq   

ffff800000109e00 <sys_getpid>:

int
sys_getpid(void)
{
ffff800000109e00:	f3 0f 1e fa          	endbr64 
ffff800000109e04:	55                   	push   %rbp
ffff800000109e05:	48 89 e5             	mov    %rsp,%rbp
  return proc->pid;
ffff800000109e08:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffff800000109e0f:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffff800000109e13:	8b 40 1c             	mov    0x1c(%rax),%eax
}
ffff800000109e16:	5d                   	pop    %rbp
ffff800000109e17:	c3                   	retq   

ffff800000109e18 <sys_sbrk>:

addr_t
sys_sbrk(void)
{
ffff800000109e18:	f3 0f 1e fa          	endbr64 
ffff800000109e1c:	55                   	push   %rbp
ffff800000109e1d:	48 89 e5             	mov    %rsp,%rbp
ffff800000109e20:	48 83 ec 10          	sub    $0x10,%rsp
  addr_t addr;
  addr_t n;

  argaddr(0, &n);
ffff800000109e24:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
ffff800000109e28:	48 89 c6             	mov    %rax,%rsi
ffff800000109e2b:	bf 00 00 00 00       	mov    $0x0,%edi
ffff800000109e30:	48 b8 8d 88 10 00 00 	movabs $0xffff80000010888d,%rax
ffff800000109e37:	80 ff ff 
ffff800000109e3a:	ff d0                	callq  *%rax
  addr = proc->sz;
ffff800000109e3c:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffff800000109e43:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffff800000109e47:	48 8b 00             	mov    (%rax),%rax
ffff800000109e4a:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  if(growproc(n) < 0)
ffff800000109e4e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff800000109e52:	48 89 c7             	mov    %rax,%rdi
ffff800000109e55:	48 b8 1a 65 10 00 00 	movabs $0xffff80000010651a,%rax
ffff800000109e5c:	80 ff ff 
ffff800000109e5f:	ff d0                	callq  *%rax
ffff800000109e61:	85 c0                	test   %eax,%eax
ffff800000109e63:	79 09                	jns    ffff800000109e6e <sys_sbrk+0x56>
    return -1;
ffff800000109e65:	48 c7 c0 ff ff ff ff 	mov    $0xffffffffffffffff,%rax
ffff800000109e6c:	eb 04                	jmp    ffff800000109e72 <sys_sbrk+0x5a>
  return addr;
ffff800000109e6e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
ffff800000109e72:	c9                   	leaveq 
ffff800000109e73:	c3                   	retq   

ffff800000109e74 <sys_sleep>:

int
sys_sleep(void)
{
ffff800000109e74:	f3 0f 1e fa          	endbr64 
ffff800000109e78:	55                   	push   %rbp
ffff800000109e79:	48 89 e5             	mov    %rsp,%rbp
ffff800000109e7c:	48 83 ec 10          	sub    $0x10,%rsp
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
ffff800000109e80:	48 8d 45 f8          	lea    -0x8(%rbp),%rax
ffff800000109e84:	48 89 c6             	mov    %rax,%rsi
ffff800000109e87:	bf 00 00 00 00       	mov    $0x0,%edi
ffff800000109e8c:	48 b8 5a 88 10 00 00 	movabs $0xffff80000010885a,%rax
ffff800000109e93:	80 ff ff 
ffff800000109e96:	ff d0                	callq  *%rax
ffff800000109e98:	85 c0                	test   %eax,%eax
ffff800000109e9a:	79 0a                	jns    ffff800000109ea6 <sys_sleep+0x32>
    return -1;
ffff800000109e9c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
ffff800000109ea1:	e9 a7 00 00 00       	jmpq   ffff800000109f4d <sys_sleep+0xd9>
  acquire(&tickslock);
ffff800000109ea6:	48 bf 80 c9 11 00 00 	movabs $0xffff80000011c980,%rdi
ffff800000109ead:	80 ff ff 
ffff800000109eb0:	48 b8 17 7f 10 00 00 	movabs $0xffff800000107f17,%rax
ffff800000109eb7:	80 ff ff 
ffff800000109eba:	ff d0                	callq  *%rax
  ticks0 = ticks;
ffff800000109ebc:	48 b8 e8 c9 11 00 00 	movabs $0xffff80000011c9e8,%rax
ffff800000109ec3:	80 ff ff 
ffff800000109ec6:	8b 00                	mov    (%rax),%eax
ffff800000109ec8:	89 45 fc             	mov    %eax,-0x4(%rbp)
  while(ticks - ticks0 < n){
ffff800000109ecb:	eb 4f                	jmp    ffff800000109f1c <sys_sleep+0xa8>
    if(proc->killed){
ffff800000109ecd:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffff800000109ed4:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffff800000109ed8:	8b 40 40             	mov    0x40(%rax),%eax
ffff800000109edb:	85 c0                	test   %eax,%eax
ffff800000109edd:	74 1d                	je     ffff800000109efc <sys_sleep+0x88>
      release(&tickslock);
ffff800000109edf:	48 bf 80 c9 11 00 00 	movabs $0xffff80000011c980,%rdi
ffff800000109ee6:	80 ff ff 
ffff800000109ee9:	48 b8 b4 7f 10 00 00 	movabs $0xffff800000107fb4,%rax
ffff800000109ef0:	80 ff ff 
ffff800000109ef3:	ff d0                	callq  *%rax
      return -1;
ffff800000109ef5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
ffff800000109efa:	eb 51                	jmp    ffff800000109f4d <sys_sleep+0xd9>
    }
    sleep(&ticks, &tickslock);
ffff800000109efc:	48 be 80 c9 11 00 00 	movabs $0xffff80000011c980,%rsi
ffff800000109f03:	80 ff ff 
ffff800000109f06:	48 bf e8 c9 11 00 00 	movabs $0xffff80000011c9e8,%rdi
ffff800000109f0d:	80 ff ff 
ffff800000109f10:	48 b8 bd 6f 10 00 00 	movabs $0xffff800000106fbd,%rax
ffff800000109f17:	80 ff ff 
ffff800000109f1a:	ff d0                	callq  *%rax
  while(ticks - ticks0 < n){
ffff800000109f1c:	48 b8 e8 c9 11 00 00 	movabs $0xffff80000011c9e8,%rax
ffff800000109f23:	80 ff ff 
ffff800000109f26:	8b 00                	mov    (%rax),%eax
ffff800000109f28:	2b 45 fc             	sub    -0x4(%rbp),%eax
ffff800000109f2b:	8b 55 f8             	mov    -0x8(%rbp),%edx
ffff800000109f2e:	39 d0                	cmp    %edx,%eax
ffff800000109f30:	72 9b                	jb     ffff800000109ecd <sys_sleep+0x59>
  }
  release(&tickslock);
ffff800000109f32:	48 bf 80 c9 11 00 00 	movabs $0xffff80000011c980,%rdi
ffff800000109f39:	80 ff ff 
ffff800000109f3c:	48 b8 b4 7f 10 00 00 	movabs $0xffff800000107fb4,%rax
ffff800000109f43:	80 ff ff 
ffff800000109f46:	ff d0                	callq  *%rax
  return 0;
ffff800000109f48:	b8 00 00 00 00       	mov    $0x0,%eax
}
ffff800000109f4d:	c9                   	leaveq 
ffff800000109f4e:	c3                   	retq   

ffff800000109f4f <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
ffff800000109f4f:	f3 0f 1e fa          	endbr64 
ffff800000109f53:	55                   	push   %rbp
ffff800000109f54:	48 89 e5             	mov    %rsp,%rbp
ffff800000109f57:	48 83 ec 10          	sub    $0x10,%rsp
  uint xticks;

  acquire(&tickslock);
ffff800000109f5b:	48 bf 80 c9 11 00 00 	movabs $0xffff80000011c980,%rdi
ffff800000109f62:	80 ff ff 
ffff800000109f65:	48 b8 17 7f 10 00 00 	movabs $0xffff800000107f17,%rax
ffff800000109f6c:	80 ff ff 
ffff800000109f6f:	ff d0                	callq  *%rax
  xticks = ticks;
ffff800000109f71:	48 b8 e8 c9 11 00 00 	movabs $0xffff80000011c9e8,%rax
ffff800000109f78:	80 ff ff 
ffff800000109f7b:	8b 00                	mov    (%rax),%eax
ffff800000109f7d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  release(&tickslock);
ffff800000109f80:	48 bf 80 c9 11 00 00 	movabs $0xffff80000011c980,%rdi
ffff800000109f87:	80 ff ff 
ffff800000109f8a:	48 b8 b4 7f 10 00 00 	movabs $0xffff800000107fb4,%rax
ffff800000109f91:	80 ff ff 
ffff800000109f94:	ff d0                	callq  *%rax
  return xticks;
ffff800000109f96:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
ffff800000109f99:	c9                   	leaveq 
ffff800000109f9a:	c3                   	retq   

ffff800000109f9b <alltraps>:
# vectors.S sends all traps here.
.global alltraps
alltraps:
  # Build trap frame.
  pushq   %r15
ffff800000109f9b:	41 57                	push   %r15
  pushq   %r14
ffff800000109f9d:	41 56                	push   %r14
  pushq   %r13
ffff800000109f9f:	41 55                	push   %r13
  pushq   %r12
ffff800000109fa1:	41 54                	push   %r12
  pushq   %r11
ffff800000109fa3:	41 53                	push   %r11
  pushq   %r10
ffff800000109fa5:	41 52                	push   %r10
  pushq   %r9
ffff800000109fa7:	41 51                	push   %r9
  pushq   %r8
ffff800000109fa9:	41 50                	push   %r8
  pushq   %rdi
ffff800000109fab:	57                   	push   %rdi
  pushq   %rsi
ffff800000109fac:	56                   	push   %rsi
  pushq   %rbp
ffff800000109fad:	55                   	push   %rbp
  pushq   %rdx
ffff800000109fae:	52                   	push   %rdx
  pushq   %rcx
ffff800000109faf:	51                   	push   %rcx
  pushq   %rbx
ffff800000109fb0:	53                   	push   %rbx
  pushq   %rax
ffff800000109fb1:	50                   	push   %rax

  movq    %rsp, %rdi  # frame in arg1
ffff800000109fb2:	48 89 e7             	mov    %rsp,%rdi
  callq   trap
ffff800000109fb5:	e8 8d 02 00 00       	callq  ffff80000010a247 <trap>

ffff800000109fba <trapret>:
# Return falls through to trapret...

.global trapret
trapret:
  popq    %rax
ffff800000109fba:	58                   	pop    %rax
  popq    %rbx
ffff800000109fbb:	5b                   	pop    %rbx
  popq    %rcx
ffff800000109fbc:	59                   	pop    %rcx
  popq    %rdx
ffff800000109fbd:	5a                   	pop    %rdx
  popq    %rbp
ffff800000109fbe:	5d                   	pop    %rbp
  popq    %rsi
ffff800000109fbf:	5e                   	pop    %rsi
  popq    %rdi
ffff800000109fc0:	5f                   	pop    %rdi
  popq    %r8
ffff800000109fc1:	41 58                	pop    %r8
  popq    %r9
ffff800000109fc3:	41 59                	pop    %r9
  popq    %r10
ffff800000109fc5:	41 5a                	pop    %r10
  popq    %r11
ffff800000109fc7:	41 5b                	pop    %r11
  popq    %r12
ffff800000109fc9:	41 5c                	pop    %r12
  popq    %r13
ffff800000109fcb:	41 5d                	pop    %r13
  popq    %r14
ffff800000109fcd:	41 5e                	pop    %r14
  popq    %r15
ffff800000109fcf:	41 5f                	pop    %r15

  addq    $16, %rsp  # discard trapnum and errorcode
ffff800000109fd1:	48 83 c4 10          	add    $0x10,%rsp
  iretq
ffff800000109fd5:	48 cf                	iretq  

ffff800000109fd7 <syscall_entry>:
.global syscall_entry
syscall_entry:
  # switch to kernel stack. With the syscall instruction,
  # this is a kernel resposibility
  # store %rsp on the top of proc->kstack,
  movq    %rax, %fs:(0)      # save %rax above __thread vars
ffff800000109fd7:	64 48 89 04 25 00 00 	mov    %rax,%fs:0x0
ffff800000109fde:	00 00 
  movq    %fs:(-8), %rax     # %fs:(-8) is proc (the last __thread)
ffff800000109fe0:	64 48 8b 04 25 f8 ff 	mov    %fs:0xfffffffffffffff8,%rax
ffff800000109fe7:	ff ff 
  movq    0x10(%rax), %rax   # get proc->kstack (see struct proc)
ffff800000109fe9:	48 8b 40 10          	mov    0x10(%rax),%rax
  addq    $(4096-16), %rax   # %rax points to tf->rsp
ffff800000109fed:	48 05 f0 0f 00 00    	add    $0xff0,%rax
  movq    %rsp, (%rax)       # save user rsp to tf->rsp
ffff800000109ff3:	48 89 20             	mov    %rsp,(%rax)
  movq    %rax, %rsp         # switch to the kstack
ffff800000109ff6:	48 89 c4             	mov    %rax,%rsp
  movq    %fs:(0), %rax      # restore %rax
ffff800000109ff9:	64 48 8b 04 25 00 00 	mov    %fs:0x0,%rax
ffff80000010a000:	00 00 

  pushq   %r11         # rflags
ffff80000010a002:	41 53                	push   %r11
  pushq   $0           # cs is ignored
ffff80000010a004:	6a 00                	pushq  $0x0
  pushq   %rcx         # rip (next user insn)
ffff80000010a006:	51                   	push   %rcx

  pushq   $0           # err
ffff80000010a007:	6a 00                	pushq  $0x0
  pushq   $0           # trapno ignored
ffff80000010a009:	6a 00                	pushq  $0x0

  pushq   %r15
ffff80000010a00b:	41 57                	push   %r15
  pushq   %r14
ffff80000010a00d:	41 56                	push   %r14
  pushq   %r13
ffff80000010a00f:	41 55                	push   %r13
  pushq   %r12
ffff80000010a011:	41 54                	push   %r12
  pushq   %r11
ffff80000010a013:	41 53                	push   %r11
  pushq   %r10
ffff80000010a015:	41 52                	push   %r10
  pushq   %r9
ffff80000010a017:	41 51                	push   %r9
  pushq   %r8
ffff80000010a019:	41 50                	push   %r8
  pushq   %rdi
ffff80000010a01b:	57                   	push   %rdi
  pushq   %rsi
ffff80000010a01c:	56                   	push   %rsi
  pushq   %rbp
ffff80000010a01d:	55                   	push   %rbp
  pushq   %rdx
ffff80000010a01e:	52                   	push   %rdx
  pushq   %rcx
ffff80000010a01f:	51                   	push   %rcx
  pushq   %rbx
ffff80000010a020:	53                   	push   %rbx
  pushq   %rax
ffff80000010a021:	50                   	push   %rax

  movq    %rsp, %rdi  # frame in arg1
ffff80000010a022:	48 89 e7             	mov    %rsp,%rdi
  callq   syscall
ffff80000010a025:	e8 7c e9 ff ff       	callq  ffff8000001089a6 <syscall>

ffff80000010a02a <syscall_trapret>:
# Return falls through to syscall_trapret...
#PAGEBREAK!

.global syscall_trapret
syscall_trapret:
  popq    %rax
ffff80000010a02a:	58                   	pop    %rax
  popq    %rbx
ffff80000010a02b:	5b                   	pop    %rbx
  popq    %rcx
ffff80000010a02c:	59                   	pop    %rcx
  popq    %rdx
ffff80000010a02d:	5a                   	pop    %rdx
  popq    %rbp
ffff80000010a02e:	5d                   	pop    %rbp
  popq    %rsi
ffff80000010a02f:	5e                   	pop    %rsi
  popq    %rdi
ffff80000010a030:	5f                   	pop    %rdi
  popq    %r8
ffff80000010a031:	41 58                	pop    %r8
  popq    %r9
ffff80000010a033:	41 59                	pop    %r9
  popq    %r10
ffff80000010a035:	41 5a                	pop    %r10
  popq    %r11
ffff80000010a037:	41 5b                	pop    %r11
  popq    %r12
ffff80000010a039:	41 5c                	pop    %r12
  popq    %r13
ffff80000010a03b:	41 5d                	pop    %r13
  popq    %r14
ffff80000010a03d:	41 5e                	pop    %r14
  popq    %r15
ffff80000010a03f:	41 5f                	pop    %r15

  addq    $40, %rsp  # discard trapnum, errorcode, rip, cs and rflags
ffff80000010a041:	48 83 c4 28          	add    $0x28,%rsp

  # to make sure we don't get any interrupts on the user stack while in
  # supervisor mode. this is actually slightly unsafe still,
  # since some interrupts are nonmaskable.
  # See https://www.felixcloutier.com/x86/sysret
  cli
ffff80000010a045:	fa                   	cli    
  movq    (%rsp), %rsp  # restore the user stack
ffff80000010a046:	48 8b 24 24          	mov    (%rsp),%rsp
  sysretq
ffff80000010a04a:	48 0f 07             	sysretq 

ffff80000010a04d <lidt>:
{
ffff80000010a04d:	f3 0f 1e fa          	endbr64 
ffff80000010a051:	55                   	push   %rbp
ffff80000010a052:	48 89 e5             	mov    %rsp,%rbp
ffff80000010a055:	48 83 ec 30          	sub    $0x30,%rsp
ffff80000010a059:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
ffff80000010a05d:	89 75 d4             	mov    %esi,-0x2c(%rbp)
  addr_t addr = (addr_t)p;
ffff80000010a060:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
ffff80000010a064:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  pd[0] = size-1;
ffff80000010a068:	8b 45 d4             	mov    -0x2c(%rbp),%eax
ffff80000010a06b:	83 e8 01             	sub    $0x1,%eax
ffff80000010a06e:	66 89 45 ee          	mov    %ax,-0x12(%rbp)
  pd[1] = addr;
ffff80000010a072:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff80000010a076:	66 89 45 f0          	mov    %ax,-0x10(%rbp)
  pd[2] = addr >> 16;
ffff80000010a07a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff80000010a07e:	48 c1 e8 10          	shr    $0x10,%rax
ffff80000010a082:	66 89 45 f2          	mov    %ax,-0xe(%rbp)
  pd[3] = addr >> 32;
ffff80000010a086:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff80000010a08a:	48 c1 e8 20          	shr    $0x20,%rax
ffff80000010a08e:	66 89 45 f4          	mov    %ax,-0xc(%rbp)
  pd[4] = addr >> 48;
ffff80000010a092:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff80000010a096:	48 c1 e8 30          	shr    $0x30,%rax
ffff80000010a09a:	66 89 45 f6          	mov    %ax,-0xa(%rbp)
  asm volatile("lidt (%0)" : : "r" (pd));
ffff80000010a09e:	48 8d 45 ee          	lea    -0x12(%rbp),%rax
ffff80000010a0a2:	0f 01 18             	lidt   (%rax)
}
ffff80000010a0a5:	90                   	nop
ffff80000010a0a6:	c9                   	leaveq 
ffff80000010a0a7:	c3                   	retq   

ffff80000010a0a8 <rcr2>:

static inline addr_t
rcr2(void)
{
ffff80000010a0a8:	f3 0f 1e fa          	endbr64 
ffff80000010a0ac:	55                   	push   %rbp
ffff80000010a0ad:	48 89 e5             	mov    %rsp,%rbp
ffff80000010a0b0:	48 83 ec 10          	sub    $0x10,%rsp
  addr_t val;
  asm volatile("mov %%cr2,%0" : "=r" (val));
ffff80000010a0b4:	0f 20 d0             	mov    %cr2,%rax
ffff80000010a0b7:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  return val;
ffff80000010a0bb:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
ffff80000010a0bf:	c9                   	leaveq 
ffff80000010a0c0:	c3                   	retq   

ffff80000010a0c1 <mkgate>:
struct spinlock tickslock;
uint ticks;

static void
mkgate(uint *idt, uint n, addr_t kva, uint pl)
{
ffff80000010a0c1:	f3 0f 1e fa          	endbr64 
ffff80000010a0c5:	55                   	push   %rbp
ffff80000010a0c6:	48 89 e5             	mov    %rsp,%rbp
ffff80000010a0c9:	48 83 ec 28          	sub    $0x28,%rsp
ffff80000010a0cd:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
ffff80000010a0d1:	89 75 e4             	mov    %esi,-0x1c(%rbp)
ffff80000010a0d4:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
ffff80000010a0d8:	89 4d e0             	mov    %ecx,-0x20(%rbp)
  uint64 addr = (uint64) kva;
ffff80000010a0db:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
ffff80000010a0df:	48 89 45 f8          	mov    %rax,-0x8(%rbp)

  n *= 4;
ffff80000010a0e3:	c1 65 e4 02          	shll   $0x2,-0x1c(%rbp)
  idt[n+0] = (addr & 0xFFFF) | (KERNEL_CS << 16);
ffff80000010a0e7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff80000010a0eb:	0f b7 d0             	movzwl %ax,%edx
ffff80000010a0ee:	8b 45 e4             	mov    -0x1c(%rbp),%eax
ffff80000010a0f1:	48 8d 0c 85 00 00 00 	lea    0x0(,%rax,4),%rcx
ffff80000010a0f8:	00 
ffff80000010a0f9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff80000010a0fd:	48 01 c8             	add    %rcx,%rax
ffff80000010a100:	81 ca 00 00 08 00    	or     $0x80000,%edx
ffff80000010a106:	89 10                	mov    %edx,(%rax)
  idt[n+1] = (addr & 0xFFFF0000) | 0x8E00 | ((pl & 3) << 13);
ffff80000010a108:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff80000010a10c:	66 b8 00 00          	mov    $0x0,%ax
ffff80000010a110:	89 c2                	mov    %eax,%edx
ffff80000010a112:	8b 45 e0             	mov    -0x20(%rbp),%eax
ffff80000010a115:	c1 e0 0d             	shl    $0xd,%eax
ffff80000010a118:	25 00 60 00 00       	and    $0x6000,%eax
ffff80000010a11d:	09 c2                	or     %eax,%edx
ffff80000010a11f:	8b 45 e4             	mov    -0x1c(%rbp),%eax
ffff80000010a122:	83 c0 01             	add    $0x1,%eax
ffff80000010a125:	89 c0                	mov    %eax,%eax
ffff80000010a127:	48 8d 0c 85 00 00 00 	lea    0x0(,%rax,4),%rcx
ffff80000010a12e:	00 
ffff80000010a12f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff80000010a133:	48 01 c8             	add    %rcx,%rax
ffff80000010a136:	80 ce 8e             	or     $0x8e,%dh
ffff80000010a139:	89 10                	mov    %edx,(%rax)
  idt[n+2] = addr >> 32;
ffff80000010a13b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff80000010a13f:	48 c1 e8 20          	shr    $0x20,%rax
ffff80000010a143:	48 89 c2             	mov    %rax,%rdx
ffff80000010a146:	8b 45 e4             	mov    -0x1c(%rbp),%eax
ffff80000010a149:	83 c0 02             	add    $0x2,%eax
ffff80000010a14c:	89 c0                	mov    %eax,%eax
ffff80000010a14e:	48 8d 0c 85 00 00 00 	lea    0x0(,%rax,4),%rcx
ffff80000010a155:	00 
ffff80000010a156:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff80000010a15a:	48 01 c8             	add    %rcx,%rax
ffff80000010a15d:	89 10                	mov    %edx,(%rax)
  idt[n+3] = 0;
ffff80000010a15f:	8b 45 e4             	mov    -0x1c(%rbp),%eax
ffff80000010a162:	83 c0 03             	add    $0x3,%eax
ffff80000010a165:	89 c0                	mov    %eax,%eax
ffff80000010a167:	48 8d 14 85 00 00 00 	lea    0x0(,%rax,4),%rdx
ffff80000010a16e:	00 
ffff80000010a16f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff80000010a173:	48 01 d0             	add    %rdx,%rax
ffff80000010a176:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
}
ffff80000010a17c:	90                   	nop
ffff80000010a17d:	c9                   	leaveq 
ffff80000010a17e:	c3                   	retq   

ffff80000010a17f <idtinit>:

void idtinit(void)
{
ffff80000010a17f:	f3 0f 1e fa          	endbr64 
ffff80000010a183:	55                   	push   %rbp
ffff80000010a184:	48 89 e5             	mov    %rsp,%rbp
  lidt((void*) idt, PGSIZE);
ffff80000010a187:	48 b8 60 c9 11 00 00 	movabs $0xffff80000011c960,%rax
ffff80000010a18e:	80 ff ff 
ffff80000010a191:	48 8b 00             	mov    (%rax),%rax
ffff80000010a194:	be 00 10 00 00       	mov    $0x1000,%esi
ffff80000010a199:	48 89 c7             	mov    %rax,%rdi
ffff80000010a19c:	48 b8 4d a0 10 00 00 	movabs $0xffff80000010a04d,%rax
ffff80000010a1a3:	80 ff ff 
ffff80000010a1a6:	ff d0                	callq  *%rax
}
ffff80000010a1a8:	90                   	nop
ffff80000010a1a9:	5d                   	pop    %rbp
ffff80000010a1aa:	c3                   	retq   

ffff80000010a1ab <tvinit>:

void tvinit(void)
{
ffff80000010a1ab:	f3 0f 1e fa          	endbr64 
ffff80000010a1af:	55                   	push   %rbp
ffff80000010a1b0:	48 89 e5             	mov    %rsp,%rbp
ffff80000010a1b3:	48 83 ec 10          	sub    $0x10,%rsp
  int n;
  idt = (uint*) kalloc();
ffff80000010a1b7:	48 b8 34 42 10 00 00 	movabs $0xffff800000104234,%rax
ffff80000010a1be:	80 ff ff 
ffff80000010a1c1:	ff d0                	callq  *%rax
ffff80000010a1c3:	48 ba 60 c9 11 00 00 	movabs $0xffff80000011c960,%rdx
ffff80000010a1ca:	80 ff ff 
ffff80000010a1cd:	48 89 02             	mov    %rax,(%rdx)
  memset(idt, 0, PGSIZE);
ffff80000010a1d0:	48 b8 60 c9 11 00 00 	movabs $0xffff80000011c960,%rax
ffff80000010a1d7:	80 ff ff 
ffff80000010a1da:	48 8b 00             	mov    (%rax),%rax
ffff80000010a1dd:	ba 00 10 00 00       	mov    $0x1000,%edx
ffff80000010a1e2:	be 00 00 00 00       	mov    $0x0,%esi
ffff80000010a1e7:	48 89 c7             	mov    %rax,%rdi
ffff80000010a1ea:	48 b8 bd 82 10 00 00 	movabs $0xffff8000001082bd,%rax
ffff80000010a1f1:	80 ff ff 
ffff80000010a1f4:	ff d0                	callq  *%rax

  for (n = 0; n < 256; n++)
ffff80000010a1f6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
ffff80000010a1fd:	eb 3b                	jmp    ffff80000010a23a <tvinit+0x8f>
    mkgate(idt, n, vectors[n], 0);
ffff80000010a1ff:	48 ba 58 d6 10 00 00 	movabs $0xffff80000010d658,%rdx
ffff80000010a206:	80 ff ff 
ffff80000010a209:	8b 45 fc             	mov    -0x4(%rbp),%eax
ffff80000010a20c:	48 98                	cltq   
ffff80000010a20e:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
ffff80000010a212:	8b 75 fc             	mov    -0x4(%rbp),%esi
ffff80000010a215:	48 b8 60 c9 11 00 00 	movabs $0xffff80000011c960,%rax
ffff80000010a21c:	80 ff ff 
ffff80000010a21f:	48 8b 00             	mov    (%rax),%rax
ffff80000010a222:	b9 00 00 00 00       	mov    $0x0,%ecx
ffff80000010a227:	48 89 c7             	mov    %rax,%rdi
ffff80000010a22a:	48 b8 c1 a0 10 00 00 	movabs $0xffff80000010a0c1,%rax
ffff80000010a231:	80 ff ff 
ffff80000010a234:	ff d0                	callq  *%rax
  for (n = 0; n < 256; n++)
ffff80000010a236:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
ffff80000010a23a:	81 7d fc ff 00 00 00 	cmpl   $0xff,-0x4(%rbp)
ffff80000010a241:	7e bc                	jle    ffff80000010a1ff <tvinit+0x54>
}
ffff80000010a243:	90                   	nop
ffff80000010a244:	90                   	nop
ffff80000010a245:	c9                   	leaveq 
ffff80000010a246:	c3                   	retq   

ffff80000010a247 <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
ffff80000010a247:	f3 0f 1e fa          	endbr64 
ffff80000010a24b:	55                   	push   %rbp
ffff80000010a24c:	48 89 e5             	mov    %rsp,%rbp
ffff80000010a24f:	41 54                	push   %r12
ffff80000010a251:	53                   	push   %rbx
ffff80000010a252:	48 83 ec 10          	sub    $0x10,%rsp
ffff80000010a256:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  switch(tf->trapno){
ffff80000010a25a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff80000010a25e:	48 8b 40 78          	mov    0x78(%rax),%rax
ffff80000010a262:	48 83 e8 20          	sub    $0x20,%rax
ffff80000010a266:	48 83 f8 1f          	cmp    $0x1f,%rax
ffff80000010a26a:	0f 87 47 01 00 00    	ja     ffff80000010a3b7 <trap+0x170>
ffff80000010a270:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
ffff80000010a277:	00 
ffff80000010a278:	48 b8 28 ce 10 00 00 	movabs $0xffff80000010ce28,%rax
ffff80000010a27f:	80 ff ff 
ffff80000010a282:	48 01 d0             	add    %rdx,%rax
ffff80000010a285:	48 8b 00             	mov    (%rax),%rax
ffff80000010a288:	3e ff e0             	notrack jmpq *%rax
  case T_IRQ0 + IRQ_TIMER:
    if(cpunum() == 0){
ffff80000010a28b:	48 b8 27 47 10 00 00 	movabs $0xffff800000104727,%rax
ffff80000010a292:	80 ff ff 
ffff80000010a295:	ff d0                	callq  *%rax
ffff80000010a297:	85 c0                	test   %eax,%eax
ffff80000010a299:	75 5d                	jne    ffff80000010a2f8 <trap+0xb1>
      acquire(&tickslock);
ffff80000010a29b:	48 bf 80 c9 11 00 00 	movabs $0xffff80000011c980,%rdi
ffff80000010a2a2:	80 ff ff 
ffff80000010a2a5:	48 b8 17 7f 10 00 00 	movabs $0xffff800000107f17,%rax
ffff80000010a2ac:	80 ff ff 
ffff80000010a2af:	ff d0                	callq  *%rax
      ticks++;
ffff80000010a2b1:	48 b8 e8 c9 11 00 00 	movabs $0xffff80000011c9e8,%rax
ffff80000010a2b8:	80 ff ff 
ffff80000010a2bb:	8b 00                	mov    (%rax),%eax
ffff80000010a2bd:	8d 50 01             	lea    0x1(%rax),%edx
ffff80000010a2c0:	48 b8 e8 c9 11 00 00 	movabs $0xffff80000011c9e8,%rax
ffff80000010a2c7:	80 ff ff 
ffff80000010a2ca:	89 10                	mov    %edx,(%rax)
      wakeup(&ticks);
ffff80000010a2cc:	48 bf e8 c9 11 00 00 	movabs $0xffff80000011c9e8,%rdi
ffff80000010a2d3:	80 ff ff 
ffff80000010a2d6:	48 b8 2e 71 10 00 00 	movabs $0xffff80000010712e,%rax
ffff80000010a2dd:	80 ff ff 
ffff80000010a2e0:	ff d0                	callq  *%rax
      release(&tickslock);
ffff80000010a2e2:	48 bf 80 c9 11 00 00 	movabs $0xffff80000011c980,%rdi
ffff80000010a2e9:	80 ff ff 
ffff80000010a2ec:	48 b8 b4 7f 10 00 00 	movabs $0xffff800000107fb4,%rax
ffff80000010a2f3:	80 ff ff 
ffff80000010a2f6:	ff d0                	callq  *%rax
    }
    lapiceoi();
ffff80000010a2f8:	48 b8 2a 48 10 00 00 	movabs $0xffff80000010482a,%rax
ffff80000010a2ff:	80 ff ff 
ffff80000010a302:	ff d0                	callq  *%rax
    break;
ffff80000010a304:	e9 1c 02 00 00       	jmpq   ffff80000010a525 <trap+0x2de>
  case T_IRQ0 + IRQ_IDE:
    ideintr();
ffff80000010a309:	48 b8 0a 3c 10 00 00 	movabs $0xffff800000103c0a,%rax
ffff80000010a310:	80 ff ff 
ffff80000010a313:	ff d0                	callq  *%rax
    lapiceoi();
ffff80000010a315:	48 b8 2a 48 10 00 00 	movabs $0xffff80000010482a,%rax
ffff80000010a31c:	80 ff ff 
ffff80000010a31f:	ff d0                	callq  *%rax
    break;
ffff80000010a321:	e9 ff 01 00 00       	jmpq   ffff80000010a525 <trap+0x2de>
  case T_IRQ0 + IRQ_IDE+1:
    // Bochs generates spurious IDE1 interrupts.
    break;
  case T_IRQ0 + IRQ_KBD:
    kbdintr();
ffff80000010a326:	48 b8 cb 44 10 00 00 	movabs $0xffff8000001044cb,%rax
ffff80000010a32d:	80 ff ff 
ffff80000010a330:	ff d0                	callq  *%rax
    lapiceoi();
ffff80000010a332:	48 b8 2a 48 10 00 00 	movabs $0xffff80000010482a,%rax
ffff80000010a339:	80 ff ff 
ffff80000010a33c:	ff d0                	callq  *%rax
    break;
ffff80000010a33e:	e9 e2 01 00 00       	jmpq   ffff80000010a525 <trap+0x2de>
  case T_IRQ0 + IRQ_COM1:
    uartintr();
ffff80000010a343:	48 b8 67 a8 10 00 00 	movabs $0xffff80000010a867,%rax
ffff80000010a34a:	80 ff ff 
ffff80000010a34d:	ff d0                	callq  *%rax
    lapiceoi();
ffff80000010a34f:	48 b8 2a 48 10 00 00 	movabs $0xffff80000010482a,%rax
ffff80000010a356:	80 ff ff 
ffff80000010a359:	ff d0                	callq  *%rax
    break;
ffff80000010a35b:	e9 c5 01 00 00       	jmpq   ffff80000010a525 <trap+0x2de>
  case T_IRQ0 + 7:
  case T_IRQ0 + IRQ_SPURIOUS:
    cprintf("cpu%d: spurious interrupt at %p:%p\n",
ffff80000010a360:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff80000010a364:	4c 8b a0 88 00 00 00 	mov    0x88(%rax),%r12
ffff80000010a36b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff80000010a36f:	48 8b 98 90 00 00 00 	mov    0x90(%rax),%rbx
ffff80000010a376:	48 b8 27 47 10 00 00 	movabs $0xffff800000104727,%rax
ffff80000010a37d:	80 ff ff 
ffff80000010a380:	ff d0                	callq  *%rax
ffff80000010a382:	4c 89 e1             	mov    %r12,%rcx
ffff80000010a385:	48 89 da             	mov    %rbx,%rdx
ffff80000010a388:	89 c6                	mov    %eax,%esi
ffff80000010a38a:	48 bf 70 cd 10 00 00 	movabs $0xffff80000010cd70,%rdi
ffff80000010a391:	80 ff ff 
ffff80000010a394:	b8 00 00 00 00       	mov    $0x0,%eax
ffff80000010a399:	49 b8 18 08 10 00 00 	movabs $0xffff800000100818,%r8
ffff80000010a3a0:	80 ff ff 
ffff80000010a3a3:	41 ff d0             	callq  *%r8
            cpunum(), tf->cs, tf->rip);
    lapiceoi();
ffff80000010a3a6:	48 b8 2a 48 10 00 00 	movabs $0xffff80000010482a,%rax
ffff80000010a3ad:	80 ff ff 
ffff80000010a3b0:	ff d0                	callq  *%rax
    break;
ffff80000010a3b2:	e9 6e 01 00 00       	jmpq   ffff80000010a525 <trap+0x2de>

  //PAGEBREAK: 13
  default:
    if(proc == 0 || (tf->cs&3) == 0){
ffff80000010a3b7:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffff80000010a3be:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffff80000010a3c2:	48 85 c0             	test   %rax,%rax
ffff80000010a3c5:	74 17                	je     ffff80000010a3de <trap+0x197>
ffff80000010a3c7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff80000010a3cb:	48 8b 80 90 00 00 00 	mov    0x90(%rax),%rax
ffff80000010a3d2:	83 e0 03             	and    $0x3,%eax
ffff80000010a3d5:	48 85 c0             	test   %rax,%rax
ffff80000010a3d8:	0f 85 a6 00 00 00    	jne    ffff80000010a484 <trap+0x23d>
      // In kernel, it must be our mistake.
      cprintf("unexpected trap %d from cpu %d rip %p (cr2=0x%p)\n",
ffff80000010a3de:	48 b8 a8 a0 10 00 00 	movabs $0xffff80000010a0a8,%rax
ffff80000010a3e5:	80 ff ff 
ffff80000010a3e8:	ff d0                	callq  *%rax
ffff80000010a3ea:	49 89 c4             	mov    %rax,%r12
ffff80000010a3ed:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff80000010a3f1:	48 8b 98 88 00 00 00 	mov    0x88(%rax),%rbx
ffff80000010a3f8:	48 b8 27 47 10 00 00 	movabs $0xffff800000104727,%rax
ffff80000010a3ff:	80 ff ff 
ffff80000010a402:	ff d0                	callq  *%rax
ffff80000010a404:	89 c2                	mov    %eax,%edx
ffff80000010a406:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff80000010a40a:	48 8b 40 78          	mov    0x78(%rax),%rax
ffff80000010a40e:	4d 89 e0             	mov    %r12,%r8
ffff80000010a411:	48 89 d9             	mov    %rbx,%rcx
ffff80000010a414:	48 89 c6             	mov    %rax,%rsi
ffff80000010a417:	48 bf 98 cd 10 00 00 	movabs $0xffff80000010cd98,%rdi
ffff80000010a41e:	80 ff ff 
ffff80000010a421:	b8 00 00 00 00       	mov    $0x0,%eax
ffff80000010a426:	49 b9 18 08 10 00 00 	movabs $0xffff800000100818,%r9
ffff80000010a42d:	80 ff ff 
ffff80000010a430:	41 ff d1             	callq  *%r9
              tf->trapno, cpunum(), tf->rip, rcr2());
      if (proc)
ffff80000010a433:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffff80000010a43a:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffff80000010a43e:	48 85 c0             	test   %rax,%rax
ffff80000010a441:	74 2b                	je     ffff80000010a46e <trap+0x227>
        cprintf("proc id: %d\n", proc->pid);
ffff80000010a443:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffff80000010a44a:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffff80000010a44e:	8b 40 1c             	mov    0x1c(%rax),%eax
ffff80000010a451:	89 c6                	mov    %eax,%esi
ffff80000010a453:	48 bf ca cd 10 00 00 	movabs $0xffff80000010cdca,%rdi
ffff80000010a45a:	80 ff ff 
ffff80000010a45d:	b8 00 00 00 00       	mov    $0x0,%eax
ffff80000010a462:	48 ba 18 08 10 00 00 	movabs $0xffff800000100818,%rdx
ffff80000010a469:	80 ff ff 
ffff80000010a46c:	ff d2                	callq  *%rdx
      panic("trap");
ffff80000010a46e:	48 bf d7 cd 10 00 00 	movabs $0xffff80000010cdd7,%rdi
ffff80000010a475:	80 ff ff 
ffff80000010a478:	48 b8 f9 0b 10 00 00 	movabs $0xffff800000100bf9,%rax
ffff80000010a47f:	80 ff ff 
ffff80000010a482:	ff d0                	callq  *%rax
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
ffff80000010a484:	48 b8 a8 a0 10 00 00 	movabs $0xffff80000010a0a8,%rax
ffff80000010a48b:	80 ff ff 
ffff80000010a48e:	ff d0                	callq  *%rax
ffff80000010a490:	48 89 c3             	mov    %rax,%rbx
ffff80000010a493:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff80000010a497:	4c 8b a0 88 00 00 00 	mov    0x88(%rax),%r12
ffff80000010a49e:	48 b8 27 47 10 00 00 	movabs $0xffff800000104727,%rax
ffff80000010a4a5:	80 ff ff 
ffff80000010a4a8:	ff d0                	callq  *%rax
ffff80000010a4aa:	89 c1                	mov    %eax,%ecx
ffff80000010a4ac:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff80000010a4b0:	48 8b b8 80 00 00 00 	mov    0x80(%rax),%rdi
ffff80000010a4b7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff80000010a4bb:	48 8b 50 78          	mov    0x78(%rax),%rdx
            "rip 0x%p addr 0x%p--kill proc\n",
            proc->pid, proc->name, tf->trapno, tf->err, cpunum(), tf->rip,
ffff80000010a4bf:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffff80000010a4c6:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffff80000010a4ca:	48 8d b0 d4 00 00 00 	lea    0xd4(%rax),%rsi
ffff80000010a4d1:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffff80000010a4d8:	64 48 8b 00          	mov    %fs:(%rax),%rax
    cprintf("pid %d %s: trap %d err %d on cpu %d "
ffff80000010a4dc:	8b 40 1c             	mov    0x1c(%rax),%eax
ffff80000010a4df:	53                   	push   %rbx
ffff80000010a4e0:	41 54                	push   %r12
ffff80000010a4e2:	41 89 c9             	mov    %ecx,%r9d
ffff80000010a4e5:	49 89 f8             	mov    %rdi,%r8
ffff80000010a4e8:	48 89 d1             	mov    %rdx,%rcx
ffff80000010a4eb:	48 89 f2             	mov    %rsi,%rdx
ffff80000010a4ee:	89 c6                	mov    %eax,%esi
ffff80000010a4f0:	48 bf e0 cd 10 00 00 	movabs $0xffff80000010cde0,%rdi
ffff80000010a4f7:	80 ff ff 
ffff80000010a4fa:	b8 00 00 00 00       	mov    $0x0,%eax
ffff80000010a4ff:	49 ba 18 08 10 00 00 	movabs $0xffff800000100818,%r10
ffff80000010a506:	80 ff ff 
ffff80000010a509:	41 ff d2             	callq  *%r10
ffff80000010a50c:	48 83 c4 10          	add    $0x10,%rsp
            rcr2());
    proc->killed = 1;
ffff80000010a510:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffff80000010a517:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffff80000010a51b:	c7 40 40 01 00 00 00 	movl   $0x1,0x40(%rax)
ffff80000010a522:	eb 01                	jmp    ffff80000010a525 <trap+0x2de>
    break;
ffff80000010a524:	90                   	nop
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(proc && proc->killed && (tf->cs&3) == DPL_USER)
ffff80000010a525:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffff80000010a52c:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffff80000010a530:	48 85 c0             	test   %rax,%rax
ffff80000010a533:	74 32                	je     ffff80000010a567 <trap+0x320>
ffff80000010a535:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffff80000010a53c:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffff80000010a540:	8b 40 40             	mov    0x40(%rax),%eax
ffff80000010a543:	85 c0                	test   %eax,%eax
ffff80000010a545:	74 20                	je     ffff80000010a567 <trap+0x320>
ffff80000010a547:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff80000010a54b:	48 8b 80 90 00 00 00 	mov    0x90(%rax),%rax
ffff80000010a552:	83 e0 03             	and    $0x3,%eax
ffff80000010a555:	48 83 f8 03          	cmp    $0x3,%rax
ffff80000010a559:	75 0c                	jne    ffff80000010a567 <trap+0x320>
    exit();
ffff80000010a55b:	48 b8 bb 68 10 00 00 	movabs $0xffff8000001068bb,%rax
ffff80000010a562:	80 ff ff 
ffff80000010a565:	ff d0                	callq  *%rax

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(proc && proc->state == RUNNING && tf->trapno == T_IRQ0+IRQ_TIMER)
ffff80000010a567:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffff80000010a56e:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffff80000010a572:	48 85 c0             	test   %rax,%rax
ffff80000010a575:	74 2d                	je     ffff80000010a5a4 <trap+0x35d>
ffff80000010a577:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffff80000010a57e:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffff80000010a582:	8b 40 18             	mov    0x18(%rax),%eax
ffff80000010a585:	83 f8 04             	cmp    $0x4,%eax
ffff80000010a588:	75 1a                	jne    ffff80000010a5a4 <trap+0x35d>
ffff80000010a58a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff80000010a58e:	48 8b 40 78          	mov    0x78(%rax),%rax
ffff80000010a592:	48 83 f8 20          	cmp    $0x20,%rax
ffff80000010a596:	75 0c                	jne    ffff80000010a5a4 <trap+0x35d>
    yield();
ffff80000010a598:	48 b8 f0 6e 10 00 00 	movabs $0xffff800000106ef0,%rax
ffff80000010a59f:	80 ff ff 
ffff80000010a5a2:	ff d0                	callq  *%rax

  // Check if the process has been killed since we yielded
  if(proc && proc->killed && (tf->cs&3) == DPL_USER)
ffff80000010a5a4:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffff80000010a5ab:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffff80000010a5af:	48 85 c0             	test   %rax,%rax
ffff80000010a5b2:	74 32                	je     ffff80000010a5e6 <trap+0x39f>
ffff80000010a5b4:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffff80000010a5bb:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffff80000010a5bf:	8b 40 40             	mov    0x40(%rax),%eax
ffff80000010a5c2:	85 c0                	test   %eax,%eax
ffff80000010a5c4:	74 20                	je     ffff80000010a5e6 <trap+0x39f>
ffff80000010a5c6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff80000010a5ca:	48 8b 80 90 00 00 00 	mov    0x90(%rax),%rax
ffff80000010a5d1:	83 e0 03             	and    $0x3,%eax
ffff80000010a5d4:	48 83 f8 03          	cmp    $0x3,%rax
ffff80000010a5d8:	75 0c                	jne    ffff80000010a5e6 <trap+0x39f>
    exit();
ffff80000010a5da:	48 b8 bb 68 10 00 00 	movabs $0xffff8000001068bb,%rax
ffff80000010a5e1:	80 ff ff 
ffff80000010a5e4:	ff d0                	callq  *%rax
}
ffff80000010a5e6:	90                   	nop
ffff80000010a5e7:	48 8d 65 f0          	lea    -0x10(%rbp),%rsp
ffff80000010a5eb:	5b                   	pop    %rbx
ffff80000010a5ec:	41 5c                	pop    %r12
ffff80000010a5ee:	5d                   	pop    %rbp
ffff80000010a5ef:	c3                   	retq   

ffff80000010a5f0 <inb>:
{
ffff80000010a5f0:	f3 0f 1e fa          	endbr64 
ffff80000010a5f4:	55                   	push   %rbp
ffff80000010a5f5:	48 89 e5             	mov    %rsp,%rbp
ffff80000010a5f8:	48 83 ec 18          	sub    $0x18,%rsp
ffff80000010a5fc:	89 f8                	mov    %edi,%eax
ffff80000010a5fe:	66 89 45 ec          	mov    %ax,-0x14(%rbp)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
ffff80000010a602:	0f b7 45 ec          	movzwl -0x14(%rbp),%eax
ffff80000010a606:	89 c2                	mov    %eax,%edx
ffff80000010a608:	ec                   	in     (%dx),%al
ffff80000010a609:	88 45 ff             	mov    %al,-0x1(%rbp)
  return data;
ffff80000010a60c:	0f b6 45 ff          	movzbl -0x1(%rbp),%eax
}
ffff80000010a610:	c9                   	leaveq 
ffff80000010a611:	c3                   	retq   

ffff80000010a612 <outb>:
{
ffff80000010a612:	f3 0f 1e fa          	endbr64 
ffff80000010a616:	55                   	push   %rbp
ffff80000010a617:	48 89 e5             	mov    %rsp,%rbp
ffff80000010a61a:	48 83 ec 08          	sub    $0x8,%rsp
ffff80000010a61e:	89 f8                	mov    %edi,%eax
ffff80000010a620:	89 f2                	mov    %esi,%edx
ffff80000010a622:	66 89 45 fc          	mov    %ax,-0x4(%rbp)
ffff80000010a626:	89 d0                	mov    %edx,%eax
ffff80000010a628:	88 45 f8             	mov    %al,-0x8(%rbp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
ffff80000010a62b:	0f b6 45 f8          	movzbl -0x8(%rbp),%eax
ffff80000010a62f:	0f b7 55 fc          	movzwl -0x4(%rbp),%edx
ffff80000010a633:	ee                   	out    %al,(%dx)
}
ffff80000010a634:	90                   	nop
ffff80000010a635:	c9                   	leaveq 
ffff80000010a636:	c3                   	retq   

ffff80000010a637 <uartearlyinit>:

static int uart;    // is there a uart?

void
uartearlyinit(void)
{
ffff80000010a637:	f3 0f 1e fa          	endbr64 
ffff80000010a63b:	55                   	push   %rbp
ffff80000010a63c:	48 89 e5             	mov    %rsp,%rbp
ffff80000010a63f:	48 83 ec 10          	sub    $0x10,%rsp
  char *p;

  // Turn off the FIFO
  outb(COM1+2, 0);
ffff80000010a643:	be 00 00 00 00       	mov    $0x0,%esi
ffff80000010a648:	bf fa 03 00 00       	mov    $0x3fa,%edi
ffff80000010a64d:	48 b8 12 a6 10 00 00 	movabs $0xffff80000010a612,%rax
ffff80000010a654:	80 ff ff 
ffff80000010a657:	ff d0                	callq  *%rax

  // 9600 baud, 8 data bits, 1 stop bit, parity off.
  outb(COM1+3, 0x80);    // Unlock divisor
ffff80000010a659:	be 80 00 00 00       	mov    $0x80,%esi
ffff80000010a65e:	bf fb 03 00 00       	mov    $0x3fb,%edi
ffff80000010a663:	48 b8 12 a6 10 00 00 	movabs $0xffff80000010a612,%rax
ffff80000010a66a:	80 ff ff 
ffff80000010a66d:	ff d0                	callq  *%rax
  outb(COM1+0, 115200/9600);
ffff80000010a66f:	be 0c 00 00 00       	mov    $0xc,%esi
ffff80000010a674:	bf f8 03 00 00       	mov    $0x3f8,%edi
ffff80000010a679:	48 b8 12 a6 10 00 00 	movabs $0xffff80000010a612,%rax
ffff80000010a680:	80 ff ff 
ffff80000010a683:	ff d0                	callq  *%rax
  outb(COM1+1, 0);
ffff80000010a685:	be 00 00 00 00       	mov    $0x0,%esi
ffff80000010a68a:	bf f9 03 00 00       	mov    $0x3f9,%edi
ffff80000010a68f:	48 b8 12 a6 10 00 00 	movabs $0xffff80000010a612,%rax
ffff80000010a696:	80 ff ff 
ffff80000010a699:	ff d0                	callq  *%rax
  outb(COM1+3, 0x03);    // Lock divisor, 8 data bits.
ffff80000010a69b:	be 03 00 00 00       	mov    $0x3,%esi
ffff80000010a6a0:	bf fb 03 00 00       	mov    $0x3fb,%edi
ffff80000010a6a5:	48 b8 12 a6 10 00 00 	movabs $0xffff80000010a612,%rax
ffff80000010a6ac:	80 ff ff 
ffff80000010a6af:	ff d0                	callq  *%rax
  outb(COM1+4, 0);
ffff80000010a6b1:	be 00 00 00 00       	mov    $0x0,%esi
ffff80000010a6b6:	bf fc 03 00 00       	mov    $0x3fc,%edi
ffff80000010a6bb:	48 b8 12 a6 10 00 00 	movabs $0xffff80000010a612,%rax
ffff80000010a6c2:	80 ff ff 
ffff80000010a6c5:	ff d0                	callq  *%rax
  outb(COM1+1, 0x01);    // Enable receive interrupts.
ffff80000010a6c7:	be 01 00 00 00       	mov    $0x1,%esi
ffff80000010a6cc:	bf f9 03 00 00       	mov    $0x3f9,%edi
ffff80000010a6d1:	48 b8 12 a6 10 00 00 	movabs $0xffff80000010a612,%rax
ffff80000010a6d8:	80 ff ff 
ffff80000010a6db:	ff d0                	callq  *%rax

  // If status is 0xFF, no serial port.
  if(inb(COM1+5) == 0xFF)
ffff80000010a6dd:	bf fd 03 00 00       	mov    $0x3fd,%edi
ffff80000010a6e2:	48 b8 f0 a5 10 00 00 	movabs $0xffff80000010a5f0,%rax
ffff80000010a6e9:	80 ff ff 
ffff80000010a6ec:	ff d0                	callq  *%rax
ffff80000010a6ee:	3c ff                	cmp    $0xff,%al
ffff80000010a6f0:	74 4a                	je     ffff80000010a73c <uartearlyinit+0x105>
    return;
  uart = 1;
ffff80000010a6f2:	48 b8 ec c9 11 00 00 	movabs $0xffff80000011c9ec,%rax
ffff80000010a6f9:	80 ff ff 
ffff80000010a6fc:	c7 00 01 00 00 00    	movl   $0x1,(%rax)



  // Announce that we're here.
  for(p="xv6...\n"; *p; p++)
ffff80000010a702:	48 b8 28 cf 10 00 00 	movabs $0xffff80000010cf28,%rax
ffff80000010a709:	80 ff ff 
ffff80000010a70c:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
ffff80000010a710:	eb 1d                	jmp    ffff80000010a72f <uartearlyinit+0xf8>
    uartputc(*p);
ffff80000010a712:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff80000010a716:	0f b6 00             	movzbl (%rax),%eax
ffff80000010a719:	0f be c0             	movsbl %al,%eax
ffff80000010a71c:	89 c7                	mov    %eax,%edi
ffff80000010a71e:	48 b8 94 a7 10 00 00 	movabs $0xffff80000010a794,%rax
ffff80000010a725:	80 ff ff 
ffff80000010a728:	ff d0                	callq  *%rax
  for(p="xv6...\n"; *p; p++)
ffff80000010a72a:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
ffff80000010a72f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff80000010a733:	0f b6 00             	movzbl (%rax),%eax
ffff80000010a736:	84 c0                	test   %al,%al
ffff80000010a738:	75 d8                	jne    ffff80000010a712 <uartearlyinit+0xdb>
ffff80000010a73a:	eb 01                	jmp    ffff80000010a73d <uartearlyinit+0x106>
    return;
ffff80000010a73c:	90                   	nop
}
ffff80000010a73d:	c9                   	leaveq 
ffff80000010a73e:	c3                   	retq   

ffff80000010a73f <uartinit>:

void
uartinit(void)
{
ffff80000010a73f:	f3 0f 1e fa          	endbr64 
ffff80000010a743:	55                   	push   %rbp
ffff80000010a744:	48 89 e5             	mov    %rsp,%rbp
  if(!uart)
ffff80000010a747:	48 b8 ec c9 11 00 00 	movabs $0xffff80000011c9ec,%rax
ffff80000010a74e:	80 ff ff 
ffff80000010a751:	8b 00                	mov    (%rax),%eax
ffff80000010a753:	85 c0                	test   %eax,%eax
ffff80000010a755:	74 3a                	je     ffff80000010a791 <uartinit+0x52>
    return;

  // Acknowledge pre-existing interrupt conditions;
  // enable interrupts.
  inb(COM1+2);
ffff80000010a757:	bf fa 03 00 00       	mov    $0x3fa,%edi
ffff80000010a75c:	48 b8 f0 a5 10 00 00 	movabs $0xffff80000010a5f0,%rax
ffff80000010a763:	80 ff ff 
ffff80000010a766:	ff d0                	callq  *%rax
  inb(COM1+0);
ffff80000010a768:	bf f8 03 00 00       	mov    $0x3f8,%edi
ffff80000010a76d:	48 b8 f0 a5 10 00 00 	movabs $0xffff80000010a5f0,%rax
ffff80000010a774:	80 ff ff 
ffff80000010a777:	ff d0                	callq  *%rax
  ioapicenable(IRQ_COM1, 0);
ffff80000010a779:	be 00 00 00 00       	mov    $0x0,%esi
ffff80000010a77e:	bf 04 00 00 00       	mov    $0x4,%edi
ffff80000010a783:	48 b8 e5 3f 10 00 00 	movabs $0xffff800000103fe5,%rax
ffff80000010a78a:	80 ff ff 
ffff80000010a78d:	ff d0                	callq  *%rax
ffff80000010a78f:	eb 01                	jmp    ffff80000010a792 <uartinit+0x53>
    return;
ffff80000010a791:	90                   	nop

}
ffff80000010a792:	5d                   	pop    %rbp
ffff80000010a793:	c3                   	retq   

ffff80000010a794 <uartputc>:
void
uartputc(int c)
{
ffff80000010a794:	f3 0f 1e fa          	endbr64 
ffff80000010a798:	55                   	push   %rbp
ffff80000010a799:	48 89 e5             	mov    %rsp,%rbp
ffff80000010a79c:	48 83 ec 20          	sub    $0x20,%rsp
ffff80000010a7a0:	89 7d ec             	mov    %edi,-0x14(%rbp)
  int i;

  if(!uart)
ffff80000010a7a3:	48 b8 ec c9 11 00 00 	movabs $0xffff80000011c9ec,%rax
ffff80000010a7aa:	80 ff ff 
ffff80000010a7ad:	8b 00                	mov    (%rax),%eax
ffff80000010a7af:	85 c0                	test   %eax,%eax
ffff80000010a7b1:	74 5a                	je     ffff80000010a80d <uartputc+0x79>
    return;
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
ffff80000010a7b3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
ffff80000010a7ba:	eb 15                	jmp    ffff80000010a7d1 <uartputc+0x3d>
    microdelay(10);
ffff80000010a7bc:	bf 0a 00 00 00       	mov    $0xa,%edi
ffff80000010a7c1:	48 b8 5d 48 10 00 00 	movabs $0xffff80000010485d,%rax
ffff80000010a7c8:	80 ff ff 
ffff80000010a7cb:	ff d0                	callq  *%rax
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
ffff80000010a7cd:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
ffff80000010a7d1:	83 7d fc 7f          	cmpl   $0x7f,-0x4(%rbp)
ffff80000010a7d5:	7f 1b                	jg     ffff80000010a7f2 <uartputc+0x5e>
ffff80000010a7d7:	bf fd 03 00 00       	mov    $0x3fd,%edi
ffff80000010a7dc:	48 b8 f0 a5 10 00 00 	movabs $0xffff80000010a5f0,%rax
ffff80000010a7e3:	80 ff ff 
ffff80000010a7e6:	ff d0                	callq  *%rax
ffff80000010a7e8:	0f b6 c0             	movzbl %al,%eax
ffff80000010a7eb:	83 e0 20             	and    $0x20,%eax
ffff80000010a7ee:	85 c0                	test   %eax,%eax
ffff80000010a7f0:	74 ca                	je     ffff80000010a7bc <uartputc+0x28>
  outb(COM1+0, c);
ffff80000010a7f2:	8b 45 ec             	mov    -0x14(%rbp),%eax
ffff80000010a7f5:	0f b6 c0             	movzbl %al,%eax
ffff80000010a7f8:	89 c6                	mov    %eax,%esi
ffff80000010a7fa:	bf f8 03 00 00       	mov    $0x3f8,%edi
ffff80000010a7ff:	48 b8 12 a6 10 00 00 	movabs $0xffff80000010a612,%rax
ffff80000010a806:	80 ff ff 
ffff80000010a809:	ff d0                	callq  *%rax
ffff80000010a80b:	eb 01                	jmp    ffff80000010a80e <uartputc+0x7a>
    return;
ffff80000010a80d:	90                   	nop
}
ffff80000010a80e:	c9                   	leaveq 
ffff80000010a80f:	c3                   	retq   

ffff80000010a810 <uartgetc>:

static int
uartgetc(void)
{
ffff80000010a810:	f3 0f 1e fa          	endbr64 
ffff80000010a814:	55                   	push   %rbp
ffff80000010a815:	48 89 e5             	mov    %rsp,%rbp
  if(!uart)
ffff80000010a818:	48 b8 ec c9 11 00 00 	movabs $0xffff80000011c9ec,%rax
ffff80000010a81f:	80 ff ff 
ffff80000010a822:	8b 00                	mov    (%rax),%eax
ffff80000010a824:	85 c0                	test   %eax,%eax
ffff80000010a826:	75 07                	jne    ffff80000010a82f <uartgetc+0x1f>
    return -1;
ffff80000010a828:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
ffff80000010a82d:	eb 36                	jmp    ffff80000010a865 <uartgetc+0x55>
  if(!(inb(COM1+5) & 0x01))
ffff80000010a82f:	bf fd 03 00 00       	mov    $0x3fd,%edi
ffff80000010a834:	48 b8 f0 a5 10 00 00 	movabs $0xffff80000010a5f0,%rax
ffff80000010a83b:	80 ff ff 
ffff80000010a83e:	ff d0                	callq  *%rax
ffff80000010a840:	0f b6 c0             	movzbl %al,%eax
ffff80000010a843:	83 e0 01             	and    $0x1,%eax
ffff80000010a846:	85 c0                	test   %eax,%eax
ffff80000010a848:	75 07                	jne    ffff80000010a851 <uartgetc+0x41>
    return -1;
ffff80000010a84a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
ffff80000010a84f:	eb 14                	jmp    ffff80000010a865 <uartgetc+0x55>
  return inb(COM1+0);
ffff80000010a851:	bf f8 03 00 00       	mov    $0x3f8,%edi
ffff80000010a856:	48 b8 f0 a5 10 00 00 	movabs $0xffff80000010a5f0,%rax
ffff80000010a85d:	80 ff ff 
ffff80000010a860:	ff d0                	callq  *%rax
ffff80000010a862:	0f b6 c0             	movzbl %al,%eax
}
ffff80000010a865:	5d                   	pop    %rbp
ffff80000010a866:	c3                   	retq   

ffff80000010a867 <uartintr>:

void
uartintr(void)
{
ffff80000010a867:	f3 0f 1e fa          	endbr64 
ffff80000010a86b:	55                   	push   %rbp
ffff80000010a86c:	48 89 e5             	mov    %rsp,%rbp
  consoleintr(uartgetc);
ffff80000010a86f:	48 bf 10 a8 10 00 00 	movabs $0xffff80000010a810,%rdi
ffff80000010a876:	80 ff ff 
ffff80000010a879:	48 b8 83 0f 10 00 00 	movabs $0xffff800000100f83,%rax
ffff80000010a880:	80 ff ff 
ffff80000010a883:	ff d0                	callq  *%rax
}
ffff80000010a885:	90                   	nop
ffff80000010a886:	5d                   	pop    %rbp
ffff80000010a887:	c3                   	retq   

ffff80000010a888 <vector0>:
# generated by vectors.pl - do not edit
# handlers
.global alltraps
vector0:
  push $0
ffff80000010a888:	6a 00                	pushq  $0x0
  push $0
ffff80000010a88a:	6a 00                	pushq  $0x0
  jmp alltraps
ffff80000010a88c:	e9 0a f7 ff ff       	jmpq   ffff800000109f9b <alltraps>

ffff80000010a891 <vector1>:
vector1:
  push $0
ffff80000010a891:	6a 00                	pushq  $0x0
  push $1
ffff80000010a893:	6a 01                	pushq  $0x1
  jmp alltraps
ffff80000010a895:	e9 01 f7 ff ff       	jmpq   ffff800000109f9b <alltraps>

ffff80000010a89a <vector2>:
vector2:
  push $0
ffff80000010a89a:	6a 00                	pushq  $0x0
  push $2
ffff80000010a89c:	6a 02                	pushq  $0x2
  jmp alltraps
ffff80000010a89e:	e9 f8 f6 ff ff       	jmpq   ffff800000109f9b <alltraps>

ffff80000010a8a3 <vector3>:
vector3:
  push $0
ffff80000010a8a3:	6a 00                	pushq  $0x0
  push $3
ffff80000010a8a5:	6a 03                	pushq  $0x3
  jmp alltraps
ffff80000010a8a7:	e9 ef f6 ff ff       	jmpq   ffff800000109f9b <alltraps>

ffff80000010a8ac <vector4>:
vector4:
  push $0
ffff80000010a8ac:	6a 00                	pushq  $0x0
  push $4
ffff80000010a8ae:	6a 04                	pushq  $0x4
  jmp alltraps
ffff80000010a8b0:	e9 e6 f6 ff ff       	jmpq   ffff800000109f9b <alltraps>

ffff80000010a8b5 <vector5>:
vector5:
  push $0
ffff80000010a8b5:	6a 00                	pushq  $0x0
  push $5
ffff80000010a8b7:	6a 05                	pushq  $0x5
  jmp alltraps
ffff80000010a8b9:	e9 dd f6 ff ff       	jmpq   ffff800000109f9b <alltraps>

ffff80000010a8be <vector6>:
vector6:
  push $0
ffff80000010a8be:	6a 00                	pushq  $0x0
  push $6
ffff80000010a8c0:	6a 06                	pushq  $0x6
  jmp alltraps
ffff80000010a8c2:	e9 d4 f6 ff ff       	jmpq   ffff800000109f9b <alltraps>

ffff80000010a8c7 <vector7>:
vector7:
  push $0
ffff80000010a8c7:	6a 00                	pushq  $0x0
  push $7
ffff80000010a8c9:	6a 07                	pushq  $0x7
  jmp alltraps
ffff80000010a8cb:	e9 cb f6 ff ff       	jmpq   ffff800000109f9b <alltraps>

ffff80000010a8d0 <vector8>:
vector8:
  push $8
ffff80000010a8d0:	6a 08                	pushq  $0x8
  jmp alltraps
ffff80000010a8d2:	e9 c4 f6 ff ff       	jmpq   ffff800000109f9b <alltraps>

ffff80000010a8d7 <vector9>:
vector9:
  push $0
ffff80000010a8d7:	6a 00                	pushq  $0x0
  push $9
ffff80000010a8d9:	6a 09                	pushq  $0x9
  jmp alltraps
ffff80000010a8db:	e9 bb f6 ff ff       	jmpq   ffff800000109f9b <alltraps>

ffff80000010a8e0 <vector10>:
vector10:
  push $10
ffff80000010a8e0:	6a 0a                	pushq  $0xa
  jmp alltraps
ffff80000010a8e2:	e9 b4 f6 ff ff       	jmpq   ffff800000109f9b <alltraps>

ffff80000010a8e7 <vector11>:
vector11:
  push $11
ffff80000010a8e7:	6a 0b                	pushq  $0xb
  jmp alltraps
ffff80000010a8e9:	e9 ad f6 ff ff       	jmpq   ffff800000109f9b <alltraps>

ffff80000010a8ee <vector12>:
vector12:
  push $12
ffff80000010a8ee:	6a 0c                	pushq  $0xc
  jmp alltraps
ffff80000010a8f0:	e9 a6 f6 ff ff       	jmpq   ffff800000109f9b <alltraps>

ffff80000010a8f5 <vector13>:
vector13:
  push $13
ffff80000010a8f5:	6a 0d                	pushq  $0xd
  jmp alltraps
ffff80000010a8f7:	e9 9f f6 ff ff       	jmpq   ffff800000109f9b <alltraps>

ffff80000010a8fc <vector14>:
vector14:
  push $14
ffff80000010a8fc:	6a 0e                	pushq  $0xe
  jmp alltraps
ffff80000010a8fe:	e9 98 f6 ff ff       	jmpq   ffff800000109f9b <alltraps>

ffff80000010a903 <vector15>:
vector15:
  push $0
ffff80000010a903:	6a 00                	pushq  $0x0
  push $15
ffff80000010a905:	6a 0f                	pushq  $0xf
  jmp alltraps
ffff80000010a907:	e9 8f f6 ff ff       	jmpq   ffff800000109f9b <alltraps>

ffff80000010a90c <vector16>:
vector16:
  push $0
ffff80000010a90c:	6a 00                	pushq  $0x0
  push $16
ffff80000010a90e:	6a 10                	pushq  $0x10
  jmp alltraps
ffff80000010a910:	e9 86 f6 ff ff       	jmpq   ffff800000109f9b <alltraps>

ffff80000010a915 <vector17>:
vector17:
  push $17
ffff80000010a915:	6a 11                	pushq  $0x11
  jmp alltraps
ffff80000010a917:	e9 7f f6 ff ff       	jmpq   ffff800000109f9b <alltraps>

ffff80000010a91c <vector18>:
vector18:
  push $0
ffff80000010a91c:	6a 00                	pushq  $0x0
  push $18
ffff80000010a91e:	6a 12                	pushq  $0x12
  jmp alltraps
ffff80000010a920:	e9 76 f6 ff ff       	jmpq   ffff800000109f9b <alltraps>

ffff80000010a925 <vector19>:
vector19:
  push $0
ffff80000010a925:	6a 00                	pushq  $0x0
  push $19
ffff80000010a927:	6a 13                	pushq  $0x13
  jmp alltraps
ffff80000010a929:	e9 6d f6 ff ff       	jmpq   ffff800000109f9b <alltraps>

ffff80000010a92e <vector20>:
vector20:
  push $0
ffff80000010a92e:	6a 00                	pushq  $0x0
  push $20
ffff80000010a930:	6a 14                	pushq  $0x14
  jmp alltraps
ffff80000010a932:	e9 64 f6 ff ff       	jmpq   ffff800000109f9b <alltraps>

ffff80000010a937 <vector21>:
vector21:
  push $0
ffff80000010a937:	6a 00                	pushq  $0x0
  push $21
ffff80000010a939:	6a 15                	pushq  $0x15
  jmp alltraps
ffff80000010a93b:	e9 5b f6 ff ff       	jmpq   ffff800000109f9b <alltraps>

ffff80000010a940 <vector22>:
vector22:
  push $0
ffff80000010a940:	6a 00                	pushq  $0x0
  push $22
ffff80000010a942:	6a 16                	pushq  $0x16
  jmp alltraps
ffff80000010a944:	e9 52 f6 ff ff       	jmpq   ffff800000109f9b <alltraps>

ffff80000010a949 <vector23>:
vector23:
  push $0
ffff80000010a949:	6a 00                	pushq  $0x0
  push $23
ffff80000010a94b:	6a 17                	pushq  $0x17
  jmp alltraps
ffff80000010a94d:	e9 49 f6 ff ff       	jmpq   ffff800000109f9b <alltraps>

ffff80000010a952 <vector24>:
vector24:
  push $0
ffff80000010a952:	6a 00                	pushq  $0x0
  push $24
ffff80000010a954:	6a 18                	pushq  $0x18
  jmp alltraps
ffff80000010a956:	e9 40 f6 ff ff       	jmpq   ffff800000109f9b <alltraps>

ffff80000010a95b <vector25>:
vector25:
  push $0
ffff80000010a95b:	6a 00                	pushq  $0x0
  push $25
ffff80000010a95d:	6a 19                	pushq  $0x19
  jmp alltraps
ffff80000010a95f:	e9 37 f6 ff ff       	jmpq   ffff800000109f9b <alltraps>

ffff80000010a964 <vector26>:
vector26:
  push $0
ffff80000010a964:	6a 00                	pushq  $0x0
  push $26
ffff80000010a966:	6a 1a                	pushq  $0x1a
  jmp alltraps
ffff80000010a968:	e9 2e f6 ff ff       	jmpq   ffff800000109f9b <alltraps>

ffff80000010a96d <vector27>:
vector27:
  push $0
ffff80000010a96d:	6a 00                	pushq  $0x0
  push $27
ffff80000010a96f:	6a 1b                	pushq  $0x1b
  jmp alltraps
ffff80000010a971:	e9 25 f6 ff ff       	jmpq   ffff800000109f9b <alltraps>

ffff80000010a976 <vector28>:
vector28:
  push $0
ffff80000010a976:	6a 00                	pushq  $0x0
  push $28
ffff80000010a978:	6a 1c                	pushq  $0x1c
  jmp alltraps
ffff80000010a97a:	e9 1c f6 ff ff       	jmpq   ffff800000109f9b <alltraps>

ffff80000010a97f <vector29>:
vector29:
  push $0
ffff80000010a97f:	6a 00                	pushq  $0x0
  push $29
ffff80000010a981:	6a 1d                	pushq  $0x1d
  jmp alltraps
ffff80000010a983:	e9 13 f6 ff ff       	jmpq   ffff800000109f9b <alltraps>

ffff80000010a988 <vector30>:
vector30:
  push $0
ffff80000010a988:	6a 00                	pushq  $0x0
  push $30
ffff80000010a98a:	6a 1e                	pushq  $0x1e
  jmp alltraps
ffff80000010a98c:	e9 0a f6 ff ff       	jmpq   ffff800000109f9b <alltraps>

ffff80000010a991 <vector31>:
vector31:
  push $0
ffff80000010a991:	6a 00                	pushq  $0x0
  push $31
ffff80000010a993:	6a 1f                	pushq  $0x1f
  jmp alltraps
ffff80000010a995:	e9 01 f6 ff ff       	jmpq   ffff800000109f9b <alltraps>

ffff80000010a99a <vector32>:
vector32:
  push $0
ffff80000010a99a:	6a 00                	pushq  $0x0
  push $32
ffff80000010a99c:	6a 20                	pushq  $0x20
  jmp alltraps
ffff80000010a99e:	e9 f8 f5 ff ff       	jmpq   ffff800000109f9b <alltraps>

ffff80000010a9a3 <vector33>:
vector33:
  push $0
ffff80000010a9a3:	6a 00                	pushq  $0x0
  push $33
ffff80000010a9a5:	6a 21                	pushq  $0x21
  jmp alltraps
ffff80000010a9a7:	e9 ef f5 ff ff       	jmpq   ffff800000109f9b <alltraps>

ffff80000010a9ac <vector34>:
vector34:
  push $0
ffff80000010a9ac:	6a 00                	pushq  $0x0
  push $34
ffff80000010a9ae:	6a 22                	pushq  $0x22
  jmp alltraps
ffff80000010a9b0:	e9 e6 f5 ff ff       	jmpq   ffff800000109f9b <alltraps>

ffff80000010a9b5 <vector35>:
vector35:
  push $0
ffff80000010a9b5:	6a 00                	pushq  $0x0
  push $35
ffff80000010a9b7:	6a 23                	pushq  $0x23
  jmp alltraps
ffff80000010a9b9:	e9 dd f5 ff ff       	jmpq   ffff800000109f9b <alltraps>

ffff80000010a9be <vector36>:
vector36:
  push $0
ffff80000010a9be:	6a 00                	pushq  $0x0
  push $36
ffff80000010a9c0:	6a 24                	pushq  $0x24
  jmp alltraps
ffff80000010a9c2:	e9 d4 f5 ff ff       	jmpq   ffff800000109f9b <alltraps>

ffff80000010a9c7 <vector37>:
vector37:
  push $0
ffff80000010a9c7:	6a 00                	pushq  $0x0
  push $37
ffff80000010a9c9:	6a 25                	pushq  $0x25
  jmp alltraps
ffff80000010a9cb:	e9 cb f5 ff ff       	jmpq   ffff800000109f9b <alltraps>

ffff80000010a9d0 <vector38>:
vector38:
  push $0
ffff80000010a9d0:	6a 00                	pushq  $0x0
  push $38
ffff80000010a9d2:	6a 26                	pushq  $0x26
  jmp alltraps
ffff80000010a9d4:	e9 c2 f5 ff ff       	jmpq   ffff800000109f9b <alltraps>

ffff80000010a9d9 <vector39>:
vector39:
  push $0
ffff80000010a9d9:	6a 00                	pushq  $0x0
  push $39
ffff80000010a9db:	6a 27                	pushq  $0x27
  jmp alltraps
ffff80000010a9dd:	e9 b9 f5 ff ff       	jmpq   ffff800000109f9b <alltraps>

ffff80000010a9e2 <vector40>:
vector40:
  push $0
ffff80000010a9e2:	6a 00                	pushq  $0x0
  push $40
ffff80000010a9e4:	6a 28                	pushq  $0x28
  jmp alltraps
ffff80000010a9e6:	e9 b0 f5 ff ff       	jmpq   ffff800000109f9b <alltraps>

ffff80000010a9eb <vector41>:
vector41:
  push $0
ffff80000010a9eb:	6a 00                	pushq  $0x0
  push $41
ffff80000010a9ed:	6a 29                	pushq  $0x29
  jmp alltraps
ffff80000010a9ef:	e9 a7 f5 ff ff       	jmpq   ffff800000109f9b <alltraps>

ffff80000010a9f4 <vector42>:
vector42:
  push $0
ffff80000010a9f4:	6a 00                	pushq  $0x0
  push $42
ffff80000010a9f6:	6a 2a                	pushq  $0x2a
  jmp alltraps
ffff80000010a9f8:	e9 9e f5 ff ff       	jmpq   ffff800000109f9b <alltraps>

ffff80000010a9fd <vector43>:
vector43:
  push $0
ffff80000010a9fd:	6a 00                	pushq  $0x0
  push $43
ffff80000010a9ff:	6a 2b                	pushq  $0x2b
  jmp alltraps
ffff80000010aa01:	e9 95 f5 ff ff       	jmpq   ffff800000109f9b <alltraps>

ffff80000010aa06 <vector44>:
vector44:
  push $0
ffff80000010aa06:	6a 00                	pushq  $0x0
  push $44
ffff80000010aa08:	6a 2c                	pushq  $0x2c
  jmp alltraps
ffff80000010aa0a:	e9 8c f5 ff ff       	jmpq   ffff800000109f9b <alltraps>

ffff80000010aa0f <vector45>:
vector45:
  push $0
ffff80000010aa0f:	6a 00                	pushq  $0x0
  push $45
ffff80000010aa11:	6a 2d                	pushq  $0x2d
  jmp alltraps
ffff80000010aa13:	e9 83 f5 ff ff       	jmpq   ffff800000109f9b <alltraps>

ffff80000010aa18 <vector46>:
vector46:
  push $0
ffff80000010aa18:	6a 00                	pushq  $0x0
  push $46
ffff80000010aa1a:	6a 2e                	pushq  $0x2e
  jmp alltraps
ffff80000010aa1c:	e9 7a f5 ff ff       	jmpq   ffff800000109f9b <alltraps>

ffff80000010aa21 <vector47>:
vector47:
  push $0
ffff80000010aa21:	6a 00                	pushq  $0x0
  push $47
ffff80000010aa23:	6a 2f                	pushq  $0x2f
  jmp alltraps
ffff80000010aa25:	e9 71 f5 ff ff       	jmpq   ffff800000109f9b <alltraps>

ffff80000010aa2a <vector48>:
vector48:
  push $0
ffff80000010aa2a:	6a 00                	pushq  $0x0
  push $48
ffff80000010aa2c:	6a 30                	pushq  $0x30
  jmp alltraps
ffff80000010aa2e:	e9 68 f5 ff ff       	jmpq   ffff800000109f9b <alltraps>

ffff80000010aa33 <vector49>:
vector49:
  push $0
ffff80000010aa33:	6a 00                	pushq  $0x0
  push $49
ffff80000010aa35:	6a 31                	pushq  $0x31
  jmp alltraps
ffff80000010aa37:	e9 5f f5 ff ff       	jmpq   ffff800000109f9b <alltraps>

ffff80000010aa3c <vector50>:
vector50:
  push $0
ffff80000010aa3c:	6a 00                	pushq  $0x0
  push $50
ffff80000010aa3e:	6a 32                	pushq  $0x32
  jmp alltraps
ffff80000010aa40:	e9 56 f5 ff ff       	jmpq   ffff800000109f9b <alltraps>

ffff80000010aa45 <vector51>:
vector51:
  push $0
ffff80000010aa45:	6a 00                	pushq  $0x0
  push $51
ffff80000010aa47:	6a 33                	pushq  $0x33
  jmp alltraps
ffff80000010aa49:	e9 4d f5 ff ff       	jmpq   ffff800000109f9b <alltraps>

ffff80000010aa4e <vector52>:
vector52:
  push $0
ffff80000010aa4e:	6a 00                	pushq  $0x0
  push $52
ffff80000010aa50:	6a 34                	pushq  $0x34
  jmp alltraps
ffff80000010aa52:	e9 44 f5 ff ff       	jmpq   ffff800000109f9b <alltraps>

ffff80000010aa57 <vector53>:
vector53:
  push $0
ffff80000010aa57:	6a 00                	pushq  $0x0
  push $53
ffff80000010aa59:	6a 35                	pushq  $0x35
  jmp alltraps
ffff80000010aa5b:	e9 3b f5 ff ff       	jmpq   ffff800000109f9b <alltraps>

ffff80000010aa60 <vector54>:
vector54:
  push $0
ffff80000010aa60:	6a 00                	pushq  $0x0
  push $54
ffff80000010aa62:	6a 36                	pushq  $0x36
  jmp alltraps
ffff80000010aa64:	e9 32 f5 ff ff       	jmpq   ffff800000109f9b <alltraps>

ffff80000010aa69 <vector55>:
vector55:
  push $0
ffff80000010aa69:	6a 00                	pushq  $0x0
  push $55
ffff80000010aa6b:	6a 37                	pushq  $0x37
  jmp alltraps
ffff80000010aa6d:	e9 29 f5 ff ff       	jmpq   ffff800000109f9b <alltraps>

ffff80000010aa72 <vector56>:
vector56:
  push $0
ffff80000010aa72:	6a 00                	pushq  $0x0
  push $56
ffff80000010aa74:	6a 38                	pushq  $0x38
  jmp alltraps
ffff80000010aa76:	e9 20 f5 ff ff       	jmpq   ffff800000109f9b <alltraps>

ffff80000010aa7b <vector57>:
vector57:
  push $0
ffff80000010aa7b:	6a 00                	pushq  $0x0
  push $57
ffff80000010aa7d:	6a 39                	pushq  $0x39
  jmp alltraps
ffff80000010aa7f:	e9 17 f5 ff ff       	jmpq   ffff800000109f9b <alltraps>

ffff80000010aa84 <vector58>:
vector58:
  push $0
ffff80000010aa84:	6a 00                	pushq  $0x0
  push $58
ffff80000010aa86:	6a 3a                	pushq  $0x3a
  jmp alltraps
ffff80000010aa88:	e9 0e f5 ff ff       	jmpq   ffff800000109f9b <alltraps>

ffff80000010aa8d <vector59>:
vector59:
  push $0
ffff80000010aa8d:	6a 00                	pushq  $0x0
  push $59
ffff80000010aa8f:	6a 3b                	pushq  $0x3b
  jmp alltraps
ffff80000010aa91:	e9 05 f5 ff ff       	jmpq   ffff800000109f9b <alltraps>

ffff80000010aa96 <vector60>:
vector60:
  push $0
ffff80000010aa96:	6a 00                	pushq  $0x0
  push $60
ffff80000010aa98:	6a 3c                	pushq  $0x3c
  jmp alltraps
ffff80000010aa9a:	e9 fc f4 ff ff       	jmpq   ffff800000109f9b <alltraps>

ffff80000010aa9f <vector61>:
vector61:
  push $0
ffff80000010aa9f:	6a 00                	pushq  $0x0
  push $61
ffff80000010aaa1:	6a 3d                	pushq  $0x3d
  jmp alltraps
ffff80000010aaa3:	e9 f3 f4 ff ff       	jmpq   ffff800000109f9b <alltraps>

ffff80000010aaa8 <vector62>:
vector62:
  push $0
ffff80000010aaa8:	6a 00                	pushq  $0x0
  push $62
ffff80000010aaaa:	6a 3e                	pushq  $0x3e
  jmp alltraps
ffff80000010aaac:	e9 ea f4 ff ff       	jmpq   ffff800000109f9b <alltraps>

ffff80000010aab1 <vector63>:
vector63:
  push $0
ffff80000010aab1:	6a 00                	pushq  $0x0
  push $63
ffff80000010aab3:	6a 3f                	pushq  $0x3f
  jmp alltraps
ffff80000010aab5:	e9 e1 f4 ff ff       	jmpq   ffff800000109f9b <alltraps>

ffff80000010aaba <vector64>:
vector64:
  push $0
ffff80000010aaba:	6a 00                	pushq  $0x0
  push $64
ffff80000010aabc:	6a 40                	pushq  $0x40
  jmp alltraps
ffff80000010aabe:	e9 d8 f4 ff ff       	jmpq   ffff800000109f9b <alltraps>

ffff80000010aac3 <vector65>:
vector65:
  push $0
ffff80000010aac3:	6a 00                	pushq  $0x0
  push $65
ffff80000010aac5:	6a 41                	pushq  $0x41
  jmp alltraps
ffff80000010aac7:	e9 cf f4 ff ff       	jmpq   ffff800000109f9b <alltraps>

ffff80000010aacc <vector66>:
vector66:
  push $0
ffff80000010aacc:	6a 00                	pushq  $0x0
  push $66
ffff80000010aace:	6a 42                	pushq  $0x42
  jmp alltraps
ffff80000010aad0:	e9 c6 f4 ff ff       	jmpq   ffff800000109f9b <alltraps>

ffff80000010aad5 <vector67>:
vector67:
  push $0
ffff80000010aad5:	6a 00                	pushq  $0x0
  push $67
ffff80000010aad7:	6a 43                	pushq  $0x43
  jmp alltraps
ffff80000010aad9:	e9 bd f4 ff ff       	jmpq   ffff800000109f9b <alltraps>

ffff80000010aade <vector68>:
vector68:
  push $0
ffff80000010aade:	6a 00                	pushq  $0x0
  push $68
ffff80000010aae0:	6a 44                	pushq  $0x44
  jmp alltraps
ffff80000010aae2:	e9 b4 f4 ff ff       	jmpq   ffff800000109f9b <alltraps>

ffff80000010aae7 <vector69>:
vector69:
  push $0
ffff80000010aae7:	6a 00                	pushq  $0x0
  push $69
ffff80000010aae9:	6a 45                	pushq  $0x45
  jmp alltraps
ffff80000010aaeb:	e9 ab f4 ff ff       	jmpq   ffff800000109f9b <alltraps>

ffff80000010aaf0 <vector70>:
vector70:
  push $0
ffff80000010aaf0:	6a 00                	pushq  $0x0
  push $70
ffff80000010aaf2:	6a 46                	pushq  $0x46
  jmp alltraps
ffff80000010aaf4:	e9 a2 f4 ff ff       	jmpq   ffff800000109f9b <alltraps>

ffff80000010aaf9 <vector71>:
vector71:
  push $0
ffff80000010aaf9:	6a 00                	pushq  $0x0
  push $71
ffff80000010aafb:	6a 47                	pushq  $0x47
  jmp alltraps
ffff80000010aafd:	e9 99 f4 ff ff       	jmpq   ffff800000109f9b <alltraps>

ffff80000010ab02 <vector72>:
vector72:
  push $0
ffff80000010ab02:	6a 00                	pushq  $0x0
  push $72
ffff80000010ab04:	6a 48                	pushq  $0x48
  jmp alltraps
ffff80000010ab06:	e9 90 f4 ff ff       	jmpq   ffff800000109f9b <alltraps>

ffff80000010ab0b <vector73>:
vector73:
  push $0
ffff80000010ab0b:	6a 00                	pushq  $0x0
  push $73
ffff80000010ab0d:	6a 49                	pushq  $0x49
  jmp alltraps
ffff80000010ab0f:	e9 87 f4 ff ff       	jmpq   ffff800000109f9b <alltraps>

ffff80000010ab14 <vector74>:
vector74:
  push $0
ffff80000010ab14:	6a 00                	pushq  $0x0
  push $74
ffff80000010ab16:	6a 4a                	pushq  $0x4a
  jmp alltraps
ffff80000010ab18:	e9 7e f4 ff ff       	jmpq   ffff800000109f9b <alltraps>

ffff80000010ab1d <vector75>:
vector75:
  push $0
ffff80000010ab1d:	6a 00                	pushq  $0x0
  push $75
ffff80000010ab1f:	6a 4b                	pushq  $0x4b
  jmp alltraps
ffff80000010ab21:	e9 75 f4 ff ff       	jmpq   ffff800000109f9b <alltraps>

ffff80000010ab26 <vector76>:
vector76:
  push $0
ffff80000010ab26:	6a 00                	pushq  $0x0
  push $76
ffff80000010ab28:	6a 4c                	pushq  $0x4c
  jmp alltraps
ffff80000010ab2a:	e9 6c f4 ff ff       	jmpq   ffff800000109f9b <alltraps>

ffff80000010ab2f <vector77>:
vector77:
  push $0
ffff80000010ab2f:	6a 00                	pushq  $0x0
  push $77
ffff80000010ab31:	6a 4d                	pushq  $0x4d
  jmp alltraps
ffff80000010ab33:	e9 63 f4 ff ff       	jmpq   ffff800000109f9b <alltraps>

ffff80000010ab38 <vector78>:
vector78:
  push $0
ffff80000010ab38:	6a 00                	pushq  $0x0
  push $78
ffff80000010ab3a:	6a 4e                	pushq  $0x4e
  jmp alltraps
ffff80000010ab3c:	e9 5a f4 ff ff       	jmpq   ffff800000109f9b <alltraps>

ffff80000010ab41 <vector79>:
vector79:
  push $0
ffff80000010ab41:	6a 00                	pushq  $0x0
  push $79
ffff80000010ab43:	6a 4f                	pushq  $0x4f
  jmp alltraps
ffff80000010ab45:	e9 51 f4 ff ff       	jmpq   ffff800000109f9b <alltraps>

ffff80000010ab4a <vector80>:
vector80:
  push $0
ffff80000010ab4a:	6a 00                	pushq  $0x0
  push $80
ffff80000010ab4c:	6a 50                	pushq  $0x50
  jmp alltraps
ffff80000010ab4e:	e9 48 f4 ff ff       	jmpq   ffff800000109f9b <alltraps>

ffff80000010ab53 <vector81>:
vector81:
  push $0
ffff80000010ab53:	6a 00                	pushq  $0x0
  push $81
ffff80000010ab55:	6a 51                	pushq  $0x51
  jmp alltraps
ffff80000010ab57:	e9 3f f4 ff ff       	jmpq   ffff800000109f9b <alltraps>

ffff80000010ab5c <vector82>:
vector82:
  push $0
ffff80000010ab5c:	6a 00                	pushq  $0x0
  push $82
ffff80000010ab5e:	6a 52                	pushq  $0x52
  jmp alltraps
ffff80000010ab60:	e9 36 f4 ff ff       	jmpq   ffff800000109f9b <alltraps>

ffff80000010ab65 <vector83>:
vector83:
  push $0
ffff80000010ab65:	6a 00                	pushq  $0x0
  push $83
ffff80000010ab67:	6a 53                	pushq  $0x53
  jmp alltraps
ffff80000010ab69:	e9 2d f4 ff ff       	jmpq   ffff800000109f9b <alltraps>

ffff80000010ab6e <vector84>:
vector84:
  push $0
ffff80000010ab6e:	6a 00                	pushq  $0x0
  push $84
ffff80000010ab70:	6a 54                	pushq  $0x54
  jmp alltraps
ffff80000010ab72:	e9 24 f4 ff ff       	jmpq   ffff800000109f9b <alltraps>

ffff80000010ab77 <vector85>:
vector85:
  push $0
ffff80000010ab77:	6a 00                	pushq  $0x0
  push $85
ffff80000010ab79:	6a 55                	pushq  $0x55
  jmp alltraps
ffff80000010ab7b:	e9 1b f4 ff ff       	jmpq   ffff800000109f9b <alltraps>

ffff80000010ab80 <vector86>:
vector86:
  push $0
ffff80000010ab80:	6a 00                	pushq  $0x0
  push $86
ffff80000010ab82:	6a 56                	pushq  $0x56
  jmp alltraps
ffff80000010ab84:	e9 12 f4 ff ff       	jmpq   ffff800000109f9b <alltraps>

ffff80000010ab89 <vector87>:
vector87:
  push $0
ffff80000010ab89:	6a 00                	pushq  $0x0
  push $87
ffff80000010ab8b:	6a 57                	pushq  $0x57
  jmp alltraps
ffff80000010ab8d:	e9 09 f4 ff ff       	jmpq   ffff800000109f9b <alltraps>

ffff80000010ab92 <vector88>:
vector88:
  push $0
ffff80000010ab92:	6a 00                	pushq  $0x0
  push $88
ffff80000010ab94:	6a 58                	pushq  $0x58
  jmp alltraps
ffff80000010ab96:	e9 00 f4 ff ff       	jmpq   ffff800000109f9b <alltraps>

ffff80000010ab9b <vector89>:
vector89:
  push $0
ffff80000010ab9b:	6a 00                	pushq  $0x0
  push $89
ffff80000010ab9d:	6a 59                	pushq  $0x59
  jmp alltraps
ffff80000010ab9f:	e9 f7 f3 ff ff       	jmpq   ffff800000109f9b <alltraps>

ffff80000010aba4 <vector90>:
vector90:
  push $0
ffff80000010aba4:	6a 00                	pushq  $0x0
  push $90
ffff80000010aba6:	6a 5a                	pushq  $0x5a
  jmp alltraps
ffff80000010aba8:	e9 ee f3 ff ff       	jmpq   ffff800000109f9b <alltraps>

ffff80000010abad <vector91>:
vector91:
  push $0
ffff80000010abad:	6a 00                	pushq  $0x0
  push $91
ffff80000010abaf:	6a 5b                	pushq  $0x5b
  jmp alltraps
ffff80000010abb1:	e9 e5 f3 ff ff       	jmpq   ffff800000109f9b <alltraps>

ffff80000010abb6 <vector92>:
vector92:
  push $0
ffff80000010abb6:	6a 00                	pushq  $0x0
  push $92
ffff80000010abb8:	6a 5c                	pushq  $0x5c
  jmp alltraps
ffff80000010abba:	e9 dc f3 ff ff       	jmpq   ffff800000109f9b <alltraps>

ffff80000010abbf <vector93>:
vector93:
  push $0
ffff80000010abbf:	6a 00                	pushq  $0x0
  push $93
ffff80000010abc1:	6a 5d                	pushq  $0x5d
  jmp alltraps
ffff80000010abc3:	e9 d3 f3 ff ff       	jmpq   ffff800000109f9b <alltraps>

ffff80000010abc8 <vector94>:
vector94:
  push $0
ffff80000010abc8:	6a 00                	pushq  $0x0
  push $94
ffff80000010abca:	6a 5e                	pushq  $0x5e
  jmp alltraps
ffff80000010abcc:	e9 ca f3 ff ff       	jmpq   ffff800000109f9b <alltraps>

ffff80000010abd1 <vector95>:
vector95:
  push $0
ffff80000010abd1:	6a 00                	pushq  $0x0
  push $95
ffff80000010abd3:	6a 5f                	pushq  $0x5f
  jmp alltraps
ffff80000010abd5:	e9 c1 f3 ff ff       	jmpq   ffff800000109f9b <alltraps>

ffff80000010abda <vector96>:
vector96:
  push $0
ffff80000010abda:	6a 00                	pushq  $0x0
  push $96
ffff80000010abdc:	6a 60                	pushq  $0x60
  jmp alltraps
ffff80000010abde:	e9 b8 f3 ff ff       	jmpq   ffff800000109f9b <alltraps>

ffff80000010abe3 <vector97>:
vector97:
  push $0
ffff80000010abe3:	6a 00                	pushq  $0x0
  push $97
ffff80000010abe5:	6a 61                	pushq  $0x61
  jmp alltraps
ffff80000010abe7:	e9 af f3 ff ff       	jmpq   ffff800000109f9b <alltraps>

ffff80000010abec <vector98>:
vector98:
  push $0
ffff80000010abec:	6a 00                	pushq  $0x0
  push $98
ffff80000010abee:	6a 62                	pushq  $0x62
  jmp alltraps
ffff80000010abf0:	e9 a6 f3 ff ff       	jmpq   ffff800000109f9b <alltraps>

ffff80000010abf5 <vector99>:
vector99:
  push $0
ffff80000010abf5:	6a 00                	pushq  $0x0
  push $99
ffff80000010abf7:	6a 63                	pushq  $0x63
  jmp alltraps
ffff80000010abf9:	e9 9d f3 ff ff       	jmpq   ffff800000109f9b <alltraps>

ffff80000010abfe <vector100>:
vector100:
  push $0
ffff80000010abfe:	6a 00                	pushq  $0x0
  push $100
ffff80000010ac00:	6a 64                	pushq  $0x64
  jmp alltraps
ffff80000010ac02:	e9 94 f3 ff ff       	jmpq   ffff800000109f9b <alltraps>

ffff80000010ac07 <vector101>:
vector101:
  push $0
ffff80000010ac07:	6a 00                	pushq  $0x0
  push $101
ffff80000010ac09:	6a 65                	pushq  $0x65
  jmp alltraps
ffff80000010ac0b:	e9 8b f3 ff ff       	jmpq   ffff800000109f9b <alltraps>

ffff80000010ac10 <vector102>:
vector102:
  push $0
ffff80000010ac10:	6a 00                	pushq  $0x0
  push $102
ffff80000010ac12:	6a 66                	pushq  $0x66
  jmp alltraps
ffff80000010ac14:	e9 82 f3 ff ff       	jmpq   ffff800000109f9b <alltraps>

ffff80000010ac19 <vector103>:
vector103:
  push $0
ffff80000010ac19:	6a 00                	pushq  $0x0
  push $103
ffff80000010ac1b:	6a 67                	pushq  $0x67
  jmp alltraps
ffff80000010ac1d:	e9 79 f3 ff ff       	jmpq   ffff800000109f9b <alltraps>

ffff80000010ac22 <vector104>:
vector104:
  push $0
ffff80000010ac22:	6a 00                	pushq  $0x0
  push $104
ffff80000010ac24:	6a 68                	pushq  $0x68
  jmp alltraps
ffff80000010ac26:	e9 70 f3 ff ff       	jmpq   ffff800000109f9b <alltraps>

ffff80000010ac2b <vector105>:
vector105:
  push $0
ffff80000010ac2b:	6a 00                	pushq  $0x0
  push $105
ffff80000010ac2d:	6a 69                	pushq  $0x69
  jmp alltraps
ffff80000010ac2f:	e9 67 f3 ff ff       	jmpq   ffff800000109f9b <alltraps>

ffff80000010ac34 <vector106>:
vector106:
  push $0
ffff80000010ac34:	6a 00                	pushq  $0x0
  push $106
ffff80000010ac36:	6a 6a                	pushq  $0x6a
  jmp alltraps
ffff80000010ac38:	e9 5e f3 ff ff       	jmpq   ffff800000109f9b <alltraps>

ffff80000010ac3d <vector107>:
vector107:
  push $0
ffff80000010ac3d:	6a 00                	pushq  $0x0
  push $107
ffff80000010ac3f:	6a 6b                	pushq  $0x6b
  jmp alltraps
ffff80000010ac41:	e9 55 f3 ff ff       	jmpq   ffff800000109f9b <alltraps>

ffff80000010ac46 <vector108>:
vector108:
  push $0
ffff80000010ac46:	6a 00                	pushq  $0x0
  push $108
ffff80000010ac48:	6a 6c                	pushq  $0x6c
  jmp alltraps
ffff80000010ac4a:	e9 4c f3 ff ff       	jmpq   ffff800000109f9b <alltraps>

ffff80000010ac4f <vector109>:
vector109:
  push $0
ffff80000010ac4f:	6a 00                	pushq  $0x0
  push $109
ffff80000010ac51:	6a 6d                	pushq  $0x6d
  jmp alltraps
ffff80000010ac53:	e9 43 f3 ff ff       	jmpq   ffff800000109f9b <alltraps>

ffff80000010ac58 <vector110>:
vector110:
  push $0
ffff80000010ac58:	6a 00                	pushq  $0x0
  push $110
ffff80000010ac5a:	6a 6e                	pushq  $0x6e
  jmp alltraps
ffff80000010ac5c:	e9 3a f3 ff ff       	jmpq   ffff800000109f9b <alltraps>

ffff80000010ac61 <vector111>:
vector111:
  push $0
ffff80000010ac61:	6a 00                	pushq  $0x0
  push $111
ffff80000010ac63:	6a 6f                	pushq  $0x6f
  jmp alltraps
ffff80000010ac65:	e9 31 f3 ff ff       	jmpq   ffff800000109f9b <alltraps>

ffff80000010ac6a <vector112>:
vector112:
  push $0
ffff80000010ac6a:	6a 00                	pushq  $0x0
  push $112
ffff80000010ac6c:	6a 70                	pushq  $0x70
  jmp alltraps
ffff80000010ac6e:	e9 28 f3 ff ff       	jmpq   ffff800000109f9b <alltraps>

ffff80000010ac73 <vector113>:
vector113:
  push $0
ffff80000010ac73:	6a 00                	pushq  $0x0
  push $113
ffff80000010ac75:	6a 71                	pushq  $0x71
  jmp alltraps
ffff80000010ac77:	e9 1f f3 ff ff       	jmpq   ffff800000109f9b <alltraps>

ffff80000010ac7c <vector114>:
vector114:
  push $0
ffff80000010ac7c:	6a 00                	pushq  $0x0
  push $114
ffff80000010ac7e:	6a 72                	pushq  $0x72
  jmp alltraps
ffff80000010ac80:	e9 16 f3 ff ff       	jmpq   ffff800000109f9b <alltraps>

ffff80000010ac85 <vector115>:
vector115:
  push $0
ffff80000010ac85:	6a 00                	pushq  $0x0
  push $115
ffff80000010ac87:	6a 73                	pushq  $0x73
  jmp alltraps
ffff80000010ac89:	e9 0d f3 ff ff       	jmpq   ffff800000109f9b <alltraps>

ffff80000010ac8e <vector116>:
vector116:
  push $0
ffff80000010ac8e:	6a 00                	pushq  $0x0
  push $116
ffff80000010ac90:	6a 74                	pushq  $0x74
  jmp alltraps
ffff80000010ac92:	e9 04 f3 ff ff       	jmpq   ffff800000109f9b <alltraps>

ffff80000010ac97 <vector117>:
vector117:
  push $0
ffff80000010ac97:	6a 00                	pushq  $0x0
  push $117
ffff80000010ac99:	6a 75                	pushq  $0x75
  jmp alltraps
ffff80000010ac9b:	e9 fb f2 ff ff       	jmpq   ffff800000109f9b <alltraps>

ffff80000010aca0 <vector118>:
vector118:
  push $0
ffff80000010aca0:	6a 00                	pushq  $0x0
  push $118
ffff80000010aca2:	6a 76                	pushq  $0x76
  jmp alltraps
ffff80000010aca4:	e9 f2 f2 ff ff       	jmpq   ffff800000109f9b <alltraps>

ffff80000010aca9 <vector119>:
vector119:
  push $0
ffff80000010aca9:	6a 00                	pushq  $0x0
  push $119
ffff80000010acab:	6a 77                	pushq  $0x77
  jmp alltraps
ffff80000010acad:	e9 e9 f2 ff ff       	jmpq   ffff800000109f9b <alltraps>

ffff80000010acb2 <vector120>:
vector120:
  push $0
ffff80000010acb2:	6a 00                	pushq  $0x0
  push $120
ffff80000010acb4:	6a 78                	pushq  $0x78
  jmp alltraps
ffff80000010acb6:	e9 e0 f2 ff ff       	jmpq   ffff800000109f9b <alltraps>

ffff80000010acbb <vector121>:
vector121:
  push $0
ffff80000010acbb:	6a 00                	pushq  $0x0
  push $121
ffff80000010acbd:	6a 79                	pushq  $0x79
  jmp alltraps
ffff80000010acbf:	e9 d7 f2 ff ff       	jmpq   ffff800000109f9b <alltraps>

ffff80000010acc4 <vector122>:
vector122:
  push $0
ffff80000010acc4:	6a 00                	pushq  $0x0
  push $122
ffff80000010acc6:	6a 7a                	pushq  $0x7a
  jmp alltraps
ffff80000010acc8:	e9 ce f2 ff ff       	jmpq   ffff800000109f9b <alltraps>

ffff80000010accd <vector123>:
vector123:
  push $0
ffff80000010accd:	6a 00                	pushq  $0x0
  push $123
ffff80000010accf:	6a 7b                	pushq  $0x7b
  jmp alltraps
ffff80000010acd1:	e9 c5 f2 ff ff       	jmpq   ffff800000109f9b <alltraps>

ffff80000010acd6 <vector124>:
vector124:
  push $0
ffff80000010acd6:	6a 00                	pushq  $0x0
  push $124
ffff80000010acd8:	6a 7c                	pushq  $0x7c
  jmp alltraps
ffff80000010acda:	e9 bc f2 ff ff       	jmpq   ffff800000109f9b <alltraps>

ffff80000010acdf <vector125>:
vector125:
  push $0
ffff80000010acdf:	6a 00                	pushq  $0x0
  push $125
ffff80000010ace1:	6a 7d                	pushq  $0x7d
  jmp alltraps
ffff80000010ace3:	e9 b3 f2 ff ff       	jmpq   ffff800000109f9b <alltraps>

ffff80000010ace8 <vector126>:
vector126:
  push $0
ffff80000010ace8:	6a 00                	pushq  $0x0
  push $126
ffff80000010acea:	6a 7e                	pushq  $0x7e
  jmp alltraps
ffff80000010acec:	e9 aa f2 ff ff       	jmpq   ffff800000109f9b <alltraps>

ffff80000010acf1 <vector127>:
vector127:
  push $0
ffff80000010acf1:	6a 00                	pushq  $0x0
  push $127
ffff80000010acf3:	6a 7f                	pushq  $0x7f
  jmp alltraps
ffff80000010acf5:	e9 a1 f2 ff ff       	jmpq   ffff800000109f9b <alltraps>

ffff80000010acfa <vector128>:
vector128:
  push $0
ffff80000010acfa:	6a 00                	pushq  $0x0
  push $128
ffff80000010acfc:	68 80 00 00 00       	pushq  $0x80
  jmp alltraps
ffff80000010ad01:	e9 95 f2 ff ff       	jmpq   ffff800000109f9b <alltraps>

ffff80000010ad06 <vector129>:
vector129:
  push $0
ffff80000010ad06:	6a 00                	pushq  $0x0
  push $129
ffff80000010ad08:	68 81 00 00 00       	pushq  $0x81
  jmp alltraps
ffff80000010ad0d:	e9 89 f2 ff ff       	jmpq   ffff800000109f9b <alltraps>

ffff80000010ad12 <vector130>:
vector130:
  push $0
ffff80000010ad12:	6a 00                	pushq  $0x0
  push $130
ffff80000010ad14:	68 82 00 00 00       	pushq  $0x82
  jmp alltraps
ffff80000010ad19:	e9 7d f2 ff ff       	jmpq   ffff800000109f9b <alltraps>

ffff80000010ad1e <vector131>:
vector131:
  push $0
ffff80000010ad1e:	6a 00                	pushq  $0x0
  push $131
ffff80000010ad20:	68 83 00 00 00       	pushq  $0x83
  jmp alltraps
ffff80000010ad25:	e9 71 f2 ff ff       	jmpq   ffff800000109f9b <alltraps>

ffff80000010ad2a <vector132>:
vector132:
  push $0
ffff80000010ad2a:	6a 00                	pushq  $0x0
  push $132
ffff80000010ad2c:	68 84 00 00 00       	pushq  $0x84
  jmp alltraps
ffff80000010ad31:	e9 65 f2 ff ff       	jmpq   ffff800000109f9b <alltraps>

ffff80000010ad36 <vector133>:
vector133:
  push $0
ffff80000010ad36:	6a 00                	pushq  $0x0
  push $133
ffff80000010ad38:	68 85 00 00 00       	pushq  $0x85
  jmp alltraps
ffff80000010ad3d:	e9 59 f2 ff ff       	jmpq   ffff800000109f9b <alltraps>

ffff80000010ad42 <vector134>:
vector134:
  push $0
ffff80000010ad42:	6a 00                	pushq  $0x0
  push $134
ffff80000010ad44:	68 86 00 00 00       	pushq  $0x86
  jmp alltraps
ffff80000010ad49:	e9 4d f2 ff ff       	jmpq   ffff800000109f9b <alltraps>

ffff80000010ad4e <vector135>:
vector135:
  push $0
ffff80000010ad4e:	6a 00                	pushq  $0x0
  push $135
ffff80000010ad50:	68 87 00 00 00       	pushq  $0x87
  jmp alltraps
ffff80000010ad55:	e9 41 f2 ff ff       	jmpq   ffff800000109f9b <alltraps>

ffff80000010ad5a <vector136>:
vector136:
  push $0
ffff80000010ad5a:	6a 00                	pushq  $0x0
  push $136
ffff80000010ad5c:	68 88 00 00 00       	pushq  $0x88
  jmp alltraps
ffff80000010ad61:	e9 35 f2 ff ff       	jmpq   ffff800000109f9b <alltraps>

ffff80000010ad66 <vector137>:
vector137:
  push $0
ffff80000010ad66:	6a 00                	pushq  $0x0
  push $137
ffff80000010ad68:	68 89 00 00 00       	pushq  $0x89
  jmp alltraps
ffff80000010ad6d:	e9 29 f2 ff ff       	jmpq   ffff800000109f9b <alltraps>

ffff80000010ad72 <vector138>:
vector138:
  push $0
ffff80000010ad72:	6a 00                	pushq  $0x0
  push $138
ffff80000010ad74:	68 8a 00 00 00       	pushq  $0x8a
  jmp alltraps
ffff80000010ad79:	e9 1d f2 ff ff       	jmpq   ffff800000109f9b <alltraps>

ffff80000010ad7e <vector139>:
vector139:
  push $0
ffff80000010ad7e:	6a 00                	pushq  $0x0
  push $139
ffff80000010ad80:	68 8b 00 00 00       	pushq  $0x8b
  jmp alltraps
ffff80000010ad85:	e9 11 f2 ff ff       	jmpq   ffff800000109f9b <alltraps>

ffff80000010ad8a <vector140>:
vector140:
  push $0
ffff80000010ad8a:	6a 00                	pushq  $0x0
  push $140
ffff80000010ad8c:	68 8c 00 00 00       	pushq  $0x8c
  jmp alltraps
ffff80000010ad91:	e9 05 f2 ff ff       	jmpq   ffff800000109f9b <alltraps>

ffff80000010ad96 <vector141>:
vector141:
  push $0
ffff80000010ad96:	6a 00                	pushq  $0x0
  push $141
ffff80000010ad98:	68 8d 00 00 00       	pushq  $0x8d
  jmp alltraps
ffff80000010ad9d:	e9 f9 f1 ff ff       	jmpq   ffff800000109f9b <alltraps>

ffff80000010ada2 <vector142>:
vector142:
  push $0
ffff80000010ada2:	6a 00                	pushq  $0x0
  push $142
ffff80000010ada4:	68 8e 00 00 00       	pushq  $0x8e
  jmp alltraps
ffff80000010ada9:	e9 ed f1 ff ff       	jmpq   ffff800000109f9b <alltraps>

ffff80000010adae <vector143>:
vector143:
  push $0
ffff80000010adae:	6a 00                	pushq  $0x0
  push $143
ffff80000010adb0:	68 8f 00 00 00       	pushq  $0x8f
  jmp alltraps
ffff80000010adb5:	e9 e1 f1 ff ff       	jmpq   ffff800000109f9b <alltraps>

ffff80000010adba <vector144>:
vector144:
  push $0
ffff80000010adba:	6a 00                	pushq  $0x0
  push $144
ffff80000010adbc:	68 90 00 00 00       	pushq  $0x90
  jmp alltraps
ffff80000010adc1:	e9 d5 f1 ff ff       	jmpq   ffff800000109f9b <alltraps>

ffff80000010adc6 <vector145>:
vector145:
  push $0
ffff80000010adc6:	6a 00                	pushq  $0x0
  push $145
ffff80000010adc8:	68 91 00 00 00       	pushq  $0x91
  jmp alltraps
ffff80000010adcd:	e9 c9 f1 ff ff       	jmpq   ffff800000109f9b <alltraps>

ffff80000010add2 <vector146>:
vector146:
  push $0
ffff80000010add2:	6a 00                	pushq  $0x0
  push $146
ffff80000010add4:	68 92 00 00 00       	pushq  $0x92
  jmp alltraps
ffff80000010add9:	e9 bd f1 ff ff       	jmpq   ffff800000109f9b <alltraps>

ffff80000010adde <vector147>:
vector147:
  push $0
ffff80000010adde:	6a 00                	pushq  $0x0
  push $147
ffff80000010ade0:	68 93 00 00 00       	pushq  $0x93
  jmp alltraps
ffff80000010ade5:	e9 b1 f1 ff ff       	jmpq   ffff800000109f9b <alltraps>

ffff80000010adea <vector148>:
vector148:
  push $0
ffff80000010adea:	6a 00                	pushq  $0x0
  push $148
ffff80000010adec:	68 94 00 00 00       	pushq  $0x94
  jmp alltraps
ffff80000010adf1:	e9 a5 f1 ff ff       	jmpq   ffff800000109f9b <alltraps>

ffff80000010adf6 <vector149>:
vector149:
  push $0
ffff80000010adf6:	6a 00                	pushq  $0x0
  push $149
ffff80000010adf8:	68 95 00 00 00       	pushq  $0x95
  jmp alltraps
ffff80000010adfd:	e9 99 f1 ff ff       	jmpq   ffff800000109f9b <alltraps>

ffff80000010ae02 <vector150>:
vector150:
  push $0
ffff80000010ae02:	6a 00                	pushq  $0x0
  push $150
ffff80000010ae04:	68 96 00 00 00       	pushq  $0x96
  jmp alltraps
ffff80000010ae09:	e9 8d f1 ff ff       	jmpq   ffff800000109f9b <alltraps>

ffff80000010ae0e <vector151>:
vector151:
  push $0
ffff80000010ae0e:	6a 00                	pushq  $0x0
  push $151
ffff80000010ae10:	68 97 00 00 00       	pushq  $0x97
  jmp alltraps
ffff80000010ae15:	e9 81 f1 ff ff       	jmpq   ffff800000109f9b <alltraps>

ffff80000010ae1a <vector152>:
vector152:
  push $0
ffff80000010ae1a:	6a 00                	pushq  $0x0
  push $152
ffff80000010ae1c:	68 98 00 00 00       	pushq  $0x98
  jmp alltraps
ffff80000010ae21:	e9 75 f1 ff ff       	jmpq   ffff800000109f9b <alltraps>

ffff80000010ae26 <vector153>:
vector153:
  push $0
ffff80000010ae26:	6a 00                	pushq  $0x0
  push $153
ffff80000010ae28:	68 99 00 00 00       	pushq  $0x99
  jmp alltraps
ffff80000010ae2d:	e9 69 f1 ff ff       	jmpq   ffff800000109f9b <alltraps>

ffff80000010ae32 <vector154>:
vector154:
  push $0
ffff80000010ae32:	6a 00                	pushq  $0x0
  push $154
ffff80000010ae34:	68 9a 00 00 00       	pushq  $0x9a
  jmp alltraps
ffff80000010ae39:	e9 5d f1 ff ff       	jmpq   ffff800000109f9b <alltraps>

ffff80000010ae3e <vector155>:
vector155:
  push $0
ffff80000010ae3e:	6a 00                	pushq  $0x0
  push $155
ffff80000010ae40:	68 9b 00 00 00       	pushq  $0x9b
  jmp alltraps
ffff80000010ae45:	e9 51 f1 ff ff       	jmpq   ffff800000109f9b <alltraps>

ffff80000010ae4a <vector156>:
vector156:
  push $0
ffff80000010ae4a:	6a 00                	pushq  $0x0
  push $156
ffff80000010ae4c:	68 9c 00 00 00       	pushq  $0x9c
  jmp alltraps
ffff80000010ae51:	e9 45 f1 ff ff       	jmpq   ffff800000109f9b <alltraps>

ffff80000010ae56 <vector157>:
vector157:
  push $0
ffff80000010ae56:	6a 00                	pushq  $0x0
  push $157
ffff80000010ae58:	68 9d 00 00 00       	pushq  $0x9d
  jmp alltraps
ffff80000010ae5d:	e9 39 f1 ff ff       	jmpq   ffff800000109f9b <alltraps>

ffff80000010ae62 <vector158>:
vector158:
  push $0
ffff80000010ae62:	6a 00                	pushq  $0x0
  push $158
ffff80000010ae64:	68 9e 00 00 00       	pushq  $0x9e
  jmp alltraps
ffff80000010ae69:	e9 2d f1 ff ff       	jmpq   ffff800000109f9b <alltraps>

ffff80000010ae6e <vector159>:
vector159:
  push $0
ffff80000010ae6e:	6a 00                	pushq  $0x0
  push $159
ffff80000010ae70:	68 9f 00 00 00       	pushq  $0x9f
  jmp alltraps
ffff80000010ae75:	e9 21 f1 ff ff       	jmpq   ffff800000109f9b <alltraps>

ffff80000010ae7a <vector160>:
vector160:
  push $0
ffff80000010ae7a:	6a 00                	pushq  $0x0
  push $160
ffff80000010ae7c:	68 a0 00 00 00       	pushq  $0xa0
  jmp alltraps
ffff80000010ae81:	e9 15 f1 ff ff       	jmpq   ffff800000109f9b <alltraps>

ffff80000010ae86 <vector161>:
vector161:
  push $0
ffff80000010ae86:	6a 00                	pushq  $0x0
  push $161
ffff80000010ae88:	68 a1 00 00 00       	pushq  $0xa1
  jmp alltraps
ffff80000010ae8d:	e9 09 f1 ff ff       	jmpq   ffff800000109f9b <alltraps>

ffff80000010ae92 <vector162>:
vector162:
  push $0
ffff80000010ae92:	6a 00                	pushq  $0x0
  push $162
ffff80000010ae94:	68 a2 00 00 00       	pushq  $0xa2
  jmp alltraps
ffff80000010ae99:	e9 fd f0 ff ff       	jmpq   ffff800000109f9b <alltraps>

ffff80000010ae9e <vector163>:
vector163:
  push $0
ffff80000010ae9e:	6a 00                	pushq  $0x0
  push $163
ffff80000010aea0:	68 a3 00 00 00       	pushq  $0xa3
  jmp alltraps
ffff80000010aea5:	e9 f1 f0 ff ff       	jmpq   ffff800000109f9b <alltraps>

ffff80000010aeaa <vector164>:
vector164:
  push $0
ffff80000010aeaa:	6a 00                	pushq  $0x0
  push $164
ffff80000010aeac:	68 a4 00 00 00       	pushq  $0xa4
  jmp alltraps
ffff80000010aeb1:	e9 e5 f0 ff ff       	jmpq   ffff800000109f9b <alltraps>

ffff80000010aeb6 <vector165>:
vector165:
  push $0
ffff80000010aeb6:	6a 00                	pushq  $0x0
  push $165
ffff80000010aeb8:	68 a5 00 00 00       	pushq  $0xa5
  jmp alltraps
ffff80000010aebd:	e9 d9 f0 ff ff       	jmpq   ffff800000109f9b <alltraps>

ffff80000010aec2 <vector166>:
vector166:
  push $0
ffff80000010aec2:	6a 00                	pushq  $0x0
  push $166
ffff80000010aec4:	68 a6 00 00 00       	pushq  $0xa6
  jmp alltraps
ffff80000010aec9:	e9 cd f0 ff ff       	jmpq   ffff800000109f9b <alltraps>

ffff80000010aece <vector167>:
vector167:
  push $0
ffff80000010aece:	6a 00                	pushq  $0x0
  push $167
ffff80000010aed0:	68 a7 00 00 00       	pushq  $0xa7
  jmp alltraps
ffff80000010aed5:	e9 c1 f0 ff ff       	jmpq   ffff800000109f9b <alltraps>

ffff80000010aeda <vector168>:
vector168:
  push $0
ffff80000010aeda:	6a 00                	pushq  $0x0
  push $168
ffff80000010aedc:	68 a8 00 00 00       	pushq  $0xa8
  jmp alltraps
ffff80000010aee1:	e9 b5 f0 ff ff       	jmpq   ffff800000109f9b <alltraps>

ffff80000010aee6 <vector169>:
vector169:
  push $0
ffff80000010aee6:	6a 00                	pushq  $0x0
  push $169
ffff80000010aee8:	68 a9 00 00 00       	pushq  $0xa9
  jmp alltraps
ffff80000010aeed:	e9 a9 f0 ff ff       	jmpq   ffff800000109f9b <alltraps>

ffff80000010aef2 <vector170>:
vector170:
  push $0
ffff80000010aef2:	6a 00                	pushq  $0x0
  push $170
ffff80000010aef4:	68 aa 00 00 00       	pushq  $0xaa
  jmp alltraps
ffff80000010aef9:	e9 9d f0 ff ff       	jmpq   ffff800000109f9b <alltraps>

ffff80000010aefe <vector171>:
vector171:
  push $0
ffff80000010aefe:	6a 00                	pushq  $0x0
  push $171
ffff80000010af00:	68 ab 00 00 00       	pushq  $0xab
  jmp alltraps
ffff80000010af05:	e9 91 f0 ff ff       	jmpq   ffff800000109f9b <alltraps>

ffff80000010af0a <vector172>:
vector172:
  push $0
ffff80000010af0a:	6a 00                	pushq  $0x0
  push $172
ffff80000010af0c:	68 ac 00 00 00       	pushq  $0xac
  jmp alltraps
ffff80000010af11:	e9 85 f0 ff ff       	jmpq   ffff800000109f9b <alltraps>

ffff80000010af16 <vector173>:
vector173:
  push $0
ffff80000010af16:	6a 00                	pushq  $0x0
  push $173
ffff80000010af18:	68 ad 00 00 00       	pushq  $0xad
  jmp alltraps
ffff80000010af1d:	e9 79 f0 ff ff       	jmpq   ffff800000109f9b <alltraps>

ffff80000010af22 <vector174>:
vector174:
  push $0
ffff80000010af22:	6a 00                	pushq  $0x0
  push $174
ffff80000010af24:	68 ae 00 00 00       	pushq  $0xae
  jmp alltraps
ffff80000010af29:	e9 6d f0 ff ff       	jmpq   ffff800000109f9b <alltraps>

ffff80000010af2e <vector175>:
vector175:
  push $0
ffff80000010af2e:	6a 00                	pushq  $0x0
  push $175
ffff80000010af30:	68 af 00 00 00       	pushq  $0xaf
  jmp alltraps
ffff80000010af35:	e9 61 f0 ff ff       	jmpq   ffff800000109f9b <alltraps>

ffff80000010af3a <vector176>:
vector176:
  push $0
ffff80000010af3a:	6a 00                	pushq  $0x0
  push $176
ffff80000010af3c:	68 b0 00 00 00       	pushq  $0xb0
  jmp alltraps
ffff80000010af41:	e9 55 f0 ff ff       	jmpq   ffff800000109f9b <alltraps>

ffff80000010af46 <vector177>:
vector177:
  push $0
ffff80000010af46:	6a 00                	pushq  $0x0
  push $177
ffff80000010af48:	68 b1 00 00 00       	pushq  $0xb1
  jmp alltraps
ffff80000010af4d:	e9 49 f0 ff ff       	jmpq   ffff800000109f9b <alltraps>

ffff80000010af52 <vector178>:
vector178:
  push $0
ffff80000010af52:	6a 00                	pushq  $0x0
  push $178
ffff80000010af54:	68 b2 00 00 00       	pushq  $0xb2
  jmp alltraps
ffff80000010af59:	e9 3d f0 ff ff       	jmpq   ffff800000109f9b <alltraps>

ffff80000010af5e <vector179>:
vector179:
  push $0
ffff80000010af5e:	6a 00                	pushq  $0x0
  push $179
ffff80000010af60:	68 b3 00 00 00       	pushq  $0xb3
  jmp alltraps
ffff80000010af65:	e9 31 f0 ff ff       	jmpq   ffff800000109f9b <alltraps>

ffff80000010af6a <vector180>:
vector180:
  push $0
ffff80000010af6a:	6a 00                	pushq  $0x0
  push $180
ffff80000010af6c:	68 b4 00 00 00       	pushq  $0xb4
  jmp alltraps
ffff80000010af71:	e9 25 f0 ff ff       	jmpq   ffff800000109f9b <alltraps>

ffff80000010af76 <vector181>:
vector181:
  push $0
ffff80000010af76:	6a 00                	pushq  $0x0
  push $181
ffff80000010af78:	68 b5 00 00 00       	pushq  $0xb5
  jmp alltraps
ffff80000010af7d:	e9 19 f0 ff ff       	jmpq   ffff800000109f9b <alltraps>

ffff80000010af82 <vector182>:
vector182:
  push $0
ffff80000010af82:	6a 00                	pushq  $0x0
  push $182
ffff80000010af84:	68 b6 00 00 00       	pushq  $0xb6
  jmp alltraps
ffff80000010af89:	e9 0d f0 ff ff       	jmpq   ffff800000109f9b <alltraps>

ffff80000010af8e <vector183>:
vector183:
  push $0
ffff80000010af8e:	6a 00                	pushq  $0x0
  push $183
ffff80000010af90:	68 b7 00 00 00       	pushq  $0xb7
  jmp alltraps
ffff80000010af95:	e9 01 f0 ff ff       	jmpq   ffff800000109f9b <alltraps>

ffff80000010af9a <vector184>:
vector184:
  push $0
ffff80000010af9a:	6a 00                	pushq  $0x0
  push $184
ffff80000010af9c:	68 b8 00 00 00       	pushq  $0xb8
  jmp alltraps
ffff80000010afa1:	e9 f5 ef ff ff       	jmpq   ffff800000109f9b <alltraps>

ffff80000010afa6 <vector185>:
vector185:
  push $0
ffff80000010afa6:	6a 00                	pushq  $0x0
  push $185
ffff80000010afa8:	68 b9 00 00 00       	pushq  $0xb9
  jmp alltraps
ffff80000010afad:	e9 e9 ef ff ff       	jmpq   ffff800000109f9b <alltraps>

ffff80000010afb2 <vector186>:
vector186:
  push $0
ffff80000010afb2:	6a 00                	pushq  $0x0
  push $186
ffff80000010afb4:	68 ba 00 00 00       	pushq  $0xba
  jmp alltraps
ffff80000010afb9:	e9 dd ef ff ff       	jmpq   ffff800000109f9b <alltraps>

ffff80000010afbe <vector187>:
vector187:
  push $0
ffff80000010afbe:	6a 00                	pushq  $0x0
  push $187
ffff80000010afc0:	68 bb 00 00 00       	pushq  $0xbb
  jmp alltraps
ffff80000010afc5:	e9 d1 ef ff ff       	jmpq   ffff800000109f9b <alltraps>

ffff80000010afca <vector188>:
vector188:
  push $0
ffff80000010afca:	6a 00                	pushq  $0x0
  push $188
ffff80000010afcc:	68 bc 00 00 00       	pushq  $0xbc
  jmp alltraps
ffff80000010afd1:	e9 c5 ef ff ff       	jmpq   ffff800000109f9b <alltraps>

ffff80000010afd6 <vector189>:
vector189:
  push $0
ffff80000010afd6:	6a 00                	pushq  $0x0
  push $189
ffff80000010afd8:	68 bd 00 00 00       	pushq  $0xbd
  jmp alltraps
ffff80000010afdd:	e9 b9 ef ff ff       	jmpq   ffff800000109f9b <alltraps>

ffff80000010afe2 <vector190>:
vector190:
  push $0
ffff80000010afe2:	6a 00                	pushq  $0x0
  push $190
ffff80000010afe4:	68 be 00 00 00       	pushq  $0xbe
  jmp alltraps
ffff80000010afe9:	e9 ad ef ff ff       	jmpq   ffff800000109f9b <alltraps>

ffff80000010afee <vector191>:
vector191:
  push $0
ffff80000010afee:	6a 00                	pushq  $0x0
  push $191
ffff80000010aff0:	68 bf 00 00 00       	pushq  $0xbf
  jmp alltraps
ffff80000010aff5:	e9 a1 ef ff ff       	jmpq   ffff800000109f9b <alltraps>

ffff80000010affa <vector192>:
vector192:
  push $0
ffff80000010affa:	6a 00                	pushq  $0x0
  push $192
ffff80000010affc:	68 c0 00 00 00       	pushq  $0xc0
  jmp alltraps
ffff80000010b001:	e9 95 ef ff ff       	jmpq   ffff800000109f9b <alltraps>

ffff80000010b006 <vector193>:
vector193:
  push $0
ffff80000010b006:	6a 00                	pushq  $0x0
  push $193
ffff80000010b008:	68 c1 00 00 00       	pushq  $0xc1
  jmp alltraps
ffff80000010b00d:	e9 89 ef ff ff       	jmpq   ffff800000109f9b <alltraps>

ffff80000010b012 <vector194>:
vector194:
  push $0
ffff80000010b012:	6a 00                	pushq  $0x0
  push $194
ffff80000010b014:	68 c2 00 00 00       	pushq  $0xc2
  jmp alltraps
ffff80000010b019:	e9 7d ef ff ff       	jmpq   ffff800000109f9b <alltraps>

ffff80000010b01e <vector195>:
vector195:
  push $0
ffff80000010b01e:	6a 00                	pushq  $0x0
  push $195
ffff80000010b020:	68 c3 00 00 00       	pushq  $0xc3
  jmp alltraps
ffff80000010b025:	e9 71 ef ff ff       	jmpq   ffff800000109f9b <alltraps>

ffff80000010b02a <vector196>:
vector196:
  push $0
ffff80000010b02a:	6a 00                	pushq  $0x0
  push $196
ffff80000010b02c:	68 c4 00 00 00       	pushq  $0xc4
  jmp alltraps
ffff80000010b031:	e9 65 ef ff ff       	jmpq   ffff800000109f9b <alltraps>

ffff80000010b036 <vector197>:
vector197:
  push $0
ffff80000010b036:	6a 00                	pushq  $0x0
  push $197
ffff80000010b038:	68 c5 00 00 00       	pushq  $0xc5
  jmp alltraps
ffff80000010b03d:	e9 59 ef ff ff       	jmpq   ffff800000109f9b <alltraps>

ffff80000010b042 <vector198>:
vector198:
  push $0
ffff80000010b042:	6a 00                	pushq  $0x0
  push $198
ffff80000010b044:	68 c6 00 00 00       	pushq  $0xc6
  jmp alltraps
ffff80000010b049:	e9 4d ef ff ff       	jmpq   ffff800000109f9b <alltraps>

ffff80000010b04e <vector199>:
vector199:
  push $0
ffff80000010b04e:	6a 00                	pushq  $0x0
  push $199
ffff80000010b050:	68 c7 00 00 00       	pushq  $0xc7
  jmp alltraps
ffff80000010b055:	e9 41 ef ff ff       	jmpq   ffff800000109f9b <alltraps>

ffff80000010b05a <vector200>:
vector200:
  push $0
ffff80000010b05a:	6a 00                	pushq  $0x0
  push $200
ffff80000010b05c:	68 c8 00 00 00       	pushq  $0xc8
  jmp alltraps
ffff80000010b061:	e9 35 ef ff ff       	jmpq   ffff800000109f9b <alltraps>

ffff80000010b066 <vector201>:
vector201:
  push $0
ffff80000010b066:	6a 00                	pushq  $0x0
  push $201
ffff80000010b068:	68 c9 00 00 00       	pushq  $0xc9
  jmp alltraps
ffff80000010b06d:	e9 29 ef ff ff       	jmpq   ffff800000109f9b <alltraps>

ffff80000010b072 <vector202>:
vector202:
  push $0
ffff80000010b072:	6a 00                	pushq  $0x0
  push $202
ffff80000010b074:	68 ca 00 00 00       	pushq  $0xca
  jmp alltraps
ffff80000010b079:	e9 1d ef ff ff       	jmpq   ffff800000109f9b <alltraps>

ffff80000010b07e <vector203>:
vector203:
  push $0
ffff80000010b07e:	6a 00                	pushq  $0x0
  push $203
ffff80000010b080:	68 cb 00 00 00       	pushq  $0xcb
  jmp alltraps
ffff80000010b085:	e9 11 ef ff ff       	jmpq   ffff800000109f9b <alltraps>

ffff80000010b08a <vector204>:
vector204:
  push $0
ffff80000010b08a:	6a 00                	pushq  $0x0
  push $204
ffff80000010b08c:	68 cc 00 00 00       	pushq  $0xcc
  jmp alltraps
ffff80000010b091:	e9 05 ef ff ff       	jmpq   ffff800000109f9b <alltraps>

ffff80000010b096 <vector205>:
vector205:
  push $0
ffff80000010b096:	6a 00                	pushq  $0x0
  push $205
ffff80000010b098:	68 cd 00 00 00       	pushq  $0xcd
  jmp alltraps
ffff80000010b09d:	e9 f9 ee ff ff       	jmpq   ffff800000109f9b <alltraps>

ffff80000010b0a2 <vector206>:
vector206:
  push $0
ffff80000010b0a2:	6a 00                	pushq  $0x0
  push $206
ffff80000010b0a4:	68 ce 00 00 00       	pushq  $0xce
  jmp alltraps
ffff80000010b0a9:	e9 ed ee ff ff       	jmpq   ffff800000109f9b <alltraps>

ffff80000010b0ae <vector207>:
vector207:
  push $0
ffff80000010b0ae:	6a 00                	pushq  $0x0
  push $207
ffff80000010b0b0:	68 cf 00 00 00       	pushq  $0xcf
  jmp alltraps
ffff80000010b0b5:	e9 e1 ee ff ff       	jmpq   ffff800000109f9b <alltraps>

ffff80000010b0ba <vector208>:
vector208:
  push $0
ffff80000010b0ba:	6a 00                	pushq  $0x0
  push $208
ffff80000010b0bc:	68 d0 00 00 00       	pushq  $0xd0
  jmp alltraps
ffff80000010b0c1:	e9 d5 ee ff ff       	jmpq   ffff800000109f9b <alltraps>

ffff80000010b0c6 <vector209>:
vector209:
  push $0
ffff80000010b0c6:	6a 00                	pushq  $0x0
  push $209
ffff80000010b0c8:	68 d1 00 00 00       	pushq  $0xd1
  jmp alltraps
ffff80000010b0cd:	e9 c9 ee ff ff       	jmpq   ffff800000109f9b <alltraps>

ffff80000010b0d2 <vector210>:
vector210:
  push $0
ffff80000010b0d2:	6a 00                	pushq  $0x0
  push $210
ffff80000010b0d4:	68 d2 00 00 00       	pushq  $0xd2
  jmp alltraps
ffff80000010b0d9:	e9 bd ee ff ff       	jmpq   ffff800000109f9b <alltraps>

ffff80000010b0de <vector211>:
vector211:
  push $0
ffff80000010b0de:	6a 00                	pushq  $0x0
  push $211
ffff80000010b0e0:	68 d3 00 00 00       	pushq  $0xd3
  jmp alltraps
ffff80000010b0e5:	e9 b1 ee ff ff       	jmpq   ffff800000109f9b <alltraps>

ffff80000010b0ea <vector212>:
vector212:
  push $0
ffff80000010b0ea:	6a 00                	pushq  $0x0
  push $212
ffff80000010b0ec:	68 d4 00 00 00       	pushq  $0xd4
  jmp alltraps
ffff80000010b0f1:	e9 a5 ee ff ff       	jmpq   ffff800000109f9b <alltraps>

ffff80000010b0f6 <vector213>:
vector213:
  push $0
ffff80000010b0f6:	6a 00                	pushq  $0x0
  push $213
ffff80000010b0f8:	68 d5 00 00 00       	pushq  $0xd5
  jmp alltraps
ffff80000010b0fd:	e9 99 ee ff ff       	jmpq   ffff800000109f9b <alltraps>

ffff80000010b102 <vector214>:
vector214:
  push $0
ffff80000010b102:	6a 00                	pushq  $0x0
  push $214
ffff80000010b104:	68 d6 00 00 00       	pushq  $0xd6
  jmp alltraps
ffff80000010b109:	e9 8d ee ff ff       	jmpq   ffff800000109f9b <alltraps>

ffff80000010b10e <vector215>:
vector215:
  push $0
ffff80000010b10e:	6a 00                	pushq  $0x0
  push $215
ffff80000010b110:	68 d7 00 00 00       	pushq  $0xd7
  jmp alltraps
ffff80000010b115:	e9 81 ee ff ff       	jmpq   ffff800000109f9b <alltraps>

ffff80000010b11a <vector216>:
vector216:
  push $0
ffff80000010b11a:	6a 00                	pushq  $0x0
  push $216
ffff80000010b11c:	68 d8 00 00 00       	pushq  $0xd8
  jmp alltraps
ffff80000010b121:	e9 75 ee ff ff       	jmpq   ffff800000109f9b <alltraps>

ffff80000010b126 <vector217>:
vector217:
  push $0
ffff80000010b126:	6a 00                	pushq  $0x0
  push $217
ffff80000010b128:	68 d9 00 00 00       	pushq  $0xd9
  jmp alltraps
ffff80000010b12d:	e9 69 ee ff ff       	jmpq   ffff800000109f9b <alltraps>

ffff80000010b132 <vector218>:
vector218:
  push $0
ffff80000010b132:	6a 00                	pushq  $0x0
  push $218
ffff80000010b134:	68 da 00 00 00       	pushq  $0xda
  jmp alltraps
ffff80000010b139:	e9 5d ee ff ff       	jmpq   ffff800000109f9b <alltraps>

ffff80000010b13e <vector219>:
vector219:
  push $0
ffff80000010b13e:	6a 00                	pushq  $0x0
  push $219
ffff80000010b140:	68 db 00 00 00       	pushq  $0xdb
  jmp alltraps
ffff80000010b145:	e9 51 ee ff ff       	jmpq   ffff800000109f9b <alltraps>

ffff80000010b14a <vector220>:
vector220:
  push $0
ffff80000010b14a:	6a 00                	pushq  $0x0
  push $220
ffff80000010b14c:	68 dc 00 00 00       	pushq  $0xdc
  jmp alltraps
ffff80000010b151:	e9 45 ee ff ff       	jmpq   ffff800000109f9b <alltraps>

ffff80000010b156 <vector221>:
vector221:
  push $0
ffff80000010b156:	6a 00                	pushq  $0x0
  push $221
ffff80000010b158:	68 dd 00 00 00       	pushq  $0xdd
  jmp alltraps
ffff80000010b15d:	e9 39 ee ff ff       	jmpq   ffff800000109f9b <alltraps>

ffff80000010b162 <vector222>:
vector222:
  push $0
ffff80000010b162:	6a 00                	pushq  $0x0
  push $222
ffff80000010b164:	68 de 00 00 00       	pushq  $0xde
  jmp alltraps
ffff80000010b169:	e9 2d ee ff ff       	jmpq   ffff800000109f9b <alltraps>

ffff80000010b16e <vector223>:
vector223:
  push $0
ffff80000010b16e:	6a 00                	pushq  $0x0
  push $223
ffff80000010b170:	68 df 00 00 00       	pushq  $0xdf
  jmp alltraps
ffff80000010b175:	e9 21 ee ff ff       	jmpq   ffff800000109f9b <alltraps>

ffff80000010b17a <vector224>:
vector224:
  push $0
ffff80000010b17a:	6a 00                	pushq  $0x0
  push $224
ffff80000010b17c:	68 e0 00 00 00       	pushq  $0xe0
  jmp alltraps
ffff80000010b181:	e9 15 ee ff ff       	jmpq   ffff800000109f9b <alltraps>

ffff80000010b186 <vector225>:
vector225:
  push $0
ffff80000010b186:	6a 00                	pushq  $0x0
  push $225
ffff80000010b188:	68 e1 00 00 00       	pushq  $0xe1
  jmp alltraps
ffff80000010b18d:	e9 09 ee ff ff       	jmpq   ffff800000109f9b <alltraps>

ffff80000010b192 <vector226>:
vector226:
  push $0
ffff80000010b192:	6a 00                	pushq  $0x0
  push $226
ffff80000010b194:	68 e2 00 00 00       	pushq  $0xe2
  jmp alltraps
ffff80000010b199:	e9 fd ed ff ff       	jmpq   ffff800000109f9b <alltraps>

ffff80000010b19e <vector227>:
vector227:
  push $0
ffff80000010b19e:	6a 00                	pushq  $0x0
  push $227
ffff80000010b1a0:	68 e3 00 00 00       	pushq  $0xe3
  jmp alltraps
ffff80000010b1a5:	e9 f1 ed ff ff       	jmpq   ffff800000109f9b <alltraps>

ffff80000010b1aa <vector228>:
vector228:
  push $0
ffff80000010b1aa:	6a 00                	pushq  $0x0
  push $228
ffff80000010b1ac:	68 e4 00 00 00       	pushq  $0xe4
  jmp alltraps
ffff80000010b1b1:	e9 e5 ed ff ff       	jmpq   ffff800000109f9b <alltraps>

ffff80000010b1b6 <vector229>:
vector229:
  push $0
ffff80000010b1b6:	6a 00                	pushq  $0x0
  push $229
ffff80000010b1b8:	68 e5 00 00 00       	pushq  $0xe5
  jmp alltraps
ffff80000010b1bd:	e9 d9 ed ff ff       	jmpq   ffff800000109f9b <alltraps>

ffff80000010b1c2 <vector230>:
vector230:
  push $0
ffff80000010b1c2:	6a 00                	pushq  $0x0
  push $230
ffff80000010b1c4:	68 e6 00 00 00       	pushq  $0xe6
  jmp alltraps
ffff80000010b1c9:	e9 cd ed ff ff       	jmpq   ffff800000109f9b <alltraps>

ffff80000010b1ce <vector231>:
vector231:
  push $0
ffff80000010b1ce:	6a 00                	pushq  $0x0
  push $231
ffff80000010b1d0:	68 e7 00 00 00       	pushq  $0xe7
  jmp alltraps
ffff80000010b1d5:	e9 c1 ed ff ff       	jmpq   ffff800000109f9b <alltraps>

ffff80000010b1da <vector232>:
vector232:
  push $0
ffff80000010b1da:	6a 00                	pushq  $0x0
  push $232
ffff80000010b1dc:	68 e8 00 00 00       	pushq  $0xe8
  jmp alltraps
ffff80000010b1e1:	e9 b5 ed ff ff       	jmpq   ffff800000109f9b <alltraps>

ffff80000010b1e6 <vector233>:
vector233:
  push $0
ffff80000010b1e6:	6a 00                	pushq  $0x0
  push $233
ffff80000010b1e8:	68 e9 00 00 00       	pushq  $0xe9
  jmp alltraps
ffff80000010b1ed:	e9 a9 ed ff ff       	jmpq   ffff800000109f9b <alltraps>

ffff80000010b1f2 <vector234>:
vector234:
  push $0
ffff80000010b1f2:	6a 00                	pushq  $0x0
  push $234
ffff80000010b1f4:	68 ea 00 00 00       	pushq  $0xea
  jmp alltraps
ffff80000010b1f9:	e9 9d ed ff ff       	jmpq   ffff800000109f9b <alltraps>

ffff80000010b1fe <vector235>:
vector235:
  push $0
ffff80000010b1fe:	6a 00                	pushq  $0x0
  push $235
ffff80000010b200:	68 eb 00 00 00       	pushq  $0xeb
  jmp alltraps
ffff80000010b205:	e9 91 ed ff ff       	jmpq   ffff800000109f9b <alltraps>

ffff80000010b20a <vector236>:
vector236:
  push $0
ffff80000010b20a:	6a 00                	pushq  $0x0
  push $236
ffff80000010b20c:	68 ec 00 00 00       	pushq  $0xec
  jmp alltraps
ffff80000010b211:	e9 85 ed ff ff       	jmpq   ffff800000109f9b <alltraps>

ffff80000010b216 <vector237>:
vector237:
  push $0
ffff80000010b216:	6a 00                	pushq  $0x0
  push $237
ffff80000010b218:	68 ed 00 00 00       	pushq  $0xed
  jmp alltraps
ffff80000010b21d:	e9 79 ed ff ff       	jmpq   ffff800000109f9b <alltraps>

ffff80000010b222 <vector238>:
vector238:
  push $0
ffff80000010b222:	6a 00                	pushq  $0x0
  push $238
ffff80000010b224:	68 ee 00 00 00       	pushq  $0xee
  jmp alltraps
ffff80000010b229:	e9 6d ed ff ff       	jmpq   ffff800000109f9b <alltraps>

ffff80000010b22e <vector239>:
vector239:
  push $0
ffff80000010b22e:	6a 00                	pushq  $0x0
  push $239
ffff80000010b230:	68 ef 00 00 00       	pushq  $0xef
  jmp alltraps
ffff80000010b235:	e9 61 ed ff ff       	jmpq   ffff800000109f9b <alltraps>

ffff80000010b23a <vector240>:
vector240:
  push $0
ffff80000010b23a:	6a 00                	pushq  $0x0
  push $240
ffff80000010b23c:	68 f0 00 00 00       	pushq  $0xf0
  jmp alltraps
ffff80000010b241:	e9 55 ed ff ff       	jmpq   ffff800000109f9b <alltraps>

ffff80000010b246 <vector241>:
vector241:
  push $0
ffff80000010b246:	6a 00                	pushq  $0x0
  push $241
ffff80000010b248:	68 f1 00 00 00       	pushq  $0xf1
  jmp alltraps
ffff80000010b24d:	e9 49 ed ff ff       	jmpq   ffff800000109f9b <alltraps>

ffff80000010b252 <vector242>:
vector242:
  push $0
ffff80000010b252:	6a 00                	pushq  $0x0
  push $242
ffff80000010b254:	68 f2 00 00 00       	pushq  $0xf2
  jmp alltraps
ffff80000010b259:	e9 3d ed ff ff       	jmpq   ffff800000109f9b <alltraps>

ffff80000010b25e <vector243>:
vector243:
  push $0
ffff80000010b25e:	6a 00                	pushq  $0x0
  push $243
ffff80000010b260:	68 f3 00 00 00       	pushq  $0xf3
  jmp alltraps
ffff80000010b265:	e9 31 ed ff ff       	jmpq   ffff800000109f9b <alltraps>

ffff80000010b26a <vector244>:
vector244:
  push $0
ffff80000010b26a:	6a 00                	pushq  $0x0
  push $244
ffff80000010b26c:	68 f4 00 00 00       	pushq  $0xf4
  jmp alltraps
ffff80000010b271:	e9 25 ed ff ff       	jmpq   ffff800000109f9b <alltraps>

ffff80000010b276 <vector245>:
vector245:
  push $0
ffff80000010b276:	6a 00                	pushq  $0x0
  push $245
ffff80000010b278:	68 f5 00 00 00       	pushq  $0xf5
  jmp alltraps
ffff80000010b27d:	e9 19 ed ff ff       	jmpq   ffff800000109f9b <alltraps>

ffff80000010b282 <vector246>:
vector246:
  push $0
ffff80000010b282:	6a 00                	pushq  $0x0
  push $246
ffff80000010b284:	68 f6 00 00 00       	pushq  $0xf6
  jmp alltraps
ffff80000010b289:	e9 0d ed ff ff       	jmpq   ffff800000109f9b <alltraps>

ffff80000010b28e <vector247>:
vector247:
  push $0
ffff80000010b28e:	6a 00                	pushq  $0x0
  push $247
ffff80000010b290:	68 f7 00 00 00       	pushq  $0xf7
  jmp alltraps
ffff80000010b295:	e9 01 ed ff ff       	jmpq   ffff800000109f9b <alltraps>

ffff80000010b29a <vector248>:
vector248:
  push $0
ffff80000010b29a:	6a 00                	pushq  $0x0
  push $248
ffff80000010b29c:	68 f8 00 00 00       	pushq  $0xf8
  jmp alltraps
ffff80000010b2a1:	e9 f5 ec ff ff       	jmpq   ffff800000109f9b <alltraps>

ffff80000010b2a6 <vector249>:
vector249:
  push $0
ffff80000010b2a6:	6a 00                	pushq  $0x0
  push $249
ffff80000010b2a8:	68 f9 00 00 00       	pushq  $0xf9
  jmp alltraps
ffff80000010b2ad:	e9 e9 ec ff ff       	jmpq   ffff800000109f9b <alltraps>

ffff80000010b2b2 <vector250>:
vector250:
  push $0
ffff80000010b2b2:	6a 00                	pushq  $0x0
  push $250
ffff80000010b2b4:	68 fa 00 00 00       	pushq  $0xfa
  jmp alltraps
ffff80000010b2b9:	e9 dd ec ff ff       	jmpq   ffff800000109f9b <alltraps>

ffff80000010b2be <vector251>:
vector251:
  push $0
ffff80000010b2be:	6a 00                	pushq  $0x0
  push $251
ffff80000010b2c0:	68 fb 00 00 00       	pushq  $0xfb
  jmp alltraps
ffff80000010b2c5:	e9 d1 ec ff ff       	jmpq   ffff800000109f9b <alltraps>

ffff80000010b2ca <vector252>:
vector252:
  push $0
ffff80000010b2ca:	6a 00                	pushq  $0x0
  push $252
ffff80000010b2cc:	68 fc 00 00 00       	pushq  $0xfc
  jmp alltraps
ffff80000010b2d1:	e9 c5 ec ff ff       	jmpq   ffff800000109f9b <alltraps>

ffff80000010b2d6 <vector253>:
vector253:
  push $0
ffff80000010b2d6:	6a 00                	pushq  $0x0
  push $253
ffff80000010b2d8:	68 fd 00 00 00       	pushq  $0xfd
  jmp alltraps
ffff80000010b2dd:	e9 b9 ec ff ff       	jmpq   ffff800000109f9b <alltraps>

ffff80000010b2e2 <vector254>:
vector254:
  push $0
ffff80000010b2e2:	6a 00                	pushq  $0x0
  push $254
ffff80000010b2e4:	68 fe 00 00 00       	pushq  $0xfe
  jmp alltraps
ffff80000010b2e9:	e9 ad ec ff ff       	jmpq   ffff800000109f9b <alltraps>

ffff80000010b2ee <vector255>:
vector255:
  push $0
ffff80000010b2ee:	6a 00                	pushq  $0x0
  push $255
ffff80000010b2f0:	68 ff 00 00 00       	pushq  $0xff
  jmp alltraps
ffff80000010b2f5:	e9 a1 ec ff ff       	jmpq   ffff800000109f9b <alltraps>

ffff80000010b2fa <lgdt>:
{
ffff80000010b2fa:	f3 0f 1e fa          	endbr64 
ffff80000010b2fe:	55                   	push   %rbp
ffff80000010b2ff:	48 89 e5             	mov    %rsp,%rbp
ffff80000010b302:	48 83 ec 30          	sub    $0x30,%rsp
ffff80000010b306:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
ffff80000010b30a:	89 75 d4             	mov    %esi,-0x2c(%rbp)
  addr_t addr = (addr_t)p;
ffff80000010b30d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
ffff80000010b311:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  pd[0] = size-1;
ffff80000010b315:	8b 45 d4             	mov    -0x2c(%rbp),%eax
ffff80000010b318:	83 e8 01             	sub    $0x1,%eax
ffff80000010b31b:	66 89 45 ee          	mov    %ax,-0x12(%rbp)
  pd[1] = addr;
ffff80000010b31f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff80000010b323:	66 89 45 f0          	mov    %ax,-0x10(%rbp)
  pd[2] = addr >> 16;
ffff80000010b327:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff80000010b32b:	48 c1 e8 10          	shr    $0x10,%rax
ffff80000010b32f:	66 89 45 f2          	mov    %ax,-0xe(%rbp)
  pd[3] = addr >> 32;
ffff80000010b333:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff80000010b337:	48 c1 e8 20          	shr    $0x20,%rax
ffff80000010b33b:	66 89 45 f4          	mov    %ax,-0xc(%rbp)
  pd[4] = addr >> 48;
ffff80000010b33f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff80000010b343:	48 c1 e8 30          	shr    $0x30,%rax
ffff80000010b347:	66 89 45 f6          	mov    %ax,-0xa(%rbp)
  asm volatile("lgdt (%0)" : : "r" (pd));
ffff80000010b34b:	48 8d 45 ee          	lea    -0x12(%rbp),%rax
ffff80000010b34f:	0f 01 10             	lgdt   (%rax)
}
ffff80000010b352:	90                   	nop
ffff80000010b353:	c9                   	leaveq 
ffff80000010b354:	c3                   	retq   

ffff80000010b355 <ltr>:
{
ffff80000010b355:	f3 0f 1e fa          	endbr64 
ffff80000010b359:	55                   	push   %rbp
ffff80000010b35a:	48 89 e5             	mov    %rsp,%rbp
ffff80000010b35d:	48 83 ec 08          	sub    $0x8,%rsp
ffff80000010b361:	89 f8                	mov    %edi,%eax
ffff80000010b363:	66 89 45 fc          	mov    %ax,-0x4(%rbp)
  asm volatile("ltr %0" : : "r" (sel));
ffff80000010b367:	0f b7 45 fc          	movzwl -0x4(%rbp),%eax
ffff80000010b36b:	0f 00 d8             	ltr    %ax
}
ffff80000010b36e:	90                   	nop
ffff80000010b36f:	c9                   	leaveq 
ffff80000010b370:	c3                   	retq   

ffff80000010b371 <lcr3>:

static inline void
lcr3(addr_t val)
{
ffff80000010b371:	f3 0f 1e fa          	endbr64 
ffff80000010b375:	55                   	push   %rbp
ffff80000010b376:	48 89 e5             	mov    %rsp,%rbp
ffff80000010b379:	48 83 ec 08          	sub    $0x8,%rsp
ffff80000010b37d:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  asm volatile("mov %0,%%cr3" : : "r" (val));
ffff80000010b381:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff80000010b385:	0f 22 d8             	mov    %rax,%cr3
}
ffff80000010b388:	90                   	nop
ffff80000010b389:	c9                   	leaveq 
ffff80000010b38a:	c3                   	retq   

ffff80000010b38b <v2p>:
static inline addr_t v2p(void *a) {
ffff80000010b38b:	f3 0f 1e fa          	endbr64 
ffff80000010b38f:	55                   	push   %rbp
ffff80000010b390:	48 89 e5             	mov    %rsp,%rbp
ffff80000010b393:	48 83 ec 08          	sub    $0x8,%rsp
ffff80000010b397:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  return ((addr_t) (a)) - ((addr_t)KERNBASE);
ffff80000010b39b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff80000010b39f:	48 ba 00 00 00 00 00 	movabs $0x800000000000,%rdx
ffff80000010b3a6:	80 00 00 
ffff80000010b3a9:	48 01 d0             	add    %rdx,%rax
}
ffff80000010b3ac:	c9                   	leaveq 
ffff80000010b3ad:	c3                   	retq   

ffff80000010b3ae <syscallinit>:
static pde_t *kpml4;
static pde_t *kpdpt;

void
syscallinit(void)
{
ffff80000010b3ae:	f3 0f 1e fa          	endbr64 
ffff80000010b3b2:	55                   	push   %rbp
ffff80000010b3b3:	48 89 e5             	mov    %rsp,%rbp
  // the MSR/SYSRET wants the segment for 32-bit user data
  // next up is 64-bit user data, then code
  // This is simply the way the sysret instruction
  // is designed to work (it assumes they follow).
  wrmsr(MSR_STAR,
ffff80000010b3b6:	48 be 00 00 00 00 08 	movabs $0x1b000800000000,%rsi
ffff80000010b3bd:	00 1b 00 
ffff80000010b3c0:	bf 81 00 00 c0       	mov    $0xc0000081,%edi
ffff80000010b3c5:	48 b8 01 01 10 00 00 	movabs $0xffff800000100101,%rax
ffff80000010b3cc:	80 ff ff 
ffff80000010b3cf:	ff d0                	callq  *%rax
    ((((uint64)USER32_CS) << 48) | ((uint64)KERNEL_CS << 32)));
  wrmsr(MSR_LSTAR, (addr_t)syscall_entry);
ffff80000010b3d1:	48 b8 d7 9f 10 00 00 	movabs $0xffff800000109fd7,%rax
ffff80000010b3d8:	80 ff ff 
ffff80000010b3db:	48 89 c6             	mov    %rax,%rsi
ffff80000010b3de:	bf 82 00 00 c0       	mov    $0xc0000082,%edi
ffff80000010b3e3:	48 b8 01 01 10 00 00 	movabs $0xffff800000100101,%rax
ffff80000010b3ea:	80 ff ff 
ffff80000010b3ed:	ff d0                	callq  *%rax
  wrmsr(MSR_CSTAR, (addr_t)ignore_sysret);
ffff80000010b3ef:	48 b8 11 01 10 00 00 	movabs $0xffff800000100111,%rax
ffff80000010b3f6:	80 ff ff 
ffff80000010b3f9:	48 89 c6             	mov    %rax,%rsi
ffff80000010b3fc:	bf 83 00 00 c0       	mov    $0xc0000083,%edi
ffff80000010b401:	48 b8 01 01 10 00 00 	movabs $0xffff800000100101,%rax
ffff80000010b408:	80 ff ff 
ffff80000010b40b:	ff d0                	callq  *%rax

  wrmsr(MSR_SFMASK, FL_TF|FL_DF|FL_IF|FL_IOPL_3|FL_AC|FL_NT);
ffff80000010b40d:	be 00 77 04 00       	mov    $0x47700,%esi
ffff80000010b412:	bf 84 00 00 c0       	mov    $0xc0000084,%edi
ffff80000010b417:	48 b8 01 01 10 00 00 	movabs $0xffff800000100101,%rax
ffff80000010b41e:	80 ff ff 
ffff80000010b421:	ff d0                	callq  *%rax
}
ffff80000010b423:	90                   	nop
ffff80000010b424:	5d                   	pop    %rbp
ffff80000010b425:	c3                   	retq   

ffff80000010b426 <seginit>:

// Set up CPU's kernel segment descriptors.
// Run once on entry on each CPU.
void
seginit(void)
{
ffff80000010b426:	f3 0f 1e fa          	endbr64 
ffff80000010b42a:	55                   	push   %rbp
ffff80000010b42b:	48 89 e5             	mov    %rsp,%rbp
ffff80000010b42e:	48 83 ec 30          	sub    $0x30,%rsp
  uint64 addr;
  void *local;
  struct cpu *c;

  // create a page for cpu local storage
  local = kalloc();
ffff80000010b432:	48 b8 34 42 10 00 00 	movabs $0xffff800000104234,%rax
ffff80000010b439:	80 ff ff 
ffff80000010b43c:	ff d0                	callq  *%rax
ffff80000010b43e:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  memset(local, 0, PGSIZE);
ffff80000010b442:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff80000010b446:	ba 00 10 00 00       	mov    $0x1000,%edx
ffff80000010b44b:	be 00 00 00 00       	mov    $0x0,%esi
ffff80000010b450:	48 89 c7             	mov    %rax,%rdi
ffff80000010b453:	48 b8 bd 82 10 00 00 	movabs $0xffff8000001082bd,%rax
ffff80000010b45a:	80 ff ff 
ffff80000010b45d:	ff d0                	callq  *%rax

  gdt = (struct segdesc*) local;
ffff80000010b45f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff80000010b463:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
  tss = (uint*) (((char*) local) + 1024);
ffff80000010b467:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff80000010b46b:	48 05 00 04 00 00    	add    $0x400,%rax
ffff80000010b471:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
  tss[16] = 0x00680000; // IO Map Base = End of TSS
ffff80000010b475:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff80000010b479:	48 83 c0 40          	add    $0x40,%rax
ffff80000010b47d:	c7 00 00 00 68 00    	movl   $0x680000,(%rax)

  // point FS smack in the middle of our local storage page
  wrmsr(0xC0000100, ((uint64) local) + 2048);
ffff80000010b483:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff80000010b487:	48 05 00 08 00 00    	add    $0x800,%rax
ffff80000010b48d:	48 89 c6             	mov    %rax,%rsi
ffff80000010b490:	bf 00 01 00 c0       	mov    $0xc0000100,%edi
ffff80000010b495:	48 b8 01 01 10 00 00 	movabs $0xffff800000100101,%rax
ffff80000010b49c:	80 ff ff 
ffff80000010b49f:	ff d0                	callq  *%rax

  c = &cpus[cpunum()];
ffff80000010b4a1:	48 b8 27 47 10 00 00 	movabs $0xffff800000104727,%rax
ffff80000010b4a8:	80 ff ff 
ffff80000010b4ab:	ff d0                	callq  *%rax
ffff80000010b4ad:	48 63 d0             	movslq %eax,%rdx
ffff80000010b4b0:	48 89 d0             	mov    %rdx,%rax
ffff80000010b4b3:	48 c1 e0 02          	shl    $0x2,%rax
ffff80000010b4b7:	48 01 d0             	add    %rdx,%rax
ffff80000010b4ba:	48 c1 e0 03          	shl    $0x3,%rax
ffff80000010b4be:	48 ba e0 72 11 00 00 	movabs $0xffff8000001172e0,%rdx
ffff80000010b4c5:	80 ff ff 
ffff80000010b4c8:	48 01 d0             	add    %rdx,%rax
ffff80000010b4cb:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
  c->local = local;
ffff80000010b4cf:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
ffff80000010b4d3:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
ffff80000010b4d7:	48 89 50 20          	mov    %rdx,0x20(%rax)

  cpu = c;
ffff80000010b4db:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
ffff80000010b4df:	64 48 89 04 25 f0 ff 	mov    %rax,%fs:0xfffffffffffffff0
ffff80000010b4e6:	ff ff 
  proc = 0;
ffff80000010b4e8:	64 48 c7 04 25 f8 ff 	movq   $0x0,%fs:0xfffffffffffffff8
ffff80000010b4ef:	ff ff 00 00 00 00 

  addr = (uint64) tss;
ffff80000010b4f5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff80000010b4f9:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  gdt[0] =  (struct segdesc) {};
ffff80000010b4fd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff80000010b501:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)

  gdt[SEG_KCODE] = SEG((STA_X|STA_R), 0, 0, APP_SEG, !DPL_USER, 1);
ffff80000010b508:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff80000010b50c:	48 83 c0 08          	add    $0x8,%rax
ffff80000010b510:	66 c7 00 00 00       	movw   $0x0,(%rax)
ffff80000010b515:	66 c7 40 02 00 00    	movw   $0x0,0x2(%rax)
ffff80000010b51b:	c6 40 04 00          	movb   $0x0,0x4(%rax)
ffff80000010b51f:	0f b6 50 05          	movzbl 0x5(%rax),%edx
ffff80000010b523:	83 e2 f0             	and    $0xfffffff0,%edx
ffff80000010b526:	83 ca 0a             	or     $0xa,%edx
ffff80000010b529:	88 50 05             	mov    %dl,0x5(%rax)
ffff80000010b52c:	0f b6 50 05          	movzbl 0x5(%rax),%edx
ffff80000010b530:	83 ca 10             	or     $0x10,%edx
ffff80000010b533:	88 50 05             	mov    %dl,0x5(%rax)
ffff80000010b536:	0f b6 50 05          	movzbl 0x5(%rax),%edx
ffff80000010b53a:	83 e2 9f             	and    $0xffffff9f,%edx
ffff80000010b53d:	88 50 05             	mov    %dl,0x5(%rax)
ffff80000010b540:	0f b6 50 05          	movzbl 0x5(%rax),%edx
ffff80000010b544:	83 ca 80             	or     $0xffffff80,%edx
ffff80000010b547:	88 50 05             	mov    %dl,0x5(%rax)
ffff80000010b54a:	0f b6 50 06          	movzbl 0x6(%rax),%edx
ffff80000010b54e:	83 e2 f0             	and    $0xfffffff0,%edx
ffff80000010b551:	88 50 06             	mov    %dl,0x6(%rax)
ffff80000010b554:	0f b6 50 06          	movzbl 0x6(%rax),%edx
ffff80000010b558:	83 e2 ef             	and    $0xffffffef,%edx
ffff80000010b55b:	88 50 06             	mov    %dl,0x6(%rax)
ffff80000010b55e:	0f b6 50 06          	movzbl 0x6(%rax),%edx
ffff80000010b562:	83 ca 20             	or     $0x20,%edx
ffff80000010b565:	88 50 06             	mov    %dl,0x6(%rax)
ffff80000010b568:	0f b6 50 06          	movzbl 0x6(%rax),%edx
ffff80000010b56c:	83 e2 bf             	and    $0xffffffbf,%edx
ffff80000010b56f:	88 50 06             	mov    %dl,0x6(%rax)
ffff80000010b572:	0f b6 50 06          	movzbl 0x6(%rax),%edx
ffff80000010b576:	83 ca 80             	or     $0xffffff80,%edx
ffff80000010b579:	88 50 06             	mov    %dl,0x6(%rax)
ffff80000010b57c:	c6 40 07 00          	movb   $0x0,0x7(%rax)
  gdt[SEG_KDATA] = SEG(STA_W, 0, 0, APP_SEG, !DPL_USER, 0);
ffff80000010b580:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff80000010b584:	48 83 c0 10          	add    $0x10,%rax
ffff80000010b588:	66 c7 00 00 00       	movw   $0x0,(%rax)
ffff80000010b58d:	66 c7 40 02 00 00    	movw   $0x0,0x2(%rax)
ffff80000010b593:	c6 40 04 00          	movb   $0x0,0x4(%rax)
ffff80000010b597:	0f b6 50 05          	movzbl 0x5(%rax),%edx
ffff80000010b59b:	83 e2 f0             	and    $0xfffffff0,%edx
ffff80000010b59e:	83 ca 02             	or     $0x2,%edx
ffff80000010b5a1:	88 50 05             	mov    %dl,0x5(%rax)
ffff80000010b5a4:	0f b6 50 05          	movzbl 0x5(%rax),%edx
ffff80000010b5a8:	83 ca 10             	or     $0x10,%edx
ffff80000010b5ab:	88 50 05             	mov    %dl,0x5(%rax)
ffff80000010b5ae:	0f b6 50 05          	movzbl 0x5(%rax),%edx
ffff80000010b5b2:	83 e2 9f             	and    $0xffffff9f,%edx
ffff80000010b5b5:	88 50 05             	mov    %dl,0x5(%rax)
ffff80000010b5b8:	0f b6 50 05          	movzbl 0x5(%rax),%edx
ffff80000010b5bc:	83 ca 80             	or     $0xffffff80,%edx
ffff80000010b5bf:	88 50 05             	mov    %dl,0x5(%rax)
ffff80000010b5c2:	0f b6 50 06          	movzbl 0x6(%rax),%edx
ffff80000010b5c6:	83 e2 f0             	and    $0xfffffff0,%edx
ffff80000010b5c9:	88 50 06             	mov    %dl,0x6(%rax)
ffff80000010b5cc:	0f b6 50 06          	movzbl 0x6(%rax),%edx
ffff80000010b5d0:	83 e2 ef             	and    $0xffffffef,%edx
ffff80000010b5d3:	88 50 06             	mov    %dl,0x6(%rax)
ffff80000010b5d6:	0f b6 50 06          	movzbl 0x6(%rax),%edx
ffff80000010b5da:	83 e2 df             	and    $0xffffffdf,%edx
ffff80000010b5dd:	88 50 06             	mov    %dl,0x6(%rax)
ffff80000010b5e0:	0f b6 50 06          	movzbl 0x6(%rax),%edx
ffff80000010b5e4:	83 e2 bf             	and    $0xffffffbf,%edx
ffff80000010b5e7:	88 50 06             	mov    %dl,0x6(%rax)
ffff80000010b5ea:	0f b6 50 06          	movzbl 0x6(%rax),%edx
ffff80000010b5ee:	83 ca 80             	or     $0xffffff80,%edx
ffff80000010b5f1:	88 50 06             	mov    %dl,0x6(%rax)
ffff80000010b5f4:	c6 40 07 00          	movb   $0x0,0x7(%rax)
  gdt[SEG_UCODE32] = (struct segdesc) {}; // required by syscall/sysret
ffff80000010b5f8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff80000010b5fc:	48 83 c0 18          	add    $0x18,%rax
ffff80000010b600:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
  gdt[SEG_UDATA] = SEG(STA_W, 0, 0, APP_SEG, DPL_USER, 0);
ffff80000010b607:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff80000010b60b:	48 83 c0 20          	add    $0x20,%rax
ffff80000010b60f:	66 c7 00 00 00       	movw   $0x0,(%rax)
ffff80000010b614:	66 c7 40 02 00 00    	movw   $0x0,0x2(%rax)
ffff80000010b61a:	c6 40 04 00          	movb   $0x0,0x4(%rax)
ffff80000010b61e:	0f b6 50 05          	movzbl 0x5(%rax),%edx
ffff80000010b622:	83 e2 f0             	and    $0xfffffff0,%edx
ffff80000010b625:	83 ca 02             	or     $0x2,%edx
ffff80000010b628:	88 50 05             	mov    %dl,0x5(%rax)
ffff80000010b62b:	0f b6 50 05          	movzbl 0x5(%rax),%edx
ffff80000010b62f:	83 ca 10             	or     $0x10,%edx
ffff80000010b632:	88 50 05             	mov    %dl,0x5(%rax)
ffff80000010b635:	0f b6 50 05          	movzbl 0x5(%rax),%edx
ffff80000010b639:	83 ca 60             	or     $0x60,%edx
ffff80000010b63c:	88 50 05             	mov    %dl,0x5(%rax)
ffff80000010b63f:	0f b6 50 05          	movzbl 0x5(%rax),%edx
ffff80000010b643:	83 ca 80             	or     $0xffffff80,%edx
ffff80000010b646:	88 50 05             	mov    %dl,0x5(%rax)
ffff80000010b649:	0f b6 50 06          	movzbl 0x6(%rax),%edx
ffff80000010b64d:	83 e2 f0             	and    $0xfffffff0,%edx
ffff80000010b650:	88 50 06             	mov    %dl,0x6(%rax)
ffff80000010b653:	0f b6 50 06          	movzbl 0x6(%rax),%edx
ffff80000010b657:	83 e2 ef             	and    $0xffffffef,%edx
ffff80000010b65a:	88 50 06             	mov    %dl,0x6(%rax)
ffff80000010b65d:	0f b6 50 06          	movzbl 0x6(%rax),%edx
ffff80000010b661:	83 e2 df             	and    $0xffffffdf,%edx
ffff80000010b664:	88 50 06             	mov    %dl,0x6(%rax)
ffff80000010b667:	0f b6 50 06          	movzbl 0x6(%rax),%edx
ffff80000010b66b:	83 e2 bf             	and    $0xffffffbf,%edx
ffff80000010b66e:	88 50 06             	mov    %dl,0x6(%rax)
ffff80000010b671:	0f b6 50 06          	movzbl 0x6(%rax),%edx
ffff80000010b675:	83 ca 80             	or     $0xffffff80,%edx
ffff80000010b678:	88 50 06             	mov    %dl,0x6(%rax)
ffff80000010b67b:	c6 40 07 00          	movb   $0x0,0x7(%rax)
  gdt[SEG_UCODE] = SEG((STA_X|STA_R), 0, 0, APP_SEG, DPL_USER, 1);
ffff80000010b67f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff80000010b683:	48 83 c0 28          	add    $0x28,%rax
ffff80000010b687:	66 c7 00 00 00       	movw   $0x0,(%rax)
ffff80000010b68c:	66 c7 40 02 00 00    	movw   $0x0,0x2(%rax)
ffff80000010b692:	c6 40 04 00          	movb   $0x0,0x4(%rax)
ffff80000010b696:	0f b6 50 05          	movzbl 0x5(%rax),%edx
ffff80000010b69a:	83 e2 f0             	and    $0xfffffff0,%edx
ffff80000010b69d:	83 ca 0a             	or     $0xa,%edx
ffff80000010b6a0:	88 50 05             	mov    %dl,0x5(%rax)
ffff80000010b6a3:	0f b6 50 05          	movzbl 0x5(%rax),%edx
ffff80000010b6a7:	83 ca 10             	or     $0x10,%edx
ffff80000010b6aa:	88 50 05             	mov    %dl,0x5(%rax)
ffff80000010b6ad:	0f b6 50 05          	movzbl 0x5(%rax),%edx
ffff80000010b6b1:	83 ca 60             	or     $0x60,%edx
ffff80000010b6b4:	88 50 05             	mov    %dl,0x5(%rax)
ffff80000010b6b7:	0f b6 50 05          	movzbl 0x5(%rax),%edx
ffff80000010b6bb:	83 ca 80             	or     $0xffffff80,%edx
ffff80000010b6be:	88 50 05             	mov    %dl,0x5(%rax)
ffff80000010b6c1:	0f b6 50 06          	movzbl 0x6(%rax),%edx
ffff80000010b6c5:	83 e2 f0             	and    $0xfffffff0,%edx
ffff80000010b6c8:	88 50 06             	mov    %dl,0x6(%rax)
ffff80000010b6cb:	0f b6 50 06          	movzbl 0x6(%rax),%edx
ffff80000010b6cf:	83 e2 ef             	and    $0xffffffef,%edx
ffff80000010b6d2:	88 50 06             	mov    %dl,0x6(%rax)
ffff80000010b6d5:	0f b6 50 06          	movzbl 0x6(%rax),%edx
ffff80000010b6d9:	83 ca 20             	or     $0x20,%edx
ffff80000010b6dc:	88 50 06             	mov    %dl,0x6(%rax)
ffff80000010b6df:	0f b6 50 06          	movzbl 0x6(%rax),%edx
ffff80000010b6e3:	83 e2 bf             	and    $0xffffffbf,%edx
ffff80000010b6e6:	88 50 06             	mov    %dl,0x6(%rax)
ffff80000010b6e9:	0f b6 50 06          	movzbl 0x6(%rax),%edx
ffff80000010b6ed:	83 ca 80             	or     $0xffffff80,%edx
ffff80000010b6f0:	88 50 06             	mov    %dl,0x6(%rax)
ffff80000010b6f3:	c6 40 07 00          	movb   $0x0,0x7(%rax)
  gdt[SEG_KCPU]  = (struct segdesc) {};
ffff80000010b6f7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff80000010b6fb:	48 83 c0 30          	add    $0x30,%rax
ffff80000010b6ff:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
  // TSS: See IA32 SDM Figure 7-4
  gdt[SEG_TSS]   = SEG(STS_T64A, 0xb, addr, !APP_SEG, DPL_USER, 0);
ffff80000010b706:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff80000010b70a:	48 83 c0 38          	add    $0x38,%rax
ffff80000010b70e:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
ffff80000010b712:	89 d7                	mov    %edx,%edi
ffff80000010b714:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
ffff80000010b718:	48 c1 ea 10          	shr    $0x10,%rdx
ffff80000010b71c:	89 d6                	mov    %edx,%esi
ffff80000010b71e:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
ffff80000010b722:	48 c1 ea 18          	shr    $0x18,%rdx
ffff80000010b726:	89 d1                	mov    %edx,%ecx
ffff80000010b728:	66 c7 00 0b 00       	movw   $0xb,(%rax)
ffff80000010b72d:	66 89 78 02          	mov    %di,0x2(%rax)
ffff80000010b731:	40 88 70 04          	mov    %sil,0x4(%rax)
ffff80000010b735:	0f b6 50 05          	movzbl 0x5(%rax),%edx
ffff80000010b739:	83 e2 f0             	and    $0xfffffff0,%edx
ffff80000010b73c:	83 ca 09             	or     $0x9,%edx
ffff80000010b73f:	88 50 05             	mov    %dl,0x5(%rax)
ffff80000010b742:	0f b6 50 05          	movzbl 0x5(%rax),%edx
ffff80000010b746:	83 e2 ef             	and    $0xffffffef,%edx
ffff80000010b749:	88 50 05             	mov    %dl,0x5(%rax)
ffff80000010b74c:	0f b6 50 05          	movzbl 0x5(%rax),%edx
ffff80000010b750:	83 ca 60             	or     $0x60,%edx
ffff80000010b753:	88 50 05             	mov    %dl,0x5(%rax)
ffff80000010b756:	0f b6 50 05          	movzbl 0x5(%rax),%edx
ffff80000010b75a:	83 ca 80             	or     $0xffffff80,%edx
ffff80000010b75d:	88 50 05             	mov    %dl,0x5(%rax)
ffff80000010b760:	0f b6 50 06          	movzbl 0x6(%rax),%edx
ffff80000010b764:	83 e2 f0             	and    $0xfffffff0,%edx
ffff80000010b767:	88 50 06             	mov    %dl,0x6(%rax)
ffff80000010b76a:	0f b6 50 06          	movzbl 0x6(%rax),%edx
ffff80000010b76e:	83 e2 ef             	and    $0xffffffef,%edx
ffff80000010b771:	88 50 06             	mov    %dl,0x6(%rax)
ffff80000010b774:	0f b6 50 06          	movzbl 0x6(%rax),%edx
ffff80000010b778:	83 e2 df             	and    $0xffffffdf,%edx
ffff80000010b77b:	88 50 06             	mov    %dl,0x6(%rax)
ffff80000010b77e:	0f b6 50 06          	movzbl 0x6(%rax),%edx
ffff80000010b782:	83 e2 bf             	and    $0xffffffbf,%edx
ffff80000010b785:	88 50 06             	mov    %dl,0x6(%rax)
ffff80000010b788:	0f b6 50 06          	movzbl 0x6(%rax),%edx
ffff80000010b78c:	83 ca 80             	or     $0xffffff80,%edx
ffff80000010b78f:	88 50 06             	mov    %dl,0x6(%rax)
ffff80000010b792:	88 48 07             	mov    %cl,0x7(%rax)
  gdt[SEG_TSS+1] = SEG(0, addr >> 32, addr >> 48, 0, 0, 0);
ffff80000010b795:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff80000010b799:	48 83 c0 40          	add    $0x40,%rax
ffff80000010b79d:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
ffff80000010b7a1:	48 c1 ea 20          	shr    $0x20,%rdx
ffff80000010b7a5:	41 89 d1             	mov    %edx,%r9d
ffff80000010b7a8:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
ffff80000010b7ac:	48 c1 ea 30          	shr    $0x30,%rdx
ffff80000010b7b0:	41 89 d0             	mov    %edx,%r8d
ffff80000010b7b3:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
ffff80000010b7b7:	48 c1 ea 30          	shr    $0x30,%rdx
ffff80000010b7bb:	48 c1 ea 10          	shr    $0x10,%rdx
ffff80000010b7bf:	89 d7                	mov    %edx,%edi
ffff80000010b7c1:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
ffff80000010b7c5:	48 c1 ea 20          	shr    $0x20,%rdx
ffff80000010b7c9:	48 c1 ea 3c          	shr    $0x3c,%rdx
ffff80000010b7cd:	83 e2 0f             	and    $0xf,%edx
ffff80000010b7d0:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
ffff80000010b7d4:	48 c1 e9 30          	shr    $0x30,%rcx
ffff80000010b7d8:	48 c1 e9 18          	shr    $0x18,%rcx
ffff80000010b7dc:	89 ce                	mov    %ecx,%esi
ffff80000010b7de:	66 44 89 08          	mov    %r9w,(%rax)
ffff80000010b7e2:	66 44 89 40 02       	mov    %r8w,0x2(%rax)
ffff80000010b7e7:	40 88 78 04          	mov    %dil,0x4(%rax)
ffff80000010b7eb:	0f b6 48 05          	movzbl 0x5(%rax),%ecx
ffff80000010b7ef:	83 e1 f0             	and    $0xfffffff0,%ecx
ffff80000010b7f2:	88 48 05             	mov    %cl,0x5(%rax)
ffff80000010b7f5:	0f b6 48 05          	movzbl 0x5(%rax),%ecx
ffff80000010b7f9:	83 e1 ef             	and    $0xffffffef,%ecx
ffff80000010b7fc:	88 48 05             	mov    %cl,0x5(%rax)
ffff80000010b7ff:	0f b6 48 05          	movzbl 0x5(%rax),%ecx
ffff80000010b803:	83 e1 9f             	and    $0xffffff9f,%ecx
ffff80000010b806:	88 48 05             	mov    %cl,0x5(%rax)
ffff80000010b809:	0f b6 48 05          	movzbl 0x5(%rax),%ecx
ffff80000010b80d:	83 c9 80             	or     $0xffffff80,%ecx
ffff80000010b810:	88 48 05             	mov    %cl,0x5(%rax)
ffff80000010b813:	89 d1                	mov    %edx,%ecx
ffff80000010b815:	83 e1 0f             	and    $0xf,%ecx
ffff80000010b818:	0f b6 50 06          	movzbl 0x6(%rax),%edx
ffff80000010b81c:	83 e2 f0             	and    $0xfffffff0,%edx
ffff80000010b81f:	09 ca                	or     %ecx,%edx
ffff80000010b821:	88 50 06             	mov    %dl,0x6(%rax)
ffff80000010b824:	0f b6 50 06          	movzbl 0x6(%rax),%edx
ffff80000010b828:	83 e2 ef             	and    $0xffffffef,%edx
ffff80000010b82b:	88 50 06             	mov    %dl,0x6(%rax)
ffff80000010b82e:	0f b6 50 06          	movzbl 0x6(%rax),%edx
ffff80000010b832:	83 e2 df             	and    $0xffffffdf,%edx
ffff80000010b835:	88 50 06             	mov    %dl,0x6(%rax)
ffff80000010b838:	0f b6 50 06          	movzbl 0x6(%rax),%edx
ffff80000010b83c:	83 e2 bf             	and    $0xffffffbf,%edx
ffff80000010b83f:	88 50 06             	mov    %dl,0x6(%rax)
ffff80000010b842:	0f b6 50 06          	movzbl 0x6(%rax),%edx
ffff80000010b846:	83 ca 80             	or     $0xffffff80,%edx
ffff80000010b849:	88 50 06             	mov    %dl,0x6(%rax)
ffff80000010b84c:	40 88 70 07          	mov    %sil,0x7(%rax)

  lgdt((void*) gdt, (NSEGS+1) * sizeof(struct segdesc));
ffff80000010b850:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff80000010b854:	be 48 00 00 00       	mov    $0x48,%esi
ffff80000010b859:	48 89 c7             	mov    %rax,%rdi
ffff80000010b85c:	48 b8 fa b2 10 00 00 	movabs $0xffff80000010b2fa,%rax
ffff80000010b863:	80 ff ff 
ffff80000010b866:	ff d0                	callq  *%rax

  ltr(SEG_TSS << 3);
ffff80000010b868:	bf 38 00 00 00       	mov    $0x38,%edi
ffff80000010b86d:	48 b8 55 b3 10 00 00 	movabs $0xffff80000010b355,%rax
ffff80000010b874:	80 ff ff 
ffff80000010b877:	ff d0                	callq  *%rax
};
ffff80000010b879:	90                   	nop
ffff80000010b87a:	c9                   	leaveq 
ffff80000010b87b:	c3                   	retq   

ffff80000010b87c <setupkvm>:
// (directly addressable from end..P2V(PHYSTOP)).


pde_t*
setupkvm(void)
{
ffff80000010b87c:	f3 0f 1e fa          	endbr64 
ffff80000010b880:	55                   	push   %rbp
ffff80000010b881:	48 89 e5             	mov    %rsp,%rbp
ffff80000010b884:	48 83 ec 10          	sub    $0x10,%rsp
  pde_t *pml4 = (pde_t*) kalloc();
ffff80000010b888:	48 b8 34 42 10 00 00 	movabs $0xffff800000104234,%rax
ffff80000010b88f:	80 ff ff 
ffff80000010b892:	ff d0                	callq  *%rax
ffff80000010b894:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  memset(pml4, 0, PGSIZE);
ffff80000010b898:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff80000010b89c:	ba 00 10 00 00       	mov    $0x1000,%edx
ffff80000010b8a1:	be 00 00 00 00       	mov    $0x0,%esi
ffff80000010b8a6:	48 89 c7             	mov    %rax,%rdi
ffff80000010b8a9:	48 b8 bd 82 10 00 00 	movabs $0xffff8000001082bd,%rax
ffff80000010b8b0:	80 ff ff 
ffff80000010b8b3:	ff d0                	callq  *%rax
  pml4[256] = v2p(kpdpt) | PTE_P | PTE_W;
ffff80000010b8b5:	48 b8 00 ca 11 00 00 	movabs $0xffff80000011ca00,%rax
ffff80000010b8bc:	80 ff ff 
ffff80000010b8bf:	48 8b 00             	mov    (%rax),%rax
ffff80000010b8c2:	48 89 c7             	mov    %rax,%rdi
ffff80000010b8c5:	48 b8 8b b3 10 00 00 	movabs $0xffff80000010b38b,%rax
ffff80000010b8cc:	80 ff ff 
ffff80000010b8cf:	ff d0                	callq  *%rax
ffff80000010b8d1:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
ffff80000010b8d5:	48 81 c2 00 08 00 00 	add    $0x800,%rdx
ffff80000010b8dc:	48 83 c8 03          	or     $0x3,%rax
ffff80000010b8e0:	48 89 02             	mov    %rax,(%rdx)
  return pml4;
ffff80000010b8e3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
};
ffff80000010b8e7:	c9                   	leaveq 
ffff80000010b8e8:	c3                   	retq   

ffff80000010b8e9 <kvmalloc>:
//
// linear map the first 4GB of physical memory starting
// at 0xFFFF800000000000
void
kvmalloc(void)
{
ffff80000010b8e9:	f3 0f 1e fa          	endbr64 
ffff80000010b8ed:	55                   	push   %rbp
ffff80000010b8ee:	48 89 e5             	mov    %rsp,%rbp
  kpml4 = (pde_t*) kalloc();
ffff80000010b8f1:	48 b8 34 42 10 00 00 	movabs $0xffff800000104234,%rax
ffff80000010b8f8:	80 ff ff 
ffff80000010b8fb:	ff d0                	callq  *%rax
ffff80000010b8fd:	48 ba f8 c9 11 00 00 	movabs $0xffff80000011c9f8,%rdx
ffff80000010b904:	80 ff ff 
ffff80000010b907:	48 89 02             	mov    %rax,(%rdx)
  memset(kpml4, 0, PGSIZE);
ffff80000010b90a:	48 b8 f8 c9 11 00 00 	movabs $0xffff80000011c9f8,%rax
ffff80000010b911:	80 ff ff 
ffff80000010b914:	48 8b 00             	mov    (%rax),%rax
ffff80000010b917:	ba 00 10 00 00       	mov    $0x1000,%edx
ffff80000010b91c:	be 00 00 00 00       	mov    $0x0,%esi
ffff80000010b921:	48 89 c7             	mov    %rax,%rdi
ffff80000010b924:	48 b8 bd 82 10 00 00 	movabs $0xffff8000001082bd,%rax
ffff80000010b92b:	80 ff ff 
ffff80000010b92e:	ff d0                	callq  *%rax

  // the kernel memory region starts at KERNBASE and up
  // allocate one PDPT at the bottom of that range.
  kpdpt = (pde_t*) kalloc();
ffff80000010b930:	48 b8 34 42 10 00 00 	movabs $0xffff800000104234,%rax
ffff80000010b937:	80 ff ff 
ffff80000010b93a:	ff d0                	callq  *%rax
ffff80000010b93c:	48 ba 00 ca 11 00 00 	movabs $0xffff80000011ca00,%rdx
ffff80000010b943:	80 ff ff 
ffff80000010b946:	48 89 02             	mov    %rax,(%rdx)
  memset(kpdpt, 0, PGSIZE);
ffff80000010b949:	48 b8 00 ca 11 00 00 	movabs $0xffff80000011ca00,%rax
ffff80000010b950:	80 ff ff 
ffff80000010b953:	48 8b 00             	mov    (%rax),%rax
ffff80000010b956:	ba 00 10 00 00       	mov    $0x1000,%edx
ffff80000010b95b:	be 00 00 00 00       	mov    $0x0,%esi
ffff80000010b960:	48 89 c7             	mov    %rax,%rdi
ffff80000010b963:	48 b8 bd 82 10 00 00 	movabs $0xffff8000001082bd,%rax
ffff80000010b96a:	80 ff ff 
ffff80000010b96d:	ff d0                	callq  *%rax
  kpml4[PMX(KERNBASE)] = v2p(kpdpt) | PTE_P | PTE_W;
ffff80000010b96f:	48 b8 00 ca 11 00 00 	movabs $0xffff80000011ca00,%rax
ffff80000010b976:	80 ff ff 
ffff80000010b979:	48 8b 00             	mov    (%rax),%rax
ffff80000010b97c:	48 89 c7             	mov    %rax,%rdi
ffff80000010b97f:	48 b8 8b b3 10 00 00 	movabs $0xffff80000010b38b,%rax
ffff80000010b986:	80 ff ff 
ffff80000010b989:	ff d0                	callq  *%rax
ffff80000010b98b:	48 ba f8 c9 11 00 00 	movabs $0xffff80000011c9f8,%rdx
ffff80000010b992:	80 ff ff 
ffff80000010b995:	48 8b 12             	mov    (%rdx),%rdx
ffff80000010b998:	48 81 c2 00 08 00 00 	add    $0x800,%rdx
ffff80000010b99f:	48 83 c8 03          	or     $0x3,%rax
ffff80000010b9a3:	48 89 02             	mov    %rax,(%rdx)

  // direct map first GB of physical addresses to KERNBASE
  kpdpt[0] = 0 | PTE_PS | PTE_P | PTE_W;
ffff80000010b9a6:	48 b8 00 ca 11 00 00 	movabs $0xffff80000011ca00,%rax
ffff80000010b9ad:	80 ff ff 
ffff80000010b9b0:	48 8b 00             	mov    (%rax),%rax
ffff80000010b9b3:	48 c7 00 83 00 00 00 	movq   $0x83,(%rax)

  // direct map 4th GB of physical addresses to KERNBASE+3GB
  // this is a very lazy way to map IO memory (for lapic and ioapic)
  // PTE_PWT and PTE_PCD for memory mapped I/O correctness.
  kpdpt[3] = 0xC0000000 | PTE_PS | PTE_P | PTE_W | PTE_PWT | PTE_PCD;
ffff80000010b9ba:	48 b8 00 ca 11 00 00 	movabs $0xffff80000011ca00,%rax
ffff80000010b9c1:	80 ff ff 
ffff80000010b9c4:	48 8b 00             	mov    (%rax),%rax
ffff80000010b9c7:	48 83 c0 18          	add    $0x18,%rax
ffff80000010b9cb:	b9 9b 00 00 c0       	mov    $0xc000009b,%ecx
ffff80000010b9d0:	48 89 08             	mov    %rcx,(%rax)

  switchkvm();
ffff80000010b9d3:	48 b8 f3 bc 10 00 00 	movabs $0xffff80000010bcf3,%rax
ffff80000010b9da:	80 ff ff 
ffff80000010b9dd:	ff d0                	callq  *%rax
}
ffff80000010b9df:	90                   	nop
ffff80000010b9e0:	5d                   	pop    %rbp
ffff80000010b9e1:	c3                   	retq   

ffff80000010b9e2 <switchuvm>:

void
switchuvm(struct proc *p)
{
ffff80000010b9e2:	f3 0f 1e fa          	endbr64 
ffff80000010b9e6:	55                   	push   %rbp
ffff80000010b9e7:	48 89 e5             	mov    %rsp,%rbp
ffff80000010b9ea:	48 83 ec 20          	sub    $0x20,%rsp
ffff80000010b9ee:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  pushcli();
ffff80000010b9f2:	48 b8 3f 81 10 00 00 	movabs $0xffff80000010813f,%rax
ffff80000010b9f9:	80 ff ff 
ffff80000010b9fc:	ff d0                	callq  *%rax
  if(p->pgdir == 0)
ffff80000010b9fe:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff80000010ba02:	48 8b 40 08          	mov    0x8(%rax),%rax
ffff80000010ba06:	48 85 c0             	test   %rax,%rax
ffff80000010ba09:	75 16                	jne    ffff80000010ba21 <switchuvm+0x3f>
    panic("switchuvm: no pgdir");
ffff80000010ba0b:	48 bf 30 cf 10 00 00 	movabs $0xffff80000010cf30,%rdi
ffff80000010ba12:	80 ff ff 
ffff80000010ba15:	48 b8 f9 0b 10 00 00 	movabs $0xffff800000100bf9,%rax
ffff80000010ba1c:	80 ff ff 
ffff80000010ba1f:	ff d0                	callq  *%rax
  uint *tss = (uint*) (((char*) cpu->local) + 1024);
ffff80000010ba21:	64 48 8b 04 25 f0 ff 	mov    %fs:0xfffffffffffffff0,%rax
ffff80000010ba28:	ff ff 
ffff80000010ba2a:	48 8b 40 20          	mov    0x20(%rax),%rax
ffff80000010ba2e:	48 05 00 04 00 00    	add    $0x400,%rax
ffff80000010ba34:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  const addr_t stktop = (addr_t)p->kstack + KSTACKSIZE;
ffff80000010ba38:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff80000010ba3c:	48 8b 40 10          	mov    0x10(%rax),%rax
ffff80000010ba40:	48 05 00 10 00 00    	add    $0x1000,%rax
ffff80000010ba46:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
  tss[1] = (uint)stktop; // https://wiki.osdev.org/Task_State_Segment
ffff80000010ba4a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff80000010ba4e:	48 83 c0 04          	add    $0x4,%rax
ffff80000010ba52:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
ffff80000010ba56:	89 10                	mov    %edx,(%rax)
  tss[2] = (uint)(stktop >> 32);
ffff80000010ba58:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff80000010ba5c:	48 c1 e8 20          	shr    $0x20,%rax
ffff80000010ba60:	48 89 c2             	mov    %rax,%rdx
ffff80000010ba63:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff80000010ba67:	48 83 c0 08          	add    $0x8,%rax
ffff80000010ba6b:	89 10                	mov    %edx,(%rax)
  lcr3(v2p(p->pgdir));
ffff80000010ba6d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff80000010ba71:	48 8b 40 08          	mov    0x8(%rax),%rax
ffff80000010ba75:	48 89 c7             	mov    %rax,%rdi
ffff80000010ba78:	48 b8 8b b3 10 00 00 	movabs $0xffff80000010b38b,%rax
ffff80000010ba7f:	80 ff ff 
ffff80000010ba82:	ff d0                	callq  *%rax
ffff80000010ba84:	48 89 c7             	mov    %rax,%rdi
ffff80000010ba87:	48 b8 71 b3 10 00 00 	movabs $0xffff80000010b371,%rax
ffff80000010ba8e:	80 ff ff 
ffff80000010ba91:	ff d0                	callq  *%rax
  popcli();
ffff80000010ba93:	48 b8 b1 81 10 00 00 	movabs $0xffff8000001081b1,%rax
ffff80000010ba9a:	80 ff ff 
ffff80000010ba9d:	ff d0                	callq  *%rax
}
ffff80000010ba9f:	90                   	nop
ffff80000010baa0:	c9                   	leaveq 
ffff80000010baa1:	c3                   	retq   

ffff80000010baa2 <walkpgdir>:
// In 64-bit mode, the page table has four levels: PML4, PDPT, PD and PT
// For each level, we dereference the correct entry, or allocate and
// initialize entry if the PTE_P bit is not set
static pte_t *
walkpgdir(pde_t *pml4, const void *va, int alloc)
{
ffff80000010baa2:	f3 0f 1e fa          	endbr64 
ffff80000010baa6:	55                   	push   %rbp
ffff80000010baa7:	48 89 e5             	mov    %rsp,%rbp
ffff80000010baaa:	48 83 ec 50          	sub    $0x50,%rsp
ffff80000010baae:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
ffff80000010bab2:	48 89 75 c0          	mov    %rsi,-0x40(%rbp)
ffff80000010bab6:	89 55 bc             	mov    %edx,-0x44(%rbp)
  pml4e_t *pml4e;
  pdpe_t *pdp, *pdpe;
  pde_t *pde, *pd, *pgtab;

  // from the PML4, find or allocate the appropriate PDP table
  pml4e = &pml4[PMX(va)];
ffff80000010bab9:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
ffff80000010babd:	48 c1 e8 27          	shr    $0x27,%rax
ffff80000010bac1:	25 ff 01 00 00       	and    $0x1ff,%eax
ffff80000010bac6:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
ffff80000010bacd:	00 
ffff80000010bace:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
ffff80000010bad2:	48 01 d0             	add    %rdx,%rax
ffff80000010bad5:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
  if(*pml4e & PTE_P)
ffff80000010bad9:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
ffff80000010badd:	48 8b 00             	mov    (%rax),%rax
ffff80000010bae0:	83 e0 01             	and    $0x1,%eax
ffff80000010bae3:	48 85 c0             	test   %rax,%rax
ffff80000010bae6:	74 23                	je     ffff80000010bb0b <walkpgdir+0x69>
    pdp = (pdpe_t*)P2V(PTE_ADDR(*pml4e));
ffff80000010bae8:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
ffff80000010baec:	48 8b 00             	mov    (%rax),%rax
ffff80000010baef:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
ffff80000010baf5:	48 89 c2             	mov    %rax,%rdx
ffff80000010baf8:	48 b8 00 00 00 00 00 	movabs $0xffff800000000000,%rax
ffff80000010baff:	80 ff ff 
ffff80000010bb02:	48 01 d0             	add    %rdx,%rax
ffff80000010bb05:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
ffff80000010bb09:	eb 63                	jmp    ffff80000010bb6e <walkpgdir+0xcc>
  else {
    if(!alloc || (pdp = (pdpe_t*)kalloc()) == 0)
ffff80000010bb0b:	83 7d bc 00          	cmpl   $0x0,-0x44(%rbp)
ffff80000010bb0f:	74 17                	je     ffff80000010bb28 <walkpgdir+0x86>
ffff80000010bb11:	48 b8 34 42 10 00 00 	movabs $0xffff800000104234,%rax
ffff80000010bb18:	80 ff ff 
ffff80000010bb1b:	ff d0                	callq  *%rax
ffff80000010bb1d:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
ffff80000010bb21:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
ffff80000010bb26:	75 0a                	jne    ffff80000010bb32 <walkpgdir+0x90>
      return 0;
ffff80000010bb28:	b8 00 00 00 00       	mov    $0x0,%eax
ffff80000010bb2d:	e9 bf 01 00 00       	jmpq   ffff80000010bcf1 <walkpgdir+0x24f>
    memset(pdp, 0, PGSIZE);
ffff80000010bb32:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff80000010bb36:	ba 00 10 00 00       	mov    $0x1000,%edx
ffff80000010bb3b:	be 00 00 00 00       	mov    $0x0,%esi
ffff80000010bb40:	48 89 c7             	mov    %rax,%rdi
ffff80000010bb43:	48 b8 bd 82 10 00 00 	movabs $0xffff8000001082bd,%rax
ffff80000010bb4a:	80 ff ff 
ffff80000010bb4d:	ff d0                	callq  *%rax
    *pml4e = V2P(pdp) | PTE_P | PTE_W | PTE_U;
ffff80000010bb4f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff80000010bb53:	48 ba 00 00 00 00 00 	movabs $0x800000000000,%rdx
ffff80000010bb5a:	80 00 00 
ffff80000010bb5d:	48 01 d0             	add    %rdx,%rax
ffff80000010bb60:	48 83 c8 07          	or     $0x7,%rax
ffff80000010bb64:	48 89 c2             	mov    %rax,%rdx
ffff80000010bb67:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
ffff80000010bb6b:	48 89 10             	mov    %rdx,(%rax)
  }

  //from the PDP, find or allocate the appropriate PD (page directory)
  pdpe = &pdp[PDPX(va)];
ffff80000010bb6e:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
ffff80000010bb72:	48 c1 e8 1e          	shr    $0x1e,%rax
ffff80000010bb76:	25 ff 01 00 00       	and    $0x1ff,%eax
ffff80000010bb7b:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
ffff80000010bb82:	00 
ffff80000010bb83:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff80000010bb87:	48 01 d0             	add    %rdx,%rax
ffff80000010bb8a:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  if(*pdpe & PTE_P)
ffff80000010bb8e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
ffff80000010bb92:	48 8b 00             	mov    (%rax),%rax
ffff80000010bb95:	83 e0 01             	and    $0x1,%eax
ffff80000010bb98:	48 85 c0             	test   %rax,%rax
ffff80000010bb9b:	74 23                	je     ffff80000010bbc0 <walkpgdir+0x11e>
    pd = (pde_t*)P2V(PTE_ADDR(*pdpe));
ffff80000010bb9d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
ffff80000010bba1:	48 8b 00             	mov    (%rax),%rax
ffff80000010bba4:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
ffff80000010bbaa:	48 89 c2             	mov    %rax,%rdx
ffff80000010bbad:	48 b8 00 00 00 00 00 	movabs $0xffff800000000000,%rax
ffff80000010bbb4:	80 ff ff 
ffff80000010bbb7:	48 01 d0             	add    %rdx,%rax
ffff80000010bbba:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
ffff80000010bbbe:	eb 63                	jmp    ffff80000010bc23 <walkpgdir+0x181>
  else {
    if(!alloc || (pd = (pde_t*)kalloc()) == 0)//allocate page table
ffff80000010bbc0:	83 7d bc 00          	cmpl   $0x0,-0x44(%rbp)
ffff80000010bbc4:	74 17                	je     ffff80000010bbdd <walkpgdir+0x13b>
ffff80000010bbc6:	48 b8 34 42 10 00 00 	movabs $0xffff800000104234,%rax
ffff80000010bbcd:	80 ff ff 
ffff80000010bbd0:	ff d0                	callq  *%rax
ffff80000010bbd2:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
ffff80000010bbd6:	48 83 7d f0 00       	cmpq   $0x0,-0x10(%rbp)
ffff80000010bbdb:	75 0a                	jne    ffff80000010bbe7 <walkpgdir+0x145>
      return 0;
ffff80000010bbdd:	b8 00 00 00 00       	mov    $0x0,%eax
ffff80000010bbe2:	e9 0a 01 00 00       	jmpq   ffff80000010bcf1 <walkpgdir+0x24f>
    memset(pd, 0, PGSIZE);
ffff80000010bbe7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff80000010bbeb:	ba 00 10 00 00       	mov    $0x1000,%edx
ffff80000010bbf0:	be 00 00 00 00       	mov    $0x0,%esi
ffff80000010bbf5:	48 89 c7             	mov    %rax,%rdi
ffff80000010bbf8:	48 b8 bd 82 10 00 00 	movabs $0xffff8000001082bd,%rax
ffff80000010bbff:	80 ff ff 
ffff80000010bc02:	ff d0                	callq  *%rax
    *pdpe = V2P(pd) | PTE_P | PTE_W | PTE_U;
ffff80000010bc04:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff80000010bc08:	48 ba 00 00 00 00 00 	movabs $0x800000000000,%rdx
ffff80000010bc0f:	80 00 00 
ffff80000010bc12:	48 01 d0             	add    %rdx,%rax
ffff80000010bc15:	48 83 c8 07          	or     $0x7,%rax
ffff80000010bc19:	48 89 c2             	mov    %rax,%rdx
ffff80000010bc1c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
ffff80000010bc20:	48 89 10             	mov    %rdx,(%rax)
  }

  // from the PD, find or allocate the appropriate page table
  pde = &pd[PDX(va)];
ffff80000010bc23:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
ffff80000010bc27:	48 c1 e8 15          	shr    $0x15,%rax
ffff80000010bc2b:	25 ff 01 00 00       	and    $0x1ff,%eax
ffff80000010bc30:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
ffff80000010bc37:	00 
ffff80000010bc38:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff80000010bc3c:	48 01 d0             	add    %rdx,%rax
ffff80000010bc3f:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  if(*pde & PTE_P)
ffff80000010bc43:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
ffff80000010bc47:	48 8b 00             	mov    (%rax),%rax
ffff80000010bc4a:	83 e0 01             	and    $0x1,%eax
ffff80000010bc4d:	48 85 c0             	test   %rax,%rax
ffff80000010bc50:	74 23                	je     ffff80000010bc75 <walkpgdir+0x1d3>
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
ffff80000010bc52:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
ffff80000010bc56:	48 8b 00             	mov    (%rax),%rax
ffff80000010bc59:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
ffff80000010bc5f:	48 89 c2             	mov    %rax,%rdx
ffff80000010bc62:	48 b8 00 00 00 00 00 	movabs $0xffff800000000000,%rax
ffff80000010bc69:	80 ff ff 
ffff80000010bc6c:	48 01 d0             	add    %rdx,%rax
ffff80000010bc6f:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
ffff80000010bc73:	eb 60                	jmp    ffff80000010bcd5 <walkpgdir+0x233>
  else {
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)//allocate page table
ffff80000010bc75:	83 7d bc 00          	cmpl   $0x0,-0x44(%rbp)
ffff80000010bc79:	74 17                	je     ffff80000010bc92 <walkpgdir+0x1f0>
ffff80000010bc7b:	48 b8 34 42 10 00 00 	movabs $0xffff800000104234,%rax
ffff80000010bc82:	80 ff ff 
ffff80000010bc85:	ff d0                	callq  *%rax
ffff80000010bc87:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
ffff80000010bc8b:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
ffff80000010bc90:	75 07                	jne    ffff80000010bc99 <walkpgdir+0x1f7>
      return 0;
ffff80000010bc92:	b8 00 00 00 00       	mov    $0x0,%eax
ffff80000010bc97:	eb 58                	jmp    ffff80000010bcf1 <walkpgdir+0x24f>
    memset(pgtab, 0, PGSIZE);
ffff80000010bc99:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff80000010bc9d:	ba 00 10 00 00       	mov    $0x1000,%edx
ffff80000010bca2:	be 00 00 00 00       	mov    $0x0,%esi
ffff80000010bca7:	48 89 c7             	mov    %rax,%rdi
ffff80000010bcaa:	48 b8 bd 82 10 00 00 	movabs $0xffff8000001082bd,%rax
ffff80000010bcb1:	80 ff ff 
ffff80000010bcb4:	ff d0                	callq  *%rax
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
ffff80000010bcb6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff80000010bcba:	48 ba 00 00 00 00 00 	movabs $0x800000000000,%rdx
ffff80000010bcc1:	80 00 00 
ffff80000010bcc4:	48 01 d0             	add    %rdx,%rax
ffff80000010bcc7:	48 83 c8 07          	or     $0x7,%rax
ffff80000010bccb:	48 89 c2             	mov    %rax,%rdx
ffff80000010bcce:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
ffff80000010bcd2:	48 89 10             	mov    %rdx,(%rax)
  }

  return &pgtab[PTX(va)];
ffff80000010bcd5:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
ffff80000010bcd9:	48 c1 e8 0c          	shr    $0xc,%rax
ffff80000010bcdd:	25 ff 01 00 00       	and    $0x1ff,%eax
ffff80000010bce2:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
ffff80000010bce9:	00 
ffff80000010bcea:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff80000010bcee:	48 01 d0             	add    %rdx,%rax
}
ffff80000010bcf1:	c9                   	leaveq 
ffff80000010bcf2:	c3                   	retq   

ffff80000010bcf3 <switchkvm>:

void
switchkvm(void)
{
ffff80000010bcf3:	f3 0f 1e fa          	endbr64 
ffff80000010bcf7:	55                   	push   %rbp
ffff80000010bcf8:	48 89 e5             	mov    %rsp,%rbp
  lcr3(v2p(kpml4));
ffff80000010bcfb:	48 b8 f8 c9 11 00 00 	movabs $0xffff80000011c9f8,%rax
ffff80000010bd02:	80 ff ff 
ffff80000010bd05:	48 8b 00             	mov    (%rax),%rax
ffff80000010bd08:	48 89 c7             	mov    %rax,%rdi
ffff80000010bd0b:	48 b8 8b b3 10 00 00 	movabs $0xffff80000010b38b,%rax
ffff80000010bd12:	80 ff ff 
ffff80000010bd15:	ff d0                	callq  *%rax
ffff80000010bd17:	48 89 c7             	mov    %rax,%rdi
ffff80000010bd1a:	48 b8 71 b3 10 00 00 	movabs $0xffff80000010b371,%rax
ffff80000010bd21:	80 ff ff 
ffff80000010bd24:	ff d0                	callq  *%rax
}
ffff80000010bd26:	90                   	nop
ffff80000010bd27:	5d                   	pop    %rbp
ffff80000010bd28:	c3                   	retq   

ffff80000010bd29 <mappages>:
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
int
mappages(pde_t *pgdir, void *va, addr_t size, addr_t pa, int perm)
{
ffff80000010bd29:	f3 0f 1e fa          	endbr64 
ffff80000010bd2d:	55                   	push   %rbp
ffff80000010bd2e:	48 89 e5             	mov    %rsp,%rbp
ffff80000010bd31:	48 83 ec 50          	sub    $0x50,%rsp
ffff80000010bd35:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
ffff80000010bd39:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
ffff80000010bd3d:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
ffff80000010bd41:	48 89 4d c0          	mov    %rcx,-0x40(%rbp)
ffff80000010bd45:	44 89 45 bc          	mov    %r8d,-0x44(%rbp)
  char *a, *last;
  pte_t *pte;

  a = (char*)PGROUNDDOWN((addr_t)va);
ffff80000010bd49:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
ffff80000010bd4d:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
ffff80000010bd53:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  last = (char*)PGROUNDDOWN(((addr_t)va) + size - 1);
ffff80000010bd57:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
ffff80000010bd5b:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
ffff80000010bd5f:	48 01 d0             	add    %rdx,%rax
ffff80000010bd62:	48 83 e8 01          	sub    $0x1,%rax
ffff80000010bd66:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
ffff80000010bd6c:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
ffff80000010bd70:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
ffff80000010bd74:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
ffff80000010bd78:	ba 01 00 00 00       	mov    $0x1,%edx
ffff80000010bd7d:	48 89 ce             	mov    %rcx,%rsi
ffff80000010bd80:	48 89 c7             	mov    %rax,%rdi
ffff80000010bd83:	48 b8 a2 ba 10 00 00 	movabs $0xffff80000010baa2,%rax
ffff80000010bd8a:	80 ff ff 
ffff80000010bd8d:	ff d0                	callq  *%rax
ffff80000010bd8f:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
ffff80000010bd93:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
ffff80000010bd98:	75 07                	jne    ffff80000010bda1 <mappages+0x78>
      return -1;
ffff80000010bd9a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
ffff80000010bd9f:	eb 61                	jmp    ffff80000010be02 <mappages+0xd9>
    if(*pte & PTE_P)
ffff80000010bda1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff80000010bda5:	48 8b 00             	mov    (%rax),%rax
ffff80000010bda8:	83 e0 01             	and    $0x1,%eax
ffff80000010bdab:	48 85 c0             	test   %rax,%rax
ffff80000010bdae:	74 16                	je     ffff80000010bdc6 <mappages+0x9d>
      panic("remap");
ffff80000010bdb0:	48 bf 44 cf 10 00 00 	movabs $0xffff80000010cf44,%rdi
ffff80000010bdb7:	80 ff ff 
ffff80000010bdba:	48 b8 f9 0b 10 00 00 	movabs $0xffff800000100bf9,%rax
ffff80000010bdc1:	80 ff ff 
ffff80000010bdc4:	ff d0                	callq  *%rax
    *pte = pa | perm | PTE_P;
ffff80000010bdc6:	8b 45 bc             	mov    -0x44(%rbp),%eax
ffff80000010bdc9:	48 98                	cltq   
ffff80000010bdcb:	48 0b 45 c0          	or     -0x40(%rbp),%rax
ffff80000010bdcf:	48 83 c8 01          	or     $0x1,%rax
ffff80000010bdd3:	48 89 c2             	mov    %rax,%rdx
ffff80000010bdd6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff80000010bdda:	48 89 10             	mov    %rdx,(%rax)
    if(a == last)
ffff80000010bddd:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff80000010bde1:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
ffff80000010bde5:	74 15                	je     ffff80000010bdfc <mappages+0xd3>
      break;
    a += PGSIZE;
ffff80000010bde7:	48 81 45 f8 00 10 00 	addq   $0x1000,-0x8(%rbp)
ffff80000010bdee:	00 
    pa += PGSIZE;
ffff80000010bdef:	48 81 45 c0 00 10 00 	addq   $0x1000,-0x40(%rbp)
ffff80000010bdf6:	00 
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
ffff80000010bdf7:	e9 74 ff ff ff       	jmpq   ffff80000010bd70 <mappages+0x47>
      break;
ffff80000010bdfc:	90                   	nop
  }
  return 0;
ffff80000010bdfd:	b8 00 00 00 00       	mov    $0x0,%eax
}
ffff80000010be02:	c9                   	leaveq 
ffff80000010be03:	c3                   	retq   

ffff80000010be04 <inituvm>:

// Load the initcode into address 0x1000 (4KB) of pgdir.
// sz must be less than a page.
void
inituvm(pde_t *pgdir, char *init, uint sz)
{
ffff80000010be04:	f3 0f 1e fa          	endbr64 
ffff80000010be08:	55                   	push   %rbp
ffff80000010be09:	48 89 e5             	mov    %rsp,%rbp
ffff80000010be0c:	48 83 ec 30          	sub    $0x30,%rsp
ffff80000010be10:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
ffff80000010be14:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
ffff80000010be18:	89 55 dc             	mov    %edx,-0x24(%rbp)
  char *mem;

  if(sz >= PGSIZE)
ffff80000010be1b:	81 7d dc ff 0f 00 00 	cmpl   $0xfff,-0x24(%rbp)
ffff80000010be22:	76 16                	jbe    ffff80000010be3a <inituvm+0x36>
    panic("inituvm: more than a page");
ffff80000010be24:	48 bf 4a cf 10 00 00 	movabs $0xffff80000010cf4a,%rdi
ffff80000010be2b:	80 ff ff 
ffff80000010be2e:	48 b8 f9 0b 10 00 00 	movabs $0xffff800000100bf9,%rax
ffff80000010be35:	80 ff ff 
ffff80000010be38:	ff d0                	callq  *%rax

  mem = kalloc();
ffff80000010be3a:	48 b8 34 42 10 00 00 	movabs $0xffff800000104234,%rax
ffff80000010be41:	80 ff ff 
ffff80000010be44:	ff d0                	callq  *%rax
ffff80000010be46:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  memset(mem, 0, PGSIZE);
ffff80000010be4a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff80000010be4e:	ba 00 10 00 00       	mov    $0x1000,%edx
ffff80000010be53:	be 00 00 00 00       	mov    $0x0,%esi
ffff80000010be58:	48 89 c7             	mov    %rax,%rdi
ffff80000010be5b:	48 b8 bd 82 10 00 00 	movabs $0xffff8000001082bd,%rax
ffff80000010be62:	80 ff ff 
ffff80000010be65:	ff d0                	callq  *%rax
  mappages(pgdir, (void *)PGSIZE, PGSIZE, V2P(mem), PTE_W|PTE_U);
ffff80000010be67:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff80000010be6b:	48 ba 00 00 00 00 00 	movabs $0x800000000000,%rdx
ffff80000010be72:	80 00 00 
ffff80000010be75:	48 01 c2             	add    %rax,%rdx
ffff80000010be78:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff80000010be7c:	41 b8 06 00 00 00    	mov    $0x6,%r8d
ffff80000010be82:	48 89 d1             	mov    %rdx,%rcx
ffff80000010be85:	ba 00 10 00 00       	mov    $0x1000,%edx
ffff80000010be8a:	be 00 10 00 00       	mov    $0x1000,%esi
ffff80000010be8f:	48 89 c7             	mov    %rax,%rdi
ffff80000010be92:	48 b8 29 bd 10 00 00 	movabs $0xffff80000010bd29,%rax
ffff80000010be99:	80 ff ff 
ffff80000010be9c:	ff d0                	callq  *%rax

  memmove(mem, init, sz);
ffff80000010be9e:	8b 55 dc             	mov    -0x24(%rbp),%edx
ffff80000010bea1:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
ffff80000010bea5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff80000010bea9:	48 89 ce             	mov    %rcx,%rsi
ffff80000010beac:	48 89 c7             	mov    %rax,%rdi
ffff80000010beaf:	48 b8 ca 83 10 00 00 	movabs $0xffff8000001083ca,%rax
ffff80000010beb6:	80 ff ff 
ffff80000010beb9:	ff d0                	callq  *%rax
}
ffff80000010bebb:	90                   	nop
ffff80000010bebc:	c9                   	leaveq 
ffff80000010bebd:	c3                   	retq   

ffff80000010bebe <loaduvm>:

// Load a program segment into pgdir.  addr must be page-aligned
// and the pages from addr to addr+sz must already be mapped.
int
loaduvm(pde_t *pgdir, char *addr, struct inode *ip, uint offset, uint sz)
{
ffff80000010bebe:	f3 0f 1e fa          	endbr64 
ffff80000010bec2:	55                   	push   %rbp
ffff80000010bec3:	48 89 e5             	mov    %rsp,%rbp
ffff80000010bec6:	48 83 ec 40          	sub    $0x40,%rsp
ffff80000010beca:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
ffff80000010bece:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
ffff80000010bed2:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
ffff80000010bed6:	89 4d c4             	mov    %ecx,-0x3c(%rbp)
ffff80000010bed9:	44 89 45 c0          	mov    %r8d,-0x40(%rbp)
  uint i, n;
  addr_t pa;
  pte_t *pte;

  if((addr_t) addr % PGSIZE != 0)
ffff80000010bedd:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
ffff80000010bee1:	25 ff 0f 00 00       	and    $0xfff,%eax
ffff80000010bee6:	48 85 c0             	test   %rax,%rax
ffff80000010bee9:	74 16                	je     ffff80000010bf01 <loaduvm+0x43>
    panic("loaduvm: addr must be page aligned");
ffff80000010beeb:	48 bf 68 cf 10 00 00 	movabs $0xffff80000010cf68,%rdi
ffff80000010bef2:	80 ff ff 
ffff80000010bef5:	48 b8 f9 0b 10 00 00 	movabs $0xffff800000100bf9,%rax
ffff80000010befc:	80 ff ff 
ffff80000010beff:	ff d0                	callq  *%rax
  for(i = 0; i < sz; i += PGSIZE){
ffff80000010bf01:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
ffff80000010bf08:	e9 c4 00 00 00       	jmpq   ffff80000010bfd1 <loaduvm+0x113>
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
ffff80000010bf0d:	8b 55 fc             	mov    -0x4(%rbp),%edx
ffff80000010bf10:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
ffff80000010bf14:	48 8d 0c 02          	lea    (%rdx,%rax,1),%rcx
ffff80000010bf18:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
ffff80000010bf1c:	ba 00 00 00 00       	mov    $0x0,%edx
ffff80000010bf21:	48 89 ce             	mov    %rcx,%rsi
ffff80000010bf24:	48 89 c7             	mov    %rax,%rdi
ffff80000010bf27:	48 b8 a2 ba 10 00 00 	movabs $0xffff80000010baa2,%rax
ffff80000010bf2e:	80 ff ff 
ffff80000010bf31:	ff d0                	callq  *%rax
ffff80000010bf33:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
ffff80000010bf37:	48 83 7d f0 00       	cmpq   $0x0,-0x10(%rbp)
ffff80000010bf3c:	75 16                	jne    ffff80000010bf54 <loaduvm+0x96>
      panic("loaduvm: address should exist");
ffff80000010bf3e:	48 bf 8b cf 10 00 00 	movabs $0xffff80000010cf8b,%rdi
ffff80000010bf45:	80 ff ff 
ffff80000010bf48:	48 b8 f9 0b 10 00 00 	movabs $0xffff800000100bf9,%rax
ffff80000010bf4f:	80 ff ff 
ffff80000010bf52:	ff d0                	callq  *%rax
    pa = PTE_ADDR(*pte);
ffff80000010bf54:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff80000010bf58:	48 8b 00             	mov    (%rax),%rax
ffff80000010bf5b:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
ffff80000010bf61:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
    if(sz - i < PGSIZE)
ffff80000010bf65:	8b 45 c0             	mov    -0x40(%rbp),%eax
ffff80000010bf68:	2b 45 fc             	sub    -0x4(%rbp),%eax
ffff80000010bf6b:	3d ff 0f 00 00       	cmp    $0xfff,%eax
ffff80000010bf70:	77 0b                	ja     ffff80000010bf7d <loaduvm+0xbf>
      n = sz - i;
ffff80000010bf72:	8b 45 c0             	mov    -0x40(%rbp),%eax
ffff80000010bf75:	2b 45 fc             	sub    -0x4(%rbp),%eax
ffff80000010bf78:	89 45 f8             	mov    %eax,-0x8(%rbp)
ffff80000010bf7b:	eb 07                	jmp    ffff80000010bf84 <loaduvm+0xc6>
    else
      n = PGSIZE;
ffff80000010bf7d:	c7 45 f8 00 10 00 00 	movl   $0x1000,-0x8(%rbp)
    if(readi(ip, P2V(pa), offset+i, n) != n)
ffff80000010bf84:	8b 55 c4             	mov    -0x3c(%rbp),%edx
ffff80000010bf87:	8b 45 fc             	mov    -0x4(%rbp),%eax
ffff80000010bf8a:	8d 34 02             	lea    (%rdx,%rax,1),%esi
ffff80000010bf8d:	48 ba 00 00 00 00 00 	movabs $0xffff800000000000,%rdx
ffff80000010bf94:	80 ff ff 
ffff80000010bf97:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff80000010bf9b:	48 01 d0             	add    %rdx,%rax
ffff80000010bf9e:	48 89 c7             	mov    %rax,%rdi
ffff80000010bfa1:	8b 55 f8             	mov    -0x8(%rbp),%edx
ffff80000010bfa4:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
ffff80000010bfa8:	89 d1                	mov    %edx,%ecx
ffff80000010bfaa:	89 f2                	mov    %esi,%edx
ffff80000010bfac:	48 89 fe             	mov    %rdi,%rsi
ffff80000010bfaf:	48 89 c7             	mov    %rax,%rdi
ffff80000010bfb2:	48 b8 51 2f 10 00 00 	movabs $0xffff800000102f51,%rax
ffff80000010bfb9:	80 ff ff 
ffff80000010bfbc:	ff d0                	callq  *%rax
ffff80000010bfbe:	39 45 f8             	cmp    %eax,-0x8(%rbp)
ffff80000010bfc1:	74 07                	je     ffff80000010bfca <loaduvm+0x10c>
      return -1;
ffff80000010bfc3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
ffff80000010bfc8:	eb 18                	jmp    ffff80000010bfe2 <loaduvm+0x124>
  for(i = 0; i < sz; i += PGSIZE){
ffff80000010bfca:	81 45 fc 00 10 00 00 	addl   $0x1000,-0x4(%rbp)
ffff80000010bfd1:	8b 45 fc             	mov    -0x4(%rbp),%eax
ffff80000010bfd4:	3b 45 c0             	cmp    -0x40(%rbp),%eax
ffff80000010bfd7:	0f 82 30 ff ff ff    	jb     ffff80000010bf0d <loaduvm+0x4f>
  }
  return 0;
ffff80000010bfdd:	b8 00 00 00 00       	mov    $0x0,%eax
}
ffff80000010bfe2:	c9                   	leaveq 
ffff80000010bfe3:	c3                   	retq   

ffff80000010bfe4 <allocuvm>:

// Allocate page tables and physical memory to grow process from oldsz to
// newsz, which need not be page aligned.  Returns new size or 0 on error.
uint64
allocuvm(pde_t *pgdir, uint64 oldsz, uint64 newsz)
{
ffff80000010bfe4:	f3 0f 1e fa          	endbr64 
ffff80000010bfe8:	55                   	push   %rbp
ffff80000010bfe9:	48 89 e5             	mov    %rsp,%rbp
ffff80000010bfec:	48 83 ec 30          	sub    $0x30,%rsp
ffff80000010bff0:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
ffff80000010bff4:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
ffff80000010bff8:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  char *mem;
  addr_t a;

  if(newsz >= KERNBASE)
ffff80000010bffc:	48 b8 ff ff ff ff ff 	movabs $0xffff7fffffffffff,%rax
ffff80000010c003:	7f ff ff 
ffff80000010c006:	48 39 45 d8          	cmp    %rax,-0x28(%rbp)
ffff80000010c00a:	76 0a                	jbe    ffff80000010c016 <allocuvm+0x32>
    return 0;
ffff80000010c00c:	b8 00 00 00 00       	mov    $0x0,%eax
ffff80000010c011:	e9 14 01 00 00       	jmpq   ffff80000010c12a <allocuvm+0x146>
  if(newsz < oldsz)
ffff80000010c016:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
ffff80000010c01a:	48 3b 45 e0          	cmp    -0x20(%rbp),%rax
ffff80000010c01e:	73 09                	jae    ffff80000010c029 <allocuvm+0x45>
    return oldsz;
ffff80000010c020:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
ffff80000010c024:	e9 01 01 00 00       	jmpq   ffff80000010c12a <allocuvm+0x146>

  a = PGROUNDUP(oldsz);
ffff80000010c029:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
ffff80000010c02d:	48 05 ff 0f 00 00    	add    $0xfff,%rax
ffff80000010c033:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
ffff80000010c039:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  for(; a < newsz; a += PGSIZE){
ffff80000010c03d:	e9 d6 00 00 00       	jmpq   ffff80000010c118 <allocuvm+0x134>
    mem = kalloc();
ffff80000010c042:	48 b8 34 42 10 00 00 	movabs $0xffff800000104234,%rax
ffff80000010c049:	80 ff ff 
ffff80000010c04c:	ff d0                	callq  *%rax
ffff80000010c04e:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
    if(mem == 0){
ffff80000010c052:	48 83 7d f0 00       	cmpq   $0x0,-0x10(%rbp)
ffff80000010c057:	75 28                	jne    ffff80000010c081 <allocuvm+0x9d>
      //cprintf("allocuvm out of memory\n");
      deallocuvm(pgdir, newsz, oldsz);
ffff80000010c059:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
ffff80000010c05d:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
ffff80000010c061:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff80000010c065:	48 89 ce             	mov    %rcx,%rsi
ffff80000010c068:	48 89 c7             	mov    %rax,%rdi
ffff80000010c06b:	48 b8 2c c1 10 00 00 	movabs $0xffff80000010c12c,%rax
ffff80000010c072:	80 ff ff 
ffff80000010c075:	ff d0                	callq  *%rax
      return 0;
ffff80000010c077:	b8 00 00 00 00       	mov    $0x0,%eax
ffff80000010c07c:	e9 a9 00 00 00       	jmpq   ffff80000010c12a <allocuvm+0x146>
    }
    memset(mem, 0, PGSIZE);
ffff80000010c081:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff80000010c085:	ba 00 10 00 00       	mov    $0x1000,%edx
ffff80000010c08a:	be 00 00 00 00       	mov    $0x0,%esi
ffff80000010c08f:	48 89 c7             	mov    %rax,%rdi
ffff80000010c092:	48 b8 bd 82 10 00 00 	movabs $0xffff8000001082bd,%rax
ffff80000010c099:	80 ff ff 
ffff80000010c09c:	ff d0                	callq  *%rax
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
ffff80000010c09e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff80000010c0a2:	48 ba 00 00 00 00 00 	movabs $0x800000000000,%rdx
ffff80000010c0a9:	80 00 00 
ffff80000010c0ac:	48 01 c2             	add    %rax,%rdx
ffff80000010c0af:	48 8b 75 f8          	mov    -0x8(%rbp),%rsi
ffff80000010c0b3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff80000010c0b7:	41 b8 06 00 00 00    	mov    $0x6,%r8d
ffff80000010c0bd:	48 89 d1             	mov    %rdx,%rcx
ffff80000010c0c0:	ba 00 10 00 00       	mov    $0x1000,%edx
ffff80000010c0c5:	48 89 c7             	mov    %rax,%rdi
ffff80000010c0c8:	48 b8 29 bd 10 00 00 	movabs $0xffff80000010bd29,%rax
ffff80000010c0cf:	80 ff ff 
ffff80000010c0d2:	ff d0                	callq  *%rax
ffff80000010c0d4:	85 c0                	test   %eax,%eax
ffff80000010c0d6:	79 38                	jns    ffff80000010c110 <allocuvm+0x12c>
      //cprintf("allocuvm out of memory (2)\n");
      deallocuvm(pgdir, newsz, oldsz);
ffff80000010c0d8:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
ffff80000010c0dc:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
ffff80000010c0e0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff80000010c0e4:	48 89 ce             	mov    %rcx,%rsi
ffff80000010c0e7:	48 89 c7             	mov    %rax,%rdi
ffff80000010c0ea:	48 b8 2c c1 10 00 00 	movabs $0xffff80000010c12c,%rax
ffff80000010c0f1:	80 ff ff 
ffff80000010c0f4:	ff d0                	callq  *%rax
      kfree(mem);
ffff80000010c0f6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff80000010c0fa:	48 89 c7             	mov    %rax,%rdi
ffff80000010c0fd:	48 b8 3a 41 10 00 00 	movabs $0xffff80000010413a,%rax
ffff80000010c104:	80 ff ff 
ffff80000010c107:	ff d0                	callq  *%rax
      return 0;
ffff80000010c109:	b8 00 00 00 00       	mov    $0x0,%eax
ffff80000010c10e:	eb 1a                	jmp    ffff80000010c12a <allocuvm+0x146>
  for(; a < newsz; a += PGSIZE){
ffff80000010c110:	48 81 45 f8 00 10 00 	addq   $0x1000,-0x8(%rbp)
ffff80000010c117:	00 
ffff80000010c118:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff80000010c11c:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
ffff80000010c120:	0f 82 1c ff ff ff    	jb     ffff80000010c042 <allocuvm+0x5e>
    }
  }
  return newsz;
ffff80000010c126:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
}
ffff80000010c12a:	c9                   	leaveq 
ffff80000010c12b:	c3                   	retq   

ffff80000010c12c <deallocuvm>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
uint64
deallocuvm(pde_t *pgdir, uint64 oldsz, uint64 newsz)
{
ffff80000010c12c:	f3 0f 1e fa          	endbr64 
ffff80000010c130:	55                   	push   %rbp
ffff80000010c131:	48 89 e5             	mov    %rsp,%rbp
ffff80000010c134:	48 83 ec 40          	sub    $0x40,%rsp
ffff80000010c138:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
ffff80000010c13c:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
ffff80000010c140:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
  pte_t *pte;
  addr_t a, pa;

  if(newsz >= oldsz)
ffff80000010c144:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
ffff80000010c148:	48 3b 45 d0          	cmp    -0x30(%rbp),%rax
ffff80000010c14c:	72 09                	jb     ffff80000010c157 <deallocuvm+0x2b>
    return oldsz;
ffff80000010c14e:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
ffff80000010c152:	e9 cd 00 00 00       	jmpq   ffff80000010c224 <deallocuvm+0xf8>

  a = PGROUNDUP(newsz);
ffff80000010c157:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
ffff80000010c15b:	48 05 ff 0f 00 00    	add    $0xfff,%rax
ffff80000010c161:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
ffff80000010c167:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  for(; a  < oldsz; a += PGSIZE){
ffff80000010c16b:	e9 a2 00 00 00       	jmpq   ffff80000010c212 <deallocuvm+0xe6>
    pte = walkpgdir(pgdir, (char*)a, 0);
ffff80000010c170:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
ffff80000010c174:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
ffff80000010c178:	ba 00 00 00 00       	mov    $0x0,%edx
ffff80000010c17d:	48 89 ce             	mov    %rcx,%rsi
ffff80000010c180:	48 89 c7             	mov    %rax,%rdi
ffff80000010c183:	48 b8 a2 ba 10 00 00 	movabs $0xffff80000010baa2,%rax
ffff80000010c18a:	80 ff ff 
ffff80000010c18d:	ff d0                	callq  *%rax
ffff80000010c18f:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
    if(pte && (*pte & PTE_P) != 0){
ffff80000010c193:	48 83 7d f0 00       	cmpq   $0x0,-0x10(%rbp)
ffff80000010c198:	74 70                	je     ffff80000010c20a <deallocuvm+0xde>
ffff80000010c19a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff80000010c19e:	48 8b 00             	mov    (%rax),%rax
ffff80000010c1a1:	83 e0 01             	and    $0x1,%eax
ffff80000010c1a4:	48 85 c0             	test   %rax,%rax
ffff80000010c1a7:	74 61                	je     ffff80000010c20a <deallocuvm+0xde>
      pa = PTE_ADDR(*pte);
ffff80000010c1a9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff80000010c1ad:	48 8b 00             	mov    (%rax),%rax
ffff80000010c1b0:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
ffff80000010c1b6:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
      if(pa == 0)
ffff80000010c1ba:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
ffff80000010c1bf:	75 16                	jne    ffff80000010c1d7 <deallocuvm+0xab>
        panic("kfree");
ffff80000010c1c1:	48 bf a9 cf 10 00 00 	movabs $0xffff80000010cfa9,%rdi
ffff80000010c1c8:	80 ff ff 
ffff80000010c1cb:	48 b8 f9 0b 10 00 00 	movabs $0xffff800000100bf9,%rax
ffff80000010c1d2:	80 ff ff 
ffff80000010c1d5:	ff d0                	callq  *%rax
      char *v = P2V(pa);
ffff80000010c1d7:	48 ba 00 00 00 00 00 	movabs $0xffff800000000000,%rdx
ffff80000010c1de:	80 ff ff 
ffff80000010c1e1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff80000010c1e5:	48 01 d0             	add    %rdx,%rax
ffff80000010c1e8:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
      kfree(v);
ffff80000010c1ec:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
ffff80000010c1f0:	48 89 c7             	mov    %rax,%rdi
ffff80000010c1f3:	48 b8 3a 41 10 00 00 	movabs $0xffff80000010413a,%rax
ffff80000010c1fa:	80 ff ff 
ffff80000010c1fd:	ff d0                	callq  *%rax
      *pte = 0;
ffff80000010c1ff:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff80000010c203:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
  for(; a  < oldsz; a += PGSIZE){
ffff80000010c20a:	48 81 45 f8 00 10 00 	addq   $0x1000,-0x8(%rbp)
ffff80000010c211:	00 
ffff80000010c212:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff80000010c216:	48 3b 45 d0          	cmp    -0x30(%rbp),%rax
ffff80000010c21a:	0f 82 50 ff ff ff    	jb     ffff80000010c170 <deallocuvm+0x44>
    }
  }
  return newsz;
ffff80000010c220:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
}
ffff80000010c224:	c9                   	leaveq 
ffff80000010c225:	c3                   	retq   

ffff80000010c226 <freevm>:

// Free all the pages mapped by, and all the memory used for,
// this page table
void
freevm(pde_t *pml4)
{
ffff80000010c226:	f3 0f 1e fa          	endbr64 
ffff80000010c22a:	55                   	push   %rbp
ffff80000010c22b:	48 89 e5             	mov    %rsp,%rbp
ffff80000010c22e:	48 83 ec 40          	sub    $0x40,%rsp
ffff80000010c232:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  uint i, j, k, l;
  pde_t *pdp, *pd, *pt;

  if(pml4 == 0)
ffff80000010c236:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
ffff80000010c23b:	75 16                	jne    ffff80000010c253 <freevm+0x2d>
    panic("freevm: no pgdir");
ffff80000010c23d:	48 bf af cf 10 00 00 	movabs $0xffff80000010cfaf,%rdi
ffff80000010c244:	80 ff ff 
ffff80000010c247:	48 b8 f9 0b 10 00 00 	movabs $0xffff800000100bf9,%rax
ffff80000010c24e:	80 ff ff 
ffff80000010c251:	ff d0                	callq  *%rax

  // then need to loop through pml4 entry
  for(i = 0; i < (NPDENTRIES/2); i++){
ffff80000010c253:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
ffff80000010c25a:	e9 dc 01 00 00       	jmpq   ffff80000010c43b <freevm+0x215>
    if(pml4[i] & PTE_P){
ffff80000010c25f:	8b 45 fc             	mov    -0x4(%rbp),%eax
ffff80000010c262:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
ffff80000010c269:	00 
ffff80000010c26a:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
ffff80000010c26e:	48 01 d0             	add    %rdx,%rax
ffff80000010c271:	48 8b 00             	mov    (%rax),%rax
ffff80000010c274:	83 e0 01             	and    $0x1,%eax
ffff80000010c277:	48 85 c0             	test   %rax,%rax
ffff80000010c27a:	0f 84 b7 01 00 00    	je     ffff80000010c437 <freevm+0x211>
      pdp = (pdpe_t*)P2V(PTE_ADDR(pml4[i]));
ffff80000010c280:	8b 45 fc             	mov    -0x4(%rbp),%eax
ffff80000010c283:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
ffff80000010c28a:	00 
ffff80000010c28b:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
ffff80000010c28f:	48 01 d0             	add    %rdx,%rax
ffff80000010c292:	48 8b 00             	mov    (%rax),%rax
ffff80000010c295:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
ffff80000010c29b:	48 89 c2             	mov    %rax,%rdx
ffff80000010c29e:	48 b8 00 00 00 00 00 	movabs $0xffff800000000000,%rax
ffff80000010c2a5:	80 ff ff 
ffff80000010c2a8:	48 01 d0             	add    %rdx,%rax
ffff80000010c2ab:	48 89 45 e8          	mov    %rax,-0x18(%rbp)

      // and every entry in the corresponding pdpt
      for(j = 0; j < NPDENTRIES; j++){
ffff80000010c2af:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%rbp)
ffff80000010c2b6:	e9 5c 01 00 00       	jmpq   ffff80000010c417 <freevm+0x1f1>
        if(pdp[j] & PTE_P){
ffff80000010c2bb:	8b 45 f8             	mov    -0x8(%rbp),%eax
ffff80000010c2be:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
ffff80000010c2c5:	00 
ffff80000010c2c6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff80000010c2ca:	48 01 d0             	add    %rdx,%rax
ffff80000010c2cd:	48 8b 00             	mov    (%rax),%rax
ffff80000010c2d0:	83 e0 01             	and    $0x1,%eax
ffff80000010c2d3:	48 85 c0             	test   %rax,%rax
ffff80000010c2d6:	0f 84 37 01 00 00    	je     ffff80000010c413 <freevm+0x1ed>
          pd = (pde_t*)P2V(PTE_ADDR(pdp[j]));
ffff80000010c2dc:	8b 45 f8             	mov    -0x8(%rbp),%eax
ffff80000010c2df:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
ffff80000010c2e6:	00 
ffff80000010c2e7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff80000010c2eb:	48 01 d0             	add    %rdx,%rax
ffff80000010c2ee:	48 8b 00             	mov    (%rax),%rax
ffff80000010c2f1:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
ffff80000010c2f7:	48 89 c2             	mov    %rax,%rdx
ffff80000010c2fa:	48 b8 00 00 00 00 00 	movabs $0xffff800000000000,%rax
ffff80000010c301:	80 ff ff 
ffff80000010c304:	48 01 d0             	add    %rdx,%rax
ffff80000010c307:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

          // and every entry in the corresponding page directory
          for(k = 0; k < (NPDENTRIES); k++){
ffff80000010c30b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%rbp)
ffff80000010c312:	e9 dc 00 00 00       	jmpq   ffff80000010c3f3 <freevm+0x1cd>
            if(pd[k] & PTE_P) {
ffff80000010c317:	8b 45 f4             	mov    -0xc(%rbp),%eax
ffff80000010c31a:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
ffff80000010c321:	00 
ffff80000010c322:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
ffff80000010c326:	48 01 d0             	add    %rdx,%rax
ffff80000010c329:	48 8b 00             	mov    (%rax),%rax
ffff80000010c32c:	83 e0 01             	and    $0x1,%eax
ffff80000010c32f:	48 85 c0             	test   %rax,%rax
ffff80000010c332:	0f 84 b7 00 00 00    	je     ffff80000010c3ef <freevm+0x1c9>
              pt = (pde_t*)P2V(PTE_ADDR(pd[k]));
ffff80000010c338:	8b 45 f4             	mov    -0xc(%rbp),%eax
ffff80000010c33b:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
ffff80000010c342:	00 
ffff80000010c343:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
ffff80000010c347:	48 01 d0             	add    %rdx,%rax
ffff80000010c34a:	48 8b 00             	mov    (%rax),%rax
ffff80000010c34d:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
ffff80000010c353:	48 89 c2             	mov    %rax,%rdx
ffff80000010c356:	48 b8 00 00 00 00 00 	movabs $0xffff800000000000,%rax
ffff80000010c35d:	80 ff ff 
ffff80000010c360:	48 01 d0             	add    %rdx,%rax
ffff80000010c363:	48 89 45 d8          	mov    %rax,-0x28(%rbp)

              // and every entry in the corresponding page table
              for(l = 0; l < (NPDENTRIES); l++){
ffff80000010c367:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%rbp)
ffff80000010c36e:	eb 63                	jmp    ffff80000010c3d3 <freevm+0x1ad>
                if(pt[l] & PTE_P) {
ffff80000010c370:	8b 45 f0             	mov    -0x10(%rbp),%eax
ffff80000010c373:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
ffff80000010c37a:	00 
ffff80000010c37b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
ffff80000010c37f:	48 01 d0             	add    %rdx,%rax
ffff80000010c382:	48 8b 00             	mov    (%rax),%rax
ffff80000010c385:	83 e0 01             	and    $0x1,%eax
ffff80000010c388:	48 85 c0             	test   %rax,%rax
ffff80000010c38b:	74 42                	je     ffff80000010c3cf <freevm+0x1a9>
                  char * v = P2V(PTE_ADDR(pt[l]));
ffff80000010c38d:	8b 45 f0             	mov    -0x10(%rbp),%eax
ffff80000010c390:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
ffff80000010c397:	00 
ffff80000010c398:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
ffff80000010c39c:	48 01 d0             	add    %rdx,%rax
ffff80000010c39f:	48 8b 00             	mov    (%rax),%rax
ffff80000010c3a2:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
ffff80000010c3a8:	48 89 c2             	mov    %rax,%rdx
ffff80000010c3ab:	48 b8 00 00 00 00 00 	movabs $0xffff800000000000,%rax
ffff80000010c3b2:	80 ff ff 
ffff80000010c3b5:	48 01 d0             	add    %rdx,%rax
ffff80000010c3b8:	48 89 45 d0          	mov    %rax,-0x30(%rbp)

                  kfree((char*)v);
ffff80000010c3bc:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
ffff80000010c3c0:	48 89 c7             	mov    %rax,%rdi
ffff80000010c3c3:	48 b8 3a 41 10 00 00 	movabs $0xffff80000010413a,%rax
ffff80000010c3ca:	80 ff ff 
ffff80000010c3cd:	ff d0                	callq  *%rax
              for(l = 0; l < (NPDENTRIES); l++){
ffff80000010c3cf:	83 45 f0 01          	addl   $0x1,-0x10(%rbp)
ffff80000010c3d3:	81 7d f0 ff 01 00 00 	cmpl   $0x1ff,-0x10(%rbp)
ffff80000010c3da:	76 94                	jbe    ffff80000010c370 <freevm+0x14a>
                }
              }
              //freeing every page table
              kfree((char*)pt);
ffff80000010c3dc:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
ffff80000010c3e0:	48 89 c7             	mov    %rax,%rdi
ffff80000010c3e3:	48 b8 3a 41 10 00 00 	movabs $0xffff80000010413a,%rax
ffff80000010c3ea:	80 ff ff 
ffff80000010c3ed:	ff d0                	callq  *%rax
          for(k = 0; k < (NPDENTRIES); k++){
ffff80000010c3ef:	83 45 f4 01          	addl   $0x1,-0xc(%rbp)
ffff80000010c3f3:	81 7d f4 ff 01 00 00 	cmpl   $0x1ff,-0xc(%rbp)
ffff80000010c3fa:	0f 86 17 ff ff ff    	jbe    ffff80000010c317 <freevm+0xf1>
            }
          }
          // freeing every page directory
          kfree((char*)pd);
ffff80000010c400:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
ffff80000010c404:	48 89 c7             	mov    %rax,%rdi
ffff80000010c407:	48 b8 3a 41 10 00 00 	movabs $0xffff80000010413a,%rax
ffff80000010c40e:	80 ff ff 
ffff80000010c411:	ff d0                	callq  *%rax
      for(j = 0; j < NPDENTRIES; j++){
ffff80000010c413:	83 45 f8 01          	addl   $0x1,-0x8(%rbp)
ffff80000010c417:	81 7d f8 ff 01 00 00 	cmpl   $0x1ff,-0x8(%rbp)
ffff80000010c41e:	0f 86 97 fe ff ff    	jbe    ffff80000010c2bb <freevm+0x95>
        }
      }
      // freeing every page directory pointer table
      kfree((char*)pdp);
ffff80000010c424:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff80000010c428:	48 89 c7             	mov    %rax,%rdi
ffff80000010c42b:	48 b8 3a 41 10 00 00 	movabs $0xffff80000010413a,%rax
ffff80000010c432:	80 ff ff 
ffff80000010c435:	ff d0                	callq  *%rax
  for(i = 0; i < (NPDENTRIES/2); i++){
ffff80000010c437:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
ffff80000010c43b:	81 7d fc ff 00 00 00 	cmpl   $0xff,-0x4(%rbp)
ffff80000010c442:	0f 86 17 fe ff ff    	jbe    ffff80000010c25f <freevm+0x39>
    }
  }
  // freeing the pml4
  kfree((char*)pml4);
ffff80000010c448:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
ffff80000010c44c:	48 89 c7             	mov    %rax,%rdi
ffff80000010c44f:	48 b8 3a 41 10 00 00 	movabs $0xffff80000010413a,%rax
ffff80000010c456:	80 ff ff 
ffff80000010c459:	ff d0                	callq  *%rax
}
ffff80000010c45b:	90                   	nop
ffff80000010c45c:	c9                   	leaveq 
ffff80000010c45d:	c3                   	retq   

ffff80000010c45e <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
ffff80000010c45e:	f3 0f 1e fa          	endbr64 
ffff80000010c462:	55                   	push   %rbp
ffff80000010c463:	48 89 e5             	mov    %rsp,%rbp
ffff80000010c466:	48 83 ec 20          	sub    $0x20,%rsp
ffff80000010c46a:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
ffff80000010c46e:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
ffff80000010c472:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
ffff80000010c476:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff80000010c47a:	ba 00 00 00 00       	mov    $0x0,%edx
ffff80000010c47f:	48 89 ce             	mov    %rcx,%rsi
ffff80000010c482:	48 89 c7             	mov    %rax,%rdi
ffff80000010c485:	48 b8 a2 ba 10 00 00 	movabs $0xffff80000010baa2,%rax
ffff80000010c48c:	80 ff ff 
ffff80000010c48f:	ff d0                	callq  *%rax
ffff80000010c491:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  if(pte == 0)
ffff80000010c495:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
ffff80000010c49a:	75 16                	jne    ffff80000010c4b2 <clearpteu+0x54>
    panic("clearpteu");
ffff80000010c49c:	48 bf c0 cf 10 00 00 	movabs $0xffff80000010cfc0,%rdi
ffff80000010c4a3:	80 ff ff 
ffff80000010c4a6:	48 b8 f9 0b 10 00 00 	movabs $0xffff800000100bf9,%rax
ffff80000010c4ad:	80 ff ff 
ffff80000010c4b0:	ff d0                	callq  *%rax
  *pte &= ~PTE_U;
ffff80000010c4b2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff80000010c4b6:	48 8b 00             	mov    (%rax),%rax
ffff80000010c4b9:	48 83 e0 fb          	and    $0xfffffffffffffffb,%rax
ffff80000010c4bd:	48 89 c2             	mov    %rax,%rdx
ffff80000010c4c0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff80000010c4c4:	48 89 10             	mov    %rdx,(%rax)
}
ffff80000010c4c7:	90                   	nop
ffff80000010c4c8:	c9                   	leaveq 
ffff80000010c4c9:	c3                   	retq   

ffff80000010c4ca <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
ffff80000010c4ca:	f3 0f 1e fa          	endbr64 
ffff80000010c4ce:	55                   	push   %rbp
ffff80000010c4cf:	48 89 e5             	mov    %rsp,%rbp
ffff80000010c4d2:	48 83 ec 40          	sub    $0x40,%rsp
ffff80000010c4d6:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
ffff80000010c4da:	89 75 c4             	mov    %esi,-0x3c(%rbp)
  pde_t *d;
  pte_t *pte;
  addr_t pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
ffff80000010c4dd:	48 b8 7c b8 10 00 00 	movabs $0xffff80000010b87c,%rax
ffff80000010c4e4:	80 ff ff 
ffff80000010c4e7:	ff d0                	callq  *%rax
ffff80000010c4e9:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
ffff80000010c4ed:	48 83 7d f0 00       	cmpq   $0x0,-0x10(%rbp)
ffff80000010c4f2:	75 0a                	jne    ffff80000010c4fe <copyuvm+0x34>
    return 0;
ffff80000010c4f4:	b8 00 00 00 00       	mov    $0x0,%eax
ffff80000010c4f9:	e9 51 01 00 00       	jmpq   ffff80000010c64f <copyuvm+0x185>
  for(i = PGSIZE; i < sz; i += PGSIZE){
ffff80000010c4fe:	48 c7 45 f8 00 10 00 	movq   $0x1000,-0x8(%rbp)
ffff80000010c505:	00 
ffff80000010c506:	e9 15 01 00 00       	jmpq   ffff80000010c620 <copyuvm+0x156>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
ffff80000010c50b:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
ffff80000010c50f:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
ffff80000010c513:	ba 00 00 00 00       	mov    $0x0,%edx
ffff80000010c518:	48 89 ce             	mov    %rcx,%rsi
ffff80000010c51b:	48 89 c7             	mov    %rax,%rdi
ffff80000010c51e:	48 b8 a2 ba 10 00 00 	movabs $0xffff80000010baa2,%rax
ffff80000010c525:	80 ff ff 
ffff80000010c528:	ff d0                	callq  *%rax
ffff80000010c52a:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
ffff80000010c52e:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
ffff80000010c533:	75 16                	jne    ffff80000010c54b <copyuvm+0x81>
      panic("copyuvm: pte should exist");
ffff80000010c535:	48 bf ca cf 10 00 00 	movabs $0xffff80000010cfca,%rdi
ffff80000010c53c:	80 ff ff 
ffff80000010c53f:	48 b8 f9 0b 10 00 00 	movabs $0xffff800000100bf9,%rax
ffff80000010c546:	80 ff ff 
ffff80000010c549:	ff d0                	callq  *%rax
    if(!(*pte & PTE_P))
ffff80000010c54b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff80000010c54f:	48 8b 00             	mov    (%rax),%rax
ffff80000010c552:	83 e0 01             	and    $0x1,%eax
ffff80000010c555:	48 85 c0             	test   %rax,%rax
ffff80000010c558:	75 16                	jne    ffff80000010c570 <copyuvm+0xa6>
      panic("copyuvm: page not present");
ffff80000010c55a:	48 bf e4 cf 10 00 00 	movabs $0xffff80000010cfe4,%rdi
ffff80000010c561:	80 ff ff 
ffff80000010c564:	48 b8 f9 0b 10 00 00 	movabs $0xffff800000100bf9,%rax
ffff80000010c56b:	80 ff ff 
ffff80000010c56e:	ff d0                	callq  *%rax
    pa = PTE_ADDR(*pte);
ffff80000010c570:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff80000010c574:	48 8b 00             	mov    (%rax),%rax
ffff80000010c577:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
ffff80000010c57d:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
    flags = PTE_FLAGS(*pte);
ffff80000010c581:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff80000010c585:	48 8b 00             	mov    (%rax),%rax
ffff80000010c588:	25 ff 0f 00 00       	and    $0xfff,%eax
ffff80000010c58d:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
    if((mem = kalloc()) == 0)
ffff80000010c591:	48 b8 34 42 10 00 00 	movabs $0xffff800000104234,%rax
ffff80000010c598:	80 ff ff 
ffff80000010c59b:	ff d0                	callq  *%rax
ffff80000010c59d:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
ffff80000010c5a1:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
ffff80000010c5a6:	0f 84 87 00 00 00    	je     ffff80000010c633 <copyuvm+0x169>
      goto bad;
    memmove(mem, (char*)P2V(pa), PGSIZE);
ffff80000010c5ac:	48 ba 00 00 00 00 00 	movabs $0xffff800000000000,%rdx
ffff80000010c5b3:	80 ff ff 
ffff80000010c5b6:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
ffff80000010c5ba:	48 01 d0             	add    %rdx,%rax
ffff80000010c5bd:	48 89 c1             	mov    %rax,%rcx
ffff80000010c5c0:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
ffff80000010c5c4:	ba 00 10 00 00       	mov    $0x1000,%edx
ffff80000010c5c9:	48 89 ce             	mov    %rcx,%rsi
ffff80000010c5cc:	48 89 c7             	mov    %rax,%rdi
ffff80000010c5cf:	48 b8 ca 83 10 00 00 	movabs $0xffff8000001083ca,%rax
ffff80000010c5d6:	80 ff ff 
ffff80000010c5d9:	ff d0                	callq  *%rax
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0)
ffff80000010c5db:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
ffff80000010c5df:	89 c1                	mov    %eax,%ecx
ffff80000010c5e1:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
ffff80000010c5e5:	48 ba 00 00 00 00 00 	movabs $0x800000000000,%rdx
ffff80000010c5ec:	80 00 00 
ffff80000010c5ef:	48 01 c2             	add    %rax,%rdx
ffff80000010c5f2:	48 8b 75 f8          	mov    -0x8(%rbp),%rsi
ffff80000010c5f6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff80000010c5fa:	41 89 c8             	mov    %ecx,%r8d
ffff80000010c5fd:	48 89 d1             	mov    %rdx,%rcx
ffff80000010c600:	ba 00 10 00 00       	mov    $0x1000,%edx
ffff80000010c605:	48 89 c7             	mov    %rax,%rdi
ffff80000010c608:	48 b8 29 bd 10 00 00 	movabs $0xffff80000010bd29,%rax
ffff80000010c60f:	80 ff ff 
ffff80000010c612:	ff d0                	callq  *%rax
ffff80000010c614:	85 c0                	test   %eax,%eax
ffff80000010c616:	78 1e                	js     ffff80000010c636 <copyuvm+0x16c>
  for(i = PGSIZE; i < sz; i += PGSIZE){
ffff80000010c618:	48 81 45 f8 00 10 00 	addq   $0x1000,-0x8(%rbp)
ffff80000010c61f:	00 
ffff80000010c620:	8b 45 c4             	mov    -0x3c(%rbp),%eax
ffff80000010c623:	48 39 45 f8          	cmp    %rax,-0x8(%rbp)
ffff80000010c627:	0f 82 de fe ff ff    	jb     ffff80000010c50b <copyuvm+0x41>
      goto bad;
  }
  return d;
ffff80000010c62d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff80000010c631:	eb 1c                	jmp    ffff80000010c64f <copyuvm+0x185>
      goto bad;
ffff80000010c633:	90                   	nop
ffff80000010c634:	eb 01                	jmp    ffff80000010c637 <copyuvm+0x16d>
      goto bad;
ffff80000010c636:	90                   	nop

bad:
  freevm(d);
ffff80000010c637:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff80000010c63b:	48 89 c7             	mov    %rax,%rdi
ffff80000010c63e:	48 b8 26 c2 10 00 00 	movabs $0xffff80000010c226,%rax
ffff80000010c645:	80 ff ff 
ffff80000010c648:	ff d0                	callq  *%rax
  return 0;
ffff80000010c64a:	b8 00 00 00 00       	mov    $0x0,%eax
}
ffff80000010c64f:	c9                   	leaveq 
ffff80000010c650:	c3                   	retq   

ffff80000010c651 <uva2ka>:

// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
ffff80000010c651:	f3 0f 1e fa          	endbr64 
ffff80000010c655:	55                   	push   %rbp
ffff80000010c656:	48 89 e5             	mov    %rsp,%rbp
ffff80000010c659:	48 83 ec 20          	sub    $0x20,%rsp
ffff80000010c65d:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
ffff80000010c661:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
ffff80000010c665:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
ffff80000010c669:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff80000010c66d:	ba 00 00 00 00       	mov    $0x0,%edx
ffff80000010c672:	48 89 ce             	mov    %rcx,%rsi
ffff80000010c675:	48 89 c7             	mov    %rax,%rdi
ffff80000010c678:	48 b8 a2 ba 10 00 00 	movabs $0xffff80000010baa2,%rax
ffff80000010c67f:	80 ff ff 
ffff80000010c682:	ff d0                	callq  *%rax
ffff80000010c684:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  if((*pte & PTE_P) == 0)
ffff80000010c688:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff80000010c68c:	48 8b 00             	mov    (%rax),%rax
ffff80000010c68f:	83 e0 01             	and    $0x1,%eax
ffff80000010c692:	48 85 c0             	test   %rax,%rax
ffff80000010c695:	75 07                	jne    ffff80000010c69e <uva2ka+0x4d>
    return 0;
ffff80000010c697:	b8 00 00 00 00       	mov    $0x0,%eax
ffff80000010c69c:	eb 33                	jmp    ffff80000010c6d1 <uva2ka+0x80>
  if((*pte & PTE_U) == 0)
ffff80000010c69e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff80000010c6a2:	48 8b 00             	mov    (%rax),%rax
ffff80000010c6a5:	83 e0 04             	and    $0x4,%eax
ffff80000010c6a8:	48 85 c0             	test   %rax,%rax
ffff80000010c6ab:	75 07                	jne    ffff80000010c6b4 <uva2ka+0x63>
    return 0;
ffff80000010c6ad:	b8 00 00 00 00       	mov    $0x0,%eax
ffff80000010c6b2:	eb 1d                	jmp    ffff80000010c6d1 <uva2ka+0x80>
  return (char*)P2V(PTE_ADDR(*pte));
ffff80000010c6b4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff80000010c6b8:	48 8b 00             	mov    (%rax),%rax
ffff80000010c6bb:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
ffff80000010c6c1:	48 89 c2             	mov    %rax,%rdx
ffff80000010c6c4:	48 b8 00 00 00 00 00 	movabs $0xffff800000000000,%rax
ffff80000010c6cb:	80 ff ff 
ffff80000010c6ce:	48 01 d0             	add    %rdx,%rax
}
ffff80000010c6d1:	c9                   	leaveq 
ffff80000010c6d2:	c3                   	retq   

ffff80000010c6d3 <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, addr_t va, void *p, uint64 len)
{
ffff80000010c6d3:	f3 0f 1e fa          	endbr64 
ffff80000010c6d7:	55                   	push   %rbp
ffff80000010c6d8:	48 89 e5             	mov    %rsp,%rbp
ffff80000010c6db:	48 83 ec 40          	sub    $0x40,%rsp
ffff80000010c6df:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
ffff80000010c6e3:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
ffff80000010c6e7:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
ffff80000010c6eb:	48 89 4d c0          	mov    %rcx,-0x40(%rbp)
  char *buf, *pa0;
  addr_t n, va0;

  buf = (char*)p;
ffff80000010c6ef:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
ffff80000010c6f3:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  while(len > 0){
ffff80000010c6f7:	e9 b0 00 00 00       	jmpq   ffff80000010c7ac <copyout+0xd9>
    va0 = PGROUNDDOWN(va);
ffff80000010c6fc:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
ffff80000010c700:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
ffff80000010c706:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
    pa0 = uva2ka(pgdir, (char*)va0);
ffff80000010c70a:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
ffff80000010c70e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
ffff80000010c712:	48 89 d6             	mov    %rdx,%rsi
ffff80000010c715:	48 89 c7             	mov    %rax,%rdi
ffff80000010c718:	48 b8 51 c6 10 00 00 	movabs $0xffff80000010c651,%rax
ffff80000010c71f:	80 ff ff 
ffff80000010c722:	ff d0                	callq  *%rax
ffff80000010c724:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
    if(pa0 == 0)
ffff80000010c728:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
ffff80000010c72d:	75 0a                	jne    ffff80000010c739 <copyout+0x66>
      return -1;
ffff80000010c72f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
ffff80000010c734:	e9 83 00 00 00       	jmpq   ffff80000010c7bc <copyout+0xe9>
    n = PGSIZE - (va - va0);
ffff80000010c739:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff80000010c73d:	48 2b 45 d0          	sub    -0x30(%rbp),%rax
ffff80000010c741:	48 05 00 10 00 00    	add    $0x1000,%rax
ffff80000010c747:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
    if(n > len)
ffff80000010c74b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff80000010c74f:	48 3b 45 c0          	cmp    -0x40(%rbp),%rax
ffff80000010c753:	76 08                	jbe    ffff80000010c75d <copyout+0x8a>
      n = len;
ffff80000010c755:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
ffff80000010c759:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
    memmove(pa0 + (va - va0), buf, n);
ffff80000010c75d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff80000010c761:	89 c6                	mov    %eax,%esi
ffff80000010c763:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
ffff80000010c767:	48 2b 45 e8          	sub    -0x18(%rbp),%rax
ffff80000010c76b:	48 89 c2             	mov    %rax,%rdx
ffff80000010c76e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
ffff80000010c772:	48 8d 0c 02          	lea    (%rdx,%rax,1),%rcx
ffff80000010c776:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff80000010c77a:	89 f2                	mov    %esi,%edx
ffff80000010c77c:	48 89 c6             	mov    %rax,%rsi
ffff80000010c77f:	48 89 cf             	mov    %rcx,%rdi
ffff80000010c782:	48 b8 ca 83 10 00 00 	movabs $0xffff8000001083ca,%rax
ffff80000010c789:	80 ff ff 
ffff80000010c78c:	ff d0                	callq  *%rax
    len -= n;
ffff80000010c78e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff80000010c792:	48 29 45 c0          	sub    %rax,-0x40(%rbp)
    buf += n;
ffff80000010c796:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff80000010c79a:	48 01 45 f8          	add    %rax,-0x8(%rbp)
    va = va0 + PGSIZE;
ffff80000010c79e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff80000010c7a2:	48 05 00 10 00 00    	add    $0x1000,%rax
ffff80000010c7a8:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  while(len > 0){
ffff80000010c7ac:	48 83 7d c0 00       	cmpq   $0x0,-0x40(%rbp)
ffff80000010c7b1:	0f 85 45 ff ff ff    	jne    ffff80000010c6fc <copyout+0x29>
  }
  return 0;
ffff80000010c7b7:	b8 00 00 00 00       	mov    $0x0,%eax
}
ffff80000010c7bc:	c9                   	leaveq 
ffff80000010c7bd:	c3                   	retq   
