# klp_advanced_style.dart：直接依賴與宣告架構

[回到目錄](README.md) · [來源檔案](../../../../../../../lib/src/features/collections/advanced/primitives/klp_advanced_style.dart)

## 範圍

核心是 `lib/src/features/collections/advanced/primitives/klp_advanced_style.dart`。主要視角為該檔案明寫的 import／export／part；輔助視角為本檔宣告及 extends／implements／with／on 關係。只展開一層外部邊界。

## 直接依賴圖

```mermaid
flowchart TD
	n0["klp_advanced_style.dart"]
	n1["../klp_advanced_data.dart"]
	n0 -->|"part of"| n1
```

## 依賴證據

| 關係 | 原始 directive | 來源 |
|---|---|---|
| part of | <code>part of &#x27;../klp_advanced_data.dart&#x27;;</code> | [lib/src/features/collections/advanced/primitives/klp_advanced_style.dart:1](../../../../../../../lib/src/features/collections/advanced/primitives/klp_advanced_style.dart#L1) |

## 宣告關係圖

本組節點是本檔宣告；沒有箭頭的宣告未在此圖主張互相依賴。

```mermaid
classDiagram
	class n0["_KlpAdvancedStyle"]
```


## 宣告與成員證據

成員包含 public 與 private；簽章取自來源，省略函式本體與欄位初始值。`(inferred)` 表示來源未明寫型別；建構子只顯示參數部分，不含初始化列表。

### _KlpAdvancedStyle

