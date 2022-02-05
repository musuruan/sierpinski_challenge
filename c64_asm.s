; Sierpinski challenge

; geoProgrammer Macros
; https://github.com/mist64/geos/blob/master/inc/geosmac.inc
drv1541=1
.include "geosmac.inc"
.include "c64.inc"

; Commodore Load Address
LOADADDR = $c000

.word LOADADDR
.org LOADADDR

; Variabili
cell = $A3
XC = FREKZP
YC = FREKZP+2
COUNT = FREKZP+3

MAXPOINTS = 10000

; Hires pointers
COLOR = $0400
SCREEN = $2000

Start:
	; Imposta il colore di sfondo a WHITE
	;LoadB VIC_BG_COLOR0, 1

	; Imposta la bitmap a $2000
	smbf 3, VIC_VIDEO_ADR
	
	; Abilita Hires
	smbf 5, VIC_CTRL1
	
	; Pulisce la grafica Hires
	lda #$00
	ldx #$00
@l1:
	sta SCREEN,x
	sta SCREEN+$0100,x
	sta SCREEN+$0200,x
	sta SCREEN+$0300,x
	sta SCREEN+$0400,x
	sta SCREEN+$0500,x
	sta SCREEN+$0600,x
	sta SCREEN+$0700,x
	sta SCREEN+$0800,x
	sta SCREEN+$0900,x
	sta SCREEN+$0A00,x
	sta SCREEN+$0B00,x
	sta SCREEN+$0C00,x
	sta SCREEN+$0D00,x
	sta SCREEN+$0E00,x
	sta SCREEN+$0F00,x
	sta SCREEN+$1000,x
	sta SCREEN+$1100,x
	sta SCREEN+$1200,x
	sta SCREEN+$1300,x
	sta SCREEN+$1400,x
	sta SCREEN+$1500,x
	sta SCREEN+$1600,x
	sta SCREEN+$1700,x
	sta SCREEN+$1800,x
	sta SCREEN+$1900,x
	sta SCREEN+$1A00,x
	sta SCREEN+$1B00,x
	sta SCREEN+$1C00,x
	sta SCREEN+$1D00,x
	sta SCREEN+$1E00,x
	sta SCREEN+$1E40,x
	inx
	bne @l1
	
	; Imposta i colori
	lda #$01
	ldx #$00
@l4:
	sta COLOR,x
	sta COLOR+200,x
	sta COLOR+400,x
	sta COLOR+600,x
	sta COLOR+800,x
	inx
	cpx #$c8
	bne @l4
	
	; Usa il SID per avere i numeri casuali
	; COMPUTE! #72 page 77
	; https://archive.org/details/1986-05-compute-magazine/page/n77/mode/2up
	
	LoadW SID_S3Lo, $FFFF
	LoadB SID_Ctl3, $80

	; Inzializzazione variabili
	LoadW XC, 160
	LoadB YC, 0
	LoadW COUNT, MAXPOINTS-1
	
next:	
	ldy $D41B		; Carica un numero casuale
	lda tbl_modulo3,y	; Calcola il modulo 3 del numero casuale
	
	cmp #$02	; A seconda del valore, calcola il nuovo vertice
	beq @2
	cmp #$01
	beq @1
@0:	AddVW 160,XC	; XC=(XC+160)/2, YC=YC/2
	lsr XC+1
	ror XC
	lsr YC
	bra @plot	; Usa bra invece di jmp per risparmare cicli di clock
@1:	lsr XC+1	; XC=XC/2, YC=(YC+199)/2
	ror XC
	AddVB 199,YC
	ror YC
	bra @plot
@2:	AddVW 319,XC	; XC=(XC+319)/2, YC=(YC+199)/2:
	lsr XC+1
	ror XC
	AddVB 199,YC
	ror YC
	
@plot:  jsr Plot

	lda COUNT
	bne @nz
	lda COUNT+1
	beq @endless	; salta quando COUNT=$0000 (COUNT non viene decrementato in questo caso)
	dec COUNT+1
@nz:
	dec COUNT
	bra next
	
@endless:
	jmp @endless
	
	; Stampa il punto XC, YC sulla grafica bitmap
	; Adattato da
	; https://github.com/johncel/c64asm/blob/master/plot.asm
Plot:	
	;-------------------------
	;calc Y-cell, divide by 8
	;y/8 is y-cell table index
	;-------------------------
	lda YC
	lsr		;/ 2
	lsr		;/ 4
	lsr		;/ 8
	tay		;tbl_8,y index

	;------------------------
	;calc X-cell, divide by 8
	;divide 2-byte pointX / 8
	;------------------------
	lda XC+1	;max(XC)=319=0x013F
	lsr		;rotate the high byte into carry flag
	lda XC
	ror		;lo byte / 2 (rotate C into low byte)
	lsr		;lo byte / 4
	lsr		;lo byte / 8
	tax		;tbl_8,x index

	;----------------------------------
	;add x & y to calc cell point is in
	;----------------------------------
	clc
	
	lda tbl_vbaseLo,y	;table of SCREEN row base addresses
	adc tbl_8Lo,x		;+ (8 * Xcell)
	sta cell		;= cell address

	lda tbl_vbaseHi,y	;do the high byte
	adc tbl_8Hi,x
	sta cell+1

	;---------------------------------
	;get in-cell offset to point (0-7)
	;---------------------------------
	lda XC		;get pointX offset from cell topleft
	and #%00000111	;3 lowest bits = (0-7)
	tax		;put into index register

	lda YC		;get pointY offset from cell topleft
	and #%00000111	;3 lowest bits = (0-7)
	tay		;put into index register

	;---------
	;set point
	;---------
	lda (cell),y	;get row with point in it
	ora tbl_orbit,x	;isolate and set the point
	sta (cell),y	;write back to SCREEN	
	
	rts

