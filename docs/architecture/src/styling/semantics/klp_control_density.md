# klp_control_density.dart：直接依賴與宣告架構

[回到目錄](README.md) · [來源檔案](../../../../../lib/src/styling/semantics/klp_control_density.dart)

## 範圍

核心是 `lib/src/styling/semantics/klp_control_density.dart`。主要視角為該檔案明寫的 import／export／part；輔助視角為本檔宣告及 extends／implements／with／on 關係。只展開一層外部邊界。

## 直接依賴圖

```mermaid
flowchart TD
	n0["klp_control_density.dart"]
	n1["dart:math"]
	n2["package:kallopis/src/styling/primitives/klp_style_value.dart"]
	n0 -->|"import"| n1
	n0 -->|"import"| n2
```

## 依賴證據

| 關係 | 原始 directive | 來源 |
|---|---|---|
| import | <code>import &#x27;dart:math&#x27; as math;</code> | [lib/src/styling/semantics/klp_control_density.dart:1](../../../../../lib/src/styling/semantics/klp_control_density.dart#L1) |
| import | <code>import &#x27;package:kallopis/src/styling/primitives/klp_style_value.dart&#x27;;</code> | [lib/src/styling/semantics/klp_control_density.dart:2](../../../../../lib/src/styling/semantics/klp_control_density.dart#L2) |

## 宣告關係圖

本組節點是本檔宣告；沒有箭頭的宣告未在此圖主張互相依賴。

```mermaid
classDiagram
	class n0["KlpControlDensity"]
```


## 宣告與成員證據

成員包含 public 與 private；簽章取自來源，省略函式本體與欄位初始值。`(inferred)` 表示來源未明寫型別；建構子只顯示參數部分，不含初始化列表。

### KlpControlDensity

ClassDeclaration · public · [lib/src/styling/semantics/klp_control_density.dart:4](../../../../../lib/src/styling/semantics/klp_control_density.dart#L4)

<code>final class KlpControlDensity</code>

來源註解摘要：已確認的緊湊控制比例；以解析後的尺度推導，不增加 primitive 欄位。


| 成員 | 可見性 | 簽章／型別 | 來源註解摘要 | 證據 |
|---|---|---|---|---|
| field <code>extent</code> | public | <code>final KlpDistance extent</code> |  | [lib/src/styling/semantics/klp_control_density.dart:6](../../../../../lib/src/styling/semantics/klp_control_density.dart#L6) |
| constructor <code>KlpControlDensity</code> | public | <code>KlpControlDensity(this.extent)</code> |  | [lib/src/styling/semantics/klp_control_density.dart:7](../../../../../lib/src/styling/semantics/klp_control_density.dart#L7) |
| getter <code>height</code> | public | <code>double get height</code> |  | [lib/src/styling/semantics/klp_control_density.dart:10](../../../../../lib/src/styling/semantics/klp_control_density.dart#L10) |
| getter <code>icon</code> | public | <code>double get icon</code> |  | [lib/src/styling/semantics/klp_control_density.dart:11](../../../../../lib/src/styling/semantics/klp_control_density.dart#L11) |
| getter <code>padding</code> | public | <code>double get padding</code> |  | [lib/src/styling/semantics/klp_control_density.dart:12](../../../../../lib/src/styling/semantics/klp_control_density.dart#L12) |
| getter <code>gap</code> | public | <code>double get gap</code> |  | [lib/src/styling/semantics/klp_control_density.dart:13](../../../../../lib/src/styling/semantics/klp_control_density.dart#L13) |
| getter <code>row</code> | public | <code>double get row</code> |  | [lib/src/styling/semantics/klp_control_density.dart:14](../../../../../lib/src/styling/semantics/klp_control_density.dart#L14) |
| getter <code>lineHeight</code> | public | <code>double get lineHeight</code> |  | [lib/src/styling/semantics/klp_control_density.dart:15](../../../../../lib/src/styling/semantics/klp_control_density.dart#L15) |
| getter <code>touchTarget</code> | public | <code>double get touchTarget</code> |  | [lib/src/styling/semantics/klp_control_density.dart:17](../../../../../lib/src/styling/semantics/klp_control_density.dart#L17) |
| getter <code>focusStroke</code> | public | <code>double get focusStroke</code> |  | [lib/src/styling/semantics/klp_control_density.dart:18](../../../../../lib/src/styling/semantics/klp_control_density.dart#L18) |
| getter <code>windowControl</code> | public | <code>double get windowControl</code> |  | [lib/src/styling/semantics/klp_control_density.dart:20](../../../../../lib/src/styling/semantics/klp_control_density.dart#L20) |

## 閱讀說明與限制

箭頭只表示來源明寫的靜態關係；import 不等於呼叫。未分析動態呼叫、欄位的實際物件擁有權、狀態轉移或渲染流程；型別未進行語意解析，繼承目標保留原始型別拼寫。public／private 依 Dart 名稱前綴判斷；public 宣告不代表已由 `lib/kallopis.dart` 匯出。

本頁由 `tool/architecture_atlas` 產生；編輯來源或生成工具後重新產生，避免手改本頁。