ClassDeclaration · private · [lib/src/features/collections/advanced/primitives/klp_advanced_style.dart:3](../../../../../../../lib/src/features/collections/advanced/primitives/klp_advanced_style.dart#L3)

<code>class _KlpAdvancedStyle</code>


| 成員 | 可見性 | 簽章／型別 | 來源註解摘要 | 證據 |
|---|---|---|---|---|
| constructor <code>_KlpAdvancedStyle</code> | private | <code>const _KlpAdvancedStyle({ required this.component, required this.surfaceInset, required this.surfaceMuted, required this.divider, required this.text, required this.textMuted, required this.textFaint, required this.selectionForeground, required this.warning, required this.info, required this.success, required this.danger, required this.cardRadius, required this.controlRadius, required this.strokeWidth, required this.controlHeight, required this.controlHeightLarge, required this.controlInset, required this.contentInset, required this.baseSpace, required this.tightSpace, required this.comfortableSpace, required this.inlineGap, required this.iconSize, required this.iconSmall, required this.treeLeadingGap, required this.filePreviewHeight, required this.statusRowOpacity, required this.statusRowSelectedOpacity, })</code> |  | [lib/src/features/collections/advanced/primitives/klp_advanced_style.dart:4](../../../../../../../lib/src/features/collections/advanced/primitives/klp_advanced_style.dart#L4) |
| constructor <code>from</code> | public | <code>factory _KlpAdvancedStyle.from(BuildContext context)</code> |  | [lib/src/features/collections/advanced/primitives/klp_advanced_style.dart:36](../../../../../../../lib/src/features/collections/advanced/primitives/klp_advanced_style.dart#L36) |
| field <code>component</code> | public | <code>final Color component</code> |  | [lib/src/features/collections/advanced/primitives/klp_advanced_style.dart:79](../../../../../../../lib/src/features/collections/advanced/primitives/klp_advanced_style.dart#L79) |
| field <code>surfaceInset</code> | public | <code>final Color surfaceInset</code> |  | [lib/src/features/collections/advanced/primitives/klp_advanced_style.dart:80](../../../../../../../lib/src/features/collections/advanced/primitives/klp_advanced_style.dart#L80) |
| field <code>surfaceMuted</code> | public | <code>final Color surfaceMuted</code> |  | [lib/src/features/collections/advanced/primitives/klp_advanced_style.dart:81](../../../../../../../lib/src/features/collections/advanced/primitives/klp_advanced_style.dart#L81) |
| field <code>divider</code> | public | <code>final Color divider</code> |  | [lib/src/features/collections/advanced/primitives/klp_advanced_style.dart:82](../../../../../../../lib/src/features/collections/advanced/primitives/klp_advanced_style.dart#L82) |
| field <code>text</code> | public | <code>final Color text</code> |  | [lib/src/features/collections/advanced/primitives/klp_advanced_style.dart:83](../../../../../../../lib/src/features/collections/advanced/primitives/klp_advanced_style.dart#L83) |
| field <code>textMuted</code> | public | <code>final Color textMuted</code> |  | [lib/src/features/collections/advanced/primitives/klp_advanced_style.dart:84](../../../../../../../lib/src/features/collections/advanced/primitives/klp_advanced_style.dart#L84) |
| field <code>textFaint</code> | public | <code>final Color textFaint</code> |  | [lib/src/features/collections/advanced/primitives/klp_advanced_style.dart:85](../../../../../../../lib/src/features/collections/advanced/primitives/klp_advanced_style.dart#L85) |
| field <code>selectionForeground</code> | public | <code>final Color selectionForeground</code> |  | [lib/src/features/collections/advanced/primitives/klp_advanced_style.dart:86](../../../../../../../lib/src/features/collections/advanced/primitives/klp_advanced_style.dart#L86) |
| field <code>warning</code> | public | <code>final Color warning</code> |  | [lib/src/features/collections/advanced/primitives/klp_advanced_style.dart:87](../../../../../../../lib/src/features/collections/advanced/primitives/klp_advanced_style.dart#L87) |
| field <code>info</code> | public | <code>final Color info</code> |  | [lib/src/features/collections/advanced/primitives/klp_advanced_style.dart:88](../../../../../../../lib/src/features/collections/advanced/primitives/klp_advanced_style.dart#L88) |
| field <code>success</code> | public | <code>final Color success</code> |  | [lib/src/features/collections/advanced/primitives/klp_advanced_style.dart:89](../../../../../../../lib/src/features/collections/advanced/primitives/klp_advanced_style.dart#L89) |
| field <code>danger</code> | public | <code>final Color danger</code> |  | [lib/src/features/collections/advanced/primitives/klp_advanced_style.dart:90](../../../../../../../lib/src/features/collections/advanced/primitives/klp_advanced_style.dart#L90) |
| field <code>cardRadius</code> | public | <code>final double cardRadius</code> |  | [lib/src/features/collections/advanced/primitives/klp_advanced_style.dart:91](../../../../../../../lib/src/features/collections/advanced/primitives/klp_advanced_style.dart#L91) |
| field <code>controlRadius</code> | public | <code>final double controlRadius</code> |  | [lib/src/features/collections/advanced/primitives/klp_advanced_style.dart:92](../../../../../../../lib/src/features/collections/advanced/primitives/klp_advanced_style.dart#L92) |
| field <code>strokeWidth</code> | public | <code>final double strokeWidth</code> |  | [lib/src/features/collections/advanced/primitives/klp_advanced_style.dart:93](../../../../../../../lib/src/features/collections/advanced/primitives/klp_advanced_style.dart#L93) |
| field <code>controlHeight</code> | public | <code>final double controlHeight</code> |  | [lib/src/features/collections/advanced/primitives/klp_advanced_style.dart:94](../../../../../../../lib/src/features/collections/advanced/primitives/klp_advanced_style.dart#L94) |
| field <code>controlHeightLarge</code> | public | <code>final double controlHeightLarge</code> |  | [lib/src/features/collections/advanced/primitives/klp_advanced_style.dart:95](../../../../../../../lib/src/features/collections/advanced/primitives/klp_advanced_style.dart#L95) |
| field <code>controlInset</code> | public | <code>final double controlInset</code> |  | [lib/src/features/collections/advanced/primitives/klp_advanced_style.dart:96](../../../../../../../lib/src/features/collections/advanced/primitives/klp_advanced_style.dart#L96) |
| field <code>contentInset</code> | public | <code>final double contentInset</code> |  | [lib/src/features/collections/advanced/primitives/klp_advanced_style.dart:97](../../../../../../../lib/src/features/collections/advanced/primitives/klp_advanced_style.dart#L97) |
| field <code>baseSpace</code> | public | <code>final double baseSpace</code> |  | [lib/src/features/collections/advanced/primitives/klp_advanced_style.dart:98](../../../../../../../lib/src/features/collections/advanced/primitives/klp_advanced_style.dart#L98) |
| field <code>tightSpace</code> | public | <code>final double tightSpace</code> |  | [lib/src/features/collections/advanced/primitives/klp_advanced_style.dart:99](../../../../../../../lib/src/features/collections/advanced/primitives/klp_advanced_style.dart#L99) |
| field <code>comfortableSpace</code> | public | <code>final double comfortableSpace</code> |  | [lib/src/features/collections/advanced/primitives/klp_advanced_style.dart:100](../../../../../../../lib/src/features/collections/advanced/primitives/klp_advanced_style.dart#L100) |
| field <code>inlineGap</code> | public | <code>final double inlineGap</code> |  | [lib/src/features/collections/advanced/primitives/klp_advanced_style.dart:101](../../../../../../../lib/src/features/collections/advanced/primitives/klp_advanced_style.dart#L101) |
| field <code>iconSize</code> | public | <code>final double iconSize</code> |  | [lib/src/features/collections/advanced/primitives/klp_advanced_style.dart:102](../../../../../../../lib/src/features/collections/advanced/primitives/klp_advanced_style.dart#L102) |
| field <code>iconSmall</code> | public | <code>final double iconSmall</code> |  | [lib/src/features/collections/advanced/primitives/klp_advanced_style.dart:103](../../../../../../../lib/src/features/collections/advanced/primitives/klp_advanced_style.dart#L103) |
| field <code>treeLeadingGap</code> | public | <code>final double treeLeadingGap</code> |  | [lib/src/features/collections/advanced/primitives/klp_advanced_style.dart:104](../../../../../../../lib/src/features/collections/advanced/primitives/klp_advanced_style.dart#L104) |
| field <code>filePreviewHeight</code> | public | <code>final double filePreviewHeight</code> |  | [lib/src/features/collections/advanced/primitives/klp_advanced_style.dart:105](../../../../../../../lib/src/features/collections/advanced/primitives/klp_advanced_style.dart#L105) |
| field <code>statusRowOpacity</code> | public | <code>final double statusRowOpacity</code> |  | [lib/src/features/collections/advanced/primitives/klp_advanced_style.dart:106](../../../../../../../lib/src/features/collections/advanced/primitives/klp_advanced_style.dart#L106) |
| field <code>statusRowSelectedOpacity</code> | public | <code>final double statusRowSelectedOpacity</code> |  | [lib/src/features/collections/advanced/primitives/klp_advanced_style.dart:107](../../../../../../../lib/src/features/collections/advanced/primitives/klp_advanced_style.dart#L107) |

## 閱讀說明與限制

箭頭只表示來源明寫的靜態關係；import 不等於呼叫。未分析動態呼叫、欄位的實際物件擁有權、狀態轉移或渲染流程；型別未進行語意解析，繼承目標保留原始型別拼寫。public／private 依 Dart 名稱前綴判斷；public 宣告不代表已由 `lib/kallopis.dart` 匯出。

本頁由 `tool/architecture_atlas` 產生；編輯來源或生成工具後重新產生，避免手改本頁。