; Lookup table per fare il modulo 3 di un numero a 8 bit
tbl_modulo3:
	.byte 0,1,2,0,1,2,0,1,2,0,1,2,0,1,2,0
	.byte 1,2,0,1,2,0,1,2,0,1,2,0,1,2,0,1
	.byte 2,0,1,2,0,1,2,0,1,2,0,1,2,0,1,2
	.byte 0,1,2,0,1,2,0,1,2,0,1,2,0,1,2,0
	.byte 1,2,0,1,2,0,1,2,0,1,2,0,1,2,0,1
	.byte 2,0,1,2,0,1,2,0,1,2,0,1,2,0,1,2
	.byte 0,1,2,0,1,2,0,1,2,0,1,2,0,1,2,0
	.byte 1,2,0,1,2,0,1,2,0,1,2,0,1,2,0,1
	.byte 2,0,1,2,0,1,2,0,1,2,0,1,2,0,1,2
	.byte 0,1,2,0,1,2,0,1,2,0,1,2,0,1,2,0
	.byte 1,2,0,1,2,0,1,2,0,1,2,0,1,2,0,1
	.byte 2,0,1,2,0,1,2,0,1,2,0,1,2,0,1,2
	.byte 0,1,2,0,1,2,0,1,2,0,1,2,0,1,2,0
	.byte 1,2,0,1,2,0,1,2,0,1,2,0,1,2,0,1
	.byte 2,0,1,2,0,1,2,0,1,2,0,1,2,0,1,2
	.byte 0,1,2,0,1,2,0,1,2,0,1,2,0,1,2,0

tbl_vbaseLo:
	.byte <(SCREEN+(0*320)),<(SCREEN+(1*320)),<(SCREEN+(2*320)),<(SCREEN+(3*320))
	.byte <(SCREEN+(4*320)),<(SCREEN+(5*320)),<(SCREEN+(6*320)),<(SCREEN+(7*320))
	.byte <(SCREEN+(8*320)),<(SCREEN+(9*320)),<(SCREEN+(10*320)),<(SCREEN+(11*320))
	.byte <(SCREEN+(12*320)),<(SCREEN+(13*320)),<(SCREEN+(14*320)),<(SCREEN+(15*320))
	.byte <(SCREEN+(16*320)),<(SCREEN+(17*320)),<(SCREEN+(18*320)),<(SCREEN+(19*320))
	.byte <(SCREEN+(20*320)),<(SCREEN+(21*320)),<(SCREEN+(22*320)),<(SCREEN+(23*320))
	.byte <(SCREEN+(24*320))

tbl_vbaseHi:
	.byte >(SCREEN+(0*320)),>(SCREEN+(1*320)),>(SCREEN+(2*320)),>(SCREEN+(3*320))
	.byte >(SCREEN+(4*320)),>(SCREEN+(5*320)),>(SCREEN+(6*320)),>(SCREEN+(7*320))
	.byte >(SCREEN+(8*320)),>(SCREEN+(9*320)),>(SCREEN+(10*320)),>(SCREEN+(11*320))
	.byte >(SCREEN+(12*320)),>(SCREEN+(13*320)),>(SCREEN+(14*320)),>(SCREEN+(15*320))
	.byte >(SCREEN+(16*320)),>(SCREEN+(17*320)),>(SCREEN+(18*320)),>(SCREEN+(19*320))
	.byte >(SCREEN+(20*320)),>(SCREEN+(21*320)),>(SCREEN+(22*320)),>(SCREEN+(23*320))
	.byte >(SCREEN+(24*320))

tbl_8Lo:
	.byte <(0*8),<(1*8),<(2*8),<(3*8),<(4*8),<(5*8),<(6*8),<(7*8),<(8*8),<(9*8)
	.byte <(10*8),<(11*8),<(12*8),<(13*8),<(14*8),<(15*8),<(16*8),<(17*8),<(18*8),<(19*8)
	.byte <(20*8),<(21*8),<(22*8),<(23*8),<(24*8),<(25*8),<(26*8),<(27*8),<(28*8),<(29*8)
	.byte <(30*8),<(31*8),<(32*8),<(33*8),<(34*8),<(35*8),<(36*8),<(37*8),<(38*8),<(39*8)

tbl_8Hi:
	.byte >(0*8),>(1*8),>(2*8),>(3*8),>(4*8),>(5*8),>(6*8),>(7*8),>(8*8),>(9*8)
	.byte >(10*8),>(11*8),>(12*8),>(13*8),>(14*8),>(15*8),>(16*8),>(17*8),>(18*8),>(19*8)
	.byte >(20*8),>(21*8),>(22*8),>(23*8),>(24*8),>(25*8),>(26*8),>(27*8),>(28*8),>(29*8)
	.byte >(30*8),>(31*8),>(32*8),>(33*8),>(34*8),>(35*8),>(36*8),>(37*8),>(38*8),>(39*8)

tbl_orbit:
	.byte %10000000
	.byte %01000000
	.byte %00100000
	.byte %00010000
	.byte %00001000
	.byte %00000100
	.byte %00000010
	.byte %00000001

