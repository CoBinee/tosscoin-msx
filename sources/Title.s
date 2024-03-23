; Title.s : タイトル
;


; モジュール宣言
;
    .module Title

; 参照ファイル
;
    .include    "bios.inc"
    .include    "vdp.inc"
    .include    "System.inc"
    .include    "Sound.inc"
    .include    "App.inc"
    .include	"Title.inc"

; 外部変数宣言
;

; マクロの定義
;


; CODE 領域
;
    .area   _CODE

; タイトルを初期化する
;
_TitleInitialize::
    
    ; レジスタの保存
    
    ; スプライトのクリア
    call    _SystemClearSprite
    
    ; パターンネームのクリア
    xor     a
    call    _SystemClearPatternName

    ; タイトルの初期化
    ld      hl, #titleDefault
    ld      de, #_title
    ld      bc, #TITLE_LENGTH
    ldir

    ; スコアの取得
    ld      hl, (_app + APP_SCORE_A_L)
    ld      de, #(_title + TITLE_SCORE_A_10000)
    call    _AppGetDecimal16
    ld      hl, (_app + APP_SCORE_B_L)
    ld      de, #(_title + TITLE_SCORE_B_10000)
    call    _AppGetDecimal16

    ; 転送の設定
    ld      hl, #_SystemUpdatePatternName
    ld      (_transfer), hl
    
    ; 描画の開始
    ld      hl, #(_videoRegister + VDP_R1)
    set     #VDP_R1_BL, (hl)
    
    ; 状態の設定
    ld      a, #TITLE_STATE_STAY
    ld      (_title + TITLE_STATE), a
    ld      a, #APP_STATE_TITLE_UPDATE
    ld      (_app + APP_STATE), a
    
    ; レジスタの復帰
    
    ; 終了
    ret

; タイトルを更新する
;
_TitleUpdate::
    
    ; レジスタの保存
    
    ; スプライトのクリア
    call    _SystemClearSprite

    ; 状態別の処理
    ld      hl, #10$
    push    hl
    ld      a, (_title + TITLE_STATE)
    and     #0xf0
    rrca
    rrca
    rrca
    ld      e, a
    ld      d, #0x00
    ld      hl, #titleProc
    add     hl, de
    ld      e, (hl)
    inc     hl
    ld      d, (hl)
    ex      de, hl
    jp      (hl)
;   pop     hl
10$:

    ; レジスタの復帰
    
    ; 終了
    ret

; 何もしない
;
TitleNull:

    ; レジスタの保存

    ; レジスタの復帰

    ; 終了
    ret

; 待機する
;
TitleStay:
    
    ; レジスタの保存
    
    ; 初期化の開始
    ld      a, (_title + TITLE_STATE)
    and     #0x0f
    jr      nz, 09$

    ; 背景の表示
    call    TitlePrintBack

    ; 初期化の完了
    ld      hl, #(_title + TITLE_STATE)
    inc     (hl)
09$:

    ; SPACE キーの押下
    ld      a, (_input + INPUT_BUTTON_SPACE)
    dec     a
    jr      nz, 10$

    ; 状態の更新
    ld      a, #TITLE_STATE_START
    ld      (_title + TITLE_STATE), a
    jr      19$

    ; モードの変更
10$:
    ld      a, (_input + INPUT_KEY_UP)
    dec     a
    jr      z, 11$
    ld      a, (_input + INPUT_KEY_DOWN)
    dec     a
    jr      nz, 19$
11$:
    ld      hl, #(_app + APP_MODE)
    ld      a, #0x01
    sub     (hl)
    ld      (hl), a
;   jr      19$

    ; 操作の完了
19$:

    ; フレームの更新
    ld      hl, #(_title + TITLE_FRAME)
    inc     (hl)

    ; スコアの表示
    call    TitlePrintScore

    ; カーソルの表示
    call    TitlePrintCursor

    ; 目の表示
    call    TitlePrintEye

    ; レジスタの復帰
    
    ; 終了
    ret

; ゲームを開始する
;
TitleStart:
    
    ; レジスタの保存
    
    ; 初期化の開始
    ld      a, (_title + TITLE_STATE)
    and     #0x0f
    jr      nz, 09$

    ; フレームの設定
    xor     a
    ld      (_title + TITLE_FRAME), a

    ; SE の再生
    ld      a, #SOUND_SE_BOOT
    call    _SoundPlaySe

    ; 初期化の完了
    ld      hl, #(_title + TITLE_STATE)
    inc     (hl)
09$:

    ; 点滅の更新
    ld      hl, #(_title + TITLE_BLINK)
    inc     (hl)
    ld      a, (hl)
    cp      #0x60
    jr      c, 19$

    ; アプリケーションの更新
    ld      a, #APP_STATE_GAME_INITIALIZE
    ld      (_app + APP_STATE), a
