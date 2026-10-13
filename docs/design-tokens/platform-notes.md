## 現行差異與邊界（AI不得自行修正）

| 項目 | 查證結果／規則 |
|---|---|
| button幾何 | 未指定size預設sm（32），compact預設xs（28）；renderer實際padding-y為0；theme.components.buttonPaddingY解析為8只是模型值，不能拿來覆蓋renderer。md按鈕36，並非space.controlHeight40。 |
| field幾何 | geometry.control.fieldHeight30與實際field-base高度40是不同路徑；field單行padding-y用1.3，而文字line-height用captionLeading1.333，保留此差異。 |
| 文字角色 | 全部預設prominent；tone.muted/faint改文字階層。KlpText的accent/danger/success tone目前仍解析主文字色，不能擅改成同名status色。medium實際400、extraBold700；appTitle/status角色明確500。 |
| 表面文字 | KlpSurface、AppFrame、PanelFrame、StageFrame依背景覆寫子樹文字階層；KlpCard只畫底色，不自行覆寫theme。 |
| 表面圓角 | KlpSurface非app/transparent的radius下限為shape.control；transparent表面可精確保留radius。 |
| Frame | AppFrame12；PanelFrame7、裁切5、外margin4；StageFrame本身不增加圓角。flat無微立體；raised必須由元件明確啟用。 |
| menu陰影 | KlpMenu目前是modalScrim RGB、overlayShadowOpacity的單層陰影；不是overlayShadow的雙層配方。 |
| 狀態 | 不把所有元件的hover/selected強制合併；Explorer同色，其餘依上述現存resolver。disabled優先序與outlined規則分別處理。 |
| brand/accent | buildKlpTheme的accent參數只改interaction/interactionSoft，brand不跟著改。主要按鈕依brand；預設brand繼承accent。 |
| 透明主題 | transparent為dark加視窗透明；app透明，surface/stageSurface alpha0.72，JSON的8-bit表示184/255。真正視窗透底需平台宿主。 |
| 圖示／字型 | 保留資產與授權，Flaticon Rounded thin/regular或既有Lucide。圖示清冊不是數值token。 |
| 未列元件 | 本檔完整列出350個theme欄位與已查證配方；未列的複合Widget不是已定型模板，不得聲稱有同名recipe。產品可依既有surface/text/spacing等語意組合。 |
| 架構 | 不重建declarative runtime、不引用lib/src、不使用私有八槽schema作為consumer入口。 |
| 來源 | primitive_token／klp_palette／default_*／各ThemeExtension與klp_geometry_theme；button_style、text_field_style/frame、KlpSurface、Card/BadgeFrame、MenuMetrics/MenuState、AppFrame/PanelFrame/StageFrame、ExplorerRow、klp_text。 |
| 驗證 | 已檢查全部primitive/semantic引用、配方繼承無循環、350個theme欄位覆蓋；本次僅整理文件，未改元件或進行Flutter編譯／視覺驗收。 |

