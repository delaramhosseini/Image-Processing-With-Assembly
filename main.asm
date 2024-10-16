;|=====================================================================================|
;|                                                                                     |
;|                                 ; Delaram Hosseini ;                                |
;|                                      610399191                                      |
;|                                                                                     |
;|=====================================================================================|
; final project, part 2

section .data
    ;menu
    Menu db 'choose one of the following items(Please write the number of that item) :', 0,
    FirstOption db '1 OpeningPicture', 0,
    SecondOption db '2 Reshaping', 0,
    TherdOption db '3 Resizing', 0,
    FourthOption db '4 Grayscaling', 0,
    FifthOption db '5 ConvolutionFilters', 0,
    SixthOption db '6 Pooling', 0,
    SeventhOption db '7 Noise', 0,
    EighthOption db '8 Print result', 0,
    Zero db '0 Exit', 0,

    ;error
    ErrorMassage1 db 'Your input is not valid', 0,

    ;opening picture
    PictureAddress db 'Please write the address of the picture :', 0,

    ;reshaping
    EnterDimension db 'Please write new dimension :', 0,

    ;resizing
    EnterResizing db 'Please enter new size :', 0,

    ;convolutionFilters
    Fiters db 'Please choose one of the following filters :', 0,
    EdgeDetection db '1 edge detection filter', 0,
    Sharpening db '2 sharpening filter', 0,
    Zeropadding db 'do you want to use zero padding?',0,
    WithZeropadding db '1 YES', 0,
    WithoutZeropadding db '2 No', 0,
    StrideMethod db 'do you want to use Stride?', 0,
    WithStride db '1 YES', 0,
    WithoutStride db '2 NO', 0,
    SizeOfStride db 'Please enter the size of the stride :', 0,
    EdgeDetection_buff dq -1,-1,-1,-1,8,-1,-1,-1,-1,
    Sharpening_buff dq 0,-1,0,-1,5,-1,0,-1,0,

    ;Pooling
    EnterPoolingSize db 'Please enter pooling size :', 0,
    PoolingMenue db 'choose on of the following items :', 0,
    MaxPooling db '1 MaxPooling', 0,
    AveragePooling db '2 AveragePooleng', 0,

    ;salt and pepper noise
    PercentageOfTheNoise db 'Please enter the prcentage of the noise :', 0,

    FinalPictureAddress db 'Please write the address of where you want save the final picture :', 0,

        
    flag db 0
    flag3D db 1
    flag2D db 0
    flag1D db 0
    EdgeDetectionFlag db 0
    SharpeningFlag db 0
    MaxValue dq 0 ;for MaxPooling
    SumValue dq 0 ;for AveragePooling
    
    ZeropaddingFlag db 0
    StrideFlag db 0

    fdSorceFile dq 0 ;file descriptor
    fdDestinationFile dq 0 ;file descriptor
    rowSize dq 0
    columnSize dq 0
    MatrixSize dq 0
    NewrowSize dq 0
    NewcolumnSize dq 0
    NewMatrixSize dq 0
    ResizingScale dq 0
    PoolingScale dq 0
    StrideSize dq 0
    r_coef dq 0.299
    g_coef dq 0.587
    b_coef dq 0.114

    ; PicturesDirectory db "/home/assembly/code/final project/second part/test.text", 0,

section .bss
    PicturesDirectory resb 1000000
    FinalPictureDirectory resb 1000000
    buff resb 1000000
    R_buff resb 1000000
    newR_buff resb 1000000
    G_buff resb 1000000
    newG_buff resb 1000000
    B_buff resb 1000000
    newB_buff resb 1000000
    FinalShape_buff resb 1000000
    ; EdgeDetection_buff resq 1000000
    

section .text
    global _start

