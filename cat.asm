
_cat:     file format elf64-x86-64


Disassembly of section .text:

0000000000001000 <cat>:

char buf[512];

void
cat(int fd)
{
    1000:	f3 0f 1e fa          	endbr64 
    1004:	55                   	push   %rbp
    1005:	48 89 e5             	mov    %rsp,%rbp
    1008:	48 83 ec 20          	sub    $0x20,%rsp
    100c:	89 7d ec             	mov    %edi,-0x14(%rbp)
  int n;

  while((n = read(fd, buf, sizeof(buf))) > 0) {
    100f:	eb 51                	jmp    1062 <cat+0x62>
    if (write(1, buf, n) != n) {
    1011:	8b 45 fc             	mov    -0x4(%rbp),%eax
    1014:	89 c2                	mov    %eax,%edx
    1016:	48 be c0 22 00 00 00 	movabs $0x22c0,%rsi
    101d:	00 00 00 
    1020:	bf 01 00 00 00       	mov    $0x1,%edi
    1025:	48 b8 31 15 00 00 00 	movabs $0x1531,%rax
    102c:	00 00 00 
    102f:	ff d0                	callq  *%rax
    1031:	39 45 fc             	cmp    %eax,-0x4(%rbp)
    1034:	74 2c                	je     1062 <cat+0x62>
      printf(1, "cat: write error\n");
    1036:	48 be 08 1f 00 00 00 	movabs $0x1f08,%rsi
    103d:	00 00 00 
    1040:	bf 01 00 00 00       	mov    $0x1,%edi
    1045:	b8 00 00 00 00       	mov    $0x0,%eax
    104a:	48 ba f4 17 00 00 00 	movabs $0x17f4,%rdx
    1051:	00 00 00 
    1054:	ff d2                	callq  *%rdx
      exit();
    1056:	48 b8 fd 14 00 00 00 	movabs $0x14fd,%rax
    105d:	00 00 00 
    1060:	ff d0                	callq  *%rax
  while((n = read(fd, buf, sizeof(buf))) > 0) {
    1062:	8b 45 ec             	mov    -0x14(%rbp),%eax
    1065:	ba 00 02 00 00       	mov    $0x200,%edx
    106a:	48 be c0 22 00 00 00 	movabs $0x22c0,%rsi
    1071:	00 00 00 
    1074:	89 c7                	mov    %eax,%edi
    1076:	48 b8 24 15 00 00 00 	movabs $0x1524,%rax
    107d:	00 00 00 
    1080:	ff d0                	callq  *%rax
    1082:	89 45 fc             	mov    %eax,-0x4(%rbp)
    1085:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
    1089:	7f 86                	jg     1011 <cat+0x11>
    }
  }
  if(n < 0){
    108b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
    108f:	79 2c                	jns    10bd <cat+0xbd>
    printf(1, "cat: read error\n");
    1091:	48 be 1a 1f 00 00 00 	movabs $0x1f1a,%rsi
    1098:	00 00 00 
    109b:	bf 01 00 00 00       	mov    $0x1,%edi
    10a0:	b8 00 00 00 00       	mov    $0x0,%eax
    10a5:	48 ba f4 17 00 00 00 	movabs $0x17f4,%rdx
    10ac:	00 00 00 
    10af:	ff d2                	callq  *%rdx
    exit();
    10b1:	48 b8 fd 14 00 00 00 	movabs $0x14fd,%rax
    10b8:	00 00 00 
    10bb:	ff d0                	callq  *%rax
  }
}
    10bd:	90                   	nop
    10be:	c9                   	leaveq 
    10bf:	c3                   	retq   

00000000000010c0 <main>:

int
main(int argc, char *argv[])
{
    10c0:	f3 0f 1e fa          	endbr64 
    10c4:	55                   	push   %rbp
    10c5:	48 89 e5             	mov    %rsp,%rbp
    10c8:	48 83 ec 20          	sub    $0x20,%rsp
    10cc:	89 7d ec             	mov    %edi,-0x14(%rbp)
    10cf:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  int fd, i;

  if(argc <= 1){
    10d3:	83 7d ec 01          	cmpl   $0x1,-0x14(%rbp)
    10d7:	7f 1d                	jg     10f6 <main+0x36>
    cat(0);
    10d9:	bf 00 00 00 00       	mov    $0x0,%edi
    10de:	48 b8 00 10 00 00 00 	movabs $0x1000,%rax
    10e5:	00 00 00 
    10e8:	ff d0                	callq  *%rax
    exit();
    10ea:	48 b8 fd 14 00 00 00 	movabs $0x14fd,%rax
    10f1:	00 00 00 
    10f4:	ff d0                	callq  *%rax
  }

  for(i = 1; i < argc; i++){
    10f6:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)
    10fd:	e9 a0 00 00 00       	jmpq   11a2 <main+0xe2>
    if((fd = open(argv[i], 0)) < 0){
    1102:	8b 45 fc             	mov    -0x4(%rbp),%eax
    1105:	48 98                	cltq   
    1107:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
    110e:	00 
    110f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
    1113:	48 01 d0             	add    %rdx,%rax
    1116:	48 8b 00             	mov    (%rax),%rax
    1119:	be 00 00 00 00       	mov    $0x0,%esi
    111e:	48 89 c7             	mov    %rax,%rdi
    1121:	48 b8 65 15 00 00 00 	movabs $0x1565,%rax
    1128:	00 00 00 
    112b:	ff d0                	callq  *%rax
    112d:	89 45 f8             	mov    %eax,-0x8(%rbp)
    1130:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
    1134:	79 46                	jns    117c <main+0xbc>
      printf(1, "cat: cannot open %s\n", argv[i]);
    1136:	8b 45 fc             	mov    -0x4(%rbp),%eax
    1139:	48 98                	cltq   
    113b:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
    1142:	00 
    1143:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
    1147:	48 01 d0             	add    %rdx,%rax
    114a:	48 8b 00             	mov    (%rax),%rax
    114d:	48 89 c2             	mov    %rax,%rdx
    1150:	48 be 2b 1f 00 00 00 	movabs $0x1f2b,%rsi
    1157:	00 00 00 
    115a:	bf 01 00 00 00       	mov    $0x1,%edi
    115f:	b8 00 00 00 00       	mov    $0x0,%eax
    1164:	48 b9 f4 17 00 00 00 	movabs $0x17f4,%rcx
    116b:	00 00 00 
    116e:	ff d1                	callq  *%rcx
      exit();
    1170:	48 b8 fd 14 00 00 00 	movabs $0x14fd,%rax
    1177:	00 00 00 
    117a:	ff d0                	callq  *%rax
    }
    cat(fd);
    117c:	8b 45 f8             	mov    -0x8(%rbp),%eax
    117f:	89 c7                	mov    %eax,%edi
    1181:	48 b8 00 10 00 00 00 	movabs $0x1000,%rax
    1188:	00 00 00 
    118b:	ff d0                	callq  *%rax
    close(fd);
    118d:	8b 45 f8             	mov    -0x8(%rbp),%eax
    1190:	89 c7                	mov    %eax,%edi
    1192:	48 b8 3e 15 00 00 00 	movabs $0x153e,%rax
    1199:	00 00 00 
    119c:	ff d0                	callq  *%rax
  for(i = 1; i < argc; i++){
    119e:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
    11a2:	8b 45 fc             	mov    -0x4(%rbp),%eax
    11a5:	3b 45 ec             	cmp    -0x14(%rbp),%eax
    11a8:	0f 8c 54 ff ff ff    	jl     1102 <main+0x42>
  }
  exit();
    11ae:	48 b8 fd 14 00 00 00 	movabs $0x14fd,%rax
    11b5:	00 00 00 
    11b8:	ff d0                	callq  *%rax

00000000000011ba <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
    11ba:	f3 0f 1e fa          	endbr64 
    11be:	55                   	push   %rbp
    11bf:	48 89 e5             	mov    %rsp,%rbp
    11c2:	48 83 ec 10          	sub    $0x10,%rsp
    11c6:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
    11ca:	89 75 f4             	mov    %esi,-0xc(%rbp)
    11cd:	89 55 f0             	mov    %edx,-0x10(%rbp)
  asm volatile("cld; rep stosb" :
    11d0:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
    11d4:	8b 55 f0             	mov    -0x10(%rbp),%edx
    11d7:	8b 45 f4             	mov    -0xc(%rbp),%eax
    11da:	48 89 ce             	mov    %rcx,%rsi
    11dd:	48 89 f7             	mov    %rsi,%rdi
    11e0:	89 d1                	mov    %edx,%ecx
    11e2:	fc                   	cld    
    11e3:	f3 aa                	rep stos %al,%es:(%rdi)
    11e5:	89 ca                	mov    %ecx,%edx
    11e7:	48 89 fe             	mov    %rdi,%rsi
    11ea:	48 89 75 f8          	mov    %rsi,-0x8(%rbp)
    11ee:	89 55 f0             	mov    %edx,-0x10(%rbp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
    11f1:	90                   	nop
    11f2:	c9                   	leaveq 
    11f3:	c3                   	retq   

00000000000011f4 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
    11f4:	f3 0f 1e fa          	endbr64 
    11f8:	55                   	push   %rbp
    11f9:	48 89 e5             	mov    %rsp,%rbp
    11fc:	48 83 ec 20          	sub    $0x20,%rsp
    1200:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
    1204:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  char *os;

  os = s;
    1208:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    120c:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  while((*s++ = *t++) != 0)
    1210:	90                   	nop
    1211:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
    1215:	48 8d 42 01          	lea    0x1(%rdx),%rax
    1219:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
    121d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    1221:	48 8d 48 01          	lea    0x1(%rax),%rcx
    1225:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
    1229:	0f b6 12             	movzbl (%rdx),%edx
    122c:	88 10                	mov    %dl,(%rax)
    122e:	0f b6 00             	movzbl (%rax),%eax
    1231:	84 c0                	test   %al,%al
    1233:	75 dc                	jne    1211 <strcpy+0x1d>
    ;
  return os;
    1235:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
    1239:	c9                   	leaveq 
    123a:	c3                   	retq   

000000000000123b <strcmp>:

int
strcmp(const char *p, const char *q)
{
    123b:	f3 0f 1e fa          	endbr64 
    123f:	55                   	push   %rbp
    1240:	48 89 e5             	mov    %rsp,%rbp
    1243:	48 83 ec 10          	sub    $0x10,%rsp
    1247:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
    124b:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  while(*p && *p == *q)
    124f:	eb 0a                	jmp    125b <strcmp+0x20>
    p++, q++;
    1251:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
    1256:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
  while(*p && *p == *q)
    125b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    125f:	0f b6 00             	movzbl (%rax),%eax
    1262:	84 c0                	test   %al,%al
    1264:	74 12                	je     1278 <strcmp+0x3d>
    1266:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    126a:	0f b6 10             	movzbl (%rax),%edx
    126d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1271:	0f b6 00             	movzbl (%rax),%eax
    1274:	38 c2                	cmp    %al,%dl
    1276:	74 d9                	je     1251 <strcmp+0x16>
  return (uchar)*p - (uchar)*q;
    1278:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    127c:	0f b6 00             	movzbl (%rax),%eax
    127f:	0f b6 d0             	movzbl %al,%edx
    1282:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1286:	0f b6 00             	movzbl (%rax),%eax
    1289:	0f b6 c0             	movzbl %al,%eax
    128c:	29 c2                	sub    %eax,%edx
    128e:	89 d0                	mov    %edx,%eax
}
    1290:	c9                   	leaveq 
    1291:	c3                   	retq   

0000000000001292 <strlen>:

uint
strlen(char *s)
{
    1292:	f3 0f 1e fa          	endbr64 
    1296:	55                   	push   %rbp
    1297:	48 89 e5             	mov    %rsp,%rbp
    129a:	48 83 ec 18          	sub    $0x18,%rsp
    129e:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  int n;

  for(n = 0; s[n]; n++)
    12a2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
    12a9:	eb 04                	jmp    12af <strlen+0x1d>
    12ab:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
    12af:	8b 45 fc             	mov    -0x4(%rbp),%eax
    12b2:	48 63 d0             	movslq %eax,%rdx
    12b5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    12b9:	48 01 d0             	add    %rdx,%rax
    12bc:	0f b6 00             	movzbl (%rax),%eax
    12bf:	84 c0                	test   %al,%al
    12c1:	75 e8                	jne    12ab <strlen+0x19>
    ;
  return n;
    12c3:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
    12c6:	c9                   	leaveq 
    12c7:	c3                   	retq   

00000000000012c8 <memset>:

void*
memset(void *dst, int c, uint n)
{
    12c8:	f3 0f 1e fa          	endbr64 
    12cc:	55                   	push   %rbp
    12cd:	48 89 e5             	mov    %rsp,%rbp
    12d0:	48 83 ec 10          	sub    $0x10,%rsp
    12d4:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
    12d8:	89 75 f4             	mov    %esi,-0xc(%rbp)
    12db:	89 55 f0             	mov    %edx,-0x10(%rbp)
  stosb(dst, c, n);
    12de:	8b 55 f0             	mov    -0x10(%rbp),%edx
    12e1:	8b 4d f4             	mov    -0xc(%rbp),%ecx
    12e4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    12e8:	89 ce                	mov    %ecx,%esi
    12ea:	48 89 c7             	mov    %rax,%rdi
    12ed:	48 b8 ba 11 00 00 00 	movabs $0x11ba,%rax
    12f4:	00 00 00 
    12f7:	ff d0                	callq  *%rax
  return dst;
    12f9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
    12fd:	c9                   	leaveq 
    12fe:	c3                   	retq   

00000000000012ff <strchr>:

char*
strchr(const char *s, char c)
{
    12ff:	f3 0f 1e fa          	endbr64 
    1303:	55                   	push   %rbp
    1304:	48 89 e5             	mov    %rsp,%rbp
    1307:	48 83 ec 10          	sub    $0x10,%rsp
    130b:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
    130f:	89 f0                	mov    %esi,%eax
    1311:	88 45 f4             	mov    %al,-0xc(%rbp)
  for(; *s; s++)
    1314:	eb 17                	jmp    132d <strchr+0x2e>
    if(*s == c)
    1316:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    131a:	0f b6 00             	movzbl (%rax),%eax
    131d:	38 45 f4             	cmp    %al,-0xc(%rbp)
    1320:	75 06                	jne    1328 <strchr+0x29>
      return (char*)s;
    1322:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1326:	eb 15                	jmp    133d <strchr+0x3e>
  for(; *s; s++)
    1328:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
    132d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1331:	0f b6 00             	movzbl (%rax),%eax
    1334:	84 c0                	test   %al,%al
    1336:	75 de                	jne    1316 <strchr+0x17>
  return 0;
    1338:	b8 00 00 00 00       	mov    $0x0,%eax
}
    133d:	c9                   	leaveq 
    133e:	c3                   	retq   

000000000000133f <gets>:

char*
gets(char *buf, int max)
{
    133f:	f3 0f 1e fa          	endbr64 
    1343:	55                   	push   %rbp
    1344:	48 89 e5             	mov    %rsp,%rbp
    1347:	48 83 ec 20          	sub    $0x20,%rsp
    134b:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
    134f:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    1352:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
    1359:	eb 4f                	jmp    13aa <gets+0x6b>
    cc = read(0, &c, 1);
    135b:	48 8d 45 f7          	lea    -0x9(%rbp),%rax
    135f:	ba 01 00 00 00       	mov    $0x1,%edx
    1364:	48 89 c6             	mov    %rax,%rsi
    1367:	bf 00 00 00 00       	mov    $0x0,%edi
    136c:	48 b8 24 15 00 00 00 	movabs $0x1524,%rax
    1373:	00 00 00 
    1376:	ff d0                	callq  *%rax
    1378:	89 45 f8             	mov    %eax,-0x8(%rbp)
    if(cc < 1)
    137b:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
    137f:	7e 36                	jle    13b7 <gets+0x78>
      break;
    buf[i++] = c;
    1381:	8b 45 fc             	mov    -0x4(%rbp),%eax
    1384:	8d 50 01             	lea    0x1(%rax),%edx
    1387:	89 55 fc             	mov    %edx,-0x4(%rbp)
    138a:	48 63 d0             	movslq %eax,%rdx
    138d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    1391:	48 01 c2             	add    %rax,%rdx
    1394:	0f b6 45 f7          	movzbl -0x9(%rbp),%eax
    1398:	88 02                	mov    %al,(%rdx)
    if(c == '\n' || c == '\r')
    139a:	0f b6 45 f7          	movzbl -0x9(%rbp),%eax
    139e:	3c 0a                	cmp    $0xa,%al
    13a0:	74 16                	je     13b8 <gets+0x79>
    13a2:	0f b6 45 f7          	movzbl -0x9(%rbp),%eax
    13a6:	3c 0d                	cmp    $0xd,%al
    13a8:	74 0e                	je     13b8 <gets+0x79>
  for(i=0; i+1 < max; ){
    13aa:	8b 45 fc             	mov    -0x4(%rbp),%eax
    13ad:	83 c0 01             	add    $0x1,%eax
    13b0:	39 45 e4             	cmp    %eax,-0x1c(%rbp)
    13b3:	7f a6                	jg     135b <gets+0x1c>
    13b5:	eb 01                	jmp    13b8 <gets+0x79>
      break;
    13b7:	90                   	nop
      break;
  }
  buf[i] = '\0';
    13b8:	8b 45 fc             	mov    -0x4(%rbp),%eax
    13bb:	48 63 d0             	movslq %eax,%rdx
    13be:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    13c2:	48 01 d0             	add    %rdx,%rax
    13c5:	c6 00 00             	movb   $0x0,(%rax)
  return buf;
    13c8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
    13cc:	c9                   	leaveq 
    13cd:	c3                   	retq   

00000000000013ce <stat>:

int
stat(char *n, struct stat *st)
{
    13ce:	f3 0f 1e fa          	endbr64 
    13d2:	55                   	push   %rbp
    13d3:	48 89 e5             	mov    %rsp,%rbp
    13d6:	48 83 ec 20          	sub    $0x20,%rsp
    13da:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
    13de:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  int fd;
  int r;

  fd = open(n, O_RDONLY);
    13e2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    13e6:	be 00 00 00 00       	mov    $0x0,%esi
    13eb:	48 89 c7             	mov    %rax,%rdi
    13ee:	48 b8 65 15 00 00 00 	movabs $0x1565,%rax
    13f5:	00 00 00 
    13f8:	ff d0                	callq  *%rax
    13fa:	89 45 fc             	mov    %eax,-0x4(%rbp)
  if(fd < 0)
    13fd:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
    1401:	79 07                	jns    140a <stat+0x3c>
    return -1;
    1403:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    1408:	eb 2f                	jmp    1439 <stat+0x6b>
  r = fstat(fd, st);
    140a:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
    140e:	8b 45 fc             	mov    -0x4(%rbp),%eax
    1411:	48 89 d6             	mov    %rdx,%rsi
    1414:	89 c7                	mov    %eax,%edi
    1416:	48 b8 8c 15 00 00 00 	movabs $0x158c,%rax
    141d:	00 00 00 
    1420:	ff d0                	callq  *%rax
    1422:	89 45 f8             	mov    %eax,-0x8(%rbp)
  close(fd);
    1425:	8b 45 fc             	mov    -0x4(%rbp),%eax
    1428:	89 c7                	mov    %eax,%edi
    142a:	48 b8 3e 15 00 00 00 	movabs $0x153e,%rax
    1431:	00 00 00 
    1434:	ff d0                	callq  *%rax
  return r;
    1436:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
    1439:	c9                   	leaveq 
    143a:	c3                   	retq   

000000000000143b <atoi>:

int
atoi(const char *s)
{
    143b:	f3 0f 1e fa          	endbr64 
    143f:	55                   	push   %rbp
    1440:	48 89 e5             	mov    %rsp,%rbp
    1443:	48 83 ec 18          	sub    $0x18,%rsp
    1447:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  int n;

  n = 0;
    144b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  while('0' <= *s && *s <= '9')
    1452:	eb 28                	jmp    147c <atoi+0x41>
    n = n*10 + *s++ - '0';
    1454:	8b 55 fc             	mov    -0x4(%rbp),%edx
    1457:	89 d0                	mov    %edx,%eax
    1459:	c1 e0 02             	shl    $0x2,%eax
    145c:	01 d0                	add    %edx,%eax
    145e:	01 c0                	add    %eax,%eax
    1460:	89 c1                	mov    %eax,%ecx
    1462:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    1466:	48 8d 50 01          	lea    0x1(%rax),%rdx
    146a:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
    146e:	0f b6 00             	movzbl (%rax),%eax
    1471:	0f be c0             	movsbl %al,%eax
    1474:	01 c8                	add    %ecx,%eax
    1476:	83 e8 30             	sub    $0x30,%eax
    1479:	89 45 fc             	mov    %eax,-0x4(%rbp)
  while('0' <= *s && *s <= '9')
    147c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    1480:	0f b6 00             	movzbl (%rax),%eax
    1483:	3c 2f                	cmp    $0x2f,%al
    1485:	7e 0b                	jle    1492 <atoi+0x57>
    1487:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    148b:	0f b6 00             	movzbl (%rax),%eax
    148e:	3c 39                	cmp    $0x39,%al
    1490:	7e c2                	jle    1454 <atoi+0x19>
  return n;
    1492:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
    1495:	c9                   	leaveq 
    1496:	c3                   	retq   

0000000000001497 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
    1497:	f3 0f 1e fa          	endbr64 
    149b:	55                   	push   %rbp
    149c:	48 89 e5             	mov    %rsp,%rbp
    149f:	48 83 ec 28          	sub    $0x28,%rsp
    14a3:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
    14a7:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
    14ab:	89 55 dc             	mov    %edx,-0x24(%rbp)
  char *dst, *src;

  dst = vdst;
    14ae:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    14b2:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  src = vsrc;
    14b6:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
    14ba:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
  while(n-- > 0)
    14be:	eb 1d                	jmp    14dd <memmove+0x46>
    *dst++ = *src++;
    14c0:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
    14c4:	48 8d 42 01          	lea    0x1(%rdx),%rax
    14c8:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
    14cc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    14d0:	48 8d 48 01          	lea    0x1(%rax),%rcx
    14d4:	48 89 4d f8          	mov    %rcx,-0x8(%rbp)
    14d8:	0f b6 12             	movzbl (%rdx),%edx
    14db:	88 10                	mov    %dl,(%rax)
  while(n-- > 0)
    14dd:	8b 45 dc             	mov    -0x24(%rbp),%eax
    14e0:	8d 50 ff             	lea    -0x1(%rax),%edx
    14e3:	89 55 dc             	mov    %edx,-0x24(%rbp)
    14e6:	85 c0                	test   %eax,%eax
    14e8:	7f d6                	jg     14c0 <memmove+0x29>
  return vdst;
    14ea:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
    14ee:	c9                   	leaveq 
    14ef:	c3                   	retq   

00000000000014f0 <fork>:
    mov $SYS_ ## name, %rax; \
    mov %rcx, %r10 ;\
    syscall		  ;\
    ret

SYSCALL(fork)
    14f0:	48 c7 c0 01 00 00 00 	mov    $0x1,%rax
    14f7:	49 89 ca             	mov    %rcx,%r10
    14fa:	0f 05                	syscall 
    14fc:	c3                   	retq   

00000000000014fd <exit>:
SYSCALL(exit)
    14fd:	48 c7 c0 02 00 00 00 	mov    $0x2,%rax
    1504:	49 89 ca             	mov    %rcx,%r10
    1507:	0f 05                	syscall 
    1509:	c3                   	retq   

000000000000150a <wait>:
SYSCALL(wait)
    150a:	48 c7 c0 03 00 00 00 	mov    $0x3,%rax
    1511:	49 89 ca             	mov    %rcx,%r10
    1514:	0f 05                	syscall 
    1516:	c3                   	retq   

0000000000001517 <pipe>:
SYSCALL(pipe)
    1517:	48 c7 c0 04 00 00 00 	mov    $0x4,%rax
    151e:	49 89 ca             	mov    %rcx,%r10
    1521:	0f 05                	syscall 
    1523:	c3                   	retq   

0000000000001524 <read>:
SYSCALL(read)
    1524:	48 c7 c0 05 00 00 00 	mov    $0x5,%rax
    152b:	49 89 ca             	mov    %rcx,%r10
    152e:	0f 05                	syscall 
    1530:	c3                   	retq   

0000000000001531 <write>:
SYSCALL(write)
    1531:	48 c7 c0 10 00 00 00 	mov    $0x10,%rax
    1538:	49 89 ca             	mov    %rcx,%r10
    153b:	0f 05                	syscall 
    153d:	c3                   	retq   

000000000000153e <close>:
SYSCALL(close)
    153e:	48 c7 c0 15 00 00 00 	mov    $0x15,%rax
    1545:	49 89 ca             	mov    %rcx,%r10
    1548:	0f 05                	syscall 
    154a:	c3                   	retq   

000000000000154b <kill>:
SYSCALL(kill)
    154b:	48 c7 c0 06 00 00 00 	mov    $0x6,%rax
    1552:	49 89 ca             	mov    %rcx,%r10
    1555:	0f 05                	syscall 
    1557:	c3                   	retq   

0000000000001558 <exec>:
SYSCALL(exec)
    1558:	48 c7 c0 07 00 00 00 	mov    $0x7,%rax
    155f:	49 89 ca             	mov    %rcx,%r10
    1562:	0f 05                	syscall 
    1564:	c3                   	retq   

0000000000001565 <open>:
SYSCALL(open)
    1565:	48 c7 c0 0f 00 00 00 	mov    $0xf,%rax
    156c:	49 89 ca             	mov    %rcx,%r10
    156f:	0f 05                	syscall 
    1571:	c3                   	retq   

0000000000001572 <mknod>:
SYSCALL(mknod)
    1572:	48 c7 c0 11 00 00 00 	mov    $0x11,%rax
    1579:	49 89 ca             	mov    %rcx,%r10
    157c:	0f 05                	syscall 
    157e:	c3                   	retq   

000000000000157f <unlink>:
SYSCALL(unlink)
    157f:	48 c7 c0 12 00 00 00 	mov    $0x12,%rax
    1586:	49 89 ca             	mov    %rcx,%r10
    1589:	0f 05                	syscall 
    158b:	c3                   	retq   

000000000000158c <fstat>:
SYSCALL(fstat)
    158c:	48 c7 c0 08 00 00 00 	mov    $0x8,%rax
    1593:	49 89 ca             	mov    %rcx,%r10
    1596:	0f 05                	syscall 
    1598:	c3                   	retq   

0000000000001599 <link>:
SYSCALL(link)
    1599:	48 c7 c0 13 00 00 00 	mov    $0x13,%rax
    15a0:	49 89 ca             	mov    %rcx,%r10
    15a3:	0f 05                	syscall 
    15a5:	c3                   	retq   

00000000000015a6 <mkdir>:
SYSCALL(mkdir)
    15a6:	48 c7 c0 14 00 00 00 	mov    $0x14,%rax
    15ad:	49 89 ca             	mov    %rcx,%r10
    15b0:	0f 05                	syscall 
    15b2:	c3                   	retq   

00000000000015b3 <chdir>:
SYSCALL(chdir)
    15b3:	48 c7 c0 09 00 00 00 	mov    $0x9,%rax
    15ba:	49 89 ca             	mov    %rcx,%r10
    15bd:	0f 05                	syscall 
    15bf:	c3                   	retq   

00000000000015c0 <dup>:
SYSCALL(dup)
    15c0:	48 c7 c0 0a 00 00 00 	mov    $0xa,%rax
    15c7:	49 89 ca             	mov    %rcx,%r10
    15ca:	0f 05                	syscall 
    15cc:	c3                   	retq   

00000000000015cd <getpid>:
SYSCALL(getpid)
    15cd:	48 c7 c0 0b 00 00 00 	mov    $0xb,%rax
    15d4:	49 89 ca             	mov    %rcx,%r10
    15d7:	0f 05                	syscall 
    15d9:	c3                   	retq   

00000000000015da <sbrk>:
SYSCALL(sbrk)
    15da:	48 c7 c0 0c 00 00 00 	mov    $0xc,%rax
    15e1:	49 89 ca             	mov    %rcx,%r10
    15e4:	0f 05                	syscall 
    15e6:	c3                   	retq   

00000000000015e7 <sleep>:
SYSCALL(sleep)
    15e7:	48 c7 c0 0d 00 00 00 	mov    $0xd,%rax
    15ee:	49 89 ca             	mov    %rcx,%r10
    15f1:	0f 05                	syscall 
    15f3:	c3                   	retq   

00000000000015f4 <uptime>:
SYSCALL(uptime)
    15f4:	48 c7 c0 0e 00 00 00 	mov    $0xe,%rax
    15fb:	49 89 ca             	mov    %rcx,%r10
    15fe:	0f 05                	syscall 
    1600:	c3                   	retq   

0000000000001601 <aread>:
SYSCALL(aread)
    1601:	48 c7 c0 16 00 00 00 	mov    $0x16,%rax
    1608:	49 89 ca             	mov    %rcx,%r10
    160b:	0f 05                	syscall 
    160d:	c3                   	retq   

000000000000160e <putc>:

#include <stdarg.h>

static void
putc(int fd, char c)
{
    160e:	f3 0f 1e fa          	endbr64 
    1612:	55                   	push   %rbp
    1613:	48 89 e5             	mov    %rsp,%rbp
    1616:	48 83 ec 10          	sub    $0x10,%rsp
    161a:	89 7d fc             	mov    %edi,-0x4(%rbp)
    161d:	89 f0                	mov    %esi,%eax
    161f:	88 45 f8             	mov    %al,-0x8(%rbp)
  write(fd, &c, 1);
    1622:	48 8d 4d f8          	lea    -0x8(%rbp),%rcx
    1626:	8b 45 fc             	mov    -0x4(%rbp),%eax
    1629:	ba 01 00 00 00       	mov    $0x1,%edx
    162e:	48 89 ce             	mov    %rcx,%rsi
    1631:	89 c7                	mov    %eax,%edi
    1633:	48 b8 31 15 00 00 00 	movabs $0x1531,%rax
    163a:	00 00 00 
    163d:	ff d0                	callq  *%rax
}
    163f:	90                   	nop
    1640:	c9                   	leaveq 
    1641:	c3                   	retq   

0000000000001642 <print_x64>:

static char digits[] = "0123456789abcdef";

  static void
print_x64(int fd, addr_t x)
{
    1642:	f3 0f 1e fa          	endbr64 
    1646:	55                   	push   %rbp
    1647:	48 89 e5             	mov    %rsp,%rbp
    164a:	48 83 ec 20          	sub    $0x20,%rsp
    164e:	89 7d ec             	mov    %edi,-0x14(%rbp)
    1651:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  int i;
  for (i = 0; i < (sizeof(addr_t) * 2); i++, x <<= 4)
    1655:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
    165c:	eb 35                	jmp    1693 <print_x64+0x51>
    putc(fd, digits[x >> (sizeof(addr_t) * 8 - 4)]);
    165e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
    1662:	48 c1 e8 3c          	shr    $0x3c,%rax
    1666:	48 ba 90 22 00 00 00 	movabs $0x2290,%rdx
    166d:	00 00 00 
    1670:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax
    1674:	0f be d0             	movsbl %al,%edx
    1677:	8b 45 ec             	mov    -0x14(%rbp),%eax
    167a:	89 d6                	mov    %edx,%esi
    167c:	89 c7                	mov    %eax,%edi
    167e:	48 b8 0e 16 00 00 00 	movabs $0x160e,%rax
    1685:	00 00 00 
    1688:	ff d0                	callq  *%rax
  for (i = 0; i < (sizeof(addr_t) * 2); i++, x <<= 4)
    168a:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
    168e:	48 c1 65 e0 04       	shlq   $0x4,-0x20(%rbp)
    1693:	8b 45 fc             	mov    -0x4(%rbp),%eax
    1696:	83 f8 0f             	cmp    $0xf,%eax
    1699:	76 c3                	jbe    165e <print_x64+0x1c>
}
    169b:	90                   	nop
    169c:	90                   	nop
    169d:	c9                   	leaveq 
    169e:	c3                   	retq   

000000000000169f <print_x32>:

  static void
print_x32(int fd, uint x)
{
    169f:	f3 0f 1e fa          	endbr64 
    16a3:	55                   	push   %rbp
    16a4:	48 89 e5             	mov    %rsp,%rbp
    16a7:	48 83 ec 20          	sub    $0x20,%rsp
    16ab:	89 7d ec             	mov    %edi,-0x14(%rbp)
    16ae:	89 75 e8             	mov    %esi,-0x18(%rbp)
  int i;
  for (i = 0; i < (sizeof(uint) * 2); i++, x <<= 4)
    16b1:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
    16b8:	eb 36                	jmp    16f0 <print_x32+0x51>
    putc(fd, digits[x >> (sizeof(uint) * 8 - 4)]);
    16ba:	8b 45 e8             	mov    -0x18(%rbp),%eax
    16bd:	c1 e8 1c             	shr    $0x1c,%eax
    16c0:	89 c2                	mov    %eax,%edx
    16c2:	48 b8 90 22 00 00 00 	movabs $0x2290,%rax
    16c9:	00 00 00 
    16cc:	89 d2                	mov    %edx,%edx
    16ce:	0f b6 04 10          	movzbl (%rax,%rdx,1),%eax
    16d2:	0f be d0             	movsbl %al,%edx
    16d5:	8b 45 ec             	mov    -0x14(%rbp),%eax
    16d8:	89 d6                	mov    %edx,%esi
    16da:	89 c7                	mov    %eax,%edi
    16dc:	48 b8 0e 16 00 00 00 	movabs $0x160e,%rax
    16e3:	00 00 00 
    16e6:	ff d0                	callq  *%rax
  for (i = 0; i < (sizeof(uint) * 2); i++, x <<= 4)
    16e8:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
    16ec:	c1 65 e8 04          	shll   $0x4,-0x18(%rbp)
    16f0:	8b 45 fc             	mov    -0x4(%rbp),%eax
    16f3:	83 f8 07             	cmp    $0x7,%eax
    16f6:	76 c2                	jbe    16ba <print_x32+0x1b>
}
    16f8:	90                   	nop
    16f9:	90                   	nop
    16fa:	c9                   	leaveq 
    16fb:	c3                   	retq   

00000000000016fc <print_d>:

  static void
print_d(int fd, int v)
{
    16fc:	f3 0f 1e fa          	endbr64 
    1700:	55                   	push   %rbp
    1701:	48 89 e5             	mov    %rsp,%rbp
    1704:	48 83 ec 30          	sub    $0x30,%rsp
    1708:	89 7d dc             	mov    %edi,-0x24(%rbp)
    170b:	89 75 d8             	mov    %esi,-0x28(%rbp)
  char buf[16];
  int64 x = v;
    170e:	8b 45 d8             	mov    -0x28(%rbp),%eax
    1711:	48 98                	cltq   
    1713:	48 89 45 f8          	mov    %rax,-0x8(%rbp)

  if (v < 0)
    1717:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
    171b:	79 04                	jns    1721 <print_d+0x25>
    x = -x;
    171d:	48 f7 5d f8          	negq   -0x8(%rbp)

  int i = 0;
    1721:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%rbp)
  do {
    buf[i++] = digits[x % 10];
    1728:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
    172c:	48 ba 67 66 66 66 66 	movabs $0x6666666666666667,%rdx
    1733:	66 66 66 
    1736:	48 89 c8             	mov    %rcx,%rax
    1739:	48 f7 ea             	imul   %rdx
    173c:	48 c1 fa 02          	sar    $0x2,%rdx
    1740:	48 89 c8             	mov    %rcx,%rax
    1743:	48 c1 f8 3f          	sar    $0x3f,%rax
    1747:	48 29 c2             	sub    %rax,%rdx
    174a:	48 89 d0             	mov    %rdx,%rax
    174d:	48 c1 e0 02          	shl    $0x2,%rax
    1751:	48 01 d0             	add    %rdx,%rax
    1754:	48 01 c0             	add    %rax,%rax
    1757:	48 29 c1             	sub    %rax,%rcx
    175a:	48 89 ca             	mov    %rcx,%rdx
    175d:	8b 45 f4             	mov    -0xc(%rbp),%eax
    1760:	8d 48 01             	lea    0x1(%rax),%ecx
    1763:	89 4d f4             	mov    %ecx,-0xc(%rbp)
    1766:	48 b9 90 22 00 00 00 	movabs $0x2290,%rcx
    176d:	00 00 00 
    1770:	0f b6 14 11          	movzbl (%rcx,%rdx,1),%edx
    1774:	48 98                	cltq   
    1776:	88 54 05 e0          	mov    %dl,-0x20(%rbp,%rax,1)
    x /= 10;
    177a:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
    177e:	48 ba 67 66 66 66 66 	movabs $0x6666666666666667,%rdx
    1785:	66 66 66 
    1788:	48 89 c8             	mov    %rcx,%rax
    178b:	48 f7 ea             	imul   %rdx
    178e:	48 c1 fa 02          	sar    $0x2,%rdx
    1792:	48 89 c8             	mov    %rcx,%rax
    1795:	48 c1 f8 3f          	sar    $0x3f,%rax
    1799:	48 29 c2             	sub    %rax,%rdx
    179c:	48 89 d0             	mov    %rdx,%rax
    179f:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  } while(x != 0);
    17a3:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
    17a8:	0f 85 7a ff ff ff    	jne    1728 <print_d+0x2c>

  if (v < 0)
    17ae:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
    17b2:	79 32                	jns    17e6 <print_d+0xea>
    buf[i++] = '-';
    17b4:	8b 45 f4             	mov    -0xc(%rbp),%eax
    17b7:	8d 50 01             	lea    0x1(%rax),%edx
    17ba:	89 55 f4             	mov    %edx,-0xc(%rbp)
    17bd:	48 98                	cltq   
    17bf:	c6 44 05 e0 2d       	movb   $0x2d,-0x20(%rbp,%rax,1)

  while (--i >= 0)
    17c4:	eb 20                	jmp    17e6 <print_d+0xea>
    putc(fd, buf[i]);
    17c6:	8b 45 f4             	mov    -0xc(%rbp),%eax
    17c9:	48 98                	cltq   
    17cb:	0f b6 44 05 e0       	movzbl -0x20(%rbp,%rax,1),%eax
    17d0:	0f be d0             	movsbl %al,%edx
    17d3:	8b 45 dc             	mov    -0x24(%rbp),%eax
    17d6:	89 d6                	mov    %edx,%esi
    17d8:	89 c7                	mov    %eax,%edi
    17da:	48 b8 0e 16 00 00 00 	movabs $0x160e,%rax
    17e1:	00 00 00 
    17e4:	ff d0                	callq  *%rax
  while (--i >= 0)
    17e6:	83 6d f4 01          	subl   $0x1,-0xc(%rbp)
    17ea:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
    17ee:	79 d6                	jns    17c6 <print_d+0xca>
}
    17f0:	90                   	nop
    17f1:	90                   	nop
    17f2:	c9                   	leaveq 
    17f3:	c3                   	retq   

00000000000017f4 <printf>:
// Print to the given fd. Only understands %d, %x, %p, %s.
  void
printf(int fd, char *fmt, ...)
{
    17f4:	f3 0f 1e fa          	endbr64 
    17f8:	55                   	push   %rbp
    17f9:	48 89 e5             	mov    %rsp,%rbp
    17fc:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
    1803:	89 bd 1c ff ff ff    	mov    %edi,-0xe4(%rbp)
    1809:	48 89 b5 10 ff ff ff 	mov    %rsi,-0xf0(%rbp)
    1810:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
    1817:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
    181e:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
    1825:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
    182c:	84 c0                	test   %al,%al
    182e:	74 20                	je     1850 <printf+0x5c>
    1830:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
    1834:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
    1838:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
    183c:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
    1840:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
    1844:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
    1848:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
    184c:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  va_list ap;
  int i, c;
  char *s;

  va_start(ap, fmt);
    1850:	c7 85 20 ff ff ff 10 	movl   $0x10,-0xe0(%rbp)
    1857:	00 00 00 
    185a:	c7 85 24 ff ff ff 30 	movl   $0x30,-0xdc(%rbp)
    1861:	00 00 00 
    1864:	48 8d 45 10          	lea    0x10(%rbp),%rax
    1868:	48 89 85 28 ff ff ff 	mov    %rax,-0xd8(%rbp)
    186f:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
    1876:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  for (i = 0; (c = fmt[i] & 0xff) != 0; i++) {
    187d:	c7 85 4c ff ff ff 00 	movl   $0x0,-0xb4(%rbp)
    1884:	00 00 00 
    1887:	e9 41 03 00 00       	jmpq   1bcd <printf+0x3d9>
    if (c != '%') {
    188c:	83 bd 3c ff ff ff 25 	cmpl   $0x25,-0xc4(%rbp)
    1893:	74 24                	je     18b9 <printf+0xc5>
      putc(fd, c);
    1895:	8b 85 3c ff ff ff    	mov    -0xc4(%rbp),%eax
    189b:	0f be d0             	movsbl %al,%edx
    189e:	8b 85 1c ff ff ff    	mov    -0xe4(%rbp),%eax
    18a4:	89 d6                	mov    %edx,%esi
    18a6:	89 c7                	mov    %eax,%edi
    18a8:	48 b8 0e 16 00 00 00 	movabs $0x160e,%rax
    18af:	00 00 00 
    18b2:	ff d0                	callq  *%rax
      continue;
    18b4:	e9 0d 03 00 00       	jmpq   1bc6 <printf+0x3d2>
    }
    c = fmt[++i] & 0xff;
    18b9:	83 85 4c ff ff ff 01 	addl   $0x1,-0xb4(%rbp)
    18c0:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
    18c6:	48 63 d0             	movslq %eax,%rdx
    18c9:	48 8b 85 10 ff ff ff 	mov    -0xf0(%rbp),%rax
    18d0:	48 01 d0             	add    %rdx,%rax
    18d3:	0f b6 00             	movzbl (%rax),%eax
    18d6:	0f be c0             	movsbl %al,%eax
    18d9:	25 ff 00 00 00       	and    $0xff,%eax
    18de:	89 85 3c ff ff ff    	mov    %eax,-0xc4(%rbp)
    if (c == 0)
    18e4:	83 bd 3c ff ff ff 00 	cmpl   $0x0,-0xc4(%rbp)
    18eb:	0f 84 0f 03 00 00    	je     1c00 <printf+0x40c>
      break;
    switch(c) {
    18f1:	83 bd 3c ff ff ff 25 	cmpl   $0x25,-0xc4(%rbp)
    18f8:	0f 84 74 02 00 00    	je     1b72 <printf+0x37e>
    18fe:	83 bd 3c ff ff ff 25 	cmpl   $0x25,-0xc4(%rbp)
    1905:	0f 8c 82 02 00 00    	jl     1b8d <printf+0x399>
    190b:	83 bd 3c ff ff ff 78 	cmpl   $0x78,-0xc4(%rbp)
    1912:	0f 8f 75 02 00 00    	jg     1b8d <printf+0x399>
    1918:	83 bd 3c ff ff ff 63 	cmpl   $0x63,-0xc4(%rbp)
    191f:	0f 8c 68 02 00 00    	jl     1b8d <printf+0x399>
    1925:	8b 85 3c ff ff ff    	mov    -0xc4(%rbp),%eax
    192b:	83 e8 63             	sub    $0x63,%eax
    192e:	83 f8 15             	cmp    $0x15,%eax
    1931:	0f 87 56 02 00 00    	ja     1b8d <printf+0x399>
    1937:	89 c0                	mov    %eax,%eax
    1939:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
    1940:	00 
    1941:	48 b8 48 1f 00 00 00 	movabs $0x1f48,%rax
    1948:	00 00 00 
    194b:	48 01 d0             	add    %rdx,%rax
    194e:	48 8b 00             	mov    (%rax),%rax
    1951:	3e ff e0             	notrack jmpq *%rax
    case 'c':
      putc(fd, va_arg(ap, int));
    1954:	8b 85 20 ff ff ff    	mov    -0xe0(%rbp),%eax
    195a:	83 f8 2f             	cmp    $0x2f,%eax
    195d:	77 23                	ja     1982 <printf+0x18e>
    195f:	48 8b 85 30 ff ff ff 	mov    -0xd0(%rbp),%rax
    1966:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    196c:	89 d2                	mov    %edx,%edx
    196e:	48 01 d0             	add    %rdx,%rax
    1971:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    1977:	83 c2 08             	add    $0x8,%edx
    197a:	89 95 20 ff ff ff    	mov    %edx,-0xe0(%rbp)
    1980:	eb 12                	jmp    1994 <printf+0x1a0>
    1982:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
    1989:	48 8d 50 08          	lea    0x8(%rax),%rdx
    198d:	48 89 95 28 ff ff ff 	mov    %rdx,-0xd8(%rbp)
    1994:	8b 00                	mov    (%rax),%eax
    1996:	0f be d0             	movsbl %al,%edx
    1999:	8b 85 1c ff ff ff    	mov    -0xe4(%rbp),%eax
    199f:	89 d6                	mov    %edx,%esi
    19a1:	89 c7                	mov    %eax,%edi
    19a3:	48 b8 0e 16 00 00 00 	movabs $0x160e,%rax
    19aa:	00 00 00 
    19ad:	ff d0                	callq  *%rax
      break;
    19af:	e9 12 02 00 00       	jmpq   1bc6 <printf+0x3d2>
    case 'd':
      print_d(fd, va_arg(ap, int));
    19b4:	8b 85 20 ff ff ff    	mov    -0xe0(%rbp),%eax
    19ba:	83 f8 2f             	cmp    $0x2f,%eax
    19bd:	77 23                	ja     19e2 <printf+0x1ee>
    19bf:	48 8b 85 30 ff ff ff 	mov    -0xd0(%rbp),%rax
    19c6:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    19cc:	89 d2                	mov    %edx,%edx
    19ce:	48 01 d0             	add    %rdx,%rax
    19d1:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    19d7:	83 c2 08             	add    $0x8,%edx
    19da:	89 95 20 ff ff ff    	mov    %edx,-0xe0(%rbp)
    19e0:	eb 12                	jmp    19f4 <printf+0x200>
    19e2:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
    19e9:	48 8d 50 08          	lea    0x8(%rax),%rdx
    19ed:	48 89 95 28 ff ff ff 	mov    %rdx,-0xd8(%rbp)
    19f4:	8b 10                	mov    (%rax),%edx
    19f6:	8b 85 1c ff ff ff    	mov    -0xe4(%rbp),%eax
    19fc:	89 d6                	mov    %edx,%esi
    19fe:	89 c7                	mov    %eax,%edi
    1a00:	48 b8 fc 16 00 00 00 	movabs $0x16fc,%rax
    1a07:	00 00 00 
    1a0a:	ff d0                	callq  *%rax
      break;
    1a0c:	e9 b5 01 00 00       	jmpq   1bc6 <printf+0x3d2>
    case 'x':
      print_x32(fd, va_arg(ap, uint));
    1a11:	8b 85 20 ff ff ff    	mov    -0xe0(%rbp),%eax
    1a17:	83 f8 2f             	cmp    $0x2f,%eax
    1a1a:	77 23                	ja     1a3f <printf+0x24b>
    1a1c:	48 8b 85 30 ff ff ff 	mov    -0xd0(%rbp),%rax
    1a23:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    1a29:	89 d2                	mov    %edx,%edx
    1a2b:	48 01 d0             	add    %rdx,%rax
    1a2e:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    1a34:	83 c2 08             	add    $0x8,%edx
    1a37:	89 95 20 ff ff ff    	mov    %edx,-0xe0(%rbp)
    1a3d:	eb 12                	jmp    1a51 <printf+0x25d>
    1a3f:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
    1a46:	48 8d 50 08          	lea    0x8(%rax),%rdx
    1a4a:	48 89 95 28 ff ff ff 	mov    %rdx,-0xd8(%rbp)
    1a51:	8b 10                	mov    (%rax),%edx
    1a53:	8b 85 1c ff ff ff    	mov    -0xe4(%rbp),%eax
    1a59:	89 d6                	mov    %edx,%esi
    1a5b:	89 c7                	mov    %eax,%edi
    1a5d:	48 b8 9f 16 00 00 00 	movabs $0x169f,%rax
    1a64:	00 00 00 
    1a67:	ff d0                	callq  *%rax
      break;
    1a69:	e9 58 01 00 00       	jmpq   1bc6 <printf+0x3d2>
    case 'p':
      print_x64(fd, va_arg(ap, addr_t));
    1a6e:	8b 85 20 ff ff ff    	mov    -0xe0(%rbp),%eax
    1a74:	83 f8 2f             	cmp    $0x2f,%eax
    1a77:	77 23                	ja     1a9c <printf+0x2a8>
    1a79:	48 8b 85 30 ff ff ff 	mov    -0xd0(%rbp),%rax
    1a80:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    1a86:	89 d2                	mov    %edx,%edx
    1a88:	48 01 d0             	add    %rdx,%rax
    1a8b:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    1a91:	83 c2 08             	add    $0x8,%edx
    1a94:	89 95 20 ff ff ff    	mov    %edx,-0xe0(%rbp)
    1a9a:	eb 12                	jmp    1aae <printf+0x2ba>
    1a9c:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
    1aa3:	48 8d 50 08          	lea    0x8(%rax),%rdx
    1aa7:	48 89 95 28 ff ff ff 	mov    %rdx,-0xd8(%rbp)
    1aae:	48 8b 10             	mov    (%rax),%rdx
    1ab1:	8b 85 1c ff ff ff    	mov    -0xe4(%rbp),%eax
    1ab7:	48 89 d6             	mov    %rdx,%rsi
    1aba:	89 c7                	mov    %eax,%edi
    1abc:	48 b8 42 16 00 00 00 	movabs $0x1642,%rax
    1ac3:	00 00 00 
    1ac6:	ff d0                	callq  *%rax
      break;
    1ac8:	e9 f9 00 00 00       	jmpq   1bc6 <printf+0x3d2>
    case 's':
      if ((s = va_arg(ap, char*)) == 0)
    1acd:	8b 85 20 ff ff ff    	mov    -0xe0(%rbp),%eax
    1ad3:	83 f8 2f             	cmp    $0x2f,%eax
    1ad6:	77 23                	ja     1afb <printf+0x307>
    1ad8:	48 8b 85 30 ff ff ff 	mov    -0xd0(%rbp),%rax
    1adf:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    1ae5:	89 d2                	mov    %edx,%edx
    1ae7:	48 01 d0             	add    %rdx,%rax
    1aea:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    1af0:	83 c2 08             	add    $0x8,%edx
    1af3:	89 95 20 ff ff ff    	mov    %edx,-0xe0(%rbp)
    1af9:	eb 12                	jmp    1b0d <printf+0x319>
    1afb:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
    1b02:	48 8d 50 08          	lea    0x8(%rax),%rdx
    1b06:	48 89 95 28 ff ff ff 	mov    %rdx,-0xd8(%rbp)
    1b0d:	48 8b 00             	mov    (%rax),%rax
    1b10:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
    1b17:	48 83 bd 40 ff ff ff 	cmpq   $0x0,-0xc0(%rbp)
    1b1e:	00 
    1b1f:	75 41                	jne    1b62 <printf+0x36e>
        s = "(null)";
    1b21:	48 b8 40 1f 00 00 00 	movabs $0x1f40,%rax
    1b28:	00 00 00 
    1b2b:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
      while (*s)
    1b32:	eb 2e                	jmp    1b62 <printf+0x36e>
        putc(fd, *(s++));
    1b34:	48 8b 85 40 ff ff ff 	mov    -0xc0(%rbp),%rax
    1b3b:	48 8d 50 01          	lea    0x1(%rax),%rdx
    1b3f:	48 89 95 40 ff ff ff 	mov    %rdx,-0xc0(%rbp)
    1b46:	0f b6 00             	movzbl (%rax),%eax
    1b49:	0f be d0             	movsbl %al,%edx
    1b4c:	8b 85 1c ff ff ff    	mov    -0xe4(%rbp),%eax
    1b52:	89 d6                	mov    %edx,%esi
    1b54:	89 c7                	mov    %eax,%edi
    1b56:	48 b8 0e 16 00 00 00 	movabs $0x160e,%rax
    1b5d:	00 00 00 
    1b60:	ff d0                	callq  *%rax
      while (*s)
    1b62:	48 8b 85 40 ff ff ff 	mov    -0xc0(%rbp),%rax
    1b69:	0f b6 00             	movzbl (%rax),%eax
    1b6c:	84 c0                	test   %al,%al
    1b6e:	75 c4                	jne    1b34 <printf+0x340>
      break;
    1b70:	eb 54                	jmp    1bc6 <printf+0x3d2>
    case '%':
      putc(fd, '%');
    1b72:	8b 85 1c ff ff ff    	mov    -0xe4(%rbp),%eax
    1b78:	be 25 00 00 00       	mov    $0x25,%esi
    1b7d:	89 c7                	mov    %eax,%edi
    1b7f:	48 b8 0e 16 00 00 00 	movabs $0x160e,%rax
    1b86:	00 00 00 
    1b89:	ff d0                	callq  *%rax
      break;
    1b8b:	eb 39                	jmp    1bc6 <printf+0x3d2>
    default:
      // Print unknown % sequence to draw attention.
      putc(fd, '%');
    1b8d:	8b 85 1c ff ff ff    	mov    -0xe4(%rbp),%eax
    1b93:	be 25 00 00 00       	mov    $0x25,%esi
    1b98:	89 c7                	mov    %eax,%edi
    1b9a:	48 b8 0e 16 00 00 00 	movabs $0x160e,%rax
    1ba1:	00 00 00 
    1ba4:	ff d0                	callq  *%rax
      putc(fd, c);
    1ba6:	8b 85 3c ff ff ff    	mov    -0xc4(%rbp),%eax
    1bac:	0f be d0             	movsbl %al,%edx
    1baf:	8b 85 1c ff ff ff    	mov    -0xe4(%rbp),%eax
    1bb5:	89 d6                	mov    %edx,%esi
    1bb7:	89 c7                	mov    %eax,%edi
    1bb9:	48 b8 0e 16 00 00 00 	movabs $0x160e,%rax
    1bc0:	00 00 00 
    1bc3:	ff d0                	callq  *%rax
      break;
    1bc5:	90                   	nop
  for (i = 0; (c = fmt[i] & 0xff) != 0; i++) {
    1bc6:	83 85 4c ff ff ff 01 	addl   $0x1,-0xb4(%rbp)
    1bcd:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
    1bd3:	48 63 d0             	movslq %eax,%rdx
    1bd6:	48 8b 85 10 ff ff ff 	mov    -0xf0(%rbp),%rax
    1bdd:	48 01 d0             	add    %rdx,%rax
    1be0:	0f b6 00             	movzbl (%rax),%eax
    1be3:	0f be c0             	movsbl %al,%eax
    1be6:	25 ff 00 00 00       	and    $0xff,%eax
    1beb:	89 85 3c ff ff ff    	mov    %eax,-0xc4(%rbp)
    1bf1:	83 bd 3c ff ff ff 00 	cmpl   $0x0,-0xc4(%rbp)
    1bf8:	0f 85 8e fc ff ff    	jne    188c <printf+0x98>
    }
  }
}
    1bfe:	eb 01                	jmp    1c01 <printf+0x40d>
      break;
    1c00:	90                   	nop
}
    1c01:	90                   	nop
    1c02:	c9                   	leaveq 
    1c03:	c3                   	retq   

0000000000001c04 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    1c04:	f3 0f 1e fa          	endbr64 
    1c08:	55                   	push   %rbp
    1c09:	48 89 e5             	mov    %rsp,%rbp
    1c0c:	48 83 ec 18          	sub    $0x18,%rsp
    1c10:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  Header *bp, *p;

  bp = (Header*)ap - 1;
    1c14:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    1c18:	48 83 e8 10          	sub    $0x10,%rax
    1c1c:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    1c20:	48 b8 d0 24 00 00 00 	movabs $0x24d0,%rax
    1c27:	00 00 00 
    1c2a:	48 8b 00             	mov    (%rax),%rax
    1c2d:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
    1c31:	eb 2f                	jmp    1c62 <free+0x5e>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    1c33:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1c37:	48 8b 00             	mov    (%rax),%rax
    1c3a:	48 39 45 f8          	cmp    %rax,-0x8(%rbp)
    1c3e:	72 17                	jb     1c57 <free+0x53>
    1c40:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1c44:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
    1c48:	77 2f                	ja     1c79 <free+0x75>
    1c4a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1c4e:	48 8b 00             	mov    (%rax),%rax
    1c51:	48 39 45 f0          	cmp    %rax,-0x10(%rbp)
    1c55:	72 22                	jb     1c79 <free+0x75>
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    1c57:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1c5b:	48 8b 00             	mov    (%rax),%rax
    1c5e:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
    1c62:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1c66:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
    1c6a:	76 c7                	jbe    1c33 <free+0x2f>
    1c6c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1c70:	48 8b 00             	mov    (%rax),%rax
    1c73:	48 39 45 f0          	cmp    %rax,-0x10(%rbp)
    1c77:	73 ba                	jae    1c33 <free+0x2f>
      break;
  if(bp + bp->s.size == p->s.ptr){
    1c79:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1c7d:	8b 40 08             	mov    0x8(%rax),%eax
    1c80:	89 c0                	mov    %eax,%eax
    1c82:	48 c1 e0 04          	shl    $0x4,%rax
    1c86:	48 89 c2             	mov    %rax,%rdx
    1c89:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1c8d:	48 01 c2             	add    %rax,%rdx
    1c90:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1c94:	48 8b 00             	mov    (%rax),%rax
    1c97:	48 39 c2             	cmp    %rax,%rdx
    1c9a:	75 2d                	jne    1cc9 <free+0xc5>
    bp->s.size += p->s.ptr->s.size;
    1c9c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1ca0:	8b 50 08             	mov    0x8(%rax),%edx
    1ca3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1ca7:	48 8b 00             	mov    (%rax),%rax
    1caa:	8b 40 08             	mov    0x8(%rax),%eax
    1cad:	01 c2                	add    %eax,%edx
    1caf:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1cb3:	89 50 08             	mov    %edx,0x8(%rax)
    bp->s.ptr = p->s.ptr->s.ptr;
    1cb6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1cba:	48 8b 00             	mov    (%rax),%rax
    1cbd:	48 8b 10             	mov    (%rax),%rdx
    1cc0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1cc4:	48 89 10             	mov    %rdx,(%rax)
    1cc7:	eb 0e                	jmp    1cd7 <free+0xd3>
  } else
    bp->s.ptr = p->s.ptr;
    1cc9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1ccd:	48 8b 10             	mov    (%rax),%rdx
    1cd0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1cd4:	48 89 10             	mov    %rdx,(%rax)
  if(p + p->s.size == bp){
    1cd7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1cdb:	8b 40 08             	mov    0x8(%rax),%eax
    1cde:	89 c0                	mov    %eax,%eax
    1ce0:	48 c1 e0 04          	shl    $0x4,%rax
    1ce4:	48 89 c2             	mov    %rax,%rdx
    1ce7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1ceb:	48 01 d0             	add    %rdx,%rax
    1cee:	48 39 45 f0          	cmp    %rax,-0x10(%rbp)
    1cf2:	75 27                	jne    1d1b <free+0x117>
    p->s.size += bp->s.size;
    1cf4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1cf8:	8b 50 08             	mov    0x8(%rax),%edx
    1cfb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1cff:	8b 40 08             	mov    0x8(%rax),%eax
    1d02:	01 c2                	add    %eax,%edx
    1d04:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1d08:	89 50 08             	mov    %edx,0x8(%rax)
    p->s.ptr = bp->s.ptr;
    1d0b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1d0f:	48 8b 10             	mov    (%rax),%rdx
    1d12:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1d16:	48 89 10             	mov    %rdx,(%rax)
    1d19:	eb 0b                	jmp    1d26 <free+0x122>
  } else
    p->s.ptr = bp;
    1d1b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1d1f:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
    1d23:	48 89 10             	mov    %rdx,(%rax)
  freep = p;
    1d26:	48 ba d0 24 00 00 00 	movabs $0x24d0,%rdx
    1d2d:	00 00 00 
    1d30:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1d34:	48 89 02             	mov    %rax,(%rdx)
}
    1d37:	90                   	nop
    1d38:	c9                   	leaveq 
    1d39:	c3                   	retq   

0000000000001d3a <morecore>:

static Header*
morecore(uint nu)
{
    1d3a:	f3 0f 1e fa          	endbr64 
    1d3e:	55                   	push   %rbp
    1d3f:	48 89 e5             	mov    %rsp,%rbp
    1d42:	48 83 ec 20          	sub    $0x20,%rsp
    1d46:	89 7d ec             	mov    %edi,-0x14(%rbp)
  char *p;
  Header *hp;

  if(nu < 4096)
    1d49:	81 7d ec ff 0f 00 00 	cmpl   $0xfff,-0x14(%rbp)
    1d50:	77 07                	ja     1d59 <morecore+0x1f>
    nu = 4096;
    1d52:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%rbp)
  p = sbrk(nu * sizeof(Header));
    1d59:	8b 45 ec             	mov    -0x14(%rbp),%eax
    1d5c:	48 c1 e0 04          	shl    $0x4,%rax
    1d60:	48 89 c7             	mov    %rax,%rdi
    1d63:	48 b8 da 15 00 00 00 	movabs $0x15da,%rax
    1d6a:	00 00 00 
    1d6d:	ff d0                	callq  *%rax
    1d6f:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  if(p == (char*)-1)
    1d73:	48 83 7d f8 ff       	cmpq   $0xffffffffffffffff,-0x8(%rbp)
    1d78:	75 07                	jne    1d81 <morecore+0x47>
    return 0;
    1d7a:	b8 00 00 00 00       	mov    $0x0,%eax
    1d7f:	eb 36                	jmp    1db7 <morecore+0x7d>
  hp = (Header*)p;
    1d81:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1d85:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
  hp->s.size = nu;
    1d89:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1d8d:	8b 55 ec             	mov    -0x14(%rbp),%edx
    1d90:	89 50 08             	mov    %edx,0x8(%rax)
  free((void*)(hp + 1));
    1d93:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1d97:	48 83 c0 10          	add    $0x10,%rax
    1d9b:	48 89 c7             	mov    %rax,%rdi
    1d9e:	48 b8 04 1c 00 00 00 	movabs $0x1c04,%rax
    1da5:	00 00 00 
    1da8:	ff d0                	callq  *%rax
  return freep;
    1daa:	48 b8 d0 24 00 00 00 	movabs $0x24d0,%rax
    1db1:	00 00 00 
    1db4:	48 8b 00             	mov    (%rax),%rax
}
    1db7:	c9                   	leaveq 
    1db8:	c3                   	retq   

0000000000001db9 <malloc>:

void*
malloc(uint nbytes)
{
    1db9:	f3 0f 1e fa          	endbr64 
    1dbd:	55                   	push   %rbp
    1dbe:	48 89 e5             	mov    %rsp,%rbp
    1dc1:	48 83 ec 30          	sub    $0x30,%rsp
    1dc5:	89 7d dc             	mov    %edi,-0x24(%rbp)
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    1dc8:	8b 45 dc             	mov    -0x24(%rbp),%eax
    1dcb:	48 83 c0 0f          	add    $0xf,%rax
    1dcf:	48 c1 e8 04          	shr    $0x4,%rax
    1dd3:	83 c0 01             	add    $0x1,%eax
    1dd6:	89 45 ec             	mov    %eax,-0x14(%rbp)
  if((prevp = freep) == 0){
    1dd9:	48 b8 d0 24 00 00 00 	movabs $0x24d0,%rax
    1de0:	00 00 00 
    1de3:	48 8b 00             	mov    (%rax),%rax
    1de6:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
    1dea:	48 83 7d f0 00       	cmpq   $0x0,-0x10(%rbp)
    1def:	75 4a                	jne    1e3b <malloc+0x82>
    base.s.ptr = freep = prevp = &base;
    1df1:	48 b8 c0 24 00 00 00 	movabs $0x24c0,%rax
    1df8:	00 00 00 
    1dfb:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
    1dff:	48 ba d0 24 00 00 00 	movabs $0x24d0,%rdx
    1e06:	00 00 00 
    1e09:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1e0d:	48 89 02             	mov    %rax,(%rdx)
    1e10:	48 b8 d0 24 00 00 00 	movabs $0x24d0,%rax
    1e17:	00 00 00 
    1e1a:	48 8b 00             	mov    (%rax),%rax
    1e1d:	48 ba c0 24 00 00 00 	movabs $0x24c0,%rdx
    1e24:	00 00 00 
    1e27:	48 89 02             	mov    %rax,(%rdx)
    base.s.size = 0;
    1e2a:	48 b8 c0 24 00 00 00 	movabs $0x24c0,%rax
    1e31:	00 00 00 
    1e34:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%rax)
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    1e3b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1e3f:	48 8b 00             	mov    (%rax),%rax
    1e42:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
    if(p->s.size >= nunits){
    1e46:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1e4a:	8b 40 08             	mov    0x8(%rax),%eax
    1e4d:	39 45 ec             	cmp    %eax,-0x14(%rbp)
    1e50:	77 65                	ja     1eb7 <malloc+0xfe>
      if(p->s.size == nunits)
    1e52:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1e56:	8b 40 08             	mov    0x8(%rax),%eax
    1e59:	39 45 ec             	cmp    %eax,-0x14(%rbp)
    1e5c:	75 10                	jne    1e6e <malloc+0xb5>
        prevp->s.ptr = p->s.ptr;
    1e5e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1e62:	48 8b 10             	mov    (%rax),%rdx
    1e65:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1e69:	48 89 10             	mov    %rdx,(%rax)
    1e6c:	eb 2e                	jmp    1e9c <malloc+0xe3>
      else {
        p->s.size -= nunits;
    1e6e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1e72:	8b 40 08             	mov    0x8(%rax),%eax
    1e75:	2b 45 ec             	sub    -0x14(%rbp),%eax
    1e78:	89 c2                	mov    %eax,%edx
    1e7a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1e7e:	89 50 08             	mov    %edx,0x8(%rax)
        p += p->s.size;
    1e81:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1e85:	8b 40 08             	mov    0x8(%rax),%eax
    1e88:	89 c0                	mov    %eax,%eax
    1e8a:	48 c1 e0 04          	shl    $0x4,%rax
    1e8e:	48 01 45 f8          	add    %rax,-0x8(%rbp)
        p->s.size = nunits;
    1e92:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1e96:	8b 55 ec             	mov    -0x14(%rbp),%edx
    1e99:	89 50 08             	mov    %edx,0x8(%rax)
      }
      freep = prevp;
    1e9c:	48 ba d0 24 00 00 00 	movabs $0x24d0,%rdx
    1ea3:	00 00 00 
    1ea6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1eaa:	48 89 02             	mov    %rax,(%rdx)
      return (void*)(p + 1);
    1ead:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1eb1:	48 83 c0 10          	add    $0x10,%rax
    1eb5:	eb 4e                	jmp    1f05 <malloc+0x14c>
    }
    if(p == freep)
    1eb7:	48 b8 d0 24 00 00 00 	movabs $0x24d0,%rax
    1ebe:	00 00 00 
    1ec1:	48 8b 00             	mov    (%rax),%rax
    1ec4:	48 39 45 f8          	cmp    %rax,-0x8(%rbp)
    1ec8:	75 23                	jne    1eed <malloc+0x134>
      if((p = morecore(nunits)) == 0)
    1eca:	8b 45 ec             	mov    -0x14(%rbp),%eax
    1ecd:	89 c7                	mov    %eax,%edi
    1ecf:	48 b8 3a 1d 00 00 00 	movabs $0x1d3a,%rax
    1ed6:	00 00 00 
    1ed9:	ff d0                	callq  *%rax
    1edb:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
    1edf:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
    1ee4:	75 07                	jne    1eed <malloc+0x134>
        return 0;
    1ee6:	b8 00 00 00 00       	mov    $0x0,%eax
    1eeb:	eb 18                	jmp    1f05 <malloc+0x14c>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    1eed:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1ef1:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
    1ef5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1ef9:	48 8b 00             	mov    (%rax),%rax
    1efc:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
    if(p->s.size >= nunits){
    1f00:	e9 41 ff ff ff       	jmpq   1e46 <malloc+0x8d>
  }
}
    1f05:	c9                   	leaveq 
    1f06:	c3                   	retq   
