# klp_bound_editing_style.dart：直接依賴與宣告架構

[回到目錄](README.md) · [來源檔案](../../../../../../lib/src/features/editing/presentation/klp_bound_editing_style.dart)

## 範圍

核心是 `lib/src/features/editing/presentation/klp_bound_editing_style.dart`。主要視角為該檔案明寫的 import／export／part；輔助視角為本檔宣告及 extends／implements／with／on 關係。只展開一層外部邊界。

## 直接依賴圖

```mermaid
flowchart LR
	n0["klp_bound_editing_style.dart"]
	n1["package:kallopis/src/capabilities/editing/contracts/klp_editing_draw_command.dart"]
	n2["package:kallopis/src/capabilities/editing/contracts/klp_editing_style.dart"]
	n3["package:kallopis/src/styling/primitives/klp_style_value.dart"]
	n4["package:kallopis/src/foundation/binding/contracts/klp_bound_control_style.dart"]
	n0 -->|"import"| n1
	n0 -->|"import"| n2
	n0 -->|"import"| n3
	n0 -->|"import"| n4
```

## 依賴證據

| 關係 | 原始 directive | 來源 |
|---|---|---|
| import | <code>import &#x27;package:kallopis/src/capabilities/editing/contracts/klp_editing_draw_command.dart&#x27;;</code> | [lib/src/features/editing/presentation/klp_bound_editing_style.dart:1](../../../../../../lib/src/features/editing/presentation/klp_bound_editing_style.dart#L1) |
| import | <code>import &#x27;package:kallopis/src/capabilities/editing/contracts/klp_editing_style.dart&#x27;;</code> | [lib/src/features/editing/presentation/klp_bound_editing_style.dart:2](../../../../../../lib/src/features/editing/presentation/klp_bound_editing_style.dart#L2) |
| import | <code>import &#x27;package:kallopis/src/styling/primitives/klp_style_value.dart&#x27;;</code> | [lib/src/features/editing/presentation/klp_bound_editing_style.dart:3](../../../../../../lib/src/features/editing/presentation/klp_bound_editing_style.dart#L3) |
| import | <code>import &#x27;package:kallopis/src/foundation/binding/contracts/klp_bound_control_style.dart&#x27;;</code> | [lib/src/features/editing/presentation/klp_bound_editing_style.dart:4](../../../../../../lib/src/features/editing/presentation/klp_bound_editing_style.dart#L4) |

## 宣告關係圖

本組節點是本檔宣告；沒有箭頭的宣告未在此圖主張互相依賴。

```mermaid
classDiagram
	class n0["KlpBoundEditingStyle"]
```


## 宣告與成員證據

成員包含 public 與 private；簽章取自來源，省略函式本體與欄位初始值。`(inferred)` 表示來源未明寫型別；建構子只顯示參數部分，不含初始化列表。

### KlpBoundEditingStyle

