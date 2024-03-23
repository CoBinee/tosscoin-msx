; Player.s : プレイヤ
;


; モジュール宣言
;
    .module Player

; 参照ファイル
;
    .include    "bios.inc"
    .include    "vdp.inc"
    .include    "System.inc"
    .include    "Sound.inc"
    .include    "App.inc"
    .include    "Game.inc"
    .include    "Back.inc"
    .include	"Player.inc"

; 外部変数宣言
;

; マクロの定義
;


; CODE 領域
;
    .area   _CODE

; プレイヤを初期化する
;
_PlayerInitialize::
    
    ; レジスタの保存
    
    ; プレイヤの初期化
    ld      hl, #playerDefault
    ld      de, #_player
    ld      bc, #PLAYER_LENGTH
    ldir

    ; 状態の設定
    ld      a, #PLAYER_STATE_PLAY
    ld      (_player + PLAYER_STATE), a
    
    ; レジスタの復帰
    
    ; 終了
    ret

; プレイヤを更新する
;
_PlayerUpdate::
    
    ; レジスタの保存

    ; 状態別の処理
    ld      hl, #10$
    push    hl
    ld      a, (_player + PLAYER_STATE)
    and     #0xf0
    rrca
    rrca
    rrca
    ld      e, a
    ld      d, #0x00
    ld      hl, #playerProc
    add     hl, de
    ld      e, (hl)
    inc     hl
    ld      d, (hl)
    ex      de, hl
    jp      (hl)
;   pop     hl
10$:

    ; ヒットの設定
    ld      a, (_player + PLAYER_FLAG)
    bit     #PLAYER_FLAG_RIGHT_BIT, a
    ld      c, #PLAYER_HIT_OFFSET_X_L
    jr      z, 20$
    ld      c, #PLAYER_HIT_OFFSET_X_R
20$:
    ld      a, (_player + PLAYER_POSITION_X_H)
    add     a, c
    ld      (_player + PLAYER_HIT_X), a
    ld      e, a
    ld      a, (_player + PLAYER_POSITION_Y_H)
    add     a, #PLAYER_HIT_OFFSET_Y
    ld      (_player + PLAYER_HIT_Y), a
    ld      d, a
    call    _BackHitCeiling

    ; スプライトの設定
    ld      a, (_player + PLAYER_FLAG)
    ld      b, a
    bit     #PLAYER_FLAG_JUMP_BIT, b
    jr      z, 30$
    ld      a, #0x24
    jr      32$
30$:
    ld      hl, (_player + PLAYER_SPEED_X_L)
    ld      a, h
    or      l
    jr      z, 32$
    ld      a, (_player + PLAYER_ANIMATION)
    and     #0x08
    jr      z, 31$
    ld      a, #0x0c
31$:
    add     a, #0x0c
32$:
    bit     #PLAYER_FLAG_RIGHT_BIT, b
    jr      z, 33$
    add     a, #0x30
33$:
    ld      e, a
    ld      d, #0x00
    ld      hl, #playerSprite
    add     hl, de
    ld      (_player + PLAYER_SPRITE_L), hl

    ; レジスタの復帰
    
    ; 終了
    ret

; プレイヤを描画する
;
_PlayerRender::

    ; レジスタの保存

    ; スプライトの描画
    ld      a, (_player + PLAYER_POSITION_X_H)
    ld      c, a
    ld      a, (_player + PLAYER_POSITION_Y_H)
    ld      b, a
    ld      hl, (_player + PLAYER_SPRITE_L)
    ld      a, c
    add     a, #0x08
    cp      #0x10
    jr      c, 100$
    ld      de, #(_sprite + GAME_SPRITE_PLAYER_0)
    call    170$
    call    170$
    call    170$
    jr      190$
100$:
    ld      a, (_game + GAME_FRAME)
    rrca
    jr      c, 101$
    ld      de, #(_sprite + GAME_SPRITE_PLAYER_0)
    call    170$
    call    170$
    call    170$
    ld      hl, #(_sprite + GAME_SPRITE_PLAYER_0)
    ld      de, #(_sprite + GAME_SPRITE_PLAYER_1)
    call    180$
    call    180$
    call    180$
    jr      190$
101$:
    ld      de, #(_sprite + GAME_SPRITE_PLAYER_1)
    call    170$
    call    170$
    call    170$
    ld      hl, #(_sprite + GAME_SPRITE_PLAYER_1)
    ld      de, #(_sprite + GAME_SPRITE_PLAYER_0)
    call    180$
    call    180$
    call    180$
    jr      190$
