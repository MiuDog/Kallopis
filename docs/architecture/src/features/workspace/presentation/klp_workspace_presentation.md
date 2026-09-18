# klp_workspace_presentation.dart：直接依賴與宣告架構

[回到目錄](README.md) · [來源檔案](../../../../../../lib/src/features/workspace/presentation/klp_workspace_presentation.dart)

## 範圍

核心是 `lib/src/features/workspace/presentation/klp_workspace_presentation.dart`。主要視角為該檔案明寫的 import／export／part；輔助視角為本檔宣告及 extends／implements／with／on 關係。只展開一層外部邊界。

## 直接依賴圖

```mermaid
flowchart LR
	n0["klp_workspace_presentation.dart"]
	n1["dart:async"]
	n2["package:kallopis/src/features/workspace/components/klp_workspace_command.dart"]
	n3["package:kallopis/src/features/workspace/explorer/klp_explorer_model.dart"]
	n4["package:kallopis/src/features/workspace/explorer/klp_explorer_snapshot.dart"]
	n5["package:kallopis/src/kernel/identity/klp_id.dart"]
	n6["package:kallopis/src/kernel/identity/klp_placement_id.dart"]
	n7["package:kallopis/src/styling/primitives/klp_style_value.dart"]
	n8["package:kallopis/src/foundation/binding/contracts/klp_bound_template.dart"]
	n9["package:kallopis/src/foundation/binding/contracts/klp_bound_text_style.dart"]
	n10["klp_bound_app_layout.dart"]
	n11["klp_bound_frame_groups.dart"]
	n0 -->|"import"| n1
	n0 -->|"import"| n2
	n0 -->|"import"| n3
	n0 -->|"import"| n4
	n0 -->|"import"| n5
	n0 -->|"import"| n6
	n0 -->|"import"| n7
	n0 -->|"import"| n8
	n0 -->|"import"| n9
	n0 -->|"part"| n10
	n0 -->|"part"| n11
```

```mermaid
flowchart LR
	n0["klp_workspace_presentation.dart"]
	n1["klp_bound_frame_group.dart"]
	n2["klp_bound_explorer.dart"]
	n3["klp_bound_document_tab_data.dart"]
	n4["klp_bound_document_tabs.dart"]
	n5["klp_bound_window_controls.dart"]
	n6["klp_bound_workspace_data.dart"]
	n7["klp_bound_workspace_item.dart"]
	n8["klp_bound_workspace_choice.dart"]
	n9["klp_bound_workspace_content.dart"]
	n10["klp_bound_workspace_content_block.dart"]
	n11["klp_bound_workspace_block.dart"]
	n0 -->|"part"| n1
	n0 -->|"part"| n2
	n0 -->|"part"| n3
	n0 -->|"part"| n4
	n0 -->|"part"| n5
	n0 -->|"part"| n6
	n0 -->|"part"| n7
	n0 -->|"part"| n8
	n0 -->|"part"| n9
	n0 -->|"part"| n10
	n0 -->|"part"| n11
```

```mermaid
flowchart TD
	n0["klp_workspace_presentation.dart"]
	n1["klp_bound_workspace_command.dart"]
	n0 -->|"part"| n1
```

## 依賴證據