_start:
    mov rsi, Menu
    call printString

    call newLine
    mov rsi, FirstOption
    call printString

    call newLine
    mov rsi, SecondOption
    call printString

    call newLine
    mov rsi, TherdOption
    call printString

    call newLine
    mov rsi, FourthOption
    call printString

    call newLine
    mov rsi, FifthOption
    call printString

    call newLine
    mov rsi, SixthOption
    call printString

    call newLine
    mov rsi, SeventhOption
    call printString

    call newLine
    mov rsi, EighthOption
    call printString   

    call newLine
    mov rsi, Zero
    call printString

    call newLine
    call readNum

    cmp rax, 0
    je end_Start

    cmp rax, 1
    je OpeningPicture

    cmp rax, 2
    je Reshaping

    cmp rax, 3
    je Resizing

    cmp rax, 4
    je Grayscaling

    cmp rax, 5
    je ConvolutionFilters

    cmp rax, 6
    je Pooling
    
    cmp rax, 7
    je Noise

    cmp rax, 8
    je PrinResultMatrix

    jmp PrintError

    OpeningPicture:
        mov rsi, PictureAddress
        call printString
        
        ; get the directory of the picture:
        ;/home/assembly/code/final project/second part/first.text
        ;/home/assembly/code/final project/second part/second.text
        ;/home/assembly/code/final project/second part/test.text
        ;/home/assembly/code/final project/second part/testResult.text


        mov rax, 0
        mov rdi, 0
        mov rsi, PicturesDirectory
        mov rdx, 1000
        syscall

        mov byte[rsi + rax-1], 0
        
        ; open the file:
        mov rdi, PicturesDirectory
        call openFile
        mov [fdSorceFile], rax

        ;read a file
        mov rdi, [fdSorceFile]
        mov rsi, buff
        mov rdx, 1000000
        call readFile

        ;close a file
        mov rdi, [fdSorceFile]
        call closeFile

        call OpeningRGB

        jmp _start

    Reshaping:
        mov rsi, EnterDimension
        call printString
        call readNum
        cmp rax, 2
            je CALL2D

        cmp rax, 1
            je CALL1D

        jmp PrintError

        CALL2D:
            push B_buff
            call ReshapeMatrix

            mov byte[flag1D], 0
            mov byte[flag2D], 1
            mov byte[flag3D], 0

            call PrintAllDimentions
            jmp _start

        CALL1D:
            push G_buff
            call ReshapeMatrix

            push B_buff
            call ReshapeMatrix

            mov byte[flag1D], 1
            mov byte[flag2D], 0
            mov byte[flag3D], 0

            call PrintAllDimentions
            jmp _start


    Resizing:
        mov rsi, EnterResizing
        call printString

        call readNum
        mov [NewrowSize], rax

        xor rax, rax
        call readNum
        mov [NewcolumnSize], rax

        xor rdx, rdx
        mov rax, [rowSize]
        mov rbx, [NewrowSize]
        div rbx
        cmp rdx, 0
            jne PrintError

        mov [ResizingScale], rax
        xor rdx, rdx

        call ResizingMatrix

        jmp _start         
            

    Grayscaling:
        cmp byte[flag3D], 1
        je continue_Grayscaling
        jne PrintError
    
        continue_Grayscaling:
            call grayScaleImage
            jmp _start

    ConvolutionFilters:
        mov byte[ZeropaddingFlag], 0
        mov byte[StrideFlag], 0

        ZeroPadding:
            mov rsi, Zeropadding
            call printString

            call newLine

            mov rsi, WithZeropadding
            call printString

            call newLine

            mov rsi, WithoutZeropadding
            call printString

            call newLine

            call readNum

            cmp rax, 1
                je ChangeZeropaddingFlag

            cmp rax, 2
                jne PrintError
                jmp Sride

            ChangeZeropaddingFlag:
                mov byte[ZeropaddingFlag], 1

        Sride:
            mov rsi, StrideMethod
            call printString

            call newLine

            mov rsi, WithStride
            call printString

            call newLine

            mov rsi, WithoutStride
            call printString

            call newLine

            call readNum

            cmp rax, 1
                je ChangeStrideFlag

            cmp rax, 2
                jne PrintError
                jmp ChooseFilters

            ChangeStrideFlag:
                mov byte[StrideFlag], 1

            mov rsi, SizeOfStride
            call printString

            call newLine

            call readNum

            mov [StrideSize], rax

        ChooseFilters:
            mov rsi, Fiters
            call printString

            call newLine

            mov rsi, EdgeDetection
            call printString

            call newLine

            mov rsi, Sharpening
            call printString

            call newLine

            call readNum

            cmp rax, 1
                je GoToEdgeDetection

            cmp rax, 2
                je GoToSharpening
            jne PrintError 

            GoToEdgeDetection:
                mov byte[EdgeDetectionFlag], 1
                mov byte[SharpeningFlag], 0
                jmp end_ChooseFilters

            GoToSharpening:
                mov byte[SharpeningFlag], 1
                mov byte[EdgeDetectionFlag], 0
     
        end_ChooseFilters:
            call ConvolutionFilterComputing
            jmp _start

    Pooling:
        mov rsi, EnterPoolingSize
        call printString

        call readNum
        mov [NewrowSize], rax
 
        xor rax, rax
        call readNum
        mov [NewcolumnSize], rax

        xor rdx, rdx
        mov rax, [rowSize]

        mov rbx, [NewrowSize]
        div rbx

        cmp rdx, 0
            jne PrintError

        mov [PoolingScale], rax
        xor rdx, rdx

        mov rsi, Menu
        call printString
        call newLine

        mov rsi, MaxPooling
        call printString
        call newLine

        mov rsi, AveragePooling
        call printString
        call newLine

        call readNum

        cmp rax, 1
            je MaxPoolingPart

        cmp rax, 2
            je AveragePoolingPart

        jmp PrintError

        MaxPoolingPart:
            cmp byte[flag1D], 1
                je GoToMaxPoolingComputingFor1D

            cmp byte[flag2D], 1
                je GoToMaxPoolingComputingFor2D

            cmp byte[flag3D], 1
                je GoToMaxPoolingComputingFor3D
            
            GoToMaxPoolingComputingFor1D:
                push R_buff
                push newR_buff
                call MaxPoolingComputing

                jmp Exchange_buff_MaxPoolingPart

            GoToMaxPoolingComputingFor2D:
                push R_buff
                push newR_buff
                call MaxPoolingComputing

                push G_buff
                push newG_buff
                call MaxPoolingComputing

                jmp Exchange_buff_MaxPoolingPart

            GoToMaxPoolingComputingFor3D:
                push R_buff
                push newR_buff
                call MaxPoolingComputing

                push G_buff
                push newG_buff
                call MaxPoolingComputing

                push B_buff
                push newB_buff
                call MaxPoolingComputing

                jmp Exchange_buff_MaxPoolingPart

            Exchange_buff_MaxPoolingPart:
                mov rax, [NewcolumnSize]
                mov [columnSize], rax

                mov rax, [NewrowSize]
                mov [rowSize], rax

                mov rax, [columnSize]
                mov rbx, [rowSize]
                mul rbx
                mov [MatrixSize], rax
                xor rdx, rdx
                
                jmp _start


        AveragePoolingPart:
            cmp byte[flag1D], 1
                je GoToAveragePoolingComputingFor1D

            cmp byte[flag2D], 1
                je GoToAveragePoolingComputingFor2D

            cmp byte[flag3D], 1
                je GoToAveragePoolingComputingFor3D
            
            GoToAveragePoolingComputingFor1D:
                push R_buff
                push newR_buff
                call AveragePoolingComputing

                jmp Exchange_buff_AveragePoolingPart

            GoToAveragePoolingComputingFor2D:
                push R_buff
                push newR_buff
                call AveragePoolingComputing

                push G_buff
                push newG_buff
                call AveragePoolingComputing

                jmp Exchange_buff_AveragePoolingPart
            GoToAveragePoolingComputingFor3D:
                push R_buff
                push newR_buff
                call AveragePoolingComputing

                push G_buff
                push newG_buff
                call AveragePoolingComputing

                push B_buff
                push newB_buff
                call AveragePoolingComputing

                jmp Exchange_buff_AveragePoolingPart

            Exchange_buff_AveragePoolingPart:
                mov rax, [NewcolumnSize]
                mov [columnSize], rax

                mov rax, [NewrowSize]
                mov [rowSize], rax

                mov rax, [NewMatrixSize]
                mov [MatrixSize], rax
                
                jmp _start


    Noise:
        mov rsi, PercentageOfTheNoise
        call printString

        call readNum

        push rax
        call NoiseSaltAndPepper

        jmp _start

    PrinResultMatrix:
        mov rsi, FinalPictureAddress
        call printString
        
        mov rax, 0
        mov rdi, 0
        mov rsi, FinalPictureDirectory
        mov rdx, 1000
        syscall
        mov byte[rsi + rax-1], 0

        ; creat a file
        mov rdi, FinalPictureDirectory
        call createFile
        mov [fdDestinationFile], rax

        mov rax, [rowSize]
        mov r9, 0
        mov r8, -1
        LOOP1_PrinResultMatrix:
            xor rdx, rdx
            mov rbx, 10
            div rbx

            add rdx, 48
            inc r9
            push rdx
            cmp rax, 0
                je inside_LOOP1_PrinResultMatrix
            jmp LOOP1_PrinResultMatrix
            
            inside_LOOP1_PrinResultMatrix:
                dec r9
                cmp r9, -1
                    jle end_LOOP1_PrinResultMatrix
                inc r8
                pop rax
                mov [FinalShape_buff+r8], al
                jmp inside_LOOP1_PrinResultMatrix

            end_LOOP1_PrinResultMatrix:
                inc r8
                mov rax, Space
                mov [FinalShape_buff+r8], al

            
        mov rax, [columnSize]
        mov r9, 0
        LOOP2_PrinResultMatrix:
            xor rdx, rdx
            mov rbx, 10
            div rbx

            add rdx, 48
            inc r9
            push rdx
            cmp rax, 0
                je inside_LOOP2_PrinResultMatrix
            jmp LOOP2_PrinResultMatrix
            
            inside_LOOP2_PrinResultMatrix:
                dec r9
                cmp r9, -1
                    jle end_LOOP2_PrinResultMatrix
                inc r8
                pop rax
                mov [FinalShape_buff+r8], al
                jmp inside_LOOP2_PrinResultMatrix

            end_LOOP2_PrinResultMatrix:
                inc r8
                mov rax, 10
                mov [FinalShape_buff+r8], al
                inc r8

        mov rdi, [fdDestinationFile]
        mov rsi, FinalShape_buff
        mov rdx, r8
        call writeFile

        push R_buff
        push newR_buff
        call MovResultMatrixToFile

        push G_buff
        push newG_buff
        call MovResultMatrixToFile

        push B_buff
        push newB_buff
        call MovResultMatrixToFile

        ;close file
        mov rdi, [fdDestinationFile]
        call closeFile

        jmp _start


    PrintError:
        mov rsi, ErrorMassage1
        call printString
        call newLine
        jmp _start

    end_Start:
        jmp Exit


