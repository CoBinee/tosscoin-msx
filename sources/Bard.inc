; Bard.inc : 吟遊詩人
;


; マクロの定義
;

; 吟遊詩人
BARD_FRAME                      =   0x00
BARD_LENGTH                     =   0x01

; フレーム
BARD_FRAME_NULL                 =   0x00

; 外部関数宣言
;

    .globl  _BardInitialize
    .globl  _BardUpdate
    .globl  _BardRender

; 外部変数宣言
;

    .globl  _bard
