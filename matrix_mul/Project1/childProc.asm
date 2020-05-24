include C:/Irvine/Irvine32.inc
.model flat,stdcall
.stack 4096
ExitProcess PROTO,dwExitCode:dword
.data
lenthOfFileBuff = 400
lenthOfFileName = 20
lenthOfArray = 200
lenthOfDword = 4
;CapStart dword ?						;截取时，一个名字的开始
;CapEnd dword ?							;截取时，一个名字的结束
Captemp byte lenthOfFileBuff dup(0)				;从控制台获取三文件名的缓冲区
;文件内容缓存区
fileBuff1 byte lenthOfFileBuff dup(0)
fileBuff2 byte lenthOfFileBuff dup(0)
fileBuff3 byte lenthOfFileBuff dup(0)
;矩阵数据存放数组
matrix1 dword lenthOfArray dup(0)
ptrMatrix1 dword offset matrix1
matrix2 dword lenthOfArray dup(0)
ptrMatrix2 dword offset matrix2
matrix3 dword lenthOfArray dup(0)
ptrMatrix3 dword offset matrix3
;文件名存储区
fileName1 byte lenthOfFileName dup(0)	;矩阵1文件
fileName2 byte lenthOfFileName dup(0)	;矩阵2文件
fileName3 byte lenthOfFileName dup(0)	;输出结果文件
;文件句柄存储变量
fileHandle1 dword ?
fileHandle2 dword ?
fileHandle3 dword ?
;存储矩阵相关参数
rowOfMatrix1 dword 0
colOfMatrix1 dword 0
rowOfMatrix2 dword 0
colOfMatrix2 dword 0

;各类指针存放
ptrCap dword ?
ptrFileName dword ?						;暂时存文件名的指针
ptrFileBuff3 dword offset fileBuff3
;其他变量
divideChar = 20h						;矩阵数字间分格用空格（20h）还是制表符（09h）
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

;将三个文件的名字从控制台读取出来
CapName PROC
	mov edx,offset Captemp				;将Captemp缓存的偏移地址存入edx待GetCommandTail调用
	call GetCommandTail
	mov ptrCap,offset Captemp
	;文件名1的读取/写入
	mov edx,ptrCap						;指针取出
	mov al,[edx]						;存临时变量
	.while al==20h						;跳过空格
		inc edx
		mov eax,[edx]
	.endw
	mov ptrCap,edx

	
	mov ecx,offset fileName1					
	mov ptrFileName,ecx					;将文件名1的缓存偏移量存入指针
	mov eax,0							;存临时变量,此处初始化
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

	;文件名2的读取/写入
	mov edx,ptrCap						;指针取出
	mov al,[edx]						;存临时变量
	.while al==20h						;跳过空格
		inc edx
		mov eax,[edx]
	.endw
	mov ptrCap,edx

	mov ecx,offset fileName2					
	mov ptrFileName,ecx					;将文件名2的缓存偏移量存入指针
	mov eax,0							;存临时变量,此处初始化
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

	;文件名3的读取/写入
	mov edx,ptrCap						;指针取出
	mov al,[edx]						;存临时变量
	.while al==20h						;跳过空格
		inc edx
		mov eax,[edx]
	.endw
	mov ptrCap,edx

	mov ecx,offset fileName3					
	mov ptrFileName,ecx					;将文件名3的缓存偏移量存入指针
	mov eax,0							;存临时变量,此处初始化
	mov edx,ptrCap
	mov al,[edx]
	mov ebx,ptrFileName
	.while al != 0h						;最后一个输入应该在最后为空字符
		mov [ebx],al
		inc ebx
		inc edx
		mov al,[edx]
	.endw
	mov ptrCap,edx
	mov ptrFileName,ebx

	ret
