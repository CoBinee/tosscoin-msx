; Coin.s : コイン
;


; モジュール宣言
;
    .module Coin

; 参照ファイル
;
    .include    "bios.inc"
    .include    "vdp.inc"
    .include    "System.inc"
    .include    "Sound.inc"
    .include    "App.inc"
    .include    "Game.inc"
    .include    "Back.inc"
    .include	"Coin.inc"

; 外部変数宣言
;

; マクロの定義
;


; CODE 領域
;
    .area   _CODE

; コインを初期化する
;
_CoinInitialize::
    
    ; レジスタの保存
    
    ; コインの初期化
    ld      hl, #(_coin + 0x0000)
    ld      de, #(_coin + 0x0001)
    ld      bc, #(COIN_ENTRY * COIN_LENGTH - 0x0001)
    ld      (hl), #0x00
    ldir

    ; ジェネレータの初期化
    ld      hl, #(coinGenerator + 0x0000)
    ld      de, #(coinGenerator + 0x0001)
    ld      bc, #(COIN_GENERATOR_LENGTH - 0x0001)
    ld      (hl), #0x00
    ldir

    ; スプライトの初期化
    ld      hl, #0x0000
    ld      (coinSpriteRotation), hl

    ; レジスタの復帰
    
    ; 終了
    ret

; コインを更新する
;
_CoinUpdate::
    
    ; レジスタの保存

    ; コインの生成
    call    _GameIsOver
    jr      c, 19$
    ld      hl, #(coinGenerator + COIN_GENERATOR_FRAME)
    ld      a, (hl)
    or      a
    jr      z, 10$
    dec     (hl)
    jr      19$
10$:
    ld      ix, #_coin
    ld      de, #COIN_LENGTH
    ld      b, #COIN_ENTRY
11$:
    ld      a, COIN_TYPE(ix)
    or      a
    jr      z, 12$
    add     ix, de
    djnz    11$
    jr      19$
12$:
    ld      (hl), #COIN_GENERATOR_FRAME_INTERVAL
    ld      hl, #(coinGenerator + COIN_GENERATOR_COUNT_SILVER)
    ld      a, (hl)
    cp      #0x03
    jr      c, 13$
    ld      (hl), #0x00
    ld      a, #COIN_TYPE_GOLD
    jr      15$
13$:
    ld      hl, #(coinGenerator + COIN_GENERATOR_COUNT_BRONZE)
    ld      a, (hl)
    cp      #0x03
    jr      c, 14$
    ld      (hl), #0x00
    ld      a, #COIN_TYPE_SILVER
    jr      15$
14$:
    ld      a, #COIN_TYPE_BRONZE
15$:
    ld      COIN_TYPE(ix), a
    ld      COIN_STATE(ix), #COIN_STATE_IN
;   jr      19$
19$:

    ; コインの走査
    ld      ix, #_coin
    ld      b, #COIN_ENTRY
20$:
    push    bc

    ; コインの存在
    ld      a, COIN_TYPE(ix)
    or      a
    jr      z, 29$

    ; 状態別の処理
    ld      hl, #21$
    push    hl
    ld      a, COIN_STATE(ix)
    and     #0xf0
    rrca
    rrca
    rrca
    ld      e, a
    ld      d, #0x00
    ld      hl, #coinProc
    add     hl, de
    ld      e, (hl)
    inc     hl
    ld      d, (hl)
    ex      de, hl
    jp      (hl)
;   pop     hl
21$:

    ; スプライトの設定
    ld      a, COIN_ANIMATION(ix)
    and     #0x0c
    rrca
    rrca
    ld      e, a
    ld      d, #0x00
    ld      hl, #coinSpritePattern
    add     hl, de
    ld      a, (hl)
    ld      COIN_SPRITE_PATTERN(ix), a

    ; 次のコインへ
29$:
    ld      bc, #COIN_LENGTH
    add     ix, bc
    pop     bc
    djnz    20$

    ; レジスタの復帰
    
    ; 終了
    ret

; コインを描画する
;
_CoinRender::

    ; レジスタの保存

    ; コインの描画
    ld      a, (_game + GAME_FRAME)
    rrca
    jr      c, 100$
    ld      hl, #(_sprite + GAME_SPRITE_COIN_0)
    call    110$
    ld      hl, #(_sprite + GAME_SPRITE_COIN_0)
    ld      de, #(_sprite + GAME_SPRITE_COIN_1)
    jr      101$
100$:
    ld      hl, #(_sprite + GAME_SPRITE_COIN_1)
    call    110$
    ld      hl, #(_sprite + GAME_SPRITE_COIN_1)
    ld      de, #(_sprite + GAME_SPRITE_COIN_0)
