; Bard.s : 吟遊詩人
;


; モジュール宣言
;
    .module Bard

; 参照ファイル
;
    .include    "bios.inc"
    .include    "vdp.inc"
    .include    "System.inc"
    .include    "Sound.inc"
    .include    "App.inc"
    .include    "Game.inc"
    .include	"Bard.inc"

; 外部変数宣言
;

; マクロの定義
;


; CODE 領域
;
    .area   _CODE

; 吟遊詩人を初期化する
;
_BardInitialize::
    
    ; レジスタの保存
    
    ; 吟遊詩人の初期化
    ld      hl, #bardDefault
    ld      de, #_bard
    ld      bc, #BARD_LENGTH
    ldir

    ; レジスタの復帰
    
    ; 終了
    ret

; 吟遊詩人を更新する
;
_BardUpdate::
    
    ; レジスタの保存

    ; 吟遊詩人の更新

    ; フレームの更新
    ld      hl, #(_bard + BARD_FRAME)
    inc     (hl)

    ; レジスタの復帰
    
    ; 終了
    ret

; 吟遊詩人を描画する
;
_BardRender::

    ; レジスタの保存

    ; スプライトの描画
    ld      a, (_bard + BARD_FRAME)
    and     #0x10
    ld      e, a
    ld      d, #0x00
    ld      hl, #bardSprite
    add     hl, de
    ld      de, #(_sprite + GAME_SPRITE_BARD)
    ld      bc, #(0x03 * 0x04)
    ldir

    ; レジスタの復帰

    ; 終了
    ret

; 定数の定義
;

; 吟遊詩人の初期値
;
bardDefault:

    .db     BARD_FRAME_NULL

; スプライト
;
bardSprite:

    .db     0x10 - 0x01, 0x78, 0x20, VDP_COLOR_LIGHT_YELLOW
    .db     0x10 - 0x01, 0x78, 0x24, VDP_COLOR_DARK_RED
    .db     0x10 - 0x01, 0x78, 0x28, VDP_COLOR_MAGENTA
    .db     0x00, 0x00, 0x00, 0x00
    .db     0x10 - 0x01, 0x78, 0x2c, VDP_COLOR_LIGHT_YELLOW
    .db     0x10 - 0x01, 0x78, 0x30, VDP_COLOR_DARK_RED
    .db     0x10 - 0x01, 0x78, 0x34, VDP_COLOR_MAGENTA
    .db     0x00, 0x00, 0x00, 0x00


; DATA 領域
;
    .area   _DATA

; 変数の定義
;

; 吟遊詩人
;
_bard::
    
    .ds     BARD_LENGTH

