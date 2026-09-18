# klp_command_anchor.dart：直接依賴與宣告架構

[回到目錄](README.md) · [來源檔案](../../../../../../lib/src/capabilities/editing/contracts/klp_command_anchor.dart)

## 範圍

核心是 `lib/src/capabilities/editing/contracts/klp_command_anchor.dart`。主要視角為該檔案明寫的 import／export／part；輔助視角為本檔宣告及 extends／implements／with／on 關係。只展開一層外部邊界。

## 直接依賴圖

```mermaid
flowchart LR
	n0["klp_command_anchor.dart"]
	n1["klp_editing_draw_command.dart"]
	n2["klp_editing_endpoint.dart"]
	n3["klp_editing_stamp.dart"]
	n4["klp_block_command_anchor.dart"]
	n5["klp_caret_command_anchor.dart"]
	n0 -->|"import"| n1
	n0 -->|"import"| n2
	n0 -->|"import"| n3
	n0 -->|"part"| n4
	n0 -->|"part"| n5
```

## 依賴證據

| 關係 | 原始 directive | 來源 |
|---|---|---|
| import | <code>import &#x27;klp_editing_draw_command.dart&#x27;;</code> | [lib/src/capabilities/editing/contracts/klp_command_anchor.dart:1](../../../../../../lib/src/capabilities/editing/contracts/klp_command_anchor.dart#L1) |
| import | <code>import &#x27;klp_editing_endpoint.dart&#x27;;</code> | [lib/src/capabilities/editing/contracts/klp_command_anchor.dart:2](../../../../../../lib/src/capabilities/editing/contracts/klp_command_anchor.dart#L2) |
| import | <code>import &#x27;klp_editing_stamp.dart&#x27;;</code> | [lib/src/capabilities/editing/contracts/klp_command_anchor.dart:3](../../../../../../lib/src/capabilities/editing/contracts/klp_command_anchor.dart#L3) |
| part | <code>part &#x27;klp_block_command_anchor.dart&#x27;;</code> | [lib/src/capabilities/editing/contracts/klp_command_anchor.dart:5](../../../../../../lib/src/capabilities/editing/contracts/klp_command_anchor.dart#L5) |
| part | <code>part &#x27;klp_caret_command_anchor.dart&#x27;;</code> | [lib/src/capabilities/editing/contracts/klp_command_anchor.dart:6](../../../../../../lib/src/capabilities/editing/contracts/klp_command_anchor.dart#L6) |

## 宣告關係圖

本組節點是本檔宣告；沒有箭頭的宣告未在此圖主張互相依賴。

```mermaid
classDiagram
	class n0["KlpCommandAnchor"]
```


## 宣告與成員證據

成員包含 public 與 private；簽章取自來源，省略函式本體與欄位初始值。`(inferred)` 表示來源未明寫型別；建構子只顯示參數部分，不含初始化列表。

### KlpCommandAnchor

ClassDeclaration · public · [lib/src/capabilities/editing/contracts/klp_command_anchor.dart:8](../../../../../../lib/src/capabilities/editing/contracts/klp_command_anchor.dart#L8)

<code>sealed class KlpCommandAnchor</code>

來源註解摘要：與 editor drawing 同幀的 typed 命令定位；座標維持 editor-local。


| 成員 | 可見性 | 簽章／型別 | 來源註解摘要 | 證據 |
|---|---|---|---|---|
| field <code>stamp</code> | public | <code>final KlpEditingStamp stamp</code> |  | [lib/src/capabilities/editing/contracts/klp_command_anchor.dart:10](../../../../../../lib/src/capabilities/editing/contracts/klp_command_anchor.dart#L10) |
| field <code>viewportWidth</code> | public | <code>final double viewportWidth</code> |  | [lib/src/capabilities/editing/contracts/klp_command_anchor.dart:11](../../../../../../lib/src/capabilities/editing/contracts/klp_command_anchor.dart#L11) |
| field <code>viewportHeight</code> | public | <code>final double viewportHeight</code> |  | [lib/src/capabilities/editing/contracts/klp_command_anchor.dart:12](../../../../../../lib/src/capabilities/editing/contracts/klp_command_anchor.dart#L12) |
| field <code>rect</code> | public | <code>final KlpEditingRect rect</code> |  | [lib/src/capabilities/editing/contracts/klp_command_anchor.dart:13](../../../../../../lib/src/capabilities/editing/contracts/klp_command_anchor.dart#L13) |
| constructor <code>KlpCommandAnchor</code> | public | <code>KlpCommandAnchor({required this.stamp, required this.viewportWidth, required this.viewportHeight, required this.rect})</code> |  | [lib/src/capabilities/editing/contracts/klp_command_anchor.dart:15](../../../../../../lib/src/capabilities/editing/contracts/klp_command_anchor.dart#L15) |
| method <code>sameIdentity</code> | public | <code>bool sameIdentity(KlpCommandAnchor other)</code> |  | [lib/src/capabilities/editing/contracts/klp_command_anchor.dart:22](../../../../../../lib/src/capabilities/editing/contracts/klp_command_anchor.dart#L22) |

## 閱讀說明與限制

箭頭只表示來源明寫的靜態關係；import 不等於呼叫。未分析動態呼叫、欄位的實際物件擁有權、狀態轉移或渲染流程；型別未進行語意解析，繼承目標保留原始型別拼寫。public／private 依 Dart 名稱前綴判斷；public 宣告不代表已由 `lib/kallopis.dart` 匯出。

本頁由 `tool/architecture_atlas` 產生；編輯來源或生成工具後重新產生，避免手改本頁。
