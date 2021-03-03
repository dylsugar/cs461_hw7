
_wc:     file format elf64-x86-64


Disassembly of section .text:

0000000000001000 <wc>:

char buf[512];

void
wc(int fd, char *name)
{
    1000:	f3 0f 1e fa          	endbr64 
    1004:	55                   	push   %rbp
    1005:	48 89 e5             	mov    %rsp,%rbp
    1008:	48 83 ec 30          	sub    $0x30,%rsp
    100c:	89 7d dc             	mov    %edi,-0x24(%rbp)
    100f:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  int i, n;
  int l, w, c, inword;

  l = w = c = 0;
    1013:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%rbp)
    101a:	8b 45 f0             	mov    -0x10(%rbp),%eax
    101d:	89 45 f4             	mov    %eax,-0xc(%rbp)
    1020:	8b 45 f4             	mov    -0xc(%rbp),%eax
    1023:	89 45 f8             	mov    %eax,-0x8(%rbp)
  inword = 0;
    1026:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%rbp)
  while((n = read(fd, buf, sizeof(buf))) > 0){
    102d:	e9 81 00 00 00       	jmpq   10b3 <wc+0xb3>
    for(i=0; i<n; i++){
    1032:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
    1039:	eb 70                	jmp    10ab <wc+0xab>
      c++;
    103b:	83 45 f0 01          	addl   $0x1,-0x10(%rbp)
      if(buf[i] == '\n')
    103f:	48 ba 60 23 00 00 00 	movabs $0x2360,%rdx
    1046:	00 00 00 
    1049:	8b 45 fc             	mov    -0x4(%rbp),%eax
    104c:	48 98                	cltq   
    104e:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax
    1052:	3c 0a                	cmp    $0xa,%al
    1054:	75 04                	jne    105a <wc+0x5a>
        l++;
    1056:	83 45 f8 01          	addl   $0x1,-0x8(%rbp)
      if(strchr(" \r\t\n\v", buf[i]))
    105a:	48 ba 60 23 00 00 00 	movabs $0x2360,%rdx
    1061:	00 00 00 
    1064:	8b 45 fc             	mov    -0x4(%rbp),%eax
    1067:	48 98                	cltq   
    1069:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax
    106d:	0f be c0             	movsbl %al,%eax
    1070:	89 c6                	mov    %eax,%esi
    1072:	48 bf b8 1f 00 00 00 	movabs $0x1fb8,%rdi
    1079:	00 00 00 
    107c:	48 b8 b0 13 00 00 00 	movabs $0x13b0,%rax
    1083:	00 00 00 
    1086:	ff d0                	callq  *%rax
    1088:	48 85 c0             	test   %rax,%rax
    108b:	74 09                	je     1096 <wc+0x96>
        inword = 0;
    108d:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%rbp)
    1094:	eb 11                	jmp    10a7 <wc+0xa7>
      else if(!inword){
    1096:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
    109a:	75 0b                	jne    10a7 <wc+0xa7>
        w++;
    109c:	83 45 f4 01          	addl   $0x1,-0xc(%rbp)
        inword = 1;
    10a0:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%rbp)
    for(i=0; i<n; i++){
    10a7:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
    10ab:	8b 45 fc             	mov    -0x4(%rbp),%eax
    10ae:	3b 45 e8             	cmp    -0x18(%rbp),%eax
    10b1:	7c 88                	jl     103b <wc+0x3b>
  while((n = read(fd, buf, sizeof(buf))) > 0){
    10b3:	8b 45 dc             	mov    -0x24(%rbp),%eax
    10b6:	ba 00 02 00 00       	mov    $0x200,%edx
    10bb:	48 be 60 23 00 00 00 	movabs $0x2360,%rsi
    10c2:	00 00 00 
    10c5:	89 c7                	mov    %eax,%edi
    10c7:	48 b8 d5 15 00 00 00 	movabs $0x15d5,%rax
    10ce:	00 00 00 
    10d1:	ff d0                	callq  *%rax
    10d3:	89 45 e8             	mov    %eax,-0x18(%rbp)
    10d6:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
    10da:	0f 8f 52 ff ff ff    	jg     1032 <wc+0x32>
      }
    }
  }
  if(n < 0){
    10e0:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
    10e4:	79 2c                	jns    1112 <wc+0x112>
    printf(1, "wc: read error\n");
    10e6:	48 be be 1f 00 00 00 	movabs $0x1fbe,%rsi
    10ed:	00 00 00 
    10f0:	bf 01 00 00 00       	mov    $0x1,%edi
    10f5:	b8 00 00 00 00       	mov    $0x0,%eax
    10fa:	48 ba a5 18 00 00 00 	movabs $0x18a5,%rdx
    1101:	00 00 00 
    1104:	ff d2                	callq  *%rdx
    exit();
    1106:	48 b8 ae 15 00 00 00 	movabs $0x15ae,%rax
    110d:	00 00 00 
    1110:	ff d0                	callq  *%rax
  }
  printf(1, "%d %d %d %s\n", l, w, c, name);
    1112:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
    1116:	8b 4d f0             	mov    -0x10(%rbp),%ecx
    1119:	8b 55 f4             	mov    -0xc(%rbp),%edx
    111c:	8b 45 f8             	mov    -0x8(%rbp),%eax
    111f:	49 89 f1             	mov    %rsi,%r9
    1122:	41 89 c8             	mov    %ecx,%r8d
    1125:	89 d1                	mov    %edx,%ecx
    1127:	89 c2                	mov    %eax,%edx
    1129:	48 be ce 1f 00 00 00 	movabs $0x1fce,%rsi
    1130:	00 00 00 
    1133:	bf 01 00 00 00       	mov    $0x1,%edi
    1138:	b8 00 00 00 00       	mov    $0x0,%eax
    113d:	49 ba a5 18 00 00 00 	movabs $0x18a5,%r10
    1144:	00 00 00 
    1147:	41 ff d2             	callq  *%r10
}
    114a:	90                   	nop
    114b:	c9                   	leaveq 
    114c:	c3                   	retq   

000000000000114d <main>:

