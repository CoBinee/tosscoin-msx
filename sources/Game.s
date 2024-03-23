; Game.s : ゲーム
;


; モジュール宣言
;
    .module Game

; 参照ファイル
;
    .include    "bios.inc"
    .include    "vdp.inc"
    .include    "System.inc"
    .include    "Sound.inc"
    .include    "App.inc"
    .include	"Game.inc"
    .include    "Player.inc"
    .include    "Coin.inc"
    .include    "Back.inc"
    .include    "Bard.inc"
    .include    "Jester.inc"

; 外部変数宣言
;

; マクロの定義
;


; CODE 領域
;
    .area   _CODE

; ゲームを初期化する
;
_GameInitialize::
    
    ; レジスタの保存
    
    ; スプライトのクリア
    call    _SystemClearSprite
    
    ; パターンネームのクリア
    xor     a
    call    _SystemClearPatternName
    
    ; ゲームの初期化
    ld      hl, #gameDefault
    ld      de, #_game
    ld      bc, #GAME_LENGTH
    ldir

    ; モードの取得
    ld      a, (_app + APP_MODE)
    or      a
    jr      z, 10$
    ld      hl, #(_game + GAME_FLAG)
    set     #GAME_FLAG_FREE_BIT, (hl)
10$:

    ; プレイヤの初期化
    call    _PlayerInitialize

    ; コインの初期化
    call    _CoinInitialize

    ; 背景の初期化
    call    _BackInitialize

    ; 吟遊詩人の初期化
    call    _BardInitialize

    ; 道化師の初期化
    call    _JesterInitialize

    ; 転送の設定
    ld      hl, #GameTransfer
    ld      (_transfer), hl
    
    ; 描画の開始
    ld      hl, #(_videoRegister + VDP_R1)
    set     #VDP_R1_BL, (hl)
    
    ; 状態の設定
    ld      a, #GAME_STATE_START
    ld      (_game + GAME_STATE), a
    ld      a, #APP_STATE_GAME_UPDATE
    ld      (_app + APP_STATE), a
    
    ; レジスタの復帰
    
    ; 終了
    ret

; ゲームを更新する
;
_GameUpdate::
    
    ; レジスタの保存
    
    ; スプライトのクリア
    call    _SystemClearSprite

    ; 状態別の処理
    ld      hl, #10$
    push    hl
    ld      a, (_game + GAME_STATE)
    and     #0xf0
    rrca
    rrca
    rrca
    ld      e, a
    ld      d, #0x00
    ld      hl, #gameProc
    add     hl, de
    ld      e, (hl)
    inc     hl
    ld      d, (hl)
    ex      de, hl
    jp      (hl)
;   pop     hl
10$:

    ; フレームの更新
    ld      hl, #(_game + GAME_FRAME)
    inc     (hl)

    ; レジスタの復帰
    
    ; 終了
    ret

; 何もしない
;
GameNull:

    ; レジスタの保存

    ; レジスタの復帰

    ; 終了
    ret

; ゲームを開始する
;
GameStart:

    ; レジスタの保存

    ; 初期化の開始
    ld      a, (_game + GAME_STATE)
    and     #0x0f
    jr      nz, 09$

    ; タイマの設定
    ld      a, #0x60
    ld      (_game + GAME_TIMER), a

;   ; パターンネームのクリア
;   xor     a
;   call    _SystemClearPatternName
    
    ; 開始の表示
    call    GamePrintStart

    ; BGM の再生
    ld      a, #SOUND_BGM_TOSSCOIN
    call    _SoundPlayBgm
    
    ; 初期化の完了
    ld      hl, #(_game + GAME_STATE)
    inc     (hl)
09$:

    ; タイマの更新
    ld      hl, #(_game + GAME_TIMER)
    dec     (hl)
    jr      nz, 19$

    ; 状態の更新
    ld      a, #GAME_STATE_PLAY
    ld      (_game + GAME_STATE), a
;   jr      19$
19$:

    ; レジスタの復帰

    ; 終了
    ret

; ゲームをプレイする
;
GamePlay:
    
    ; レジスタの保存
    
    ; 初期化の開始
    ld      a, (_game + GAME_STATE)
    and     #0x0f
    jr      nz, 09$

    ; タイマの設定
    ld      a, #0xc0
    ld      (_game + GAME_TIMER), a

    ; パターンネームのクリア
    xor     a
    call    _SystemClearPatternName
    
    ; 初期化の完了
    ld      hl, #(_game + GAME_STATE)
    inc     (hl)
