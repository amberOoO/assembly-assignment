include C:/Irvine/Irvine32.inc
.model flat,stdcall
.stack 4096
ExitProcess PROTO,dwExitCode:dword
.data
lenthOfFileBuff = 400
lenthOfFileName = 20
lenthOfArray = 200
lenthOfDword = 4
;CapStart dword ?						;��ȡʱ��һ�����ֵĿ�ʼ
;CapEnd dword ?							;��ȡʱ��һ�����ֵĽ���
Captemp byte lenthOfFileBuff dup(0)				;�ӿ���̨��ȡ���ļ����Ļ�����
;�ļ����ݻ�����
fileBuff1 byte lenthOfFileBuff dup(0)
fileBuff2 byte lenthOfFileBuff dup(0)
fileBuff3 byte lenthOfFileBuff dup(0)
;�������ݴ������
matrix1 dword lenthOfArray dup(0)
ptrMatrix1 dword offset matrix1
matrix2 dword lenthOfArray dup(0)
ptrMatrix2 dword offset matrix2
matrix3 dword lenthOfArray dup(0)
ptrMatrix3 dword offset matrix3
;�ļ����洢��
fileName1 byte lenthOfFileName dup(0)	;����1�ļ�
fileName2 byte lenthOfFileName dup(0)	;����2�ļ�
fileName3 byte lenthOfFileName dup(0)	;�������ļ�
;�ļ�����洢����
fileHandle1 dword ?
fileHandle2 dword ?
fileHandle3 dword ?
;�洢������ز���
rowOfMatrix1 dword 0
colOfMatrix1 dword 0
rowOfMatrix2 dword 0
colOfMatrix2 dword 0

;����ָ����
ptrCap dword ?
ptrFileName dword ?						;��ʱ���ļ�����ָ��
ptrFileBuff3 dword offset fileBuff3
;��������
divideChar = 20h						;�������ּ�ָ��ÿո�20h�������Ʊ����09h��
temp dword ?
flagOfRow dword 0
i dword 0
j dword 0
k dword 0
posX dword 0
posY dword 0
warningCaption byte "Warning",0
warningContent byte "Your row can't match with col.",0
count word 0d
swap byte lenthOfArray dup(0)
.code

;�������ļ������ִӿ���̨��ȡ����
CapName PROC
	mov edx,offset Captemp				;��Captemp�����ƫ�Ƶ�ַ����edx��GetCommandTail����
	call GetCommandTail
	mov ptrCap,offset Captemp
	;�ļ���1�Ķ�ȡ/д��
	mov edx,ptrCap						;ָ��ȡ��
	mov al,[edx]						;����ʱ����
	.while al==20h						;�����ո�
		inc edx
		mov eax,[edx]
	.endw
	mov ptrCap,edx

	
	mov ecx,offset fileName1					
	mov ptrFileName,ecx					;���ļ���1�Ļ���ƫ��������ָ��
	mov eax,0							;����ʱ����,�˴���ʼ��
	mov edx,ptrCap
	mov al,[edx]
	mov ebx,ptrFileName
	.while al != 20h
		mov [ebx],al
		inc ebx
		inc edx
		mov al,[edx]
	.endw
	mov ptrCap,edx
	mov ptrFileName,ebx

	;�ļ���2�Ķ�ȡ/д��
	mov edx,ptrCap						;ָ��ȡ��
	mov al,[edx]						;����ʱ����
	.while al==20h						;�����ո�
		inc edx
		mov eax,[edx]
	.endw
	mov ptrCap,edx

	mov ecx,offset fileName2					
	mov ptrFileName,ecx					;���ļ���2�Ļ���ƫ��������ָ��
	mov eax,0							;����ʱ����,�˴���ʼ��
	mov edx,ptrCap
	mov al,[edx]
	mov ebx,ptrFileName
	.while al != 20h
		mov [ebx],al
		inc ebx
		inc edx
		mov al,[edx]
	.endw
	mov ptrCap,edx
	mov ptrFileName,ebx

	;�ļ���3�Ķ�ȡ/д��
	mov edx,ptrCap						;ָ��ȡ��
	mov al,[edx]						;����ʱ����
	.while al==20h						;�����ո�
		inc edx
		mov eax,[edx]
	.endw
	mov ptrCap,edx

	mov ecx,offset fileName3					
	mov ptrFileName,ecx					;���ļ���3�Ļ���ƫ��������ָ��
	mov eax,0							;����ʱ����,�˴���ʼ��
	mov edx,ptrCap
	mov al,[edx]
	mov ebx,ptrFileName
	.while al != 0h						;���һ������Ӧ�������Ϊ���ַ�
		mov [ebx],al
		inc ebx
		inc edx
		mov al,[edx]
	.endw
	mov ptrCap,edx
	mov ptrFileName,ebx

	ret
