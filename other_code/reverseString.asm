includelib Irvine32.inc
.386
.model flat,stdcall
.stack 4096
WriteString PROTO
ExitProcess PROTO,dwExitCode:dword
.data
source byte "this is the source string",0dh,0ah,0
nameSize = ($-source) -2
target byte sizeof source dup(0),0
.code

main PROC
	mov ecx,nameSize
	mov esi,0
	mov edx,offset source
	call WriteString
reverse1:
	movzx eax,source[esi]
	push eax
	inc esi
	loop reverse1
	
	mov esi,0
	mov ecx,nameSize
reverse2:
	pop eax
	mov source[esi],al
	inc esi
	loop reverse2

	mov edx,offset source
	call WriteString
	invoke ExitProcess,0
main ENDP
end main
