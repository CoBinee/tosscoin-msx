; Coin.inc : コイン
;


; マクロの定義
;

; コイン
COIN_TYPE                       =   0x00
COIN_STATE                      =   0x01
COIN_POSITION_X_L               =   0x02
COIN_POSITION_X_H               =   0x03
COIN_POSITION_Y_L               =   0x04
COIN_POSITION_Y_H               =   0x05
COIN_SPEED_X_L                  =   0x06
COIN_SPEED_X_H                  =   0x07
COIN_SPEED_Y_L                  =   0x08
COIN_SPEED_Y_H                  =   0x09
COIN_WORK                       =   0x0a
COIN_ANIMATION                  =   0x0b
COIN_SPRITE_Y                   =   0x0c
COIN_SPRITE_X                   =   0x0d
COIN_SPRITE_PATTERN             =   0x0e
COIN_SPRITE_COLOR               =   0x0f
COIN_LENGTH                     =   0x10

; 種類
COIN_TYPE_NULL                  =   0x00
COIN_TYPE_BRONZE                =   0x01
COIN_TYPE_SILVER                =   0x02
COIN_TYPE_GOLD                  =   0x03

; 状態
COIN_STATE_NULL                 =   0x00
COIN_STATE_IN                   =   0x10
COIN_STATE_STAY                 =   0x20
COIN_STATE_HIT                  =   0x30

; 位置
COIN_POSITION_NULL              =   0x00

; 速度
COIN_SPEED_NULL                 =   0x00
COIN_SPEED_Y_START              =   -0x08
COIN_SPEED_Y_MAXIMUM            =   0x04
COIN_SPEED_ACCEL                =   0x0100
COIN_SPEED_BRAKE                =   0x0040
COIN_SPEED_GRAVITY              =   0x0040

; ワーク
COIN_WORK_NULL                  =   0x00

; 色
COIN_COLOR_NULL                 =   0x00

; アニメーション
COIN_ANIMATION_NULL             =   0x00

; スプライト
COIN_SPRITE_NULL                =   0x00
COIN_SPRITE_OFFSET_X            =   -0x08
COIN_SPRITE_OFFSET_Y            =   -0x10

; 登録
COIN_ENTRY                      =   0x04

; ジェネレータ
COIN_GENERATOR_FRAME            =   0x00
COIN_GENERATOR_COUNT            =   0x01
COIN_GENERATOR_COUNT_BRONZE     =   0x02
COIN_GENERATOR_COUNT_SILVER     =   0x03
COIN_GENERATOR_COUNT_GOLD       =   0x04
COIN_GENERATOR_LENGTH           =   0x05

; ジェネレータ／フレーム
COIN_GENERATOR_FRAME_NULL       =   0x00
COIN_GENERATOR_FRAME_INTERVAL   =   0x30

; ジェネレータ／カウント
COIN_GENERATOR_COUNT_NULL       =   0x00

; 外部関数宣言
;

    .globl  _CoinInitialize
    .globl  _CoinUpdate
    .globl  _CoinRender

; 外部変数宣言
;

    .globl  _coin
