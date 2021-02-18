	;; Vector table
ffff0000:	ea000008 	b	reset	      ; reset
ffff0004:	ea000006 	b	unimplemented ; _undefined_instruction
ffff0008:	ea000005 	b	unimplemented ; _software_interrupt
ffff000c:	ea000004 	b	unimplemented ; _prefetch_abort
ffff0010:	ea000003 	b	unimplemented ; _data_abort
ffff0014:	ea000002 	b	unimplemented ; _not_used
ffff0018:	ea000011 	b	irq	      ; _irq
ffff001c:	ea000000 	b	unimplemented ; _fiq
ffff0020:	ea000013 	b	fel_setup     ; FEL

unimplemented:
ffff0024:	eafffffe 	b	unimplemented ; loop forever

	;;  Entry point, clear all registers (except r0) and jump to BROM
reset:
ffff0028:	e3a00001 	mov	r0, #1
ffff002c:	e3a01000 	mov	r1, #0
ffff0030:	e3a02000 	mov	r2, #0
ffff0034:	e3a03000 	mov	r3, #0
ffff0038:	e3a04000 	mov	r4, #0
ffff003c:	e3a05000 	mov	r5, #0
ffff0040:	e3a06000 	mov	r6, #0
ffff0044:	e3a07000 	mov	r7, #0
ffff0048:	e3a08000 	mov	r8, #0
ffff004c:	e3a09000 	mov	r9, #0
ffff0050:	e3a0a000 	mov	sl, #0
ffff0054:	e3a0b000 	mov	fp, #0
ffff0058:	e3a0c000 	mov	ip, #0
ffff005c:	e3a0d000 	mov	sp, #0
ffff0060:	e59ff100 	ldr	pc, [pc, #256]	; 0xffff0168 =0xffff2c00 jump to BROM

	;; First-level interrrupt handler
irq:
ffff0064:	e24ee004 	sub	lr, lr, #4
ffff0068:	e92d5fff 	push	{r0, r1, r2, r3, r4, r5, r6, r7, r8, r9, sl, fp, ip, lr}
ffff006c:	eb000709 	bl	interrupt_handler
ffff0070:	e8fd9fff 	ldm	sp!, {r0, r1, r2, r3, r4, r5, r6, r7, r8, r9, sl, fp, ip, pc}^

	;; FEL entry point
fel_setup:
ffff0074:	e3a020d2 	mov	r2, #210	; 0xd2
ffff0078:	e121f002 	msr	CPSR_c, r2
ffff007c:	e59fd0e8 	ldr	sp, [pc, #232]	; 0xffff016c =0x00002000
ffff0080:	e10f0000 	mrs	r0, CPSR
ffff0084:	e3c0001f 	bic	r0, r0, #31
ffff0088:	e38000d3 	orr	r0, r0, #211	; 0xd3
ffff008c:	e121f000 	msr	CPSR_c, r0
ffff0090:	e59fd0d8 	ldr	sp, [pc, #216]	; 0xffff0170 =0x00007000
ffff0094:	ee110f30 	mrc	15, 0, r0, cr1, cr0, {1}
ffff0098:	e3c00002 	bic	r0, r0, #2
ffff009c:	ee010f30 	mcr	15, 0, r0, cr1, cr0, {1}
ffff00a0:	ee110f10 	mrc	15, 0, r0, cr1, cr0, {0}
ffff00a4:	e3c00001 	bic	r0, r0, #1
ffff00a8:	e3c00b02 	bic	r0, r0, #2048	; 0x800
ffff00ac:	e3c00a01 	bic	r0, r0, #4096	; 0x1000
ffff00b0:	e3c00004 	bic	r0, r0, #4
ffff00b4:	ee010f10 	mcr	15, 0, r0, cr1, cr0, {0}
ffff00b8:	ee110f10 	mrc	15, 0, r0, cr1, cr0, {0}
ffff00bc:	e3800a02 	orr	r0, r0, #8192	; 0x2000
ffff00c0:	ee010f10 	mcr	15, 0, r0, cr1, cr0, {0}
ffff00c4:	e59f10a8 	ldr	r1, [pc, #168]	; 0xffff0174 =0x01c20000 CCU_BASE
ffff00c8:	e3a02000 	mov	r2, #0
ffff00cc:	e5913050 	ldr	r3, [r1, #80]	; 0x50
ffff00d0:	e3c33a01 	bic	r3, r3, #4096	; 0x1000
ffff00d4:	e1834002 	orr	r4, r3, r2
ffff00d8:	e5814050 	str	r4, [r1, #80]	; 0x50
ffff00dc:	e3a02000 	mov	r2, #0
ffff00e0:	e5913050 	ldr	r3, [r1, #80]	; 0x50
ffff00e4:	e3c33003 	bic	r3, r3, #3
ffff00e8:	e1834002 	orr	r4, r3, r2
ffff00ec:	e5814050 	str	r4, [r1, #80]	; 0x50
ffff00f0:	e3012110 	movw	r2, #4368	; 0x1110
ffff00f4:	e5913054 	ldr	r3, [r1, #84]	; 0x54
ffff00f8:	e3c330f0 	bic	r3, r3, #240	; 0xf0
ffff00fc:	e3c33c33 	bic	r3, r3, #13056	; 0x3300
ffff0100:	e1834002 	orr	r4, r3, r2
ffff0104:	e5814054 	str	r4, [r1, #84]	; 0x54
ffff0108:	e3a02c01 	mov	r2, #256	; 0x100
ffff010c:	e59130cc 	ldr	r3, [r1, #204]	; 0xcc
ffff0110:	e3c33c01 	bic	r3, r3, #256	; 0x100
ffff0114:	e1834002 	orr	r4, r3, r2
ffff0118:	e58140cc 	str	r4, [r1, #204]	; 0xcc
ffff011c:	e3020710 	movw	r0, #10000	; 0x2710

ffff0120:	e2500001 	subs	r0, r0, #1
ffff0124:	1afffffd 	bne	0xffff0120

ffff0128:	e3a02401 	mov	r2, #16777216	; 0x1000000
ffff012c:	e5913060 	ldr	r3, [r1, #96]	; 0x60
ffff0130:	e3c33401 	bic	r3, r3, #16777216	; 0x1000000
ffff0134:	e1834002 	orr	r4, r3, r2
ffff0138:	e5814060 	str	r4, [r1, #96]	; 0x60
ffff013c:	e3a02401 	mov	r2, #16777216	; 0x1000000
ffff0140:	e59132c0 	ldr	r3, [r1, #704]	; 0x2c0
ffff0144:	e3c33401 	bic	r3, r3, #16777216	; 0x1000000
ffff0148:	e1834002 	orr	r4, r3, r2
ffff014c:	e58142c0 	str	r4, [r1, #704]	; 0x2c0
ffff0150:	e3a02001 	mov	r2, #1
ffff0154:	e59130cc 	ldr	r3, [r1, #204]	; 0xcc
ffff0158:	e3c33001 	bic	r3, r3, #1
ffff015c:	e1834002 	orr	r4, r3, r2
ffff0160:	e58140cc 	str	r4, [r1, #204]	; 0xcc
ffff0164:	eb00085f 	bl	0xffff22e8

	;; Global Offset Table
ffff0168:	ffff2c00
ffff016c:	00002000
ffff0170:	00007000
ffff0174:	01c20000			 	; CCU_BASE

ffff0178:	e12fff1e 	bx	lr

ffff017c:	e12fff1e 	bx	lr

ffff0180:	e3a01000 	mov	r1, #0
ffff0184:	ea000000 	b	0xffff018c

ffff0188:	e2811001 	add	r1, r1, #1

ffff018c:	e5d02018 	ldrb	r2, [r0, #24]
ffff0190:	e3520001 	cmp	r2, #1
ffff0194:	0afffffb 	beq	0xffff0188

ffff0198:	e12fff1e 	bx	lr

ffff019c:	e92d4010 	push	{r4, lr}
ffff01a0:	e1a04000 	mov	r4, r0
ffff01a4:	e3a02022 	mov	r2, #34	; 0x22
ffff01a8:	e3a01000 	mov	r1, #0
ffff01ac:	e1a00004 	mov	r0, r4
ffff01b0:	eb0001c9 	bl	0xffff08dc
ffff01b4:	e3a00000 	mov	r0, #0
ffff01b8:	e5c40020 	strb	r0, [r4, #32]
ffff01bc:	e5c40021 	strb	r0, [r4, #33]	; 0x21
ffff01c0:	e8bd8010 	pop	{r4, pc}

ffff01c4:	e5801000 	str	r1, [r0]
ffff01c8:	e5802004 	str	r2, [r0, #4]
ffff01cc:	e3a03000 	mov	r3, #0
ffff01d0:	e5c03008 	strb	r3, [r0, #8]
ffff01d4:	e5803010 	str	r3, [r0, #16]
ffff01d8:	e3a03001 	mov	r3, #1
ffff01dc:	e5c03018 	strb	r3, [r0, #24]
ffff01e0:	e12fff1e 	bx	lr

ffff01e4:	e92d4070 	push	{r4, r5, r6, lr}
ffff01e8:	e24dd020 	sub	sp, sp, #32
ffff01ec:	e1a06000 	mov	r6, r0
ffff01f0:	e1a04001 	mov	r4, r1
ffff01f4:	e3a05000 	mov	r5, #0
ffff01f8:	e5965034 	ldr	r5, [r6, #52]	; 0x34
ffff01fc:	e1a00005 	mov	r0, r5
ffff0200:	ebffffde 	bl	0xffff0180
ffff0204:	e3a02020 	mov	r2, #32
ffff0208:	e3a01000 	mov	r1, #0
ffff020c:	e1a0000d 	mov	r0, sp
ffff0210:	eb0001b1 	bl	0xffff08dc
ffff0214:	e1a00006 	mov	r0, r6
ffff0218:	eb000324 	bl	0xffff0eb0
ffff021c:	e3a02020 	mov	r2, #32
ffff0220:	e1a0100d 	mov	r1, sp
ffff0224:	e1a00005 	mov	r0, r5
ffff0228:	ebffffe5 	bl	0xffff01c4
ffff022c:	e3a00001 	mov	r0, #1
ffff0230:	e5c40020 	strb	r0, [r4, #32]
ffff0234:	e3a02000 	mov	r2, #0
ffff0238:	e1a01005 	mov	r1, r5
ffff023c:	e1a00006 	mov	r0, r6
ffff0240:	eb00039c 	bl	0xffff10b8
ffff0244:	e1a00005 	mov	r0, r5
ffff0248:	ebffffcc 	bl	0xffff0180
ffff024c:	e3a02022 	mov	r2, #34	; 0x22
ffff0250:	e1a00004 	mov	r0, r4
ffff0254:	e5951000 	ldr	r1, [r5]
ffff0258:	eb000195 	bl	0xffff08b4
ffff025c:	e28dd020 	add	sp, sp, #32
ffff0260:	e8bd8070 	pop	{r4, r5, r6, pc}

ffff0264:	e92d41f0 	push	{r4, r5, r6, r7, r8, lr}
ffff0268:	e1a06000 	mov	r6, r0
ffff026c:	e1a04001 	mov	r4, r1
ffff0270:	e1a07002 	mov	r7, r2
ffff0274:	e1a05003 	mov	r5, r3
ffff0278:	e3a08000 	mov	r8, #0
ffff027c:	e3560000 	cmp	r6, #0
ffff0280:	1a000001 	bne	0xffff028c

ffff0284:	e5948034 	ldr	r8, [r4, #52]	; 0x34
ffff0288:	ea000000 	b	0xffff0290

ffff028c:	e5948030 	ldr	r8, [r4, #48]	; 0x30

ffff0290:	e1a00008 	mov	r0, r8
ffff0294:	ebffffb9 	bl	0xffff0180
ffff0298:	e3a00002 	mov	r0, #2
ffff029c:	e5c70020 	strb	r0, [r7, #32]
ffff02a0:	e1a00004 	mov	r0, r4
ffff02a4:	eb000301 	bl	0xffff0eb0
ffff02a8:	e1a00008 	mov	r0, r8
ffff02ac:	e8950006 	ldm	r5, {r1, r2}
ffff02b0:	ebffffc3 	bl	0xffff01c4
ffff02b4:	e3a02000 	mov	r2, #0
ffff02b8:	e1a01008 	mov	r1, r8
ffff02bc:	e1a00004 	mov	r0, r4
ffff02c0:	eb00037c 	bl	0xffff10b8
ffff02c4:	e1a00008 	mov	r0, r8
ffff02c8:	ebffffac 	bl	0xffff0180
ffff02cc:	e8bd81f0 	pop	{r4, r5, r6, r7, r8, pc}

ffff02d0:	e92d41f0 	push	{r4, r5, r6, r7, r8, lr}
ffff02d4:	e1a05000 	mov	r5, r0
ffff02d8:	e1a04001 	mov	r4, r1
ffff02dc:	e1a06002 	mov	r6, r2
ffff02e0:	e5d47010 	ldrb	r7, [r4, #16]
ffff02e4:	e3570011 	cmp	r7, #17
ffff02e8:	0a000002 	beq	0xffff02f8

ffff02ec:	e3570012 	cmp	r7, #18
ffff02f0:	1a00000e 	bne	0xffff0330

ffff02f4:	ea000006 	b	0xffff0314

ffff02f8:	e320f000 	nop	{0}
ffff02fc:	e1a03006 	mov	r3, r6
ffff0300:	e1a02004 	mov	r2, r4
ffff0304:	e1a01005 	mov	r1, r5
ffff0308:	e3a00001 	mov	r0, #1
ffff030c:	ebffffd4 	bl	0xffff0264
ffff0310:	ea000008 	b	0xffff0338

ffff0314:	e320f000 	nop	{0}
ffff0318:	e1a03006 	mov	r3, r6
ffff031c:	e1a02004 	mov	r2, r4
ffff0320:	e1a01005 	mov	r1, r5
ffff0324:	e3a00000 	mov	r0, #0
ffff0328:	ebffffcd 	bl	0xffff0264
ffff032c:	ea000001 	b	0xffff0338

ffff0330:	e320f000 	nop	{0}
ffff0334:	e320f000 	nop	{0}

ffff0338:	e320f000 	nop	{0}
ffff033c:	e8bd81f0 	pop	{r4, r5, r6, r7, r8, pc}

ffff0340:	e92d41ff 	push	{r0, r1, r2, r3, r4, r5, r6, r7, r8, lr}
ffff0344:	e1a05000 	mov	r5, r0
ffff0348:	e1a04001 	mov	r4, r1
ffff034c:	e1a07002 	mov	r7, r2
ffff0350:	e3a06000 	mov	r6, #0
ffff0354:	e5956030 	ldr	r6, [r5, #48]	; 0x30
ffff0358:	e3a00003 	mov	r0, #3
ffff035c:	e5c40020 	strb	r0, [r4, #32]
ffff0360:	e59f02f0 	ldr	r0, [pc, #752]	; 0xffff0658 ="AWUS"
ffff0364:	e58d0000 	str	r0, [sp]
ffff0368:	e5940004 	ldr	r0, [r4, #4]
ffff036c:	e58d0004 	str	r0, [sp, #4]
ffff0370:	e3a00000 	mov	r0, #0
ffff0374:	e58d0008 	str	r0, [sp, #8]
ffff0378:	e5cd000c 	strb	r0, [sp, #12]
ffff037c:	e1a00005 	mov	r0, r5
ffff0380:	eb0002ca 	bl	0xffff0eb0
ffff0384:	e3a0200d 	mov	r2, #13
ffff0388:	e1a0100d 	mov	r1, sp
ffff038c:	e1a00006 	mov	r0, r6
ffff0390:	ebffff8b 	bl	0xffff01c4
ffff0394:	e3a02000 	mov	r2, #0
ffff0398:	e1a01006 	mov	r1, r6
ffff039c:	e1a00005 	mov	r0, r5
ffff03a0:	eb000344 	bl	0xffff10b8
ffff03a4:	e1a00006 	mov	r0, r6
ffff03a8:	ebffff74 	bl	0xffff0180
ffff03ac:	e8bd81ff 	pop	{r0, r1, r2, r3, r4, r5, r6, r7, r8, pc}

ffff03b0:	e92d4030 	push	{r4, r5, lr}
ffff03b4:	e24dd024 	sub	sp, sp, #36	; 0x24
ffff03b8:	e1a05000 	mov	r5, r0
ffff03bc:	e1a04001 	mov	r4, r1
ffff03c0:	e1a0000d 	mov	r0, sp
ffff03c4:	ebffff74 	bl	0xffff019c
ffff03c8:	e1a0100d 	mov	r1, sp
ffff03cc:	e1a00005 	mov	r0, r5
ffff03d0:	ebffff83 	bl	0xffff01e4
ffff03d4:	e1a02004 	mov	r2, r4
ffff03d8:	e1a0100d 	mov	r1, sp
ffff03dc:	e1a00005 	mov	r0, r5
ffff03e0:	ebffffba 	bl	0xffff02d0
ffff03e4:	e1a02004 	mov	r2, r4
ffff03e8:	e1a0100d 	mov	r1, sp
ffff03ec:	e1a00005 	mov	r0, r5
ffff03f0:	ebffffd2 	bl	0xffff0340
ffff03f4:	e3a00000 	mov	r0, #0
ffff03f8:	e5c40008 	strb	r0, [r4, #8]
ffff03fc:	e28dd024 	add	sp, sp, #36	; 0x24
ffff0400:	e8bd8030 	pop	{r4, r5, pc}

ffff0404:	e92d4070 	push	{r4, r5, r6, lr}
ffff0408:	e1a04000 	mov	r4, r0
ffff040c:	e1a05001 	mov	r5, r1
ffff0410:	e1a01005 	mov	r1, r5
ffff0414:	e1a00004 	mov	r0, r4
ffff0418:	ebffffe4 	bl	0xffff03b0
ffff041c:	e8bd8070 	pop	{r4, r5, r6, pc}

ffff0420:	e92d4070 	push	{r4, r5, r6, lr}
ffff0424:	e1a04000 	mov	r4, r0
ffff0428:	e1a05001 	mov	r5, r1
ffff042c:	e3a0200c 	mov	r2, #12
ffff0430:	e3a01000 	mov	r1, #0
ffff0434:	e59f0220 	ldr	r0, [pc, #544]	; 0xffff065c = 0x00007d04
ffff0438:	eb000127 	bl	0xffff08dc
ffff043c:	e59f0218 	ldr	r0, [pc, #536]	; 0xffff065c =0x00007d04
ffff0440:	e5804000 	str	r4, [r0]
ffff0444:	e5805004 	str	r5, [r0, #4]
ffff0448:	e3a00002 	mov	r0, #2
ffff044c:	e59f1208 	ldr	r1, [pc, #520]	; 0xffff065c =0x00007d04
ffff0450:	e5c10008 	strb	r0, [r1, #8]
ffff0454:	e2810000 	add	r0, r1, #0
ffff0458:	e8bd8070 	pop	{r4, r5, r6, pc}

ffff045c:	e92d4030 	push	{r4, r5, lr}
ffff0460:	e24dd024 	sub	sp, sp, #36	; 0x24
ffff0464:	e1a04000 	mov	r4, r0
ffff0468:	e3a05000 	mov	r5, #0
ffff046c:	e3a02020 	mov	r2, #32
ffff0470:	e3a01000 	mov	r1, #0
ffff0474:	e28d0004 	add	r0, sp, #4
ffff0478:	eb000117 	bl	0xffff08dc
ffff047c:	e3a02008 	mov	r2, #8
ffff0480:	e28f1f76 	add	r1, pc, #472	; 0x1d8
ffff0484:	e28d0004 	add	r0, sp, #4
ffff0488:	eb000109 	bl	0xffff08b4
ffff048c:	e59f01d8 	ldr	r0, [pc, #472]	; 0xffff066c =0x00168100
ffff0490:	e58d000c 	str	r0, [sp, #12]
ffff0494:	e3a00001 	mov	r0, #1
ffff0498:	e58d0010 	str	r0, [sp, #16]
ffff049c:	e1cd01b4 	strh	r0, [sp, #20]
ffff04a0:	e3a00044 	mov	r0, #68	; 0x44
ffff04a4:	e5cd0016 	strb	r0, [sp, #22]
ffff04a8:	e3a00008 	mov	r0, #8
ffff04ac:	e5cd0017 	strb	r0, [sp, #23]
ffff04b0:	e3070e00 	movw	r0, #32256	; 0x7e00
ffff04b4:	e58d0018 	str	r0, [sp, #24]
ffff04b8:	e3a01020 	mov	r1, #32
ffff04bc:	e28d0004 	add	r0, sp, #4
ffff04c0:	ebffffd6 	bl	0xffff0420
ffff04c4:	e1a05000 	mov	r5, r0
ffff04c8:	e1a01005 	mov	r1, r5
ffff04cc:	e1a00004 	mov	r0, r4
ffff04d0:	ebffffb6 	bl	0xffff03b0
ffff04d4:	e28dd024 	add	sp, sp, #36	; 0x24
ffff04d8:	e8bd8030 	pop	{r4, r5, pc}

ffff04dc:	e92d407f 	push	{r0, r1, r2, r3, r4, r5, r6, lr}
ffff04e0:	e1a04000 	mov	r4, r0
ffff04e4:	e3a05000 	mov	r5, #0
ffff04e8:	e3a02010 	mov	r2, #16
ffff04ec:	e3a01000 	mov	r1, #0
ffff04f0:	e1a0000d 	mov	r0, sp
ffff04f4:	eb0000f8 	bl	0xffff08dc
ffff04f8:	e3a00001 	mov	r0, #1
ffff04fc:	e1cd00b0 	strh	r0, [sp]
ffff0500:	e3a00000 	mov	r0, #0
ffff0504:	e1cd00b2 	strh	r0, [sp, #2]
ffff0508:	e3a01010 	mov	r1, #16
ffff050c:	e1a0000d 	mov	r0, sp
ffff0510:	ebffffc2 	bl	0xffff0420
ffff0514:	e1a05000 	mov	r5, r0
ffff0518:	e1a01005 	mov	r1, r5
ffff051c:	e1a00004 	mov	r0, r4
ffff0520:	ebffffa2 	bl	0xffff03b0
ffff0524:	e8bd807f 	pop	{r0, r1, r2, r3, r4, r5, r6, pc}

ffff0528:	e92d407f 	push	{r0, r1, r2, r3, r4, r5, r6, lr}
ffff052c:	e1a04000 	mov	r4, r0
ffff0530:	e3a05000 	mov	r5, #0
ffff0534:	e3a02010 	mov	r2, #16
ffff0538:	e3a01000 	mov	r1, #0
ffff053c:	e1a0000d 	mov	r0, sp
ffff0540:	eb0000e5 	bl	0xffff08dc
ffff0544:	e30001f4 	movw	r0, #500	; 0x1f4
ffff0548:	e1cd00b2 	strh	r0, [sp, #2]
ffff054c:	e3a00002 	mov	r0, #2
ffff0550:	e1cd00b0 	strh	r0, [sp]
ffff0554:	e3a01010 	mov	r1, #16
ffff0558:	e1a0000d 	mov	r0, sp
ffff055c:	ebffffaf 	bl	0xffff0420
ffff0560:	e1a05000 	mov	r5, r0
ffff0564:	e1a01005 	mov	r1, r5
ffff0568:	e1a00004 	mov	r0, r4
ffff056c:	ebffff8f 	bl	0xffff03b0
ffff0570:	e8bd807f 	pop	{r0, r1, r2, r3, r4, r5, r6, pc}

ffff0574:	e92d41f0 	push	{r4, r5, r6, r7, r8, lr}
ffff0578:	e1a06000 	mov	r6, r0
ffff057c:	e1a04001 	mov	r4, r1
ffff0580:	e3a05000 	mov	r5, #0
ffff0584:	e3a07000 	mov	r7, #0
ffff0588:	e3540000 	cmp	r4, #0
ffff058c:	1a000001 	bne	0xffff0598

ffff0590:	e3a00001 	mov	r0, #1

ffff0594:	e8bd81f0 	pop	{r4, r5, r6, r7, r8, pc}

ffff0598:	e1a05004 	mov	r5, r4
ffff059c:	e5950008 	ldr	r0, [r5, #8]
ffff05a0:	e3500000 	cmp	r0, #0
ffff05a4:	1a000001 	bne	0xffff05b0

ffff05a8:	e3a00001 	mov	r0, #1
ffff05ac:	eafffff8 	b	0xffff0594

ffff05b0:	e5951008 	ldr	r1, [r5, #8]
ffff05b4:	e5950004 	ldr	r0, [r5, #4]
ffff05b8:	ebffff98 	bl	0xffff0420
ffff05bc:	e1a07000 	mov	r7, r0
ffff05c0:	e1a01007 	mov	r1, r7
ffff05c4:	e1a00006 	mov	r0, r6
ffff05c8:	ebffff78 	bl	0xffff03b0
ffff05cc:	e3a00000 	mov	r0, #0
ffff05d0:	eaffffef 	b	0xffff0594

ffff05d4:	e92d41f0 	push	{r4, r5, r6, r7, r8, lr}
ffff05d8:	e1a06000 	mov	r6, r0
ffff05dc:	e1a04001 	mov	r4, r1
ffff05e0:	e3a05000 	mov	r5, #0
ffff05e4:	e3a07000 	mov	r7, #0
ffff05e8:	e3540000 	cmp	r4, #0
ffff05ec:	1a000001 	bne	0xffff05f8

ffff05f0:	e3a00001 	mov	r0, #1

ffff05f4:	e8bd81f0 	pop	{r4, r5, r6, r7, r8, pc}

ffff05f8:	e1a05004 	mov	r5, r4
ffff05fc:	e5950008 	ldr	r0, [r5, #8]
ffff0600:	e3500000 	cmp	r0, #0
ffff0604:	1a000001 	bne	0xffff0610

ffff0608:	e3a00001 	mov	r0, #1
ffff060c:	eafffff8 	b	0xffff05f4

ffff0610:	e5951008 	ldr	r1, [r5, #8]
ffff0614:	e5950004 	ldr	r0, [r5, #4]
ffff0618:	ebffff80 	bl	0xffff0420
ffff061c:	e1a07000 	mov	r7, r0
ffff0620:	e1a01007 	mov	r1, r7
ffff0624:	e1a00006 	mov	r0, r6
ffff0628:	ebffff60 	bl	0xffff03b0
ffff062c:	e3a00000 	mov	r0, #0
ffff0630:	eaffffef 	b	0xffff05f4

ffff0634:	e1a03000 	mov	r3, r0
ffff0638:	e3a02000 	mov	r2, #0
ffff063c:	e3510000 	cmp	r1, #0
ffff0640:	1a000001 	bne	0xffff064c

ffff0644:	e3e00000 	mvn	r0, #0

ffff0648:	e12fff1e 	bx	lr

ffff064c:	e1a02001 	mov	r2, r1
ffff0650:	e5920004 	ldr	r0, [r2, #4]
ffff0654:	eafffffb 	b	0xffff0648

	;; Global Offset Table
ffff0658:	53555741	.ascii	"AWUS"
ffff065c:	00007d04
ffff0660:	53555741	.ascii	"AWUS"
ffff0664:	58454642	.ascii	"BFEX"
ffff0668:	00000000
ffff066c:	00168100

ffff0670:	e92d41fc 	push	{r2, r3, r4, r5, r6, r7, r8, lr}
ffff0674:	e1a06000 	mov	r6, r0
ffff0678:	e1a04001 	mov	r4, r1
ffff067c:	e1a05002 	mov	r5, r2
ffff0680:	e3a07000 	mov	r7, #0
ffff0684:	e3a02008 	mov	r2, #8
ffff0688:	e3a01000 	mov	r1, #0
ffff068c:	e1a0000d 	mov	r0, sp
ffff0690:	eb000091 	bl	0xffff08dc
ffff0694:	e30f0fff 	movw	r0, #65535	; 0xffff
ffff0698:	e1cd00b0 	strh	r0, [sp]
ffff069c:	e1cd40b2 	strh	r4, [sp, #2]
ffff06a0:	e5cd5004 	strb	r5, [sp, #4]
ffff06a4:	e3a01008 	mov	r1, #8
ffff06a8:	e1a0000d 	mov	r0, sp
ffff06ac:	ebffff5b 	bl	0xffff0420
ffff06b0:	e1a07000 	mov	r7, r0
ffff06b4:	e1a01007 	mov	r1, r7
ffff06b8:	e1a00006 	mov	r0, r6
ffff06bc:	ebffff3b 	bl	0xffff03b0
ffff06c0:	e8bd81fc 	pop	{r2, r3, r4, r5, r6, r7, r8, pc}

ffff06c4:	e92d41f0 	push	{r4, r5, r6, r7, r8, lr}
ffff06c8:	e1a06000 	mov	r6, r0
ffff06cc:	e1a04001 	mov	r4, r1
ffff06d0:	e1a05002 	mov	r5, r2
ffff06d4:	e3a07000 	mov	r7, #0
ffff06d8:	e1a02005 	mov	r2, r5
ffff06dc:	e3a01000 	mov	r1, #0
ffff06e0:	e1a00004 	mov	r0, r4
ffff06e4:	eb00007c 	bl	0xffff08dc
ffff06e8:	e1a01005 	mov	r1, r5
ffff06ec:	e1a00004 	mov	r0, r4
ffff06f0:	ebffff4a 	bl	0xffff0420
ffff06f4:	e1a07000 	mov	r7, r0
ffff06f8:	e1a01007 	mov	r1, r7
ffff06fc:	e1a00006 	mov	r0, r6
ffff0700:	ebffff3f 	bl	0xffff0404
ffff0704:	e8bd81f0 	pop	{r4, r5, r6, r7, r8, pc}

ffff0708:	e92d47ff 	push	{r0, r1, r2, r3, r4, r5, r6, r7, r8, r9, sl, lr}
ffff070c:	e1a06000 	mov	r6, r0
ffff0710:	e3a04000 	mov	r4, #0
ffff0714:	e3a07000 	mov	r7, #0
ffff0718:	e3a08000 	mov	r8, #0
ffff071c:	e3a0a001 	mov	sl, #1
ffff0720:	e3a02010 	mov	r2, #16
ffff0724:	e1a0100d 	mov	r1, sp
ffff0728:	e1a00006 	mov	r0, r6
ffff072c:	ebffffe4 	bl	0xffff06c4
ffff0730:	e1a0400d 	mov	r4, sp
ffff0734:	e1d470b0 	ldrh	r7, [r4]
ffff0738:	e1d480b2 	ldrh	r8, [r4, #2]
ffff073c:	e3570010 	cmp	r7, #16
ffff0740:	0a000022 	beq	0xffff07d0

ffff0744:	ca000008 	bgt	0xffff076c

ffff0748:	e3570001 	cmp	r7, #1
ffff074c:	0a00000e 	beq	0xffff078c

ffff0750:	e3570002 	cmp	r7, #2
ffff0754:	0a000011 	beq	0xffff07a0

ffff0758:	e3570003 	cmp	r7, #3
ffff075c:	0a000011 	beq	0xffff07a8

ffff0760:	e3570004 	cmp	r7, #4
ffff0764:	1a000037 	bne	0xffff0848

ffff0768:	ea000013 	b	0xffff07bc

ffff076c:	e3e00c01 	mvn	r0, #256	; 0x100
ffff0770:	e0900007 	adds	r0, r0, r7
ffff0774:	0a000017 	beq	0xffff07d8

ffff0778:	e3500001 	cmp	r0, #1
ffff077c:	0a000021 	beq	0xffff0808

ffff0780:	e3500002 	cmp	r0, #2
ffff0784:	1a00002f 	bne	0xffff0848

ffff0788:	ea000018 	b	0xffff07f0

ffff078c:	e320f000 	nop	{0}
ffff0790:	e1a00006 	mov	r0, r6
ffff0794:	ebffff30 	bl	0xffff045c
ffff0798:	e3a0a000 	mov	sl, #0
ffff079c:	ea00002c 	b	0xffff0854

ffff07a0:	e320f000 	nop	{0}
ffff07a4:	ea00002a 	b	0xffff0854

ffff07a8:	e320f000 	nop	{0}
ffff07ac:	e1a00006 	mov	r0, r6
ffff07b0:	ebffff5c 	bl	0xffff0528
ffff07b4:	e3a0a000 	mov	sl, #0
ffff07b8:	ea000025 	b	0xffff0854

ffff07bc:	e320f000 	nop	{0}
ffff07c0:	e1a00006 	mov	r0, r6
ffff07c4:	ebffff44 	bl	0xffff04dc
ffff07c8:	e3a0a000 	mov	sl, #0
ffff07cc:	ea000020 	b	0xffff0854

ffff07d0:	e320f000 	nop	{0}
ffff07d4:	ea00001e 	b	0xffff0854

ffff07d8:	e320f000 	nop	{0}
ffff07dc:	e1a0100d 	mov	r1, sp
ffff07e0:	e1a00006 	mov	r0, r6
ffff07e4:	ebffff62 	bl	0xffff0574
ffff07e8:	e1a0a000 	mov	sl, r0
ffff07ec:	ea000018 	b	0xffff0854
ffff07f0:	e320f000 	nop	{0}
ffff07f4:	e1a0100d 	mov	r1, sp
ffff07f8:	e1a00006 	mov	r0, r6
ffff07fc:	ebffff74 	bl	0xffff05d4
ffff0800:	e1a0a000 	mov	sl, r0
ffff0804:	ea000012 	b	0xffff0854

ffff0808:	e320f000 	nop	{0}
ffff080c:	e3a05000 	mov	r5, #0
ffff0810:	e1a0100d 	mov	r1, sp
ffff0814:	e1a00006 	mov	r0, r6
ffff0818:	ebffff85 	bl	0xffff0634
ffff081c:	e1a05000 	mov	r5, r0
ffff0820:	e3a0a000 	mov	sl, #0
ffff0824:	e1a0200a 	mov	r2, sl
ffff0828:	e1a01008 	mov	r1, r8
ffff082c:	e1a00006 	mov	r0, r6
ffff0830:	ebffff8e 	bl	0xffff0670
ffff0834:	e1a00006 	mov	r0, r6
ffff0838:	eb00073b 	bl	0xffff252c
ffff083c:	e1a09005 	mov	r9, r5
ffff0840:	e12fff39 	blx	r9
ffff0844:	e8bd87ff 	pop	{r0, r1, r2, r3, r4, r5, r6, r7, r8, r9, sl, pc}

ffff0848:	e320f000 	nop	{0}
ffff084c:	e3a0a001 	mov	sl, #1
ffff0850:	e320f000 	nop	{0}
ffff0854:	e320f000 	nop	{0}
ffff0858:	e1a0200a 	mov	r2, sl
ffff085c:	e1a01008 	mov	r1, r8
ffff0860:	e1a00006 	mov	r0, r6
ffff0864:	ebffff81 	bl	0xffff0670
ffff0868:	e320f000 	nop	{0}
ffff086c:	eafffff4 	b	0xffff0844
ffff0870:	e1a05000 	mov	r5, r0
ffff0874:	e3a04000 	mov	r4, #0
ffff0878:	ea000003 	b	0xffff088c
ffff087c:	ebfffe3d 	bl	0xffff0178
ffff0880:	e1a00005 	mov	r0, r5
ffff0884:	ebffff9f 	bl	0xffff0708
ffff0888:	e2844001 	add	r4, r4, #1
ffff088c:	eafffffa 	b	0xffff087c
ffff0890:	e3a01000 	mov	r1, #0
ffff0894:	e5c01018 	strb	r1, [r0, #24]
ffff0898:	e12fff1e 	bx	lr
ffff089c:	e3a01000 	mov	r1, #0
ffff08a0:	e5c01018 	strb	r1, [r0, #24]
ffff08a4:	e12fff1e 	bx	lr
ffff08a8:	e3a01000 	mov	r1, #0
ffff08ac:	e5c01018 	strb	r1, [r0, #24]
ffff08b0:	e12fff1e 	bx	lr

ffff08b4:	e92d4030 	push	{r4, r5, lr}
ffff08b8:	e1a03000 	mov	r3, r0
ffff08bc:	e1a0c001 	mov	ip, r1
ffff08c0:	ea000001 	b	0xffff08cc

ffff08c4:	e4dc4001 	ldrb	r4, [ip], #1
ffff08c8:	e4c34001 	strb	r4, [r3], #1

ffff08cc:	e1b04002 	movs	r4, r2
ffff08d0:	e2422001 	sub	r2, r2, #1
ffff08d4:	1afffffa 	bne	0xffff08c4

ffff08d8:	e8bd8030 	pop	{r4, r5, pc}

ffff08dc:	e92d4030 	push	{r4, r5, lr}
ffff08e0:	e1a03000 	mov	r3, r0
ffff08e4:	ea000000 	b	0xffff08ec

ffff08e8:	e4c31001 	strb	r1, [r3], #1
ffff08ec:	e1b04002 	movs	r4, r2
ffff08f0:	e2422001 	sub	r2, r2, #1
ffff08f4:	1afffffb 	bne	0xffff08e8

ffff08f8:	e8bd8030 	pop	{r4, r5, pc}

ffff08fc:	e92d4070 	push	{r4, r5, r6, lr}
ffff0900:	e3a05001 	mov	r5, #1
ffff0904:	e1a05215 	lsl	r5, r5, r2
ffff0908:	e245c001 	sub	ip, r5, #1
ffff090c:	e5905000 	ldr	r5, [r0]
ffff0910:	e1c5411c 	bic	r4, r5, ip, lsl r1
ffff0914:	e1844113 	orr	r4, r4, r3, lsl r1
ffff0918:	e5804000 	str	r4, [r0]
ffff091c:	e8bd8070 	pop	{r4, r5, r6, pc}

ffff0920:	e12fff1e 	bx	lr

ffff0924:	e92d4070 	push	{r4, r5, r6, lr}
ffff0928:	e1a06000 	mov	r6, r0
ffff092c:	e1a04001 	mov	r4, r1
ffff0930:	e1a05002 	mov	r5, r2
ffff0934:	e6af0075 	sxtb	r0, r5
ffff0938:	e5c40018 	strb	r0, [r4, #24]
ffff093c:	e594100c 	ldr	r1, [r4, #12]
ffff0940:	e1a00004 	mov	r0, r4
ffff0944:	e12fff31 	blx	r1
ffff0948:	e8bd8070 	pop	{r4, r5, r6, pc}

ffff094c:	e1a03000 	mov	r3, r0
ffff0950:	e5d30005 	ldrb	r0, [r3, #5]
ffff0954:	e200007f 	and	r0, r0, #127	; 0x7f
ffff0958:	e3500004 	cmp	r0, #4
ffff095c:	da000001 	ble	0xffff0968

ffff0960:	e3e00000 	mvn	r0, #0
ffff0964:	e12fff1e 	bx	lr

ffff0968:	e5d30005 	ldrb	r0, [r3, #5]
ffff096c:	e200007f 	and	r0, r0, #127	; 0x7f
ffff0970:	e3500005 	cmp	r0, #5
ffff0974:	308ff100 	addcc	pc, pc, r0, lsl #2
ffff0978:	ea000004 	b	0xffff0990
ffff097c:	ea000005 	b	0xffff0998
ffff0980:	ea000009 	b	0xffff09ac
ffff0984:	ea00000e 	b	0xffff09c4
ffff0988:	ea000013 	b	0xffff09dc
ffff098c:	ea000018 	b	0xffff09f4

ffff0990:	e320f000 	nop	{0}
ffff0994:	e320f000 	nop	{0}

ffff0998:	e3a00000 	mov	r0, #0
ffff099c:	e5810000 	str	r0, [r1]
ffff09a0:	e59f0f24 	ldr	r0, [pc, #3876]	; 0xffff18cc =0x01c19000 USB_OTG_BASE
ffff09a4:	e5820000 	str	r0, [r2]
ffff09a8:	ea000017 	b	0xffff0a0c

ffff09ac:	e320f000 	nop	{0}
ffff09b0:	e3a00001 	mov	r0, #1
ffff09b4:	e5810000 	str	r0, [r1]
ffff09b8:	e59f0f10 	ldr	r0, [pc, #3856]	; 0xffff18d0 =01c19004 E_HCSPARAMS
ffff09bc:	e5820000 	str	r0, [r2]
ffff09c0:	ea000011 	b	0xffff0a0c

ffff09c4:	e320f000 	nop	{0}
ffff09c8:	e3a00002 	mov	r0, #2
ffff09cc:	e5810000 	str	r0, [r1]
ffff09d0:	e59f0efc 	ldr	r0, [pc, #3836]	; 0xffff18d4 =01c19008 E_HCCPARAMS
ffff09d4:	e5820000 	str	r0, [r2]
ffff09d8:	ea00000b 	b	0xffff0a0c

ffff09dc:	e320f000 	nop	{0}
ffff09e0:	e3a00003 	mov	r0, #3
ffff09e4:	e5810000 	str	r0, [r1]
ffff09e8:	e59f0ee8 	ldr	r0, [pc, #3816]	; 0xffff18d8 =01c1900c E_HCSPORTROUTE
ffff09ec:	e5820000 	str	r0, [r2]
ffff09f0:	ea000005 	b	0xffff0a0c

ffff09f4:	e320f000 	nop	{0}
ffff09f8:	e3a00004 	mov	r0, #4
ffff09fc:	e5810000 	str	r0, [r1]
ffff0a00:	e59f0ed4 	ldr	r0, [pc, #3796]	; 0xffff18dc =01c19010 E_USBCMD
ffff0a04:	e5820000 	str	r0, [r2]
ffff0a08:	e320f000 	nop	{0}

ffff0a0c:	e320f000 	nop	{0}
ffff0a10:	e3a00000 	mov	r0, #0
ffff0a14:	eaffffd2 	b	0xffff0964

ffff0a18:	e92d4ffe 	push	{r1, r2, r3, r4, r5, r6, r7, r8, r9, sl, fp, lr}
ffff0a1c:	e1a09000 	mov	r9, r0
ffff0a20:	e1a06001 	mov	r6, r1
ffff0a24:	e1a04002 	mov	r4, r2
ffff0a28:	e3a00001 	mov	r0, #1
ffff0a2c:	e58d0008 	str	r0, [sp, #8]
ffff0a30:	e3a08000 	mov	r8, #0
ffff0a34:	e1a0200d 	mov	r2, sp
ffff0a38:	e28d1004 	add	r1, sp, #4
ffff0a3c:	e1a00006 	mov	r0, r6
ffff0a40:	ebffffc1 	bl	0xffff094c
ffff0a44:	e3500000 	cmp	r0, #0
ffff0a48:	0a000001 	beq	0xffff0a54
ffff0a4c:	e3e00000 	mvn	r0, #0
ffff0a50:	e8bd8ffe 	pop	{r1, r2, r3, r4, r5, r6, r7, r8, r9, sl, fp, pc}

ffff0a54:	e5940000 	ldr	r0, [r4]
ffff0a58:	e5941010 	ldr	r1, [r4, #16]
ffff0a5c:	e080b001 	add	fp, r0, r1
ffff0a60:	e5940004 	ldr	r0, [r4, #4]
ffff0a64:	e5941010 	ldr	r1, [r4, #16]
ffff0a68:	e040a001 	sub	sl, r0, r1
ffff0a6c:	e35a0000 	cmp	sl, #0
ffff0a70:	1a000001 	bne	0xffff0a7c

ffff0a74:	e3e00000 	mvn	r0, #0
ffff0a78:	eafffff4 	b	0xffff0a50

ffff0a7c:	e59d0004 	ldr	r0, [sp, #4]
ffff0a80:	e59f1e44 	ldr	r1, [pc, #3652]	; 0xffff18cc =0x01c19000 USB_OTG_BASE
ffff0a84:	e5c10042 	strb	r0, [r1, #66]	; 0x42
ffff0a88:	e1a00001 	mov	r0, r1
ffff0a8c:	e5908088 	ldr	r8, [r0, #136]	; 0x88
ffff0a90:	e5960008 	ldr	r0, [r6, #8]
ffff0a94:	e1500008 	cmp	r0, r8
ffff0a98:	2a000001 	bcs	0xffff0aa4
ffff0a9c:	e5967008 	ldr	r7, [r6, #8]
ffff0aa0:	ea000000 	b	0xffff0aa8
ffff0aa4:	e1a07008 	mov	r7, r8
ffff0aa8:	e1a03007 	mov	r3, r7
ffff0aac:	e1a02004 	mov	r2, r4
ffff0ab0:	e1a0100b 	mov	r1, fp
ffff0ab4:	e59d0000 	ldr	r0, [sp]
ffff0ab8:	eb0006b0 	bl	0xffff2580
ffff0abc:	e1a08000 	mov	r8, r0
ffff0ac0:	e5960008 	ldr	r0, [r6, #8]
ffff0ac4:	e1500008 	cmp	r0, r8
ffff0ac8:	9a000006 	bls	0xffff0ae8
ffff0acc:	e3a00001 	mov	r0, #1
ffff0ad0:	e58d0008 	str	r0, [sp, #8]
ffff0ad4:	e1580007 	cmp	r8, r7
ffff0ad8:	0a00000b 	beq	0xffff0b0c
ffff0adc:	e3a000ff 	mov	r0, #255	; 0xff
ffff0ae0:	e5c40018 	strb	r0, [r4, #24]
ffff0ae4:	ea000008 	b	0xffff0b0c
ffff0ae8:	e5940004 	ldr	r0, [r4, #4]
ffff0aec:	e5941010 	ldr	r1, [r4, #16]
ffff0af0:	e1500001 	cmp	r0, r1
ffff0af4:	1a000002 	bne	0xffff0b04

ffff0af8:	e3a00001 	mov	r0, #1
ffff0afc:	e58d0008 	str	r0, [sp, #8]
ffff0b00:	ea000001 	b	0xffff0b0c
ffff0b04:	e3a00000 	mov	r0, #0
ffff0b08:	e58d0008 	str	r0, [sp, #8]
ffff0b0c:	e59d0004 	ldr	r0, [sp, #4]
ffff0b10:	e59f1db4 	ldr	r1, [pc, #3508]	; 0xffff18cc =0x01c19000 USB_OTG_BASE
ffff0b14:	e5c10042 	strb	r0, [r1, #66]	; 0x42
ffff0b18:	e1a00001 	mov	r0, r1
ffff0b1c:	e5908088 	ldr	r8, [r0, #136]	; 0x88
ffff0b20:	e59d0008 	ldr	r0, [sp, #8]
ffff0b24:	e3500000 	cmp	r0, #0
ffff0b28:	0a000018 	beq	0xffff0b90
ffff0b2c:	e59d0004 	ldr	r0, [sp, #4]
ffff0b30:	e3500000 	cmp	r0, #0
ffff0b34:	1a000007 	bne	0xffff0b58

ffff0b38:	e59d0004 	ldr	r0, [sp, #4]
ffff0b3c:	e5c10042 	strb	r0, [r1, #66]	; 0x42
ffff0b40:	e3a00048 	mov	r0, #72	; 0x48
ffff0b44:	e1c108b2 	strh	r0, [r1, #130]	; 0x82
ffff0b48:	e3a00000 	mov	r0, #0
ffff0b4c:	e5991024 	ldr	r1, [r9, #36]	; 0x24
ffff0b50:	e5810030 	str	r0, [r1, #48]	; 0x30
ffff0b54:	ea000006 	b	0xffff0b74
ffff0b58:	e59d0004 	ldr	r0, [sp, #4]
ffff0b5c:	e59f1d68 	ldr	r1, [pc, #3432]	; 0xffff18cc =0x01c19000 USB_OTG_BASE
ffff0b60:	e5c10042 	strb	r0, [r1, #66]	; 0x42
ffff0b64:	e1a00001 	mov	r0, r1
ffff0b68:	e1d058b6 	ldrh	r5, [r0, #134]	; 0x86
ffff0b6c:	e3c55001 	bic	r5, r5, #1
ffff0b70:	e1c058b6 	strh	r5, [r0, #134]	; 0x86
ffff0b74:	e3a02000 	mov	r2, #0
ffff0b78:	e1a01004 	mov	r1, r4
ffff0b7c:	e1a00006 	mov	r0, r6
ffff0b80:	ebffff67 	bl	0xffff0924
ffff0b84:	e3a00001 	mov	r0, #1
ffff0b88:	e58d0008 	str	r0, [sp, #8]
ffff0b8c:	ea00000f 	b	0xffff0bd0
ffff0b90:	e59d0004 	ldr	r0, [sp, #4]
ffff0b94:	e3500000 	cmp	r0, #0
ffff0b98:	1a000005 	bne	0xffff0bb4

ffff0b9c:	e59d0004 	ldr	r0, [sp, #4]
ffff0ba0:	e59f1d24 	ldr	r1, [pc, #3364]	; 0xffff18cc =0x01c19000 USB_OTG_BASE
ffff0ba4:	e5c10042 	strb	r0, [r1, #66]	; 0x42
ffff0ba8:	e3a00040 	mov	r0, #64	; 0x40
ffff0bac:	e1c108b2 	strh	r0, [r1, #130]	; 0x82
ffff0bb0:	ea000006 	b	0xffff0bd0
ffff0bb4:	e59d0004 	ldr	r0, [sp, #4]
ffff0bb8:	e59f1d0c 	ldr	r1, [pc, #3340]	; 0xffff18cc =0x01c19000 USB_OTG_BASE
ffff0bbc:	e5c10042 	strb	r0, [r1, #66]	; 0x42
ffff0bc0:	e1a00001 	mov	r0, r1
ffff0bc4:	e1d058b6 	ldrh	r5, [r0, #134]	; 0x86
ffff0bc8:	e3c55001 	bic	r5, r5, #1
ffff0bcc:	e1c058b6 	strh	r5, [r0, #134]	; 0x86
ffff0bd0:	e59d0008 	ldr	r0, [sp, #8]
ffff0bd4:	eaffff9d 	b	0xffff0a50

ffff0bd8:	e92d47fc 	push	{r2, r3, r4, r5, r6, r7, r8, r9, sl, lr}
ffff0bdc:	e1a07000 	mov	r7, r0
ffff0be0:	e1a06001 	mov	r6, r1
ffff0be4:	e1a05002 	mov	r5, r2
ffff0be8:	e3a09000 	mov	r9, #0
ffff0bec:	e1a0200d 	mov	r2, sp
ffff0bf0:	e28d1004 	add	r1, sp, #4
ffff0bf4:	e1a00006 	mov	r0, r6
ffff0bf8:	ebffff53 	bl	0xffff094c
ffff0bfc:	e3500000 	cmp	r0, #0
ffff0c00:	0a000001 	beq	0xffff0c0c
ffff0c04:	e3e00000 	mvn	r0, #0
ffff0c08:	e8bd87fc 	pop	{r2, r3, r4, r5, r6, r7, r8, r9, sl, pc}

ffff0c0c:	e5968008 	ldr	r8, [r6, #8]
ffff0c10:	e1a02008 	mov	r2, r8
ffff0c14:	e1a01005 	mov	r1, r5
ffff0c18:	e59d0000 	ldr	r0, [sp]
ffff0c1c:	eb000694 	bl	0xffff2674
ffff0c20:	e1a08000 	mov	r8, r0
ffff0c24:	e5960008 	ldr	r0, [r6, #8]
ffff0c28:	e1500008 	cmp	r0, r8
ffff0c2c:	0a000001 	beq	0xffff0c38
ffff0c30:	e3a04001 	mov	r4, #1
ffff0c34:	ea000009 	b	0xffff0c60
ffff0c38:	e5950004 	ldr	r0, [r5, #4]
ffff0c3c:	e5951010 	ldr	r1, [r5, #16]
ffff0c40:	e1500001 	cmp	r0, r1
ffff0c44:	1a000004 	bne	0xffff0c5c

ffff0c48:	e5d50008 	ldrb	r0, [r5, #8]
ffff0c4c:	e3500000 	cmp	r0, #0
ffff0c50:	1a000001 	bne	0xffff0c5c

ffff0c54:	e3a04002 	mov	r4, #2
ffff0c58:	ea000000 	b	0xffff0c60
ffff0c5c:	e3a04000 	mov	r4, #0
ffff0c60:	e3540000 	cmp	r4, #0
ffff0c64:	0a000027 	beq	0xffff0d08
ffff0c68:	e59d0004 	ldr	r0, [sp, #4]
ffff0c6c:	e3500000 	cmp	r0, #0
ffff0c70:	1a000017 	bne	0xffff0cd4

ffff0c74:	e1a00007 	mov	r0, r7
ffff0c78:	eb000674 	bl	0xffff2650
ffff0c7c:	e3100004 	tst	r0, #4
ffff0c80:	1a000019 	bne	0xffff0cec

ffff0c84:	e3540001 	cmp	r4, #1
ffff0c88:	1a000009 	bne	0xffff0cb4

ffff0c8c:	e59d0004 	ldr	r0, [sp, #4]
ffff0c90:	e59f1c34 	ldr	r1, [pc, #3124]	; 0xffff18cc =0x01c19000 USB_OTG_BASE
ffff0c94:	e5c10042 	strb	r0, [r1, #66]	; 0x42
ffff0c98:	e3a0000a 	mov	r0, #10
ffff0c9c:	e1c108b2 	strh	r0, [r1, #130]	; 0x82
ffff0ca0:	e3a00000 	mov	r0, #0
ffff0ca4:	e5971024 	ldr	r1, [r7, #36]	; 0x24
ffff0ca8:	e5810030 	str	r0, [r1, #48]	; 0x30
ffff0cac:	e3a09001 	mov	r9, #1
ffff0cb0:	ea00000d 	b	0xffff0cec
ffff0cb4:	e3540002 	cmp	r4, #2
ffff0cb8:	1a00000b 	bne	0xffff0cec

ffff0cbc:	e59d0004 	ldr	r0, [sp, #4]
ffff0cc0:	e59f1c04 	ldr	r1, [pc, #3076]	; 0xffff18cc =0x01c19000 USB_OTG_BASE
ffff0cc4:	e5c10042 	strb	r0, [r1, #66]	; 0x42
ffff0cc8:	e3a00002 	mov	r0, #2
ffff0ccc:	e1c108b2 	strh	r0, [r1, #130]	; 0x82
ffff0cd0:	ea000005 	b	0xffff0cec
ffff0cd4:	e59d0004 	ldr	r0, [sp, #4]
ffff0cd8:	e59f1bec 	ldr	r1, [pc, #3052]	; 0xffff18cc =0x01c19000 USB_OTG_BASE
ffff0cdc:	e5c10042 	strb	r0, [r1, #66]	; 0x42
ffff0ce0:	e3020001 	movw	r0, #8193	; 0x2001
ffff0ce4:	e1c108b2 	strh	r0, [r1, #130]	; 0x82
ffff0ce8:	e3a09001 	mov	r9, #1
ffff0cec:	e3590001 	cmp	r9, #1
ffff0cf0:	1a000016 	bne	0xffff0d50

ffff0cf4:	e3a02000 	mov	r2, #0
ffff0cf8:	e1a01005 	mov	r1, r5
ffff0cfc:	e1a00006 	mov	r0, r6
ffff0d00:	ebffff07 	bl	0xffff0924
ffff0d04:	ea000011 	b	0xffff0d50
ffff0d08:	e59d0004 	ldr	r0, [sp, #4]
ffff0d0c:	e3500000 	cmp	r0, #0
ffff0d10:	1a000009 	bne	0xffff0d3c

ffff0d14:	e1a00007 	mov	r0, r7
ffff0d18:	eb00064c 	bl	0xffff2650
ffff0d1c:	e3100004 	tst	r0, #4
ffff0d20:	1a00000a 	bne	0xffff0d50

ffff0d24:	e59d0004 	ldr	r0, [sp, #4]
ffff0d28:	e59f1b9c 	ldr	r1, [pc, #2972]	; 0xffff18cc =0x01c19000 USB_OTG_BASE
ffff0d2c:	e5c10042 	strb	r0, [r1, #66]	; 0x42
ffff0d30:	e3a00002 	mov	r0, #2
ffff0d34:	e1c108b2 	strh	r0, [r1, #130]	; 0x82
ffff0d38:	ea000004 	b	0xffff0d50
ffff0d3c:	e59d0004 	ldr	r0, [sp, #4]
ffff0d40:	e59f1b84 	ldr	r1, [pc, #2948]	; 0xffff18cc =0x01c19000 USB_OTG_BASE
ffff0d44:	e5c10042 	strb	r0, [r1, #66]	; 0x42
ffff0d48:	e3020001 	movw	r0, #8193	; 0x2001
ffff0d4c:	e1c108b2 	strh	r0, [r1, #130]	; 0x82
ffff0d50:	e1a00009 	mov	r0, r9
ffff0d54:	eaffffab 	b	0xffff0c08
ffff0d58:	e59f1b6c 	ldr	r1, [pc, #2924]	; 0xffff18cc =0x01c19000 USB_OTG_BASE
ffff0d5c:	e5c10042 	strb	r0, [r1, #66]	; 0x42
ffff0d60:	e12fff1e 	bx	lr

ffff0d64:	e92d47f0 	push	{r4, r5, r6, r7, r8, r9, sl, lr}
ffff0d68:	e1a09000 	mov	r9, r0
ffff0d6c:	e1a08001 	mov	r8, r1
ffff0d70:	e3a05000 	mov	r5, #0
ffff0d74:	e3a06000 	mov	r6, #0
ffff0d78:	e3a0a000 	mov	sl, #0
ffff0d7c:	e3580000 	cmp	r8, #0
ffff0d80:	1a000000 	bne	0xffff0d88

ffff0d84:	e8bd87f0 	pop	{r4, r5, r6, r7, r8, r9, sl, pc}
ffff0d88:	e5990024 	ldr	r0, [r9, #36]	; 0x24
ffff0d8c:	e0806208 	add	r6, r0, r8, lsl #4
ffff0d90:	e596500c 	ldr	r5, [r6, #12]
ffff0d94:	e5d60005 	ldrb	r0, [r6, #5]
ffff0d98:	e200a080 	and	sl, r0, #128	; 0x80
ffff0d9c:	e5d60005 	ldrb	r0, [r6, #5]
ffff0da0:	e200707f 	and	r7, r0, #127	; 0x7f
ffff0da4:	e5d50018 	ldrb	r0, [r5, #24]
ffff0da8:	e3500001 	cmp	r0, #1
ffff0dac:	0a000000 	beq	0xffff0db4
ffff0db0:	eafffff3 	b	0xffff0d84
ffff0db4:	e35a0000 	cmp	sl, #0
ffff0db8:	0a000013 	beq	0xffff0e0c
ffff0dbc:	e5d60004 	ldrb	r0, [r6, #4]
ffff0dc0:	ebffffe4 	bl	0xffff0d58
ffff0dc4:	e59f0b00 	ldr	r0, [pc, #2816]	; 0xffff18cc =0x01c19000 USB_OTG_BASE
ffff0dc8:	e1d048b2 	ldrh	r4, [r0, #130]	; 0x82
ffff0dcc:	e3140020 	tst	r4, #32
ffff0dd0:	0a000004 	beq	0xffff0de8
ffff0dd4:	e59f1af0 	ldr	r1, [pc, #2800]	; 0xffff18cc =0x01c19000 USB_OTG_BASE
ffff0dd8:	e1c174b2 	strh	r7, [r1, #66]	; 0x42
ffff0ddc:	e3a00000 	mov	r0, #0
ffff0de0:	e1c108b2 	strh	r0, [r1, #130]	; 0x82
ffff0de4:	eaffffe6 	b	0xffff0d84
ffff0de8:	e3140001 	tst	r4, #1
ffff0dec:	1a000025 	bne	0xffff0e88

ffff0df0:	e3550000 	cmp	r5, #0
ffff0df4:	0a000023 	beq	0xffff0e88
ffff0df8:	e1a02005 	mov	r2, r5
ffff0dfc:	e1a01006 	mov	r1, r6
ffff0e00:	e1a00009 	mov	r0, r9
ffff0e04:	ebffff73 	bl	0xffff0bd8
ffff0e08:	ea00001e 	b	0xffff0e88
ffff0e0c:	e59f1ab8 	ldr	r1, [pc, #2744]	; 0xffff18cc =0x01c19000 USB_OTG_BASE
ffff0e10:	e5c17042 	strb	r7, [r1, #66]	; 0x42
ffff0e14:	e1a00001 	mov	r0, r1
ffff0e18:	e1d048b6 	ldrh	r4, [r0, #134]	; 0x86
ffff0e1c:	e3140040 	tst	r4, #64	; 0x40
ffff0e20:	0a000003 	beq	0xffff0e34
ffff0e24:	e1c174b2 	strh	r7, [r1, #66]	; 0x42
ffff0e28:	e3a00000 	mov	r0, #0
ffff0e2c:	e1c108b6 	strh	r0, [r1, #134]	; 0x86
ffff0e30:	eaffffd3 	b	0xffff0d84
ffff0e34:	e320f000 	nop	{0}
ffff0e38:	e3140001 	tst	r4, #1
ffff0e3c:	0a000011 	beq	0xffff0e88
ffff0e40:	e3550000 	cmp	r5, #0
ffff0e44:	0a00000f 	beq	0xffff0e88
ffff0e48:	e1a02005 	mov	r2, r5
ffff0e4c:	e1a01006 	mov	r1, r6
ffff0e50:	e1a00009 	mov	r0, r9
ffff0e54:	ebfffeef 	bl	0xffff0a18
ffff0e58:	e5d50018 	ldrb	r0, [r5, #24]
ffff0e5c:	e3500000 	cmp	r0, #0
ffff0e60:	0a000008 	beq	0xffff0e88
ffff0e64:	e59f1a60 	ldr	r1, [pc, #2656]	; 0xffff18cc =0x01c19000 USB_OTG_BASE
ffff0e68:	e5c17042 	strb	r7, [r1, #66]	; 0x42
ffff0e6c:	e1a00001 	mov	r0, r1
ffff0e70:	e1d048b6 	ldrh	r4, [r0, #134]	; 0x86
ffff0e74:	e3140001 	tst	r4, #1
ffff0e78:	0a000002 	beq	0xffff0e88
ffff0e7c:	e3550000 	cmp	r5, #0
ffff0e80:	0a000000 	beq	0xffff0e88
ffff0e84:	eaffffeb 	b	0xffff0e38
ffff0e88:	e320f000 	nop	{0}
ffff0e8c:	eaffffbc 	b	0xffff0d84
ffff0e90:	e59f0a34 	ldr	r0, [pc, #2612]	; 0xffff18cc =0x01c19000 USB_OTG_BASE
ffff0e94:	e5d00042 	ldrb	r0, [r0, #66]	; 0x42
ffff0e98:	e12fff1e 	bx	lr
ffff0e9c:	e1a02000 	mov	r2, r0
ffff0ea0:	e10f1000 	mrs	r1, CPSR
ffff0ea4:	e3c11080 	bic	r1, r1, #128	; 0x80
ffff0ea8:	e121f001 	msr	CPSR_c, r1
ffff0eac:	e12fff1e 	bx	lr
ffff0eb0:	e1a02000 	mov	r2, r0
ffff0eb4:	e10f1000 	mrs	r1, CPSR
ffff0eb8:	e3811080 	orr	r1, r1, #128	; 0x80
ffff0ebc:	e121f001 	msr	CPSR_c, r1
ffff0ec0:	e12fff1e 	bx	lr

ffff0ec4:	e92d47f0 	push	{r4, r5, r6, r7, r8, r9, sl, lr}
ffff0ec8:	e1a06000 	mov	r6, r0
ffff0ecc:	e1a05001 	mov	r5, r1
ffff0ed0:	e1a07002 	mov	r7, r2
ffff0ed4:	e3a04000 	mov	r4, #0
ffff0ed8:	e3a08000 	mov	r8, #0
ffff0edc:	e3a09000 	mov	r9, #0
ffff0ee0:	e5950014 	ldr	r0, [r5, #20]
ffff0ee4:	e3d00003 	bics	r0, r0, #3
ffff0ee8:	0a000001 	beq	0xffff0ef4
ffff0eec:	e3e00000 	mvn	r0, #0
ffff0ef0:	e8bd87f0 	pop	{r4, r5, r6, r7, r8, r9, sl, pc}

ffff0ef4:	e3570000 	cmp	r7, #0
ffff0ef8:	1a000001 	bne	0xffff0f04

ffff0efc:	e1a00006 	mov	r0, r6
ffff0f00:	ebffffea 	bl	0xffff0eb0
ffff0f04:	e5960024 	ldr	r0, [r6, #36]	; 0x24
ffff0f08:	e5951014 	ldr	r1, [r5, #20]
ffff0f0c:	e0804201 	add	r4, r0, r1, lsl #4
ffff0f10:	e3a00000 	mov	r0, #0
ffff0f14:	e5850010 	str	r0, [r5, #16]
ffff0f18:	e5d40005 	ldrb	r0, [r4, #5]
ffff0f1c:	e3500000 	cmp	r0, #0
ffff0f20:	0a00000c 	beq	0xffff0f58
ffff0f24:	e5d40005 	ldrb	r0, [r4, #5]
ffff0f28:	e200007f 	and	r0, r0, #127	; 0x7f
ffff0f2c:	e59f1998 	ldr	r1, [pc, #2456]	; 0xffff18cc =0x01c19000 USB_OTG_BASE
ffff0f30:	e5c10042 	strb	r0, [r1, #66]	; 0x42
ffff0f34:	e5d40005 	ldrb	r0, [r4, #5]
ffff0f38:	e3100080 	tst	r0, #128	; 0x80
ffff0f3c:	0a000001 	beq	0xffff0f48
ffff0f40:	e2810082 	add	r0, r1, #130	; 0x82
ffff0f44:	ea000000 	b	0xffff0f4c
ffff0f48:	e59f0990 	ldr	r0, [pc, #2448]	; 0xffff18e0
ffff0f4c:	e1d080b0 	ldrh	r8, [r0]
ffff0f50:	e59f0974 	ldr	r0, [pc, #2420]	; 0xffff18cc =0x01c19000 USB_OTG_BASE
ffff0f54:	e1d098b8 	ldrh	r9, [r0, #136]	; 0x88
ffff0f58:	e5d40005 	ldrb	r0, [r4, #5]
ffff0f5c:	e3500000 	cmp	r0, #0
ffff0f60:	1a00001c 	bne	0xffff0fd8

ffff0f64:	e5960024 	ldr	r0, [r6, #36]	; 0x24
ffff0f68:	e5900030 	ldr	r0, [r0, #48]	; 0x30
ffff0f6c:	e3500001 	cmp	r0, #1
ffff0f70:	0a000002 	beq	0xffff0f80
ffff0f74:	e3500002 	cmp	r0, #2
ffff0f78:	1a00000e 	bne	0xffff0fb8

ffff0f7c:	ea000008 	b	0xffff0fa4
ffff0f80:	e320f000 	nop	{0}
ffff0f84:	e1a02005 	mov	r2, r5
ffff0f88:	e1a01004 	mov	r1, r4
ffff0f8c:	e1a00006 	mov	r0, r6
ffff0f90:	ebffff10 	bl	0xffff0bd8
ffff0f94:	e3500000 	cmp	r0, #0
ffff0f98:	0a000000 	beq	0xffff0fa0
ffff0f9c:	e3a05000 	mov	r5, #0
ffff0fa0:	ea00000b 	b	0xffff0fd4
ffff0fa4:	e320f000 	nop	{0}
ffff0fa8:	e3a00000 	mov	r0, #0
ffff0fac:	e5961024 	ldr	r1, [r6, #36]	; 0x24
ffff0fb0:	e5810030 	str	r0, [r1, #48]	; 0x30
ffff0fb4:	ea000006 	b	0xffff0fd4
ffff0fb8:	e320f000 	nop	{0}
ffff0fbc:	e3570000 	cmp	r7, #0
ffff0fc0:	1a000001 	bne	0xffff0fcc

ffff0fc4:	e1a00006 	mov	r0, r6
ffff0fc8:	ebffffb3 	bl	0xffff0e9c
ffff0fcc:	e3e00000 	mvn	r0, #0
ffff0fd0:	eaffffc6 	b	0xffff0ef0
ffff0fd4:	ea000031 	b	0xffff10a0
ffff0fd8:	e5d40005 	ldrb	r0, [r4, #5]
ffff0fdc:	e3100080 	tst	r0, #128	; 0x80
ffff0fe0:	0a000009 	beq	0xffff100c
ffff0fe4:	e3180001 	tst	r8, #1
ffff0fe8:	1a000007 	bne	0xffff100c

ffff0fec:	e1a02005 	mov	r2, r5
ffff0ff0:	e1a01004 	mov	r1, r4
ffff0ff4:	e1a00006 	mov	r0, r6
ffff0ff8:	ebfffef6 	bl	0xffff0bd8
ffff0ffc:	e3500000 	cmp	r0, #0
ffff1000:	0a000001 	beq	0xffff100c
ffff1004:	e3a05000 	mov	r5, #0
ffff1008:	ea000024 	b	0xffff10a0
ffff100c:	e5d40005 	ldrb	r0, [r4, #5]
ffff1010:	e3100080 	tst	r0, #128	; 0x80
ffff1014:	1a000021 	bne	0xffff10a0

ffff1018:	e3180001 	tst	r8, #1
ffff101c:	0a00001f 	beq	0xffff10a0
ffff1020:	e59f08a4 	ldr	r0, [pc, #2212]	; 0xffff18cc =0x01c19000 USB_OTG_BASE
ffff1024:	e1d008b8 	ldrh	r0, [r0, #136]	; 0x88
ffff1028:	e1b09000 	movs	r9, r0
ffff102c:	0a00001b 	beq	0xffff10a0
ffff1030:	e320f000 	nop	{0}
ffff1034:	e1a02005 	mov	r2, r5
ffff1038:	e1a01004 	mov	r1, r4
ffff103c:	e1a00006 	mov	r0, r6
ffff1040:	ebfffe74 	bl	0xffff0a18
ffff1044:	e5d40005 	ldrb	r0, [r4, #5]
ffff1048:	e200007f 	and	r0, r0, #127	; 0x7f
ffff104c:	e59f1878 	ldr	r1, [pc, #2168]	; 0xffff18cc =0x01c19000 USB_OTG_BASE
ffff1050:	e5c10042 	strb	r0, [r1, #66]	; 0x42
ffff1054:	e5d40005 	ldrb	r0, [r4, #5]
ffff1058:	e3100080 	tst	r0, #128	; 0x80
ffff105c:	0a000001 	beq	0xffff1068
ffff1060:	e2810082 	add	r0, r1, #130	; 0x82
ffff1064:	ea000000 	b	0xffff106c
ffff1068:	e59f0870 	ldr	r0, [pc, #2160]	; 0xffff18e0
ffff106c:	e1d080b0 	ldrh	r8, [r0]
ffff1070:	e59f0854 	ldr	r0, [pc, #2132]	; 0xffff18cc =0x01c19000 USB_OTG_BASE
ffff1074:	e1d098b8 	ldrh	r9, [r0, #136]	; 0x88
ffff1078:	e5d50018 	ldrb	r0, [r5, #24]
ffff107c:	e3500000 	cmp	r0, #0
ffff1080:	1a000000 	bne	0xffff1088

ffff1084:	ea000003 	b	0xffff1098
ffff1088:	e3180001 	tst	r8, #1
ffff108c:	0a000001 	beq	0xffff1098
ffff1090:	e3590000 	cmp	r9, #0
ffff1094:	1affffe6 	bne	0xffff1034

ffff1098:	e320f000 	nop	{0}
ffff109c:	e3a05000 	mov	r5, #0
ffff10a0:	e3570000 	cmp	r7, #0
ffff10a4:	1a000001 	bne	0xffff10b0

ffff10a8:	e1a00006 	mov	r0, r6
ffff10ac:	ebffff7a 	bl	0xffff0e9c
ffff10b0:	e3a00000 	mov	r0, #0
ffff10b4:	eaffff8d 	b	0xffff0ef0

ffff10b8:	e92d4070 	push	{r4, r5, r6, lr}
ffff10bc:	e1a04000 	mov	r4, r0
ffff10c0:	e1a05001 	mov	r5, r1
ffff10c4:	e1a06002 	mov	r6, r2
ffff10c8:	e1a02006 	mov	r2, r6
ffff10cc:	e1a01005 	mov	r1, r5
ffff10d0:	e1a00004 	mov	r0, r4
ffff10d4:	ebffff7a 	bl	0xffff0ec4
ffff10d8:	e8bd8070 	pop	{r4, r5, r6, pc}

ffff10dc:	e92d47f0 	push	{r4, r5, r6, r7, r8, r9, sl, lr}
ffff10e0:	e1a06000 	mov	r6, r0
ffff10e4:	e1a04001 	mov	r4, r1
ffff10e8:	e1a0a002 	mov	sl, r2
ffff10ec:	e1a09003 	mov	r9, r3
ffff10f0:	e1a05004 	mov	r5, r4
ffff10f4:	e3590000 	cmp	r9, #0
ffff10f8:	0a000001 	beq	0xffff1104
ffff10fc:	e3e00000 	mvn	r0, #0
ffff1100:	e8bd87f0 	pop	{r4, r5, r6, r7, r8, r9, sl, pc}

ffff1104:	e5968014 	ldr	r8, [r6, #20]
ffff1108:	e3a07000 	mov	r7, #0
ffff110c:	e3a02009 	mov	r2, #9
ffff1110:	e1a00004 	mov	r0, r4
ffff1114:	e5961004 	ldr	r1, [r6, #4]
ffff1118:	ebfffde5 	bl	0xffff08b4
ffff111c:	e2844009 	add	r4, r4, #9
ffff1120:	e3a02009 	mov	r2, #9
ffff1124:	e1a00004 	mov	r0, r4
ffff1128:	e5961008 	ldr	r1, [r6, #8]
ffff112c:	ebfffde0 	bl	0xffff08b4
ffff1130:	e2844009 	add	r4, r4, #9
ffff1134:	e3a02007 	mov	r2, #7
ffff1138:	e1a00004 	mov	r0, r4
ffff113c:	e5981000 	ldr	r1, [r8]
ffff1140:	ebfffddb 	bl	0xffff08b4
ffff1144:	e2844007 	add	r4, r4, #7
ffff1148:	e3a02007 	mov	r2, #7
ffff114c:	e1a00004 	mov	r0, r4
ffff1150:	e5981004 	ldr	r1, [r8, #4]
ffff1154:	ebfffdd6 	bl	0xffff08b4
ffff1158:	e2844007 	add	r4, r4, #7
ffff115c:	e3a07020 	mov	r7, #32
ffff1160:	e3a00009 	mov	r0, #9
ffff1164:	e5c50000 	strb	r0, [r5]
ffff1168:	e3a00002 	mov	r0, #2
ffff116c:	e5c50001 	strb	r0, [r5, #1]
ffff1170:	e1c570b2 	strh	r7, [r5, #2]
ffff1174:	e5d50007 	ldrb	r0, [r5, #7]
ffff1178:	e3800080 	orr	r0, r0, #128	; 0x80
ffff117c:	e5c50007 	strb	r0, [r5, #7]
ffff1180:	e1a00007 	mov	r0, r7
ffff1184:	eaffffdd 	b	0xffff1100

ffff1188:	e92d47f0 	push	{r4, r5, r6, r7, r8, r9, sl, lr}
ffff118c:	e1a08000 	mov	r8, r0
ffff1190:	e1a05001 	mov	r5, r1
ffff1194:	e3a04000 	mov	r4, #0
ffff1198:	e3a09000 	mov	r9, #0
ffff119c:	e1d560b2 	ldrh	r6, [r5, #2]
ffff11a0:	e3a07000 	mov	r7, #0
ffff11a4:	e5989024 	ldr	r9, [r8, #36]	; 0x24
ffff11a8:	e599400c 	ldr	r4, [r9, #12]
ffff11ac:	e5d50001 	ldrb	r0, [r5, #1]
ffff11b0:	e3500006 	cmp	r0, #6
ffff11b4:	0a000002 	beq	0xffff11c4
ffff11b8:	e35000fe 	cmp	r0, #254	; 0xfe
ffff11bc:	1a000046 	bne	0xffff12dc

ffff11c0:	ea00003e 	b	0xffff12c0
ffff11c4:	e320f000 	nop	{0}
ffff11c8:	e5d50000 	ldrb	r0, [r5]
ffff11cc:	e3500080 	cmp	r0, #128	; 0x80
ffff11d0:	0a000000 	beq	0xffff11d8
ffff11d4:	ea000042 	b	0xffff12e4
ffff11d8:	e1a00446 	asr	r0, r6, #8
ffff11dc:	e3500001 	cmp	r0, #1
ffff11e0:	0a000004 	beq	0xffff11f8
ffff11e4:	e3500002 	cmp	r0, #2
ffff11e8:	0a000011 	beq	0xffff1234
ffff11ec:	e3500003 	cmp	r0, #3
ffff11f0:	1a000030 	bne	0xffff12b8

ffff11f4:	ea00001f 	b	0xffff1278
ffff11f8:	e320f000 	nop	{0}
ffff11fc:	e1d500b6 	ldrh	r0, [r5, #6]
ffff1200:	e3500012 	cmp	r0, #18
ffff1204:	9a000001 	bls	0xffff1210
ffff1208:	e3a07012 	mov	r7, #18
ffff120c:	ea000000 	b	0xffff1214
ffff1210:	e1d570b6 	ldrh	r7, [r5, #6]
ffff1214:	e5981000 	ldr	r1, [r8]
ffff1218:	e1a02007 	mov	r2, r7
ffff121c:	e5940000 	ldr	r0, [r4]
ffff1220:	ebfffda3 	bl	0xffff08b4
ffff1224:	e5847004 	str	r7, [r4, #4]
ffff1228:	e3a00000 	mov	r0, #0
ffff122c:	e5c40008 	strb	r0, [r4, #8]
ffff1230:	ea000020 	b	0xffff12b8
ffff1234:	e320f000 	nop	{0}
ffff1238:	e20630ff 	and	r3, r6, #255	; 0xff
ffff123c:	e1a02446 	asr	r2, r6, #8
ffff1240:	e1a00008 	mov	r0, r8
ffff1244:	e5941000 	ldr	r1, [r4]
ffff1248:	ebffffa3 	bl	0xffff10dc
ffff124c:	e1a07000 	mov	r7, r0
ffff1250:	e1d500b6 	ldrh	r0, [r5, #6]
ffff1254:	e1500007 	cmp	r0, r7
ffff1258:	ba000001 	blt	0xffff1264
ffff125c:	e5847004 	str	r7, [r4, #4]
ffff1260:	ea000001 	b	0xffff126c
ffff1264:	e1d500b6 	ldrh	r0, [r5, #6]
ffff1268:	e5840004 	str	r0, [r4, #4]
ffff126c:	e3a00000 	mov	r0, #0
ffff1270:	e5c40008 	strb	r0, [r4, #8]
ffff1274:	ea00000f 	b	0xffff12b8
ffff1278:	e320f000 	nop	{0}
ffff127c:	e20610ff 	and	r1, r6, #255	; 0xff
ffff1280:	e3510000 	cmp	r1, #0
ffff1284:	1a000009 	bne	0xffff12b0

ffff1288:	e5940000 	ldr	r0, [r4]
ffff128c:	e3a02004 	mov	r2, #4
ffff1290:	e5c02000 	strb	r2, [r0]
ffff1294:	e3a02003 	mov	r2, #3
ffff1298:	e5c02001 	strb	r2, [r0, #1]
ffff129c:	e3a02009 	mov	r2, #9
ffff12a0:	e5c02002 	strb	r2, [r0, #2]
ffff12a4:	e3a02004 	mov	r2, #4
ffff12a8:	e5c02003 	strb	r2, [r0, #3]
ffff12ac:	ea000001 	b	0xffff12b8
ffff12b0:	e320f000 	nop	{0}
ffff12b4:	e320f000 	nop	{0}
ffff12b8:	e320f000 	nop	{0}
ffff12bc:	ea000008 	b	0xffff12e4
ffff12c0:	e320f000 	nop	{0}
ffff12c4:	e5940000 	ldr	r0, [r4]
ffff12c8:	e3a01001 	mov	r1, #1
ffff12cc:	e5841004 	str	r1, [r4, #4]
ffff12d0:	e3a01000 	mov	r1, #0
ffff12d4:	e5c01000 	strb	r1, [r0]
ffff12d8:	ea000001 	b	0xffff12e4
ffff12dc:	e320f000 	nop	{0}
ffff12e0:	e320f000 	nop	{0}
ffff12e4:	e320f000 	nop	{0}
ffff12e8:	e3a02001 	mov	r2, #1
ffff12ec:	e1a01004 	mov	r1, r4
ffff12f0:	e1a00008 	mov	r0, r8
ffff12f4:	ebffff6f 	bl	0xffff10b8
ffff12f8:	e3a00000 	mov	r0, #0
ffff12fc:	e8bd87f0 	pop	{r4, r5, r6, r7, r8, r9, sl, pc}

ffff1300:	e92d41f0 	push	{r4, r5, r6, r7, r8, lr}
ffff1304:	e1a06000 	mov	r6, r0
ffff1308:	e3a08000 	mov	r8, #0
ffff130c:	e3a04000 	mov	r4, #0
ffff1310:	e1a07006 	mov	r7, r6
ffff1314:	e3a00000 	mov	r0, #0
ffff1318:	ebfffe8e 	bl	0xffff0d58
ffff131c:	e59f05a8 	ldr	r0, [pc, #1448]	; 0xffff18cc =0x01c19000 USB_OTG_BASE
ffff1320:	e1d048b8 	ldrh	r4, [r0, #136]	; 0x88
ffff1324:	e3540008 	cmp	r4, #8
ffff1328:	0a000008 	beq	0xffff1350
ffff132c:	e3a05000 	mov	r5, #0
ffff1330:	ea000002 	b	0xffff1340
ffff1334:	e59f0590 	ldr	r0, [pc, #1424]	; 0xffff18cc =0x01c19000 USB_OTG_BASE
ffff1338:	e1d048b8 	ldrh	r4, [r0, #136]	; 0x88
ffff133c:	e2855001 	add	r5, r5, #1
ffff1340:	e3550010 	cmp	r5, #16
ffff1344:	aa000001 	bge	0xffff1350
ffff1348:	e3540008 	cmp	r4, #8
ffff134c:	1afffff8 	bne	0xffff1334

ffff1350:	ea000004 	b	0xffff1368
ffff1354:	e59f0570 	ldr	r0, [pc, #1392]	; 0xffff18cc =0x01c19000 USB_OTG_BASE
ffff1358:	e5d00000 	ldrb	r0, [r0]
ffff135c:	e5c70000 	strb	r0, [r7]
ffff1360:	e2877001 	add	r7, r7, #1
ffff1364:	e2888001 	add	r8, r8, #1
ffff1368:	e1b00004 	movs	r0, r4
ffff136c:	e2444001 	sub	r4, r4, #1
ffff1370:	1afffff7 	bne	0xffff1354

ffff1374:	e1a00008 	mov	r0, r8
ffff1378:	e8bd81f0 	pop	{r4, r5, r6, r7, r8, pc}

ffff137c:	e92d47fc 	push	{r2, r3, r4, r5, r6, r7, r8, r9, sl, lr}
ffff1380:	e1a04000 	mov	r4, r0
ffff1384:	e3a06000 	mov	r6, #0
ffff1388:	e3a09000 	mov	r9, #0
ffff138c:	e5946024 	ldr	r6, [r4, #36]	; 0x24
ffff1390:	e596900c 	ldr	r9, [r6, #12]
ffff1394:	e5d60004 	ldrb	r0, [r6, #4]
ffff1398:	ebfffe6e 	bl	0xffff0d58
ffff139c:	e59f0528 	ldr	r0, [pc, #1320]	; 0xffff18cc =0x01c19000 USB_OTG_BASE
ffff13a0:	e1d058b2 	ldrh	r5, [r0, #130]	; 0x82
ffff13a4:	e3150004 	tst	r5, #4
ffff13a8:	0a000005 	beq	0xffff13c4
ffff13ac:	e3a00000 	mov	r0, #0
ffff13b0:	e59f1514 	ldr	r1, [pc, #1300]	; 0xffff18cc =0x01c19000 USB_OTG_BASE
ffff13b4:	e1c108b2 	strh	r0, [r1, #130]	; 0x82
ffff13b8:	e5941024 	ldr	r1, [r4, #36]	; 0x24
ffff13bc:	e5810030 	str	r0, [r1, #48]	; 0x30
ffff13c0:	e8bd87fc 	pop	{r2, r3, r4, r5, r6, r7, r8, r9, sl, pc}

ffff13c4:	e3150010 	tst	r5, #16
ffff13c8:	0a000007 	beq	0xffff13ec
ffff13cc:	e59f04f8 	ldr	r0, [pc, #1272]	; 0xffff18cc =0x01c19000 USB_OTG_BASE
ffff13d0:	e1d008b2 	ldrh	r0, [r0, #130]	; 0x82
ffff13d4:	e3c00010 	bic	r0, r0, #16
ffff13d8:	e59f14ec 	ldr	r1, [pc, #1260]	; 0xffff18cc =0x01c19000 USB_OTG_BASE
ffff13dc:	e1c108b2 	strh	r0, [r1, #130]	; 0x82
ffff13e0:	e3a00000 	mov	r0, #0
ffff13e4:	e5941024 	ldr	r1, [r4, #36]	; 0x24
ffff13e8:	e5810030 	str	r0, [r1, #48]	; 0x30
ffff13ec:	e5940024 	ldr	r0, [r4, #36]	; 0x24
ffff13f0:	e5900030 	ldr	r0, [r0, #48]	; 0x30
ffff13f4:	e3500005 	cmp	r0, #5
ffff13f8:	308ff100 	addcc	pc, pc, r0, lsl #2
ffff13fc:	ea00009c 	b	0xffff1674
ffff1400:	ea000003 	b	0xffff1414
ffff1404:	ea000066 	b	0xffff15a4
ffff1408:	ea00006f 	b	0xffff15cc
ffff140c:	ea000078 	b	0xffff15f4
ffff1410:	ea000092 	b	0xffff1660
ffff1414:	e320f000 	nop	{0}
ffff1418:	e3150001 	tst	r5, #1
ffff141c:	0a00005f 	beq	0xffff15a0
ffff1420:	e1a0000d 	mov	r0, sp
ffff1424:	ebffffb5 	bl	0xffff1300
ffff1428:	e1a0a000 	mov	sl, r0
ffff142c:	e35a0008 	cmp	sl, #8
ffff1430:	0a000003 	beq	0xffff1444
ffff1434:	e3a00060 	mov	r0, #96	; 0x60
ffff1438:	e59f148c 	ldr	r1, [pc, #1164]	; 0xffff18cc =0x01c19000 USB_OTG_BASE
ffff143c:	e1c108b2 	strh	r0, [r1, #130]	; 0x82
ffff1440:	eaffffde 	b	0xffff13c0
ffff1444:	e5941024 	ldr	r1, [r4, #36]	; 0x24
ffff1448:	e281003e 	add	r0, r1, #62	; 0x3e
ffff144c:	e3a02008 	mov	r2, #8
ffff1450:	e1a0100d 	mov	r1, sp
ffff1454:	ebfffd16 	bl	0xffff08b4
ffff1458:	e3a00001 	mov	r0, #1
ffff145c:	e5941024 	ldr	r1, [r4, #36]	; 0x24
ffff1460:	e5c1003d 	strb	r0, [r1, #61]	; 0x3d
ffff1464:	e5dd0001 	ldrb	r0, [sp, #1]
ffff1468:	e3500005 	cmp	r0, #5
ffff146c:	0a000014 	beq	0xffff14c4
ffff1470:	e3500009 	cmp	r0, #9
ffff1474:	0a000002 	beq	0xffff1484
ffff1478:	e350000b 	cmp	r0, #11
ffff147c:	1a000020 	bne	0xffff1504

ffff1480:	ea000009 	b	0xffff14ac
ffff1484:	e320f000 	nop	{0}
ffff1488:	e5dd0000 	ldrb	r0, [sp]
ffff148c:	e3500000 	cmp	r0, #0
ffff1490:	1a000004 	bne	0xffff14a8

ffff1494:	e320f000 	nop	{0}
ffff1498:	e3a00048 	mov	r0, #72	; 0x48
ffff149c:	e59f1428 	ldr	r1, [pc, #1064]	; 0xffff18cc =0x01c19000 USB_OTG_BASE
ffff14a0:	e1c108b2 	strh	r0, [r1, #130]	; 0x82
ffff14a4:	eaffffc5 	b	0xffff13c0
ffff14a8:	ea00001a 	b	0xffff1518
ffff14ac:	e320f000 	nop	{0}
ffff14b0:	e5dd0000 	ldrb	r0, [sp]
ffff14b4:	e3500001 	cmp	r0, #1
ffff14b8:	1a000000 	bne	0xffff14c0

ffff14bc:	eafffff5 	b	0xffff1498
ffff14c0:	ea000014 	b	0xffff1518
ffff14c4:	e320f000 	nop	{0}
ffff14c8:	e5dd0000 	ldrb	r0, [sp]
ffff14cc:	e3500000 	cmp	r0, #0
ffff14d0:	1a00000a 	bne	0xffff1500

ffff14d4:	e1dd00b2 	ldrh	r0, [sp, #2]
ffff14d8:	e200707f 	and	r7, r0, #127	; 0x7f
ffff14dc:	e5940024 	ldr	r0, [r4, #36]	; 0x24
ffff14e0:	e5c0703c 	strb	r7, [r0, #60]	; 0x3c
ffff14e4:	e3a0004a 	mov	r0, #74	; 0x4a
ffff14e8:	e59f13dc 	ldr	r1, [pc, #988]	; 0xffff18cc =0x01c19000 USB_OTG_BASE
ffff14ec:	e1c108b2 	strh	r0, [r1, #130]	; 0x82
ffff14f0:	e3a00003 	mov	r0, #3
ffff14f4:	e5941024 	ldr	r1, [r4, #36]	; 0x24
ffff14f8:	e5810030 	str	r0, [r1, #48]	; 0x30
ffff14fc:	eaffffaf 	b	0xffff13c0
ffff1500:	ea000004 	b	0xffff1518
ffff1504:	e320f000 	nop	{0}
ffff1508:	e3a00040 	mov	r0, #64	; 0x40
ffff150c:	e59f13b8 	ldr	r1, [pc, #952]	; 0xffff18cc =0x01c19000 USB_OTG_BASE
ffff1510:	e1c108b2 	strh	r0, [r1, #130]	; 0x82
ffff1514:	e320f000 	nop	{0}
ffff1518:	e320f000 	nop	{0}
ffff151c:	e5dd0000 	ldrb	r0, [sp]
ffff1520:	e3100080 	tst	r0, #128	; 0x80
ffff1524:	0a000003 	beq	0xffff1538
ffff1528:	e3a00001 	mov	r0, #1
ffff152c:	e5941024 	ldr	r1, [r4, #36]	; 0x24
ffff1530:	e5810030 	str	r0, [r1, #48]	; 0x30
ffff1534:	ea000002 	b	0xffff1544
ffff1538:	e3a00002 	mov	r0, #2
ffff153c:	e5941024 	ldr	r1, [r4, #36]	; 0x24
ffff1540:	e5810030 	str	r0, [r1, #48]	; 0x30
ffff1544:	e1a0100d 	mov	r1, sp
ffff1548:	e1a00004 	mov	r0, r4
ffff154c:	ebffff0d 	bl	0xffff1188
ffff1550:	e1a08000 	mov	r8, r0
ffff1554:	e3580000 	cmp	r8, #0
ffff1558:	aa000008 	bge	0xffff1580
ffff155c:	e3a00060 	mov	r0, #96	; 0x60
ffff1560:	e59f1364 	ldr	r1, [pc, #868]	; 0xffff18cc =0x01c19000 USB_OTG_BASE
ffff1564:	e1c108b2 	strh	r0, [r1, #130]	; 0x82
ffff1568:	e3a00048 	mov	r0, #72	; 0x48
ffff156c:	e1c108b2 	strh	r0, [r1, #130]	; 0x82
ffff1570:	e3a00000 	mov	r0, #0
ffff1574:	e5941024 	ldr	r1, [r4, #36]	; 0x24
ffff1578:	e5810030 	str	r0, [r1, #48]	; 0x30
ffff157c:	ea000006 	b	0xffff159c
ffff1580:	e5940024 	ldr	r0, [r4, #36]	; 0x24
ffff1584:	e5d0003d 	ldrb	r0, [r0, #61]	; 0x3d
ffff1588:	e3500000 	cmp	r0, #0
ffff158c:	0a000002 	beq	0xffff159c
ffff1590:	e3a00000 	mov	r0, #0
ffff1594:	e5941024 	ldr	r1, [r4, #36]	; 0x24
ffff1598:	e5c1003d 	strb	r0, [r1, #61]	; 0x3d
ffff159c:	e320f000 	nop	{0}
ffff15a0:	ea000035 	b	0xffff167c
ffff15a4:	e320f000 	nop	{0}
ffff15a8:	e3150002 	tst	r5, #2
ffff15ac:	1a000005 	bne	0xffff15c8

ffff15b0:	e3590000 	cmp	r9, #0
ffff15b4:	0a000003 	beq	0xffff15c8
ffff15b8:	e1a02009 	mov	r2, r9
ffff15bc:	e1a01006 	mov	r1, r6
ffff15c0:	e1a00004 	mov	r0, r4
ffff15c4:	ebfffd83 	bl	0xffff0bd8
ffff15c8:	ea00002b 	b	0xffff167c
ffff15cc:	e320f000 	nop	{0}
ffff15d0:	e3150001 	tst	r5, #1
ffff15d4:	0a000005 	beq	0xffff15f0
ffff15d8:	e3590000 	cmp	r9, #0
ffff15dc:	0a000003 	beq	0xffff15f0
ffff15e0:	e1a02009 	mov	r2, r9
ffff15e4:	e1a01006 	mov	r1, r6
ffff15e8:	e1a00004 	mov	r0, r4
ffff15ec:	ebfffd09 	bl	0xffff0a18
ffff15f0:	ea000021 	b	0xffff167c
ffff15f4:	e320f000 	nop	{0}
ffff15f8:	e5940024 	ldr	r0, [r4, #36]	; 0x24
ffff15fc:	e5d0003f 	ldrb	r0, [r0, #63]	; 0x3f
ffff1600:	e3500005 	cmp	r0, #5
ffff1604:	1a00000e 	bne	0xffff1644

ffff1608:	e3a000c0 	mov	r0, #192	; 0xc0
ffff160c:	e59f12b8 	ldr	r1, [pc, #696]	; 0xffff18cc =0x01c19000 USB_OTG_BASE
ffff1610:	e1c108b2 	strh	r0, [r1, #130]	; 0x82
ffff1614:	e3a07000 	mov	r7, #0
ffff1618:	ebfffe1c 	bl	0xffff0e90
ffff161c:	e1a07000 	mov	r7, r0
ffff1620:	e3a00000 	mov	r0, #0
ffff1624:	ebfffdcb 	bl	0xffff0d58
ffff1628:	e5940024 	ldr	r0, [r4, #36]	; 0x24
ffff162c:	e5d0003c 	ldrb	r0, [r0, #60]	; 0x3c
ffff1630:	e59f1294 	ldr	r1, [pc, #660]	; 0xffff18cc =0x01c19000 USB_OTG_BASE
ffff1634:	e5c10098 	strb	r0, [r1, #152]	; 0x98
ffff1638:	e1a00007 	mov	r0, r7
ffff163c:	ebfffdc5 	bl	0xffff0d58
ffff1640:	ea000001 	b	0xffff164c
ffff1644:	e320f000 	nop	{0}
ffff1648:	e320f000 	nop	{0}
ffff164c:	e320f000 	nop	{0}
ffff1650:	e3a00000 	mov	r0, #0
ffff1654:	e5941024 	ldr	r1, [r4, #36]	; 0x24
ffff1658:	e5810030 	str	r0, [r1, #48]	; 0x30
ffff165c:	ea000006 	b	0xffff167c
ffff1660:	e320f000 	nop	{0}
ffff1664:	e3a00000 	mov	r0, #0
ffff1668:	e5941024 	ldr	r1, [r4, #36]	; 0x24
ffff166c:	e5810030 	str	r0, [r1, #48]	; 0x30
ffff1670:	ea000001 	b	0xffff167c
ffff1674:	e320f000 	nop	{0}
ffff1678:	e320f000 	nop	{0}
ffff167c:	e320f000 	nop	{0}
ffff1680:	e320f000 	nop	{0}
ffff1684:	eaffff4d 	b	0xffff13c0

ffff1688:	e92d4070 	push	{r4, r5, r6, lr}
ffff168c:	e1a04000 	mov	r4, r0
ffff1690:	e3a05000 	mov	r5, #0
ffff1694:	e5d40004 	ldrb	r0, [r4, #4]
ffff1698:	ebfffdae 	bl	0xffff0d58
ffff169c:	e5d40005 	ldrb	r0, [r4, #5]
ffff16a0:	e3100080 	tst	r0, #128	; 0x80
ffff16a4:	0a00000d 	beq	0xffff16e0
ffff16a8:	e3a00048 	mov	r0, #72	; 0x48
ffff16ac:	e59f1218 	ldr	r1, [pc, #536]	; 0xffff18cc =0x01c19000 USB_OTG_BASE
ffff16b0:	e1c108b2 	strh	r0, [r1, #130]	; 0x82
ffff16b4:	e5940008 	ldr	r0, [r4, #8]
ffff16b8:	e7df059f 	bfc	r0, #11, #21
ffff16bc:	e5810080 	str	r0, [r1, #128]	; 0x80
ffff16c0:	e1a00001 	mov	r0, r1
ffff16c4:	e5d05048 	ldrb	r5, [r0, #72]	; 0x48
ffff16c8:	e5d40004 	ldrb	r0, [r4, #4]
ffff16cc:	e3a01001 	mov	r1, #1
ffff16d0:	e1850011 	orr	r0, r5, r1, lsl r0
ffff16d4:	e59f11f0 	ldr	r1, [pc, #496]	; 0xffff18cc =0x01c19000 USB_OTG_BASE
ffff16d8:	e5c10048 	strb	r0, [r1, #72]	; 0x48
ffff16dc:	ea00000c 	b	0xffff1714
ffff16e0:	e3a00090 	mov	r0, #144	; 0x90
ffff16e4:	e59f11e0 	ldr	r1, [pc, #480]	; 0xffff18cc =0x01c19000 USB_OTG_BASE
ffff16e8:	e1c108b6 	strh	r0, [r1, #134]	; 0x86
ffff16ec:	e5940008 	ldr	r0, [r4, #8]
ffff16f0:	e7df059f 	bfc	r0, #11, #21
ffff16f4:	e1c108b4 	strh	r0, [r1, #132]	; 0x84
ffff16f8:	e1a00001 	mov	r0, r1
ffff16fc:	e5d0504a 	ldrb	r5, [r0, #74]	; 0x4a
ffff1700:	e5d40004 	ldrb	r0, [r4, #4]
ffff1704:	e3a01001 	mov	r1, #1
ffff1708:	e1850011 	orr	r0, r5, r1, lsl r0
ffff170c:	e59f11b8 	ldr	r1, [pc, #440]	; 0xffff18cc =0x01c19000 USB_OTG_BASE
ffff1710:	e5c1004a 	strb	r0, [r1, #74]	; 0x4a
ffff1714:	e8bd8070 	pop	{r4, r5, r6, pc}

ffff1718:	e92d4010 	push	{r4, lr}
ffff171c:	e1a04000 	mov	r4, r0
ffff1720:	e5941024 	ldr	r1, [r4, #36]	; 0x24
ffff1724:	e2810020 	add	r0, r1, #32
ffff1728:	ebffffd6 	bl	0xffff1688
ffff172c:	e5941024 	ldr	r1, [r4, #36]	; 0x24
ffff1730:	e2810010 	add	r0, r1, #16
ffff1734:	ebffffd3 	bl	0xffff1688
ffff1738:	e8bd8010 	pop	{r4, pc}

ffff173c:	e92d47f0 	push	{r4, r5, r6, r7, r8, r9, sl, lr}
ffff1740:	e3a08000 	mov	r8, #0
ffff1744:	e3a04000 	mov	r4, #0
ffff1748:	e3a06000 	mov	r6, #0
ffff174c:	e3a09000 	mov	r9, #0
ffff1750:	e3a0a000 	mov	sl, #0
ffff1754:	ebfffdcd 	bl	0xffff0e90
ffff1758:	e1a08000 	mov	r8, r0
ffff175c:	e59f0180 	ldr	r0, [pc, #384]	; 0xffff18e4 =0x00007d00
ffff1760:	e5900000 	ldr	r0, [r0]
ffff1764:	eb0003b9 	bl	0xffff2650
ffff1768:	e1a06000 	mov	r6, r0
ffff176c:	e59f1170 	ldr	r1, [pc, #368]	; 0xffff18e4 =0x00007d00
ffff1770:	e5910000 	ldr	r0, [r1]
ffff1774:	e5901038 	ldr	r1, [r0, #56]	; 0x38
ffff1778:	e3510000 	cmp	r1, #0
ffff177c:	1a000002 	bne	0xffff178c

ffff1780:	e59f1144 	ldr	r1, [pc, #324]	; 0xffff18cc =0x01c19000 USB_OTG_BASE
ffff1784:	e5d11044 	ldrb	r1, [r1, #68]	; 0x44
ffff1788:	e5801038 	str	r1, [r0, #56]	; 0x38
ffff178c:	e320f000 	nop	{0}
ffff1790:	e5901038 	ldr	r1, [r0, #56]	; 0x38
ffff1794:	e1a09001 	mov	r9, r1
ffff1798:	e59f1144 	ldr	r1, [pc, #324]	; 0xffff18e4 =0x00007d00
ffff179c:	e5910000 	ldr	r0, [r1]
ffff17a0:	e590103c 	ldr	r1, [r0, #60]	; 0x3c
ffff17a4:	e3510000 	cmp	r1, #0
ffff17a8:	1a000002 	bne	0xffff17b8

ffff17ac:	e59f1118 	ldr	r1, [pc, #280]	; 0xffff18cc =0x01c19000 USB_OTG_BASE
ffff17b0:	e5d11046 	ldrb	r1, [r1, #70]	; 0x46
ffff17b4:	e580103c 	str	r1, [r0, #60]	; 0x3c
ffff17b8:	e320f000 	nop	{0}
ffff17bc:	e590103c 	ldr	r1, [r0, #60]	; 0x3c
ffff17c0:	e1a0a001 	mov	sl, r1
ffff17c4:	e3160004 	tst	r6, #4
ffff17c8:	0a000023 	beq	0xffff185c
ffff17cc:	e3a00002 	mov	r0, #2
ffff17d0:	e59f110c 	ldr	r1, [pc, #268]	; 0xffff18e4 =0x00007d00
ffff17d4:	e5911000 	ldr	r1, [r1]
ffff17d8:	e5911024 	ldr	r1, [r1, #36]	; 0x24
ffff17dc:	e5c10034 	strb	r0, [r1, #52]	; 0x34
ffff17e0:	e3a00000 	mov	r0, #0
ffff17e4:	e59f10f8 	ldr	r1, [pc, #248]	; 0xffff18e4 =0x00007d00
ffff17e8:	e5911000 	ldr	r1, [r1]
ffff17ec:	e5911024 	ldr	r1, [r1, #36]	; 0x24
ffff17f0:	e5810030 	str	r0, [r1, #48]	; 0x30
ffff17f4:	e3a01004 	mov	r1, #4
ffff17f8:	e59f00e4 	ldr	r0, [pc, #228]	; 0xffff18e4 =0x00007d00
ffff17fc:	e5900000 	ldr	r0, [r0]
ffff1800:	eb0003bf 	bl	0xffff2704

ffff1804:	e59f10c0 	ldr	r1, [pc, #192]	; 0xffff18cc =0x01c19000 USB_OTG_BASE
ffff1808:	e5c18042 	strb	r8, [r1, #66]	; 0x42
ffff180c:	ebfffc43 	bl	0xffff0920
ffff1810:	e59f00b4 	ldr	r0, [pc, #180]	; 0xffff18cc =0x01c19000 USB_OTG_BASE
ffff1814:	e5d00048 	ldrb	r0, [r0, #72]	; 0x48
ffff1818:	e3800001 	orr	r0, r0, #1
ffff181c:	e59f10a8 	ldr	r1, [pc, #168]	; 0xffff18cc =0x01c19000 USB_OTG_BASE
ffff1820:	e5c10048 	strb	r0, [r1, #72]	; 0x48
ffff1824:	e59f00b8 	ldr	r0, [pc, #184]	; 0xffff18e4 =0x00007d00
ffff1828:	e5900000 	ldr	r0, [r0]
ffff182c:	ebffffb9 	bl	0xffff1718
ffff1830:	e3a05000 	mov	r5, #0
ffff1834:	ebfffd95 	bl	0xffff0e90
ffff1838:	e1a05000 	mov	r5, r0
ffff183c:	e3a00000 	mov	r0, #0
ffff1840:	ebfffd44 	bl	0xffff0d58
ffff1844:	e3a00000 	mov	r0, #0
ffff1848:	e59f107c 	ldr	r1, [pc, #124]	; 0xffff18cc =0x01c19000 USB_OTG_BASE
ffff184c:	e5c10098 	strb	r0, [r1, #152]	; 0x98
ffff1850:	e1a00005 	mov	r0, r5
ffff1854:	ebfffd3f 	bl	0xffff0d58

ffff1858:	e8bd87f0 	pop	{r4, r5, r6, r7, r8, r9, sl, pc}

ffff185c:	e3160002 	tst	r6, #2
ffff1860:	0a000003 	beq	0xffff1874

ffff1864:	e3a01002 	mov	r1, #2
ffff1868:	e59f0074 	ldr	r0, [pc, #116]	; 0xffff18e4 =0x00007d00
ffff186c:	e5900000 	ldr	r0, [r0]
ffff1870:	eb0003a3 	bl	0xffff2704

ffff1874:	e3160001 	tst	r6, #1
ffff1878:	0a000008 	beq	0xffff18a0
ffff187c:	e3a01001 	mov	r1, #1
ffff1880:	e59f005c 	ldr	r0, [pc, #92]	; 0xffff18e4 =0x00007d00
ffff1884:	e5900000 	ldr	r0, [r0]
ffff1888:	eb00039d 	bl	0xffff2704
ffff188c:	e3a00000 	mov	r0, #0
ffff1890:	e59f104c 	ldr	r1, [pc, #76]	; 0xffff18e4 =0x00007d00
ffff1894:	e5911000 	ldr	r1, [r1]
ffff1898:	e5911024 	ldr	r1, [r1, #36]	; 0x24
ffff189c:	e5810030 	str	r0, [r1, #48]	; 0x30
ffff18a0:	e3190001 	tst	r9, #1
ffff18a4:	0a000006 	beq	0xffff18c4

ffff18a8:	e3a01001 	mov	r1, #1
ffff18ac:	e59f0030 	ldr	r0, [pc, #48]	; 0xffff18e4 =0x00007d00
ffff18b0:	e5900000 	ldr	r0, [r0]
ffff18b4:	eb00038a 	bl	0xffff26e4
ffff18b8:	e59f0024 	ldr	r0, [pc, #36]	; 0xffff18e4 =0x00007d00
ffff18bc:	e5900000 	ldr	r0, [r0]
ffff18c0:	ebfffead 	bl	0xffff137c

ffff18c4:	e3a04001 	mov	r4, #1
ffff18c8:	ea000022 	b	0xffff1958

	;; Global Offset Table
ffff18cc:	01c19000			 	; USB_OTG_BASE
ffff18d0:	01c19004				; E_HCSPARAMS
ffff18d4:	01c19008				; E_HCCPARAMS
ffff18d8:	01c1900c				; E_HCSPORTROUTE
ffff18dc:	01c19010				; E_USBCMD
ffff18e0:	01c19086
ffff18e4:	00007d00

ffff18e8:	e3a00001 	mov	r0, #1
ffff18ec:	e1a07410 	lsl	r7, r0, r4
ffff18f0:	e1190007 	tst	r9, r7
ffff18f4:	0a000016 	beq	0xffff1954

ffff18f8:	e3a05000 	mov	r5, #0
ffff18fc:	e20710ff 	and	r1, r7, #255	; 0xff
ffff1900:	e51f0024 	ldr	r0, [pc, #-36]	; 0xffff18e4 =0x00007d00
ffff1904:	e5900000 	ldr	r0, [r0]
ffff1908:	eb000375 	bl	0xffff26e4
ffff190c:	e3a05001 	mov	r5, #1
ffff1910:	ea00000c 	b	0xffff1948

ffff1914:	e51f0038 	ldr	r0, [pc, #-56]	; 0xffff18e4 =0x00007d00
ffff1918:	e5900000 	ldr	r0, [r0]
ffff191c:	e5900024 	ldr	r0, [r0, #36]	; 0x24
ffff1920:	e0800205 	add	r0, r0, r5, lsl #4
ffff1924:	e5d00005 	ldrb	r0, [r0, #5]
ffff1928:	e2000080 	and	r0, r0, #128	; 0x80
ffff192c:	e3500080 	cmp	r0, #128	; 0x80
ffff1930:	1a000003 	bne	0xffff1944

ffff1934:	e1a01005 	mov	r1, r5
ffff1938:	e51f005c 	ldr	r0, [pc, #-92]	; 0xffff18e4 =0x00007d00
ffff193c:	e5900000 	ldr	r0, [r0]
ffff1940:	ebfffd07 	bl	0xffff0d64

ffff1944:	e2855001 	add	r5, r5, #1

ffff1948:	e3550003 	cmp	r5, #3
ffff194c:	bafffff0 	blt	0xffff1914

ffff1950:	e320f000 	nop	{0}

ffff1954:	e2844001 	add	r4, r4, #1
ffff1958:	e3540005 	cmp	r4, #5
ffff195c:	daffffe1 	ble	0xffff18e8

ffff1960:	e3a04001 	mov	r4, #1
ffff1964:	ea000020 	b	0xffff19ec

ffff1968:	e3a00001 	mov	r0, #1
ffff196c:	e1a07410 	lsl	r7, r0, r4
ffff1970:	e11a0007 	tst	sl, r7
ffff1974:	0a00001b 	beq	0xffff19e8

ffff1978:	e3a00000 	mov	r0, #0
ffff197c:	e1a05000 	mov	r5, r0
ffff1980:	e51f20a4 	ldr	r2, [pc, #-164]	; 0xffff18e4 =0x00007d00
ffff1984:	e20710ff 	and	r1, r7, #255	; 0xff
ffff1988:	e5920000 	ldr	r0, [r2]
ffff198c:	e590203c 	ldr	r2, [r0, #60]	; 0x3c
ffff1990:	e1c22001 	bic	r2, r2, r1
ffff1994:	e580203c 	str	r2, [r0, #60]	; 0x3c
ffff1998:	e51f20d4 	ldr	r2, [pc, #-212]	; 0xffff18cc =0x01c19000 USB_OTG_BASE
ffff199c:	e5c21046 	strb	r1, [r2, #70]	; 0x46
ffff19a0:	e320f000 	nop	{0}
ffff19a4:	e3a05001 	mov	r5, #1
ffff19a8:	ea00000b 	b	0xffff19dc

ffff19ac:	e51f00d0 	ldr	r0, [pc, #-208]	; 0xffff18e4 =0x00007d00
ffff19b0:	e5900000 	ldr	r0, [r0]
ffff19b4:	e5900024 	ldr	r0, [r0, #36]	; 0x24
ffff19b8:	e0800205 	add	r0, r0, r5, lsl #4
ffff19bc:	e5d00005 	ldrb	r0, [r0, #5]
ffff19c0:	e3100080 	tst	r0, #128	; 0x80
ffff19c4:	1a000003 	bne	0xffff19d8

ffff19c8:	e1a01005 	mov	r1, r5
ffff19cc:	e51f00f0 	ldr	r0, [pc, #-240]	; 0xffff18e4 =0x00007d00
ffff19d0:	e5900000 	ldr	r0, [r0]
ffff19d4:	ebfffce2 	bl	0xffff0d64

ffff19d8:	e2855001 	add	r5, r5, #1

ffff19dc:	e3550003 	cmp	r5, #3
ffff19e0:	bafffff1 	blt	0xffff19ac
ffff19e4:	e320f000 	nop	{0}

ffff19e8:	e2844001 	add	r4, r4, #1

ffff19ec:	e3540005 	cmp	r4, #5
ffff19f0:	daffffdc 	ble	0xffff1968
ffff19f4:	ebfffbc9 	bl	0xffff0920
ffff19f8:	e51f1134 	ldr	r1, [pc, #-308]	; 0xffff18cc =0x01c19000 USB_OTG_BASE
ffff19fc:	e5c18042 	strb	r8, [r1, #66]	; 0x42
ffff1a00:	e51f1124 	ldr	r1, [pc, #-292]	; 0xffff18e4 =0x00007d00
ffff1a04:	e5910000 	ldr	r0, [r1]
ffff1a08:	e3a01000 	mov	r1, #0
ffff1a0c:	e5801040 	str	r1, [r0, #64]	; 0x40
ffff1a10:	e5801038 	str	r1, [r0, #56]	; 0x38
ffff1a14:	e580103c 	str	r1, [r0, #60]	; 0x3c
ffff1a18:	e320f000 	nop	{0}
ffff1a1c:	e320f000 	nop	{0}
ffff1a20:	eaffff8c 	b	0xffff1858

ffff1a24:	e92d4010 	push	{r4, lr}
ffff1a28:	e1a04000 	mov	r4, r0
ffff1a2c:	ebffff42 	bl	0xffff173c
ffff1a30:	e8bd8010 	pop	{r4, pc}

ffff1a34:	e92d4010 	push	{r4, lr}
ffff1a38:	e1a022a0 	lsr	r2, r0, #5
ffff1a3c:	e1a04102 	lsl	r4, r2, #2
ffff1a40:	e2841772 	add	r1, r4, #29884416	; 0x1c80000 GIC_DIST
ffff1a44:	e2811d4a 	add	r1, r1, #4736	; 0x1280
ffff1a48:	e200301f 	and	r3, r0, #31
ffff1a4c:	e3a04001 	mov	r4, #1
ffff1a50:	e1a04314 	lsl	r4, r4, r3
ffff1a54:	e5814000 	str	r4, [r1]
ffff1a58:	e8bd8010 	pop	{r4, pc}

ffff1a5c:	e92d4070 	push	{r4, r5, r6, lr}
ffff1a60:	e59f2cbc 	ldr	r2, [pc, #3260]	; 0xffff2724 =0x01010101
ffff1a64:	e3a03000 	mov	r3, #0
ffff1a68:	e59f4cb8 	ldr	r4, [pc, #3256]	; 0xffff2728 =01c81000 GIC_DIST
ffff1a6c:	e5843000 	str	r3, [r4]
ffff1a70:	e1c431c2 	bic	r3, r4, r2, asr #3
ffff1a74:	e5933004 	ldr	r3, [r3, #4]
ffff1a78:	e203301f 	and	r3, r3, #31
ffff1a7c:	e2833001 	add	r3, r3, #1
ffff1a80:	e1a01283 	lsl	r1, r3, #5
ffff1a84:	e3510fff 	cmp	r1, #1020	; 0x3fc
ffff1a88:	9a000001 	bls	0xffff1a94
ffff1a8c:	e30013fc 	movw	r1, #1020	; 0x3fc
ffff1a90:	ea000002 	b	0xffff1aa0
ffff1a94:	e351008c 	cmp	r1, #140	; 0x8c
ffff1a98:	2a000000 	bcs	0xffff1aa0
ffff1a9c:	e8bd8070 	pop	{r4, r5, r6, pc}

ffff1aa0:	e3a00020 	mov	r0, #32
ffff1aa4:	ea000006 	b	0xffff1ac4
ffff1aa8:	e3a03000 	mov	r3, #0
ffff1aac:	e1a04220 	lsr	r4, r0, #4
ffff1ab0:	e1a04104 	lsl	r4, r4, #2
ffff1ab4:	e2844772 	add	r4, r4, #29884416	; 0x1c80000 GIC_DIST
ffff1ab8:	e2844b07 	add	r4, r4, #7168	; 0x1c00
ffff1abc:	e5843000 	str	r3, [r4]
ffff1ac0:	e2800010 	add	r0, r0, #16
ffff1ac4:	e350008c 	cmp	r0, #140	; 0x8c
ffff1ac8:	3afffff6 	bcc	0xffff1aa8
ffff1acc:	e3a00020 	mov	r0, #32
ffff1ad0:	ea000007 	b	0xffff1af4
ffff1ad4:	e59f3c50 	ldr	r3, [pc, #3152]	; 0xffff272c =0xa0a0a0a0
0ffff1ad8:	e2404020 	sub	r4, r0, #32
ffff1adc:	e1a04124 	lsr	r4, r4, #2
ffff1ae0:	e59f5c48 	ldr	r5, [pc, #3144]	; 0xffff2730 =0x01c81420
ffff1ae4:	e3a06004 	mov	r6, #4
ffff1ae8:	e0245496 	mla	r4, r6, r4, r5
ffff1aec:	e5843000 	str	r3, [r4]
ffff1af0:	e2800004 	add	r0, r0, #4
ffff1af4:	e350008c 	cmp	r0, #140	; 0x8c
ffff1af8:	3afffff5 	bcc	0xffff1ad4
ffff1afc:	e3a00020 	mov	r0, #32
ffff1b00:	ea000006 	b	0xffff1b20
ffff1b04:	e2403020 	sub	r3, r0, #32
ffff1b08:	e1a03123 	lsr	r3, r3, #2
ffff1b0c:	e59f4c20 	ldr	r4, [pc, #3104]	; 0xffff2734 =0x01c81820
ffff1b10:	e3a05004 	mov	r5, #4
ffff1b14:	e0234395 	mla	r3, r5, r3, r4
ffff1b18:	e5832000 	str	r2, [r3]
ffff1b1c:	e2800004 	add	r0, r0, #4
ffff1b20:	e350008c 	cmp	r0, #140	; 0x8c
ffff1b24:	3afffff6 	bcc	0xffff1b04
ffff1b28:	e3a00020 	mov	r0, #32
ffff1b2c:	ea000006 	b	0xffff1b4c
ffff1b30:	e3e03000 	mvn	r3, #0
ffff1b34:	e1a042a0 	lsr	r4, r0, #5
ffff1b38:	e1a04104 	lsl	r4, r4, #2
ffff1b3c:	e2844507 	add	r4, r4, #29360128	; 0x1c00000
ffff1b40:	e2844a81 	add	r4, r4, #528384	; 0x81000
ffff1b44:	e5843180 	str	r3, [r4, #384]	; 0x180
ffff1b48:	e2800020 	add	r0, r0, #32
ffff1b4c:	e350008c 	cmp	r0, #140	; 0x8c
ffff1b50:	3afffff6 	bcc	0xffff1b30
ffff1b54:	e3a00020 	mov	r0, #32
ffff1b58:	ea000006 	b	0xffff1b78
ffff1b5c:	e3e03000 	mvn	r3, #0
ffff1b60:	e1a042a0 	lsr	r4, r0, #5
ffff1b64:	e1a04104 	lsl	r4, r4, #2
ffff1b68:	e2844507 	add	r4, r4, #29360128	; 0x1c00000
ffff1b6c:	e2844a81 	add	r4, r4, #528384	; 0x81000
ffff1b70:	e5843380 	str	r3, [r4, #896]	; 0x380
ffff1b74:	e2800020 	add	r0, r0, #32
ffff1b78:	e350008c 	cmp	r0, #140	; 0x8c
ffff1b7c:	3afffff6 	bcc	0xffff1b5c
ffff1b80:	e3a03001 	mov	r3, #1
ffff1b84:	e59f4b9c 	ldr	r4, [pc, #2972]	; 0xffff2728 =01c81000 GIC_DIST
ffff1b88:	e5843000 	str	r3, [r4]
ffff1b8c:	e320f000 	nop	{0}
ffff1b90:	eaffffc1 	b	0xffff1a9c

ffff1b94:	e92d4010 	push	{r4, lr}
ffff1b98:	e3a01000 	mov	r1, #0
ffff1b9c:	e59f2b94 	ldr	r2, [pc, #2964]	; 0xffff2738 =0x01c82000 GIC_CPUIF
ffff1ba0:	e5821000 	str	r1, [r2]
ffff1ba4:	e2411801 	sub	r1, r1, #65536	; 0x10000
ffff1ba8:	e0822241 	add	r2, r2, r1, asr #4
ffff1bac:	e5821180 	str	r1, [r2, #384]	; 0x180
ffff1bb0:	e30f1fff 	movw	r1, #65535	; 0xffff
ffff1bb4:	e5821100 	str	r1, [r2, #256]	; 0x100
ffff1bb8:	e3a00000 	mov	r0, #0
ffff1bbc:	ea000006 	b	0xffff1bdc
ffff1bc0:	e59f1b64 	ldr	r1, [pc, #2916]	; 0xffff272c =0xa0a0a0a0
ffff1bc4:	e1a02120 	lsr	r2, r0, #2
ffff1bc8:	e1a02102 	lsl	r2, r2, #2
ffff1bcc:	e2822772 	add	r2, r2, #29884416	; 0x1c80000 GIC_DIST
ffff1bd0:	e2822b05 	add	r2, r2, #5120	; 0x1400
ffff1bd4:	e5821000 	str	r1, [r2]
ffff1bd8:	e2800004 	add	r0, r0, #4
ffff1bdc:	e3500010 	cmp	r0, #16
ffff1be0:	3afffff6 	bcc	0xffff1bc0
ffff1be4:	e3a00010 	mov	r0, #16
ffff1be8:	ea000007 	b	0xffff1c0c
ffff1bec:	e59f1b38 	ldr	r1, [pc, #2872]	; 0xffff272c =0xa0a0a0a0
ffff1bf0:	e2402010 	sub	r2, r0, #16
ffff1bf4:	e1a02122 	lsr	r2, r2, #2
ffff1bf8:	e59f3b3c 	ldr	r3, [pc, #2876]	; 0xffff273c =0x01c81410
ffff1bfc:	e3a04004 	mov	r4, #4
ffff1c00:	e0223294 	mla	r2, r4, r2, r3
ffff1c04:	e5821000 	str	r1, [r2]
ffff1c08:	e2800004 	add	r0, r0, #4
ffff1c0c:	e3500020 	cmp	r0, #32
ffff1c10:	3afffff5 	bcc	0xffff1bec
ffff1c14:	e3a010f0 	mov	r1, #240	; 0xf0
ffff1c18:	e59f2b18 	ldr	r2, [pc, #2840]	; 0xffff2738 =0x01c82000 GIC_CPUIF
ffff1c1c:	e5821004 	str	r1, [r2, #4]
ffff1c20:	e3a01001 	mov	r1, #1
ffff1c24:	e5821000 	str	r1, [r2]
ffff1c28:	e8bd8010 	pop	{r4, pc}

ffff1c2c:	e92d41f0 	push	{r4, r5, r6, r7, r8, lr}
ffff1c30:	e1a04000 	mov	r4, r0
ffff1c34:	e1a062a4 	lsr	r6, r4, #5
ffff1c38:	e1a00106 	lsl	r0, r6, #2
ffff1c3c:	e2805772 	add	r5, r0, #29884416	; 0x1c80000 GIC_DIST
ffff1c40:	e2855c11 	add	r5, r5, #4352	; 0x1100
ffff1c44:	e204701f 	and	r7, r4, #31
ffff1c48:	e3a03001 	mov	r3, #1
ffff1c4c:	e1a02003 	mov	r2, r3
ffff1c50:	e1a01007 	mov	r1, r7
ffff1c54:	e1a00005 	mov	r0, r5
ffff1c58:	ebfffb27 	bl	0xffff08fc
ffff1c5c:	e3a00000 	mov	r0, #0
ffff1c60:	e8bd81f0 	pop	{r4, r5, r6, r7, r8, pc}

ffff1c64:	e3a00000 	mov	r0, #0
ffff1c68:	e3e01000 	mvn	r1, #0
ffff1c6c:	e59f2ab4 	ldr	r2, [pc, #2740]	; 0xffff2728 =01c81000 GIC_DIST
ffff1c70:	e5821180 	str	r1, [r2, #384]	; 0x180
ffff1c74:	e5821184 	str	r1, [r2, #388]	; 0x184
ffff1c78:	e5821188 	str	r1, [r2, #392]	; 0x188
ffff1c7c:	e582118c 	str	r1, [r2, #396]	; 0x18c
ffff1c80:	e5821190 	str	r1, [r2, #400]	; 0x190
ffff1c84:	e12fff1e 	bx	lr

ffff1c88:	e92d4010 	push	{r4, lr}
ffff1c8c:	e3a00067 	mov	r0, #103	; 0x67
ffff1c90:	ebffffe5 	bl	0xffff1c2c
ffff1c94:	e8bd8010 	pop	{r4, pc}

interrupt_handler:
ffff1c98:	e92d4010 	push	{r4, lr}
ffff1c9c:	e59f0a94 	ldr	r0, [pc, #2708]	; 0xffff2738 =0x01c82000 GIC_CPUIF
ffff1ca0:	e590400c 	ldr	r4, [r0, #12]
ffff1ca4:	e1a00004 	mov	r0, r4
ffff1ca8:	e7df051f 	bfc	r0, #10, #22
ffff1cac:	e1a04000 	mov	r4, r0
ffff1cb0:	e3540067 	cmp	r4, #103	; 0x67
ffff1cb4:	1a000001 	bne	0xffff1cc0

ffff1cb8:	e1a00004 	mov	r0, r4
ffff1cbc:	ebffff58 	bl	0xffff1a24
ffff1cc0:	e59f0a70 	ldr	r0, [pc, #2672]	; 0xffff2738 =0x01c82000 GIC_CPUIF
ffff1cc4:	e5804010 	str	r4, [r0, #16]
ffff1cc8:	e2800a01 	add	r0, r0, #4096	; 0x1000
ffff1ccc:	e5804000 	str	r4, [r0]
ffff1cd0:	e1a00004 	mov	r0, r4
ffff1cd4:	ebffff56 	bl	0xffff1a34
ffff1cd8:	e8bd8010 	pop	{r4, pc}

ffff1cdc:	e92d4010 	push	{r4, lr}
ffff1ce0:	ebffffdf 	bl	0xffff1c64
ffff1ce4:	ebffff5c 	bl	0xffff1a5c
ffff1ce8:	ebffffa9 	bl	0xffff1b94
ffff1cec:	e8bd8010 	pop	{r4, pc}

ffff1cf0:	e92d4010 	push	{r4, lr}
ffff1cf4:	ebffffe3 	bl	0xffff1c88
ffff1cf8:	e8bd8010 	pop	{r4, pc}

ffff1cfc:	e3a01012 	mov	r1, #18
ffff1d00:	e5c01000 	strb	r1, [r0]
ffff1d04:	e3a01001 	mov	r1, #1
ffff1d08:	e5c01001 	strb	r1, [r0, #1]
ffff1d0c:	e3001110 	movw	r1, #272	; 0x110
ffff1d10:	e1c010b2 	strh	r1, [r0, #2]
ffff1d14:	e3a01000 	mov	r1, #0
ffff1d18:	e5c01004 	strb	r1, [r0, #4]
ffff1d1c:	e5c01005 	strb	r1, [r0, #5]
ffff1d20:	e5c01006 	strb	r1, [r0, #6]
ffff1d24:	e3a01040 	mov	r1, #64	; 0x40
ffff1d28:	e5c01007 	strb	r1, [r0, #7]
ffff1d2c:	e3011f3a 	movw	r1, #7994	; 0x1f3a
ffff1d30:	e1c010b8 	strh	r1, [r0, #8]
ffff1d34:	e30e1fe8 	movw	r1, #61416	; 0xefe8
ffff1d38:	e1c010ba 	strh	r1, [r0, #10]
ffff1d3c:	e30012b3 	movw	r1, #691	; 0x2b3
ffff1d40:	e1c010bc 	strh	r1, [r0, #12]
ffff1d44:	e3a01000 	mov	r1, #0
ffff1d48:	e5c0100e 	strb	r1, [r0, #14]
ffff1d4c:	e5c0100f 	strb	r1, [r0, #15]
ffff1d50:	e5c01010 	strb	r1, [r0, #16]
ffff1d54:	e3a01001 	mov	r1, #1
ffff1d58:	e5c01011 	strb	r1, [r0, #17]
ffff1d5c:	e12fff1e 	bx	lr
ffff1d60:	e3a0100a 	mov	r1, #10
ffff1d64:	e5c01000 	strb	r1, [r0]
ffff1d68:	e3a01002 	mov	r1, #2
ffff1d6c:	e5c01001 	strb	r1, [r0, #1]
ffff1d70:	e3a01020 	mov	r1, #32
ffff1d74:	e1c010b2 	strh	r1, [r0, #2]
ffff1d78:	e3a01001 	mov	r1, #1
ffff1d7c:	e5c01004 	strb	r1, [r0, #4]
ffff1d80:	e5c01005 	strb	r1, [r0, #5]
ffff1d84:	e3a01000 	mov	r1, #0
ffff1d88:	e5c01006 	strb	r1, [r0, #6]
ffff1d8c:	e3a01080 	mov	r1, #128	; 0x80
ffff1d90:	e5c01007 	strb	r1, [r0, #7]
ffff1d94:	e3a01096 	mov	r1, #150	; 0x96
ffff1d98:	e5c01008 	strb	r1, [r0, #8]
ffff1d9c:	e12fff1e 	bx	lr
ffff1da0:	e3a01009 	mov	r1, #9
ffff1da4:	e5c01000 	strb	r1, [r0]
ffff1da8:	e3a01004 	mov	r1, #4
ffff1dac:	e5c01001 	strb	r1, [r0, #1]
ffff1db0:	e3a01000 	mov	r1, #0
ffff1db4:	e5c01002 	strb	r1, [r0, #2]
ffff1db8:	e5c01003 	strb	r1, [r0, #3]
ffff1dbc:	e3a01002 	mov	r1, #2
ffff1dc0:	e5c01004 	strb	r1, [r0, #4]
ffff1dc4:	e3a010ff 	mov	r1, #255	; 0xff
ffff1dc8:	e5c01005 	strb	r1, [r0, #5]
ffff1dcc:	e5c01006 	strb	r1, [r0, #6]
ffff1dd0:	e5c01007 	strb	r1, [r0, #7]
ffff1dd4:	e3a01000 	mov	r1, #0
ffff1dd8:	e5c01008 	strb	r1, [r0, #8]
ffff1ddc:	e12fff1e 	bx	lr
ffff1de0:	e3a01007 	mov	r1, #7
ffff1de4:	e5c01000 	strb	r1, [r0]
ffff1de8:	e3a01005 	mov	r1, #5
ffff1dec:	e5c01001 	strb	r1, [r0, #1]
ffff1df0:	e3a01040 	mov	r1, #64	; 0x40
ffff1df4:	e1c010b4 	strh	r1, [r0, #4]
ffff1df8:	e3a01001 	mov	r1, #1
ffff1dfc:	e5c01002 	strb	r1, [r0, #2]
ffff1e00:	e3a01002 	mov	r1, #2
ffff1e04:	e5c01003 	strb	r1, [r0, #3]
ffff1e08:	e3a01000 	mov	r1, #0
ffff1e0c:	e5c01006 	strb	r1, [r0, #6]
ffff1e10:	e12fff1e 	bx	lr
ffff1e14:	e3a01007 	mov	r1, #7
ffff1e18:	e5c01000 	strb	r1, [r0]
ffff1e1c:	e3a01005 	mov	r1, #5
ffff1e20:	e5c01001 	strb	r1, [r0, #1]
ffff1e24:	e3a01040 	mov	r1, #64	; 0x40
ffff1e28:	e1c010b4 	strh	r1, [r0, #4]
ffff1e2c:	e3a01082 	mov	r1, #130	; 0x82
ffff1e30:	e5c01002 	strb	r1, [r0, #2]
ffff1e34:	e3a01002 	mov	r1, #2
ffff1e38:	e5c01003 	strb	r1, [r0, #3]
ffff1e3c:	e3a01000 	mov	r1, #0
ffff1e40:	e5c01006 	strb	r1, [r0, #6]
ffff1e44:	e12fff1e 	bx	lr
ffff1e48:	e5802000 	str	r2, [r0]
ffff1e4c:	e5801004 	str	r1, [r0, #4]
ffff1e50:	e12fff1e 	bx	lr
ffff1e54:	e12fff1e 	bx	lr
ffff1e58:	e12fff1e 	bx	lr
ffff1e5c:	e12fff1e 	bx	lr

ffff1e60:	e92d4010 	push	{r4, lr}
ffff1e64:	e3a03000 	mov	r3, #0
ffff1e68:	e5c03005 	strb	r3, [r0, #5]
ffff1e6c:	e5c03006 	strb	r3, [r0, #6]
ffff1e70:	e5803000 	str	r3, [r0]
ffff1e74:	e5c03004 	strb	r3, [r0, #4]
ffff1e78:	e3a03040 	mov	r3, #64	; 0x40
ffff1e7c:	e5803008 	str	r3, [r0, #8]
ffff1e80:	e3a03000 	mov	r3, #0
ffff1e84:	e580300c 	str	r3, [r0, #12]
ffff1e88:	e5d13002 	ldrb	r3, [r1, #2]
ffff1e8c:	e5c03015 	strb	r3, [r0, #21]
ffff1e90:	e5d13003 	ldrb	r3, [r1, #3]
ffff1e94:	e5c03016 	strb	r3, [r0, #22]
ffff1e98:	e5801010 	str	r1, [r0, #16]
ffff1e9c:	e3a03001 	mov	r3, #1
ffff1ea0:	e5c03014 	strb	r3, [r0, #20]
ffff1ea4:	e1d130b4 	ldrh	r3, [r1, #4]
ffff1ea8:	e5803018 	str	r3, [r0, #24]
ffff1eac:	e3a03000 	mov	r3, #0
ffff1eb0:	e580301c 	str	r3, [r0, #28]
ffff1eb4:	e5d23002 	ldrb	r3, [r2, #2]
ffff1eb8:	e5c03025 	strb	r3, [r0, #37]	; 0x25
ffff1ebc:	e5d23003 	ldrb	r3, [r2, #3]
ffff1ec0:	e5c03026 	strb	r3, [r0, #38]	; 0x26
ffff1ec4:	e5802020 	str	r2, [r0, #32]
ffff1ec8:	e3a03002 	mov	r3, #2
ffff1ecc:	e5c03024 	strb	r3, [r0, #36]	; 0x24
ffff1ed0:	e1d230b4 	ldrh	r3, [r2, #4]
ffff1ed4:	e5803028 	str	r3, [r0, #40]	; 0x28
ffff1ed8:	e3a03000 	mov	r3, #0
ffff1edc:	e580302c 	str	r3, [r0, #44]	; 0x2c
ffff1ee0:	e5803030 	str	r3, [r0, #48]	; 0x30
ffff1ee4:	e5c03034 	strb	r3, [r0, #52]	; 0x34
ffff1ee8:	e5803038 	str	r3, [r0, #56]	; 0x38
ffff1eec:	e5c0303c 	strb	r3, [r0, #60]	; 0x3c
ffff1ef0:	e5c0303d 	strb	r3, [r0, #61]	; 0x3d
ffff1ef4:	e8bd8010 	pop	{r4, pc}

ffff1ef8:	e92d4010 	push	{r4, lr}
ffff1efc:	e5801000 	str	r1, [r0]
ffff1f00:	e3a04000 	mov	r4, #0
ffff1f04:	e5c04004 	strb	r4, [r0, #4]
ffff1f08:	e5804008 	str	r4, [r0, #8]
ffff1f0c:	e5802014 	str	r2, [r0, #20]
ffff1f10:	e5804018 	str	r4, [r0, #24]
ffff1f14:	e580300c 	str	r3, [r0, #12]
ffff1f18:	e5804010 	str	r4, [r0, #16]
ffff1f1c:	e8bd8010 	pop	{r4, pc}

ffff1f20:	e5801000 	str	r1, [r0]
ffff1f24:	e3a02000 	mov	r2, #0
ffff1f28:	e5802004 	str	r2, [r0, #4]
ffff1f2c:	e59f280c 	ldr	r2, [pc, #2060]	; 0xffff2740 =0xffff0890
ffff1f30:	e580200c 	str	r2, [r0, #12]
ffff1f34:	e3a02000 	mov	r2, #0
ffff1f38:	e5802010 	str	r2, [r0, #16]
ffff1f3c:	e5c02008 	strb	r2, [r0, #8]
ffff1f40:	e5c02018 	strb	r2, [r0, #24]
ffff1f44:	e5802014 	str	r2, [r0, #20]
ffff1f48:	e12fff1e 	bx	lr
ffff1f4c:	e5801000 	str	r1, [r0]
ffff1f50:	e3a02000 	mov	r2, #0
ffff1f54:	e5802004 	str	r2, [r0, #4]
ffff1f58:	e59f27e4 	ldr	r2, [pc, #2020]	; 0xffff2744 =0xffff08a8
ffff1f5c:	e580200c 	str	r2, [r0, #12]
ffff1f60:	e3a02000 	mov	r2, #0
ffff1f64:	e5802010 	str	r2, [r0, #16]
ffff1f68:	e5c02008 	strb	r2, [r0, #8]
ffff1f6c:	e5c02018 	strb	r2, [r0, #24]
ffff1f70:	e3a02001 	mov	r2, #1
ffff1f74:	e5802014 	str	r2, [r0, #20]
ffff1f78:	e12fff1e 	bx	lr
ffff1f7c:	e5801000 	str	r1, [r0]
ffff1f80:	e3a02000 	mov	r2, #0
ffff1f84:	e5802004 	str	r2, [r0, #4]
ffff1f88:	e59f27b8 	ldr	r2, [pc, #1976]	; 0xffff2748 =0xffff089c
ffff1f8c:	e580200c 	str	r2, [r0, #12]
ffff1f90:	e3a02000 	mov	r2, #0
ffff1f94:	e5802010 	str	r2, [r0, #16]
ffff1f98:	e5c02008 	strb	r2, [r0, #8]
ffff1f9c:	e5c02018 	strb	r2, [r0, #24]
ffff1fa0:	e3a02002 	mov	r2, #2
ffff1fa4:	e5802014 	str	r2, [r0, #20]
ffff1fa8:	e12fff1e 	bx	lr

ffff1fac:	e92d4010 	push	{r4, lr}
ffff1fb0:	e580100c 	str	r1, [r0, #12]
ffff1fb4:	e580201c 	str	r2, [r0, #28]
ffff1fb8:	e580302c 	str	r3, [r0, #44]	; 0x2c
ffff1fbc:	e8bd8010 	pop	{r4, pc}

ffff1fc0:	e3a00000 	mov	r0, #0
ffff1fc4:	e51f1700 	ldr	r1, [pc, #-1792]	; 0xffff18cc =0x01c19000 USB_OTG_BASE
ffff1fc8:	e5d10040 	ldrb	r0, [r1, #64]	; 0x40
ffff1fcc:	e3c00020 	bic	r0, r0, #32
ffff1fd0:	e5c10040 	strb	r0, [r1, #64]	; 0x40
ffff1fd4:	e5d10040 	ldrb	r0, [r1, #64]	; 0x40
ffff1fd8:	e12fff1e 	bx	lr
ffff1fdc:	e3a01000 	mov	r1, #0
ffff1fe0:	e3a02000 	mov	r2, #0
ffff1fe4:	e59f0760 	ldr	r0, [pc, #1888]	; 0xffff274c =0x01c20000 CCU_BASE
ffff1fe8:	e5901000 	ldr	r1, [r0]
ffff1fec:	e59f075c 	ldr	r0, [pc, #1884]	; 0xffff2750 =0x7ffce0ff
ffff1ff0:	e0011000 	and	r1, r1, r0
ffff1ff4:	e3811102 	orr	r1, r1, #-2147483648	; 0x80000000
ffff1ff8:	e3811a01 	orr	r1, r1, #4096	; 0x1000
ffff1ffc:	e59f0748 	ldr	r0, [pc, #1864]	; 0xffff274c =0x01c20000 CCU_BASE
ffff2000:	e5801000 	str	r1, [r0]
ffff2004:	e5901028 	ldr	r1, [r0, #40]	; 0x28
ffff2008:	e3811102 	orr	r1, r1, #-2147483648	; 0x80000000
ffff200c:	e5801028 	str	r1, [r0, #40]	; 0x28
ffff2010:	e30c2350 	movw	r2, #50000	; 0xc350
ffff2014:	e320f000 	nop	{0}
ffff2018:	e1b00002 	movs	r0, r2
ffff201c:	e2422001 	sub	r2, r2, #1
ffff2020:	1afffffc 	bne	0xffff2018

ffff2024:	e59f0720 	ldr	r0, [pc, #1824]	; 0xffff274c =0x01c20000 CCU_BASE
ffff2028:	e5901050 	ldr	r1, [r0, #80]	; 0x50
ffff202c:	e3c11003 	bic	r1, r1, #3
ffff2030:	e3811001 	orr	r1, r1, #1
ffff2034:	e5801050 	str	r1, [r0, #80]	; 0x50
ffff2038:	e30021f4 	movw	r2, #500	; 0x1f4
ffff203c:	e320f000 	nop	{0}
ffff2040:	e1b00002 	movs	r0, r2
ffff2044:	e2422001 	sub	r2, r2, #1
ffff2048:	1afffffc 	bne	0xffff2040

ffff204c:	e59f06f8 	ldr	r0, [pc, #1784]	; 0xffff274c =0x01c20000 CCU_BASE
ffff2050:	e5901050 	ldr	r1, [r0, #80]	; 0x50
ffff2054:	e3c11803 	bic	r1, r1, #196608	; 0x30000
ffff2058:	e3811803 	orr	r1, r1, #196608	; 0x30000
ffff205c:	e5801050 	str	r1, [r0, #80]	; 0x50
ffff2060:	e5901054 	ldr	r1, [r0, #84]	; 0x54
ffff2064:	e3c11e3f 	bic	r1, r1, #1008	; 0x3f0
ffff2068:	e3811e19 	orr	r1, r1, #400	; 0x190
ffff206c:	e5801054 	str	r1, [r0, #84]	; 0x54
ffff2070:	e30021f4 	movw	r2, #500	; 0x1f4
ffff2074:	e320f000 	nop	{0}
ffff2078:	e1b00002 	movs	r0, r2
ffff207c:	e2422001 	sub	r2, r2, #1
ffff2080:	1afffffc 	bne	0xffff2078

ffff2084:	e59f06c0 	ldr	r0, [pc, #1728]	; 0xffff274c =0x01c20000 CCU_BASE
ffff2088:	e5901054 	ldr	r1, [r0, #84]	; 0x54
ffff208c:	e3c11a03 	bic	r1, r1, #12288	; 0x3000
ffff2090:	e3811a03 	orr	r1, r1, #12288	; 0x3000
ffff2094:	e5801054 	str	r1, [r0, #84]	; 0x54
ffff2098:	e12fff1e 	bx	lr
ffff209c:	e3a00000 	mov	r0, #0
ffff20a0:	e59f16ac 	ldr	r1, [pc, #1708]	; 0xffff2754 =0x01c19400 O_HcRevision
ffff20a4:	e5910000 	ldr	r0, [r1]
ffff20a8:	e3800903 	orr	r0, r0, #49152	; 0xc000
ffff20ac:	e5810000 	str	r0, [r1]
ffff20b0:	e12fff1e 	bx	lr
ffff20b4:	e3a00000 	mov	r0, #0
ffff20b8:	e3a01000 	mov	r1, #0
ffff20bc:	e59f2690 	ldr	r2, [pc, #1680]	; 0xffff2754 =0x01c19400 O_HcRevision
ffff20c0:	e5920000 	ldr	r0, [r2]
ffff20c4:	e3800801 	orr	r0, r0, #65536	; 0x10000
ffff20c8:	e5820000 	str	r0, [r2]
ffff20cc:	e30017d0 	movw	r1, #2000	; 0x7d0
ffff20d0:	e320f000 	nop	{0}
ffff20d4:	e1b02001 	movs	r2, r1
ffff20d8:	e2411001 	sub	r1, r1, #1
ffff20dc:	1afffffc 	bne	0xffff20d4

ffff20e0:	e3800b03 	orr	r0, r0, #3072	; 0xc00
ffff20e4:	e59f2668 	ldr	r2, [pc, #1640]	; 0xffff2754 =0x01c19400 O_HcRevision
ffff20e8:	e5820000 	str	r0, [r2]
ffff20ec:	e12fff1e 	bx	lr
ffff20f0:	e3a01000 	mov	r1, #0
ffff20f4:	e59f0658 	ldr	r0, [pc, #1624]	; 0xffff2754 =0x01c19400 O_HcRevision
ffff20f8:	e5900000 	ldr	r0, [r0]
ffff20fc:	e20020ff 	and	r2, r0, #255	; 0xff
ffff2100:	e3120303 	tst	r2, #201326592	; 0xc000000
ffff2104:	1a00000a 	bne	0xffff2134

ffff2108:	e51f0844 	ldr	r0, [pc, #-2116]	; 0xffff18cc =0x01c19000 USB_OTG_BASE
ffff210c:	e5d00041 	ldrb	r0, [r0, #65]	; 0x41
ffff2110:	e2000018 	and	r0, r0, #24
ffff2114:	e3500018 	cmp	r0, #24
ffff2118:	0a000003 	beq	0xffff212c
ffff211c:	e59f0630 	ldr	r0, [pc, #1584]	; 0xffff2754 =0x01c19400 O_HcRevision
ffff2120:	e5901000 	ldr	r1, [r0]
ffff2124:	e3811a03 	orr	r1, r1, #12288	; 0x3000
ffff2128:	e5801000 	str	r1, [r0]
ffff212c:	e3a00001 	mov	r0, #1
ffff2130:	e12fff1e 	bx	lr
ffff2134:	e3a00000 	mov	r0, #0
ffff2138:	eafffffc 	b	0xffff2130
ffff213c:	e3a00000 	mov	r0, #0
ffff2140:	e59f160c 	ldr	r1, [pc, #1548]	; 0xffff2754 =0x01c19400 O_HcRevision
ffff2144:	e5910000 	ldr	r0, [r1]
ffff2148:	e3c00801 	bic	r0, r0, #65536	; 0x10000
ffff214c:	e5810000 	str	r0, [r1]
ffff2150:	e12fff1e 	bx	lr
ffff2154:	e51f0890 	ldr	r0, [pc, #-2192]	; 0xffff18cc =0x01c19000 USB_OTG_BASE
ffff2158:	e5d01041 	ldrb	r1, [r0, #65]	; 0x41
ffff215c:	e2010080 	and	r0, r1, #128	; 0x80
ffff2160:	e3500080 	cmp	r0, #128	; 0x80
ffff2164:	1a000007 	bne	0xffff2188

ffff2168:	e51f08a4 	ldr	r0, [pc, #-2212]	; 0xffff18cc =0x01c19000 USB_OTG_BASE
ffff216c:	e5d02041 	ldrb	r2, [r0, #65]	; 0x41
ffff2170:	e2020018 	and	r0, r2, #24
ffff2174:	e3500018 	cmp	r0, #24
ffff2178:	1a000001 	bne	0xffff2184

ffff217c:	e3a00001 	mov	r0, #1
ffff2180:	e12fff1e 	bx	lr
ffff2184:	e320f000 	nop	{0}
ffff2188:	e3a00000 	mov	r0, #0
ffff218c:	eafffffb 	b	0xffff2180

ffff2190:	e92d4010 	push	{r4, lr}
ffff2194:	ebffffc0 	bl	0xffff209c
ffff2198:	ebffffc5 	bl	0xffff20b4
ffff219c:	ea000009 	b	0xffff21c8
ffff21a0:	ebffffeb 	bl	0xffff2154
ffff21a4:	e1a03000 	mov	r3, r0
ffff21a8:	ebffffd0 	bl	0xffff20f0
ffff21ac:	e1a04000 	mov	r4, r0
ffff21b0:	e3530000 	cmp	r3, #0
ffff21b4:	1a000001 	bne	0xffff21c0

ffff21b8:	e3540000 	cmp	r4, #0
ffff21bc:	0a000000 	beq	0xffff21c4
ffff21c0:	ea000001 	b	0xffff21cc
ffff21c4:	e320f000 	nop	{0}
ffff21c8:	eafffff4 	b	0xffff21a0
ffff21cc:	e320f000 	nop	{0}
ffff21d0:	ebffffd9 	bl	0xffff213c
ffff21d4:	ebffff80 	bl	0xffff1fdc
ffff21d8:	e8bd8010 	pop	{r4, pc}

ffff21dc:	e92d4070 	push	{r4, r5, r6, lr}
ffff21e0:	e1a04000 	mov	r4, r0
ffff21e4:	e3a05000 	mov	r5, #0
ffff21e8:	e3a06000 	mov	r6, #0
ffff21ec:	ebffff73 	bl	0xffff1fc0
ffff21f0:	e59f0560 	ldr	r0, [pc, #1376]	; 0xffff2758 =0x01c19410 O_HcInterruptEnable
ffff21f4:	e3a01000 	mov	r1, #0
ffff21f8:	e5901000 	ldr	r1, [r0]
ffff21fc:	e3c11002 	bic	r1, r1, #2
ffff2200:	e5801000 	str	r1, [r0]
ffff2204:	e3a00001 	mov	r0, #1
ffff2208:	e51f1944 	ldr	r1, [pc, #-2372]	; 0xffff18cc =0x01c19000 USB_OTG_BASE
ffff220c:	e5c10042 	strb	r0, [r1, #66]	; 0x42
ffff2210:	e3a00007 	mov	r0, #7
ffff2214:	e5c10094 	strb	r0, [r1, #148]	; 0x94
ffff2218:	e3a00080 	mov	r0, #128	; 0x80
ffff221c:	e1c109b6 	strh	r0, [r1, #150]	; 0x96
ffff2220:	e3a00002 	mov	r0, #2
ffff2224:	e5c10042 	strb	r0, [r1, #66]	; 0x42
ffff2228:	e3a00007 	mov	r0, #7
ffff222c:	e5c10090 	strb	r0, [r1, #144]	; 0x90
ffff2230:	e3000100 	movw	r0, #256	; 0x100
ffff2234:	e1c109b2 	strh	r0, [r1, #146]	; 0x92
ffff2238:	e3a00007 	mov	r0, #7
ffff223c:	e5c10050 	strb	r0, [r1, #80]	; 0x50
ffff2240:	e1c10000 	bic	r0, r1, r0
ffff2244:	e5d00048 	ldrb	r0, [r0, #72]	; 0x48
ffff2248:	e3800001 	orr	r0, r0, #1
ffff224c:	e5c10048 	strb	r0, [r1, #72]	; 0x48
ffff2250:	e51f0974 	ldr	r0, [pc, #-2420]	; 0xffff18e4 =0x00007d00
ffff2254:	e5900000 	ldr	r0, [r0]
ffff2258:	ebfffd2e 	bl	0xffff1718
ffff225c:	e3a00002 	mov	r0, #2
ffff2260:	e5941024 	ldr	r1, [r4, #36]	; 0x24
ffff2264:	e5c10034 	strb	r0, [r1, #52]	; 0x34
ffff2268:	ebffffc8 	bl	0xffff2190
ffff226c:	e51f09a8 	ldr	r0, [pc, #-2472]	; 0xffff18cc =0x01c19000 USB_OTG_BASE
ffff2270:	e5d00040 	ldrb	r0, [r0, #64]	; 0x40
ffff2274:	e3800040 	orr	r0, r0, #64	; 0x40
ffff2278:	e51f19b4 	ldr	r1, [pc, #-2484]	; 0xffff18cc =0x01c19000 USB_OTG_BASE
ffff227c:	e5c10040 	strb	r0, [r1, #64]	; 0x40
ffff2280:	e8bd8070 	pop	{r4, r5, r6, pc}

ffff2284:	e92d4010 	push	{r4, lr}
ffff2288:	e1a04000 	mov	r4, r0
ffff228c:	e51f09c8 	ldr	r0, [pc, #-2504]	; 0xffff18cc =0x01c19000 USB_OTG_BASE
ffff2290:	e5d00043 	ldrb	r0, [r0, #67]	; 0x43
ffff2294:	e20000fe 	and	r0, r0, #254	; 0xfe
ffff2298:	e51f19d4 	ldr	r1, [pc, #-2516]	; 0xffff18cc =0x01c19000 USB_OTG_BASE
ffff229c:	e5c10043 	strb	r0, [r1, #67]	; 0x43
ffff22a0:	e1a00004 	mov	r0, r4
ffff22a4:	ebffffcc 	bl	0xffff21dc
ffff22a8:	ebfffe90 	bl	0xffff1cf0
ffff22ac:	e1a00004 	mov	r0, r4
ffff22b0:	ebfffaf9 	bl	0xffff0e9c
ffff22b4:	ebfff7b0 	bl	0xffff017c
ffff22b8:	e8bd8010 	pop	{r4, pc}

ffff22bc:	e3a01000 	mov	r1, #0
ffff22c0:	e5801008 	str	r1, [r0, #8]
ffff22c4:	e5801004 	str	r1, [r0, #4]
ffff22c8:	e5801000 	str	r1, [r0]
ffff22cc:	e12fff1e 	bx	lr

ffff22d0:	e92d4010 	push	{r4, lr}
ffff22d4:	e3002100 	movw	r2, #256	; 0x100
ffff22d8:	e3a010cc 	mov	r1, #204	; 0xcc
ffff22dc:	e3070e00 	movw	r0, #32256	; 0x7e00
ffff22e0:	ebfff97d 	bl	0xffff08dc
ffff22e4:	e8bd8010 	pop	{r4, pc}

ffff22e8:	e92d4010 	push	{r4, lr}
ffff22ec:	e24ddd47 	sub	sp, sp, #4544	; 0x11c0
ffff22f0:	ebfffff6 	bl	0xffff22d0
ffff22f4:	e28d0a01 	add	r0, sp, #4096	; 0x1000
ffff22f8:	e2800f5f 	add	r0, r0, #380	; 0x17c
ffff22fc:	e51f1a20 	ldr	r1, [pc, #-2592]	; 0xffff18e4 =0x00007d00
ffff2300:	e5810000 	str	r0, [r1]
ffff2304:	e28d1a01 	add	r1, sp, #4096	; 0x1000
ffff2308:	e2811f5a 	add	r1, r1, #360	; 0x168
ffff230c:	e28d0a01 	add	r0, sp, #4096	; 0x1000
ffff2310:	e580117c 	str	r1, [r0, #380]	; 0x17c
ffff2314:	e28d1a01 	add	r1, sp, #4096	; 0x1000
ffff2318:	e2811f57 	add	r1, r1, #348	; 0x15c
ffff231c:	e28d0a01 	add	r0, sp, #4096	; 0x1000
ffff2320:	e5801180 	str	r1, [r0, #384]	; 0x180
ffff2324:	e28d1a01 	add	r1, sp, #4096	; 0x1000
ffff2328:	e2811e15 	add	r1, r1, #336	; 0x150
ffff232c:	e28d0a01 	add	r0, sp, #4096	; 0x1000
ffff2330:	e5801184 	str	r1, [r0, #388]	; 0x184
ffff2334:	e28d1a01 	add	r1, sp, #4096	; 0x1000
ffff2338:	e2811f52 	add	r1, r1, #328	; 0x148
ffff233c:	e28d0a01 	add	r0, sp, #4096	; 0x1000
ffff2340:	e5801188 	str	r1, [r0, #392]	; 0x188
ffff2344:	e28d1d45 	add	r1, sp, #4416	; 0x1140
ffff2348:	e28d0a01 	add	r0, sp, #4096	; 0x1000
ffff234c:	e580118c 	str	r1, [r0, #396]	; 0x18c
ffff2350:	e28d1a01 	add	r1, sp, #4096	; 0x1000
ffff2354:	e2811f4e 	add	r1, r1, #312	; 0x138
ffff2358:	e28d0a01 	add	r0, sp, #4096	; 0x1000
ffff235c:	e5801190 	str	r1, [r0, #400]	; 0x190
ffff2360:	e28d1a01 	add	r1, sp, #4096	; 0x1000
ffff2364:	e2811e13 	add	r1, r1, #304	; 0x130
ffff2368:	e28d0a01 	add	r0, sp, #4096	; 0x1000
ffff236c:	e5801194 	str	r1, [r0, #404]	; 0x194
ffff2370:	e28d1a01 	add	r1, sp, #4096	; 0x1000
ffff2374:	e2811f4a 	add	r1, r1, #296	; 0x128
ffff2378:	e28d0a01 	add	r0, sp, #4096	; 0x1000
ffff237c:	e5801198 	str	r1, [r0, #408]	; 0x198
ffff2380:	e28d1a01 	add	r1, sp, #4096	; 0x1000
ffff2384:	e2811e12 	add	r1, r1, #288	; 0x120
ffff2388:	e28d0a01 	add	r0, sp, #4096	; 0x1000
ffff238c:	e580119c 	str	r1, [r0, #412]	; 0x19c
ffff2390:	e28d1a01 	add	r1, sp, #4096	; 0x1000
ffff2394:	e28110d8 	add	r1, r1, #216	; 0xd8
ffff2398:	e28d0a01 	add	r0, sp, #4096	; 0x1000
ffff239c:	e58011a0 	str	r1, [r0, #416]	; 0x1a0
ffff23a0:	e28d1a01 	add	r1, sp, #4096	; 0x1000
ffff23a4:	e28110bc 	add	r1, r1, #188	; 0xbc
ffff23a8:	e28d0a01 	add	r0, sp, #4096	; 0x1000
ffff23ac:	e58011a4 	str	r1, [r0, #420]	; 0x1a4
ffff23b0:	e28d1a01 	add	r1, sp, #4096	; 0x1000
ffff23b4:	e28110a0 	add	r1, r1, #160	; 0xa0
ffff23b8:	e28d0a01 	add	r0, sp, #4096	; 0x1000
ffff23bc:	e58011a8 	str	r1, [r0, #424]	; 0x1a8
ffff23c0:	e28d1a01 	add	r1, sp, #4096	; 0x1000
ffff23c4:	e2811084 	add	r1, r1, #132	; 0x84
ffff23c8:	e28d0a01 	add	r0, sp, #4096	; 0x1000
ffff23cc:	e58011ac 	str	r1, [r0, #428]	; 0x1ac
ffff23d0:	e28d1a01 	add	r1, sp, #4096	; 0x1000
ffff23d4:	e2811068 	add	r1, r1, #104	; 0x68
ffff23d8:	e28d0a01 	add	r0, sp, #4096	; 0x1000
ffff23dc:	e58011b0 	str	r1, [r0, #432]	; 0x1b0
ffff23e0:	e28d0a01 	add	r0, sp, #4096	; 0x1000
ffff23e4:	e2800f6d 	add	r0, r0, #436	; 0x1b4
ffff23e8:	ebffffb3 	bl	0xffff22bc
ffff23ec:	ebfffe3a 	bl	0xffff1cdc
ffff23f0:	e28d0a01 	add	r0, sp, #4096	; 0x1000
ffff23f4:	e2800f5a 	add	r0, r0, #360	; 0x168
ffff23f8:	ebfffe3f 	bl	0xffff1cfc
ffff23fc:	e28d0a01 	add	r0, sp, #4096	; 0x1000
ffff2400:	e2800f57 	add	r0, r0, #348	; 0x15c
ffff2404:	ebfffe55 	bl	0xffff1d60
ffff2408:	e28d0a01 	add	r0, sp, #4096	; 0x1000
ffff240c:	e2800e15 	add	r0, r0, #336	; 0x150
ffff2410:	ebfffe62 	bl	0xffff1da0
ffff2414:	e28d0a01 	add	r0, sp, #4096	; 0x1000
ffff2418:	e2800f52 	add	r0, r0, #328	; 0x148
ffff241c:	ebfffe6f 	bl	0xffff1de0
ffff2420:	e28d0d45 	add	r0, sp, #4416	; 0x1140
ffff2424:	ebfffe7a 	bl	0xffff1e14
ffff2428:	e28d2a01 	add	r2, sp, #4096	; 0x1000
ffff242c:	e2822f52 	add	r2, r2, #328	; 0x148
ffff2430:	e28d1d45 	add	r1, sp, #4416	; 0x1140
ffff2434:	e28d0a01 	add	r0, sp, #4096	; 0x1000
ffff2438:	e2800f4e 	add	r0, r0, #312	; 0x138
ffff243c:	ebfffe81 	bl	0xffff1e48
ffff2440:	e28d0a01 	add	r0, sp, #4096	; 0x1000
ffff2444:	e2800e13 	add	r0, r0, #304	; 0x130
ffff2448:	ebfffe81 	bl	0xffff1e54
ffff244c:	e28d0a01 	add	r0, sp, #4096	; 0x1000
ffff2450:	e2800f4a 	add	r0, r0, #296	; 0x128
ffff2454:	ebfffe7f 	bl	0xffff1e58
ffff2458:	e28d2a01 	add	r2, sp, #4096	; 0x1000
ffff245c:	e2822e13 	add	r2, r2, #304	; 0x130
ffff2460:	e28d1a01 	add	r1, sp, #4096	; 0x1000
ffff2464:	e2811f4a 	add	r1, r1, #296	; 0x128
ffff2468:	e28d0a01 	add	r0, sp, #4096	; 0x1000
ffff246c:	e2800e12 	add	r0, r0, #288	; 0x120
ffff2470:	ebfffe79 	bl	0xffff1e5c
ffff2474:	e28d2d45 	add	r2, sp, #4416	; 0x1140
ffff2478:	e28d1a01 	add	r1, sp, #4096	; 0x1000
ffff247c:	e2811f52 	add	r1, r1, #328	; 0x148
ffff2480:	e28d0a01 	add	r0, sp, #4096	; 0x1000
ffff2484:	e28000d8 	add	r0, r0, #216	; 0xd8
ffff2488:	ebfffe74 	bl	0xffff1e60
ffff248c:	e28d3a01 	add	r3, sp, #4096	; 0x1000
ffff2490:	e2833084 	add	r3, r3, #132	; 0x84
ffff2494:	e28d2a01 	add	r2, sp, #4096	; 0x1000
ffff2498:	e2822068 	add	r2, r2, #104	; 0x68
ffff249c:	e28d1068 	add	r1, sp, #104	; 0x68
ffff24a0:	e28d0a01 	add	r0, sp, #4096	; 0x1000
ffff24a4:	e28000bc 	add	r0, r0, #188	; 0xbc
ffff24a8:	ebfffe92 	bl	0xffff1ef8
ffff24ac:	e28d1024 	add	r1, sp, #36	; 0x24
ffff24b0:	e28d0a01 	add	r0, sp, #4096	; 0x1000
ffff24b4:	e28000a0 	add	r0, r0, #160	; 0xa0
ffff24b8:	ebfffe98 	bl	0xffff1f20
ffff24bc:	e28d1068 	add	r1, sp, #104	; 0x68
ffff24c0:	e28d0a01 	add	r0, sp, #4096	; 0x1000
ffff24c4:	e2800084 	add	r0, r0, #132	; 0x84
ffff24c8:	ebfffeab 	bl	0xffff1f7c
ffff24cc:	e28d1068 	add	r1, sp, #104	; 0x68
ffff24d0:	e28d0a01 	add	r0, sp, #4096	; 0x1000
ffff24d4:	e2800068 	add	r0, r0, #104	; 0x68
ffff24d8:	ebfffe9b 	bl	0xffff1f4c
ffff24dc:	e28d1a01 	add	r1, sp, #4096	; 0x1000
ffff24e0:	e28d3a01 	add	r3, sp, #4096	; 0x1000
ffff24e4:	e2833084 	add	r3, r3, #132	; 0x84
ffff24e8:	e28d2a01 	add	r2, sp, #4096	; 0x1000
ffff24ec:	e2822068 	add	r2, r2, #104	; 0x68
ffff24f0:	e59101a0 	ldr	r0, [r1, #416]	; 0x1a0
ffff24f4:	e28d1a01 	add	r1, sp, #4096	; 0x1000
ffff24f8:	e28110a0 	add	r1, r1, #160	; 0xa0
ffff24fc:	ebfffeaa 	bl	0xffff1fac
ffff2500:	e28d0a01 	add	r0, sp, #4096	; 0x1000
ffff2504:	e2800f5f 	add	r0, r0, #380	; 0x17c
ffff2508:	ebfffa68 	bl	0xffff0eb0
ffff250c:	e28d0a01 	add	r0, sp, #4096	; 0x1000
ffff2510:	e2800f5f 	add	r0, r0, #380	; 0x17c
ffff2514:	ebffff5a 	bl	0xffff2284
ffff2518:	e28d0a01 	add	r0, sp, #4096	; 0x1000
ffff251c:	e2800f5f 	add	r0, r0, #380	; 0x17c
ffff2520:	ebfff8d2 	bl	0xffff0870
ffff2524:	e28ddd47 	add	sp, sp, #4544	; 0x11c0
ffff2528:	e8bd8010 	pop	{r4, pc}

ffff252c:	e92d4070 	push	{r4, r5, r6, lr}
ffff2530:	e1a04000 	mov	r4, r0
ffff2534:	e3a06000 	mov	r6, #0
ffff2538:	e3045e20 	movw	r5, #20000	; 0x4e20
ffff253c:	e5940024 	ldr	r0, [r4, #36]	; 0x24
ffff2540:	e2806020 	add	r6, r0, #32
ffff2544:	e5d60004 	ldrb	r0, [r6, #4]
ffff2548:	ebfffa02 	bl	0xffff0d58
ffff254c:	ea00000a 	b	0xffff257c
ffff2550:	e51f0c8c 	ldr	r0, [pc, #-3212]	; 0xffff18cc =0x01c19000 USB_OTG_BASE
ffff2554:	e1d008b2 	ldrh	r0, [r0, #130]	; 0x82
ffff2558:	e3100001 	tst	r0, #1
ffff255c:	1a000001 	bne	0xffff2568

ffff2560:	e3a00001 	mov	r0, #1
ffff2564:	e8bd8070 	pop	{r4, r5, r6, pc}

ffff2568:	e3550000 	cmp	r5, #0
ffff256c:	1a000001 	bne	0xffff2578

ffff2570:	e3a00002 	mov	r0, #2
ffff2574:	eafffffa 	b	0xffff2564
ffff2578:	e2455001 	sub	r5, r5, #1
ffff257c:	eafffff3 	b	0xffff2550

ffff2580:	e92d40f0 	push	{r4, r5, r6, r7, lr}
ffff2584:	e1a04000 	mov	r4, r0
ffff2588:	e3a05000 	mov	r5, #0
ffff258c:	e5926004 	ldr	r6, [r2, #4]
ffff2590:	e5927010 	ldr	r7, [r2, #16]
ffff2594:	e0466007 	sub	r6, r6, r7
ffff2598:	e1560003 	cmp	r6, r3
ffff259c:	2a000003 	bcs	0xffff25b0
ffff25a0:	e5926004 	ldr	r6, [r2, #4]
ffff25a4:	e5927010 	ldr	r7, [r2, #16]
ffff25a8:	e0466007 	sub	r6, r6, r7
ffff25ac:	ea000000 	b	0xffff25b4
ffff25b0:	e1a06003 	mov	r6, r3
ffff25b4:	e1a00006 	mov	r0, r6
ffff25b8:	e5926010 	ldr	r6, [r2, #16]
ffff25bc:	e0866000 	add	r6, r6, r0
ffff25c0:	e5826010 	str	r6, [r2, #16]
ffff25c4:	e1a03000 	mov	r3, r0
ffff25c8:	e3530004 	cmp	r3, #4
ffff25cc:	9a00000a 	bls	0xffff25fc
ffff25d0:	ea000005 	b	0xffff25ec
ffff25d4:	e5d46000 	ldrb	r6, [r4]
ffff25d8:	e5c16000 	strb	r6, [r1]
ffff25dc:	e3550008 	cmp	r5, #8
ffff25e0:	2a000000 	bcs	0xffff25e8
ffff25e4:	e2855001 	add	r5, r5, #1
ffff25e8:	e2811001 	add	r1, r1, #1
ffff25ec:	e1b06003 	movs	r6, r3
ffff25f0:	e2433001 	sub	r3, r3, #1
ffff25f4:	1afffff6 	bne	0xffff25d4

ffff25f8:	ea000013 	b	0xffff264c
ffff25fc:	e1a06001 	mov	r6, r1
ffff2600:	e1a0c001 	mov	ip, r1
ffff2604:	e3530004 	cmp	r3, #4
ffff2608:	1a000002 	bne	0xffff2618

ffff260c:	e5947000 	ldr	r7, [r4]
ffff2610:	e5867000 	str	r7, [r6]
ffff2614:	ea00000b 	b	0xffff2648
ffff2618:	e3530002 	cmp	r3, #2
ffff261c:	1a000002 	bne	0xffff262c

ffff2620:	e1d470b0 	ldrh	r7, [r4]
ffff2624:	e1cc70b0 	strh	r7, [ip]
ffff2628:	ea000006 	b	0xffff2648
ffff262c:	ea000002 	b	0xffff263c
ffff2630:	e5d47000 	ldrb	r7, [r4]
ffff2634:	e5c17000 	strb	r7, [r1]
ffff2638:	e2811001 	add	r1, r1, #1
ffff263c:	e1b07003 	movs	r7, r3
ffff2640:	e2433001 	sub	r3, r3, #1
ffff2644:	1afffff9 	bne	0xffff2630

ffff2648:	e320f000 	nop	{0}
ffff264c:	e8bd80f0 	pop	{r4, r5, r6, r7, pc}

ffff2650:	e1a01000 	mov	r1, r0
ffff2654:	e5910040 	ldr	r0, [r1, #64]	; 0x40
ffff2658:	e3500000 	cmp	r0, #0
ffff265c:	1a000002 	bne	0xffff266c

ffff2660:	e51f0d9c 	ldr	r0, [pc, #-3484]	; 0xffff18cc =0x01c19000 USB_OTG_BASE
ffff2664:	e5d0004c 	ldrb	r0, [r0, #76]	; 0x4c
ffff2668:	e5810040 	str	r0, [r1, #64]	; 0x40
ffff266c:	e5910040 	ldr	r0, [r1, #64]	; 0x40
ffff2670:	e12fff1e 	bx	lr

ffff2674:	e92d4070 	push	{r4, r5, r6, lr}
ffff2678:	e1a03000 	mov	r3, r0
ffff267c:	e3a00000 	mov	r0, #0
ffff2680:	e5915000 	ldr	r5, [r1]
ffff2684:	e5916010 	ldr	r6, [r1, #16]
ffff2688:	e0854006 	add	r4, r5, r6
ffff268c:	e5915004 	ldr	r5, [r1, #4]
ffff2690:	e5916010 	ldr	r6, [r1, #16]
ffff2694:	e0455006 	sub	r5, r5, r6
ffff2698:	e1550002 	cmp	r5, r2
ffff269c:	2a000003 	bcs	0xffff26b0
ffff26a0:	e5915004 	ldr	r5, [r1, #4]
ffff26a4:	e5916010 	ldr	r6, [r1, #16]
ffff26a8:	e045c006 	sub	ip, r5, r6
ffff26ac:	ea000000 	b	0xffff26b4
ffff26b0:	e1a0c002 	mov	ip, r2
ffff26b4:	e1a0000c 	mov	r0, ip
ffff26b8:	e5915010 	ldr	r5, [r1, #16]
ffff26bc:	e0855000 	add	r5, r5, r0
ffff26c0:	e5815010 	str	r5, [r1, #16]
ffff26c4:	e1a02000 	mov	r2, r0
ffff26c8:	ea000001 	b	0xffff26d4
ffff26cc:	e4d45001 	ldrb	r5, [r4], #1
ffff26d0:	e5c35000 	strb	r5, [r3]
ffff26d4:	e1b05002 	movs	r5, r2
ffff26d8:	e2422001 	sub	r2, r2, #1
ffff26dc:	1afffffa 	bne	0xffff26cc

ffff26e0:	e8bd8070 	pop	{r4, r5, r6, pc}

ffff26e4:	e1a02000 	mov	r2, r0
ffff26e8:	e5920038 	ldr	r0, [r2, #56]	; 0x38
ffff26ec:	e1c00001 	bic	r0, r0, r1
ffff26f0:	e5820038 	str	r0, [r2, #56]	; 0x38
ffff26f4:	e51f0e30 	ldr	r0, [pc, #-3632]	; 0xffff18cc =0x01c19000 USB_OTG_BASE
ffff26f8:	e5c01044 	strb	r1, [r0, #68]	; 0x44
ffff26fc:	e3a00000 	mov	r0, #0
ffff2700:	e12fff1e 	bx	lr

ffff2704:	e1a02000 	mov	r2, r0
ffff2708:	e5920040 	ldr	r0, [r2, #64]	; 0x40
ffff270c:	e1c00001 	bic	r0, r0, r1
ffff2710:	e5820040 	str	r0, [r2, #64]	; 0x40
ffff2714:	e51f0e50 	ldr	r0, [pc, #-3664]	; 0xffff18cc =0x01c19000 USB_OTG_BASE
ffff2718:	e5c0104c 	strb	r1, [r0, #76]	; 0x4c
ffff271c:	e3a00000 	mov	r0, #0
ffff2720:	e12fff1e 	bx	lr

	;; Global Offset Table
ffff2724:	01010101
ffff2728:	01c81000					; GIC_DIST
ffff272c:	a0a0a0a0
ffff2730:	01c81420
ffff2734:	01c81820
ffff2738:	01c82000
ffff273c:	01c81410
ffff2740:	ffff0890
ffff2744:	ffff08a8
ffff2748:	ffff089c
ffff274c:	01c20000					; CCU_BASE
ffff2750:	7ffce0ff
ffff2754:	01c19400					; O_HcRevision
ffff2758:	01c19410					; O_HcInterruptEnable

ffff275c:	e92d4001 	push	{r0, lr}
ffff2760:	ebffffff 	bl	0xffff2764
ffff2764:	ebffffff 	bl	0xffff2768
ffff2768:	ebffffff 	bl	0xffff276c
ffff276c:	ebffffff 	bl	0xffff2770
ffff2770:	ebffffff 	bl	0xffff2774
ffff2774:	ebffffff 	bl	0xffff2778
ffff2778:	ebffffff 	bl	0xffff277c
ffff277c:	ebffffff 	bl	0xffff2780
ffff2780:	ee110f10 	mrc	15, 0, r0, cr1, cr0, {0}
ffff2784:	e3800b02 	orr	r0, r0, #2048	; 0x800
ffff2788:	ee010f10 	mcr	15, 0, r0, cr1, cr0, {0}
ffff278c:	e8bd4001 	pop	{r0, lr}

ffff2790:	e1a0f00e 	mov	pc, lr

ffff2794:	e92d4001 	push	{r0, lr}
ffff2798:	ee110f10 	mrc	15, 0, r0, cr1, cr0, {0}
ffff279c:	e3800a01 	orr	r0, r0, #4096	; 0x1000
ffff27a0:	ee010f10 	mcr	15, 0, r0, cr1, cr0, {0}
ffff27a4:	e8bd4001 	pop	{r0, lr}

ffff27a8:	e1a0f00e 	mov	pc, lr

ffff27ac:	e92d4001 	push	{r0, lr}
ffff27b0:	ee110f10 	mrc	15, 0, r0, cr1, cr0, {0}
ffff27b4:	e3800004 	orr	r0, r0, #4
ffff27b8:	ee010f10 	mcr	15, 0, r0, cr1, cr0, {0}
ffff27bc:	e8bd4001 	pop	{r0, lr}

ffff27c0:	e1a0f00e 	mov	pc, lr

ffff27c4:	e92d4001 	push	{r0, lr}
ffff27c8:	ee110f30 	mrc	15, 0, r0, cr1, cr0, {1}
ffff27cc:	e3800002 	orr	r0, r0, #2
ffff27d0:	ee010f30 	mcr	15, 0, r0, cr1, cr0, {1}
ffff27d4:	e8bd4001 	pop	{r0, lr}

ffff27d8:	e1a0f00e 	mov	pc, lr

ffff27dc:	e92d4001 	push	{r0, lr}
ffff27e0:	ee110f10 	mrc	15, 0, r0, cr1, cr0, {0}
ffff27e4:	e3800001 	orr	r0, r0, #1
ffff27e8:	ee010f10 	mcr	15, 0, r0, cr1, cr0, {0}
ffff27ec:	e8bd4001 	pop	{r0, lr}

ffff27f0:	e1a0f00e 	mov	pc, lr

ffff27f4:	e92d4001 	push	{r0, lr}
ffff27f8:	ee110f30 	mrc	15, 0, r0, cr1, cr0, {1}
ffff27fc:	e3c00002 	bic	r0, r0, #2
ffff2800:	ee010f30 	mcr	15, 0, r0, cr1, cr0, {1}
ffff2804:	ee110f10 	mrc	15, 0, r0, cr1, cr0, {0}
ffff2808:	e3c00001 	bic	r0, r0, #1
ffff280c:	e3c00b02 	bic	r0, r0, #2048	; 0x800
ffff2810:	e3c00a01 	bic	r0, r0, #4096	; 0x1000
ffff2814:	e3c00004 	bic	r0, r0, #4
ffff2818:	ee010f10 	mcr	15, 0, r0, cr1, cr0, {0}
ffff281c:	e8bd4001 	pop	{r0, lr}

ffff2820:	e1a0f00e 	mov	pc, lr

ffff2824:	e92d5fff 	push	{r0, r1, r2, r3, r4, r5, r6, r7, r8, r9, sl, fp, ip, lr}
ffff2828:	ee300f30 	mrc	15, 1, r0, cr0, cr0, {1}
ffff282c:	e2103407 	ands	r3, r0, #117440512	; 0x7000000
ffff2830:	e1a03ba3 	lsr	r3, r3, #23
ffff2834:	0a00001a 	beq	0xffff28a4
ffff2838:	e3a0a000 	mov	sl, #0
ffff283c:	e08a20aa 	add	r2, sl, sl, lsr #1
ffff2840:	e1a01230 	lsr	r1, r0, r2
ffff2844:	e2011007 	and	r1, r1, #7
ffff2848:	e3510002 	cmp	r1, #2
ffff284c:	ba000011 	blt	0xffff2898
ffff2850:	ee40af10 	mcr	15, 2, sl, cr0, cr0, {0}
ffff2854:	f57ff06f 	isb	sy
ffff2858:	ee301f10 	mrc	15, 1, r1, cr0, cr0, {0}
ffff285c:	e2012007 	and	r2, r1, #7
ffff2860:	e2822004 	add	r2, r2, #4
ffff2864:	e30043ff 	movw	r4, #1023	; 0x3ff
ffff2868:	e01441a1 	ands	r4, r4, r1, lsr #3
ffff286c:	e16f5f14 	clz	r5, r4
ffff2870:	e3077fff 	movw	r7, #32767	; 0x7fff
ffff2874:	e01776a1 	ands	r7, r7, r1, lsr #13
ffff2878:	e1a09004 	mov	r9, r4
ffff287c:	e18ab519 	orr	fp, sl, r9, lsl r5
ffff2880:	e18bb217 	orr	fp, fp, r7, lsl r2
ffff2884:	ee07bf5e 	mcr	15, 0, fp, cr7, cr14, {2}
ffff2888:	e2599001 	subs	r9, r9, #1
ffff288c:	aafffffa 	bge	0xffff287c
ffff2890:	e2577001 	subs	r7, r7, #1
ffff2894:	aafffff7 	bge	0xffff2878
ffff2898:	e28aa002 	add	sl, sl, #2
ffff289c:	e153000a 	cmp	r3, sl
ffff28a0:	caffffe5 	bgt	0xffff283c
ffff28a4:	e3a0a000 	mov	sl, #0
ffff28a8:	ee40af10 	mcr	15, 2, sl, cr0, cr0, {0}
ffff28ac:	f57ff06f 	isb	sy
ffff28b0:	e8bd5fff 	pop	{r0, r1, r2, r3, r4, r5, r6, r7, r8, r9, sl, fp, ip, lr}

ffff28b4:	e1a0f00e 	mov	pc, lr

ffff28b8:	e92d0003 	push	{r0, r1}
ffff28bc:	e3a00000 	mov	r0, #0
ffff28c0:	ee070f15 	mcr	15, 0, r0, cr7, cr5, {0}
ffff28c4:	e8bd0003 	pop	{r0, r1}

ffff28c8:	e1a0f00e 	mov	pc, lr

ffff28cc:	e92d4001 	push	{r0, lr}
ffff28d0:	ebfffff8 	bl	0xffff28b8
ffff28d4:	ebffffd2 	bl	0xffff2824
ffff28d8:	e8bd4001 	pop	{r0, lr}

ffff28dc:	e1a0f00e 	mov	pc, lr

ffff28e0:	e92d5fff 	push	{r0, r1, r2, r3, r4, r5, r6, r7, r8, r9, sl, fp, ip, lr}
ffff28e4:	e3a02040 	mov	r2, #64	; 0x40
ffff28e8:	e2423001 	sub	r3, r2, #1
ffff28ec:	e1c00003 	bic	r0, r0, r3
ffff28f0:	ee070f3b 	mcr	15, 0, r0, cr7, cr11, {1}
ffff28f4:	f57ff04f 	dsb	sy
ffff28f8:	ee070f35 	mcr	15, 0, r0, cr7, cr5, {1}
ffff28fc:	e0800002 	add	r0, r0, r2
ffff2900:	e1500001 	cmp	r0, r1
ffff2904:	3afffff9 	bcc	0xffff28f0
ffff2908:	e3a00000 	mov	r0, #0
ffff290c:	ee070fd5 	mcr	15, 0, r0, cr7, cr5, {6}
ffff2910:	f57ff04f 	dsb	sy
ffff2914:	f57ff06f 	isb	sy
ffff2918:	e8bd5fff 	pop	{r0, r1, r2, r3, r4, r5, r6, r7, r8, r9, sl, fp, ip, lr}

ffff291c:	e1a0f00e 	mov	pc, lr

ffff2920:	e92d5fff 	push	{r0, r1, r2, r3, r4, r5, r6, r7, r8, r9, sl, fp, ip, lr}
ffff2924:	e3a02040 	mov	r2, #64	; 0x40
ffff2928:	e2423001 	sub	r3, r2, #1
ffff292c:	e1c00003 	bic	r0, r0, r3
ffff2930:	ee070f3e 	mcr	15, 0, r0, cr7, cr14, {1}
ffff2934:	e0800002 	add	r0, r0, r2
ffff2938:	e1500001 	cmp	r0, r1
ffff293c:	3afffffb 	bcc	0xffff2930
ffff2940:	f57ff04f 	dsb	sy
ffff2944:	e8bd5fff 	pop	{r0, r1, r2, r3, r4, r5, r6, r7, r8, r9, sl, fp, ip, lr}

ffff2948:	e1a0f00e 	mov	pc, lr

ffff294c:	e92d5fff 	push	{r0, r1, r2, r3, r4, r5, r6, r7, r8, r9, sl, fp, ip, lr}
ffff2950:	e3a02040 	mov	r2, #64	; 0x40
ffff2954:	e2423001 	sub	r3, r2, #1
ffff2958:	e1c00003 	bic	r0, r0, r3
ffff295c:	ee070f3a 	mcr	15, 0, r0, cr7, cr10, {1}
ffff2960:	e0800002 	add	r0, r0, r2
ffff2964:	e1500001 	cmp	r0, r1
ffff2968:	3afffffb 	bcc	0xffff295c
ffff296c:	f57ff04f 	dsb	sy
ffff2970:	e8bd5fff 	pop	{r0, r1, r2, r3, r4, r5, r6, r7, r8, r9, sl, fp, ip, lr}

ffff2974:	e1a0f00e 	mov	pc, lr

ffff2978:	e92d5fff 	push	{r0, r1, r2, r3, r4, r5, r6, r7, r8, r9, sl, fp, ip, lr}
ffff297c:	e3a02040 	mov	r2, #64	; 0x40
ffff2980:	e2423001 	sub	r3, r2, #1
ffff2984:	e1100003 	tst	r0, r3
ffff2988:	e1c00003 	bic	r0, r0, r3
ffff298c:	1e070f3e 	mcrne	15, 0, r0, cr7, cr14, {1}
ffff2990:	e1110003 	tst	r1, r3
ffff2994:	e1c11003 	bic	r1, r1, r3
ffff2998:	1e071f3e 	mcrne	15, 0, r1, cr7, cr14, {1}
ffff299c:	ee070f36 	mcr	15, 0, r0, cr7, cr6, {1}
ffff29a0:	e0800002 	add	r0, r0, r2
ffff29a4:	e1500001 	cmp	r0, r1
ffff29a8:	3afffffb 	bcc	0xffff299c
ffff29ac:	f57ff04f 	dsb	sy
ffff29b0:	e8bd5fff 	pop	{r0, r1, r2, r3, r4, r5, r6, r7, r8, r9, sl, fp, ip, lr}

ffff29b4:	e1a0f00e 	mov	pc, lr

ffff29b8:	e92d4001 	push	{r0, lr}
ffff29bc:	e3a00000 	mov	r0, #0
ffff29c0:	ee080f15 	mcr	15, 0, r0, cr8, cr5, {0}
ffff29c4:	ee080f16 	mcr	15, 0, r0, cr8, cr6, {0}
ffff29c8:	e8bd4001 	pop	{r0, lr}

ffff29cc:	e1a0f00e 	mov	pc, lr

ffff29d0:	e92d4001 	push	{r0, lr}
ffff29d4:	e10f0000 	mrs	r0, CPSR
ffff29d8:	e3c01080 	bic	r1, r0, #128	; 0x80
ffff29dc:	e121f001 	msr	CPSR_c, r1
ffff29e0:	e8bd4001 	pop	{r0, lr}

ffff29e4:	e1a0f00e 	mov	pc, lr

ffff29e8:	e92d4001 	push	{r0, lr}
ffff29ec:	e10f0000 	mrs	r0, CPSR
ffff29f0:	e3801080 	orr	r1, r0, #128	; 0x80
ffff29f4:	e121f001 	msr	CPSR_c, r1
ffff29f8:	e8bd4001 	pop	{r0, lr}

ffff29fc:	e1a0f00e 	mov	pc, lr

ffff2a00:	e92d4001 	push	{r0, lr}
ffff2a04:	e10f0000 	mrs	r0, CPSR
ffff2a08:	e3c01040 	bic	r1, r0, #64	; 0x40
ffff2a0c:	e121f001 	msr	CPSR_c, r1
ffff2a10:	e8bd4001 	pop	{r0, lr}

ffff2a14:	e1a0f00e 	mov	pc, lr

ffff2a18:	e92d4001 	push	{r0, lr}
ffff2a1c:	e10f0000 	mrs	r0, CPSR
ffff2a20:	e3801040 	orr	r1, r0, #64	; 0x40
ffff2a24:	e121f001 	msr	CPSR_c, r1
ffff2a28:	e8bd4001 	pop	{r0, lr}

ffff2a2c:	e1a0f00e 	mov	pc, lr

ffff2a30:	e92d4001 	push	{r0, lr}
ffff2a34:	ee110f10 	mrc	15, 0, r0, cr1, cr0, {0}
ffff2a38:	e3800a02 	orr	r0, r0, #8192	; 0x2000
ffff2a3c:	ee010f10 	mcr	15, 0, r0, cr1, cr0, {0}
ffff2a40:	e8bd4001 	pop	{r0, lr}

ffff2a44:	e1a0f00e 	mov	pc, lr

ffff2a48:	e92d4001 	push	{r0, lr}
ffff2a4c:	ee110f10 	mrc	15, 0, r0, cr1, cr0, {0}
ffff2a50:	e3c00a02 	bic	r0, r0, #8192	; 0x2000
ffff2a54:	ee010f10 	mcr	15, 0, r0, cr1, cr0, {0}
ffff2a58:	e8bd4001 	pop	{r0, lr}

ffff2a5c:	e1a0f00e 	mov	pc, lr
	...

;;;*****************************************************************************
;;;
;;; Boot ROM
;;;
;;;*****************************************************************************

BROM:

	;; BROM header
ffff2c00:	ea000006 	b	start  		; jump instruction, see below
ffff2c04:	4e4f4765	.ascii	"eGON" 		; magic
ffff2c08:	4d52422e	.ascii	".BRM"
ffff2c0c:	00000020	.word	32 		; header length
ffff2c10:	30303131	.ascii	"1100"		; boot version (1.1.00)
ffff2c14:	30303131	.ascii	"1100"		; eGon version (1.1.00)
ffff2c18:	31383631	.ascii	"1681"		; platform information (V3s)
ffff2c1c:	00000000	.word	0

	;; BROM entry point

	;; Unknown sequence of pulsing
	;;
	;; According to the H6 User Manual (https://linux-sunxi.org/images/4/46/Allwinner_H6_V200_User_Manual_V1.1.pdf)
	;; which has a register with similar offset (0xa4) in its system configuration block,
	;; it is BROM_OUTPUT_REG, and bit 0 is BROM_OUTPUT_ENABLE, bit 1 is BROM_OUTPUT_VALUE
	;; This seems to generate a HI/LO/HI/LO/HI sequence on this pin...
	;; ... Except that it is an unknown pin on the V3s
start:
ffff2c20:	e59f11bc 	ldr	r1, [pc, #444]	; 0xffff2de4 =0x01c000a4 BROM_OUTPUT_REG
ffff2c24:	e5912000 	ldr	r2, [r1]
ffff2c28:	e3a03001 	mov	r3, #1
ffff2c2c:	e1822003 	orr	r2, r2, r3
ffff2c30:	e5812000 	str	r2, [r1] 	; set bit 0 BROM_OUTPUT_ENABLE

ffff2c34:	e59f11a8 	ldr	r1, [pc, #424]	; 0xffff2de4 =0x01c000a4 BROM_OUTPUT_REG
ffff2c38:	e5912000 	ldr	r2, [r1]
ffff2c3c:	e3a03002 	mov	r3, #2
ffff2c40:	e1822003 	orr	r2, r2, r3
ffff2c44:	e5812000 	str	r2, [r1]	; set bit 1 BROM_OUTPUT_VALUE

ffff2c48:	e3a00014 	mov	r0, #20		; delay loop 20 times

.delay0:
ffff2c4c:	e2500001 	subs	r0, r0, #1
ffff2c50:	1afffffd 	bne	.delay0

ffff2c54:	e5912000 	ldr	r2, [r1]
ffff2c58:	e1c22003 	bic	r2, r2, r3
ffff2c5c:	e5812000 	str	r2, [r1]	; clear bit 1 BROM_OUTPUT_VALUE

ffff2c60:	e3a0001e 	mov	r0, #30		; delay loop 30 times

.delay1:
ffff2c64:	e2500001 	subs	r0, r0, #1
ffff2c68:	1afffffd 	bne	.delay1

ffff2c6c:	e5912000 	ldr	r2, [r1]
ffff2c70:	e1822003 	orr	r2, r2, r3
ffff2c74:	e5812000 	str	r2, [r1]	; set bit 1 BROM_OUTPUT_VALUE

ffff2c78:	e3a00014 	mov	r0, #20 	; delay loop 20 times

.delay2:
ffff2c7c:	e2500001 	subs	r0, r0, #1
ffff2c80:	1afffffd 	bne	.delay2

ffff2c84:	e5912000 	ldr	r2, [r1]
ffff2c88:	e1c22003 	bic	r2, r2, r3
ffff2c8c:	e5812000 	str	r2, [r1]	; clear bit 1 BROM_OUTPUT_VALUE

ffff2c90:	e3a0001e 	mov	r0, #30		; delay loop 30 times

.delay3:
ffff2c94:	e2500001 	subs	r0, r0, #1
ffff2c98:	1afffffd 	bne	.delay3

ffff2c9c:	e5912000 	ldr	r2, [r1]
ffff2ca0:	e1822003 	orr	r2, r2, r3
ffff2ca4:	e5812000 	str	r2, [r1]	; set bit 1 BROM_OUTPUT_VALUE

ffff2ca8:	e3a00014 	mov	r0, #20		; delay loop 20 times

.delay4:
ffff2cac:	e2500001 	subs	r0, r0, #1
ffff2cb0:	1afffffd 	bne	.delay4

ffff2cb4:	e59f1128 	ldr	r1, [pc, #296]	; 0xffff2de4 =0x01c000a4 BROM_OUTPUT_REG
ffff2cb8:	e5912000 	ldr	r2, [r1]
ffff2cbc:	e3a03001 	mov	r3, #1
ffff2cc0:	e1c22003 	bic	r2, r2, r3
ffff2cc4:	e5812000 	str	r2, [r1]	; clear bit 0 BROM_OUTPUT_ENABLE

ffff2cc8:	e3a00050 	mov	r0, #80		; delay loop 80 times

.delay5:
ffff2ccc:	e2500001 	subs	r0, r0, #1
ffff2cd0:	1afffffd 	bne	.delay5

ffff2cd4:	ea000001 	b	.check_multi_cpu

	;; Start a CPU other than #0, which is unlikely as the V3s only features a single core
.start_other_cpu:
ffff2cd8:	e59f0108 	ldr	r0, [pc, #264]	; 0xffff2de8 =0x01f01da4 cpu0+ (or cpu0 hotplug) entry address register?
ffff2cdc:	e590f000 	ldr	pc, [r0]

	;; Check for multi-CPU, which is unlikely as the V3s only features a single core
	;; For system CoProcessor instructions, see https://developer.arm.com/documentation/ddi0344/k/system-control-coprocessor/system-control-coprocessor-registers/register-allocation
.check_multi_cpu:
ffff2ce0:	ee100fb0 	mrc	15, 0, r0, cr0, cr0, {5}; read the MPIDR (Multiprocessor ID Register) from system CoProcessor
ffff2ce4:	e2000003 	and	r0, r0, #3
ffff2ce8:	e3500000 	cmp	r0, #0	        ; 2 LSB bits are processor #
ffff2cec:	1afffff9 	bne	.start_other_cpu; start non-zero CPU
ffff2cf0:	eaffffff 	b	.start_cpu0	; start CPU 0

	;; Start CPU #0
.start_cpu0:
ffff2cf4:	e10f0000 	mrs	r0, CPSR	; read current program status register
ffff2cf8:	e3c0001f 	bic	r0, r0, #31	; load System (ARMv4+) R0-R14, CPSR, PC as MASK
ffff2cfc:	e3800013 	orr	r0, r0, #19	; set SVC mode (supervisor) R0-R12, R13_svc R14_svc CPSR, SPSR_IRQ, PC
ffff2d00:	e38000c0 	orr	r0, r0, #192	; 0xc0e: enable FIQ + IRQ interrupts
ffff2d04:	e3c00c02 	bic	r0, r0, #512	; set little endianess
ffff2d08:	e121f000 	msr	CPSR_c, r0	; write to current program status register

	;; Disable MMU, I and D cache and program flow prediction
ffff2d0c:	ee110f10 	mrc	15, 0, r0, cr1, cr0, {0}; read CR (Control Register) from CoProcessor
ffff2d10:	e3c00005 	bic	r0, r0, #5	; disable MMU and data caching
ffff2d14:	e3c00b06 	bic	r0, r0, #6144	; 0x1800: disable program flow prediction and instruction caching
ffff2d18:	ee010f10 	mcr	15, 0, r0, cr1, cr0, {0}; write to CoProcessor control register

	;; Disable watchdog
ffff2d1c:	e59f10c8 	ldr	r1, [pc, #200]	; 0xffff2dec =0x01c20cb8 load WDOG_MODE_REG address
ffff2d20:	e5912000 	ldr	r2, [r1]	; load WDOG_MODE_REG value
ffff2d24:	e3c22001 	bic	r2, r2, #1	; disable watchdog reset WDOG_EN = 0
ffff2d28:	e5812000 	str	r2, [r1]	; store WDOG_MODE_REG register

	;; Configure APB1 and AHB1 clocks, APB1 clock is /4
ffff2d2c:	e59f10bc 	ldr	r1, [pc, #188]	; 0xffff2df0 =0x01c20000 load CCU base address
ffff2d30:	e5912054 	ldr	r2, [r1, #84]	; load AHB1_APB1_CFG_REG
ffff2d34:	e3a03e33 	mov	r3, #816	; 0x330: APB1_CLK_RATIO = 0x11, AHB1_PRE_DIV = 0x11, AHB1_CLK_DIV_RATIO = 0x11 (mask)
ffff2d38:	e1c22003 	bic	r2, r2, r3	;        APB1_CLK_RATIO = 0x00, AHB1_PRE_DIV = 0x00, AHB1_CLK_DIV_RATIO = 0x00
ffff2d3c:	e3a03c01 	mov	r3, #256	; 0x100: APB1_CLK_RATIO = 0x10 (/4)
ffff2d40:	e1822003 	orr	r2, r2, r3
ffff2d44:	e5812054 	str	r2, [r1, #84]	; store AHB1_APB1_CFG_REG

	;; Enable DMA and PIO clock gating, reset DMA
ffff2d48:	e5912060 	ldr	r2, [r1, #96]	; load BUS_CLK_GATING_REG0
ffff2d4c:	e3a03040 	mov	r3, #64		; DMA_GATING = 0x1
ffff2d50:	e1822003 	orr	r2, r2, r3
ffff2d54:	e5812060 	str	r2, [r1, #96]	; store BUS_CLK_GATING_REG0

ffff2d58:	e5912068 	ldr	r2, [r1, #104]	; load BUS_CLK_GATING_REG2
ffff2d5c:	e3a03020 	mov	r3, #32		; PIO_GATING = 0x1
ffff2d60:	e1822003 	orr	r2, r2, r3
ffff2d64:	e5812068 	str	r2, [r1, #104]	; store BUS_CLK_GATING_REG2

ffff2d68:	e59122c0 	ldr	r2, [r1, #704]	; load BUS_SOFT_RST_REG0
ffff2d6c:	e3a03040 	mov	r3, #64		; DMA_RST = 1
ffff2d70:	e1822003 	orr	r2, r2, r3
ffff2d74:	e58122c0 	str	r2, [r1, #704]	; store BUS_SOFT_RST_REG0

	;; Setup stack pointer to end of SRAM A1 (16KB)
ffff2d78:	e59fd074 	ldr	sp, [pc, #116]	; 0xffff2df4 =0x00003ffc setup stack pointer to end of SRAM A1 (16KB)

	;; Check if resuming from standby mode
ffff2d7c:	e59f3074 	ldr	r3, [pc, #116]	; 0xffff2df8 =0x01f01da0 standby flag register?
ffff2d80:	e5932000 	ldr	r2, [r3]
ffff2d84:	e30f1fff 	movw	r1, #65535	; 0xffff
ffff2d88:	e0010002 	and	r0, r1, r2
ffff2d8c:	e30e1fe8 	movw	r1, #61416	; 0xefe8
ffff2d90:	e1500001 	cmp	r0, r1
ffff2d94:	0a000058 	beq	resume_from_standby

	;; Clear undocumented register in System Control block
	;; Is this to enable SRAM C for CPU/DMA access?
ffff2d98:	e3a01507 	mov	r1, #29360128	; 0x1c00000: undocumented register in System Control block
ffff2d9c:	e3a02000 	mov	r2, #0
ffff2da0:	e5812000 	str	r2, [r1]

	;; Gate the Video Engine clock and reset it: why is it done here?
	;; Is it related to SRAM C being connected to the Video Engine?
ffff2da4:	e59f1050 	ldr	r1, [pc, #80]	; 0xffff2dfc =0x01c20064 load BUS_CLK_GATING_REG1
ffff2da8:	e5912000 	ldr	r2, [r1]
ffff2dac:	e3a03001 	mov	r3, #1 		; VE_GATING = 1
ffff2db0:	e1822003 	orr	r2, r2, r3
ffff2db4:	e5812000 	str	r2, [r1] 	; store BUS_CLK_GATING_REG1
ffff2db8:	e59f1040 	ldr	r1, [pc, #64]	; 0xffff2e00 =0x01c202c4 load BUS_SOFT_RST_REG1
ffff2dbc:	e5912000 	ldr	r2, [r1]
ffff2dc0:	e3a03001 	mov	r3, #1 		; VE_RST = 1
ffff2dc4:	e1822003 	orr	r2, r2, r3
ffff2dc8:	e5812000 	str	r2, [r1]  	; store BUS_SOFT_RST_REG1
ffff2dcc:	e3a00e7d 	mov	r0, #2000	; 0x7d0

.delay_6:
ffff2dd0:	e2500001 	subs	r0, r0, #1
ffff2dd4:	1afffffd 	bne	.delay_6

	;; Setup stack pointer to 4k below end of SRAM C (44KB)
ffff2dd8:	e59fd024 	ldr	sp, [pc, #36]	; 0xffff2e04 = 0x0000dffc setup stack pointer to 4k below end of SRAM C (44KB)
ffff2ddc:	eb000014 	bl	boot		; jump to boot
ffff2de0:	eafffffe 	b	0xffff2de0	; loop forever

	;; Global Offset table
ffff2de4:	01c000a4
ffff2de8:	01f01da4				; cpu0+ (or cpu hotplug) entry address register?
ffff2dec:	01c20cb8				; WDOG_MODE_REG
ffff2df0:	01c20000				; CCU_BASE
ffff2df4:	00003ffc
ffff2df8:	01f01da0				; standby flag register?
ffff2dfc:	01c20064				; BUS_CLK_GATING_REG1
ffff2e00:	01c202c4				; BUS_SOFT_RST_REG1
ffff2e04:	0000dffc

;;;*****************************************************************************
	;; Fetch the content of 0x20000 + r0 * 256 into r2, for unknow purpose
ffff2e08:	e3a02000 	mov	r2, #0
ffff2e0c:	e3a01000 	mov	r1, #0
ffff2e10:	e3a03802 	mov	r3, #131072	; 0x20000
ffff2e14:	e0831400 	add	r1, r3, r0, lsl #8
ffff2e18:	e5912000 	ldr	r2, [r1]
ffff2e1c:	e12fff1e 	bx	lr

;;;*****************************************************************************
jump_spl:
ffff2e20:	e1a04000 	mov	r4, r0
ffff2e24:	e1a00004 	mov	r0, r4
ffff2e28:	eb000ce6 	bl	jump_to
ffff2e2c:	e320f000 	nop	{0}
ffff2e30:	eafffffe 	b	0xffff2e30	; loop forever
;;; *****************************************************************************
	;; Boot sequence check
	;; Check first uboot button, it does not look like it is accessible on any of the V3s pins (please let me know!)
boot:
ffff2e34:	eb000cce 	bl	check_uboot	; check if uboot button is pressed, return value in r0
ffff2e38:	e1a04000 	mov	r4, r0		; r4 = check_uboot();
ffff2e3c:	e3540000 	cmp	r4, #0		; see if check_uboot returned 0
ffff2e40:	0a000000 	beq	.try_boot_MMC0	; if check_uboot was 0, try to boot from MMC0
ffff2e44:	ea000026 	b	.boot_fel	; else boot FEL mode

.try_boot_MMC0:
ffff2e48:	e3a00000 	mov	r0, #0
ffff2e4c:	ebffffed 	bl	0xffff2e08
ffff2e50:	e3a00000 	mov	r0, #0		; r0 = 0x0; (which card_no to boot, 0 = mmc0)
ffff2e54:	eb000190 	bl	load_boot0_from_mmc ; load SPL from mmc0
ffff2e58:	e1a04000 	mov	r4, r0		; r4 = load_from_mmc();
ffff2e5c:	e3540000 	cmp	r4, #0		; see if load_from_mmc returned 0
ffff2e60:	1a000000 	bne	.try_boot_eMMC	; if load_from_mmc returned 0 try to boot from eMMc on MMC2
ffff2e64:	ea000021 	b	.boot_spl	; else skip to .boot_spl

.try_boot_eMMC:
ffff2e68:	e3a00001 	mov	r0, #1
ffff2e6c:	ebffffe5 	bl	0xffff2e08
ffff2e70:	e3a00002 	mov	r0, #2		; r0 = 0x2; (which card_no to boot, 2 = mmc2)
ffff2e74:	eb0001b0 	bl	0xffff353c	; load SPL from eMMC
ffff2e78:	e1a04000 	mov	r4, r0		; r4 = load_from_emmc();
ffff2e7c:	e3540000 	cmp	r4, #0		; see if load_from_emmc returned 0
ffff2e80:	1a000000 	bne	.try_boot_MMC2	; if load_from_emmc returned 0 try to boot from MMC2
ffff2e84:	ea000019 	b	.boot_spl	; else skip to .boot_spl

.try_boot_MMC2:
ffff2e88:	e3a00002 	mov	r0, #2		; r0 = 0x2; (which card_no to boot, 2 = mmc2)
ffff2e8c:	eb000182 	bl	load_boot0_from_mmc ; load SPL from mmc2
ffff2e90:	e1a04000 	mov	r4, r0		; r4 = load_from_mmc();
ffff2e94:	e3540000 	cmp	r4, #0		; see if load_from_mmc returned 0
ffff2e98:	1a000000 	bne	.try_boot_SPINOR; if load_from_mmc returned 0 try to boot from SPI NAND-flash
ffff2e9c:	ea000013 	b	.boot_spl

.try_boot_SPINOR:
ffff2ea0:	e3a00002 	mov	r0, #2
ffff2ea4:	ebffffd7 	bl	0xffff2e08
ffff2ea8:	eb000c2b 	bl	load_boot0_from_spinor; load SPL from SPI NOR-flash
ffff2eac:	e1a04000 	mov	r4, r0		; r4 = load_from_spinor();
ffff2eb0:	e3540000 	cmp	r4, #0		; see if load_from_spinor returned 0
ffff2eb4:	1a000000 	bne	.try_boot_from_SPINAND; if load_from_spinor returned 0 try to boot from SPI NOR-flash
ffff2eb8:	ea00000c 	b	.boot_spl	; else skip to .boot_spl

.try_boot_SPINAND:
ffff2ebc:	e3a00003 	mov	r0, #3
ffff2ec0:	ebffffd0 	bl	0xffff2e08
ffff2ec4:	eb0000d7 	bl	load_boot0_from_spinand; load SPL from SPI NAND-flash
ffff2ec8:	e1a04000 	mov	r4, r0		; r4 = load_from_spinand();
ffff2ecc:	e3540000 	cmp	r4, #0		; see if load_from_spinand returned 0
ffff2ed0:	1a000000 	bne	.none_found	; if load_from_spinand returned 0 boot from FEL mode (via .none_found)
ffff2ed4:	ea000005 	b	.boot_spl	; else skip to .boot_spl

.none_found:
ffff2ed8:	e3a00004 	mov	r0, #4
ffff2edc:	ebffffc9 	bl	0xffff2e08

ffff2ee0:	e320f000 	nop	{0}

.boot_fel:
ffff2ee4:	e59f006c 	ldr	r0, [pc, #108]	; 0xffff2f58 =0xffff0020 load interrupt vector 'fel_setup' into r0
ffff2ee8:	eb000cb6 	bl	jump_to		; execute 'fel_setup' (via jump_to)
ffff2eec:	e320f000 	nop	{0}

.boot_spl:
ffff2ef0:	e3a010fc 	mov	r1, #252	; 0xfc
ffff2ef4:	e3a00000 	mov	r0, #0
ffff2ef8:	ebffffc8 	bl	jump_spl

resume_from_standby:
ffff2efc:	e59f4058 	ldr	r4, [pc, #88]	; 0xffff2f5c =0x01f01da8 standby resume entry address register?
ffff2f00:	e3a06000 	mov	r6, #0
ffff2f04:	e3a05000 	mov	r5, #0
ffff2f08:	e5946000 	ldr	r6, [r4]
ffff2f0c:	e5965010 	ldr	r5, [r6, #16]
ffff2f10:	e28f1048 	add	r1, pc, #72	; 0x48 =0xffff2f60 "eGON.BT0"
ffff2f14:	e5940000 	ldr	r0, [r4]
ffff2f18:	eb000c45 	bl	check_magic 	; check magic

ffff2f1c:	e3500000 	cmp	r0, #0
ffff2f20:	1a00000b 	bne	resume_fail

ffff2f24:	e1a00005 	mov	r0, r5 		; value pointed by standby resume entry address register + 16
ffff2f28:	e7df051f 	bfc	r0, #10, #22	; check if 10 MSB bits are 0 (valid address)
ffff2f2c:	e3500000 	cmp	r0, #0
ffff2f30:	1a000007 	bne	resume_fail

ffff2f34:	e1a01005 	mov	r1, r5		; value pointed by standby resume entry address register + 16
ffff2f38:	e5940000 	ldr	r0, [r4]
ffff2f3c:	eb000c4e 	bl	check_sum
ffff2f40:	e3500000 	cmp	r0, #0
ffff2f44:	1a000002 	bne	resume_fail

ffff2f48:	e3a010fc 	mov	r1, #252	; 0xfc
ffff2f4c:	e5940000 	ldr	r0, [r4]
ffff2f50:	ebffffb2 	bl	jump_spl

resume_fail:
ffff2f54:	ebffffb6 	bl	boot

	;; Global Offset Table
ffff2f58:	ffff0020
ffff2f5c:	01f01da8				; standby resume entry address register?
ffff2f60:	4e4f4765	.ascii	"eGON"
ffff2f64:	3054422e	.asci	".BT0"
ffff2f68:	00000000

ffff2f6c:	e92d4070 	push	{r4, r5, r6, lr}
ffff2f70:	e1a03000 	mov	r3, r0
ffff2f74:	e3520000 	cmp	r2, #0
ffff2f78:	1a00000b 	bne	0xffff2fac

ffff2f7c:	e3510002 	cmp	r1, #2
ffff2f80:	2a000007 	bcs	0xffff2fa4

ffff2f84:	e59f0058 	ldr	r0, [pc, #88]	; 0xffff2fe4 =0xffff61cc
ffff2f88:	e7b04201 	ldr	r4, [r0, r1, lsl #4]!
ffff2f8c:	e9900060 	ldmib	r0, {r5, r6}
ffff2f90:	e590000c 	ldr	r0, [r0, #12]
ffff2f94:	e583000c 	str	r0, [r3, #12]
ffff2f98:	e8830070 	stm	r3, {r4, r5, r6}
ffff2f9c:	e3a00000 	mov	r0, #0

ffff2fa0:	e8bd8070 	pop	{r4, r5, r6, pc}

ffff2fa4:	e3e00000 	mvn	r0, #0
ffff2fa8:	eafffffc 	b	0xffff2fa0

ffff2fac:	e3520001 	cmp	r2, #1
ffff2fb0:	1a000009 	bne	0xffff2fdc

ffff2fb4:	e3510004 	cmp	r1, #4
ffff2fb8:	2a000005 	bcs	0xffff2fd4

ffff2fbc:	e59f0024 	ldr	r0, [pc, #36]	; 0xffff2fe8 =0xffff61ec
ffff2fc0:	e0806201 	add	r6, r0, r1, lsl #4
ffff2fc4:	e8960071 	ldm	r6, {r0, r4, r5, r6}
ffff2fc8:	e8830071 	stm	r3, {r0, r4, r5, r6}
ffff2fcc:	e3a00000 	mov	r0, #0
ffff2fd0:	eafffff2 	b	0xffff2fa0

ffff2fd4:	e3e00000 	mvn	r0, #0
ffff2fd8:	eafffff0 	b	0xffff2fa0

ffff2fdc:	e3e00000 	mvn	r0, #0
ffff2fe0:	eaffffee 	b	0xffff2fa0

	;; Global Offset Table
ffff2fe4:	ffff61cc
ffff2fe8:	ffff61ec

ffff2fec:	e92d4ff0 	push	{r4, r5, r6, r7, r8, r9, sl, fp, lr}
ffff2ff0:	e24dd024 	sub	sp, sp, #36	; 0x24
ffff2ff4:	eb000a1f 	bl	0xffff5878
ffff2ff8:	eb000b4d 	bl	0xffff5d34
ffff2ffc:	e3a06000 	mov	r6, #0
ffff3000:	ea00003f 	b	0xffff3104

ffff3004:	e3a0a020 	mov	sl, #32
ffff3008:	ea00003a 	b	0xffff30f8

ffff300c:	e3a02001 	mov	r2, #1
ffff3010:	e1a01006 	mov	r1, r6
ffff3014:	e28d000c 	add	r0, sp, #12
ffff3018:	ebffffd3 	bl	0xffff2f6c
ffff301c:	e1a09000 	mov	r9, r0
ffff3020:	e3790001 	cmn	r9, #1
ffff3024:	1a000000 	bne	0xffff302c

ffff3028:	ea000031 	b	0xffff30f4

ffff302c:	e59d000c 	ldr	r0, [sp, #12]
ffff3030:	e58d0020 	str	r0, [sp, #32]
ffff3034:	e59d4010 	ldr	r4, [sp, #16]
ffff3038:	e59d7018 	ldr	r7, [sp, #24]
ffff303c:	e59d8014 	ldr	r8, [sp, #20]
ffff3040:	e88d0110 	stm	sp, {r4, r8}
ffff3044:	e58d7008 	str	r7, [sp, #8]
ffff3048:	e3a02001 	mov	r2, #1
ffff304c:	e3a01000 	mov	r1, #0
ffff3050:	e1a0000a 	mov	r0, sl
ffff3054:	e59d3020 	ldr	r3, [sp, #32]
ffff3058:	eb000b46 	bl	0xffff5d78
ffff305c:	e3500002 	cmp	r0, #2
ffff3060:	1a000000 	bne	0xffff3068

ffff3064:	ea000022 	b	0xffff30f4

ffff3068:	e28f1f7b 	add	r1, pc, #492	; 0x1ec =0xffff325c "eGON.BT0"
ffff306c:	e3a00000 	mov	r0, #0
ffff3070:	eb000bef 	bl	check_magic
ffff3074:	e3500000 	cmp	r0, #0
ffff3078:	0a000000 	beq	0xffff3080

ffff307c:	ea00001c 	b	0xffff30f4

ffff3080:	e3a0b000 	mov	fp, #0
ffff3084:	e59b5010 	ldr	r5, [fp, #16]
ffff3088:	e2440001 	sub	r0, r4, #1
ffff308c:	e1100005 	tst	r0, r5
ffff3090:	0a000000 	beq	0xffff3098

ffff3094:	ea000016 	b	0xffff30f4

ffff3098:	e730f415 	udiv	r0, r5, r4
ffff309c:	e58d001c 	str	r0, [sp, #28]
ffff30a0:	e88d0110 	stm	sp, {r4, r8}
ffff30a4:	e58d7008 	str	r7, [sp, #8]
ffff30a8:	e3a01000 	mov	r1, #0
ffff30ac:	e1a0000a 	mov	r0, sl
ffff30b0:	e1cd21dc 	ldrd	r2, [sp, #28]
ffff30b4:	eb000b2f 	bl	0xffff5d78
ffff30b8:	e3500002 	cmp	r0, #2
ffff30bc:	1a000000 	bne	0xffff30c4

ffff30c0:	ea00000b 	b	0xffff30f4

ffff30c4:	e1a01005 	mov	r1, r5
ffff30c8:	e3a00000 	mov	r0, #0
ffff30cc:	eb000bea 	bl	check_sum
ffff30d0:	e3500000 	cmp	r0, #0
ffff30d4:	1a000005 	bne	0xffff30f0

ffff30d8:	e3a00003 	mov	r0, #3
ffff30dc:	e5cb0028 	strb	r0, [fp, #40]	; 0x28
ffff30e0:	eb000a08 	bl	0xffff5908
ffff30e4:	e3a00000 	mov	r0, #0

ffff30e8:	e28dd024 	add	sp, sp, #36	; 0x24
ffff30ec:	e8bd8ff0 	pop	{r4, r5, r6, r7, r8, r9, sl, fp, pc}

ffff30f0:	e320f000 	nop	{0}

ffff30f4:	e28aa020 	add	sl, sl, #32

ffff30f8:	e35a0c01 	cmp	sl, #256	; 0x100
ffff30fc:	3affffc2 	bcc	0xffff300c

ffff3100:	e2866001 	add	r6, r6, #1
ffff3104:	e3560004 	cmp	r6, #4
ffff3108:	3affffbd 	bcc	0xffff3004

ffff310c:	eb0009fd 	bl	0xffff5908
ffff3110:	e3e00000 	mvn	r0, #0
ffff3114:	eafffff3 	b	0xffff30e8
;;;*****************************************************************************

ffff3118:	e92d4ff0 	push	{r4, r5, r6, r7, r8, r9, sl, fp, lr}
ffff311c:	e24dd024 	sub	sp, sp, #36	; 0x24
ffff3120:	eb0009d4 	bl	0xffff5878
ffff3124:	eb000b02 	bl	0xffff5d34
ffff3128:	e3a06000 	mov	r6, #0
ffff312c:	ea000038 	b	0xffff3214

ffff3130:	e3a02000 	mov	r2, #0
ffff3134:	e1a01006 	mov	r1, r6
ffff3138:	e28d0010 	add	r0, sp, #16
ffff313c:	ebffff8a 	bl	0xffff2f6c
ffff3140:	e1a09000 	mov	r9, r0
ffff3144:	e3790001 	cmn	r9, #1
ffff3148:	1a000000 	bne	0xffff3150

ffff314c:	ea00002f 	b	0xffff3210

ffff3150:	e59db010 	ldr	fp, [sp, #16]
ffff3154:	e59d4014 	ldr	r4, [sp, #20]
ffff3158:	e59d801c 	ldr	r8, [sp, #28]
ffff315c:	e59d7018 	ldr	r7, [sp, #24]
ffff3160:	e1a0300b 	mov	r3, fp
ffff3164:	e3a02001 	mov	r2, #1
ffff3168:	e3a01000 	mov	r1, #0
ffff316c:	e1a00001 	mov	r0, r1
ffff3170:	e88d0190 	stm	sp, {r4, r7, r8}
ffff3174:	eb000aff 	bl	0xffff5d78
ffff3178:	e3500002 	cmp	r0, #2
ffff317c:	1a000000 	bne	0xffff3184

ffff3180:	ea000022 	b	0xffff3210

ffff3184:	e28f10d0 	add	r1, pc, #208	; 0xd0 =0xffff325c "eGON.BT0"
ffff3188:	e3a00000 	mov	r0, #0
ffff318c:	eb000ba8 	bl	check_magic
ffff3190:	e3500000 	cmp	r0, #0
ffff3194:	0a000000 	beq	0xffff319c

ffff3198:	ea00001c 	b	0xffff3210

ffff319c:	e3a0a000 	mov	sl, #0
ffff31a0:	e59a5010 	ldr	r5, [sl, #16]
ffff31a4:	e2440001 	sub	r0, r4, #1
ffff31a8:	e1100005 	tst	r0, r5
ffff31ac:	0a000000 	beq	0xffff31b4

ffff31b0:	ea000016 	b	0xffff3210

ffff31b4:	e730f415 	udiv	r0, r5, r4
ffff31b8:	e58d0020 	str	r0, [sp, #32]
ffff31bc:	e1a0300b 	mov	r3, fp
ffff31c0:	e88d0190 	stm	sp, {r4, r7, r8}
ffff31c4:	e3a01000 	mov	r1, #0
ffff31c8:	e1a00001 	mov	r0, r1
ffff31cc:	e59d2020 	ldr	r2, [sp, #32]
ffff31d0:	eb000ae8 	bl	0xffff5d78
ffff31d4:	e3500002 	cmp	r0, #2
ffff31d8:	1a000000 	bne	0xffff31e0

ffff31dc:	ea00000b 	b	0xffff3210

ffff31e0:	e1a01005 	mov	r1, r5
ffff31e4:	e3a00000 	mov	r0, #0
ffff31e8:	eb000ba3 	bl	check_sum
ffff31ec:	e3500000 	cmp	r0, #0
ffff31f0:	1a000005 	bne	0xffff320c

ffff31f4:	e3a00003 	mov	r0, #3
ffff31f8:	e5ca0028 	strb	r0, [sl, #40]	; 0x28
ffff31fc:	eb0009c1 	bl	0xffff5908
ffff3200:	e3a00000 	mov	r0, #0

ffff3204:	e28dd024 	add	sp, sp, #36	; 0x24
ffff3208:	e8bd8ff0 	pop	{r4, r5, r6, r7, r8, r9, sl, fp, pc}

ffff320c:	e320f000 	nop	{0}

ffff3210:	e2866001 	add	r6, r6, #1

ffff3214:	e3560002 	cmp	r6, #2
ffff3218:	3affffc4 	bcc	0xffff3130

ffff321c:	eb0009b9 	bl	0xffff5908
ffff3220:	e3e00000 	mvn	r0, #0
ffff3224:	eafffff6 	b	0xffff3204
;;;*****************************************************************************

load_boot0_from_spinand:
ffff3228:	e92d4010 	push	{r4, lr}
ffff322c:	ebffffb9 	bl	0xffff3118

ffff3230:	e3500000 	cmp	r0, #0
ffff3234:	1a000001 	bne	0xffff3240

ffff3238:	e3a00000 	mov	r0, #0

ffff323c:	e8bd8010 	pop	{r4, pc}

ffff3240:	ebffff69 	bl	0xffff2fec

ffff3244:	e3500000 	cmp	r0, #0
ffff3248:	1a000001 	bne	0xffff3254

ffff324c:	e3a00000 	mov	r0, #0
ffff3250:	eafffff9 	b	0xffff323c

ffff3254:	e3e00000 	mvn	r0, #0
ffff3258:	eafffff7 	b	0xffff323c

ffff325c:	4e4f4765 	.ascii	"eGON"
ffff3260:	3054422e 	.ascii	".BT0"
ffff3264:	00000000 	.word	0

;;;*****************************************************************************
memcpy:
ffff3268:	e92d4030 	push	{r4, r5, lr}
ffff326c:	e1a03000 	mov	r3, r0
ffff3270:	e3a00000 	mov	r0, #0
ffff3274:	e1a04003 	mov	r4, r3
ffff3278:	e1a0c001 	mov	ip, r1
ffff327c:	e320f000 	nop	{0}
ffff3280:	ea000002 	b	0xffff3290

ffff3284:	e7dc5000 	ldrb	r5, [ip, r0]
ffff3288:	e7c45000 	strb	r5, [r4, r0]
ffff328c:	e2800001 	add	r0, r0, #1

ffff3290:	e1500002 	cmp	r0, r2
ffff3294:	3afffffa 	bcc	0xffff3284
ffff3298:	e8bd8030 	pop	{r4, r5, pc}

;;;*****************************************************************************
memset:							; r0 = dest, r1 = value, r2 = size
ffff329c:	e92d4010 	push	{r4, lr}
ffff32a0:	e1a03000 	mov	r3, r0
ffff32a4:	e3a00000 	mov	r0, #0
ffff32a8:	e1a0c003 	mov	ip, r3
ffff32ac:	e320f000 	nop	{0}
ffff32b0:	ea000001 	b	0xffff32bc

ffff32b4:	e7cc1000 	strb	r1, [ip, r0]
ffff32b8:	e2800001 	add	r0, r0, #1

ffff32bc:	e1500002 	cmp	r0, r2
ffff32c0:	3afffffb 	bcc	0xffff32b4
ffff32c4:	e8bd8010 	pop	{r4, pc}

;;;*****************************************************************************
memcmp:							; r0 = src, r1 = dest, r2 = size
ffff32c8:	e92d4010 	push	{r4, lr}
ffff32cc:	e1a03000 	mov	r3, r0
ffff32d0:	e1a0c001 	mov	ip, r1
ffff32d4:	e3a01000 	mov	r1, #0
ffff32d8:	e320f000 	nop	{0}
ffff32dc:	ea000006 	b	0xffff32fc

ffff32e0:	e7d30001 	ldrb	r0, [r3, r1]
ffff32e4:	e7dc4001 	ldrb	r4, [ip, r1]
ffff32e8:	e1500004 	cmp	r0, r4
ffff32ec:	0a000001 	beq	0xffff32f8

ffff32f0:	e3e00000 	mvn	r0, #0

ffff32f4:	e8bd8010 	pop	{r4, pc}

ffff32f8:	e2811001 	add	r1, r1, #1

ffff32fc:	e1510002 	cmp	r1, r2
ffff3300:	3afffff6 	bcc	0xffff32e0

ffff3304:	e3a00000 	mov	r0, #0
ffff3308:	eafffff9 	b	0xffff32f4

;;;*****************************************************************************
ffff330c:	e92d47f0 	push	{r4, r5, r6, r7, r8, r9, sl, lr}
ffff3310:	e1a07000 	mov	r7, r0
ffff3314:	e1a06001 	mov	r6, r1
ffff3318:	e1a08002 	mov	r8, r2
ffff331c:	e3e09000 	mvn	r9, #0
ffff3320:	e3a04000 	mov	r4, #0
ffff3324:	e3a05000 	mov	r5, #0
ffff3328:	e3a0a000 	mov	sl, #0
ffff332c:	e3560000 	cmp	r6, #0
ffff3330:	1a000001 	bne	0xffff333c

ffff3334:	e3a0a010 	mov	sl, #16 	; try loading from offset 8KB
ffff3338:	ea000006 	b	0xffff3358

ffff333c:	e3560001 	cmp	r6, #1
ffff3340:	1a000001 	bne	0xffff334c

ffff3344:	e300a100 	movw	sl, #256 	; try loading from offset 128KB
ffff3348:	ea000002 	b	0xffff3358

ffff334c:	e3e09000 	mvn	r9, #0
ffff3350:	e1a00009 	mov	r0, r9

ffff3354:	e8bd87f0 	pop	{r4, r5, r6, r7, r8, r9, sl, pc}

ffff3358:	e3a03000 	mov	r3, #0
ffff335c:	e3a02001 	mov	r2, #1
ffff3360:	e1a0100a 	mov	r1, sl
ffff3364:	e1a00008 	mov	r0, r8
ffff3368:	eb00085c 	bl	0xffff54e0
ffff336c:	e3500001 	cmp	r0, #1
ffff3370:	0a00000c 	beq	0xffff33a8

ffff3374:	e59f12fc 	ldr	r1, [pc, #764]	; 0xffff3678 =0x005b8d80
ffff3378:	e1a00008 	mov	r0, r8
ffff337c:	eb00067e 	bl	0xffff4d7c
ffff3380:	e3a03000 	mov	r3, #0
ffff3384:	e3a02001 	mov	r2, #1
ffff3388:	e1a0100a 	mov	r1, sl
ffff338c:	e1a00008 	mov	r0, r8
ffff3390:	eb000852 	bl	0xffff54e0
ffff3394:	e3500001 	cmp	r0, #1
ffff3398:	0a000002 	beq	0xffff33a8

ffff339c:	e3e09000 	mvn	r9, #0
ffff33a0:	e1a00009 	mov	r0, r9
ffff33a4:	eaffffea 	b	0xffff3354

ffff33a8:	e28f1fb3 	add	r1, pc, #716	; 0x2cc = 0xffff367c "eGON.BT0"
ffff33ac:	e3a00000 	mov	r0, #0
ffff33b0:	eb000b1f 	bl	check_magic
ffff33b4:	e3500000 	cmp	r0, #0
ffff33b8:	0a000002 	beq	0xffff33c8

ffff33bc:	e3e09000 	mvn	r9, #0
ffff33c0:	e1a00009 	mov	r0, r9
ffff33c4:	eaffffe2 	b	0xffff3354

ffff33c8:	e3a05000 	mov	r5, #0
ffff33cc:	e5954010 	ldr	r4, [r5, #16]
ffff33d0:	e3540902 	cmp	r4, #32768	; 0x8000
ffff33d4:	8a000003 	bhi	0xffff33e8
ffff33d8:	e1a00004 	mov	r0, r4
ffff33dc:	e7df049f 	bfc	r0, #9, #23
ffff33e0:	e3500000 	cmp	r0, #0
ffff33e4:	0a000002 	beq	0xffff33f4

ffff33e8:	e3e09000 	mvn	r9, #0
ffff33ec:	e1a00009 	mov	r0, r9
ffff33f0:	eaffffd7 	b	0xffff3354

ffff33f4:	e1a024a4 	lsr	r2, r4, #9
ffff33f8:	e3a03000 	mov	r3, #0
ffff33fc:	e1a0100a 	mov	r1, sl
ffff3400:	e1a00008 	mov	r0, r8
ffff3404:	eb000835 	bl	0xffff54e0
ffff3408:	e15004a4 	cmp	r0, r4, lsr #9
ffff340c:	0a00000c 	beq	0xffff3444

ffff3410:	e59f1260 	ldr	r1, [pc, #608]	; 0xffff3678 =0x005b8d80
ffff3414:	e1a00008 	mov	r0, r8
ffff3418:	eb000657 	bl	0xffff4d7c
ffff341c:	e1a024a4 	lsr	r2, r4, #9
ffff3420:	e3a03000 	mov	r3, #0
ffff3424:	e1a0100a 	mov	r1, sl
ffff3428:	e1a00008 	mov	r0, r8
ffff342c:	eb00082b 	bl	0xffff54e0
ffff3430:	e15004a4 	cmp	r0, r4, lsr #9
ffff3434:	0a000002 	beq	0xffff3444

ffff3438:	e3e09000 	mvn	r9, #0
ffff343c:	e1a00009 	mov	r0, r9
ffff3440:	eaffffc3 	b	0xffff3354

ffff3444:	e1a01004 	mov	r1, r4
ffff3448:	e3a00000 	mov	r0, #0
ffff344c:	eb000b0a 	bl	check_sum
ffff3450:	e3500000 	cmp	r0, #0
ffff3454:	1a00000d 	bne	0xffff3490

ffff3458:	e3570000 	cmp	r7, #0
ffff345c:	1a000002 	bne	0xffff346c
ffff3460:	e3a00000 	mov	r0, #0
ffff3464:	e5c50028 	strb	r0, [r5, #40]	; 0x28
ffff3468:	ea000003 	b	0xffff347c

ffff346c:	e3570002 	cmp	r7, #2
ffff3470:	1a000001 	bne	0xffff347c

ffff3474:	e3a00002 	mov	r0, #2
ffff3478:	e5c50028 	strb	r0, [r5, #40]	; 0x28

ffff347c:	e5d50028 	ldrb	r0, [r5, #40]	; 0x28
ffff3480:	e1800206 	orr	r0, r0, r6, lsl #4
ffff3484:	e5c50028 	strb	r0, [r5, #40]	; 0x28
ffff3488:	e3a09000 	mov	r9, #0
ffff348c:	ea000000 	b	0xffff3494

ffff3490:	e3e09000 	mvn	r9, #0

ffff3494:	e1a00009 	mov	r0, r9
ffff3498:	eaffffad 	b	0xffff3354

;;;*****************************************************************************
load_boot0_from_mmc:					; r0 = card_no
ffff349c:	e92d4030 	push	{r4, r5, lr}
ffff34a0:	e24dd064 	sub	sp, sp, #100	; allocate local variables

ffff34a4:	e1a05000 	mov	r5, r0 		; save card_no in r5
ffff34a8:	e3e04000 	mvn	r4, #0		; -1
ffff34ac:	e3a0204c 	mov	r2, #76		; length
ffff34b0:	e3a01000 	mov	r1, #0		; value
ffff34b4:	e28d0018 	add	r0, sp, #24	; dest
ffff34b8:	ebffff77 	bl	memset

ffff34bc:	e3a02018 	mov	r2, #24		; length
ffff34c0:	e3a01000 	mov	r1, #0		; value
ffff34c4:	e1a0000d 	mov	r0, sp		; dest
ffff34c8:	ebffff73 	bl	memset

ffff34cc:	e58dd018 	str	sp, [sp, #24]
ffff34d0:	e28d1018 	add	r1, sp, #24
ffff34d4:	e1a00005 	mov	r0, r5 		; r0 = card_no, r1 = structure
ffff34d8:	eb00088e 	bl	0xffff5718

ffff34dc:	e1a04000 	mov	r4, r0
ffff34e0:	e3540000 	cmp	r4, #0
ffff34e4:	0a000001 	beq	0xffff34f0

ffff34e8:	e3e04000 	mvn	r4, #0
ffff34ec:	ea00000c 	b	0xffff3524

ffff34f0:	e28d2018 	add	r2, sp, #24
ffff34f4:	e3a01000 	mov	r1, #0 		; try booting from offset 8KB
ffff34f8:	e1a00005 	mov	r0, r5
ffff34fc:	ebffff82 	bl	0xffff330c

ffff3500:	e1a04000 	mov	r4, r0
ffff3504:	e3540000 	cmp	r4, #0
ffff3508:	0a000004 	beq	0xffff3520

ffff350c:	e28d2018 	add	r2, sp, #24
ffff3510:	e3a01001 	mov	r1, #1 		; try booting from offset 128KB
ffff3514:	e1a00005 	mov	r0, r5
ffff3518:	ebffff7b 	bl	0xffff330c
ffff351c:	e1a04000 	mov	r4, r0

ffff3520:	e320f000 	nop	{0}

ffff3524:	e28d1018 	add	r1, sp, #24
ffff3528:	e1a00005 	mov	r0, r5
ffff352c:	eb0008b9 	bl	0xffff5818
ffff3530:	e1a00004 	mov	r0, r4
ffff3534:	e28dd064 	add	sp, sp, #100	; 0x64
ffff3538:	e8bd8030 	pop	{r4, r5, pc}

;;; *****************************************************************************
ffff353c:	e92d40f0 	push	{r4, r5, r6, r7, lr}
ffff3540:	e24dd064 	sub	sp, sp, #100	; 0x64
ffff3544:	e1a06000 	mov	r6, r0
ffff3548:	e3e07000 	mvn	r7, #0
ffff354c:	e3a0204c 	mov	r2, #76	; 0x4c
ffff3550:	e3a01000 	mov	r1, #0
ffff3554:	e28d0018 	add	r0, sp, #24
ffff3558:	ebffff4f 	bl	memset

ffff355c:	e3a02018 	mov	r2, #24
ffff3560:	e3a01000 	mov	r1, #0
ffff3564:	e1a0000d 	mov	r0, sp
ffff3568:	ebffff4b 	bl	memset

ffff356c:	e58dd018 	str	sp, [sp, #24]
ffff3570:	e28d1018 	add	r1, sp, #24
ffff3574:	e1a00006 	mov	r0, r6
ffff3578:	eb000884 	bl	0xffff5790
ffff357c:	e3500000 	cmp	r0, #0
ffff3580:	0a000001 	beq	0xffff358c

ffff3584:	e320f000 	nop	{0}
ffff3588:	ea000034 	b	0xffff3660

ffff358c:	e3a03000 	mov	r3, #0
ffff3590:	e3a02001 	mov	r2, #1
ffff3594:	e1a01003 	mov	r1, r3
ffff3598:	e28d0018 	add	r0, sp, #24
ffff359c:	eb0007f2 	bl	0xffff556c
ffff35a0:	e3500001 	cmp	r0, #1
ffff35a4:	0a000001 	beq	0xffff35b0

ffff35a8:	e3e07000 	mvn	r7, #0
ffff35ac:	ea00002b 	b	0xffff3660

ffff35b0:	e28f10c4 	add	r1, pc, #196	; 0xc4 =0xffff367c "eGON.BT0"
ffff35b4:	e3a00000 	mov	r0, #0
ffff35b8:	eb000a9d 	bl	check_magic
ffff35bc:	e3500000 	cmp	r0, #0
ffff35c0:	0a000001 	beq	0xffff35cc

ffff35c4:	e3e07000 	mvn	r7, #0
ffff35c8:	ea000024 	b	0xffff3660

ffff35cc:	e3a05000 	mov	r5, #0
ffff35d0:	e5954010 	ldr	r4, [r5, #16]
ffff35d4:	e3540902 	cmp	r4, #32768	; 0x8000
ffff35d8:	8a000003 	bhi	0xffff35ec

ffff35dc:	e1a00004 	mov	r0, r4
ffff35e0:	e7df049f 	bfc	r0, #9, #23
ffff35e4:	e3500000 	cmp	r0, #0
ffff35e8:	0a000001 	beq	0xffff35f4

ffff35ec:	e3e07000 	mvn	r7, #0
ffff35f0:	ea00001a 	b	0xffff3660

ffff35f4:	e1a024a4 	lsr	r2, r4, #9
ffff35f8:	e3a03000 	mov	r3, #0
ffff35fc:	e1a01003 	mov	r1, r3
ffff3600:	e28d0018 	add	r0, sp, #24
ffff3604:	eb0007d8 	bl	0xffff556c
ffff3608:	e15004a4 	cmp	r0, r4, lsr #9
ffff360c:	0a000001 	beq	0xffff3618

ffff3610:	e3e07000 	mvn	r7, #0
ffff3614:	ea000011 	b	0xffff3660

ffff3618:	e1a01004 	mov	r1, r4
ffff361c:	e3a00000 	mov	r0, #0
ffff3620:	eb000a95 	bl	check_sum
ffff3624:	e3500000 	cmp	r0, #0
ffff3628:	1a00000a 	bne	0xffff3658

ffff362c:	e3560000 	cmp	r6, #0
ffff3630:	1a000002 	bne	0xffff3640
ffff3634:	e3a00000 	mov	r0, #0
ffff3638:	e5c50028 	strb	r0, [r5, #40]	; 0x28
ffff363c:	ea000003 	b	0xffff3650
ffff3640:	e3560002 	cmp	r6, #2
ffff3644:	1a000001 	bne	0xffff3650
ffff3648:	e3a00002 	mov	r0, #2
ffff364c:	e5c50028 	strb	r0, [r5, #40]	; 0x28
ffff3650:	e3a07000 	mov	r7, #0
ffff3654:	ea000000 	b	0xffff365c

ffff3658:	e3e07000 	mvn	r7, #0
ffff365c:	e320f000 	nop	{0}

ffff3660:	e28d1018 	add	r1, sp, #24
ffff3664:	e1a00006 	mov	r0, r6
ffff3668:	eb00086a 	bl	0xffff5818
ffff366c:	e1a00007 	mov	r0, r7
ffff3670:	e28dd064 	add	sp, sp, #100	; 0x64
ffff3674:	e8bd80f0 	pop	{r4, r5, r6, r7, pc}
;;; *****************************************************************************

	;; Global Offset Table
ffff3678:	005b8d80
ffff367c:	4e4f4765	.ascii	"eGON"
ffff3680:	3054422e	.ascii	".BT0"
ffff3684:	00000000

;;;*****************************************************************************
reset_counter:
ffff3688:	e3a00001 	mov	r0, #1
ffff368c:	e59f1e64 	ldr	r1, [pc, #3684]	; 0xffff44f8 =0x01c20cd0 CNT64_TEST_REG
ffff3690:	e5810000 	str	r0, [r1]
ffff3694:	e12fff1e 	bx	lr

;;;*****************************************************************************
get_counter:
ffff3698:	e92d4030 	push	{r4, r5, lr}
ffff369c:	e320f000 	nop	{0}
ffff36a0:	e3a00002 	mov	r0, #2
ffff36a4:	e59f1e4c 	ldr	r1, [pc, #3660]	; 0xffff44f8 =0x01c20cd0 CNT64_TEST_REG
ffff36a8:	e5810000 	str	r0, [r1]	; CNT64_RL_EN = 0x1
ffff36ac:	e1810100 	orr	r0, r1, r0, lsl #2 ; r0 = 0x01c20cd8 CNT64_HIGH_REG
ffff36b0:	e5902000 	ldr	r2, [r0]	; load CNT64_HIGH_REG
ffff36b4:	e1a03002 	mov	r3, r2
ffff36b8:	e3a02000 	mov	r2, #0
ffff36bc:	e2400004 	sub	r0, r0, #4 	; r0 = 0x01c20cd4 CNT64_LOW_REG
ffff36c0:	e5900000 	ldr	r0, [r0]	; load CNT64_LOW_REG
ffff36c4:	e1822000 	orr	r2, r2, r0
ffff36c8:	e1a00002 	mov	r0, r2
ffff36cc:	e1a01003 	mov	r1, r3
ffff36d0:	e8bd8030 	pop	{r4, r5, pc} 	; r0 = CNT64_LOW, r1 = CNT64_HIGH

;;;*****************************************************************************
ffff36d4:	e92d4ff0 	push	{r4, r5, r6, r7, r8, r9, sl, fp, lr}
ffff36d8:	e1a04000 	mov	r4, r0
ffff36dc:	e1a05001 	mov	r5, r1
ffff36e0:	e1a01185 	lsl	r1, r5, #3
ffff36e4:	e1810ea4 	orr	r0, r1, r4, lsr #29
ffff36e8:	e1a01184 	lsl	r1, r4, #3
ffff36ec:	e1a03205 	lsl	r3, r5, #4
ffff36f0:	e1832e24 	orr	r2, r3, r4, lsr #28
ffff36f4:	e1a03204 	lsl	r3, r4, #4
ffff36f8:	e091a003 	adds	sl, r1, r3
ffff36fc:	e0a0b002 	adc	fp, r0, r2
ffff3700:	ebffffe4 	bl	get_counter
ffff3704:	e1a08000 	mov	r8, r0
ffff3708:	e1a09001 	mov	r9, r1
ffff370c:	e320f000 	nop	{0}
ffff3710:	ebffffe0 	bl	get_counter
ffff3714:	e0506008 	subs	r6, r0, r8
ffff3718:	e0c17009 	sbc	r7, r1, r9
ffff371c:	e056000a 	subs	r0, r6, sl
ffff3720:	e0d7000b 	sbcs	r0, r7, fp
ffff3724:	3afffff9 	bcc	0xffff3710
ffff3728:	e8bd8ff0 	pop	{r4, r5, r6, r7, r8, r9, sl, fp, pc}

;;; *****************************************************************************
ffff372c:	e92d4030 	push	{r4, r5, lr}
ffff3730:	e1a04000 	mov	r4, r0
ffff3734:	e1a05001 	mov	r5, r1
ffff3738:	ea000002 	b	0xffff3748

ffff373c:	e3000320 	movw	r0, #800	; 0x320
ffff3740:	e3a01000 	mov	r1, #0
ffff3744:	ebffffe2 	bl	0xffff36d4

ffff3748:	e1a01004 	mov	r1, r4
ffff374c:	e1a00005 	mov	r0, r5
ffff3750:	e2544001 	subs	r4, r4, #1
ffff3754:	e2c55000 	sbc	r5, r5, #0
ffff3758:	e3a03000 	mov	r3, #0
ffff375c:	e0211003 	eor	r1, r1, r3
ffff3760:	e0200003 	eor	r0, r0, r3
ffff3764:	e1900001 	orrs	r0, r0, r1
ffff3768:	1afffff3 	bne	0xffff373c

ffff376c:	e8bd8030 	pop	{r4, r5, pc}

;;;*****************************************************************************
init_SDC:
ffff3770:	e3500002 	cmp	r0, #2 		;  r0 = card_no, r1 = structure
ffff3774:	1a00001d 	bne	.init_SDC0	; SDC0

.init_SDC2:
ffff3778:	e59f2d7c 	ldr	r2, [pc, #3452]	; 0xffff44fc =0b01 01 01 01 01 01 01 01 01 01 01
ffff377c:	e59f3d7c 	ldr	r3, [pc, #3452]	; 0xffff4500 =0x01c20864 PC_PUL0
ffff3780:	e5832000 	str	r2, [r3]	; enable pull-up on PC0-10
ffff3784:	e59f2d78 	ldr	r2, [pc, #3448]	; 0xffff4504 =0b10 10 10 10 10 10 10 10
ffff3788:	e243301c 	sub	r3, r3, #28	; PC_CFG0_REG
ffff378c:	e5832000 	str	r2, [r3]	; configure PC as SDC2 function
ffff3790:	e3002222 	movw	r2, #546	; 0x222
ffff3794:	e18331c2 	orr	r3, r3, r2, asr #3 ; PC_CFG1_REG
ffff3798:	e5832000 	str	r2, [r3]	; configure PC as SDC2 function
ffff379c:	e59f2d64 	ldr	r2, [pc, #3428]	; 0xffff4508 =0x01c20000 CCU_BASE
ffff37a0:	e59222c0 	ldr	r2, [r2, #704]	; 0x2c0 0x01c202c0
ffff37a4:	e3822b01 	orr	r2, r2, #1024	; 0x400
ffff37a8:	e59f3d58 	ldr	r3, [pc, #3416]	; 0xffff4508 =0x01c20000 CCU_BASE
ffff37ac:	e58322c0 	str	r2, [r3, #704]	; 0x2c0 0x01c202c0
ffff37b0:	e1a02003 	mov	r2, r3
ffff37b4:	e5922060 	ldr	r2, [r2, #96]	; 0x60
ffff37b8:	e3822b01 	orr	r2, r2, #1024	; 0x400
ffff37bc:	e5832060 	str	r2, [r3, #96]	; 0x60
ffff37c0:	e3a02102 	mov	r2, #-2147483648	; 0x80000000
ffff37c4:	e5832090 	str	r2, [r3, #144]	; 0x90
ffff37c8:	e2432a0f 	sub	r2, r3, #61440	; 0xf000
ffff37cc:	e5812000 	str	r2, [r1]
ffff37d0:	e5912000 	ldr	r2, [r1]
ffff37d4:	e2822c02 	add	r2, r2, #512	; 0x200
ffff37d8:	e5812010 	str	r2, [r1, #16]
ffff37dc:	e2832090 	add	r2, r3, #144	; 0x90
ffff37e0:	e5812008 	str	r2, [r1, #8]
ffff37e4:	e59f2d20 	ldr	r2, [pc, #3360]	; 0xffff450c =0x016e3600 (24000000)
ffff37e8:	e581200c 	str	r2, [r1, #12]
ffff37ec:	ea000019 	b	0xffff3858

.init_SDC0:
ffff37f0:	e3002565 	movw	r2, #1381	; 0x565 =0b00 01 01 01 10 01 01
ffff37f4:	e59f3d14 	ldr	r3, [pc, #3348]	; 0xffff4510 =0x01c208d0 PF_PUL0
ffff37f8:	e5832000 	str	r2, [r3]	; enable pull-down on PF2, enable pull-up on PF0-1/PF3-5, disable pull-up/down on PF6
ffff37fc:	e59f2d10 	ldr	r2, [pc, #3344]	; 0xffff4514 =0b111 0 010 0 010 0 010 0 010 0 010 0 010
ffff3800:	e0433b42 	sub	r3, r3, r2, asr #22 ; PF_CFG0_REG
ffff3804:	e5832000 	str	r2, [r3]	; configure PF as SDC0 function except for PF6
ffff3808:	e59f2cf8 	ldr	r2, [pc, #3320]	; 0xffff4508 =0x01c20000 CCU_BASE
ffff380c:	e59222c0 	ldr	r2, [r2, #704]	; 0x2c0
ffff3810:	e3822c01 	orr	r2, r2, #256	; 0x100
ffff3814:	e59f3cec 	ldr	r3, [pc, #3308]	; 0xffff4508 =0x01c20000 CCU_BASE
ffff3818:	e58322c0 	str	r2, [r3, #704]	; 0x2c0
ffff381c:	e1a02003 	mov	r2, r3
ffff3820:	e5922060 	ldr	r2, [r2, #96]	; 0x60
ffff3824:	e3822c01 	orr	r2, r2, #256	; 0x100
ffff3828:	e5832060 	str	r2, [r3, #96]	; 0x60
ffff382c:	e3a02102 	mov	r2, #-2147483648	; 0x80000000
ffff3830:	e5832088 	str	r2, [r3, #136]	; 0x88
ffff3834:	e2432a11 	sub	r2, r3, #69632	; 0x11000
ffff3838:	e5812000 	str	r2, [r1]
ffff383c:	e5912000 	ldr	r2, [r1]
ffff3840:	e2822c02 	add	r2, r2, #512	; 0x200
ffff3844:	e5812010 	str	r2, [r1, #16]
ffff3848:	e2832088 	add	r2, r3, #136	; 0x88
ffff384c:	e5812008 	str	r2, [r1, #8]
ffff3850:	e59f2cb4 	ldr	r2, [pc, #3252]	; 0xffff450c =0x016e3600 (24000000)
ffff3854:	e581200c 	str	r2, [r1, #12]

ffff3858:	e3a02000 	mov	r2, #0
ffff385c:	e5812004 	str	r2, [r1, #4]
ffff3860:	e12fff1e 	bx	lr
;;;*****************************************************************************

ffff3864:	e3500002 	cmp	r0, #2
ffff3868:	1a000019 	bne	0xffff38d4

ffff386c:	e59f2ca4 	ldr	r2, [pc, #3236]	; 0xffff4518 =0x77777777
ffff3870:	e59f3ca4 	ldr	r3, [pc, #3236]	; 0xffff451c =0x01c20848 PC_CFG0
ffff3874:	e5832000 	str	r2, [r3]
ffff3878:	e2833004 	add	r3, r3, #4
ffff387c:	e5832000 	str	r2, [r3]
ffff3880:	e3002777 	movw	r2, #1911	; 0x777
ffff3884:	e2833004 	add	r3, r3, #4
ffff3888:	e5832000 	str	r2, [r3]
ffff388c:	e3052140 	movw	r2, #20800	; 0x5140
ffff3890:	e0833542 	add	r3, r3, r2, asr #10
ffff3894:	e5832000 	str	r2, [r3]
ffff3898:	e3a02014 	mov	r2, #20
ffff389c:	e2833004 	add	r3, r3, #4
ffff38a0:	e5832000 	str	r2, [r3]
ffff38a4:	e3a02000 	mov	r2, #0
ffff38a8:	e59f3c58 	ldr	r3, [pc, #3160]	; 0xffff4508 =0x01c20000 CCU_BASE
ffff38ac:	e5832090 	str	r2, [r3, #144]	; 0x90
ffff38b0:	e1c32002 	bic	r2, r3, r2
ffff38b4:	e5922060 	ldr	r2, [r2, #96]	; 0x60
ffff38b8:	e3c22b01 	bic	r2, r2, #1024	; 0x400
ffff38bc:	e5832060 	str	r2, [r3, #96]	; 0x60
ffff38c0:	e1a02003 	mov	r2, r3
ffff38c4:	e59222c0 	ldr	r2, [r2, #704]	; 0x2c0
ffff38c8:	e3c22b01 	bic	r2, r2, #1024	; 0x400
ffff38cc:	e58322c0 	str	r2, [r3, #704]	; 0x2c0
ffff38d0:	ea00000f 	b	0xffff3914

ffff38d4:	e59f2c44 	ldr	r2, [pc, #3140]	; 0xffff4520 =0x07373733
ffff38d8:	e59f3c44 	ldr	r3, [pc, #3140]	; 0xffff4524 =0x01c208b4 PF_CFG0
ffff38dc:	e5832000 	str	r2, [r3]
ffff38e0:	e3a02000 	mov	r2, #0
ffff38e4:	e283301c 	add	r3, r3, #28
ffff38e8:	e5832000 	str	r2, [r3]
ffff38ec:	e2433e8d 	sub	r3, r3, #2256	; 0x8d0
ffff38f0:	e5832088 	str	r2, [r3, #136]	; 0x88
ffff38f4:	e1c32002 	bic	r2, r3, r2
ffff38f8:	e5922060 	ldr	r2, [r2, #96]	; 0x60
ffff38fc:	e3c22c01 	bic	r2, r2, #256	; 0x100
ffff3900:	e5832060 	str	r2, [r3, #96]	; 0x60
ffff3904:	e1a02003 	mov	r2, r3
ffff3908:	e59222c0 	ldr	r2, [r2, #704]	; 0x2c0
ffff390c:	e3c22c01 	bic	r2, r2, #256	; 0x100
ffff3910:	e58322c0 	str	r2, [r3, #704]	; 0x2c0
ffff3914:	e12fff1e 	bx	lr

;;;********************************************************************************
ffff3918:	e92d4070 	push	{r4, r5, r6, lr}
ffff391c:	e1a02000 	mov	r2, r0
ffff3920:	e5924000 	ldr	r4, [r2]
ffff3924:	e5941000 	ldr	r1, [r4]
ffff3928:	e3003190 	movw	r3, #400	; 0x190
ffff392c:	e59f5bf4 	ldr	r5, [pc, #3060]	; 0xffff4528 =0x80202000
ffff3930:	e5815018 	str	r5, [r1, #24]
ffff3934:	e320f000 	nop	{0}

ffff3938:	e5910018 	ldr	r0, [r1, #24]
ffff393c:	e3100102 	tst	r0, #-2147483648	; 0x80000000
ffff3940:	0a000002 	beq	0xffff3950

ffff3944:	e1b00003 	movs	r0, r3
ffff3948:	e2433001 	sub	r3, r3, #1
ffff394c:	1afffff9 	bne	0xffff3938

ffff3950:	e3530000 	cmp	r3, #0
ffff3954:	ca000001 	bgt	0xffff3960

ffff3958:	e3e00000 	mvn	r0, #0

ffff395c:	e8bd8070 	pop	{r4, r5, r6, pc}

ffff3960:	e3e00000 	mvn	r0, #0
ffff3964:	e5810038 	str	r0, [r1, #56]	; 0x38
ffff3968:	e3a00000 	mov	r0, #0
ffff396c:	eafffffa 	b	0xffff395c

;;;********************************************************************************
ffff3970:	e92d4ffe 	push	{r1, r2, r3, r4, r5, r6, r7, r8, r9, sl, fp, lr}
ffff3974:	e1a0a000 	mov	sl, r0
ffff3978:	e59a0000 	ldr	r0, [sl]
ffff397c:	e58d0008 	str	r0, [sp, #8]
ffff3980:	e59d0008 	ldr	r0, [sp, #8]
ffff3984:	e5900000 	ldr	r0, [r0]
ffff3988:	e58d0004 	str	r0, [sp, #4]
ffff398c:	e3a00000 	mov	r0, #0
ffff3990:	e58d0000 	str	r0, [sp]
ffff3994:	e3a0b000 	mov	fp, #0
ffff3998:	e320f000 	nop	{0}
ffff399c:	e320f000 	nop	{0}
ffff39a0:	e320f000 	nop	{0}
ffff39a4:	ebffff3b 	bl	get_counter
ffff39a8:	e1a08000 	mov	r8, r0
ffff39ac:	e1a09001 	mov	r9, r1
ffff39b0:	e30f6fff 	movw	r6, #65535	; 0xffff
ffff39b4:	e3a07000 	mov	r7, #0
ffff39b8:	e320f000 	nop	{0}

ffff39bc:	ebffff35 	bl	get_counter
ffff39c0:	e0504008 	subs	r4, r0, r8
ffff39c4:	e0c15009 	sbc	r5, r1, r9
ffff39c8:	e59d0004 	ldr	r0, [sp, #4]
ffff39cc:	e590b000 	ldr	fp, [r0]
ffff39d0:	e31b0007 	tst	fp, #7
ffff39d4:	1a000001 	bne	0xffff39e0

ffff39d8:	e3a00000 	mov	r0, #0

ffff39dc:	e8bd8ffe 	pop	{r1, r2, r3, r4, r5, r6, r7, r8, r9, sl, fp, pc}

ffff39e0:	e0540006 	subs	r0, r4, r6
ffff39e4:	e0d50007 	sbcs	r0, r5, r7
ffff39e8:	3afffff3 	bcc	0xffff39bc

ffff39ec:	e0540006 	subs	r0, r4, r6
ffff39f0:	e0d50007 	sbcs	r0, r5, r7
ffff39f4:	3a000005 	bcc	0xffff3a10

ffff39f8:	e31b0007 	tst	fp, #7
ffff39fc:	0a000003 	beq	0xffff3a10

ffff3a00:	e3e00006 	mvn	r0, #6
ffff3a04:	e58d0000 	str	r0, [sp]
ffff3a08:	e59d0000 	ldr	r0, [sp]
ffff3a0c:	eafffff2 	b	0xffff39dc

ffff3a10:	e3a00000 	mov	r0, #0
ffff3a14:	eafffff0 	b	0xffff39dc

;;;********************************************************************************
ffff3a18:	e92d43f0 	push	{r4, r5, r6, r7, r8, r9, lr}
ffff3a1c:	e1a07000 	mov	r7, r0
ffff3a20:	e1a05001 	mov	r5, r1
ffff3a24:	e5974000 	ldr	r4, [r7]
ffff3a28:	e5948000 	ldr	r8, [r4]
ffff3a2c:	e3a09000 	mov	r9, #0
ffff3a30:	e3a06010 	mov	r6, #16
ffff3a34:	e320f000 	nop	{0}
ffff3a38:	e5889004 	str	r9, [r8, #4]
ffff3a3c:	e1a00007 	mov	r0, r7
ffff3a40:	ebffffb4 	bl	0xffff3918
ffff3a44:	e3500000 	cmp	r0, #0
ffff3a48:	0a000001 	beq	0xffff3a54

ffff3a4c:	e3e00000 	mvn	r0, #0

ffff3a50:	e8bd83f0 	pop	{r4, r5, r6, r7, r8, r9, pc}

ffff3a54:	e3a00000 	mov	r0, #0
ffff3a58:	e5941008 	ldr	r1, [r4, #8]
ffff3a5c:	e5810000 	str	r0, [r1]
ffff3a60:	e3a06010 	mov	r6, #16
ffff3a64:	e320f000 	nop	{0}

ffff3a68:	e1b00006 	movs	r0, r6
ffff3a6c:	e2466001 	sub	r6, r6, #1
ffff3a70:	1afffffc 	bne	0xffff3a68

ffff3a74:	e59f0ab0 	ldr	r0, [pc, #2736]	; 0xffff452c =0x00061a80 (400000)
ffff3a78:	e1550000 	cmp	r5, r0
ffff3a7c:	8a000003 	bhi	0xffff3a90

ffff3a80:	e59f0aa8 	ldr	r0, [pc, #2728]	; 0xffff4530
ffff3a84:	e5941008 	ldr	r1, [r4, #8]
ffff3a88:	e5810000 	str	r0, [r1]
ffff3a8c:	ea000009 	b	0xffff3ab8

ffff3a90:	e59f0a9c 	ldr	r0, [pc, #2716]	; 0xffff4534
ffff3a94:	e1550000 	cmp	r5, r0
ffff3a98:	8a000003 	bhi	0xffff3aac

ffff3a9c:	e3a00802 	mov	r0, #131072	; 0x20000
ffff3aa0:	e5941008 	ldr	r1, [r4, #8]
ffff3aa4:	e5810000 	str	r0, [r1]
ffff3aa8:	ea000002 	b	0xffff3ab8

ffff3aac:	e3a00801 	mov	r0, #65536	; 0x10000
ffff3ab0:	e5941008 	ldr	r1, [r4, #8]
ffff3ab4:	e5810000 	str	r0, [r1]

ffff3ab8:	e3a06010 	mov	r6, #16
ffff3abc:	e320f000 	nop	{0}

ffff3ac0:	e1b00006 	movs	r0, r6
ffff3ac4:	e2466001 	sub	r6, r6, #1
ffff3ac8:	1afffffc 	bne	0xffff3ac0

ffff3acc:	e5940008 	ldr	r0, [r4, #8]
ffff3ad0:	e5900000 	ldr	r0, [r0]
ffff3ad4:	e3800102 	orr	r0, r0, #-2147483648	; 0x80000000
ffff3ad8:	e5941008 	ldr	r1, [r4, #8]
ffff3adc:	e5810000 	str	r0, [r1]
ffff3ae0:	e3a06010 	mov	r6, #16
ffff3ae4:	e320f000 	nop	{0}

ffff3ae8:	e1b00006 	movs	r0, r6
ffff3aec:	e2466001 	sub	r6, r6, #1
ffff3af0:	1afffffc 	bne	0xffff3ae8

ffff3af4:	e3a09801 	mov	r9, #65536	; 0x10000
ffff3af8:	e5889004 	str	r9, [r8, #4]
ffff3afc:	e1a00007 	mov	r0, r7
ffff3b00:	ebffff84 	bl	0xffff3918
ffff3b04:	e3500000 	cmp	r0, #0
ffff3b08:	0a000001 	beq	0xffff3b14

ffff3b0c:	e3e00000 	mvn	r0, #0
ffff3b10:	eaffffce 	b	0xffff3a50

ffff3b14:	e3a00000 	mov	r0, #0
ffff3b18:	eaffffcc 	b	0xffff3a50

;;;********************************************************************************
ffff3b1c:	e92d4070 	push	{r4, r5, r6, lr}
ffff3b20:	e1a04000 	mov	r4, r0
ffff3b24:	e5946000 	ldr	r6, [r4]
ffff3b28:	e5965000 	ldr	r5, [r6]
ffff3b2c:	e3a00000 	mov	r0, #0
ffff3b30:	e5850078 	str	r0, [r5, #120]	; 0x78
ffff3b34:	e3a0001e 	mov	r0, #30
ffff3b38:	e3a01000 	mov	r1, #0
ffff3b3c:	ebfffee4 	bl	0xffff36d4
ffff3b40:	e3a00001 	mov	r0, #1
ffff3b44:	e5850078 	str	r0, [r5, #120]	; 0x78
ffff3b48:	e300012c 	movw	r0, #300	; 0x12c
ffff3b4c:	e3a01000 	mov	r1, #0
ffff3b50:	ebfffedf 	bl	0xffff36d4
ffff3b54:	e8bd8070 	pop	{r4, r5, r6, pc}

;;;********************************************************************************
ffff3b58:	e92d4070 	push	{r4, r5, r6, lr}
ffff3b5c:	e1a04000 	mov	r4, r0
ffff3b60:	e5946000 	ldr	r6, [r4]
ffff3b64:	e5965000 	ldr	r5, [r6]
ffff3b68:	e594001c 	ldr	r0, [r4, #28]
ffff3b6c:	e3500000 	cmp	r0, #0
ffff3b70:	0a000007 	beq	0xffff3b94

ffff3b74:	e594101c 	ldr	r1, [r4, #28]
ffff3b78:	e1a00004 	mov	r0, r4
ffff3b7c:	ebffffa5 	bl	0xffff3a18
ffff3b80:	e3500000 	cmp	r0, #0
ffff3b84:	0a000002 	beq	0xffff3b94

ffff3b88:	e3a00001 	mov	r0, #1
ffff3b8c:	e5860014 	str	r0, [r6, #20]

ffff3b90:	e8bd8070 	pop	{r4, r5, r6, pc}

ffff3b94:	e5940018 	ldr	r0, [r4, #24]
ffff3b98:	e3500004 	cmp	r0, #4
ffff3b9c:	1a000002 	bne	0xffff3bac

ffff3ba0:	e3a00001 	mov	r0, #1
ffff3ba4:	e585000c 	str	r0, [r5, #12]
ffff3ba8:	ea000007 	b	0xffff3bcc

ffff3bac:	e5940018 	ldr	r0, [r4, #24]
ffff3bb0:	e3500008 	cmp	r0, #8
ffff3bb4:	1a000002 	bne	0xffff3bc4
ffff3bb8:	e3a00002 	mov	r0, #2
ffff3bbc:	e585000c 	str	r0, [r5, #12]
ffff3bc0:	ea000001 	b	0xffff3bcc
ffff3bc4:	e3a00000 	mov	r0, #0
ffff3bc8:	e585000c 	str	r0, [r5, #12]

ffff3bcc:	e320f000 	nop	{0}
ffff3bd0:	eaffffee 	b	0xffff3b90

;;;********************************************************************************
ffff3bd4:	e92d40f0 	push	{r4, r5, r6, r7, lr}
ffff3bd8:	e1a05000 	mov	r5, r0
ffff3bdc:	e5957000 	ldr	r7, [r5]
ffff3be0:	e5974000 	ldr	r4, [r7]
ffff3be4:	e3a00007 	mov	r0, #7
ffff3be8:	e5840000 	str	r0, [r4]
ffff3bec:	e1a00005 	mov	r0, r5
ffff3bf0:	ebffff5e 	bl	0xffff3970
ffff3bf4:	e1a06000 	mov	r6, r0
ffff3bf8:	e3560000 	cmp	r6, #0
ffff3bfc:	0a000001 	beq	0xffff3c08

ffff3c00:	e1a00006 	mov	r0, r6

ffff3c04:	e8bd80f0 	pop	{r4, r5, r6, r7, pc}

ffff3c08:	e59f0928 	ldr	r0, [pc, #2344]	; 0xffff4538
ffff3c0c:	e5840040 	str	r0, [r4, #64]	; 0x40
ffff3c10:	e3a00000 	mov	r0, #0
ffff3c14:	e5840030 	str	r0, [r4, #48]	; 0x30
ffff3c18:	e3e00000 	mvn	r0, #0
ffff3c1c:	e5840038 	str	r0, [r4, #56]	; 0x38
ffff3c20:	e30003ff 	movw	r0, #1023	; 0x3ff
ffff3c24:	e5840088 	str	r0, [r4, #136]	; 0x88
ffff3c28:	e3000deb 	movw	r0, #3563	; 0xdeb
ffff3c2c:	e5840050 	str	r0, [r4, #80]	; 0x50
ffff3c30:	e3e00000 	mvn	r0, #0
ffff3c34:	e5840008 	str	r0, [r4, #8]
ffff3c38:	e3a00000 	mov	r0, #0
ffff3c3c:	eafffff0 	b	0xffff3c04

;;;********************************************************************************
ffff3c40:	e92d43f0 	push	{r4, r5, r6, r7, r8, r9, lr}
ffff3c44:	e1a07000 	mov	r7, r0
ffff3c48:	e5974000 	ldr	r4, [r7]
ffff3c4c:	e5945000 	ldr	r5, [r4]
ffff3c50:	e3a02000 	mov	r2, #0
ffff3c54:	e591000c 	ldr	r0, [r1, #12]
ffff3c58:	e5918008 	ldr	r8, [r1, #8]
ffff3c5c:	e00c0890 	mul	ip, r0, r8
ffff3c60:	e59f68d4 	ldr	r6, [pc, #2260]	; 0xffff453c
ffff3c64:	e3a0e000 	mov	lr, #0
ffff3c68:	e5910004 	ldr	r0, [r1, #4]
ffff3c6c:	e3100001 	tst	r0, #1
ffff3c70:	0a00001c 	beq	0xffff3ce8

ffff3c74:	e5913000 	ldr	r3, [r1]
ffff3c78:	e320f000 	nop	{0}
ffff3c7c:	ea000016 	b	0xffff3cdc

ffff3c80:	e595003c 	ldr	r0, [r5, #60]	; 0x3c
ffff3c84:	e3100004 	tst	r0, #4
ffff3c88:	1a00000e 	bne	0xffff3cc8

ffff3c8c:	e595003c 	ldr	r0, [r5, #60]	; 0x3c
ffff3c90:	e7e4e8d0 	ubfx	lr, r0, #17, #5
ffff3c94:	e35e0000 	cmp	lr, #0
ffff3c98:	1a000000 	bne	0xffff3ca0

ffff3c9c:	e3a0e020 	mov	lr, #32

ffff3ca0:	ea000005 	b	0xffff3cbc

ffff3ca4:	e5940010 	ldr	r0, [r4, #16]
ffff3ca8:	e5908000 	ldr	r8, [r0]
ffff3cac:	e1a00002 	mov	r0, r2
ffff3cb0:	e2822001 	add	r2, r2, #1
ffff3cb4:	e7838100 	str	r8, [r3, r0, lsl #2]
ffff3cb8:	e59f687c 	ldr	r6, [pc, #2172]	; 0xffff453c

ffff3cbc:	e1b0000e 	movs	r0, lr
ffff3cc0:	e24ee001 	sub	lr, lr, #1
ffff3cc4:	1afffff6 	bne	0xffff3ca4

ffff3cc8:	e1b00006 	movs	r0, r6
ffff3ccc:	e2466001 	sub	r6, r6, #1
ffff3cd0:	1a000001 	bne	0xffff3cdc

ffff3cd4:	e3e00000 	mvn	r0, #0

ffff3cd8:	e8bd83f0 	pop	{r4, r5, r6, r7, r8, r9, pc}

ffff3cdc:	e152012c 	cmp	r2, ip, lsr #2
ffff3ce0:	3affffe6 	bcc	0xffff3c80

ffff3ce4:	ea000014 	b	0xffff3d3c

ffff3ce8:	e5913000 	ldr	r3, [r1]
ffff3cec:	e3a02000 	mov	r2, #0
ffff3cf0:	ea00000f 	b	0xffff3d34

ffff3cf4:	e320f000 	nop	{0}

ffff3cf8:	e2460001 	sub	r0, r6, #1
ffff3cfc:	e1b06000 	movs	r6, r0
ffff3d00:	0a000002 	beq	0xffff3d10

ffff3d04:	e595003c 	ldr	r0, [r5, #60]	; 0x3c
ffff3d08:	e3100008 	tst	r0, #8
ffff3d0c:	1afffff9 	bne	0xffff3cf8

ffff3d10:	e3560000 	cmp	r6, #0
ffff3d14:	ca000001 	bgt	0xffff3d20

ffff3d18:	e3e00000 	mvn	r0, #0
ffff3d1c:	eaffffed 	b	0xffff3cd8

ffff3d20:	e7930102 	ldr	r0, [r3, r2, lsl #2]
ffff3d24:	e5948010 	ldr	r8, [r4, #16]
ffff3d28:	e5880000 	str	r0, [r8]
ffff3d2c:	e59f680c 	ldr	r6, [pc, #2060]	; 0xffff4540
ffff3d30:	e2822001 	add	r2, r2, #1
ffff3d34:	e152012c 	cmp	r2, ip, lsr #2
ffff3d38:	3affffed 	bcc	0xffff3cf4

ffff3d3c:	e3a00000 	mov	r0, #0
ffff3d40:	eaffffe4 	b	0xffff3cd8

;;;********************************************************************************
ffff3d44:	e92d4ff3 	push	{r0, r1, r4, r5, r6, r7, r8, r9, sl, fp, lr}
ffff3d48:	e24dd014 	sub	sp, sp, #20
ffff3d4c:	e1a07001 	mov	r7, r1
ffff3d50:	e59d0014 	ldr	r0, [sp, #20]
ffff3d54:	e5900000 	ldr	r0, [r0]
ffff3d58:	e58d0010 	str	r0, [sp, #16]
ffff3d5c:	e59d0010 	ldr	r0, [sp, #16]
ffff3d60:	e5906000 	ldr	r6, [r0]
ffff3d64:	e59d0010 	ldr	r0, [sp, #16]
ffff3d68:	e5904004 	ldr	r4, [r0, #4]
ffff3d6c:	e597000c 	ldr	r0, [r7, #12]
ffff3d70:	e5971008 	ldr	r1, [r7, #8]
ffff3d74:	e0000190 	mul	r0, r0, r1
ffff3d78:	e58d000c 	str	r0, [sp, #12]
ffff3d7c:	e3a000ff 	mov	r0, #255	; 0xff
ffff3d80:	e58d0008 	str	r0, [sp, #8]
ffff3d84:	e3a05000 	mov	r5, #0
ffff3d88:	e3a0a000 	mov	sl, #0
ffff3d8c:	e3a00000 	mov	r0, #0
ffff3d90:	e58d0000 	str	r0, [sp]
ffff3d94:	e3a08000 	mov	r8, #0
ffff3d98:	e5970004 	ldr	r0, [r7, #4]
ffff3d9c:	e3100001 	tst	r0, #1
ffff3da0:	0a000001 	beq	0xffff3dac

ffff3da4:	e5970000 	ldr	r0, [r7]
ffff3da8:	ea000000 	b	0xffff3db0

ffff3dac:	e5970000 	ldr	r0, [r7]

ffff3db0:	e58d0004 	str	r0, [sp, #4]
ffff3db4:	e59d000c 	ldr	r0, [sp, #12]
ffff3db8:	e1a0a7a0 	lsr	sl, r0, #15
ffff3dbc:	e59d000c 	ldr	r0, [sp, #12]
ffff3dc0:	e7df079f 	bfc	r0, #15, #17
ffff3dc4:	e58d0000 	str	r0, [sp]
ffff3dc8:	e59d0000 	ldr	r0, [sp]
ffff3dcc:	e3500000 	cmp	r0, #0
ffff3dd0:	0a000001 	beq	0xffff3ddc

ffff3dd4:	e28aa001 	add	sl, sl, #1
ffff3dd8:	ea000001 	b	0xffff3de4

ffff3ddc:	e3080000 	movw	r0, #32768	; 0x8000
ffff3de0:	e58d0000 	str	r0, [sp]

ffff3de4:	e3a08000 	mov	r8, #0
ffff3de8:	ea000045 	b	0xffff3f04

ffff3dec:	e0840205 	add	r0, r4, r5, lsl #4
ffff3df0:	e3a01000 	mov	r1, #0
ffff3df4:	e5801000 	str	r1, [r0]
ffff3df8:	e5801004 	str	r1, [r0, #4]
ffff3dfc:	e5801008 	str	r1, [r0, #8]
ffff3e00:	e580100c 	str	r1, [r0, #12]
ffff3e04:	e7940205 	ldr	r0, [r4, r5, lsl #4]
ffff3e08:	e3c00010 	bic	r0, r0, #16
ffff3e0c:	e2800010 	add	r0, r0, #16
ffff3e10:	e7840205 	str	r0, [r4, r5, lsl #4]
ffff3e14:	e7940205 	ldr	r0, [r4, r5, lsl #4]
ffff3e18:	e3c00102 	bic	r0, r0, #-2147483648	; 0x80000000
ffff3e1c:	e2800102 	add	r0, r0, #-2147483648	; 0x80000000
ffff3e20:	e7840205 	str	r0, [r4, r5, lsl #4]
ffff3e24:	e7940205 	ldr	r0, [r4, r5, lsl #4]
ffff3e28:	e3c00002 	bic	r0, r0, #2
ffff3e2c:	e2800002 	add	r0, r0, #2
ffff3e30:	e7840205 	str	r0, [r4, r5, lsl #4]
ffff3e34:	e35a0001 	cmp	sl, #1
ffff3e38:	9a000009 	bls	0xffff3e64

ffff3e3c:	e24a0001 	sub	r0, sl, #1
ffff3e40:	e1500008 	cmp	r0, r8
ffff3e44:	0a000006 	beq	0xffff3e64

ffff3e48:	e3080000 	movw	r0, #32768	; 0x8000
ffff3e4c:	e0841205 	add	r1, r4, r5, lsl #4
ffff3e50:	e5911004 	ldr	r1, [r1, #4]
ffff3e54:	e7cf1010 	bfi	r1, r0, #0, #16
ffff3e58:	e0840205 	add	r0, r4, r5, lsl #4
ffff3e5c:	e5801004 	str	r1, [r0, #4]
ffff3e60:	ea000005 	b	0xffff3e7c

ffff3e64:	e0841205 	add	r1, r4, r5, lsl #4
ffff3e68:	e59d0000 	ldr	r0, [sp]
ffff3e6c:	e5911004 	ldr	r1, [r1, #4]
ffff3e70:	e7cf1010 	bfi	r1, r0, #0, #16
ffff3e74:	e0840205 	add	r0, r4, r5, lsl #4
ffff3e78:	e5801004 	str	r1, [r0, #4]

ffff3e7c:	e59d0004 	ldr	r0, [sp, #4]
ffff3e80:	e0800788 	add	r0, r0, r8, lsl #15
ffff3e84:	e0841205 	add	r1, r4, r5, lsl #4
ffff3e88:	e5810008 	str	r0, [r1, #8]
ffff3e8c:	e3580000 	cmp	r8, #0
ffff3e90:	1a000003 	bne	0xffff3ea4

ffff3e94:	e7940205 	ldr	r0, [r4, r5, lsl #4]
ffff3e98:	e3c00008 	bic	r0, r0, #8
ffff3e9c:	e2800008 	add	r0, r0, #8
ffff3ea0:	e7840205 	str	r0, [r4, r5, lsl #4]

ffff3ea4:	e24a0001 	sub	r0, sl, #1
ffff3ea8:	e1500008 	cmp	r0, r8
ffff3eac:	1a00000e 	bne	0xffff3eec

ffff3eb0:	e7940205 	ldr	r0, [r4, r5, lsl #4]
ffff3eb4:	e3c00002 	bic	r0, r0, #2
ffff3eb8:	e7840205 	str	r0, [r4, r5, lsl #4]
ffff3ebc:	e7940205 	ldr	r0, [r4, r5, lsl #4]
ffff3ec0:	e3c00004 	bic	r0, r0, #4
ffff3ec4:	e2800004 	add	r0, r0, #4
ffff3ec8:	e7840205 	str	r0, [r4, r5, lsl #4]
ffff3ecc:	e7940205 	ldr	r0, [r4, r5, lsl #4]
ffff3ed0:	e3c00020 	bic	r0, r0, #32
ffff3ed4:	e2800020 	add	r0, r0, #32
ffff3ed8:	e7840205 	str	r0, [r4, r5, lsl #4]
ffff3edc:	e3a00000 	mov	r0, #0
ffff3ee0:	e0841205 	add	r1, r4, r5, lsl #4
ffff3ee4:	e581000c 	str	r0, [r1, #12]
ffff3ee8:	ea000003 	b	0xffff3efc

ffff3eec:	e2850001 	add	r0, r5, #1
ffff3ef0:	e0840200 	add	r0, r4, r0, lsl #4
ffff3ef4:	e0841205 	add	r1, r4, r5, lsl #4
ffff3ef8:	e581000c 	str	r0, [r1, #12]

ffff3efc:	e2888001 	add	r8, r8, #1
ffff3f00:	e2855001 	add	r5, r5, #1

ffff3f04:	e158000a 	cmp	r8, sl
ffff3f08:	3affffb7 	bcc	0xffff3dec

ffff3f0c:	e5969000 	ldr	r9, [r6]
ffff3f10:	e3890024 	orr	r0, r9, #36	; 0x24
ffff3f14:	e5860000 	str	r0, [r6]
ffff3f18:	e59d0014 	ldr	r0, [sp, #20]
ffff3f1c:	ebfffe93 	bl	0xffff3970
ffff3f20:	e1a0b000 	mov	fp, r0
ffff3f24:	e35b0000 	cmp	fp, #0
ffff3f28:	0a000002 	beq	0xffff3f38

ffff3f2c:	e1a0000b 	mov	r0, fp

ffff3f30:	e28dd01c 	add	sp, sp, #28
ffff3f34:	e8bd8ff0 	pop	{r4, r5, r6, r7, r8, r9, sl, fp, pc}

ffff3f38:	e3a00001 	mov	r0, #1
ffff3f3c:	e5860080 	str	r0, [r6, #128]	; 0x80
ffff3f40:	e320f000 	nop	{0}

ffff3f44:	e5960080 	ldr	r0, [r6, #128]	; 0x80
ffff3f48:	e3100001 	tst	r0, #1
ffff3f4c:	1a000000 	bne	0xffff3f54

ffff3f50:	ea000005 	b	0xffff3f6c

ffff3f54:	e59d0008 	ldr	r0, [sp, #8]
ffff3f58:	e2400001 	sub	r0, r0, #1
ffff3f5c:	e58d0008 	str	r0, [sp, #8]
ffff3f60:	e59d0008 	ldr	r0, [sp, #8]
ffff3f64:	e3500000 	cmp	r0, #0
ffff3f68:	cafffff5 	bgt	0xffff3f44

ffff3f6c:	e320f000 	nop	{0}
ffff3f70:	e59d0008 	ldr	r0, [sp, #8]
ffff3f74:	e3500000 	cmp	r0, #0
ffff3f78:	1a000001 	bne	0xffff3f84

ffff3f7c:	e3e00006 	mvn	r0, #6
ffff3f80:	eaffffea 	b	0xffff3f30

ffff3f84:	e3a00082 	mov	r0, #130	; 0x82
ffff3f88:	e5860080 	str	r0, [r6, #128]	; 0x80
ffff3f8c:	e596008c 	ldr	r0, [r6, #140]	; 0x8c
ffff3f90:	e3c09003 	bic	r9, r0, #3
ffff3f94:	e5970004 	ldr	r0, [r7, #4]
ffff3f98:	e3100002 	tst	r0, #2
ffff3f9c:	0a000001 	beq	0xffff3fa8

ffff3fa0:	e3899001 	orr	r9, r9, #1
ffff3fa4:	ea000000 	b	0xffff3fac

ffff3fa8:	e3899002 	orr	r9, r9, #2

ffff3fac:	e586908c 	str	r9, [r6, #140]	; 0x8c
ffff3fb0:	e5864084 	str	r4, [r6, #132]	; 0x84
ffff3fb4:	e59f0588 	ldr	r0, [pc, #1416]	; 0xffff4544
ffff3fb8:	e5860040 	str	r0, [r6, #64]	; 0x40
ffff3fbc:	e3a00000 	mov	r0, #0
ffff3fc0:	eaffffda 	b	0xffff3f30

;;;********************************************************************************
ffff3fc4:	e92d4ff7 	push	{r0, r1, r2, r4, r5, r6, r7, r8, r9, sl, fp, lr}
ffff3fc8:	e24dd020 	sub	sp, sp, #32
ffff3fcc:	e1a0b001 	mov	fp, r1
ffff3fd0:	e59d0020 	ldr	r0, [sp, #32]
ffff3fd4:	e5900000 	ldr	r0, [r0]
ffff3fd8:	e58d001c 	str	r0, [sp, #28]
ffff3fdc:	e59d001c 	ldr	r0, [sp, #28]
ffff3fe0:	e590a000 	ldr	sl, [r0]
ffff3fe4:	e3a00102 	mov	r0, #-2147483648	; 0x80000000
ffff3fe8:	e58d0018 	str	r0, [sp, #24]
ffff3fec:	e3a00000 	mov	r0, #0
ffff3ff0:	e58d0014 	str	r0, [sp, #20]
ffff3ff4:	e58d0010 	str	r0, [sp, #16]
ffff3ff8:	e58d000c 	str	r0, [sp, #12]
ffff3ffc:	e58d0008 	str	r0, [sp, #8]
ffff4000:	e320f000 	nop	{0}
ffff4004:	e320f000 	nop	{0}
ffff4008:	e320f000 	nop	{0}
ffff400c:	e59d001c 	ldr	r0, [sp, #28]
ffff4010:	e5900014 	ldr	r0, [r0, #20]
ffff4014:	e3500000 	cmp	r0, #0
ffff4018:	0a000002 	beq	0xffff4028

ffff401c:	e3e00000 	mvn	r0, #0

ffff4020:	e28dd02c 	add	sp, sp, #44	; 0x2c
ffff4024:	e8bd8ff0 	pop	{r4, r5, r6, r7, r8, r9, sl, fp, pc}

ffff4028:	e59b0000 	ldr	r0, [fp]
ffff402c:	e3500000 	cmp	r0, #0
ffff4030:	1a000002 	bne	0xffff4040

ffff4034:	e59d0018 	ldr	r0, [sp, #24]
ffff4038:	e3800902 	orr	r0, r0, #32768	; 0x8000
ffff403c:	e58d0018 	str	r0, [sp, #24]

ffff4040:	e59b0004 	ldr	r0, [fp, #4]
ffff4044:	e3100001 	tst	r0, #1
ffff4048:	0a000002 	beq	0xffff4058

ffff404c:	e59d0018 	ldr	r0, [sp, #24]
ffff4050:	e3800040 	orr	r0, r0, #64	; 0x40
ffff4054:	e58d0018 	str	r0, [sp, #24]

ffff4058:	e59b0004 	ldr	r0, [fp, #4]
ffff405c:	e3100002 	tst	r0, #2
ffff4060:	0a000002 	beq	0xffff4070

ffff4064:	e59d0018 	ldr	r0, [sp, #24]
ffff4068:	e3800080 	orr	r0, r0, #128	; 0x80
ffff406c:	e58d0018 	str	r0, [sp, #24]

ffff4070:	e59b0004 	ldr	r0, [fp, #4]
ffff4074:	e3100004 	tst	r0, #4
ffff4078:	0a000002 	beq	0xffff4088

ffff407c:	e59d0018 	ldr	r0, [sp, #24]
ffff4080:	e3800c01 	orr	r0, r0, #256	; 0x100
ffff4084:	e58d0018 	str	r0, [sp, #24]

ffff4088:	e59b001c 	ldr	r0, [fp, #28]
ffff408c:	e3100001 	tst	r0, #1
ffff4090:	0a000002 	beq	0xffff40a0

ffff4094:	e59d0018 	ldr	r0, [sp, #24]
ffff4098:	e3800405 	orr	r0, r0, #83886080	; 0x5000000
ffff409c:	e58d0018 	str	r0, [sp, #24]

ffff40a0:	e59b0008 	ldr	r0, [fp, #8]
ffff40a4:	e58a001c 	str	r0, [sl, #28]
ffff40a8:	e59d0028 	ldr	r0, [sp, #40]	; 0x28
ffff40ac:	e3500000 	cmp	r0, #0
ffff40b0:	1a000004 	bne	0xffff40c8

ffff40b4:	e59b0000 	ldr	r0, [fp]
ffff40b8:	e59d1018 	ldr	r1, [sp, #24]
ffff40bc:	e1800001 	orr	r0, r0, r1
ffff40c0:	e58a0018 	str	r0, [sl, #24]
ffff40c4:	ea000032 	b	0xffff4194

ffff40c8:	e59d0028 	ldr	r0, [sp, #40]	; 0x28
ffff40cc:	e5900000 	ldr	r0, [r0]
ffff40d0:	e3100003 	tst	r0, #3
ffff40d4:	0a000002 	beq	0xffff40e4

ffff40d8:	e3e00003 	mvn	r0, #3
ffff40dc:	e58d0014 	str	r0, [sp, #20]
ffff40e0:	ea0000e1 	b	0xffff446c

ffff40e4:	e59d0018 	ldr	r0, [sp, #24]
ffff40e8:	e3800c22 	orr	r0, r0, #8704	; 0x2200
ffff40ec:	e58d0018 	str	r0, [sp, #24]
ffff40f0:	e59d0028 	ldr	r0, [sp, #40]	; 0x28
ffff40f4:	e5900004 	ldr	r0, [r0, #4]
ffff40f8:	e3100002 	tst	r0, #2
ffff40fc:	0a000002 	beq	0xffff410c

ffff4100:	e59d0018 	ldr	r0, [sp, #24]
ffff4104:	e3800b01 	orr	r0, r0, #1024	; 0x400
ffff4108:	e58d0018 	str	r0, [sp, #24]

ffff410c:	e59d0028 	ldr	r0, [sp, #40]	; 0x28
ffff4110:	e5900008 	ldr	r0, [r0, #8]
ffff4114:	e59d1028 	ldr	r1, [sp, #40]	; 0x28
ffff4118:	e591100c 	ldr	r1, [r1, #12]
ffff411c:	e0000190 	mul	r0, r0, r1
ffff4120:	e58d0008 	str	r0, [sp, #8]
ffff4124:	e59d0028 	ldr	r0, [sp, #40]	; 0x28
ffff4128:	e590000c 	ldr	r0, [r0, #12]
ffff412c:	e58a0010 	str	r0, [sl, #16]
ffff4130:	e59d0008 	ldr	r0, [sp, #8]
ffff4134:	e58a0014 	str	r0, [sl, #20]
ffff4138:	e59a0000 	ldr	r0, [sl]
ffff413c:	e3800102 	orr	r0, r0, #-2147483648	; 0x80000000
ffff4140:	e58a0000 	str	r0, [sl]
ffff4144:	e59b0000 	ldr	r0, [fp]
ffff4148:	e59d1018 	ldr	r1, [sp, #24]
ffff414c:	e1800001 	orr	r0, r0, r1
ffff4150:	e58a0018 	str	r0, [sl, #24]
ffff4154:	e59b001c 	ldr	r0, [fp, #28]
ffff4158:	e3100001 	tst	r0, #1
ffff415c:	0a000002 	beq	0xffff416c

ffff4160:	e3a00000 	mov	r0, #0
ffff4164:	e58d0014 	str	r0, [sp, #20]
ffff4168:	ea000003 	b	0xffff417c

ffff416c:	e59d0020 	ldr	r0, [sp, #32]
ffff4170:	e59d1028 	ldr	r1, [sp, #40]	; 0x28
ffff4174:	ebfffeb1 	bl	0xffff3c40
ffff4178:	e58d0014 	str	r0, [sp, #20]

ffff417c:	e59d0014 	ldr	r0, [sp, #20]
ffff4180:	e3500000 	cmp	r0, #0
ffff4184:	0a000002 	beq	0xffff4194

ffff4188:	e3e00002 	mvn	r0, #2
ffff418c:	e58d0014 	str	r0, [sp, #20]
ffff4190:	ea0000b5 	b	0xffff446c

ffff4194:	e59b001c 	ldr	r0, [fp, #28]
ffff4198:	e3100001 	tst	r0, #1
ffff419c:	0a000043 	beq	0xffff42b0

ffff41a0:	ebfffd3c 	bl	get_counter
ffff41a4:	e1a08000 	mov	r8, r0
ffff41a8:	e1a09001 	mov	r9, r1
ffff41ac:	e59f6394 	ldr	r6, [pc, #916]	; 0xffff4548
ffff41b0:	e3a07000 	mov	r7, #0
ffff41b4:	e320f000 	nop	{0}

ffff41b8:	ebfffd36 	bl	get_counter
ffff41bc:	e0504008 	subs	r4, r0, r8
ffff41c0:	e0c15009 	sbc	r5, r1, r9
ffff41c4:	e59a0038 	ldr	r0, [sl, #56]	; 0x38
ffff41c8:	e30b19c2 	movw	r1, #47554	; 0xb9c2
ffff41cc:	e1100001 	tst	r0, r1
ffff41d0:	0a000000 	beq	0xffff41d8

ffff41d4:	ea000002 	b	0xffff41e4

ffff41d8:	e0540006 	subs	r0, r4, r6
ffff41dc:	e0d50007 	sbcs	r0, r5, r7
ffff41e0:	3afffff4 	bcc	0xffff41b8

ffff41e4:	e320f000 	nop	{0}
ffff41e8:	e0540006 	subs	r0, r4, r6
ffff41ec:	e0d50007 	sbcs	r0, r5, r7
ffff41f0:	2a000003 	bcs	0xffff4204

ffff41f4:	e59a0038 	ldr	r0, [sl, #56]	; 0x38
ffff41f8:	e30b18c2 	movw	r1, #47298	; 0xb8c2
ffff41fc:	e1100001 	tst	r0, r1
ffff4200:	0a000004 	beq	0xffff4218

ffff4204:	e3e00004 	mvn	r0, #4
ffff4208:	e58d0014 	str	r0, [sp, #20]
ffff420c:	e3a00322 	mov	r0, #-2013265920	; 0x88000000
ffff4210:	e58a0018 	str	r0, [sl, #24]
ffff4214:	ea000094 	b	0xffff446c

ffff4218:	e3000100 	movw	r0, #256	; 0x100
ffff421c:	e58a0038 	str	r0, [sl, #56]	; 0x38
ffff4220:	ebfffd1c 	bl	get_counter
ffff4224:	e1a08000 	mov	r8, r0
ffff4228:	e1a09001 	mov	r9, r1
ffff422c:	e59f6318 	ldr	r6, [pc, #792]	; 0xffff454c
ffff4230:	e3a07000 	mov	r7, #0
ffff4234:	e320f000 	nop	{0}
ffff4238:	ebfffd16 	bl	get_counter
ffff423c:	e0504008 	subs	r4, r0, r8
ffff4240:	e0c15009 	sbc	r5, r1, r9
ffff4244:	e59a0038 	ldr	r0, [sl, #56]	; 0x38
ffff4248:	e30b1ac2 	movw	r1, #47810	; 0xbac2
ffff424c:	e1100001 	tst	r0, r1
ffff4250:	0a000000 	beq	0xffff4258

ffff4254:	ea000002 	b	0xffff4264

ffff4258:	e0540006 	subs	r0, r4, r6
ffff425c:	e0d50007 	sbcs	r0, r5, r7
ffff4260:	3afffff4 	bcc	0xffff4238

ffff4264:	e320f000 	nop	{0}
ffff4268:	e0540006 	subs	r0, r4, r6
ffff426c:	e0d50007 	sbcs	r0, r5, r7
ffff4270:	2a000003 	bcs	0xffff4284

ffff4274:	e59a0038 	ldr	r0, [sl, #56]	; 0x38
ffff4278:	e30b18c2 	movw	r1, #47298	; 0xb8c2
ffff427c:	e1100001 	tst	r0, r1
ffff4280:	0a000004 	beq	0xffff4298

ffff4284:	e3e00005 	mvn	r0, #5
ffff4288:	e58d0014 	str	r0, [sp, #20]
ffff428c:	e3a00322 	mov	r0, #-2013265920	; 0x88000000
ffff4290:	e58a0018 	str	r0, [sl, #24]
ffff4294:	ea000074 	b	0xffff446c

ffff4298:	e3000200 	movw	r0, #512	; 0x200
ffff429c:	e58a0038 	str	r0, [sl, #56]	; 0x38
ffff42a0:	e59d0020 	ldr	r0, [sp, #32]
ffff42a4:	e59d1028 	ldr	r1, [sp, #40]	; 0x28
ffff42a8:	ebfffe64 	bl	0xffff3c40
ffff42ac:	e58d0014 	str	r0, [sp, #20]

ffff42b0:	ebfffcf8 	bl	get_counter
ffff42b4:	e1a08000 	mov	r8, r0
ffff42b8:	e1a09001 	mov	r9, r1
ffff42bc:	e3056dc0 	movw	r6, #24000	; 0x5dc0
ffff42c0:	e3a07000 	mov	r7, #0
ffff42c4:	e320f000 	nop	{0}

ffff42c8:	ebfffcf2 	bl	get_counter
ffff42cc:	e0504008 	subs	r4, r0, r8
ffff42d0:	e0c15009 	sbc	r5, r1, r9
ffff42d4:	e59a0038 	ldr	r0, [sl, #56]	; 0x38
ffff42d8:	e58d0010 	str	r0, [sp, #16]
ffff42dc:	e30b0bc6 	movw	r0, #48070	; 0xbbc6
ffff42e0:	e59d1010 	ldr	r1, [sp, #16]
ffff42e4:	e1100001 	tst	r0, r1
ffff42e8:	0a000000 	beq	0xffff42f0

ffff42ec:	ea000002 	b	0xffff42fc

ffff42f0:	e0540006 	subs	r0, r4, r6
ffff42f4:	e0d50007 	sbcs	r0, r5, r7
ffff42f8:	3afffff2 	bcc	0xffff42c8

ffff42fc:	e320f000 	nop	{0}
ffff4300:	e0540006 	subs	r0, r4, r6
ffff4304:	e0d50007 	sbcs	r0, r5, r7
ffff4308:	2a000003 	bcs	0xffff431c

ffff430c:	e30b0bc2 	movw	r0, #48066	; 0xbbc2
ffff4310:	e59d1010 	ldr	r1, [sp, #16]
ffff4314:	e1100001 	tst	r0, r1
ffff4318:	0a000002 	beq	0xffff4328

ffff431c:	e3e00001 	mvn	r0, #1
ffff4320:	e58d0014 	str	r0, [sp, #20]
ffff4324:	ea000050 	b	0xffff446c

ffff4328:	e59d0028 	ldr	r0, [sp, #40]	; 0x28
ffff432c:	e3500000 	cmp	r0, #0
ffff4330:	0a000022 	beq	0xffff43c0

ffff4334:	e3a00000 	mov	r0, #0
ffff4338:	e58d0000 	str	r0, [sp]
ffff433c:	ebfffcd5 	bl	get_counter
ffff4340:	e1a08000 	mov	r8, r0
ffff4344:	e1a09001 	mov	r9, r1
ffff4348:	e59f6200 	ldr	r6, [pc, #512]	; 0xffff4550
ffff434c:	e3a07000 	mov	r7, #0
ffff4350:	e30b0bca 	movw	r0, #48074	; 0xbbca
ffff4354:	e58d0000 	str	r0, [sp]
ffff4358:	e320f000 	nop	{0}

ffff435c:	ebfffccd 	bl	get_counter
ffff4360:	e0504008 	subs	r4, r0, r8
ffff4364:	e0c15009 	sbc	r5, r1, r9
ffff4368:	e59a0038 	ldr	r0, [sl, #56]	; 0x38
ffff436c:	e58d0010 	str	r0, [sp, #16]
ffff4370:	e59d0000 	ldr	r0, [sp]
ffff4374:	e59d1010 	ldr	r1, [sp, #16]
ffff4378:	e1100001 	tst	r0, r1
ffff437c:	0a000000 	beq	0xffff4384

ffff4380:	ea000002 	b	0xffff4390

ffff4384:	e0540006 	subs	r0, r4, r6
ffff4388:	e0d50007 	sbcs	r0, r5, r7
ffff438c:	3afffff2 	bcc	0xffff435c

ffff4390:	e320f000 	nop	{0}
ffff4394:	e0540006 	subs	r0, r4, r6
ffff4398:	e0d50007 	sbcs	r0, r5, r7
ffff439c:	2a000003 	bcs	0xffff43b0

ffff43a0:	e30b0bc2 	movw	r0, #48066	; 0xbbc2
ffff43a4:	e59d1010 	ldr	r1, [sp, #16]
ffff43a8:	e1100001 	tst	r0, r1
ffff43ac:	0a000002 	beq	0xffff43bc

ffff43b0:	e3e00002 	mvn	r0, #2
ffff43b4:	e58d0014 	str	r0, [sp, #20]
ffff43b8:	ea00002b 	b	0xffff446c

ffff43bc:	e320f000 	nop	{0}

ffff43c0:	e59b0004 	ldr	r0, [fp, #4]
ffff43c4:	e3100008 	tst	r0, #8
ffff43c8:	0a000018 	beq	0xffff4430

ffff43cc:	ebfffcb1 	bl	get_counter
ffff43d0:	e1a08000 	mov	r8, r0
ffff43d4:	e1a09001 	mov	r9, r1
ffff43d8:	e59f6174 	ldr	r6, [pc, #372]	; 0xffff4554
ffff43dc:	e3a07000 	mov	r7, #0
ffff43e0:	e320f000 	nop	{0}

ffff43e4:	ebfffcab 	bl	get_counter
ffff43e8:	e0504008 	subs	r4, r0, r8
ffff43ec:	e0c15009 	sbc	r5, r1, r9
ffff43f0:	e59a003c 	ldr	r0, [sl, #60]	; 0x3c
ffff43f4:	e58d0010 	str	r0, [sp, #16]
ffff43f8:	e59d0010 	ldr	r0, [sp, #16]
ffff43fc:	e3100c02 	tst	r0, #512	; 0x200
ffff4400:	1a000000 	bne	0xffff4408

ffff4404:	ea000002 	b	0xffff4414

ffff4408:	e0540006 	subs	r0, r4, r6
ffff440c:	e0d50007 	sbcs	r0, r5, r7
ffff4410:	3afffff3 	bcc	0xffff43e4

ffff4414:	e320f000 	nop	{0}
ffff4418:	e0540006 	subs	r0, r4, r6
ffff441c:	e0d50007 	sbcs	r0, r5, r7
ffff4420:	3a000002 	bcc	0xffff4430

ffff4424:	e3e00002 	mvn	r0, #2
ffff4428:	e58d0014 	str	r0, [sp, #20]
ffff442c:	ea00000e 	b	0xffff446c

ffff4430:	e59b0004 	ldr	r0, [fp, #4]
ffff4434:	e3100002 	tst	r0, #2
ffff4438:	0a000008 	beq	0xffff4460

ffff443c:	e59a002c 	ldr	r0, [sl, #44]	; 0x2c
ffff4440:	e58b000c 	str	r0, [fp, #12]
ffff4444:	e59a0028 	ldr	r0, [sl, #40]	; 0x28
ffff4448:	e58b0010 	str	r0, [fp, #16]
ffff444c:	e59a0024 	ldr	r0, [sl, #36]	; 0x24
ffff4450:	e58b0014 	str	r0, [fp, #20]
ffff4454:	e59a0020 	ldr	r0, [sl, #32]
ffff4458:	e58b0018 	str	r0, [fp, #24]
ffff445c:	ea000001 	b	0xffff4468

ffff4460:	e59a0020 	ldr	r0, [sl, #32]
ffff4464:	e58b000c 	str	r0, [fp, #12]

ffff4468:	e320f000 	nop	{0}

ffff446c:	e59d0028 	ldr	r0, [sp, #40]	; 0x28
ffff4470:	e3500000 	cmp	r0, #0
ffff4474:	0a00000c 	beq	0xffff44ac

ffff4478:	e59d000c 	ldr	r0, [sp, #12]
ffff447c:	e3500000 	cmp	r0, #0
ffff4480:	0a000009 	beq	0xffff44ac

ffff4484:	e59a0088 	ldr	r0, [sl, #136]	; 0x88
ffff4488:	e58d0010 	str	r0, [sp, #16]
ffff448c:	e59d0010 	ldr	r0, [sp, #16]
ffff4490:	e58a0088 	str	r0, [sl, #136]	; 0x88
ffff4494:	e3a00000 	mov	r0, #0
ffff4498:	e58a008c 	str	r0, [sl, #140]	; 0x8c
ffff449c:	e58a0080 	str	r0, [sl, #128]	; 0x80
ffff44a0:	e59a0000 	ldr	r0, [sl]
ffff44a4:	e3c00020 	bic	r0, r0, #32
ffff44a8:	e58a0000 	str	r0, [sl]

ffff44ac:	e59d0014 	ldr	r0, [sp, #20]
ffff44b0:	e3500000 	cmp	r0, #0
ffff44b4:	0a00000b 	beq	0xffff44e8

ffff44b8:	e3a00007 	mov	r0, #7
ffff44bc:	e58a0000 	str	r0, [sl]
ffff44c0:	e59d0020 	ldr	r0, [sp, #32]
ffff44c4:	ebfffd29 	bl	0xffff3970
ffff44c8:	e58d0004 	str	r0, [sp, #4]
ffff44cc:	e59d0004 	ldr	r0, [sp, #4]
ffff44d0:	e3500000 	cmp	r0, #0
ffff44d4:	0a000001 	beq	0xffff44e0

ffff44d8:	e59d0004 	ldr	r0, [sp, #4]
ffff44dc:	eafffecf 	b	0xffff4020

ffff44e0:	e59d0020 	ldr	r0, [sp, #32]
ffff44e4:	ebfffd0b 	bl	0xffff3918

ffff44e8:	e3e00000 	mvn	r0, #0
ffff44ec:	e58a0038 	str	r0, [sl, #56]	; 0x38
ffff44f0:	e59d0014 	ldr	r0, [sp, #20]
ffff44f4:	eafffec9e 	b	0xffff4020

	;; Global Offset Table
ffff44f8:	01c20cd0				; CNT64_TEST_REG
ffff44fc:	00155555
ffff4500:	01c20864				; PC_PUL0
ffff4504:	22222222
ffff4508:	01c20000				; CCU_BASE
ffff450c:	016e3600				; 24000000
ffff4510:	01c208d0				; PF_PUL0
ffff4514:	07222222
ffff4518:	77777777
ffff451c:	01c20848				; PC_CFG0
ffff4520:	07373733
ffff4524:	01c208b4				; PF_CFG0
ffff4528:	80202000
ffff452c:	00061a80				; 400000
ffff4530:	0002000e
ffff4534:	005b8d80
ffff4538:	00070008
ffff453c:	0007ffff
ffff4540:	000fffff
ffff4544:	20070008
ffff4548:	00249f00
ffff454c:	015be680
ffff4550:	00b71b00				; 12000000
ffff4554:	00493e00

;;;********************************************************************************
ffff4558:	e92d40f0 	push	{r4, r5, r6, r7, lr}  ; r0 = card_no, r1 = structure
ffff455c:	e1a07000 	mov	r7, r0
ffff4560:	e1a04001 	mov	r4, r1
ffff4564:	e5945000 	ldr	r5, [r4]
ffff4568:	e1a01005 	mov	r1, r5
ffff456c:	e1a00007 	mov	r0, r7
ffff4570:	ebfffc7e 	bl	init_SDC
ffff4574:	e3a00007 	mov	r0, #7
ffff4578:	e5951000 	ldr	r1, [r5]
ffff457c:	e5810000 	str	r0, [r1]
ffff4580:	e1a00004 	mov	r0, r4
ffff4584:	ebfffcf9 	bl	0xffff3970
ffff4588:	e1a06000 	mov	r6, r0
ffff458c:	e3560000 	cmp	r6, #0
ffff4590:	0a000001 	beq	0xffff459c
ffff4594:	e1a00006 	mov	r0, r6
ffff4598:	e8bd80f0 	pop	{r4, r5, r6, r7, pc}

ffff459c:	e3000911 	movw	r0, #2321	; 0x911
ffff45a0:	e5840024 	str	r0, [r4, #36]	; 0x24
ffff45a4:	e3a008fe 	mov	r0, #16646144	; 0xfe0000
ffff45a8:	e5840004 	str	r0, [r4, #4]
ffff45ac:	e51f0088 	ldr	r0, [pc, #-136]	; 0xffff452c =0x00061a80 (400000)
ffff45b0:	e584000c 	str	r0, [r4, #12]
ffff45b4:	e59f002c 	ldr	r0, [pc, #44]	; 0xffff45e8 =0x03197500 (52000000)
ffff45b8:	e5840010 	str	r0, [r4, #16]
ffff45bc:	e3a00000 	mov	r0, #0
ffff45c0:	eafffff4 	b	0xffff4598

;;;********************************************************************************
ffff45c4:	e92d4070 	push	{r4, r5, r6, lr}
ffff45c8:	e1a05000 	mov	r5, r0
ffff45cc:	e1a04001 	mov	r4, r1
ffff45d0:	e5946000 	ldr	r6, [r4]
ffff45d4:	e1a01006 	mov	r1, r6
ffff45d8:	e1a00005 	mov	r0, r5
ffff45dc:	ebfffca0 	bl	0xffff3864
ffff45e0:	e3a00000 	mov	r0, #0
ffff45e4:	e8bd8070 	pop	{r4, r5, r6, pc}

	;; Global Offset Table
ffff45e8:	03197500				; 52000000

;;;********************************************************************************
ffff45ec:	e92d4070 	push	{r4, r5, r6, lr}
ffff45f0:	e24dd028 	sub	sp, sp, #40	; 0x28
ffff45f4:	e1a06000 	mov	r6, r0
ffff45f8:	e1a04001 	mov	r4, r1
ffff45fc:	e3a0000d 	mov	r0, #13
ffff4600:	e58d0004 	str	r0, [sp, #4]
ffff4604:	e3a00015 	mov	r0, #21
ffff4608:	e58d0008 	str	r0, [sp, #8]
ffff460c:	e5960034 	ldr	r0, [r6, #52]	; 0x34
ffff4610:	e1a00800 	lsl	r0, r0, #16
ffff4614:	e58d000c 	str	r0, [sp, #12]
ffff4618:	e3a00000 	mov	r0, #0
ffff461c:	e58d0020 	str	r0, [sp, #32]
ffff4620:	e320f000 	nop	{0}
ffff4624:	e3a02000 	mov	r2, #0
ffff4628:	e28d1004 	add	r1, sp, #4
ffff462c:	e1a00006 	mov	r0, r6
ffff4630:	ebfffe63 	bl	0xffff3fc4
ffff4634:	e1a05000 	mov	r5, r0
ffff4638:	e3550000 	cmp	r5, #0
ffff463c:	0a000002 	beq	0xffff464c

ffff4640:	e1a00005 	mov	r0, r5

ffff4644:	e28dd028 	add	sp, sp, #40	; 0x28
ffff4648:	e8bd8070 	pop	{r4, r5, r6, pc}

ffff464c:	e59d0010 	ldr	r0, [sp, #16]
ffff4650:	e3100c01 	tst	r0, #256	; 0x100
ffff4654:	0a000000 	beq	0xffff465c

ffff4658:	ea00000b 	b	0xffff468c

ffff465c:	e3a00001 	mov	r0, #1
ffff4660:	e3a01000 	mov	r1, #0
ffff4664:	ebfffc30 	bl	0xffff372c
ffff4668:	e59d0010 	ldr	r0, [sp, #16]
ffff466c:	e59f1e10 	ldr	r1, [pc, #3600]	; 0xffff5484 = 0xfdf94080
ffff4670:	e1100001 	tst	r0, r1
ffff4674:	0a000001 	beq	0xffff4680

ffff4678:	e3e00011 	mvn	r0, #17
ffff467c:	eafffff0 	b	0xffff4644

ffff4680:	e1b00004 	movs	r0, r4
ffff4684:	e2444001 	sub	r4, r4, #1
ffff4688:	1affffe5 	bne	0xffff4624

ffff468c:	e320f000 	nop	{0}
ffff4690:	e3540000 	cmp	r4, #0
ffff4694:	ca000001 	bgt	0xffff46a0

ffff4698:	e3e00012 	mvn	r0, #18
ffff469c:	eaffffe8 	b	0xffff4644

ffff46a0:	e3a00000 	mov	r0, #0
ffff46a4:	eaffffe6 	b	0xffff4644

;;;********************************************************************************
ffff46a8:	e92d4030 	push	{r4, r5, lr}
ffff46ac:	e24dd024 	sub	sp, sp, #36	; 0x24
ffff46b0:	e1a04000 	mov	r4, r0
ffff46b4:	e3a05000 	mov	r5, #0
ffff46b8:	e3a00000 	mov	r0, #0
ffff46bc:	e58d0000 	str	r0, [sp]
ffff46c0:	e58d0008 	str	r0, [sp, #8]
ffff46c4:	e58d0004 	str	r0, [sp, #4]
ffff46c8:	e58d001c 	str	r0, [sp, #28]
ffff46cc:	e3a02000 	mov	r2, #0
ffff46d0:	e1a0100d 	mov	r1, sp
ffff46d4:	e1a00004 	mov	r0, r4
ffff46d8:	ebfffe39 	bl	0xffff3fc4
ffff46dc:	e1a05000 	mov	r5, r0
ffff46e0:	e3a00001 	mov	r0, #1
ffff46e4:	e3a01000 	mov	r1, #0
ffff46e8:	ebfffc0f 	bl	0xffff372c
ffff46ec:	e1a00005 	mov	r0, r5
ffff46f0:	e28dd024 	add	sp, sp, #36	; 0x24
ffff46f4:	e8bd8030 	pop	{r4, r5, pc}

;;;********************************************************************************
ffff46f8:	e92d4030 	push	{r4, r5, lr}
ffff46fc:	e24dd024 	sub	sp, sp, #36	; 0x24
ffff4700:	e1a04000 	mov	r4, r0
ffff4704:	e3a05000 	mov	r5, #0
ffff4708:	e3a00000 	mov	r0, #0
ffff470c:	e58d0000 	str	r0, [sp]
ffff4710:	e59f0d70 	ldr	r0, [pc, #3440]	; 0xffff5488 =0xf0f0f0f0
ffff4714:	e58d0008 	str	r0, [sp, #8]
ffff4718:	e3a00000 	mov	r0, #0
ffff471c:	e58d0004 	str	r0, [sp, #4]
ffff4720:	e58d001c 	str	r0, [sp, #28]
ffff4724:	e3a02000 	mov	r2, #0
ffff4728:	e1a0100d 	mov	r1, sp
ffff472c:	e1a00004 	mov	r0, r4
ffff4730:	ebfffe23 	bl	0xffff3fc4
ffff4734:	e1a05000 	mov	r5, r0
ffff4738:	e1a00005 	mov	r0, r5
ffff473c:	e28dd024 	add	sp, sp, #36	; 0x24
ffff4740:	e8bd8030 	pop	{r4, r5, pc}

ffff4744:	e92d4030 	push	{r4, r5, lr}
ffff4748:	e24dd024 	sub	sp, sp, #36	; 0x24
ffff474c:	e1a04000 	mov	r4, r0
ffff4750:	e3a05000 	mov	r5, #0
ffff4754:	e3a00000 	mov	r0, #0
ffff4758:	e58d0000 	str	r0, [sp]
ffff475c:	e59f0d28 	ldr	r0, [pc, #3368]	; 0xffff548c =0xf0f0f0fa
ffff4760:	e58d0008 	str	r0, [sp, #8]
ffff4764:	e3a00000 	mov	r0, #0
ffff4768:	e58d0004 	str	r0, [sp, #4]
ffff476c:	e58d001c 	str	r0, [sp, #28]
ffff4770:	e3a02000 	mov	r2, #0
ffff4774:	e1a0100d 	mov	r1, sp
ffff4778:	e1a00004 	mov	r0, r4
ffff477c:	ebfffe10 	bl	0xffff3fc4
ffff4780:	e1a05000 	mov	r5, r0
ffff4784:	e3a00001 	mov	r0, #1
ffff4788:	e3a01000 	mov	r1, #0
ffff478c:	ebfffbe6 	bl	0xffff372c
ffff4790:	e1a00005 	mov	r0, r5
ffff4794:	e28dd024 	add	sp, sp, #36	; 0x24
ffff4798:	e8bd8030 	pop	{r4, r5, pc}

;;;********************************************************************************
ffff479c:	e92d4070 	push	{r4, r5, r6, lr}
ffff47a0:	e24dd028 	sub	sp, sp, #40	; 0x28
ffff47a4:	e1a04000 	mov	r4, r0
ffff47a8:	e30063e8 	movw	r6, #1000	; 0x3e8
ffff47ac:	e320f000 	nop	{0}

ffff47b0:	e3a00037 	mov	r0, #55	; 0x37
ffff47b4:	e58d0004 	str	r0, [sp, #4]
ffff47b8:	e3a00015 	mov	r0, #21
ffff47bc:	e58d0008 	str	r0, [sp, #8]
ffff47c0:	e3a00000 	mov	r0, #0
ffff47c4:	e58d000c 	str	r0, [sp, #12]
ffff47c8:	e58d0020 	str	r0, [sp, #32]
ffff47cc:	e3a02000 	mov	r2, #0
ffff47d0:	e28d1004 	add	r1, sp, #4
ffff47d4:	e1a00004 	mov	r0, r4
ffff47d8:	ebfffdf9 	bl	0xffff3fc4
ffff47dc:	e1a05000 	mov	r5, r0
ffff47e0:	e3550000 	cmp	r5, #0
ffff47e4:	0a000002 	beq	0xffff47f4

ffff47e8:	e1a00005 	mov	r0, r5

ffff47ec:	e28dd028 	add	sp, sp, #40	; 0x28
ffff47f0:	e8bd8070 	pop	{r4, r5, r6, pc}

ffff47f4:	e3a00029 	mov	r0, #41	; 0x29
ffff47f8:	e58d0004 	str	r0, [sp, #4]
ffff47fc:	e3a00001 	mov	r0, #1
ffff4800:	e58d0008 	str	r0, [sp, #8]
ffff4804:	e5940004 	ldr	r0, [r4, #4]
ffff4808:	e59f1c80 	ldr	r1, [pc, #3200]	; 0xffff5490 =0x00ff8000
ffff480c:	e0000001 	and	r0, r0, r1
ffff4810:	e58d000c 	str	r0, [sp, #12]
ffff4814:	e5940008 	ldr	r0, [r4, #8]
ffff4818:	e2401802 	sub	r1, r0, #131072	; 0x20000
ffff481c:	e2511020 	subs	r1, r1, #32
ffff4820:	1a000002 	bne	0xffff4830

ffff4824:	e59d000c 	ldr	r0, [sp, #12]
ffff4828:	e3800101 	orr	r0, r0, #1073741824	; 0x40000000
ffff482c:	e58d000c 	str	r0, [sp, #12]

ffff4830:	e3a02000 	mov	r2, #0
ffff4834:	e28d1004 	add	r1, sp, #4
ffff4838:	e1a00004 	mov	r0, r4
ffff483c:	ebfffde0 	bl	0xffff3fc4
ffff4840:	e1a05000 	mov	r5, r0
ffff4844:	e3550000 	cmp	r5, #0
ffff4848:	0a000001 	beq	0xffff4854

ffff484c:	e1a00005 	mov	r0, r5
ffff4850:	eaffffe5 	b	0xffff47ec

ffff4854:	e3a00001 	mov	r0, #1
ffff4858:	e3a01000 	mov	r1, #0
ffff485c:	ebfffbb2 	bl	0xffff372c
ffff4860:	e59d0010 	ldr	r0, [sp, #16]
ffff4864:	e3100102 	tst	r0, #-2147483648	; 0x80000000
ffff4868:	1a000002 	bne	0xffff4878

ffff486c:	e1b00006 	movs	r0, r6
ffff4870:	e2466001 	sub	r6, r6, #1
ffff4874:	1affffcd 	bne	0xffff47b0

ffff4878:	e3560000 	cmp	r6, #0
ffff487c:	ca000001 	bgt	0xffff4888

ffff4880:	e3e00010 	mvn	r0, #16
ffff4884:	eaffffd8 	b	0xffff47ec

ffff4888:	e5940008 	ldr	r0, [r4, #8]
ffff488c:	e2401802 	sub	r1, r0, #131072	; 0x20000
ffff4890:	e2511020 	subs	r1, r1, #32
ffff4894:	0a000001 	beq	0xffff48a0

ffff4898:	e59f0bf4 	ldr	r0, [pc, #3060]	; 0xffff5494 =0x00020010
ffff489c:	e5840008 	str	r0, [r4, #8]

ffff48a0:	e59d0010 	ldr	r0, [sp, #16]
ffff48a4:	e5840028 	str	r0, [r4, #40]	; 0x28
ffff48a8:	e5940028 	ldr	r0, [r4, #40]	; 0x28
ffff48ac:	e7e00f50 	ubfx	r0, r0, #30, #1
ffff48b0:	e5840014 	str	r0, [r4, #20]
ffff48b4:	e3a00000 	mov	r0, #0
ffff48b8:	e5840034 	str	r0, [r4, #52]	; 0x34
ffff48bc:	e320f000 	nop	{0}
ffff48c0:	eaffffc9 	b	0xffff47ec

;;;********************************************************************************
ffff48c4:	e92d4070 	push	{r4, r5, r6, lr}
ffff48c8:	e24dd028 	sub	sp, sp, #40	; 0x28
ffff48cc:	e1a04000 	mov	r4, r0
ffff48d0:	e30063e8 	movw	r6, #1000	; 0x3e8
ffff48d4:	e1a00004 	mov	r0, r4
ffff48d8:	ebffff72 	bl	0xffff46a8
ffff48dc:	e3a00001 	mov	r0, #1
ffff48e0:	e58d0004 	str	r0, [sp, #4]
ffff48e4:	e58d0008 	str	r0, [sp, #8]
ffff48e8:	e3a00000 	mov	r0, #0
ffff48ec:	e58d000c 	str	r0, [sp, #12]
ffff48f0:	e58d0020 	str	r0, [sp, #32]
ffff48f4:	e3a02000 	mov	r2, #0
ffff48f8:	e28d1004 	add	r1, sp, #4
ffff48fc:	e1a00004 	mov	r0, r4
ffff4900:	ebfffdaf 	bl	0xffff3fc4
ffff4904:	e1a05000 	mov	r5, r0
ffff4908:	e3550000 	cmp	r5, #0
ffff490c:	0a000002 	beq	0xffff491c

ffff4910:	e1a00005 	mov	r0, r5

ffff4914:	e28dd028 	add	sp, sp, #40	; 0x28
ffff4918:	e8bd8070 	pop	{r4, r5, r6, pc}

ffff491c:	e3a00001 	mov	r0, #1
ffff4920:	e3a01000 	mov	r1, #0
ffff4924:	ebfffb80 	bl	0xffff372c
ffff4928:	e320f000 	nop	{0}

ffff492c:	e3a00001 	mov	r0, #1
ffff4930:	e58d0004 	str	r0, [sp, #4]
ffff4934:	e58d0008 	str	r0, [sp, #8]
ffff4938:	e5940004 	ldr	r0, [r4, #4]
ffff493c:	e59d1010 	ldr	r1, [sp, #16]
ffff4940:	e3c114ff 	bic	r1, r1, #-16777216	; 0xff000000
ffff4944:	e3c1107f 	bic	r1, r1, #127	; 0x7f
ffff4948:	e0000001 	and	r0, r0, r1
ffff494c:	e59d1010 	ldr	r1, [sp, #16]
ffff4950:	e2011206 	and	r1, r1, #1610612736	; 0x60000000
ffff4954:	e1800001 	orr	r0, r0, r1
ffff4958:	e58d000c 	str	r0, [sp, #12]
ffff495c:	e5940024 	ldr	r0, [r4, #36]	; 0x24
ffff4960:	e3100b02 	tst	r0, #2048	; 0x800
ffff4964:	0a000002 	beq	0xffff4974

ffff4968:	e59d000c 	ldr	r0, [sp, #12]
ffff496c:	e3800101 	orr	r0, r0, #1073741824	; 0x40000000
ffff4970:	e58d000c 	str	r0, [sp, #12]

ffff4974:	e3a00000 	mov	r0, #0
ffff4978:	e58d0020 	str	r0, [sp, #32]
ffff497c:	e3a02000 	mov	r2, #0
ffff4980:	e28d1004 	add	r1, sp, #4
ffff4984:	e1a00004 	mov	r0, r4
ffff4988:	ebfffd8d 	bl	0xffff3fc4
ffff498c:	e1a05000 	mov	r5, r0
ffff4990:	e3550000 	cmp	r5, #0
ffff4994:	0a000001 	beq	0xffff49a0

ffff4998:	e1a00005 	mov	r0, r5
ffff499c:	eaffffdc 	b	0xffff4914

ffff49a0:	e3a00001 	mov	r0, #1
ffff49a4:	e3a01000 	mov	r1, #0
ffff49a8:	ebfffb5f 	bl	0xffff372c
ffff49ac:	e59d0010 	ldr	r0, [sp, #16]
ffff49b0:	e3100102 	tst	r0, #-2147483648	; 0x80000000
ffff49b4:	1a000002 	bne	0xffff49c4

ffff49b8:	e1b00006 	movs	r0, r6
ffff49bc:	e2466001 	sub	r6, r6, #1
ffff49c0:	1affffd9 	bne	0xffff492c

ffff49c4:	e3560000 	cmp	r6, #0
ffff49c8:	ca000001 	bgt	0xffff49d4

ffff49cc:	e3e00010 	mvn	r0, #16
ffff49d0:	eaffffcf 	b	0xffff4914

ffff49d4:	e3a00801 	mov	r0, #65536	; 0x10000
ffff49d8:	e5840008 	str	r0, [r4, #8]
ffff49dc:	e59d0010 	ldr	r0, [sp, #16]
ffff49e0:	e5840028 	str	r0, [r4, #40]	; 0x28
ffff49e4:	e5940028 	ldr	r0, [r4, #40]	; 0x28
ffff49e8:	e7e00f50 	ubfx	r0, r0, #30, #1
ffff49ec:	e5840014 	str	r0, [r4, #20]
ffff49f0:	e3a00001 	mov	r0, #1
ffff49f4:	e5840034 	str	r0, [r4, #52]	; 0x34
ffff49f8:	e3a00000 	mov	r0, #0
ffff49fc:	eaffffc4 	b	0xffff4914

;;;********************************************************************************
ffff4a00:	e92d4070 	push	{r4, r5, r6, lr}
ffff4a04:	e24dd038 	sub	sp, sp, #56	; 0x38
ffff4a08:	e1a05000 	mov	r5, r0
ffff4a0c:	e1a04001 	mov	r4, r1
ffff4a10:	e3a00008 	mov	r0, #8
ffff4a14:	e58d0014 	str	r0, [sp, #20]
ffff4a18:	e3a00015 	mov	r0, #21
ffff4a1c:	e58d0018 	str	r0, [sp, #24]
ffff4a20:	e3a00000 	mov	r0, #0
ffff4a24:	e58d001c 	str	r0, [sp, #28]
ffff4a28:	e58d0030 	str	r0, [sp, #48]	; 0x30
ffff4a2c:	e58d4004 	str	r4, [sp, #4]
ffff4a30:	e3a00001 	mov	r0, #1
ffff4a34:	e58d000c 	str	r0, [sp, #12]
ffff4a38:	e3000200 	movw	r0, #512	; 0x200
ffff4a3c:	e58d0010 	str	r0, [sp, #16]
ffff4a40:	e3a00001 	mov	r0, #1
ffff4a44:	e58d0008 	str	r0, [sp, #8]
ffff4a48:	e28d2004 	add	r2, sp, #4
ffff4a4c:	e28d1014 	add	r1, sp, #20
ffff4a50:	e1a00005 	mov	r0, r5
ffff4a54:	ebfffd5a 	bl	0xffff3fc4
ffff4a58:	e1a06000 	mov	r6, r0
ffff4a5c:	e1a00006 	mov	r0, r6
ffff4a60:	e28dd038 	add	sp, sp, #56	; 0x38
ffff4a64:	e8bd8070 	pop	{r4, r5, r6, pc}

;;; ;********************************************************************************
ffff4a68:	e92d43f0 	push	{r4, r5, r6, r7, r8, r9, lr}
ffff4a6c:	e24dd024 	sub	sp, sp, #36	; 0x24
ffff4a70:	e1a06000 	mov	r6, r0
ffff4a74:	e1a09001 	mov	r9, r1
ffff4a78:	e1a04002 	mov	r4, r2
ffff4a7c:	e1a05003 	mov	r5, r3
ffff4a80:	e30073e8 	movw	r7, #1000	; 0x3e8
ffff4a84:	e3a00006 	mov	r0, #6
ffff4a88:	e58d0000 	str	r0, [sp]
ffff4a8c:	e3a0001d 	mov	r0, #29
ffff4a90:	e58d0004 	str	r0, [sp, #4]
ffff4a94:	e3a00403 	mov	r0, #50331648	; 0x3000000
ffff4a98:	e1800804 	orr	r0, r0, r4, lsl #16
ffff4a9c:	e1800405 	orr	r0, r0, r5, lsl #8
ffff4aa0:	e58d0008 	str	r0, [sp, #8]
ffff4aa4:	e3a00000 	mov	r0, #0
ffff4aa8:	e58d001c 	str	r0, [sp, #28]
ffff4aac:	e3a02000 	mov	r2, #0
ffff4ab0:	e1a0100d 	mov	r1, sp
ffff4ab4:	e1a00006 	mov	r0, r6
ffff4ab8:	ebfffd41 	bl	0xffff3fc4
ffff4abc:	e1a08000 	mov	r8, r0
ffff4ac0:	e1a01007 	mov	r1, r7
ffff4ac4:	e1a00006 	mov	r0, r6
ffff4ac8:	ebfffec7 	bl	0xffff45ec
ffff4acc:	e1a00008 	mov	r0, r8
ffff4ad0:	e28dd024 	add	sp, sp, #36	; 0x24
ffff4ad4:	e8bd83f0 	pop	{r4, r5, r6, r7, r8, r9, pc}

;;;********************************************************************************
ffff4ad8:	e1a02000 	mov	r2, r0
ffff4adc:	e3a00000 	mov	r0, #0
ffff4ae0:	e5820020 	str	r0, [r2, #32]
ffff4ae4:	e5920008 	ldr	r0, [r2, #8]
ffff4ae8:	e59f39a8 	ldr	r3, [pc, #2472]	; 0xffff5498 =0x00010040
ffff4aec:	e1500003 	cmp	r0, r3
ffff4af0:	2a000001 	bcs	0xffff4afc

ffff4af4:	e3a00000 	mov	r0, #0

ffff4af8:	e12fff1e 	bx	lr

ffff4afc:	e5920020 	ldr	r0, [r2, #32]
ffff4b00:	e3800c01 	orr	r0, r0, #256	; 0x100
ffff4b04:	e5820020 	str	r0, [r2, #32]
ffff4b08:	e5920020 	ldr	r0, [r2, #32]
ffff4b0c:	e3800001 	orr	r0, r0, #1
ffff4b10:	e5820020 	str	r0, [r2, #32]
ffff4b14:	e3a00000 	mov	r0, #0
ffff4b18:	eafffff6 	b	0xffff4af8

;;;********************************************************************************
ffff4b1c:	e92d41f0 	push	{r4, r5, r6, r7, r8, lr}
ffff4b20:	e24dd038 	sub	sp, sp, #56	; 0x38
ffff4b24:	e1a08000 	mov	r8, r0
ffff4b28:	e1a05001 	mov	r5, r1
ffff4b2c:	e1a04002 	mov	r4, r2
ffff4b30:	e1a06003 	mov	r6, r3
ffff4b34:	e59d7050 	ldr	r7, [sp, #80]	; 0x50
ffff4b38:	e3a00006 	mov	r0, #6
ffff4b3c:	e58d0014 	str	r0, [sp, #20]
ffff4b40:	e3a00015 	mov	r0, #21
ffff4b44:	e58d0018 	str	r0, [sp, #24]
ffff4b48:	e3e004ff 	mvn	r0, #-16777216	; 0xff000000
ffff4b4c:	e1800f85 	orr	r0, r0, r5, lsl #31
ffff4b50:	e58d001c 	str	r0, [sp, #28]
ffff4b54:	e1a01104 	lsl	r1, r4, #2
ffff4b58:	e3a0200f 	mov	r2, #15
ffff4b5c:	e59d001c 	ldr	r0, [sp, #28]
ffff4b60:	e1c00112 	bic	r0, r0, r2, lsl r1
ffff4b64:	e58d001c 	str	r0, [sp, #28]
ffff4b68:	e1a01104 	lsl	r1, r4, #2
ffff4b6c:	e59d001c 	ldr	r0, [sp, #28]
ffff4b70:	e1800116 	orr	r0, r0, r6, lsl r1
ffff4b74:	e58d001c 	str	r0, [sp, #28]
ffff4b78:	e3a00000 	mov	r0, #0
ffff4b7c:	e58d0030 	str	r0, [sp, #48]	; 0x30
ffff4b80:	e58d7004 	str	r7, [sp, #4]
ffff4b84:	e3a00040 	mov	r0, #64	; 0x40
ffff4b88:	e58d0010 	str	r0, [sp, #16]
ffff4b8c:	e3a00001 	mov	r0, #1
ffff4b90:	e58d000c 	str	r0, [sp, #12]
ffff4b94:	e58d0008 	str	r0, [sp, #8]
ffff4b98:	e28d2004 	add	r2, sp, #4
ffff4b9c:	e28d1014 	add	r1, sp, #20
ffff4ba0:	e1a00008 	mov	r0, r8
ffff4ba4:	ebfffd06 	bl	0xffff3fc4
ffff4ba8:	e28dd038 	add	sp, sp, #56	; 0x38
ffff4bac:	e8bd81f0 	pop	{r4, r5, r6, r7, r8, pc}

;;;********************************************************************************
ffff4bb0:	e92d4070 	push	{r4, r5, r6, lr}
ffff4bb4:	e24dd040 	sub	sp, sp, #64	; 0x40
ffff4bb8:	e1a04000 	mov	r4, r0
ffff4bbc:	e3a00000 	mov	r0, #0
ffff4bc0:	e5840020 	str	r0, [r4, #32]
ffff4bc4:	e3a00037 	mov	r0, #55	; 0x37
ffff4bc8:	e58d001c 	str	r0, [sp, #28]
ffff4bcc:	e3a00015 	mov	r0, #21
ffff4bd0:	e58d0020 	str	r0, [sp, #32]
ffff4bd4:	e5940034 	ldr	r0, [r4, #52]	; 0x34
ffff4bd8:	e1a00800 	lsl	r0, r0, #16
ffff4bdc:	e58d0024 	str	r0, [sp, #36]	; 0x24
ffff4be0:	e3a00000 	mov	r0, #0
ffff4be4:	e58d0038 	str	r0, [sp, #56]	; 0x38
ffff4be8:	e3a02000 	mov	r2, #0
ffff4bec:	e28d101c 	add	r1, sp, #28
ffff4bf0:	e1a00004 	mov	r0, r4
ffff4bf4:	ebfffcf2 	bl	0xffff3fc4
ffff4bf8:	e1a05000 	mov	r5, r0
ffff4bfc:	e3550000 	cmp	r5, #0
ffff4c00:	0a000002 	beq	0xffff4c10

ffff4c04:	e1a00005 	mov	r0, r5

ffff4c08:	e28dd040 	add	sp, sp, #64	; 0x40
ffff4c0c:	e8bd8070 	pop	{r4, r5, r6, pc}

ffff4c10:	e3a00033 	mov	r0, #51	; 0x33
ffff4c14:	e58d001c 	str	r0, [sp, #28]
ffff4c18:	e3a00015 	mov	r0, #21
ffff4c1c:	e58d0020 	str	r0, [sp, #32]
ffff4c20:	e3a00000 	mov	r0, #0
ffff4c24:	e58d0024 	str	r0, [sp, #36]	; 0x24
ffff4c28:	e58d0038 	str	r0, [sp, #56]	; 0x38
ffff4c2c:	e3a06003 	mov	r6, #3
ffff4c30:	e320f000 	nop	{0}

ffff4c34:	e28d0014 	add	r0, sp, #20
ffff4c38:	e58d0004 	str	r0, [sp, #4]
ffff4c3c:	e3a00008 	mov	r0, #8
ffff4c40:	e58d0010 	str	r0, [sp, #16]
ffff4c44:	e3a00001 	mov	r0, #1
ffff4c48:	e58d000c 	str	r0, [sp, #12]
ffff4c4c:	e58d0008 	str	r0, [sp, #8]
ffff4c50:	e28d2004 	add	r2, sp, #4
ffff4c54:	e28d101c 	add	r1, sp, #28
ffff4c58:	e1a00004 	mov	r0, r4
ffff4c5c:	ebfffcd8 	bl	0xffff3fc4
ffff4c60:	e1a05000 	mov	r5, r0
ffff4c64:	e3550000 	cmp	r5, #0
ffff4c68:	0a000005 	beq	0xffff4c84

ffff4c6c:	e1b00006 	movs	r0, r6
ffff4c70:	e2466001 	sub	r6, r6, #1
ffff4c74:	0a000000 	beq	0xffff4c7c

ffff4c78:	eaffffed 	b	0xffff4c34

ffff4c7c:	e1a00005 	mov	r0, r5
ffff4c80:	eaffffe0 	b	0xffff4c08

ffff4c84:	e30f2f00 	movw	r2, #65280	; 0xff00
ffff4c88:	e59d1014 	ldr	r1, [sp, #20]
ffff4c8c:	e0021421 	and	r1, r2, r1, lsr #8
ffff4c90:	e59d0014 	ldr	r0, [sp, #20]
ffff4c94:	e1810c20 	orr	r0, r1, r0, lsr #24
ffff4c98:	e3a028ff 	mov	r2, #16711680	; 0xff0000
ffff4c9c:	e59d1014 	ldr	r1, [sp, #20]
ffff4ca0:	e0021401 	and	r1, r2, r1, lsl #8
ffff4ca4:	e1800001 	orr	r0, r0, r1
ffff4ca8:	e3a024ff 	mov	r2, #-16777216	; 0xff000000
ffff4cac:	e59d1014 	ldr	r1, [sp, #20]
ffff4cb0:	e0021c01 	and	r1, r2, r1, lsl #24
ffff4cb4:	e1800001 	orr	r0, r0, r1
ffff4cb8:	e584002c 	str	r0, [r4, #44]	; 0x2c
ffff4cbc:	e30f2f00 	movw	r2, #65280	; 0xff00
ffff4cc0:	e59d1018 	ldr	r1, [sp, #24]
ffff4cc4:	e0021421 	and	r1, r2, r1, lsr #8
ffff4cc8:	e59d0018 	ldr	r0, [sp, #24]
ffff4ccc:	e1810c20 	orr	r0, r1, r0, lsr #24
ffff4cd0:	e3a028ff 	mov	r2, #16711680	; 0xff0000
ffff4cd4:	e59d1018 	ldr	r1, [sp, #24]
ffff4cd8:	e0021401 	and	r1, r2, r1, lsl #8
ffff4cdc:	e1800001 	orr	r0, r0, r1
ffff4ce0:	e3a024ff 	mov	r2, #-16777216	; 0xff000000
ffff4ce4:	e59d1018 	ldr	r1, [sp, #24]
ffff4ce8:	e0021c01 	and	r1, r2, r1, lsl #24
ffff4cec:	e1800001 	orr	r0, r0, r1
ffff4cf0:	e5840030 	str	r0, [r4, #48]	; 0x30
ffff4cf4:	e594002c 	ldr	r0, [r4, #44]	; 0x2c
ffff4cf8:	e7e30c50 	ubfx	r0, r0, #24, #4
ffff4cfc:	e3500000 	cmp	r0, #0
ffff4d00:	0a000004 	beq	0xffff4d18

ffff4d04:	e3500001 	cmp	r0, #1
ffff4d08:	0a000006 	beq	0xffff4d28

ffff4d0c:	e3500002 	cmp	r0, #2
ffff4d10:	1a00000c 	bne	0xffff4d48

ffff4d14:	ea000007 	b	0xffff4d38

ffff4d18:	e320f000 	nop	{0}
ffff4d1c:	e59f0770 	ldr	r0, [pc, #1904]	; 0xffff5494 =0x00020010
ffff4d20:	e5840008 	str	r0, [r4, #8]
ffff4d24:	ea00000b 	b	0xffff4d58

ffff4d28:	e320f000 	nop	{0}
ffff4d2c:	e59f0768 	ldr	r0, [pc, #1896]	; 0xffff549c =0x0002001a
ffff4d30:	e5840008 	str	r0, [r4, #8]
ffff4d34:	ea000007 	b	0xffff4d58

ffff4d38:	e320f000 	nop	{0}
ffff4d3c:	e59f075c 	ldr	r0, [pc, #1884]	; 0xffff54a0 =0x00020020
ffff4d40:	e5840008 	str	r0, [r4, #8]
ffff4d44:	ea000003 	b	0xffff4d58

ffff4d48:	e320f000 	nop	{0}
ffff4d4c:	e59f0740 	ldr	r0, [pc, #1856]	; 0xffff5494 =0x00020010
ffff4d50:	e5840008 	str	r0, [r4, #8]
ffff4d54:	e320f000 	nop	{0}

ffff4d58:	e320f000 	nop	{0}
ffff4d5c:	e594002c 	ldr	r0, [r4, #44]	; 0x2c
ffff4d60:	e3100701 	tst	r0, #262144	; 0x40000
ffff4d64:	0a000002 	beq	0xffff4d74

ffff4d68:	e5940020 	ldr	r0, [r4, #32]
ffff4d6c:	e3800c01 	orr	r0, r0, #256	; 0x100
ffff4d70:	e5840020 	str	r0, [r4, #32]

ffff4d74:	e3a00000 	mov	r0, #0
ffff4d78:	eaffffa2 	b	0xffff4c08

;;;********************************************************************************
ffff4d7c:	e92d4070 	push	{r4, r5, r6, lr}
ffff4d80:	e1a04000 	mov	r4, r0
ffff4d84:	e1a05001 	mov	r5, r1
ffff4d88:	e5940010 	ldr	r0, [r4, #16]
ffff4d8c:	e1500005 	cmp	r0, r5
ffff4d90:	2a000000 	bcs	0xffff4d98

ffff4d94:	e5945010 	ldr	r5, [r4, #16]

ffff4d98:	e594000c 	ldr	r0, [r4, #12]
ffff4d9c:	e1500005 	cmp	r0, r5
ffff4da0:	9a000000 	bls	0xffff4da8

ffff4da4:	e594500c 	ldr	r5, [r4, #12]

ffff4da8:	e584501c 	str	r5, [r4, #28]
ffff4dac:	e1a00004 	mov	r0, r4
ffff4db0:	ebfffb68 	bl	0xffff3b58
ffff4db4:	e8bd8070 	pop	{r4, r5, r6, pc}

;;;********************************************************************************
ffff4db8:	e92d4070 	push	{r4, r5, r6, lr}
ffff4dbc:	e1a04000 	mov	r4, r0
ffff4dc0:	e1a05001 	mov	r5, r1
ffff4dc4:	e5845018 	str	r5, [r4, #24]
ffff4dc8:	e1a00004 	mov	r0, r4
ffff4dcc:	ebfffb61 	bl	0xffff3b58
ffff4dd0:	e8bd8070 	pop	{r4, r5, r6, pc}

;;;********************************************************************************
ffff4dd4:	e92d4070 	push	{r4, r5, r6, lr}
ffff4dd8:	e24ddf8a 	sub	sp, sp, #552	; 0x228
ffff4ddc:	e1a04000 	mov	r4, r0
ffff4de0:	e30063e8 	movw	r6, #1000	; 0x3e8
ffff4de4:	e3a00002 	mov	r0, #2
ffff4de8:	e58d0204 	str	r0, [sp, #516]	; 0x204
ffff4dec:	e3a00007 	mov	r0, #7
ffff4df0:	e58d0208 	str	r0, [sp, #520]	; 0x208
ffff4df4:	e3a00000 	mov	r0, #0
ffff4df8:	e58d020c 	str	r0, [sp, #524]	; 0x20c
ffff4dfc:	e58d0220 	str	r0, [sp, #544]	; 0x220
ffff4e00:	e3a02000 	mov	r2, #0
ffff4e04:	e28d1f81 	add	r1, sp, #516	; 0x204
ffff4e08:	e1a00004 	mov	r0, r4
ffff4e0c:	ebfffc6c 	bl	0xffff3fc4
ffff4e10:	e1a05000 	mov	r5, r0
ffff4e14:	e3550000 	cmp	r5, #0
ffff4e18:	0a000002 	beq	0xffff4e28

ffff4e1c:	e1a00005 	mov	r0, r5

ffff4e20:	e28ddf8a 	add	sp, sp, #552	; 0x228
ffff4e24:	e8bd8070 	pop	{r4, r5, r6, pc}

ffff4e28:	e3a00003 	mov	r0, #3
ffff4e2c:	e58d0204 	str	r0, [sp, #516]	; 0x204
ffff4e30:	e5940034 	ldr	r0, [r4, #52]	; 0x34
ffff4e34:	e1a00800 	lsl	r0, r0, #16
ffff4e38:	e58d020c 	str	r0, [sp, #524]	; 0x20c
ffff4e3c:	e3a00015 	mov	r0, #21
ffff4e40:	e58d0208 	str	r0, [sp, #520]	; 0x208
ffff4e44:	e3a00000 	mov	r0, #0
ffff4e48:	e58d0220 	str	r0, [sp, #544]	; 0x220
ffff4e4c:	e3a02000 	mov	r2, #0
ffff4e50:	e28d1f81 	add	r1, sp, #516	; 0x204
ffff4e54:	e1a00004 	mov	r0, r4
ffff4e58:	ebfffc59 	bl	0xffff3fc4
ffff4e5c:	e1a05000 	mov	r5, r0
ffff4e60:	e3550000 	cmp	r5, #0
ffff4e64:	0a000001 	beq	0xffff4e70

ffff4e68:	e1a00005 	mov	r0, r5
ffff4e6c:	eaffffeb 	b	0xffff4e20

ffff4e70:	e5940008 	ldr	r0, [r4, #8]
ffff4e74:	e3100802 	tst	r0, #131072	; 0x20000
ffff4e78:	0a000003 	beq	0xffff4e8c

ffff4e7c:	e30f1fff 	movw	r1, #65535	; 0xffff
ffff4e80:	e59d0210 	ldr	r0, [sp, #528]	; 0x210
ffff4e84:	e0010820 	and	r0, r1, r0, lsr #16
ffff4e88:	e5840034 	str	r0, [r4, #52]	; 0x34

ffff4e8c:	e59f1610 	ldr	r1, [pc, #1552]	; 0xffff54a4
ffff4e90:	e1a00004 	mov	r0, r4
ffff4e94:	ebffffb8 	bl	0xffff4d7c
ffff4e98:	e3a00009 	mov	r0, #9
ffff4e9c:	e58d0204 	str	r0, [sp, #516]	; 0x204
ffff4ea0:	e3a00007 	mov	r0, #7
ffff4ea4:	e58d0208 	str	r0, [sp, #520]	; 0x208
ffff4ea8:	e5940034 	ldr	r0, [r4, #52]	; 0x34
ffff4eac:	e1a00800 	lsl	r0, r0, #16
ffff4eb0:	e58d020c 	str	r0, [sp, #524]	; 0x20c
ffff4eb4:	e3a00000 	mov	r0, #0
ffff4eb8:	e58d0220 	str	r0, [sp, #544]	; 0x220
ffff4ebc:	e3a02000 	mov	r2, #0
ffff4ec0:	e28d1f81 	add	r1, sp, #516	; 0x204
ffff4ec4:	e1a00004 	mov	r0, r4
ffff4ec8:	ebfffc3d 	bl	0xffff3fc4
ffff4ecc:	e1a05000 	mov	r5, r0
ffff4ed0:	e3550000 	cmp	r5, #0
ffff4ed4:	0a000001 	beq	0xffff4ee0

ffff4ed8:	e1a00005 	mov	r0, r5
ffff4edc:	eaffffcf 	b	0xffff4e20

ffff4ee0:	e1a01006 	mov	r1, r6
ffff4ee4:	e1a00004 	mov	r0, r4
ffff4ee8:	ebfffdbf 	bl	0xffff45ec
ffff4eec:	e5940008 	ldr	r0, [r4, #8]
ffff4ef0:	e3500801 	cmp	r0, #65536	; 0x10000
ffff4ef4:	1a000023 	bne	0xffff4f88

ffff4ef8:	e59d1210 	ldr	r1, [sp, #528]	; 0x210
ffff4efc:	e7e30d51 	ubfx	r0, r1, #26, #4
ffff4f00:	e3500005 	cmp	r0, #5
ffff4f04:	308ff100 	addcc	pc, pc, r0, lsl #2
ffff4f08:	ea000018 	b	0xffff4f70
ffff4f0c:	ea000003 	b	0xffff4f20
ffff4f10:	ea000006 	b	0xffff4f30
ffff4f14:	ea000009 	b	0xffff4f40
ffff4f18:	ea00000c 	b	0xffff4f50
ffff4f1c:	ea00000f 	b	0xffff4f60

ffff4f20:	e320f000 	nop	{0}
ffff4f24:	e59f157c 	ldr	r1, [pc, #1404]	; 0xffff54a8
ffff4f28:	e5841008 	str	r1, [r4, #8]
ffff4f2c:	ea000013 	b	0xffff4f80

ffff4f30:	e320f000 	nop	{0}
ffff4f34:	e59f1570 	ldr	r1, [pc, #1392]	; 0xffff54ac
ffff4f38:	e5841008 	str	r1, [r4, #8]
ffff4f3c:	ea00000f 	b	0xffff4f80

ffff4f40:	e320f000 	nop	{0}
ffff4f44:	e59f1564 	ldr	r1, [pc, #1380]	; 0xffff54b0
ffff4f48:	e5841008 	str	r1, [r4, #8]
ffff4f4c:	ea00000b 	b	0xffff4f80

ffff4f50:	e320f000 	nop	{0}
ffff4f54:	e59f1558 	ldr	r1, [pc, #1368]	; 0xffff54b4
ffff4f58:	e5841008 	str	r1, [r4, #8]
ffff4f5c:	ea000007 	b	0xffff4f80

ffff4f60:	e320f000 	nop	{0}
ffff4f64:	e59f152c 	ldr	r1, [pc, #1324]	; 0xffff5498 =0x00010040
ffff4f68:	e5841008 	str	r1, [r4, #8]
ffff4f6c:	ea000003 	b	0xffff4f80

ffff4f70:	e320f000 	nop	{0}
ffff4f74:	e59f152c 	ldr	r1, [pc, #1324]	; 0xffff54a8
ffff4f78:	e5841008 	str	r1, [r4, #8]
ffff4f7c:	e320f000 	nop	{0}
ffff4f80:	e320f000 	nop	{0}
ffff4f84:	e320f000 	nop	{0}

ffff4f88:	e59d0214 	ldr	r0, [sp, #532]	; 0x214
ffff4f8c:	e7e30850 	ubfx	r0, r0, #16, #4
ffff4f90:	e3a01001 	mov	r1, #1
ffff4f94:	e1a00011 	lsl	r0, r1, r0
ffff4f98:	e5840044 	str	r0, [r4, #68]	; 0x44
ffff4f9c:	e5940044 	ldr	r0, [r4, #68]	; 0x44
ffff4fa0:	e3500c02 	cmp	r0, #512	; 0x200
ffff4fa4:	9a000001 	bls	0xffff4fb0

ffff4fa8:	e3000200 	movw	r0, #512	; 0x200
ffff4fac:	e5840044 	str	r0, [r4, #68]	; 0x44

ffff4fb0:	e3a00007 	mov	r0, #7
ffff4fb4:	e58d0204 	str	r0, [sp, #516]	; 0x204
ffff4fb8:	e3a0001d 	mov	r0, #29
ffff4fbc:	e58d0208 	str	r0, [sp, #520]	; 0x208
ffff4fc0:	e5940034 	ldr	r0, [r4, #52]	; 0x34
ffff4fc4:	e1a00800 	lsl	r0, r0, #16
ffff4fc8:	e58d020c 	str	r0, [sp, #524]	; 0x20c
ffff4fcc:	e3a00000 	mov	r0, #0
ffff4fd0:	e58d0220 	str	r0, [sp, #544]	; 0x220
ffff4fd4:	e3a02000 	mov	r2, #0
ffff4fd8:	e28d1f81 	add	r1, sp, #516	; 0x204
ffff4fdc:	e1a00004 	mov	r0, r4
ffff4fe0:	ebfffbf7 	bl	0xffff3fc4
ffff4fe4:	e1a05000 	mov	r5, r0
ffff4fe8:	e3550000 	cmp	r5, #0
ffff4fec:	0a000001 	beq	0xffff4ff8

ffff4ff0:	e1a00005 	mov	r0, r5
ffff4ff4:	eaffff89 	b	0xffff4e20

ffff4ff8:	e3a000ff 	mov	r0, #255	; 0xff
ffff4ffc:	e5840038 	str	r0, [r4, #56]	; 0x38
ffff5000:	e584003c 	str	r0, [r4, #60]	; 0x3c
ffff5004:	e5940008 	ldr	r0, [r4, #8]
ffff5008:	e3100802 	tst	r0, #131072	; 0x20000
ffff500c:	1a000036 	bne	0xffff50ec

ffff5010:	e5940008 	ldr	r0, [r4, #8]
ffff5014:	e59f147c 	ldr	r1, [pc, #1148]	; 0xffff5498 =0x00010040
ffff5018:	e1500001 	cmp	r0, r1
ffff501c:	3a000032 	bcc	0xffff50ec

ffff5020:	e28d1004 	add	r1, sp, #4
ffff5024:	e1a00004 	mov	r0, r4
ffff5028:	ebfffe74 	bl	0xffff4a00
ffff502c:	e1a05000 	mov	r5, r0
ffff5030:	e5dd00c4 	ldrb	r0, [sp, #196]	; 0xc4
ffff5034:	e3500007 	cmp	r0, #7
ffff5038:	308ff100 	addcc	pc, pc, r0, lsl #2
ffff503c:	ea00001e 	b	0xffff50bc
ffff5040:	ea000005 	b	0xffff505c
ffff5044:	ea000008 	b	0xffff506c
ffff5048:	ea00000b 	b	0xffff507c
ffff504c:	ea00000e 	b	0xffff508c
ffff5050:	ea000019 	b	0xffff50bc
ffff5054:	ea000010 	b	0xffff509c
ffff5058:	ea000013 	b	0xffff50ac

ffff505c:	e320f000 	nop	{0}
ffff5060:	e59f0430 	ldr	r0, [pc, #1072]	; 0xffff5498 =0x00010040
ffff5064:	e5840008 	str	r0, [r4, #8]
ffff5068:	ea000013 	b	0xffff50bc

ffff506c:	e320f000 	nop	{0}
ffff5070:	e59f0440 	ldr	r0, [pc, #1088]	; 0xffff54b8
ffff5074:	e5840008 	str	r0, [r4, #8]
ffff5078:	ea00000f 	b	0xffff50bc

ffff507c:	e320f000 	nop	{0}
ffff5080:	e59f0434 	ldr	r0, [pc, #1076]	; 0xffff54bc
ffff5084:	e5840008 	str	r0, [r4, #8]
ffff5088:	ea00000b 	b	0xffff50bc

ffff508c:	e320f000 	nop	{0}
ffff5090:	e59f0428 	ldr	r0, [pc, #1064]	; 0xffff54c0
ffff5094:	e5840008 	str	r0, [r4, #8]
ffff5098:	ea000007 	b	0xffff50bc

ffff509c:	e320f000 	nop	{0}
ffff50a0:	e59f041c 	ldr	r0, [pc, #1052]	; 0xffff54c4
ffff50a4:	e5840008 	str	r0, [r4, #8]
ffff50a8:	ea000003 	b	0xffff50bc

ffff50ac:	e320f000 	nop	{0}
ffff50b0:	e59f0410 	ldr	r0, [pc, #1040]	; 0xffff54c8
ffff50b4:	e5840008 	str	r0, [r4, #8]
ffff50b8:	e320f000 	nop	{0}

ffff50bc:	e320f000 	nop	{0}
ffff50c0:	e5dd00a4 	ldrb	r0, [sp, #164]	; 0xa4
ffff50c4:	e3100001 	tst	r0, #1
ffff50c8:	0a000001 	beq	0xffff50d4

ffff50cc:	e5dd00b7 	ldrb	r0, [sp, #183]	; 0xb7
ffff50d0:	e5840038 	str	r0, [r4, #56]	; 0x38

ffff50d4:	e5940008 	ldr	r0, [r4, #8]
ffff50d8:	e59f13e0 	ldr	r1, [pc, #992]	; 0xffff54c0
ffff50dc:	e1500001 	cmp	r0, r1
ffff50e0:	3a000001 	bcc	0xffff50ec

ffff50e4:	e5dd00b5 	ldrb	r0, [sp, #181]	; 0xb5
ffff50e8:	e584003c 	str	r0, [r4, #60]	; 0x3c

ffff50ec:	e5940008 	ldr	r0, [r4, #8]
ffff50f0:	e3100802 	tst	r0, #131072	; 0x20000
ffff50f4:	0a000003 	beq	0xffff5108

ffff50f8:	e1a00004 	mov	r0, r4
ffff50fc:	ebfffeab 	bl	0xffff4bb0
ffff5100:	e1a05000 	mov	r5, r0
ffff5104:	ea000003 	b	0xffff5118

ffff5108:	e28d1004 	add	r1, sp, #4
ffff510c:	e1a00004 	mov	r0, r4
ffff5110:	ebfffe70 	bl	0xffff4ad8
ffff5114:	e1a05000 	mov	r5, r0

ffff5118:	e3550000 	cmp	r5, #0
ffff511c:	0a000001 	beq	0xffff5128

ffff5120:	e1a00005 	mov	r0, r5
ffff5124:	eaffff3d 	b	0xffff4e20

ffff5128:	e1c402d0 	ldrd	r0, [r4, #32]
ffff512c:	e0000001 	and	r0, r0, r1
ffff5130:	e5840020 	str	r0, [r4, #32]
ffff5134:	e5940008 	ldr	r0, [r4, #8]
ffff5138:	e3100802 	tst	r0, #131072	; 0x20000
ffff513c:	0a000033 	beq	0xffff5210

ffff5140:	e5940020 	ldr	r0, [r4, #32]
ffff5144:	e3100c01 	tst	r0, #256	; 0x100
ffff5148:	0a000025 	beq	0xffff51e4

ffff514c:	e3a00037 	mov	r0, #55	; 0x37
ffff5150:	e58d0204 	str	r0, [sp, #516]	; 0x204
ffff5154:	e3a00015 	mov	r0, #21
ffff5158:	e58d0208 	str	r0, [sp, #520]	; 0x208
ffff515c:	e5940034 	ldr	r0, [r4, #52]	; 0x34
ffff5160:	e1a00800 	lsl	r0, r0, #16
ffff5164:	e58d020c 	str	r0, [sp, #524]	; 0x20c
ffff5168:	e3a00000 	mov	r0, #0
ffff516c:	e58d0220 	str	r0, [sp, #544]	; 0x220
ffff5170:	e3a02000 	mov	r2, #0
ffff5174:	e28d1f81 	add	r1, sp, #516	; 0x204
ffff5178:	e1a00004 	mov	r0, r4
ffff517c:	ebfffb90 	bl	0xffff3fc4
ffff5180:	e1a05000 	mov	r5, r0
ffff5184:	e3550000 	cmp	r5, #0
ffff5188:	0a000001 	beq	0xffff5194

ffff518c:	e1a00005 	mov	r0, r5
ffff5190:	eaffff22 	b	0xffff4e20

ffff5194:	e3a00006 	mov	r0, #6
ffff5198:	e58d0204 	str	r0, [sp, #516]	; 0x204
ffff519c:	e3a00015 	mov	r0, #21
ffff51a0:	e58d0208 	str	r0, [sp, #520]	; 0x208
ffff51a4:	e3a00002 	mov	r0, #2
ffff51a8:	e58d020c 	str	r0, [sp, #524]	; 0x20c
ffff51ac:	e3a00000 	mov	r0, #0
ffff51b0:	e58d0220 	str	r0, [sp, #544]	; 0x220
ffff51b4:	e3a02000 	mov	r2, #0
ffff51b8:	e28d1f81 	add	r1, sp, #516	; 0x204
ffff51bc:	e1a00004 	mov	r0, r4
ffff51c0:	ebfffb7f 	bl	0xffff3fc4
ffff51c4:	e1a05000 	mov	r5, r0
ffff51c8:	e3550000 	cmp	r5, #0
ffff51cc:	0a000001 	beq	0xffff51d8
ffff51d0:	e1a00005 	mov	r0, r5
ffff51d4:	eaffff11 	b	0xffff4e20
ffff51d8:	e3a01004 	mov	r1, #4
ffff51dc:	e1a00004 	mov	r0, r4
ffff51e0:	ebfffef4 	bl	0xffff4db8

ffff51e4:	e5940020 	ldr	r0, [r4, #32]
ffff51e8:	e3100001 	tst	r0, #1
ffff51ec:	0a000003 	beq	0xffff5200

ffff51f0:	e59f12d4 	ldr	r1, [pc, #724]	; 0xffff54cc
ffff51f4:	e1a00004 	mov	r0, r4
ffff51f8:	ebfffedf 	bl	0xffff4d7c
ffff51fc:	ea000035 	b	0xffff52d8

ffff5200:	e59f12c8 	ldr	r1, [pc, #712]	; 0xffff54d0 =0x017d7840 (25000000)
ffff5204:	e1a00004 	mov	r0, r4
ffff5208:	ebfffedb 	bl	0xffff4d7c
ffff520c:	ea000031 	b	0xffff52d8

ffff5210:	e5940020 	ldr	r0, [r4, #32]
ffff5214:	e3100c01 	tst	r0, #256	; 0x100
ffff5218:	0a00000d 	beq	0xffff5254

ffff521c:	e3a03001 	mov	r3, #1
ffff5220:	e3a020b7 	mov	r2, #183	; 0xb7
ffff5224:	e1a01003 	mov	r1, r3
ffff5228:	e1a00004 	mov	r0, r4
ffff522c:	ebfffe0d 	bl	0xffff4a68
ffff5230:	e1a05000 	mov	r5, r0
ffff5234:	e3550000 	cmp	r5, #0
ffff5238:	0a000001 	beq	0xffff5244

ffff523c:	e1a00005 	mov	r0, r5
ffff5240:	eafffef6 	b	0xffff4e20

ffff5244:	e3a01004 	mov	r1, #4
ffff5248:	e1a00004 	mov	r0, r4
ffff524c:	ebfffed9 	bl	0xffff4db8
ffff5250:	ea00000f 	b	0xffff5294

ffff5254:	e5940020 	ldr	r0, [r4, #32]
ffff5258:	e3100c02 	tst	r0, #512	; 0x200
ffff525c:	0a00000c 	beq	0xffff5294

ffff5260:	e3a03002 	mov	r3, #2
ffff5264:	e3a020b7 	mov	r2, #183	; 0xb7
ffff5268:	e3a01001 	mov	r1, #1
ffff526c:	e1a00004 	mov	r0, r4
ffff5270:	ebfffdfc 	bl	0xffff4a68
ffff5274:	e1a05000 	mov	r5, r0
ffff5278:	e3550000 	cmp	r5, #0
ffff527c:	0a000001 	beq	0xffff5288

ffff5280:	e1a00005 	mov	r0, r5
ffff5284:	eafffee5 	b	0xffff4e20

ffff5288:	e3a01008 	mov	r1, #8
ffff528c:	e1a00004 	mov	r0, r4
ffff5290:	ebfffec8 	bl	0xffff4db8

ffff5294:	e5940020 	ldr	r0, [r4, #32]
ffff5298:	e3100001 	tst	r0, #1
ffff529c:	0a00000a 	beq	0xffff52cc

ffff52a0:	e5940020 	ldr	r0, [r4, #32]
ffff52a4:	e3100010 	tst	r0, #16
ffff52a8:	0a000003 	beq	0xffff52bc

ffff52ac:	e59f1220 	ldr	r1, [pc, #544]	; 0xffff54d4
ffff52b0:	e1a00004 	mov	r0, r4
ffff52b4:	ebfffeb0 	bl	0xffff4d7c
ffff52b8:	ea000006 	b	0xffff52d8

ffff52bc:	e59f1214 	ldr	r1, [pc, #532]	; 0xffff54d8
ffff52c0:	e1a00004 	mov	r0, r4
ffff52c4:	ebfffeac 	bl	0xffff4d7c
ffff52c8:	ea000002 	b	0xffff52d8

ffff52cc:	e59f1208 	ldr	r1, [pc, #520]	; 0xffff54dc
ffff52d0:	e1a00004 	mov	r0, r4
ffff52d4:	ebfffea8 	bl	0xffff4d7c

ffff52d8:	e3a00000 	mov	r0, #0
ffff52dc:	eafffecf 	b	0xffff4e20

;;;********************************************************************************
ffff52e0:	e92d4030 	push	{r4, r5, lr}
ffff52e4:	e24dd024 	sub	sp, sp, #36	; 0x24
ffff52e8:	e1a04000 	mov	r4, r0
ffff52ec:	e3a00008 	mov	r0, #8
ffff52f0:	e58d0000 	str	r0, [sp]
ffff52f4:	e5940004 	ldr	r0, [r4, #4]
ffff52f8:	e59f1190 	ldr	r1, [pc, #400]	; 0xffff5490 =0x00ff8000
ffff52fc:	e1100001 	tst	r0, r1
ffff5300:	0a000001 	beq	0xffff530c

ffff5304:	e3a00001 	mov	r0, #1
ffff5308:	ea000000 	b	0xffff5310

ffff530c:	e3a00000 	mov	r0, #0

ffff5310:	e3a010aa 	mov	r1, #170	; 0xaa
ffff5314:	e1810400 	orr	r0, r1, r0, lsl #8
ffff5318:	e58d0008 	str	r0, [sp, #8]
ffff531c:	e3a00015 	mov	r0, #21
ffff5320:	e58d0004 	str	r0, [sp, #4]
ffff5324:	e3a00000 	mov	r0, #0
ffff5328:	e58d001c 	str	r0, [sp, #28]
ffff532c:	e3a02000 	mov	r2, #0
ffff5330:	e1a0100d 	mov	r1, sp
ffff5334:	e1a00004 	mov	r0, r4
ffff5338:	ebfffb21 	bl	0xffff3fc4
ffff533c:	e1a05000 	mov	r5, r0
ffff5340:	e3550000 	cmp	r5, #0
ffff5344:	0a000002 	beq	0xffff5354

ffff5348:	e1a00005 	mov	r0, r5

ffff534c:	e28dd024 	add	sp, sp, #36	; 0x24
ffff5350:	e8bd8030 	pop	{r4, r5, pc}

ffff5354:	e59d000c 	ldr	r0, [sp, #12]
ffff5358:	e20000ff 	and	r0, r0, #255	; 0xff
ffff535c:	e35000aa 	cmp	r0, #170	; 0xaa
ffff5360:	0a000001 	beq	0xffff536c

ffff5364:	e3e00010 	mvn	r0, #16
ffff5368:	eafffff7 	b	0xffff534c

ffff536c:	e59f012c 	ldr	r0, [pc, #300]	; 0xffff54a0 =0x00020020
ffff5370:	e5840008 	str	r0, [r4, #8]
ffff5374:	e3a00000 	mov	r0, #0
ffff5378:	eafffff3 	b	0xffff534c

;;;********************************************************************************
ffff537c:	e92d41f0 	push	{r4, r5, r6, r7, r8, lr}
ffff5380:	e24dd038 	sub	sp, sp, #56	; 0x38
ffff5384:	e1a04000 	mov	r4, r0
ffff5388:	e1a08001 	mov	r8, r1
ffff538c:	e1a06002 	mov	r6, r2
ffff5390:	e1a05003 	mov	r5, r3
ffff5394:	e3550000 	cmp	r5, #0
ffff5398:	0a000004 	beq	0xffff53b0

ffff539c:	e3a00012 	mov	r0, #18
ffff53a0:	e58d0014 	str	r0, [sp, #20]
ffff53a4:	e3a00000 	mov	r0, #0
ffff53a8:	e58d0034 	str	r0, [sp, #52]	; 0x34
ffff53ac:	ea000002 	b	0xffff53bc

ffff53b0:	e3a00000 	mov	r0, #0

ffff53b4:	e28dd038 	add	sp, sp, #56	; 0x38
ffff53b8:	e8bd81f0 	pop	{r4, r5, r6, r7, r8, pc}

ffff53bc:	e5940014 	ldr	r0, [r4, #20]
ffff53c0:	e3500000 	cmp	r0, #0
ffff53c4:	0a000001 	beq	0xffff53d0

ffff53c8:	e58d601c 	str	r6, [sp, #28]
ffff53cc:	ea000002 	b	0xffff53dc

ffff53d0:	e5940044 	ldr	r0, [r4, #68]	; 0x44
ffff53d4:	e0000690 	mul	r0, r0, r6
ffff53d8:	e58d001c 	str	r0, [sp, #28]

ffff53dc:	e3a00015 	mov	r0, #21
ffff53e0:	e58d0018 	str	r0, [sp, #24]
ffff53e4:	e3a00000 	mov	r0, #0
ffff53e8:	e58d0030 	str	r0, [sp, #48]	; 0x30
ffff53ec:	e58d8004 	str	r8, [sp, #4]
ffff53f0:	e58d500c 	str	r5, [sp, #12]
ffff53f4:	e5940044 	ldr	r0, [r4, #68]	; 0x44
ffff53f8:	e58d0010 	str	r0, [sp, #16]
ffff53fc:	e3a00001 	mov	r0, #1
ffff5400:	e58d0008 	str	r0, [sp, #8]
ffff5404:	e28d2004 	add	r2, sp, #4
ffff5408:	e28d1014 	add	r1, sp, #20
ffff540c:	e1a00004 	mov	r0, r4
ffff5410:	ebfffaeb 	bl	0xffff3fc4
ffff5414:	e1a07000 	mov	r7, r0
ffff5418:	e59d0014 	ldr	r0, [sp, #20]
ffff541c:	e3500012 	cmp	r0, #18
ffff5420:	1a000011 	bne	0xffff546c

ffff5424:	e59d0034 	ldr	r0, [sp, #52]	; 0x34
ffff5428:	e3500000 	cmp	r0, #0

ffff542c:	1a00000e 	bne	0xffff546c
ffff5430:	e3a0000c 	mov	r0, #12
ffff5434:	e58d0014 	str	r0, [sp, #20]
ffff5438:	e3a0001d 	mov	r0, #29
ffff543c:	e58d0018 	str	r0, [sp, #24]
ffff5440:	e3a00000 	mov	r0, #0
ffff5444:	e58d001c 	str	r0, [sp, #28]
ffff5448:	e58d0030 	str	r0, [sp, #48]	; 0x30
ffff544c:	e3a02000 	mov	r2, #0
ffff5450:	e28d1014 	add	r1, sp, #20
ffff5454:	e1a00004 	mov	r0, r4
ffff5458:	ebfffad9 	bl	0xffff3fc4
ffff545c:	e3500000 	cmp	r0, #0
ffff5460:	0a000001 	beq	0xffff546c
ffff5464:	e3a00000 	mov	r0, #0
ffff5468:	eaffffd1 	b	0xffff53b4
ffff546c:	e3570000 	cmp	r7, #0
ffff5470:	0a000001 	beq	0xffff547c

ffff5474:	e3a00000 	mov	r0, #0
ffff5478:	eaffffcd 	b	0xffff53b4

ffff547c:	e1a00005 	mov	r0, r5
ffff5480:	eaffffcb 	b	0xffff53b4

;;;********************************************************************************

	;; Global Offset Table
ffff5484:	fdf94080
ffff5488:	f0f0f0f0
ffff548c:	f0f0f0fa
ffff5490:	00ff8000
ffff5494:	00020010
ffff5498:	00010040
ffff549c:	0002001a
ffff54a0:	00020020
ffff54a4:	005b8d80
ffff54a8:	00010012
ffff54ac:	00010014
ffff54b0:	00010022
ffff54b4:	00010030
ffff54b8:	00010041
ffff54bc:	00010042
ffff54c0:	00010043
ffff54c4:	00010044
ffff54c8:	00010045
ffff54cc:	02faf080
ffff54d0:	017d7840
ffff54d4:	03197500
ffff54d8:	018cba80
ffff54dc:	01312d00

;;;********************************************************************************
ffff54e0:	e92d47f0 	push	{r4, r5, r6, r7, r8, r9, sl, lr}
ffff54e4:	e1a05000 	mov	r5, r0
ffff54e8:	e1a08001 	mov	r8, r1
ffff54ec:	e1a06002 	mov	r6, r2
ffff54f0:	e1a09003 	mov	r9, r3
ffff54f4:	e1a07006 	mov	r7, r6
ffff54f8:	e3560000 	cmp	r6, #0
ffff54fc:	1a000001 	bne	0xffff5508

ffff5500:	e3a00000 	mov	r0, #0

ffff5504:	e8bd87f0 	pop	{r4, r5, r6, r7, r8, r9, sl, pc}

ffff5508:	e320f000 	nop	{0}

ffff550c:	e5950048 	ldr	r0, [r5, #72]	; 0x48
ffff5510:	e1500007 	cmp	r0, r7
ffff5514:	2a000001 	bcs	0xffff5520

ffff5518:	e5950048 	ldr	r0, [r5, #72]	; 0x48
ffff551c:	ea000000 	b	0xffff5524

ffff5520:	e1a00007 	mov	r0, r7

ffff5524:	e1a04000 	mov	r4, r0
ffff5528:	e1a03004 	mov	r3, r4
ffff552c:	e1a02008 	mov	r2, r8
ffff5530:	e1a01009 	mov	r1, r9
ffff5534:	e1a00005 	mov	r0, r5
ffff5538:	ebffff8f 	bl	0xffff537c
ffff553c:	e1500004 	cmp	r0, r4
ffff5540:	0a000001 	beq	0xffff554c

ffff5544:	e3a00000 	mov	r0, #0
ffff5548:	eaffffed 	b	0xffff5504

ffff554c:	e0477004 	sub	r7, r7, r4
ffff5550:	e0888004 	add	r8, r8, r4
ffff5554:	e5950044 	ldr	r0, [r5, #68]	; 0x44
ffff5558:	e0299094 	mla	r9, r4, r0, r9
ffff555c:	e3570000 	cmp	r7, #0
ffff5560:	1affffe9 	bne	0xffff550c

ffff5564:	e1a00006 	mov	r0, r6
ffff5568:	eaffffe5 	b	0xffff5504

;;;********************************************************************************
ffff556c:	e92d43f0 	push	{r4, r5, r6, r7, r8, r9, lr}
ffff5570:	e24dd034 	sub	sp, sp, #52	; 0x34
ffff5574:	e1a05000 	mov	r5, r0
ffff5578:	e1a09001 	mov	r9, r1
ffff557c:	e1a06002 	mov	r6, r2
ffff5580:	e1a07003 	mov	r7, r3
ffff5584:	e3a04000 	mov	r4, #0
ffff5588:	e3a08001 	mov	r8, #1
ffff558c:	e59f02a4 	ldr	r0, [pc, #676]	; 0xffff5838 = 0x00b71b00 (12000000)
ffff5590:	e585001c 	str	r0, [r5, #28]
ffff5594:	e320f000 	nop	{0}
ffff5598:	e1a00005 	mov	r0, r5
ffff559c:	ebfff95e 	bl	0xffff3b1c
ffff55a0:	e1a00005 	mov	r0, r5
ffff55a4:	ebfff96b 	bl	0xffff3b58
ffff55a8:	e300012c 	movw	r0, #300	; 0x12c
ffff55ac:	e3a01000 	mov	r1, #0
ffff55b0:	ebfff847 	bl	0xffff36d4
ffff55b4:	e1a00005 	mov	r0, r5
ffff55b8:	ebfffc4e 	bl	0xffff46f8
ffff55bc:	e3a00000 	mov	r0, #0
ffff55c0:	e58d0010 	str	r0, [sp, #16]
ffff55c4:	e58d0018 	str	r0, [sp, #24]
ffff55c8:	e58d0014 	str	r0, [sp, #20]
ffff55cc:	e3a00001 	mov	r0, #1
ffff55d0:	e58d002c 	str	r0, [sp, #44]	; 0x2c
ffff55d4:	e58d7000 	str	r7, [sp]
ffff55d8:	e58d6008 	str	r6, [sp, #8]
ffff55dc:	e3000200 	movw	r0, #512	; 0x200
ffff55e0:	e58d000c 	str	r0, [sp, #12]
ffff55e4:	e3a00001 	mov	r0, #1
ffff55e8:	e58d0004 	str	r0, [sp, #4]
ffff55ec:	e1a0200d 	mov	r2, sp
ffff55f0:	e28d1010 	add	r1, sp, #16
ffff55f4:	e1a00005 	mov	r0, r5
ffff55f8:	ebfffa71 	bl	0xffff3fc4
ffff55fc:	e1a04000 	mov	r4, r0
ffff5600:	e3740005 	cmn	r4, #5
ffff5604:	0a000001 	beq	0xffff5610
ffff5608:	e3740006 	cmn	r4, #6
ffff560c:	1a000002 	bne	0xffff561c
ffff5610:	e1a00004 	mov	r0, r4
ffff5614:	e28dd034 	add	sp, sp, #52	; 0x34
ffff5618:	e8bd83f0 	pop	{r4, r5, r6, r7, r8, r9, pc}

ffff561c:	e3540000 	cmp	r4, #0
ffff5620:	0a000008 	beq	0xffff5648
ffff5624:	e3580000 	cmp	r8, #0
ffff5628:	0a000006 	beq	0xffff5648
ffff562c:	e3a08000 	mov	r8, #0
ffff5630:	e51f0194 	ldr	r0, [pc, #-404]	; 0xffff54a4 =0x005b8d80
ffff5634:	e585001c 	str	r0, [r5, #28]
ffff5638:	e3a00001 	mov	r0, #1
ffff563c:	e3a01000 	mov	r1, #0
ffff5640:	ebfff839 	bl	0xffff372c
ffff5644:	eaffffd3 	b	0xffff5598
ffff5648:	e3540000 	cmp	r4, #0
ffff564c:	0a000001 	beq	0xffff5658
ffff5650:	e1a00004 	mov	r0, r4
ffff5654:	eaffffee 	b	0xffff5614
ffff5658:	e1a00006 	mov	r0, r6
ffff565c:	eaffffec 	b	0xffff5614

;;;********************************************************************************
ffff5660:	e92d4070 	push	{r4, r5, r6, lr}
ffff5664:	e1a05000 	mov	r5, r0
ffff5668:	e3a04000 	mov	r4, #0
ffff566c:	e1a00005 	mov	r0, r5
ffff5670:	ebfff957 	bl	0xffff3bd4
ffff5674:	e1a04000 	mov	r4, r0
ffff5678:	e3540000 	cmp	r4, #0
ffff567c:	0a000001 	beq	0xffff5688

ffff5680:	e1a00004 	mov	r0, r4

ffff5684:	e8bd8070 	pop	{r4, r5, r6, pc}

ffff5688:	e1a00005 	mov	r0, r5
ffff568c:	ebfff922 	bl	0xffff3b1c
ffff5690:	e59f01a4 	ldr	r0, [pc, #420]	; 0xffff583c =0x00061a80 (400000)
ffff5694:	e585001c 	str	r0, [r5, #28]
ffff5698:	e3a00001 	mov	r0, #1
ffff569c:	e5850018 	str	r0, [r5, #24]
ffff56a0:	e1a00005 	mov	r0, r5
ffff56a4:	ebfff92b 	bl	0xffff3b58
ffff56a8:	e300012c 	movw	r0, #300	; 0x12c
ffff56ac:	e3a01000 	mov	r1, #0
ffff56b0:	ebfff807 	bl	0xffff36d4
ffff56b4:	e1a00005 	mov	r0, r5
ffff56b8:	ebfffbfa 	bl	0xffff46a8
ffff56bc:	e1a04000 	mov	r4, r0
ffff56c0:	e3540000 	cmp	r4, #0
ffff56c4:	0a000001 	beq	0xffff56d0

ffff56c8:	e1a00004 	mov	r0, r4
ffff56cc:	eaffffec 	b	0xffff5684

ffff56d0:	e3a00000 	mov	r0, #0
ffff56d4:	e5850040 	str	r0, [r5, #64]	; 0x40
ffff56d8:	e1a00005 	mov	r0, r5
ffff56dc:	ebfffeff 	bl	0xffff52e0
ffff56e0:	e1a00005 	mov	r0, r5
ffff56e4:	ebfffc2c 	bl	0xffff479c
ffff56e8:	e1a04000 	mov	r4, r0
ffff56ec:	e3540000 	cmp	r4, #0
ffff56f0:	0a000006 	beq	0xffff5710

ffff56f4:	e1a00005 	mov	r0, r5
ffff56f8:	ebfffc71 	bl	0xffff48c4
ffff56fc:	e1a04000 	mov	r4, r0
ffff5700:	e3540000 	cmp	r4, #0
ffff5704:	0a000001 	beq	0xffff5710

ffff5708:	e3e00010 	mvn	r0, #16
ffff570c:	eaffffdc 	b	0xffff5684

ffff5710:	e1a00004 	mov	r0, r4
ffff5714:	eaffffda 	b	0xffff5684

;;;********************************************************************************
ffff5718:	e92d4070 	push	{r4, r5, r6, lr} ; r0 = card_no, r1 = structure
ffff571c:	e1a06000 	mov	r6, r0
ffff5720:	e1a04001 	mov	r4, r1
ffff5724:	e3e05000 	mvn	r5, #0
ffff5728:	e1a01004 	mov	r1, r4
ffff572c:	e1a00006 	mov	r0, r6
ffff5730:	ebfffb88 	bl	0xffff4558
ffff5734:	e1a05000 	mov	r5, r0
ffff5738:	e3550000 	cmp	r5, #0
ffff573c:	0a000001 	beq	0xffff5748

ffff5740:	e3e00000 	mvn	r0, #0

ffff5744:	e8bd8070 	pop	{r4, r5, r6, pc}

ffff5748:	e300012c 	movw	r0, #300	; 0x12c
ffff574c:	e5840048 	str	r0, [r4, #72]	; 0x48
ffff5750:	e1a00004 	mov	r0, r4
ffff5754:	ebffffc1 	bl	0xffff5660
ffff5758:	e1a05000 	mov	r5, r0
ffff575c:	e3550000 	cmp	r5, #0
ffff5760:	0a000001 	beq	0xffff576c

ffff5764:	e3e00000 	mvn	r0, #0
ffff5768:	eafffff5 	b	0xffff5744

ffff576c:	e1a00004 	mov	r0, r4
ffff5770:	ebfffd97 	bl	0xffff4dd4
ffff5774:	e1a05000 	mov	r5, r0
ffff5778:	e3550000 	cmp	r5, #0
ffff577c:	0a000001 	beq	0xffff5788

ffff5780:	e3e00000 	mvn	r0, #0
ffff5784:	eaffffee 	b	0xffff5744

ffff5788:	e3a00000 	mov	r0, #0
ffff578c:	eaffffec 	b	0xffff5744

;;;********************************************************************************
ffff5790:	e92d4070 	push	{r4, r5, r6, lr}
ffff5794:	e1a06000 	mov	r6, r0
ffff5798:	e1a04001 	mov	r4, r1
ffff579c:	e3e05000 	mvn	r5, #0
ffff57a0:	e1a01004 	mov	r1, r4
ffff57a4:	e1a00006 	mov	r0, r6
ffff57a8:	ebfffb6a 	bl	0xffff4558
ffff57ac:	e1a05000 	mov	r5, r0
ffff57b0:	e3550000 	cmp	r5, #0
ffff57b4:	0a000001 	beq	0xffff57c0

ffff57b8:	e3e00000 	mvn	r0, #0

ffff57bc:	e8bd8070 	pop	{r4, r5, r6, pc}

ffff57c0:	e300012c 	movw	r0, #300	; 0x12c
ffff57c4:	e5840048 	str	r0, [r4, #72]	; 0x48
ffff57c8:	e1a00004 	mov	r0, r4
ffff57cc:	ebfff900 	bl	0xffff3bd4
ffff57d0:	e1a05000 	mov	r5, r0
ffff57d4:	e3550000 	cmp	r5, #0
ffff57d8:	0a000001 	beq	0xffff57e4

ffff57dc:	e1a00005 	mov	r0, r5
ffff57e0:	eafffff5 	b	0xffff57bc

ffff57e4:	e1a00004 	mov	r0, r4
ffff57e8:	ebfff8cb 	bl	0xffff3b1c
ffff57ec:	e59f0044 	ldr	r0, [pc, #68]	; 0xffff5838 =0x00b71b00 (12000000)
ffff57f0:	e584001c 	str	r0, [r4, #28]
ffff57f4:	e3a00004 	mov	r0, #4
ffff57f8:	e5840018 	str	r0, [r4, #24]
ffff57fc:	e1a00004 	mov	r0, r4
ffff5800:	ebfff8d4 	bl	0xffff3b58
ffff5804:	e300012c 	movw	r0, #300	; 0x12c
ffff5808:	e3a01000 	mov	r1, #0
ffff580c:	ebfff7b0 	bl	0xffff36d4
ffff5810:	e3a00000 	mov	r0, #0
ffff5814:	eaffffe8 	b	0xffff57bc

;;;********************************************************************************
ffff5818:	e92d4070 	push	{r4, r5, r6, lr}
ffff581c:	e1a04000 	mov	r4, r0
ffff5820:	e1a05001 	mov	r5, r1
ffff5824:	e1a01005 	mov	r1, r5
ffff5828:	e1a00004 	mov	r0, r4
ffff582c:	ebfffb64 	bl	0xffff45c4
ffff5830:	e3a00000 	mov	r0, #0
ffff5834:	e8bd8070 	pop	{r4, r5, r6, pc}

;;;********************************************************************************
	;; Global Offset Table
ffff5838:	00b71b00				; 12000000
ffff583c:	00061a80				; 400000

;;;********************************************************************************
ffff5840:	e59f06e8 	ldr	r0, [pc, #1768]	; 0xffff5f30 =0x77773333 =b0 111 0 111 0 111 0 111 0 011 0 011 0 011 0 011
ffff5844:	e59f16e8 	ldr	r1, [pc, #1768]	; 0xffff5f34 =0x01c20848 PC_CFG0
ffff5848:	e5810000 	str	r0, [r1]	; configure PC as SPI
ffff584c:	e3a00010 	mov	r0, #16		; 00 00 00 00 00 00 00 00 01 00 00
ffff5850:	e281101c 	add	r1, r1, #28	; PC_PULL0
ffff5854:	e5810000 	str	r0, [r1] 	; enable pull-up on PC2
ffff5858:	e12fff1e 	bx	lr

;;;********************************************************************************
ffff585c:	e59f06d4 	ldr	r0, [pc, #1748]	; 0xffff5f38 =0x77777777 =b0 111 0 111 0 111 0 111 0 111 0 111 0 111 0 111
ffff5860:	e59f16cc 	ldr	r1, [pc, #1740]	; 0xffff5f34 =0x01c20848 PC_CFG0
ffff5864:	e5810000 	str	r0, [r1]	; configure PC as disabled I/O
ffff5868:	e3a00000 	mov	r0, #0
ffff586c:	e281101c 	add	r1, r1, #28 	; PC_PULL0
ffff5870:	e5810000 	str	r0, [r1]	; disable pull-ups
ffff5874:	e12fff1e 	bx	lr

;;;********************************************************************************
ffff5878:	e92d4010 	push	{r4, lr}
ffff587c:	e59f06b8 	ldr	r0, [pc, #1720]	; 0xffff5f3c =0x01c20000 SCU_BASE
ffff5880:	e59002c0 	ldr	r0, [r0, #704]	; 0x2c0
ffff5884:	e3800601 	orr	r0, r0, #1048576	; 0x100000
ffff5888:	e59f16ac 	ldr	r1, [pc, #1708]	; 0xffff5f3c =0x01c20000 SCU_BASE
ffff588c:	e58102c0 	str	r0, [r1, #704]	; 0x2c0
ffff5890:	e1a00001 	mov	r0, r1
ffff5894:	e5900060 	ldr	r0, [r0, #96]	; 0x60
ffff5898:	e3800601 	orr	r0, r0, #1048576	; 0x100000
ffff589c:	e5810060 	str	r0, [r1, #96]	; 0x60
ffff58a0:	e3a00102 	mov	r0, #-2147483648	; 0x80000000
ffff58a4:	e58100a0 	str	r0, [r1, #160]	; 0xa0
ffff58a8:	ebffffe4 	bl	0xffff5840
ffff58ac:	e59f0688 	ldr	r0, [pc, #1672]	; 0xffff5f3c =0x01c20000 SCU_BASE
ffff58b0:	e59002c0 	ldr	r0, [r0, #704]	; 0x2c0
ffff58b4:	e3800040 	orr	r0, r0, #64	; 0x40
ffff58b8:	e59f167c 	ldr	r1, [pc, #1660]	; 0xffff5f3c =0x01c20000 SCU_BASE
ffff58bc:	e58102c0 	str	r0, [r1, #704]	; 0x2c0
ffff58c0:	e1a00001 	mov	r0, r1
ffff58c4:	e5900060 	ldr	r0, [r0, #96]	; 0x60
ffff58c8:	e3800040 	orr	r0, r0, #64	; 0x40
ffff58cc:	e5810060 	str	r0, [r1, #96]	; 0x60
ffff58d0:	e3010001 	movw	r0, #4097	; 0x1001
ffff58d4:	e2811912 	add	r1, r1, #294912	; 0x48000
ffff58d8:	e5810024 	str	r0, [r1, #36]	; 0x24
ffff58dc:	e59f065c 	ldr	r0, [pc, #1628]	; 0xffff5f40 =0x80000083
ffff58e0:	e5810004 	str	r0, [r1, #4]
ffff58e4:	e3000184 	movw	r0, #388	; 0x184
ffff58e8:	e5810008 	str	r0, [r1, #8]
ffff58ec:	e59f0650 	ldr	r0, [pc, #1616]	; 0xffff5f44 =0x80208020
ffff58f0:	e5810018 	str	r0, [r1, #24]
ffff58f4:	e3a00000 	mov	r0, #0
ffff58f8:	e5810010 	str	r0, [r1, #16]
ffff58fc:	e3e00000 	mvn	r0, #0
ffff5900:	e5810014 	str	r0, [r1, #20]
ffff5904:	e8bd8010 	pop	{r4, pc}

;;;********************************************************************************
ffff5908:	e92d4010 	push	{r4, lr}
ffff590c:	e3a00000 	mov	r0, #0
ffff5910:	e59f1630 	ldr	r1, [pc, #1584]	; 0xffff5f48 = 0x01c68000
ffff5914:	e5810004 	str	r0, [r1, #4]
ffff5918:	ebffffcf 	bl	0xffff585c
ffff591c:	e3a00000 	mov	r0, #0
ffff5920:	e59f1614 	ldr	r1, [pc, #1556]	; 0xffff5f3c =0x01c20000 SCU_BASE
ffff5924:	e58100a0 	str	r0, [r1, #160]	; 0xa0
ffff5928:	e1c10000 	bic	r0, r1, r0
ffff592c:	e59002c0 	ldr	r0, [r0, #704]	; 0x2c0
ffff5930:	e3c00601 	bic	r0, r0, #1048576	; 0x100000
ffff5934:	e58102c0 	str	r0, [r1, #704]	; 0x2c0
ffff5938:	e1a00001 	mov	r0, r1
ffff593c:	e5900060 	ldr	r0, [r0, #96]	; 0x60
ffff5940:	e3c00601 	bic	r0, r0, #1048576	; 0x100000
ffff5944:	e5810060 	str	r0, [r1, #96]	; 0x60
ffff5948:	e1a00001 	mov	r0, r1
ffff594c:	e5900060 	ldr	r0, [r0, #96]	; 0x60
ffff5950:	e3c00040 	bic	r0, r0, #64	; 0x40
ffff5954:	e5810060 	str	r0, [r1, #96]	; 0x60
ffff5958:	e1a00001 	mov	r0, r1
ffff595c:	e59002c0 	ldr	r0, [r0, #704]	; 0x2c0
ffff5960:	e3c00040 	bic	r0, r0, #64	; 0x40
ffff5964:	e58102c0 	str	r0, [r1, #704]	; 0x2c0
ffff5968:	e8bd8010 	pop	{r4, pc}

;;;********************************************************************************
ffff596c:	e1a01000 	mov	r1, r0
ffff5970:	e320f000 	nop	{0}

ffff5974:	e59f05d0 	ldr	r0, [pc, #1488]	; 0xffff5f4c =0x01c02000 DMA_BASE
ffff5978:	e5900030 	ldr	r0, [r0, #48]	; 0x30
ffff597c:	e3100001 	tst	r0, #1
ffff5980:	1a000001 	bne	0xffff598c

ffff5984:	e3a00000 	mov	r0, #0

ffff5988:	e12fff1e 	bx	lr

ffff598c:	e2410001 	sub	r0, r1, #1
ffff5990:	e1b01000 	movs	r1, r0
ffff5994:	1afffff6 	bne	0xffff5974

ffff5998:	e3a00002 	mov	r0, #2
ffff599c:	eafffff9 	b	0xffff5988

;;;********************************************************************************
ffff59a0:	e1a01000 	mov	r1, r0
ffff59a4:	e320f000 	nop	{0}

ffff59a8:	e59f0598 	ldr	r0, [pc, #1432]	; 0xffff5f48 =0x01c68000
ffff59ac:	e5900014 	ldr	r0, [r0, #20]
ffff59b0:	e3100a01 	tst	r0, #4096	; 0x1000
ffff59b4:	0a000001 	beq	0xffff59c0

ffff59b8:	e3a00000 	mov	r0, #0

ffff59bc:	e12fff1e 	bx	lr

ffff59c0:	e2410001 	sub	r0, r1, #1
ffff59c4:	e1b01000 	movs	r1, r0
ffff59c8:	1afffff6 	bne	0xffff59a8

ffff59cc:	e3a00002 	mov	r0, #2
ffff59d0:	eafffff9 	b	0xffff59bc

;;;********************************************************************************
ffff59d4:	e3a00000 	mov	r0, #0
ffff59d8:	e59f156c 	ldr	r1, [pc, #1388]	; 0xffff5f4c =0x01c02000 DMA_BASE
ffff59dc:	e5810100 	str	r0, [r1, #256]	; 0x100
ffff59e0:	e2400b02 	sub	r0, r0, #2048	; 0x800
ffff59e4:	e5810108 	str	r0, [r1, #264]	; 0x108
ffff59e8:	e3a0000f 	mov	r0, #15
ffff59ec:	e5810010 	str	r0, [r1, #16]
ffff59f0:	e3a00000 	mov	r0, #0
ffff59f4:	e12fff1e 	bx	lr

;;;********************************************************************************
ffff59f8:	e92d4070 	push	{r4, r5, r6, lr}
ffff59fc:	e1a04000 	mov	r4, r0
ffff5a00:	e1a05001 	mov	r5, r1
ffff5a04:	e59dc010 	ldr	ip, [sp, #16]
ffff5a08:	e30e1000 	movw	r1, #57344	; 0xe000
ffff5a0c:	e5814000 	str	r4, [r1]
ffff5a10:	e5812004 	str	r2, [r1, #4]
ffff5a14:	e5813008 	str	r3, [r1, #8]
ffff5a18:	e581c00c 	str	ip, [r1, #12]
ffff5a1c:	e5815010 	str	r5, [r1, #16]
ffff5a20:	e2410b3a 	sub	r0, r1, #59392	; 0xe800
ffff5a24:	e5810014 	str	r0, [r1, #20]
ffff5a28:	e3a00000 	mov	r0, #0
ffff5a2c:	e59f6518 	ldr	r6, [pc, #1304]	; 0xffff5f4c =0x01c02000 DMA_BASE
ffff5a30:	e5860100 	str	r0, [r6, #256]	; 0x100
ffff5a34:	e3a0000f 	mov	r0, #15
ffff5a38:	e5860010 	str	r0, [r6, #16]
ffff5a3c:	e1c60000 	bic	r0, r6, r0
ffff5a40:	e5801108 	str	r1, [r0, #264]	; 0x108
ffff5a44:	e3a00001 	mov	r0, #1
ffff5a48:	e5860100 	str	r0, [r6, #256]	; 0x100
ffff5a4c:	e3a00000 	mov	r0, #0
ffff5a50:	e8bd8070 	pop	{r4, r5, r6, pc}

;;;********************************************************************************
ffff5a54:	e92d4ffe 	push	{r1, r2, r3, r4, r5, r6, r7, r8, r9, sl, fp, lr}
ffff5a58:	e1a04000 	mov	r4, r0
ffff5a5c:	e1a05001 	mov	r5, r1
ffff5a60:	e1a07002 	mov	r7, r2
ffff5a64:	e1a09003 	mov	r9, r3
ffff5a68:	e301bf07 	movw	fp, #7943	; 0x1f07
ffff5a6c:	e3a00037 	mov	r0, #55	; 0x37
ffff5a70:	e58d0008 	str	r0, [sp, #8]
ffff5a74:	e59f04d4 	ldr	r0, [pc, #1236]	; 0xffff5f50 =0x01c68300 SPI_RXD
ffff5a78:	e58d0004 	str	r0, [sp, #4]
ffff5a7c:	e2408c01 	sub	r8, r0, #256	; 0x100
ffff5a80:	e0840005 	add	r0, r4, r5
ffff5a84:	e280ae96 	add	sl, r0, #2400	; 0x960
ffff5a88:	e2480c02 	sub	r0, r8, #512	; 0x200
ffff5a8c:	e5804034 	str	r4, [r0, #52]	; 0x34
ffff5a90:	e0840005 	add	r0, r4, r5
ffff5a94:	e2481c02 	sub	r1, r8, #512	; 0x200
ffff5a98:	e5810030 	str	r0, [r1, #48]	; 0x30
ffff5a9c:	e1a00001 	mov	r0, r1
ffff5aa0:	e5804038 	str	r4, [r0, #56]	; 0x38
ffff5aa4:	e5900018 	ldr	r0, [r0, #24]
ffff5aa8:	e3800c01 	orr	r0, r0, #256	; 0x100
ffff5aac:	e5810018 	str	r0, [r1, #24]
ffff5ab0:	e1a03009 	mov	r3, r9
ffff5ab4:	e58d5000 	str	r5, [sp]
ffff5ab8:	e1a0100b 	mov	r1, fp
ffff5abc:	e59d0008 	ldr	r0, [sp, #8]
ffff5ac0:	e59d2004 	ldr	r2, [sp, #4]
ffff5ac4:	ebffffcb 	bl	0xffff59f8
ffff5ac8:	e3a06000 	mov	r6, #0
ffff5acc:	ea000002 	b	0xffff5adc

ffff5ad0:	e7d70006 	ldrb	r0, [r7, r6]
ffff5ad4:	e5c80000 	strb	r0, [r8]
ffff5ad8:	e2866001 	add	r6, r6, #1

ffff5adc:	e1560004 	cmp	r6, r4
ffff5ae0:	3afffffa 	bcc	0xffff5ad0

ffff5ae4:	e59f045c 	ldr	r0, [pc, #1116]	; 0xffff5f48 =0x01c68000
ffff5ae8:	e5900008 	ldr	r0, [r0, #8]
ffff5aec:	e3800102 	orr	r0, r0, #-2147483648	; 0x80000000
ffff5af0:	e59f1450 	ldr	r1, [pc, #1104]	; 0xffff5f48 =0x01c68000
ffff5af4:	e5810008 	str	r0, [r1, #8]
ffff5af8:	e1a0000a 	mov	r0, sl
ffff5afc:	ebffff9a 	bl	0xffff596c
ffff5b00:	e3500002 	cmp	r0, #2
ffff5b04:	1a000002 	bne	0xffff5b14

ffff5b08:	ebffffb1 	bl	0xffff59d4
ffff5b0c:	e3a00002 	mov	r0, #2

ffff5b10:	e8bd8ffe 	pop	{r1, r2, r3, r4, r5, r6, r7, r8, r9, sl, fp, pc}

ffff5b14:	e1a0000a 	mov	r0, sl
ffff5b18:	ebffffa0 	bl	0xffff59a0
ffff5b1c:	e3500002 	cmp	r0, #2
ffff5b20:	1a000002 	bne	0xffff5b30

ffff5b24:	ebffffaa 	bl	0xffff59d4
ffff5b28:	e3a00002 	mov	r0, #2
ffff5b2c:	eafffff7 	b	0xffff5b10

ffff5b30:	ebffffa7 	bl	0xffff59d4
ffff5b34:	e3010000 	movw	r0, #4096	; 0x1000
ffff5b38:	e59f1408 	ldr	r1, [pc, #1032]	; 0xffff5f48 =0x01c68000
ffff5b3c:	e5810014 	str	r0, [r1, #20]
ffff5b40:	e1c10000 	bic	r0, r1, r0
ffff5b44:	e5900014 	ldr	r0, [r0, #20]
ffff5b48:	e3100c0f 	tst	r0, #3840	; 0xf00
ffff5b4c:	0a000001 	beq	0xffff5b58

ffff5b50:	e3a00002 	mov	r0, #2
ffff5b54:	eaffffed 	b	0xffff5be8

ffff5b84:	e3a00003 	mov	r0, #3
ffff5b88:	e5cd0000 	strb	r0, [sp]
ffff5b8c:	e1a00825 	lsr	r0, r5, #16
ffff5b90:	e5cd0001 	strb	r0, [sp, #1]
ffff5b94:	e1a00425 	lsr	r0, r5, #8
ffff5b98:	e5cd0002 	strb	r0, [sp, #2]
ffff5b9c:	e5cd5003 	strb	r5, [sp, #3]
ffff5ba0:	e0470004 	sub	r0, r7, r4
ffff5ba4:	e3500b02 	cmp	r0, #2048	; 0x800
ffff5ba8:	9a000001 	bls	0xffff5bb4

ffff5bac:	e3000800 	movw	r0, #2048	; 0x800
ffff5bb0:	ea000000 	b	0xffff5bb8

ffff5bb4:	e0470004 	sub	r0, r7, r4

ffff5bb8:	e1a06000 	mov	r6, r0
ffff5bbc:	e08b3004 	add	r3, fp, r4
ffff5bc0:	e1a0200d 	mov	r2, sp
ffff5bc4:	e1a01006 	mov	r1, r6
ffff5bc8:	e3a00004 	mov	r0, #4
ffff5bcc:	ebffffa0 	bl	0xffff5a54
ffff5bd0:	e3500002 	cmp	r0, #2
ffff5bd4:	1a000001 	bne	0xffff5be0

ffff5bd8:	e3a00002 	mov	r0, #2

ffff5bdc:	e8bd8ff8 	pop	{r3, r4, r5, r6, r7, r8, r9, sl, fp, pc}

ffff5be0:	e0855006 	add	r5, r5, r6
ffff5be4:	e0844006 	add	r4, r4, r6

ffff5be8:	e1540007 	cmp	r4, r7
ffff5bec:	3affffe4 	bcc	0xffff5b84

ffff5bf0:	e3a00000 	mov	r0, #0
ffff5bf4:	eafffff8 	b	0xffff5bdc

;;;********************************************************************************
ffff5bf8:	e92d47fc 	push	{r2, r3, r4, r5, r6, r7, r8, r9, sl, lr}
ffff5bfc:	e1a05000 	mov	r5, r0
ffff5c00:	e1a07001 	mov	r7, r1
ffff5c04:	e1a08002 	mov	r8, r2
ffff5c08:	e1a0a007 	mov	sl, r7
ffff5c0c:	e3a00000 	mov	r0, #0
ffff5c10:	e58d0004 	str	r0, [sp, #4]
ffff5c14:	e3a06000 	mov	r6, #0
ffff5c18:	e3a09000 	mov	r9, #0
ffff5c1c:	e1a04485 	lsl	r4, r5, #9
ffff5c20:	ea000012 	b	0xffff5c70

ffff5c24:	e3a000e8 	mov	r0, #232	; 0xe8
ffff5c28:	e5cd0000 	strb	r0, [sp]
ffff5c2c:	e1a00824 	lsr	r0, r4, #16
ffff5c30:	e5cd0001 	strb	r0, [sp, #1]
ffff5c34:	e1a00424 	lsr	r0, r4, #8
ffff5c38:	e5cd0002 	strb	r0, [sp, #2]
ffff5c3c:	e5cd4003 	strb	r4, [sp, #3]
ffff5c40:	e08a3009 	add	r3, sl, r9
ffff5c44:	e1a0200d 	mov	r2, sp
ffff5c48:	e3001100 	movw	r1, #256	; 0x100
ffff5c4c:	e3a00008 	mov	r0, #8
ffff5c50:	ebffff7f 	bl	0xffff5a54
ffff5c54:	e3500002 	cmp	r0, #2
ffff5c58:	1a000001 	bne	0xffff5c64

ffff5c5c:	e3a00002 	mov	r0, #2

ffff5c60:	e8bd87fc 	pop	{r2, r3, r4, r5, r6, r7, r8, r9, sl, pc}

ffff5c64:	e2866001 	add	r6, r6, #1
ffff5c68:	e2899c01 	add	r9, r9, #256	; 0x100
ffff5c6c:	e2844c02 	add	r4, r4, #512	; 0x200

ffff5c70:	e1560008 	cmp	r6, r8
ffff5c74:	3affffea 	bcc	0xffff5c24

ffff5c78:	e3a00000 	mov	r0, #0
ffff5c7c:	eafffff7 	b	0xffff5c60

;;;********************************************************************************
ffff5c80:	e92d400c 	push	{r2, r3, lr}
ffff5c84:	e1a01000 	mov	r1, r0
ffff5c88:	e59f22c4 	ldr	r2, [pc, #708]	; 0xffff5f54 =0xffff622c
ffff5c8c:	e8920005 	ldm	r2, {r0, r2}
ffff5c90:	e88d0005 	stm	sp, {r0, r2}
ffff5c94:	e79d0101 	ldr	r0, [sp, r1, lsl #2]
ffff5c98:	e8bd800c 	pop	{r2, r3, pc}

;;;********************************************************************************
ffff5c9c:	e92d41f0 	push	{r4, r5, r6, r7, r8, lr}
ffff5ca0:	e1a04000 	mov	r4, r0
ffff5ca4:	e1a06001 	mov	r6, r1
ffff5ca8:	e59f72a8 	ldr	r7, [pc, #680]	; 0xffff5f58 =0x01c68200 SPI_TXD
ffff5cac:	e2470c02 	sub	r0, r7, #512	; 0x200
ffff5cb0:	e5804034 	str	r4, [r0, #52]	; 0x34
ffff5cb4:	e5804030 	str	r4, [r0, #48]	; 0x30
ffff5cb8:	e5804038 	str	r4, [r0, #56]	; 0x38
ffff5cbc:	e2848e96 	add	r8, r4, #2400	; 0x960
ffff5cc0:	e3a05000 	mov	r5, #0
ffff5cc4:	ea000002 	b	0xffff5cd4

ffff5cc8:	e7d60005 	ldrb	r0, [r6, r5]
ffff5ccc:	e5c70000 	strb	r0, [r7]
ffff5cd0:	e2855001 	add	r5, r5, #1

ffff5cd4:	e1550004 	cmp	r5, r4
ffff5cd8:	3afffffa 	bcc	0xffff5cc8

ffff5cdc:	e59f0264 	ldr	r0, [pc, #612]	; 0xffff5f48 =0x01c68000
ffff5ce0:	e5900008 	ldr	r0, [r0, #8]
ffff5ce4:	e3800102 	orr	r0, r0, #-2147483648	; 0x80000000
ffff5ce8:	e59f1258 	ldr	r1, [pc, #600]	; 0xffff5f48 =0x01c68000
ffff5cec:	e5810008 	str	r0, [r1, #8]
ffff5cf0:	e1a00008 	mov	r0, r8
ffff5cf4:	ebffff29 	bl	0xffff59a0
ffff5cf8:	e3500002 	cmp	r0, #2
ffff5cfc:	1a000001 	bne	0xffff5d08

ffff5d00:	e3a00002 	mov	r0, #2

ffff5d04:	e8bd81f0 	pop	{r4, r5, r6, r7, r8, pc}

ffff5d08:	e3010000 	movw	r0, #4096	; 0x1000
ffff5d0c:	e59f1234 	ldr	r1, [pc, #564]	; 0xffff5f48 =0x01c68000
ffff5d10:	e5810014 	str	r0, [r1, #20]
ffff5d14:	e1c10000 	bic	r0, r1, r0
ffff5d18:	e5900014 	ldr	r0, [r0, #20]
ffff5d1c:	e3100c0f 	tst	r0, #3840	; 0xf00
ffff5d20:	0a000001 	beq	0xffff5d2c

ffff5d24:	e3a00002 	mov	r0, #2
ffff5d28:	eafffff5 	b	0xffff5d04

ffff5d2c:	e3a00000 	mov	r0, #0
ffff5d30:	eafffff3 	b	0xffff5d04

;;;********************************************************************************
ffff5d34:	e92d4038 	push	{r3, r4, r5, lr}
ffff5d38:	e3a000ff 	mov	r0, #255	; 0xff
ffff5d3c:	e58d0000 	str	r0, [sp]
ffff5d40:	e3a040f0 	mov	r4, #240	; 0xf0
ffff5d44:	e1a0100d 	mov	r1, sp
ffff5d48:	e3a00001 	mov	r0, #1
ffff5d4c:	ebffffd2 	bl	0xffff5c9c
ffff5d50:	e3500002 	cmp	r0, #2
ffff5d54:	1a000001 	bne	0xffff5d60

ffff5d58:	e3a00002 	mov	r0, #2

ffff5d5c:	e8bd8038 	pop	{r3, r4, r5, pc}

ffff5d60:	e320f000 	nop	{0}

ffff5d64:	e2440001 	sub	r0, r4, #1
ffff5d68:	e1b04000 	movs	r4, r0
ffff5d6c:	1afffffc 	bne	0xffff5d64

ffff5d70:	e3a00000 	mov	r0, #0
ffff5d74:	eafffff8 	b	0xffff5d5c

;;;********************************************************************************
ffff5d78:	e92d4ff0 	push	{r4, r5, r6, r7, r8, r9, sl, fp, lr}
ffff5d7c:	e24dd024 	sub	sp, sp, #36	; 0x24
ffff5d80:	e1a05000 	mov	r5, r0
ffff5d84:	e1a07001 	mov	r7, r1
ffff5d88:	e1a08002 	mov	r8, r2
ffff5d8c:	e1a06003 	mov	r6, r3
ffff5d90:	e28db048 	add	fp, sp, #72	; 0x48
ffff5d94:	e89b0e00 	ldm	fp, {r9, sl, fp}
ffff5d98:	e3a00000 	mov	r0, #0
ffff5d9c:	e58d0010 	str	r0, [sp, #16]
ffff5da0:	e58d700c 	str	r7, [sp, #12]
ffff5da4:	e58d0008 	str	r0, [sp, #8]
ffff5da8:	e3a00032 	mov	r0, #50	; 0x32
ffff5dac:	e58d0004 	str	r0, [sp, #4]
ffff5db0:	e1a04005 	mov	r4, r5
ffff5db4:	ea000056 	b	0xffff5f14

ffff5db8:	e3a00013 	mov	r0, #19
ffff5dbc:	e5cd001c 	strb	r0, [sp, #28]
ffff5dc0:	e1a00824 	lsr	r0, r4, #16
ffff5dc4:	e5cd001d 	strb	r0, [sp, #29]
ffff5dc8:	e1a00424 	lsr	r0, r4, #8
ffff5dcc:	e5cd001e 	strb	r0, [sp, #30]
ffff5dd0:	e5cd401f 	strb	r4, [sp, #31]
ffff5dd4:	e28d101c 	add	r1, sp, #28
ffff5dd8:	e3a00004 	mov	r0, #4
ffff5ddc:	ebffffae 	bl	0xffff5c9c
ffff5de0:	e3500002 	cmp	r0, #2
ffff5de4:	1a000002 	bne	0xffff5df4

ffff5de8:	e3a00002 	mov	r0, #2
ffff5dec:	e58d0010 	str	r0, [sp, #16]
ffff5df0:	ea00004b 	b	0xffff5f24

ffff5df4:	e3a0000f 	mov	r0, #15
ffff5df8:	e5cd0018 	strb	r0, [sp, #24]
ffff5dfc:	e3a000c0 	mov	r0, #192	; 0xc0
ffff5e00:	e5cd0019 	strb	r0, [sp, #25]
ffff5e04:	e3a00032 	mov	r0, #50	; 0x32
ffff5e08:	e58d0004 	str	r0, [sp, #4]
ffff5e0c:	e320f000 	nop	{0}

ffff5e10:	e28d3008 	add	r3, sp, #8
ffff5e14:	e28d2018 	add	r2, sp, #24
ffff5e18:	e3a01001 	mov	r1, #1
ffff5e1c:	e3a00002 	mov	r0, #2
ffff5e20:	ebffff0b 	bl	0xffff5a54
ffff5e24:	e3500002 	cmp	r0, #2
ffff5e28:	1a000002 	bne	0xffff5e38

ffff5e2c:	e3a00002 	mov	r0, #2
ffff5e30:	e58d0010 	str	r0, [sp, #16]
ffff5e34:	ea00003a 	b	0xffff5f24

ffff5e38:	e5dd0008 	ldrb	r0, [sp, #8]
ffff5e3c:	e2000001 	and	r0, r0, #1
ffff5e40:	e58d0008 	str	r0, [sp, #8]
ffff5e44:	e5dd0008 	ldrb	r0, [sp, #8]
ffff5e48:	e3500000 	cmp	r0, #0
ffff5e4c:	1a000000 	bne	0xffff5e54

ffff5e50:	ea000003 	b	0xffff5e64

ffff5e54:	e59d0004 	ldr	r0, [sp, #4]
ffff5e58:	e2500001 	subs	r0, r0, #1
ffff5e5c:	e58d0004 	str	r0, [sp, #4]
ffff5e60:	1affffea 	bne	0xffff5e10

ffff5e64:	e320f000 	nop	{0}
ffff5e68:	e3a0000b 	mov	r0, #11
ffff5e6c:	e5cd001c 	strb	r0, [sp, #28]
ffff5e70:	e3560b02 	cmp	r6, #2048	; 0x800
ffff5e74:	1a000010 	bne	0xffff5ebc

ffff5e78:	e35a0001 	cmp	sl, #1
ffff5e7c:	1a000006 	bne	0xffff5e9c

ffff5e80:	e730fb14 	udiv	r0, r4, fp
ffff5e84:	e2000001 	and	r0, r0, #1
ffff5e88:	e3500001 	cmp	r0, #1
ffff5e8c:	1a000002 	bne	0xffff5e9c

ffff5e90:	e3a00010 	mov	r0, #16
ffff5e94:	e5cd001d 	strb	r0, [sp, #29]
ffff5e98:	ea000001 	b	0xffff5ea4

ffff5e9c:	e3a00000 	mov	r0, #0
ffff5ea0:	e5cd001d 	strb	r0, [sp, #29]

ffff5ea4:	e3a00000 	mov	r0, #0
ffff5ea8:	e5cd001e 	strb	r0, [sp, #30]
ffff5eac:	e5cd001f 	strb	r0, [sp, #31]
ffff5eb0:	e3a00004 	mov	r0, #4
ffff5eb4:	e58d0014 	str	r0, [sp, #20]
ffff5eb8:	ea000008 	b	0xffff5ee0

ffff5ebc:	e3560a01 	cmp	r6, #4096	; 0x1000
ffff5ec0:	1a000006 	bne	0xffff5ee0
ffff5ec4:	e3a00000 	mov	r0, #0
ffff5ec8:	e5cd001d 	strb	r0, [sp, #29]
ffff5ecc:	e5cd001e 	strb	r0, [sp, #30]
ffff5ed0:	e5cd001f 	strb	r0, [sp, #31]
ffff5ed4:	e5cd0020 	strb	r0, [sp, #32]
ffff5ed8:	e3a00005 	mov	r0, #5
ffff5edc:	e58d0014 	str	r0, [sp, #20]

ffff5ee0:	e0441005 	sub	r1, r4, r5
ffff5ee4:	e59d000c 	ldr	r0, [sp, #12]
ffff5ee8:	e0230199 	mla	r3, r9, r1, r0
ffff5eec:	e28d201c 	add	r2, sp, #28
ffff5ef0:	e1a01009 	mov	r1, r9
ffff5ef4:	e59d0014 	ldr	r0, [sp, #20]
ffff5ef8:	ebfffed5 	bl	0xffff5a54
ffff5efc:	e3500002 	cmp	r0, #2
ffff5f00:	1a000002 	bne	0xffff5f10

ffff5f04:	e3a00002 	mov	r0, #2
ffff5f08:	e58d0010 	str	r0, [sp, #16]
ffff5f0c:	ea000004 	b	0xffff5f24

ffff5f10:	e2844001 	add	r4, r4, #1

ffff5f14:	e0850008 	add	r0, r5, r8
ffff5f18:	e1500004 	cmp	r0, r4
ffff5f1c:	8affffa5 	bhi	0xffff5db8

ffff5f20:	e320f000 	nop	{0}

ffff5f24:	e59d0010 	ldr	r0, [sp, #16]
ffff5f28:	e28dd024 	add	sp, sp, #36	; 0x24
ffff5f2c:	e8bd8ff0 	pop	{r4, r5, r6, r7, r8, r9, sl, fp, pc}

;;;********************************************************************************

	;; Global Offset Table
ffff5f30:	77773333
ffff5f34:	01c20848					; PC_CFG0
ffff5f38:	77777777
ffff5f3c:	01c20000					; SCU_BASE
ffff5f40:	80000083
ffff5f44:	80208020
ffff5f48:	01c68000					; SPI0_BASE
ffff5f4c:	01c02000					; DMA_BASE
ffff5f50:	01c68300					; SPI_RXD
ffff5f54:	ffff622c
ffff5f58:	01c68200					; SPI_TXD
;;;*****************************************************************************

load_boot0_from_spinor:
ffff5f5c:	e92d41f0 	push	{r4, r5, r6, r7, r8, lr}
ffff5f60:	ebfffe44 	bl	0xffff5878
ffff5f64:	e3a07000 	mov	r7, #0
ffff5f68:	ea000029 	b	0xffff6014

ffff5f6c:	e1a00007 	mov	r0, r7
ffff5f70:	ebffff42 	bl	0xffff5c80
ffff5f74:	e1a05000 	mov	r5, r0
ffff5f78:	e3a02001 	mov	r2, #1
ffff5f7c:	e3a01000 	mov	r1, #0
ffff5f80:	e1a00001 	mov	r0, r1
ffff5f84:	e12fff35 	blx	r5
ffff5f88:	e3500002 	cmp	r0, #2
ffff5f8c:	1a000000 	bne	0xffff5f94

ffff5f90:	ea00001e 	b	0xffff6010

ffff5f94:	e28f108c 	add	r1, pc, #140	; 0x8c =0xffff5028 "eGON.BT0"
ffff5f98:	e3a00000 	mov	r0, #0
ffff5f9c:	eb000024 	bl	check_magic
ffff5fa0:	e3500000 	cmp	r0, #0
ffff5fa4:	0a000000 	beq	0xffff5fac

ffff5fa8:	ea000018 	b	0xffff6010

ffff5fac:	e3a06000 	mov	r6, #0
ffff5fb0:	e5964010 	ldr	r4, [r6, #16]
ffff5fb4:	e1a00004 	mov	r0, r4
ffff5fb8:	e7df049f 	bfc	r0, #9, #23
ffff5fbc:	e3500000 	cmp	r0, #0
ffff5fc0:	0a000000 	beq	0xffff5fc8

ffff5fc4:	ea000011 	b	0xffff6010

ffff5fc8:	e1a02424 	lsr	r2, r4, #8
ffff5fcc:	e3a01000 	mov	r1, #0
ffff5fd0:	e1a00001 	mov	r0, r1
ffff5fd4:	e12fff35 	blx	r5
ffff5fd8:	e3500002 	cmp	r0, #2
ffff5fdc:	1a000000 	bne	0xffff5fe4

ffff5fe0:	ea00000a 	b	0xffff6010

ffff5fe4:	e1a01004 	mov	r1, r4
ffff5fe8:	e3a00000 	mov	r0, #0
ffff5fec:	eb000022 	bl	check_sum
ffff5ff0:	e3500000 	cmp	r0, #0
ffff5ff4:	1a000004 	bne	0xffff600c

ffff5ff8:	e3a00003 	mov	r0, #3
ffff5ffc:	e5c60028 	strb	r0, [r6, #40]	; 0x28
ffff6000:	ebfffe40 	bl	0xffff5908
ffff6004:	e3a00000 	mov	r0, #0

ffff6008:	e8bd81f0 	pop	{r4, r5, r6, r7, r8, pc}

ffff600c:	e320f000 	nop	{0}

ffff6010:	e2877001 	add	r7, r7, #1

ffff6014:	e3570002 	cmp	r7, #2
ffff6018:	3affffd3 	bcc	0xffff5f6c

ffff601c:	ebfffe39 	bl	0xffff5908
ffff6020:	e3e00000 	mvn	r0, #0
ffff6024:	eafffff7 	b	0xffff6008
;;;*****************************************************************************

ffff6028:	4e4f4765	.ascii	"eGON"
ffff602c:	3054422e	.ascii	".BT0"
ffff6030:	00000000

;;;*****************************************************************************
check_magic:
ffff6034:	e92d40f0 	push	{r4, r5, r6, r7, lr}
ffff6038:	e1a02000 	mov	r2, r0
ffff603c:	e1a0c002 	mov	ip, r2
ffff6040:	e28c4004 	add	r4, ip, #4
ffff6044:	e3a03000 	mov	r3, #0 		; counter
ffff6048:	e3a05008 	mov	r5, #8		; length
ffff604c:	ea000006 	b	0xffff606c	; while

ffff6050:	e4d40001 	ldrb	r0, [r4], #1 	; load byte from src
ffff6054:	e4d16001 	ldrb	r6, [r1], #1	; load byte from reference
ffff6058:	e1500006 	cmp	r0, r6
ffff605c:	0a000001 	beq	0xffff6068 	; check if bytes are equal

ffff6060:	e3a00001 	mov	r0, #1 		; no match

ffff6064:	e8bd80f0 	pop	{r4, r5, r6, r7, pc}

ffff6068:	e2833001 	add	r3, r3, #1 	; increment counter

ffff606c:	e1530005 	cmp	r3, r5
ffff6070:	3afffff6 	bcc	0xffff6050 	; end of magic?

ffff6074:	e3a00000 	mov	r0, #0 		; yes, this is a match!
ffff6078:	eafffff9 	b	0xffff6064

;;;*****************************************************************************
check_sum:
ffff607c:	e92d40f0 	push	{r4, r5, r6, r7, lr}
ffff6080:	e1a03000 	mov	r3, r0
ffff6084:	e1a05001 	mov	r5, r1
ffff6088:	e1a04003 	mov	r4, r3
ffff608c:	e594600c 	ldr	r6, [r4, #12]
ffff6090:	e59f00bc 	ldr	r0, [pc, #188]	; 0xffff6154 =0x5f0a6c39
ffff6094:	e584000c 	str	r0, [r4, #12]
ffff6098:	e1a07125 	lsr	r7, r5, #2
ffff609c:	e3a02000 	mov	r2, #0
ffff60a0:	e1a01003 	mov	r1, r3
ffff60a4:	e320f000 	nop	{0}

ffff60a8:	e4910004 	ldr	r0, [r1], #4
ffff60ac:	e0822000 	add	r2, r2, r0
ffff60b0:	e4910004 	ldr	r0, [r1], #4
ffff60b4:	e0822000 	add	r2, r2, r0
ffff60b8:	e4910004 	ldr	r0, [r1], #4
ffff60bc:	e0822000 	add	r2, r2, r0
ffff60c0:	e4910004 	ldr	r0, [r1], #4
ffff60c4:	e0822000 	add	r2, r2, r0
ffff60c8:	e2470004 	sub	r0, r7, #4
ffff60cc:	e1a07000 	mov	r7, r0
ffff60d0:	e3500003 	cmp	r0, #3
ffff60d4:	8afffff3 	bhi	0xffff60a8

ffff60d8:	ea000001 	b	0xffff60e4

ffff60dc:	e4910004 	ldr	r0, [r1], #4
ffff60e0:	e0822000 	add	r2, r2, r0

ffff60e4:	e1b00007 	movs	r0, r7
ffff60e8:	e2477001 	sub	r7, r7, #1
ffff60ec:	1afffffa 	bne	0xffff60dc

ffff60f0:	e584600c 	str	r6, [r4, #12]
ffff60f4:	e1520006 	cmp	r2, r6
ffff60f8:	1a000001 	bne	0xffff6104

ffff60fc:	e3a00000 	mov	r0, #0
ffff6100:	e8bd80f0 	pop	{r4, r5, r6, r7, pc}

ffff6104:	e3a00001 	mov	r0, #1
ffff6108:	eafffffc 	b	0xffff6100

ffff610c:	e92d4070 	push	{r4, r5, r6, lr}
ffff6110:	e1a05000 	mov	r5, r0
ffff6114:	e1a06001 	mov	r6, r1
ffff6118:	e1a04002 	mov	r4, r2
ffff611c:	e1a01004 	mov	r1, r4
ffff6120:	e1a00005 	mov	r0, r5
ffff6124:	ebffffc2 	bl	check_magic
ffff6128:	e3500000 	cmp	r0, #0
ffff612c:	1a000006 	bne	0xffff614c

ffff6130:	e1a01006 	mov	r1, r6
ffff6134:	e1a00005 	mov	r0, r5
ffff6138:	ebffffcf 	bl	check_sum
ffff613c:	e3500000 	cmp	r0, #0
ffff6140:	1a000001 	bne	0xffff614c

ffff6144:	e3a00000 	mov	r0, #0
ffff6148:	e8bd8070 	pop	{r4, r5, r6, pc}

ffff614c:	e3a00001 	mov	r0, #1
ffff6150:	eafffffc 	b	0xffff6148

	;; Global Offset Table
ffff6154:	5f0a6c39

ffff6158:	e1a01000 	mov	r1, r0
ffff615c:	e1a00001 	mov	r0, r1
ffff6160:	ea000000 	b	0xffff6168
ffff6164:	e2400001 	sub	r0, r0, #1
ffff6168:	e3500000 	cmp	r0, #0
ffff616c:	cafffffc 	bgt	0xffff6164
ffff6170:	e12fff1e 	bx	lr
;;; ;*****************************************************************************
check_uboot:
ffff6174:	e92d4070 	push	{r4, r5, r6, lr}
ffff6178:	e3a05000 	mov	r5, #0
ffff617c:	e3a0603c 	mov	r6, #60	; 0x3c
ffff6180:	e3a04004 	mov	r4, #4
ffff6184:	ea000006 	b	0xffff61a4

ffff6188:	e1a00006 	mov	r0, r6
ffff618c:	ebfffff1 	bl	0xffff6158
ffff6190:	e3a00507 	mov	r0, #29360128	; 0x1c00000
ffff6194:	e5900024 	ldr	r0, [r0, #36]	; 0x24 VER_REG
ffff6198:	e7e00450 	ubfx	r0, r0, #8, #1 	; UBOOT_SEL_PAD_STA
ffff619c:	e0855000 	add	r5, r5, r0
ffff61a0:	e2444001 	sub	r4, r4, #1

ffff61a4:	e3540000 	cmp	r4, #0
ffff61a8:	cafffff6 	bgt	0xffff6188
ffff61ac:	e3550000 	cmp	r5, #0
ffff61b0:	1a000001 	bne	0xffff61bc

ffff61b4:	e3e00000 	mvn	r0, #0
ffff61b8:	e8bd8070 	pop	{r4, r5, r6, pc}

ffff61bc:	e3a00000 	mov	r0, #0
ffff61c0:	eafffffc 	b	0xffff61b8

ffff61c4:	00004770 	andeq	r4, r0, r0, ror r7
;;;*****************************************************************************

jump_to:
ffff61c8:	e1a0f000 	mov	pc, r0
;;;*****************************************************************************

ffff61cc:	00000800
ffff61d0:	00000400
ffff61d4:	00000000
ffff61d8:	00000040
ffff61dc:	00001000
ffff61e0:	00000400
ffff61e4:	00000000
ffff61e8:	00000040
ffff61ec:	00000800
ffff61f0:	00000400
ffff61f4:	00000000
ffff61f8:	00000040
ffff61fc:	00001000
ffff6200:	00000400
ffff6204:	00000000
ffff6208:	00000040
ffff620c:	00000800
ffff6210:	00000400
ffff6214:	00000001
ffff6218:	00000040
ffff621c:	00000800
ffff6220:	00000400
ffff6224:	00000001
ffff6228:	00000080

ffff622c:	ffff5b60
ffff6230:	ffff5bf8
	...
