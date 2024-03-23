; Sound.s : サウンド
;


; モジュール宣言
;
    .module Sound

; 参照ファイル
;
    .include    "bios.inc"
    .include    "System.inc"
    .include	"Sound.inc"

; 外部変数宣言
;

; マクロの定義
;


; CODE 領域
;
    .area   _CODE

; BGM を再生する
;
_SoundPlayBgm::

    ; レジスタの保存
    push    hl
    push    bc
    push    de

    ; a < BGM

    ; 現在再生している BGM の取得
    ld      bc, (_soundChannel + SOUND_CHANNEL_A + SOUND_CHANNEL_HEAD)

    ; サウンドの再生
    add     a, a
    ld      e, a
    add     a, a
    add     a, e
    ld      e, a
    ld      d, #0x00
    ld      hl, #soundBgm
    add     hl, de
    ld      e, (hl)
    inc     hl
    ld      d, (hl)
    inc     hl
    ld      a, e
    cp      c
    jr      nz, 10$
    ld      a, d
    cp      b
    jr      z, 19$
10$:
    ld      (_soundChannel + SOUND_CHANNEL_A + SOUND_CHANNEL_REQUEST), de
    ld      e, (hl)
    inc     hl
    ld      d, (hl)
    inc     hl
    ld      (_soundChannel + SOUND_CHANNEL_B + SOUND_CHANNEL_REQUEST), de
    ld      e, (hl)
    inc     hl
    ld      d, (hl)
;   inc     hl
    ld      (_soundChannel + SOUND_CHANNEL_C + SOUND_CHANNEL_REQUEST), de
19$:

    ; レジスタの復帰
    pop     de
    pop     bc
    pop     hl

    ; 終了
    ret

; SE を再生する
;
_SoundPlaySe::

    ; レジスタの保存
    push    hl
    push    de

    ; a < SE

    ; サウンドの再生
    add     a, a
    ld      e, a
    ld      d, #0x00
    ld      hl, #soundSe
    add     hl, de
    ld      e, (hl)
    inc     hl
    ld      d, (hl)
;   inc     hl
    ld      (_soundChannel + SOUND_CHANNEL_D + SOUND_CHANNEL_REQUEST), de

    ; レジスタの復帰
    pop     de
    pop     hl

    ; 終了
    ret

; サウンドを停止する
;
_SoundStop::

    ; レジスタの保存

    ; サウンドの停止
    call    _SystemStopSound

    ; レジスタの復帰

    ; 終了
    ret

; BGM が再生中かどうかを判定する
;
_SoundIsPlayBgm::

    ; レジスタの保存
    push    hl

    ; cf > 0/1 = 停止/再生中

    ; サウンドの監視
    ld      hl, (_soundChannel + SOUND_CHANNEL_A + SOUND_CHANNEL_REQUEST)
    ld      a, h
    or      l
    jr      nz, 10$
    ld      hl, (_soundChannel + SOUND_CHANNEL_A + SOUND_CHANNEL_PLAY)
    ld      a, h
    or      l
    jr      nz, 10$
    or      a
    jr      19$
10$:
    scf
19$:

    ; レジスタの復帰
    pop     hl

    ; 終了
    ret

; SE が再生中かどうかを判定する
;
_SoundIsPlaySe::

    ; レジスタの保存
    push    hl

    ; cf > 0/1 = 停止/再生中

    ; サウンドの監視
    ld      hl, (_soundChannel + SOUND_CHANNEL_D + SOUND_CHANNEL_REQUEST)
    ld      a, h
    or      l
    jr      nz, 10$
    ld      hl, (_soundChannel + SOUND_CHANNEL_D + SOUND_CHANNEL_PLAY)
    ld      a, h
    or      l
    jr      nz, 10$
    or      a
    jr      19$
10$:
    scf
19$:

    ; レジスタの復帰
    pop     hl

    ; 終了
    ret

; 共通
;
soundNull:

    .ascii  "T1@0"
    .db     0x00

; BGM
;
soundBgm:

    .dw     soundNull, soundNull, soundNull
    .dw     soundBgmTossCoin_A, soundBgmTossCoin_B, soundBgmTossCoin_C

; TOSS A COIN To YOUR WITCHER
soundBgmTossCoin_A:

    .ascii  "T4@0V15,8"
    .ascii  "L3R5RO3FO4D-4C1O3B-4A-1B-5RB-O4D-4E-1D-5"
    .ascii  "L3O3A-B-RB-O4E-E-FD-5O3B-RB-O4E-4E-1E-"
    .ascii  "L3O4F8RD-O3B-7RR7"
    .ascii  "L3R7O5D-CO4B-A-B-5RB-O5D-E-D-CO4"
    .ascii  "L3O4B-5R5O5E-E-FD-5O4B-RB-O5A-E-D-"
    .ascii  "L3O5F6R5D-4C1O4B-1A-4B-5R5O5D-E-D-C"
    .ascii  "L3O4B-5RB-O5E-E-FD-O4B-5R5O5E-D-E-E-"
    .ascii  "L9O5F"
    .ascii  "L3R5O4B-O5D-F5E-D-E-F5FE-D-CD-5O4B-RO5FE-D-CD-5O4B-5A-B-O5D-6"
    .ascii  "L3R5O4B-O5D-F5E-D-E-F5FA-FE-F5F8RA8AB-5R"
    .ascii  "L3O4B-O5D-F5E-D-E-F5FE-D-CD-5O4B-RO5FE-D-CD-5O4B-5A-B-O5D-6"
    .ascii  "L3R5O4B-O5D-F5E-D-E-F5FA-FE-F5F8RA8AB-5R"
    .ascii  "L3O4B-O5D-F5E-D-E-F5FE-D-CD-5O4B-RO5FE-D-CD-5O4B-5A-B-O5D-6"
    .ascii  "L3R5O4B-O5D-F5E-D-E-F5FA-FE-F5F8RA9B-9"
    .db     0x00

