; Jester.s : 道化師
;


; モジュール宣言
;
    .module Jester

; 参照ファイル
;
    .include    "bios.inc"
    .include    "vdp.inc"
    .include    "System.inc"
    .include    "Sound.inc"
    .include    "App.inc"
    .include    "Game.inc"
    .include	"Jester.inc"

; 外部変数宣言
;

; マクロの定義
;


; CODE 領域
;
    .area   _CODE

; 道化師を初期化する
;
_JesterInitialize::
    
    ; レジスタの保存
    
    ; 道化師の初期化
    ld      de, #jesterPosition
    ld      ix, #_jester
    ld      b, #JESTER_ENTRY
10$:
    push    bc
    ld      a, (de)
    ld      JESTER_POSITION_X(ix), a
    inc     de
    ld      a, (de)
    ld      JESTER_POSITION_Y(ix), a
    inc     de
    call    _SystemGetRandom
    ld      JESTER_OFFSET(ix), a
    call    _SystemGetRandom
    and     #0x03
    ld      c, a
    ld      b, #0x00
    ld      hl, #jesterColor
    add     hl, bc
    ld      a, (hl)
    ld      JESTER_COLOR(ix), a
    ld      bc, #JESTER_LENGTH
    add     ix, bc
    pop     bc
    djnz    10$

    ; レジスタの復帰
    
    ; 終了
    ret

; 道化師を更新する
;
_JesterUpdate::
    
    ; レジスタの保存

    ; 道化師の走査
    ld      ix, #_jester
    ld      b, #JESTER_ENTRY
10$:
    push    bc

    ; 道化師の更新

    ; オフセットの更新
    inc     JESTER_OFFSET(ix)

    ; 次の道化師へ
19$:
    ld      bc, #JESTER_LENGTH
    add     ix, bc
    pop     bc
    djnz    10$

    ; レジスタの復帰
    
    ; 終了
    ret

; 道化師を描画する
;
_JesterRender::

    ; レジスタの保存

    ; 道化師の走査
    ld      ix, #_jester
    ld      hl, #(_sprite + GAME_SPRITE_JESTER)
    ld      b, #JESTER_ENTRY
10$:
    push    bc

    ; スプライトの描画
    ld      a, JESTER_POSITION_Y(ix)
    dec     a
    ld      (hl), a
    inc     hl
    ld      a, JESTER_OFFSET(ix)
    rrca
    rrca
    ld      c, a
    and     #0x1f
    cp      #0x11
    jr      c, 11$
    sub     #0x20
    neg
11$:
    add     a, JESTER_POSITION_X(ix)
    ld      (hl), a
    inc     hl
    ld      a, c
    and     #0x04
    add     a, #0x38
    ld      (hl), a
    inc     hl
    ld      a, JESTER_COLOR(ix)
    ld      (hl), a
    inc     hl

    ; 次の道化師へ
19$:
    ld      bc, #JESTER_LENGTH
    add     ix, bc
    pop     bc
    djnz    10$

    ; レジスタの復帰

    ; 終了
    ret

; 定数の定義
;

; 位置
;
jesterPosition:

    .db     0x50, 0x20
    .db     0x90, 0x20
    .db     0x20, 0x30
    .db     0xc0, 0x30
    .db     0x10, 0x00
    .db     0xd0, 0x00

; 色
;
jesterColor:

    .db     VDP_COLOR_MEDIUM_RED
    .db     VDP_COLOR_MEDIUM_GREEN
    .db     VDP_COLOR_LIGHT_BLUE
    .db     VDP_COLOR_DARK_YELLOW


; DATA 領域
;
    .area   _DATA

; 変数の定義
;

; 道化師
;
_jester::
    
    .ds     JESTER_ENTRY * JESTER_LENGTH

