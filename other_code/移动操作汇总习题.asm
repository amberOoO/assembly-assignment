comment !
.386
.model flat,stdcall
.stack 4096
ExitProcess PROTO,dwExitCode:DWORD
.data
val1 WORD 1000h
val2 WORD 2000h
arrayB BYTE 10h,20h,30h,40h,50h
arrayW WORD 100h,200h,300h
arrayD DWORD 10000h,20000h,30000h
.code
movp PROC
;present the performence of MOVZX
	mov bx,0A69Bh
	movzx eax,bx
	movzx edx,bl
	movzx cx,bl
;present the performence of MOVSX
	mov bx,0A69Bh
	movsx eax,bx
	movsx edx,bl
	mov bl,7Bh
	movsx cx,bl
;present the performence of XCHG
	mov ax,val1
	xchg ax,val2
	mov val1,ax
;present the performence of PianYiXunZhi[byte]
	mov al,arrayB
	mov al,[arrayB+1]
	mov al,[arrayB+2]
;present the performence of PianYiXunZhi[word]
	mov ax,arrayW
	mov ax,[arrayW+2]
;present the performence of PianYiXunZhi[dword]
	mov eax,arrayD
	mov eax,[arrayD+4]
	mov eax,[arrayD+8]

	invoke ExitProcess,0
movp ENDP
END movp
!