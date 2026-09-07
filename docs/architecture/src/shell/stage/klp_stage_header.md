# klp_stage_header.dart：直接依賴與宣告架構

[回到目錄](README.md) · [來源檔案](../../../../../lib/src/shell/stage/klp_stage_header.dart)

## 範圍

核心是 `lib/src/shell/stage/klp_stage_header.dart`。主要視角為該檔案明寫的 import／export／part；輔助視角為本檔宣告及 extends／implements／with／on 關係。只展開一層外部邊界。

## 直接依賴圖

```mermaid
flowchart TD
	n0["klp_stage_header.dart"]
	n1["package:flutter/widgets.dart"]
	n2["../../theme/klp_theme.dart"]
	n3["../../typography/klp_text.dart"]
	n0 -->|"import"| n1
	n0 -->|"import"| n2
	n0 -->|"import"| n3
```

## 依賴證據

| 關係 | 原始 directive | 來源 |
|---|---|---|
| import | <code>import &#x27;package:flutter/widgets.dart&#x27;;</code> | [lib/src/shell/stage/klp_stage_header.dart:1](../../../../../lib/src/shell/stage/klp_stage_header.dart#L1) |
| import | <code>import &#x27;../../theme/klp_theme.dart&#x27;;</code> | [lib/src/shell/stage/klp_stage_header.dart:3](../../../../../lib/src/shell/stage/klp_stage_header.dart#L3) |
| import | <code>import &#x27;../../typography/klp_text.dart&#x27;;</code> | [lib/src/shell/stage/klp_stage_header.dart:4](../../../../../lib/src/shell/stage/klp_stage_header.dart#L4) |

## 宣告關係圖

本組節點是本檔宣告；沒有箭頭的宣告未在此圖主張互相依賴。

```mermaid
classDiagram
	class n0["KlpStageHeader"]
```

```mermaid
classDiagram
	class n0["KlpStageHeader"]
	class n1["StatelessWidget"]
	n0 --|> n1 : extends
```


## 宣告與成員證據

成員包含 public 與 private；簽章取自來源，省略函式本體與欄位初始值。`(inferred)` 表示來源未明寫型別；建構子只顯示參數部分，不含初始化列表。

### KlpStageHeader

ClassDeclaration · public · [lib/src/shell/stage/klp_stage_header.dart:6](../../../../../lib/src/shell/stage/klp_stage_header.dart#L6)

<code>class KlpStageHeader extends StatelessWidget</code>

來源註解摘要：Stage 頂部的兩行識別標頭。 第一行顯示專案與區域，第二行顯示目前項目與類型；呼叫端只提供語意資料， 排版、間距與文字層級一律由 Kallopis theme 決定。

- `extends` → <code>StatelessWidget</code>：[lib/src/shell/stage/klp_stage_header.dart:10](../../../../../lib/src/shell/stage/klp_stage_header.dart#L10)

| 成員 | 可見性 | 簽章／型別 | 來源註解摘要 | 證據 |
|---|---|---|---|---|
| constructor <code>KlpStageHeader</code> | public | <code>const KlpStageHeader({ super.key, required this.projectName, required this.sectionLabel, required this.title, required this.typeLabel, this.actions = const [], this.wrapTitle = true, })</code> |  | [lib/src/shell/stage/klp_stage_header.dart:11](../../../../../lib/src/shell/stage/klp_stage_header.dart#L11) |
| field <code>projectName</code> | public | <code>final String projectName</code> |  | [lib/src/shell/stage/klp_stage_header.dart:21](../../../../../lib/src/shell/stage/klp_stage_header.dart#L21) |
| field <code>sectionLabel</code> | public | <code>final String sectionLabel</code> |  | [lib/src/shell/stage/klp_stage_header.dart:22](../../../../../lib/src/shell/stage/klp_stage_header.dart#L22) |
| field <code>title</code> | public | <code>final String title</code> |  | [lib/src/shell/stage/klp_stage_header.dart:23](../../../../../lib/src/shell/stage/klp_stage_header.dart#L23) |
| field <code>typeLabel</code> | public | <code>final String typeLabel</code> |  | [lib/src/shell/stage/klp_stage_header.dart:24](../../../../../lib/src/shell/stage/klp_stage_header.dart#L24) |
| field <code>actions</code> | public | <code>final List&lt;Widget&gt; actions</code> |  | [lib/src/shell/stage/klp_stage_header.dart:25](../../../../../lib/src/shell/stage/klp_stage_header.dart#L25) |
| field <code>wrapTitle</code> | public | <code>final bool wrapTitle</code> |  | [lib/src/shell/stage/klp_stage_header.dart:26](../../../../../lib/src/shell/stage/klp_stage_header.dart#L26) |
| method <code>build</code> | public | <code>Widget build(BuildContext context)</code> |  | [lib/src/shell/stage/klp_stage_header.dart:28](../../../../../lib/src/shell/stage/klp_stage_header.dart#L28) |

## 閱讀說明與限制

箭頭只表示來源明寫的靜態關係；import 不等於呼叫。未分析動態呼叫、欄位的實際物件擁有權、狀態轉移或渲染流程；型別未進行語意解析，繼承目標保留原始型別拼寫。public／private 依 Dart 名稱前綴判斷；public 宣告不代表已由 `lib/kallopis.dart` 匯出。

本頁由 `tool/architecture_atlas` 產生；編輯來源或生成工具後重新產生，避免手改本頁。
