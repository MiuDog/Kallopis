# klp_theme_mode_picker.dart：直接依賴與宣告架構

[回到目錄](README.md) · [來源檔案](../../../../../../lib/src/features/workspace/settings/klp_theme_mode_picker.dart)

## 範圍

核心是 `lib/src/features/workspace/settings/klp_theme_mode_picker.dart`。主要視角為該檔案明寫的 import／export／part；輔助視角為本檔宣告及 extends／implements／with／on 關係。只展開一層外部邊界。

## 直接依賴圖

```mermaid
flowchart LR
	n0["klp_theme_mode_picker.dart"]
	n1["package:flutter/widgets.dart"]
	n2["../../../foundation/layout/klp_space_size.dart"]
	n3["../../../foundation/layout/klp_wrap.dart"]
	n4["../shell/theme/klp_theme_preview_tile.dart"]
	n5["klp_theme_mode_option.dart"]
	n6["klp_theme_mode_option.dart"]
	n0 -->|"import"| n1
	n0 -->|"import"| n2
	n0 -->|"import"| n3
	n0 -->|"import"| n4
	n0 -->|"import"| n5
	n0 -->|"export"| n6
```

## 依賴證據

| 關係 | 原始 directive | 來源 |
|---|---|---|
| import | <code>import &#x27;package:flutter/widgets.dart&#x27;;</code> | [lib/src/features/workspace/settings/klp_theme_mode_picker.dart:1](../../../../../../lib/src/features/workspace/settings/klp_theme_mode_picker.dart#L1) |
| import | <code>import &#x27;../../../foundation/layout/klp_space_size.dart&#x27;;</code> | [lib/src/features/workspace/settings/klp_theme_mode_picker.dart:3](../../../../../../lib/src/features/workspace/settings/klp_theme_mode_picker.dart#L3) |
| import | <code>import &#x27;../../../foundation/layout/klp_wrap.dart&#x27;;</code> | [lib/src/features/workspace/settings/klp_theme_mode_picker.dart:4](../../../../../../lib/src/features/workspace/settings/klp_theme_mode_picker.dart#L4) |
| import | <code>import &#x27;../shell/theme/klp_theme_preview_tile.dart&#x27;;</code> | [lib/src/features/workspace/settings/klp_theme_mode_picker.dart:5](../../../../../../lib/src/features/workspace/settings/klp_theme_mode_picker.dart#L5) |
| import | <code>import &#x27;klp_theme_mode_option.dart&#x27;;</code> | [lib/src/features/workspace/settings/klp_theme_mode_picker.dart:6](../../../../../../lib/src/features/workspace/settings/klp_theme_mode_picker.dart#L6) |
| export | <code>export &#x27;klp_theme_mode_option.dart&#x27;;</code> | [lib/src/features/workspace/settings/klp_theme_mode_picker.dart:8](../../../../../../lib/src/features/workspace/settings/klp_theme_mode_picker.dart#L8) |

## 宣告關係圖

本組節點是本檔宣告；沒有箭頭的宣告未在此圖主張互相依賴。

```mermaid
classDiagram
	class n0["KlpThemeModePicker"]
```

```mermaid
classDiagram
	class n0["KlpThemeModePicker"]
	class n1["StatelessWidget"]
	n0 --|> n1 : extends
```


## 宣告與成員證據

成員包含 public 與 private；簽章取自來源，省略函式本體與欄位初始值。`(inferred)` 表示來源未明寫型別；建構子只顯示參數部分，不含初始化列表。

### KlpThemeModePicker

ClassDeclaration · public · [lib/src/features/workspace/settings/klp_theme_mode_picker.dart:10](../../../../../../lib/src/features/workspace/settings/klp_theme_mode_picker.dart#L10)

<code>class KlpThemeModePicker extends StatelessWidget</code>

來源註解摘要：以 Kallopis 預覽磚排列受控的顏色模式選項。

- `extends` → <code>StatelessWidget</code>：[lib/src/features/workspace/settings/klp_theme_mode_picker.dart:11](../../../../../../lib/src/features/workspace/settings/klp_theme_mode_picker.dart#L11)

| 成員 | 可見性 | 簽章／型別 | 來源註解摘要 | 證據 |
|---|---|---|---|---|
| constructor <code>KlpThemeModePicker</code> | public | <code>const KlpThemeModePicker({ super.key, required this.options, required this.selected, required this.onSelected, })</code> |  | [lib/src/features/workspace/settings/klp_theme_mode_picker.dart:12](../../../../../../lib/src/features/workspace/settings/klp_theme_mode_picker.dart#L12) |
| field <code>options</code> | public | <code>final List&lt;KlpThemeModeOption&gt; options</code> |  | [lib/src/features/workspace/settings/klp_theme_mode_picker.dart:19](../../../../../../lib/src/features/workspace/settings/klp_theme_mode_picker.dart#L19) |
| field <code>selected</code> | public | <code>final KlpThemePreviewMode selected</code> |  | [lib/src/features/workspace/settings/klp_theme_mode_picker.dart:20](../../../../../../lib/src/features/workspace/settings/klp_theme_mode_picker.dart#L20) |
| field <code>onSelected</code> | public | <code>final ValueChanged&lt;KlpThemePreviewMode&gt; onSelected</code> |  | [lib/src/features/workspace/settings/klp_theme_mode_picker.dart:21](../../../../../../lib/src/features/workspace/settings/klp_theme_mode_picker.dart#L21) |
| method <code>build</code> | public | <code>Widget build(BuildContext context)</code> |  | [lib/src/features/workspace/settings/klp_theme_mode_picker.dart:23](../../../../../../lib/src/features/workspace/settings/klp_theme_mode_picker.dart#L23) |

## 閱讀說明與限制

箭頭只表示來源明寫的靜態關係；import 不等於呼叫。未分析動態呼叫、欄位的實際物件擁有權、狀態轉移或渲染流程；型別未進行語意解析，繼承目標保留原始型別拼寫。public／private 依 Dart 名稱前綴判斷；public 宣告不代表已由 `lib/kallopis.dart` 匯出。

本頁由 `tool/architecture_atlas` 產生；編輯來源或生成工具後重新產生，避免手改本頁。
