# klp_dialog.dart：直接依賴與宣告架構

[回到目錄](README.md) · [來源檔案](../../../../../lib/src/features/overlays/klp_dialog.dart)

## 範圍

核心是 `lib/src/features/overlays/klp_dialog.dart`。主要視角為該檔案明寫的 import／export／part；輔助視角為本檔宣告及 extends／implements／with／on 關係。只展開一層外部邊界。

## 直接依賴圖

```mermaid
flowchart LR
	n0["klp_dialog.dart"]
	n1["package:flutter/widgets.dart"]
	n2["../actions/button/klp_button.dart"]
	n3["../../foundation/layout/klp_layout.dart"]
	n4["../../foundation/surface/klp_surface.dart"]
	n5["../../foundation/content/klp_text.dart"]
	n6["../../styling/legacy_theme/klp_theme.dart"]
	n0 -->|"import"| n1
	n0 -->|"import"| n2
	n0 -->|"import"| n3
	n0 -->|"import"| n4
	n0 -->|"import"| n5
	n0 -->|"import"| n6
```

## 依賴證據

| 關係 | 原始 directive | 來源 |
|---|---|---|
| import | <code>import &#x27;package:flutter/widgets.dart&#x27;;</code> | [lib/src/features/overlays/klp_dialog.dart:1](../../../../../lib/src/features/overlays/klp_dialog.dart#L1) |
| import | <code>import &#x27;../actions/button/klp_button.dart&#x27;;</code> | [lib/src/features/overlays/klp_dialog.dart:3](../../../../../lib/src/features/overlays/klp_dialog.dart#L3) |
| import | <code>import &#x27;../../foundation/layout/klp_layout.dart&#x27;;</code> | [lib/src/features/overlays/klp_dialog.dart:4](../../../../../lib/src/features/overlays/klp_dialog.dart#L4) |
| import | <code>import &#x27;../../foundation/surface/klp_surface.dart&#x27;;</code> | [lib/src/features/overlays/klp_dialog.dart:5](../../../../../lib/src/features/overlays/klp_dialog.dart#L5) |
| import | <code>import &#x27;../../foundation/content/klp_text.dart&#x27;;</code> | [lib/src/features/overlays/klp_dialog.dart:6](../../../../../lib/src/features/overlays/klp_dialog.dart#L6) |
| import | <code>import &#x27;../../styling/legacy_theme/klp_theme.dart&#x27;;</code> | [lib/src/features/overlays/klp_dialog.dart:7](../../../../../lib/src/features/overlays/klp_dialog.dart#L7) |

## 宣告關係圖

本組節點是本檔宣告；沒有箭頭的宣告未在此圖主張互相依賴。

```mermaid
classDiagram
	class n0["KlpDialog"]
```

```mermaid
classDiagram
	class n0["KlpDialog"]
	class n1["StatelessWidget"]
	n0 --|> n1 : extends
```


## 宣告與成員證據

成員包含 public 與 private；簽章取自來源，省略函式本體與欄位初始值。`(inferred)` 表示來源未明寫型別；建構子只顯示參數部分，不含初始化列表。

### KlpDialog

ClassDeclaration · public · [lib/src/features/overlays/klp_dialog.dart:9](../../../../../lib/src/features/overlays/klp_dialog.dart#L9)

<code>class KlpDialog extends StatelessWidget</code>

來源註解摘要：對話框內容。**不負責彈出**——呼叫端自行決定用 `showDialog` 或其他方式呈現。 `secondaryLabel` 為必填：庫不替產品決定用什麼語言說「取消」。

- `extends` → <code>StatelessWidget</code>：[lib/src/features/overlays/klp_dialog.dart:11](../../../../../lib/src/features/overlays/klp_dialog.dart#L11)

| 成員 | 可見性 | 簽章／型別 | 來源註解摘要 | 證據 |
|---|---|---|---|---|
| constructor <code>KlpDialog</code> | public | <code>const KlpDialog({ super.key, required this.label, required this.title, required this.child, required this.primaryLabel, required this.onPrimary, required this.secondaryLabel, this.onSecondary, })</code> |  | [lib/src/features/overlays/klp_dialog.dart:12](../../../../../lib/src/features/overlays/klp_dialog.dart#L12) |
| field <code>label</code> | public | <code>final String label</code> |  | [lib/src/features/overlays/klp_dialog.dart:23](../../../../../lib/src/features/overlays/klp_dialog.dart#L23) |
| field <code>title</code> | public | <code>final String title</code> |  | [lib/src/features/overlays/klp_dialog.dart:24](../../../../../lib/src/features/overlays/klp_dialog.dart#L24) |
| field <code>child</code> | public | <code>final Widget child</code> |  | [lib/src/features/overlays/klp_dialog.dart:25](../../../../../lib/src/features/overlays/klp_dialog.dart#L25) |
| field <code>primaryLabel</code> | public | <code>final String primaryLabel</code> |  | [lib/src/features/overlays/klp_dialog.dart:26](../../../../../lib/src/features/overlays/klp_dialog.dart#L26) |
| field <code>onPrimary</code> | public | <code>final VoidCallback onPrimary</code> |  | [lib/src/features/overlays/klp_dialog.dart:27](../../../../../lib/src/features/overlays/klp_dialog.dart#L27) |
| field <code>secondaryLabel</code> | public | <code>final String secondaryLabel</code> | 次要動作的文字。**沒有預設值是刻意的**——庫不替產品決定用什麼語言說「取消」。 | [lib/src/features/overlays/klp_dialog.dart:30](../../../../../lib/src/features/overlays/klp_dialog.dart#L30) |
| field <code>onSecondary</code> | public | <code>final VoidCallback? onSecondary</code> |  | [lib/src/features/overlays/klp_dialog.dart:31](../../../../../lib/src/features/overlays/klp_dialog.dart#L31) |
| method <code>build</code> | public | <code>Widget build(BuildContext context)</code> |  | [lib/src/features/overlays/klp_dialog.dart:33](../../../../../lib/src/features/overlays/klp_dialog.dart#L33) |

## 閱讀說明與限制

箭頭只表示來源明寫的靜態關係；import 不等於呼叫。未分析動態呼叫、欄位的實際物件擁有權、狀態轉移或渲染流程；型別未進行語意解析，繼承目標保留原始型別拼寫。public／private 依 Dart 名稱前綴判斷；public 宣告不代表已由 `lib/kallopis.dart` 匯出。

本頁由 `tool/architecture_atlas` 產生；編輯來源或生成工具後重新產生，避免手改本頁。
