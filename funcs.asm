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

;=====================================================
; Cmp first and second pieces of mem
; Entry:     di - & of start pos in first
;            si - & of start pos in second
;            cx - number of comparing bytes
; Exit:      ax is first ne char1 - first ne char2
; Destr:     cx, di
;=====================================================

Memcmp          macro
                
                cld
                repe cmpsb
                jne @@Notequ
@@Equ:          xor ax, ax

                ret
                endp                          ; return

@@Notequ:       dec si
                dec di
                mov ax, [si]
                sub ax, [di]

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
                ;call Strprnt
                Memchr

                mov ah, 02h    
                mov dl, [di]
                int 21h    
                ;mov dl, [si]
                ;int 21h    

                ret                           ; return 0

;=====================================================
; Find first char = al
; Entry:     di - & of first byte of string
;            al - char to find
; Exit:      di is & of finding char
; Destr:    
;=====================================================

Strchr          proc
                
                dec di                        ; --di
@@Until_nch:    inc di                        ; ++di
                cmp byte ptr [di], al         ;
                jne @@Until_nch               ; if ([di] != al) {goto @@Until_nch}

                ret
                endp

;=====================================================
; Find last char = al
; Entry:     di - & of first byte of string
;            al - char to find
; Exit:      si is & of finding char
; Destr:     di
;=====================================================

Strrchr         proc
                
                dec di                        ; --di
@@Until_nch:    inc di                        ; ++di
                cmp byte ptr [di], al         ;
                je @@Take_it
                jmp @@Dont_take                

@@Take_it:      mov si, di                    ; si = di
                jmp @@Dont_take    

@@Dont_take:    cmp byte ptr [di], 0h         ;
                jne @@Until_nch               ; if ([di] != 0h) {goto @@Until_nch}

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
