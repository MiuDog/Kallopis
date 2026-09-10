# klp_stage_frame.dart：直接依賴與宣告架構

[回到目錄](README.md) · [來源檔案](../../../../../../../lib/src/features/workspace/shell/stage/klp_stage_frame.dart)

## 範圍

核心是 `lib/src/features/workspace/shell/stage/klp_stage_frame.dart`。主要視角為該檔案明寫的 import／export／part；輔助視角為本檔宣告及 extends／implements／with／on 關係。只展開一層外部邊界。

## 直接依賴圖

```mermaid
flowchart LR
	n0["klp_stage_frame.dart"]
	n1["package:flutter/material.dart"]
	n2["../../../../foundation/layout/klp_layout.dart"]
	n3["../../../../styling/legacy_theme/klp_theme.dart"]
	n4["../panel/klp_panel_footer.dart"]
	n5["../status/klp_status_bar.dart"]
	n6["../status/klp_status_data.dart"]
	n7["klp_stage_header.dart"]
	n8["primitives/klp_stage_header_slot.dart"]
	n9["primitives/klp_stage_status_slot.dart"]
	n10["primitives/klp_stage_surface.dart"]
	n0 -->|"import"| n1
	n0 -->|"import"| n2
	n0 -->|"import"| n3
	n0 -->|"import"| n4
	n0 -->|"import"| n5
	n0 -->|"import"| n6
	n0 -->|"import"| n7
	n0 -->|"part"| n8
	n0 -->|"part"| n9
	n0 -->|"part"| n10
```

## 依賴證據

| 關係 | 原始 directive | 來源 |
|---|---|---|
| import | <code>import &#x27;package:flutter/material.dart&#x27;;</code> | [lib/src/features/workspace/shell/stage/klp_stage_frame.dart:1](../../../../../../../lib/src/features/workspace/shell/stage/klp_stage_frame.dart#L1) |
| import | <code>import &#x27;../../../../foundation/layout/klp_layout.dart&#x27;;</code> | [lib/src/features/workspace/shell/stage/klp_stage_frame.dart:3](../../../../../../../lib/src/features/workspace/shell/stage/klp_stage_frame.dart#L3) |
| import | <code>import &#x27;../../../../styling/legacy_theme/klp_theme.dart&#x27;;</code> | [lib/src/features/workspace/shell/stage/klp_stage_frame.dart:4](../../../../../../../lib/src/features/workspace/shell/stage/klp_stage_frame.dart#L4) |
| import | <code>import &#x27;../panel/klp_panel_footer.dart&#x27;;</code> | [lib/src/features/workspace/shell/stage/klp_stage_frame.dart:5](../../../../../../../lib/src/features/workspace/shell/stage/klp_stage_frame.dart#L5) |
| import | <code>import &#x27;../status/klp_status_bar.dart&#x27;;</code> | [lib/src/features/workspace/shell/stage/klp_stage_frame.dart:6](../../../../../../../lib/src/features/workspace/shell/stage/klp_stage_frame.dart#L6) |
| import | <code>import &#x27;../status/klp_status_data.dart&#x27;;</code> | [lib/src/features/workspace/shell/stage/klp_stage_frame.dart:7](../../../../../../../lib/src/features/workspace/shell/stage/klp_stage_frame.dart#L7) |
| import | <code>import &#x27;klp_stage_header.dart&#x27;;</code> | [lib/src/features/workspace/shell/stage/klp_stage_frame.dart:8](../../../../../../../lib/src/features/workspace/shell/stage/klp_stage_frame.dart#L8) |
| part | <code>part &#x27;primitives/klp_stage_header_slot.dart&#x27;;</code> | [lib/src/features/workspace/shell/stage/klp_stage_frame.dart:10](../../../../../../../lib/src/features/workspace/shell/stage/klp_stage_frame.dart#L10) |
| part | <code>part &#x27;primitives/klp_stage_status_slot.dart&#x27;;</code> | [lib/src/features/workspace/shell/stage/klp_stage_frame.dart:11](../../../../../../../lib/src/features/workspace/shell/stage/klp_stage_frame.dart#L11) |
| part | <code>part &#x27;primitives/klp_stage_surface.dart&#x27;;</code> | [lib/src/features/workspace/shell/stage/klp_stage_frame.dart:12](../../../../../../../lib/src/features/workspace/shell/stage/klp_stage_frame.dart#L12) |

