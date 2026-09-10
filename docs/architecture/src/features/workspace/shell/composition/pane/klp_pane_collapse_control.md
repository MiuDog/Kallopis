# klp_pane_collapse_control.dart：直接依賴與宣告架構

[回到目錄](README.md) · [來源檔案](../../../../../../../../lib/src/features/workspace/shell/composition/pane/klp_pane_collapse_control.dart)

## 範圍

核心是 `lib/src/features/workspace/shell/composition/pane/klp_pane_collapse_control.dart`。主要視角為該檔案明寫的 import／export／part；輔助視角為本檔宣告及 extends／implements／with／on 關係。只展開一層外部邊界。

## 直接依賴圖

```mermaid
flowchart LR
	n0["klp_pane_collapse_control.dart"]
	n1["package:flutter/widgets.dart"]
	n2["../../../../../foundation/klp_icon.dart"]
	n3["../../../../../foundation/klp_icons.dart"]
	n4["../../../../../foundation/interaction/klp_action_region.dart"]
	n5["../../../../../foundation/interaction/klp_action_region_shape.dart"]
	n6["../../../../../application/localization/klp_localizations.dart"]
	n7["../../../../../styling/legacy_theme/klp_theme.dart"]
	n8["primitives/klp_pane_collapse_icon_frame.dart"]
	n0 -->|"import"| n1
	n0 -->|"import"| n2
	n0 -->|"import"| n3
	n0 -->|"import"| n4
	n0 -->|"import"| n5
	n0 -->|"import"| n6
	n0 -->|"import"| n7
	n0 -->|"part"| n8
```

## 依賴證據

| 關係 | 原始 directive | 來源 |
|---|---|---|
| import | <code>import &#x27;package:flutter/widgets.dart&#x27;;</code> | [lib/src/features/workspace/shell/composition/pane/klp_pane_collapse_control.dart:1](../../../../../../../../lib/src/features/workspace/shell/composition/pane/klp_pane_collapse_control.dart#L1) |
| import | <code>import &#x27;../../../../../foundation/klp_icon.dart&#x27;;</code> | [lib/src/features/workspace/shell/composition/pane/klp_pane_collapse_control.dart:3](../../../../../../../../lib/src/features/workspace/shell/composition/pane/klp_pane_collapse_control.dart#L3) |
| import | <code>import &#x27;../../../../../foundation/klp_icons.dart&#x27;;</code> | [lib/src/features/workspace/shell/composition/pane/klp_pane_collapse_control.dart:4](../../../../../../../../lib/src/features/workspace/shell/composition/pane/klp_pane_collapse_control.dart#L4) |
| import | <code>import &#x27;../../../../../foundation/interaction/klp_action_region.dart&#x27;;</code> | [lib/src/features/workspace/shell/composition/pane/klp_pane_collapse_control.dart:5](../../../../../../../../lib/src/features/workspace/shell/composition/pane/klp_pane_collapse_control.dart#L5) |
| import | <code>import &#x27;../../../../../foundation/interaction/klp_action_region_shape.dart&#x27;;</code> | [lib/src/features/workspace/shell/composition/pane/klp_pane_collapse_control.dart:6](../../../../../../../../lib/src/features/workspace/shell/composition/pane/klp_pane_collapse_control.dart#L6) |
| import | <code>import &#x27;../../../../../application/localization/klp_localizations.dart&#x27;;</code> | [lib/src/features/workspace/shell/composition/pane/klp_pane_collapse_control.dart:7](../../../../../../../../lib/src/features/workspace/shell/composition/pane/klp_pane_collapse_control.dart#L7) |
| import | <code>import &#x27;../../../../../styling/legacy_theme/klp_theme.dart&#x27;;</code> | [lib/src/features/workspace/shell/composition/pane/klp_pane_collapse_control.dart:8](../../../../../../../../lib/src/features/workspace/shell/composition/pane/klp_pane_collapse_control.dart#L8) |
| part | <code>part &#x27;primitives/klp_pane_collapse_icon_frame.dart&#x27;;</code> | [lib/src/features/workspace/shell/composition/pane/klp_pane_collapse_control.dart:10](../../../../../../../../lib/src/features/workspace/shell/composition/pane/klp_pane_collapse_control.dart#L10) |

