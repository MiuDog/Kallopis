# default_data_visualization.dart：直接依賴與宣告架構

[回到目錄](README.md) · [來源檔案](../../../../lib/src/styles/default_data_visualization.dart)

## 範圍

核心是 `lib/src/styles/default_data_visualization.dart`。主要視角為該檔案明寫的 import／export／part；輔助視角為本檔宣告及 extends／implements／with／on 關係。只展開一層外部邊界。

## 直接依賴圖

```mermaid
flowchart TD
	n0["default_data_visualization.dart"]
	n1["../theme/klp_data_visualization_theme.dart"]
	n0 -->|"part of"| n1
```

## 依賴證據

| 關係 | 原始 directive | 來源 |
|---|---|---|
| part of | <code>part of &#x27;../theme/klp_data_visualization_theme.dart&#x27;;</code> | [lib/src/styles/default_data_visualization.dart:1](../../../../lib/src/styles/default_data_visualization.dart#L1) |

## 宣告關係圖

本檔沒有 class／enum／mixin／extension 宣告；頂層函式、變數與 typedef 見下表。

## 宣告與成員證據

成員包含 public 與 private；簽章取自來源，省略函式本體與欄位初始值。`(inferred)` 表示來源未明寫型別；建構子只顯示參數部分，不含初始化列表。

### _defaultDataVisualizationLight

top-level variable · private · [lib/src/styles/default_data_visualization.dart:5](../../../../lib/src/styles/default_data_visualization.dart#L5)

<code>const KlpDataVisualizationTheme _defaultDataVisualizationLight</code>

來源註解摘要：此分類的預設風格 recipe；schema 的公開 static 成員保留相同值與 const 契約。


### _defaultDataVisualizationDark

top-level variable · private · [lib/src/styles/default_data_visualization.dart:37](../../../../lib/src/styles/default_data_visualization.dart#L37)

<code>const KlpDataVisualizationTheme _defaultDataVisualizationDark</code>


### _defaultDataVisualizationUltraDark

top-level variable · private · [lib/src/styles/default_data_visualization.dart:69](../../../../lib/src/styles/default_data_visualization.dart#L69)

<code>const KlpDataVisualizationTheme _defaultDataVisualizationUltraDark</code>


## 閱讀說明與限制

箭頭只表示來源明寫的靜態關係；import 不等於呼叫。未分析動態呼叫、欄位的實際物件擁有權、狀態轉移或渲染流程；型別未進行語意解析，繼承目標保留原始型別拼寫。public／private 依 Dart 名稱前綴判斷；public 宣告不代表已由 `lib/kallopis.dart` 匯出。

本頁由 `tool/architecture_atlas` 產生；編輯來源或生成工具後重新產生，避免手改本頁。