## 宣告關係圖

本組節點是本檔宣告；沒有箭頭的宣告未在此圖主張互相依賴。

```mermaid
classDiagram
	class n0["KlpStageFrame"]
```

```mermaid
classDiagram
	class n0["KlpStageFrame"]
	class n1["StatelessWidget"]
	n0 --|> n1 : extends
```


## 宣告與成員證據

成員包含 public 與 private；簽章取自來源，省略函式本體與欄位初始值。`(inferred)` 表示來源未明寫型別；建構子只顯示參數部分，不含初始化列表。

### KlpStageFrame

ClassDeclaration · public · [lib/src/features/workspace/shell/stage/klp_stage_frame.dart:14](../../../../../../../lib/src/features/workspace/shell/stage/klp_stage_frame.dart#L14)

<code>class KlpStageFrame extends StatelessWidget</code>

來源註解摘要：舞台區：選用的頂部 header、中央 content、底部選用的 status 列。

- `extends` → <code>StatelessWidget</code>：[lib/src/features/workspace/shell/stage/klp_stage_frame.dart:15](../../../../../../../lib/src/features/workspace/shell/stage/klp_stage_frame.dart#L15)

| 成員 | 可見性 | 簽章／型別 | 來源註解摘要 | 證據 |
|---|---|---|---|---|
| constructor <code>KlpStageFrame</code> | public | <code>const KlpStageFrame({ super.key, this.header, required this.content, this.status, })</code> |  | [lib/src/features/workspace/shell/stage/klp_stage_frame.dart:16](../../../../../../../lib/src/features/workspace/shell/stage/klp_stage_frame.dart#L16) |
| constructor <code>workbench</code> | public | <code>factory KlpStageFrame.workbench({ Key? key, required String projectName, required String sectionLabel, required String title, required String typeLabel, required Widget content, KlpStatusBarData? status, })</code> | 建立具備 Kallopis 標準識別列與狀態列的工作舞台。 產品只提供語意資料與主要內容；header、status 的元件選擇、排列、間距與 響應式行為都留在 Kallopis。 | [lib/src/features/workspace/shell/stage/klp_stage_frame.dart:23](../../../../../../../lib/src/features/workspace/shell/stage/klp_stage_frame.dart#L23) |
| field <code>header</code> | public | <code>final Widget? header</code> |  | [lib/src/features/workspace/shell/stage/klp_stage_frame.dart:49](../../../../../../../lib/src/features/workspace/shell/stage/klp_stage_frame.dart#L49) |
| field <code>content</code> | public | <code>final Widget content</code> |  | [lib/src/features/workspace/shell/stage/klp_stage_frame.dart:50](../../../../../../../lib/src/features/workspace/shell/stage/klp_stage_frame.dart#L50) |
| field <code>status</code> | public | <code>final Widget? status</code> |  | [lib/src/features/workspace/shell/stage/klp_stage_frame.dart:51](../../../../../../../lib/src/features/workspace/shell/stage/klp_stage_frame.dart#L51) |
| method <code>build</code> | public | <code>Widget build(BuildContext context)</code> |  | [lib/src/features/workspace/shell/stage/klp_stage_frame.dart:53](../../../../../../../lib/src/features/workspace/shell/stage/klp_stage_frame.dart#L53) |

## 閱讀說明與限制

箭頭只表示來源明寫的靜態關係；import 不等於呼叫。未分析動態呼叫、欄位的實際物件擁有權、狀態轉移或渲染流程；型別未進行語意解析，繼承目標保留原始型別拼寫。public／private 依 Dart 名稱前綴判斷；public 宣告不代表已由 `lib/kallopis.dart` 匯出。

本頁由 `tool/architecture_atlas` 產生；編輯來源或生成工具後重新產生，避免手改本頁。
