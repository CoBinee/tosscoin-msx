; Jester.inc : 道化師
;


; マクロの定義
;

; 道化師
JESTER_POSITION_X               =   0x00
JESTER_POSITION_Y               =   0x01
JESTER_OFFSET                   =   0x02
JESTER_COLOR                    =   0x03
JESTER_LENGTH                   =   0x04

; 位置
JESTER_POSITION_NULL            =   0x00

; オフセット
JESTER_OFFSET_NULL              =   0x00

; 色
JESTER_COLOR_NULL               =   0x00

; 登録
JESTER_ENTRY                    =   0x06

; 外部関数宣言
;

    .globl  _JesterInitialize
    .globl  _JesterUpdate
    .globl  _JesterRender

; 外部変数宣言
;

    .globl  _jester
