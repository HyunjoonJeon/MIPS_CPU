
7-ctests/array_write/array_write.mips.elf:     file format elf32-tradlittlemips


Disassembly of section .text:

bfc00000 <arraywrite>:
bfc00000:	27bdffd8 	addiu	sp,sp,-40
bfc00004:	afbe0024 	sw	s8,36(sp)
bfc00008:	03a0f025 	move	s8,sp
bfc0000c:	afc00008 	sw	zero,8(s8)
bfc00010:	1000000d 	b	bfc00048 <arraywrite+0x48>
bfc00014:	00000000 	nop
bfc00018:	8fc20008 	lw	v0,8(s8)
bfc0001c:	00000000 	nop
bfc00020:	00021080 	sll	v0,v0,0x2
bfc00024:	27c30008 	addiu	v1,s8,8
bfc00028:	00621021 	addu	v0,v1,v0
bfc0002c:	8fc30008 	lw	v1,8(s8)
bfc00030:	00000000 	nop
bfc00034:	ac430004 	sw	v1,4(v0)
bfc00038:	8fc20008 	lw	v0,8(s8)
bfc0003c:	00000000 	nop
bfc00040:	24420001 	addiu	v0,v0,1
bfc00044:	afc20008 	sw	v0,8(s8)
bfc00048:	8fc20008 	lw	v0,8(s8)
bfc0004c:	00000000 	nop
bfc00050:	28420005 	slti	v0,v0,5
bfc00054:	1440fff0 	bnez	v0,bfc00018 <arraywrite+0x18>
bfc00058:	00000000 	nop
bfc0005c:	8fc2001c 	lw	v0,28(s8)
bfc00060:	03c0e825 	move	sp,s8
bfc00064:	8fbe0024 	lw	s8,36(sp)
bfc00068:	27bd0028 	addiu	sp,sp,40
bfc0006c:	03e00008 	jr	ra
bfc00070:	00000000 	nop
	...