170$:
    ld      a, b
    add     a, (hl)
    ld      (de), a
    inc     hl
    inc     de
    ld      a, c
    add     a, (hl)
    ld      (de), a
    inc     hl
    inc     de
    ld      a, (hl)
    ld      (de), a
    inc     hl
    inc     de
    ld      a, (hl)
    ld      (de), a
    inc     hl
    inc     de
    ret
180$:
    ld      a, (hl)
    ld      (de), a
    inc     hl
    inc     de
    ld      a, (hl)
    add     a, #0x20
    ld      (de), a
    inc     hl
    inc     de
    ld      a, (hl)
    ld      (de), a
    inc     hl
    inc     de
    ld      a, (hl)
    or      #0x80
    ld      (de), a
    inc     hl
    inc     de
    ret
190$:

    ; レジスタの復帰

    ; 終了
    ret

; 何もしない
;
PlayerNull:

    ; レジスタの保存

    ; レジスタの復帰

    ; 終了
    ret

; プレイヤを操作する
;
PlayerPlay:

    ; レジスタの保存

    ; 初期化
    ld      a, (_player + PLAYER_STATE)
    and     #0x0f
    jr      nz, 09$

    ; 初期化の完了
    ld      hl, #(_player + PLAYER_STATE)
    inc     (hl)
09$:

    ; 左右の操作
    ld      a, (_game + GAME_FLAG)
    bit     #GAME_FLAG_FREE_BIT, a
    jr      z, 120$
    ld      a, (_input + INPUT_KEY_LEFT)
    or      a
    jr      nz, 110$
    ld      a, (_input + INPUT_KEY_RIGHT)
    or      a
    jr      nz, 120$

    ; 停止
100$:
    ld      hl, (_player + PLAYER_SPEED_X_L)
    ld      de, #PLAYER_SPEED_BRAKE
    ld      a, h
    or      l
    jr      z, 109$
    ld      a, h
    or      h
    jp      p, 101$
;   or      a
    adc     hl, de
    jp      m, 109$
    ld      hl, #0x0000
    jr      109$
101$:
;   or      a
    sbc     hl, de
    jp      p, 109$
    ld      hl, #0x0000
109$:
    ld      (_player + PLAYER_SPEED_X_L), hl
    jr      130$

    ; 左へ移動
110$:
    ld      hl, (_player + PLAYER_SPEED_X_L)
    ld      de, #PLAYER_SPEED_ACCEL
    or      a
    sbc     hl, de
    jp      p, 111$
    ld      a, h
    cp      #-PLAYER_SPEED_X_MAXIMUM
    jr      nc, 111$
    ld      hl, #-(PLAYER_SPEED_X_MAXIMUM << 8)
111$:
    ld      (_player + PLAYER_SPEED_X_L), hl
    ld      hl, #(_player + PLAYER_FLAG)
    bit     #PLAYER_FLAG_JUMP_BIT, (hl)
    jr      nz, 112$
    res     #PLAYER_FLAG_RIGHT_BIT, (hl)
112$:
    jr      130$

    ; 右へ移動
120$:
    ld      hl, (_player + PLAYER_SPEED_X_L)
    ld      de, #PLAYER_SPEED_ACCEL
    or      a
    adc     hl, de
    jp      m, 121$
    jr      z, 121$
    ld      a, h
    cp      #PLAYER_SPEED_X_MAXIMUM
    jr      c, 121$
    ld      hl, #(PLAYER_SPEED_X_MAXIMUM << 8)
121$:
    ld      (_player + PLAYER_SPEED_X_L), hl
    ld      hl, #(_player + PLAYER_FLAG)
    bit     #PLAYER_FLAG_JUMP_BIT, (hl)
    jr      nz, 122$
    set     #PLAYER_FLAG_RIGHT_BIT, (hl)
122$:
;   jr      130$

    ; 左右の移動
130$:
    ld      hl, (_player + PLAYER_POSITION_X_L)
    ld      de, (_player + PLAYER_SPEED_X_L)
    add     hl, de
    ld      (_player + PLAYER_POSITION_X_L), hl

    ; ジャンプの操作
    ld      hl, #(_player + PLAYER_FLAG)
    bit     #PLAYER_FLAG_JUMP_BIT, (hl)
    jr      nz, 20$
    ld      a, (_input + INPUT_BUTTON_SPACE)
    dec     a
    jr      nz, 20$

    ; ジャンプの開始
    set     #PLAYER_FLAG_JUMP_BIT, (hl)
    ld      hl, #PLAYER_SPEED_JUMP
    ld      (_player + PLAYER_SPEED_Y_L), hl

    ;　SE の再生
    ld      a, #SOUND_SE_JUMP
    call    _SoundPlaySe
;   jr      20$

    ; ジャンプ
