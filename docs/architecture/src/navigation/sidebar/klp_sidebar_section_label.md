# klp_sidebar_section_label.dart：直接依賴與宣告架構

[回到目錄](README.md) · [來源檔案](../../../../../lib/src/navigation/sidebar/klp_sidebar_section_label.dart)

## 範圍

核心是 `lib/src/navigation/sidebar/klp_sidebar_section_label.dart`。主要視角為該檔案明寫的 import／export／part；輔助視角為本檔宣告及 extends／implements／with／on 關係。只展開一層外部邊界。

## 直接依賴圖

```mermaid
flowchart TD
	n0["klp_sidebar_section_label.dart"]
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
| import | <code>import &#x27;package:flutter/widgets.dart&#x27;;</code> | [lib/src/navigation/sidebar/klp_sidebar_section_label.dart:1](../../../../../lib/src/navigation/sidebar/klp_sidebar_section_label.dart#L1) |
| import | <code>import &#x27;../../theme/klp_theme.dart&#x27;;</code> | [lib/src/navigation/sidebar/klp_sidebar_section_label.dart:3](../../../../../lib/src/navigation/sidebar/klp_sidebar_section_label.dart#L3) |
| import | <code>import &#x27;../../typography/klp_text.dart&#x27;;</code> | [lib/src/navigation/sidebar/klp_sidebar_section_label.dart:4](../../../../../lib/src/navigation/sidebar/klp_sidebar_section_label.dart#L4) |

## 宣告關係圖

本組節點是本檔宣告；沒有箭頭的宣告未在此圖主張互相依賴。

```mermaid
classDiagram
	class n0["KlpSidebarSectionLabel"]
```

```mermaid
classDiagram
	class n0["KlpSidebarSectionLabel"]
	class n1["StatelessWidget"]
	n0 --|> n1 : extends
```


## 宣告與成員證據

成員包含 public 與 private；簽章取自來源，省略函式本體與欄位初始值。`(inferred)` 表示來源未明寫型別；建構子只顯示參數部分，不含初始化列表。

### KlpSidebarSectionLabel

ClassDeclaration · public · [lib/src/navigation/sidebar/klp_sidebar_section_label.dart:6](../../../../../lib/src/navigation/sidebar/klp_sidebar_section_label.dart#L6)

<code>class KlpSidebarSectionLabel extends StatelessWidget</code>

來源註解摘要：側邊欄分組標題，固定高度且左對齊、使用低對比的 [KlpTextRole.label] 樣式。 固定高度是為了讓不同分組標題之間的垂直節奏一致，即使某個標題很短也不會 讓上下間距看起來不一樣。

- `extends` → <code>StatelessWidget</code>：[lib/src/navigation/sidebar/klp_sidebar_section_label.dart:11](../../../../../lib/src/navigation/sidebar/klp_sidebar_section_label.dart#L11)

| 成員 | 可見性 | 簽章／型別 | 來源註解摘要 | 證據 |
|---|---|---|---|---|
| constructor <code>KlpSidebarSectionLabel</code> | public | <code>const KlpSidebarSectionLabel({super.key, required this.label})</code> |  | [lib/src/navigation/sidebar/klp_sidebar_section_label.dart:12](../../../../../lib/src/navigation/sidebar/klp_sidebar_section_label.dart#L12) |
| field <code>label</code> | public | <code>final String label</code> |  | [lib/src/navigation/sidebar/klp_sidebar_section_label.dart:14](../../../../../lib/src/navigation/sidebar/klp_sidebar_section_label.dart#L14) |
| method <code>build</code> | public | <code>Widget build(BuildContext context)</code> |  | [lib/src/navigation/sidebar/klp_sidebar_section_label.dart:16](../../../../../lib/src/navigation/sidebar/klp_sidebar_section_label.dart#L16) |

## 閱讀說明與限制

箭頭只表示來源明寫的靜態關係；import 不等於呼叫。未分析動態呼叫、欄位的實際物件擁有權、狀態轉移或渲染流程；型別未進行語意解析，繼承目標保留原始型別拼寫。public／private 依 Dart 名稱前綴判斷；public 宣告不代表已由 `lib/kallopis.dart` 匯出。

本頁由 `tool/architecture_atlas` 產生；編輯來源或生成工具後重新產生，避免手改本頁。
