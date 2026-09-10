# klp_status_bar_data.dart：直接依賴與宣告架構

[回到目錄](README.md) · [來源檔案](../../../../../../../lib/src/features/workspace/shell/status/klp_status_bar_data.dart)

## 範圍

核心是 `lib/src/features/workspace/shell/status/klp_status_bar_data.dart`。主要視角為該檔案明寫的 import／export／part；輔助視角為本檔宣告及 extends／implements／with／on 關係。只展開一層外部邊界。

## 直接依賴圖

```mermaid
flowchart TD
	n0["klp_status_bar_data.dart"]
	n1["package:flutter/widgets.dart"]
	n2["klp_status_item_data.dart"]
	n0 -->|"import"| n1
	n0 -->|"import"| n2
```

## 依賴證據

| 關係 | 原始 directive | 來源 |
|---|---|---|
| import | <code>import &#x27;package:flutter/widgets.dart&#x27;;</code> | [lib/src/features/workspace/shell/status/klp_status_bar_data.dart:4](../../../../../../../lib/src/features/workspace/shell/status/klp_status_bar_data.dart#L4) |
| import | <code>import &#x27;klp_status_item_data.dart&#x27;;</code> | [lib/src/features/workspace/shell/status/klp_status_bar_data.dart:5](../../../../../../../lib/src/features/workspace/shell/status/klp_status_bar_data.dart#L5) |

## 宣告關係圖

本組節點是本檔宣告；沒有箭頭的宣告未在此圖主張互相依賴。

```mermaid
classDiagram
	class n0["KlpStatusBarData"]
```


## 宣告與成員證據

成員包含 public 與 private；簽章取自來源，省略函式本體與欄位初始值。`(inferred)` 表示來源未明寫型別；建構子只顯示參數部分，不含初始化列表。

### KlpStatusBarData

ClassDeclaration · public · [lib/src/features/workspace/shell/status/klp_status_bar_data.dart:7](../../../../../../../lib/src/features/workspace/shell/status/klp_status_bar_data.dart#L7)

<code>class KlpStatusBarData</code>

來源註解摘要：Stage 底部狀態列的資料模型。 左右群組都可提供多個狀態項目；窄版會保留左側群組並隱藏右側群組。


| 成員 | 可見性 | 簽章／型別 | 來源註解摘要 | 證據 |
|---|---|---|---|---|
| constructor <code>KlpStatusBarData</code> | public | <code>const KlpStatusBarData({required this.leading, this.trailing = const []})</code> |  | [lib/src/features/workspace/shell/status/klp_status_bar_data.dart:12](../../../../../../../lib/src/features/workspace/shell/status/klp_status_bar_data.dart#L12) |
| field <code>leading</code> | public | <code>final List&lt;KlpStatusItemData&gt; leading</code> |  | [lib/src/features/workspace/shell/status/klp_status_bar_data.dart:14](../../../../../../../lib/src/features/workspace/shell/status/klp_status_bar_data.dart#L14) |
| field <code>trailing</code> | public | <code>final List&lt;KlpStatusItemData&gt; trailing</code> |  | [lib/src/features/workspace/shell/status/klp_status_bar_data.dart:15](../../../../../../../lib/src/features/workspace/shell/status/klp_status_bar_data.dart#L15) |

## 閱讀說明與限制

箭頭只表示來源明寫的靜態關係；import 不等於呼叫。未分析動態呼叫、欄位的實際物件擁有權、狀態轉移或渲染流程；型別未進行語意解析，繼承目標保留原始型別拼寫。public／private 依 Dart 名稱前綴判斷；public 宣告不代表已由 `lib/kallopis.dart` 匯出。

本頁由 `tool/architecture_atlas` 產生；編輯來源或生成工具後重新產生，避免手改本頁。