;   jr      101$
101$:
    jr      120$

    ; 単独のコインの描画
110$:
    ld      ix, #_coin
    ld      de, (coinSpriteRotation)
    ld      b, #COIN_ENTRY
111$:
    push    bc
    ld      a, COIN_TYPE(ix)
    or      a
    jr      z, 119$
    push    hl
    add     hl, de
    ld      a, COIN_POSITION_Y_H(ix)
    add     a, COIN_SPRITE_Y(ix)
    ld      (hl), a
    inc     hl
    ld      a, COIN_POSITION_X_H(ix)
    add     a, COIN_SPRITE_X(ix)
    ld      (hl), a
    inc     hl
    ld      a, COIN_SPRITE_PATTERN(ix)
    ld      (hl), a
    inc     hl
    ld      a, COIN_SPRITE_COLOR(ix)
    ld      (hl), a
;   inc     hl
    pop     hl
    ld      a, e
    add     a, #0x04
    and     #0x0f
    ld      e, a
119$:
    ld      bc, #COIN_LENGTH
    add     ix, bc
    pop     bc
    djnz    111$
    ret

    ; 境界上のコインの描画
120$:
    ld      b, #COIN_ENTRY
121$:
    ld      c, (hl)
    inc     hl
    ld      a, (hl)
    cp      #0xf1
    jr      nc, 122$
    inc     hl
    inc     hl
    inc     hl
    jr      129$
122$:
    ld      a, c
    ld      (de), a
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
;   jr      129$
129$:
    djnz    121$

    ; スプライトのローテーション
    ld      a, (coinSpriteRotation)
    add     a, #0x04
    and     #0x0f
    ld      (coinSpriteRotation), a

    ; レジスタの復帰

    ; 終了
    ret

; 何もしない
;
CoinNull:

    ; レジスタの保存

    ; レジスタの復帰

    ; 終了
    ret

; コインを出現させる
;
CoinIn:

    ; レジスタの保存

    ; 初期化
    ld      a, COIN_STATE(ix)
    and     #0x0f
    jr      nz, 09$

    ; 0 の設定
    ld      c, #0x00

    ; 位置の設定
    call    _SystemGetRandom
    ld      COIN_POSITION_X_L(ix), c
    ld      COIN_POSITION_X_H(ix), a
    ld      COIN_POSITION_Y_L(ix), c
    ld      COIN_POSITION_Y_H(ix), #0xd0

    ; 速度の設定
    ld      COIN_SPEED_X_L(ix), c
    ld      COIN_SPEED_X_H(ix), c
    ld      COIN_SPEED_Y_L(ix), c
    ld      COIN_SPEED_Y_H(ix), #COIN_SPEED_Y_START

    ; スプライトの設定
    ld      e, COIN_TYPE(ix)
    ld      d, #0x00
    ld      hl, #coinSpriteColor
    add     hl, de
    ld      a, (hl)
    ld      COIN_SPRITE_Y(ix), #COIN_SPRITE_OFFSET_Y
    ld      COIN_SPRITE_X(ix), #COIN_SPRITE_OFFSET_X
    ld      COIN_SPRITE_PATTERN(ix), c
    ld      COIN_SPRITE_COLOR(ix), a

    ; 初期化の完了
    inc     COIN_STATE(ix)
09$:

    ; 移動
    call    CoinMove

    ; 着地
    bit     #0x07, COIN_SPEED_Y_H(ix)
    jr      nz, 19$
    ld      a, COIN_POSITION_X_H(ix)
    call    _BackGetCeilingY
    cp      COIN_POSITION_Y_H(ix)
    jr      c, 10$
    jr      nz, 19$
10$:
    ld      COIN_POSITION_Y_L(ix), #0x00
    ld      COIN_POSITION_Y_H(ix), a

    ; 状態の更新
    ld      COIN_STATE(ix), #COIN_STATE_STAY
;   jr      19$
19$:

    ; アニメーションの更新
    inc     COIN_ANIMATION(ix)

    ; レジスタの復帰

    ; 終了
    ret

; 待機する
;
CoinStay:

    ; レジスタの保存

    ; 位置の保存
    ld      a, COIN_POSITION_Y_H(ix)
    ld      COIN_WORK(ix), a

    ; 着地
    ld      a, COIN_POSITION_X_H(ix)
    call    _BackGetCeilingY
    ld      COIN_POSITION_Y_H(ix), a

    ; ヒットの判定
    call    _GameIsOver
    jr      c, 19$
    cp      COIN_WORK(ix)
    jr      z, 19$
    jr      c, 19$

    ; 位置の復帰
    ld      a, COIN_WORK(ix)
    ld      COIN_POSITION_Y_H(ix), a

    ; 状態の更新
    ld      COIN_STATE(ix), #COIN_STATE_HIT
