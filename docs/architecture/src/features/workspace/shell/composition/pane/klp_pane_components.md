# klp_pane_components.dart：直接依賴與宣告架構

[回到目錄](README.md) · [來源檔案](../../../../../../../../lib/src/features/workspace/shell/composition/pane/klp_pane_components.dart)

## 範圍

核心是 `lib/src/features/workspace/shell/composition/pane/klp_pane_components.dart`。主要視角為該檔案明寫的 import／export／part；輔助視角為本檔宣告及 extends／implements／with／on 關係。只展開一層外部邊界。

## 直接依賴圖

```mermaid
flowchart LR
	n0["klp_pane_components.dart"]
	n1["klp_content_state.dart"]
	n2["klp_pane_collapse_control.dart"]
	n3["klp_responsive_pane_breakpoint.dart"]
	n4["klp_responsive_pane_coordinator.dart"]
	n0 -->|"export"| n1
	n0 -->|"export"| n2
	n0 -->|"export"| n3
	n0 -->|"export"| n4
```

## 依賴證據

| 關係 | 原始 directive | 來源 |
|---|---|---|
| export | <code>export &#x27;klp_content_state.dart&#x27;;</code> | [lib/src/features/workspace/shell/composition/pane/klp_pane_components.dart:1](../../../../../../../../lib/src/features/workspace/shell/composition/pane/klp_pane_components.dart#L1) |
| export | <code>export &#x27;klp_pane_collapse_control.dart&#x27;;</code> | [lib/src/features/workspace/shell/composition/pane/klp_pane_components.dart:2](../../../../../../../../lib/src/features/workspace/shell/composition/pane/klp_pane_components.dart#L2) |
| export | <code>export &#x27;klp_responsive_pane_breakpoint.dart&#x27;;</code> | [lib/src/features/workspace/shell/composition/pane/klp_pane_components.dart:3](../../../../../../../../lib/src/features/workspace/shell/composition/pane/klp_pane_components.dart#L3) |
| export | <code>export &#x27;klp_responsive_pane_coordinator.dart&#x27;;</code> | [lib/src/features/workspace/shell/composition/pane/klp_pane_components.dart:4](../../../../../../../../lib/src/features/workspace/shell/composition/pane/klp_pane_components.dart#L4) |

## 宣告關係圖

本檔沒有 class／enum／mixin／extension 宣告；頂層函式、變數與 typedef 見下表。

## 宣告與成員證據

成員包含 public 與 private；簽章取自來源，省略函式本體與欄位初始值。`(inferred)` 表示來源未明寫型別；建構子只顯示參數部分，不含初始化列表。

## 閱讀說明與限制

箭頭只表示來源明寫的靜態關係；import 不等於呼叫。未分析動態呼叫、欄位的實際物件擁有權、狀態轉移或渲染流程；型別未進行語意解析，繼承目標保留原始型別拼寫。public／private 依 Dart 名稱前綴判斷；public 宣告不代表已由 `lib/kallopis.dart` 匯出。

本頁由 `tool/architecture_atlas` 產生；編輯來源或生成工具後重新產生，避免手改本頁。
