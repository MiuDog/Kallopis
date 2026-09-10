# klp_stepper.dart：直接依賴與宣告架構

[回到目錄](README.md) · [來源檔案](../../../../../../lib/src/features/collections/stepper/klp_stepper.dart)

## 範圍

核心是 `lib/src/features/collections/stepper/klp_stepper.dart`。主要視角為該檔案明寫的 import／export／part；輔助視角為本檔宣告及 extends／implements／with／on 關係。只展開一層外部邊界。

## 直接依賴圖

```mermaid
flowchart LR
	n0["klp_stepper.dart"]
	n1["package:flutter/widgets.dart"]
	n2["../../../foundation/klp_icon.dart"]
	n3["../../../foundation/klp_icons.dart"]
	n4["../../../foundation/layout/klp_layout.dart"]
	n5["../../../styling/legacy_theme/klp_theme.dart"]
	n6["../../../foundation/content/klp_text.dart"]
	n7["internal/klp_step_label.dart"]
	n8["internal/klp_step_status_resolver.dart"]
	n9["internal/klp_stepper_horizontal_layout.dart"]
	n10["internal/klp_stepper_vertical_layout.dart"]
	n11["models/klp_step_data.dart"]
	n0 -->|"import"| n1
	n0 -->|"import"| n2
	n0 -->|"import"| n3
	n0 -->|"import"| n4
	n0 -->|"import"| n5
	n0 -->|"import"| n6
	n0 -->|"part"| n7
	n0 -->|"part"| n8
	n0 -->|"part"| n9
	n0 -->|"part"| n10
	n0 -->|"part"| n11
```

```mermaid
flowchart LR
	n0["klp_stepper.dart"]
	n1["models/klp_step_status.dart"]
	n2["models/klp_stepper_direction.dart"]
	n3["primitives/klp_step_connector.dart"]
	n4["primitives/klp_step_marker.dart"]
	n5["primitives/klp_stepper_intrinsic_height.dart"]
	n6["klp_stepper_widget.dart"]
	n0 -->|"part"| n1
	n0 -->|"part"| n2
	n0 -->|"part"| n3
	n0 -->|"part"| n4
	n0 -->|"part"| n5
	n0 -->|"part"| n6
```

## 依賴證據

| 關係 | 原始 directive | 來源 |
|---|---|---|
| import | <code>import &#x27;package:flutter/widgets.dart&#x27;;</code> | [lib/src/features/collections/stepper/klp_stepper.dart:1](../../../../../../lib/src/features/collections/stepper/klp_stepper.dart#L1) |
| import | <code>import &#x27;../../../foundation/klp_icon.dart&#x27;;</code> | [lib/src/features/collections/stepper/klp_stepper.dart:3](../../../../../../lib/src/features/collections/stepper/klp_stepper.dart#L3) |
| import | <code>import &#x27;../../../foundation/klp_icons.dart&#x27;;</code> | [lib/src/features/collections/stepper/klp_stepper.dart:4](../../../../../../lib/src/features/collections/stepper/klp_stepper.dart#L4) |
| import | <code>import &#x27;../../../foundation/layout/klp_layout.dart&#x27;;</code> | [lib/src/features/collections/stepper/klp_stepper.dart:5](../../../../../../lib/src/features/collections/stepper/klp_stepper.dart#L5) |
| import | <code>import &#x27;../../../styling/legacy_theme/klp_theme.dart&#x27;;</code> | [lib/src/features/collections/stepper/klp_stepper.dart:6](../../../../../../lib/src/features/collections/stepper/klp_stepper.dart#L6) |
| import | <code>import &#x27;../../../foundation/content/klp_text.dart&#x27;;</code> | [lib/src/features/collections/stepper/klp_stepper.dart:7](../../../../../../lib/src/features/collections/stepper/klp_stepper.dart#L7) |
| part | <code>part &#x27;internal/klp_step_label.dart&#x27;;</code> | [lib/src/features/collections/stepper/klp_stepper.dart:9](../../../../../../lib/src/features/collections/stepper/klp_stepper.dart#L9) |
| part | <code>part &#x27;internal/klp_step_status_resolver.dart&#x27;;</code> | [lib/src/features/collections/stepper/klp_stepper.dart:10](../../../../../../lib/src/features/collections/stepper/klp_stepper.dart#L10) |
| part | <code>part &#x27;internal/klp_stepper_horizontal_layout.dart&#x27;;</code> | [lib/src/features/collections/stepper/klp_stepper.dart:11](../../../../../../lib/src/features/collections/stepper/klp_stepper.dart#L11) |
| part | <code>part &#x27;internal/klp_stepper_vertical_layout.dart&#x27;;</code> | [lib/src/features/collections/stepper/klp_stepper.dart:12](../../../../../../lib/src/features/collections/stepper/klp_stepper.dart#L12) |
| part | <code>part &#x27;models/klp_step_data.dart&#x27;;</code> | [lib/src/features/collections/stepper/klp_stepper.dart:13](../../../../../../lib/src/features/collections/stepper/klp_stepper.dart#L13) |
| part | <code>part &#x27;models/klp_step_status.dart&#x27;;</code> | [lib/src/features/collections/stepper/klp_stepper.dart:14](../../../../../../lib/src/features/collections/stepper/klp_stepper.dart#L14) |
| part | <code>part &#x27;models/klp_stepper_direction.dart&#x27;;</code> | [lib/src/features/collections/stepper/klp_stepper.dart:15](../../../../../../lib/src/features/collections/stepper/klp_stepper.dart#L15) |
| part | <code>part &#x27;primitives/klp_step_connector.dart&#x27;;</code> | [lib/src/features/collections/stepper/klp_stepper.dart:16](../../../../../../lib/src/features/collections/stepper/klp_stepper.dart#L16) |
| part | <code>part &#x27;primitives/klp_step_marker.dart&#x27;;</code> | [lib/src/features/collections/stepper/klp_stepper.dart:17](../../../../../../lib/src/features/collections/stepper/klp_stepper.dart#L17) |
| part | <code>part &#x27;primitives/klp_stepper_intrinsic_height.dart&#x27;;</code> | [lib/src/features/collections/stepper/klp_stepper.dart:18](../../../../../../lib/src/features/collections/stepper/klp_stepper.dart#L18) |
| part | <code>part &#x27;klp_stepper_widget.dart&#x27;;</code> | [lib/src/features/collections/stepper/klp_stepper.dart:19](../../../../../../lib/src/features/collections/stepper/klp_stepper.dart#L19) |

## 宣告關係圖

本檔沒有 class／enum／mixin／extension 宣告；頂層函式、變數與 typedef 見下表。

## 宣告與成員證據

成員包含 public 與 private；簽章取自來源，省略函式本體與欄位初始值。`(inferred)` 表示來源未明寫型別；建構子只顯示參數部分，不含初始化列表。

## 閱讀說明與限制

箭頭只表示來源明寫的靜態關係；import 不等於呼叫。未分析動態呼叫、欄位的實際物件擁有權、狀態轉移或渲染流程；型別未進行語意解析，繼承目標保留原始型別拼寫。public／private 依 Dart 名稱前綴判斷；public 宣告不代表已由 `lib/kallopis.dart` 匯出。

本頁由 `tool/architecture_atlas` 產生；編輯來源或生成工具後重新產生，避免手改本頁。
