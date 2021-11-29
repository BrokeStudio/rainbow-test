.feature c_comments
.feature force_range
.linecont +

/*
                                                                          
88                                            88                          
88                                            88                          
88                                            88                          
88,dPPYba,    ,adPPYba,  ,adPPYYba,   ,adPPYb,88   ,adPPYba,  8b,dPPYba,  
88P'    "8a  a8P_____88  ""     `Y8  a8"    `Y88  a8P_____88  88P'   "Y8  
88       88  8PP"""""""  ,adPPPPP88  8b       88  8PP"""""""  88          
88       88  "8b,   ,aa  88,    ,88  "8a,   ,d88  "8b,   ,aa  88          
88       88   `"Ybbd8"'  `"8bbdP"Y8   `"8bbdP"Y8   `"Ybbd8"'  88          
                                                                          
                                                                          
*/
.segment "HEADER"
.import NES_MAPPER
.import NES_PRG_BANKS,NES_CHR_BANKS,NES_MIRRORING

.define RNBW_CHR_ROM      0 ; CHR-ROM only
.define RNBW_CHR_RAM      1 ; CHR-RAM only
.define RNBW_CHR_ROM_RAM  2 ; CHR-ROM + CHR-RAM

.ifndef CHR_CHIPS
  .warning "CHR_CHIPS not defined, using default value (2) : CHR-ROM+CHR-RAM"
  CHR_CHIPS = RNBW_CHR_ROM_RAM
.endif

.if CHR_CHIPS = RNBW_CHR_ROM
  .out "# Building CHR-ROM version"
.endif

.if CHR_CHIPS = RNBW_CHR_RAM
  .out "# Building CHR-RAM version"
.endif

.if CHR_CHIPS = RNBW_CHR_ROM_RAM
  .out "# Building CHR-ROM + CHR-RAM version"
.endif

.out "#"

; NES 2.0 format
.byte $4E,$45,$53,$1A   ; 'NES' + $1A
.byte <NES_PRG_BANKS
.if CHR_CHIPS = RNBW_CHR_RAM
  .byte 0
.else
  .byte <NES_CHR_BANKS
.endif
.byte <(NES_MIRRORING|(NES_MAPPER&$0F)<<4) ;|%00000010 ; (battery)
.byte <((NES_MAPPER&$F0)|%00001000) ; upper nybble of mapper number + iNES 2.0
.byte <((NES_MAPPER&$F00)>>8)
.byte $00
.byte 9 ; PRG-RAM shift counter - (64 << shift counter)
.if CHR_CHIPS <> RNBW_CHR_ROM
  .byte 9 ; CHR-RAM shift counter - (64 << shift counter)
.else
  .byte 0
.endif
.byte $01 ; PAL TIMING
.byte $00, $00, $00 ; padding

/*
                                                                                                  
                                                                                                  
                                                                                                  
                                                                                                  
888888888   ,adPPYba,  8b,dPPYba,   ,adPPYba,   8b,dPPYba,   ,adPPYYba,   ,adPPYb,d8   ,adPPYba,  
     a8P"  a8P_____88  88P'   "Y8  a8"     "8a  88P'    "8a  ""     `Y8  a8"    `Y88  a8P_____88  
  ,d8P'    8PP"""""""  88          8b       d8  88       d8  ,adPPPPP88  8b       88  8PP"""""""  
,d8"       "8b,   ,aa  88          "8a,   ,a8"  88b,   ,a8"  88,    ,88  "8a,   ,d88  "8b,   ,aa  
888888888   `"Ybbd8"'  88           `"YbbdP"'   88`YbbdP"'   `"8bbdP"Y8   `"YbbdP"Y8   `"Ybbd8"'  
                                                88                        aa,    ,88              
                                                88                         "Y8bbdP"               
*/
.zeropage

zp0:                .res 1
zp1:                .res 1
zp2:                .res 1
zp3:                .res 1
zp4:                .res 1
zp5:                .res 1
zp6:                .res 1
zp7:                .res 1
zp8:                .res 1
zp9:                .res 1
zp10:               .res 1
zp11:               .res 1
zp12:               .res 1
zp13:               .res 1
zp14:               .res 1
zp15:               .res 1

