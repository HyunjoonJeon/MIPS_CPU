
7-ctests/countoccurance/countoccurance.mips.elf:     file format elf32-tradlittlemips


Disassembly of section .text:

bfc00000 <count>:
bfc00000:	27bdff90 	addiu	sp,sp,-112
bfc00004:	afbe006c 	sw	s8,108(sp)
bfc00008:	03a0f025 	move	s8,sp
bfc0000c:	afc00008 	sw	zero,8(s8)
bfc00010:	10000013 	b	bfc00060 <count+0x60>
bfc00014:	00000000 	nop
bfc00018:	8fc30008 	lw	v1,8(s8)
bfc0001c:	24020003 	li	v0,3
bfc00020:	0062001a 	div	zero,v1,v0
bfc00024:	14400002 	bnez	v0,bfc00030 <count+0x30>
bfc00028:	00000000 	nop
bfc0002c:	0007000d 	break	0x7
bfc00030:	00001010 	mfhi	v0
bfc00034:	00401825 	move	v1,v0
bfc00038:	8fc20008 	lw	v0,8(s8)
bfc0003c:	00000000 	nop
bfc00040:	00021080 	sll	v0,v0,0x2
bfc00044:	27c40008 	addiu	a0,s8,8
bfc00048:	00821021 	addu	v0,a0,v0
bfc0004c:	ac43000c 	sw	v1,12(v0)
bfc00050:	8fc20008 	lw	v0,8(s8)
bfc00054:	00000000 	nop
bfc00058:	24420001 	addiu	v0,v0,1
bfc0005c:	afc20008 	sw	v0,8(s8)
bfc00060:	8fc20008 	lw	v0,8(s8)
bfc00064:	00000000 	nop
bfc00068:	28420014 	slti	v0,v0,20
bfc0006c:	1440ffea 	bnez	v0,bfc00018 <count+0x18>
bfc00070:	00000000 	nop
bfc00074:	afc0000c 	sw	zero,12(s8)
bfc00078:	afc00010 	sw	zero,16(s8)
bfc0007c:	10000012 	b	bfc000c8 <count+0xc8>
bfc00080:	00000000 	nop
bfc00084:	8fc20010 	lw	v0,16(s8)
bfc00088:	00000000 	nop
bfc0008c:	00021080 	sll	v0,v0,0x2
bfc00090:	27c30008 	addiu	v1,s8,8
bfc00094:	00621021 	addu	v0,v1,v0
bfc00098:	8c43000c 	lw	v1,12(v0)
bfc0009c:	24020002 	li	v0,2
bfc000a0:	14620005 	bne	v1,v0,bfc000b8 <count+0xb8>
bfc000a4:	00000000 	nop
bfc000a8:	8fc2000c 	lw	v0,12(s8)
bfc000ac:	00000000 	nop
bfc000b0:	24420001 	addiu	v0,v0,1
bfc000b4:	afc2000c 	sw	v0,12(s8)
bfc000b8:	8fc20010 	lw	v0,16(s8)
bfc000bc:	00000000 	nop
bfc000c0:	24420001 	addiu	v0,v0,1
bfc000c4:	afc20010 	sw	v0,16(s8)
bfc000c8:	8fc20010 	lw	v0,16(s8)
bfc000cc:	00000000 	nop
bfc000d0:	28420014 	slti	v0,v0,20
bfc000d4:	1440ffeb 	bnez	v0,bfc00084 <count+0x84>
bfc000d8:	00000000 	nop
bfc000dc:	8fc2000c 	lw	v0,12(s8)
bfc000e0:	03c0e825 	move	sp,s8
bfc000e4:	8fbe006c 	lw	s8,108(sp)
bfc000e8:	27bd0070 	addiu	sp,sp,112
bfc000ec:	03e00008 	jr	ra
bfc000f0:	00000000 	nop
	...
