# klp_status_bar.dart：直接依賴與宣告架構

[回到目錄](README.md) · [來源檔案](../../../../../lib/src/shell/status/klp_status_bar.dart)

## 範圍

核心是 `lib/src/shell/status/klp_status_bar.dart`。主要視角為該檔案明寫的 import／export／part；輔助視角為本檔宣告及 extends／implements／with／on 關係。只展開一層外部邊界。

## 直接依賴圖

```mermaid
flowchart LR
	n0["klp_status_bar.dart"]
	n1["package:flutter/widgets.dart"]
	n2["../../feedback/klp_status_indicator.dart"]
	n3["../../theme/klp_theme.dart"]
	n4["../../typography/klp_text.dart"]
	n0 -->|"import"| n1
	n0 -->|"import"| n2
	n0 -->|"import"| n3
	n0 -->|"import"| n4
```

## 依賴證據

| 關係 | 原始 directive | 來源 |
|---|---|---|
| import | <code>import &#x27;package:flutter/widgets.dart&#x27;;</code> | [lib/src/shell/status/klp_status_bar.dart:1](../../../../../lib/src/shell/status/klp_status_bar.dart#L1) |
| import | <code>import &#x27;../../feedback/klp_status_indicator.dart&#x27;;</code> | [lib/src/shell/status/klp_status_bar.dart:3](../../../../../lib/src/shell/status/klp_status_bar.dart#L3) |
| import | <code>import &#x27;../../theme/klp_theme.dart&#x27;;</code> | [lib/src/shell/status/klp_status_bar.dart:4](../../../../../lib/src/shell/status/klp_status_bar.dart#L4) |
| import | <code>import &#x27;../../typography/klp_text.dart&#x27;;</code> | [lib/src/shell/status/klp_status_bar.dart:5](../../../../../lib/src/shell/status/klp_status_bar.dart#L5) |

## 宣告關係圖

本組節點是本檔宣告；沒有箭頭的宣告未在此圖主張互相依賴。

```mermaid
classDiagram
	class n0["KlpStatusBar"]
```

```mermaid
classDiagram
	class n0["KlpStatusBar"]
	class n1["StatelessWidget"]
	n0 --|> n1 : extends
```


## 宣告與成員證據

成員包含 public 與 private；簽章取自來源，省略函式本體與欄位初始值。`(inferred)` 表示來源未明寫型別；建構子只顯示參數部分，不含初始化列表。

### KlpStatusBar

ClassDeclaration · public · [lib/src/shell/status/klp_status_bar.dart:7](../../../../../lib/src/shell/status/klp_status_bar.dart#L7)

<code>class KlpStatusBar extends StatelessWidget</code>

- `extends` → <code>StatelessWidget</code>：[lib/src/shell/status/klp_status_bar.dart:7](../../../../../lib/src/shell/status/klp_status_bar.dart#L7)

| 成員 | 可見性 | 簽章／型別 | 來源註解摘要 | 證據 |
|---|---|---|---|---|
| constructor <code>KlpStatusBar</code> | public | <code>const KlpStatusBar({ super.key, required this.leading, required this.trailing, this.active = true, })</code> |  | [lib/src/shell/status/klp_status_bar.dart:8](../../../../../lib/src/shell/status/klp_status_bar.dart#L8) |
| field <code>leading</code> | public | <code>final String leading</code> |  | [lib/src/shell/status/klp_status_bar.dart:15](../../../../../lib/src/shell/status/klp_status_bar.dart#L15) |
| field <code>trailing</code> | public | <code>final String trailing</code> |  | [lib/src/shell/status/klp_status_bar.dart:16](../../../../../lib/src/shell/status/klp_status_bar.dart#L16) |
| field <code>active</code> | public | <code>final bool active</code> |  | [lib/src/shell/status/klp_status_bar.dart:17](../../../../../lib/src/shell/status/klp_status_bar.dart#L17) |
| method <code>build</code> | public | <code>Widget build(BuildContext context)</code> |  | [lib/src/shell/status/klp_status_bar.dart:19](../../../../../lib/src/shell/status/klp_status_bar.dart#L19) |

## 閱讀說明與限制

箭頭只表示來源明寫的靜態關係；import 不等於呼叫。未分析動態呼叫、欄位的實際物件擁有權、狀態轉移或渲染流程；型別未進行語意解析，繼承目標保留原始型別拼寫。public／private 依 Dart 名稱前綴判斷；public 宣告不代表已由 `lib/kallopis.dart` 匯出。

本頁由 `tool/architecture_atlas` 產生；編輯來源或生成工具後重新產生，避免手改本頁。
