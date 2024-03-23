; Back.s : 背景
;


; モジュール宣言
;
    .module Back

; 参照ファイル
;
    .include    "bios.inc"
    .include    "vdp.inc"
    .include    "System.inc"
    .include    "Sound.inc"
    .include    "App.inc"
    .include    "Game.inc"
    .include	"Back.inc"

; 外部変数宣言
;
    .globl  _patternTable

; マクロの定義
;


; CODE 領域
;
    .area   _CODE

; 背景を初期化する
;
_BackInitialize::
    
    ; レジスタの保存
    
    ; 背景の初期化
    ld      hl, #backDefault
    ld      de, #_back
    ld      bc, #BACK_LENGTH
    ldir

;   ; 状態の設定
;   ld      a, #BACK_STATE_NULL
;   ld      (_back + BACK_STATE), a
    
    ; レジスタの復帰
    
    ; 終了
    ret

; 背景を更新する
;
_BackUpdate::
    
    ; レジスタの保存

    ; 初期化
    ld      a, (_back + BACK_STATE)
    or      a
    jr      nz, 09$

    ; ブロックの表示
    call    BackPrintBlock

    ; 床の表示
    call    BackPrintFloor

    ; 初期化の完了
    ld      hl, #(_back + BACK_STATE)
    inc     (hl)
09$:

    ; 天井の表示
    call    BackPrintCeiling

    ; レジスタの復帰
    
    ; 終了
    ret

; 背景を描画する
;
_BackRender::

    ; レジスタの保存

    ; レジスタの復帰

    ; 終了
    ret

; 背景を転送する
;
_BackTransfer::

    ; レジスタの保存

    ; d < ポート #0
    ; e < ポート #1

    ; パターンジェネレータの取得    
    ld      a, (_videoRegister + VDP_R4)
    add     a, a
    add     a, a
    add     a, a
    add     a, #0x03
    ld      l, #0xa0    ; 0x03a0 = 0x74 * 0x08

    ; VRAM アドレスの設定
    ld      c, e
    out     (c), l
    or      #0b01000000
    out     (c), a

    ; パターンネームテーブルの転送
    ld      c, d
    ld      hl, (_back + BACK_TRANSFER_L)
    ld      b, #0x20
10$:
    outi
    jp      nz, 10$

    ; レジスタの復帰

    ; 終了
    ret

; 天井にヒットする
;
_BackHitCeiling::

    ; レジスタの保存

    ; de = ヒットする Y/X 位置

    ; 位置と転送の取得
    ld      a, e
    ld      (_back + BACK_HIT_X), a
    and     #0x07
    ld      e, a
    ld      a, #BACK_CEILING_Y
    sub     d
    jr      nc, 10$
    xor     a
    jr      11$
10$:
    cp      #(BACK_CEILING_HIT_HEIGHT + 0x01)
    jr      c, 11$
    ld      a, #BACK_CEILING_HIT_HEIGHT
11$:
    ld      (_back + BACK_HIT_Y), a
    and     #0x07
    rrca
    rrca
    rrca
    ld      d, e
    ld      e, a
    ld      hl, #(_patternTable + 0x1000)
    add     hl, de
    ld      (_back + BACK_TRANSFER_L), hl

    ; レジスタの復帰

    ; 終了
    ret

; 天井の高さを取得する
;
_BackGetCeilingY::

    ; レジスタの保存

    ; a < X 位置
    ; a > Y 位置

    ; 高さの取得
    ld      e, a
    ld      a, (_back + BACK_HIT_X)
    sub     #0x08
    sub     e
    neg
    cp      #0x20
    jr      nc, 18$
    ld      e, a
    ld      a, (_back + BACK_HIT_Y)
    rrca
    rrca
    rrca
    add     a, e
    ld      e, a
    ld      d, #0x00
    ld      hl, #backHitY
    add     hl, de
    ld      a, #BACK_CEILING_Y
    sub     (hl)
    jr      19$
18$:
    ld      a, #BACK_CEILING_Y
19$:

    ; レジスタの復帰

    ; 終了
    ret

