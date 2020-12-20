
7-ctests/arraysearchn/arraysearchn.mips.elf:     file format elf32-tradlittlemips


Disassembly of section .text:

bfc00000 <searcharray>:
bfc00000:	27bdffd0 	addiu	sp,sp,-48
bfc00004:	afbe002c 	sw	s8,44(sp)
bfc00008:	03a0f025 	move	s8,sp
bfc0000c:	afc00008 	sw	zero,8(s8)
bfc00010:	1000000e 	b	bfc0004c <searcharray+0x4c>
bfc00014:	00000000 	nop
bfc00018:	8fc20008 	lw	v0,8(s8)
bfc0001c:	00000000 	nop
bfc00020:	24430003 	addiu	v1,v0,3
bfc00024:	8fc20008 	lw	v0,8(s8)
bfc00028:	00000000 	nop
bfc0002c:	00021080 	sll	v0,v0,0x2
bfc00030:	27c40008 	addiu	a0,s8,8
bfc00034:	00821021 	addu	v0,a0,v0
bfc00038:	ac43000c 	sw	v1,12(v0)
bfc0003c:	8fc20008 	lw	v0,8(s8)
bfc00040:	00000000 	nop
bfc00044:	24420001 	addiu	v0,v0,1
bfc00048:	afc20008 	sw	v0,8(s8)
bfc0004c:	8fc20008 	lw	v0,8(s8)
bfc00050:	00000000 	nop
bfc00054:	2842000a 	slti	v0,v0,10
bfc00058:	1440ffef 	bnez	v0,bfc00018 <searcharray+0x18>
bfc0005c:	00000000 	nop
bfc00060:	24020548 	li	v0,1352
bfc00064:	afc20010 	sw	v0,16(s8)
bfc00068:	afc0000c 	sw	zero,12(s8)
bfc0006c:	10000012 	b	bfc000b8 <searcharray+0xb8>
bfc00070:	00000000 	nop
bfc00074:	8fc2000c 	lw	v0,12(s8)
bfc00078:	00000000 	nop
bfc0007c:	00021080 	sll	v0,v0,0x2
bfc00080:	27c30008 	addiu	v1,s8,8
bfc00084:	00621021 	addu	v0,v1,v0
bfc00088:	8c42000c 	lw	v0,12(v0)
bfc0008c:	8fc30010 	lw	v1,16(s8)
bfc00090:	00000000 	nop
bfc00094:	14620004 	bne	v1,v0,bfc000a8 <searcharray+0xa8>
bfc00098:	00000000 	nop
bfc0009c:	8fc2000c 	lw	v0,12(s8)
bfc000a0:	1000000b 	b	bfc000d0 <searcharray+0xd0>
bfc000a4:	00000000 	nop
bfc000a8:	8fc2000c 	lw	v0,12(s8)
bfc000ac:	00000000 	nop
bfc000b0:	24420001 	addiu	v0,v0,1
bfc000b4:	afc2000c 	sw	v0,12(s8)
bfc000b8:	8fc2000c 	lw	v0,12(s8)
bfc000bc:	00000000 	nop
bfc000c0:	2842000a 	slti	v0,v0,10
bfc000c4:	1440ffeb 	bnez	v0,bfc00074 <searcharray+0x74>
bfc000c8:	00000000 	nop
bfc000cc:	2402ffff 	li	v0,-1
bfc000d0:	03c0e825 	move	sp,s8
bfc000d4:	8fbe002c 	lw	s8,44(sp)
bfc000d8:	27bd0030 	addiu	sp,sp,48
bfc000dc:	03e00008 	jr	ra
bfc000e0:	00000000 	nop
	...