ClassDeclaration · public · [lib/src/features/editing/presentation/klp_bound_editing_style.dart:6](../../../../../../lib/src/features/editing/presentation/klp_bound_editing_style.dart#L6)

<code>final class KlpBoundEditingStyle</code>

來源註解摘要：僅供本庫繫結階段建立，提供者不能指定任何局部色彩。


| 成員 | 可見性 | 簽章／型別 | 來源註解摘要 | 證據 |
|---|---|---|---|---|
| field <code>text</code> | public | <code>final KlpColor text</code> |  | [lib/src/features/editing/presentation/klp_bound_editing_style.dart:9](../../../../../../lib/src/features/editing/presentation/klp_bound_editing_style.dart#L9) |
| field <code>ink</code> | public | <code>final KlpColor ink</code> |  | [lib/src/features/editing/presentation/klp_bound_editing_style.dart:10](../../../../../../lib/src/features/editing/presentation/klp_bound_editing_style.dart#L10) |
| field <code>caret</code> | public | <code>final KlpColor caret</code> |  | [lib/src/features/editing/presentation/klp_bound_editing_style.dart:11](../../../../../../lib/src/features/editing/presentation/klp_bound_editing_style.dart#L11) |
| field <code>selection</code> | public | <code>final KlpColor selection</code> |  | [lib/src/features/editing/presentation/klp_bound_editing_style.dart:12](../../../../../../lib/src/features/editing/presentation/klp_bound_editing_style.dart#L12) |
| field <code>fontFamily</code> | public | <code>final KlpFontFamily fontFamily</code> |  | [lib/src/features/editing/presentation/klp_bound_editing_style.dart:13](../../../../../../lib/src/features/editing/presentation/klp_bound_editing_style.dart#L13) |
| field <code>fontWeight</code> | public | <code>final KlpFontWeight fontWeight</code> |  | [lib/src/features/editing/presentation/klp_bound_editing_style.dart:14](../../../../../../lib/src/features/editing/presentation/klp_bound_editing_style.dart#L14) |
| field <code>fontSize</code> | public | <code>final KlpFontSize fontSize</code> |  | [lib/src/features/editing/presentation/klp_bound_editing_style.dart:15](../../../../../../lib/src/features/editing/presentation/klp_bound_editing_style.dart#L15) |
| field <code>lineHeight</code> | public | <code>final KlpLineHeight lineHeight</code> |  | [lib/src/features/editing/presentation/klp_bound_editing_style.dart:16](../../../../../../lib/src/features/editing/presentation/klp_bound_editing_style.dart#L16) |
| field <code>letterSpacing</code> | public | <code>final KlpLetterSpacing letterSpacing</code> |  | [lib/src/features/editing/presentation/klp_bound_editing_style.dart:17](../../../../../../lib/src/features/editing/presentation/klp_bound_editing_style.dart#L17) |
| field <code>horizontalPadding</code> | public | <code>final KlpDistance horizontalPadding</code> |  | [lib/src/features/editing/presentation/klp_bound_editing_style.dart:18](../../../../../../lib/src/features/editing/presentation/klp_bound_editing_style.dart#L18) |
| field <code>verticalPadding</code> | public | <code>final KlpDistance verticalPadding</code> |  | [lib/src/features/editing/presentation/klp_bound_editing_style.dart:19](../../../../../../lib/src/features/editing/presentation/klp_bound_editing_style.dart#L19) |
| field <code>blockSpacing</code> | public | <code>final KlpDistance blockSpacing</code> |  | [lib/src/features/editing/presentation/klp_bound_editing_style.dart:20](../../../../../../lib/src/features/editing/presentation/klp_bound_editing_style.dart#L20) |
| field <code>overscan</code> | public | <code>final KlpDistance overscan</code> |  | [lib/src/features/editing/presentation/klp_bound_editing_style.dart:21](../../../../../../lib/src/features/editing/presentation/klp_bound_editing_style.dart#L21) |
| field <code>listIndent</code> | public | <code>final KlpDistance listIndent</code> |  | [lib/src/features/editing/presentation/klp_bound_editing_style.dart:22](../../../../../../lib/src/features/editing/presentation/klp_bound_editing_style.dart#L22) |
| field <code>markerGap</code> | public | <code>final KlpDistance markerGap</code> |  | [lib/src/features/editing/presentation/klp_bound_editing_style.dart:23](../../../../../../lib/src/features/editing/presentation/klp_bound_editing_style.dart#L23) |
| field <code>marker</code> | public | <code>final KlpColor marker</code> |  | [lib/src/features/editing/presentation/klp_bound_editing_style.dart:24](../../../../../../lib/src/features/editing/presentation/klp_bound_editing_style.dart#L24) |
| field <code>minimumBodyEm</code> | public | <code>final double minimumBodyEm</code> |  | [lib/src/features/editing/presentation/klp_bound_editing_style.dart:25](../../../../../../lib/src/features/editing/presentation/klp_bound_editing_style.dart#L25) |
| field <code>dragAutoScrollEdge</code> | public | <code>final KlpDistance dragAutoScrollEdge</code> |  | [lib/src/features/editing/presentation/klp_bound_editing_style.dart:26](../../../../../../lib/src/features/editing/presentation/klp_bound_editing_style.dart#L26) |
| field <code>dragAutoScrollStep</code> | public | <code>final KlpDistance dragAutoScrollStep</code> |  | [lib/src/features/editing/presentation/klp_bound_editing_style.dart:27](../../../../../../lib/src/features/editing/presentation/klp_bound_editing_style.dart#L27) |
| field <code>dragAutoScrollInterval</code> | public | <code>final KlpDuration dragAutoScrollInterval</code> |  | [lib/src/features/editing/presentation/klp_bound_editing_style.dart:28](../../../../../../lib/src/features/editing/presentation/klp_bound_editing_style.dart#L28) |
| field <code>control</code> | public | <code>final KlpBoundControlStyle control</code> |  | [lib/src/features/editing/presentation/klp_bound_editing_style.dart:29](../../../../../../lib/src/features/editing/presentation/klp_bound_editing_style.dart#L29) |
| constructor <code>KlpBoundEditingStyle</code> | public | <code>KlpBoundEditingStyle({ required this.text, required this.ink, required this.caret, required this.selection, required this.fontFamily, required this.fontWeight, required this.fontSize, required this.lineHeight, required this.letterSpacing, required this.horizontalPadding, required this.verticalPadding, required this.blockSpacing, required this.overscan, required this.listIndent, required this.markerGap, required this.marker, required this.minimumBodyEm, required this.dragAutoScrollEdge, required this.dragAutoScrollStep, required this.dragAutoScrollInterval, required this.control, })</code> |  | [lib/src/features/editing/presentation/klp_bound_editing_style.dart:31](../../../../../../lib/src/features/editing/presentation/klp_bound_editing_style.dart#L31) |
| getter <code>core</code> | public | <code>KlpEditingStyle get core</code> |  | [lib/src/features/editing/presentation/klp_bound_editing_style.dart:57](../../../../../../lib/src/features/editing/presentation/klp_bound_editing_style.dart#L57) |
| method <code>_rgba</code> | private | <code>int _rgba(KlpColor color)</code> |  | [lib/src/features/editing/presentation/klp_bound_editing_style.dart:78](../../../../../../lib/src/features/editing/presentation/klp_bound_editing_style.dart#L78) |
| method <code>color</code> | public | <code>KlpColor color(KlpEditingPaintRole role)</code> |  | [lib/src/features/editing/presentation/klp_bound_editing_style.dart:80](../../../../../../lib/src/features/editing/presentation/klp_bound_editing_style.dart#L80) |

## 閱讀說明與限制

箭頭只表示來源明寫的靜態關係；import 不等於呼叫。未分析動態呼叫、欄位的實際物件擁有權、狀態轉移或渲染流程；型別未進行語意解析，繼承目標保留原始型別拼寫。public／private 依 Dart 名稱前綴判斷；public 宣告不代表已由 `lib/kallopis.dart` 匯出。

本頁由 `tool/architecture_atlas` 產生；編輯來源或生成工具後重新產生，避免手改本頁。
