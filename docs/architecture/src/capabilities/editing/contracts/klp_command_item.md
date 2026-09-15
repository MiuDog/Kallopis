# klp_command_item.dart：直接依賴與宣告架構

[回到目錄](README.md) · [來源檔案](../../../../../../lib/src/capabilities/editing/contracts/klp_command_item.dart)

## 範圍

核心是 `lib/src/capabilities/editing/contracts/klp_command_item.dart`。主要視角為該檔案明寫的 import／export／part；輔助視角為本檔宣告及 extends／implements／with／on 關係。只展開一層外部邊界。

## 直接依賴圖

```mermaid
flowchart TD
	n0["klp_command_item.dart"]
```

## 依賴證據

| 關係 | 原始 directive | 來源 |
|---|---|---|
| 無 | 本檔未宣告 import／export／part | [lib/src/capabilities/editing/contracts/klp_command_item.dart:1](../../../../../../lib/src/capabilities/editing/contracts/klp_command_item.dart#L1) |

## 宣告關係圖

本組節點是本檔宣告；沒有箭頭的宣告未在此圖主張互相依賴。

```mermaid
classDiagram
	class n0["KlpCommandAvailability"]
	class n1["KlpCommandTone"]
	class n2["KlpCommandItem"]
```


## 宣告與成員證據

成員包含 public 與 private；簽章取自來源，省略函式本體與欄位初始值。`(inferred)` 表示來源未明寫型別；建構子只顯示參數部分，不含初始化列表。

### KlpCommandAvailability

EnumDeclaration · public · [lib/src/capabilities/editing/contracts/klp_command_item.dart:1](../../../../../../lib/src/capabilities/editing/contracts/klp_command_item.dart#L1)

<code>enum KlpCommandAvailability</code>

來源註解摘要：提供者回報的命令可用性；畫面不自行推定執行權限。


| 成員 | 可見性 | 簽章／型別 | 來源註解摘要 | 證據 |
|---|---|---|---|---|
| enum value <code>enabled</code> | public | <code>enabled</code> |  | [lib/src/capabilities/editing/contracts/klp_command_item.dart:2](../../../../../../lib/src/capabilities/editing/contracts/klp_command_item.dart#L2) |
| enum value <code>disabled</code> | public | <code>disabled</code> |  | [lib/src/capabilities/editing/contracts/klp_command_item.dart:2](../../../../../../lib/src/capabilities/editing/contracts/klp_command_item.dart#L2) |

### KlpCommandTone

EnumDeclaration · public · [lib/src/capabilities/editing/contracts/klp_command_item.dart:3](../../../../../../lib/src/capabilities/editing/contracts/klp_command_item.dart#L3)

<code>enum KlpCommandTone</code>

來源註解摘要：命令的語意強調用途；實際風格由本庫解析。


| 成員 | 可見性 | 簽章／型別 | 來源註解摘要 | 證據 |
|---|---|---|---|---|
| enum value <code>neutral</code> | public | <code>neutral</code> |  | [lib/src/capabilities/editing/contracts/klp_command_item.dart:4](../../../../../../lib/src/capabilities/editing/contracts/klp_command_item.dart#L4) |
| enum value <code>danger</code> | public | <code>danger</code> |  | [lib/src/capabilities/editing/contracts/klp_command_item.dart:4](../../../../../../lib/src/capabilities/editing/contracts/klp_command_item.dart#L4) |

### KlpCommandItem

ClassDeclaration · public · [lib/src/capabilities/editing/contracts/klp_command_item.dart:6](../../../../../../lib/src/capabilities/editing/contracts/klp_command_item.dart#L6)

<code>final class KlpCommandItem</code>

來源註解摘要：來源擁有的穩定候選資料；callback、樣式與鍵盤高亮不屬於 item。


| 成員 | 可見性 | 簽章／型別 | 來源註解摘要 | 證據 |
|---|---|---|---|---|
| field <code>id</code> | public | <code>final String id</code> |  | [lib/src/capabilities/editing/contracts/klp_command_item.dart:8](../../../../../../lib/src/capabilities/editing/contracts/klp_command_item.dart#L8) |
| field <code>label</code> | public | <code>final String label</code> |  | [lib/src/capabilities/editing/contracts/klp_command_item.dart:9](../../../../../../lib/src/capabilities/editing/contracts/klp_command_item.dart#L9) |
| field <code>caption</code> | public | <code>final String? caption</code> |  | [lib/src/capabilities/editing/contracts/klp_command_item.dart:10](../../../../../../lib/src/capabilities/editing/contracts/klp_command_item.dart#L10) |
| field <code>availability</code> | public | <code>final KlpCommandAvailability availability</code> |  | [lib/src/capabilities/editing/contracts/klp_command_item.dart:11](../../../../../../lib/src/capabilities/editing/contracts/klp_command_item.dart#L11) |
| field <code>disabledReason</code> | public | <code>final String? disabledReason</code> |  | [lib/src/capabilities/editing/contracts/klp_command_item.dart:12](../../../../../../lib/src/capabilities/editing/contracts/klp_command_item.dart#L12) |
| field <code>selected</code> | public | <code>final bool selected</code> |  | [lib/src/capabilities/editing/contracts/klp_command_item.dart:13](../../../../../../lib/src/capabilities/editing/contracts/klp_command_item.dart#L13) |
| field <code>tone</code> | public | <code>final KlpCommandTone tone</code> |  | [lib/src/capabilities/editing/contracts/klp_command_item.dart:14](../../../../../../lib/src/capabilities/editing/contracts/klp_command_item.dart#L14) |
| constructor <code>KlpCommandItem</code> | public | <code>KlpCommandItem({required this.id, required this.label, required this.availability, required this.selected, required this.tone, this.caption, this.disabledReason})</code> |  | [lib/src/capabilities/editing/contracts/klp_command_item.dart:16](../../../../../../lib/src/capabilities/editing/contracts/klp_command_item.dart#L16) |
| getter <code>enabled</code> | public | <code>bool get enabled</code> |  | [lib/src/capabilities/editing/contracts/klp_command_item.dart:22](../../../../../../lib/src/capabilities/editing/contracts/klp_command_item.dart#L22) |

## 閱讀說明與限制

箭頭只表示來源明寫的靜態關係；import 不等於呼叫。未分析動態呼叫、欄位的實際物件擁有權、狀態轉移或渲染流程；型別未進行語意解析，繼承目標保留原始型別拼寫。public／private 依 Dart 名稱前綴判斷；public 宣告不代表已由 `lib/kallopis.dart` 匯出。

本頁由 `tool/architecture_atlas` 產生；編輯來源或生成工具後重新產生，避免手改本頁。
