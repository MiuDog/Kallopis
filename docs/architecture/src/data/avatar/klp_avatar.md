# klp_avatar.dart：直接依賴與宣告架構

[回到目錄](README.md) · [來源檔案](../../../../../lib/src/data/avatar/klp_avatar.dart)

## 範圍

核心是 `lib/src/data/avatar/klp_avatar.dart`。主要視角為該檔案明寫的 import／export／part；輔助視角為本檔宣告及 extends／implements／with／on 關係。只展開一層外部邊界。

## 直接依賴圖

```mermaid
flowchart TD
	n0["klp_avatar.dart"]
	n1["package:flutter/material.dart"]
	n2["../../theme/klp_theme.dart"]
	n3["../../typography/klp_text.dart"]
	n0 -->|"import"| n1
	n0 -->|"import"| n2
	n0 -->|"import"| n3
```

## 依賴證據

| 關係 | 原始 directive | 來源 |
|---|---|---|
| import | <code>import &#x27;package:flutter/material.dart&#x27;;</code> | [lib/src/data/avatar/klp_avatar.dart:1](../../../../../lib/src/data/avatar/klp_avatar.dart#L1) |
| import | <code>import &#x27;../../theme/klp_theme.dart&#x27;;</code> | [lib/src/data/avatar/klp_avatar.dart:3](../../../../../lib/src/data/avatar/klp_avatar.dart#L3) |
| import | <code>import &#x27;../../typography/klp_text.dart&#x27;;</code> | [lib/src/data/avatar/klp_avatar.dart:4](../../../../../lib/src/data/avatar/klp_avatar.dart#L4) |

## 宣告關係圖

本組節點是本檔宣告；沒有箭頭的宣告未在此圖主張互相依賴。

```mermaid
classDiagram
	class n0["KlpAvatar"]
	class n1["KlpAvatarData"]
	class n2["KlpAvatarGroup"]
```

```mermaid
classDiagram
	class n0["KlpAvatar"]
	class n1["StatelessWidget"]
	n0 --|> n1 : extends
```

```mermaid
classDiagram
	class n0["KlpAvatarGroup"]
	class n1["StatelessWidget"]
	n0 --|> n1 : extends
```


## 宣告與成員證據

成員包含 public 與 private；簽章取自來源，省略函式本體與欄位初始值。`(inferred)` 表示來源未明寫型別；建構子只顯示參數部分，不含初始化列表。

### KlpAvatar

