# klp_block_drop_preview.dart：直接依賴與宣告架構

[回到目錄](README.md) · [來源檔案](../../../../../../lib/src/capabilities/editing/contracts/klp_block_drop_preview.dart)

## 範圍

核心是 `lib/src/capabilities/editing/contracts/klp_block_drop_preview.dart`。主要視角為該檔案明寫的 import／export／part；輔助視角為本檔宣告及 extends／implements／with／on 關係。只展開一層外部邊界。

## 直接依賴圖

```mermaid
flowchart TD
	n0["klp_block_drop_preview.dart"]
	n1["klp_editing_stamp.dart"]
	n0 -->|"import"| n1
```

## 依賴證據

| 關係 | 原始 directive | 來源 |
|---|---|---|
| import | <code>import &#x27;klp_editing_stamp.dart&#x27;;</code> | [lib/src/capabilities/editing/contracts/klp_block_drop_preview.dart:1](../../../../../../lib/src/capabilities/editing/contracts/klp_block_drop_preview.dart#L1) |

## 宣告關係圖

本組節點是本檔宣告；沒有箭頭的宣告未在此圖主張互相依賴。

```mermaid
classDiagram
	class n0["KlpBlockDropPlacement"]
	class n1["KlpBlockDropPreview"]
```


## 宣告與成員證據

成員包含 public 與 private；簽章取自來源，省略函式本體與欄位初始值。`(inferred)` 表示來源未明寫型別；建構子只顯示參數部分，不含初始化列表。

### KlpBlockDropPlacement

EnumDeclaration · public · [lib/src/capabilities/editing/contracts/klp_block_drop_preview.dart:3](../../../../../../lib/src/capabilities/editing/contracts/klp_block_drop_preview.dart#L3)

<code>enum KlpBlockDropPlacement</code>

來源註解摘要：落點相對於目標區塊的穩定語意，不以快照 index 表示位置。


| 成員 | 可見性 | 簽章／型別 | 來源註解摘要 | 證據 |
|---|---|---|---|---|
| enum value <code>before</code> | public | <code>before</code> |  | [lib/src/capabilities/editing/contracts/klp_block_drop_preview.dart:4](../../../../../../lib/src/capabilities/editing/contracts/klp_block_drop_preview.dart#L4) |
| enum value <code>after</code> | public | <code>after</code> |  | [lib/src/capabilities/editing/contracts/klp_block_drop_preview.dart:4](../../../../../../lib/src/capabilities/editing/contracts/klp_block_drop_preview.dart#L4) |

### KlpBlockDropPreview

ClassDeclaration · public · [lib/src/capabilities/editing/contracts/klp_block_drop_preview.dart:6](../../../../../../lib/src/capabilities/editing/contracts/klp_block_drop_preview.dart#L6)

<code>final class KlpBlockDropPreview</code>

來源註解摘要：連續區塊拖曳的本地暫態；建立或更新不會修改權威區塊順序。


| 成員 | 可見性 | 簽章／型別 | 來源註解摘要 | 證據 |
|---|---|---|---|---|
| field <code>expected</code> | public | <code>final KlpEditingStamp expected</code> |  | [lib/src/capabilities/editing/contracts/klp_block_drop_preview.dart:8](../../../../../../lib/src/capabilities/editing/contracts/klp_block_drop_preview.dart#L8) |
| field <code>blockId</code> | public | <code>final String blockId</code> |  | [lib/src/capabilities/editing/contracts/klp_block_drop_preview.dart:9](../../../../../../lib/src/capabilities/editing/contracts/klp_block_drop_preview.dart#L9) |
| field <code>rangeEndId</code> | public | <code>final String rangeEndId</code> |  | [lib/src/capabilities/editing/contracts/klp_block_drop_preview.dart:10](../../../../../../lib/src/capabilities/editing/contracts/klp_block_drop_preview.dart#L10) |
| field <code>targetId</code> | public | <code>final String targetId</code> |  | [lib/src/capabilities/editing/contracts/klp_block_drop_preview.dart:11](../../../../../../lib/src/capabilities/editing/contracts/klp_block_drop_preview.dart#L11) |
| field <code>placement</code> | public | <code>final KlpBlockDropPlacement placement</code> |  | [lib/src/capabilities/editing/contracts/klp_block_drop_preview.dart:12](../../../../../../lib/src/capabilities/editing/contracts/klp_block_drop_preview.dart#L12) |
| constructor <code>KlpBlockDropPreview</code> | public | <code>KlpBlockDropPreview({required this.expected, required this.blockId, String? rangeEndId, required this.targetId, required this.placement})</code> |  | [lib/src/capabilities/editing/contracts/klp_block_drop_preview.dart:14](../../../../../../lib/src/capabilities/editing/contracts/klp_block_drop_preview.dart#L14) |

## 閱讀說明與限制

箭頭只表示來源明寫的靜態關係；import 不等於呼叫。未分析動態呼叫、欄位的實際物件擁有權、狀態轉移或渲染流程；型別未進行語意解析，繼承目標保留原始型別拼寫。public／private 依 Dart 名稱前綴判斷；public 宣告不代表已由 `lib/kallopis.dart` 匯出。

本頁由 `tool/architecture_atlas` 產生；編輯來源或生成工具後重新產生，避免手改本頁。