09$:

    ; プレイヤの更新
    call    _PlayerUpdate

    ; コインの更新
    call    _CoinUpdate

    ; 背景の更新
    call    _BackUpdate

    ; 吟遊詩人の更新
    call    _BardUpdate

    ; 道化師の更新
    call    _JesterUpdate

    ; プレイヤの描画
    call    _PlayerRender

    ; コインの描画
    call    _CoinRender

    ; 背景の描画
    call    _BackRender

    ; 吟遊詩人の描画
    call    _BardRender

    ; 道化師の描画
    call    _JesterRender

    ; ゲームオーバーの監視
    ld      hl, #(_game + GAME_FLAG)
    bit     #GAME_FLAG_OVER_BIT, (hl)
    jr      nz, 10$

    ; ゲームオーバーの判定
    call    _SoundIsPlayBgm
    jr      c, 19$
;   ld      a, (_input + INPUT_BUTTON_SHIFT)
;   dec     a
;   jr      nz, 19$

    ; フラグの設定
    ld      hl, #(_game + GAME_FLAG)
    set     #GAME_FLAG_OVER_BIT, (hl)
    jr      19$

    ; タイマの更新
10$:
    ld      hl, #(_game + GAME_TIMER)
    dec     (hl)
    jr      nz, 19$

    ; 状態の更新
    ld      a, #GAME_STATE_RESULT
    ld      (_game + GAME_STATE), a
;   jr      19$
19$:

    ; レジスタの復帰
    
    ; 終了
    ret

; 結果を示す
;
GameResult:

    ; レジスタの保存

    ; 初期化の開始
    ld      a, (_game + GAME_STATE)
    and     #0x0f
    jr      nz, 09$

    ; タイマの設定
    ld      a, #0x30
    ld      (_game + GAME_TIMER), a

    ; パターンネームのクリア
    xor     a
    call    _SystemClearPatternName

    ; タイトルの表示
    call    GamePrintResultTitle

    ; 初期化の完了
    ld      hl, #(_game + GAME_STATE)
    inc     (hl)
09$:

    ; タイマの更新
    ld      hl, #(_game + GAME_TIMER)
    ld      a, (hl)
    or      a
    jr      z, 100$
    dec     (hl)
    jp      190$
100$:
    ld      a, (_game + GAME_STATE)
    and     #0x0f
    dec     a
    jr      z, 110$
    dec     a
    jr      z, 120$
    dec     a
    jr      z, 130$
    dec     a
    jp      z, 140$
    dec     a
    jp      z, 150$

    ; アプリケーションの更新
    ld      a, #APP_STATE_TITLE_INITIALIZE
    ld      (_app + APP_STATE), a
    jp      190$

    ; 0x01 : 銅貨のカウント
110$:
    ld      hl, #(_game + GAME_FLAG)
    bit     #GAME_FLAG_RESULT_BRONZE_BIT, (hl)
    jr      nz, 111$
    set     #GAME_FLAG_RESULT_BRONZE_BIT, (hl)
    ld      a, #0x30
    ld      (_game + GAME_TIMER), a
    jr      119$
111$:
    ld      hl, #(_game + GAME_RESULT_BRONZE)
    ld      a, (_game + GAME_COIN_BRONZE)
    cp      (hl)
    jr      z, 112$
    inc     (hl)
    ld      hl, (_game + GAME_SCORE_BRONZE_L)
;   ld      de, #0x0001
;   add     hl, de
    inc     hl
    ld      (_game + GAME_SCORE_BRONZE_L), hl
    jr      119$
112$:
    ld      a, #0x30
    ld      (_game + GAME_TIMER), a
    ld      hl, #(_game + GAME_STATE)
    inc     (hl)
;   jr      119$
119$:
    call    GamePrintResultBronze
    jp      190$

    ; 0x02 : 銀貨のカウント
120$:
    ld      hl, #(_game + GAME_FLAG)
    bit     #GAME_FLAG_RESULT_SILVER_BIT, (hl)
    jr      nz, 121$
    set     #GAME_FLAG_RESULT_SILVER_BIT, (hl)
    ld      a, #0x30
    ld      (_game + GAME_TIMER), a
    jr      129$
