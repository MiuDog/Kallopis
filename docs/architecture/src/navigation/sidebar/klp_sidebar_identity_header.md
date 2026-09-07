# klp_sidebar_identity_header.dart：直接依賴與宣告架構

[回到目錄](README.md) · [來源檔案](../../../../../lib/src/navigation/sidebar/klp_sidebar_identity_header.dart)

## 範圍

核心是 `lib/src/navigation/sidebar/klp_sidebar_identity_header.dart`。主要視角為該檔案明寫的 import／export／part；輔助視角為本檔宣告及 extends／implements／with／on 關係。只展開一層外部邊界。

## 直接依賴圖

```mermaid
flowchart LR
	n0["klp_sidebar_identity_header.dart"]
	n1["package:flutter/widgets.dart"]
	n2["../../data/avatar/klp_avatar.dart"]
	n3["../../foundation/klp_icon.dart"]
	n4["../../surface/klp_surface.dart"]
	n5["../../theme/klp_theme.dart"]
	n6["../../typography/klp_text.dart"]
	n0 -->|"import"| n1
	n0 -->|"import"| n2
	n0 -->|"import"| n3
	n0 -->|"import"| n4
	n0 -->|"import"| n5
	n0 -->|"import"| n6
```

## 依賴證據

| 關係 | 原始 directive | 來源 |
|---|---|---|
| import | <code>import &#x27;package:flutter/widgets.dart&#x27;;</code> | [lib/src/navigation/sidebar/klp_sidebar_identity_header.dart:1](../../../../../lib/src/navigation/sidebar/klp_sidebar_identity_header.dart#L1) |
| import | <code>import &#x27;../../data/avatar/klp_avatar.dart&#x27;;</code> | [lib/src/navigation/sidebar/klp_sidebar_identity_header.dart:3](../../../../../lib/src/navigation/sidebar/klp_sidebar_identity_header.dart#L3) |
| import | <code>import &#x27;../../foundation/klp_icon.dart&#x27;;</code> | [lib/src/navigation/sidebar/klp_sidebar_identity_header.dart:4](../../../../../lib/src/navigation/sidebar/klp_sidebar_identity_header.dart#L4) |
| import | <code>import &#x27;../../surface/klp_surface.dart&#x27;;</code> | [lib/src/navigation/sidebar/klp_sidebar_identity_header.dart:5](../../../../../lib/src/navigation/sidebar/klp_sidebar_identity_header.dart#L5) |
| import | <code>import &#x27;../../theme/klp_theme.dart&#x27;;</code> | [lib/src/navigation/sidebar/klp_sidebar_identity_header.dart:6](../../../../../lib/src/navigation/sidebar/klp_sidebar_identity_header.dart#L6) |
| import | <code>import &#x27;../../typography/klp_text.dart&#x27;;</code> | [lib/src/navigation/sidebar/klp_sidebar_identity_header.dart:7](../../../../../lib/src/navigation/sidebar/klp_sidebar_identity_header.dart#L7) |

## 宣告關係圖

本組節點是本檔宣告；沒有箭頭的宣告未在此圖主張互相依賴。

```mermaid
classDiagram
	class n0["KlpSidebarIdentityHeader"]
```

```mermaid
classDiagram
	class n0["KlpSidebarIdentityHeader"]
	class n1["StatelessWidget"]
	n0 --|> n1 : extends
```


## 宣告與成員證據

成員包含 public 與 private；簽章取自來源，省略函式本體與欄位初始值。`(inferred)` 表示來源未明寫型別；建構子只顯示參數部分，不含初始化列表。

### KlpSidebarIdentityHeader

ClassDeclaration · public · [lib/src/navigation/sidebar/klp_sidebar_identity_header.dart:9](../../../../../lib/src/navigation/sidebar/klp_sidebar_identity_header.dart#L9)

<code>class KlpSidebarIdentityHeader extends StatelessWidget</code>

來源註解摘要：Primary Sidebar 頂部的 workspace identity。 呼叫端提供圖示、名稱與選填尾端內容；Kallopis 統一負責圖示底面、文字層級、 間距與截斷行為。

- `extends` → <code>StatelessWidget</code>：[lib/src/navigation/sidebar/klp_sidebar_identity_header.dart:13](../../../../../lib/src/navigation/sidebar/klp_sidebar_identity_header.dart#L13)

| 成員 | 可見性 | 簽章／型別 | 來源註解摘要 | 證據 |
|---|---|---|---|---|
| constructor <code>KlpSidebarIdentityHeader</code> | public | <code>const KlpSidebarIdentityHeader({ super.key, required this.icon, required this.title, this.trailing, this.avatarLabel, this.avatarSemanticLabel, this.avatarImage, })</code> |  | [lib/src/navigation/sidebar/klp_sidebar_identity_header.dart:14](../../../../../lib/src/navigation/sidebar/klp_sidebar_identity_header.dart#L14) |
| field <code>icon</code> | public | <code>final KlpIconData icon</code> |  | [lib/src/navigation/sidebar/klp_sidebar_identity_header.dart:24](../../../../../lib/src/navigation/sidebar/klp_sidebar_identity_header.dart#L24) |
| field <code>title</code> | public | <code>final String title</code> |  | [lib/src/navigation/sidebar/klp_sidebar_identity_header.dart:25](../../../../../lib/src/navigation/sidebar/klp_sidebar_identity_header.dart#L25) |
| field <code>trailing</code> | public | <code>final Widget? trailing</code> |  | [lib/src/navigation/sidebar/klp_sidebar_identity_header.dart:26](../../../../../lib/src/navigation/sidebar/klp_sidebar_identity_header.dart#L26) |
| field <code>avatarLabel</code> | public | <code>final String? avatarLabel</code> | 尾端識別標記；尺寸由 Primary Sidebar 的預設密度決定。 | [lib/src/navigation/sidebar/klp_sidebar_identity_header.dart:29](../../../../../lib/src/navigation/sidebar/klp_sidebar_identity_header.dart#L29) |
| field <code>avatarSemanticLabel</code> | public | <code>final String? avatarSemanticLabel</code> |  | [lib/src/navigation/sidebar/klp_sidebar_identity_header.dart:30](../../../../../lib/src/navigation/sidebar/klp_sidebar_identity_header.dart#L30) |
| field <code>avatarImage</code> | public | <code>final ImageProvider? avatarImage</code> |  | [lib/src/navigation/sidebar/klp_sidebar_identity_header.dart:31](../../../../../lib/src/navigation/sidebar/klp_sidebar_identity_header.dart#L31) |
| method <code>build</code> | public | <code>Widget build(BuildContext context)</code> |  | [lib/src/navigation/sidebar/klp_sidebar_identity_header.dart:33](../../../../../lib/src/navigation/sidebar/klp_sidebar_identity_header.dart#L33) |

## 閱讀說明與限制

箭頭只表示來源明寫的靜態關係；import 不等於呼叫。未分析動態呼叫、欄位的實際物件擁有權、狀態轉移或渲染流程；型別未進行語意解析，繼承目標保留原始型別拼寫。public／private 依 Dart 名稱前綴判斷；public 宣告不代表已由 `lib/kallopis.dart` 匯出。

本頁由 `tool/architecture_atlas` 產生；編輯來源或生成工具後重新產生，避免手改本頁。
