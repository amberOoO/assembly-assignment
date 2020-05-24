.386
.model flat,stdcall
.stack 4096
ExitProcess PROTO,dwExitCode:DWORD
.data

.code
main PROC
	mov eax,-100h
	neg eax

	invoke ExitProcess,0
main ENDP
end main
