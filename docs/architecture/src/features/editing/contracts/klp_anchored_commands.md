# klp_anchored_commands.dart：直接依賴與宣告架構

[回到目錄](README.md) · [來源檔案](../../../../../../lib/src/features/editing/contracts/klp_anchored_commands.dart)

## 範圍

核心是 `lib/src/features/editing/contracts/klp_anchored_commands.dart`。主要視角為該檔案明寫的 import／export／part；輔助視角為本檔宣告及 extends／implements／with／on 關係。只展開一層外部邊界。

## 直接依賴圖

```mermaid
flowchart TD
	n0["klp_anchored_commands.dart"]
	n1["package:kallopis/src/kernel/identity/klp_id.dart"]
	n2["klp_command_slot_child.dart"]
	n0 -->|"import"| n1
	n0 -->|"import"| n2
```

## 依賴證據

| 關係 | 原始 directive | 來源 |
|---|---|---|
| import | <code>import &#x27;package:kallopis/src/kernel/identity/klp_id.dart&#x27;;</code> | [lib/src/features/editing/contracts/klp_anchored_commands.dart:1](../../../../../../lib/src/features/editing/contracts/klp_anchored_commands.dart#L1) |
| import | <code>import &#x27;klp_command_slot_child.dart&#x27;;</code> | [lib/src/features/editing/contracts/klp_anchored_commands.dart:2](../../../../../../lib/src/features/editing/contracts/klp_anchored_commands.dart#L2) |

## 宣告關係圖

本組節點是本檔宣告；沒有箭頭的宣告未在此圖主張互相依賴。

```mermaid
classDiagram
	class n0["KlpAnchoredCommands"]
```

```mermaid
classDiagram
	class n0["KlpAnchoredCommands"]
	class n1["KlpCommandSlotChild"]
	n0 ..|> n1 : implements
```


## 宣告與成員證據

成員包含 public 與 private；簽章取自來源，省略函式本體與欄位初始值。`(inferred)` 表示來源未明寫型別；建構子只顯示參數部分，不含初始化列表。

### KlpAnchoredCommands

ClassDeclaration · public · [lib/src/features/editing/contracts/klp_anchored_commands.dart:4](../../../../../../lib/src/features/editing/contracts/klp_anchored_commands.dart#L4)

<code>final class KlpAnchoredCommands implements KlpCommandSlotChild</code>

來源註解摘要：啟用本庫定位命令機制；consumer 只提供結構身分。

- `implements` → <code>KlpCommandSlotChild</code>：[lib/src/features/editing/contracts/klp_anchored_commands.dart:5](../../../../../../lib/src/features/editing/contracts/klp_anchored_commands.dart#L5)

| 成員 | 可見性 | 簽章／型別 | 來源註解摘要 | 證據 |
|---|---|---|---|---|
| field <code>typeId</code> | public | <code>static const (inferred) typeId</code> |  | [lib/src/features/editing/contracts/klp_anchored_commands.dart:6](../../../../../../lib/src/features/editing/contracts/klp_anchored_commands.dart#L6) |
| field <code>id</code> | public | <code>final KlpId id</code> |  | [lib/src/features/editing/contracts/klp_anchored_commands.dart:8](../../../../../../lib/src/features/editing/contracts/klp_anchored_commands.dart#L8) |
| constructor <code>KlpAnchoredCommands</code> | public | <code>const KlpAnchoredCommands({required this.id})</code> |  | [lib/src/features/editing/contracts/klp_anchored_commands.dart:10](../../../../../../lib/src/features/editing/contracts/klp_anchored_commands.dart#L10) |
| getter <code>definitionId</code> | public | <code>String get definitionId</code> |  | [lib/src/features/editing/contracts/klp_anchored_commands.dart:12](../../../../../../lib/src/features/editing/contracts/klp_anchored_commands.dart#L12) |
| getter <code>children</code> | public | <code>Iterable&lt;KlpCommandSlotChild&gt; get children</code> |  | [lib/src/features/editing/contracts/klp_anchored_commands.dart:14](../../../../../../lib/src/features/editing/contracts/klp_anchored_commands.dart#L14) |

## 閱讀說明與限制

箭頭只表示來源明寫的靜態關係；import 不等於呼叫。未分析動態呼叫、欄位的實際物件擁有權、狀態轉移或渲染流程；型別未進行語意解析，繼承目標保留原始型別拼寫。public／private 依 Dart 名稱前綴判斷；public 宣告不代表已由 `lib/kallopis.dart` 匯出。

本頁由 `tool/architecture_atlas` 產生；編輯來源或生成工具後重新產生，避免手改本頁。