; ブロックを表示する
;
BackPrintBlock:

    ; レジスタの保存

    ; ブロックの描画
    ld      de, #0x001c
    ld      hl, #(_patternName + 0x008e)
    call    10$
    ld      hl, #(_patternName + 0x00ca)
    call    10$
    ld      hl, #(_patternName + 0x00d2)
    call    10$
    ld      hl, #(_patternName + 0x0104)
    call    10$
    ld      hl, #(_patternName + 0x0118)
    call    10$
    ld      hl, #(_patternName + 0x0042)
    call    10$
    ld      hl, #(_patternName + 0x005a)
    call    10$
    jr      19$
10$:
    call    _SystemGetRandom
    and     #0x18
    add     a, #0x40
    ld      b, #0x04
11$:
    ld      (hl), a
    inc     hl
    inc     a
    djnz    11$
    add     hl, de
    ld      b, #0x04
12$:
    ld      (hl), a
    inc     hl
    inc     a
    djnz    12$
    ret
19$:

    ; レジスタの復帰

    ; 終了
    ret

; 床を表示する
;
BackPrintFloor:

    ; レジスタの保存

    ; 五線譜の表示
    ld      hl, #(_patternName + 0x0280)
    ld      de, #(_patternName + 0x0281)
    ld      bc, #0x001f
    ld      (hl), #0x6a
    ldir
    inc     hl
    inc     de
    ld      bc, #0x001f
    ld      (hl), #0x6b
    ldir
    inc     hl
    inc     de
    ld      bc, #0x001f
    ld      (hl), #0x6c
    ldir

    ; ト音記号の表示
    ld      hl, #(_patternName + 0x0261)
    ld      de, #0x001e
    ld      a, #0x60
    ld      b, #0x05
20$:
    ld      (hl), a
    inc     hl
    inc     a
    ld      (hl), a
    inc     hl
    inc     a
    add     hl, de
    djnz    20$

    ; レジスタの復帰

    ; 終了
    ret

; 天井を表示する
;
BackPrintCeiling:

    ; レジスタの保存

    ; 天井の表示
    ld      hl, #(_patternName + ((BACK_CEILING_Y - 0x08) / 0x08 * 0x20 + 0x00))
    ld      de, #(_patternName + ((BACK_CEILING_Y - 0x08) / 0x08 * 0x20 + 0x01))
    ld      bc, #0x001f
    ld      (hl), #0x70
    ldir

    ; ヒットの表示
    ld      a, (_back + BACK_HIT_Y)
    or      a
    jr      z, 29$
    ld      a, (_back + BACK_HIT_X)
    sub     #0x08
    and     #0xf8
    rrca
    rrca
    rrca
    ld      de, #(_patternName + ((BACK_CEILING_Y - 0x08) / 0x08 * 0x20))
    ld      c, #0x74
    ld      b, #0x04
20$:
    ld      l, a
    ld      h, #0x00
    add     hl, de
    ld      (hl), c
    inc     c
    inc     a
    and     #0x1f
    djnz    20$
29$:

    ; レジスタの復帰

    ; 終了
    ret

; 定数の定義
;

; 背景の初期値
;
backDefault:

    .db     BACK_STATE_NULL
    .db     BACK_FLAG_NULL
    .db     BACK_HIT_NULL
    .db     BACK_HIT_NULL
    .dw     BACK_TRANSFER_NULL

; ヒット
;
backHitY:

    .db     0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    .db     0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    .db     0, 0, 0, 0, 0, 0, 1, 1, 2, 2, 2, 2, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    .db     0, 0, 0, 0, 1, 1, 2, 2, 3, 3, 3, 3, 2, 2, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    .db     0, 0, 0, 1, 1, 2, 3, 3, 4, 4, 4, 4, 3, 3, 2, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    .db     0, 0, 1, 1, 2, 3, 4, 4, 5, 5, 5, 5, 4, 4, 3, 2, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    .db     0, 1, 1, 2, 3, 4, 5, 5, 6, 6, 6, 6, 5, 5, 4, 3, 2, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    .db     1, 1, 2, 3, 4, 5, 6, 6, 7, 7, 7, 7, 6, 6, 5, 4, 3, 2, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0


; DATA 領域
;
    .area   _DATA

; 変数の定義
;

; 背景
;
_back::
    
    .ds     BACK_LENGTH