MovResultMatrixToFile:
    enter 0,0
    push rax
    push rbx
    push rdx
    push r8
    push r9
    push r10
    push r11
    push r12
    push rdi
    push rsi

    mov r11, [rbp+16] ;new?_buff
    mov r12, [rbp+24] ;?_buff

    mov r8, -1
    mov r10, -1
    LOOP1_ConvertingDecimalToChar_MovResultMatrixToFile:
        xor rax, rax
        inc r8
        cmp r8, [MatrixSize]
        jge end_LOOP1_ConvertingDecimalToChar_MovResultMatrixToFile
        mov r9, 0
        mov al, [r12+r8]
        and rax, 0xFF
        LOOP2_DiviteToTen_MovResultMatrixToFile:
            xor rdx, rdx
            mov rbx, 10
            div rbx

            add rdx, 48
            inc r9
            push rdx

            cmp rax, 0
            je inside_LOOP2_DiviteToTen_MovResultMatrixToFile
            jmp LOOP2_DiviteToTen_MovResultMatrixToFile

            inside_LOOP2_DiviteToTen_MovResultMatrixToFile:
                xor rax, rax
                dec r9
                cmp r9, -1
                jle end_LOOP2_DiviteToTen_MovResultMatrixToFile
                inc r10
                pop rax
                mov [r11+r10], al
                jmp inside_LOOP2_DiviteToTen_MovResultMatrixToFile

            end_LOOP2_DiviteToTen_MovResultMatrixToFile:
                inc r10
                mov rax, Space
                mov [r11+r10], al
                jmp LOOP1_ConvertingDecimalToChar_MovResultMatrixToFile

        end_LOOP1_ConvertingDecimalToChar_MovResultMatrixToFile:
            inc r10
            mov rax, 10
            mov [r11+r10], al 
            inc r10

    mov rdi, [fdDestinationFile]
    mov rsi, r11
    mov rdx, r10
    call writeFile

    end_MovResultMatrixToFile:

    pop rsi
    pop rdi
    pop r12
    pop r11
    pop r10
    pop r9
    pop r8
    pop rdx
    pop rbx
    pop rax
    leave
    ret 16



grayscalePixel:
    enter 0,0
    push rax
    push rbx
    push rcx
    
        fild qword[rbp+32] ; red pixel
        ; fmul qword[r_coef]
        fld qword[r_coef] 
        fmulp

        fild qword[rbp+24] ; green pixel
        ; fmul qword[g_coef]
        fld qword[g_coef] 
        fmulp

        faddp

        fild qword[rbp+16] ; blue pixel
        ; fmul qword[b_coef]
        fld qword[b_coef] 
        fmulp

        faddp

        fistp qword[rbp+32]

    pop rcx
    pop rbx
    pop rax
    leave
    ret 16


grayScaleImage:
    push rax
    push rbx
    push rcx

    ; check image have 3 layers. 

    mov rcx, [MatrixSize]
    dec rcx

    LoopGrayScaleImage:
        mov bl, [R_buff+rcx]
        and rbx, 0xFF
        push rbx
        
        mov bl, [G_buff+rcx]
        and rbx, 0xFF
        push rbx
        
        mov bl, [B_buff+rcx]
        and rbx, 0xFF
        push rbx

        call grayscalePixel

        pop rbx 
        
        mov [R_buff+rcx], bl

        loop LoopGrayScaleImage

    push G_buff
    call ReshapeMatrix

    push B_buff
    call ReshapeMatrix

    mov byte[flag1D], 1
    mov byte[flag2D], 0
    mov byte[flag3D], 0

    call PrintAllDimentions

    pop rcx
    pop rbx
    pop rax
    ret


FindIndexForConvolution:
    enter 0,0
    push rax
    push rbx
    push rdx

    xor rdx, rdx
    mov rax, [rbp+16] ;center index
    mov rbx, [columnSize]
    div rbx

    mov [rbp+24], rax ; number of row
    mov [rbp+16], rdx ; number of column

    pop rdx
    pop rbx
    pop rax
    leave
    ret

ComputeConvolution:
    enter 24,0
    push rax
    push rbx
    push rcx
    push rdx
    push r8
    push r9
    push r10
    push r11
    push r12
    push rsi

    mov r8, [rbp+16] ;row of image
    mov r9, [rbp+24] ;column of image
    mov r12, [rbp+32]

    ; mov rax, [rbp+40]
    ; call writeNum
    ; call newLine
    ; call newLine

    ; mov rax, r8
    ; call writeNum
    ; mov rax, Space
    ; call putc
    ; mov rax, r9
    ; call writeNum
    ; call newLine

    mov r10, -1 ;row of filter
    mov r11, -1 ;column of filter

    mov rbx, r8
    inc rbx  
    cmp rbx, [rowSize]
    jl continue1_ComputeConvolution
    dec rbx ;upper limit for row
    
    continue1_ComputeConvolution:
    mov rdx, r9
    inc rdx ;upper limit for column
    cmp rdx, [columnSize]
    jl continue2_ComputeConvolution
    dec rdx 
    
    continue2_ComputeConvolution:
    sub r8, 2
    sub r9, 2
    mov rsi, r9
    mov qword[rbp-8], 0
    mov qword[rbp-16], 0
    mov qword[rbp-24], 0

    LOOP1_ComputeConvolution:
        inc r10
        inc r8
        
        cmp r8, 0
        jl LOOP1_ComputeConvolution

        cmp r8, rbx
        jg end_LOOP1_ComputeConvolution
        mov r9, rsi
        mov r11, -1
        LOOP2_ComputeConvolution:
            inc r11
            inc r9
            cmp r9, 0
            jl LOOP2_ComputeConvolution

            cmp r9, rdx
            jg LOOP1_ComputeConvolution

            ; mov rax, r8
            ; call writeNum
            ; mov rax, Space
            ; call putc
            ; mov rax, r9
            ; call writeNum
            ; call newLine
            ; call newLine

            push rdx
            push rbx
            push rsi
            mov rax, r8
            mov rbx, [columnSize]
            imul rbx
            add rax, r9
            mov rsi, rax ; index of image

            xor rdx, rdx
            mov rbx, 3
            mov rax, r10
            imul rbx
            add rax, r11
            ; call writeNum
            ; call newLine
            mov rdi, rax ; index of filter


            xor rdx, rdx
            mov bl, [R_buff+rsi]
            and rbx, 0xFF
            mov rax, rbx

            ; call writeNum
            ; call newLine


            mov rax, [r12+rdi*8]

            ; call writeNum
            ; call newLine

            imul rbx

            ; call writeNum
            ; call newLine
            ; call newLine
            ; call newLine

            add qword[rbp-8], rax


            xor rdx, rdx
            mov bl, [G_buff+rsi]
            and rbx, 0xFF
            mov rax, [r12+rdi*8]
            imul rbx
            add qword[rbp-16], rax


            xor rdx, rdx
            mov bl, [B_buff+rsi]
            and rbx, 0xFF
            mov rax, [r12+rdi*8]
            imul rbx
            add  qword[rbp-24], rax


            pop rsi
            pop rbx
            pop rdx

            jmp LOOP2_ComputeConvolution

    end_LOOP1_ComputeConvolution:
        mov r8, qword[rbp+40]
        inc r8
        mov [rbp+40], r8

        ; mov rax, '-'
        ; call putc
        ; call putc
        ; call newLine

        mov rax, [rbp-8]

        push rax
        call normalizeValue
        pop rax 
        ; mov rax, r8
        ; call writeNum
        mov [newR_buff+r8], al
        
        mov rax, [rbp-16]
        push rax
        call normalizeValue
        pop rax 
        mov [newG_buff+r8], al
        ; call writeNum
        ; call newLine

        mov rax, [rbp-24]
        push rax
        call normalizeValue
        pop rax 
        mov [newB_buff+r8], al


        ; mov rax, '-'
        ; call putc
        ; call newLine
    pop rsi
    pop r12
    pop r11
    pop r10
    pop r9
    pop r8
    pop rdx
    pop rcx
    pop rbx
    pop rax
    leave
    ret 24