;   jr      19$
19$:

    ; アニメーションの更新
    inc     COIN_ANIMATION(ix)

    ; レジスタの復帰

    ; 終了
    ret

; コインがヒットした
;
CoinHit:

    ; レジスタの保存

    ; 初期化
    ld      a, COIN_STATE(ix)
    and     #0x0f
    jr      nz, 09$

    ; ワークの設定
    ld      COIN_WORK(ix), #0x18

    ; SE の再生
    ld      a, #SOUND_SE_COIN
    call    _SoundPlaySe

    ; 初期化の完了
    inc     COIN_STATE(ix)
09$:

    ; 速度の設定
    ld      hl, #(-0x0100 - COIN_SPEED_GRAVITY)
    ld      COIN_SPEED_Y_L(ix), l
    ld      COIN_SPEED_Y_H(ix), h

    ; 移動
    call    CoinMove

    ; ワークの更新
    dec     COIN_WORK(ix)
    jr      nz, 19$

    ; コインの加算
    ld      a, COIN_TYPE(ix)
    call    _GameAddCoin

    ; ジェネレータの更新
    ld      e, COIN_TYPE(ix)
    ld      d, #0x00
    ld      hl, #(coinGenerator + COIN_GENERATOR_COUNT)
    add     hl, de
    inc     (hl)

    ; 削除
    ld      COIN_TYPE(ix), #COIN_TYPE_NULL
;   jr      19$
19$:

    ; アニメーションの更新
    inc     COIN_ANIMATION(ix)
    inc     COIN_ANIMATION(ix)

    ; レジスタの復帰

    ; 終了
    ret

; コインを移動させる
;
CoinMove:

    ; レジスタの保存

;   ; X の移動
;   ld      l, COIN_SPEED_X_L(ix)
;   ld      h, COIN_SPEED_X_H(ix)
;   ld      a, h
;   or      l
;   jr      z, 12$
;   ld      de, #COIN_SPEED_BRAKE
;   bit     #0x07, h
;   jr      z, 10$
;   or      a
;   adc     hl, de
;   jr      nc, 12$
;   jr      11$
;10$:
;   or      a
;   sbc     hl, de
;   jr      nc, 12$
;   jr      11$
;11$:
;   ld      hl, #0x0000
;12$:
;   ld      COIN_SPEED_X_L(ix), l
;   ld      COIN_SPEED_X_H(ix), h
;   ld      e, COIN_POSITION_X_L(ix)
;   ld      d, COIN_POSITION_X_H(ix)
;   add     hl, de
;   ld      COIN_POSITION_X_L(ix), l
;   ld      COIN_POSITION_X_H(ix), h

    ; Y の移動
    ld      l, COIN_SPEED_Y_L(ix)
    ld      h, COIN_SPEED_Y_H(ix)
    ld      de, #COIN_SPEED_GRAVITY
    or      a
    adc     hl, de
    jp      m, 20$
    ld      a, h
    cp      #COIN_SPEED_Y_MAXIMUM
    jr      c, 20$
    ld      hl, #(COIN_SPEED_Y_MAXIMUM << 8)
20$:
    ld      COIN_SPEED_Y_L(ix), l
    ld      COIN_SPEED_Y_H(ix), h
    ld      e, COIN_POSITION_Y_L(ix)
    ld      d, COIN_POSITION_Y_H(ix)
    add     hl, de
    ld      COIN_POSITION_Y_L(ix), l
    ld      COIN_POSITION_Y_H(ix), h

    ; レジスタの復帰

    ; 終了
    ret

; 定数の定義
;

; 状態別の処理
;
coinProc:

    .dw     CoinNull
    .dw     CoinIn
    .dw     CoinStay
    .dw     CoinHit

; スプライト
;
coinSpritePattern:

    .db     0x10, 0x14, 0x18, 0x14, 0x1c, 0x14, 0x18, 0x14

coinSpriteColor:

    .db     VDP_COLOR_TRANSPARENT
    .db     VDP_COLOR_DARK_RED
    .db     VDP_COLOR_GRAY
    .db     VDP_COLOR_LIGHT_YELLOW


; DATA 領域
;
    .area   _DATA

; 変数の定義
;

; コイン
;
_coin::
    
    .ds     COIN_ENTRY * COIN_LENGTH

; ジェネレータ
;
coinGenerator:

    .ds     COIN_GENERATOR_LENGTH

; スプライト
;
coinSpriteRotation:

    .ds     0x02