CapName ENDP
;���ļ����ݶ��뻺����
ReadProcess PROC
	;�򿪸��ļ�������þ��
	mov edx,offset fileName1
	call OpenInputFile
	mov fileHandle1,eax

	mov edx,offset fileName2
	call OpenInputFile
	mov fileHandle2,eax

	;�Ӹ��ļ��ж�ȡ���ݵ�������
	mov edx,offset fileBuff1
	mov ecx,lenthOfFileBuff
	mov eax,fileHandle1
	call ReadFromFile

	mov edx,offset fileBuff2
	mov ecx,lenthOfFileBuff
	mov eax,fileHandle2
	call ReadFromFile

	;mov edx,offset fileBuff3
	;mov ecx,lenthOfFileBuff
	;mov eax,fileHandle3
	;call ReadFromFile
	ret
ReadProcess ENDP
;���ļ��ַ�ת��Ϊ����
BuffProcess PROC
	mov ecx,0
	mov ebx,0
	mov eax,0
	mov esi,0
	mov edx,10d									;edx�ݴ汶��10d
	mov esi,offset fileBuff1					;esi��ʱ��ָ�򻺴�����ָ��
	mov bl,[esi]								;ebx,bl�ݴ��ַ�
	mov ecx,0									;ecx��������ڼ�������
	.while bl!=0
		.if bl == 0dh
				mov edi,ptrMatrix1
				mov [edi], eax					;eax�ǵ�ǰ�����³˵õ���
				add ptrMatrix1,4d
				inc ecx
				.if flagOfRow == 0
					mov colOfMatrix1,ecx
					inc flagOfRow
				.endif
				mov ebx,0
				mov eax,0

				inc rowOfMatrix1
				mov eax,0
				inc esi							;�ѻس�������
			.elseif (bl == 09h) || (bl == 20h)
				mov edi,ptrMatrix1
				mov [edi], eax
				add ptrMatrix1,4d
				inc ecx
				mov ebx,0
				mov eax,0
			.elseif (bl >= 48d) && (bl <= 58d)
				mul edx							;eax�ݴ�ת������
				mov edx,10d
				movzx ebx,bl
 				sub ebx,48d
				add eax,ebx
		.endif
		inc esi
		mov bl,[esi]
	.endw
	inc rowOfMatrix1
	mov flagOfRow,0					;ָ�����޸�λ��Ϊ��߳�����׼��
	mov edi,ptrMatrix1
	mov [edi], eax
	add ptrMatrix1,4d
	inc ecx
	mov ebx,0
	mov eax,0

	mov ecx,0
	mov ebx,0
	mov eax,0
	mov esi,0
	mov edx,10d									;edx�ݴ汶��10d
	mov esi,offset fileBuff2					;esi��ʱ��ָ�򻺴�����ָ��
	mov bl,[esi]								;ebx,bl�ݴ��ַ�
	mov ecx,0									;ecx��������ڼ�������
	.while bl!=0
		.if bl == 0dh
				mov edi,ptrMatrix2
				mov [edi], eax
				add ptrMatrix2,4d
				inc ecx
				.if flagOfRow == 0
					mov colOfMatrix2,ecx
					inc flagOfRow
				.endif
				mov ebx,0
				mov eax,0

				inc rowOfMatrix2
				mov eax,0
				inc esi							;�ѻس�������
			.elseif (bl == 09h) || (bl == 20h)
				mov edi,ptrMatrix2
				mov [edi], eax
				add ptrMatrix2,4d
				inc ecx
				mov ebx,0
				mov eax,0
			.elseif (bl >= 48d) && (bl <= 58d)
				mul edx							;eax�ݴ�ת������
				mov edx,10d
				movzx ebx,bl
 				sub ebx,48d
				add eax,ebx
		.endif
		inc esi
		mov bl,[esi]
	.endw
	inc rowOfMatrix2
	mov flagOfRow,0
	mov edi,ptrMatrix2
	mov [edi], eax
	add ptrMatrix2,4d
	inc ecx
	mov ebx,0
	mov eax,0
	ret
BuffProcess ENDP
;�ж������Ƿ�ƥ��
Judge PROC
	mov esi,colOfMatrix1
	mov edi,rowOfMatrix2
	.if (edi != esi)
		mov edx,offset warningContent
		mov ebx,offset warningCaption
		call MsgBox
		invoke ExitProcess,0
	.endif
	ret
Judge ENDP
;�������1����Ԫ������λ��
CalPosition1 PROC	;�Ծ���1������׵�ַ��Զ����posX��posY���к���,���������ַ����esi��
	;���е�ƫ����
	push eax;
	mov esi,0		;��ʼ��esi
	mov eax,posX
	mov ebx,colOfMatrix1
	mul ebx
	mov ebx,lenthOfDword
	mul ebx
	mov esi,eax
	;���е�ƫ����
	mov eax,posY
	inc eax
	mov ebx,lenthOfDword
	mul ebx
	add esi,eax
	sub esi,lenthOfDword
	pop eax
	ret
