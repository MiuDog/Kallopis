# klp_prepared_children.dart：直接依賴與宣告架構

[回到目錄](README.md) · [來源檔案](../../../../../../lib/src/foundation/binding/internal/klp_prepared_children.dart)

## 範圍

核心是 `lib/src/foundation/binding/internal/klp_prepared_children.dart`。主要視角為該檔案明寫的 import／export／part；輔助視角為本檔宣告及 extends／implements／with／on 關係。只展開一層外部邊界。

## 直接依賴圖

```mermaid
flowchart TD
	n0["klp_prepared_children.dart"]
	n1["klp_prepared_template.dart"]
	n0 -->|"part of"| n1
```

## 依賴證據

| 關係 | 原始 directive | 來源 |
|---|---|---|
| part of | <code>part of &#x27;klp_prepared_template.dart&#x27;;</code> | [lib/src/foundation/binding/internal/klp_prepared_children.dart:1](../../../../../../lib/src/foundation/binding/internal/klp_prepared_children.dart#L1) |

## 宣告關係圖

本組節點是本檔宣告；沒有箭頭的宣告未在此圖主張互相依賴。

```mermaid
classDiagram
	class n0["KlpPreparedChildren"]
```

```mermaid
classDiagram
	class n0["KlpPreparedChildren"]
	class n1["KlpPreparedTemplate"]
	n0 --|> n1 : extends
```


## 宣告與成員證據

成員包含 public 與 private；簽章取自來源，省略函式本體與欄位初始值。`(inferred)` 表示來源未明寫型別；建構子只顯示參數部分，不含初始化列表。

### KlpPreparedChildren

ClassDeclaration · public · [lib/src/foundation/binding/internal/klp_prepared_children.dart:3](../../../../../../lib/src/foundation/binding/internal/klp_prepared_children.dart#L3)

<code>final class KlpPreparedChildren extends KlpPreparedTemplate</code>

來源註解摘要：範圍只引用已驗證的直接子放置，每個子項恰好嵌入一次。

- `extends` → <code>KlpPreparedTemplate</code>：[lib/src/foundation/binding/internal/klp_prepared_children.dart:4](../../../../../../lib/src/foundation/binding/internal/klp_prepared_children.dart#L4)

| 成員 | 可見性 | 簽章／型別 | 來源註解摘要 | 證據 |
|---|---|---|---|---|
| field <code>axis</code> | public | <code>final KlpAxis axis</code> |  | [lib/src/foundation/binding/internal/klp_prepared_children.dart:6](../../../../../../lib/src/foundation/binding/internal/klp_prepared_children.dart#L6) |
| field <code>gap</code> | public | <code>final KlpDistance gap</code> |  | [lib/src/foundation/binding/internal/klp_prepared_children.dart:7](../../../../../../lib/src/foundation/binding/internal/klp_prepared_children.dart#L7) |
| field <code>start</code> | public | <code>final int start</code> |  | [lib/src/foundation/binding/internal/klp_prepared_children.dart:8](../../../../../../lib/src/foundation/binding/internal/klp_prepared_children.dart#L8) |
| field <code>end</code> | public | <code>final int end</code> |  | [lib/src/foundation/binding/internal/klp_prepared_children.dart:9](../../../../../../lib/src/foundation/binding/internal/klp_prepared_children.dart#L9) |
| constructor <code>KlpPreparedChildren</code> | public | <code>const KlpPreparedChildren({required this.axis, required this.gap, required this.start, required this.end})</code> |  | [lib/src/foundation/binding/internal/klp_prepared_children.dart:11](../../../../../../lib/src/foundation/binding/internal/klp_prepared_children.dart#L11) |
| method <code>materialize</code> | public | <code>KlpBoundTemplate materialize(List&lt;KlpBoundTemplate&gt; children)</code> |  | [lib/src/foundation/binding/internal/klp_prepared_children.dart:13](../../../../../../lib/src/foundation/binding/internal/klp_prepared_children.dart#L13) |

## 閱讀說明與限制

箭頭只表示來源明寫的靜態關係；import 不等於呼叫。未分析動態呼叫、欄位的實際物件擁有權、狀態轉移或渲染流程；型別未進行語意解析，繼承目標保留原始型別拼寫。public／private 依 Dart 名稱前綴判斷；public 宣告不代表已由 `lib/kallopis.dart` 匯出。

本頁由 `tool/architecture_atlas` 產生；編輯來源或生成工具後重新產生，避免手改本頁。
