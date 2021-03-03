
_init:     file format elf64-x86-64


Disassembly of section .text:

0000000000001000 <main>:

char *argv[] = { "sh", 0 };

int
main(void)
{
    1000:	f3 0f 1e fa          	endbr64 
    1004:	55                   	push   %rbp
    1005:	48 89 e5             	mov    %rsp,%rbp
    1008:	48 83 ec 10          	sub    $0x10,%rsp
  int pid, wpid;

  if(open("console", O_RDWR) < 0){
    100c:	be 02 00 00 00       	mov    $0x2,%esi
    1011:	48 bf d3 1e 00 00 00 	movabs $0x1ed3,%rdi
    1018:	00 00 00 
    101b:	48 b8 2c 15 00 00 00 	movabs $0x152c,%rax
    1022:	00 00 00 
    1025:	ff d0                	callq  *%rax
    1027:	85 c0                	test   %eax,%eax
    1029:	79 3b                	jns    1066 <main+0x66>
    mknod("console", 1, 1);
    102b:	ba 01 00 00 00       	mov    $0x1,%edx
    1030:	be 01 00 00 00       	mov    $0x1,%esi
    1035:	48 bf d3 1e 00 00 00 	movabs $0x1ed3,%rdi
    103c:	00 00 00 
    103f:	48 b8 39 15 00 00 00 	movabs $0x1539,%rax
    1046:	00 00 00 
    1049:	ff d0                	callq  *%rax
    open("console", O_RDWR);
    104b:	be 02 00 00 00       	mov    $0x2,%esi
    1050:	48 bf d3 1e 00 00 00 	movabs $0x1ed3,%rdi
    1057:	00 00 00 
    105a:	48 b8 2c 15 00 00 00 	movabs $0x152c,%rax
    1061:	00 00 00 
    1064:	ff d0                	callq  *%rax
  }
  dup(0);  // stdout
    1066:	bf 00 00 00 00       	mov    $0x0,%edi
    106b:	48 b8 87 15 00 00 00 	movabs $0x1587,%rax
    1072:	00 00 00 
    1075:	ff d0                	callq  *%rax
  dup(0);  // stderr
    1077:	bf 00 00 00 00       	mov    $0x0,%edi
    107c:	48 b8 87 15 00 00 00 	movabs $0x1587,%rax
    1083:	00 00 00 
    1086:	ff d0                	callq  *%rax

  for(;;){
    printf(1, "init: starting sh\n");
    1088:	48 be db 1e 00 00 00 	movabs $0x1edb,%rsi
    108f:	00 00 00 
    1092:	bf 01 00 00 00       	mov    $0x1,%edi
    1097:	b8 00 00 00 00       	mov    $0x0,%eax
    109c:	48 ba bb 17 00 00 00 	movabs $0x17bb,%rdx
    10a3:	00 00 00 
    10a6:	ff d2                	callq  *%rdx
    pid = fork();
    10a8:	48 b8 b7 14 00 00 00 	movabs $0x14b7,%rax
    10af:	00 00 00 
    10b2:	ff d0                	callq  *%rax
    10b4:	89 45 fc             	mov    %eax,-0x4(%rbp)
    if(pid < 0){
    10b7:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
    10bb:	79 2c                	jns    10e9 <main+0xe9>
      printf(1, "init: fork failed\n");
    10bd:	48 be ee 1e 00 00 00 	movabs $0x1eee,%rsi
    10c4:	00 00 00 
    10c7:	bf 01 00 00 00       	mov    $0x1,%edi
    10cc:	b8 00 00 00 00       	mov    $0x0,%eax
    10d1:	48 ba bb 17 00 00 00 	movabs $0x17bb,%rdx
    10d8:	00 00 00 
    10db:	ff d2                	callq  *%rdx
      exit();
    10dd:	48 b8 c4 14 00 00 00 	movabs $0x14c4,%rax
    10e4:	00 00 00 
    10e7:	ff d0                	callq  *%rax
    }
    if(pid == 0){
    10e9:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
    10ed:	75 6c                	jne    115b <main+0x15b>
      exec("sh", argv);
    10ef:	48 be 50 22 00 00 00 	movabs $0x2250,%rsi
    10f6:	00 00 00 
    10f9:	48 bf d0 1e 00 00 00 	movabs $0x1ed0,%rdi
    1100:	00 00 00 
    1103:	48 b8 1f 15 00 00 00 	movabs $0x151f,%rax
    110a:	00 00 00 
    110d:	ff d0                	callq  *%rax
      printf(1, "init: exec sh failed\n");
    110f:	48 be 01 1f 00 00 00 	movabs $0x1f01,%rsi
    1116:	00 00 00 
    1119:	bf 01 00 00 00       	mov    $0x1,%edi
    111e:	b8 00 00 00 00       	mov    $0x0,%eax
    1123:	48 ba bb 17 00 00 00 	movabs $0x17bb,%rdx
    112a:	00 00 00 
    112d:	ff d2                	callq  *%rdx
      exit();
    112f:	48 b8 c4 14 00 00 00 	movabs $0x14c4,%rax
    1136:	00 00 00 
    1139:	ff d0                	callq  *%rax
    }
    while((wpid=wait()) >= 0 && wpid != pid)
      printf(1, "zombie!\n");
    113b:	48 be 17 1f 00 00 00 	movabs $0x1f17,%rsi
    1142:	00 00 00 
    1145:	bf 01 00 00 00       	mov    $0x1,%edi
    114a:	b8 00 00 00 00       	mov    $0x0,%eax
    114f:	48 ba bb 17 00 00 00 	movabs $0x17bb,%rdx
    1156:	00 00 00 
    1159:	ff d2                	callq  *%rdx
    while((wpid=wait()) >= 0 && wpid != pid)
    115b:	48 b8 d1 14 00 00 00 	movabs $0x14d1,%rax
    1162:	00 00 00 
    1165:	ff d0                	callq  *%rax
    1167:	89 45 f8             	mov    %eax,-0x8(%rbp)
    116a:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
    116e:	0f 88 14 ff ff ff    	js     1088 <main+0x88>
    1174:	8b 45 f8             	mov    -0x8(%rbp),%eax
    1177:	3b 45 fc             	cmp    -0x4(%rbp),%eax
    117a:	75 bf                	jne    113b <main+0x13b>
    printf(1, "init: starting sh\n");
    117c:	e9 07 ff ff ff       	jmpq   1088 <main+0x88>

0000000000001181 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
    1181:	f3 0f 1e fa          	endbr64 
    1185:	55                   	push   %rbp
    1186:	48 89 e5             	mov    %rsp,%rbp
    1189:	48 83 ec 10          	sub    $0x10,%rsp
    118d:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
    1191:	89 75 f4             	mov    %esi,-0xc(%rbp)
    1194:	89 55 f0             	mov    %edx,-0x10(%rbp)
  asm volatile("cld; rep stosb" :
    1197:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
    119b:	8b 55 f0             	mov    -0x10(%rbp),%edx
    119e:	8b 45 f4             	mov    -0xc(%rbp),%eax
    11a1:	48 89 ce             	mov    %rcx,%rsi
    11a4:	48 89 f7             	mov    %rsi,%rdi
    11a7:	89 d1                	mov    %edx,%ecx
    11a9:	fc                   	cld    
    11aa:	f3 aa                	rep stos %al,%es:(%rdi)
    11ac:	89 ca                	mov    %ecx,%edx
    11ae:	48 89 fe             	mov    %rdi,%rsi
    11b1:	48 89 75 f8          	mov    %rsi,-0x8(%rbp)
    11b5:	89 55 f0             	mov    %edx,-0x10(%rbp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
    11b8:	90                   	nop
    11b9:	c9                   	leaveq 
    11ba:	c3                   	retq   

00000000000011bb <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
    11bb:	f3 0f 1e fa          	endbr64 
    11bf:	55                   	push   %rbp
    11c0:	48 89 e5             	mov    %rsp,%rbp
    11c3:	48 83 ec 20          	sub    $0x20,%rsp
    11c7:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
    11cb:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  char *os;

  os = s;
    11cf:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    11d3:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  while((*s++ = *t++) != 0)
    11d7:	90                   	nop
    11d8:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
    11dc:	48 8d 42 01          	lea    0x1(%rdx),%rax
    11e0:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
    11e4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    11e8:	48 8d 48 01          	lea    0x1(%rax),%rcx
    11ec:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
    11f0:	0f b6 12             	movzbl (%rdx),%edx
    11f3:	88 10                	mov    %dl,(%rax)
    11f5:	0f b6 00             	movzbl (%rax),%eax
    11f8:	84 c0                	test   %al,%al
    11fa:	75 dc                	jne    11d8 <strcpy+0x1d>
    ;
  return os;
    11fc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
    1200:	c9                   	leaveq 
    1201:	c3                   	retq   

0000000000001202 <strcmp>:

int
strcmp(const char *p, const char *q)
{
    1202:	f3 0f 1e fa          	endbr64 
    1206:	55                   	push   %rbp
    1207:	48 89 e5             	mov    %rsp,%rbp
    120a:	48 83 ec 10          	sub    $0x10,%rsp
    120e:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
    1212:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  while(*p && *p == *q)
    1216:	eb 0a                	jmp    1222 <strcmp+0x20>
    p++, q++;
    1218:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
    121d:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
  while(*p && *p == *q)
    1222:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1226:	0f b6 00             	movzbl (%rax),%eax
    1229:	84 c0                	test   %al,%al
    122b:	74 12                	je     123f <strcmp+0x3d>
    122d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1231:	0f b6 10             	movzbl (%rax),%edx
    1234:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1238:	0f b6 00             	movzbl (%rax),%eax
    123b:	38 c2                	cmp    %al,%dl
    123d:	74 d9                	je     1218 <strcmp+0x16>
  return (uchar)*p - (uchar)*q;
    123f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1243:	0f b6 00             	movzbl (%rax),%eax
    1246:	0f b6 d0             	movzbl %al,%edx
    1249:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    124d:	0f b6 00             	movzbl (%rax),%eax
    1250:	0f b6 c0             	movzbl %al,%eax
    1253:	29 c2                	sub    %eax,%edx
    1255:	89 d0                	mov    %edx,%eax
}
    1257:	c9                   	leaveq 
    1258:	c3                   	retq   

0000000000001259 <strlen>:

uint
strlen(char *s)
{
    1259:	f3 0f 1e fa          	endbr64 
    125d:	55                   	push   %rbp
    125e:	48 89 e5             	mov    %rsp,%rbp
    1261:	48 83 ec 18          	sub    $0x18,%rsp
    1265:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  int n;

  for(n = 0; s[n]; n++)
    1269:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
    1270:	eb 04                	jmp    1276 <strlen+0x1d>
    1272:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
    1276:	8b 45 fc             	mov    -0x4(%rbp),%eax
    1279:	48 63 d0             	movslq %eax,%rdx
    127c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    1280:	48 01 d0             	add    %rdx,%rax
    1283:	0f b6 00             	movzbl (%rax),%eax
    1286:	84 c0                	test   %al,%al
    1288:	75 e8                	jne    1272 <strlen+0x19>
    ;
  return n;
    128a:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
    128d:	c9                   	leaveq 
    128e:	c3                   	retq   

000000000000128f <memset>:

void*
memset(void *dst, int c, uint n)
{
    128f:	f3 0f 1e fa          	endbr64 
    1293:	55                   	push   %rbp
    1294:	48 89 e5             	mov    %rsp,%rbp
    1297:	48 83 ec 10          	sub    $0x10,%rsp
    129b:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
    129f:	89 75 f4             	mov    %esi,-0xc(%rbp)
    12a2:	89 55 f0             	mov    %edx,-0x10(%rbp)
  stosb(dst, c, n);
    12a5:	8b 55 f0             	mov    -0x10(%rbp),%edx
    12a8:	8b 4d f4             	mov    -0xc(%rbp),%ecx
    12ab:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    12af:	89 ce                	mov    %ecx,%esi
    12b1:	48 89 c7             	mov    %rax,%rdi
    12b4:	48 b8 81 11 00 00 00 	movabs $0x1181,%rax
    12bb:	00 00 00 
    12be:	ff d0                	callq  *%rax
  return dst;
    12c0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
    12c4:	c9                   	leaveq 
    12c5:	c3                   	retq   

00000000000012c6 <strchr>:

char*
strchr(const char *s, char c)
{
    12c6:	f3 0f 1e fa          	endbr64 
    12ca:	55                   	push   %rbp
    12cb:	48 89 e5             	mov    %rsp,%rbp
    12ce:	48 83 ec 10          	sub    $0x10,%rsp
    12d2:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
    12d6:	89 f0                	mov    %esi,%eax
    12d8:	88 45 f4             	mov    %al,-0xc(%rbp)
  for(; *s; s++)
    12db:	eb 17                	jmp    12f4 <strchr+0x2e>
    if(*s == c)
    12dd:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    12e1:	0f b6 00             	movzbl (%rax),%eax
    12e4:	38 45 f4             	cmp    %al,-0xc(%rbp)
    12e7:	75 06                	jne    12ef <strchr+0x29>
      return (char*)s;
    12e9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    12ed:	eb 15                	jmp    1304 <strchr+0x3e>
  for(; *s; s++)
    12ef:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
    12f4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    12f8:	0f b6 00             	movzbl (%rax),%eax
    12fb:	84 c0                	test   %al,%al
    12fd:	75 de                	jne    12dd <strchr+0x17>
  return 0;
    12ff:	b8 00 00 00 00       	mov    $0x0,%eax
}
    1304:	c9                   	leaveq 
    1305:	c3                   	retq   

0000000000001306 <gets>:

char*
gets(char *buf, int max)
{
    1306:	f3 0f 1e fa          	endbr64 
    130a:	55                   	push   %rbp
    130b:	48 89 e5             	mov    %rsp,%rbp
    130e:	48 83 ec 20          	sub    $0x20,%rsp
    1312:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
    1316:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    1319:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
    1320:	eb 4f                	jmp    1371 <gets+0x6b>
    cc = read(0, &c, 1);
    1322:	48 8d 45 f7          	lea    -0x9(%rbp),%rax
    1326:	ba 01 00 00 00       	mov    $0x1,%edx
    132b:	48 89 c6             	mov    %rax,%rsi
    132e:	bf 00 00 00 00       	mov    $0x0,%edi
    1333:	48 b8 eb 14 00 00 00 	movabs $0x14eb,%rax
    133a:	00 00 00 
    133d:	ff d0                	callq  *%rax
    133f:	89 45 f8             	mov    %eax,-0x8(%rbp)
    if(cc < 1)
    1342:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
    1346:	7e 36                	jle    137e <gets+0x78>
      break;
    buf[i++] = c;
    1348:	8b 45 fc             	mov    -0x4(%rbp),%eax
    134b:	8d 50 01             	lea    0x1(%rax),%edx
    134e:	89 55 fc             	mov    %edx,-0x4(%rbp)
    1351:	48 63 d0             	movslq %eax,%rdx
    1354:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    1358:	48 01 c2             	add    %rax,%rdx
    135b:	0f b6 45 f7          	movzbl -0x9(%rbp),%eax
    135f:	88 02                	mov    %al,(%rdx)
    if(c == '\n' || c == '\r')
    1361:	0f b6 45 f7          	movzbl -0x9(%rbp),%eax
    1365:	3c 0a                	cmp    $0xa,%al
    1367:	74 16                	je     137f <gets+0x79>
    1369:	0f b6 45 f7          	movzbl -0x9(%rbp),%eax
    136d:	3c 0d                	cmp    $0xd,%al
    136f:	74 0e                	je     137f <gets+0x79>
  for(i=0; i+1 < max; ){
    1371:	8b 45 fc             	mov    -0x4(%rbp),%eax
    1374:	83 c0 01             	add    $0x1,%eax
    1377:	39 45 e4             	cmp    %eax,-0x1c(%rbp)
    137a:	7f a6                	jg     1322 <gets+0x1c>
    137c:	eb 01                	jmp    137f <gets+0x79>
      break;
    137e:	90                   	nop
      break;
  }
  buf[i] = '\0';
    137f:	8b 45 fc             	mov    -0x4(%rbp),%eax
    1382:	48 63 d0             	movslq %eax,%rdx
    1385:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    1389:	48 01 d0             	add    %rdx,%rax
    138c:	c6 00 00             	movb   $0x0,(%rax)
  return buf;
    138f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
    1393:	c9                   	leaveq 
    1394:	c3                   	retq   

0000000000001395 <stat>:

int
stat(char *n, struct stat *st)
{
    1395:	f3 0f 1e fa          	endbr64 
    1399:	55                   	push   %rbp
    139a:	48 89 e5             	mov    %rsp,%rbp
    139d:	48 83 ec 20          	sub    $0x20,%rsp
    13a1:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
    13a5:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  int fd;
  int r;

  fd = open(n, O_RDONLY);
    13a9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    13ad:	be 00 00 00 00       	mov    $0x0,%esi
    13b2:	48 89 c7             	mov    %rax,%rdi
    13b5:	48 b8 2c 15 00 00 00 	movabs $0x152c,%rax
    13bc:	00 00 00 
    13bf:	ff d0                	callq  *%rax
    13c1:	89 45 fc             	mov    %eax,-0x4(%rbp)
  if(fd < 0)
    13c4:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
    13c8:	79 07                	jns    13d1 <stat+0x3c>
    return -1;
    13ca:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    13cf:	eb 2f                	jmp    1400 <stat+0x6b>
  r = fstat(fd, st);
    13d1:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
    13d5:	8b 45 fc             	mov    -0x4(%rbp),%eax
    13d8:	48 89 d6             	mov    %rdx,%rsi
    13db:	89 c7                	mov    %eax,%edi
    13dd:	48 b8 53 15 00 00 00 	movabs $0x1553,%rax
    13e4:	00 00 00 
    13e7:	ff d0                	callq  *%rax
    13e9:	89 45 f8             	mov    %eax,-0x8(%rbp)
  close(fd);
    13ec:	8b 45 fc             	mov    -0x4(%rbp),%eax
    13ef:	89 c7                	mov    %eax,%edi
    13f1:	48 b8 05 15 00 00 00 	movabs $0x1505,%rax
    13f8:	00 00 00 
    13fb:	ff d0                	callq  *%rax
  return r;
    13fd:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
    1400:	c9                   	leaveq 
    1401:	c3                   	retq   

0000000000001402 <atoi>:

int
atoi(const char *s)
{
    1402:	f3 0f 1e fa          	endbr64 
    1406:	55                   	push   %rbp
    1407:	48 89 e5             	mov    %rsp,%rbp
    140a:	48 83 ec 18          	sub    $0x18,%rsp
    140e:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  int n;

  n = 0;
    1412:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  while('0' <= *s && *s <= '9')
    1419:	eb 28                	jmp    1443 <atoi+0x41>
    n = n*10 + *s++ - '0';
    141b:	8b 55 fc             	mov    -0x4(%rbp),%edx
    141e:	89 d0                	mov    %edx,%eax
    1420:	c1 e0 02             	shl    $0x2,%eax
    1423:	01 d0                	add    %edx,%eax
    1425:	01 c0                	add    %eax,%eax
    1427:	89 c1                	mov    %eax,%ecx
    1429:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    142d:	48 8d 50 01          	lea    0x1(%rax),%rdx
    1431:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
    1435:	0f b6 00             	movzbl (%rax),%eax
    1438:	0f be c0             	movsbl %al,%eax
    143b:	01 c8                	add    %ecx,%eax
    143d:	83 e8 30             	sub    $0x30,%eax
    1440:	89 45 fc             	mov    %eax,-0x4(%rbp)
  while('0' <= *s && *s <= '9')
    1443:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    1447:	0f b6 00             	movzbl (%rax),%eax
    144a:	3c 2f                	cmp    $0x2f,%al
    144c:	7e 0b                	jle    1459 <atoi+0x57>
    144e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    1452:	0f b6 00             	movzbl (%rax),%eax
    1455:	3c 39                	cmp    $0x39,%al
    1457:	7e c2                	jle    141b <atoi+0x19>
  return n;
    1459:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
    145c:	c9                   	leaveq 
    145d:	c3                   	retq   

000000000000145e <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
    145e:	f3 0f 1e fa          	endbr64 
    1462:	55                   	push   %rbp
    1463:	48 89 e5             	mov    %rsp,%rbp
    1466:	48 83 ec 28          	sub    $0x28,%rsp
    146a:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
    146e:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
    1472:	89 55 dc             	mov    %edx,-0x24(%rbp)
  char *dst, *src;

  dst = vdst;
    1475:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    1479:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  src = vsrc;
    147d:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
    1481:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
  while(n-- > 0)
    1485:	eb 1d                	jmp    14a4 <memmove+0x46>
    *dst++ = *src++;
    1487:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
    148b:	48 8d 42 01          	lea    0x1(%rdx),%rax
    148f:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
    1493:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1497:	48 8d 48 01          	lea    0x1(%rax),%rcx
    149b:	48 89 4d f8          	mov    %rcx,-0x8(%rbp)
    149f:	0f b6 12             	movzbl (%rdx),%edx
    14a2:	88 10                	mov    %dl,(%rax)
  while(n-- > 0)
    14a4:	8b 45 dc             	mov    -0x24(%rbp),%eax
    14a7:	8d 50 ff             	lea    -0x1(%rax),%edx
    14aa:	89 55 dc             	mov    %edx,-0x24(%rbp)
    14ad:	85 c0                	test   %eax,%eax
    14af:	7f d6                	jg     1487 <memmove+0x29>
  return vdst;
    14b1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
    14b5:	c9                   	leaveq 
    14b6:	c3                   	retq   

00000000000014b7 <fork>:
    mov $SYS_ ## name, %rax; \
    mov %rcx, %r10 ;\
    syscall		  ;\
    ret

SYSCALL(fork)
    14b7:	48 c7 c0 01 00 00 00 	mov    $0x1,%rax
    14be:	49 89 ca             	mov    %rcx,%r10
    14c1:	0f 05                	syscall 
    14c3:	c3                   	retq   

00000000000014c4 <exit>:
SYSCALL(exit)
    14c4:	48 c7 c0 02 00 00 00 	mov    $0x2,%rax
    14cb:	49 89 ca             	mov    %rcx,%r10
    14ce:	0f 05                	syscall 
    14d0:	c3                   	retq   

00000000000014d1 <wait>:
SYSCALL(wait)
    14d1:	48 c7 c0 03 00 00 00 	mov    $0x3,%rax
    14d8:	49 89 ca             	mov    %rcx,%r10
    14db:	0f 05                	syscall 
    14dd:	c3                   	retq   

00000000000014de <pipe>:
SYSCALL(pipe)
    14de:	48 c7 c0 04 00 00 00 	mov    $0x4,%rax
    14e5:	49 89 ca             	mov    %rcx,%r10
    14e8:	0f 05                	syscall 
    14ea:	c3                   	retq   

00000000000014eb <read>:
SYSCALL(read)
    14eb:	48 c7 c0 05 00 00 00 	mov    $0x5,%rax
    14f2:	49 89 ca             	mov    %rcx,%r10
    14f5:	0f 05                	syscall 
    14f7:	c3                   	retq   

00000000000014f8 <write>:
SYSCALL(write)
    14f8:	48 c7 c0 10 00 00 00 	mov    $0x10,%rax
    14ff:	49 89 ca             	mov    %rcx,%r10
    1502:	0f 05                	syscall 
    1504:	c3                   	retq   

0000000000001505 <close>:
SYSCALL(close)
    1505:	48 c7 c0 15 00 00 00 	mov    $0x15,%rax
    150c:	49 89 ca             	mov    %rcx,%r10
    150f:	0f 05                	syscall 
    1511:	c3                   	retq   

0000000000001512 <kill>:
SYSCALL(kill)
    1512:	48 c7 c0 06 00 00 00 	mov    $0x6,%rax
    1519:	49 89 ca             	mov    %rcx,%r10
    151c:	0f 05                	syscall 
    151e:	c3                   	retq   

000000000000151f <exec>:
SYSCALL(exec)
    151f:	48 c7 c0 07 00 00 00 	mov    $0x7,%rax
    1526:	49 89 ca             	mov    %rcx,%r10
    1529:	0f 05                	syscall 
    152b:	c3                   	retq   

000000000000152c <open>:
SYSCALL(open)
    152c:	48 c7 c0 0f 00 00 00 	mov    $0xf,%rax
    1533:	49 89 ca             	mov    %rcx,%r10
    1536:	0f 05                	syscall 
    1538:	c3                   	retq   

0000000000001539 <mknod>:
SYSCALL(mknod)
    1539:	48 c7 c0 11 00 00 00 	mov    $0x11,%rax
    1540:	49 89 ca             	mov    %rcx,%r10
    1543:	0f 05                	syscall 
    1545:	c3                   	retq   

0000000000001546 <unlink>:
SYSCALL(unlink)
    1546:	48 c7 c0 12 00 00 00 	mov    $0x12,%rax
    154d:	49 89 ca             	mov    %rcx,%r10
    1550:	0f 05                	syscall 
    1552:	c3                   	retq   

0000000000001553 <fstat>:
SYSCALL(fstat)
    1553:	48 c7 c0 08 00 00 00 	mov    $0x8,%rax
    155a:	49 89 ca             	mov    %rcx,%r10
    155d:	0f 05                	syscall 
    155f:	c3                   	retq   

0000000000001560 <link>:
SYSCALL(link)
    1560:	48 c7 c0 13 00 00 00 	mov    $0x13,%rax
    1567:	49 89 ca             	mov    %rcx,%r10
    156a:	0f 05                	syscall 
    156c:	c3                   	retq   

000000000000156d <mkdir>:
SYSCALL(mkdir)
    156d:	48 c7 c0 14 00 00 00 	mov    $0x14,%rax
    1574:	49 89 ca             	mov    %rcx,%r10
    1577:	0f 05                	syscall 
    1579:	c3                   	retq   

000000000000157a <chdir>:
SYSCALL(chdir)
    157a:	48 c7 c0 09 00 00 00 	mov    $0x9,%rax
    1581:	49 89 ca             	mov    %rcx,%r10
    1584:	0f 05                	syscall 
    1586:	c3                   	retq   

0000000000001587 <dup>:
SYSCALL(dup)
    1587:	48 c7 c0 0a 00 00 00 	mov    $0xa,%rax
    158e:	49 89 ca             	mov    %rcx,%r10
    1591:	0f 05                	syscall 
    1593:	c3                   	retq   

0000000000001594 <getpid>:
SYSCALL(getpid)
    1594:	48 c7 c0 0b 00 00 00 	mov    $0xb,%rax
    159b:	49 89 ca             	mov    %rcx,%r10
    159e:	0f 05                	syscall 
    15a0:	c3                   	retq   

00000000000015a1 <sbrk>:
SYSCALL(sbrk)
    15a1:	48 c7 c0 0c 00 00 00 	mov    $0xc,%rax
    15a8:	49 89 ca             	mov    %rcx,%r10
    15ab:	0f 05                	syscall 
    15ad:	c3                   	retq   

00000000000015ae <sleep>:
SYSCALL(sleep)
    15ae:	48 c7 c0 0d 00 00 00 	mov    $0xd,%rax
    15b5:	49 89 ca             	mov    %rcx,%r10
    15b8:	0f 05                	syscall 
    15ba:	c3                   	retq   

00000000000015bb <uptime>:
SYSCALL(uptime)
    15bb:	48 c7 c0 0e 00 00 00 	mov    $0xe,%rax
    15c2:	49 89 ca             	mov    %rcx,%r10
    15c5:	0f 05                	syscall 
    15c7:	c3                   	retq   

00000000000015c8 <aread>:
SYSCALL(aread)
    15c8:	48 c7 c0 16 00 00 00 	mov    $0x16,%rax
    15cf:	49 89 ca             	mov    %rcx,%r10
    15d2:	0f 05                	syscall 
    15d4:	c3                   	retq   

00000000000015d5 <putc>:

#include <stdarg.h>

static void
putc(int fd, char c)
{
    15d5:	f3 0f 1e fa          	endbr64 
    15d9:	55                   	push   %rbp
    15da:	48 89 e5             	mov    %rsp,%rbp
    15dd:	48 83 ec 10          	sub    $0x10,%rsp
    15e1:	89 7d fc             	mov    %edi,-0x4(%rbp)
    15e4:	89 f0                	mov    %esi,%eax
    15e6:	88 45 f8             	mov    %al,-0x8(%rbp)
  write(fd, &c, 1);
    15e9:	48 8d 4d f8          	lea    -0x8(%rbp),%rcx
    15ed:	8b 45 fc             	mov    -0x4(%rbp),%eax
    15f0:	ba 01 00 00 00       	mov    $0x1,%edx
    15f5:	48 89 ce             	mov    %rcx,%rsi
    15f8:	89 c7                	mov    %eax,%edi
    15fa:	48 b8 f8 14 00 00 00 	movabs $0x14f8,%rax
    1601:	00 00 00 
    1604:	ff d0                	callq  *%rax
}
    1606:	90                   	nop
    1607:	c9                   	leaveq 
    1608:	c3                   	retq   

0000000000001609 <print_x64>:

static char digits[] = "0123456789abcdef";

  static void
print_x64(int fd, addr_t x)
{
    1609:	f3 0f 1e fa          	endbr64 
    160d:	55                   	push   %rbp
    160e:	48 89 e5             	mov    %rsp,%rbp
    1611:	48 83 ec 20          	sub    $0x20,%rsp
    1615:	89 7d ec             	mov    %edi,-0x14(%rbp)
    1618:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  int i;
  for (i = 0; i < (sizeof(addr_t) * 2); i++, x <<= 4)
    161c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
    1623:	eb 35                	jmp    165a <print_x64+0x51>
    putc(fd, digits[x >> (sizeof(addr_t) * 8 - 4)]);
    1625:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
    1629:	48 c1 e8 3c          	shr    $0x3c,%rax
    162d:	48 ba 60 22 00 00 00 	movabs $0x2260,%rdx
    1634:	00 00 00 
    1637:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax
    163b:	0f be d0             	movsbl %al,%edx
    163e:	8b 45 ec             	mov    -0x14(%rbp),%eax
    1641:	89 d6                	mov    %edx,%esi
    1643:	89 c7                	mov    %eax,%edi
    1645:	48 b8 d5 15 00 00 00 	movabs $0x15d5,%rax
    164c:	00 00 00 
    164f:	ff d0                	callq  *%rax
  for (i = 0; i < (sizeof(addr_t) * 2); i++, x <<= 4)
    1651:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
    1655:	48 c1 65 e0 04       	shlq   $0x4,-0x20(%rbp)
    165a:	8b 45 fc             	mov    -0x4(%rbp),%eax
    165d:	83 f8 0f             	cmp    $0xf,%eax
    1660:	76 c3                	jbe    1625 <print_x64+0x1c>
}
    1662:	90                   	nop
    1663:	90                   	nop
    1664:	c9                   	leaveq 
    1665:	c3                   	retq   

0000000000001666 <print_x32>:

  static void
print_x32(int fd, uint x)
{
    1666:	f3 0f 1e fa          	endbr64 
    166a:	55                   	push   %rbp
    166b:	48 89 e5             	mov    %rsp,%rbp
    166e:	48 83 ec 20          	sub    $0x20,%rsp
    1672:	89 7d ec             	mov    %edi,-0x14(%rbp)
    1675:	89 75 e8             	mov    %esi,-0x18(%rbp)
  int i;
  for (i = 0; i < (sizeof(uint) * 2); i++, x <<= 4)
    1678:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
    167f:	eb 36                	jmp    16b7 <print_x32+0x51>
    putc(fd, digits[x >> (sizeof(uint) * 8 - 4)]);
    1681:	8b 45 e8             	mov    -0x18(%rbp),%eax
    1684:	c1 e8 1c             	shr    $0x1c,%eax
    1687:	89 c2                	mov    %eax,%edx
    1689:	48 b8 60 22 00 00 00 	movabs $0x2260,%rax
    1690:	00 00 00 
    1693:	89 d2                	mov    %edx,%edx
    1695:	0f b6 04 10          	movzbl (%rax,%rdx,1),%eax
    1699:	0f be d0             	movsbl %al,%edx
    169c:	8b 45 ec             	mov    -0x14(%rbp),%eax
    169f:	89 d6                	mov    %edx,%esi
    16a1:	89 c7                	mov    %eax,%edi
    16a3:	48 b8 d5 15 00 00 00 	movabs $0x15d5,%rax
    16aa:	00 00 00 
    16ad:	ff d0                	callq  *%rax
  for (i = 0; i < (sizeof(uint) * 2); i++, x <<= 4)
    16af:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
    16b3:	c1 65 e8 04          	shll   $0x4,-0x18(%rbp)
    16b7:	8b 45 fc             	mov    -0x4(%rbp),%eax
    16ba:	83 f8 07             	cmp    $0x7,%eax
    16bd:	76 c2                	jbe    1681 <print_x32+0x1b>
}
    16bf:	90                   	nop
    16c0:	90                   	nop
    16c1:	c9                   	leaveq 
    16c2:	c3                   	retq   

00000000000016c3 <print_d>:

  static void
print_d(int fd, int v)
{
    16c3:	f3 0f 1e fa          	endbr64 
    16c7:	55                   	push   %rbp
    16c8:	48 89 e5             	mov    %rsp,%rbp
    16cb:	48 83 ec 30          	sub    $0x30,%rsp
    16cf:	89 7d dc             	mov    %edi,-0x24(%rbp)
    16d2:	89 75 d8             	mov    %esi,-0x28(%rbp)
  char buf[16];
  int64 x = v;
    16d5:	8b 45 d8             	mov    -0x28(%rbp),%eax
    16d8:	48 98                	cltq   
    16da:	48 89 45 f8          	mov    %rax,-0x8(%rbp)

  if (v < 0)
    16de:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
    16e2:	79 04                	jns    16e8 <print_d+0x25>
    x = -x;
    16e4:	48 f7 5d f8          	negq   -0x8(%rbp)

  int i = 0;
    16e8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%rbp)
  do {
    buf[i++] = digits[x % 10];
    16ef:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
    16f3:	48 ba 67 66 66 66 66 	movabs $0x6666666666666667,%rdx
    16fa:	66 66 66 
    16fd:	48 89 c8             	mov    %rcx,%rax
    1700:	48 f7 ea             	imul   %rdx
    1703:	48 c1 fa 02          	sar    $0x2,%rdx
    1707:	48 89 c8             	mov    %rcx,%rax
    170a:	48 c1 f8 3f          	sar    $0x3f,%rax
    170e:	48 29 c2             	sub    %rax,%rdx
    1711:	48 89 d0             	mov    %rdx,%rax
    1714:	48 c1 e0 02          	shl    $0x2,%rax
    1718:	48 01 d0             	add    %rdx,%rax
    171b:	48 01 c0             	add    %rax,%rax
    171e:	48 29 c1             	sub    %rax,%rcx
    1721:	48 89 ca             	mov    %rcx,%rdx
    1724:	8b 45 f4             	mov    -0xc(%rbp),%eax
    1727:	8d 48 01             	lea    0x1(%rax),%ecx
    172a:	89 4d f4             	mov    %ecx,-0xc(%rbp)
    172d:	48 b9 60 22 00 00 00 	movabs $0x2260,%rcx
    1734:	00 00 00 
    1737:	0f b6 14 11          	movzbl (%rcx,%rdx,1),%edx
    173b:	48 98                	cltq   
    173d:	88 54 05 e0          	mov    %dl,-0x20(%rbp,%rax,1)
    x /= 10;
    1741:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
    1745:	48 ba 67 66 66 66 66 	movabs $0x6666666666666667,%rdx
    174c:	66 66 66 
    174f:	48 89 c8             	mov    %rcx,%rax
    1752:	48 f7 ea             	imul   %rdx
    1755:	48 c1 fa 02          	sar    $0x2,%rdx
    1759:	48 89 c8             	mov    %rcx,%rax
    175c:	48 c1 f8 3f          	sar    $0x3f,%rax
    1760:	48 29 c2             	sub    %rax,%rdx
    1763:	48 89 d0             	mov    %rdx,%rax
    1766:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  } while(x != 0);
    176a:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
    176f:	0f 85 7a ff ff ff    	jne    16ef <print_d+0x2c>

  if (v < 0)
    1775:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
    1779:	79 32                	jns    17ad <print_d+0xea>
    buf[i++] = '-';
    177b:	8b 45 f4             	mov    -0xc(%rbp),%eax
    177e:	8d 50 01             	lea    0x1(%rax),%edx
    1781:	89 55 f4             	mov    %edx,-0xc(%rbp)
    1784:	48 98                	cltq   
    1786:	c6 44 05 e0 2d       	movb   $0x2d,-0x20(%rbp,%rax,1)

  while (--i >= 0)
    178b:	eb 20                	jmp    17ad <print_d+0xea>
    putc(fd, buf[i]);
    178d:	8b 45 f4             	mov    -0xc(%rbp),%eax
    1790:	48 98                	cltq   
    1792:	0f b6 44 05 e0       	movzbl -0x20(%rbp,%rax,1),%eax
    1797:	0f be d0             	movsbl %al,%edx
    179a:	8b 45 dc             	mov    -0x24(%rbp),%eax
    179d:	89 d6                	mov    %edx,%esi
    179f:	89 c7                	mov    %eax,%edi
    17a1:	48 b8 d5 15 00 00 00 	movabs $0x15d5,%rax
    17a8:	00 00 00 
    17ab:	ff d0                	callq  *%rax
  while (--i >= 0)
    17ad:	83 6d f4 01          	subl   $0x1,-0xc(%rbp)
    17b1:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
    17b5:	79 d6                	jns    178d <print_d+0xca>
}
    17b7:	90                   	nop
    17b8:	90                   	nop
    17b9:	c9                   	leaveq 
    17ba:	c3                   	retq   

00000000000017bb <printf>:
// Print to the given fd. Only understands %d, %x, %p, %s.
  void
printf(int fd, char *fmt, ...)
{
    17bb:	f3 0f 1e fa          	endbr64 
    17bf:	55                   	push   %rbp
    17c0:	48 89 e5             	mov    %rsp,%rbp
    17c3:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
    17ca:	89 bd 1c ff ff ff    	mov    %edi,-0xe4(%rbp)
    17d0:	48 89 b5 10 ff ff ff 	mov    %rsi,-0xf0(%rbp)
    17d7:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
    17de:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
    17e5:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
    17ec:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
    17f3:	84 c0                	test   %al,%al
    17f5:	74 20                	je     1817 <printf+0x5c>
    17f7:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
    17fb:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
    17ff:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
    1803:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
    1807:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
    180b:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
    180f:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
    1813:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  va_list ap;
  int i, c;
  char *s;

  va_start(ap, fmt);
    1817:	c7 85 20 ff ff ff 10 	movl   $0x10,-0xe0(%rbp)
    181e:	00 00 00 
    1821:	c7 85 24 ff ff ff 30 	movl   $0x30,-0xdc(%rbp)
    1828:	00 00 00 
    182b:	48 8d 45 10          	lea    0x10(%rbp),%rax
    182f:	48 89 85 28 ff ff ff 	mov    %rax,-0xd8(%rbp)
    1836:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
    183d:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  for (i = 0; (c = fmt[i] & 0xff) != 0; i++) {
    1844:	c7 85 4c ff ff ff 00 	movl   $0x0,-0xb4(%rbp)
    184b:	00 00 00 
    184e:	e9 41 03 00 00       	jmpq   1b94 <printf+0x3d9>
    if (c != '%') {
    1853:	83 bd 3c ff ff ff 25 	cmpl   $0x25,-0xc4(%rbp)
    185a:	74 24                	je     1880 <printf+0xc5>
      putc(fd, c);
    185c:	8b 85 3c ff ff ff    	mov    -0xc4(%rbp),%eax
    1862:	0f be d0             	movsbl %al,%edx
    1865:	8b 85 1c ff ff ff    	mov    -0xe4(%rbp),%eax
    186b:	89 d6                	mov    %edx,%esi
    186d:	89 c7                	mov    %eax,%edi
    186f:	48 b8 d5 15 00 00 00 	movabs $0x15d5,%rax
    1876:	00 00 00 
    1879:	ff d0                	callq  *%rax
      continue;
    187b:	e9 0d 03 00 00       	jmpq   1b8d <printf+0x3d2>
    }
    c = fmt[++i] & 0xff;
    1880:	83 85 4c ff ff ff 01 	addl   $0x1,-0xb4(%rbp)
    1887:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
    188d:	48 63 d0             	movslq %eax,%rdx
    1890:	48 8b 85 10 ff ff ff 	mov    -0xf0(%rbp),%rax
    1897:	48 01 d0             	add    %rdx,%rax
    189a:	0f b6 00             	movzbl (%rax),%eax
    189d:	0f be c0             	movsbl %al,%eax
    18a0:	25 ff 00 00 00       	and    $0xff,%eax
    18a5:	89 85 3c ff ff ff    	mov    %eax,-0xc4(%rbp)
    if (c == 0)
    18ab:	83 bd 3c ff ff ff 00 	cmpl   $0x0,-0xc4(%rbp)
    18b2:	0f 84 0f 03 00 00    	je     1bc7 <printf+0x40c>
      break;
    switch(c) {
    18b8:	83 bd 3c ff ff ff 25 	cmpl   $0x25,-0xc4(%rbp)
    18bf:	0f 84 74 02 00 00    	je     1b39 <printf+0x37e>
    18c5:	83 bd 3c ff ff ff 25 	cmpl   $0x25,-0xc4(%rbp)
    18cc:	0f 8c 82 02 00 00    	jl     1b54 <printf+0x399>
    18d2:	83 bd 3c ff ff ff 78 	cmpl   $0x78,-0xc4(%rbp)
    18d9:	0f 8f 75 02 00 00    	jg     1b54 <printf+0x399>
    18df:	83 bd 3c ff ff ff 63 	cmpl   $0x63,-0xc4(%rbp)
    18e6:	0f 8c 68 02 00 00    	jl     1b54 <printf+0x399>
    18ec:	8b 85 3c ff ff ff    	mov    -0xc4(%rbp),%eax
    18f2:	83 e8 63             	sub    $0x63,%eax
    18f5:	83 f8 15             	cmp    $0x15,%eax
    18f8:	0f 87 56 02 00 00    	ja     1b54 <printf+0x399>
    18fe:	89 c0                	mov    %eax,%eax
    1900:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
    1907:	00 
    1908:	48 b8 28 1f 00 00 00 	movabs $0x1f28,%rax
    190f:	00 00 00 
    1912:	48 01 d0             	add    %rdx,%rax
    1915:	48 8b 00             	mov    (%rax),%rax
    1918:	3e ff e0             	notrack jmpq *%rax
    case 'c':
      putc(fd, va_arg(ap, int));
    191b:	8b 85 20 ff ff ff    	mov    -0xe0(%rbp),%eax
    1921:	83 f8 2f             	cmp    $0x2f,%eax
    1924:	77 23                	ja     1949 <printf+0x18e>
    1926:	48 8b 85 30 ff ff ff 	mov    -0xd0(%rbp),%rax
    192d:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    1933:	89 d2                	mov    %edx,%edx
    1935:	48 01 d0             	add    %rdx,%rax
    1938:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    193e:	83 c2 08             	add    $0x8,%edx
    1941:	89 95 20 ff ff ff    	mov    %edx,-0xe0(%rbp)
    1947:	eb 12                	jmp    195b <printf+0x1a0>
    1949:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
    1950:	48 8d 50 08          	lea    0x8(%rax),%rdx
    1954:	48 89 95 28 ff ff ff 	mov    %rdx,-0xd8(%rbp)
    195b:	8b 00                	mov    (%rax),%eax
    195d:	0f be d0             	movsbl %al,%edx
    1960:	8b 85 1c ff ff ff    	mov    -0xe4(%rbp),%eax
    1966:	89 d6                	mov    %edx,%esi
    1968:	89 c7                	mov    %eax,%edi
    196a:	48 b8 d5 15 00 00 00 	movabs $0x15d5,%rax
    1971:	00 00 00 
    1974:	ff d0                	callq  *%rax
      break;
    1976:	e9 12 02 00 00       	jmpq   1b8d <printf+0x3d2>
    case 'd':
      print_d(fd, va_arg(ap, int));
    197b:	8b 85 20 ff ff ff    	mov    -0xe0(%rbp),%eax
    1981:	83 f8 2f             	cmp    $0x2f,%eax
    1984:	77 23                	ja     19a9 <printf+0x1ee>
    1986:	48 8b 85 30 ff ff ff 	mov    -0xd0(%rbp),%rax
    198d:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    1993:	89 d2                	mov    %edx,%edx
    1995:	48 01 d0             	add    %rdx,%rax
    1998:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    199e:	83 c2 08             	add    $0x8,%edx
    19a1:	89 95 20 ff ff ff    	mov    %edx,-0xe0(%rbp)
    19a7:	eb 12                	jmp    19bb <printf+0x200>
    19a9:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
    19b0:	48 8d 50 08          	lea    0x8(%rax),%rdx
    19b4:	48 89 95 28 ff ff ff 	mov    %rdx,-0xd8(%rbp)
    19bb:	8b 10                	mov    (%rax),%edx
    19bd:	8b 85 1c ff ff ff    	mov    -0xe4(%rbp),%eax
    19c3:	89 d6                	mov    %edx,%esi
    19c5:	89 c7                	mov    %eax,%edi
    19c7:	48 b8 c3 16 00 00 00 	movabs $0x16c3,%rax
    19ce:	00 00 00 
    19d1:	ff d0                	callq  *%rax
      break;
    19d3:	e9 b5 01 00 00       	jmpq   1b8d <printf+0x3d2>
    case 'x':
      print_x32(fd, va_arg(ap, uint));
    19d8:	8b 85 20 ff ff ff    	mov    -0xe0(%rbp),%eax
    19de:	83 f8 2f             	cmp    $0x2f,%eax
    19e1:	77 23                	ja     1a06 <printf+0x24b>
    19e3:	48 8b 85 30 ff ff ff 	mov    -0xd0(%rbp),%rax
    19ea:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    19f0:	89 d2                	mov    %edx,%edx
    19f2:	48 01 d0             	add    %rdx,%rax
    19f5:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    19fb:	83 c2 08             	add    $0x8,%edx
    19fe:	89 95 20 ff ff ff    	mov    %edx,-0xe0(%rbp)
    1a04:	eb 12                	jmp    1a18 <printf+0x25d>
    1a06:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
    1a0d:	48 8d 50 08          	lea    0x8(%rax),%rdx
    1a11:	48 89 95 28 ff ff ff 	mov    %rdx,-0xd8(%rbp)
    1a18:	8b 10                	mov    (%rax),%edx
    1a1a:	8b 85 1c ff ff ff    	mov    -0xe4(%rbp),%eax
    1a20:	89 d6                	mov    %edx,%esi
    1a22:	89 c7                	mov    %eax,%edi
    1a24:	48 b8 66 16 00 00 00 	movabs $0x1666,%rax
    1a2b:	00 00 00 
    1a2e:	ff d0                	callq  *%rax
      break;
    1a30:	e9 58 01 00 00       	jmpq   1b8d <printf+0x3d2>
    case 'p':
      print_x64(fd, va_arg(ap, addr_t));
    1a35:	8b 85 20 ff ff ff    	mov    -0xe0(%rbp),%eax
    1a3b:	83 f8 2f             	cmp    $0x2f,%eax
    1a3e:	77 23                	ja     1a63 <printf+0x2a8>
    1a40:	48 8b 85 30 ff ff ff 	mov    -0xd0(%rbp),%rax
    1a47:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    1a4d:	89 d2                	mov    %edx,%edx
    1a4f:	48 01 d0             	add    %rdx,%rax
    1a52:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    1a58:	83 c2 08             	add    $0x8,%edx
    1a5b:	89 95 20 ff ff ff    	mov    %edx,-0xe0(%rbp)
    1a61:	eb 12                	jmp    1a75 <printf+0x2ba>
    1a63:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
    1a6a:	48 8d 50 08          	lea    0x8(%rax),%rdx
    1a6e:	48 89 95 28 ff ff ff 	mov    %rdx,-0xd8(%rbp)
    1a75:	48 8b 10             	mov    (%rax),%rdx
    1a78:	8b 85 1c ff ff ff    	mov    -0xe4(%rbp),%eax
    1a7e:	48 89 d6             	mov    %rdx,%rsi
    1a81:	89 c7                	mov    %eax,%edi
    1a83:	48 b8 09 16 00 00 00 	movabs $0x1609,%rax
    1a8a:	00 00 00 
    1a8d:	ff d0                	callq  *%rax
      break;
    1a8f:	e9 f9 00 00 00       	jmpq   1b8d <printf+0x3d2>
    case 's':
      if ((s = va_arg(ap, char*)) == 0)
    1a94:	8b 85 20 ff ff ff    	mov    -0xe0(%rbp),%eax
    1a9a:	83 f8 2f             	cmp    $0x2f,%eax
    1a9d:	77 23                	ja     1ac2 <printf+0x307>
    1a9f:	48 8b 85 30 ff ff ff 	mov    -0xd0(%rbp),%rax
    1aa6:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    1aac:	89 d2                	mov    %edx,%edx
    1aae:	48 01 d0             	add    %rdx,%rax
    1ab1:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    1ab7:	83 c2 08             	add    $0x8,%edx
    1aba:	89 95 20 ff ff ff    	mov    %edx,-0xe0(%rbp)
    1ac0:	eb 12                	jmp    1ad4 <printf+0x319>
    1ac2:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
    1ac9:	48 8d 50 08          	lea    0x8(%rax),%rdx
    1acd:	48 89 95 28 ff ff ff 	mov    %rdx,-0xd8(%rbp)
    1ad4:	48 8b 00             	mov    (%rax),%rax
    1ad7:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
    1ade:	48 83 bd 40 ff ff ff 	cmpq   $0x0,-0xc0(%rbp)
    1ae5:	00 
    1ae6:	75 41                	jne    1b29 <printf+0x36e>
        s = "(null)";
    1ae8:	48 b8 20 1f 00 00 00 	movabs $0x1f20,%rax
    1aef:	00 00 00 
    1af2:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
      while (*s)
    1af9:	eb 2e                	jmp    1b29 <printf+0x36e>
        putc(fd, *(s++));
    1afb:	48 8b 85 40 ff ff ff 	mov    -0xc0(%rbp),%rax
    1b02:	48 8d 50 01          	lea    0x1(%rax),%rdx
    1b06:	48 89 95 40 ff ff ff 	mov    %rdx,-0xc0(%rbp)
    1b0d:	0f b6 00             	movzbl (%rax),%eax
    1b10:	0f be d0             	movsbl %al,%edx
    1b13:	8b 85 1c ff ff ff    	mov    -0xe4(%rbp),%eax
    1b19:	89 d6                	mov    %edx,%esi
    1b1b:	89 c7                	mov    %eax,%edi
    1b1d:	48 b8 d5 15 00 00 00 	movabs $0x15d5,%rax
    1b24:	00 00 00 
    1b27:	ff d0                	callq  *%rax
      while (*s)
    1b29:	48 8b 85 40 ff ff ff 	mov    -0xc0(%rbp),%rax
    1b30:	0f b6 00             	movzbl (%rax),%eax
    1b33:	84 c0                	test   %al,%al
    1b35:	75 c4                	jne    1afb <printf+0x340>
      break;
    1b37:	eb 54                	jmp    1b8d <printf+0x3d2>
    case '%':
      putc(fd, '%');
    1b39:	8b 85 1c ff ff ff    	mov    -0xe4(%rbp),%eax
    1b3f:	be 25 00 00 00       	mov    $0x25,%esi
    1b44:	89 c7                	mov    %eax,%edi
    1b46:	48 b8 d5 15 00 00 00 	movabs $0x15d5,%rax
    1b4d:	00 00 00 
    1b50:	ff d0                	callq  *%rax
      break;
    1b52:	eb 39                	jmp    1b8d <printf+0x3d2>
    default:
      // Print unknown % sequence to draw attention.
      putc(fd, '%');
    1b54:	8b 85 1c ff ff ff    	mov    -0xe4(%rbp),%eax
    1b5a:	be 25 00 00 00       	mov    $0x25,%esi
    1b5f:	89 c7                	mov    %eax,%edi
    1b61:	48 b8 d5 15 00 00 00 	movabs $0x15d5,%rax
    1b68:	00 00 00 
    1b6b:	ff d0                	callq  *%rax
      putc(fd, c);
    1b6d:	8b 85 3c ff ff ff    	mov    -0xc4(%rbp),%eax
    1b73:	0f be d0             	movsbl %al,%edx
    1b76:	8b 85 1c ff ff ff    	mov    -0xe4(%rbp),%eax
    1b7c:	89 d6                	mov    %edx,%esi
    1b7e:	89 c7                	mov    %eax,%edi
    1b80:	48 b8 d5 15 00 00 00 	movabs $0x15d5,%rax
    1b87:	00 00 00 
    1b8a:	ff d0                	callq  *%rax
      break;
    1b8c:	90                   	nop
  for (i = 0; (c = fmt[i] & 0xff) != 0; i++) {
    1b8d:	83 85 4c ff ff ff 01 	addl   $0x1,-0xb4(%rbp)
    1b94:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
    1b9a:	48 63 d0             	movslq %eax,%rdx
    1b9d:	48 8b 85 10 ff ff ff 	mov    -0xf0(%rbp),%rax
    1ba4:	48 01 d0             	add    %rdx,%rax
    1ba7:	0f b6 00             	movzbl (%rax),%eax
    1baa:	0f be c0             	movsbl %al,%eax
    1bad:	25 ff 00 00 00       	and    $0xff,%eax
    1bb2:	89 85 3c ff ff ff    	mov    %eax,-0xc4(%rbp)
    1bb8:	83 bd 3c ff ff ff 00 	cmpl   $0x0,-0xc4(%rbp)
    1bbf:	0f 85 8e fc ff ff    	jne    1853 <printf+0x98>
    }
  }
}
    1bc5:	eb 01                	jmp    1bc8 <printf+0x40d>
      break;
    1bc7:	90                   	nop
}
    1bc8:	90                   	nop
    1bc9:	c9                   	leaveq 
    1bca:	c3                   	retq   

0000000000001bcb <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    1bcb:	f3 0f 1e fa          	endbr64 
    1bcf:	55                   	push   %rbp
    1bd0:	48 89 e5             	mov    %rsp,%rbp
    1bd3:	48 83 ec 18          	sub    $0x18,%rsp
    1bd7:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  Header *bp, *p;

  bp = (Header*)ap - 1;
    1bdb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    1bdf:	48 83 e8 10          	sub    $0x10,%rax
    1be3:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    1be7:	48 b8 90 22 00 00 00 	movabs $0x2290,%rax
    1bee:	00 00 00 
    1bf1:	48 8b 00             	mov    (%rax),%rax
    1bf4:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
    1bf8:	eb 2f                	jmp    1c29 <free+0x5e>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    1bfa:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1bfe:	48 8b 00             	mov    (%rax),%rax
    1c01:	48 39 45 f8          	cmp    %rax,-0x8(%rbp)
    1c05:	72 17                	jb     1c1e <free+0x53>
    1c07:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1c0b:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
    1c0f:	77 2f                	ja     1c40 <free+0x75>
    1c11:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1c15:	48 8b 00             	mov    (%rax),%rax
    1c18:	48 39 45 f0          	cmp    %rax,-0x10(%rbp)
    1c1c:	72 22                	jb     1c40 <free+0x75>
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    1c1e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1c22:	48 8b 00             	mov    (%rax),%rax
    1c25:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
    1c29:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1c2d:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
    1c31:	76 c7                	jbe    1bfa <free+0x2f>
    1c33:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1c37:	48 8b 00             	mov    (%rax),%rax
    1c3a:	48 39 45 f0          	cmp    %rax,-0x10(%rbp)
    1c3e:	73 ba                	jae    1bfa <free+0x2f>
      break;
  if(bp + bp->s.size == p->s.ptr){
    1c40:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1c44:	8b 40 08             	mov    0x8(%rax),%eax
    1c47:	89 c0                	mov    %eax,%eax
    1c49:	48 c1 e0 04          	shl    $0x4,%rax
    1c4d:	48 89 c2             	mov    %rax,%rdx
    1c50:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1c54:	48 01 c2             	add    %rax,%rdx
    1c57:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1c5b:	48 8b 00             	mov    (%rax),%rax
    1c5e:	48 39 c2             	cmp    %rax,%rdx
    1c61:	75 2d                	jne    1c90 <free+0xc5>
    bp->s.size += p->s.ptr->s.size;
    1c63:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1c67:	8b 50 08             	mov    0x8(%rax),%edx
    1c6a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1c6e:	48 8b 00             	mov    (%rax),%rax
    1c71:	8b 40 08             	mov    0x8(%rax),%eax
    1c74:	01 c2                	add    %eax,%edx
    1c76:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1c7a:	89 50 08             	mov    %edx,0x8(%rax)
    bp->s.ptr = p->s.ptr->s.ptr;
    1c7d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1c81:	48 8b 00             	mov    (%rax),%rax
    1c84:	48 8b 10             	mov    (%rax),%rdx
    1c87:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1c8b:	48 89 10             	mov    %rdx,(%rax)
    1c8e:	eb 0e                	jmp    1c9e <free+0xd3>
  } else
    bp->s.ptr = p->s.ptr;
    1c90:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1c94:	48 8b 10             	mov    (%rax),%rdx
    1c97:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1c9b:	48 89 10             	mov    %rdx,(%rax)
  if(p + p->s.size == bp){
    1c9e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1ca2:	8b 40 08             	mov    0x8(%rax),%eax
    1ca5:	89 c0                	mov    %eax,%eax
    1ca7:	48 c1 e0 04          	shl    $0x4,%rax
    1cab:	48 89 c2             	mov    %rax,%rdx
    1cae:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1cb2:	48 01 d0             	add    %rdx,%rax
    1cb5:	48 39 45 f0          	cmp    %rax,-0x10(%rbp)
    1cb9:	75 27                	jne    1ce2 <free+0x117>
    p->s.size += bp->s.size;
    1cbb:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1cbf:	8b 50 08             	mov    0x8(%rax),%edx
    1cc2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1cc6:	8b 40 08             	mov    0x8(%rax),%eax
    1cc9:	01 c2                	add    %eax,%edx
    1ccb:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1ccf:	89 50 08             	mov    %edx,0x8(%rax)
    p->s.ptr = bp->s.ptr;
    1cd2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1cd6:	48 8b 10             	mov    (%rax),%rdx
    1cd9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1cdd:	48 89 10             	mov    %rdx,(%rax)
    1ce0:	eb 0b                	jmp    1ced <free+0x122>
  } else
    p->s.ptr = bp;
    1ce2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1ce6:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
    1cea:	48 89 10             	mov    %rdx,(%rax)
  freep = p;
    1ced:	48 ba 90 22 00 00 00 	movabs $0x2290,%rdx
    1cf4:	00 00 00 
    1cf7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1cfb:	48 89 02             	mov    %rax,(%rdx)
}
    1cfe:	90                   	nop
    1cff:	c9                   	leaveq 
    1d00:	c3                   	retq   

0000000000001d01 <morecore>:

static Header*
morecore(uint nu)
{
    1d01:	f3 0f 1e fa          	endbr64 
    1d05:	55                   	push   %rbp
    1d06:	48 89 e5             	mov    %rsp,%rbp
    1d09:	48 83 ec 20          	sub    $0x20,%rsp
    1d0d:	89 7d ec             	mov    %edi,-0x14(%rbp)
  char *p;
  Header *hp;

  if(nu < 4096)
    1d10:	81 7d ec ff 0f 00 00 	cmpl   $0xfff,-0x14(%rbp)
    1d17:	77 07                	ja     1d20 <morecore+0x1f>
    nu = 4096;
    1d19:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%rbp)
  p = sbrk(nu * sizeof(Header));
    1d20:	8b 45 ec             	mov    -0x14(%rbp),%eax
    1d23:	48 c1 e0 04          	shl    $0x4,%rax
    1d27:	48 89 c7             	mov    %rax,%rdi
    1d2a:	48 b8 a1 15 00 00 00 	movabs $0x15a1,%rax
    1d31:	00 00 00 
    1d34:	ff d0                	callq  *%rax
    1d36:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  if(p == (char*)-1)
    1d3a:	48 83 7d f8 ff       	cmpq   $0xffffffffffffffff,-0x8(%rbp)
    1d3f:	75 07                	jne    1d48 <morecore+0x47>
    return 0;
    1d41:	b8 00 00 00 00       	mov    $0x0,%eax
    1d46:	eb 36                	jmp    1d7e <morecore+0x7d>
  hp = (Header*)p;
    1d48:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1d4c:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
  hp->s.size = nu;
    1d50:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1d54:	8b 55 ec             	mov    -0x14(%rbp),%edx
    1d57:	89 50 08             	mov    %edx,0x8(%rax)
  free((void*)(hp + 1));
    1d5a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1d5e:	48 83 c0 10          	add    $0x10,%rax
    1d62:	48 89 c7             	mov    %rax,%rdi
    1d65:	48 b8 cb 1b 00 00 00 	movabs $0x1bcb,%rax
    1d6c:	00 00 00 
    1d6f:	ff d0                	callq  *%rax
  return freep;
    1d71:	48 b8 90 22 00 00 00 	movabs $0x2290,%rax
    1d78:	00 00 00 
    1d7b:	48 8b 00             	mov    (%rax),%rax
}
    1d7e:	c9                   	leaveq 
    1d7f:	c3                   	retq   

0000000000001d80 <malloc>:

void*
malloc(uint nbytes)
{
    1d80:	f3 0f 1e fa          	endbr64 
    1d84:	55                   	push   %rbp
    1d85:	48 89 e5             	mov    %rsp,%rbp
    1d88:	48 83 ec 30          	sub    $0x30,%rsp
    1d8c:	89 7d dc             	mov    %edi,-0x24(%rbp)
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    1d8f:	8b 45 dc             	mov    -0x24(%rbp),%eax
    1d92:	48 83 c0 0f          	add    $0xf,%rax
    1d96:	48 c1 e8 04          	shr    $0x4,%rax
    1d9a:	83 c0 01             	add    $0x1,%eax
    1d9d:	89 45 ec             	mov    %eax,-0x14(%rbp)
  if((prevp = freep) == 0){
    1da0:	48 b8 90 22 00 00 00 	movabs $0x2290,%rax
    1da7:	00 00 00 
    1daa:	48 8b 00             	mov    (%rax),%rax
    1dad:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
    1db1:	48 83 7d f0 00       	cmpq   $0x0,-0x10(%rbp)
    1db6:	75 4a                	jne    1e02 <malloc+0x82>
    base.s.ptr = freep = prevp = &base;
    1db8:	48 b8 80 22 00 00 00 	movabs $0x2280,%rax
    1dbf:	00 00 00 
    1dc2:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
    1dc6:	48 ba 90 22 00 00 00 	movabs $0x2290,%rdx
    1dcd:	00 00 00 
    1dd0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1dd4:	48 89 02             	mov    %rax,(%rdx)
    1dd7:	48 b8 90 22 00 00 00 	movabs $0x2290,%rax
    1dde:	00 00 00 
    1de1:	48 8b 00             	mov    (%rax),%rax
    1de4:	48 ba 80 22 00 00 00 	movabs $0x2280,%rdx
    1deb:	00 00 00 
    1dee:	48 89 02             	mov    %rax,(%rdx)
    base.s.size = 0;
    1df1:	48 b8 80 22 00 00 00 	movabs $0x2280,%rax
    1df8:	00 00 00 
    1dfb:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%rax)
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    1e02:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1e06:	48 8b 00             	mov    (%rax),%rax
    1e09:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
    if(p->s.size >= nunits){
    1e0d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1e11:	8b 40 08             	mov    0x8(%rax),%eax
    1e14:	39 45 ec             	cmp    %eax,-0x14(%rbp)
    1e17:	77 65                	ja     1e7e <malloc+0xfe>
      if(p->s.size == nunits)
    1e19:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1e1d:	8b 40 08             	mov    0x8(%rax),%eax
    1e20:	39 45 ec             	cmp    %eax,-0x14(%rbp)
    1e23:	75 10                	jne    1e35 <malloc+0xb5>
        prevp->s.ptr = p->s.ptr;
    1e25:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1e29:	48 8b 10             	mov    (%rax),%rdx
    1e2c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1e30:	48 89 10             	mov    %rdx,(%rax)
    1e33:	eb 2e                	jmp    1e63 <malloc+0xe3>
      else {
        p->s.size -= nunits;
    1e35:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1e39:	8b 40 08             	mov    0x8(%rax),%eax
    1e3c:	2b 45 ec             	sub    -0x14(%rbp),%eax
    1e3f:	89 c2                	mov    %eax,%edx
    1e41:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1e45:	89 50 08             	mov    %edx,0x8(%rax)
        p += p->s.size;
    1e48:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1e4c:	8b 40 08             	mov    0x8(%rax),%eax
    1e4f:	89 c0                	mov    %eax,%eax
    1e51:	48 c1 e0 04          	shl    $0x4,%rax
    1e55:	48 01 45 f8          	add    %rax,-0x8(%rbp)
        p->s.size = nunits;
    1e59:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1e5d:	8b 55 ec             	mov    -0x14(%rbp),%edx
    1e60:	89 50 08             	mov    %edx,0x8(%rax)
      }
      freep = prevp;
    1e63:	48 ba 90 22 00 00 00 	movabs $0x2290,%rdx
    1e6a:	00 00 00 
    1e6d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1e71:	48 89 02             	mov    %rax,(%rdx)
      return (void*)(p + 1);
    1e74:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1e78:	48 83 c0 10          	add    $0x10,%rax
    1e7c:	eb 4e                	jmp    1ecc <malloc+0x14c>
    }
    if(p == freep)
    1e7e:	48 b8 90 22 00 00 00 	movabs $0x2290,%rax
    1e85:	00 00 00 
    1e88:	48 8b 00             	mov    (%rax),%rax
    1e8b:	48 39 45 f8          	cmp    %rax,-0x8(%rbp)
    1e8f:	75 23                	jne    1eb4 <malloc+0x134>
      if((p = morecore(nunits)) == 0)
    1e91:	8b 45 ec             	mov    -0x14(%rbp),%eax
    1e94:	89 c7                	mov    %eax,%edi
    1e96:	48 b8 01 1d 00 00 00 	movabs $0x1d01,%rax
    1e9d:	00 00 00 
    1ea0:	ff d0                	callq  *%rax
    1ea2:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
    1ea6:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
    1eab:	75 07                	jne    1eb4 <malloc+0x134>
        return 0;
    1ead:	b8 00 00 00 00       	mov    $0x0,%eax
    1eb2:	eb 18                	jmp    1ecc <malloc+0x14c>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    1eb4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1eb8:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
    1ebc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1ec0:	48 8b 00             	mov    (%rax),%rax
    1ec3:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
    if(p->s.size >= nunits){
    1ec7:	e9 41 ff ff ff       	jmpq   1e0d <malloc+0x8d>
  }
}
    1ecc:	c9                   	leaveq 
    1ecd:	c3                   	retq   