normalizeValue:
    enter 0,0
    push rax 
    push rbx
    mov rax, [rbp+16]
    
    cmp rax, 0
    jge Reverse
    mov rbx, -1
    imul rbx


    Reverse:
    mov [rbp+16], rax
    ; call writeNum
    ; call newLine

    cmp rax, 255
    jl CheckZero
    mov qword[rbp+16], 255

    CheckZero:
        cmp rax, 0
        jg end_normalizeValue
        mov qword[rbp+16], 0
    
    end_normalizeValue:
    pop rbx
    pop rax
    leave
    ret


ConvolutionFilterComputing:
    push rax
    push r8
    push r9
    push r10
    push r11

    cmp byte[EdgeDetectionFlag], 1
        je UseEdgeDetectionFilter

    cmp byte[SharpeningFlag], 1
        je UseSharpeningFilter

    UseEdgeDetectionFilter:
        mov rax, EdgeDetection_buff
        jmp continue_ConvolutionFilterComputing

    UseSharpeningFilter:
        mov rax, Sharpening_buff

    continue_ConvolutionFilterComputing:
    mov r11, -1 ;index for newbuff
    mov r8, -1
    LOOP1_ConvolutionFilterComputing:
        inc r8
        cmp r8, [MatrixSize]
        jge end_LOOP1_ConvolutionFilterComputing

        push 0
        push r8
        call FindIndexForConvolution
        pop r9 ;column
        pop r10 ;row

        push r11
        push rax
        push r9
        push r10
        call ComputeConvolution
        pop r11
        jmp LOOP1_ConvolutionFilterComputing
        
    end_LOOP1_ConvolutionFilterComputing:
        call CheckZeroPadding
        call CheckStride
        cmp byte[StrideFlag], 1
        je continue_end_LOOP1_ConvolutionFilterComputing
        call PrintAllDimentions

    continue_end_LOOP1_ConvolutionFilterComputing:
    pop r11
    pop r10
    pop r9
    pop r8
    pop rax
    ret


CheckStride:
    push rax
    cmp byte[StrideFlag], 1
    jne end_CheckStride
    mov rax, [StrideSize]
    mov [ResizingScale], rax

    xor rdx, rdx
    mov rbx, rax
    mov rax, [columnSize]
    div rbx

    ; call writeNum
    ; call newLine

    mov [NewcolumnSize], rax

    xor rdx, rdx
    mov rbx, [ResizingScale]
    mov rax, [rowSize]
    div rbx

    ; call writeNum
    ; call newLine

    mov [NewrowSize], rax

    call ResizingMatrix

    end_CheckStride:
    pop rax
    ret


CheckZeroPadding:
    push rax
    push rbx
    push rcx
    push rdx
    push r8
    push r9

    cmp byte[ZeropaddingFlag], 1
        jne ExchangeWithoutPadding
        je ExchangeWithPadding

    ExchangeWithPadding:
        mov r8, -1
        LOOP1_ExchangeWithPadding:
            inc r8
            cmp r8, [MatrixSize]
            jge end_LOOP1_ExchangeWithPadding
            mov al, [newR_buff+r8]
            mov [R_buff+r8], al
            mov byte [newR_buff+r8], 0

            ; and rax, 0xFF
            ; call writeNum
            ; mov rax, ' '
            ; call putc

            mov al, [newG_buff+r8]
            mov [G_buff+r8], al
            mov byte[newG_buff+r8], 0

            mov al, [newB_buff+r8]
            mov [B_buff+r8], al
            mov byte[newB_buff+r8], 0
            jmp LOOP1_ExchangeWithPadding

        end_LOOP1_ExchangeWithPadding:
            jmp end_CheckZeroPadding

    ExchangeWithoutPadding:
        mov r9, -1
        mov r8, -1
        LOOP1_ExchangeWithoutPadding:
            inc r8
            cmp r8, [MatrixSize]
            jge ExchangeWithoutPadding_makeZero_new_buff

            push r8
            push r8
            call FindIndexForConvolution
            pop rbx ; column
            pop rcx ; row

            cmp rbx, 0
            je LOOP1_ExchangeWithoutPadding

            inc rbx 
            cmp rbx, [columnSize]
            je LOOP1_ExchangeWithoutPadding
            
            cmp rcx, 0
            je LOOP1_ExchangeWithoutPadding

            inc rcx 
            cmp rcx, [rowSize]
            jge LOOP1_ExchangeWithoutPadding

            inc r9


            ; mov rax, r8
            ; call writeNum
            ; call newLine
            xor rax,rax
            mov al, [newR_buff+r8]
            mov [R_buff+r9], al
            ; call writeNum
            ; call newLine
            ; call newLine

            mov al, [newG_buff+r8]
            mov [G_buff+r9], al

            mov al, [newB_buff+r8]
            mov [B_buff+r9], al
            jmp LOOP1_ExchangeWithoutPadding
            
        ExchangeWithoutPadding_makeZero_new_buff:

            mov rcx, [MatrixSize]
        LOOP2_ExchangeWithoutPadding:
            mov byte[newG_buff+rcx], 0
            mov byte [newR_buff+rcx], 0
            mov byte[newB_buff+rcx], 0
            loop LOOP2_ExchangeWithoutPadding

            mov rax, [rowSize]
            sub rax, 2
            mov [rowSize], rax

            mov rbx, [columnSize]
            sub rbx, 2
            mov [columnSize], rbx

            mul rbx

            mov [MatrixSize], rax


    end_CheckZeroPadding:
        pop r9
        pop r8
        pop rdx
        pop rcx
        pop rbx
        pop rax
        ret
        


