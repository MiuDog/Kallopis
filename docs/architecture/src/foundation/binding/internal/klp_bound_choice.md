# klp_bound_choice.dart：直接依賴與宣告架構

[回到目錄](README.md) · [來源檔案](../../../../../../lib/src/foundation/binding/internal/klp_bound_choice.dart)

## 範圍

核心是 `lib/src/foundation/binding/internal/klp_bound_choice.dart`。主要視角為該檔案明寫的 import／export／part；輔助視角為本檔宣告及 extends／implements／with／on 關係。只展開一層外部邊界。

## 直接依賴圖

```mermaid
flowchart TD
	n0["klp_bound_choice.dart"]
	n1["klp_bound_template.dart"]
	n0 -->|"part of"| n1
```

## 依賴證據

| 關係 | 原始 directive | 來源 |
|---|---|---|
| part of | <code>part of &#x27;klp_bound_template.dart&#x27;;</code> | [lib/src/foundation/binding/internal/klp_bound_choice.dart:1](../../../../../../lib/src/foundation/binding/internal/klp_bound_choice.dart#L1) |

## 宣告關係圖

本組節點是本檔宣告；沒有箭頭的宣告未在此圖主張互相依賴。

```mermaid
classDiagram
	class n0["KlpBoundChoice"]
```

```mermaid
classDiagram
	class n0["KlpBoundChoice"]
	class n1["KlpBoundTemplate"]
	n0 --|> n1 : extends
```


## 宣告與成員證據

成員包含 public 與 private；簽章取自來源，省略函式本體與欄位初始值。`(inferred)` 表示來源未明寫型別；建構子只顯示參數部分，不含初始化列表。

### KlpBoundChoice

ClassDeclaration · public · [lib/src/foundation/binding/internal/klp_bound_choice.dart:3](../../../../../../lib/src/foundation/binding/internal/klp_bound_choice.dart#L3)

<code>final class KlpBoundChoice extends KlpBoundTemplate</code>

來源註解摘要：借用同一選取來源的操作原語；callback 已由本庫附加生命週期檢查。

- `extends` → <code>KlpBoundTemplate</code>：[lib/src/foundation/binding/internal/klp_bound_choice.dart:4](../../../../../../lib/src/foundation/binding/internal/klp_bound_choice.dart#L4)

| 成員 | 可見性 | 簽章／型別 | 來源註解摘要 | 證據 |
|---|---|---|---|---|
| field <code>id</code> | public | <code>final KlpPlacementId id</code> |  | [lib/src/foundation/binding/internal/klp_bound_choice.dart:5](../../../../../../lib/src/foundation/binding/internal/klp_bound_choice.dart#L5) |
| field <code>label</code> | public | <code>final String label</code> |  | [lib/src/foundation/binding/internal/klp_bound_choice.dart:6](../../../../../../lib/src/foundation/binding/internal/klp_bound_choice.dart#L6) |
| field <code>selection</code> | public | <code>final KlpState&lt;KlpPlacementId?&gt; selection</code> |  | [lib/src/foundation/binding/internal/klp_bound_choice.dart:7](../../../../../../lib/src/foundation/binding/internal/klp_bound_choice.dart#L7) |
| field <code>onActivate</code> | public | <code>final FutureOr&lt;void&gt; Function()? onActivate</code> |  | [lib/src/foundation/binding/internal/klp_bound_choice.dart:8](../../../../../../lib/src/foundation/binding/internal/klp_bound_choice.dart#L8) |
| field <code>child</code> | public | <code>final KlpBoundTemplate child</code> |  | [lib/src/foundation/binding/internal/klp_bound_choice.dart:9](../../../../../../lib/src/foundation/binding/internal/klp_bound_choice.dart#L9) |
| field <code>style</code> | public | <code>final KlpBoundChoiceStyle style</code> |  | [lib/src/foundation/binding/internal/klp_bound_choice.dart:10](../../../../../../lib/src/foundation/binding/internal/klp_bound_choice.dart#L10) |
| constructor <code>KlpBoundChoice</code> | public | <code>const KlpBoundChoice({ required this.id, required this.label, required this.selection, required this.onActivate, required this.child, required this.style, })</code> |  | [lib/src/foundation/binding/internal/klp_bound_choice.dart:12](../../../../../../lib/src/foundation/binding/internal/klp_bound_choice.dart#L12) |

## 閱讀說明與限制

箭頭只表示來源明寫的靜態關係；import 不等於呼叫。未分析動態呼叫、欄位的實際物件擁有權、狀態轉移或渲染流程；型別未進行語意解析，繼承目標保留原始型別拼寫。public／private 依 Dart 名稱前綴判斷；public 宣告不代表已由 `lib/kallopis.dart` 匯出。

本頁由 `tool/architecture_atlas` 產生；編輯來源或生成工具後重新產生，避免手改本頁。
