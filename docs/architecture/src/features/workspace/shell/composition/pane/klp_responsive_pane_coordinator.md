# klp_responsive_pane_coordinator.dart：直接依賴與宣告架構

[回到目錄](README.md) · [來源檔案](../../../../../../../../lib/src/features/workspace/shell/composition/pane/klp_responsive_pane_coordinator.dart)

## 範圍

核心是 `lib/src/features/workspace/shell/composition/pane/klp_responsive_pane_coordinator.dart`。主要視角為該檔案明寫的 import／export／part；輔助視角為本檔宣告及 extends／implements／with／on 關係。只展開一層外部邊界。

## 直接依賴圖

```mermaid
flowchart TD
	n0["klp_responsive_pane_coordinator.dart"]
	n1["package:flutter/widgets.dart"]
	n2["../../../../../foundation/layout/klp_layout_builder.dart"]
	n3["klp_responsive_pane_breakpoint.dart"]
	n0 -->|"import"| n1
	n0 -->|"import"| n2
	n0 -->|"import"| n3
```

## 依賴證據

| 關係 | 原始 directive | 來源 |
|---|---|---|
| import | <code>import &#x27;package:flutter/widgets.dart&#x27;;</code> | [lib/src/features/workspace/shell/composition/pane/klp_responsive_pane_coordinator.dart:1](../../../../../../../../lib/src/features/workspace/shell/composition/pane/klp_responsive_pane_coordinator.dart#L1) |
| import | <code>import &#x27;../../../../../foundation/layout/klp_layout_builder.dart&#x27;;</code> | [lib/src/features/workspace/shell/composition/pane/klp_responsive_pane_coordinator.dart:3](../../../../../../../../lib/src/features/workspace/shell/composition/pane/klp_responsive_pane_coordinator.dart#L3) |
| import | <code>import &#x27;klp_responsive_pane_breakpoint.dart&#x27;;</code> | [lib/src/features/workspace/shell/composition/pane/klp_responsive_pane_coordinator.dart:4](../../../../../../../../lib/src/features/workspace/shell/composition/pane/klp_responsive_pane_coordinator.dart#L4) |

## 宣告關係圖

本組節點是本檔宣告；沒有箭頭的宣告未在此圖主張互相依賴。

```mermaid
classDiagram
	class n0["KlpResponsivePaneCoordinator"]
```

```mermaid
classDiagram
	class n0["KlpResponsivePaneCoordinator"]
	class n1["StatelessWidget"]
	n0 --|> n1 : extends
```


## 宣告與成員證據

成員包含 public 與 private；簽章取自來源，省略函式本體與欄位初始值。`(inferred)` 表示來源未明寫型別；建構子只顯示參數部分，不含初始化列表。

### KlpResponsivePaneCoordinator

ClassDeclaration · public · [lib/src/features/workspace/shell/composition/pane/klp_responsive_pane_coordinator.dart:6](../../../../../../../../lib/src/features/workspace/shell/composition/pane/klp_responsive_pane_coordinator.dart#L6)

<code>class KlpResponsivePaneCoordinator extends StatelessWidget</code>

來源註解摘要：依可用寬度與 typed breakpoint 切換 Pane 呈現。

- `extends` → <code>StatelessWidget</code>：[lib/src/features/workspace/shell/composition/pane/klp_responsive_pane_coordinator.dart:7](../../../../../../../../lib/src/features/workspace/shell/composition/pane/klp_responsive_pane_coordinator.dart#L7)

| 成員 | 可見性 | 簽章／型別 | 來源註解摘要 | 證據 |
|---|---|---|---|---|
| constructor <code>KlpResponsivePaneCoordinator</code> | public | <code>const KlpResponsivePaneCoordinator({ super.key, required this.wide, required this.compact, this.breakpoint = KlpResponsivePaneBreakpoint.standard, })</code> |  | [lib/src/features/workspace/shell/composition/pane/klp_responsive_pane_coordinator.dart:8](../../../../../../../../lib/src/features/workspace/shell/composition/pane/klp_responsive_pane_coordinator.dart#L8) |
| field <code>wide</code> | public | <code>final Widget wide</code> |  | [lib/src/features/workspace/shell/composition/pane/klp_responsive_pane_coordinator.dart:15](../../../../../../../../lib/src/features/workspace/shell/composition/pane/klp_responsive_pane_coordinator.dart#L15) |
| field <code>compact</code> | public | <code>final Widget compact</code> |  | [lib/src/features/workspace/shell/composition/pane/klp_responsive_pane_coordinator.dart:16](../../../../../../../../lib/src/features/workspace/shell/composition/pane/klp_responsive_pane_coordinator.dart#L16) |
| field <code>breakpoint</code> | public | <code>final KlpResponsivePaneBreakpoint breakpoint</code> |  | [lib/src/features/workspace/shell/composition/pane/klp_responsive_pane_coordinator.dart:17](../../../../../../../../lib/src/features/workspace/shell/composition/pane/klp_responsive_pane_coordinator.dart#L17) |
| method <code>build</code> | public | <code>Widget build(BuildContext context)</code> |  | [lib/src/features/workspace/shell/composition/pane/klp_responsive_pane_coordinator.dart:19](../../../../../../../../lib/src/features/workspace/shell/composition/pane/klp_responsive_pane_coordinator.dart#L19) |

## 閱讀說明與限制

箭頭只表示來源明寫的靜態關係；import 不等於呼叫。未分析動態呼叫、欄位的實際物件擁有權、狀態轉移或渲染流程；型別未進行語意解析，繼承目標保留原始型別拼寫。public／private 依 Dart 名稱前綴判斷；public 宣告不代表已由 `lib/kallopis.dart` 匯出。

本頁由 `tool/architecture_atlas` 產生；編輯來源或生成工具後重新產生，避免手改本頁。
