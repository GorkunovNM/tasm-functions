locals @@
.model tiny
.code
org 100h

;----------------------MACRO_BOX----------------------
;=====================================================
; Find byte in mem
; Entry:     di - & of start pos
;            al - byte to find
;            cx - number of bytes in piece of mem
; Exit:      di - & of finding byte
; Destr:     cx
;=====================================================

Memchr          macro

                cld
                repne scasb

                endm

;=====================================================
; Fill byte in mem
; Entry:     di - & of start pos
;            al - byte to fill
;            cx - number of filling bytes
; Exit:      
; Destr:     cx, di
;=====================================================

Memset          macro
                
                cld
                rep stosb

                endm

;=====================================================
; Copy piece of mem from source to destination
; Entry:     si - & of start pos in source
;            di - & of start pos in destination
;            cx - number of filling bytes
; Exit:        
; Destr:     cx, di, si
;=====================================================

Memcpy          macro
                
                cld
                rep movsb

                endm
;-----------------------------------------------------

Start:          mov al, 'l'
                mov dl, '!'
                mov cx, 16
                mov si, offset Msg2
                mov di, offset Msg
                ;push di
                ;call Memcmp
                ;pop di
                ;call Strchr
                ;call Strrchr
                ;call Strcpy
                ;mov di, si
                ;call Strprnt
                ;Memchr
                ;call Strlen

                mov ah, 02h    
                mov dl, [di]
                int 21h    
                ;mov dl, [si]
                ;int 21h    

                ret                           ; return 0

;=====================================================
; Cmp first and second pieces of mem
; Entry:     di - & of start pos in first
;            si - & of start pos in second
;            cx - number of comparing bytes
; Exit:      ax is first !equ char1 - first !equ char2
;                            (=0 if equ, != 0 if !equ)
; Destr:     cx, di
;=====================================================

Memcmp          proc
                
                cld
                repe cmpsb
                jne @@Notequ
@@Equ:          xor ax, ax

                ret                           ; return

@@Notequ:       dec si
                dec di
                mov ax, [si]
                sub ax, [di]

                ret
                endp                          ; return

;=====================================================
; Returns length of string
; Entry:     di - & of first byte of string
; Exit:      cx - length of string
; Destr:     al, di
;=====================================================

Strlen          proc
                
                xor cx, cx
                dec cx
                xor al, al
                cld
                repne scasb
                not cx
                dec cx

                ret
                endp

;=====================================================
; Find first char = ah
; Entry:     si - & of first byte of string
;            ah - char to find
; Exit:      si is & of finding char or 0, if !found
; Destr:     al, cx
;=====================================================

Strchr          proc
                
                xor cx, cx
                dec cx

@@Loop:         cld
                lodsb
                cmp al, ah
                je @@Ret
                cmp al, 0h
                je @@E404
                loop @@Loop

@@E404:         xor si, si

@@Ret:          ret
                endp

;=====================================================
; Find last char = ah
; Entry:     si - & of first byte of string
;            ah - char to find
; Exit:      di is & of finding char or 0, if !found
; Destr:     al, cx, si
;=====================================================

Strrchr         proc
                
                xor cx, cx
                dec cx
                xor di, di

@@Saved:        mov di, si

@@Loop:         cld
                lodsb
                cmp al, ah
                je @@Saved
                cmp al, 0h
                je @@Ret
                loop @@Loop

@@Ret:          ret
                endp

;=====================================================
; Copy second string to first
; Entry:     si - & of first byte of first string
;            di - & of first byte of second string
; Exit:      
; Destr:     si, di, cx, ax, bx
;=====================================================

Strcpy          proc
                
                mov ax, si
                mov bx, di
                call Strlen
                mov di, ax
                mov si, bx
                cld
                rep movsb

                ret
                endp

;=====================================================
; Compare second string with first
; Entry:     si - & of first byte of first string
;            di - & of first byte of second string
; Exit:      
; Destr:     si, di, cx, ax
;=====================================================

Strcmp          proc
                
                mov ax, di
                call Strlen
                mov di, ax
                cld
                repe cmpsb

                ret
                endp

;=====================================================
; Print string
; Entry:     di - & of first byte of string
; Exit:      di is & of end of string
; Destr:     dl, ah
;=====================================================

Strprnt         proc
                
                mov ah, 02h                   ; ah = 2
@@Until:        mov dl, [di]                  ; dl = [di]
                int 21h                       ; putc (dl)
                inc di                        ; di++
                cmp byte ptr [di], 00h 
                jne @@Until                   ; if ([di] != '\0') {goto @@Until}

                ret
                endp

Msg:            db 'Hello, world!!!', 00h     ; "Hello, World!!!\0"

Msg2:           db 'Hello, new day!', 00h     ; "Hello, new day!\0"

end Start
