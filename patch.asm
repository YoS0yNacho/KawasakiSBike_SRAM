
; Overrides: ---------------------------------------------------------------------------------
    ;Credit
    org $180
    dc.b   'YoSoyNacho'

    ;SRAM TYPE AND ADDRESS
    org $1B0
    dc.w   $5241, $f820, $0020, $0001, $0020, $3fff ;( "RA",F8h,20h )(00200001)(00203fff)

    ;menu password to load game
    org $E1F55
    dc.b '___LOAD_GAME____'

    ;remember your password to game saved
    org $E1EE9
    dc.b '______GAME__SAVED_____'

    ;Enable SRAM writing
    org $256
    jsr ENABLE_SRAM

    ;remove pword ram writing    
    org $dcaa8
    nop
    nop
    nop
    nop

    ;copy password from SRAM
    org $dd656
    jsr LOAD_SRAM

    ;bypass type password screen
    org $de4f4
    nop

    org $dd6b0
    nop
    nop

    ;save password
    org $df0b2
    jsr SAVE_SRAM

    ;remove password from result screen
    org $dd61a
    nop
    nop
    
; Detours: -----------------------------------------------------------------------------------
    org $ff870
ENABLE_SRAM:
    move.b     #1,($A130F1).l ; enable SRAM writing
    move.w     D0,(A2)
    move.w     D0,(A1)
    move.w     D7,(A2)
    rts

LOAD_SRAM:
    lea     ($ffe939).l,a5   ; Beginning of data
    lea     ($200001).l,a1  ; Beginning of SRAM  
    move.w  #$25,d0  ; Number of bytes
    move.b  #$20,(a5)      ; save header
    addq.l  #1,a5          ; Advance data byte
Loop:
    move.b  (a1),(a5)       ; Write byte to RAM
    addq.l  #1,a5           ; Advance data byte
    addq.l  #2,a1           ; Advance SRAM byte
    dbf     d0,Loop         ; Keep going
    lea     ($000dea68).l,A1
    rts

SAVE_SRAM:
    lea     ($ffe860).l,a2   ; Beginning of data
    lea     ($200001).l,a1  ; Beginning of SRAM  
    move.w  #$1F,d0  ; Number of bytes
Loop2:
    move.b  (a2),(a1)       ; Write byte to SRAM
    addq.l  #1,a2           ; Advance data byte
    addq.l  #2,a1           ; Advance SRAM byte
    dbf     d0,Loop2         ; Keep going
    lea     ($000df54a).l,a1 
    rts




