# klp_avatar_group.dart：直接依賴與宣告架構

[回到目錄](README.md) · [來源檔案](../../../../../../lib/src/features/collections/avatar/klp_avatar_group.dart)

## 範圍

核心是 `lib/src/features/collections/avatar/klp_avatar_group.dart`。主要視角為該檔案明寫的 import／export／part；輔助視角為本檔宣告及 extends／implements／with／on 關係。只展開一層外部邊界。

## 直接依賴圖

```mermaid
flowchart LR
	n0["klp_avatar_group.dart"]
	n1["package:flutter/widgets.dart"]
	n2["../../../foundation/layout/klp_gap.dart"]
	n3["../../../foundation/layout/klp_row.dart"]
	n4["../../../foundation/layout/klp_space_size.dart"]
	n5["klp_avatar.dart"]
	n0 -->|"import"| n1
	n0 -->|"import"| n2
	n0 -->|"import"| n3
	n0 -->|"import"| n4
	n0 -->|"import"| n5
```

## 依賴證據

| 關係 | 原始 directive | 來源 |
|---|---|---|
| import | <code>import &#x27;package:flutter/widgets.dart&#x27;;</code> | [lib/src/features/collections/avatar/klp_avatar_group.dart:1](../../../../../../lib/src/features/collections/avatar/klp_avatar_group.dart#L1) |
| import | <code>import &#x27;../../../foundation/layout/klp_gap.dart&#x27;;</code> | [lib/src/features/collections/avatar/klp_avatar_group.dart:3](../../../../../../lib/src/features/collections/avatar/klp_avatar_group.dart#L3) |
| import | <code>import &#x27;../../../foundation/layout/klp_row.dart&#x27;;</code> | [lib/src/features/collections/avatar/klp_avatar_group.dart:4](../../../../../../lib/src/features/collections/avatar/klp_avatar_group.dart#L4) |
| import | <code>import &#x27;../../../foundation/layout/klp_space_size.dart&#x27;;</code> | [lib/src/features/collections/avatar/klp_avatar_group.dart:5](../../../../../../lib/src/features/collections/avatar/klp_avatar_group.dart#L5) |
| import | <code>import &#x27;klp_avatar.dart&#x27;;</code> | [lib/src/features/collections/avatar/klp_avatar_group.dart:6](../../../../../../lib/src/features/collections/avatar/klp_avatar_group.dart#L6) |

## 宣告關係圖

本組節點是本檔宣告；沒有箭頭的宣告未在此圖主張互相依賴。

```mermaid
classDiagram
	class n0["KlpAvatarGroup"]
```

```mermaid
classDiagram
	class n0["KlpAvatarGroup"]
	class n1["StatelessWidget"]
	n0 --|> n1 : extends
```


## 宣告與成員證據

成員包含 public 與 private；簽章取自來源，省略函式本體與欄位初始值。`(inferred)` 表示來源未明寫型別；建構子只顯示參數部分，不含初始化列表。

### KlpAvatarGroup

ClassDeclaration · public · [lib/src/features/collections/avatar/klp_avatar_group.dart:8](../../../../../../lib/src/features/collections/avatar/klp_avatar_group.dart#L8)

<code>class KlpAvatarGroup extends StatelessWidget</code>

來源註解摘要：以緊密水平排列呈現多個 Avatar，超出上限時顯示剩餘數量。

- `extends` → <code>StatelessWidget</code>：[lib/src/features/collections/avatar/klp_avatar_group.dart:9](../../../../../../lib/src/features/collections/avatar/klp_avatar_group.dart#L9)

| 成員 | 可見性 | 簽章／型別 | 來源註解摘要 | 證據 |
|---|---|---|---|---|
| constructor <code>KlpAvatarGroup</code> | public | <code>const KlpAvatarGroup({ super.key, required this.avatars, this.maximumVisible = 4, })</code> |  | [lib/src/features/collections/avatar/klp_avatar_group.dart:10](../../../../../../lib/src/features/collections/avatar/klp_avatar_group.dart#L10) |
| field <code>avatars</code> | public | <code>final List&lt;KlpAvatarData&gt; avatars</code> |  | [lib/src/features/collections/avatar/klp_avatar_group.dart:16](../../../../../../lib/src/features/collections/avatar/klp_avatar_group.dart#L16) |
| field <code>maximumVisible</code> | public | <code>final int maximumVisible</code> |  | [lib/src/features/collections/avatar/klp_avatar_group.dart:17](../../../../../../lib/src/features/collections/avatar/klp_avatar_group.dart#L17) |
| method <code>build</code> | public | <code>Widget build(BuildContext context)</code> |  | [lib/src/features/collections/avatar/klp_avatar_group.dart:19](../../../../../../lib/src/features/collections/avatar/klp_avatar_group.dart#L19) |

## 閱讀說明與限制

箭頭只表示來源明寫的靜態關係；import 不等於呼叫。未分析動態呼叫、欄位的實際物件擁有權、狀態轉移或渲染流程；型別未進行語意解析，繼承目標保留原始型別拼寫。public／private 依 Dart 名稱前綴判斷；public 宣告不代表已由 `lib/kallopis.dart` 匯出。

本頁由 `tool/architecture_atlas` 產生；編輯來源或生成工具後重新產生，避免手改本頁。