saltAndPepperRandom:
    enter 16,0
    push rax 
    push rbx
    push rcx
    push rdx

    mov rax, [rbp+16] ; percentage
    ; mov rcx, [rbp+24] ; original value
    ; mov rcx, [rbp+24] ; original value
    ; mov rcx, [rbp+24] ; original value

    mov rbx, 2
    div rbx
    mov [rbp-8],rax ; salt range
    mov rbx,100
    sub rbx, rax 
    mov [rbp-16], rbx ; pepper range

    xor rax, rax 
    xor rbx, rbx 

    rdrand rax  

    mov rbx, 100
    xor rdx, rdx 
    div rbx 


    cmp rdx, [rbp-8]
    jge PepperCheck

    mov qword[rbp+24], 0
    mov qword[rbp+32], 0
    mov qword[rbp+40], 0
    jmp end_SaltAndPepper

    PepperCheck:
        cmp rdx, [rbp-16] 
        jle end_SaltAndPepper

        mov qword[rbp+24], 255
        mov qword[rbp+32], 255
        mov qword[rbp+40], 255


    end_SaltAndPepper:
    pop rdx
    pop rcx
    pop rbx
    pop rax

    leave
    ret 8

NoiseSaltAndPepper:
    enter 0,0
    push rax
    push rbx 
    push rcx
    
    mov rax, [rowSize]
    mov rbx, [columnSize]
    mul rbx

    mov rcx, rax


    loopNoiseSaltAndPepper:
        mov bl, [R_buff+rcx-1]
        and rbx, 0xFF
        push rbx

        mov bl, [G_buff+rcx-1]
        and rbx, 0xFF
        push rbx

        mov bl, [B_buff+rcx-1]
        and rbx, 0xFF
        push rbx

        mov rbx, [rbp+16]
        push rbx
        call saltAndPepperRandom

        pop rax
        mov [B_buff+rcx-1], al
        pop rax
        mov [G_buff+rcx-1], al
        pop rax
        mov [R_buff+rcx-1], al

        loop loopNoiseSaltAndPepper

        call PrintAllDimentions


    pop rcx
    pop rbx
    pop rax
    leave
    ret 8



PrintAllDimentions:
    push rax
    push r8

    mov r8, -1
    LOOP1_PrintAllDimentionsR:
        inc r8
        cmp r8, [MatrixSize]
        jge end_LOOP1_PrintAllDimentionsR
        xor rax, rax
        mov al, [R_buff+r8]
        call writeNum
        mov rax, Space
        call putc
        jmp LOOP1_PrintAllDimentionsR

    end_LOOP1_PrintAllDimentionsR:
        call newLine

    cmp byte[flag1D], 1
        je end_PrintAllDimentions

    mov r8, -1
    LOOP1_PrintAllDimentionsG:
        inc r8
        cmp r8, [MatrixSize]
        jge end_LOOP1_PrintAllDimentionsG
        xor rax, rax
        mov al, [G_buff+r8]
        call writeNum
        mov rax, Space
        call putc
        jmp LOOP1_PrintAllDimentionsG

    end_LOOP1_PrintAllDimentionsG:
        call newLine

    cmp byte[flag2D], 1
        je end_PrintAllDimentions

    mov r8, -1
    LOOP1_PrintAllDimentionsB:
        inc r8
        cmp r8, [MatrixSize]
        jge end_LOOP1_PrintAllDimentionsB
        xor rax, rax
        mov al, [B_buff+r8]
        call writeNum
        mov rax, Space
        call putc
        jmp LOOP1_PrintAllDimentionsB

    end_LOOP1_PrintAllDimentionsB:
        call newLine

    end_PrintAllDimentions:

    pop r8
    pop rax
    ret


MaxPoolingComputing:
    enter 0,0
    push rax
    push rbx
    push rcx
    push rdx
    push r8
    push r9
    push r10
    push r11
    push r12
    push rsi
    push rdi

    mov rsi, [rbp+16] ;newR_buff
    mov rdi, [rbp+24] ;R_buff

    mov byte[MaxValue], 0 ;max
    mov rcx, 0 
    mov rbx, -1
    mov r8, 0 ;walking on the rows
    LOOP1_CountingRows_MaxPoolingComputing:
        mov r9, 0 ;walking on the columns
        mov r10, r8 ;walk on the rows of the inside matrix 
        dec r10
        mov rdx, r10
        add r8, [PoolingScale]
        cmp r8, [rowSize]
        jg end_LOOP1_CountingRows_MaxPoolingComputing
        inside1_LOOP1_CountingRows_MaxPoolingComputing:
            mov r11, r9 ;walk on the columns of the inside matrix 
            dec r11
            mov rcx, r11
            add r9, [PoolingScale]
            cmp r9, [columnSize]
            jg LOOP1_CountingRows_MaxPoolingComputing
            inside2_LOOP1_CountingRows_MaxPoolingComputing: 
                inc r10
                cmp r10, r8
                jge Update_Variables_inside_LOOP1_CountingRows_MaxPoolingComputing
                mov r11, rcx
                LOOP2_CountingColumns_MaxPoolingComputing:
                    inc r11
                    cmp r11, r9
                    jge inside2_LOOP1_CountingRows_MaxPoolingComputing

                    push rbx
                    push rdx
                    xor rdx, rdx
                    mov rax, [columnSize]
                    mul r10
                    pop rdx
                    mov rbx, rax
                    add rbx, r11

                    xor rax, rax
                    mov al, [rdi+rbx]
                    pop rbx
                    cmp al, byte[MaxValue]
                    ja Change_Max_Value_LOOP2_CountingColumns_MaxPoolingComputing
                    jmp LOOP2_CountingColumns_MaxPoolingComputing
        
            Update_Variables_inside_LOOP1_CountingRows_MaxPoolingComputing:
                mov byte[flag], 0
                inc rbx
                mov al, byte[MaxValue]
                mov [rsi+rbx], al
                mov byte[MaxValue], 0
                mov r10, rdx
                ; mov r11, -1
                jmp inside1_LOOP1_CountingRows_MaxPoolingComputing

            Change_Max_Value_LOOP2_CountingColumns_MaxPoolingComputing:
                mov byte[MaxValue], al
                jmp LOOP2_CountingColumns_MaxPoolingComputing


    end_LOOP1_CountingRows_MaxPoolingComputing:
        inc rbx


    Exchange_buffers_MaxPoolingComputing:
        mov r8, -1
        LOOP1_Exchange_buffers_MaxPoolingComputing:
            inc r8
            cmp r8, rbx
            jge LOOP2_Exchange_buffers_MaxPoolingComputing
            mov al, [rsi+r8]
            mov [rdi+r8], al
            mov byte[rsi+r8], 0
            jmp LOOP1_Exchange_buffers_MaxPoolingComputing

            LOOP2_Exchange_buffers_MaxPoolingComputing:
                mov byte[rdi+r8], 0
                inc r8
                cmp r8, [MatrixSize]
                jge end_Exchange_buffers_MaxPoolingComputing

        end_Exchange_buffers_MaxPoolingComputing:

    Print_Matrix_MaxPoolingComputing:
        mov r8, -1
        LOOP1_Print_Matrix_MaxPoolingComputing:
            inc r8
            cmp r8, rbx
            jge end_LOOP1_Print_Matrix_MaxPoolingComputing
            mov al, [rdi+r8]
            call writeNum
            mov rax, Space
            call putc
            jmp LOOP1_Print_Matrix_MaxPoolingComputing

        end_LOOP1_Print_Matrix_MaxPoolingComputing:
            call newLine

    pop rdi
    pop rsi
    pop r12
    pop r11
    pop r10
    pop r9
    pop r8
    pop rdx
    pop rcx
    pop rbx
    pop rax
    leave
    ret

