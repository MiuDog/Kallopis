# klp_box_insets.dart：直接依賴與宣告架構

[回到目錄](README.md) · [來源檔案](../../../../../lib/src/foundation/layout/klp_box_insets.dart)

## 範圍

核心是 `lib/src/foundation/layout/klp_box_insets.dart`。主要視角為該檔案明寫的 import／export／part；輔助視角為本檔宣告及 extends／implements／with／on 關係。只展開一層外部邊界。

## 直接依賴圖

```mermaid
flowchart TD
	n0["klp_box_insets.dart"]
	n1["package:flutter/widgets.dart"]
	n0 -->|"import"| n1
```

## 依賴證據

| 關係 | 原始 directive | 來源 |
|---|---|---|
| import | <code>import &#x27;package:flutter/widgets.dart&#x27;;</code> | [lib/src/foundation/layout/klp_box_insets.dart:1](../../../../../lib/src/foundation/layout/klp_box_insets.dart#L1) |

## 宣告關係圖

本組節點是本檔宣告；沒有箭頭的宣告未在此圖主張互相依賴。

```mermaid
classDiagram
	class n0["KlpBoxInsets"]
```


## 宣告與成員證據

成員包含 public 與 private；簽章取自來源，省略函式本體與欄位初始值。`(inferred)` 表示來源未明寫型別；建構子只顯示參數部分，不含初始化列表。

### KlpBoxInsets

ClassDeclaration · public · [lib/src/foundation/layout/klp_box_insets.dart:3](../../../../../lib/src/foundation/layout/klp_box_insets.dart#L3)

<code>class KlpBoxInsets</code>

來源註解摘要：封裝已由 theme 解析的方向感知內距，避免高階元件傳遞 Flutter 樣式物件。


| 成員 | 可見性 | 簽章／型別 | 來源註解摘要 | 證據 |
|---|---|---|---|---|
| constructor <code>uniform</code> | public | <code>const KlpBoxInsets.uniform(double value)</code> |  | [lib/src/foundation/layout/klp_box_insets.dart:5](../../../../../lib/src/foundation/layout/klp_box_insets.dart#L5) |
| constructor <code>directional</code> | public | <code>const KlpBoxInsets.directional({ this.start = 0, this.top = 0, this.end = 0, this.bottom = 0, })</code> |  | [lib/src/foundation/layout/klp_box_insets.dart:11](../../../../../lib/src/foundation/layout/klp_box_insets.dart#L11) |
| field <code>start</code> | public | <code>final double start</code> |  | [lib/src/foundation/layout/klp_box_insets.dart:18](../../../../../lib/src/foundation/layout/klp_box_insets.dart#L18) |
| field <code>top</code> | public | <code>final double top</code> |  | [lib/src/foundation/layout/klp_box_insets.dart:19](../../../../../lib/src/foundation/layout/klp_box_insets.dart#L19) |
| field <code>end</code> | public | <code>final double end</code> |  | [lib/src/foundation/layout/klp_box_insets.dart:20](../../../../../lib/src/foundation/layout/klp_box_insets.dart#L20) |
| field <code>bottom</code> | public | <code>final double bottom</code> |  | [lib/src/foundation/layout/klp_box_insets.dart:21](../../../../../lib/src/foundation/layout/klp_box_insets.dart#L21) |
| getter <code>edgeInsets</code> | public | <code>EdgeInsetsDirectional get edgeInsets</code> |  | [lib/src/foundation/layout/klp_box_insets.dart:23](../../../../../lib/src/foundation/layout/klp_box_insets.dart#L23) |

## 閱讀說明與限制

箭頭只表示來源明寫的靜態關係；import 不等於呼叫。未分析動態呼叫、欄位的實際物件擁有權、狀態轉移或渲染流程；型別未進行語意解析，繼承目標保留原始型別拼寫。public／private 依 Dart 名稱前綴判斷；public 宣告不代表已由 `lib/kallopis.dart` 匯出。

本頁由 `tool/architecture_atlas` 產生；編輯來源或生成工具後重新產生，避免手改本頁。
