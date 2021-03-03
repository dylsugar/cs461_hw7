
_grep:     file format elf64-x86-64


Disassembly of section .text:

0000000000001000 <grep>:
char buf[1024];
int match(char*, char*);

void
grep(char *pattern, int fd)
{
    1000:	f3 0f 1e fa          	endbr64 
    1004:	55                   	push   %rbp
    1005:	48 89 e5             	mov    %rsp,%rbp
    1008:	48 83 ec 30          	sub    $0x30,%rsp
    100c:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
    1010:	89 75 d4             	mov    %esi,-0x2c(%rbp)
  int n, m;
  char *p, *q;

  m = 0;
    1013:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  while((n = read(fd, buf+m, sizeof(buf)-m-1)) > 0){
    101a:	e9 04 01 00 00       	jmpq   1123 <grep+0x123>
    m += n;
    101f:	8b 45 ec             	mov    -0x14(%rbp),%eax
    1022:	01 45 fc             	add    %eax,-0x4(%rbp)
    buf[m] = '\0';
    1025:	48 ba e0 25 00 00 00 	movabs $0x25e0,%rdx
    102c:	00 00 00 
    102f:	8b 45 fc             	mov    -0x4(%rbp),%eax
    1032:	48 98                	cltq   
    1034:	c6 04 02 00          	movb   $0x0,(%rdx,%rax,1)
    p = buf;
    1038:	48 b8 e0 25 00 00 00 	movabs $0x25e0,%rax
    103f:	00 00 00 
    1042:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
    while((q = strchr(p, '\n')) != 0){
    1046:	eb 5e                	jmp    10a6 <grep+0xa6>
      *q = 0;
    1048:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
    104c:	c6 00 00             	movb   $0x0,(%rax)
      if(match(pattern, p)){
    104f:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
    1053:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
    1057:	48 89 d6             	mov    %rdx,%rsi
    105a:	48 89 c7             	mov    %rax,%rdi
    105d:	48 b8 b1 12 00 00 00 	movabs $0x12b1,%rax
    1064:	00 00 00 
    1067:	ff d0                	callq  *%rax
    1069:	85 c0                	test   %eax,%eax
    106b:	74 2d                	je     109a <grep+0x9a>
        *q = '\n';
    106d:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
    1071:	c6 00 0a             	movb   $0xa,(%rax)
        write(1, p, q+1 - p);
    1074:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
    1078:	48 83 c0 01          	add    $0x1,%rax
    107c:	48 2b 45 f0          	sub    -0x10(%rbp),%rax
    1080:	89 c2                	mov    %eax,%edx
    1082:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1086:	48 89 c6             	mov    %rax,%rsi
    1089:	bf 01 00 00 00       	mov    $0x1,%edi
    108e:	48 b8 f0 17 00 00 00 	movabs $0x17f0,%rax
    1095:	00 00 00 
    1098:	ff d0                	callq  *%rax
      }
      p = q+1;
    109a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
    109e:	48 83 c0 01          	add    $0x1,%rax
    10a2:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
    while((q = strchr(p, '\n')) != 0){
    10a6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    10aa:	be 0a 00 00 00       	mov    $0xa,%esi
    10af:	48 89 c7             	mov    %rax,%rdi
    10b2:	48 b8 be 15 00 00 00 	movabs $0x15be,%rax
    10b9:	00 00 00 
    10bc:	ff d0                	callq  *%rax
    10be:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
    10c2:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
    10c7:	0f 85 7b ff ff ff    	jne    1048 <grep+0x48>
    }
    if(p == buf)
    10cd:	48 b8 e0 25 00 00 00 	movabs $0x25e0,%rax
    10d4:	00 00 00 
    10d7:	48 39 45 f0          	cmp    %rax,-0x10(%rbp)
    10db:	75 07                	jne    10e4 <grep+0xe4>
      m = 0;
    10dd:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
    if(m > 0){
    10e4:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
    10e8:	7e 39                	jle    1123 <grep+0x123>
      m -= p - buf;
    10ea:	8b 45 fc             	mov    -0x4(%rbp),%eax
    10ed:	48 b9 e0 25 00 00 00 	movabs $0x25e0,%rcx
    10f4:	00 00 00 
    10f7:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
    10fb:	48 29 ca             	sub    %rcx,%rdx
    10fe:	29 d0                	sub    %edx,%eax
    1100:	89 45 fc             	mov    %eax,-0x4(%rbp)
      memmove(buf, p, m);
    1103:	8b 55 fc             	mov    -0x4(%rbp),%edx
    1106:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    110a:	48 89 c6             	mov    %rax,%rsi
    110d:	48 bf e0 25 00 00 00 	movabs $0x25e0,%rdi
    1114:	00 00 00 
    1117:	48 b8 56 17 00 00 00 	movabs $0x1756,%rax
    111e:	00 00 00 
    1121:	ff d0                	callq  *%rax
  while((n = read(fd, buf+m, sizeof(buf)-m-1)) > 0){
    1123:	8b 45 fc             	mov    -0x4(%rbp),%eax
    1126:	ba ff 03 00 00       	mov    $0x3ff,%edx
    112b:	29 c2                	sub    %eax,%edx
    112d:	89 d0                	mov    %edx,%eax
    112f:	89 c6                	mov    %eax,%esi
    1131:	8b 45 fc             	mov    -0x4(%rbp),%eax
    1134:	48 98                	cltq   
    1136:	48 ba e0 25 00 00 00 	movabs $0x25e0,%rdx
    113d:	00 00 00 
    1140:	48 8d 0c 10          	lea    (%rax,%rdx,1),%rcx
    1144:	8b 45 d4             	mov    -0x2c(%rbp),%eax
    1147:	89 f2                	mov    %esi,%edx
    1149:	48 89 ce             	mov    %rcx,%rsi
    114c:	89 c7                	mov    %eax,%edi
    114e:	48 b8 e3 17 00 00 00 	movabs $0x17e3,%rax
    1155:	00 00 00 
    1158:	ff d0                	callq  *%rax
    115a:	89 45 ec             	mov    %eax,-0x14(%rbp)
    115d:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
    1161:	0f 8f b8 fe ff ff    	jg     101f <grep+0x1f>
    }
  }
}
    1167:	90                   	nop
    1168:	90                   	nop
    1169:	c9                   	leaveq 
    116a:	c3                   	retq   

000000000000116b <main>:

int
main(int argc, char *argv[])
{
    116b:	f3 0f 1e fa          	endbr64 
    116f:	55                   	push   %rbp
    1170:	48 89 e5             	mov    %rsp,%rbp
    1173:	48 83 ec 30          	sub    $0x30,%rsp
    1177:	89 7d dc             	mov    %edi,-0x24(%rbp)
    117a:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  int fd, i;
  char *pattern;

  if(argc <= 1){
    117e:	83 7d dc 01          	cmpl   $0x1,-0x24(%rbp)
    1182:	7f 2c                	jg     11b0 <main+0x45>
    printf(2, "usage: grep pattern [file ...]\n");
    1184:	48 be c8 21 00 00 00 	movabs $0x21c8,%rsi
    118b:	00 00 00 
    118e:	bf 02 00 00 00       	mov    $0x2,%edi
    1193:	b8 00 00 00 00       	mov    $0x0,%eax
    1198:	48 ba b3 1a 00 00 00 	movabs $0x1ab3,%rdx
    119f:	00 00 00 
    11a2:	ff d2                	callq  *%rdx
    exit();
    11a4:	48 b8 bc 17 00 00 00 	movabs $0x17bc,%rax
    11ab:	00 00 00 
    11ae:	ff d0                	callq  *%rax
  }
  pattern = argv[1];
    11b0:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
    11b4:	48 8b 40 08          	mov    0x8(%rax),%rax
    11b8:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

  if(argc <= 2){
    11bc:	83 7d dc 02          	cmpl   $0x2,-0x24(%rbp)
    11c0:	7f 24                	jg     11e6 <main+0x7b>
    grep(pattern, 0);
    11c2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    11c6:	be 00 00 00 00       	mov    $0x0,%esi
    11cb:	48 89 c7             	mov    %rax,%rdi
    11ce:	48 b8 00 10 00 00 00 	movabs $0x1000,%rax
    11d5:	00 00 00 
    11d8:	ff d0                	callq  *%rax
    exit();
    11da:	48 b8 bc 17 00 00 00 	movabs $0x17bc,%rax
    11e1:	00 00 00 
    11e4:	ff d0                	callq  *%rax
  }

  for(i = 2; i < argc; i++){
    11e6:	c7 45 fc 02 00 00 00 	movl   $0x2,-0x4(%rbp)
    11ed:	e9 a7 00 00 00       	jmpq   1299 <main+0x12e>
    if((fd = open(argv[i], 0)) < 0){
    11f2:	8b 45 fc             	mov    -0x4(%rbp),%eax
    11f5:	48 98                	cltq   
    11f7:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
    11fe:	00 
    11ff:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
    1203:	48 01 d0             	add    %rdx,%rax
    1206:	48 8b 00             	mov    (%rax),%rax
    1209:	be 00 00 00 00       	mov    $0x0,%esi
    120e:	48 89 c7             	mov    %rax,%rdi
    1211:	48 b8 24 18 00 00 00 	movabs $0x1824,%rax
    1218:	00 00 00 
    121b:	ff d0                	callq  *%rax
    121d:	89 45 ec             	mov    %eax,-0x14(%rbp)
    1220:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
    1224:	79 46                	jns    126c <main+0x101>
      printf(1, "grep: cannot open %s\n", argv[i]);
    1226:	8b 45 fc             	mov    -0x4(%rbp),%eax
    1229:	48 98                	cltq   
    122b:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
    1232:	00 
    1233:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
    1237:	48 01 d0             	add    %rdx,%rax
    123a:	48 8b 00             	mov    (%rax),%rax
    123d:	48 89 c2             	mov    %rax,%rdx
    1240:	48 be e8 21 00 00 00 	movabs $0x21e8,%rsi
    1247:	00 00 00 
    124a:	bf 01 00 00 00       	mov    $0x1,%edi
    124f:	b8 00 00 00 00       	mov    $0x0,%eax
    1254:	48 b9 b3 1a 00 00 00 	movabs $0x1ab3,%rcx
    125b:	00 00 00 
    125e:	ff d1                	callq  *%rcx
      exit();
    1260:	48 b8 bc 17 00 00 00 	movabs $0x17bc,%rax
    1267:	00 00 00 
    126a:	ff d0                	callq  *%rax
    }
    grep(pattern, fd);
    126c:	8b 55 ec             	mov    -0x14(%rbp),%edx
    126f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1273:	89 d6                	mov    %edx,%esi
    1275:	48 89 c7             	mov    %rax,%rdi
    1278:	48 b8 00 10 00 00 00 	movabs $0x1000,%rax
    127f:	00 00 00 
    1282:	ff d0                	callq  *%rax
    close(fd);
    1284:	8b 45 ec             	mov    -0x14(%rbp),%eax
    1287:	89 c7                	mov    %eax,%edi
    1289:	48 b8 fd 17 00 00 00 	movabs $0x17fd,%rax
    1290:	00 00 00 
    1293:	ff d0                	callq  *%rax
  for(i = 2; i < argc; i++){
    1295:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
    1299:	8b 45 fc             	mov    -0x4(%rbp),%eax
    129c:	3b 45 dc             	cmp    -0x24(%rbp),%eax
    129f:	0f 8c 4d ff ff ff    	jl     11f2 <main+0x87>
  }
  exit();
    12a5:	48 b8 bc 17 00 00 00 	movabs $0x17bc,%rax
    12ac:	00 00 00 
    12af:	ff d0                	callq  *%rax

00000000000012b1 <match>:
int matchhere(char*, char*);
int matchstar(int, char*, char*);

int
match(char *re, char *text)
{
    12b1:	f3 0f 1e fa          	endbr64 
    12b5:	55                   	push   %rbp
    12b6:	48 89 e5             	mov    %rsp,%rbp
    12b9:	48 83 ec 10          	sub    $0x10,%rsp
    12bd:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
    12c1:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  if(re[0] == '^')
    12c5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    12c9:	0f b6 00             	movzbl (%rax),%eax
    12cc:	3c 5e                	cmp    $0x5e,%al
    12ce:	75 20                	jne    12f0 <match+0x3f>
    return matchhere(re+1, text);
    12d0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    12d4:	48 8d 50 01          	lea    0x1(%rax),%rdx
    12d8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    12dc:	48 89 c6             	mov    %rax,%rsi
    12df:	48 89 d7             	mov    %rdx,%rdi
    12e2:	48 b8 2f 13 00 00 00 	movabs $0x132f,%rax
    12e9:	00 00 00 
    12ec:	ff d0                	callq  *%rax
    12ee:	eb 3d                	jmp    132d <match+0x7c>
  do{  // must look at empty string
    if(matchhere(re, text))
    12f0:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
    12f4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    12f8:	48 89 d6             	mov    %rdx,%rsi
    12fb:	48 89 c7             	mov    %rax,%rdi
    12fe:	48 b8 2f 13 00 00 00 	movabs $0x132f,%rax
    1305:	00 00 00 
    1308:	ff d0                	callq  *%rax
    130a:	85 c0                	test   %eax,%eax
    130c:	74 07                	je     1315 <match+0x64>
      return 1;
    130e:	b8 01 00 00 00       	mov    $0x1,%eax
    1313:	eb 18                	jmp    132d <match+0x7c>
  }while(*text++ != '\0');
    1315:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1319:	48 8d 50 01          	lea    0x1(%rax),%rdx
    131d:	48 89 55 f0          	mov    %rdx,-0x10(%rbp)
    1321:	0f b6 00             	movzbl (%rax),%eax
    1324:	84 c0                	test   %al,%al
    1326:	75 c8                	jne    12f0 <match+0x3f>
  return 0;
    1328:	b8 00 00 00 00       	mov    $0x0,%eax
}
    132d:	c9                   	leaveq 
    132e:	c3                   	retq   

000000000000132f <matchhere>:

// matchhere: search for re at beginning of text
int matchhere(char *re, char *text)
{
    132f:	f3 0f 1e fa          	endbr64 
    1333:	55                   	push   %rbp
    1334:	48 89 e5             	mov    %rsp,%rbp
    1337:	48 83 ec 10          	sub    $0x10,%rsp
    133b:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
    133f:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  if(re[0] == '\0')
    1343:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1347:	0f b6 00             	movzbl (%rax),%eax
    134a:	84 c0                	test   %al,%al
    134c:	75 0a                	jne    1358 <matchhere+0x29>
    return 1;
    134e:	b8 01 00 00 00       	mov    $0x1,%eax
    1353:	e9 b4 00 00 00       	jmpq   140c <matchhere+0xdd>
  if(re[1] == '*')
    1358:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    135c:	48 83 c0 01          	add    $0x1,%rax
    1360:	0f b6 00             	movzbl (%rax),%eax
    1363:	3c 2a                	cmp    $0x2a,%al
    1365:	75 29                	jne    1390 <matchhere+0x61>
    return matchstar(re[0], re+2, text);
    1367:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    136b:	48 8d 48 02          	lea    0x2(%rax),%rcx
    136f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1373:	0f b6 00             	movzbl (%rax),%eax
    1376:	0f be c0             	movsbl %al,%eax
    1379:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
    137d:	48 89 ce             	mov    %rcx,%rsi
    1380:	89 c7                	mov    %eax,%edi
    1382:	48 b8 0e 14 00 00 00 	movabs $0x140e,%rax
    1389:	00 00 00 
    138c:	ff d0                	callq  *%rax
    138e:	eb 7c                	jmp    140c <matchhere+0xdd>
  if(re[0] == '$' && re[1] == '\0')
    1390:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1394:	0f b6 00             	movzbl (%rax),%eax
    1397:	3c 24                	cmp    $0x24,%al
    1399:	75 20                	jne    13bb <matchhere+0x8c>
    139b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    139f:	48 83 c0 01          	add    $0x1,%rax
    13a3:	0f b6 00             	movzbl (%rax),%eax
    13a6:	84 c0                	test   %al,%al
    13a8:	75 11                	jne    13bb <matchhere+0x8c>
    return *text == '\0';
    13aa:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    13ae:	0f b6 00             	movzbl (%rax),%eax
    13b1:	84 c0                	test   %al,%al
    13b3:	0f 94 c0             	sete   %al
    13b6:	0f b6 c0             	movzbl %al,%eax
    13b9:	eb 51                	jmp    140c <matchhere+0xdd>
  if(*text!='\0' && (re[0]=='.' || re[0]==*text))
    13bb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    13bf:	0f b6 00             	movzbl (%rax),%eax
    13c2:	84 c0                	test   %al,%al
    13c4:	74 41                	je     1407 <matchhere+0xd8>
    13c6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    13ca:	0f b6 00             	movzbl (%rax),%eax
    13cd:	3c 2e                	cmp    $0x2e,%al
    13cf:	74 12                	je     13e3 <matchhere+0xb4>
    13d1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    13d5:	0f b6 10             	movzbl (%rax),%edx
    13d8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    13dc:	0f b6 00             	movzbl (%rax),%eax
    13df:	38 c2                	cmp    %al,%dl
    13e1:	75 24                	jne    1407 <matchhere+0xd8>
    return matchhere(re+1, text+1);
    13e3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    13e7:	48 8d 50 01          	lea    0x1(%rax),%rdx
    13eb:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    13ef:	48 83 c0 01          	add    $0x1,%rax
    13f3:	48 89 d6             	mov    %rdx,%rsi
    13f6:	48 89 c7             	mov    %rax,%rdi
    13f9:	48 b8 2f 13 00 00 00 	movabs $0x132f,%rax
    1400:	00 00 00 
    1403:	ff d0                	callq  *%rax
    1405:	eb 05                	jmp    140c <matchhere+0xdd>
  return 0;
    1407:	b8 00 00 00 00       	mov    $0x0,%eax
}
    140c:	c9                   	leaveq 
    140d:	c3                   	retq   

000000000000140e <matchstar>:

// matchstar: search for c*re at beginning of text
int matchstar(int c, char *re, char *text)
{
    140e:	f3 0f 1e fa          	endbr64 
    1412:	55                   	push   %rbp
    1413:	48 89 e5             	mov    %rsp,%rbp
    1416:	48 83 ec 20          	sub    $0x20,%rsp
    141a:	89 7d fc             	mov    %edi,-0x4(%rbp)
    141d:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
    1421:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  do{  // a * matches zero or more instances
    if(matchhere(re, text))
    1425:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
    1429:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    142d:	48 89 d6             	mov    %rdx,%rsi
    1430:	48 89 c7             	mov    %rax,%rdi
    1433:	48 b8 2f 13 00 00 00 	movabs $0x132f,%rax
    143a:	00 00 00 
    143d:	ff d0                	callq  *%rax
    143f:	85 c0                	test   %eax,%eax
    1441:	74 07                	je     144a <matchstar+0x3c>
      return 1;
    1443:	b8 01 00 00 00       	mov    $0x1,%eax
    1448:	eb 2d                	jmp    1477 <matchstar+0x69>
  }while(*text!='\0' && (*text++==c || c=='.'));
    144a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    144e:	0f b6 00             	movzbl (%rax),%eax
    1451:	84 c0                	test   %al,%al
    1453:	74 1d                	je     1472 <matchstar+0x64>
    1455:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    1459:	48 8d 50 01          	lea    0x1(%rax),%rdx
    145d:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
    1461:	0f b6 00             	movzbl (%rax),%eax
    1464:	0f be c0             	movsbl %al,%eax
    1467:	39 45 fc             	cmp    %eax,-0x4(%rbp)
    146a:	74 b9                	je     1425 <matchstar+0x17>
    146c:	83 7d fc 2e          	cmpl   $0x2e,-0x4(%rbp)
    1470:	74 b3                	je     1425 <matchstar+0x17>
  return 0;
    1472:	b8 00 00 00 00       	mov    $0x0,%eax
}
    1477:	c9                   	leaveq 
    1478:	c3                   	retq   

0000000000001479 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
    1479:	f3 0f 1e fa          	endbr64 
    147d:	55                   	push   %rbp
    147e:	48 89 e5             	mov    %rsp,%rbp
    1481:	48 83 ec 10          	sub    $0x10,%rsp
    1485:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
    1489:	89 75 f4             	mov    %esi,-0xc(%rbp)
    148c:	89 55 f0             	mov    %edx,-0x10(%rbp)
  asm volatile("cld; rep stosb" :
    148f:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
    1493:	8b 55 f0             	mov    -0x10(%rbp),%edx
    1496:	8b 45 f4             	mov    -0xc(%rbp),%eax
    1499:	48 89 ce             	mov    %rcx,%rsi
    149c:	48 89 f7             	mov    %rsi,%rdi
    149f:	89 d1                	mov    %edx,%ecx
    14a1:	fc                   	cld    
    14a2:	f3 aa                	rep stos %al,%es:(%rdi)
    14a4:	89 ca                	mov    %ecx,%edx
    14a6:	48 89 fe             	mov    %rdi,%rsi
    14a9:	48 89 75 f8          	mov    %rsi,-0x8(%rbp)
    14ad:	89 55 f0             	mov    %edx,-0x10(%rbp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
    14b0:	90                   	nop
    14b1:	c9                   	leaveq 
    14b2:	c3                   	retq   

00000000000014b3 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
    14b3:	f3 0f 1e fa          	endbr64 
    14b7:	55                   	push   %rbp
    14b8:	48 89 e5             	mov    %rsp,%rbp
    14bb:	48 83 ec 20          	sub    $0x20,%rsp
    14bf:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
    14c3:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  char *os;

  os = s;
    14c7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    14cb:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  while((*s++ = *t++) != 0)
    14cf:	90                   	nop
    14d0:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
    14d4:	48 8d 42 01          	lea    0x1(%rdx),%rax
    14d8:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
    14dc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    14e0:	48 8d 48 01          	lea    0x1(%rax),%rcx
    14e4:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
    14e8:	0f b6 12             	movzbl (%rdx),%edx
    14eb:	88 10                	mov    %dl,(%rax)
    14ed:	0f b6 00             	movzbl (%rax),%eax
    14f0:	84 c0                	test   %al,%al
    14f2:	75 dc                	jne    14d0 <strcpy+0x1d>
    ;
  return os;
    14f4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
    14f8:	c9                   	leaveq 
    14f9:	c3                   	retq   

00000000000014fa <strcmp>:

int
strcmp(const char *p, const char *q)
{
    14fa:	f3 0f 1e fa          	endbr64 
    14fe:	55                   	push   %rbp
    14ff:	48 89 e5             	mov    %rsp,%rbp
    1502:	48 83 ec 10          	sub    $0x10,%rsp
    1506:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
    150a:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  while(*p && *p == *q)
    150e:	eb 0a                	jmp    151a <strcmp+0x20>
    p++, q++;
    1510:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
    1515:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
  while(*p && *p == *q)
    151a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    151e:	0f b6 00             	movzbl (%rax),%eax
    1521:	84 c0                	test   %al,%al
    1523:	74 12                	je     1537 <strcmp+0x3d>
    1525:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1529:	0f b6 10             	movzbl (%rax),%edx
    152c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1530:	0f b6 00             	movzbl (%rax),%eax
    1533:	38 c2                	cmp    %al,%dl
    1535:	74 d9                	je     1510 <strcmp+0x16>
  return (uchar)*p - (uchar)*q;
    1537:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    153b:	0f b6 00             	movzbl (%rax),%eax
    153e:	0f b6 d0             	movzbl %al,%edx
    1541:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1545:	0f b6 00             	movzbl (%rax),%eax
    1548:	0f b6 c0             	movzbl %al,%eax
    154b:	29 c2                	sub    %eax,%edx
    154d:	89 d0                	mov    %edx,%eax
}
    154f:	c9                   	leaveq 
    1550:	c3                   	retq   

0000000000001551 <strlen>:

uint
strlen(char *s)
{
    1551:	f3 0f 1e fa          	endbr64 
    1555:	55                   	push   %rbp
    1556:	48 89 e5             	mov    %rsp,%rbp
    1559:	48 83 ec 18          	sub    $0x18,%rsp
    155d:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  int n;

  for(n = 0; s[n]; n++)
    1561:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
    1568:	eb 04                	jmp    156e <strlen+0x1d>
    156a:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
    156e:	8b 45 fc             	mov    -0x4(%rbp),%eax
    1571:	48 63 d0             	movslq %eax,%rdx
    1574:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    1578:	48 01 d0             	add    %rdx,%rax
    157b:	0f b6 00             	movzbl (%rax),%eax
    157e:	84 c0                	test   %al,%al
    1580:	75 e8                	jne    156a <strlen+0x19>
    ;
  return n;
    1582:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
    1585:	c9                   	leaveq 
    1586:	c3                   	retq   

0000000000001587 <memset>:

void*
memset(void *dst, int c, uint n)
{
    1587:	f3 0f 1e fa          	endbr64 
    158b:	55                   	push   %rbp
    158c:	48 89 e5             	mov    %rsp,%rbp
    158f:	48 83 ec 10          	sub    $0x10,%rsp
    1593:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
    1597:	89 75 f4             	mov    %esi,-0xc(%rbp)
    159a:	89 55 f0             	mov    %edx,-0x10(%rbp)
  stosb(dst, c, n);
    159d:	8b 55 f0             	mov    -0x10(%rbp),%edx
    15a0:	8b 4d f4             	mov    -0xc(%rbp),%ecx
    15a3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    15a7:	89 ce                	mov    %ecx,%esi
    15a9:	48 89 c7             	mov    %rax,%rdi
    15ac:	48 b8 79 14 00 00 00 	movabs $0x1479,%rax
    15b3:	00 00 00 
    15b6:	ff d0                	callq  *%rax
  return dst;
    15b8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
    15bc:	c9                   	leaveq 
    15bd:	c3                   	retq   

00000000000015be <strchr>:

char*
strchr(const char *s, char c)
{
    15be:	f3 0f 1e fa          	endbr64 
    15c2:	55                   	push   %rbp
    15c3:	48 89 e5             	mov    %rsp,%rbp
    15c6:	48 83 ec 10          	sub    $0x10,%rsp
    15ca:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
    15ce:	89 f0                	mov    %esi,%eax
    15d0:	88 45 f4             	mov    %al,-0xc(%rbp)
  for(; *s; s++)
    15d3:	eb 17                	jmp    15ec <strchr+0x2e>
    if(*s == c)
    15d5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    15d9:	0f b6 00             	movzbl (%rax),%eax
    15dc:	38 45 f4             	cmp    %al,-0xc(%rbp)
    15df:	75 06                	jne    15e7 <strchr+0x29>
      return (char*)s;
    15e1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    15e5:	eb 15                	jmp    15fc <strchr+0x3e>
  for(; *s; s++)
    15e7:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
    15ec:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    15f0:	0f b6 00             	movzbl (%rax),%eax
    15f3:	84 c0                	test   %al,%al
    15f5:	75 de                	jne    15d5 <strchr+0x17>
  return 0;
    15f7:	b8 00 00 00 00       	mov    $0x0,%eax
}
    15fc:	c9                   	leaveq 
    15fd:	c3                   	retq   

00000000000015fe <gets>:

char*
gets(char *buf, int max)
{
    15fe:	f3 0f 1e fa          	endbr64 
    1602:	55                   	push   %rbp
    1603:	48 89 e5             	mov    %rsp,%rbp
    1606:	48 83 ec 20          	sub    $0x20,%rsp
    160a:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
    160e:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    1611:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
    1618:	eb 4f                	jmp    1669 <gets+0x6b>
    cc = read(0, &c, 1);
    161a:	48 8d 45 f7          	lea    -0x9(%rbp),%rax
    161e:	ba 01 00 00 00       	mov    $0x1,%edx
    1623:	48 89 c6             	mov    %rax,%rsi
    1626:	bf 00 00 00 00       	mov    $0x0,%edi
    162b:	48 b8 e3 17 00 00 00 	movabs $0x17e3,%rax
    1632:	00 00 00 
    1635:	ff d0                	callq  *%rax
    1637:	89 45 f8             	mov    %eax,-0x8(%rbp)
    if(cc < 1)
    163a:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
    163e:	7e 36                	jle    1676 <gets+0x78>
      break;
    buf[i++] = c;
    1640:	8b 45 fc             	mov    -0x4(%rbp),%eax
    1643:	8d 50 01             	lea    0x1(%rax),%edx
    1646:	89 55 fc             	mov    %edx,-0x4(%rbp)
    1649:	48 63 d0             	movslq %eax,%rdx
    164c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    1650:	48 01 c2             	add    %rax,%rdx
    1653:	0f b6 45 f7          	movzbl -0x9(%rbp),%eax
    1657:	88 02                	mov    %al,(%rdx)
    if(c == '\n' || c == '\r')
    1659:	0f b6 45 f7          	movzbl -0x9(%rbp),%eax
    165d:	3c 0a                	cmp    $0xa,%al
    165f:	74 16                	je     1677 <gets+0x79>
    1661:	0f b6 45 f7          	movzbl -0x9(%rbp),%eax
    1665:	3c 0d                	cmp    $0xd,%al
    1667:	74 0e                	je     1677 <gets+0x79>
  for(i=0; i+1 < max; ){
    1669:	8b 45 fc             	mov    -0x4(%rbp),%eax
    166c:	83 c0 01             	add    $0x1,%eax
    166f:	39 45 e4             	cmp    %eax,-0x1c(%rbp)
    1672:	7f a6                	jg     161a <gets+0x1c>
    1674:	eb 01                	jmp    1677 <gets+0x79>
      break;
    1676:	90                   	nop
      break;
  }
  buf[i] = '\0';
    1677:	8b 45 fc             	mov    -0x4(%rbp),%eax
    167a:	48 63 d0             	movslq %eax,%rdx
    167d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    1681:	48 01 d0             	add    %rdx,%rax
    1684:	c6 00 00             	movb   $0x0,(%rax)
  return buf;
    1687:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
    168b:	c9                   	leaveq 
    168c:	c3                   	retq   

000000000000168d <stat>:

int
stat(char *n, struct stat *st)
{
    168d:	f3 0f 1e fa          	endbr64 
    1691:	55                   	push   %rbp
    1692:	48 89 e5             	mov    %rsp,%rbp
    1695:	48 83 ec 20          	sub    $0x20,%rsp
    1699:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
    169d:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  int fd;
  int r;

  fd = open(n, O_RDONLY);
    16a1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    16a5:	be 00 00 00 00       	mov    $0x0,%esi
    16aa:	48 89 c7             	mov    %rax,%rdi
    16ad:	48 b8 24 18 00 00 00 	movabs $0x1824,%rax
    16b4:	00 00 00 
    16b7:	ff d0                	callq  *%rax
    16b9:	89 45 fc             	mov    %eax,-0x4(%rbp)
  if(fd < 0)
    16bc:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
    16c0:	79 07                	jns    16c9 <stat+0x3c>
    return -1;
    16c2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    16c7:	eb 2f                	jmp    16f8 <stat+0x6b>
  r = fstat(fd, st);
    16c9:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
    16cd:	8b 45 fc             	mov    -0x4(%rbp),%eax
    16d0:	48 89 d6             	mov    %rdx,%rsi
    16d3:	89 c7                	mov    %eax,%edi
    16d5:	48 b8 4b 18 00 00 00 	movabs $0x184b,%rax
    16dc:	00 00 00 
    16df:	ff d0                	callq  *%rax
    16e1:	89 45 f8             	mov    %eax,-0x8(%rbp)
  close(fd);
    16e4:	8b 45 fc             	mov    -0x4(%rbp),%eax
    16e7:	89 c7                	mov    %eax,%edi
    16e9:	48 b8 fd 17 00 00 00 	movabs $0x17fd,%rax
    16f0:	00 00 00 
    16f3:	ff d0                	callq  *%rax
  return r;
    16f5:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
    16f8:	c9                   	leaveq 
    16f9:	c3                   	retq   

00000000000016fa <atoi>:

int
atoi(const char *s)
{
    16fa:	f3 0f 1e fa          	endbr64 
    16fe:	55                   	push   %rbp
    16ff:	48 89 e5             	mov    %rsp,%rbp
    1702:	48 83 ec 18          	sub    $0x18,%rsp
    1706:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  int n;

  n = 0;
    170a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  while('0' <= *s && *s <= '9')
    1711:	eb 28                	jmp    173b <atoi+0x41>
    n = n*10 + *s++ - '0';
    1713:	8b 55 fc             	mov    -0x4(%rbp),%edx
    1716:	89 d0                	mov    %edx,%eax
    1718:	c1 e0 02             	shl    $0x2,%eax
    171b:	01 d0                	add    %edx,%eax
    171d:	01 c0                	add    %eax,%eax
    171f:	89 c1                	mov    %eax,%ecx
    1721:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    1725:	48 8d 50 01          	lea    0x1(%rax),%rdx
    1729:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
    172d:	0f b6 00             	movzbl (%rax),%eax
    1730:	0f be c0             	movsbl %al,%eax
    1733:	01 c8                	add    %ecx,%eax
    1735:	83 e8 30             	sub    $0x30,%eax
    1738:	89 45 fc             	mov    %eax,-0x4(%rbp)
  while('0' <= *s && *s <= '9')
    173b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    173f:	0f b6 00             	movzbl (%rax),%eax
    1742:	3c 2f                	cmp    $0x2f,%al
    1744:	7e 0b                	jle    1751 <atoi+0x57>
    1746:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    174a:	0f b6 00             	movzbl (%rax),%eax
    174d:	3c 39                	cmp    $0x39,%al
    174f:	7e c2                	jle    1713 <atoi+0x19>
  return n;
    1751:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
    1754:	c9                   	leaveq 
    1755:	c3                   	retq   

0000000000001756 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
    1756:	f3 0f 1e fa          	endbr64 
    175a:	55                   	push   %rbp
    175b:	48 89 e5             	mov    %rsp,%rbp
    175e:	48 83 ec 28          	sub    $0x28,%rsp
    1762:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
    1766:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
    176a:	89 55 dc             	mov    %edx,-0x24(%rbp)
  char *dst, *src;

  dst = vdst;
    176d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    1771:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  src = vsrc;
    1775:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
    1779:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
  while(n-- > 0)
    177d:	eb 1d                	jmp    179c <memmove+0x46>
    *dst++ = *src++;
    177f:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
    1783:	48 8d 42 01          	lea    0x1(%rdx),%rax
    1787:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
    178b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    178f:	48 8d 48 01          	lea    0x1(%rax),%rcx
    1793:	48 89 4d f8          	mov    %rcx,-0x8(%rbp)
    1797:	0f b6 12             	movzbl (%rdx),%edx
    179a:	88 10                	mov    %dl,(%rax)
  while(n-- > 0)
    179c:	8b 45 dc             	mov    -0x24(%rbp),%eax
    179f:	8d 50 ff             	lea    -0x1(%rax),%edx
    17a2:	89 55 dc             	mov    %edx,-0x24(%rbp)
    17a5:	85 c0                	test   %eax,%eax
    17a7:	7f d6                	jg     177f <memmove+0x29>
  return vdst;
    17a9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
    17ad:	c9                   	leaveq 
    17ae:	c3                   	retq   

00000000000017af <fork>:
    mov $SYS_ ## name, %rax; \
    mov %rcx, %r10 ;\
    syscall		  ;\
    ret

SYSCALL(fork)
    17af:	48 c7 c0 01 00 00 00 	mov    $0x1,%rax
    17b6:	49 89 ca             	mov    %rcx,%r10
    17b9:	0f 05                	syscall 
    17bb:	c3                   	retq   

00000000000017bc <exit>:
SYSCALL(exit)
    17bc:	48 c7 c0 02 00 00 00 	mov    $0x2,%rax
    17c3:	49 89 ca             	mov    %rcx,%r10
    17c6:	0f 05                	syscall 
    17c8:	c3                   	retq   

00000000000017c9 <wait>:
SYSCALL(wait)
    17c9:	48 c7 c0 03 00 00 00 	mov    $0x3,%rax
    17d0:	49 89 ca             	mov    %rcx,%r10
    17d3:	0f 05                	syscall 
    17d5:	c3                   	retq   

00000000000017d6 <pipe>:
SYSCALL(pipe)
    17d6:	48 c7 c0 04 00 00 00 	mov    $0x4,%rax
    17dd:	49 89 ca             	mov    %rcx,%r10
    17e0:	0f 05                	syscall 
    17e2:	c3                   	retq   

00000000000017e3 <read>:
SYSCALL(read)
    17e3:	48 c7 c0 05 00 00 00 	mov    $0x5,%rax
    17ea:	49 89 ca             	mov    %rcx,%r10
    17ed:	0f 05                	syscall 
    17ef:	c3                   	retq   

00000000000017f0 <write>:
SYSCALL(write)
    17f0:	48 c7 c0 10 00 00 00 	mov    $0x10,%rax
    17f7:	49 89 ca             	mov    %rcx,%r10
    17fa:	0f 05                	syscall 
    17fc:	c3                   	retq   

00000000000017fd <close>:
SYSCALL(close)
    17fd:	48 c7 c0 15 00 00 00 	mov    $0x15,%rax
    1804:	49 89 ca             	mov    %rcx,%r10
    1807:	0f 05                	syscall 
    1809:	c3                   	retq   

000000000000180a <kill>:
SYSCALL(kill)
    180a:	48 c7 c0 06 00 00 00 	mov    $0x6,%rax
    1811:	49 89 ca             	mov    %rcx,%r10
    1814:	0f 05                	syscall 
    1816:	c3                   	retq   

0000000000001817 <exec>:
SYSCALL(exec)
    1817:	48 c7 c0 07 00 00 00 	mov    $0x7,%rax
    181e:	49 89 ca             	mov    %rcx,%r10
    1821:	0f 05                	syscall 
    1823:	c3                   	retq   

0000000000001824 <open>:
SYSCALL(open)
    1824:	48 c7 c0 0f 00 00 00 	mov    $0xf,%rax
    182b:	49 89 ca             	mov    %rcx,%r10
    182e:	0f 05                	syscall 
    1830:	c3                   	retq   

0000000000001831 <mknod>:
SYSCALL(mknod)
    1831:	48 c7 c0 11 00 00 00 	mov    $0x11,%rax
    1838:	49 89 ca             	mov    %rcx,%r10
    183b:	0f 05                	syscall 
    183d:	c3                   	retq   

000000000000183e <unlink>:
SYSCALL(unlink)
    183e:	48 c7 c0 12 00 00 00 	mov    $0x12,%rax
    1845:	49 89 ca             	mov    %rcx,%r10
    1848:	0f 05                	syscall 
    184a:	c3                   	retq   

000000000000184b <fstat>:
SYSCALL(fstat)
    184b:	48 c7 c0 08 00 00 00 	mov    $0x8,%rax
    1852:	49 89 ca             	mov    %rcx,%r10
    1855:	0f 05                	syscall 
    1857:	c3                   	retq   

0000000000001858 <link>:
SYSCALL(link)
    1858:	48 c7 c0 13 00 00 00 	mov    $0x13,%rax
    185f:	49 89 ca             	mov    %rcx,%r10
    1862:	0f 05                	syscall 
    1864:	c3                   	retq   

0000000000001865 <mkdir>:
SYSCALL(mkdir)
    1865:	48 c7 c0 14 00 00 00 	mov    $0x14,%rax
    186c:	49 89 ca             	mov    %rcx,%r10
    186f:	0f 05                	syscall 
    1871:	c3                   	retq   

0000000000001872 <chdir>:
SYSCALL(chdir)
    1872:	48 c7 c0 09 00 00 00 	mov    $0x9,%rax
    1879:	49 89 ca             	mov    %rcx,%r10
    187c:	0f 05                	syscall 
    187e:	c3                   	retq   

000000000000187f <dup>:
SYSCALL(dup)
    187f:	48 c7 c0 0a 00 00 00 	mov    $0xa,%rax
    1886:	49 89 ca             	mov    %rcx,%r10
    1889:	0f 05                	syscall 
    188b:	c3                   	retq   

000000000000188c <getpid>:
SYSCALL(getpid)
    188c:	48 c7 c0 0b 00 00 00 	mov    $0xb,%rax
    1893:	49 89 ca             	mov    %rcx,%r10
    1896:	0f 05                	syscall 
    1898:	c3                   	retq   

0000000000001899 <sbrk>:
SYSCALL(sbrk)
    1899:	48 c7 c0 0c 00 00 00 	mov    $0xc,%rax
    18a0:	49 89 ca             	mov    %rcx,%r10
    18a3:	0f 05                	syscall 
    18a5:	c3                   	retq   

00000000000018a6 <sleep>:
SYSCALL(sleep)
    18a6:	48 c7 c0 0d 00 00 00 	mov    $0xd,%rax
    18ad:	49 89 ca             	mov    %rcx,%r10
    18b0:	0f 05                	syscall 
    18b2:	c3                   	retq   

00000000000018b3 <uptime>:
SYSCALL(uptime)
    18b3:	48 c7 c0 0e 00 00 00 	mov    $0xe,%rax
    18ba:	49 89 ca             	mov    %rcx,%r10
    18bd:	0f 05                	syscall 
    18bf:	c3                   	retq   

00000000000018c0 <aread>:
SYSCALL(aread)
    18c0:	48 c7 c0 16 00 00 00 	mov    $0x16,%rax
    18c7:	49 89 ca             	mov    %rcx,%r10
    18ca:	0f 05                	syscall 
    18cc:	c3                   	retq   

00000000000018cd <putc>:

#include <stdarg.h>

static void
putc(int fd, char c)
{
    18cd:	f3 0f 1e fa          	endbr64 
    18d1:	55                   	push   %rbp
    18d2:	48 89 e5             	mov    %rsp,%rbp
    18d5:	48 83 ec 10          	sub    $0x10,%rsp
    18d9:	89 7d fc             	mov    %edi,-0x4(%rbp)
    18dc:	89 f0                	mov    %esi,%eax
    18de:	88 45 f8             	mov    %al,-0x8(%rbp)
  write(fd, &c, 1);
    18e1:	48 8d 4d f8          	lea    -0x8(%rbp),%rcx
    18e5:	8b 45 fc             	mov    -0x4(%rbp),%eax
    18e8:	ba 01 00 00 00       	mov    $0x1,%edx
    18ed:	48 89 ce             	mov    %rcx,%rsi
    18f0:	89 c7                	mov    %eax,%edi
    18f2:	48 b8 f0 17 00 00 00 	movabs $0x17f0,%rax
    18f9:	00 00 00 
    18fc:	ff d0                	callq  *%rax
}
    18fe:	90                   	nop
    18ff:	c9                   	leaveq 
    1900:	c3                   	retq   

0000000000001901 <print_x64>:

static char digits[] = "0123456789abcdef";

  static void
print_x64(int fd, addr_t x)
{
    1901:	f3 0f 1e fa          	endbr64 
    1905:	55                   	push   %rbp
    1906:	48 89 e5             	mov    %rsp,%rbp
    1909:	48 83 ec 20          	sub    $0x20,%rsp
    190d:	89 7d ec             	mov    %edi,-0x14(%rbp)
    1910:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  int i;
  for (i = 0; i < (sizeof(addr_t) * 2); i++, x <<= 4)
    1914:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
    191b:	eb 35                	jmp    1952 <print_x64+0x51>
    putc(fd, digits[x >> (sizeof(addr_t) * 8 - 4)]);
    191d:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
    1921:	48 c1 e8 3c          	shr    $0x3c,%rax
    1925:	48 ba b0 25 00 00 00 	movabs $0x25b0,%rdx
    192c:	00 00 00 
    192f:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax
    1933:	0f be d0             	movsbl %al,%edx
    1936:	8b 45 ec             	mov    -0x14(%rbp),%eax
    1939:	89 d6                	mov    %edx,%esi
    193b:	89 c7                	mov    %eax,%edi
    193d:	48 b8 cd 18 00 00 00 	movabs $0x18cd,%rax
    1944:	00 00 00 
    1947:	ff d0                	callq  *%rax
  for (i = 0; i < (sizeof(addr_t) * 2); i++, x <<= 4)
    1949:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
    194d:	48 c1 65 e0 04       	shlq   $0x4,-0x20(%rbp)
    1952:	8b 45 fc             	mov    -0x4(%rbp),%eax
    1955:	83 f8 0f             	cmp    $0xf,%eax
    1958:	76 c3                	jbe    191d <print_x64+0x1c>
}
    195a:	90                   	nop
    195b:	90                   	nop
    195c:	c9                   	leaveq 
    195d:	c3                   	retq   

000000000000195e <print_x32>:

  static void
print_x32(int fd, uint x)
{
    195e:	f3 0f 1e fa          	endbr64 
    1962:	55                   	push   %rbp
    1963:	48 89 e5             	mov    %rsp,%rbp
    1966:	48 83 ec 20          	sub    $0x20,%rsp
    196a:	89 7d ec             	mov    %edi,-0x14(%rbp)
    196d:	89 75 e8             	mov    %esi,-0x18(%rbp)
  int i;
  for (i = 0; i < (sizeof(uint) * 2); i++, x <<= 4)
    1970:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
    1977:	eb 36                	jmp    19af <print_x32+0x51>
    putc(fd, digits[x >> (sizeof(uint) * 8 - 4)]);
    1979:	8b 45 e8             	mov    -0x18(%rbp),%eax
    197c:	c1 e8 1c             	shr    $0x1c,%eax
    197f:	89 c2                	mov    %eax,%edx
    1981:	48 b8 b0 25 00 00 00 	movabs $0x25b0,%rax
    1988:	00 00 00 
    198b:	89 d2                	mov    %edx,%edx
    198d:	0f b6 04 10          	movzbl (%rax,%rdx,1),%eax
    1991:	0f be d0             	movsbl %al,%edx
    1994:	8b 45 ec             	mov    -0x14(%rbp),%eax
    1997:	89 d6                	mov    %edx,%esi
    1999:	89 c7                	mov    %eax,%edi
    199b:	48 b8 cd 18 00 00 00 	movabs $0x18cd,%rax
    19a2:	00 00 00 
    19a5:	ff d0                	callq  *%rax
  for (i = 0; i < (sizeof(uint) * 2); i++, x <<= 4)
    19a7:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
    19ab:	c1 65 e8 04          	shll   $0x4,-0x18(%rbp)
    19af:	8b 45 fc             	mov    -0x4(%rbp),%eax
    19b2:	83 f8 07             	cmp    $0x7,%eax
    19b5:	76 c2                	jbe    1979 <print_x32+0x1b>
}
    19b7:	90                   	nop
    19b8:	90                   	nop
    19b9:	c9                   	leaveq 
    19ba:	c3                   	retq   

00000000000019bb <print_d>:

  static void
print_d(int fd, int v)
{
    19bb:	f3 0f 1e fa          	endbr64 
    19bf:	55                   	push   %rbp
    19c0:	48 89 e5             	mov    %rsp,%rbp
    19c3:	48 83 ec 30          	sub    $0x30,%rsp
    19c7:	89 7d dc             	mov    %edi,-0x24(%rbp)
    19ca:	89 75 d8             	mov    %esi,-0x28(%rbp)
  char buf[16];
  int64 x = v;
    19cd:	8b 45 d8             	mov    -0x28(%rbp),%eax
    19d0:	48 98                	cltq   
    19d2:	48 89 45 f8          	mov    %rax,-0x8(%rbp)

  if (v < 0)
    19d6:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
    19da:	79 04                	jns    19e0 <print_d+0x25>
    x = -x;
    19dc:	48 f7 5d f8          	negq   -0x8(%rbp)

  int i = 0;
    19e0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%rbp)
  do {
    buf[i++] = digits[x % 10];
    19e7:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
    19eb:	48 ba 67 66 66 66 66 	movabs $0x6666666666666667,%rdx
    19f2:	66 66 66 
    19f5:	48 89 c8             	mov    %rcx,%rax
    19f8:	48 f7 ea             	imul   %rdx
    19fb:	48 c1 fa 02          	sar    $0x2,%rdx
    19ff:	48 89 c8             	mov    %rcx,%rax
    1a02:	48 c1 f8 3f          	sar    $0x3f,%rax
    1a06:	48 29 c2             	sub    %rax,%rdx
    1a09:	48 89 d0             	mov    %rdx,%rax
    1a0c:	48 c1 e0 02          	shl    $0x2,%rax
    1a10:	48 01 d0             	add    %rdx,%rax
    1a13:	48 01 c0             	add    %rax,%rax
    1a16:	48 29 c1             	sub    %rax,%rcx
    1a19:	48 89 ca             	mov    %rcx,%rdx
    1a1c:	8b 45 f4             	mov    -0xc(%rbp),%eax
    1a1f:	8d 48 01             	lea    0x1(%rax),%ecx
    1a22:	89 4d f4             	mov    %ecx,-0xc(%rbp)
    1a25:	48 b9 b0 25 00 00 00 	movabs $0x25b0,%rcx
    1a2c:	00 00 00 
    1a2f:	0f b6 14 11          	movzbl (%rcx,%rdx,1),%edx
    1a33:	48 98                	cltq   
    1a35:	88 54 05 e0          	mov    %dl,-0x20(%rbp,%rax,1)
    x /= 10;
    1a39:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
    1a3d:	48 ba 67 66 66 66 66 	movabs $0x6666666666666667,%rdx
    1a44:	66 66 66 
    1a47:	48 89 c8             	mov    %rcx,%rax
    1a4a:	48 f7 ea             	imul   %rdx
    1a4d:	48 c1 fa 02          	sar    $0x2,%rdx
    1a51:	48 89 c8             	mov    %rcx,%rax
    1a54:	48 c1 f8 3f          	sar    $0x3f,%rax
    1a58:	48 29 c2             	sub    %rax,%rdx
    1a5b:	48 89 d0             	mov    %rdx,%rax
    1a5e:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  } while(x != 0);
    1a62:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
    1a67:	0f 85 7a ff ff ff    	jne    19e7 <print_d+0x2c>

  if (v < 0)
    1a6d:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
    1a71:	79 32                	jns    1aa5 <print_d+0xea>
    buf[i++] = '-';
    1a73:	8b 45 f4             	mov    -0xc(%rbp),%eax
    1a76:	8d 50 01             	lea    0x1(%rax),%edx
    1a79:	89 55 f4             	mov    %edx,-0xc(%rbp)
    1a7c:	48 98                	cltq   
    1a7e:	c6 44 05 e0 2d       	movb   $0x2d,-0x20(%rbp,%rax,1)

  while (--i >= 0)
    1a83:	eb 20                	jmp    1aa5 <print_d+0xea>
    putc(fd, buf[i]);
    1a85:	8b 45 f4             	mov    -0xc(%rbp),%eax
    1a88:	48 98                	cltq   
    1a8a:	0f b6 44 05 e0       	movzbl -0x20(%rbp,%rax,1),%eax
    1a8f:	0f be d0             	movsbl %al,%edx
    1a92:	8b 45 dc             	mov    -0x24(%rbp),%eax
    1a95:	89 d6                	mov    %edx,%esi
    1a97:	89 c7                	mov    %eax,%edi
    1a99:	48 b8 cd 18 00 00 00 	movabs $0x18cd,%rax
    1aa0:	00 00 00 
    1aa3:	ff d0                	callq  *%rax
  while (--i >= 0)
    1aa5:	83 6d f4 01          	subl   $0x1,-0xc(%rbp)
    1aa9:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
    1aad:	79 d6                	jns    1a85 <print_d+0xca>
}
    1aaf:	90                   	nop
    1ab0:	90                   	nop
    1ab1:	c9                   	leaveq 
    1ab2:	c3                   	retq   

0000000000001ab3 <printf>:
// Print to the given fd. Only understands %d, %x, %p, %s.
  void
printf(int fd, char *fmt, ...)
{
    1ab3:	f3 0f 1e fa          	endbr64 
    1ab7:	55                   	push   %rbp
    1ab8:	48 89 e5             	mov    %rsp,%rbp
    1abb:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
    1ac2:	89 bd 1c ff ff ff    	mov    %edi,-0xe4(%rbp)
    1ac8:	48 89 b5 10 ff ff ff 	mov    %rsi,-0xf0(%rbp)
    1acf:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
    1ad6:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
    1add:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
    1ae4:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
    1aeb:	84 c0                	test   %al,%al
    1aed:	74 20                	je     1b0f <printf+0x5c>
    1aef:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
    1af3:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
    1af7:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
    1afb:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
    1aff:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
    1b03:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
    1b07:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
    1b0b:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  va_list ap;
  int i, c;
  char *s;

  va_start(ap, fmt);
    1b0f:	c7 85 20 ff ff ff 10 	movl   $0x10,-0xe0(%rbp)
    1b16:	00 00 00 
    1b19:	c7 85 24 ff ff ff 30 	movl   $0x30,-0xdc(%rbp)
    1b20:	00 00 00 
    1b23:	48 8d 45 10          	lea    0x10(%rbp),%rax
    1b27:	48 89 85 28 ff ff ff 	mov    %rax,-0xd8(%rbp)
    1b2e:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
    1b35:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  for (i = 0; (c = fmt[i] & 0xff) != 0; i++) {
    1b3c:	c7 85 4c ff ff ff 00 	movl   $0x0,-0xb4(%rbp)
    1b43:	00 00 00 
    1b46:	e9 41 03 00 00       	jmpq   1e8c <printf+0x3d9>
    if (c != '%') {
    1b4b:	83 bd 3c ff ff ff 25 	cmpl   $0x25,-0xc4(%rbp)
    1b52:	74 24                	je     1b78 <printf+0xc5>
      putc(fd, c);
    1b54:	8b 85 3c ff ff ff    	mov    -0xc4(%rbp),%eax
    1b5a:	0f be d0             	movsbl %al,%edx
    1b5d:	8b 85 1c ff ff ff    	mov    -0xe4(%rbp),%eax
    1b63:	89 d6                	mov    %edx,%esi
    1b65:	89 c7                	mov    %eax,%edi
    1b67:	48 b8 cd 18 00 00 00 	movabs $0x18cd,%rax
    1b6e:	00 00 00 
    1b71:	ff d0                	callq  *%rax
      continue;
    1b73:	e9 0d 03 00 00       	jmpq   1e85 <printf+0x3d2>
    }
    c = fmt[++i] & 0xff;
    1b78:	83 85 4c ff ff ff 01 	addl   $0x1,-0xb4(%rbp)
    1b7f:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
    1b85:	48 63 d0             	movslq %eax,%rdx
    1b88:	48 8b 85 10 ff ff ff 	mov    -0xf0(%rbp),%rax
    1b8f:	48 01 d0             	add    %rdx,%rax
    1b92:	0f b6 00             	movzbl (%rax),%eax
    1b95:	0f be c0             	movsbl %al,%eax
    1b98:	25 ff 00 00 00       	and    $0xff,%eax
    1b9d:	89 85 3c ff ff ff    	mov    %eax,-0xc4(%rbp)
    if (c == 0)
    1ba3:	83 bd 3c ff ff ff 00 	cmpl   $0x0,-0xc4(%rbp)
    1baa:	0f 84 0f 03 00 00    	je     1ebf <printf+0x40c>
      break;
    switch(c) {
    1bb0:	83 bd 3c ff ff ff 25 	cmpl   $0x25,-0xc4(%rbp)
    1bb7:	0f 84 74 02 00 00    	je     1e31 <printf+0x37e>
    1bbd:	83 bd 3c ff ff ff 25 	cmpl   $0x25,-0xc4(%rbp)
    1bc4:	0f 8c 82 02 00 00    	jl     1e4c <printf+0x399>
    1bca:	83 bd 3c ff ff ff 78 	cmpl   $0x78,-0xc4(%rbp)
    1bd1:	0f 8f 75 02 00 00    	jg     1e4c <printf+0x399>
    1bd7:	83 bd 3c ff ff ff 63 	cmpl   $0x63,-0xc4(%rbp)
    1bde:	0f 8c 68 02 00 00    	jl     1e4c <printf+0x399>
    1be4:	8b 85 3c ff ff ff    	mov    -0xc4(%rbp),%eax
    1bea:	83 e8 63             	sub    $0x63,%eax
    1bed:	83 f8 15             	cmp    $0x15,%eax
    1bf0:	0f 87 56 02 00 00    	ja     1e4c <printf+0x399>
    1bf6:	89 c0                	mov    %eax,%eax
    1bf8:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
    1bff:	00 
    1c00:	48 b8 08 22 00 00 00 	movabs $0x2208,%rax
    1c07:	00 00 00 
    1c0a:	48 01 d0             	add    %rdx,%rax
    1c0d:	48 8b 00             	mov    (%rax),%rax
    1c10:	3e ff e0             	notrack jmpq *%rax
    case 'c':
      putc(fd, va_arg(ap, int));
    1c13:	8b 85 20 ff ff ff    	mov    -0xe0(%rbp),%eax
    1c19:	83 f8 2f             	cmp    $0x2f,%eax
    1c1c:	77 23                	ja     1c41 <printf+0x18e>
    1c1e:	48 8b 85 30 ff ff ff 	mov    -0xd0(%rbp),%rax
    1c25:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    1c2b:	89 d2                	mov    %edx,%edx
    1c2d:	48 01 d0             	add    %rdx,%rax
    1c30:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    1c36:	83 c2 08             	add    $0x8,%edx
    1c39:	89 95 20 ff ff ff    	mov    %edx,-0xe0(%rbp)
    1c3f:	eb 12                	jmp    1c53 <printf+0x1a0>
    1c41:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
    1c48:	48 8d 50 08          	lea    0x8(%rax),%rdx
    1c4c:	48 89 95 28 ff ff ff 	mov    %rdx,-0xd8(%rbp)
    1c53:	8b 00                	mov    (%rax),%eax
    1c55:	0f be d0             	movsbl %al,%edx
    1c58:	8b 85 1c ff ff ff    	mov    -0xe4(%rbp),%eax
    1c5e:	89 d6                	mov    %edx,%esi
    1c60:	89 c7                	mov    %eax,%edi
    1c62:	48 b8 cd 18 00 00 00 	movabs $0x18cd,%rax
    1c69:	00 00 00 
    1c6c:	ff d0                	callq  *%rax
      break;
    1c6e:	e9 12 02 00 00       	jmpq   1e85 <printf+0x3d2>
    case 'd':
      print_d(fd, va_arg(ap, int));
    1c73:	8b 85 20 ff ff ff    	mov    -0xe0(%rbp),%eax
    1c79:	83 f8 2f             	cmp    $0x2f,%eax
    1c7c:	77 23                	ja     1ca1 <printf+0x1ee>
    1c7e:	48 8b 85 30 ff ff ff 	mov    -0xd0(%rbp),%rax
    1c85:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    1c8b:	89 d2                	mov    %edx,%edx
    1c8d:	48 01 d0             	add    %rdx,%rax
    1c90:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    1c96:	83 c2 08             	add    $0x8,%edx
    1c99:	89 95 20 ff ff ff    	mov    %edx,-0xe0(%rbp)
    1c9f:	eb 12                	jmp    1cb3 <printf+0x200>
    1ca1:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
    1ca8:	48 8d 50 08          	lea    0x8(%rax),%rdx
    1cac:	48 89 95 28 ff ff ff 	mov    %rdx,-0xd8(%rbp)
    1cb3:	8b 10                	mov    (%rax),%edx
    1cb5:	8b 85 1c ff ff ff    	mov    -0xe4(%rbp),%eax
    1cbb:	89 d6                	mov    %edx,%esi
    1cbd:	89 c7                	mov    %eax,%edi
    1cbf:	48 b8 bb 19 00 00 00 	movabs $0x19bb,%rax
    1cc6:	00 00 00 
    1cc9:	ff d0                	callq  *%rax
      break;
    1ccb:	e9 b5 01 00 00       	jmpq   1e85 <printf+0x3d2>
    case 'x':
      print_x32(fd, va_arg(ap, uint));
    1cd0:	8b 85 20 ff ff ff    	mov    -0xe0(%rbp),%eax
    1cd6:	83 f8 2f             	cmp    $0x2f,%eax
    1cd9:	77 23                	ja     1cfe <printf+0x24b>
    1cdb:	48 8b 85 30 ff ff ff 	mov    -0xd0(%rbp),%rax
    1ce2:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    1ce8:	89 d2                	mov    %edx,%edx
    1cea:	48 01 d0             	add    %rdx,%rax
    1ced:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    1cf3:	83 c2 08             	add    $0x8,%edx
    1cf6:	89 95 20 ff ff ff    	mov    %edx,-0xe0(%rbp)
    1cfc:	eb 12                	jmp    1d10 <printf+0x25d>
    1cfe:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
    1d05:	48 8d 50 08          	lea    0x8(%rax),%rdx
    1d09:	48 89 95 28 ff ff ff 	mov    %rdx,-0xd8(%rbp)
    1d10:	8b 10                	mov    (%rax),%edx
    1d12:	8b 85 1c ff ff ff    	mov    -0xe4(%rbp),%eax
    1d18:	89 d6                	mov    %edx,%esi
    1d1a:	89 c7                	mov    %eax,%edi
    1d1c:	48 b8 5e 19 00 00 00 	movabs $0x195e,%rax
    1d23:	00 00 00 
    1d26:	ff d0                	callq  *%rax
      break;
    1d28:	e9 58 01 00 00       	jmpq   1e85 <printf+0x3d2>
    case 'p':
      print_x64(fd, va_arg(ap, addr_t));
    1d2d:	8b 85 20 ff ff ff    	mov    -0xe0(%rbp),%eax
    1d33:	83 f8 2f             	cmp    $0x2f,%eax
    1d36:	77 23                	ja     1d5b <printf+0x2a8>
    1d38:	48 8b 85 30 ff ff ff 	mov    -0xd0(%rbp),%rax
    1d3f:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    1d45:	89 d2                	mov    %edx,%edx
    1d47:	48 01 d0             	add    %rdx,%rax
    1d4a:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    1d50:	83 c2 08             	add    $0x8,%edx
    1d53:	89 95 20 ff ff ff    	mov    %edx,-0xe0(%rbp)
    1d59:	eb 12                	jmp    1d6d <printf+0x2ba>
    1d5b:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
    1d62:	48 8d 50 08          	lea    0x8(%rax),%rdx
    1d66:	48 89 95 28 ff ff ff 	mov    %rdx,-0xd8(%rbp)
    1d6d:	48 8b 10             	mov    (%rax),%rdx
    1d70:	8b 85 1c ff ff ff    	mov    -0xe4(%rbp),%eax
    1d76:	48 89 d6             	mov    %rdx,%rsi
    1d79:	89 c7                	mov    %eax,%edi
    1d7b:	48 b8 01 19 00 00 00 	movabs $0x1901,%rax
    1d82:	00 00 00 
    1d85:	ff d0                	callq  *%rax
      break;
    1d87:	e9 f9 00 00 00       	jmpq   1e85 <printf+0x3d2>
    case 's':
      if ((s = va_arg(ap, char*)) == 0)
    1d8c:	8b 85 20 ff ff ff    	mov    -0xe0(%rbp),%eax
    1d92:	83 f8 2f             	cmp    $0x2f,%eax
    1d95:	77 23                	ja     1dba <printf+0x307>
    1d97:	48 8b 85 30 ff ff ff 	mov    -0xd0(%rbp),%rax
    1d9e:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    1da4:	89 d2                	mov    %edx,%edx
    1da6:	48 01 d0             	add    %rdx,%rax
    1da9:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    1daf:	83 c2 08             	add    $0x8,%edx
    1db2:	89 95 20 ff ff ff    	mov    %edx,-0xe0(%rbp)
    1db8:	eb 12                	jmp    1dcc <printf+0x319>
    1dba:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
    1dc1:	48 8d 50 08          	lea    0x8(%rax),%rdx
    1dc5:	48 89 95 28 ff ff ff 	mov    %rdx,-0xd8(%rbp)
    1dcc:	48 8b 00             	mov    (%rax),%rax
    1dcf:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
    1dd6:	48 83 bd 40 ff ff ff 	cmpq   $0x0,-0xc0(%rbp)
    1ddd:	00 
    1dde:	75 41                	jne    1e21 <printf+0x36e>
        s = "(null)";
    1de0:	48 b8 00 22 00 00 00 	movabs $0x2200,%rax
    1de7:	00 00 00 
    1dea:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
      while (*s)
    1df1:	eb 2e                	jmp    1e21 <printf+0x36e>
        putc(fd, *(s++));
    1df3:	48 8b 85 40 ff ff ff 	mov    -0xc0(%rbp),%rax
    1dfa:	48 8d 50 01          	lea    0x1(%rax),%rdx
    1dfe:	48 89 95 40 ff ff ff 	mov    %rdx,-0xc0(%rbp)
    1e05:	0f b6 00             	movzbl (%rax),%eax
    1e08:	0f be d0             	movsbl %al,%edx
    1e0b:	8b 85 1c ff ff ff    	mov    -0xe4(%rbp),%eax
    1e11:	89 d6                	mov    %edx,%esi
    1e13:	89 c7                	mov    %eax,%edi
    1e15:	48 b8 cd 18 00 00 00 	movabs $0x18cd,%rax
    1e1c:	00 00 00 
    1e1f:	ff d0                	callq  *%rax
      while (*s)
    1e21:	48 8b 85 40 ff ff ff 	mov    -0xc0(%rbp),%rax
    1e28:	0f b6 00             	movzbl (%rax),%eax
    1e2b:	84 c0                	test   %al,%al
    1e2d:	75 c4                	jne    1df3 <printf+0x340>
      break;
    1e2f:	eb 54                	jmp    1e85 <printf+0x3d2>
    case '%':
      putc(fd, '%');
    1e31:	8b 85 1c ff ff ff    	mov    -0xe4(%rbp),%eax
    1e37:	be 25 00 00 00       	mov    $0x25,%esi
    1e3c:	89 c7                	mov    %eax,%edi
    1e3e:	48 b8 cd 18 00 00 00 	movabs $0x18cd,%rax
    1e45:	00 00 00 
    1e48:	ff d0                	callq  *%rax
      break;
    1e4a:	eb 39                	jmp    1e85 <printf+0x3d2>
    default:
      // Print unknown % sequence to draw attention.
      putc(fd, '%');
    1e4c:	8b 85 1c ff ff ff    	mov    -0xe4(%rbp),%eax
    1e52:	be 25 00 00 00       	mov    $0x25,%esi
    1e57:	89 c7                	mov    %eax,%edi
    1e59:	48 b8 cd 18 00 00 00 	movabs $0x18cd,%rax
    1e60:	00 00 00 
    1e63:	ff d0                	callq  *%rax
      putc(fd, c);
    1e65:	8b 85 3c ff ff ff    	mov    -0xc4(%rbp),%eax
    1e6b:	0f be d0             	movsbl %al,%edx
    1e6e:	8b 85 1c ff ff ff    	mov    -0xe4(%rbp),%eax
    1e74:	89 d6                	mov    %edx,%esi
    1e76:	89 c7                	mov    %eax,%edi
    1e78:	48 b8 cd 18 00 00 00 	movabs $0x18cd,%rax
    1e7f:	00 00 00 
    1e82:	ff d0                	callq  *%rax
      break;
    1e84:	90                   	nop
  for (i = 0; (c = fmt[i] & 0xff) != 0; i++) {
    1e85:	83 85 4c ff ff ff 01 	addl   $0x1,-0xb4(%rbp)
    1e8c:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
    1e92:	48 63 d0             	movslq %eax,%rdx
    1e95:	48 8b 85 10 ff ff ff 	mov    -0xf0(%rbp),%rax
    1e9c:	48 01 d0             	add    %rdx,%rax
    1e9f:	0f b6 00             	movzbl (%rax),%eax
    1ea2:	0f be c0             	movsbl %al,%eax
    1ea5:	25 ff 00 00 00       	and    $0xff,%eax
    1eaa:	89 85 3c ff ff ff    	mov    %eax,-0xc4(%rbp)
    1eb0:	83 bd 3c ff ff ff 00 	cmpl   $0x0,-0xc4(%rbp)
    1eb7:	0f 85 8e fc ff ff    	jne    1b4b <printf+0x98>
    }
  }
}
    1ebd:	eb 01                	jmp    1ec0 <printf+0x40d>
      break;
    1ebf:	90                   	nop
}
    1ec0:	90                   	nop
    1ec1:	c9                   	leaveq 
    1ec2:	c3                   	retq   

0000000000001ec3 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    1ec3:	f3 0f 1e fa          	endbr64 
    1ec7:	55                   	push   %rbp
    1ec8:	48 89 e5             	mov    %rsp,%rbp
    1ecb:	48 83 ec 18          	sub    $0x18,%rsp
    1ecf:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  Header *bp, *p;

  bp = (Header*)ap - 1;
    1ed3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    1ed7:	48 83 e8 10          	sub    $0x10,%rax
    1edb:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    1edf:	48 b8 f0 29 00 00 00 	movabs $0x29f0,%rax
    1ee6:	00 00 00 
    1ee9:	48 8b 00             	mov    (%rax),%rax
    1eec:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
    1ef0:	eb 2f                	jmp    1f21 <free+0x5e>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    1ef2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1ef6:	48 8b 00             	mov    (%rax),%rax
    1ef9:	48 39 45 f8          	cmp    %rax,-0x8(%rbp)
    1efd:	72 17                	jb     1f16 <free+0x53>
    1eff:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1f03:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
    1f07:	77 2f                	ja     1f38 <free+0x75>
    1f09:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1f0d:	48 8b 00             	mov    (%rax),%rax
    1f10:	48 39 45 f0          	cmp    %rax,-0x10(%rbp)
    1f14:	72 22                	jb     1f38 <free+0x75>
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    1f16:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1f1a:	48 8b 00             	mov    (%rax),%rax
    1f1d:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
    1f21:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1f25:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
    1f29:	76 c7                	jbe    1ef2 <free+0x2f>
    1f2b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1f2f:	48 8b 00             	mov    (%rax),%rax
    1f32:	48 39 45 f0          	cmp    %rax,-0x10(%rbp)
    1f36:	73 ba                	jae    1ef2 <free+0x2f>
      break;
  if(bp + bp->s.size == p->s.ptr){
    1f38:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1f3c:	8b 40 08             	mov    0x8(%rax),%eax
    1f3f:	89 c0                	mov    %eax,%eax
    1f41:	48 c1 e0 04          	shl    $0x4,%rax
    1f45:	48 89 c2             	mov    %rax,%rdx
    1f48:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1f4c:	48 01 c2             	add    %rax,%rdx
    1f4f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1f53:	48 8b 00             	mov    (%rax),%rax
    1f56:	48 39 c2             	cmp    %rax,%rdx
    1f59:	75 2d                	jne    1f88 <free+0xc5>
    bp->s.size += p->s.ptr->s.size;
    1f5b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1f5f:	8b 50 08             	mov    0x8(%rax),%edx
    1f62:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1f66:	48 8b 00             	mov    (%rax),%rax
    1f69:	8b 40 08             	mov    0x8(%rax),%eax
    1f6c:	01 c2                	add    %eax,%edx
    1f6e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1f72:	89 50 08             	mov    %edx,0x8(%rax)
    bp->s.ptr = p->s.ptr->s.ptr;
    1f75:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1f79:	48 8b 00             	mov    (%rax),%rax
    1f7c:	48 8b 10             	mov    (%rax),%rdx
    1f7f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1f83:	48 89 10             	mov    %rdx,(%rax)
    1f86:	eb 0e                	jmp    1f96 <free+0xd3>
  } else
    bp->s.ptr = p->s.ptr;
    1f88:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1f8c:	48 8b 10             	mov    (%rax),%rdx
    1f8f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1f93:	48 89 10             	mov    %rdx,(%rax)
  if(p + p->s.size == bp){
    1f96:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1f9a:	8b 40 08             	mov    0x8(%rax),%eax
    1f9d:	89 c0                	mov    %eax,%eax
    1f9f:	48 c1 e0 04          	shl    $0x4,%rax
    1fa3:	48 89 c2             	mov    %rax,%rdx
    1fa6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1faa:	48 01 d0             	add    %rdx,%rax
    1fad:	48 39 45 f0          	cmp    %rax,-0x10(%rbp)
    1fb1:	75 27                	jne    1fda <free+0x117>
    p->s.size += bp->s.size;
    1fb3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1fb7:	8b 50 08             	mov    0x8(%rax),%edx
    1fba:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1fbe:	8b 40 08             	mov    0x8(%rax),%eax
    1fc1:	01 c2                	add    %eax,%edx
    1fc3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1fc7:	89 50 08             	mov    %edx,0x8(%rax)
    p->s.ptr = bp->s.ptr;
    1fca:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1fce:	48 8b 10             	mov    (%rax),%rdx
    1fd1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1fd5:	48 89 10             	mov    %rdx,(%rax)
    1fd8:	eb 0b                	jmp    1fe5 <free+0x122>
  } else
    p->s.ptr = bp;
    1fda:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1fde:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
    1fe2:	48 89 10             	mov    %rdx,(%rax)
  freep = p;
    1fe5:	48 ba f0 29 00 00 00 	movabs $0x29f0,%rdx
    1fec:	00 00 00 
    1fef:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1ff3:	48 89 02             	mov    %rax,(%rdx)
}
    1ff6:	90                   	nop
    1ff7:	c9                   	leaveq 
    1ff8:	c3                   	retq   

0000000000001ff9 <morecore>:

static Header*
morecore(uint nu)
{
    1ff9:	f3 0f 1e fa          	endbr64 
    1ffd:	55                   	push   %rbp
    1ffe:	48 89 e5             	mov    %rsp,%rbp
    2001:	48 83 ec 20          	sub    $0x20,%rsp
    2005:	89 7d ec             	mov    %edi,-0x14(%rbp)
  char *p;
  Header *hp;

  if(nu < 4096)
    2008:	81 7d ec ff 0f 00 00 	cmpl   $0xfff,-0x14(%rbp)
    200f:	77 07                	ja     2018 <morecore+0x1f>
    nu = 4096;
    2011:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%rbp)
  p = sbrk(nu * sizeof(Header));
    2018:	8b 45 ec             	mov    -0x14(%rbp),%eax
    201b:	48 c1 e0 04          	shl    $0x4,%rax
    201f:	48 89 c7             	mov    %rax,%rdi
    2022:	48 b8 99 18 00 00 00 	movabs $0x1899,%rax
    2029:	00 00 00 
    202c:	ff d0                	callq  *%rax
    202e:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  if(p == (char*)-1)
    2032:	48 83 7d f8 ff       	cmpq   $0xffffffffffffffff,-0x8(%rbp)
    2037:	75 07                	jne    2040 <morecore+0x47>
    return 0;
    2039:	b8 00 00 00 00       	mov    $0x0,%eax
    203e:	eb 36                	jmp    2076 <morecore+0x7d>
  hp = (Header*)p;
    2040:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    2044:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
  hp->s.size = nu;
    2048:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    204c:	8b 55 ec             	mov    -0x14(%rbp),%edx
    204f:	89 50 08             	mov    %edx,0x8(%rax)
  free((void*)(hp + 1));
    2052:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    2056:	48 83 c0 10          	add    $0x10,%rax
    205a:	48 89 c7             	mov    %rax,%rdi
    205d:	48 b8 c3 1e 00 00 00 	movabs $0x1ec3,%rax
    2064:	00 00 00 
    2067:	ff d0                	callq  *%rax
  return freep;
    2069:	48 b8 f0 29 00 00 00 	movabs $0x29f0,%rax
    2070:	00 00 00 
    2073:	48 8b 00             	mov    (%rax),%rax
}
    2076:	c9                   	leaveq 
    2077:	c3                   	retq   

0000000000002078 <malloc>:

void*
malloc(uint nbytes)
{
    2078:	f3 0f 1e fa          	endbr64 
    207c:	55                   	push   %rbp
    207d:	48 89 e5             	mov    %rsp,%rbp
    2080:	48 83 ec 30          	sub    $0x30,%rsp
    2084:	89 7d dc             	mov    %edi,-0x24(%rbp)
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    2087:	8b 45 dc             	mov    -0x24(%rbp),%eax
    208a:	48 83 c0 0f          	add    $0xf,%rax
    208e:	48 c1 e8 04          	shr    $0x4,%rax
    2092:	83 c0 01             	add    $0x1,%eax
    2095:	89 45 ec             	mov    %eax,-0x14(%rbp)
  if((prevp = freep) == 0){
    2098:	48 b8 f0 29 00 00 00 	movabs $0x29f0,%rax
    209f:	00 00 00 
    20a2:	48 8b 00             	mov    (%rax),%rax
    20a5:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
    20a9:	48 83 7d f0 00       	cmpq   $0x0,-0x10(%rbp)
    20ae:	75 4a                	jne    20fa <malloc+0x82>
    base.s.ptr = freep = prevp = &base;
    20b0:	48 b8 e0 29 00 00 00 	movabs $0x29e0,%rax
    20b7:	00 00 00 
    20ba:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
    20be:	48 ba f0 29 00 00 00 	movabs $0x29f0,%rdx
    20c5:	00 00 00 
    20c8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    20cc:	48 89 02             	mov    %rax,(%rdx)
    20cf:	48 b8 f0 29 00 00 00 	movabs $0x29f0,%rax
    20d6:	00 00 00 
    20d9:	48 8b 00             	mov    (%rax),%rax
    20dc:	48 ba e0 29 00 00 00 	movabs $0x29e0,%rdx
    20e3:	00 00 00 
    20e6:	48 89 02             	mov    %rax,(%rdx)
    base.s.size = 0;
    20e9:	48 b8 e0 29 00 00 00 	movabs $0x29e0,%rax
    20f0:	00 00 00 
    20f3:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%rax)
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    20fa:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    20fe:	48 8b 00             	mov    (%rax),%rax
    2101:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
    if(p->s.size >= nunits){
    2105:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    2109:	8b 40 08             	mov    0x8(%rax),%eax
    210c:	39 45 ec             	cmp    %eax,-0x14(%rbp)
    210f:	77 65                	ja     2176 <malloc+0xfe>
      if(p->s.size == nunits)
    2111:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    2115:	8b 40 08             	mov    0x8(%rax),%eax
    2118:	39 45 ec             	cmp    %eax,-0x14(%rbp)
    211b:	75 10                	jne    212d <malloc+0xb5>
        prevp->s.ptr = p->s.ptr;
    211d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    2121:	48 8b 10             	mov    (%rax),%rdx
    2124:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    2128:	48 89 10             	mov    %rdx,(%rax)
    212b:	eb 2e                	jmp    215b <malloc+0xe3>
      else {
        p->s.size -= nunits;
    212d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    2131:	8b 40 08             	mov    0x8(%rax),%eax
    2134:	2b 45 ec             	sub    -0x14(%rbp),%eax
    2137:	89 c2                	mov    %eax,%edx
    2139:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    213d:	89 50 08             	mov    %edx,0x8(%rax)
        p += p->s.size;
    2140:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    2144:	8b 40 08             	mov    0x8(%rax),%eax
    2147:	89 c0                	mov    %eax,%eax
    2149:	48 c1 e0 04          	shl    $0x4,%rax
    214d:	48 01 45 f8          	add    %rax,-0x8(%rbp)
        p->s.size = nunits;
    2151:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    2155:	8b 55 ec             	mov    -0x14(%rbp),%edx
    2158:	89 50 08             	mov    %edx,0x8(%rax)
      }
      freep = prevp;
    215b:	48 ba f0 29 00 00 00 	movabs $0x29f0,%rdx
    2162:	00 00 00 
    2165:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    2169:	48 89 02             	mov    %rax,(%rdx)
      return (void*)(p + 1);
    216c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    2170:	48 83 c0 10          	add    $0x10,%rax
    2174:	eb 4e                	jmp    21c4 <malloc+0x14c>
    }
    if(p == freep)
    2176:	48 b8 f0 29 00 00 00 	movabs $0x29f0,%rax
    217d:	00 00 00 
    2180:	48 8b 00             	mov    (%rax),%rax
    2183:	48 39 45 f8          	cmp    %rax,-0x8(%rbp)
    2187:	75 23                	jne    21ac <malloc+0x134>
      if((p = morecore(nunits)) == 0)
    2189:	8b 45 ec             	mov    -0x14(%rbp),%eax
    218c:	89 c7                	mov    %eax,%edi
    218e:	48 b8 f9 1f 00 00 00 	movabs $0x1ff9,%rax
    2195:	00 00 00 
    2198:	ff d0                	callq  *%rax
    219a:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
    219e:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
    21a3:	75 07                	jne    21ac <malloc+0x134>
        return 0;
    21a5:	b8 00 00 00 00       	mov    $0x0,%eax
    21aa:	eb 18                	jmp    21c4 <malloc+0x14c>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    21ac:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    21b0:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
    21b4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    21b8:	48 8b 00             	mov    (%rax),%rax
    21bb:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
    if(p->s.size >= nunits){
    21bf:	e9 41 ff ff ff       	jmpq   2105 <malloc+0x8d>
  }
}
    21c4:	c9                   	leaveq 
    21c5:	c3                   	retq   
