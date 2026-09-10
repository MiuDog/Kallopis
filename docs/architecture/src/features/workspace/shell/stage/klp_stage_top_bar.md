# klp_stage_top_bar.dart：直接依賴與宣告架構

[回到目錄](README.md) · [來源檔案](../../../../../../../lib/src/features/workspace/shell/stage/klp_stage_top_bar.dart)

## 範圍

核心是 `lib/src/features/workspace/shell/stage/klp_stage_top_bar.dart`。主要視角為該檔案明寫的 import／export／part；輔助視角為本檔宣告及 extends／implements／with／on 關係。只展開一層外部邊界。

## 直接依賴圖

```mermaid
flowchart LR
	n0["klp_stage_top_bar.dart"]
	n1["dart:math"]
	n2["package:flutter/widgets.dart"]
	n3["../../../../foundation/layout/klp_directional_position.dart"]
	n4["../../../../foundation/layout/klp_directional_positioned.dart"]
	n5["../../../../foundation/layout/klp_gap.dart"]
	n6["../../../../foundation/layout/klp_row.dart"]
	n7["../../../../foundation/layout/klp_space_size.dart"]
	n8["../../../../foundation/layout/klp_stack.dart"]
	n9["../../../../styling/legacy_theme/klp_theme.dart"]
	n10["klp_stage_tab.dart"]
	n0 -->|"import"| n1
	n0 -->|"import"| n2
	n0 -->|"import"| n3
	n0 -->|"import"| n4
	n0 -->|"import"| n5
	n0 -->|"import"| n6
	n0 -->|"import"| n7
	n0 -->|"import"| n8
	n0 -->|"import"| n9
	n0 -->|"export"| n10
```

## 依賴證據

| 關係 | 原始 directive | 來源 |
|---|---|---|
| import | <code>import &#x27;dart:math&#x27; as math;</code> | [lib/src/features/workspace/shell/stage/klp_stage_top_bar.dart:1](../../../../../../../lib/src/features/workspace/shell/stage/klp_stage_top_bar.dart#L1) |
| import | <code>import &#x27;package:flutter/widgets.dart&#x27;;</code> | [lib/src/features/workspace/shell/stage/klp_stage_top_bar.dart:3](../../../../../../../lib/src/features/workspace/shell/stage/klp_stage_top_bar.dart#L3) |
| import | <code>import &#x27;../../../../foundation/layout/klp_directional_position.dart&#x27;;</code> | [lib/src/features/workspace/shell/stage/klp_stage_top_bar.dart:5](../../../../../../../lib/src/features/workspace/shell/stage/klp_stage_top_bar.dart#L5) |
| import | <code>import &#x27;../../../../foundation/layout/klp_directional_positioned.dart&#x27;;</code> | [lib/src/features/workspace/shell/stage/klp_stage_top_bar.dart:6](../../../../../../../lib/src/features/workspace/shell/stage/klp_stage_top_bar.dart#L6) |
| import | <code>import &#x27;../../../../foundation/layout/klp_gap.dart&#x27;;</code> | [lib/src/features/workspace/shell/stage/klp_stage_top_bar.dart:7](../../../../../../../lib/src/features/workspace/shell/stage/klp_stage_top_bar.dart#L7) |
| import | <code>import &#x27;../../../../foundation/layout/klp_row.dart&#x27;;</code> | [lib/src/features/workspace/shell/stage/klp_stage_top_bar.dart:8](../../../../../../../lib/src/features/workspace/shell/stage/klp_stage_top_bar.dart#L8) |
| import | <code>import &#x27;../../../../foundation/layout/klp_space_size.dart&#x27;;</code> | [lib/src/features/workspace/shell/stage/klp_stage_top_bar.dart:9](../../../../../../../lib/src/features/workspace/shell/stage/klp_stage_top_bar.dart#L9) |
| import | <code>import &#x27;../../../../foundation/layout/klp_stack.dart&#x27;;</code> | [lib/src/features/workspace/shell/stage/klp_stage_top_bar.dart:10](../../../../../../../lib/src/features/workspace/shell/stage/klp_stage_top_bar.dart#L10) |
| import | <code>import &#x27;../../../../styling/legacy_theme/klp_theme.dart&#x27;;</code> | [lib/src/features/workspace/shell/stage/klp_stage_top_bar.dart:11](../../../../../../../lib/src/features/workspace/shell/stage/klp_stage_top_bar.dart#L11) |
| export | <code>export &#x27;klp_stage_tab.dart&#x27;;</code> | [lib/src/features/workspace/shell/stage/klp_stage_top_bar.dart:13](../../../../../../../lib/src/features/workspace/shell/stage/klp_stage_top_bar.dart#L13) |

## 宣告關係圖

本組節點是本檔宣告；沒有箭頭的宣告未在此圖主張互相依賴。

```mermaid
classDiagram
	class n0["KlpStageTopBar"]
```

```mermaid
classDiagram
	class n0["KlpStageTopBar"]
	class n1["StatelessWidget"]
	n0 --|> n1 : extends
```


## 宣告與成員證據

成員包含 public 與 private；簽章取自來源，省略函式本體與欄位初始值。`(inferred)` 表示來源未明寫型別；建構子只顯示參數部分，不含初始化列表。

### KlpStageTopBar

ClassDeclaration · public · [lib/src/features/workspace/shell/stage/klp_stage_top_bar.dart:15](../../../../../../../lib/src/features/workspace/shell/stage/klp_stage_top_bar.dart#L15)

<code>class KlpStageTopBar extends StatelessWidget</code>

來源註解摘要：位於 Workbench window header 中央 Stage 區域的分頁與動作列。

- `extends` → <code>StatelessWidget</code>：[lib/src/features/workspace/shell/stage/klp_stage_top_bar.dart:16](../../../../../../../lib/src/features/workspace/shell/stage/klp_stage_top_bar.dart#L16)

| 成員 | 可見性 | 簽章／型別 | 來源註解摘要 | 證據 |
|---|---|---|---|---|
| constructor <code>KlpStageTopBar</code> | public | <code>const KlpStageTopBar({super.key, required this.tab, this.actions = const []})</code> |  | [lib/src/features/workspace/shell/stage/klp_stage_top_bar.dart:17](../../../../../../../lib/src/features/workspace/shell/stage/klp_stage_top_bar.dart#L17) |
| field <code>tab</code> | public | <code>final Widget tab</code> |  | [lib/src/features/workspace/shell/stage/klp_stage_top_bar.dart:19](../../../../../../../lib/src/features/workspace/shell/stage/klp_stage_top_bar.dart#L19) |
| field <code>actions</code> | public | <code>final List&lt;Widget&gt; actions</code> |  | [lib/src/features/workspace/shell/stage/klp_stage_top_bar.dart:20](../../../../../../../lib/src/features/workspace/shell/stage/klp_stage_top_bar.dart#L20) |
| method <code>build</code> | public | <code>Widget build(BuildContext context)</code> |  | [lib/src/features/workspace/shell/stage/klp_stage_top_bar.dart:22](../../../../../../../lib/src/features/workspace/shell/stage/klp_stage_top_bar.dart#L22) |

## 閱讀說明與限制

箭頭只表示來源明寫的靜態關係；import 不等於呼叫。未分析動態呼叫、欄位的實際物件擁有權、狀態轉移或渲染流程；型別未進行語意解析，繼承目標保留原始型別拼寫。public／private 依 Dart 名稱前綴判斷；public 宣告不代表已由 `lib/kallopis.dart` 匯出。

本頁由 `tool/architecture_atlas` 產生；編輯來源或生成工具後重新產生，避免手改本頁。
