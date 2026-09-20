# 前端責任邊界

本文件實作 [KLP-0022](../../spec/decisions/KLP-0022-thin-design-system-boundary.md) 的唯一 Flutter 架構。

## 公開入口

| Library | 責任 |
| --- | --- |
| `kallopis_theme.dart` | Stable semantic theme、token 與 `context.klp` |
| `kallopis_foundation.dart` | Stable 公開 Flutter 元件、布局、互動與平台資訊 |
| `kallopis_experimental.dart` | 尚未穩定的直接 Flutter 高階元件 |

`kallopis.dart` 只彙整上述三個現行入口，不提供另一種架構。`lib/src` 對 consumer 永遠 private。

## Kallopis 擁有

- semantic color、type、space、shape、motion 與 surface。
- 公開共用元件的內部 Widget tree、hover／focus／pressed 狀態、鍵盤操作、無障礙與平台適應。
- BlockNote／Canva 的通用 WebView 呈現宿主；正文與保存權威不在 Kallopis。
- Catalog 的公開元件 specimen 與人工視覺接受面。

## 產品擁有

- `MaterialApp`、route、screen、產品 Widget tree 與布局。
- 產品 controller、導航、載入、錯誤、保存與業務流程。
- 產品專用 Widget、功能順序、欄位、寬度與資料投影。
- Krepis session 與產品資料 owner 的生命週期。

產品專用 Widget 從 `context.klp` 取得共用視覺值；不得複製 Kallopis 元件內部樣式或建立第二份 theme。

## 禁止依賴

- product → `package:kallopis/src/...`
- product → declarative node、application host、adapter／bound model、runtime compiler 或 private renderer
- Kallopis → Planist 或其他產品模型
- 同一能力的 compatibility shim、deprecated alias、feature flag 或雙軌實作

缺少產品畫面時由產品直接建立 Flutter Widget。只有能力已證明跨產品重用，才移入 Kallopis 公開元件。
