# klp_schedule_list.dart：直接依賴與宣告架構

[回到目錄](README.md) · [來源檔案](../../../../../../lib/src/features/collections/agenda/klp_schedule_list.dart)

## 範圍

核心是 `lib/src/features/collections/agenda/klp_schedule_list.dart`。主要視角為該檔案明寫的 import／export／part；輔助視角為本檔宣告及 extends／implements／with／on 關係。只展開一層外部邊界。

## 直接依賴圖

```mermaid
flowchart LR
	n0["klp_schedule_list.dart"]
	n1["package:flutter/widgets.dart"]
	n2["klp_schedule_item_data.dart"]
	n3["../badge/klp_badge.dart"]
	n4["../../../foundation/layout/klp_layout.dart"]
	n5["../../../foundation/surface/klp_surface.dart"]
	n6["../../../styling/legacy_theme/klp_theme.dart"]
	n7["../../../foundation/content/klp_text.dart"]
	n0 -->|"import"| n1
	n0 -->|"import"| n2
	n0 -->|"import"| n3
	n0 -->|"import"| n4
	n0 -->|"import"| n5
	n0 -->|"import"| n6
	n0 -->|"import"| n7
```

## 依賴證據

| 關係 | 原始 directive | 來源 |
|---|---|---|
| import | <code>import &#x27;package:flutter/widgets.dart&#x27;;</code> | [lib/src/features/collections/agenda/klp_schedule_list.dart:4](../../../../../../lib/src/features/collections/agenda/klp_schedule_list.dart#L4) |
| import | <code>import &#x27;klp_schedule_item_data.dart&#x27;;</code> | [lib/src/features/collections/agenda/klp_schedule_list.dart:6](../../../../../../lib/src/features/collections/agenda/klp_schedule_list.dart#L6) |
| import | <code>import &#x27;../badge/klp_badge.dart&#x27;;</code> | [lib/src/features/collections/agenda/klp_schedule_list.dart:7](../../../../../../lib/src/features/collections/agenda/klp_schedule_list.dart#L7) |
| import | <code>import &#x27;../../../foundation/layout/klp_layout.dart&#x27;;</code> | [lib/src/features/collections/agenda/klp_schedule_list.dart:8](../../../../../../lib/src/features/collections/agenda/klp_schedule_list.dart#L8) |
| import | <code>import &#x27;../../../foundation/surface/klp_surface.dart&#x27;;</code> | [lib/src/features/collections/agenda/klp_schedule_list.dart:9](../../../../../../lib/src/features/collections/agenda/klp_schedule_list.dart#L9) |
| import | <code>import &#x27;../../../styling/legacy_theme/klp_theme.dart&#x27;;</code> | [lib/src/features/collections/agenda/klp_schedule_list.dart:10](../../../../../../lib/src/features/collections/agenda/klp_schedule_list.dart#L10) |
| import | <code>import &#x27;../../../foundation/content/klp_text.dart&#x27;;</code> | [lib/src/features/collections/agenda/klp_schedule_list.dart:11](../../../../../../lib/src/features/collections/agenda/klp_schedule_list.dart#L11) |

## 宣告關係圖

本組節點是本檔宣告；沒有箭頭的宣告未在此圖主張互相依賴。

```mermaid
classDiagram
	class n0["KlpScheduleList"]
```

```mermaid
classDiagram
	class n0["KlpScheduleList"]
	class n1["StatelessWidget"]
	n0 --|> n1 : extends
```


## 宣告與成員證據

成員包含 public 與 private；簽章取自來源，省略函式本體與欄位初始值。`(inferred)` 表示來源未明寫型別；建構子只顯示參數部分，不含初始化列表。

### KlpScheduleList

ClassDeclaration · public · [lib/src/features/collections/agenda/klp_schedule_list.dart:13](../../../../../../lib/src/features/collections/agenda/klp_schedule_list.dart#L13)

<code>class KlpScheduleList extends StatelessWidget</code>

來源註解摘要：固定時間欄、標題與選填標籤的排程清單。

- `extends` → <code>StatelessWidget</code>：[lib/src/features/collections/agenda/klp_schedule_list.dart:14](../../../../../../lib/src/features/collections/agenda/klp_schedule_list.dart#L14)

| 成員 | 可見性 | 簽章／型別 | 來源註解摘要 | 證據 |
|---|---|---|---|---|
| constructor <code>KlpScheduleList</code> | public | <code>const KlpScheduleList({super.key, required this.items})</code> |  | [lib/src/features/collections/agenda/klp_schedule_list.dart:15](../../../../../../lib/src/features/collections/agenda/klp_schedule_list.dart#L15) |
| field <code>items</code> | public | <code>final List&lt;KlpScheduleItemData&gt; items</code> |  | [lib/src/features/collections/agenda/klp_schedule_list.dart:17](../../../../../../lib/src/features/collections/agenda/klp_schedule_list.dart#L17) |
| method <code>build</code> | public | <code>Widget build(BuildContext context)</code> |  | [lib/src/features/collections/agenda/klp_schedule_list.dart:19](../../../../../../lib/src/features/collections/agenda/klp_schedule_list.dart#L19) |

## 閱讀說明與限制

箭頭只表示來源明寫的靜態關係；import 不等於呼叫。未分析動態呼叫、欄位的實際物件擁有權、狀態轉移或渲染流程；型別未進行語意解析，繼承目標保留原始型別拼寫。public／private 依 Dart 名稱前綴判斷；public 宣告不代表已由 `lib/kallopis.dart` 匯出。

本頁由 `tool/architecture_atlas` 產生；編輯來源或生成工具後重新產生，避免手改本頁。
