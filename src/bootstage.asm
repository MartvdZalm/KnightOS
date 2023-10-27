; This loaded program will be our 32 bit kernel
; We do not have the limitation of 512 bytes here,
; so we can add anything we want here

org 0x0 																									 ; Offset to 0, we will set segments later

BITS 16 																									 ; We are still in real mode

; we are loaded at linear address 0x10000

jmp main																									 ; Jump to main

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
;	Second Stage Loader Entry Point
; *********************************************************

main:
	cli        																							     ; Clear interrupts to prevent triple faults
	push cs	                            																	 ; Insure DS=CS
	pop ds

	mov si, Msg
	call Print

	cli 																									 ; Clear interrupts to prevent triple faults
	hlt 																									 ; Hault the system

; *********************************************************
;	Data Section
; *********************************************************

Msg DB "Preparing to load operating system...",13,10,0
