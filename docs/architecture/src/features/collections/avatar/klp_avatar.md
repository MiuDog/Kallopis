# klp_avatar.dart：直接依賴與宣告架構

[回到目錄](README.md) · [來源檔案](../../../../../../lib/src/features/collections/avatar/klp_avatar.dart)

## 範圍

核心是 `lib/src/features/collections/avatar/klp_avatar.dart`。主要視角為該檔案明寫的 import／export／part；輔助視角為本檔宣告及 extends／implements／with／on 關係。只展開一層外部邊界。

## 直接依賴圖

```mermaid
flowchart LR
	n0["klp_avatar.dart"]
	n1["package:flutter/widgets.dart"]
	n2["../../../styling/legacy_theme/klp_theme.dart"]
	n3["../../../foundation/content/klp_text.dart"]
	n4["klp_avatar_size.dart"]
	n5["klp_avatar_tone.dart"]
	n6["klp_avatar_data.dart"]
	n7["klp_avatar_group.dart"]
	n8["klp_avatar_size.dart"]
	n9["klp_avatar_tone.dart"]
	n10["primitives/klp_avatar_frame.dart"]
	n0 -->|"import"| n1
	n0 -->|"import"| n2
	n0 -->|"import"| n3
	n0 -->|"import"| n4
	n0 -->|"import"| n5
	n0 -->|"export"| n6
	n0 -->|"export"| n7
	n0 -->|"export"| n8
	n0 -->|"export"| n9
	n0 -->|"part"| n10
```

## 依賴證據

| 關係 | 原始 directive | 來源 |
|---|---|---|
| import | <code>import &#x27;package:flutter/widgets.dart&#x27;;</code> | [lib/src/features/collections/avatar/klp_avatar.dart:1](../../../../../../lib/src/features/collections/avatar/klp_avatar.dart#L1) |
| import | <code>import &#x27;../../../styling/legacy_theme/klp_theme.dart&#x27;;</code> | [lib/src/features/collections/avatar/klp_avatar.dart:3](../../../../../../lib/src/features/collections/avatar/klp_avatar.dart#L3) |
| import | <code>import &#x27;../../../foundation/content/klp_text.dart&#x27;;</code> | [lib/src/features/collections/avatar/klp_avatar.dart:4](../../../../../../lib/src/features/collections/avatar/klp_avatar.dart#L4) |
| import | <code>import &#x27;klp_avatar_size.dart&#x27;;</code> | [lib/src/features/collections/avatar/klp_avatar.dart:5](../../../../../../lib/src/features/collections/avatar/klp_avatar.dart#L5) |
| import | <code>import &#x27;klp_avatar_tone.dart&#x27;;</code> | [lib/src/features/collections/avatar/klp_avatar.dart:6](../../../../../../lib/src/features/collections/avatar/klp_avatar.dart#L6) |
| export | <code>export &#x27;klp_avatar_data.dart&#x27;;</code> | [lib/src/features/collections/avatar/klp_avatar.dart:8](../../../../../../lib/src/features/collections/avatar/klp_avatar.dart#L8) |
| export | <code>export &#x27;klp_avatar_group.dart&#x27;;</code> | [lib/src/features/collections/avatar/klp_avatar.dart:9](../../../../../../lib/src/features/collections/avatar/klp_avatar.dart#L9) |
| export | <code>export &#x27;klp_avatar_size.dart&#x27;;</code> | [lib/src/features/collections/avatar/klp_avatar.dart:10](../../../../../../lib/src/features/collections/avatar/klp_avatar.dart#L10) |
| export | <code>export &#x27;klp_avatar_tone.dart&#x27;;</code> | [lib/src/features/collections/avatar/klp_avatar.dart:11](../../../../../../lib/src/features/collections/avatar/klp_avatar.dart#L11) |
| part | <code>part &#x27;primitives/klp_avatar_frame.dart&#x27;;</code> | [lib/src/features/collections/avatar/klp_avatar.dart:13](../../../../../../lib/src/features/collections/avatar/klp_avatar.dart#L13) |

## 宣告關係圖

本組節點是本檔宣告；沒有箭頭的宣告未在此圖主張互相依賴。

```mermaid
classDiagram
	class n0["KlpAvatar"]
```

```mermaid
classDiagram
	class n0["KlpAvatar"]
	class n1["StatelessWidget"]
	n0 --|> n1 : extends
```


## 宣告與成員證據

成員包含 public 與 private；簽章取自來源，省略函式本體與欄位初始值。`(inferred)` 表示來源未明寫型別；建構子只顯示參數部分，不含初始化列表。

### KlpAvatar

ClassDeclaration · public · [lib/src/features/collections/avatar/klp_avatar.dart:15](../../../../../../lib/src/features/collections/avatar/klp_avatar.dart#L15)

<code>class KlpAvatar extends StatelessWidget</code>

來源註解摘要：以文字或圖片呈現無產品語意的身份識別圖像。

- `extends` → <code>StatelessWidget</code>：[lib/src/features/collections/avatar/klp_avatar.dart:16](../../../../../../lib/src/features/collections/avatar/klp_avatar.dart#L16)

| 成員 | 可見性 | 簽章／型別 | 來源註解摘要 | 證據 |
|---|---|---|---|---|
| constructor <code>KlpAvatar</code> | public | <code>const KlpAvatar({ super.key, required this.label, this.image, this.size = KlpAvatarSize.standard, this.semanticLabel, this.tone = KlpAvatarTone.neutral, })</code> |  | [lib/src/features/collections/avatar/klp_avatar.dart:17](../../../../../../lib/src/features/collections/avatar/klp_avatar.dart#L17) |
| field <code>label</code> | public | <code>final String label</code> |  | [lib/src/features/collections/avatar/klp_avatar.dart:26](../../../../../../lib/src/features/collections/avatar/klp_avatar.dart#L26) |
| field <code>image</code> | public | <code>final ImageProvider? image</code> |  | [lib/src/features/collections/avatar/klp_avatar.dart:27](../../../../../../lib/src/features/collections/avatar/klp_avatar.dart#L27) |
| field <code>size</code> | public | <code>final KlpAvatarSize size</code> |  | [lib/src/features/collections/avatar/klp_avatar.dart:28](../../../../../../lib/src/features/collections/avatar/klp_avatar.dart#L28) |
| field <code>semanticLabel</code> | public | <code>final String? semanticLabel</code> |  | [lib/src/features/collections/avatar/klp_avatar.dart:29](../../../../../../lib/src/features/collections/avatar/klp_avatar.dart#L29) |
| field <code>tone</code> | public | <code>final KlpAvatarTone tone</code> |  | [lib/src/features/collections/avatar/klp_avatar.dart:30](../../../../../../lib/src/features/collections/avatar/klp_avatar.dart#L30) |
| method <code>build</code> | public | <code>Widget build(BuildContext context)</code> |  | [lib/src/features/collections/avatar/klp_avatar.dart:32](../../../../../../lib/src/features/collections/avatar/klp_avatar.dart#L32) |

## 閱讀說明與限制

箭頭只表示來源明寫的靜態關係；import 不等於呼叫。未分析動態呼叫、欄位的實際物件擁有權、狀態轉移或渲染流程；型別未進行語意解析，繼承目標保留原始型別拼寫。public／private 依 Dart 名稱前綴判斷；public 宣告不代表已由 `lib/kallopis.dart` 匯出。

本頁由 `tool/architecture_atlas` 產生；編輯來源或生成工具後重新產生，避免手改本頁。
