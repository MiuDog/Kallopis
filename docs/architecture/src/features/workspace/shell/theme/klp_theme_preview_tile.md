# klp_theme_preview_tile.dart：直接依賴與宣告架構

[回到目錄](README.md) · [來源檔案](../../../../../../../lib/src/features/workspace/shell/theme/klp_theme_preview_tile.dart)

## 範圍

核心是 `lib/src/features/workspace/shell/theme/klp_theme_preview_tile.dart`。主要視角為該檔案明寫的 import／export／part；輔助視角為本檔宣告及 extends／implements／with／on 關係。只展開一層外部邊界。

## 直接依賴圖

```mermaid
flowchart LR
	n0["klp_theme_preview_tile.dart"]
	n1["dart:math"]
	n2["package:flutter/material.dart"]
	n3["../../../../foundation/klp_palette.dart"]
	n4["../../../../foundation/interaction/klp_pressable.dart"]
	n5["../../../../foundation/layout/klp_column.dart"]
	n6["../../../../foundation/layout/klp_gap.dart"]
	n7["../../../../foundation/layout/klp_space_size.dart"]
	n8["../../../../styling/legacy_theme/klp_theme.dart"]
	n9["../../../../foundation/content/klp_text.dart"]
	n10["klp_theme_preview_mode.dart"]
	n11["klp_theme_preview_mode.dart"]
	n0 -->|"import"| n1
	n0 -->|"import"| n2
	n0 -->|"import"| n3
	n0 -->|"import"| n4
	n0 -->|"import"| n5
	n0 -->|"import"| n6
	n0 -->|"import"| n7
	n0 -->|"import"| n8
	n0 -->|"import"| n9
	n0 -->|"import"| n10
	n0 -->|"export"| n11
```

```mermaid
flowchart LR
	n0["klp_theme_preview_tile.dart"]
	n1["internal/klp_theme_preview_skin.dart"]
	n2["primitives/klp_theme_preview_artwork.dart"]
	n3["primitives/klp_theme_preview_painter.dart"]
	n4["primitives/klp_theme_preview_tile_frame.dart"]
	n0 -->|"part"| n1
	n0 -->|"part"| n2
	n0 -->|"part"| n3
	n0 -->|"part"| n4
```

## 依賴證據

| 關係 | 原始 directive | 來源 |
|---|---|---|
| import | <code>import &#x27;dart:math&#x27; as math;</code> | [lib/src/features/workspace/shell/theme/klp_theme_preview_tile.dart:1](../../../../../../../lib/src/features/workspace/shell/theme/klp_theme_preview_tile.dart#L1) |
| import | <code>import &#x27;package:flutter/material.dart&#x27;;</code> | [lib/src/features/workspace/shell/theme/klp_theme_preview_tile.dart:3](../../../../../../../lib/src/features/workspace/shell/theme/klp_theme_preview_tile.dart#L3) |
| import | <code>import &#x27;../../../../foundation/klp_palette.dart&#x27;;</code> | [lib/src/features/workspace/shell/theme/klp_theme_preview_tile.dart:5](../../../../../../../lib/src/features/workspace/shell/theme/klp_theme_preview_tile.dart#L5) |
| import | <code>import &#x27;../../../../foundation/interaction/klp_pressable.dart&#x27;;</code> | [lib/src/features/workspace/shell/theme/klp_theme_preview_tile.dart:6](../../../../../../../lib/src/features/workspace/shell/theme/klp_theme_preview_tile.dart#L6) |
| import | <code>import &#x27;../../../../foundation/layout/klp_column.dart&#x27;;</code> | [lib/src/features/workspace/shell/theme/klp_theme_preview_tile.dart:7](../../../../../../../lib/src/features/workspace/shell/theme/klp_theme_preview_tile.dart#L7) |
| import | <code>import &#x27;../../../../foundation/layout/klp_gap.dart&#x27;;</code> | [lib/src/features/workspace/shell/theme/klp_theme_preview_tile.dart:8](../../../../../../../lib/src/features/workspace/shell/theme/klp_theme_preview_tile.dart#L8) |
| import | <code>import &#x27;../../../../foundation/layout/klp_space_size.dart&#x27;;</code> | [lib/src/features/workspace/shell/theme/klp_theme_preview_tile.dart:9](../../../../../../../lib/src/features/workspace/shell/theme/klp_theme_preview_tile.dart#L9) |
| import | <code>import &#x27;../../../../styling/legacy_theme/klp_theme.dart&#x27;;</code> | [lib/src/features/workspace/shell/theme/klp_theme_preview_tile.dart:10](../../../../../../../lib/src/features/workspace/shell/theme/klp_theme_preview_tile.dart#L10) |
| import | <code>import &#x27;../../../../foundation/content/klp_text.dart&#x27;;</code> | [lib/src/features/workspace/shell/theme/klp_theme_preview_tile.dart:11](../../../../../../../lib/src/features/workspace/shell/theme/klp_theme_preview_tile.dart#L11) |
| import | <code>import &#x27;klp_theme_preview_mode.dart&#x27;;</code> | [lib/src/features/workspace/shell/theme/klp_theme_preview_tile.dart:12](../../../../../../../lib/src/features/workspace/shell/theme/klp_theme_preview_tile.dart#L12) |
| export | <code>export &#x27;klp_theme_preview_mode.dart&#x27;;</code> | [lib/src/features/workspace/shell/theme/klp_theme_preview_tile.dart:14](../../../../../../../lib/src/features/workspace/shell/theme/klp_theme_preview_tile.dart#L14) |
| part | <code>part &#x27;internal/klp_theme_preview_skin.dart&#x27;;</code> | [lib/src/features/workspace/shell/theme/klp_theme_preview_tile.dart:16](../../../../../../../lib/src/features/workspace/shell/theme/klp_theme_preview_tile.dart#L16) |
| part | <code>part &#x27;primitives/klp_theme_preview_artwork.dart&#x27;;</code> | [lib/src/features/workspace/shell/theme/klp_theme_preview_tile.dart:17](../../../../../../../lib/src/features/workspace/shell/theme/klp_theme_preview_tile.dart#L17) |
| part | <code>part &#x27;primitives/klp_theme_preview_painter.dart&#x27;;</code> | [lib/src/features/workspace/shell/theme/klp_theme_preview_tile.dart:18](../../../../../../../lib/src/features/workspace/shell/theme/klp_theme_preview_tile.dart#L18) |
| part | <code>part &#x27;primitives/klp_theme_preview_tile_frame.dart&#x27;;</code> | [lib/src/features/workspace/shell/theme/klp_theme_preview_tile.dart:19](../../../../../../../lib/src/features/workspace/shell/theme/klp_theme_preview_tile.dart#L19) |

