
_mkdir:     file format elf64-x86-64


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
    1008:	48 83 ec 20          	sub    $0x20,%rsp
    100c:	89 7d ec             	mov    %edi,-0x14(%rbp)
    100f:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  int i;

  if(argc < 2){
    1013:	83 7d ec 01          	cmpl   $0x1,-0x14(%rbp)
    1017:	7f 2c                	jg     1045 <main+0x45>
    printf(2, "Usage: mkdir files...\n");
    1019:	48 be 20 1e 00 00 00 	movabs $0x1e20,%rsi
    1020:	00 00 00 
    1023:	bf 02 00 00 00       	mov    $0x2,%edi
    1028:	b8 00 00 00 00       	mov    $0x0,%eax
    102d:	48 ba 06 17 00 00 00 	movabs $0x1706,%rdx
    1034:	00 00 00 
    1037:	ff d2                	callq  *%rdx
    exit();
    1039:	48 b8 0f 14 00 00 00 	movabs $0x140f,%rax
    1040:	00 00 00 
    1043:	ff d0                	callq  *%rax
  }

  for(i = 1; i < argc; i++){
    1045:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)
    104c:	eb 6a                	jmp    10b8 <main+0xb8>
    if(mkdir(argv[i]) < 0){
    104e:	8b 45 fc             	mov    -0x4(%rbp),%eax
    1051:	48 98                	cltq   
    1053:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
    105a:	00 
    105b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
    105f:	48 01 d0             	add    %rdx,%rax
    1062:	48 8b 00             	mov    (%rax),%rax
    1065:	48 89 c7             	mov    %rax,%rdi
    1068:	48 b8 b8 14 00 00 00 	movabs $0x14b8,%rax
    106f:	00 00 00 
    1072:	ff d0                	callq  *%rax
    1074:	85 c0                	test   %eax,%eax
    1076:	79 3c                	jns    10b4 <main+0xb4>
      printf(2, "mkdir: %s failed to create\n", argv[i]);
    1078:	8b 45 fc             	mov    -0x4(%rbp),%eax
    107b:	48 98                	cltq   
    107d:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
    1084:	00 
    1085:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
    1089:	48 01 d0             	add    %rdx,%rax
    108c:	48 8b 00             	mov    (%rax),%rax
    108f:	48 89 c2             	mov    %rax,%rdx
    1092:	48 be 37 1e 00 00 00 	movabs $0x1e37,%rsi
    1099:	00 00 00 
    109c:	bf 02 00 00 00       	mov    $0x2,%edi
    10a1:	b8 00 00 00 00       	mov    $0x0,%eax
    10a6:	48 b9 06 17 00 00 00 	movabs $0x1706,%rcx
    10ad:	00 00 00 
    10b0:	ff d1                	callq  *%rcx
      break;
    10b2:	eb 0c                	jmp    10c0 <main+0xc0>
  for(i = 1; i < argc; i++){
    10b4:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
    10b8:	8b 45 fc             	mov    -0x4(%rbp),%eax
    10bb:	3b 45 ec             	cmp    -0x14(%rbp),%eax
    10be:	7c 8e                	jl     104e <main+0x4e>
    }
  }

  exit();
    10c0:	48 b8 0f 14 00 00 00 	movabs $0x140f,%rax
    10c7:	00 00 00 
    10ca:	ff d0                	callq  *%rax

