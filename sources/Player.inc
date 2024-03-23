; Player.inc : プレイヤ
;


; マクロの定義
;

; プレイヤ
PLAYER_STATE                    =   0x00
PLAYER_FLAG                     =   0x01
PLAYER_POSITION_X_L             =   0x02
PLAYER_POSITION_X_H             =   0x03
PLAYER_POSITION_Y_L             =   0x04
PLAYER_POSITION_Y_H             =   0x05
PLAYER_SPEED_X_L                =   0x06
PLAYER_SPEED_X_H                =   0x07
PLAYER_SPEED_Y_L                =   0x08
PLAYER_SPEED_Y_H                =   0x09
PLAYER_HIT_X                    =   0x0a
PLAYER_HIT_Y                    =   0x0b
PLAYER_ANIMATION                =   0x0c
PLAYER_SPRITE_L                 =   0x0d
PLAYER_SPRITE_H                 =   0x0e
PLAYER_LENGTH                   =   0x0f

; 状態
PLAYER_STATE_NULL               =   0x00
PLAYER_STATE_PLAY               =   0x10

; フラグ
PLAYER_FLAG_NULL                =   0x00
PLAYER_FLAG_RIGHT_BIT           =   0x00
PLAYER_FLAG_RIGHT               =   (1 << PLAYER_FLAG_RIGHT_BIT)
PLAYER_FLAG_JUMP_BIT            =   0x01
PLAYER_FLAG_JUMP                =   (1 << PLAYER_FLAG_JUMP_BIT)

; 位置
PLAYER_POSITION_NULL            =   0x00

; 速度
PLAYER_SPEED_NULL               =   0x00
PLAYER_SPEED_X_MAXIMUM          =   0x02
PLAYER_SPEED_Y_MAXIMUM          =   0x04
PLAYER_SPEED_ACCEL              =   0x0020
PLAYER_SPEED_BRAKE              =   0x0010
PLAYER_SPEED_JUMP               =   -0x0400
PLAYER_SPEED_GRAVITY            =   0x003e

; ヒット
PLAYER_HIT_NULL                 =   0x00
PLAYER_HIT_OFFSET_X_L           =   -0x09
PLAYER_HIT_OFFSET_X_R           =   0x05
PLAYER_HIT_OFFSET_Y             =   -0x0e

; アニメーション
PLAYER_ANIMATION_NULL           =   0x00

; スプライト
PLAYER_SPRITE_NULL              =   0x00

; 外部関数宣言
;

    .globl  _PlayerInitialize
    .globl  _PlayerUpdate
    .globl  _PlayerRender

; 外部変数宣言
;

    .globl  _player
