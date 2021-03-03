
_ln:     file format elf64-x86-64


Disassembly of section .text:

0000000000001000 <main>:
#include "stat.h"
#include "user.h"

int
main(int argc, char *argv[])
{
    1000:	f3 0f 1e fa          	endbr64 
    1004:	55                   	push   %rbp
    1005:	48 89 e5             	mov    %rsp,%rbp
    1008:	48 83 ec 10          	sub    $0x10,%rsp
    100c:	89 7d fc             	mov    %edi,-0x4(%rbp)
    100f:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  if(argc != 3){
    1013:	83 7d fc 03          	cmpl   $0x3,-0x4(%rbp)
    1017:	74 2c                	je     1045 <main+0x45>
    printf(2, "Usage: ln old new\n");
    1019:	48 be 08 1e 00 00 00 	movabs $0x1e08,%rsi
    1020:	00 00 00 
    1023:	bf 02 00 00 00       	mov    $0x2,%edi
    1028:	b8 00 00 00 00       	mov    $0x0,%eax
    102d:	48 ba f4 16 00 00 00 	movabs $0x16f4,%rdx
    1034:	00 00 00 
    1037:	ff d2                	callq  *%rdx
    exit();
    1039:	48 b8 fd 13 00 00 00 	movabs $0x13fd,%rax
    1040:	00 00 00 
    1043:	ff d0                	callq  *%rax
  }
  if(link(argv[1], argv[2]) < 0)
    1045:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1049:	48 83 c0 10          	add    $0x10,%rax
    104d:	48 8b 10             	mov    (%rax),%rdx
    1050:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1054:	48 83 c0 08          	add    $0x8,%rax
    1058:	48 8b 00             	mov    (%rax),%rax
    105b:	48 89 d6             	mov    %rdx,%rsi
    105e:	48 89 c7             	mov    %rax,%rdi
    1061:	48 b8 99 14 00 00 00 	movabs $0x1499,%rax
    1068:	00 00 00 
    106b:	ff d0                	callq  *%rax
    106d:	85 c0                	test   %eax,%eax
    106f:	79 3d                	jns    10ae <main+0xae>
    printf(2, "link %s %s: failed\n", argv[1], argv[2]);
    1071:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1075:	48 83 c0 10          	add    $0x10,%rax
    1079:	48 8b 10             	mov    (%rax),%rdx
    107c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1080:	48 83 c0 08          	add    $0x8,%rax
    1084:	48 8b 00             	mov    (%rax),%rax
    1087:	48 89 d1             	mov    %rdx,%rcx
    108a:	48 89 c2             	mov    %rax,%rdx
    108d:	48 be 1b 1e 00 00 00 	movabs $0x1e1b,%rsi
    1094:	00 00 00 
    1097:	bf 02 00 00 00       	mov    $0x2,%edi
    109c:	b8 00 00 00 00       	mov    $0x0,%eax
    10a1:	49 b8 f4 16 00 00 00 	movabs $0x16f4,%r8
    10a8:	00 00 00 
    10ab:	41 ff d0             	callq  *%r8
  exit();
    10ae:	48 b8 fd 13 00 00 00 	movabs $0x13fd,%rax
    10b5:	00 00 00 
    10b8:	ff d0                	callq  *%rax

00000000000010ba <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
    10ba:	f3 0f 1e fa          	endbr64 
    10be:	55                   	push   %rbp
    10bf:	48 89 e5             	mov    %rsp,%rbp
    10c2:	48 83 ec 10          	sub    $0x10,%rsp
    10c6:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
    10ca:	89 75 f4             	mov    %esi,-0xc(%rbp)
    10cd:	89 55 f0             	mov    %edx,-0x10(%rbp)
  asm volatile("cld; rep stosb" :
    10d0:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
    10d4:	8b 55 f0             	mov    -0x10(%rbp),%edx
    10d7:	8b 45 f4             	mov    -0xc(%rbp),%eax
    10da:	48 89 ce             	mov    %rcx,%rsi
    10dd:	48 89 f7             	mov    %rsi,%rdi
    10e0:	89 d1                	mov    %edx,%ecx
    10e2:	fc                   	cld    
    10e3:	f3 aa                	rep stos %al,%es:(%rdi)
    10e5:	89 ca                	mov    %ecx,%edx
    10e7:	48 89 fe             	mov    %rdi,%rsi
    10ea:	48 89 75 f8          	mov    %rsi,-0x8(%rbp)
    10ee:	89 55 f0             	mov    %edx,-0x10(%rbp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
    10f1:	90                   	nop
    10f2:	c9                   	leaveq 
    10f3:	c3                   	retq   

00000000000010f4 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
    10f4:	f3 0f 1e fa          	endbr64 
    10f8:	55                   	push   %rbp
    10f9:	48 89 e5             	mov    %rsp,%rbp
    10fc:	48 83 ec 20          	sub    $0x20,%rsp
    1100:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
    1104:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  char *os;

  os = s;
    1108:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    110c:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  while((*s++ = *t++) != 0)
    1110:	90                   	nop
    1111:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
    1115:	48 8d 42 01          	lea    0x1(%rdx),%rax
    1119:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
    111d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    1121:	48 8d 48 01          	lea    0x1(%rax),%rcx
    1125:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
    1129:	0f b6 12             	movzbl (%rdx),%edx
    112c:	88 10                	mov    %dl,(%rax)
    112e:	0f b6 00             	movzbl (%rax),%eax
    1131:	84 c0                	test   %al,%al
    1133:	75 dc                	jne    1111 <strcpy+0x1d>
    ;
  return os;
    1135:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
    1139:	c9                   	leaveq 
    113a:	c3                   	retq   

000000000000113b <strcmp>:

int
strcmp(const char *p, const char *q)
{
    113b:	f3 0f 1e fa          	endbr64 
    113f:	55                   	push   %rbp
    1140:	48 89 e5             	mov    %rsp,%rbp
    1143:	48 83 ec 10          	sub    $0x10,%rsp
    1147:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
    114b:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  while(*p && *p == *q)
    114f:	eb 0a                	jmp    115b <strcmp+0x20>
    p++, q++;
    1151:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
    1156:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
  while(*p && *p == *q)
    115b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    115f:	0f b6 00             	movzbl (%rax),%eax
    1162:	84 c0                	test   %al,%al
    1164:	74 12                	je     1178 <strcmp+0x3d>
    1166:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    116a:	0f b6 10             	movzbl (%rax),%edx
    116d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1171:	0f b6 00             	movzbl (%rax),%eax
    1174:	38 c2                	cmp    %al,%dl
    1176:	74 d9                	je     1151 <strcmp+0x16>
  return (uchar)*p - (uchar)*q;
    1178:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    117c:	0f b6 00             	movzbl (%rax),%eax
    117f:	0f b6 d0             	movzbl %al,%edx
    1182:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1186:	0f b6 00             	movzbl (%rax),%eax
    1189:	0f b6 c0             	movzbl %al,%eax
    118c:	29 c2                	sub    %eax,%edx
    118e:	89 d0                	mov    %edx,%eax
}
    1190:	c9                   	leaveq 
    1191:	c3                   	retq   

0000000000001192 <strlen>:

uint
strlen(char *s)
{
    1192:	f3 0f 1e fa          	endbr64 
    1196:	55                   	push   %rbp
    1197:	48 89 e5             	mov    %rsp,%rbp
    119a:	48 83 ec 18          	sub    $0x18,%rsp
    119e:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  int n;

  for(n = 0; s[n]; n++)
    11a2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
    11a9:	eb 04                	jmp    11af <strlen+0x1d>
    11ab:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
    11af:	8b 45 fc             	mov    -0x4(%rbp),%eax
    11b2:	48 63 d0             	movslq %eax,%rdx
    11b5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    11b9:	48 01 d0             	add    %rdx,%rax
    11bc:	0f b6 00             	movzbl (%rax),%eax
    11bf:	84 c0                	test   %al,%al
    11c1:	75 e8                	jne    11ab <strlen+0x19>
    ;
  return n;
    11c3:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
    11c6:	c9                   	leaveq 
    11c7:	c3                   	retq   

00000000000011c8 <memset>:

void*
memset(void *dst, int c, uint n)
{
    11c8:	f3 0f 1e fa          	endbr64 
    11cc:	55                   	push   %rbp
    11cd:	48 89 e5             	mov    %rsp,%rbp
    11d0:	48 83 ec 10          	sub    $0x10,%rsp
    11d4:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
    11d8:	89 75 f4             	mov    %esi,-0xc(%rbp)
    11db:	89 55 f0             	mov    %edx,-0x10(%rbp)
  stosb(dst, c, n);
    11de:	8b 55 f0             	mov    -0x10(%rbp),%edx
    11e1:	8b 4d f4             	mov    -0xc(%rbp),%ecx
    11e4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    11e8:	89 ce                	mov    %ecx,%esi
    11ea:	48 89 c7             	mov    %rax,%rdi
    11ed:	48 b8 ba 10 00 00 00 	movabs $0x10ba,%rax
    11f4:	00 00 00 
    11f7:	ff d0                	callq  *%rax
  return dst;
    11f9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
    11fd:	c9                   	leaveq 
    11fe:	c3                   	retq   

00000000000011ff <strchr>:

char*
strchr(const char *s, char c)
{
    11ff:	f3 0f 1e fa          	endbr64 
    1203:	55                   	push   %rbp
    1204:	48 89 e5             	mov    %rsp,%rbp
    1207:	48 83 ec 10          	sub    $0x10,%rsp
    120b:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
    120f:	89 f0                	mov    %esi,%eax
    1211:	88 45 f4             	mov    %al,-0xc(%rbp)
  for(; *s; s++)
    1214:	eb 17                	jmp    122d <strchr+0x2e>
    if(*s == c)
    1216:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    121a:	0f b6 00             	movzbl (%rax),%eax
    121d:	38 45 f4             	cmp    %al,-0xc(%rbp)
    1220:	75 06                	jne    1228 <strchr+0x29>
      return (char*)s;
    1222:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1226:	eb 15                	jmp    123d <strchr+0x3e>
  for(; *s; s++)
    1228:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
    122d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1231:	0f b6 00             	movzbl (%rax),%eax
    1234:	84 c0                	test   %al,%al
    1236:	75 de                	jne    1216 <strchr+0x17>
  return 0;
    1238:	b8 00 00 00 00       	mov    $0x0,%eax
}
    123d:	c9                   	leaveq 
    123e:	c3                   	retq   

000000000000123f <gets>:

char*
gets(char *buf, int max)
{
    123f:	f3 0f 1e fa          	endbr64 
    1243:	55                   	push   %rbp
    1244:	48 89 e5             	mov    %rsp,%rbp
    1247:	48 83 ec 20          	sub    $0x20,%rsp
    124b:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
    124f:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    1252:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
    1259:	eb 4f                	jmp    12aa <gets+0x6b>
    cc = read(0, &c, 1);
    125b:	48 8d 45 f7          	lea    -0x9(%rbp),%rax
    125f:	ba 01 00 00 00       	mov    $0x1,%edx
    1264:	48 89 c6             	mov    %rax,%rsi
    1267:	bf 00 00 00 00       	mov    $0x0,%edi
    126c:	48 b8 24 14 00 00 00 	movabs $0x1424,%rax
    1273:	00 00 00 
    1276:	ff d0                	callq  *%rax
    1278:	89 45 f8             	mov    %eax,-0x8(%rbp)
    if(cc < 1)
    127b:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
    127f:	7e 36                	jle    12b7 <gets+0x78>
      break;
    buf[i++] = c;
    1281:	8b 45 fc             	mov    -0x4(%rbp),%eax
    1284:	8d 50 01             	lea    0x1(%rax),%edx
    1287:	89 55 fc             	mov    %edx,-0x4(%rbp)
    128a:	48 63 d0             	movslq %eax,%rdx
    128d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    1291:	48 01 c2             	add    %rax,%rdx
    1294:	0f b6 45 f7          	movzbl -0x9(%rbp),%eax
    1298:	88 02                	mov    %al,(%rdx)
    if(c == '\n' || c == '\r')
    129a:	0f b6 45 f7          	movzbl -0x9(%rbp),%eax
    129e:	3c 0a                	cmp    $0xa,%al
    12a0:	74 16                	je     12b8 <gets+0x79>
    12a2:	0f b6 45 f7          	movzbl -0x9(%rbp),%eax
    12a6:	3c 0d                	cmp    $0xd,%al
    12a8:	74 0e                	je     12b8 <gets+0x79>
  for(i=0; i+1 < max; ){
    12aa:	8b 45 fc             	mov    -0x4(%rbp),%eax
    12ad:	83 c0 01             	add    $0x1,%eax
    12b0:	39 45 e4             	cmp    %eax,-0x1c(%rbp)
    12b3:	7f a6                	jg     125b <gets+0x1c>
    12b5:	eb 01                	jmp    12b8 <gets+0x79>
      break;
    12b7:	90                   	nop
      break;
  }
  buf[i] = '\0';
    12b8:	8b 45 fc             	mov    -0x4(%rbp),%eax
    12bb:	48 63 d0             	movslq %eax,%rdx
    12be:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    12c2:	48 01 d0             	add    %rdx,%rax
    12c5:	c6 00 00             	movb   $0x0,(%rax)
  return buf;
    12c8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
    12cc:	c9                   	leaveq 
    12cd:	c3                   	retq   

00000000000012ce <stat>:

int
stat(char *n, struct stat *st)
{
    12ce:	f3 0f 1e fa          	endbr64 
    12d2:	55                   	push   %rbp
    12d3:	48 89 e5             	mov    %rsp,%rbp
    12d6:	48 83 ec 20          	sub    $0x20,%rsp
    12da:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
    12de:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  int fd;
  int r;

  fd = open(n, O_RDONLY);
    12e2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    12e6:	be 00 00 00 00       	mov    $0x0,%esi
    12eb:	48 89 c7             	mov    %rax,%rdi
    12ee:	48 b8 65 14 00 00 00 	movabs $0x1465,%rax
    12f5:	00 00 00 
    12f8:	ff d0                	callq  *%rax
    12fa:	89 45 fc             	mov    %eax,-0x4(%rbp)
  if(fd < 0)
    12fd:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
    1301:	79 07                	jns    130a <stat+0x3c>
    return -1;
    1303:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    1308:	eb 2f                	jmp    1339 <stat+0x6b>
  r = fstat(fd, st);
    130a:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
    130e:	8b 45 fc             	mov    -0x4(%rbp),%eax
    1311:	48 89 d6             	mov    %rdx,%rsi
    1314:	89 c7                	mov    %eax,%edi
    1316:	48 b8 8c 14 00 00 00 	movabs $0x148c,%rax
    131d:	00 00 00 
    1320:	ff d0                	callq  *%rax
    1322:	89 45 f8             	mov    %eax,-0x8(%rbp)
  close(fd);
    1325:	8b 45 fc             	mov    -0x4(%rbp),%eax
    1328:	89 c7                	mov    %eax,%edi
    132a:	48 b8 3e 14 00 00 00 	movabs $0x143e,%rax
    1331:	00 00 00 
    1334:	ff d0                	callq  *%rax
  return r;
    1336:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
    1339:	c9                   	leaveq 
    133a:	c3                   	retq   

000000000000133b <atoi>:

int
atoi(const char *s)
{
    133b:	f3 0f 1e fa          	endbr64 
    133f:	55                   	push   %rbp
    1340:	48 89 e5             	mov    %rsp,%rbp
    1343:	48 83 ec 18          	sub    $0x18,%rsp
    1347:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  int n;

  n = 0;
    134b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  while('0' <= *s && *s <= '9')
    1352:	eb 28                	jmp    137c <atoi+0x41>
    n = n*10 + *s++ - '0';
    1354:	8b 55 fc             	mov    -0x4(%rbp),%edx
    1357:	89 d0                	mov    %edx,%eax
    1359:	c1 e0 02             	shl    $0x2,%eax
    135c:	01 d0                	add    %edx,%eax
    135e:	01 c0                	add    %eax,%eax
    1360:	89 c1                	mov    %eax,%ecx
    1362:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    1366:	48 8d 50 01          	lea    0x1(%rax),%rdx
    136a:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
    136e:	0f b6 00             	movzbl (%rax),%eax
    1371:	0f be c0             	movsbl %al,%eax
    1374:	01 c8                	add    %ecx,%eax
    1376:	83 e8 30             	sub    $0x30,%eax
    1379:	89 45 fc             	mov    %eax,-0x4(%rbp)
  while('0' <= *s && *s <= '9')
    137c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    1380:	0f b6 00             	movzbl (%rax),%eax
    1383:	3c 2f                	cmp    $0x2f,%al
    1385:	7e 0b                	jle    1392 <atoi+0x57>
    1387:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    138b:	0f b6 00             	movzbl (%rax),%eax
    138e:	3c 39                	cmp    $0x39,%al
    1390:	7e c2                	jle    1354 <atoi+0x19>
  return n;
    1392:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
    1395:	c9                   	leaveq 
    1396:	c3                   	retq   

0000000000001397 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
    1397:	f3 0f 1e fa          	endbr64 
    139b:	55                   	push   %rbp
    139c:	48 89 e5             	mov    %rsp,%rbp
    139f:	48 83 ec 28          	sub    $0x28,%rsp
    13a3:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
    13a7:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
    13ab:	89 55 dc             	mov    %edx,-0x24(%rbp)
  char *dst, *src;

  dst = vdst;
    13ae:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    13b2:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  src = vsrc;
    13b6:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
    13ba:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
  while(n-- > 0)
    13be:	eb 1d                	jmp    13dd <memmove+0x46>
    *dst++ = *src++;
    13c0:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
    13c4:	48 8d 42 01          	lea    0x1(%rdx),%rax
    13c8:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
    13cc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    13d0:	48 8d 48 01          	lea    0x1(%rax),%rcx
    13d4:	48 89 4d f8          	mov    %rcx,-0x8(%rbp)
    13d8:	0f b6 12             	movzbl (%rdx),%edx
    13db:	88 10                	mov    %dl,(%rax)
  while(n-- > 0)
    13dd:	8b 45 dc             	mov    -0x24(%rbp),%eax
    13e0:	8d 50 ff             	lea    -0x1(%rax),%edx
    13e3:	89 55 dc             	mov    %edx,-0x24(%rbp)
    13e6:	85 c0                	test   %eax,%eax
    13e8:	7f d6                	jg     13c0 <memmove+0x29>
  return vdst;
    13ea:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
    13ee:	c9                   	leaveq 
    13ef:	c3                   	retq   

00000000000013f0 <fork>:
    mov $SYS_ ## name, %rax; \
    mov %rcx, %r10 ;\
    syscall		  ;\
    ret

SYSCALL(fork)
    13f0:	48 c7 c0 01 00 00 00 	mov    $0x1,%rax
    13f7:	49 89 ca             	mov    %rcx,%r10
    13fa:	0f 05                	syscall 
    13fc:	c3                   	retq   

00000000000013fd <exit>:
SYSCALL(exit)
    13fd:	48 c7 c0 02 00 00 00 	mov    $0x2,%rax
    1404:	49 89 ca             	mov    %rcx,%r10
    1407:	0f 05                	syscall 
    1409:	c3                   	retq   

000000000000140a <wait>:
SYSCALL(wait)
    140a:	48 c7 c0 03 00 00 00 	mov    $0x3,%rax
    1411:	49 89 ca             	mov    %rcx,%r10
    1414:	0f 05                	syscall 
    1416:	c3                   	retq   

0000000000001417 <pipe>:
SYSCALL(pipe)
    1417:	48 c7 c0 04 00 00 00 	mov    $0x4,%rax
    141e:	49 89 ca             	mov    %rcx,%r10
    1421:	0f 05                	syscall 
    1423:	c3                   	retq   

0000000000001424 <read>:
SYSCALL(read)
    1424:	48 c7 c0 05 00 00 00 	mov    $0x5,%rax
    142b:	49 89 ca             	mov    %rcx,%r10
    142e:	0f 05                	syscall 
    1430:	c3                   	retq   

0000000000001431 <write>:
SYSCALL(write)
    1431:	48 c7 c0 10 00 00 00 	mov    $0x10,%rax
    1438:	49 89 ca             	mov    %rcx,%r10
    143b:	0f 05                	syscall 
    143d:	c3                   	retq   

000000000000143e <close>:
SYSCALL(close)
    143e:	48 c7 c0 15 00 00 00 	mov    $0x15,%rax
    1445:	49 89 ca             	mov    %rcx,%r10
    1448:	0f 05                	syscall 
    144a:	c3                   	retq   

000000000000144b <kill>:
SYSCALL(kill)
    144b:	48 c7 c0 06 00 00 00 	mov    $0x6,%rax
    1452:	49 89 ca             	mov    %rcx,%r10
    1455:	0f 05                	syscall 
    1457:	c3                   	retq   

0000000000001458 <exec>:
SYSCALL(exec)
    1458:	48 c7 c0 07 00 00 00 	mov    $0x7,%rax
    145f:	49 89 ca             	mov    %rcx,%r10
    1462:	0f 05                	syscall 
    1464:	c3                   	retq   

0000000000001465 <open>:
SYSCALL(open)
    1465:	48 c7 c0 0f 00 00 00 	mov    $0xf,%rax
    146c:	49 89 ca             	mov    %rcx,%r10
    146f:	0f 05                	syscall 
    1471:	c3                   	retq   

0000000000001472 <mknod>:
SYSCALL(mknod)
    1472:	48 c7 c0 11 00 00 00 	mov    $0x11,%rax
    1479:	49 89 ca             	mov    %rcx,%r10
    147c:	0f 05                	syscall 
    147e:	c3                   	retq   

000000000000147f <unlink>:
SYSCALL(unlink)
    147f:	48 c7 c0 12 00 00 00 	mov    $0x12,%rax
    1486:	49 89 ca             	mov    %rcx,%r10
    1489:	0f 05                	syscall 
    148b:	c3                   	retq   

000000000000148c <fstat>:
SYSCALL(fstat)
    148c:	48 c7 c0 08 00 00 00 	mov    $0x8,%rax
    1493:	49 89 ca             	mov    %rcx,%r10
    1496:	0f 05                	syscall 
    1498:	c3                   	retq   

0000000000001499 <link>:
SYSCALL(link)
    1499:	48 c7 c0 13 00 00 00 	mov    $0x13,%rax
    14a0:	49 89 ca             	mov    %rcx,%r10
    14a3:	0f 05                	syscall 
    14a5:	c3                   	retq   

00000000000014a6 <mkdir>:
SYSCALL(mkdir)
    14a6:	48 c7 c0 14 00 00 00 	mov    $0x14,%rax
    14ad:	49 89 ca             	mov    %rcx,%r10
    14b0:	0f 05                	syscall 
    14b2:	c3                   	retq   

00000000000014b3 <chdir>:
SYSCALL(chdir)
    14b3:	48 c7 c0 09 00 00 00 	mov    $0x9,%rax
    14ba:	49 89 ca             	mov    %rcx,%r10
    14bd:	0f 05                	syscall 
    14bf:	c3                   	retq   

00000000000014c0 <dup>:
SYSCALL(dup)
    14c0:	48 c7 c0 0a 00 00 00 	mov    $0xa,%rax
    14c7:	49 89 ca             	mov    %rcx,%r10
    14ca:	0f 05                	syscall 
    14cc:	c3                   	retq   

00000000000014cd <getpid>:
SYSCALL(getpid)
    14cd:	48 c7 c0 0b 00 00 00 	mov    $0xb,%rax
    14d4:	49 89 ca             	mov    %rcx,%r10
    14d7:	0f 05                	syscall 
    14d9:	c3                   	retq   

00000000000014da <sbrk>:
SYSCALL(sbrk)
    14da:	48 c7 c0 0c 00 00 00 	mov    $0xc,%rax
    14e1:	49 89 ca             	mov    %rcx,%r10
    14e4:	0f 05                	syscall 
    14e6:	c3                   	retq   

00000000000014e7 <sleep>:
SYSCALL(sleep)
    14e7:	48 c7 c0 0d 00 00 00 	mov    $0xd,%rax
    14ee:	49 89 ca             	mov    %rcx,%r10
    14f1:	0f 05                	syscall 
    14f3:	c3                   	retq   

00000000000014f4 <uptime>:
SYSCALL(uptime)
    14f4:	48 c7 c0 0e 00 00 00 	mov    $0xe,%rax
    14fb:	49 89 ca             	mov    %rcx,%r10
    14fe:	0f 05                	syscall 
    1500:	c3                   	retq   

0000000000001501 <aread>:
SYSCALL(aread)
    1501:	48 c7 c0 16 00 00 00 	mov    $0x16,%rax
    1508:	49 89 ca             	mov    %rcx,%r10
    150b:	0f 05                	syscall 
    150d:	c3                   	retq   

000000000000150e <putc>:

#include <stdarg.h>

static void
putc(int fd, char c)
{
    150e:	f3 0f 1e fa          	endbr64 
    1512:	55                   	push   %rbp
    1513:	48 89 e5             	mov    %rsp,%rbp
    1516:	48 83 ec 10          	sub    $0x10,%rsp
    151a:	89 7d fc             	mov    %edi,-0x4(%rbp)
    151d:	89 f0                	mov    %esi,%eax
    151f:	88 45 f8             	mov    %al,-0x8(%rbp)
  write(fd, &c, 1);
    1522:	48 8d 4d f8          	lea    -0x8(%rbp),%rcx
    1526:	8b 45 fc             	mov    -0x4(%rbp),%eax
    1529:	ba 01 00 00 00       	mov    $0x1,%edx
    152e:	48 89 ce             	mov    %rcx,%rsi
    1531:	89 c7                	mov    %eax,%edi
    1533:	48 b8 31 14 00 00 00 	movabs $0x1431,%rax
    153a:	00 00 00 
    153d:	ff d0                	callq  *%rax
}
    153f:	90                   	nop
    1540:	c9                   	leaveq 
    1541:	c3                   	retq   

0000000000001542 <print_x64>:

static char digits[] = "0123456789abcdef";

  static void
print_x64(int fd, addr_t x)
{
    1542:	f3 0f 1e fa          	endbr64 
    1546:	55                   	push   %rbp
    1547:	48 89 e5             	mov    %rsp,%rbp
    154a:	48 83 ec 20          	sub    $0x20,%rsp
    154e:	89 7d ec             	mov    %edi,-0x14(%rbp)
    1551:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  int i;
  for (i = 0; i < (sizeof(addr_t) * 2); i++, x <<= 4)
    1555:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
    155c:	eb 35                	jmp    1593 <print_x64+0x51>
    putc(fd, digits[x >> (sizeof(addr_t) * 8 - 4)]);
    155e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
    1562:	48 c1 e8 3c          	shr    $0x3c,%rax
    1566:	48 ba 60 21 00 00 00 	movabs $0x2160,%rdx
    156d:	00 00 00 
    1570:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax
    1574:	0f be d0             	movsbl %al,%edx
    1577:	8b 45 ec             	mov    -0x14(%rbp),%eax
    157a:	89 d6                	mov    %edx,%esi
    157c:	89 c7                	mov    %eax,%edi
    157e:	48 b8 0e 15 00 00 00 	movabs $0x150e,%rax
    1585:	00 00 00 
    1588:	ff d0                	callq  *%rax
  for (i = 0; i < (sizeof(addr_t) * 2); i++, x <<= 4)
    158a:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
    158e:	48 c1 65 e0 04       	shlq   $0x4,-0x20(%rbp)
    1593:	8b 45 fc             	mov    -0x4(%rbp),%eax
    1596:	83 f8 0f             	cmp    $0xf,%eax
    1599:	76 c3                	jbe    155e <print_x64+0x1c>
}
    159b:	90                   	nop
    159c:	90                   	nop
    159d:	c9                   	leaveq 
    159e:	c3                   	retq   

000000000000159f <print_x32>:

  static void
print_x32(int fd, uint x)
{
    159f:	f3 0f 1e fa          	endbr64 
    15a3:	55                   	push   %rbp
    15a4:	48 89 e5             	mov    %rsp,%rbp
    15a7:	48 83 ec 20          	sub    $0x20,%rsp
    15ab:	89 7d ec             	mov    %edi,-0x14(%rbp)
    15ae:	89 75 e8             	mov    %esi,-0x18(%rbp)
  int i;
  for (i = 0; i < (sizeof(uint) * 2); i++, x <<= 4)
    15b1:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
    15b8:	eb 36                	jmp    15f0 <print_x32+0x51>
    putc(fd, digits[x >> (sizeof(uint) * 8 - 4)]);
    15ba:	8b 45 e8             	mov    -0x18(%rbp),%eax
    15bd:	c1 e8 1c             	shr    $0x1c,%eax
    15c0:	89 c2                	mov    %eax,%edx
    15c2:	48 b8 60 21 00 00 00 	movabs $0x2160,%rax
    15c9:	00 00 00 
    15cc:	89 d2                	mov    %edx,%edx
    15ce:	0f b6 04 10          	movzbl (%rax,%rdx,1),%eax
    15d2:	0f be d0             	movsbl %al,%edx
    15d5:	8b 45 ec             	mov    -0x14(%rbp),%eax
    15d8:	89 d6                	mov    %edx,%esi
    15da:	89 c7                	mov    %eax,%edi
    15dc:	48 b8 0e 15 00 00 00 	movabs $0x150e,%rax
    15e3:	00 00 00 
    15e6:	ff d0                	callq  *%rax
  for (i = 0; i < (sizeof(uint) * 2); i++, x <<= 4)
    15e8:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
    15ec:	c1 65 e8 04          	shll   $0x4,-0x18(%rbp)
    15f0:	8b 45 fc             	mov    -0x4(%rbp),%eax
    15f3:	83 f8 07             	cmp    $0x7,%eax
    15f6:	76 c2                	jbe    15ba <print_x32+0x1b>
}
    15f8:	90                   	nop
    15f9:	90                   	nop
    15fa:	c9                   	leaveq 
    15fb:	c3                   	retq   

00000000000015fc <print_d>:

  static void
print_d(int fd, int v)
{
    15fc:	f3 0f 1e fa          	endbr64 
    1600:	55                   	push   %rbp
    1601:	48 89 e5             	mov    %rsp,%rbp
    1604:	48 83 ec 30          	sub    $0x30,%rsp
    1608:	89 7d dc             	mov    %edi,-0x24(%rbp)
    160b:	89 75 d8             	mov    %esi,-0x28(%rbp)
  char buf[16];
  int64 x = v;
    160e:	8b 45 d8             	mov    -0x28(%rbp),%eax
    1611:	48 98                	cltq   
    1613:	48 89 45 f8          	mov    %rax,-0x8(%rbp)

  if (v < 0)
    1617:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
    161b:	79 04                	jns    1621 <print_d+0x25>
    x = -x;
    161d:	48 f7 5d f8          	negq   -0x8(%rbp)

  int i = 0;
    1621:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%rbp)
  do {
    buf[i++] = digits[x % 10];
    1628:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
    162c:	48 ba 67 66 66 66 66 	movabs $0x6666666666666667,%rdx
    1633:	66 66 66 
    1636:	48 89 c8             	mov    %rcx,%rax
    1639:	48 f7 ea             	imul   %rdx
    163c:	48 c1 fa 02          	sar    $0x2,%rdx
    1640:	48 89 c8             	mov    %rcx,%rax
    1643:	48 c1 f8 3f          	sar    $0x3f,%rax
    1647:	48 29 c2             	sub    %rax,%rdx
    164a:	48 89 d0             	mov    %rdx,%rax
    164d:	48 c1 e0 02          	shl    $0x2,%rax
    1651:	48 01 d0             	add    %rdx,%rax
    1654:	48 01 c0             	add    %rax,%rax
    1657:	48 29 c1             	sub    %rax,%rcx
    165a:	48 89 ca             	mov    %rcx,%rdx
    165d:	8b 45 f4             	mov    -0xc(%rbp),%eax
    1660:	8d 48 01             	lea    0x1(%rax),%ecx
    1663:	89 4d f4             	mov    %ecx,-0xc(%rbp)
    1666:	48 b9 60 21 00 00 00 	movabs $0x2160,%rcx
    166d:	00 00 00 
    1670:	0f b6 14 11          	movzbl (%rcx,%rdx,1),%edx
    1674:	48 98                	cltq   
    1676:	88 54 05 e0          	mov    %dl,-0x20(%rbp,%rax,1)
    x /= 10;
    167a:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
    167e:	48 ba 67 66 66 66 66 	movabs $0x6666666666666667,%rdx
    1685:	66 66 66 
    1688:	48 89 c8             	mov    %rcx,%rax
    168b:	48 f7 ea             	imul   %rdx
    168e:	48 c1 fa 02          	sar    $0x2,%rdx
    1692:	48 89 c8             	mov    %rcx,%rax
    1695:	48 c1 f8 3f          	sar    $0x3f,%rax
    1699:	48 29 c2             	sub    %rax,%rdx
    169c:	48 89 d0             	mov    %rdx,%rax
    169f:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  } while(x != 0);
    16a3:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
    16a8:	0f 85 7a ff ff ff    	jne    1628 <print_d+0x2c>

  if (v < 0)
    16ae:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
    16b2:	79 32                	jns    16e6 <print_d+0xea>
    buf[i++] = '-';
    16b4:	8b 45 f4             	mov    -0xc(%rbp),%eax
    16b7:	8d 50 01             	lea    0x1(%rax),%edx
    16ba:	89 55 f4             	mov    %edx,-0xc(%rbp)
    16bd:	48 98                	cltq   
    16bf:	c6 44 05 e0 2d       	movb   $0x2d,-0x20(%rbp,%rax,1)

  while (--i >= 0)
    16c4:	eb 20                	jmp    16e6 <print_d+0xea>
    putc(fd, buf[i]);
    16c6:	8b 45 f4             	mov    -0xc(%rbp),%eax
    16c9:	48 98                	cltq   
    16cb:	0f b6 44 05 e0       	movzbl -0x20(%rbp,%rax,1),%eax
    16d0:	0f be d0             	movsbl %al,%edx
    16d3:	8b 45 dc             	mov    -0x24(%rbp),%eax
    16d6:	89 d6                	mov    %edx,%esi
    16d8:	89 c7                	mov    %eax,%edi
    16da:	48 b8 0e 15 00 00 00 	movabs $0x150e,%rax
    16e1:	00 00 00 
    16e4:	ff d0                	callq  *%rax
  while (--i >= 0)
    16e6:	83 6d f4 01          	subl   $0x1,-0xc(%rbp)
    16ea:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
    16ee:	79 d6                	jns    16c6 <print_d+0xca>
}
    16f0:	90                   	nop
    16f1:	90                   	nop
    16f2:	c9                   	leaveq 
    16f3:	c3                   	retq   

00000000000016f4 <printf>:
// Print to the given fd. Only understands %d, %x, %p, %s.
  void
printf(int fd, char *fmt, ...)
{
    16f4:	f3 0f 1e fa          	endbr64 
    16f8:	55                   	push   %rbp
    16f9:	48 89 e5             	mov    %rsp,%rbp
    16fc:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
    1703:	89 bd 1c ff ff ff    	mov    %edi,-0xe4(%rbp)
    1709:	48 89 b5 10 ff ff ff 	mov    %rsi,-0xf0(%rbp)
    1710:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
    1717:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
    171e:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
    1725:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
    172c:	84 c0                	test   %al,%al
    172e:	74 20                	je     1750 <printf+0x5c>
    1730:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
    1734:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
    1738:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
    173c:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
    1740:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
    1744:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
    1748:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
    174c:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  va_list ap;
  int i, c;
  char *s;

  va_start(ap, fmt);
    1750:	c7 85 20 ff ff ff 10 	movl   $0x10,-0xe0(%rbp)
    1757:	00 00 00 
    175a:	c7 85 24 ff ff ff 30 	movl   $0x30,-0xdc(%rbp)
    1761:	00 00 00 
    1764:	48 8d 45 10          	lea    0x10(%rbp),%rax
    1768:	48 89 85 28 ff ff ff 	mov    %rax,-0xd8(%rbp)
    176f:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
    1776:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  for (i = 0; (c = fmt[i] & 0xff) != 0; i++) {
    177d:	c7 85 4c ff ff ff 00 	movl   $0x0,-0xb4(%rbp)
    1784:	00 00 00 
    1787:	e9 41 03 00 00       	jmpq   1acd <printf+0x3d9>
    if (c != '%') {
    178c:	83 bd 3c ff ff ff 25 	cmpl   $0x25,-0xc4(%rbp)
    1793:	74 24                	je     17b9 <printf+0xc5>
      putc(fd, c);
    1795:	8b 85 3c ff ff ff    	mov    -0xc4(%rbp),%eax
    179b:	0f be d0             	movsbl %al,%edx
    179e:	8b 85 1c ff ff ff    	mov    -0xe4(%rbp),%eax
    17a4:	89 d6                	mov    %edx,%esi
    17a6:	89 c7                	mov    %eax,%edi
    17a8:	48 b8 0e 15 00 00 00 	movabs $0x150e,%rax
    17af:	00 00 00 
    17b2:	ff d0                	callq  *%rax
      continue;
    17b4:	e9 0d 03 00 00       	jmpq   1ac6 <printf+0x3d2>
    }
    c = fmt[++i] & 0xff;
    17b9:	83 85 4c ff ff ff 01 	addl   $0x1,-0xb4(%rbp)
    17c0:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
    17c6:	48 63 d0             	movslq %eax,%rdx
    17c9:	48 8b 85 10 ff ff ff 	mov    -0xf0(%rbp),%rax
    17d0:	48 01 d0             	add    %rdx,%rax
    17d3:	0f b6 00             	movzbl (%rax),%eax
    17d6:	0f be c0             	movsbl %al,%eax
    17d9:	25 ff 00 00 00       	and    $0xff,%eax
    17de:	89 85 3c ff ff ff    	mov    %eax,-0xc4(%rbp)
    if (c == 0)
    17e4:	83 bd 3c ff ff ff 00 	cmpl   $0x0,-0xc4(%rbp)
    17eb:	0f 84 0f 03 00 00    	je     1b00 <printf+0x40c>
      break;
    switch(c) {
    17f1:	83 bd 3c ff ff ff 25 	cmpl   $0x25,-0xc4(%rbp)
    17f8:	0f 84 74 02 00 00    	je     1a72 <printf+0x37e>
    17fe:	83 bd 3c ff ff ff 25 	cmpl   $0x25,-0xc4(%rbp)
    1805:	0f 8c 82 02 00 00    	jl     1a8d <printf+0x399>
    180b:	83 bd 3c ff ff ff 78 	cmpl   $0x78,-0xc4(%rbp)
    1812:	0f 8f 75 02 00 00    	jg     1a8d <printf+0x399>
    1818:	83 bd 3c ff ff ff 63 	cmpl   $0x63,-0xc4(%rbp)
    181f:	0f 8c 68 02 00 00    	jl     1a8d <printf+0x399>
    1825:	8b 85 3c ff ff ff    	mov    -0xc4(%rbp),%eax
    182b:	83 e8 63             	sub    $0x63,%eax
    182e:	83 f8 15             	cmp    $0x15,%eax
    1831:	0f 87 56 02 00 00    	ja     1a8d <printf+0x399>
    1837:	89 c0                	mov    %eax,%eax
    1839:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
    1840:	00 
    1841:	48 b8 38 1e 00 00 00 	movabs $0x1e38,%rax
    1848:	00 00 00 
    184b:	48 01 d0             	add    %rdx,%rax
    184e:	48 8b 00             	mov    (%rax),%rax
    1851:	3e ff e0             	notrack jmpq *%rax
    case 'c':
      putc(fd, va_arg(ap, int));
    1854:	8b 85 20 ff ff ff    	mov    -0xe0(%rbp),%eax
    185a:	83 f8 2f             	cmp    $0x2f,%eax
    185d:	77 23                	ja     1882 <printf+0x18e>
    185f:	48 8b 85 30 ff ff ff 	mov    -0xd0(%rbp),%rax
    1866:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    186c:	89 d2                	mov    %edx,%edx
    186e:	48 01 d0             	add    %rdx,%rax
    1871:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    1877:	83 c2 08             	add    $0x8,%edx
    187a:	89 95 20 ff ff ff    	mov    %edx,-0xe0(%rbp)
    1880:	eb 12                	jmp    1894 <printf+0x1a0>
    1882:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
    1889:	48 8d 50 08          	lea    0x8(%rax),%rdx
    188d:	48 89 95 28 ff ff ff 	mov    %rdx,-0xd8(%rbp)
    1894:	8b 00                	mov    (%rax),%eax
    1896:	0f be d0             	movsbl %al,%edx
    1899:	8b 85 1c ff ff ff    	mov    -0xe4(%rbp),%eax
    189f:	89 d6                	mov    %edx,%esi
    18a1:	89 c7                	mov    %eax,%edi
    18a3:	48 b8 0e 15 00 00 00 	movabs $0x150e,%rax
    18aa:	00 00 00 
    18ad:	ff d0                	callq  *%rax
      break;
    18af:	e9 12 02 00 00       	jmpq   1ac6 <printf+0x3d2>
    case 'd':
      print_d(fd, va_arg(ap, int));
    18b4:	8b 85 20 ff ff ff    	mov    -0xe0(%rbp),%eax
    18ba:	83 f8 2f             	cmp    $0x2f,%eax
    18bd:	77 23                	ja     18e2 <printf+0x1ee>
    18bf:	48 8b 85 30 ff ff ff 	mov    -0xd0(%rbp),%rax
    18c6:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    18cc:	89 d2                	mov    %edx,%edx
    18ce:	48 01 d0             	add    %rdx,%rax
    18d1:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    18d7:	83 c2 08             	add    $0x8,%edx
    18da:	89 95 20 ff ff ff    	mov    %edx,-0xe0(%rbp)
    18e0:	eb 12                	jmp    18f4 <printf+0x200>
    18e2:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
    18e9:	48 8d 50 08          	lea    0x8(%rax),%rdx
    18ed:	48 89 95 28 ff ff ff 	mov    %rdx,-0xd8(%rbp)
    18f4:	8b 10                	mov    (%rax),%edx
    18f6:	8b 85 1c ff ff ff    	mov    -0xe4(%rbp),%eax
    18fc:	89 d6                	mov    %edx,%esi
    18fe:	89 c7                	mov    %eax,%edi
    1900:	48 b8 fc 15 00 00 00 	movabs $0x15fc,%rax
    1907:	00 00 00 
    190a:	ff d0                	callq  *%rax
      break;
    190c:	e9 b5 01 00 00       	jmpq   1ac6 <printf+0x3d2>
    case 'x':
      print_x32(fd, va_arg(ap, uint));
    1911:	8b 85 20 ff ff ff    	mov    -0xe0(%rbp),%eax
    1917:	83 f8 2f             	cmp    $0x2f,%eax
    191a:	77 23                	ja     193f <printf+0x24b>
    191c:	48 8b 85 30 ff ff ff 	mov    -0xd0(%rbp),%rax
    1923:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    1929:	89 d2                	mov    %edx,%edx
    192b:	48 01 d0             	add    %rdx,%rax
    192e:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    1934:	83 c2 08             	add    $0x8,%edx
    1937:	89 95 20 ff ff ff    	mov    %edx,-0xe0(%rbp)
    193d:	eb 12                	jmp    1951 <printf+0x25d>
    193f:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
    1946:	48 8d 50 08          	lea    0x8(%rax),%rdx
    194a:	48 89 95 28 ff ff ff 	mov    %rdx,-0xd8(%rbp)
    1951:	8b 10                	mov    (%rax),%edx
    1953:	8b 85 1c ff ff ff    	mov    -0xe4(%rbp),%eax
    1959:	89 d6                	mov    %edx,%esi
    195b:	89 c7                	mov    %eax,%edi
    195d:	48 b8 9f 15 00 00 00 	movabs $0x159f,%rax
    1964:	00 00 00 
    1967:	ff d0                	callq  *%rax
      break;
    1969:	e9 58 01 00 00       	jmpq   1ac6 <printf+0x3d2>
    case 'p':
      print_x64(fd, va_arg(ap, addr_t));
    196e:	8b 85 20 ff ff ff    	mov    -0xe0(%rbp),%eax
    1974:	83 f8 2f             	cmp    $0x2f,%eax
    1977:	77 23                	ja     199c <printf+0x2a8>
    1979:	48 8b 85 30 ff ff ff 	mov    -0xd0(%rbp),%rax
    1980:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    1986:	89 d2                	mov    %edx,%edx
    1988:	48 01 d0             	add    %rdx,%rax
    198b:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    1991:	83 c2 08             	add    $0x8,%edx
    1994:	89 95 20 ff ff ff    	mov    %edx,-0xe0(%rbp)
    199a:	eb 12                	jmp    19ae <printf+0x2ba>
    199c:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
    19a3:	48 8d 50 08          	lea    0x8(%rax),%rdx
    19a7:	48 89 95 28 ff ff ff 	mov    %rdx,-0xd8(%rbp)
    19ae:	48 8b 10             	mov    (%rax),%rdx
    19b1:	8b 85 1c ff ff ff    	mov    -0xe4(%rbp),%eax
    19b7:	48 89 d6             	mov    %rdx,%rsi
    19ba:	89 c7                	mov    %eax,%edi
    19bc:	48 b8 42 15 00 00 00 	movabs $0x1542,%rax
    19c3:	00 00 00 
    19c6:	ff d0                	callq  *%rax
      break;
    19c8:	e9 f9 00 00 00       	jmpq   1ac6 <printf+0x3d2>
    case 's':
      if ((s = va_arg(ap, char*)) == 0)
    19cd:	8b 85 20 ff ff ff    	mov    -0xe0(%rbp),%eax
    19d3:	83 f8 2f             	cmp    $0x2f,%eax
    19d6:	77 23                	ja     19fb <printf+0x307>
    19d8:	48 8b 85 30 ff ff ff 	mov    -0xd0(%rbp),%rax
    19df:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    19e5:	89 d2                	mov    %edx,%edx
    19e7:	48 01 d0             	add    %rdx,%rax
    19ea:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    19f0:	83 c2 08             	add    $0x8,%edx
    19f3:	89 95 20 ff ff ff    	mov    %edx,-0xe0(%rbp)
    19f9:	eb 12                	jmp    1a0d <printf+0x319>
    19fb:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
    1a02:	48 8d 50 08          	lea    0x8(%rax),%rdx
    1a06:	48 89 95 28 ff ff ff 	mov    %rdx,-0xd8(%rbp)
    1a0d:	48 8b 00             	mov    (%rax),%rax
    1a10:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
    1a17:	48 83 bd 40 ff ff ff 	cmpq   $0x0,-0xc0(%rbp)
    1a1e:	00 
    1a1f:	75 41                	jne    1a62 <printf+0x36e>
        s = "(null)";
    1a21:	48 b8 30 1e 00 00 00 	movabs $0x1e30,%rax
    1a28:	00 00 00 
    1a2b:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
      while (*s)
    1a32:	eb 2e                	jmp    1a62 <printf+0x36e>
        putc(fd, *(s++));
    1a34:	48 8b 85 40 ff ff ff 	mov    -0xc0(%rbp),%rax
    1a3b:	48 8d 50 01          	lea    0x1(%rax),%rdx
    1a3f:	48 89 95 40 ff ff ff 	mov    %rdx,-0xc0(%rbp)
    1a46:	0f b6 00             	movzbl (%rax),%eax
    1a49:	0f be d0             	movsbl %al,%edx
    1a4c:	8b 85 1c ff ff ff    	mov    -0xe4(%rbp),%eax
    1a52:	89 d6                	mov    %edx,%esi
    1a54:	89 c7                	mov    %eax,%edi
    1a56:	48 b8 0e 15 00 00 00 	movabs $0x150e,%rax
    1a5d:	00 00 00 
    1a60:	ff d0                	callq  *%rax
      while (*s)
    1a62:	48 8b 85 40 ff ff ff 	mov    -0xc0(%rbp),%rax
    1a69:	0f b6 00             	movzbl (%rax),%eax
    1a6c:	84 c0                	test   %al,%al
    1a6e:	75 c4                	jne    1a34 <printf+0x340>
      break;
    1a70:	eb 54                	jmp    1ac6 <printf+0x3d2>
    case '%':
      putc(fd, '%');
    1a72:	8b 85 1c ff ff ff    	mov    -0xe4(%rbp),%eax
    1a78:	be 25 00 00 00       	mov    $0x25,%esi
    1a7d:	89 c7                	mov    %eax,%edi
    1a7f:	48 b8 0e 15 00 00 00 	movabs $0x150e,%rax
    1a86:	00 00 00 
    1a89:	ff d0                	callq  *%rax
      break;
    1a8b:	eb 39                	jmp    1ac6 <printf+0x3d2>
    default:
      // Print unknown % sequence to draw attention.
      putc(fd, '%');
    1a8d:	8b 85 1c ff ff ff    	mov    -0xe4(%rbp),%eax
    1a93:	be 25 00 00 00       	mov    $0x25,%esi
    1a98:	89 c7                	mov    %eax,%edi
    1a9a:	48 b8 0e 15 00 00 00 	movabs $0x150e,%rax
    1aa1:	00 00 00 
    1aa4:	ff d0                	callq  *%rax
      putc(fd, c);
    1aa6:	8b 85 3c ff ff ff    	mov    -0xc4(%rbp),%eax
    1aac:	0f be d0             	movsbl %al,%edx
    1aaf:	8b 85 1c ff ff ff    	mov    -0xe4(%rbp),%eax
    1ab5:	89 d6                	mov    %edx,%esi
    1ab7:	89 c7                	mov    %eax,%edi
    1ab9:	48 b8 0e 15 00 00 00 	movabs $0x150e,%rax
    1ac0:	00 00 00 
    1ac3:	ff d0                	callq  *%rax
      break;
    1ac5:	90                   	nop
  for (i = 0; (c = fmt[i] & 0xff) != 0; i++) {
    1ac6:	83 85 4c ff ff ff 01 	addl   $0x1,-0xb4(%rbp)
    1acd:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
    1ad3:	48 63 d0             	movslq %eax,%rdx
    1ad6:	48 8b 85 10 ff ff ff 	mov    -0xf0(%rbp),%rax
    1add:	48 01 d0             	add    %rdx,%rax
    1ae0:	0f b6 00             	movzbl (%rax),%eax
    1ae3:	0f be c0             	movsbl %al,%eax
    1ae6:	25 ff 00 00 00       	and    $0xff,%eax
    1aeb:	89 85 3c ff ff ff    	mov    %eax,-0xc4(%rbp)
    1af1:	83 bd 3c ff ff ff 00 	cmpl   $0x0,-0xc4(%rbp)
    1af8:	0f 85 8e fc ff ff    	jne    178c <printf+0x98>
    }
  }
}
    1afe:	eb 01                	jmp    1b01 <printf+0x40d>
      break;
    1b00:	90                   	nop
}
    1b01:	90                   	nop
    1b02:	c9                   	leaveq 
    1b03:	c3                   	retq   

0000000000001b04 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    1b04:	f3 0f 1e fa          	endbr64 
    1b08:	55                   	push   %rbp
    1b09:	48 89 e5             	mov    %rsp,%rbp
    1b0c:	48 83 ec 18          	sub    $0x18,%rsp
    1b10:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  Header *bp, *p;

  bp = (Header*)ap - 1;
    1b14:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    1b18:	48 83 e8 10          	sub    $0x10,%rax
    1b1c:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    1b20:	48 b8 90 21 00 00 00 	movabs $0x2190,%rax
    1b27:	00 00 00 
    1b2a:	48 8b 00             	mov    (%rax),%rax
    1b2d:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
    1b31:	eb 2f                	jmp    1b62 <free+0x5e>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    1b33:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1b37:	48 8b 00             	mov    (%rax),%rax
    1b3a:	48 39 45 f8          	cmp    %rax,-0x8(%rbp)
    1b3e:	72 17                	jb     1b57 <free+0x53>
    1b40:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1b44:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
    1b48:	77 2f                	ja     1b79 <free+0x75>
    1b4a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1b4e:	48 8b 00             	mov    (%rax),%rax
    1b51:	48 39 45 f0          	cmp    %rax,-0x10(%rbp)
    1b55:	72 22                	jb     1b79 <free+0x75>
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    1b57:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1b5b:	48 8b 00             	mov    (%rax),%rax
    1b5e:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
    1b62:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1b66:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
    1b6a:	76 c7                	jbe    1b33 <free+0x2f>
    1b6c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1b70:	48 8b 00             	mov    (%rax),%rax
    1b73:	48 39 45 f0          	cmp    %rax,-0x10(%rbp)
    1b77:	73 ba                	jae    1b33 <free+0x2f>
      break;
  if(bp + bp->s.size == p->s.ptr){
    1b79:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1b7d:	8b 40 08             	mov    0x8(%rax),%eax
    1b80:	89 c0                	mov    %eax,%eax
    1b82:	48 c1 e0 04          	shl    $0x4,%rax
    1b86:	48 89 c2             	mov    %rax,%rdx
    1b89:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1b8d:	48 01 c2             	add    %rax,%rdx
    1b90:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1b94:	48 8b 00             	mov    (%rax),%rax
    1b97:	48 39 c2             	cmp    %rax,%rdx
    1b9a:	75 2d                	jne    1bc9 <free+0xc5>
    bp->s.size += p->s.ptr->s.size;
    1b9c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1ba0:	8b 50 08             	mov    0x8(%rax),%edx
    1ba3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1ba7:	48 8b 00             	mov    (%rax),%rax
    1baa:	8b 40 08             	mov    0x8(%rax),%eax
    1bad:	01 c2                	add    %eax,%edx
    1baf:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1bb3:	89 50 08             	mov    %edx,0x8(%rax)
    bp->s.ptr = p->s.ptr->s.ptr;
    1bb6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1bba:	48 8b 00             	mov    (%rax),%rax
    1bbd:	48 8b 10             	mov    (%rax),%rdx
    1bc0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1bc4:	48 89 10             	mov    %rdx,(%rax)
    1bc7:	eb 0e                	jmp    1bd7 <free+0xd3>
  } else
    bp->s.ptr = p->s.ptr;
    1bc9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1bcd:	48 8b 10             	mov    (%rax),%rdx
    1bd0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1bd4:	48 89 10             	mov    %rdx,(%rax)
  if(p + p->s.size == bp){
    1bd7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1bdb:	8b 40 08             	mov    0x8(%rax),%eax
    1bde:	89 c0                	mov    %eax,%eax
    1be0:	48 c1 e0 04          	shl    $0x4,%rax
    1be4:	48 89 c2             	mov    %rax,%rdx
    1be7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1beb:	48 01 d0             	add    %rdx,%rax
    1bee:	48 39 45 f0          	cmp    %rax,-0x10(%rbp)
    1bf2:	75 27                	jne    1c1b <free+0x117>
    p->s.size += bp->s.size;
    1bf4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1bf8:	8b 50 08             	mov    0x8(%rax),%edx
    1bfb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1bff:	8b 40 08             	mov    0x8(%rax),%eax
    1c02:	01 c2                	add    %eax,%edx
    1c04:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1c08:	89 50 08             	mov    %edx,0x8(%rax)
    p->s.ptr = bp->s.ptr;
    1c0b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1c0f:	48 8b 10             	mov    (%rax),%rdx
    1c12:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1c16:	48 89 10             	mov    %rdx,(%rax)
    1c19:	eb 0b                	jmp    1c26 <free+0x122>
  } else
    p->s.ptr = bp;
    1c1b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1c1f:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
    1c23:	48 89 10             	mov    %rdx,(%rax)
  freep = p;
    1c26:	48 ba 90 21 00 00 00 	movabs $0x2190,%rdx
    1c2d:	00 00 00 
    1c30:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1c34:	48 89 02             	mov    %rax,(%rdx)
}
    1c37:	90                   	nop
    1c38:	c9                   	leaveq 
    1c39:	c3                   	retq   

0000000000001c3a <morecore>:

static Header*
morecore(uint nu)
{
    1c3a:	f3 0f 1e fa          	endbr64 
    1c3e:	55                   	push   %rbp
    1c3f:	48 89 e5             	mov    %rsp,%rbp
    1c42:	48 83 ec 20          	sub    $0x20,%rsp
    1c46:	89 7d ec             	mov    %edi,-0x14(%rbp)
  char *p;
  Header *hp;

  if(nu < 4096)
    1c49:	81 7d ec ff 0f 00 00 	cmpl   $0xfff,-0x14(%rbp)
    1c50:	77 07                	ja     1c59 <morecore+0x1f>
    nu = 4096;
    1c52:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%rbp)
  p = sbrk(nu * sizeof(Header));
    1c59:	8b 45 ec             	mov    -0x14(%rbp),%eax
    1c5c:	48 c1 e0 04          	shl    $0x4,%rax
    1c60:	48 89 c7             	mov    %rax,%rdi
    1c63:	48 b8 da 14 00 00 00 	movabs $0x14da,%rax
    1c6a:	00 00 00 
    1c6d:	ff d0                	callq  *%rax
    1c6f:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  if(p == (char*)-1)
    1c73:	48 83 7d f8 ff       	cmpq   $0xffffffffffffffff,-0x8(%rbp)
    1c78:	75 07                	jne    1c81 <morecore+0x47>
    return 0;
    1c7a:	b8 00 00 00 00       	mov    $0x0,%eax
    1c7f:	eb 36                	jmp    1cb7 <morecore+0x7d>
  hp = (Header*)p;
    1c81:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1c85:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
  hp->s.size = nu;
    1c89:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1c8d:	8b 55 ec             	mov    -0x14(%rbp),%edx
    1c90:	89 50 08             	mov    %edx,0x8(%rax)
  free((void*)(hp + 1));
    1c93:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1c97:	48 83 c0 10          	add    $0x10,%rax
    1c9b:	48 89 c7             	mov    %rax,%rdi
    1c9e:	48 b8 04 1b 00 00 00 	movabs $0x1b04,%rax
    1ca5:	00 00 00 
    1ca8:	ff d0                	callq  *%rax
  return freep;
    1caa:	48 b8 90 21 00 00 00 	movabs $0x2190,%rax
    1cb1:	00 00 00 
    1cb4:	48 8b 00             	mov    (%rax),%rax
}
    1cb7:	c9                   	leaveq 
    1cb8:	c3                   	retq   

0000000000001cb9 <malloc>:

void*
malloc(uint nbytes)
{
    1cb9:	f3 0f 1e fa          	endbr64 
    1cbd:	55                   	push   %rbp
    1cbe:	48 89 e5             	mov    %rsp,%rbp
    1cc1:	48 83 ec 30          	sub    $0x30,%rsp
    1cc5:	89 7d dc             	mov    %edi,-0x24(%rbp)
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    1cc8:	8b 45 dc             	mov    -0x24(%rbp),%eax
    1ccb:	48 83 c0 0f          	add    $0xf,%rax
    1ccf:	48 c1 e8 04          	shr    $0x4,%rax
    1cd3:	83 c0 01             	add    $0x1,%eax
    1cd6:	89 45 ec             	mov    %eax,-0x14(%rbp)
  if((prevp = freep) == 0){
    1cd9:	48 b8 90 21 00 00 00 	movabs $0x2190,%rax
    1ce0:	00 00 00 
    1ce3:	48 8b 00             	mov    (%rax),%rax
    1ce6:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
    1cea:	48 83 7d f0 00       	cmpq   $0x0,-0x10(%rbp)
    1cef:	75 4a                	jne    1d3b <malloc+0x82>
    base.s.ptr = freep = prevp = &base;
    1cf1:	48 b8 80 21 00 00 00 	movabs $0x2180,%rax
    1cf8:	00 00 00 
    1cfb:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
    1cff:	48 ba 90 21 00 00 00 	movabs $0x2190,%rdx
    1d06:	00 00 00 
    1d09:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1d0d:	48 89 02             	mov    %rax,(%rdx)
    1d10:	48 b8 90 21 00 00 00 	movabs $0x2190,%rax
    1d17:	00 00 00 
    1d1a:	48 8b 00             	mov    (%rax),%rax
    1d1d:	48 ba 80 21 00 00 00 	movabs $0x2180,%rdx
    1d24:	00 00 00 
    1d27:	48 89 02             	mov    %rax,(%rdx)
    base.s.size = 0;
    1d2a:	48 b8 80 21 00 00 00 	movabs $0x2180,%rax
    1d31:	00 00 00 
    1d34:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%rax)
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    1d3b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1d3f:	48 8b 00             	mov    (%rax),%rax
    1d42:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
    if(p->s.size >= nunits){
    1d46:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1d4a:	8b 40 08             	mov    0x8(%rax),%eax
    1d4d:	39 45 ec             	cmp    %eax,-0x14(%rbp)
    1d50:	77 65                	ja     1db7 <malloc+0xfe>
      if(p->s.size == nunits)
    1d52:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1d56:	8b 40 08             	mov    0x8(%rax),%eax
    1d59:	39 45 ec             	cmp    %eax,-0x14(%rbp)
    1d5c:	75 10                	jne    1d6e <malloc+0xb5>
        prevp->s.ptr = p->s.ptr;
    1d5e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1d62:	48 8b 10             	mov    (%rax),%rdx
    1d65:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1d69:	48 89 10             	mov    %rdx,(%rax)
    1d6c:	eb 2e                	jmp    1d9c <malloc+0xe3>
      else {
        p->s.size -= nunits;
    1d6e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1d72:	8b 40 08             	mov    0x8(%rax),%eax
    1d75:	2b 45 ec             	sub    -0x14(%rbp),%eax
    1d78:	89 c2                	mov    %eax,%edx
    1d7a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1d7e:	89 50 08             	mov    %edx,0x8(%rax)
        p += p->s.size;
    1d81:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1d85:	8b 40 08             	mov    0x8(%rax),%eax
    1d88:	89 c0                	mov    %eax,%eax
    1d8a:	48 c1 e0 04          	shl    $0x4,%rax
    1d8e:	48 01 45 f8          	add    %rax,-0x8(%rbp)
        p->s.size = nunits;
    1d92:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1d96:	8b 55 ec             	mov    -0x14(%rbp),%edx
    1d99:	89 50 08             	mov    %edx,0x8(%rax)
      }
      freep = prevp;
    1d9c:	48 ba 90 21 00 00 00 	movabs $0x2190,%rdx
    1da3:	00 00 00 
    1da6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1daa:	48 89 02             	mov    %rax,(%rdx)
      return (void*)(p + 1);
    1dad:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1db1:	48 83 c0 10          	add    $0x10,%rax
    1db5:	eb 4e                	jmp    1e05 <malloc+0x14c>
    }
    if(p == freep)
    1db7:	48 b8 90 21 00 00 00 	movabs $0x2190,%rax
    1dbe:	00 00 00 
    1dc1:	48 8b 00             	mov    (%rax),%rax
    1dc4:	48 39 45 f8          	cmp    %rax,-0x8(%rbp)
    1dc8:	75 23                	jne    1ded <malloc+0x134>
      if((p = morecore(nunits)) == 0)
    1dca:	8b 45 ec             	mov    -0x14(%rbp),%eax
    1dcd:	89 c7                	mov    %eax,%edi
    1dcf:	48 b8 3a 1c 00 00 00 	movabs $0x1c3a,%rax
    1dd6:	00 00 00 
    1dd9:	ff d0                	callq  *%rax
    1ddb:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
    1ddf:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
    1de4:	75 07                	jne    1ded <malloc+0x134>
        return 0;
    1de6:	b8 00 00 00 00       	mov    $0x0,%eax
    1deb:	eb 18                	jmp    1e05 <malloc+0x14c>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    1ded:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1df1:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
    1df5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1df9:	48 8b 00             	mov    (%rax),%rax
    1dfc:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
    if(p->s.size >= nunits){
    1e00:	e9 41 ff ff ff       	jmpq   1d46 <malloc+0x8d>
  }
}
    1e05:	c9                   	leaveq 
    1e06:	c3                   	retq   
