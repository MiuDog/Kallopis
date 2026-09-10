# klp_data_geometry.dart：直接依賴與宣告架構

[回到目錄](README.md) · [來源檔案](../../../../../lib/src/styling/legacy_theme/klp_data_geometry.dart)

## 範圍

核心是 `lib/src/styling/legacy_theme/klp_data_geometry.dart`。主要視角為該檔案明寫的 import／export／part；輔助視角為本檔宣告及 extends／implements／with／on 關係。只展開一層外部邊界。

## 直接依賴圖

```mermaid
flowchart TD
	n0["klp_data_geometry.dart"]
	n1["package:flutter/foundation.dart"]
	n0 -->|"import"| n1
```

## 依賴證據

| 關係 | 原始 directive | 來源 |
|---|---|---|
| import | <code>import &#x27;package:flutter/foundation.dart&#x27;;</code> | [lib/src/styling/legacy_theme/klp_data_geometry.dart:1](../../../../../lib/src/styling/legacy_theme/klp_data_geometry.dart#L1) |

## 宣告關係圖

本組節點是本檔宣告；沒有箭頭的宣告未在此圖主張互相依賴。

```mermaid
classDiagram
	class n0["KlpDataGeometry"]
```


## 宣告與成員證據

成員包含 public 與 private；簽章取自來源，省略函式本體與欄位初始值。`(inferred)` 表示來源未明寫型別；建構子只顯示參數部分，不含初始化列表。

### KlpDataGeometry