AveragePoolingComputing:
    enter 0,0
    push rax
    push rbx
    push rcx
    push rdx
    push r8
    push r9
    push r10
    push r11
    push r12
    push rsi
    push rdi

    mov rsi, [rbp+16] ;newR_buff
    mov rdi, [rbp+24] ;R_buff

    mov byte[SumValue], 0 ;Sum

    mov rax, [NewcolumnSize]
    mov rbx, [NewrowSize]
    mul rbx
    mov [NewMatrixSize], rax

    mov rcx, 0 
    mov rbx, -1
    mov r8, 0 ;walking on the rows
    LOOP1_CountingRows_AveragePoolingComputing:
        mov r9, 0 ;walking on the columns
        mov r10, r8 ;walk on the rows of the inside matrix 
        dec r10
        mov rdx, r10
        ; mov byte[flag], 0
        add r8, [PoolingScale]
        cmp r8, [rowSize]
        jg end_LOOP1_CountingRows_AveragePoolingComputing
        inside1_LOOP1_CountingRows_AveragePoolingComputing:
            mov r11, r9 ;walk on the columns of the inside matrix 
            dec r11
            mov rcx, r11
            add r9, [PoolingScale]
            cmp r9, [columnSize]
            jg LOOP1_CountingRows_AveragePoolingComputing
            inside2_LOOP1_CountingRows_AveragePoolingComputing: 
                inc r10
                cmp r10, r8
                jge Update_Variables_inside_LOOP1_CountingRows_AveragePoolingComputing
                mov r11, rcx
                mov qword[SumValue], 0
                LOOP2_CountingColumns_AveragePoolingComputing:
                    inc r11
                    cmp r11, r9
                    jge inside2_LOOP1_CountingRows_AveragePoolingComputing

                    push rbx
                    push rdx
                    xor rdx, rdx
                    mov rax, [columnSize]
                    mul r10
                    ; call writeNum
                    ; call newLine
                    pop rdx
                    mov rbx, rax
                    add rbx, r11

                    xor rax, rax
                    mov al, [rdi+rbx]
                    pop rbx
                    and rax, 0xFF
                    add qword[SumValue], rax
                    jmp LOOP2_CountingColumns_AveragePoolingComputing
        
            Update_Variables_inside_LOOP1_CountingRows_AveragePoolingComputing:
                mov byte[flag], 0
                inc rbx
                push rdx
                mov rax, qword[SumValue]
                xor rdx, rdx
                div qword[NewMatrixSize]
                pop rdx
                mov [rsi+rbx], al
                mov qword[SumValue], 0 ;Sum
                mov r10, rdx
                jmp inside1_LOOP1_CountingRows_AveragePoolingComputing

            ; Change_Max_Value_LOOP2_CountingColumns_AveragePoolingComputing:
            ;     mov byte[MaxValue], al
            ;     jmp LOOP2_CountingColumns_AveragePoolingComputing

    end_LOOP1_CountingRows_AveragePoolingComputing:
        inc rbx

    Exchange_buffers_AveragePoolingComputing:
        mov r8, -1
        LOOP1_Exchange_buffers_AveragePoolingComputing:
            inc r8
            cmp r8, rbx
            jge LOOP2_Exchange_buffers_AveragePoolingComputing
            mov al, [rsi+r8]
            mov [rdi+r8], al
            mov byte[rsi+r8], 0
            jmp LOOP1_Exchange_buffers_AveragePoolingComputing

            LOOP2_Exchange_buffers_AveragePoolingComputing:
                mov byte[rdi+r8], 0
                inc r8
                cmp r8, [MatrixSize]
                jge end_Exchange_buffers_AveragePoolingComputing

        end_Exchange_buffers_AveragePoolingComputing:


    Print_Matrix_AveragePoolingComputing:
        mov r8, -1
        LOOP1_Print_Matrix_AveragePoolingComputing:
            inc r8
            cmp r8, rbx
            jge end_LOOP1_Print_Matrix_AveragePoolingComputing
            mov al, [rdi+r8]
            call writeNum
            mov rax, Space
            call putc
            jmp LOOP1_Print_Matrix_AveragePoolingComputing

        end_LOOP1_Print_Matrix_AveragePoolingComputing:
            call newLine
           
    pop rdi
    pop rsi
    pop r12
    pop r11
    pop r10
    pop r9
    pop r8
    pop rdx
    pop rcx
    pop rbx
    pop rax
    leave
    ret



ResizingMatrix:
    push rax
    push rbx
    push r8
    push r9
    push r10
    push r11
    push r12

    mov r8, 0
    mov r9, -1
    LOOP1_ResizingMatrix:
        mov r10, 0
        cmp r8, 0
        je inside_LOOP1_ResizingMatrix

        mov rbx, [ResizingScale]
        dec rbx 
        mov rax, [columnSize]
        mul rbx
        add r8, rax
        xor rax, rax
        xor rdx, rdx
        cmp r8, [MatrixSize]
        jge end_LOOP1_ResizingMatrix

        inside_LOOP1_ResizingMatrix:
            cmp r10, [columnSize]
            jge LOOP1_ResizingMatrix

            mov al, [R_buff+r8]
            mov r11, [G_buff+r8]
            mov r12, [B_buff+r8]

            inc r9
            mov [newR_buff+r9], al
            mov [newG_buff+r9], r11
            mov [newB_buff+r9], r12

            add r8, [ResizingScale]
            add r10, [ResizingScale]
            jmp inside_LOOP1_ResizingMatrix
        
        end_LOOP1_ResizingMatrix:

    Exchange_buffers_ResizingMatrix:
        inc r9
        mov rax, [NewcolumnSize]
        mov [columnSize], rax

        mov rax, [NewrowSize]
        mov [rowSize], rax

        mov r8, -1
        LOOP2_Exchange_buffers_ResizingMatrix:
            inc r8
            cmp r8, r9
            jge LOOP3_Exchange_buffers_ResizingMatrix

            mov al, [newR_buff+r8]
            mov r11, [newG_buff+r8]
            mov r12, [newB_buff+r8]

            mov [R_buff+r8], al
            mov [G_buff+r8], r11
            mov [B_buff+r8], r12

            mov byte[newR_buff+r8], 0
            mov byte[newG_buff+r8], 0
            mov byte[newB_buff+r8], 0

            jmp LOOP2_Exchange_buffers_ResizingMatrix

        LOOP3_Exchange_buffers_ResizingMatrix:
            cmp r8, [MatrixSize]
            jge end_Exchange_buffers_ResizingMatrix

            mov byte[R_buff+r8], 0
            mov byte[G_buff+r8], 0
            mov byte[B_buff+r8], 0

            inc r8
            jmp LOOP3_Exchange_buffers_ResizingMatrix

        end_Exchange_buffers_ResizingMatrix:
            mov [MatrixSize], r9

        call PrintAllDimentions

    pop r12
    pop r11
    pop r10
    pop r9
    pop r8
    pop rbx
    pop rax
    
    ret



ReshapeMatrix:
    enter 0,0
    push rax
    push r8

    mov rax, [rbp+16]

    mov r8, -1
    LOOP1_ReshapeMatrix:
        inc r8
        cmp r8, [MatrixSize]
        jge end_LOOP1_ReshapeMatrix
        mov byte[rax+r8], 0
        jmp LOOP1_ReshapeMatrix

    end_LOOP1_ReshapeMatrix:

    pop r8
    pop rax
    leave
    ret 8