;   jr      19$
19$:

    ; カーソルの表示
    call    TitlePrintCursor

    ; 目の表示
    call    TitlePrintEye

    ; レジスタの復帰
    
    ; 終了
    ret

; 背景を表示する
;
TitlePrintBack:

    ; レジスタの保存

    ; シンボルの表示
    ld      hl, #titleBackPatternNameSymbol
    ld      de, #(_patternName + 0x0049)
    ld      a, #0x0c
10$:
    ld      bc, #0x000e
    ldir
    ex      de, hl
    ld      bc, #0x0012
    add     hl, bc
    ex      de, hl
    dec     a
    jr      nz, 10$

    ; モードの表示
    ld      hl, #titleBackStringModeA
    ld      de, #(_patternName + 0x020b)
    call    TitlePrintString
    ld      hl, #titleBackStringModeB
    ld      de, #(_patternName + 0x024b)
    call    TitlePrintString

    ; レジスタの復帰

    ; 終了
    ret

; スコアを表示する
;
TitlePrintScore:

    ; レジスタの保存

    ; スコアの表示
    ld      hl, #titleBackStringTop
    ld      de, #(_patternName + 0x02ab)
    call    TitlePrintString
    ld      a, (_app + APP_MODE)
    ld      e, a
    add     a, a
    add     a, a
    add     a, e
    ld      e, a
    ld      d, #0x00
    ld      hl, #(_title + TITLE_SCORE_A_10000)
    add     hl, de
    ld      de, #(_patternName + 0x02b0)
    ld      b, #0x05
    call    TitlePrintValue

    ; レジスタの復帰

    ; 終了
    ret

; カーソルを表示する
;
TitlePrintCursor:

    ; レジスタの保存

    ; カーソルの表示
    ld      a, (_title + TITLE_BLINK)
    and     #0x04
    jr      nz, 19$
    ld      hl, #(_sprite + TITLE_SPRITE_MODE)
    ld      a, (_app + APP_MODE)
    add     a, a
    add     a, a
    add     a, a
    add     a, a
    add     a, #(0x7c - 0x01)
    ld      (hl), a
    inc     hl
    ld      (hl), #0x3c
    inc     hl
    ld      a, (_title + TITLE_FRAME)
    and     #0x08
    rrca
    add     a, #0x08
    ld      (hl), a
    inc     hl
    ld      (hl), #VDP_COLOR_LIGHT_YELLOW
;   inc     hl
19$:

    ; レジスタの復帰

    ; 終了
    ret

; 目を表示する
;
TitlePrintEye:

    ; レジスタの保存

    ; 目の表示
    ld      a, (_title + TITLE_FRAME)
    and     #0xe0
    rrca
    rrca
    ld      e, a
    ld      d, #0x00
    ld      hl, #titleBackSpriteEye
    add     hl, de
    ld      de, #(_sprite + TITLE_SPRITE_EYE)
    ld      bc, #0x0008
    ldir

    ; レジスタの復帰

    ; 終了
    ret

; 文字列を表示する
;
TitlePrintString:

    ; レジスタの保存

    ; hl < 文字列
    ; de < 表示位置

    ; 文字列の表示
10$:
    ld      a, (hl)
    or      a
    jr      z, 19$
    sub     #0x20
    ld      (de), a
    inc     hl
    inc     de
    jr      10$
19$:

    ; レジスタの復帰

    ; 終了
    ret

; 数値を右詰で表示する
;
TitlePrintValue:

    ; レジスタの保存

    ; hl < 数値
    ; de < 表示位置
    ; b  < 桁数

    ; 数値の表示
    dec     b
    jr      z, 11$
10$:
    ld      a, (hl)
    or      a
    jr      nz, 11$
    ld      (de), a
    inc     hl
    inc     de
    djnz    10$
11$:
    inc     b
12$:
    ld      a, (hl)
    add     a, #0x10
    ld      (de), a
    inc     hl
    inc     de
    djnz    12$

    ; レジスタの復帰

    ; 終了
    ret

; 定数の定義
;

; 状態別の処理
;
titleProc:
    
    .dw     TitleNull
    .dw     TitleStay
    .dw     TitleStart

; タイトルの初期値
;
titleDefault:

    .db     TITLE_STATE_NULL
    .db     TITLE_FRAME_NULL
    .db     TITLE_TIMER_NULL
    .db     TITLE_BLINK_NULL
    .db     TITLE_SCORE_NULL, TITLE_SCORE_NULL, TITLE_SCORE_NULL, TITLE_SCORE_NULL, TITLE_SCORE_NULL
    .db     TITLE_SCORE_NULL, TITLE_SCORE_NULL, TITLE_SCORE_NULL, TITLE_SCORE_NULL, TITLE_SCORE_NULL