ClassDeclaration · public · [lib/src/styling/legacy_theme/klp_data_geometry.dart:3](../../../../../lib/src/styling/legacy_theme/klp_data_geometry.dart#L3)

<code>class KlpDataGeometry</code>

來源註解摘要：程式碼、placeholder 與資料型元件的精確幾何。


| 成員 | 可見性 | 簽章／型別 | 來源註解摘要 | 證據 |
|---|---|---|---|---|
| constructor <code>KlpDataGeometry</code> | public | <code>const KlpDataGeometry({ required this.codeActionButtonSize, required this.codeHeaderHeight, required this.codeTerminalDot, required this.codeTerminalDotGap, required this.codeHeaderPaddingX, required this.codeBodyPaddingX, required this.codeLineNumberWidth, required this.codeWrappedLineWidth, required this.codeMaximumHeight, required this.codeCollapsedHeight, required this.codeDisclosureSize, required this.filePreviewHeight, required this.previewCardCompactHeight, required this.previewCardStandardHeight, required this.previewCardLargeHeight, required this.dateGridCellHeight, required this.keyValueLabelWidthCompact, required this.keyValueLabelWidthStandard, required this.stepperMarkerSize, required this.stepperLabelWidth, required this.progressIndeterminateFraction, required this.placeholderMinimumHeight, required this.placeholderContentPaddingY, required this.placeholderActionPaddingY, required this.placeholderHatchBand, required this.placeholderHatchGap, required this.placeholderLabelTracking, required this.placeholderDetailMaximumWidth, required this.spinnerSquareFactor, required this.spinnerOrbitFactor, required this.spinnerCornerFactor, })</code> |  | [lib/src/styling/legacy_theme/klp_data_geometry.dart:6](../../../../../lib/src/styling/legacy_theme/klp_data_geometry.dart#L6) |
| field <code>codeActionButtonSize</code> | public | <code>final double codeActionButtonSize</code> |  | [lib/src/styling/legacy_theme/klp_data_geometry.dart:40](../../../../../lib/src/styling/legacy_theme/klp_data_geometry.dart#L40) |
| field <code>codeHeaderHeight</code> | public | <code>final double codeHeaderHeight</code> |  | [lib/src/styling/legacy_theme/klp_data_geometry.dart:41](../../../../../lib/src/styling/legacy_theme/klp_data_geometry.dart#L41) |
| field <code>codeTerminalDot</code> | public | <code>final double codeTerminalDot</code> |  | [lib/src/styling/legacy_theme/klp_data_geometry.dart:42](../../../../../lib/src/styling/legacy_theme/klp_data_geometry.dart#L42) |
| field <code>codeTerminalDotGap</code> | public | <code>final double codeTerminalDotGap</code> |  | [lib/src/styling/legacy_theme/klp_data_geometry.dart:43](../../../../../lib/src/styling/legacy_theme/klp_data_geometry.dart#L43) |
| field <code>codeHeaderPaddingX</code> | public | <code>final double codeHeaderPaddingX</code> |  | [lib/src/styling/legacy_theme/klp_data_geometry.dart:44](../../../../../lib/src/styling/legacy_theme/klp_data_geometry.dart#L44) |
| field <code>codeBodyPaddingX</code> | public | <code>final double codeBodyPaddingX</code> |  | [lib/src/styling/legacy_theme/klp_data_geometry.dart:45](../../../../../lib/src/styling/legacy_theme/klp_data_geometry.dart#L45) |
| field <code>codeLineNumberWidth</code> | public | <code>final double codeLineNumberWidth</code> |  | [lib/src/styling/legacy_theme/klp_data_geometry.dart:46](../../../../../lib/src/styling/legacy_theme/klp_data_geometry.dart#L46) |
| field <code>codeWrappedLineWidth</code> | public | <code>final double codeWrappedLineWidth</code> |  | [lib/src/styling/legacy_theme/klp_data_geometry.dart:47](../../../../../lib/src/styling/legacy_theme/klp_data_geometry.dart#L47) |
| field <code>codeMaximumHeight</code> | public | <code>final double codeMaximumHeight</code> |  | [lib/src/styling/legacy_theme/klp_data_geometry.dart:48](../../../../../lib/src/styling/legacy_theme/klp_data_geometry.dart#L48) |
| field <code>codeCollapsedHeight</code> | public | <code>final double codeCollapsedHeight</code> |  | [lib/src/styling/legacy_theme/klp_data_geometry.dart:49](../../../../../lib/src/styling/legacy_theme/klp_data_geometry.dart#L49) |
| field <code>codeDisclosureSize</code> | public | <code>final double codeDisclosureSize</code> |  | [lib/src/styling/legacy_theme/klp_data_geometry.dart:50](../../../../../lib/src/styling/legacy_theme/klp_data_geometry.dart#L50) |
| field <code>filePreviewHeight</code> | public | <code>final double filePreviewHeight</code> |  | [lib/src/styling/legacy_theme/klp_data_geometry.dart:51](../../../../../lib/src/styling/legacy_theme/klp_data_geometry.dart#L51) |
| field <code>previewCardCompactHeight</code> | public | <code>final double previewCardCompactHeight</code> |  | [lib/src/styling/legacy_theme/klp_data_geometry.dart:52](../../../../../lib/src/styling/legacy_theme/klp_data_geometry.dart#L52) |
| field <code>previewCardStandardHeight</code> | public | <code>final double previewCardStandardHeight</code> |  | [lib/src/styling/legacy_theme/klp_data_geometry.dart:53](../../../../../lib/src/styling/legacy_theme/klp_data_geometry.dart#L53) |
| field <code>previewCardLargeHeight</code> | public | <code>final double previewCardLargeHeight</code> |  | [lib/src/styling/legacy_theme/klp_data_geometry.dart:54](../../../../../lib/src/styling/legacy_theme/klp_data_geometry.dart#L54) |
| field <code>dateGridCellHeight</code> | public | <code>final double dateGridCellHeight</code> |  | [lib/src/styling/legacy_theme/klp_data_geometry.dart:55](../../../../../lib/src/styling/legacy_theme/klp_data_geometry.dart#L55) |
| field <code>keyValueLabelWidthCompact</code> | public | <code>final double keyValueLabelWidthCompact</code> |  | [lib/src/styling/legacy_theme/klp_data_geometry.dart:56](../../../../../lib/src/styling/legacy_theme/klp_data_geometry.dart#L56) |
| field <code>keyValueLabelWidthStandard</code> | public | <code>final double keyValueLabelWidthStandard</code> |  | [lib/src/styling/legacy_theme/klp_data_geometry.dart:57](../../../../../lib/src/styling/legacy_theme/klp_data_geometry.dart#L57) |
| field <code>stepperMarkerSize</code> | public | <code>final double stepperMarkerSize</code> |  | [lib/src/styling/legacy_theme/klp_data_geometry.dart:58](../../../../../lib/src/styling/legacy_theme/klp_data_geometry.dart#L58) |
| field <code>stepperLabelWidth</code> | public | <code>final double stepperLabelWidth</code> |  | [lib/src/styling/legacy_theme/klp_data_geometry.dart:59](../../../../../lib/src/styling/legacy_theme/klp_data_geometry.dart#L59) |
| field <code>progressIndeterminateFraction</code> | public | <code>final double progressIndeterminateFraction</code> |  | [lib/src/styling/legacy_theme/klp_data_geometry.dart:60](../../../../../lib/src/styling/legacy_theme/klp_data_geometry.dart#L60) |
| field <code>placeholderMinimumHeight</code> | public | <code>final double placeholderMinimumHeight</code> |  | [lib/src/styling/legacy_theme/klp_data_geometry.dart:61](../../../../../lib/src/styling/legacy_theme/klp_data_geometry.dart#L61) |
| field <code>placeholderContentPaddingY</code> | public | <code>final double placeholderContentPaddingY</code> |  | [lib/src/styling/legacy_theme/klp_data_geometry.dart:62](../../../../../lib/src/styling/legacy_theme/klp_data_geometry.dart#L62) |
| field <code>placeholderActionPaddingY</code> | public | <code>final double placeholderActionPaddingY</code> |  | [lib/src/styling/legacy_theme/klp_data_geometry.dart:63](../../../../../lib/src/styling/legacy_theme/klp_data_geometry.dart#L63) |
| field <code>placeholderHatchBand</code> | public | <code>final double placeholderHatchBand</code> |  | [lib/src/styling/legacy_theme/klp_data_geometry.dart:64](../../../../../lib/src/styling/legacy_theme/klp_data_geometry.dart#L64) |
| field <code>placeholderHatchGap</code> | public | <code>final double placeholderHatchGap</code> |  | [lib/src/styling/legacy_theme/klp_data_geometry.dart:65](../../../../../lib/src/styling/legacy_theme/klp_data_geometry.dart#L65) |
| field <code>placeholderLabelTracking</code> | public | <code>final double placeholderLabelTracking</code> |  | [lib/src/styling/legacy_theme/klp_data_geometry.dart:66](../../../../../lib/src/styling/legacy_theme/klp_data_geometry.dart#L66) |
| field <code>placeholderDetailMaximumWidth</code> | public | <code>final double placeholderDetailMaximumWidth</code> |  | [lib/src/styling/legacy_theme/klp_data_geometry.dart:67](../../../../../lib/src/styling/legacy_theme/klp_data_geometry.dart#L67) |
| field <code>spinnerSquareFactor</code> | public | <code>final double spinnerSquareFactor</code> |  | [lib/src/styling/legacy_theme/klp_data_geometry.dart:68](../../../../../lib/src/styling/legacy_theme/klp_data_geometry.dart#L68) |
| field <code>spinnerOrbitFactor</code> | public | <code>final double spinnerOrbitFactor</code> |  | [lib/src/styling/legacy_theme/klp_data_geometry.dart:69](../../../../../lib/src/styling/legacy_theme/klp_data_geometry.dart#L69) |
| field <code>spinnerCornerFactor</code> | public | <code>final double spinnerCornerFactor</code> |  | [lib/src/styling/legacy_theme/klp_data_geometry.dart:70](../../../../../lib/src/styling/legacy_theme/klp_data_geometry.dart#L70) |
| method <code>==</code> | public | <code>bool operator ==(Object other)</code> |  | [lib/src/styling/legacy_theme/klp_data_geometry.dart:72](../../../../../lib/src/styling/legacy_theme/klp_data_geometry.dart#L72) |
| getter <code>hashCode</code> | public | <code>int get hashCode</code> |  | [lib/src/styling/legacy_theme/klp_data_geometry.dart:110](../../../../../lib/src/styling/legacy_theme/klp_data_geometry.dart#L110) |

## 閱讀說明與限制

箭頭只表示來源明寫的靜態關係；import 不等於呼叫。未分析動態呼叫、欄位的實際物件擁有權、狀態轉移或渲染流程；型別未進行語意解析，繼承目標保留原始型別拼寫。public／private 依 Dart 名稱前綴判斷；public 宣告不代表已由 `lib/kallopis.dart` 匯出。

本頁由 `tool/architecture_atlas` 產生；編輯來源或生成工具後重新產生，避免手改本頁。
