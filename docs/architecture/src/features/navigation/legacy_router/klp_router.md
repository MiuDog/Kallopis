# klp_router.dart：直接依賴與宣告架構

[回到目錄](README.md) · [來源檔案](../../../../../../lib/src/features/navigation/legacy_router/klp_router.dart)

## 範圍

核心是 `lib/src/features/navigation/legacy_router/klp_router.dart`。主要視角為該檔案明寫的 import／export／part；輔助視角為本檔宣告及 extends／implements／with／on 關係。只展開一層外部邊界。

## 直接依賴圖

```mermaid
flowchart LR
	n0["klp_router.dart"]
	n1["package:flutter/widgets.dart"]
	n2["../../../foundation/layout/klp_panel_layout.dart"]
	n3["klp_panel_layout_builder.dart"]
	n4["klp_route.dart"]
	n5["klp_route_not_found.dart"]
	n6["klp_router_context.dart"]
	n7["klp_router_controller.dart"]
	n8["klp_router_outlet.dart"]
	n9["klp_router_scope.dart"]
	n0 -->|"import"| n1
	n0 -->|"import"| n2
	n0 -->|"part"| n3
	n0 -->|"part"| n4
	n0 -->|"part"| n5
	n0 -->|"part"| n6
	n0 -->|"part"| n7
	n0 -->|"part"| n8
	n0 -->|"part"| n9
```

## 依賴證據

| 關係 | 原始 directive | 來源 |
|---|---|---|
| import | <code>import &#x27;package:flutter/widgets.dart&#x27;;</code> | [lib/src/features/navigation/legacy_router/klp_router.dart:1](../../../../../../lib/src/features/navigation/legacy_router/klp_router.dart#L1) |
| import | <code>import &#x27;../../../foundation/layout/klp_panel_layout.dart&#x27;;</code> | [lib/src/features/navigation/legacy_router/klp_router.dart:3](../../../../../../lib/src/features/navigation/legacy_router/klp_router.dart#L3) |
| part | <code>part &#x27;klp_panel_layout_builder.dart&#x27;;</code> | [lib/src/features/navigation/legacy_router/klp_router.dart:5](../../../../../../lib/src/features/navigation/legacy_router/klp_router.dart#L5) |
| part | <code>part &#x27;klp_route.dart&#x27;;</code> | [lib/src/features/navigation/legacy_router/klp_router.dart:6](../../../../../../lib/src/features/navigation/legacy_router/klp_router.dart#L6) |
| part | <code>part &#x27;klp_route_not_found.dart&#x27;;</code> | [lib/src/features/navigation/legacy_router/klp_router.dart:7](../../../../../../lib/src/features/navigation/legacy_router/klp_router.dart#L7) |
| part | <code>part &#x27;klp_router_context.dart&#x27;;</code> | [lib/src/features/navigation/legacy_router/klp_router.dart:8](../../../../../../lib/src/features/navigation/legacy_router/klp_router.dart#L8) |
| part | <code>part &#x27;klp_router_controller.dart&#x27;;</code> | [lib/src/features/navigation/legacy_router/klp_router.dart:9](../../../../../../lib/src/features/navigation/legacy_router/klp_router.dart#L9) |
| part | <code>part &#x27;klp_router_outlet.dart&#x27;;</code> | [lib/src/features/navigation/legacy_router/klp_router.dart:10](../../../../../../lib/src/features/navigation/legacy_router/klp_router.dart#L10) |
| part | <code>part &#x27;klp_router_scope.dart&#x27;;</code> | [lib/src/features/navigation/legacy_router/klp_router.dart:11](../../../../../../lib/src/features/navigation/legacy_router/klp_router.dart#L11) |

## 宣告關係圖

本檔沒有 class／enum／mixin／extension 宣告；頂層函式、變數與 typedef 見下表。

## 宣告與成員證據

成員包含 public 與 private；簽章取自來源，省略函式本體與欄位初始值。`(inferred)` 表示來源未明寫型別；建構子只顯示參數部分，不含初始化列表。

## 閱讀說明與限制

箭頭只表示來源明寫的靜態關係；import 不等於呼叫。未分析動態呼叫、欄位的實際物件擁有權、狀態轉移或渲染流程；型別未進行語意解析，繼承目標保留原始型別拼寫。public／private 依 Dart 名稱前綴判斷；public 宣告不代表已由 `lib/kallopis.dart` 匯出。

本頁由 `tool/architecture_atlas` 產生；編輯來源或生成工具後重新產生，避免手改本頁。