121$:
    ld      hl, #(_game + GAME_RESULT_SILVER)
    ld      a, (_game + GAME_COIN_SILVER)
    cp      (hl)
    jr      z, 122$
    inc     (hl)
    ld      hl, (_game + GAME_SCORE_SILVER_L)
    ld      de, #0x0003
    add     hl, de
    ld      (_game + GAME_SCORE_SILVER_L), hl
    jr      129$
122$:
    ld      a, #0x30
    ld      (_game + GAME_TIMER), a
    ld      hl, #(_game + GAME_STATE)
    inc     (hl)
;   jr      129$
129$:
    call    GamePrintResultSilver
    jp      190$

    ; 0x03 : 金貨のカウント
130$:
    ld      hl, #(_game + GAME_FLAG)
    bit     #GAME_FLAG_RESULT_GOLD_BIT, (hl)
    jr      nz, 131$
    set     #GAME_FLAG_RESULT_GOLD_BIT, (hl)
    ld      a, #0x30
    ld      (_game + GAME_TIMER), a
    jr      139$
131$:
    ld      hl, #(_game + GAME_RESULT_GOLD)
    ld      a, (_game + GAME_COIN_GOLD)
    cp      (hl)
    jr      z, 132$
    inc     (hl)
    ld      hl, (_game + GAME_SCORE_GOLD_L)
    ld      de, #0x000a
    add     hl, de
    ld      (_game + GAME_SCORE_GOLD_L), hl
    jr      139$
132$:
    ld      a, #0x30
    ld      (_game + GAME_TIMER), a
    ld      hl, #(_game + GAME_STATE)
    inc     (hl)
;   jr      139$
139$:
    call    GamePrintResultGold
    jr      190$

    ; 0x04 : トータル
140$:
    ld      hl, #(_game + GAME_FLAG)
    bit     #GAME_FLAG_RESULT_TOTAL_BIT, (hl)
    jr      nz, 141$
    set     #GAME_FLAG_RESULT_TOTAL_BIT, (hl)
    ld      hl, (_game + GAME_SCORE_BRONZE_L)
    ld      de, (_game + GAME_SCORE_SILVER_L)
    add     hl, de
    ld      de, (_game + GAME_SCORE_GOLD_L)
    add     hl, de
    ld      (_game + GAME_SCORE_TOTAL_L), hl
    ld      a, #0x30
    ld      (_game + GAME_TIMER), a
    jr      149$
141$:
    ld      a, (_app + APP_MODE)
    add     a, a
    ld      e, a
    ld      d, #0x00
    ld      hl, #(_app + APP_SCORE_A_L)
    add     hl, de
    ld      e, l
    ld      d, h
    ld      c, (hl)
    inc     hl
    ld      b, (hl)
    ld      hl, (_game + GAME_SCORE_TOTAL_L)
    or      a
    sbc     hl, bc
    jr      z, 142$
    jr      c, 142$
    add     hl, bc
    ex      de, hl
    ld      (hl), e
    inc     hl
    ld      (hl), d
    call    GamePrintResultTop
142$:
    ld      hl, #(_game + GAME_STATE)
    inc     (hl)
;   jr      149$
149$:
    call    GamePrintResultTotal
    jr      190$

    ; 0x05 : 待機
150$:
    ld      a, (_input + INPUT_BUTTON_SPACE)
    dec     a
    jr      nz, 159$
    ld      a, #0x30
    ld      (_game + GAME_TIMER), a
    ld      a, #SOUND_SE_CLICK
    call    _SoundPlaySe
    ld      hl, #(_game + GAME_STATE)
    inc     (hl)
159$:
;   jr      190$

    ; 結果の完了
190$:

    ; コインの表示
    call    GamePrintResultCoin

    ; レジスタの復帰

    ; 終了
    ret

; VRAM へ転送する
;
GameTransfer:

    ; レジスタの保存

    ; d < ポート #0
    ; e < ポート #1

    ; パターンネームの転送
    call    _SystemUpdatePatternName

    ; 背景の転送
    call    _BackTransfer
    
    ; レジスタの復帰

    ; 終了
    ret