soundBgmTossCoin_B:

    .ascii  "T4@0V13,8"
    .ascii  "L3O2B-O3FO2B-O3E-O2B-O3E-O2B-O3E-O2GO3FO2GO3E-O2GO3E-O2GO3E-"
    .ascii  "L3O2G-O3FO2G-O3E-O2G-O3E-O2G-O3E-O2A-O3FO2A-O3E-O2A-O3E-O2A-O3E-"
    .ascii  "L3O2GO3FO2GO3E-O2GO3E-O2GO3E-O2A-O3FO2A-O3E-O2A-O3E-O2AO3F"
    .ascii  "L3O2B-O3FO2B-O3E-O2B-O3E-O2B-O3E-O2GO3FO2GO3E-O2GO3E-O2GO3E-"
    .ascii  "L3O2G-O3FO2G-O3E-O2G-O3E-O2G-O3E-O2A-O3FO2A-O3E-O2A-O3E-O2AO3E-"
    .ascii  "L3O2B-O3FO2B-O3E-O2B-O3E-O2B-O3E-O2GO3FO2GO3E-O2GO3E-O2GO3E-"
    .ascii  "L3O2G-O3FO2G-O3E-O2G-O3E-O2G-O3E-O2A-O3FO2A-O3E-O2A-O3E-O2A-O3E-"
    .ascii  "L3O3A-A-A-A-A-A-AA"
    .ascii  "L3O2B-O3FO2B-O3FO2AO3E-O2AO3E-O2A-O3D-O2A-O3D-O2GO3E-O2GO3E-O2B-O3FO2B-O3E-O2GO3E-O2GO3E-O2B-O3FO2B-O3FO2B-O3FO2AO3A"
    .ascii  "L3O3B-7O2AO3E-O2AO3E-O2A-O3D-O2A-O3E-O2GO3E-O2GO3A5AAAAAAAAAAAAAE-F7R"
    .ascii  "L3O2AO3E-O2AO3E-O2A-O3D-O2A-O3D-O2GO3E-O2GO3E-O2B-O3FO2B-O3E-O2GO3E-O2GO3E-O2B-O3FO2B-O3FO2B-O3FO2AO3A"
    .ascii  "L3O3B-7O2AO3E-O2AO3E-O2A-O3D-O2A-O3E-O2GO3E-O2GO3A5AAAAAAAAAAAAAE-F7R"
    .ascii  "L3O2AO3E-O2AO3E-O2A-O3D-O2A-O3D-O2GO3E-O2GO3E-O2B-O3FO2B-O3E-O2GO3E-O2GO3E-O2B-O3FO2B-O3FO2B-O3FAO2A"
    .ascii  "L3O3B-7O2AO3E-O2AO3E-O2A-O3D-O2A-O3E-O2GO3E-O2GO3E-O2FO3CFCO4CO3FO4FO3FO4CO3FAB-AFE-D-O2B-9"
    .db     0x00

soundBgmTossCoin_C:

    .ascii  "T4@0V13,8"
    .ascii  "L9RR"
    .ascii  "L9RR"
    .ascii  "L9RR"
    .ascii  "L9RR"
    .ascii  "L9RR"
    .ascii  "L9RR"
    .ascii  "L9RR"
    .ascii  "L3O3CCCCCCCC"
    .ascii  "L9RRRR"
    .ascii  "L3O3F7R7R7R5RO3F5FFFFFFFCCCCCCO2AB-7R"
    .ascii  "L9R7RRR"
    .ascii  "L3O3F7R7R7R5RO3F5FFFFFFFCCCCCCO2AB-7R"
    .ascii  "L9R7RRR"
    .ascii  "L3O3F7R7R9R9R7E-CO2AD-O1B-9"
    .db     0x00

; SE
;
soundSe:

    .dw     soundNull
    .dw     soundSeBoot
    .dw     soundSeClick
    .dw     soundSeJump
    .dw     soundSeCoin

; ブート
soundSeBoot:

    .ascii  "T2@0V15L3O6BO5BR9"
    .db     0x00

; クリック
soundSeClick:

    .ascii  "T2@0V15O4B0"
    .db     0x00

; ジャンプ
soundSeJump:

    .ascii  "T1@0V15L0O4A1O3ABO4C+D+FGABO5C+D+FGA"
    .db     0x00

; コイン
soundSeCoin:

    .ascii  "T1@0V15,4O5B3O6E9"
    .db     0x00


; DATA 領域
;
    .area   _DATA

; 変数の定義
;