| 關係 | 原始 directive | 來源 |
|---|---|---|
| import | <code>import &#x27;dart:async&#x27;;</code> | [lib/src/features/workspace/presentation/klp_workspace_presentation.dart:1](../../../../../../lib/src/features/workspace/presentation/klp_workspace_presentation.dart#L1) |
| import | <code>import &#x27;package:kallopis/src/features/workspace/components/klp_workspace_command.dart&#x27;;</code> | [lib/src/features/workspace/presentation/klp_workspace_presentation.dart:2](../../../../../../lib/src/features/workspace/presentation/klp_workspace_presentation.dart#L2) |
| import | <code>import &#x27;package:kallopis/src/features/workspace/explorer/klp_explorer_model.dart&#x27;;</code> | [lib/src/features/workspace/presentation/klp_workspace_presentation.dart:3](../../../../../../lib/src/features/workspace/presentation/klp_workspace_presentation.dart#L3) |
| import | <code>import &#x27;package:kallopis/src/features/workspace/explorer/klp_explorer_snapshot.dart&#x27;;</code> | [lib/src/features/workspace/presentation/klp_workspace_presentation.dart:4](../../../../../../lib/src/features/workspace/presentation/klp_workspace_presentation.dart#L4) |
| import | <code>import &#x27;package:kallopis/src/kernel/identity/klp_id.dart&#x27;;</code> | [lib/src/features/workspace/presentation/klp_workspace_presentation.dart:5](../../../../../../lib/src/features/workspace/presentation/klp_workspace_presentation.dart#L5) |
| import | <code>import &#x27;package:kallopis/src/kernel/identity/klp_placement_id.dart&#x27;;</code> | [lib/src/features/workspace/presentation/klp_workspace_presentation.dart:6](../../../../../../lib/src/features/workspace/presentation/klp_workspace_presentation.dart#L6) |
| import | <code>import &#x27;package:kallopis/src/styling/primitives/klp_style_value.dart&#x27;;</code> | [lib/src/features/workspace/presentation/klp_workspace_presentation.dart:7](../../../../../../lib/src/features/workspace/presentation/klp_workspace_presentation.dart#L7) |
| import | <code>import &#x27;package:kallopis/src/foundation/binding/contracts/klp_bound_template.dart&#x27;;</code> | [lib/src/features/workspace/presentation/klp_workspace_presentation.dart:8](../../../../../../lib/src/features/workspace/presentation/klp_workspace_presentation.dart#L8) |
| import | <code>import &#x27;package:kallopis/src/foundation/binding/contracts/klp_bound_text_style.dart&#x27;;</code> | [lib/src/features/workspace/presentation/klp_workspace_presentation.dart:9](../../../../../../lib/src/features/workspace/presentation/klp_workspace_presentation.dart#L9) |
| part | <code>part &#x27;klp_bound_app_layout.dart&#x27;;</code> | [lib/src/features/workspace/presentation/klp_workspace_presentation.dart:12](../../../../../../lib/src/features/workspace/presentation/klp_workspace_presentation.dart#L12) |
| part | <code>part &#x27;klp_bound_frame_groups.dart&#x27;;</code> | [lib/src/features/workspace/presentation/klp_workspace_presentation.dart:13](../../../../../../lib/src/features/workspace/presentation/klp_workspace_presentation.dart#L13) |
| part | <code>part &#x27;klp_bound_frame_group.dart&#x27;;</code> | [lib/src/features/workspace/presentation/klp_workspace_presentation.dart:14](../../../../../../lib/src/features/workspace/presentation/klp_workspace_presentation.dart#L14) |
| part | <code>part &#x27;klp_bound_explorer.dart&#x27;;</code> | [lib/src/features/workspace/presentation/klp_workspace_presentation.dart:15](../../../../../../lib/src/features/workspace/presentation/klp_workspace_presentation.dart#L15) |
| part | <code>part &#x27;klp_bound_document_tab_data.dart&#x27;;</code> | [lib/src/features/workspace/presentation/klp_workspace_presentation.dart:16](../../../../../../lib/src/features/workspace/presentation/klp_workspace_presentation.dart#L16) |
| part | <code>part &#x27;klp_bound_document_tabs.dart&#x27;;</code> | [lib/src/features/workspace/presentation/klp_workspace_presentation.dart:17](../../../../../../lib/src/features/workspace/presentation/klp_workspace_presentation.dart#L17) |
| part | <code>part &#x27;klp_bound_window_controls.dart&#x27;;</code> | [lib/src/features/workspace/presentation/klp_workspace_presentation.dart:18](../../../../../../lib/src/features/workspace/presentation/klp_workspace_presentation.dart#L18) |
| part | <code>part &#x27;klp_bound_workspace_data.dart&#x27;;</code> | [lib/src/features/workspace/presentation/klp_workspace_presentation.dart:19](../../../../../../lib/src/features/workspace/presentation/klp_workspace_presentation.dart#L19) |
| part | <code>part &#x27;klp_bound_workspace_item.dart&#x27;;</code> | [lib/src/features/workspace/presentation/klp_workspace_presentation.dart:20](../../../../../../lib/src/features/workspace/presentation/klp_workspace_presentation.dart#L20) |
| part | <code>part &#x27;klp_bound_workspace_choice.dart&#x27;;</code> | [lib/src/features/workspace/presentation/klp_workspace_presentation.dart:21](../../../../../../lib/src/features/workspace/presentation/klp_workspace_presentation.dart#L21) |
| part | <code>part &#x27;klp_bound_workspace_content.dart&#x27;;</code> | [lib/src/features/workspace/presentation/klp_workspace_presentation.dart:22](../../../../../../lib/src/features/workspace/presentation/klp_workspace_presentation.dart#L22) |
| part | <code>part &#x27;klp_bound_workspace_content_block.dart&#x27;;</code> | [lib/src/features/workspace/presentation/klp_workspace_presentation.dart:23](../../../../../../lib/src/features/workspace/presentation/klp_workspace_presentation.dart#L23) |
| part | <code>part &#x27;klp_bound_workspace_block.dart&#x27;;</code> | [lib/src/features/workspace/presentation/klp_workspace_presentation.dart:24](../../../../../../lib/src/features/workspace/presentation/klp_workspace_presentation.dart#L24) |
| part | <code>part &#x27;klp_bound_workspace_command.dart&#x27;;</code> | [lib/src/features/workspace/presentation/klp_workspace_presentation.dart:25](../../../../../../lib/src/features/workspace/presentation/klp_workspace_presentation.dart#L25) |

## 宣告關係圖

本檔沒有 class／enum／mixin／extension 宣告；頂層函式、變數與 typedef 見下表。

## 宣告與成員證據

成員包含 public 與 private；簽章取自來源，省略函式本體與欄位初始值。`(inferred)` 表示來源未明寫型別；建構子只顯示參數部分，不含初始化列表。

## 閱讀說明與限制

箭頭只表示來源明寫的靜態關係；import 不等於呼叫。未分析動態呼叫、欄位的實際物件擁有權、狀態轉移或渲染流程；型別未進行語意解析，繼承目標保留原始型別拼寫。public／private 依 Dart 名稱前綴判斷；public 宣告不代表已由 `lib/kallopis.dart` 匯出。

本頁由 `tool/architecture_atlas` 產生；編輯來源或生成工具後重新產生，避免手改本頁。