int
main(int argc, char *argv[])
{
    114d:	f3 0f 1e fa          	endbr64 
    1151:	55                   	push   %rbp
    1152:	48 89 e5             	mov    %rsp,%rbp
    1155:	48 83 ec 20          	sub    $0x20,%rsp
    1159:	89 7d ec             	mov    %edi,-0x14(%rbp)
    115c:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  int fd, i;

  if(argc <= 1){
    1160:	83 7d ec 01          	cmpl   $0x1,-0x14(%rbp)
    1164:	7f 27                	jg     118d <main+0x40>
    wc(0, "");
    1166:	48 be db 1f 00 00 00 	movabs $0x1fdb,%rsi
    116d:	00 00 00 
    1170:	bf 00 00 00 00       	mov    $0x0,%edi
    1175:	48 b8 00 10 00 00 00 	movabs $0x1000,%rax
    117c:	00 00 00 
    117f:	ff d0                	callq  *%rax
    exit();
    1181:	48 b8 ae 15 00 00 00 	movabs $0x15ae,%rax
    1188:	00 00 00 
    118b:	ff d0                	callq  *%rax
  }

  for(i = 1; i < argc; i++){
    118d:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)
    1194:	e9 ba 00 00 00       	jmpq   1253 <main+0x106>
    if((fd = open(argv[i], 0)) < 0){
    1199:	8b 45 fc             	mov    -0x4(%rbp),%eax
    119c:	48 98                	cltq   
    119e:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
    11a5:	00 
    11a6:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
    11aa:	48 01 d0             	add    %rdx,%rax
    11ad:	48 8b 00             	mov    (%rax),%rax
    11b0:	be 00 00 00 00       	mov    $0x0,%esi
    11b5:	48 89 c7             	mov    %rax,%rdi
    11b8:	48 b8 16 16 00 00 00 	movabs $0x1616,%rax
    11bf:	00 00 00 
    11c2:	ff d0                	callq  *%rax
    11c4:	89 45 f8             	mov    %eax,-0x8(%rbp)
    11c7:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
    11cb:	79 46                	jns    1213 <main+0xc6>
      printf(1, "wc: cannot open %s\n", argv[i]);
    11cd:	8b 45 fc             	mov    -0x4(%rbp),%eax
    11d0:	48 98                	cltq   
    11d2:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
    11d9:	00 
    11da:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
    11de:	48 01 d0             	add    %rdx,%rax
    11e1:	48 8b 00             	mov    (%rax),%rax
    11e4:	48 89 c2             	mov    %rax,%rdx
    11e7:	48 be dc 1f 00 00 00 	movabs $0x1fdc,%rsi
    11ee:	00 00 00 
    11f1:	bf 01 00 00 00       	mov    $0x1,%edi
    11f6:	b8 00 00 00 00       	mov    $0x0,%eax
    11fb:	48 b9 a5 18 00 00 00 	movabs $0x18a5,%rcx
    1202:	00 00 00 
    1205:	ff d1                	callq  *%rcx
      exit();
    1207:	48 b8 ae 15 00 00 00 	movabs $0x15ae,%rax
    120e:	00 00 00 
    1211:	ff d0                	callq  *%rax
    }
    wc(fd, argv[i]);
    1213:	8b 45 fc             	mov    -0x4(%rbp),%eax
    1216:	48 98                	cltq   
    1218:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
    121f:	00 
    1220:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
    1224:	48 01 d0             	add    %rdx,%rax
    1227:	48 8b 10             	mov    (%rax),%rdx
    122a:	8b 45 f8             	mov    -0x8(%rbp),%eax
    122d:	48 89 d6             	mov    %rdx,%rsi
    1230:	89 c7                	mov    %eax,%edi
    1232:	48 b8 00 10 00 00 00 	movabs $0x1000,%rax
    1239:	00 00 00 
    123c:	ff d0                	callq  *%rax
    close(fd);
    123e:	8b 45 f8             	mov    -0x8(%rbp),%eax
    1241:	89 c7                	mov    %eax,%edi
    1243:	48 b8 ef 15 00 00 00 	movabs $0x15ef,%rax
    124a:	00 00 00 
    124d:	ff d0                	callq  *%rax
  for(i = 1; i < argc; i++){
    124f:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
    1253:	8b 45 fc             	mov    -0x4(%rbp),%eax
    1256:	3b 45 ec             	cmp    -0x14(%rbp),%eax
    1259:	0f 8c 3a ff ff ff    	jl     1199 <main+0x4c>
  }
  exit();
    125f:	48 b8 ae 15 00 00 00 	movabs $0x15ae,%rax
    1266:	00 00 00 
    1269:	ff d0                	callq  *%rax

000000000000126b <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
    126b:	f3 0f 1e fa          	endbr64 
    126f:	55                   	push   %rbp
    1270:	48 89 e5             	mov    %rsp,%rbp
    1273:	48 83 ec 10          	sub    $0x10,%rsp
    1277:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
    127b:	89 75 f4             	mov    %esi,-0xc(%rbp)
    127e:	89 55 f0             	mov    %edx,-0x10(%rbp)
  asm volatile("cld; rep stosb" :
    1281:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
    1285:	8b 55 f0             	mov    -0x10(%rbp),%edx
    1288:	8b 45 f4             	mov    -0xc(%rbp),%eax
    128b:	48 89 ce             	mov    %rcx,%rsi
    128e:	48 89 f7             	mov    %rsi,%rdi
    1291:	89 d1                	mov    %edx,%ecx
    1293:	fc                   	cld    
    1294:	f3 aa                	rep stos %al,%es:(%rdi)
    1296:	89 ca                	mov    %ecx,%edx
    1298:	48 89 fe             	mov    %rdi,%rsi
    129b:	48 89 75 f8          	mov    %rsi,-0x8(%rbp)
    129f:	89 55 f0             	mov    %edx,-0x10(%rbp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
    12a2:	90                   	nop
    12a3:	c9                   	leaveq 
    12a4:	c3                   	retq   

00000000000012a5 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
    12a5:	f3 0f 1e fa          	endbr64 
    12a9:	55                   	push   %rbp
    12aa:	48 89 e5             	mov    %rsp,%rbp
    12ad:	48 83 ec 20          	sub    $0x20,%rsp
    12b1:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
    12b5:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  char *os;

  os = s;
    12b9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    12bd:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  while((*s++ = *t++) != 0)
    12c1:	90                   	nop
    12c2:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
    12c6:	48 8d 42 01          	lea    0x1(%rdx),%rax
    12ca:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
    12ce:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    12d2:	48 8d 48 01          	lea    0x1(%rax),%rcx
    12d6:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
    12da:	0f b6 12             	movzbl (%rdx),%edx
    12dd:	88 10                	mov    %dl,(%rax)
    12df:	0f b6 00             	movzbl (%rax),%eax
    12e2:	84 c0                	test   %al,%al
    12e4:	75 dc                	jne    12c2 <strcpy+0x1d>
    ;
  return os;
    12e6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
    12ea:	c9                   	leaveq 
    12eb:	c3                   	retq   

00000000000012ec <strcmp>:

int
strcmp(const char *p, const char *q)
{
    12ec:	f3 0f 1e fa          	endbr64 
    12f0:	55                   	push   %rbp
    12f1:	48 89 e5             	mov    %rsp,%rbp
    12f4:	48 83 ec 10          	sub    $0x10,%rsp
    12f8:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
    12fc:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  while(*p && *p == *q)
    1300:	eb 0a                	jmp    130c <strcmp+0x20>
    p++, q++;
    1302:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
    1307:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
  while(*p && *p == *q)
    130c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1310:	0f b6 00             	movzbl (%rax),%eax
    1313:	84 c0                	test   %al,%al
    1315:	74 12                	je     1329 <strcmp+0x3d>
    1317:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    131b:	0f b6 10             	movzbl (%rax),%edx
    131e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1322:	0f b6 00             	movzbl (%rax),%eax
    1325:	38 c2                	cmp    %al,%dl
    1327:	74 d9                	je     1302 <strcmp+0x16>
  return (uchar)*p - (uchar)*q;
    1329:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    132d:	0f b6 00             	movzbl (%rax),%eax
    1330:	0f b6 d0             	movzbl %al,%edx
    1333:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1337:	0f b6 00             	movzbl (%rax),%eax
    133a:	0f b6 c0             	movzbl %al,%eax
    133d:	29 c2                	sub    %eax,%edx
    133f:	89 d0                	mov    %edx,%eax
}
    1341:	c9                   	leaveq 
    1342:	c3                   	retq   

0000000000001343 <strlen>:

uint
strlen(char *s)
{
    1343:	f3 0f 1e fa          	endbr64 
    1347:	55                   	push   %rbp
    1348:	48 89 e5             	mov    %rsp,%rbp
    134b:	48 83 ec 18          	sub    $0x18,%rsp
    134f:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  int n;

  for(n = 0; s[n]; n++)
    1353:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
    135a:	eb 04                	jmp    1360 <strlen+0x1d>
    135c:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
    1360:	8b 45 fc             	mov    -0x4(%rbp),%eax
    1363:	48 63 d0             	movslq %eax,%rdx
    1366:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    136a:	48 01 d0             	add    %rdx,%rax
    136d:	0f b6 00             	movzbl (%rax),%eax
    1370:	84 c0                	test   %al,%al
    1372:	75 e8                	jne    135c <strlen+0x19>
    ;
  return n;
    1374:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
    1377:	c9                   	leaveq 
    1378:	c3                   	retq   

0000000000001379 <memset>:

void*
memset(void *dst, int c, uint n)
{
    1379:	f3 0f 1e fa          	endbr64 
    137d:	55                   	push   %rbp
    137e:	48 89 e5             	mov    %rsp,%rbp
    1381:	48 83 ec 10          	sub    $0x10,%rsp
    1385:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
    1389:	89 75 f4             	mov    %esi,-0xc(%rbp)
    138c:	89 55 f0             	mov    %edx,-0x10(%rbp)
  stosb(dst, c, n);
    138f:	8b 55 f0             	mov    -0x10(%rbp),%edx
    1392:	8b 4d f4             	mov    -0xc(%rbp),%ecx
    1395:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1399:	89 ce                	mov    %ecx,%esi
    139b:	48 89 c7             	mov    %rax,%rdi
    139e:	48 b8 6b 12 00 00 00 	movabs $0x126b,%rax
    13a5:	00 00 00 
    13a8:	ff d0                	callq  *%rax
  return dst;
    13aa:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
    13ae:	c9                   	leaveq 
    13af:	c3                   	retq   

00000000000013b0 <strchr>:

char*
strchr(const char *s, char c)
{
    13b0:	f3 0f 1e fa          	endbr64 
    13b4:	55                   	push   %rbp
    13b5:	48 89 e5             	mov    %rsp,%rbp
    13b8:	48 83 ec 10          	sub    $0x10,%rsp
    13bc:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
    13c0:	89 f0                	mov    %esi,%eax
    13c2:	88 45 f4             	mov    %al,-0xc(%rbp)
  for(; *s; s++)
    13c5:	eb 17                	jmp    13de <strchr+0x2e>
    if(*s == c)
    13c7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    13cb:	0f b6 00             	movzbl (%rax),%eax
    13ce:	38 45 f4             	cmp    %al,-0xc(%rbp)
    13d1:	75 06                	jne    13d9 <strchr+0x29>
      return (char*)s;
    13d3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    13d7:	eb 15                	jmp    13ee <strchr+0x3e>
  for(; *s; s++)
    13d9:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
    13de:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    13e2:	0f b6 00             	movzbl (%rax),%eax
    13e5:	84 c0                	test   %al,%al
    13e7:	75 de                	jne    13c7 <strchr+0x17>
  return 0;
    13e9:	b8 00 00 00 00       	mov    $0x0,%eax
}
    13ee:	c9                   	leaveq 
    13ef:	c3                   	retq   

00000000000013f0 <gets>:

char*
gets(char *buf, int max)
{
    13f0:	f3 0f 1e fa          	endbr64 
    13f4:	55                   	push   %rbp
    13f5:	48 89 e5             	mov    %rsp,%rbp
    13f8:	48 83 ec 20          	sub    $0x20,%rsp
    13fc:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
    1400:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    1403:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
    140a:	eb 4f                	jmp    145b <gets+0x6b>
    cc = read(0, &c, 1);
    140c:	48 8d 45 f7          	lea    -0x9(%rbp),%rax
    1410:	ba 01 00 00 00       	mov    $0x1,%edx
    1415:	48 89 c6             	mov    %rax,%rsi
    1418:	bf 00 00 00 00       	mov    $0x0,%edi
    141d:	48 b8 d5 15 00 00 00 	movabs $0x15d5,%rax
    1424:	00 00 00 
    1427:	ff d0                	callq  *%rax
    1429:	89 45 f8             	mov    %eax,-0x8(%rbp)
    if(cc < 1)
    142c:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
    1430:	7e 36                	jle    1468 <gets+0x78>
      break;
    buf[i++] = c;
    1432:	8b 45 fc             	mov    -0x4(%rbp),%eax
    1435:	8d 50 01             	lea    0x1(%rax),%edx
    1438:	89 55 fc             	mov    %edx,-0x4(%rbp)
    143b:	48 63 d0             	movslq %eax,%rdx
    143e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    1442:	48 01 c2             	add    %rax,%rdx
    1445:	0f b6 45 f7          	movzbl -0x9(%rbp),%eax
    1449:	88 02                	mov    %al,(%rdx)
    if(c == '\n' || c == '\r')
    144b:	0f b6 45 f7          	movzbl -0x9(%rbp),%eax
    144f:	3c 0a                	cmp    $0xa,%al
    1451:	74 16                	je     1469 <gets+0x79>
    1453:	0f b6 45 f7          	movzbl -0x9(%rbp),%eax
    1457:	3c 0d                	cmp    $0xd,%al
    1459:	74 0e                	je     1469 <gets+0x79>
  for(i=0; i+1 < max; ){
    145b:	8b 45 fc             	mov    -0x4(%rbp),%eax
    145e:	83 c0 01             	add    $0x1,%eax
    1461:	39 45 e4             	cmp    %eax,-0x1c(%rbp)
    1464:	7f a6                	jg     140c <gets+0x1c>
    1466:	eb 01                	jmp    1469 <gets+0x79>
      break;
    1468:	90                   	nop
      break;
  }
  buf[i] = '\0';
    1469:	8b 45 fc             	mov    -0x4(%rbp),%eax
    146c:	48 63 d0             	movslq %eax,%rdx
    146f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    1473:	48 01 d0             	add    %rdx,%rax
    1476:	c6 00 00             	movb   $0x0,(%rax)
  return buf;
    1479:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
    147d:	c9                   	leaveq 
    147e:	c3                   	retq   

000000000000147f <stat>:

int
stat(char *n, struct stat *st)
{
    147f:	f3 0f 1e fa          	endbr64 
    1483:	55                   	push   %rbp
    1484:	48 89 e5             	mov    %rsp,%rbp
    1487:	48 83 ec 20          	sub    $0x20,%rsp
    148b:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
    148f:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  int fd;
  int r;

  fd = open(n, O_RDONLY);
    1493:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    1497:	be 00 00 00 00       	mov    $0x0,%esi
    149c:	48 89 c7             	mov    %rax,%rdi
    149f:	48 b8 16 16 00 00 00 	movabs $0x1616,%rax
    14a6:	00 00 00 
    14a9:	ff d0                	callq  *%rax
    14ab:	89 45 fc             	mov    %eax,-0x4(%rbp)
  if(fd < 0)
    14ae:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
    14b2:	79 07                	jns    14bb <stat+0x3c>
    return -1;
    14b4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    14b9:	eb 2f                	jmp    14ea <stat+0x6b>
  r = fstat(fd, st);
    14bb:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
    14bf:	8b 45 fc             	mov    -0x4(%rbp),%eax
    14c2:	48 89 d6             	mov    %rdx,%rsi
    14c5:	89 c7                	mov    %eax,%edi
    14c7:	48 b8 3d 16 00 00 00 	movabs $0x163d,%rax
    14ce:	00 00 00 
    14d1:	ff d0                	callq  *%rax
    14d3:	89 45 f8             	mov    %eax,-0x8(%rbp)
  close(fd);
    14d6:	8b 45 fc             	mov    -0x4(%rbp),%eax
    14d9:	89 c7                	mov    %eax,%edi
    14db:	48 b8 ef 15 00 00 00 	movabs $0x15ef,%rax
    14e2:	00 00 00 
    14e5:	ff d0                	callq  *%rax
  return r;
    14e7:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
    14ea:	c9                   	leaveq 
    14eb:	c3                   	retq   

00000000000014ec <atoi>:

int
atoi(const char *s)
{
    14ec:	f3 0f 1e fa          	endbr64 
    14f0:	55                   	push   %rbp
    14f1:	48 89 e5             	mov    %rsp,%rbp
    14f4:	48 83 ec 18          	sub    $0x18,%rsp
    14f8:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  int n;

  n = 0;
    14fc:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  while('0' <= *s && *s <= '9')
    1503:	eb 28                	jmp    152d <atoi+0x41>
    n = n*10 + *s++ - '0';
    1505:	8b 55 fc             	mov    -0x4(%rbp),%edx
    1508:	89 d0                	mov    %edx,%eax
    150a:	c1 e0 02             	shl    $0x2,%eax
    150d:	01 d0                	add    %edx,%eax
    150f:	01 c0                	add    %eax,%eax
    1511:	89 c1                	mov    %eax,%ecx
    1513:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    1517:	48 8d 50 01          	lea    0x1(%rax),%rdx
    151b:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
    151f:	0f b6 00             	movzbl (%rax),%eax
    1522:	0f be c0             	movsbl %al,%eax
    1525:	01 c8                	add    %ecx,%eax
    1527:	83 e8 30             	sub    $0x30,%eax
    152a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  while('0' <= *s && *s <= '9')
    152d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    1531:	0f b6 00             	movzbl (%rax),%eax
    1534:	3c 2f                	cmp    $0x2f,%al
    1536:	7e 0b                	jle    1543 <atoi+0x57>
    1538:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    153c:	0f b6 00             	movzbl (%rax),%eax
    153f:	3c 39                	cmp    $0x39,%al
    1541:	7e c2                	jle    1505 <atoi+0x19>
  return n;
    1543:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
    1546:	c9                   	leaveq 
    1547:	c3                   	retq   

0000000000001548 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
    1548:	f3 0f 1e fa          	endbr64 
    154c:	55                   	push   %rbp
    154d:	48 89 e5             	mov    %rsp,%rbp
    1550:	48 83 ec 28          	sub    $0x28,%rsp
    1554:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
    1558:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
    155c:	89 55 dc             	mov    %edx,-0x24(%rbp)
  char *dst, *src;

  dst = vdst;
    155f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    1563:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  src = vsrc;
    1567:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
    156b:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
  while(n-- > 0)
    156f:	eb 1d                	jmp    158e <memmove+0x46>
    *dst++ = *src++;
    1571:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
    1575:	48 8d 42 01          	lea    0x1(%rdx),%rax
    1579:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
    157d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1581:	48 8d 48 01          	lea    0x1(%rax),%rcx
    1585:	48 89 4d f8          	mov    %rcx,-0x8(%rbp)
    1589:	0f b6 12             	movzbl (%rdx),%edx
    158c:	88 10                	mov    %dl,(%rax)
  while(n-- > 0)
    158e:	8b 45 dc             	mov    -0x24(%rbp),%eax
    1591:	8d 50 ff             	lea    -0x1(%rax),%edx
    1594:	89 55 dc             	mov    %edx,-0x24(%rbp)
    1597:	85 c0                	test   %eax,%eax
    1599:	7f d6                	jg     1571 <memmove+0x29>
  return vdst;
    159b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
    159f:	c9                   	leaveq 
    15a0:	c3                   	retq   

00000000000015a1 <fork>:
    mov $SYS_ ## name, %rax; \
    mov %rcx, %r10 ;\
    syscall		  ;\
    ret

SYSCALL(fork)
    15a1:	48 c7 c0 01 00 00 00 	mov    $0x1,%rax
    15a8:	49 89 ca             	mov    %rcx,%r10
    15ab:	0f 05                	syscall 
    15ad:	c3                   	retq   

00000000000015ae <exit>:
SYSCALL(exit)
    15ae:	48 c7 c0 02 00 00 00 	mov    $0x2,%rax
    15b5:	49 89 ca             	mov    %rcx,%r10
    15b8:	0f 05                	syscall 
    15ba:	c3                   	retq   

00000000000015bb <wait>:
SYSCALL(wait)
    15bb:	48 c7 c0 03 00 00 00 	mov    $0x3,%rax
    15c2:	49 89 ca             	mov    %rcx,%r10
    15c5:	0f 05                	syscall 
    15c7:	c3                   	retq   

00000000000015c8 <pipe>:
SYSCALL(pipe)
    15c8:	48 c7 c0 04 00 00 00 	mov    $0x4,%rax
    15cf:	49 89 ca             	mov    %rcx,%r10
    15d2:	0f 05                	syscall 
    15d4:	c3                   	retq   

00000000000015d5 <read>:
SYSCALL(read)
    15d5:	48 c7 c0 05 00 00 00 	mov    $0x5,%rax
    15dc:	49 89 ca             	mov    %rcx,%r10
    15df:	0f 05                	syscall 
    15e1:	c3                   	retq   

00000000000015e2 <write>:
SYSCALL(write)
    15e2:	48 c7 c0 10 00 00 00 	mov    $0x10,%rax
    15e9:	49 89 ca             	mov    %rcx,%r10
    15ec:	0f 05                	syscall 
    15ee:	c3                   	retq   

00000000000015ef <close>:
SYSCALL(close)
    15ef:	48 c7 c0 15 00 00 00 	mov    $0x15,%rax
    15f6:	49 89 ca             	mov    %rcx,%r10
    15f9:	0f 05                	syscall 
    15fb:	c3                   	retq   

00000000000015fc <kill>:
SYSCALL(kill)
    15fc:	48 c7 c0 06 00 00 00 	mov    $0x6,%rax
    1603:	49 89 ca             	mov    %rcx,%r10
    1606:	0f 05                	syscall 
    1608:	c3                   	retq   

0000000000001609 <exec>:
SYSCALL(exec)
    1609:	48 c7 c0 07 00 00 00 	mov    $0x7,%rax
    1610:	49 89 ca             	mov    %rcx,%r10
    1613:	0f 05                	syscall 
    1615:	c3                   	retq   

0000000000001616 <open>:
SYSCALL(open)
    1616:	48 c7 c0 0f 00 00 00 	mov    $0xf,%rax
    161d:	49 89 ca             	mov    %rcx,%r10
    1620:	0f 05                	syscall 
    1622:	c3                   	retq   

0000000000001623 <mknod>:
SYSCALL(mknod)
    1623:	48 c7 c0 11 00 00 00 	mov    $0x11,%rax
    162a:	49 89 ca             	mov    %rcx,%r10
    162d:	0f 05                	syscall 
    162f:	c3                   	retq   

0000000000001630 <unlink>:
SYSCALL(unlink)
    1630:	48 c7 c0 12 00 00 00 	mov    $0x12,%rax
    1637:	49 89 ca             	mov    %rcx,%r10
    163a:	0f 05                	syscall 
    163c:	c3                   	retq   

000000000000163d <fstat>:
SYSCALL(fstat)
    163d:	48 c7 c0 08 00 00 00 	mov    $0x8,%rax
    1644:	49 89 ca             	mov    %rcx,%r10
    1647:	0f 05                	syscall 
    1649:	c3                   	retq   

000000000000164a <link>:
SYSCALL(link)
    164a:	48 c7 c0 13 00 00 00 	mov    $0x13,%rax
    1651:	49 89 ca             	mov    %rcx,%r10
    1654:	0f 05                	syscall 
    1656:	c3                   	retq   

0000000000001657 <mkdir>:
SYSCALL(mkdir)
    1657:	48 c7 c0 14 00 00 00 	mov    $0x14,%rax
    165e:	49 89 ca             	mov    %rcx,%r10
    1661:	0f 05                	syscall 
    1663:	c3                   	retq   

0000000000001664 <chdir>:
SYSCALL(chdir)
    1664:	48 c7 c0 09 00 00 00 	mov    $0x9,%rax
    166b:	49 89 ca             	mov    %rcx,%r10
    166e:	0f 05                	syscall 
    1670:	c3                   	retq   

0000000000001671 <dup>:
SYSCALL(dup)
    1671:	48 c7 c0 0a 00 00 00 	mov    $0xa,%rax
    1678:	49 89 ca             	mov    %rcx,%r10
    167b:	0f 05                	syscall 
    167d:	c3                   	retq   

000000000000167e <getpid>:
SYSCALL(getpid)
    167e:	48 c7 c0 0b 00 00 00 	mov    $0xb,%rax
    1685:	49 89 ca             	mov    %rcx,%r10
    1688:	0f 05                	syscall 
    168a:	c3                   	retq   

000000000000168b <sbrk>:
SYSCALL(sbrk)
    168b:	48 c7 c0 0c 00 00 00 	mov    $0xc,%rax
    1692:	49 89 ca             	mov    %rcx,%r10
    1695:	0f 05                	syscall 
    1697:	c3                   	retq   

0000000000001698 <sleep>:
SYSCALL(sleep)
    1698:	48 c7 c0 0d 00 00 00 	mov    $0xd,%rax
    169f:	49 89 ca             	mov    %rcx,%r10
    16a2:	0f 05                	syscall 
    16a4:	c3                   	retq   

00000000000016a5 <uptime>:
SYSCALL(uptime)
    16a5:	48 c7 c0 0e 00 00 00 	mov    $0xe,%rax
    16ac:	49 89 ca             	mov    %rcx,%r10
    16af:	0f 05                	syscall 
    16b1:	c3                   	retq   

00000000000016b2 <aread>:
SYSCALL(aread)
    16b2:	48 c7 c0 16 00 00 00 	mov    $0x16,%rax
    16b9:	49 89 ca             	mov    %rcx,%r10
    16bc:	0f 05                	syscall 
    16be:	c3                   	retq   

00000000000016bf <putc>:

#include <stdarg.h>

static void
putc(int fd, char c)
{
    16bf:	f3 0f 1e fa          	endbr64 
    16c3:	55                   	push   %rbp
    16c4:	48 89 e5             	mov    %rsp,%rbp
    16c7:	48 83 ec 10          	sub    $0x10,%rsp
    16cb:	89 7d fc             	mov    %edi,-0x4(%rbp)
    16ce:	89 f0                	mov    %esi,%eax
    16d0:	88 45 f8             	mov    %al,-0x8(%rbp)
  write(fd, &c, 1);
    16d3:	48 8d 4d f8          	lea    -0x8(%rbp),%rcx
    16d7:	8b 45 fc             	mov    -0x4(%rbp),%eax
    16da:	ba 01 00 00 00       	mov    $0x1,%edx
    16df:	48 89 ce             	mov    %rcx,%rsi
    16e2:	89 c7                	mov    %eax,%edi
    16e4:	48 b8 e2 15 00 00 00 	movabs $0x15e2,%rax
    16eb:	00 00 00 
    16ee:	ff d0                	callq  *%rax
}
    16f0:	90                   	nop
    16f1:	c9                   	leaveq 
    16f2:	c3                   	retq   

00000000000016f3 <print_x64>:

static char digits[] = "0123456789abcdef";

  static void
print_x64(int fd, addr_t x)
{
    16f3:	f3 0f 1e fa          	endbr64 
    16f7:	55                   	push   %rbp
    16f8:	48 89 e5             	mov    %rsp,%rbp
    16fb:	48 83 ec 20          	sub    $0x20,%rsp
    16ff:	89 7d ec             	mov    %edi,-0x14(%rbp)
    1702:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  int i;
  for (i = 0; i < (sizeof(addr_t) * 2); i++, x <<= 4)
    1706:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
    170d:	eb 35                	jmp    1744 <print_x64+0x51>
    putc(fd, digits[x >> (sizeof(addr_t) * 8 - 4)]);
    170f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
    1713:	48 c1 e8 3c          	shr    $0x3c,%rax
    1717:	48 ba 40 23 00 00 00 	movabs $0x2340,%rdx
    171e:	00 00 00 
    1721:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax
    1725:	0f be d0             	movsbl %al,%edx
    1728:	8b 45 ec             	mov    -0x14(%rbp),%eax
    172b:	89 d6                	mov    %edx,%esi
    172d:	89 c7                	mov    %eax,%edi
    172f:	48 b8 bf 16 00 00 00 	movabs $0x16bf,%rax
    1736:	00 00 00 
    1739:	ff d0                	callq  *%rax
  for (i = 0; i < (sizeof(addr_t) * 2); i++, x <<= 4)
    173b:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
    173f:	48 c1 65 e0 04       	shlq   $0x4,-0x20(%rbp)
    1744:	8b 45 fc             	mov    -0x4(%rbp),%eax
    1747:	83 f8 0f             	cmp    $0xf,%eax
    174a:	76 c3                	jbe    170f <print_x64+0x1c>
}
    174c:	90                   	nop
    174d:	90                   	nop
    174e:	c9                   	leaveq 
    174f:	c3                   	retq   

0000000000001750 <print_x32>:

  static void
print_x32(int fd, uint x)
{
    1750:	f3 0f 1e fa          	endbr64 
    1754:	55                   	push   %rbp
    1755:	48 89 e5             	mov    %rsp,%rbp
    1758:	48 83 ec 20          	sub    $0x20,%rsp
    175c:	89 7d ec             	mov    %edi,-0x14(%rbp)
    175f:	89 75 e8             	mov    %esi,-0x18(%rbp)
  int i;
  for (i = 0; i < (sizeof(uint) * 2); i++, x <<= 4)
    1762:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
    1769:	eb 36                	jmp    17a1 <print_x32+0x51>
    putc(fd, digits[x >> (sizeof(uint) * 8 - 4)]);
    176b:	8b 45 e8             	mov    -0x18(%rbp),%eax
    176e:	c1 e8 1c             	shr    $0x1c,%eax
    1771:	89 c2                	mov    %eax,%edx
    1773:	48 b8 40 23 00 00 00 	movabs $0x2340,%rax
    177a:	00 00 00 
    177d:	89 d2                	mov    %edx,%edx
    177f:	0f b6 04 10          	movzbl (%rax,%rdx,1),%eax
    1783:	0f be d0             	movsbl %al,%edx
    1786:	8b 45 ec             	mov    -0x14(%rbp),%eax
    1789:	89 d6                	mov    %edx,%esi
    178b:	89 c7                	mov    %eax,%edi
    178d:	48 b8 bf 16 00 00 00 	movabs $0x16bf,%rax
    1794:	00 00 00 
    1797:	ff d0                	callq  *%rax
  for (i = 0; i < (sizeof(uint) * 2); i++, x <<= 4)
    1799:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
    179d:	c1 65 e8 04          	shll   $0x4,-0x18(%rbp)
    17a1:	8b 45 fc             	mov    -0x4(%rbp),%eax
    17a4:	83 f8 07             	cmp    $0x7,%eax
    17a7:	76 c2                	jbe    176b <print_x32+0x1b>
}
    17a9:	90                   	nop
    17aa:	90                   	nop
    17ab:	c9                   	leaveq 
    17ac:	c3                   	retq   

00000000000017ad <print_d>:

  static void
print_d(int fd, int v)
{
    17ad:	f3 0f 1e fa          	endbr64 
    17b1:	55                   	push   %rbp
    17b2:	48 89 e5             	mov    %rsp,%rbp
    17b5:	48 83 ec 30          	sub    $0x30,%rsp
    17b9:	89 7d dc             	mov    %edi,-0x24(%rbp)
    17bc:	89 75 d8             	mov    %esi,-0x28(%rbp)
  char buf[16];
  int64 x = v;
    17bf:	8b 45 d8             	mov    -0x28(%rbp),%eax
    17c2:	48 98                	cltq   
    17c4:	48 89 45 f8          	mov    %rax,-0x8(%rbp)

  if (v < 0)
    17c8:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
    17cc:	79 04                	jns    17d2 <print_d+0x25>
    x = -x;
    17ce:	48 f7 5d f8          	negq   -0x8(%rbp)

  int i = 0;
    17d2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%rbp)
  do {
    buf[i++] = digits[x % 10];
    17d9:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
    17dd:	48 ba 67 66 66 66 66 	movabs $0x6666666666666667,%rdx
    17e4:	66 66 66 
    17e7:	48 89 c8             	mov    %rcx,%rax
    17ea:	48 f7 ea             	imul   %rdx
    17ed:	48 c1 fa 02          	sar    $0x2,%rdx
    17f1:	48 89 c8             	mov    %rcx,%rax
    17f4:	48 c1 f8 3f          	sar    $0x3f,%rax
    17f8:	48 29 c2             	sub    %rax,%rdx
    17fb:	48 89 d0             	mov    %rdx,%rax
    17fe:	48 c1 e0 02          	shl    $0x2,%rax
    1802:	48 01 d0             	add    %rdx,%rax
    1805:	48 01 c0             	add    %rax,%rax
    1808:	48 29 c1             	sub    %rax,%rcx
    180b:	48 89 ca             	mov    %rcx,%rdx
    180e:	8b 45 f4             	mov    -0xc(%rbp),%eax
    1811:	8d 48 01             	lea    0x1(%rax),%ecx
    1814:	89 4d f4             	mov    %ecx,-0xc(%rbp)
    1817:	48 b9 40 23 00 00 00 	movabs $0x2340,%rcx
    181e:	00 00 00 
    1821:	0f b6 14 11          	movzbl (%rcx,%rdx,1),%edx
    1825:	48 98                	cltq   
    1827:	88 54 05 e0          	mov    %dl,-0x20(%rbp,%rax,1)
    x /= 10;
    182b:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
    182f:	48 ba 67 66 66 66 66 	movabs $0x6666666666666667,%rdx
    1836:	66 66 66 
    1839:	48 89 c8             	mov    %rcx,%rax
    183c:	48 f7 ea             	imul   %rdx
    183f:	48 c1 fa 02          	sar    $0x2,%rdx
    1843:	48 89 c8             	mov    %rcx,%rax
    1846:	48 c1 f8 3f          	sar    $0x3f,%rax
    184a:	48 29 c2             	sub    %rax,%rdx
    184d:	48 89 d0             	mov    %rdx,%rax
    1850:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  } while(x != 0);
    1854:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
    1859:	0f 85 7a ff ff ff    	jne    17d9 <print_d+0x2c>

  if (v < 0)
    185f:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
    1863:	79 32                	jns    1897 <print_d+0xea>
    buf[i++] = '-';
    1865:	8b 45 f4             	mov    -0xc(%rbp),%eax
    1868:	8d 50 01             	lea    0x1(%rax),%edx
    186b:	89 55 f4             	mov    %edx,-0xc(%rbp)
    186e:	48 98                	cltq   
    1870:	c6 44 05 e0 2d       	movb   $0x2d,-0x20(%rbp,%rax,1)

  while (--i >= 0)
    1875:	eb 20                	jmp    1897 <print_d+0xea>
    putc(fd, buf[i]);
    1877:	8b 45 f4             	mov    -0xc(%rbp),%eax
    187a:	48 98                	cltq   
    187c:	0f b6 44 05 e0       	movzbl -0x20(%rbp,%rax,1),%eax
    1881:	0f be d0             	movsbl %al,%edx
    1884:	8b 45 dc             	mov    -0x24(%rbp),%eax
    1887:	89 d6                	mov    %edx,%esi
    1889:	89 c7                	mov    %eax,%edi
    188b:	48 b8 bf 16 00 00 00 	movabs $0x16bf,%rax
    1892:	00 00 00 
    1895:	ff d0                	callq  *%rax
  while (--i >= 0)
    1897:	83 6d f4 01          	subl   $0x1,-0xc(%rbp)
    189b:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
    189f:	79 d6                	jns    1877 <print_d+0xca>
}
    18a1:	90                   	nop
    18a2:	90                   	nop
    18a3:	c9                   	leaveq 
    18a4:	c3                   	retq   

00000000000018a5 <printf>:
// Print to the given fd. Only understands %d, %x, %p, %s.
  void
printf(int fd, char *fmt, ...)
{
    18a5:	f3 0f 1e fa          	endbr64 
    18a9:	55                   	push   %rbp
    18aa:	48 89 e5             	mov    %rsp,%rbp
    18ad:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
    18b4:	89 bd 1c ff ff ff    	mov    %edi,-0xe4(%rbp)
    18ba:	48 89 b5 10 ff ff ff 	mov    %rsi,-0xf0(%rbp)
    18c1:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
    18c8:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
    18cf:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
    18d6:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
    18dd:	84 c0                	test   %al,%al
    18df:	74 20                	je     1901 <printf+0x5c>
    18e1:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
    18e5:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
    18e9:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
    18ed:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
    18f1:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
    18f5:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
    18f9:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
    18fd:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  va_list ap;
  int i, c;
  char *s;

  va_start(ap, fmt);
    1901:	c7 85 20 ff ff ff 10 	movl   $0x10,-0xe0(%rbp)
    1908:	00 00 00 
    190b:	c7 85 24 ff ff ff 30 	movl   $0x30,-0xdc(%rbp)
    1912:	00 00 00 
    1915:	48 8d 45 10          	lea    0x10(%rbp),%rax
    1919:	48 89 85 28 ff ff ff 	mov    %rax,-0xd8(%rbp)
    1920:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
    1927:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  for (i = 0; (c = fmt[i] & 0xff) != 0; i++) {
    192e:	c7 85 4c ff ff ff 00 	movl   $0x0,-0xb4(%rbp)
    1935:	00 00 00 
    1938:	e9 41 03 00 00       	jmpq   1c7e <printf+0x3d9>
    if (c != '%') {
    193d:	83 bd 3c ff ff ff 25 	cmpl   $0x25,-0xc4(%rbp)
    1944:	74 24                	je     196a <printf+0xc5>
      putc(fd, c);
    1946:	8b 85 3c ff ff ff    	mov    -0xc4(%rbp),%eax
    194c:	0f be d0             	movsbl %al,%edx
    194f:	8b 85 1c ff ff ff    	mov    -0xe4(%rbp),%eax
    1955:	89 d6                	mov    %edx,%esi
    1957:	89 c7                	mov    %eax,%edi
    1959:	48 b8 bf 16 00 00 00 	movabs $0x16bf,%rax
    1960:	00 00 00 
    1963:	ff d0                	callq  *%rax
      continue;
    1965:	e9 0d 03 00 00       	jmpq   1c77 <printf+0x3d2>
    }
    c = fmt[++i] & 0xff;
    196a:	83 85 4c ff ff ff 01 	addl   $0x1,-0xb4(%rbp)
    1971:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
    1977:	48 63 d0             	movslq %eax,%rdx
    197a:	48 8b 85 10 ff ff ff 	mov    -0xf0(%rbp),%rax
    1981:	48 01 d0             	add    %rdx,%rax
    1984:	0f b6 00             	movzbl (%rax),%eax
    1987:	0f be c0             	movsbl %al,%eax
    198a:	25 ff 00 00 00       	and    $0xff,%eax
    198f:	89 85 3c ff ff ff    	mov    %eax,-0xc4(%rbp)
    if (c == 0)
    1995:	83 bd 3c ff ff ff 00 	cmpl   $0x0,-0xc4(%rbp)
    199c:	0f 84 0f 03 00 00    	je     1cb1 <printf+0x40c>
      break;
    switch(c) {
    19a2:	83 bd 3c ff ff ff 25 	cmpl   $0x25,-0xc4(%rbp)
    19a9:	0f 84 74 02 00 00    	je     1c23 <printf+0x37e>
    19af:	83 bd 3c ff ff ff 25 	cmpl   $0x25,-0xc4(%rbp)
    19b6:	0f 8c 82 02 00 00    	jl     1c3e <printf+0x399>
    19bc:	83 bd 3c ff ff ff 78 	cmpl   $0x78,-0xc4(%rbp)
    19c3:	0f 8f 75 02 00 00    	jg     1c3e <printf+0x399>
    19c9:	83 bd 3c ff ff ff 63 	cmpl   $0x63,-0xc4(%rbp)
    19d0:	0f 8c 68 02 00 00    	jl     1c3e <printf+0x399>
    19d6:	8b 85 3c ff ff ff    	mov    -0xc4(%rbp),%eax
    19dc:	83 e8 63             	sub    $0x63,%eax
    19df:	83 f8 15             	cmp    $0x15,%eax
    19e2:	0f 87 56 02 00 00    	ja     1c3e <printf+0x399>
    19e8:	89 c0                	mov    %eax,%eax
    19ea:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
    19f1:	00 
    19f2:	48 b8 f8 1f 00 00 00 	movabs $0x1ff8,%rax
    19f9:	00 00 00 
    19fc:	48 01 d0             	add    %rdx,%rax
    19ff:	48 8b 00             	mov    (%rax),%rax
    1a02:	3e ff e0             	notrack jmpq *%rax
    case 'c':
      putc(fd, va_arg(ap, int));
    1a05:	8b 85 20 ff ff ff    	mov    -0xe0(%rbp),%eax
    1a0b:	83 f8 2f             	cmp    $0x2f,%eax
    1a0e:	77 23                	ja     1a33 <printf+0x18e>
    1a10:	48 8b 85 30 ff ff ff 	mov    -0xd0(%rbp),%rax
    1a17:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    1a1d:	89 d2                	mov    %edx,%edx
    1a1f:	48 01 d0             	add    %rdx,%rax
    1a22:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    1a28:	83 c2 08             	add    $0x8,%edx
    1a2b:	89 95 20 ff ff ff    	mov    %edx,-0xe0(%rbp)
    1a31:	eb 12                	jmp    1a45 <printf+0x1a0>
    1a33:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
    1a3a:	48 8d 50 08          	lea    0x8(%rax),%rdx
    1a3e:	48 89 95 28 ff ff ff 	mov    %rdx,-0xd8(%rbp)
    1a45:	8b 00                	mov    (%rax),%eax
    1a47:	0f be d0             	movsbl %al,%edx
    1a4a:	8b 85 1c ff ff ff    	mov    -0xe4(%rbp),%eax
    1a50:	89 d6                	mov    %edx,%esi
    1a52:	89 c7                	mov    %eax,%edi
    1a54:	48 b8 bf 16 00 00 00 	movabs $0x16bf,%rax
    1a5b:	00 00 00 
    1a5e:	ff d0                	callq  *%rax
      break;
    1a60:	e9 12 02 00 00       	jmpq   1c77 <printf+0x3d2>
    case 'd':
      print_d(fd, va_arg(ap, int));
    1a65:	8b 85 20 ff ff ff    	mov    -0xe0(%rbp),%eax
    1a6b:	83 f8 2f             	cmp    $0x2f,%eax
    1a6e:	77 23                	ja     1a93 <printf+0x1ee>
    1a70:	48 8b 85 30 ff ff ff 	mov    -0xd0(%rbp),%rax
    1a77:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    1a7d:	89 d2                	mov    %edx,%edx
    1a7f:	48 01 d0             	add    %rdx,%rax
    1a82:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    1a88:	83 c2 08             	add    $0x8,%edx
    1a8b:	89 95 20 ff ff ff    	mov    %edx,-0xe0(%rbp)
    1a91:	eb 12                	jmp    1aa5 <printf+0x200>
    1a93:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
    1a9a:	48 8d 50 08          	lea    0x8(%rax),%rdx
    1a9e:	48 89 95 28 ff ff ff 	mov    %rdx,-0xd8(%rbp)
    1aa5:	8b 10                	mov    (%rax),%edx
    1aa7:	8b 85 1c ff ff ff    	mov    -0xe4(%rbp),%eax
    1aad:	89 d6                	mov    %edx,%esi
    1aaf:	89 c7                	mov    %eax,%edi
    1ab1:	48 b8 ad 17 00 00 00 	movabs $0x17ad,%rax
    1ab8:	00 00 00 
    1abb:	ff d0                	callq  *%rax
      break;
    1abd:	e9 b5 01 00 00       	jmpq   1c77 <printf+0x3d2>
    case 'x':
      print_x32(fd, va_arg(ap, uint));
    1ac2:	8b 85 20 ff ff ff    	mov    -0xe0(%rbp),%eax
    1ac8:	83 f8 2f             	cmp    $0x2f,%eax
    1acb:	77 23                	ja     1af0 <printf+0x24b>
    1acd:	48 8b 85 30 ff ff ff 	mov    -0xd0(%rbp),%rax
    1ad4:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    1ada:	89 d2                	mov    %edx,%edx
    1adc:	48 01 d0             	add    %rdx,%rax
    1adf:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    1ae5:	83 c2 08             	add    $0x8,%edx
    1ae8:	89 95 20 ff ff ff    	mov    %edx,-0xe0(%rbp)
    1aee:	eb 12                	jmp    1b02 <printf+0x25d>
    1af0:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
    1af7:	48 8d 50 08          	lea    0x8(%rax),%rdx
    1afb:	48 89 95 28 ff ff ff 	mov    %rdx,-0xd8(%rbp)
    1b02:	8b 10                	mov    (%rax),%edx
    1b04:	8b 85 1c ff ff ff    	mov    -0xe4(%rbp),%eax
    1b0a:	89 d6                	mov    %edx,%esi
    1b0c:	89 c7                	mov    %eax,%edi
    1b0e:	48 b8 50 17 00 00 00 	movabs $0x1750,%rax
    1b15:	00 00 00 
    1b18:	ff d0                	callq  *%rax
      break;
    1b1a:	e9 58 01 00 00       	jmpq   1c77 <printf+0x3d2>
    case 'p':
      print_x64(fd, va_arg(ap, addr_t));
    1b1f:	8b 85 20 ff ff ff    	mov    -0xe0(%rbp),%eax
    1b25:	83 f8 2f             	cmp    $0x2f,%eax
    1b28:	77 23                	ja     1b4d <printf+0x2a8>
    1b2a:	48 8b 85 30 ff ff ff 	mov    -0xd0(%rbp),%rax
    1b31:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    1b37:	89 d2                	mov    %edx,%edx
    1b39:	48 01 d0             	add    %rdx,%rax
    1b3c:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    1b42:	83 c2 08             	add    $0x8,%edx
    1b45:	89 95 20 ff ff ff    	mov    %edx,-0xe0(%rbp)
    1b4b:	eb 12                	jmp    1b5f <printf+0x2ba>
    1b4d:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
    1b54:	48 8d 50 08          	lea    0x8(%rax),%rdx
    1b58:	48 89 95 28 ff ff ff 	mov    %rdx,-0xd8(%rbp)
    1b5f:	48 8b 10             	mov    (%rax),%rdx
    1b62:	8b 85 1c ff ff ff    	mov    -0xe4(%rbp),%eax
    1b68:	48 89 d6             	mov    %rdx,%rsi
    1b6b:	89 c7                	mov    %eax,%edi
    1b6d:	48 b8 f3 16 00 00 00 	movabs $0x16f3,%rax
    1b74:	00 00 00 
    1b77:	ff d0                	callq  *%rax
      break;
    1b79:	e9 f9 00 00 00       	jmpq   1c77 <printf+0x3d2>
    case 's':
      if ((s = va_arg(ap, char*)) == 0)
    1b7e:	8b 85 20 ff ff ff    	mov    -0xe0(%rbp),%eax
    1b84:	83 f8 2f             	cmp    $0x2f,%eax
    1b87:	77 23                	ja     1bac <printf+0x307>
    1b89:	48 8b 85 30 ff ff ff 	mov    -0xd0(%rbp),%rax
    1b90:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    1b96:	89 d2                	mov    %edx,%edx
    1b98:	48 01 d0             	add    %rdx,%rax
    1b9b:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    1ba1:	83 c2 08             	add    $0x8,%edx
    1ba4:	89 95 20 ff ff ff    	mov    %edx,-0xe0(%rbp)
    1baa:	eb 12                	jmp    1bbe <printf+0x319>
    1bac:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
    1bb3:	48 8d 50 08          	lea    0x8(%rax),%rdx
    1bb7:	48 89 95 28 ff ff ff 	mov    %rdx,-0xd8(%rbp)
    1bbe:	48 8b 00             	mov    (%rax),%rax
    1bc1:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
    1bc8:	48 83 bd 40 ff ff ff 	cmpq   $0x0,-0xc0(%rbp)
    1bcf:	00 
    1bd0:	75 41                	jne    1c13 <printf+0x36e>
        s = "(null)";
    1bd2:	48 b8 f0 1f 00 00 00 	movabs $0x1ff0,%rax
    1bd9:	00 00 00 
    1bdc:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
      while (*s)
    1be3:	eb 2e                	jmp    1c13 <printf+0x36e>
        putc(fd, *(s++));
    1be5:	48 8b 85 40 ff ff ff 	mov    -0xc0(%rbp),%rax
    1bec:	48 8d 50 01          	lea    0x1(%rax),%rdx
    1bf0:	48 89 95 40 ff ff ff 	mov    %rdx,-0xc0(%rbp)
    1bf7:	0f b6 00             	movzbl (%rax),%eax
    1bfa:	0f be d0             	movsbl %al,%edx
    1bfd:	8b 85 1c ff ff ff    	mov    -0xe4(%rbp),%eax
    1c03:	89 d6                	mov    %edx,%esi
    1c05:	89 c7                	mov    %eax,%edi
    1c07:	48 b8 bf 16 00 00 00 	movabs $0x16bf,%rax
    1c0e:	00 00 00 
    1c11:	ff d0                	callq  *%rax
      while (*s)
    1c13:	48 8b 85 40 ff ff ff 	mov    -0xc0(%rbp),%rax
    1c1a:	0f b6 00             	movzbl (%rax),%eax
    1c1d:	84 c0                	test   %al,%al
    1c1f:	75 c4                	jne    1be5 <printf+0x340>
      break;
    1c21:	eb 54                	jmp    1c77 <printf+0x3d2>
    case '%':
      putc(fd, '%');
    1c23:	8b 85 1c ff ff ff    	mov    -0xe4(%rbp),%eax
    1c29:	be 25 00 00 00       	mov    $0x25,%esi
    1c2e:	89 c7                	mov    %eax,%edi
    1c30:	48 b8 bf 16 00 00 00 	movabs $0x16bf,%rax
    1c37:	00 00 00 
    1c3a:	ff d0                	callq  *%rax
      break;
    1c3c:	eb 39                	jmp    1c77 <printf+0x3d2>
    default:
      // Print unknown % sequence to draw attention.
      putc(fd, '%');
    1c3e:	8b 85 1c ff ff ff    	mov    -0xe4(%rbp),%eax
    1c44:	be 25 00 00 00       	mov    $0x25,%esi
    1c49:	89 c7                	mov    %eax,%edi
    1c4b:	48 b8 bf 16 00 00 00 	movabs $0x16bf,%rax
    1c52:	00 00 00 
    1c55:	ff d0                	callq  *%rax
      putc(fd, c);
    1c57:	8b 85 3c ff ff ff    	mov    -0xc4(%rbp),%eax
    1c5d:	0f be d0             	movsbl %al,%edx
    1c60:	8b 85 1c ff ff ff    	mov    -0xe4(%rbp),%eax
    1c66:	89 d6                	mov    %edx,%esi
    1c68:	89 c7                	mov    %eax,%edi
    1c6a:	48 b8 bf 16 00 00 00 	movabs $0x16bf,%rax
    1c71:	00 00 00 
    1c74:	ff d0                	callq  *%rax
      break;
    1c76:	90                   	nop
  for (i = 0; (c = fmt[i] & 0xff) != 0; i++) {
    1c77:	83 85 4c ff ff ff 01 	addl   $0x1,-0xb4(%rbp)
    1c7e:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
    1c84:	48 63 d0             	movslq %eax,%rdx
    1c87:	48 8b 85 10 ff ff ff 	mov    -0xf0(%rbp),%rax
    1c8e:	48 01 d0             	add    %rdx,%rax
    1c91:	0f b6 00             	movzbl (%rax),%eax
    1c94:	0f be c0             	movsbl %al,%eax
    1c97:	25 ff 00 00 00       	and    $0xff,%eax
    1c9c:	89 85 3c ff ff ff    	mov    %eax,-0xc4(%rbp)
    1ca2:	83 bd 3c ff ff ff 00 	cmpl   $0x0,-0xc4(%rbp)
    1ca9:	0f 85 8e fc ff ff    	jne    193d <printf+0x98>
    }
  }
}
    1caf:	eb 01                	jmp    1cb2 <printf+0x40d>
      break;
    1cb1:	90                   	nop
}
    1cb2:	90                   	nop
    1cb3:	c9                   	leaveq 
    1cb4:	c3                   	retq   

0000000000001cb5 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    1cb5:	f3 0f 1e fa          	endbr64 
    1cb9:	55                   	push   %rbp
    1cba:	48 89 e5             	mov    %rsp,%rbp
    1cbd:	48 83 ec 18          	sub    $0x18,%rsp
    1cc1:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  Header *bp, *p;

  bp = (Header*)ap - 1;
    1cc5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    1cc9:	48 83 e8 10          	sub    $0x10,%rax
    1ccd:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    1cd1:	48 b8 70 25 00 00 00 	movabs $0x2570,%rax
    1cd8:	00 00 00 
    1cdb:	48 8b 00             	mov    (%rax),%rax
    1cde:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
    1ce2:	eb 2f                	jmp    1d13 <free+0x5e>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    1ce4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1ce8:	48 8b 00             	mov    (%rax),%rax
    1ceb:	48 39 45 f8          	cmp    %rax,-0x8(%rbp)
    1cef:	72 17                	jb     1d08 <free+0x53>
    1cf1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1cf5:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
    1cf9:	77 2f                	ja     1d2a <free+0x75>
    1cfb:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1cff:	48 8b 00             	mov    (%rax),%rax
    1d02:	48 39 45 f0          	cmp    %rax,-0x10(%rbp)
    1d06:	72 22                	jb     1d2a <free+0x75>
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    1d08:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1d0c:	48 8b 00             	mov    (%rax),%rax
    1d0f:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
    1d13:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1d17:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
    1d1b:	76 c7                	jbe    1ce4 <free+0x2f>
    1d1d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1d21:	48 8b 00             	mov    (%rax),%rax
    1d24:	48 39 45 f0          	cmp    %rax,-0x10(%rbp)
    1d28:	73 ba                	jae    1ce4 <free+0x2f>
      break;
  if(bp + bp->s.size == p->s.ptr){
    1d2a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1d2e:	8b 40 08             	mov    0x8(%rax),%eax
    1d31:	89 c0                	mov    %eax,%eax
    1d33:	48 c1 e0 04          	shl    $0x4,%rax
    1d37:	48 89 c2             	mov    %rax,%rdx
    1d3a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1d3e:	48 01 c2             	add    %rax,%rdx
    1d41:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1d45:	48 8b 00             	mov    (%rax),%rax
    1d48:	48 39 c2             	cmp    %rax,%rdx
    1d4b:	75 2d                	jne    1d7a <free+0xc5>
    bp->s.size += p->s.ptr->s.size;
    1d4d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1d51:	8b 50 08             	mov    0x8(%rax),%edx
    1d54:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1d58:	48 8b 00             	mov    (%rax),%rax
    1d5b:	8b 40 08             	mov    0x8(%rax),%eax
    1d5e:	01 c2                	add    %eax,%edx
    1d60:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1d64:	89 50 08             	mov    %edx,0x8(%rax)
    bp->s.ptr = p->s.ptr->s.ptr;
    1d67:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1d6b:	48 8b 00             	mov    (%rax),%rax
    1d6e:	48 8b 10             	mov    (%rax),%rdx
    1d71:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1d75:	48 89 10             	mov    %rdx,(%rax)
    1d78:	eb 0e                	jmp    1d88 <free+0xd3>
  } else
    bp->s.ptr = p->s.ptr;
    1d7a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1d7e:	48 8b 10             	mov    (%rax),%rdx
    1d81:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1d85:	48 89 10             	mov    %rdx,(%rax)
  if(p + p->s.size == bp){
    1d88:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1d8c:	8b 40 08             	mov    0x8(%rax),%eax
    1d8f:	89 c0                	mov    %eax,%eax
    1d91:	48 c1 e0 04          	shl    $0x4,%rax
    1d95:	48 89 c2             	mov    %rax,%rdx
    1d98:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1d9c:	48 01 d0             	add    %rdx,%rax
    1d9f:	48 39 45 f0          	cmp    %rax,-0x10(%rbp)
    1da3:	75 27                	jne    1dcc <free+0x117>
    p->s.size += bp->s.size;
    1da5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1da9:	8b 50 08             	mov    0x8(%rax),%edx
    1dac:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1db0:	8b 40 08             	mov    0x8(%rax),%eax
    1db3:	01 c2                	add    %eax,%edx
    1db5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1db9:	89 50 08             	mov    %edx,0x8(%rax)
    p->s.ptr = bp->s.ptr;
    1dbc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1dc0:	48 8b 10             	mov    (%rax),%rdx
    1dc3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1dc7:	48 89 10             	mov    %rdx,(%rax)
    1dca:	eb 0b                	jmp    1dd7 <free+0x122>
  } else
    p->s.ptr = bp;
    1dcc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1dd0:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
    1dd4:	48 89 10             	mov    %rdx,(%rax)
  freep = p;
    1dd7:	48 ba 70 25 00 00 00 	movabs $0x2570,%rdx
    1dde:	00 00 00 
    1de1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1de5:	48 89 02             	mov    %rax,(%rdx)
}
    1de8:	90                   	nop
    1de9:	c9                   	leaveq 
    1dea:	c3                   	retq   

0000000000001deb <morecore>:

static Header*
morecore(uint nu)
{
    1deb:	f3 0f 1e fa          	endbr64 
    1def:	55                   	push   %rbp
    1df0:	48 89 e5             	mov    %rsp,%rbp
    1df3:	48 83 ec 20          	sub    $0x20,%rsp
    1df7:	89 7d ec             	mov    %edi,-0x14(%rbp)
  char *p;
  Header *hp;

  if(nu < 4096)
    1dfa:	81 7d ec ff 0f 00 00 	cmpl   $0xfff,-0x14(%rbp)
    1e01:	77 07                	ja     1e0a <morecore+0x1f>
    nu = 4096;
    1e03:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%rbp)
  p = sbrk(nu * sizeof(Header));
    1e0a:	8b 45 ec             	mov    -0x14(%rbp),%eax
    1e0d:	48 c1 e0 04          	shl    $0x4,%rax
    1e11:	48 89 c7             	mov    %rax,%rdi
    1e14:	48 b8 8b 16 00 00 00 	movabs $0x168b,%rax
    1e1b:	00 00 00 
    1e1e:	ff d0                	callq  *%rax
    1e20:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  if(p == (char*)-1)
    1e24:	48 83 7d f8 ff       	cmpq   $0xffffffffffffffff,-0x8(%rbp)
    1e29:	75 07                	jne    1e32 <morecore+0x47>
    return 0;
    1e2b:	b8 00 00 00 00       	mov    $0x0,%eax
    1e30:	eb 36                	jmp    1e68 <morecore+0x7d>
  hp = (Header*)p;
    1e32:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1e36:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
  hp->s.size = nu;
    1e3a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1e3e:	8b 55 ec             	mov    -0x14(%rbp),%edx
    1e41:	89 50 08             	mov    %edx,0x8(%rax)
  free((void*)(hp + 1));
    1e44:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1e48:	48 83 c0 10          	add    $0x10,%rax
    1e4c:	48 89 c7             	mov    %rax,%rdi
    1e4f:	48 b8 b5 1c 00 00 00 	movabs $0x1cb5,%rax
    1e56:	00 00 00 
    1e59:	ff d0                	callq  *%rax
  return freep;
    1e5b:	48 b8 70 25 00 00 00 	movabs $0x2570,%rax
    1e62:	00 00 00 
    1e65:	48 8b 00             	mov    (%rax),%rax
}
    1e68:	c9                   	leaveq 
    1e69:	c3                   	retq   

0000000000001e6a <malloc>:

void*
malloc(uint nbytes)
{
    1e6a:	f3 0f 1e fa          	endbr64 
    1e6e:	55                   	push   %rbp
    1e6f:	48 89 e5             	mov    %rsp,%rbp
    1e72:	48 83 ec 30          	sub    $0x30,%rsp
    1e76:	89 7d dc             	mov    %edi,-0x24(%rbp)
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    1e79:	8b 45 dc             	mov    -0x24(%rbp),%eax
    1e7c:	48 83 c0 0f          	add    $0xf,%rax
    1e80:	48 c1 e8 04          	shr    $0x4,%rax
    1e84:	83 c0 01             	add    $0x1,%eax
    1e87:	89 45 ec             	mov    %eax,-0x14(%rbp)
  if((prevp = freep) == 0){
    1e8a:	48 b8 70 25 00 00 00 	movabs $0x2570,%rax
    1e91:	00 00 00 
    1e94:	48 8b 00             	mov    (%rax),%rax
    1e97:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
    1e9b:	48 83 7d f0 00       	cmpq   $0x0,-0x10(%rbp)
    1ea0:	75 4a                	jne    1eec <malloc+0x82>
    base.s.ptr = freep = prevp = &base;
    1ea2:	48 b8 60 25 00 00 00 	movabs $0x2560,%rax
    1ea9:	00 00 00 
    1eac:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
    1eb0:	48 ba 70 25 00 00 00 	movabs $0x2570,%rdx
    1eb7:	00 00 00 
    1eba:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1ebe:	48 89 02             	mov    %rax,(%rdx)
    1ec1:	48 b8 70 25 00 00 00 	movabs $0x2570,%rax
    1ec8:	00 00 00 
    1ecb:	48 8b 00             	mov    (%rax),%rax
    1ece:	48 ba 60 25 00 00 00 	movabs $0x2560,%rdx
    1ed5:	00 00 00 
    1ed8:	48 89 02             	mov    %rax,(%rdx)
    base.s.size = 0;
    1edb:	48 b8 60 25 00 00 00 	movabs $0x2560,%rax
    1ee2:	00 00 00 
    1ee5:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%rax)
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    1eec:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1ef0:	48 8b 00             	mov    (%rax),%rax
    1ef3:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
    if(p->s.size >= nunits){
    1ef7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1efb:	8b 40 08             	mov    0x8(%rax),%eax
    1efe:	39 45 ec             	cmp    %eax,-0x14(%rbp)
    1f01:	77 65                	ja     1f68 <malloc+0xfe>
      if(p->s.size == nunits)
    1f03:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1f07:	8b 40 08             	mov    0x8(%rax),%eax
    1f0a:	39 45 ec             	cmp    %eax,-0x14(%rbp)
    1f0d:	75 10                	jne    1f1f <malloc+0xb5>
        prevp->s.ptr = p->s.ptr;
    1f0f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1f13:	48 8b 10             	mov    (%rax),%rdx
    1f16:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1f1a:	48 89 10             	mov    %rdx,(%rax)
    1f1d:	eb 2e                	jmp    1f4d <malloc+0xe3>
      else {
        p->s.size -= nunits;
    1f1f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1f23:	8b 40 08             	mov    0x8(%rax),%eax
    1f26:	2b 45 ec             	sub    -0x14(%rbp),%eax
    1f29:	89 c2                	mov    %eax,%edx
    1f2b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1f2f:	89 50 08             	mov    %edx,0x8(%rax)
        p += p->s.size;
    1f32:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1f36:	8b 40 08             	mov    0x8(%rax),%eax
    1f39:	89 c0                	mov    %eax,%eax
    1f3b:	48 c1 e0 04          	shl    $0x4,%rax
    1f3f:	48 01 45 f8          	add    %rax,-0x8(%rbp)
        p->s.size = nunits;
    1f43:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1f47:	8b 55 ec             	mov    -0x14(%rbp),%edx
    1f4a:	89 50 08             	mov    %edx,0x8(%rax)
      }
      freep = prevp;
    1f4d:	48 ba 70 25 00 00 00 	movabs $0x2570,%rdx
    1f54:	00 00 00 
    1f57:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1f5b:	48 89 02             	mov    %rax,(%rdx)
      return (void*)(p + 1);
    1f5e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1f62:	48 83 c0 10          	add    $0x10,%rax
    1f66:	eb 4e                	jmp    1fb6 <malloc+0x14c>
    }
    if(p == freep)
    1f68:	48 b8 70 25 00 00 00 	movabs $0x2570,%rax
    1f6f:	00 00 00 
    1f72:	48 8b 00             	mov    (%rax),%rax
    1f75:	48 39 45 f8          	cmp    %rax,-0x8(%rbp)
    1f79:	75 23                	jne    1f9e <malloc+0x134>
      if((p = morecore(nunits)) == 0)
    1f7b:	8b 45 ec             	mov    -0x14(%rbp),%eax
    1f7e:	89 c7                	mov    %eax,%edi
    1f80:	48 b8 eb 1d 00 00 00 	movabs $0x1deb,%rax
    1f87:	00 00 00 
    1f8a:	ff d0                	callq  *%rax
    1f8c:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
    1f90:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
    1f95:	75 07                	jne    1f9e <malloc+0x134>
        return 0;
    1f97:	b8 00 00 00 00       	mov    $0x0,%eax
    1f9c:	eb 18                	jmp    1fb6 <malloc+0x14c>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    1f9e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1fa2:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
    1fa6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1faa:	48 8b 00             	mov    (%rax),%rax
    1fad:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
    if(p->s.size >= nunits){
    1fb1:	e9 41 ff ff ff       	jmpq   1ef7 <malloc+0x8d>
  }
}
    1fb6:	c9                   	leaveq 
    1fb7:	c3                   	retq   
