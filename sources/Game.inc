; Game.inc : ゲーム
;


; マクロの定義
;

; スプライト
GAME_SPRITE_NULL                =   0x00
GAME_SPRITE_PLAYER_0            =   0x00
GAME_SPRITE_PLAYER_1            =   0x70
GAME_SPRITE_COIN_0              =   0x10
GAME_SPRITE_COIN_1              =   0x20
GAME_SPRITE_BARD                =   0x30
GAME_SPRITE_JESTER              =   0x40
GAME_SPRITE_RESULT              =   0x00

; ゲーム
GAME_STATE                      =   0x00
GAME_FLAG                       =   0x01
GAME_FRAME                      =   0x02
GAME_TIMER                      =   0x03
GAME_COIN_BRONZE                =   0x04
GAME_COIN_SILVER                =   0x05
GAME_COIN_GOLD                  =   0x06
GAME_RESULT_BRONZE              =   0x07
GAME_RESULT_SILVER              =   0x08
GAME_RESULT_GOLD                =   0x09
GAME_SCORE_BRONZE_L             =   0x0a
GAME_SCORE_BRONZE_H             =   0x0b
GAME_SCORE_SILVER_L             =   0x0c
GAME_SCORE_SILVER_H             =   0x0d
GAME_SCORE_GOLD_L               =   0x0e
GAME_SCORE_GOLD_H               =   0x0f
GAME_SCORE_TOTAL_L              =   0x10
GAME_SCORE_TOTAL_H              =   0x11
GAME_VALUE_10000                =   0x12
GAME_VALUE_01000                =   0x13
GAME_VALUE_00100                =   0x14
GAME_VALUE_00010                =   0x15
GAME_VALUE_00001                =   0x16
GAME_LENGTH                     =   0x17

; 状態
GAME_STATE_NULL                 =   0x00
GAME_STATE_START                =   0x10
GAME_STATE_PLAY                 =   0x20
GAME_STATE_RESULT               =   0x30

; フラグ
GAME_FLAG_NULL                  =   0x00
GAME_FLAG_OVER_BIT              =   0x00
GAME_FLAG_OVER                  =   (1 << GAME_FLAG_OVER_BIT)
GAME_FLAG_FREE_BIT              =   0x01
GAME_FLAG_FREE                  =   (1 << GAME_FLAG_FREE_BIT)
GAME_FLAG_RESULT_BRONZE_BIT     =   0x04
GAME_FLAG_RESULT_BRONZE         =   (1 << GAME_FLAG_RESULT_BRONZE_BIT)
GAME_FLAG_RESULT_SILVER_BIT     =   0x05
GAME_FLAG_RESULT_SILVER         =   (1 << GAME_FLAG_RESULT_SILVER_BIT)
GAME_FLAG_RESULT_GOLD_BIT       =   0x06
GAME_FLAG_RESULT_GOLD           =   (1 << GAME_FLAG_RESULT_GOLD_BIT)
GAME_FLAG_RESULT_TOTAL_BIT      =   0x07
GAME_FLAG_RESULT_TOTAL          =   (1 << GAME_FLAG_RESULT_TOTAL_BIT)

; フレーム
GAME_FRAME_NULL                 =   0x00

; タイマ
GAME_TIMER_NULL                 =   0x00

; コイン
GAME_COIN_NULL                  =   0x00

; 結果
GAME_RESULT_NULL                =   0x00

; スコア
GAME_SCORE_NULL                 =   0x00

; 値
GAME_VALUE_NULL                 =   0x00

; 外部関数宣言
;

    .globl  _GameInitialize
    .globl  _GameUpdate
    .globl  _GameIsOver
    .globl  _GameAddCoin

; 外部変数宣言
;

    .globl  _game