CalPosition1 ENDP
;�������2����Ԫ������λ��
CalPosition2 PROC	;�Ծ���1������׵�ַ��Զ����posX��posY���к���,���������ַ����esi��
	;���е�ƫ����
	push eax
	mov esi,0		;��ʼ��esi
	mov eax,posX
	mov ebx,colOfMatrix2
	mul ebx
	mov ebx,lenthOfDword
	mul ebx
	mov esi,eax
	;���е�ƫ����
	mov eax,posY
	inc eax
	mov ebx,lenthOfDword
	mul ebx
	add esi,eax
	sub esi,lenthOfDword
	pop eax
	ret
CalPosition2 ENDP
;������ת��Ϊ�ַ������洢��fileBuff3�С���Ҫת�������ִ����edx��
TransToString PROC
	mov temp,edx
	mov esi,0
	mov eax,edx
	mov edx,0
	mov ebx,10d
	div ebx					;����eax/ebx�У��̴���eax�У�������edx��
	.while eax > 0
		mov ecx,edx
		add ecx,48d
		mov swap[esi],cl
		inc esi

		mov ebx,10d
		mov edx,0
		div ebx
		inc count	
	.endw
	add edx,48d
	mov swap[esi],dl
	inc count
	.while count > 0
		mov edi,ptrFileBuff3
		mov al,swap[esi]
		dec esi
		mov [edi],al
		dec count
		inc ptrFileBuff3
	.endw

	ret
TransToString ENDP
;����˷�
MatrixMul PROC
	mov i,0
	mov ebx,i
	mov esi,0
	.while ebx < rowOfMatrix1
		mov j,0
		mov ebx,j
		.while ebx < colOfMatrix2
			mov temp,0								;EDI�ݴ�i��j�еļ����м�ֵ,�˴���ʼ��
			mov eax,0
			mov k,0
			mov ebx,k
			.while ebx < colOfMatrix1
				;��ȡ�ھ���1�У�i��k��Ԫ�ؾ�ͷָ�����
				mov ecx, i
				mov posX, ecx
				mov ecx, k
				mov posY, ecx
				call CalPosition1
				mov eax,matrix1[esi]
				;��ȡ�ھ���2�У�k��j��Ԫ�ؾ�ͷָ�����
				mov ecx, k
				mov posX, ecx
				mov ecx, j
				mov posY, ecx
				call CalPosition2
				mov ecx,matrix2[esi]
				mul ecx
				add temp,eax							

				inc k
				mov ebx,k
			.endw		
			mov edx,temp					;edxΪtrans�������ṩ���ݵļĴ���
			mov edi,ptrMatrix3
			mov [edi],edx
			add ptrMatrix3,lenthOfDword
			;sub dx,48d
			call TransToString
			mov eax,ptrFileBuff3			;�ڼ���һ�����ֺ����ո�/�Ʊ��
			mov bl,divideChar
			mov [eax],bl
			inc ptrFileBuff3
			

			inc j
			mov ebx,j
		.endw
		mov eax,ptrFileBuff3				;�ڼ���һ�����ֺ���뻻��
		mov bl,0ah
		mov [eax],bl		
		inc ptrFileBuff3
		;mov eax,ptrFileBuff3				;�ڼ���һ�����ֺ����س�
		;mov bl,0dh							
		;mov [eax],bl	
		;inc ptrFileBuff3

		inc i
		mov ebx,i
	.endw
	ret
MatrixMul ENDP
;д������ļ�
WriteToDestination PROC
	mov edx,offset fileName3
	call CreateOutputFile
	mov fileHandle3,eax

	mov esi,ptrFileBuff3
	mov ebx,offset fileBuff3
	sub esi,ebx

	mov eax,fileHandle3
	mov edx,offset fileBuff3
	mov ecx,esi
	call WriteToFile
	ret
WriteToDestination ENDP
;�ر����е��ļ�
CloseAllFile PROC
	mov eax,fileHandle1
	call CloseFile
	mov eax,fileHandle2
	call CloseFile
	mov eax,fileHandle3
	call CloseFile
	ret
CloseAllFile ENDP
;������
main PROC

	call CapName
	call ReadProcess
	call BuffProcess

	mov posX,0
	mov posY,1
	call CalPosition1

	call Judge
	call MatrixMul
	mov edx,offset fileBuff3

	call WriteString
	;д��Ŀ���ļ�
	call WriteToDestination
	;�ر������ļ�
	call CloseAllFile
	call WaitMsg

	;jumEnd::

	invoke ExitProcess,0
main ENDP
end main