OpeningRGB:
    push rax
    push rbx
    push rcx
    push rdx
    push r8
    push r9
    push r10

    mov r8, 22
    mov rcx,0 ;sum
    mov byte[flag], 0
    LOOP1_Find_shape:
        inc r8
        mov al, [buff+r8]
        and rax, 0xFF
        mov byte[buff+r8], 0

        cmp rax, Space
        je check_LOOP1_Find_shap

        cmp rax, 10
        je end_LOOP1_Find_shap

        push rax
        mov rbx, 10
        mov rax, rcx
        mul rbx
        mov rcx, rax
        pop rax

        sub rax, 48

        add rcx, rax

        xor rdx, rdx
        xor rax, rax
        jmp LOOP1_Find_shape

        check_LOOP1_Find_shap:
            cmp byte[flag], 1
            je end_LOOP1_Find_shap
            mov byte[flag], 1
            mov [rowSize], rcx
            mov rcx, 0
            jmp LOOP1_Find_shape

        end_LOOP1_Find_shap:
            mov [columnSize], rcx

        Print_Matrix_shape:
            mov rax, [rowSize]
            call writeNum
            mov rax, Space
            call putc
            mov rax, [columnSize]
            call writeNum
            call newLine

    mov rax, [rowSize]
    mov rbx, [columnSize]
    mul rbx
    mov qword[MatrixSize], rax
    xor rax, rax
    xor rdx, rdx

    ; print R matrix
    add r8, 10
    mov r9, -1
    mov rcx, 0 ;sum
    LOOP2_R_Matrix:
        inc r8

        mov al, [buff+r8]
        and rax, 0xFF
        mov byte[buff+r8], 0

        cmp rax, Space
        je check_LOOP2_R_Matrix

        cmp rax, 10
        je end_LOOP2_R_Matrix

        push rax
        mov rbx, 10
        mov rax, rcx
        mul rbx
        mov rcx, rax
        pop rax

        sub rax, 48
        add rcx, rax
        xor rdx, rdx
        xor rax, rax
        jmp LOOP2_R_Matrix

        check_LOOP2_R_Matrix:
            inc r9
            ; mov rax, rcx
            ; call writeNum
            ; call newLine
            mov byte[R_buff+r9], cl
            mov rcx, 0
            jmp LOOP2_R_Matrix

        end_LOOP2_R_Matrix:

        mov r10, -1
        Print_R_Matrix:
            inc r10
            cmp r10, r9
            jg end_Print_R_Matrix
            mov al, [R_buff+r10]
            and rax, 0xFF
            call writeNum
            mov rax, Space
            call putc
            jmp Print_R_Matrix

            end_Print_R_Matrix:
            call newLine
            call newLine



    ; pring G matrix
    add r8, 10
    mov r9, -1
    mov rcx, 0 ;sum
    LOOP3_G_Matrix:
        inc r8

        mov al, [buff+r8]
        and rax, 0xFF
        mov byte[buff+r8], 0

        cmp rax, Space
        je check_LOOP3_G_Matrix

        cmp rax, 10
        je end_LOOP3_G_Matrix

        push rax
        mov rbx, 10
        mov rax, rcx
        mul rbx
        mov rcx, rax
        pop rax

        sub rax, 48
        add rcx, rax
        xor rdx, rdx
        xor rax, rax
        jmp LOOP3_G_Matrix

        check_LOOP3_G_Matrix:
            inc r9
            ; mov rax, rcx
            ; call writeNum
            ; call newLine
            mov byte[G_buff+r9], cl
            mov rcx, 0
            jmp LOOP3_G_Matrix

        end_LOOP3_G_Matrix:

        mov r10, -1
        Print_G_Matrix:
            inc r10
            cmp r10, r9
            jg end_Print_G_Matrix
            mov al, [G_buff+r10]
            and rax, 0xFF
            call writeNum
            mov rax, Space
            call putc
            jmp Print_G_Matrix

            end_Print_G_Matrix:
            call newLine
            call newLine


    ; print B matrix
    add r8, 10
    mov r9, -1
    mov rcx, 0 ;sum
    LOOP4_B_Matrix:
        inc r8
        ; mov rax, r8
        ; call writeNum
        ; call newLine

        mov al, [buff+r8]
        and rax, 0xFF
        mov byte[buff+r8], 0

        cmp rax, Space
        je check_LOOP4_B_Matrix

        cmp rax, 36
        je end_LOOP4_B_Matrix

        push rax
        mov rbx, 10
        mov rax, rcx
        mul rbx
        mov rcx, rax
        pop rax

        sub rax, 48
        add rcx, rax
        xor rdx, rdx
        xor rax, rax
        jmp LOOP4_B_Matrix

        check_LOOP4_B_Matrix:
            inc r9
            ; mov rax, rcx
            ; call writeNum
            ; call newLine
            mov byte[B_buff+r9], cl
            mov rcx, 0
            jmp LOOP4_B_Matrix

        end_LOOP4_B_Matrix:

        mov r10, -1
        Print_B_Matrix:
            inc r10
            cmp r10, r9
            jg end_Print_B_Matrix
            mov al, [B_buff+r10]
            and rax, 0xFF
            call writeNum
            mov rax, Space
            call putc
            jmp Print_B_Matrix

            end_Print_B_Matrix:

    call newLine

    pop r10
    pop r9
    pop r8
    pop rdx
    pop rcx
    pop rbx
    pop rax
    ret

    
Exit:
    mov rax, sys_exit
    xor rdi, rdi
    syscall
























































































; ===============================================
; ===============================================
; ================= includes ====================
; ===============================================
; ===============================================


    sys_read     equ     0
    sys_write    equ     1
    sys_open     equ     2
    sys_close    equ     3
    
    sys_lseek    equ     8
    sys_create   equ     85
    sys_unlink   equ     87
      

    sys_mkdir       equ 83
    sys_makenewdir  equ 0q777


    sys_mmap     equ     9
    sys_mumap    equ     11
    sys_brk      equ     12
    
     
    sys_exit     equ     60
    
    stdin        equ     0
    stdout       equ     1
    stderr       equ     3

 
    PROT_NONE      equ   0x0
    PROT_READ     equ   0x1
    PROT_WRITE    equ   0x2
    MAP_PRIVATE   equ   0x2
    MAP_ANONYMOUS equ   0x20
    
    ;access mode
    O_DIRECTORY equ     0q0200000
    O_RDONLY    equ     0q000000
    O_WRONLY    equ     0q000001
    O_RDWR      equ     0q000002
    O_CREAT     equ     0q000100
    O_APPEND    equ     0q002000


    BEG_FILE_POS    equ     0
    CURR_POS        equ     1
    END_FILE_POS    equ     2
    
; create permission mode
    sys_IRUSR     equ     0q400      ; user read permission
    sys_IWUSR     equ     0q200      ; user write permission

    NL            equ   0xA
    Space         equ   0x20

;----------------------------------------------------
;----------------------------------------------------
newLine:
   push   rax
   mov    rax, NL
   call   putc
   pop    rax
   ret
