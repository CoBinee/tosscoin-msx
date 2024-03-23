; Title.inc : タイトル
;


; マクロの定義
;

; スプライト
TITLE_SPRITE_NULL               =   0x00
TITLE_SPRITE_MODE               =   0x00
TITLE_SPRITE_EYE                =   0x10

; タイトル
TITLE_STATE                     =   0x00
TITLE_FRAME                     =   0x01
TITLE_TIMER                     =   0x02
TITLE_BLINK                     =   0x03
TITLE_SCORE_A_10000             =   0x04
TITLE_SCORE_A_01000             =   0x05
TITLE_SCORE_A_00100             =   0x06
TITLE_SCORE_A_00010             =   0x07
TITLE_SCORE_A_00001             =   0x08
TITLE_SCORE_B_10000             =   0x09
TITLE_SCORE_B_01000             =   0x0a
TITLE_SCORE_B_00100             =   0x0b
TITLE_SCORE_B_00010             =   0x0c
TITLE_SCORE_B_00001             =   0x0d
TITLE_LENGTH                    =   0x0e

; 状態
TITLE_STATE_NULL                =   0x00
TITLE_STATE_STAY                =   0x10
TITLE_STATE_START               =   0x20

; フレーム
TITLE_FRAME_NULL                =   0x00

; タイマ
TITLE_TIMER_NULL                =   0x00

; 点滅
TITLE_BLINK_NULL                =   0x00

; スコア
TITLE_SCORE_NULL                =   0x00

; 外部関数宣言
;

    .globl  _TitleInitialize
    .globl  _TitleUpdate

; 外部変数宣言
;

    .globl  _title