; 背景
;
titleBackPatternNameSymbol:

    .db     0x00, 0x80, 0x81, 0x00, 0x82, 0x00, 0x00, 0x00, 0x00, 0x83, 0x00, 0x84, 0x85, 0x00
    .db     0x00, 0x86, 0x87, 0x88, 0x89, 0x8a, 0x8b, 0x8c, 0x8d, 0x8e, 0x8f, 0x90, 0x91, 0x00
    .db     0x00, 0x00, 0x92, 0x93, 0x94, 0x95, 0x96, 0x97, 0x98, 0x99, 0x9a, 0x9b, 0x00, 0x00
    .db     0x00, 0x9c, 0x9d, 0x9e, 0x9f, 0xa0, 0xa1, 0xa2, 0xa3, 0xa4, 0xa5, 0xa6, 0xa7, 0x00
    .db     0xa8, 0xa9, 0xaa, 0xab, 0xac, 0xad, 0xae, 0xaf, 0xb0, 0xb1, 0xb2, 0xb3, 0xb4, 0xb5
    .db     0xb6, 0xb7, 0xb8, 0xb9, 0xba, 0xbb, 0xbc, 0xbd, 0xbe, 0xbf, 0xc0, 0xc1, 0xc2, 0xc3
    .db     0x00, 0x00, 0xc4, 0xc5, 0xc6, 0xc7, 0xc8, 0xc9, 0xca, 0xcb, 0xcc, 0xcd, 0x00, 0x00
    .db     0x00, 0xce, 0xcf, 0xd0, 0xd1, 0xd2, 0xd3, 0xd4, 0xd5, 0xd6, 0xd7, 0xd8, 0xd9, 0x00
    .db     0xda, 0xdb, 0xdc, 0xdd, 0xde, 0xdf, 0xe0, 0xe1, 0xe2, 0xe3, 0xe4, 0xe5, 0xe6, 0xe7
    .db     0xe8, 0x00, 0x00, 0xe9, 0xea, 0xeb, 0xec, 0xed, 0xee, 0xef, 0xf0, 0x00, 0x00, 0xf1
    .db     0x00, 0x00, 0x00, 0xf2, 0x00, 0x00, 0xf3, 0xf4, 0x00, 0x00, 0xf5, 0x00, 0x00, 0x00
    .db     0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0xf6, 0xf7, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00

titleBackStringModeA:

    .ascii  "MARCHING GAME"
    .db     0x00

titleBackStringModeB:

    .ascii  "FREE RUN GAME"
    .db     0x00

titleBackStringTop:

    .ascii  "TOP -"
    .db     0x00

titleBackSpriteEye:

    .db     0x28 - 0x01, 0x68, 0xa0, VDP_COLOR_LIGHT_RED
    .db     0x28 - 0x01, 0x88, 0xa4, VDP_COLOR_LIGHT_RED
    .db     0x28 - 0x01, 0x68, 0xa0, VDP_COLOR_MEDIUM_RED
    .db     0x28 - 0x01, 0x88, 0xa4, VDP_COLOR_MEDIUM_RED
    .db     0x28 - 0x01, 0x68, 0xa0, VDP_COLOR_DARK_RED
    .db     0x28 - 0x01, 0x88, 0xa4, VDP_COLOR_DARK_RED
    .db     0x28 - 0x01, 0x68, 0xa0, VDP_COLOR_TRANSPARENT
    .db     0x28 - 0x01, 0x88, 0xa4, VDP_COLOR_TRANSPARENT
    .db     0x28 - 0x01, 0x68, 0xa0, VDP_COLOR_TRANSPARENT
    .db     0x28 - 0x01, 0x88, 0xa4, VDP_COLOR_TRANSPARENT
    .db     0x28 - 0x01, 0x68, 0xa0, VDP_COLOR_DARK_RED
    .db     0x28 - 0x01, 0x88, 0xa4, VDP_COLOR_DARK_RED
    .db     0x28 - 0x01, 0x68, 0xa0, VDP_COLOR_MEDIUM_RED
    .db     0x28 - 0x01, 0x88, 0xa4, VDP_COLOR_MEDIUM_RED
    .db     0x28 - 0x01, 0x68, 0xa0, VDP_COLOR_LIGHT_RED
    .db     0x28 - 0x01, 0x88, 0xa4, VDP_COLOR_LIGHT_RED


; DATA 領域
;
    .area   _DATA

; 変数の定義
;

; タイトル
;
_title::

    .ds     TITLE_LENGTH