ClassDeclaration · public · [lib/src/data/avatar/klp_avatar.dart:6](../../../../../lib/src/data/avatar/klp_avatar.dart#L6)

<code>class KlpAvatar extends StatelessWidget</code>

- `extends` → <code>StatelessWidget</code>：[lib/src/data/avatar/klp_avatar.dart:6](../../../../../lib/src/data/avatar/klp_avatar.dart#L6)

| 成員 | 可見性 | 簽章／型別 | 來源註解摘要 | 證據 |
|---|---|---|---|---|
| constructor <code>KlpAvatar</code> | public | <code>const KlpAvatar({ super.key, required this.label, this.image, this.size, this.semanticLabel, this.emphasized = false, })</code> |  | [lib/src/data/avatar/klp_avatar.dart:7](../../../../../lib/src/data/avatar/klp_avatar.dart#L7) |
| field <code>label</code> | public | <code>final String label</code> |  | [lib/src/data/avatar/klp_avatar.dart:16](../../../../../lib/src/data/avatar/klp_avatar.dart#L16) |
| field <code>image</code> | public | <code>final ImageProvider? image</code> |  | [lib/src/data/avatar/klp_avatar.dart:17](../../../../../lib/src/data/avatar/klp_avatar.dart#L17) |
| field <code>size</code> | public | <code>final double? size</code> | `null` 表示沿用 theme 的大型控制項高度。 | [lib/src/data/avatar/klp_avatar.dart:20](../../../../../lib/src/data/avatar/klp_avatar.dart#L20) |
| field <code>semanticLabel</code> | public | <code>final String? semanticLabel</code> |  | [lib/src/data/avatar/klp_avatar.dart:21](../../../../../lib/src/data/avatar/klp_avatar.dart#L21) |
| field <code>emphasized</code> | public | <code>final bool emphasized</code> | 強調型使用 accent 底色、對比前景與 pill 圓角。 | [lib/src/data/avatar/klp_avatar.dart:24](../../../../../lib/src/data/avatar/klp_avatar.dart#L24) |
| method <code>build</code> | public | <code>Widget build(BuildContext context)</code> |  | [lib/src/data/avatar/klp_avatar.dart:26](../../../../../lib/src/data/avatar/klp_avatar.dart#L26) |

### KlpAvatarData

ClassDeclaration · public · [lib/src/data/avatar/klp_avatar.dart:58](../../../../../lib/src/data/avatar/klp_avatar.dart#L58)

<code>class KlpAvatarData</code>


| 成員 | 可見性 | 簽章／型別 | 來源註解摘要 | 證據 |
|---|---|---|---|---|
| constructor <code>KlpAvatarData</code> | public | <code>const KlpAvatarData({required this.id, required this.label, this.image})</code> |  | [lib/src/data/avatar/klp_avatar.dart:60](../../../../../lib/src/data/avatar/klp_avatar.dart#L60) |
| field <code>id</code> | public | <code>final String id</code> |  | [lib/src/data/avatar/klp_avatar.dart:62](../../../../../lib/src/data/avatar/klp_avatar.dart#L62) |
| field <code>label</code> | public | <code>final String label</code> |  | [lib/src/data/avatar/klp_avatar.dart:63](../../../../../lib/src/data/avatar/klp_avatar.dart#L63) |
| field <code>image</code> | public | <code>final ImageProvider? image</code> |  | [lib/src/data/avatar/klp_avatar.dart:64](../../../../../lib/src/data/avatar/klp_avatar.dart#L64) |

### KlpAvatarGroup

ClassDeclaration · public · [lib/src/data/avatar/klp_avatar.dart:67](../../../../../lib/src/data/avatar/klp_avatar.dart#L67)

<code>class KlpAvatarGroup extends StatelessWidget</code>

- `extends` → <code>StatelessWidget</code>：[lib/src/data/avatar/klp_avatar.dart:67](../../../../../lib/src/data/avatar/klp_avatar.dart#L67)

| 成員 | 可見性 | 簽章／型別 | 來源註解摘要 | 證據 |
|---|---|---|---|---|
| constructor <code>KlpAvatarGroup</code> | public | <code>const KlpAvatarGroup({ super.key, required this.avatars, this.maximumVisible = 4, })</code> |  | [lib/src/data/avatar/klp_avatar.dart:68](../../../../../lib/src/data/avatar/klp_avatar.dart#L68) |
| field <code>avatars</code> | public | <code>final List&lt;KlpAvatarData&gt; avatars</code> |  | [lib/src/data/avatar/klp_avatar.dart:74](../../../../../lib/src/data/avatar/klp_avatar.dart#L74) |
| field <code>maximumVisible</code> | public | <code>final int maximumVisible</code> |  | [lib/src/data/avatar/klp_avatar.dart:75](../../../../../lib/src/data/avatar/klp_avatar.dart#L75) |
| method <code>build</code> | public | <code>Widget build(BuildContext context)</code> |  | [lib/src/data/avatar/klp_avatar.dart:77](../../../../../lib/src/data/avatar/klp_avatar.dart#L77) |

## 閱讀說明與限制

箭頭只表示來源明寫的靜態關係；import 不等於呼叫。未分析動態呼叫、欄位的實際物件擁有權、狀態轉移或渲染流程；型別未進行語意解析，繼承目標保留原始型別拼寫。public／private 依 Dart 名稱前綴判斷；public 宣告不代表已由 `lib/kallopis.dart` 匯出。

本頁由 `tool/architecture_atlas` 產生；編輯來源或生成工具後重新產生，避免手改本頁。
