# klp_editor_mode_item.dart：直接依賴與宣告架構

[回到目錄](README.md) · [來源檔案](../../../../../../lib/src/capabilities/editing/contracts/klp_editor_mode_item.dart)

## 範圍

核心是 `lib/src/capabilities/editing/contracts/klp_editor_mode_item.dart`。主要視角為該檔案明寫的 import／export／part；輔助視角為本檔宣告及 extends／implements／with／on 關係。只展開一層外部邊界。

## 直接依賴圖

```mermaid
flowchart TD
	n0["klp_editor_mode_item.dart"]
```

## 依賴證據

| 關係 | 原始 directive | 來源 |
|---|---|---|
| 無 | 本檔未宣告 import／export／part | [lib/src/capabilities/editing/contracts/klp_editor_mode_item.dart:1](../../../../../../lib/src/capabilities/editing/contracts/klp_editor_mode_item.dart#L1) |

## 宣告關係圖

本組節點是本檔宣告；沒有箭頭的宣告未在此圖主張互相依賴。

```mermaid
classDiagram
	class n0["KlpEditorInputPurpose"]
	class n1["KlpEditorModeAvailability"]
	class n2["KlpEditorModeItem"]
```


## 宣告與成員證據

成員包含 public 與 private；簽章取自來源，省略函式本體與欄位初始值。`(inferred)` 表示來源未明寫型別；建構子只顯示參數部分，不含初始化列表。

### KlpEditorInputPurpose

EnumDeclaration · public · [lib/src/capabilities/editing/contracts/klp_editor_mode_item.dart:1](../../../../../../lib/src/capabilities/editing/contracts/klp_editor_mode_item.dart#L1)

<code>enum KlpEditorInputPurpose</code>

來源註解摘要：編輯模式的輸入通道用途；不實作文字、導覽或筆跡引擎。


| 成員 | 可見性 | 簽章／型別 | 來源註解摘要 | 證據 |
|---|---|---|---|---|
| enum value <code>text</code> | public | <code>text</code> |  | [lib/src/capabilities/editing/contracts/klp_editor_mode_item.dart:2](../../../../../../lib/src/capabilities/editing/contracts/klp_editor_mode_item.dart#L2) |
| enum value <code>navigation</code> | public | <code>navigation</code> |  | [lib/src/capabilities/editing/contracts/klp_editor_mode_item.dart:2](../../../../../../lib/src/capabilities/editing/contracts/klp_editor_mode_item.dart#L2) |
| enum value <code>handwriting</code> | public | <code>handwriting</code> |  | [lib/src/capabilities/editing/contracts/klp_editor_mode_item.dart:2](../../../../../../lib/src/capabilities/editing/contracts/klp_editor_mode_item.dart#L2) |

### KlpEditorModeAvailability

EnumDeclaration · public · [lib/src/capabilities/editing/contracts/klp_editor_mode_item.dart:3](../../../../../../lib/src/capabilities/editing/contracts/klp_editor_mode_item.dart#L3)

<code>enum KlpEditorModeAvailability</code>

來源註解摘要：來源回報的模式可用性；不由畫面重新判定模式能力。


| 成員 | 可見性 | 簽章／型別 | 來源註解摘要 | 證據 |
|---|---|---|---|---|
| enum value <code>enabled</code> | public | <code>enabled</code> |  | [lib/src/capabilities/editing/contracts/klp_editor_mode_item.dart:4](../../../../../../lib/src/capabilities/editing/contracts/klp_editor_mode_item.dart#L4) |
| enum value <code>disabled</code> | public | <code>disabled</code> |  | [lib/src/capabilities/editing/contracts/klp_editor_mode_item.dart:4](../../../../../../lib/src/capabilities/editing/contracts/klp_editor_mode_item.dart#L4) |

### KlpEditorModeItem

ClassDeclaration · public · [lib/src/capabilities/editing/contracts/klp_editor_mode_item.dart:6](../../../../../../lib/src/capabilities/editing/contracts/klp_editor_mode_item.dart#L6)

<code>final class KlpEditorModeItem</code>

來源註解摘要：來源註冊的模式；availability 必須反映完整 handler 與核心能力。


| 成員 | 可見性 | 簽章／型別 | 來源註解摘要 | 證據 |
|---|---|---|---|---|
| field <code>id</code> | public | <code>final String id</code> |  | [lib/src/capabilities/editing/contracts/klp_editor_mode_item.dart:8](../../../../../../lib/src/capabilities/editing/contracts/klp_editor_mode_item.dart#L8) |
| field <code>label</code> | public | <code>final String label</code> |  | [lib/src/capabilities/editing/contracts/klp_editor_mode_item.dart:9](../../../../../../lib/src/capabilities/editing/contracts/klp_editor_mode_item.dart#L9) |
| field <code>purpose</code> | public | <code>final KlpEditorInputPurpose purpose</code> |  | [lib/src/capabilities/editing/contracts/klp_editor_mode_item.dart:10](../../../../../../lib/src/capabilities/editing/contracts/klp_editor_mode_item.dart#L10) |
| field <code>availability</code> | public | <code>final KlpEditorModeAvailability availability</code> |  | [lib/src/capabilities/editing/contracts/klp_editor_mode_item.dart:11](../../../../../../lib/src/capabilities/editing/contracts/klp_editor_mode_item.dart#L11) |
| field <code>disabledReason</code> | public | <code>final String? disabledReason</code> |  | [lib/src/capabilities/editing/contracts/klp_editor_mode_item.dart:12](../../../../../../lib/src/capabilities/editing/contracts/klp_editor_mode_item.dart#L12) |
| constructor <code>KlpEditorModeItem</code> | public | <code>KlpEditorModeItem({required this.id, required this.label, required this.purpose, required this.availability, this.disabledReason})</code> |  | [lib/src/capabilities/editing/contracts/klp_editor_mode_item.dart:14](../../../../../../lib/src/capabilities/editing/contracts/klp_editor_mode_item.dart#L14) |
| getter <code>enabled</code> | public | <code>bool get enabled</code> |  | [lib/src/capabilities/editing/contracts/klp_editor_mode_item.dart:20](../../../../../../lib/src/capabilities/editing/contracts/klp_editor_mode_item.dart#L20) |

## 閱讀說明與限制

箭頭只表示來源明寫的靜態關係；import 不等於呼叫。未分析動態呼叫、欄位的實際物件擁有權、狀態轉移或渲染流程；型別未進行語意解析，繼承目標保留原始型別拼寫。public／private 依 Dart 名稱前綴判斷；public 宣告不代表已由 `lib/kallopis.dart` 匯出。

本頁由 `tool/architecture_atlas` 產生；編輯來源或生成工具後重新產生，避免手改本頁。
