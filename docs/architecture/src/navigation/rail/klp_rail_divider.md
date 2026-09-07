# klp_rail_divider.dart：直接依賴與宣告架構

[回到目錄](README.md) · [來源檔案](../../../../../lib/src/navigation/rail/klp_rail_divider.dart)

## 範圍

核心是 `lib/src/navigation/rail/klp_rail_divider.dart`。主要視角為該檔案明寫的 import／export／part；輔助視角為本檔宣告及 extends／implements／with／on 關係。只展開一層外部邊界。

## 直接依賴圖

```mermaid
flowchart TD
	n0["klp_rail_divider.dart"]
	n1["package:flutter/widgets.dart"]
	n2["../../surface/klp_dashed_border.dart"]
	n3["klp_rail_entry.dart"]
	n0 -->|"import"| n1
	n0 -->|"import"| n2
	n0 -->|"import"| n3
```

## 依賴證據

| 關係 | 原始 directive | 來源 |
|---|---|---|
| import | <code>import &#x27;package:flutter/widgets.dart&#x27;;</code> | [lib/src/navigation/rail/klp_rail_divider.dart:1](../../../../../lib/src/navigation/rail/klp_rail_divider.dart#L1) |
| import | <code>import &#x27;../../surface/klp_dashed_border.dart&#x27;;</code> | [lib/src/navigation/rail/klp_rail_divider.dart:3](../../../../../lib/src/navigation/rail/klp_rail_divider.dart#L3) |
| import | <code>import &#x27;klp_rail_entry.dart&#x27;;</code> | [lib/src/navigation/rail/klp_rail_divider.dart:4](../../../../../lib/src/navigation/rail/klp_rail_divider.dart#L4) |

## 宣告關係圖

本組節點是本檔宣告；沒有箭頭的宣告未在此圖主張互相依賴。

```mermaid
classDiagram
	class n0["KlpRailDivider"]
```

```mermaid
classDiagram
	class n0["KlpRailDivider"]
	class n1["KlpRailEntry"]
	n0 --|> n1 : extends
```


## 宣告與成員證據

成員包含 public 與 private；簽章取自來源，省略函式本體與欄位初始值。`(inferred)` 表示來源未明寫型別；建構子只顯示參數部分，不含初始化列表。

### KlpRailDivider

ClassDeclaration · public · [lib/src/navigation/rail/klp_rail_divider.dart:6](../../../../../lib/src/navigation/rail/klp_rail_divider.dart#L6)

<code>final class KlpRailDivider extends KlpRailEntry</code>

來源註解摘要：Rail 專用的固定分隔 Entry。

- `extends` → <code>KlpRailEntry</code>：[lib/src/navigation/rail/klp_rail_divider.dart:7](../../../../../lib/src/navigation/rail/klp_rail_divider.dart#L7)

| 成員 | 可見性 | 簽章／型別 | 來源註解摘要 | 證據 |
|---|---|---|---|---|
| constructor <code>KlpRailDivider</code> | public | <code>const KlpRailDivider({required super.id})</code> |  | [lib/src/navigation/rail/klp_rail_divider.dart:8](../../../../../lib/src/navigation/rail/klp_rail_divider.dart#L8) |
| getter <code>isDraggable</code> | public | <code>bool get isDraggable</code> |  | [lib/src/navigation/rail/klp_rail_divider.dart:10](../../../../../lib/src/navigation/rail/klp_rail_divider.dart#L10) |
| method <code>build</code> | public | <code>Widget build(BuildContext context)</code> |  | [lib/src/navigation/rail/klp_rail_divider.dart:13](../../../../../lib/src/navigation/rail/klp_rail_divider.dart#L13) |

## 閱讀說明與限制

箭頭只表示來源明寫的靜態關係；import 不等於呼叫。未分析動態呼叫、欄位的實際物件擁有權、狀態轉移或渲染流程；型別未進行語意解析，繼承目標保留原始型別拼寫。public／private 依 Dart 名稱前綴判斷；public 宣告不代表已由 `lib/kallopis.dart` 匯出。

本頁由 `tool/architecture_atlas` 產生；編輯來源或生成工具後重新產生，避免手改本頁。
