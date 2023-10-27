; *********************************************************
;	KnightOS
; 	
;	Operating System build by Mart van der Zalm
; *********************************************************

bits 16 																									 ; We are for now in 16 bit real mode

org 0x7c00																						   			 	 ; We are loaded by BIOS at 0x7C00

start: jmp loader																							 ; Jump over BPB block

; *********************************************************
;	BPB (Bios Parameter Block)
; *********************************************************

OEMLabel                    DB "KNIGHTOS"                                        							 ; OEM (Original Equipment Manufacturer)
bpbBytesPerSector:			DW 512
bpbSectorsPerCluster:		DB 1
bpbReservedSectors:			DW 1
bpbNumberOfFATs:			DB 2
bpbRootEntries:				DW 224
bpbTotalSectors:			DW 2880
bpbMedia:					DB 0xF0
bpbSectorsPerFAT:			DW 9
bpbSectorsPerTrack:			DW 18
bpbHeadsPerCylinder:		DW 2
bpbHiddenSectors:			DD 0
bpbTotalSectorsBig:			DD 0
bsDriveNumber:				DB 0
bsUnused:					DB 0
bsExtBootSignature:			DB 0x29
bsSerialNumber:				DD 0xAB29F1C7
bsVolumeLabel:              DB "KNIGHT OS  "
bsFileSystem:               DB "FAT12   "

msg	DB	"Welcome to My Operating System!", 0		; the string to print

; *********************************************************
;	Prints a string
; 	DS=>SI: 0 terminated string
; *********************************************************
Print:
	lodsb
	or al, al
	jz PrintDone
	mov ah, 0eh
	int 10h
	jmp Print

PrintDone:
	ret 

; *********************************************************
;	Bootloader Entry Point
; *********************************************************

loader:

	xor	ax, ax																								 ; Setup segments to insure they are 0. Remember that
	mov	ds, ax																								 ; we have ORG 0x7c00. This means all addresses are based
	mov	es, ax																																															

	mov	si, msg																								 ; our message to print
	call Print																							 	 ; call our print function

	xor	ax, ax																								 ; clear ax
	int	0x12																								 ; get the amount of KB from the BIOS

	cli																										 ; Clear all Interrupts
	hlt																										 ; halt the system
	
times 510 - ($-$$) DB 0																						 ; We have to be 512 bytes. Clear the rest of the bytes with 0

DW 0xAA55																								     ; Boot Signiture