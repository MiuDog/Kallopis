# klp_editing_intent.dart：直接依賴與宣告架構

[回到目錄](README.md) · [來源檔案](../../../../../../lib/src/capabilities/editing/contracts/klp_editing_intent.dart)

## 範圍

核心是 `lib/src/capabilities/editing/contracts/klp_editing_intent.dart`。主要視角為該檔案明寫的 import／export／part；輔助視角為本檔宣告及 extends／implements／with／on 關係。只展開一層外部邊界。

## 直接依賴圖

```mermaid
flowchart LR
	n0["klp_editing_intent.dart"]
	n1["klp_text_offsets.dart"]
	n2["klp_composition_text.dart"]
	n3["klp_replace_text_intent.dart"]
	n4["klp_select_text_intent.dart"]
	n5["klp_begin_composition_intent.dart"]
	n6["klp_update_composition_intent.dart"]
	n7["klp_commit_composition_intent.dart"]
	n8["klp_cancel_composition_intent.dart"]
	n9["klp_editing_command_intent.dart"]
	n0 -->|"import"| n1
	n0 -->|"import"| n2
	n0 -->|"part"| n3
	n0 -->|"part"| n4
	n0 -->|"part"| n5
	n0 -->|"part"| n6
	n0 -->|"part"| n7
	n0 -->|"part"| n8
	n0 -->|"part"| n9
```

## 依賴證據

| 關係 | 原始 directive | 來源 |
|---|---|---|
| import | <code>import &#x27;klp_text_offsets.dart&#x27;;</code> | [lib/src/capabilities/editing/contracts/klp_editing_intent.dart:1](../../../../../../lib/src/capabilities/editing/contracts/klp_editing_intent.dart#L1) |
| import | <code>import &#x27;klp_composition_text.dart&#x27;;</code> | [lib/src/capabilities/editing/contracts/klp_editing_intent.dart:2](../../../../../../lib/src/capabilities/editing/contracts/klp_editing_intent.dart#L2) |
| part | <code>part &#x27;klp_replace_text_intent.dart&#x27;;</code> | [lib/src/capabilities/editing/contracts/klp_editing_intent.dart:4](../../../../../../lib/src/capabilities/editing/contracts/klp_editing_intent.dart#L4) |
| part | <code>part &#x27;klp_select_text_intent.dart&#x27;;</code> | [lib/src/capabilities/editing/contracts/klp_editing_intent.dart:5](../../../../../../lib/src/capabilities/editing/contracts/klp_editing_intent.dart#L5) |
| part | <code>part &#x27;klp_begin_composition_intent.dart&#x27;;</code> | [lib/src/capabilities/editing/contracts/klp_editing_intent.dart:6](../../../../../../lib/src/capabilities/editing/contracts/klp_editing_intent.dart#L6) |
| part | <code>part &#x27;klp_update_composition_intent.dart&#x27;;</code> | [lib/src/capabilities/editing/contracts/klp_editing_intent.dart:7](../../../../../../lib/src/capabilities/editing/contracts/klp_editing_intent.dart#L7) |
| part | <code>part &#x27;klp_commit_composition_intent.dart&#x27;;</code> | [lib/src/capabilities/editing/contracts/klp_editing_intent.dart:8](../../../../../../lib/src/capabilities/editing/contracts/klp_editing_intent.dart#L8) |
| part | <code>part &#x27;klp_cancel_composition_intent.dart&#x27;;</code> | [lib/src/capabilities/editing/contracts/klp_editing_intent.dart:9](../../../../../../lib/src/capabilities/editing/contracts/klp_editing_intent.dart#L9) |
| part | <code>part &#x27;klp_editing_command_intent.dart&#x27;;</code> | [lib/src/capabilities/editing/contracts/klp_editing_intent.dart:10](../../../../../../lib/src/capabilities/editing/contracts/klp_editing_intent.dart#L10) |

## 宣告關係圖

本組節點是本檔宣告；沒有箭頭的宣告未在此圖主張互相依賴。

```mermaid
classDiagram
	class n0["KlpEditingIntent"]
```


## 宣告與成員證據

成員包含 public 與 private；簽章取自來源，省略函式本體與欄位初始值。`(inferred)` 表示來源未明寫型別；建構子只顯示參數部分，不含初始化列表。

### KlpEditingIntent

ClassDeclaration · public · [lib/src/capabilities/editing/contracts/klp_editing_intent.dart:12](../../../../../../lib/src/capabilities/editing/contracts/klp_editing_intent.dart#L12)

<code>sealed class KlpEditingIntent</code>

來源註解摘要：封閉的編輯操作資料；不允許字串命令、Widget 或外部執行函式。


| 成員 | 可見性 | 簽章／型別 | 來源註解摘要 | 證據 |
|---|---|---|---|---|
| constructor <code>KlpEditingIntent</code> | public | <code>const KlpEditingIntent()</code> |  | [lib/src/capabilities/editing/contracts/klp_editing_intent.dart:15](../../../../../../lib/src/capabilities/editing/contracts/klp_editing_intent.dart#L15) |

## 閱讀說明與限制

箭頭只表示來源明寫的靜態關係；import 不等於呼叫。未分析動態呼叫、欄位的實際物件擁有權、狀態轉移或渲染流程；型別未進行語意解析，繼承目標保留原始型別拼寫。public／private 依 Dart 名稱前綴判斷；public 宣告不代表已由 `lib/kallopis.dart` 匯出。

本頁由 `tool/architecture_atlas` 產生；編輯來源或生成工具後重新產生，避免手改本頁。
