# klp_window_control_button.dart：直接依賴與宣告架構

[回到目錄](README.md) · [來源檔案](../../../../../../../../lib/src/features/workspace/shell/window/internal/klp_window_control_button.dart)

## 範圍

核心是 `lib/src/features/workspace/shell/window/internal/klp_window_control_button.dart`。主要視角為該檔案明寫的 import／export／part；輔助視角為本檔宣告及 extends／implements／with／on 關係。只展開一層外部邊界。

## 直接依賴圖

```mermaid
flowchart LR
	n0["klp_window_control_button.dart"]
	n1["package:flutter/widgets.dart"]
	n2["../../../../../foundation/klp_icon.dart"]
	n3["../../../../../foundation/interaction/klp_action_region.dart"]
	n4["../../../../../foundation/interaction/klp_action_region_tone.dart"]
	n5["../../../../../foundation/layout/klp_box.dart"]
	n6["../../../../../foundation/layout/klp_center.dart"]
	n7["../../../../overlays/klp_tooltip.dart"]
	n8["../klp_window_controls_geometry.dart"]
	n0 -->|"import"| n1
	n0 -->|"import"| n2
	n0 -->|"import"| n3
	n0 -->|"import"| n4
	n0 -->|"import"| n5
	n0 -->|"import"| n6
	n0 -->|"import"| n7
	n0 -->|"import"| n8
```

## 依賴證據

| 關係 | 原始 directive | 來源 |
|---|---|---|
| import | <code>import &#x27;package:flutter/widgets.dart&#x27;;</code> | [lib/src/features/workspace/shell/window/internal/klp_window_control_button.dart:1](../../../../../../../../lib/src/features/workspace/shell/window/internal/klp_window_control_button.dart#L1) |
| import | <code>import &#x27;../../../../../foundation/klp_icon.dart&#x27;;</code> | [lib/src/features/workspace/shell/window/internal/klp_window_control_button.dart:3](../../../../../../../../lib/src/features/workspace/shell/window/internal/klp_window_control_button.dart#L3) |
| import | <code>import &#x27;../../../../../foundation/interaction/klp_action_region.dart&#x27;;</code> | [lib/src/features/workspace/shell/window/internal/klp_window_control_button.dart:4](../../../../../../../../lib/src/features/workspace/shell/window/internal/klp_window_control_button.dart#L4) |
| import | <code>import &#x27;../../../../../foundation/interaction/klp_action_region_tone.dart&#x27;;</code> | [lib/src/features/workspace/shell/window/internal/klp_window_control_button.dart:5](../../../../../../../../lib/src/features/workspace/shell/window/internal/klp_window_control_button.dart#L5) |
| import | <code>import &#x27;../../../../../foundation/layout/klp_box.dart&#x27;;</code> | [lib/src/features/workspace/shell/window/internal/klp_window_control_button.dart:6](../../../../../../../../lib/src/features/workspace/shell/window/internal/klp_window_control_button.dart#L6) |
| import | <code>import &#x27;../../../../../foundation/layout/klp_center.dart&#x27;;</code> | [lib/src/features/workspace/shell/window/internal/klp_window_control_button.dart:7](../../../../../../../../lib/src/features/workspace/shell/window/internal/klp_window_control_button.dart#L7) |
| import | <code>import &#x27;../../../../overlays/klp_tooltip.dart&#x27;;</code> | [lib/src/features/workspace/shell/window/internal/klp_window_control_button.dart:8](../../../../../../../../lib/src/features/workspace/shell/window/internal/klp_window_control_button.dart#L8) |
| import | <code>import &#x27;../klp_window_controls_geometry.dart&#x27;;</code> | [lib/src/features/workspace/shell/window/internal/klp_window_control_button.dart:9](../../../../../../../../lib/src/features/workspace/shell/window/internal/klp_window_control_button.dart#L9) |

## 宣告關係圖