## 宣告關係圖

本組節點是本檔宣告；沒有箭頭的宣告未在此圖主張互相依賴。

```mermaid
classDiagram
	class n0["KlpPaneCollapseControl"]
```

```mermaid
classDiagram
	class n0["KlpPaneCollapseControl"]
	class n1["StatelessWidget"]
	n0 --|> n1 : extends
```


## 宣告與成員證據

成員包含 public 與 private；簽章取自來源，省略函式本體與欄位初始值。`(inferred)` 表示來源未明寫型別；建構子只顯示參數部分，不含初始化列表。

### KlpPaneCollapseControl

ClassDeclaration · public · [lib/src/features/workspace/shell/composition/pane/klp_pane_collapse_control.dart:12](../../../../../../../../lib/src/features/workspace/shell/composition/pane/klp_pane_collapse_control.dart#L12)

<code>class KlpPaneCollapseControl extends StatelessWidget</code>

來源註解摘要：Pane 的收合互動控制。

- `extends` → <code>StatelessWidget</code>：[lib/src/features/workspace/shell/composition/pane/klp_pane_collapse_control.dart:13](../../../../../../../../lib/src/features/workspace/shell/composition/pane/klp_pane_collapse_control.dart#L13)

| 成員 | 可見性 | 簽章／型別 | 來源註解摘要 | 證據 |
|---|---|---|---|---|
| constructor <code>KlpPaneCollapseControl</code> | public | <code>const KlpPaneCollapseControl({ super.key, this.icon, this.label, required this.collapsed, required this.onToggle, })</code> |  | [lib/src/features/workspace/shell/composition/pane/klp_pane_collapse_control.dart:14](../../../../../../../../lib/src/features/workspace/shell/composition/pane/klp_pane_collapse_control.dart#L14) |
| field <code>icon</code> | public | <code>final KlpIconData? icon</code> |  | [lib/src/features/workspace/shell/composition/pane/klp_pane_collapse_control.dart:22](../../../../../../../../lib/src/features/workspace/shell/composition/pane/klp_pane_collapse_control.dart#L22) |
| field <code>label</code> | public | <code>final String? label</code> |  | [lib/src/features/workspace/shell/composition/pane/klp_pane_collapse_control.dart:23](../../../../../../../../lib/src/features/workspace/shell/composition/pane/klp_pane_collapse_control.dart#L23) |
| field <code>collapsed</code> | public | <code>final bool collapsed</code> |  | [lib/src/features/workspace/shell/composition/pane/klp_pane_collapse_control.dart:24](../../../../../../../../lib/src/features/workspace/shell/composition/pane/klp_pane_collapse_control.dart#L24) |
| field <code>onToggle</code> | public | <code>final VoidCallback? onToggle</code> |  | [lib/src/features/workspace/shell/composition/pane/klp_pane_collapse_control.dart:25](../../../../../../../../lib/src/features/workspace/shell/composition/pane/klp_pane_collapse_control.dart#L25) |
| method <code>build</code> | public | <code>Widget build(BuildContext context)</code> |  | [lib/src/features/workspace/shell/composition/pane/klp_pane_collapse_control.dart:27](../../../../../../../../lib/src/features/workspace/shell/composition/pane/klp_pane_collapse_control.dart#L27) |

## 閱讀說明與限制

箭頭只表示來源明寫的靜態關係；import 不等於呼叫。未分析動態呼叫、欄位的實際物件擁有權、狀態轉移或渲染流程；型別未進行語意解析，繼承目標保留原始型別拼寫。public／private 依 Dart 名稱前綴判斷；public 宣告不代表已由 `lib/kallopis.dart` 匯出。

本頁由 `tool/architecture_atlas` 產生；編輯來源或生成工具後重新產生，避免手改本頁。