; ゲームオーバーになったかどうかを取得する
;
_GameIsOver::

    ; レジスタの保存
    push    hl

    ; cf > 1 = ゲームオーバー

    ; フラグの判定
    ld      hl, #(_game + GAME_FLAG)
    bit     #GAME_FLAG_OVER_BIT, (hl)
    jr      nz, 10$
    or      a
    jr      19$
10$:
    scf
19$:

    ; レジスタの復帰
    pop     hl

    ; 終了
    ret

; コインを加える
;
_GameAddCoin::

    ; レジスタの保存

    ; a < コインの種類

    ; コインの加算
    ld      e, a
    ld      d, #0x00
    ld      hl, #(_game + GAME_COIN_BRONZE - 0x0001)
    add     hl, de
    inc     (hl)

    ; レジスタの復帰

    ; 終了
    ret

; 開始を表示する
;
GamePrintStart:

    ; レジスタの保存

    ; START の表示
    ld      hl, #gameStartString
    ld      de, #(_patternName + 0x0182)
    call    GamePrintString

    ;　レジスタの復帰

    ; 終了
    ret

; 結果を表示する
;
GamePrintResultTitle:

    ; レジスタの保存

    ; タイトルの表示
    ld      hl, #gameResultStringTitle
    ld      de, #(_patternName + (0x06 * 0x20 + 0x0d))
    call    GamePrintString

    ; レジスタの復帰

    ; 終了
    ret

GamePrintResultBronze:

    ; レジスタの保存

    ; 銅貨の表示
    ld      hl, #gameResultStringBronze
    ld      de, #(_patternName + (0x09 * 0x20 + 0x09))
    call    GamePrintString
    ld      a, (_game + GAME_RESULT_BRONZE)
    ld      de, #(_game + GAME_VALUE_00100)
    call    _AppGetDecimal8
    ld      hl, #(_game + GAME_VALUE_00100)
    ld      de, #(_patternName + (0x09 * 0x20 + 0x09))
    ld      b, #0x03
    call    GamePrintValue
    ld      hl, (_game + GAME_SCORE_BRONZE_L)
    ld      de, #(_game + GAME_VALUE_10000)
    call    _AppGetDecimal16
    ld      hl, #(_game + GAME_VALUE_10000)
    ld      de, #(_patternName + (0x09 * 0x20 + 0x13))
    ld      b, #0x05
    call    GamePrintValue

    ; レジスタの復帰

    ; 終了
    ret

GamePrintResultSilver:

    ; レジスタの保存

    ; 銀貨の表示
    ld      hl, #gameResultStringSilver
    ld      de, #(_patternName + (0x0b * 0x20 + 0x09))
    call    GamePrintString
    ld      a, (_game + GAME_RESULT_SILVER)
    ld      de, #(_game + GAME_VALUE_00100)
    call    _AppGetDecimal8
    ld      hl, #(_game + GAME_VALUE_00100)
    ld      de, #(_patternName + (0x0b * 0x20 + 0x09))
    ld      b, #0x03
    call    GamePrintValue
    ld      hl, (_game + GAME_SCORE_SILVER_L)
    ld      de, #(_game + GAME_VALUE_10000)
    call    _AppGetDecimal16
    ld      hl, #(_game + GAME_VALUE_10000)
    ld      de, #(_patternName + (0x0b * 0x20 + 0x13))
    ld      b, #0x05
    call    GamePrintValue

    ; レジスタの復帰

    ; 終了
    ret

GamePrintResultGold:

    ; レジスタの保存

    ; 金貨の表示
    ld      hl, #gameResultStringGold
    ld      de, #(_patternName + (0x0d * 0x20 + 0x09))
    call    GamePrintString
    ld      a, (_game + GAME_RESULT_GOLD)
    ld      de, #(_game + GAME_VALUE_00100)
    call    _AppGetDecimal8
    ld      hl, #(_game + GAME_VALUE_00100)
    ld      de, #(_patternName + (0x0d * 0x20 + 0x09))
    ld      b, #0x03
    call    GamePrintValue
    ld      hl, (_game + GAME_SCORE_GOLD_L)
    ld      de, #(_game + GAME_VALUE_10000)
    call    _AppGetDecimal16
    ld      hl, #(_game + GAME_VALUE_10000)
    ld      de, #(_patternName + (0x0d * 0x20 + 0x13))
    ld      b, #0x05
    call    GamePrintValue

    ; レジスタの復帰

    ; 終了
    ret