## 宣告關係圖

本組節點是本檔宣告；沒有箭頭的宣告未在此圖主張互相依賴。

```mermaid
classDiagram
	class n0["KlpThemePreviewTile"]
```

```mermaid
classDiagram
	class n0["KlpThemePreviewTile"]
	class n1["StatelessWidget"]
	n0 --|> n1 : extends
```


## 宣告與成員證據

成員包含 public 與 private；簽章取自來源，省略函式本體與欄位初始值。`(inferred)` 表示來源未明寫型別；建構子只顯示參數部分，不含初始化列表。

### KlpThemePreviewTile

ClassDeclaration · public · [lib/src/features/workspace/shell/theme/klp_theme_preview_tile.dart:21](../../../../../../../lib/src/features/workspace/shell/theme/klp_theme_preview_tile.dart#L21)

<code>class KlpThemePreviewTile extends StatelessWidget</code>

來源註解摘要：以插圖預覽受控的 Kallopis 顏色模式。

- `extends` → <code>StatelessWidget</code>：[lib/src/features/workspace/shell/theme/klp_theme_preview_tile.dart:22](../../../../../../../lib/src/features/workspace/shell/theme/klp_theme_preview_tile.dart#L22)

| 成員 | 可見性 | 簽章／型別 | 來源註解摘要 | 證據 |
|---|---|---|---|---|
| constructor <code>KlpThemePreviewTile</code> | public | <code>const KlpThemePreviewTile({ super.key, required this.mode, required this.label, required this.description, this.selected = false, this.enabled = true, this.onSelected, })</code> |  | [lib/src/features/workspace/shell/theme/klp_theme_preview_tile.dart:23](../../../../../../../lib/src/features/workspace/shell/theme/klp_theme_preview_tile.dart#L23) |
| field <code>mode</code> | public | <code>final KlpThemePreviewMode mode</code> |  | [lib/src/features/workspace/shell/theme/klp_theme_preview_tile.dart:33](../../../../../../../lib/src/features/workspace/shell/theme/klp_theme_preview_tile.dart#L33) |
| field <code>label</code> | public | <code>final String label</code> |  | [lib/src/features/workspace/shell/theme/klp_theme_preview_tile.dart:34](../../../../../../../lib/src/features/workspace/shell/theme/klp_theme_preview_tile.dart#L34) |
| field <code>description</code> | public | <code>final String description</code> |  | [lib/src/features/workspace/shell/theme/klp_theme_preview_tile.dart:35](../../../../../../../lib/src/features/workspace/shell/theme/klp_theme_preview_tile.dart#L35) |
| field <code>selected</code> | public | <code>final bool selected</code> |  | [lib/src/features/workspace/shell/theme/klp_theme_preview_tile.dart:36](../../../../../../../lib/src/features/workspace/shell/theme/klp_theme_preview_tile.dart#L36) |
| field <code>enabled</code> | public | <code>final bool enabled</code> |  | [lib/src/features/workspace/shell/theme/klp_theme_preview_tile.dart:37](../../../../../../../lib/src/features/workspace/shell/theme/klp_theme_preview_tile.dart#L37) |
| field <code>onSelected</code> | public | <code>final VoidCallback? onSelected</code> |  | [lib/src/features/workspace/shell/theme/klp_theme_preview_tile.dart:38](../../../../../../../lib/src/features/workspace/shell/theme/klp_theme_preview_tile.dart#L38) |
| method <code>build</code> | public | <code>Widget build(BuildContext context)</code> |  | [lib/src/features/workspace/shell/theme/klp_theme_preview_tile.dart:40](../../../../../../../lib/src/features/workspace/shell/theme/klp_theme_preview_tile.dart#L40) |

## 閱讀說明與限制

箭頭只表示來源明寫的靜態關係；import 不等於呼叫。未分析動態呼叫、欄位的實際物件擁有權、狀態轉移或渲染流程；型別未進行語意解析，繼承目標保留原始型別拼寫。public／private 依 Dart 名稱前綴判斷；public 宣告不代表已由 `lib/kallopis.dart` 匯出。

本頁由 `tool/architecture_atlas` 產生；編輯來源或生成工具後重新產生，避免手改本頁。