00000000000010cc <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
    10cc:	f3 0f 1e fa          	endbr64 
    10d0:	55                   	push   %rbp
    10d1:	48 89 e5             	mov    %rsp,%rbp
    10d4:	48 83 ec 10          	sub    $0x10,%rsp
    10d8:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
    10dc:	89 75 f4             	mov    %esi,-0xc(%rbp)
    10df:	89 55 f0             	mov    %edx,-0x10(%rbp)
  asm volatile("cld; rep stosb" :
    10e2:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
    10e6:	8b 55 f0             	mov    -0x10(%rbp),%edx
    10e9:	8b 45 f4             	mov    -0xc(%rbp),%eax
    10ec:	48 89 ce             	mov    %rcx,%rsi
    10ef:	48 89 f7             	mov    %rsi,%rdi
    10f2:	89 d1                	mov    %edx,%ecx
    10f4:	fc                   	cld    
    10f5:	f3 aa                	rep stos %al,%es:(%rdi)
    10f7:	89 ca                	mov    %ecx,%edx
    10f9:	48 89 fe             	mov    %rdi,%rsi
    10fc:	48 89 75 f8          	mov    %rsi,-0x8(%rbp)
    1100:	89 55 f0             	mov    %edx,-0x10(%rbp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
    1103:	90                   	nop
    1104:	c9                   	leaveq 
    1105:	c3                   	retq   

0000000000001106 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
    1106:	f3 0f 1e fa          	endbr64 
    110a:	55                   	push   %rbp
    110b:	48 89 e5             	mov    %rsp,%rbp
    110e:	48 83 ec 20          	sub    $0x20,%rsp
    1112:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
    1116:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  char *os;

  os = s;
    111a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    111e:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  while((*s++ = *t++) != 0)
    1122:	90                   	nop
    1123:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
    1127:	48 8d 42 01          	lea    0x1(%rdx),%rax
    112b:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
    112f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    1133:	48 8d 48 01          	lea    0x1(%rax),%rcx
    1137:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
    113b:	0f b6 12             	movzbl (%rdx),%edx
    113e:	88 10                	mov    %dl,(%rax)
    1140:	0f b6 00             	movzbl (%rax),%eax
    1143:	84 c0                	test   %al,%al
    1145:	75 dc                	jne    1123 <strcpy+0x1d>
    ;
  return os;
    1147:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
    114b:	c9                   	leaveq 
    114c:	c3                   	retq   

000000000000114d <strcmp>:

int
strcmp(const char *p, const char *q)
{
    114d:	f3 0f 1e fa          	endbr64 
    1151:	55                   	push   %rbp
    1152:	48 89 e5             	mov    %rsp,%rbp
    1155:	48 83 ec 10          	sub    $0x10,%rsp
    1159:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
    115d:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  while(*p && *p == *q)
    1161:	eb 0a                	jmp    116d <strcmp+0x20>
    p++, q++;
    1163:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
    1168:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
  while(*p && *p == *q)
    116d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1171:	0f b6 00             	movzbl (%rax),%eax
    1174:	84 c0                	test   %al,%al
    1176:	74 12                	je     118a <strcmp+0x3d>
    1178:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    117c:	0f b6 10             	movzbl (%rax),%edx
    117f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1183:	0f b6 00             	movzbl (%rax),%eax
    1186:	38 c2                	cmp    %al,%dl
    1188:	74 d9                	je     1163 <strcmp+0x16>
  return (uchar)*p - (uchar)*q;
    118a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    118e:	0f b6 00             	movzbl (%rax),%eax
    1191:	0f b6 d0             	movzbl %al,%edx
    1194:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1198:	0f b6 00             	movzbl (%rax),%eax
    119b:	0f b6 c0             	movzbl %al,%eax
    119e:	29 c2                	sub    %eax,%edx
    11a0:	89 d0                	mov    %edx,%eax
}
    11a2:	c9                   	leaveq 
    11a3:	c3                   	retq   

00000000000011a4 <strlen>:

uint
strlen(char *s)
{
    11a4:	f3 0f 1e fa          	endbr64 
    11a8:	55                   	push   %rbp
    11a9:	48 89 e5             	mov    %rsp,%rbp
    11ac:	48 83 ec 18          	sub    $0x18,%rsp
    11b0:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  int n;

  for(n = 0; s[n]; n++)
    11b4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
    11bb:	eb 04                	jmp    11c1 <strlen+0x1d>
    11bd:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
    11c1:	8b 45 fc             	mov    -0x4(%rbp),%eax
    11c4:	48 63 d0             	movslq %eax,%rdx
    11c7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    11cb:	48 01 d0             	add    %rdx,%rax
    11ce:	0f b6 00             	movzbl (%rax),%eax
    11d1:	84 c0                	test   %al,%al
    11d3:	75 e8                	jne    11bd <strlen+0x19>
    ;
  return n;
    11d5:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
    11d8:	c9                   	leaveq 
    11d9:	c3                   	retq   

00000000000011da <memset>:

void*
memset(void *dst, int c, uint n)
{
    11da:	f3 0f 1e fa          	endbr64 
    11de:	55                   	push   %rbp
    11df:	48 89 e5             	mov    %rsp,%rbp
    11e2:	48 83 ec 10          	sub    $0x10,%rsp
    11e6:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
    11ea:	89 75 f4             	mov    %esi,-0xc(%rbp)
    11ed:	89 55 f0             	mov    %edx,-0x10(%rbp)
  stosb(dst, c, n);
    11f0:	8b 55 f0             	mov    -0x10(%rbp),%edx
    11f3:	8b 4d f4             	mov    -0xc(%rbp),%ecx
    11f6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    11fa:	89 ce                	mov    %ecx,%esi
    11fc:	48 89 c7             	mov    %rax,%rdi
    11ff:	48 b8 cc 10 00 00 00 	movabs $0x10cc,%rax
    1206:	00 00 00 
    1209:	ff d0                	callq  *%rax
  return dst;
    120b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
    120f:	c9                   	leaveq 
    1210:	c3                   	retq   

0000000000001211 <strchr>:

char*
strchr(const char *s, char c)
{
    1211:	f3 0f 1e fa          	endbr64 
    1215:	55                   	push   %rbp
    1216:	48 89 e5             	mov    %rsp,%rbp
    1219:	48 83 ec 10          	sub    $0x10,%rsp
    121d:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
    1221:	89 f0                	mov    %esi,%eax
    1223:	88 45 f4             	mov    %al,-0xc(%rbp)
  for(; *s; s++)
    1226:	eb 17                	jmp    123f <strchr+0x2e>
    if(*s == c)
    1228:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    122c:	0f b6 00             	movzbl (%rax),%eax
    122f:	38 45 f4             	cmp    %al,-0xc(%rbp)
    1232:	75 06                	jne    123a <strchr+0x29>
      return (char*)s;
    1234:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1238:	eb 15                	jmp    124f <strchr+0x3e>
  for(; *s; s++)
    123a:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
    123f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1243:	0f b6 00             	movzbl (%rax),%eax
    1246:	84 c0                	test   %al,%al
    1248:	75 de                	jne    1228 <strchr+0x17>
  return 0;
    124a:	b8 00 00 00 00       	mov    $0x0,%eax
}
    124f:	c9                   	leaveq 
    1250:	c3                   	retq   

0000000000001251 <gets>:

char*
gets(char *buf, int max)
{
    1251:	f3 0f 1e fa          	endbr64 
    1255:	55                   	push   %rbp
    1256:	48 89 e5             	mov    %rsp,%rbp
    1259:	48 83 ec 20          	sub    $0x20,%rsp
    125d:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
    1261:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    1264:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
    126b:	eb 4f                	jmp    12bc <gets+0x6b>
    cc = read(0, &c, 1);
    126d:	48 8d 45 f7          	lea    -0x9(%rbp),%rax
    1271:	ba 01 00 00 00       	mov    $0x1,%edx
    1276:	48 89 c6             	mov    %rax,%rsi
    1279:	bf 00 00 00 00       	mov    $0x0,%edi
    127e:	48 b8 36 14 00 00 00 	movabs $0x1436,%rax
    1285:	00 00 00 
    1288:	ff d0                	callq  *%rax
    128a:	89 45 f8             	mov    %eax,-0x8(%rbp)
    if(cc < 1)
    128d:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
    1291:	7e 36                	jle    12c9 <gets+0x78>
      break;
    buf[i++] = c;
    1293:	8b 45 fc             	mov    -0x4(%rbp),%eax
    1296:	8d 50 01             	lea    0x1(%rax),%edx
    1299:	89 55 fc             	mov    %edx,-0x4(%rbp)
    129c:	48 63 d0             	movslq %eax,%rdx
    129f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    12a3:	48 01 c2             	add    %rax,%rdx
    12a6:	0f b6 45 f7          	movzbl -0x9(%rbp),%eax
    12aa:	88 02                	mov    %al,(%rdx)
    if(c == '\n' || c == '\r')
    12ac:	0f b6 45 f7          	movzbl -0x9(%rbp),%eax
    12b0:	3c 0a                	cmp    $0xa,%al
    12b2:	74 16                	je     12ca <gets+0x79>
    12b4:	0f b6 45 f7          	movzbl -0x9(%rbp),%eax
    12b8:	3c 0d                	cmp    $0xd,%al
    12ba:	74 0e                	je     12ca <gets+0x79>
  for(i=0; i+1 < max; ){
    12bc:	8b 45 fc             	mov    -0x4(%rbp),%eax
    12bf:	83 c0 01             	add    $0x1,%eax
    12c2:	39 45 e4             	cmp    %eax,-0x1c(%rbp)
    12c5:	7f a6                	jg     126d <gets+0x1c>
    12c7:	eb 01                	jmp    12ca <gets+0x79>
      break;
    12c9:	90                   	nop
      break;
  }
  buf[i] = '\0';
    12ca:	8b 45 fc             	mov    -0x4(%rbp),%eax
    12cd:	48 63 d0             	movslq %eax,%rdx
    12d0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    12d4:	48 01 d0             	add    %rdx,%rax
    12d7:	c6 00 00             	movb   $0x0,(%rax)
  return buf;
    12da:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
    12de:	c9                   	leaveq 
    12df:	c3                   	retq   

00000000000012e0 <stat>:

int
stat(char *n, struct stat *st)
{
    12e0:	f3 0f 1e fa          	endbr64 
    12e4:	55                   	push   %rbp
    12e5:	48 89 e5             	mov    %rsp,%rbp
    12e8:	48 83 ec 20          	sub    $0x20,%rsp
    12ec:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
    12f0:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  int fd;
  int r;

  fd = open(n, O_RDONLY);
    12f4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    12f8:	be 00 00 00 00       	mov    $0x0,%esi
    12fd:	48 89 c7             	mov    %rax,%rdi
    1300:	48 b8 77 14 00 00 00 	movabs $0x1477,%rax
    1307:	00 00 00 
    130a:	ff d0                	callq  *%rax
    130c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  if(fd < 0)
    130f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
    1313:	79 07                	jns    131c <stat+0x3c>
    return -1;
    1315:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    131a:	eb 2f                	jmp    134b <stat+0x6b>
  r = fstat(fd, st);
    131c:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
    1320:	8b 45 fc             	mov    -0x4(%rbp),%eax
    1323:	48 89 d6             	mov    %rdx,%rsi
    1326:	89 c7                	mov    %eax,%edi
    1328:	48 b8 9e 14 00 00 00 	movabs $0x149e,%rax
    132f:	00 00 00 
    1332:	ff d0                	callq  *%rax
    1334:	89 45 f8             	mov    %eax,-0x8(%rbp)
  close(fd);
    1337:	8b 45 fc             	mov    -0x4(%rbp),%eax
    133a:	89 c7                	mov    %eax,%edi
    133c:	48 b8 50 14 00 00 00 	movabs $0x1450,%rax
    1343:	00 00 00 
    1346:	ff d0                	callq  *%rax
  return r;
    1348:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
    134b:	c9                   	leaveq 
    134c:	c3                   	retq   

000000000000134d <atoi>:

int
atoi(const char *s)
{
    134d:	f3 0f 1e fa          	endbr64 
    1351:	55                   	push   %rbp
    1352:	48 89 e5             	mov    %rsp,%rbp
    1355:	48 83 ec 18          	sub    $0x18,%rsp
    1359:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  int n;

  n = 0;
    135d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  while('0' <= *s && *s <= '9')
    1364:	eb 28                	jmp    138e <atoi+0x41>
    n = n*10 + *s++ - '0';
    1366:	8b 55 fc             	mov    -0x4(%rbp),%edx
    1369:	89 d0                	mov    %edx,%eax
    136b:	c1 e0 02             	shl    $0x2,%eax
    136e:	01 d0                	add    %edx,%eax
    1370:	01 c0                	add    %eax,%eax
    1372:	89 c1                	mov    %eax,%ecx
    1374:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    1378:	48 8d 50 01          	lea    0x1(%rax),%rdx
    137c:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
    1380:	0f b6 00             	movzbl (%rax),%eax
    1383:	0f be c0             	movsbl %al,%eax
    1386:	01 c8                	add    %ecx,%eax
    1388:	83 e8 30             	sub    $0x30,%eax
    138b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  while('0' <= *s && *s <= '9')
    138e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    1392:	0f b6 00             	movzbl (%rax),%eax
    1395:	3c 2f                	cmp    $0x2f,%al
    1397:	7e 0b                	jle    13a4 <atoi+0x57>
    1399:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    139d:	0f b6 00             	movzbl (%rax),%eax
    13a0:	3c 39                	cmp    $0x39,%al
    13a2:	7e c2                	jle    1366 <atoi+0x19>
  return n;
    13a4:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
    13a7:	c9                   	leaveq 
    13a8:	c3                   	retq   

00000000000013a9 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
    13a9:	f3 0f 1e fa          	endbr64 
    13ad:	55                   	push   %rbp
    13ae:	48 89 e5             	mov    %rsp,%rbp
    13b1:	48 83 ec 28          	sub    $0x28,%rsp
    13b5:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
    13b9:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
    13bd:	89 55 dc             	mov    %edx,-0x24(%rbp)
  char *dst, *src;

  dst = vdst;
    13c0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    13c4:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  src = vsrc;
    13c8:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
    13cc:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
  while(n-- > 0)
    13d0:	eb 1d                	jmp    13ef <memmove+0x46>
    *dst++ = *src++;
    13d2:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
    13d6:	48 8d 42 01          	lea    0x1(%rdx),%rax
    13da:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
    13de:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    13e2:	48 8d 48 01          	lea    0x1(%rax),%rcx
    13e6:	48 89 4d f8          	mov    %rcx,-0x8(%rbp)
    13ea:	0f b6 12             	movzbl (%rdx),%edx
    13ed:	88 10                	mov    %dl,(%rax)
  while(n-- > 0)
    13ef:	8b 45 dc             	mov    -0x24(%rbp),%eax
    13f2:	8d 50 ff             	lea    -0x1(%rax),%edx
    13f5:	89 55 dc             	mov    %edx,-0x24(%rbp)
    13f8:	85 c0                	test   %eax,%eax
    13fa:	7f d6                	jg     13d2 <memmove+0x29>
  return vdst;
    13fc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
    1400:	c9                   	leaveq 
    1401:	c3                   	retq   

0000000000001402 <fork>:
    mov $SYS_ ## name, %rax; \
    mov %rcx, %r10 ;\
    syscall		  ;\
    ret

SYSCALL(fork)
    1402:	48 c7 c0 01 00 00 00 	mov    $0x1,%rax
    1409:	49 89 ca             	mov    %rcx,%r10
    140c:	0f 05                	syscall 
    140e:	c3                   	retq   

000000000000140f <exit>:
SYSCALL(exit)
    140f:	48 c7 c0 02 00 00 00 	mov    $0x2,%rax
    1416:	49 89 ca             	mov    %rcx,%r10
    1419:	0f 05                	syscall 
    141b:	c3                   	retq   

000000000000141c <wait>:
SYSCALL(wait)
    141c:	48 c7 c0 03 00 00 00 	mov    $0x3,%rax
    1423:	49 89 ca             	mov    %rcx,%r10
    1426:	0f 05                	syscall 
    1428:	c3                   	retq   

0000000000001429 <pipe>:
SYSCALL(pipe)
    1429:	48 c7 c0 04 00 00 00 	mov    $0x4,%rax
    1430:	49 89 ca             	mov    %rcx,%r10
    1433:	0f 05                	syscall 
    1435:	c3                   	retq   

0000000000001436 <read>:
SYSCALL(read)
    1436:	48 c7 c0 05 00 00 00 	mov    $0x5,%rax
    143d:	49 89 ca             	mov    %rcx,%r10
    1440:	0f 05                	syscall 
    1442:	c3                   	retq   

0000000000001443 <write>:
SYSCALL(write)
    1443:	48 c7 c0 10 00 00 00 	mov    $0x10,%rax
    144a:	49 89 ca             	mov    %rcx,%r10
    144d:	0f 05                	syscall 
    144f:	c3                   	retq   

0000000000001450 <close>:
SYSCALL(close)
    1450:	48 c7 c0 15 00 00 00 	mov    $0x15,%rax
    1457:	49 89 ca             	mov    %rcx,%r10
    145a:	0f 05                	syscall 
    145c:	c3                   	retq   

000000000000145d <kill>:
SYSCALL(kill)
    145d:	48 c7 c0 06 00 00 00 	mov    $0x6,%rax
    1464:	49 89 ca             	mov    %rcx,%r10
    1467:	0f 05                	syscall 
    1469:	c3                   	retq   

000000000000146a <exec>:
SYSCALL(exec)
    146a:	48 c7 c0 07 00 00 00 	mov    $0x7,%rax
    1471:	49 89 ca             	mov    %rcx,%r10
    1474:	0f 05                	syscall 
    1476:	c3                   	retq   

0000000000001477 <open>:
SYSCALL(open)
    1477:	48 c7 c0 0f 00 00 00 	mov    $0xf,%rax
    147e:	49 89 ca             	mov    %rcx,%r10
    1481:	0f 05                	syscall 
    1483:	c3                   	retq   

0000000000001484 <mknod>:
SYSCALL(mknod)
    1484:	48 c7 c0 11 00 00 00 	mov    $0x11,%rax
    148b:	49 89 ca             	mov    %rcx,%r10
    148e:	0f 05                	syscall 
    1490:	c3                   	retq   

0000000000001491 <unlink>:
SYSCALL(unlink)
    1491:	48 c7 c0 12 00 00 00 	mov    $0x12,%rax
    1498:	49 89 ca             	mov    %rcx,%r10
    149b:	0f 05                	syscall 
    149d:	c3                   	retq   

000000000000149e <fstat>:
SYSCALL(fstat)
    149e:	48 c7 c0 08 00 00 00 	mov    $0x8,%rax
    14a5:	49 89 ca             	mov    %rcx,%r10
    14a8:	0f 05                	syscall 
    14aa:	c3                   	retq   

00000000000014ab <link>:
SYSCALL(link)
    14ab:	48 c7 c0 13 00 00 00 	mov    $0x13,%rax
    14b2:	49 89 ca             	mov    %rcx,%r10
    14b5:	0f 05                	syscall 
    14b7:	c3                   	retq   

00000000000014b8 <mkdir>:
SYSCALL(mkdir)
    14b8:	48 c7 c0 14 00 00 00 	mov    $0x14,%rax
    14bf:	49 89 ca             	mov    %rcx,%r10
    14c2:	0f 05                	syscall 
    14c4:	c3                   	retq   

00000000000014c5 <chdir>:
SYSCALL(chdir)
    14c5:	48 c7 c0 09 00 00 00 	mov    $0x9,%rax
    14cc:	49 89 ca             	mov    %rcx,%r10
    14cf:	0f 05                	syscall 
    14d1:	c3                   	retq   

00000000000014d2 <dup>:
SYSCALL(dup)
    14d2:	48 c7 c0 0a 00 00 00 	mov    $0xa,%rax
    14d9:	49 89 ca             	mov    %rcx,%r10
    14dc:	0f 05                	syscall 
    14de:	c3                   	retq   

00000000000014df <getpid>:
SYSCALL(getpid)
    14df:	48 c7 c0 0b 00 00 00 	mov    $0xb,%rax
    14e6:	49 89 ca             	mov    %rcx,%r10
    14e9:	0f 05                	syscall 
    14eb:	c3                   	retq   

00000000000014ec <sbrk>:
SYSCALL(sbrk)
    14ec:	48 c7 c0 0c 00 00 00 	mov    $0xc,%rax
    14f3:	49 89 ca             	mov    %rcx,%r10
    14f6:	0f 05                	syscall 
    14f8:	c3                   	retq   

00000000000014f9 <sleep>:
SYSCALL(sleep)
    14f9:	48 c7 c0 0d 00 00 00 	mov    $0xd,%rax
    1500:	49 89 ca             	mov    %rcx,%r10
    1503:	0f 05                	syscall 
    1505:	c3                   	retq   

0000000000001506 <uptime>:
SYSCALL(uptime)
    1506:	48 c7 c0 0e 00 00 00 	mov    $0xe,%rax
    150d:	49 89 ca             	mov    %rcx,%r10
    1510:	0f 05                	syscall 
    1512:	c3                   	retq   

0000000000001513 <aread>:
SYSCALL(aread)
    1513:	48 c7 c0 16 00 00 00 	mov    $0x16,%rax
    151a:	49 89 ca             	mov    %rcx,%r10
    151d:	0f 05                	syscall 
    151f:	c3                   	retq   

0000000000001520 <putc>:

#include <stdarg.h>

static void
putc(int fd, char c)
{
    1520:	f3 0f 1e fa          	endbr64 
    1524:	55                   	push   %rbp
    1525:	48 89 e5             	mov    %rsp,%rbp
    1528:	48 83 ec 10          	sub    $0x10,%rsp
    152c:	89 7d fc             	mov    %edi,-0x4(%rbp)
    152f:	89 f0                	mov    %esi,%eax
    1531:	88 45 f8             	mov    %al,-0x8(%rbp)
  write(fd, &c, 1);
    1534:	48 8d 4d f8          	lea    -0x8(%rbp),%rcx
    1538:	8b 45 fc             	mov    -0x4(%rbp),%eax
    153b:	ba 01 00 00 00       	mov    $0x1,%edx
    1540:	48 89 ce             	mov    %rcx,%rsi
    1543:	89 c7                	mov    %eax,%edi
    1545:	48 b8 43 14 00 00 00 	movabs $0x1443,%rax
    154c:	00 00 00 
    154f:	ff d0                	callq  *%rax
}
    1551:	90                   	nop
    1552:	c9                   	leaveq 
    1553:	c3                   	retq   

0000000000001554 <print_x64>:

static char digits[] = "0123456789abcdef";

  static void
print_x64(int fd, addr_t x)
{
    1554:	f3 0f 1e fa          	endbr64 
    1558:	55                   	push   %rbp
    1559:	48 89 e5             	mov    %rsp,%rbp
    155c:	48 83 ec 20          	sub    $0x20,%rsp
    1560:	89 7d ec             	mov    %edi,-0x14(%rbp)
    1563:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  int i;
  for (i = 0; i < (sizeof(addr_t) * 2); i++, x <<= 4)
    1567:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
    156e:	eb 35                	jmp    15a5 <print_x64+0x51>
    putc(fd, digits[x >> (sizeof(addr_t) * 8 - 4)]);
    1570:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
    1574:	48 c1 e8 3c          	shr    $0x3c,%rax
    1578:	48 ba 90 21 00 00 00 	movabs $0x2190,%rdx
    157f:	00 00 00 
    1582:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax
    1586:	0f be d0             	movsbl %al,%edx
    1589:	8b 45 ec             	mov    -0x14(%rbp),%eax
    158c:	89 d6                	mov    %edx,%esi
    158e:	89 c7                	mov    %eax,%edi
    1590:	48 b8 20 15 00 00 00 	movabs $0x1520,%rax
    1597:	00 00 00 
    159a:	ff d0                	callq  *%rax
  for (i = 0; i < (sizeof(addr_t) * 2); i++, x <<= 4)
    159c:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
    15a0:	48 c1 65 e0 04       	shlq   $0x4,-0x20(%rbp)
    15a5:	8b 45 fc             	mov    -0x4(%rbp),%eax
    15a8:	83 f8 0f             	cmp    $0xf,%eax
    15ab:	76 c3                	jbe    1570 <print_x64+0x1c>
}
    15ad:	90                   	nop
    15ae:	90                   	nop
    15af:	c9                   	leaveq 
    15b0:	c3                   	retq   

00000000000015b1 <print_x32>:

  static void
print_x32(int fd, uint x)
{
    15b1:	f3 0f 1e fa          	endbr64 
    15b5:	55                   	push   %rbp
    15b6:	48 89 e5             	mov    %rsp,%rbp
    15b9:	48 83 ec 20          	sub    $0x20,%rsp
    15bd:	89 7d ec             	mov    %edi,-0x14(%rbp)
    15c0:	89 75 e8             	mov    %esi,-0x18(%rbp)
  int i;
  for (i = 0; i < (sizeof(uint) * 2); i++, x <<= 4)
    15c3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
    15ca:	eb 36                	jmp    1602 <print_x32+0x51>
    putc(fd, digits[x >> (sizeof(uint) * 8 - 4)]);
    15cc:	8b 45 e8             	mov    -0x18(%rbp),%eax
    15cf:	c1 e8 1c             	shr    $0x1c,%eax
    15d2:	89 c2                	mov    %eax,%edx
    15d4:	48 b8 90 21 00 00 00 	movabs $0x2190,%rax
    15db:	00 00 00 
    15de:	89 d2                	mov    %edx,%edx
    15e0:	0f b6 04 10          	movzbl (%rax,%rdx,1),%eax
    15e4:	0f be d0             	movsbl %al,%edx
    15e7:	8b 45 ec             	mov    -0x14(%rbp),%eax
    15ea:	89 d6                	mov    %edx,%esi
    15ec:	89 c7                	mov    %eax,%edi
    15ee:	48 b8 20 15 00 00 00 	movabs $0x1520,%rax
    15f5:	00 00 00 
    15f8:	ff d0                	callq  *%rax
  for (i = 0; i < (sizeof(uint) * 2); i++, x <<= 4)
    15fa:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
    15fe:	c1 65 e8 04          	shll   $0x4,-0x18(%rbp)
    1602:	8b 45 fc             	mov    -0x4(%rbp),%eax
    1605:	83 f8 07             	cmp    $0x7,%eax
    1608:	76 c2                	jbe    15cc <print_x32+0x1b>
}
    160a:	90                   	nop
    160b:	90                   	nop
    160c:	c9                   	leaveq 
    160d:	c3                   	retq   

000000000000160e <print_d>:

  static void
print_d(int fd, int v)
{
    160e:	f3 0f 1e fa          	endbr64 
    1612:	55                   	push   %rbp
    1613:	48 89 e5             	mov    %rsp,%rbp
    1616:	48 83 ec 30          	sub    $0x30,%rsp
    161a:	89 7d dc             	mov    %edi,-0x24(%rbp)
    161d:	89 75 d8             	mov    %esi,-0x28(%rbp)
  char buf[16];
  int64 x = v;
    1620:	8b 45 d8             	mov    -0x28(%rbp),%eax
    1623:	48 98                	cltq   
    1625:	48 89 45 f8          	mov    %rax,-0x8(%rbp)

  if (v < 0)
    1629:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
    162d:	79 04                	jns    1633 <print_d+0x25>
    x = -x;
    162f:	48 f7 5d f8          	negq   -0x8(%rbp)

  int i = 0;
    1633:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%rbp)
  do {
    buf[i++] = digits[x % 10];
    163a:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
    163e:	48 ba 67 66 66 66 66 	movabs $0x6666666666666667,%rdx
    1645:	66 66 66 
    1648:	48 89 c8             	mov    %rcx,%rax
    164b:	48 f7 ea             	imul   %rdx
    164e:	48 c1 fa 02          	sar    $0x2,%rdx
    1652:	48 89 c8             	mov    %rcx,%rax
    1655:	48 c1 f8 3f          	sar    $0x3f,%rax
    1659:	48 29 c2             	sub    %rax,%rdx
    165c:	48 89 d0             	mov    %rdx,%rax
    165f:	48 c1 e0 02          	shl    $0x2,%rax
    1663:	48 01 d0             	add    %rdx,%rax
    1666:	48 01 c0             	add    %rax,%rax
    1669:	48 29 c1             	sub    %rax,%rcx
    166c:	48 89 ca             	mov    %rcx,%rdx
    166f:	8b 45 f4             	mov    -0xc(%rbp),%eax
    1672:	8d 48 01             	lea    0x1(%rax),%ecx
    1675:	89 4d f4             	mov    %ecx,-0xc(%rbp)
    1678:	48 b9 90 21 00 00 00 	movabs $0x2190,%rcx
    167f:	00 00 00 
    1682:	0f b6 14 11          	movzbl (%rcx,%rdx,1),%edx
    1686:	48 98                	cltq   
    1688:	88 54 05 e0          	mov    %dl,-0x20(%rbp,%rax,1)
    x /= 10;
    168c:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
    1690:	48 ba 67 66 66 66 66 	movabs $0x6666666666666667,%rdx
    1697:	66 66 66 
    169a:	48 89 c8             	mov    %rcx,%rax
    169d:	48 f7 ea             	imul   %rdx
    16a0:	48 c1 fa 02          	sar    $0x2,%rdx
    16a4:	48 89 c8             	mov    %rcx,%rax
    16a7:	48 c1 f8 3f          	sar    $0x3f,%rax
    16ab:	48 29 c2             	sub    %rax,%rdx
    16ae:	48 89 d0             	mov    %rdx,%rax
    16b1:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  } while(x != 0);
    16b5:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
    16ba:	0f 85 7a ff ff ff    	jne    163a <print_d+0x2c>

  if (v < 0)
    16c0:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
    16c4:	79 32                	jns    16f8 <print_d+0xea>
    buf[i++] = '-';
    16c6:	8b 45 f4             	mov    -0xc(%rbp),%eax
    16c9:	8d 50 01             	lea    0x1(%rax),%edx
    16cc:	89 55 f4             	mov    %edx,-0xc(%rbp)
    16cf:	48 98                	cltq   
    16d1:	c6 44 05 e0 2d       	movb   $0x2d,-0x20(%rbp,%rax,1)

  while (--i >= 0)
    16d6:	eb 20                	jmp    16f8 <print_d+0xea>
    putc(fd, buf[i]);
    16d8:	8b 45 f4             	mov    -0xc(%rbp),%eax
    16db:	48 98                	cltq   
    16dd:	0f b6 44 05 e0       	movzbl -0x20(%rbp,%rax,1),%eax
    16e2:	0f be d0             	movsbl %al,%edx
    16e5:	8b 45 dc             	mov    -0x24(%rbp),%eax
    16e8:	89 d6                	mov    %edx,%esi
    16ea:	89 c7                	mov    %eax,%edi
    16ec:	48 b8 20 15 00 00 00 	movabs $0x1520,%rax
    16f3:	00 00 00 
    16f6:	ff d0                	callq  *%rax
  while (--i >= 0)
    16f8:	83 6d f4 01          	subl   $0x1,-0xc(%rbp)
    16fc:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
    1700:	79 d6                	jns    16d8 <print_d+0xca>
}
    1702:	90                   	nop
    1703:	90                   	nop
    1704:	c9                   	leaveq 
    1705:	c3                   	retq   

0000000000001706 <printf>:
// Print to the given fd. Only understands %d, %x, %p, %s.
  void
printf(int fd, char *fmt, ...)
{
    1706:	f3 0f 1e fa          	endbr64 
    170a:	55                   	push   %rbp
    170b:	48 89 e5             	mov    %rsp,%rbp
    170e:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
    1715:	89 bd 1c ff ff ff    	mov    %edi,-0xe4(%rbp)
    171b:	48 89 b5 10 ff ff ff 	mov    %rsi,-0xf0(%rbp)
    1722:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
    1729:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
    1730:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
    1737:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
    173e:	84 c0                	test   %al,%al
    1740:	74 20                	je     1762 <printf+0x5c>
    1742:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
    1746:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
    174a:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
    174e:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
    1752:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
    1756:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
    175a:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
    175e:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  va_list ap;
  int i, c;
  char *s;

  va_start(ap, fmt);
    1762:	c7 85 20 ff ff ff 10 	movl   $0x10,-0xe0(%rbp)
    1769:	00 00 00 
    176c:	c7 85 24 ff ff ff 30 	movl   $0x30,-0xdc(%rbp)
    1773:	00 00 00 
    1776:	48 8d 45 10          	lea    0x10(%rbp),%rax
    177a:	48 89 85 28 ff ff ff 	mov    %rax,-0xd8(%rbp)
    1781:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
    1788:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  for (i = 0; (c = fmt[i] & 0xff) != 0; i++) {
    178f:	c7 85 4c ff ff ff 00 	movl   $0x0,-0xb4(%rbp)
    1796:	00 00 00 
    1799:	e9 41 03 00 00       	jmpq   1adf <printf+0x3d9>
    if (c != '%') {
    179e:	83 bd 3c ff ff ff 25 	cmpl   $0x25,-0xc4(%rbp)
    17a5:	74 24                	je     17cb <printf+0xc5>
      putc(fd, c);
    17a7:	8b 85 3c ff ff ff    	mov    -0xc4(%rbp),%eax
    17ad:	0f be d0             	movsbl %al,%edx
    17b0:	8b 85 1c ff ff ff    	mov    -0xe4(%rbp),%eax
    17b6:	89 d6                	mov    %edx,%esi
    17b8:	89 c7                	mov    %eax,%edi
    17ba:	48 b8 20 15 00 00 00 	movabs $0x1520,%rax
    17c1:	00 00 00 
    17c4:	ff d0                	callq  *%rax
      continue;
    17c6:	e9 0d 03 00 00       	jmpq   1ad8 <printf+0x3d2>
    }
    c = fmt[++i] & 0xff;
    17cb:	83 85 4c ff ff ff 01 	addl   $0x1,-0xb4(%rbp)
    17d2:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
    17d8:	48 63 d0             	movslq %eax,%rdx
    17db:	48 8b 85 10 ff ff ff 	mov    -0xf0(%rbp),%rax
    17e2:	48 01 d0             	add    %rdx,%rax
    17e5:	0f b6 00             	movzbl (%rax),%eax
    17e8:	0f be c0             	movsbl %al,%eax
    17eb:	25 ff 00 00 00       	and    $0xff,%eax
    17f0:	89 85 3c ff ff ff    	mov    %eax,-0xc4(%rbp)
    if (c == 0)
    17f6:	83 bd 3c ff ff ff 00 	cmpl   $0x0,-0xc4(%rbp)
    17fd:	0f 84 0f 03 00 00    	je     1b12 <printf+0x40c>
      break;
    switch(c) {
    1803:	83 bd 3c ff ff ff 25 	cmpl   $0x25,-0xc4(%rbp)
    180a:	0f 84 74 02 00 00    	je     1a84 <printf+0x37e>
    1810:	83 bd 3c ff ff ff 25 	cmpl   $0x25,-0xc4(%rbp)
    1817:	0f 8c 82 02 00 00    	jl     1a9f <printf+0x399>
    181d:	83 bd 3c ff ff ff 78 	cmpl   $0x78,-0xc4(%rbp)
    1824:	0f 8f 75 02 00 00    	jg     1a9f <printf+0x399>
    182a:	83 bd 3c ff ff ff 63 	cmpl   $0x63,-0xc4(%rbp)
    1831:	0f 8c 68 02 00 00    	jl     1a9f <printf+0x399>
    1837:	8b 85 3c ff ff ff    	mov    -0xc4(%rbp),%eax
    183d:	83 e8 63             	sub    $0x63,%eax
    1840:	83 f8 15             	cmp    $0x15,%eax
    1843:	0f 87 56 02 00 00    	ja     1a9f <printf+0x399>
    1849:	89 c0                	mov    %eax,%eax
    184b:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
    1852:	00 
    1853:	48 b8 60 1e 00 00 00 	movabs $0x1e60,%rax
    185a:	00 00 00 
    185d:	48 01 d0             	add    %rdx,%rax
    1860:	48 8b 00             	mov    (%rax),%rax
    1863:	3e ff e0             	notrack jmpq *%rax
    case 'c':
      putc(fd, va_arg(ap, int));
    1866:	8b 85 20 ff ff ff    	mov    -0xe0(%rbp),%eax
    186c:	83 f8 2f             	cmp    $0x2f,%eax
    186f:	77 23                	ja     1894 <printf+0x18e>
    1871:	48 8b 85 30 ff ff ff 	mov    -0xd0(%rbp),%rax
    1878:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    187e:	89 d2                	mov    %edx,%edx
    1880:	48 01 d0             	add    %rdx,%rax
    1883:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    1889:	83 c2 08             	add    $0x8,%edx
    188c:	89 95 20 ff ff ff    	mov    %edx,-0xe0(%rbp)
    1892:	eb 12                	jmp    18a6 <printf+0x1a0>
    1894:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
    189b:	48 8d 50 08          	lea    0x8(%rax),%rdx
    189f:	48 89 95 28 ff ff ff 	mov    %rdx,-0xd8(%rbp)
    18a6:	8b 00                	mov    (%rax),%eax
    18a8:	0f be d0             	movsbl %al,%edx
    18ab:	8b 85 1c ff ff ff    	mov    -0xe4(%rbp),%eax
    18b1:	89 d6                	mov    %edx,%esi
    18b3:	89 c7                	mov    %eax,%edi
    18b5:	48 b8 20 15 00 00 00 	movabs $0x1520,%rax
    18bc:	00 00 00 
    18bf:	ff d0                	callq  *%rax
      break;
    18c1:	e9 12 02 00 00       	jmpq   1ad8 <printf+0x3d2>
    case 'd':
      print_d(fd, va_arg(ap, int));
    18c6:	8b 85 20 ff ff ff    	mov    -0xe0(%rbp),%eax
    18cc:	83 f8 2f             	cmp    $0x2f,%eax
    18cf:	77 23                	ja     18f4 <printf+0x1ee>
    18d1:	48 8b 85 30 ff ff ff 	mov    -0xd0(%rbp),%rax
    18d8:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    18de:	89 d2                	mov    %edx,%edx
    18e0:	48 01 d0             	add    %rdx,%rax
    18e3:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    18e9:	83 c2 08             	add    $0x8,%edx
    18ec:	89 95 20 ff ff ff    	mov    %edx,-0xe0(%rbp)
    18f2:	eb 12                	jmp    1906 <printf+0x200>
    18f4:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
    18fb:	48 8d 50 08          	lea    0x8(%rax),%rdx
    18ff:	48 89 95 28 ff ff ff 	mov    %rdx,-0xd8(%rbp)
    1906:	8b 10                	mov    (%rax),%edx
    1908:	8b 85 1c ff ff ff    	mov    -0xe4(%rbp),%eax
    190e:	89 d6                	mov    %edx,%esi
    1910:	89 c7                	mov    %eax,%edi
    1912:	48 b8 0e 16 00 00 00 	movabs $0x160e,%rax
    1919:	00 00 00 
    191c:	ff d0                	callq  *%rax
      break;
    191e:	e9 b5 01 00 00       	jmpq   1ad8 <printf+0x3d2>
    case 'x':
      print_x32(fd, va_arg(ap, uint));
    1923:	8b 85 20 ff ff ff    	mov    -0xe0(%rbp),%eax
    1929:	83 f8 2f             	cmp    $0x2f,%eax
    192c:	77 23                	ja     1951 <printf+0x24b>
    192e:	48 8b 85 30 ff ff ff 	mov    -0xd0(%rbp),%rax
    1935:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    193b:	89 d2                	mov    %edx,%edx
    193d:	48 01 d0             	add    %rdx,%rax
    1940:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    1946:	83 c2 08             	add    $0x8,%edx
    1949:	89 95 20 ff ff ff    	mov    %edx,-0xe0(%rbp)
    194f:	eb 12                	jmp    1963 <printf+0x25d>
    1951:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
    1958:	48 8d 50 08          	lea    0x8(%rax),%rdx
    195c:	48 89 95 28 ff ff ff 	mov    %rdx,-0xd8(%rbp)
    1963:	8b 10                	mov    (%rax),%edx
    1965:	8b 85 1c ff ff ff    	mov    -0xe4(%rbp),%eax
    196b:	89 d6                	mov    %edx,%esi
    196d:	89 c7                	mov    %eax,%edi
    196f:	48 b8 b1 15 00 00 00 	movabs $0x15b1,%rax
    1976:	00 00 00 
    1979:	ff d0                	callq  *%rax
      break;
    197b:	e9 58 01 00 00       	jmpq   1ad8 <printf+0x3d2>
    case 'p':
      print_x64(fd, va_arg(ap, addr_t));
    1980:	8b 85 20 ff ff ff    	mov    -0xe0(%rbp),%eax
    1986:	83 f8 2f             	cmp    $0x2f,%eax
    1989:	77 23                	ja     19ae <printf+0x2a8>
    198b:	48 8b 85 30 ff ff ff 	mov    -0xd0(%rbp),%rax
    1992:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    1998:	89 d2                	mov    %edx,%edx
    199a:	48 01 d0             	add    %rdx,%rax
    199d:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    19a3:	83 c2 08             	add    $0x8,%edx
    19a6:	89 95 20 ff ff ff    	mov    %edx,-0xe0(%rbp)
    19ac:	eb 12                	jmp    19c0 <printf+0x2ba>
    19ae:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
    19b5:	48 8d 50 08          	lea    0x8(%rax),%rdx
    19b9:	48 89 95 28 ff ff ff 	mov    %rdx,-0xd8(%rbp)
    19c0:	48 8b 10             	mov    (%rax),%rdx
    19c3:	8b 85 1c ff ff ff    	mov    -0xe4(%rbp),%eax
    19c9:	48 89 d6             	mov    %rdx,%rsi
    19cc:	89 c7                	mov    %eax,%edi
    19ce:	48 b8 54 15 00 00 00 	movabs $0x1554,%rax
    19d5:	00 00 00 
    19d8:	ff d0                	callq  *%rax
      break;
    19da:	e9 f9 00 00 00       	jmpq   1ad8 <printf+0x3d2>
    case 's':
      if ((s = va_arg(ap, char*)) == 0)
    19df:	8b 85 20 ff ff ff    	mov    -0xe0(%rbp),%eax
    19e5:	83 f8 2f             	cmp    $0x2f,%eax
    19e8:	77 23                	ja     1a0d <printf+0x307>
    19ea:	48 8b 85 30 ff ff ff 	mov    -0xd0(%rbp),%rax
    19f1:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    19f7:	89 d2                	mov    %edx,%edx
    19f9:	48 01 d0             	add    %rdx,%rax
    19fc:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    1a02:	83 c2 08             	add    $0x8,%edx
    1a05:	89 95 20 ff ff ff    	mov    %edx,-0xe0(%rbp)
    1a0b:	eb 12                	jmp    1a1f <printf+0x319>
    1a0d:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
    1a14:	48 8d 50 08          	lea    0x8(%rax),%rdx
    1a18:	48 89 95 28 ff ff ff 	mov    %rdx,-0xd8(%rbp)
    1a1f:	48 8b 00             	mov    (%rax),%rax
    1a22:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
    1a29:	48 83 bd 40 ff ff ff 	cmpq   $0x0,-0xc0(%rbp)
    1a30:	00 
    1a31:	75 41                	jne    1a74 <printf+0x36e>
        s = "(null)";
    1a33:	48 b8 58 1e 00 00 00 	movabs $0x1e58,%rax
    1a3a:	00 00 00 
    1a3d:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
      while (*s)
    1a44:	eb 2e                	jmp    1a74 <printf+0x36e>
        putc(fd, *(s++));
    1a46:	48 8b 85 40 ff ff ff 	mov    -0xc0(%rbp),%rax
    1a4d:	48 8d 50 01          	lea    0x1(%rax),%rdx
    1a51:	48 89 95 40 ff ff ff 	mov    %rdx,-0xc0(%rbp)
    1a58:	0f b6 00             	movzbl (%rax),%eax
    1a5b:	0f be d0             	movsbl %al,%edx
    1a5e:	8b 85 1c ff ff ff    	mov    -0xe4(%rbp),%eax
    1a64:	89 d6                	mov    %edx,%esi
    1a66:	89 c7                	mov    %eax,%edi
    1a68:	48 b8 20 15 00 00 00 	movabs $0x1520,%rax
    1a6f:	00 00 00 
    1a72:	ff d0                	callq  *%rax
      while (*s)
    1a74:	48 8b 85 40 ff ff ff 	mov    -0xc0(%rbp),%rax
    1a7b:	0f b6 00             	movzbl (%rax),%eax
    1a7e:	84 c0                	test   %al,%al
    1a80:	75 c4                	jne    1a46 <printf+0x340>
      break;
    1a82:	eb 54                	jmp    1ad8 <printf+0x3d2>
    case '%':
      putc(fd, '%');
    1a84:	8b 85 1c ff ff ff    	mov    -0xe4(%rbp),%eax
    1a8a:	be 25 00 00 00       	mov    $0x25,%esi
    1a8f:	89 c7                	mov    %eax,%edi
    1a91:	48 b8 20 15 00 00 00 	movabs $0x1520,%rax
    1a98:	00 00 00 
    1a9b:	ff d0                	callq  *%rax
      break;
    1a9d:	eb 39                	jmp    1ad8 <printf+0x3d2>
    default:
      // Print unknown % sequence to draw attention.
      putc(fd, '%');
    1a9f:	8b 85 1c ff ff ff    	mov    -0xe4(%rbp),%eax
    1aa5:	be 25 00 00 00       	mov    $0x25,%esi
    1aaa:	89 c7                	mov    %eax,%edi
    1aac:	48 b8 20 15 00 00 00 	movabs $0x1520,%rax
    1ab3:	00 00 00 
    1ab6:	ff d0                	callq  *%rax
      putc(fd, c);
    1ab8:	8b 85 3c ff ff ff    	mov    -0xc4(%rbp),%eax
    1abe:	0f be d0             	movsbl %al,%edx
    1ac1:	8b 85 1c ff ff ff    	mov    -0xe4(%rbp),%eax
    1ac7:	89 d6                	mov    %edx,%esi
    1ac9:	89 c7                	mov    %eax,%edi
    1acb:	48 b8 20 15 00 00 00 	movabs $0x1520,%rax
    1ad2:	00 00 00 
    1ad5:	ff d0                	callq  *%rax
      break;
    1ad7:	90                   	nop
  for (i = 0; (c = fmt[i] & 0xff) != 0; i++) {
    1ad8:	83 85 4c ff ff ff 01 	addl   $0x1,-0xb4(%rbp)
    1adf:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
    1ae5:	48 63 d0             	movslq %eax,%rdx
    1ae8:	48 8b 85 10 ff ff ff 	mov    -0xf0(%rbp),%rax
    1aef:	48 01 d0             	add    %rdx,%rax
    1af2:	0f b6 00             	movzbl (%rax),%eax
    1af5:	0f be c0             	movsbl %al,%eax
    1af8:	25 ff 00 00 00       	and    $0xff,%eax
    1afd:	89 85 3c ff ff ff    	mov    %eax,-0xc4(%rbp)
    1b03:	83 bd 3c ff ff ff 00 	cmpl   $0x0,-0xc4(%rbp)
    1b0a:	0f 85 8e fc ff ff    	jne    179e <printf+0x98>
    }
  }
}
    1b10:	eb 01                	jmp    1b13 <printf+0x40d>
      break;
    1b12:	90                   	nop
}
    1b13:	90                   	nop
    1b14:	c9                   	leaveq 
    1b15:	c3                   	retq   

0000000000001b16 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    1b16:	f3 0f 1e fa          	endbr64 
    1b1a:	55                   	push   %rbp
    1b1b:	48 89 e5             	mov    %rsp,%rbp
    1b1e:	48 83 ec 18          	sub    $0x18,%rsp
    1b22:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  Header *bp, *p;

  bp = (Header*)ap - 1;
    1b26:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    1b2a:	48 83 e8 10          	sub    $0x10,%rax
    1b2e:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    1b32:	48 b8 c0 21 00 00 00 	movabs $0x21c0,%rax
    1b39:	00 00 00 
    1b3c:	48 8b 00             	mov    (%rax),%rax
    1b3f:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
    1b43:	eb 2f                	jmp    1b74 <free+0x5e>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    1b45:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1b49:	48 8b 00             	mov    (%rax),%rax
    1b4c:	48 39 45 f8          	cmp    %rax,-0x8(%rbp)
    1b50:	72 17                	jb     1b69 <free+0x53>
    1b52:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1b56:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
    1b5a:	77 2f                	ja     1b8b <free+0x75>
    1b5c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1b60:	48 8b 00             	mov    (%rax),%rax
    1b63:	48 39 45 f0          	cmp    %rax,-0x10(%rbp)
    1b67:	72 22                	jb     1b8b <free+0x75>
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    1b69:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1b6d:	48 8b 00             	mov    (%rax),%rax
    1b70:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
    1b74:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1b78:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
    1b7c:	76 c7                	jbe    1b45 <free+0x2f>
    1b7e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1b82:	48 8b 00             	mov    (%rax),%rax
    1b85:	48 39 45 f0          	cmp    %rax,-0x10(%rbp)
    1b89:	73 ba                	jae    1b45 <free+0x2f>
      break;
  if(bp + bp->s.size == p->s.ptr){
    1b8b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1b8f:	8b 40 08             	mov    0x8(%rax),%eax
    1b92:	89 c0                	mov    %eax,%eax
    1b94:	48 c1 e0 04          	shl    $0x4,%rax
    1b98:	48 89 c2             	mov    %rax,%rdx
    1b9b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1b9f:	48 01 c2             	add    %rax,%rdx
    1ba2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1ba6:	48 8b 00             	mov    (%rax),%rax
    1ba9:	48 39 c2             	cmp    %rax,%rdx
    1bac:	75 2d                	jne    1bdb <free+0xc5>
    bp->s.size += p->s.ptr->s.size;
    1bae:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1bb2:	8b 50 08             	mov    0x8(%rax),%edx
    1bb5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1bb9:	48 8b 00             	mov    (%rax),%rax
    1bbc:	8b 40 08             	mov    0x8(%rax),%eax
    1bbf:	01 c2                	add    %eax,%edx
    1bc1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1bc5:	89 50 08             	mov    %edx,0x8(%rax)
    bp->s.ptr = p->s.ptr->s.ptr;
    1bc8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1bcc:	48 8b 00             	mov    (%rax),%rax
    1bcf:	48 8b 10             	mov    (%rax),%rdx
    1bd2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1bd6:	48 89 10             	mov    %rdx,(%rax)
    1bd9:	eb 0e                	jmp    1be9 <free+0xd3>
  } else
    bp->s.ptr = p->s.ptr;
    1bdb:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1bdf:	48 8b 10             	mov    (%rax),%rdx
    1be2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1be6:	48 89 10             	mov    %rdx,(%rax)
  if(p + p->s.size == bp){
    1be9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1bed:	8b 40 08             	mov    0x8(%rax),%eax
    1bf0:	89 c0                	mov    %eax,%eax
    1bf2:	48 c1 e0 04          	shl    $0x4,%rax
    1bf6:	48 89 c2             	mov    %rax,%rdx
    1bf9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1bfd:	48 01 d0             	add    %rdx,%rax
    1c00:	48 39 45 f0          	cmp    %rax,-0x10(%rbp)
    1c04:	75 27                	jne    1c2d <free+0x117>
    p->s.size += bp->s.size;
    1c06:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1c0a:	8b 50 08             	mov    0x8(%rax),%edx
    1c0d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1c11:	8b 40 08             	mov    0x8(%rax),%eax
    1c14:	01 c2                	add    %eax,%edx
    1c16:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1c1a:	89 50 08             	mov    %edx,0x8(%rax)
    p->s.ptr = bp->s.ptr;
    1c1d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1c21:	48 8b 10             	mov    (%rax),%rdx
    1c24:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1c28:	48 89 10             	mov    %rdx,(%rax)
    1c2b:	eb 0b                	jmp    1c38 <free+0x122>
  } else
    p->s.ptr = bp;
    1c2d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1c31:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
    1c35:	48 89 10             	mov    %rdx,(%rax)
  freep = p;
    1c38:	48 ba c0 21 00 00 00 	movabs $0x21c0,%rdx
    1c3f:	00 00 00 
    1c42:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1c46:	48 89 02             	mov    %rax,(%rdx)
}
    1c49:	90                   	nop
    1c4a:	c9                   	leaveq 
    1c4b:	c3                   	retq   

0000000000001c4c <morecore>:

static Header*
morecore(uint nu)
{
    1c4c:	f3 0f 1e fa          	endbr64 
    1c50:	55                   	push   %rbp
    1c51:	48 89 e5             	mov    %rsp,%rbp
    1c54:	48 83 ec 20          	sub    $0x20,%rsp
    1c58:	89 7d ec             	mov    %edi,-0x14(%rbp)
  char *p;
  Header *hp;

  if(nu < 4096)
    1c5b:	81 7d ec ff 0f 00 00 	cmpl   $0xfff,-0x14(%rbp)
    1c62:	77 07                	ja     1c6b <morecore+0x1f>
    nu = 4096;
    1c64:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%rbp)
  p = sbrk(nu * sizeof(Header));
    1c6b:	8b 45 ec             	mov    -0x14(%rbp),%eax
    1c6e:	48 c1 e0 04          	shl    $0x4,%rax
    1c72:	48 89 c7             	mov    %rax,%rdi
    1c75:	48 b8 ec 14 00 00 00 	movabs $0x14ec,%rax
    1c7c:	00 00 00 
    1c7f:	ff d0                	callq  *%rax
    1c81:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  if(p == (char*)-1)
    1c85:	48 83 7d f8 ff       	cmpq   $0xffffffffffffffff,-0x8(%rbp)
    1c8a:	75 07                	jne    1c93 <morecore+0x47>
    return 0;
    1c8c:	b8 00 00 00 00       	mov    $0x0,%eax
    1c91:	eb 36                	jmp    1cc9 <morecore+0x7d>
  hp = (Header*)p;
    1c93:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1c97:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
  hp->s.size = nu;
    1c9b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1c9f:	8b 55 ec             	mov    -0x14(%rbp),%edx
    1ca2:	89 50 08             	mov    %edx,0x8(%rax)
  free((void*)(hp + 1));
    1ca5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1ca9:	48 83 c0 10          	add    $0x10,%rax
    1cad:	48 89 c7             	mov    %rax,%rdi
    1cb0:	48 b8 16 1b 00 00 00 	movabs $0x1b16,%rax
    1cb7:	00 00 00 
    1cba:	ff d0                	callq  *%rax
  return freep;
    1cbc:	48 b8 c0 21 00 00 00 	movabs $0x21c0,%rax
    1cc3:	00 00 00 
    1cc6:	48 8b 00             	mov    (%rax),%rax
}
    1cc9:	c9                   	leaveq 
    1cca:	c3                   	retq   

0000000000001ccb <malloc>:

void*
malloc(uint nbytes)
{
    1ccb:	f3 0f 1e fa          	endbr64 
    1ccf:	55                   	push   %rbp
    1cd0:	48 89 e5             	mov    %rsp,%rbp
    1cd3:	48 83 ec 30          	sub    $0x30,%rsp
    1cd7:	89 7d dc             	mov    %edi,-0x24(%rbp)
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    1cda:	8b 45 dc             	mov    -0x24(%rbp),%eax
    1cdd:	48 83 c0 0f          	add    $0xf,%rax
    1ce1:	48 c1 e8 04          	shr    $0x4,%rax
    1ce5:	83 c0 01             	add    $0x1,%eax
    1ce8:	89 45 ec             	mov    %eax,-0x14(%rbp)
  if((prevp = freep) == 0){
    1ceb:	48 b8 c0 21 00 00 00 	movabs $0x21c0,%rax
    1cf2:	00 00 00 
    1cf5:	48 8b 00             	mov    (%rax),%rax
    1cf8:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
    1cfc:	48 83 7d f0 00       	cmpq   $0x0,-0x10(%rbp)
    1d01:	75 4a                	jne    1d4d <malloc+0x82>
    base.s.ptr = freep = prevp = &base;
    1d03:	48 b8 b0 21 00 00 00 	movabs $0x21b0,%rax
    1d0a:	00 00 00 
    1d0d:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
    1d11:	48 ba c0 21 00 00 00 	movabs $0x21c0,%rdx
    1d18:	00 00 00 
    1d1b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1d1f:	48 89 02             	mov    %rax,(%rdx)
    1d22:	48 b8 c0 21 00 00 00 	movabs $0x21c0,%rax
    1d29:	00 00 00 
    1d2c:	48 8b 00             	mov    (%rax),%rax
    1d2f:	48 ba b0 21 00 00 00 	movabs $0x21b0,%rdx
    1d36:	00 00 00 
    1d39:	48 89 02             	mov    %rax,(%rdx)
    base.s.size = 0;
    1d3c:	48 b8 b0 21 00 00 00 	movabs $0x21b0,%rax
    1d43:	00 00 00 
    1d46:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%rax)
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    1d4d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1d51:	48 8b 00             	mov    (%rax),%rax
    1d54:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
    if(p->s.size >= nunits){
    1d58:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1d5c:	8b 40 08             	mov    0x8(%rax),%eax
    1d5f:	39 45 ec             	cmp    %eax,-0x14(%rbp)
    1d62:	77 65                	ja     1dc9 <malloc+0xfe>
      if(p->s.size == nunits)
    1d64:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1d68:	8b 40 08             	mov    0x8(%rax),%eax
    1d6b:	39 45 ec             	cmp    %eax,-0x14(%rbp)
    1d6e:	75 10                	jne    1d80 <malloc+0xb5>
        prevp->s.ptr = p->s.ptr;
    1d70:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1d74:	48 8b 10             	mov    (%rax),%rdx
    1d77:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1d7b:	48 89 10             	mov    %rdx,(%rax)
    1d7e:	eb 2e                	jmp    1dae <malloc+0xe3>
      else {
        p->s.size -= nunits;
    1d80:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1d84:	8b 40 08             	mov    0x8(%rax),%eax
    1d87:	2b 45 ec             	sub    -0x14(%rbp),%eax
    1d8a:	89 c2                	mov    %eax,%edx
    1d8c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1d90:	89 50 08             	mov    %edx,0x8(%rax)
        p += p->s.size;
    1d93:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1d97:	8b 40 08             	mov    0x8(%rax),%eax
    1d9a:	89 c0                	mov    %eax,%eax
    1d9c:	48 c1 e0 04          	shl    $0x4,%rax
    1da0:	48 01 45 f8          	add    %rax,-0x8(%rbp)
        p->s.size = nunits;
    1da4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1da8:	8b 55 ec             	mov    -0x14(%rbp),%edx
    1dab:	89 50 08             	mov    %edx,0x8(%rax)
      }
      freep = prevp;
    1dae:	48 ba c0 21 00 00 00 	movabs $0x21c0,%rdx
    1db5:	00 00 00 
    1db8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1dbc:	48 89 02             	mov    %rax,(%rdx)
      return (void*)(p + 1);
    1dbf:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1dc3:	48 83 c0 10          	add    $0x10,%rax
    1dc7:	eb 4e                	jmp    1e17 <malloc+0x14c>
    }
    if(p == freep)
    1dc9:	48 b8 c0 21 00 00 00 	movabs $0x21c0,%rax
    1dd0:	00 00 00 
    1dd3:	48 8b 00             	mov    (%rax),%rax
    1dd6:	48 39 45 f8          	cmp    %rax,-0x8(%rbp)
    1dda:	75 23                	jne    1dff <malloc+0x134>
      if((p = morecore(nunits)) == 0)
    1ddc:	8b 45 ec             	mov    -0x14(%rbp),%eax
    1ddf:	89 c7                	mov    %eax,%edi
    1de1:	48 b8 4c 1c 00 00 00 	movabs $0x1c4c,%rax
    1de8:	00 00 00 
    1deb:	ff d0                	callq  *%rax
    1ded:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
    1df1:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
    1df6:	75 07                	jne    1dff <malloc+0x134>
        return 0;
    1df8:	b8 00 00 00 00       	mov    $0x0,%eax
    1dfd:	eb 18                	jmp    1e17 <malloc+0x14c>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    1dff:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1e03:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
    1e07:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1e0b:	48 8b 00             	mov    (%rax),%rax
    1e0e:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
    if(p->s.size >= nunits){
    1e12:	e9 41 ff ff ff       	jmpq   1d58 <malloc+0x8d>
  }
}
    1e17:	c9                   	leaveq 
    1e18:	c3                   	retq   