20$:
    ld      hl, (_player + PLAYER_SPEED_Y_L)
    ld      de, #PLAYER_SPEED_GRAVITY
    or      a
    adc     hl, de
    jp      m, 21$
    ld      a, h
    cp      #PLAYER_SPEED_Y_MAXIMUM
    jr      c, 21$
    ld      hl, #(PLAYER_SPEED_Y_MAXIMUM << 8)
21$:
    ld      (_player + PLAYER_SPEED_Y_L), hl
    ld      de, (_player + PLAYER_POSITION_Y_L)
    add     hl, de
    ld      a, h
    cp      #BACK_FLOOR_Y
    jr      c, 22$
    ld      hl, #(_player + PLAYER_FLAG)
    res     #PLAYER_FLAG_JUMP_BIT, (hl)
    ld      hl, #(BACK_FLOOR_Y << 8)
22$:
    ld      (_player + PLAYER_POSITION_Y_L), hl

    ; 操作の完了
90$:

    ; アニメーションの更新
    ld      hl, #(_player + PLAYER_ANIMATION)
    inc     (hl)

    ; レジスタの復帰

    ; 終了
    ret

; 定数の定義
;

; 状態別の処理
;
playerProc:
    
    .dw     PlayerNull
    .dw     PlayerPlay

; プレイヤの初期値
;
playerDefault:

    .db     PLAYER_STATE_NULL
    .db     PLAYER_FLAG_RIGHT ; PLAYER_FLAG_NULL
    .dw     0x2000 ; PLAYER_POSITION_NULL
    .dw     BACK_FLOOR_Y << 8 ; PLAYER_POSITION_NULL
    .dw     PLAYER_SPEED_NULL
    .dw     PLAYER_SPEED_NULL
    .db     PLAYER_HIT_NULL
    .db     PLAYER_HIT_NULL
    .db     PLAYER_ANIMATION_NULL
    .dw     PLAYER_SPRITE_NULL

; スプライト
;
playerSprite:

    ; Stay Left
    .db     -0x0f - 0x01, -0x08, 0x40, VDP_COLOR_LIGHT_YELLOW
    .db     -0x0f - 0x01, -0x08, 0x60, VDP_COLOR_WHITE
    .db     -0x0f - 0x01, -0x08, 0x80, VDP_COLOR_MAGENTA
    ; Walk 0 Left
    .db     -0x0f - 0x01, -0x08, 0x44, VDP_COLOR_LIGHT_YELLOW
    .db     -0x0f - 0x01, -0x08, 0x64, VDP_COLOR_WHITE
    .db     -0x0f - 0x01, -0x08, 0x84, VDP_COLOR_MAGENTA
    ; Walk 1 Left
    .db     -0x0f - 0x01, -0x08, 0x48, VDP_COLOR_LIGHT_YELLOW
    .db     -0x0f - 0x01, -0x08, 0x68, VDP_COLOR_WHITE
    .db     -0x0f - 0x01, -0x08, 0x88, VDP_COLOR_MAGENTA
    ; Jump Left
    .db     -0x0f - 0x01, -0x08, 0x4c, VDP_COLOR_LIGHT_YELLOW
    .db     -0x0f - 0x01, -0x08, 0x6c, VDP_COLOR_WHITE
    .db     -0x0f - 0x01, -0x08, 0x8c, VDP_COLOR_MAGENTA
    ; Stay Right
    .db     -0x0f - 0x01, -0x08, 0x50, VDP_COLOR_LIGHT_YELLOW
    .db     -0x0f - 0x01, -0x08, 0x70, VDP_COLOR_WHITE
    .db     -0x0f - 0x01, -0x08, 0x90, VDP_COLOR_MAGENTA
    ; Walk 0 Right
    .db     -0x0f - 0x01, -0x08, 0x54, VDP_COLOR_LIGHT_YELLOW
    .db     -0x0f - 0x01, -0x08, 0x74, VDP_COLOR_WHITE
    .db     -0x0f - 0x01, -0x08, 0x94, VDP_COLOR_MAGENTA
    ; Walk 1 Right
    .db     -0x0f - 0x01, -0x08, 0x58, VDP_COLOR_LIGHT_YELLOW
    .db     -0x0f - 0x01, -0x08, 0x78, VDP_COLOR_WHITE
    .db     -0x0f - 0x01, -0x08, 0x98, VDP_COLOR_MAGENTA
    ; Jump Right
    .db     -0x0f - 0x01, -0x08, 0x5c, VDP_COLOR_LIGHT_YELLOW
    .db     -0x0f - 0x01, -0x08, 0x7c, VDP_COLOR_WHITE
    .db     -0x0f - 0x01, -0x08, 0x9c, VDP_COLOR_MAGENTA
    

; DATA 領域
;
    .area   _DATA

; 変数の定義
;

; プレイヤ
;
_player::
    
    .ds     PLAYER_LENGTH