zp16:               .res 1
zp17:               .res 1
zp18:               .res 1
zp19:               .res 1
zp20:               .res 1
zp21:               .res 1
zp22:               .res 1
zp23:               .res 1
zp24:               .res 1
zp25:               .res 1
zp26:               .res 1
zp27:               .res 1
zp28:               .res 1
zp29:               .res 1
zp30:               .res 1
zp31:               .res 1

last_received_value: .res 1

/*
                                                                                  
88                           88                        88                         
""                           88                        88                         
                             88                        88                         
88  8b,dPPYba,    ,adPPYba,  88  88       88   ,adPPYb,88   ,adPPYba,  ,adPPYba,  
88  88P'   `"8a  a8"     ""  88  88       88  a8"    `Y88  a8P_____88  I8[    ""  
88  88       88  8b          88  88       88  8b       88  8PP"""""""   `"Y8ba,   
88  88       88  "8a,   ,aa  88  "8a,   ,a88  "8a,   ,d88  "8b,   ,aa  aa    ]8I  
88  88       88   `"Ybbd8"'  88   `"YbbdP'Y8   `"8bbdP"Y8   `"Ybbd8"'  `"YbbdP"'  
                                                                                  
                                                                                  
*/

.include "constants.s"

; BUILD VERSION
.include "version.s"
.out .sprintf( "# build %s", STR_BUILD )
.out ""

