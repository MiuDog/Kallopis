# klp_shell_extras.dart：直接依賴與宣告架構

[回到目錄](README.md) · [來源檔案](../../../../../lib/src/shell/composition/klp_shell_extras.dart)

## 範圍

核心是 `lib/src/shell/composition/klp_shell_extras.dart`。主要視角為該檔案明寫的 import／export／part；輔助視角為本檔宣告及 extends／implements／with／on 關係。只展開一層外部邊界。

## 直接依賴圖

```mermaid
flowchart TD
	n0["klp_shell_extras.dart"]
	n1["app_screen/klp_app_screen.dart"]
	n2["pane/klp_pane_components.dart"]
	n3["window_header/klp_app_window_header.dart"]
	n0 -->|"export"| n1
	n0 -->|"export"| n2
	n0 -->|"export"| n3
```

## 依賴證據

| 關係 | 原始 directive | 來源 |
|---|---|---|
| export | <code>export &#x27;app_screen/klp_app_screen.dart&#x27;;</code> | [lib/src/shell/composition/klp_shell_extras.dart:1](../../../../../lib/src/shell/composition/klp_shell_extras.dart#L1) |
| export | <code>export &#x27;pane/klp_pane_components.dart&#x27;;</code> | [lib/src/shell/composition/klp_shell_extras.dart:2](../../../../../lib/src/shell/composition/klp_shell_extras.dart#L2) |
| export | <code>export &#x27;window_header/klp_app_window_header.dart&#x27;;</code> | [lib/src/shell/composition/klp_shell_extras.dart:3](../../../../../lib/src/shell/composition/klp_shell_extras.dart#L3) |

## 宣告關係圖

本檔沒有 class／enum／mixin／extension 宣告；頂層函式、變數與 typedef 見下表。

## 宣告與成員證據

成員包含 public 與 private；簽章取自來源，省略函式本體與欄位初始值。`(inferred)` 表示來源未明寫型別；建構子只顯示參數部分，不含初始化列表。

## 閱讀說明與限制

箭頭只表示來源明寫的靜態關係；import 不等於呼叫。未分析動態呼叫、欄位的實際物件擁有權、狀態轉移或渲染流程；型別未進行語意解析，繼承目標保留原始型別拼寫。public／private 依 Dart 名稱前綴判斷；public 宣告不代表已由 `lib/kallopis.dart` 匯出。

本頁由 `tool/architecture_atlas` 產生；編輯來源或生成工具後重新產生，避免手改本頁。
