# klp_sidebar_navigation_group.dart：直接依賴與宣告架構

[回到目錄](README.md) · [來源檔案](../../../../../lib/src/navigation/sidebar/klp_sidebar_navigation_group.dart)

## 範圍

核心是 `lib/src/navigation/sidebar/klp_sidebar_navigation_group.dart`。主要視角為該檔案明寫的 import／export／part；輔助視角為本檔宣告及 extends／implements／with／on 關係。只展開一層外部邊界。

## 直接依賴圖

```mermaid
flowchart TD
	n0["klp_sidebar_navigation_group.dart"]
	n1["package:flutter/widgets.dart"]
	n0 -->|"import"| n1
```

## 依賴證據

| 關係 | 原始 directive | 來源 |
|---|---|---|
| import | <code>import &#x27;package:flutter/widgets.dart&#x27;;</code> | [lib/src/navigation/sidebar/klp_sidebar_navigation_group.dart:1](../../../../../lib/src/navigation/sidebar/klp_sidebar_navigation_group.dart#L1) |

## 宣告關係圖

本組節點是本檔宣告；沒有箭頭的宣告未在此圖主張互相依賴。

```mermaid
classDiagram
	class n0["KlpSidebarNavigationGroup"]
```

```mermaid
classDiagram
	class n0["KlpSidebarNavigationGroup"]
	class n1["StatelessWidget"]
	n0 --|> n1 : extends
```


## 宣告與成員證據

成員包含 public 與 private；簽章取自來源，省略函式本體與欄位初始值。`(inferred)` 表示來源未明寫型別；建構子只顯示參數部分，不含初始化列表。

### KlpSidebarNavigationGroup

ClassDeclaration · public · [lib/src/navigation/sidebar/klp_sidebar_navigation_group.dart:3](../../../../../lib/src/navigation/sidebar/klp_sidebar_navigation_group.dart#L3)

<code>class KlpSidebarNavigationGroup extends StatelessWidget</code>

來源註解摘要：Primary Sidebar 的全寬導覽列群組。 呼叫端只決定項目順序；相鄰列緊密排列，不插入額外間距或分隔線。

- `extends` → <code>StatelessWidget</code>：[lib/src/navigation/sidebar/klp_sidebar_navigation_group.dart:6](../../../../../lib/src/navigation/sidebar/klp_sidebar_navigation_group.dart#L6)

| 成員 | 可見性 | 簽章／型別 | 來源註解摘要 | 證據 |
|---|---|---|---|---|
| constructor <code>KlpSidebarNavigationGroup</code> | public | <code>const KlpSidebarNavigationGroup({super.key, required this.children})</code> |  | [lib/src/navigation/sidebar/klp_sidebar_navigation_group.dart:7](../../../../../lib/src/navigation/sidebar/klp_sidebar_navigation_group.dart#L7) |
| field <code>children</code> | public | <code>final List&lt;Widget&gt; children</code> |  | [lib/src/navigation/sidebar/klp_sidebar_navigation_group.dart:9](../../../../../lib/src/navigation/sidebar/klp_sidebar_navigation_group.dart#L9) |
| method <code>build</code> | public | <code>Widget build(BuildContext context)</code> |  | [lib/src/navigation/sidebar/klp_sidebar_navigation_group.dart:11](../../../../../lib/src/navigation/sidebar/klp_sidebar_navigation_group.dart#L11) |

## 閱讀說明與限制

箭頭只表示來源明寫的靜態關係；import 不等於呼叫。未分析動態呼叫、欄位的實際物件擁有權、狀態轉移或渲染流程；型別未進行語意解析，繼承目標保留原始型別拼寫。public／private 依 Dart 名稱前綴判斷；public 宣告不代表已由 `lib/kallopis.dart` 匯出。

本頁由 `tool/architecture_atlas` 產生；編輯來源或生成工具後重新產生，避免手改本頁。