;---------------------------------------------------------
putc:    

   push   rcx
   push   rdx
   push   rsi
   push   rdi 
   push   r11 

   push   ax
   mov    rsi, rsp    ; points to our char
   mov    rdx, 1      ; how many characters to print
   mov    rax, sys_write
   mov    rdi, stdout 
   syscall
   pop    ax

   pop    r11
   pop    rdi
   pop    rsi
   pop    rdx
   pop    rcx
   ret
;---------------------------------------------------------
writeNum:
   push   rax
   push   rbx
   push   rcx
   push   rdx

   sub    rdx, rdx
   mov    rbx, 10 
   sub    rcx, rcx
   cmp    rax, 0
   jge    wAgain
   push   rax 
   mov    al, '-'
   call   putc
   pop    rax
   neg    rax  

wAgain:
   cmp    rax, 9    
   jle    cEnd
   div    rbx
   push   rdx
   inc    rcx
   sub    rdx, rdx
   jmp    wAgain

cEnd:
   add    al, 0x30
   call   putc
   dec    rcx
   jl     wEnd
   pop    rax
   jmp    cEnd
wEnd:
   pop    rdx
   pop    rcx
   pop    rbx
   pop    rax
   ret

;---------------------------------------------------------
getc:
   push   rcx
   push   rdx
   push   rsi
   push   rdi 
   push   r11 

 
   sub    rsp, 1
   mov    rsi, rsp
   mov    rdx, 1
   mov    rax, sys_read
   mov    rdi, stdin
   syscall
   mov    al, [rsi]
   add    rsp, 1

   pop    r11
   pop    rdi
   pop    rsi
   pop    rdx
   pop    rcx

   ret
;---------------------------------------------------------

readNum:
   push   rcx
   push   rbx
   push   rdx

   mov    bl,0
   mov    rdx, 0
rAgain:
   xor    rax, rax
   call   getc
   cmp    al, '-'
   jne    sAgain
   mov    bl,1  
   jmp    rAgain
sAgain:
   cmp    al, NL
   je     rEnd
   cmp    al, ' ' ;Space
   je     rEnd
   sub    rax, 0x30
   imul   rdx, 10
   add    rdx,  rax
   xor    rax, rax
   call   getc
   jmp    sAgain
rEnd:
   mov    rax, rdx 
   cmp    bl, 0
   je     sEnd
   neg    rax 
sEnd:  
   pop    rdx
   pop    rbx
   pop    rcx
   ret

;-------------------------------------------
printString:
   push    rax
   push    rcx
   push    rsi
   push    rdx
   push    rdi

   mov     rdi, rsi
   call    GetStrlen
   mov     rax, sys_write  
   mov     rdi, stdout
   syscall 
   
   pop     rdi
   pop     rdx
   pop     rsi
   pop     rcx
   pop     rax
   ret
;-------------------------------------------
; rdi : zero terminated string start 
GetStrlen:
   push    rbx
   push    rcx
   push    rax  

   xor     rcx, rcx
   not     rcx
   xor     rax, rax
   cld
         repne   scasb
   not     rcx
   lea     rdx, [rcx -1]  ; length in rdx

   pop     rax
   pop     rcx
   pop     rbx
   ret
;-------------------------------------------
;----------------------------------------------------
section     .fileIOMessages
    error_create        db      'error in creating file             ', NL, 0
    error_close         db      'error in closing file              ', NL, 0
    error_write         db      'error in writing file              ', NL, 0
    error_open          db      'error in opening file              ', NL, 0
    error_open_dir      db      'error in opening dir               ', NL, 0
    error_append        db      'error in appending file            ', NL, 0
    error_delete        db      'error in deleting file             ', NL, 0
    error_read          db      'error in reading file              ', NL, 0
    error_print         db      'error in printing file             ', NL, 0
    error_seek          db      'error in seeking file              ', NL, 0
    error_create_dir    db      'error in creating directory        ', NL, 0
    suces_create        db      'file created and opened for R/W    ', NL, 0
    suces_create_dir    db      'dir created and opened for R/W     ', NL, 0
    suces_close         db      'file closed                        ', NL, 0
    suces_write         db      'written to file                    ', NL, 0
    suces_open          db      'file opend for R/W                 ', NL, 0
    suces_open_dir      db      'dir opened for R/W                 ', NL, 0
    suces_append        db      'file opened for appending          ', NL, 0
    suces_delete        db      'file deleted                       ', NL, 0
    suces_read          db      'reading file                       ', NL, 0
    suces_seek          db      'seeking file                       ', NL, 0


section .text


;----------------------------------------------------
; rdi : file name; rsi : file permission
createFile:
    mov     rax, sys_create
    mov     rsi, sys_IRUSR | sys_IWUSR 
    syscall
    cmp     rax, -1   ; file descriptor in rax
    jle     createerror
    mov     rsi, suces_create           
    call    printString
    ret
createerror:
    mov     rsi, error_create
    call    printString
    ret

;----------------------------------------------------
; rdi : file name; rsi : file access mode 
; rdx: file permission, do not need
openFile:
    mov     rax, sys_open
    mov     rsi, O_RDWR     
    syscall
    cmp     rax, -1   ; file descriptor in rax
    jle     openerror
    mov     rsi, suces_open
    call    printString
    ret
openerror:
    mov     rsi, error_open
    call    printString
    ret
;----------------------------------------------------
; rdi point to file name
appendFile:
    mov     rax, sys_open
    mov     rsi, O_RDWR | O_APPEND
    syscall
    cmp     rax, -1     ; file descriptor in rax
    jle     appenderror
    mov     rsi, suces_append
    call    printString
    ret
appenderror:
    mov     rsi, error_append
    call    printString
    ret
;----------------------------------------------------
; rdi : file descriptor ; rsi : buffer ; rdx : length
writeFile:
    mov     rax, sys_write
    syscall
    cmp     rax, -1         ; number of written byte
    jle     writeerror
    mov     rsi, suces_write
    call    printString
    ret
writeerror:
    mov     rsi, error_write
    call    printString
    ret
;----------------------------------------------------
; rdi : file descriptor ; rsi : buffer ; rdx : length
readFile:
    mov     rax, sys_read
    syscall
    cmp     rax, -1           ; number of read byte
    jle     readerror
    ; mov     byte [rsi+rax], 0 ; add a  zero ??????????????
    mov     rsi, suces_read
    call    printString
    ret
readerror:
    mov     rsi, error_read
    call    printString
    ret
;----------------------------------------------------
; rdi : file descriptor
closeFile:
    mov     rax, sys_close
    syscall
    cmp     rax, -1      ; 0 successful
    jle     closeerror
    mov     rsi, suces_close
    call    printString
    ret
closeerror:
    mov     rsi, error_close
    call    printString
    ret

;----------------------------------------------------
; rdi : file name
deleteFile:
    mov     rax, sys_unlink
    syscall
    cmp     rax, -1      ; 0 successful
    jle     deleterror
    mov     rsi, suces_delete
    call    printString
    ret
deleterror:
    mov     rsi, error_delete
    call    printString
    ret
;----------------------------------------------------
; rdi : file descriptor ; rsi: offset ; rdx : whence
seekFile:
    mov     rax, sys_lseek
    syscall
    cmp     rax, -1
    jle     seekerror
    mov     rsi, suces_seek
    call    printString
    ret
seekerror:
    mov     rsi, error_seek
    call    printString
    ret

;----------------------------------------------------

