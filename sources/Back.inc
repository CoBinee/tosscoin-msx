; Back.inc : 背景
;


; マクロの定義
;

; 背景
BACK_STATE                      =   0x00
BACK_FLAG                       =   0x01
BACK_HIT_X                      =   0x02
BACK_HIT_Y                      =   0x03
BACK_TRANSFER_L                 =   0x04
BACK_TRANSFER_H                 =   0x05
BACK_LENGTH                     =   0x06

; 状態
BACK_STATE_NULL                 =   0x00

; フラグ
BACK_FLAG_NULL                  =   0x00

; ヒット
BACK_HIT_NULL                   =   0x00

; 転送
BACK_TRANSFER_NULL              =   0x00

; 床
BACK_FLOOR_Y                    =   0x9f

; 天井
BACK_CEILING_Y                  =   0x78
BACK_CEILING_HIT_WIDTH          =   0x04
BACK_CEILING_HIT_HEIGHT         =   0x07
BACK_CEILING_HIT_Y              =   (BACK_CEILING_Y - BACK_CEILING_HIT_HEIGHT)

; 外部関数宣言
;

    .globl  _BackInitialize
    .globl  _BackUpdate
    .globl  _BackRender
    .globl  _BackTransfer
    .globl  _BackHitCeiling
    .globl  _BackGetCeilingY

; 外部変数宣言
;

    .globl  _back