CapName ENDP
;将文件内容读入缓存区
ReadProcess PROC
	;打开各文件，并获得句柄
	mov edx,offset fileName1
	call OpenInputFile
	mov fileHandle1,eax

	mov edx,offset fileName2
	call OpenInputFile
	mov fileHandle2,eax

	;从各文件中读取内容到缓存区
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
;将文件字符转换为数字
BuffProcess PROC
	mov ecx,0
	mov ebx,0
	mov eax,0
	mov esi,0
	mov edx,10d									;edx暂存倍数10d
	mov esi,offset fileBuff1					;esi暂时作指向缓存区的指针
	mov bl,[esi]								;ebx,bl暂存字符
	mov ecx,0									;ecx存放数到第几个数了
	.while bl!=0
		.if bl == 0dh
				mov edi,ptrMatrix1
				mov [edi], eax					;eax是当前行列下乘得的数
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
				inc esi							;把回车给跳掉
			.elseif (bl == 09h) || (bl == 20h)
				mov edi,ptrMatrix1
				mov [edi], eax
				add ptrMatrix1,4d
				inc ecx
				mov ebx,0
				mov eax,0
			.elseif (bl >= 48d) && (bl <= 58d)
				mul edx							;eax暂存转换的数
				mov edx,10d
				movzx ebx,bl
 				sub ebx,48d
				add eax,ebx
		.endif
		inc esi
		mov bl,[esi]
	.endw
	inc rowOfMatrix1
	mov flagOfRow,0					;指令列修改位，为后边程序做准备
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
	mov edx,10d									;edx暂存倍数10d
	mov esi,offset fileBuff2					;esi暂时作指向缓存区的指针
	mov bl,[esi]								;ebx,bl暂存字符
	mov ecx,0									;ecx存放数到第几个数了
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
				inc esi							;把回车给跳掉
			.elseif (bl == 09h) || (bl == 20h)
				mov edi,ptrMatrix2
				mov [edi], eax
				add ptrMatrix2,4d
				inc ecx
				mov ebx,0
				mov eax,0
			.elseif (bl >= 48d) && (bl <= 58d)
				mul edx							;eax暂存转换的数
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
;判断行列是否匹配
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
;算出矩阵1所在元素所在位置
CalPosition1 PROC	;对矩阵1算距离首地址多远，用posX和posY存行和列,并将结果地址存在esi中
	;算行的偏移量
	push eax;
	mov esi,0		;初始化esi
	mov eax,posX
	mov ebx,colOfMatrix1
	mul ebx
	mov ebx,lenthOfDword
	mul ebx
	mov esi,eax
	;算列的偏移量
	mov eax,posY
	inc eax
	mov ebx,lenthOfDword
	mul ebx
	add esi,eax
	sub esi,lenthOfDword
	pop eax
	ret
CalPosition1 ENDP
;算出矩阵2所在元素所在位置
CalPosition2 PROC	;对矩阵1算距离首地址多远，用posX和posY存行和列,并将结果地址存在esi中
	;算行的偏移量
	push eax
	mov esi,0		;初始化esi
	mov eax,posX
	mov ebx,colOfMatrix2
	mul ebx
	mov ebx,lenthOfDword
	mul ebx
	mov esi,eax
	;算列的偏移量
	mov eax,posY
	inc eax
	mov ebx,lenthOfDword
	mul ebx
	add esi,eax
	sub esi,lenthOfDword
	pop eax
	ret
CalPosition2 ENDP
;将整数转化为字符，并存储在fileBuff3中。需要转换的数字存放在edx中
TransToString PROC
	mov temp,edx
	mov esi,0
	mov eax,edx
	mov edx,0
	mov ebx,10d
	div ebx					;除法eax/ebx中，商存在eax中，余数在edx中
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
;矩阵乘法
MatrixMul PROC
	mov i,0
	mov ebx,i
	mov esi,0
	.while ebx < rowOfMatrix1
		mov j,0
		mov ebx,j
		.while ebx < colOfMatrix2
			mov temp,0								;EDI暂存i行j列的计算中间值,此处初始化
			mov eax,0
			mov k,0
			mov ebx,k
			.while ebx < colOfMatrix1
				;获取在矩阵1中，i行k列元素距头指针距离
				mov ecx, i
				mov posX, ecx
				mov ecx, k
				mov posY, ecx
				call CalPosition1
				mov eax,matrix1[esi]
				;获取在矩阵2中，k行j列元素距头指针距离
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
			mov edx,temp					;edx为trans函数的提供数据的寄存器
			mov edi,ptrMatrix3
			mov [edi],edx
			add ptrMatrix3,lenthOfDword
			;sub dx,48d
			call TransToString
			mov eax,ptrFileBuff3			;在加入一个数字后加入空格/制表符
			mov bl,divideChar
			mov [eax],bl
			inc ptrFileBuff3
			

			inc j
			mov ebx,j
		.endw
		mov eax,ptrFileBuff3				;在加入一个数字后加入换行
		mov bl,0ah
		mov [eax],bl		
		inc ptrFileBuff3
		;mov eax,ptrFileBuff3				;在加入一个数字后加入回车
		;mov bl,0dh							
		;mov [eax],bl	
		;inc ptrFileBuff3

		inc i
		mov ebx,i
	.endw
	ret
MatrixMul ENDP
;写入输出文件
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
;关闭所有地文件
CloseAllFile PROC
	mov eax,fileHandle1
	call CloseFile
	mov eax,fileHandle2
	call CloseFile
	mov eax,fileHandle3
	call CloseFile
	ret
CloseAllFile ENDP
;主程序
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
	;写入目标文件
	call WriteToDestination
	;关闭所有文件
	call CloseAllFile
	call WaitMsg

	;jumEnd::

	invoke ExitProcess,0
main ENDP
end main