本組節點是本檔宣告；沒有箭頭的宣告未在此圖主張互相依賴。

```mermaid
classDiagram
	class n0["KlpWindowControlButton"]
```

```mermaid
classDiagram
	class n0["KlpWindowControlButton"]
	class n1["StatelessWidget"]
	n0 --|> n1 : extends
```


## 宣告與成員證據

成員包含 public 與 private；簽章取自來源，省略函式本體與欄位初始值。`(inferred)` 表示來源未明寫型別；建構子只顯示參數部分，不含初始化列表。

### KlpWindowControlButton

ClassDeclaration · public · [lib/src/features/workspace/shell/window/internal/klp_window_control_button.dart:11](../../../../../../../../lib/src/features/workspace/shell/window/internal/klp_window_control_button.dart#L11)

<code>class KlpWindowControlButton extends StatelessWidget</code>

來源註解摘要：視窗控制列內部的單一按鈕呈現。

- `extends` → <code>StatelessWidget</code>：[lib/src/features/workspace/shell/window/internal/klp_window_control_button.dart:12](../../../../../../../../lib/src/features/workspace/shell/window/internal/klp_window_control_button.dart#L12)

| 成員 | 可見性 | 簽章／型別 | 來源註解摘要 | 證據 |
|---|---|---|---|---|
| constructor <code>KlpWindowControlButton</code> | public | <code>const KlpWindowControlButton({ super.key, required this.icon, required this.label, required this.onPressed, required this.geometry, this.destructive = false, })</code> |  | [lib/src/features/workspace/shell/window/internal/klp_window_control_button.dart:13](../../../../../../../../lib/src/features/workspace/shell/window/internal/klp_window_control_button.dart#L13) |
| field <code>icon</code> | public | <code>final KlpIconData icon</code> |  | [lib/src/features/workspace/shell/window/internal/klp_window_control_button.dart:22](../../../../../../../../lib/src/features/workspace/shell/window/internal/klp_window_control_button.dart#L22) |
| field <code>label</code> | public | <code>final String label</code> |  | [lib/src/features/workspace/shell/window/internal/klp_window_control_button.dart:23](../../../../../../../../lib/src/features/workspace/shell/window/internal/klp_window_control_button.dart#L23) |
| field <code>onPressed</code> | public | <code>final VoidCallback? onPressed</code> |  | [lib/src/features/workspace/shell/window/internal/klp_window_control_button.dart:24](../../../../../../../../lib/src/features/workspace/shell/window/internal/klp_window_control_button.dart#L24) |
| field <code>geometry</code> | public | <code>final KlpWindowControlsGeometry geometry</code> |  | [lib/src/features/workspace/shell/window/internal/klp_window_control_button.dart:25](../../../../../../../../lib/src/features/workspace/shell/window/internal/klp_window_control_button.dart#L25) |
| field <code>destructive</code> | public | <code>final bool destructive</code> |  | [lib/src/features/workspace/shell/window/internal/klp_window_control_button.dart:26](../../../../../../../../lib/src/features/workspace/shell/window/internal/klp_window_control_button.dart#L26) |
| method <code>build</code> | public | <code>Widget build(BuildContext context)</code> |  | [lib/src/features/workspace/shell/window/internal/klp_window_control_button.dart:28](../../../../../../../../lib/src/features/workspace/shell/window/internal/klp_window_control_button.dart#L28) |

## 閱讀說明與限制

箭頭只表示來源明寫的靜態關係；import 不等於呼叫。未分析動態呼叫、欄位的實際物件擁有權、狀態轉移或渲染流程；型別未進行語意解析，繼承目標保留原始型別拼寫。public／private 依 Dart 名稱前綴判斷；public 宣告不代表已由 `lib/kallopis.dart` 匯出。

本頁由 `tool/architecture_atlas` 產生；編輯來源或生成工具後重新產生，避免手改本頁。