; NES LIB - thanks Shiru (http://shiru.untergrund.net/code.shtml)
.segment "CODE"
.include "nes-lib/nes-lib.s"

; RAINBOW
.segment "CODE"
.include "rainbow-lib/rainbow.s"

/*
                                                                               
                                                                               
             ,d                               ,d                               
             88                               88                               
,adPPYba,  MM88MMM  ,adPPYYba,  8b,dPPYba,  MM88MMM  88       88  8b,dPPYba,   
I8[    ""    88     ""     `Y8  88P'   "Y8    88     88       88  88P'    "8a  
 `"Y8ba,     88     ,adPPPPP88  88            88     88       88  88       d8  
aa    ]8I    88,    88,    ,88  88            88,    "8a,   ,a88  88b,   ,a8"  
`"YbbdP"'    "Y888  `"8bbdP"Y8  88            "Y888   `"YbbdP'Y8  88`YbbdP"'   
                                                                  88           
                                                                  88           
*/

.segment "CODE"
vector_reset:

  ; initialize the NES
  cld
  sei
  ldx #$FF
  txs

initPPU1:
  lda PPU_STATUS
  bpl initPPU1
initPPU2:
  lda PPU_STATUS
  bpl initPPU2

  ldx #$00
  stx PPU_MASK
  stx DMC_FREQ
  stx PPU_CTRL        ;no NMI

clearRAM:
  txa
:
  sta $000,x
  sta $100,x
  sta $200,x
  sta $300,x
  sta $400,x
  sta $500,x
  sta $600,x
  sta $700,x
  inx
  bne :-

  jsr PPU::oam_clear

  lda #%10000000
  sta <PPU::CTRL_VAR
  sta PPU_CTRL        ; enable NMI
  lda #%00000110
  sta <PPU::MASK_VAR

waitSync3:
  lda PPU::FRAME_CNT1
:
  cmp PPU::FRAME_CNT1
  beq :-

  ; get TV system
  ; 0 : NTSC
  ; 1 : PAL
  ; 2 : dendy
  ; 3 : unknown
  jsr PPU::getTVSystem

  ; initialize sound APU
  ldx #$00
apu_clear_loop:
  sta $4000, X            ; write 0 to most APU registers
  inx
  cpx #$13
  bne apu_clear_loop
  ldx #$00
  stx $4015               ; turn off square/noise/triangle/DPCM channels

  ; acknowledge/disable both APU IRQs
  ; (frame counter and DMC completion)
  lda #$40
  sta $4017  ; APU IRQ: OFF!
  lda $4015  ; APU IRQ: ACK!

  ; disable ESP for now
  lda #0
  sta MAP_ESP_CONFIG

/*
                                                 
                                88               
                                ""               
                                                 
88,dPYba,,adPYba,   ,adPPYYba,  88  8b,dPPYba,   
88P'   "88"    "8a  ""     `Y8  88  88P'   `"8a  
88      88      88  ,adPPPPP88  88  88       88  
88      88      88  88,    ,88  88  88       88  
88      88      88  `"8bbdP"Y8  88  88       88  
                                                 
                                                 
*/

  ; disable rendering
  jsr PPU::off

  lda #CHR_CHIP_RAM|CHR_MODE_4K
  sta MAP_CONFIG

  ; load CHR data
  lda #0
  sta MAP_CHR_0
  sta MAP_CHR_1
  sta PPU_ADDR
  sta PPU_ADDR
  lda #<chrData
  sta zp0
  lda #>chrData
  sta zp1

  ldx #8
  ldy #0
:
  lda (zp0),y
  sta PPU_DATA
  iny
  bne :-
  inc zp1
  dex
  bne :-

  ; clear nametable
  lda #$20
  ldx #0
  jsr PPU::fillNT

  ; clear nametable attributes
  lda #$20
  ldx #0
  jsr PPU::fillAT

  ; set brightness to 4
  lda #4
  sta PPU::palBrightness
  jsr PPU::setPaletteBrightness

  ; load palette
  ldx #>pal
  lda #<pal
  jsr PPU::pal_all

  ; push palette updates
  jsr PPU::flushPalette

  ; set BG CHR page
  lda #0
  jsr PPU::setBG_bank

  ; set SPR CHR page
  lda #1
  jsr PPU::setSPR_bank

  ; enable rendering
  jsr PPU::on

  ; start game or whatever
  jsr game_init

  ; main loop
:
  jsr PPU::waitNMI
	jsr game_tick
  jmp :-

  .proc game_tick

    ; reset sprite tile
    lda #1
    sta OAM_BUF+1

    ; read controller #1
    ldy #0
    jsr pad::read

    ; A pressed ? send debug log command
    lda pad::padState
    and #PAD_A
    beq skipA
      lda #'A'
      sta OAM_BUF+1
      lda #<send_debug_msg_cmd
      ldx #>send_debug_msg_cmd
      jsr RNBW::sendData
  skipA:

    ; B pressed ? send message to server
    lda pad::padState
    and #PAD_B
    beq skipB
      lda #'B'
      sta OAM_BUF+1
      lda #<send_server_msg_cmd
      ldx #>send_server_msg_cmd
      jsr RNBW::sendData
  skipB:

    ; Check incoming message
    lda RNBW::ESP_CONFIG
    bpl end_receive
      jsr RNBW::getData

      ; Length
      lda RNBW::BUF_IN
      cmp #152
      bne fail

      ; Type
      lda RNBW::BUF_IN+1
      cmp #RNBW::FROM_ESP::MESSAGE_FROM_SERVER
      bne fail

      ; Padding
      ldx #150
      :
        lda RNBW::BUF_IN+1, x
        sta zp0
        cpx zp0
        bne fail

        dex
        bne :-

      ; Value
      lda RNBW::BUF_IN+152
      sta last_received_value
;      tax
;      dex
;      cpx last_received_value
;      bne fail

      ; Everything went well
      jmp end_receive

      fail:
        ; Place error sprite
        lda #$88
        sta OAM_BUF+4
        lda last_received_value
        sta OAM_BUF+4+3

  end_receive:

    ; Place progress sprite
    lda last_received_value
    sta OAM_BUF+3

    rts

  send_debug_msg_cmd:
		.byt 11, RNBW::TO_ESP::DEBUG_LOG, 1,2,3,4,5,6,7,8,9,10

  send_server_msg_cmd:
    .byt 11, RNBW::TO_ESP::SERVER_SEND_MESSAGE, 1,2,3,4,5,6,7,8,9,10

  .endproc

  .proc game_init

    ; Init state
    lda #0
    sta last_received_value

    ; Place progress sprites
    lda #$80
    sta OAM_BUF
    lda #1
    sta OAM_BUF+1
    lda #2
    sta OAM_BUF+1+4
    lda #0
    sta OAM_BUF+2
    sta OAM_BUF+2+4
    sta OAM_BUF+3
    sta OAM_BUF+3+4

    ; Wait for start to be pressed
  :
    ldy #0
    jsr pad::read
    and #PAD_START ; START ?
    beq :-

    ; Connect to server
    jsr connect

    lda #<send_server_msg_cmd
    ldx #>send_server_msg_cmd
    jmp RNBW::sendData

    ;rts

    send_server_msg_cmd:
      .byt 11, RNBW::TO_ESP::SERVER_SEND_MESSAGE, 1,2,3,4,5,6,7,8,9,10

  .endproc

  .proc connect

    ; enable ESP / disable IRQ
    lda #1
    sta MAP_ESP_CONFIG

    ; clear TX/RX buffers
    lda #1
    sta MAP_ESP_DATA
    lda #RNBW::TO_ESP::BUFFER_CLEAR_RX_TX
    sta MAP_ESP_DATA

    ; because clearing TX/RX buffers can take some times, we wait for an NMI
    jsr PPU::waitNMI

    ; Get configured server info
    lda #<get_config_cmd
    ldx #>get_config_cmd
    jsr RNBW::sendData
    RNBW_waitResponse
    jsr RNBW::getData

    ; Convert result to set_server command
    lda #RNBW::TO_ESP::SERVER_SET_SETTINGS
    sta RNBW::BUF_IN+1

    ; Send the set_server command
    lda #<RNBW::BUF_IN
    ldx #>RNBW::BUF_IN
    jsr RNBW::sendData

    ; Set protocol
    lda #<set_protocol_cmd
    ldx #>set_protocol_cmd
    jsr RNBW::sendData

    ; Connect to server
    lda #<connect_cmd
    ldx #>connect_cmd
    jmp RNBW::sendData

    ; Give the ESP some rest (not sure that it is necessary)
    ;jmp PPU::waitNMI

    ;rts

    get_config_cmd:
      .byt 1, RNBW::TO_ESP::SERVER_GET_CONFIG_SETTINGS

    set_protocol_cmd:
      .byt 2, RNBW::TO_ESP::SERVER_SET_PROTOCOL, RNBW::SERVER_PROTOCOLS::UDP

    connect_cmd:
      .byt 1, RNBW::TO_ESP::SERVER_CONNECT

  .endproc

/*
                                                                         
                                             88  88                      
                                             88  ""    ,d                
                                             88        88                
 ,adPPYba,  8b,dPPYba,   ,adPPYba,   ,adPPYb,88  88  MM88MMM  ,adPPYba,  
a8"     ""  88P'   "Y8  a8P_____88  a8"    `Y88  88    88     I8[    ""  
8b          88          8PP"""""""  8b       88  88    88      `"Y8ba,   
"8a,   ,aa  88          "8b,   ,aa  "8a,   ,d88  88    88,    aa    ]8I  
 `"Ybbd8"'  88           `"Ybbd8"'   `"8bbdP"Y8  88    "Y888  `"YbbdP"'  
                                                                         
                                                                         
*/

  ; credits+build
  credits:
  .byte "/mapper-nes-boiler-plate b"
  build:
  .byte STR_BUILD
  .byte "/(c) 2021 Broke Studio/code Antoine Gohin/"

/*
                                     
                                 88  
                                 ""  
                                     
8b,dPPYba,   88,dPYba,,adPYba,   88  
88P'   `"8a  88P'   "88"    "8a  88  
88       88  88      88      88  88  
88       88  88      88      88  88  
88       88  88      88      88  88  
                                     
                                     
*/
.segment "CODE"

.proc vector_nmi
  ; save stack
  pha
  txa
  pha
  tya
  pha

  ; if rendering is disabled, do not access the VRAM at all
  lda PPU::MASK_VAR
  and #%00011000
  bne doUpdate
  jmp skipAll

doUpdate:

  ; update OAM
  ldx #$00
  stx PPU_OAM_ADDR
  lda #>OAM_BUF
  sta PPU_OAM_DMA

  ; update palette if needed
  lda <PPU::palUpdate
  beq updVRAM
  bmi fadePal
  jmp flushPal
fadePal:

  jsr PPU::fadePalette
  jmp updVRAM

flushPal:

  jsr PPU::flushPalette

updVRAM:

  lda PPU::VRAM_UPDATE
  beq skipUpd
  stx PPU::VRAM_UPDATE
  
  lda PPU::NAME_UPD_ENABLE
  beq skipUpd

  jsr PPU::flush_vram_update_nmi

skipUpd:

  lda #$00
  sta PPU_ADDR
  sta PPU_ADDR

  sta PPU_SCROLL
  sta PPU_SCROLL

skipAll:

  lda PPU::CTRL_VAR
  sta PPU_CTRL

  lda PPU::MASK_VAR
  sta PPU_MASK

skipClassicNMI:

  inc PPU::FRAME_CNT1
  inc PPU::FRAME_CNT2
  lda PPU::FRAME_CNT2
  cmp #$06
  bne skipNtsc
  lda #$00
  sta PPU::FRAME_CNT2

skipNtsc:
  ; update sound/music here

  ; update prng
  jsr system::prng

  ; restore stack
  pla
  tay
  pla
  tax
  pla

  ; return
  rti

.endproc

/*
                             
88                           
""                           
                             
88  8b,dPPYba,   ,adPPYb,d8  
88  88P'   "Y8  a8"    `Y88  
88  88          8b       88  
88  88          "8a    ,d88  
88  88           `"YbbdP'88  
                         88  
                         88  
*/

.proc vector_irq

  ; ESP irq ?
  lda MAP_ESP_CONFIG
  bmi :+
    ; no message to read, then return
    rti
:

  ; process ESP messages here if using IRQ setting

  ; return
  rti

.endproc

/*
                                              
         88                                   
         88                ,d                 
         88                88                 
 ,adPPYb,88  ,adPPYYba,  MM88MMM  ,adPPYYba,  
a8"    `Y88  ""     `Y8    88     ""     `Y8  
8b       88  ,adPPPPP88    88     ,adPPPPP88  
"8a,   ,d88  88,    ,88    88,    88,    ,88  
 `"8bbdP"Y8  `"8bbdP"Y8    "Y888  `"8bbdP"Y8  
                                              
                                              
*/

; insert data here
pal:
  .byte $0f,$00,$10,$30,$0f,$01,$21,$31,$0f,$06,$16,$26,$0f,$09,$19,$29
  .byte $0f,$00,$10,$30,$0f,$01,$21,$31,$0f,$06,$16,$26,$0f,$09,$19,$29


/*
                                     
            88                       
            88                       
            88                       
 ,adPPYba,  88,dPPYba,   8b,dPPYba,  
a8"     ""  88P'    "8a  88P'   "Y8  
8b          88       88  88          
"8a,   ,aa  88       88  88          
 `"Ybbd8"'  88       88  88          
                                     
                                     
*/
.if CHR_CHIPS <> RNBW_CHR_RAM

  .macro chr c
    .segment .sprintf("CHR%02d",c)
  .endmacro

  .repeat 63,C
    chr C
    .incbin "gfx/8K-blank.chr"
  .endrepeat

  .segment "CHR63"
    .incbin "gfx/ascii.chr"
    .incbin "gfx/ascii.chr"

.else

  chrData:
    .incbin "gfx/ascii2K.chr"

.endif

/*
                                                                                 
                                                                                 
                                       ,d                                        
                                       88                                        
8b       d8   ,adPPYba,   ,adPPYba,  MM88MMM  ,adPPYba,   8b,dPPYba,  ,adPPYba,  
`8b     d8'  a8P_____88  a8"     ""    88    a8"     "8a  88P'   "Y8  I8[    ""  
 `8b   d8'   8PP"""""""  8b            88    8b       d8  88           `"Y8ba,   
  `8b,d8'    "8b,   ,aa  "8a,   ,aa    88,   "8a,   ,a8"  88          aa    ]8I  
    "8"       `"Ybbd8"'   `"Ybbd8"'    "Y888  `"YbbdP"'   88          `"YbbdP"'  
                                                                                 
                                                                                 
*/

.segment "VECTORS"
  .word vector_nmi    ; $FFFA vblank nmi
  .word vector_reset  ; $FFFC reset
  .word vector_irq    ; $FFFE irq / brk
