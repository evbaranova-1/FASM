format PE GUI

include 'win32ax.inc'

.data

    ;First line segment
    a1_x dd 0
    a1_y dd 1
    b1_x dd 1
    b1_y dd 0

    ;Second line segment
    a2_x dd 1
    a2_y dd 0
    b2_x dd 0
    b2_y dd -1

    ;Third line segment
    a3_x dd 0
    a3_y dd -1
    b3_x dd -1
    b3_y dd 0

    ;Fourth line segment
    a4_x dd -1
    a4_y dd 0
    b4_x dd 0
    b4_y dd 1

    ;First vector
    v1_x dd 0
    v1_y dd 0

    ;Second vector
    v2_x dd 0
    v2_y dd 0

    ;Third vector
    v3_x dd 0
    v3_y dd 0

    ;Fourth vector
    v4_x dd 0
    v4_y dd 0

    ;Perpendicularity flags
    p12 dd 0
    p13 dd 0
    p14 dd 0
    p23 dd 0
    p24 dd 0
    p34 dd 0

    ;Title string
    title db 'Perpendicular line segments', 0

    ;Output format string
    output_format db 'Line segments:', 10, '(%d;%d),(%d;%d)', 10, '(%d;%d),(%d;%d)', 10, '(%d;%d),(%d;%d)', 10, '(%d;%d),(%d;%d)', 10, 10, 'Perpendicularity:', 10, '1-2: %d', 10, '1-3: %d', 10, '1-4: %d', 10, '2-3: %d', 10, '2-4: %d', 10, '3-4: %d', 0

    ;Output string
    output db 256 dup(?)

.code

start:

    ;Calculate the first vector
    mov eax, [b1_x]
    sub eax, [a1_x]
    mov [v1_x], eax

    mov eax, [b1_y]
    sub eax, [a1_y]
    mov [v1_y], eax

    ;Calculate the second vector
    mov eax, [b2_x]
    sub eax, [a2_x]
    mov [v2_x], eax

    mov eax, [b2_y]
    sub eax, [a2_y]
    mov [v2_y], eax

    ;Calculate the third vector
    mov eax, [b3_x]
    sub eax, [a3_x]
    mov [v3_x], eax

    mov eax, [b3_y]
    sub eax, [a3_y]
    mov [v3_y], eax

    ;Calculate the fourth vector
    mov eax, [b4_x]
    sub eax, [a4_x]
    mov [v4_x], eax

    mov eax, [b4_y]
    sub eax, [a4_y]
    mov [v4_y], eax

    ;Find wheather the first and the second vectors are perpendicular
    push [v1_x]
    push [v1_y]
    push [v2_x]
    push [v2_y]

    call is_perpendicular

    mov [p12], eax

    ;Find wheather the first and the third vectors are perpendicular
    push [v1_x]
    push [v1_y]
    push [v3_x]
    push [v3_y]

    call is_perpendicular

    mov [p13], eax

    ;Find wheather the first and the fourth vectors are perpendicular
    push [v1_x]
    push [v1_y]
    push [v4_x]
    push [v4_y]

    call is_perpendicular

    mov [p14], eax

    ;Find wheather the second and the third vectors are perpendicular
    push [v2_x]
    push [v2_y]
    push [v3_x]
    push [v3_y]

    call is_perpendicular

    mov [p23], eax

    ;Find wheather the second and the fourth vectors are perpendicular
    push [v2_x]
    push [v2_y]
    push [v4_x]
    push [v4_y]

    call is_perpendicular

    mov [p24], eax

    ;Find wheather the third and the fourth vectors are perpendicular
    push [v3_x]
    push [v3_y]
    push [v4_x]
    push [v4_y]

    call is_perpendicular

    mov [p34], eax

    ;Format the output
    cinvoke wsprintf, output, output_format, [a1_x], [a1_y], [b1_x], [b1_y], [a2_x], [a2_y], [b2_x], [b2_y], [a3_x], [a3_y], [b3_x], [b3_y], [a4_x], [a4_y], [b4_x], [b4_y], [p12], [p13], [p14], [p23], [p24], [p34]

    ;Create the output window
    invoke MessageBox, 0, output, title, 0

    ;Exit the program
    invoke ExitProcess, 0

.end start

;Calculates a dot product of two vectors
;Call convention - stdcall
;Used registers - EAX, EBX
;Parameters - coordinates of two vectors on the stack
;Return value - a dot product of two vectors in the EAX register
proc dot

    mov eax, [esp + 16]

    imul eax, [esp + 8]

    mov ebx, eax

    mov eax, [esp + 12]

    imul eax, [esp + 4]

    add eax, ebx

    ret 16

endp

;Finds wheather two vectors are perpendicular
;Call convention - stdcall
;Used registers - EAX, EBX
;Parameters - coordinates of two vectors on the stack
;Return value - 1 if two vectors are perpendicular or 0 in the EAX register
proc is_perpendicular

    mov eax, esp

    push dword [eax + 16]
    push dword [eax + 12]
    push dword [eax + 8]
    push dword [eax + 4]

    call dot

    cmp eax, 0

    je perpendicular

    not_perpendicular:

    mov eax, 0

    ret 16

    perpendicular:

    mov eax, 1

    ret 16

endp