GamePrintResultTotal:

    ; レジスタの保存

    ; トータルの表示
    ld      hl, #gameResultStringTotal
    ld      de, #(_patternName + (0x10 * 0x20 + 0x0c))
    call    GamePrintString
    ld      hl, (_game + GAME_SCORE_TOTAL_L)
    ld      de, #(_game + GAME_VALUE_10000)
    call    _AppGetDecimal16
    ld      hl, #(_game + GAME_VALUE_10000)
    ld      de, #(_patternName + (0x10 * 0x20 + 0x13))
    ld      b, #0x05
    call    GamePrintValue

    ; レジスタの復帰

    ; 終了
    ret

GamePrintResultTop:

    ; レジスタの保存

    ; トータルの表示
    ld      hl, #gameResultStringTop
    ld      de, #(_patternName + (0x13 * 0x20 + 0x0a))
    call    GamePrintString

    ; レジスタの復帰

    ; 終了
    ret

GamePrintResultCoin:

    ; レジスタの保存

    ; コインの表示
    ld      de, #(_sprite + GAME_SPRITE_RESULT)
    ld      a, (_game + GAME_FLAG)
10$:
    bit     #GAME_FLAG_RESULT_BRONZE_BIT, a
    jr      z, 11$
    ld      hl, #gameResultSpriteBronze
    ld      bc, #0x0004
    ldir
11$:
    bit     #GAME_FLAG_RESULT_SILVER_BIT, a
    jr      z, 12$
    ld      hl, #gameResultSpriteSilver
    ld      bc, #0x0004
    ldir
12$:
    bit     #GAME_FLAG_RESULT_GOLD_BIT, a
    jr      z, 13$
    ld      hl, #gameResultSpriteGold
    ld      bc, #0x0004
    ldir
13$:

    ; レジスタの復帰

    ; 終了
    ret

; 文字列を表示する
;
GamePrintString:

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
GamePrintValue:

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
gameProc:
    
    .dw     GameNull
    .dw     GameStart
    .dw     GamePlay
    .dw     GameResult

; ゲームの初期値
;
gameDefault:

    .db     GAME_STATE_NULL
    .db     GAME_FLAG_NULL
    .db     GAME_FRAME_NULL
    .db     GAME_TIMER_NULL
    .db     GAME_COIN_NULL
    .db     GAME_COIN_NULL
    .db     GAME_COIN_NULL
    .db     GAME_RESULT_NULL
    .db     GAME_RESULT_NULL
    .db     GAME_RESULT_NULL
    .dw     GAME_SCORE_NULL
    .dw     GAME_SCORE_NULL
    .dw     GAME_SCORE_NULL
    .dw     GAME_SCORE_NULL
    .db     GAME_VALUE_NULL
    .db     GAME_VALUE_NULL
    .db     GAME_VALUE_NULL
    .db     GAME_VALUE_NULL
    .db     GAME_VALUE_NULL

; スタート
;
gameStartString:

    .ascii  "TOSS A COIN TO YOUR WITCHER?"
    .db     0x00

; 結果
;
gameResultStringTitle:

    .ascii  "RESULT"
    .db     0x00

gameResultStringBronze:

    .ascii  "  0 *  1 =    0"
    .db     0x00

gameResultStringSilver:

    .ascii  "  0 *  3 =    0"
    .db     0x00

gameResultStringGold:

    .ascii  "  0 * 10 =    0"
    .db     0x00

gameResultStringTotal:

    .ascii  "TOTAL      0"
    .db     0x00

gameResultStringTop:

    .ascii  "TOP REWARD !"
    .db     0x00

gameResultSpriteBronze:

    .db     0x44 - 0x01, 0x3c, 0x08, VDP_COLOR_DARK_RED

gameResultSpriteSilver:

    .db     0x54 - 0x01, 0x3c, 0x08, VDP_COLOR_GRAY

gameResultSpriteGold:

    .db     0x64 - 0x01, 0x3c, 0x08, VDP_COLOR_LIGHT_YELLOW


; DATA 領域
;
    .area   _DATA

; 変数の定義
;

; ゲーム
;
_game::

    .ds     GAME_LENGTH
