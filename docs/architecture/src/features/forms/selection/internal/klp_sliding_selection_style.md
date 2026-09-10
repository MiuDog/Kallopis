# klp_sliding_selection_style.dart：直接依賴與宣告架構

[回到目錄](README.md) · [來源檔案](../../../../../../../lib/src/features/forms/selection/internal/klp_sliding_selection_style.dart)

## 範圍

核心是 `lib/src/features/forms/selection/internal/klp_sliding_selection_style.dart`。主要視角為該檔案明寫的 import／export／part；輔助視角為本檔宣告及 extends／implements／with／on 關係。只展開一層外部邊界。

## 直接依賴圖

```mermaid
flowchart TD
	n0["klp_sliding_selection_style.dart"]
	n1["../klp_sliding_selection.dart"]
	n0 -->|"part of"| n1
```

## 依賴證據

| 關係 | 原始 directive | 來源 |
|---|---|---|
| part of | <code>part of &#x27;../klp_sliding_selection.dart&#x27;;</code> | [lib/src/features/forms/selection/internal/klp_sliding_selection_style.dart:1](../../../../../../../lib/src/features/forms/selection/internal/klp_sliding_selection_style.dart#L1) |

## 宣告關係圖

本組節點是本檔宣告；沒有箭頭的宣告未在此圖主張互相依賴。

```mermaid
classDiagram
	class n0["_KlpSlidingSelectionStyle"]
```


## 宣告與成員證據

成員包含 public 與 private；簽章取自來源，省略函式本體與欄位初始值。`(inferred)` 表示來源未明寫型別；建構子只顯示參數部分，不含初始化列表。

### _KlpSlidingSelectionStyle

ClassDeclaration · private · [lib/src/features/forms/selection/internal/klp_sliding_selection_style.dart:3](../../../../../../../lib/src/features/forms/selection/internal/klp_sliding_selection_style.dart#L3)

<code>class _KlpSlidingSelectionStyle</code>


| 成員 | 可見性 | 簽章／型別 | 來源註解摘要 | 證據 |
|---|---|---|---|---|
| constructor <code>_KlpSlidingSelectionStyle</code> | private | <code>const _KlpSlidingSelectionStyle({ required this.toneColors, required this.surfaceColor, required this.dividerColor, required this.mutedColor, required this.clearColor, required this.controlHeight, required this.segmentWidth, required this.padding, required this.borderWidth, required this.indicatorHeight, required this.controlRadius, required this.indicatorRadius, required this.statusFillOpacity, required this.stateDuration, required this.styleDuration, required this.curve, })</code> |  | [lib/src/features/forms/selection/internal/klp_sliding_selection_style.dart:4](../../../../../../../lib/src/features/forms/selection/internal/klp_sliding_selection_style.dart#L4) |
| field <code>toneColors</code> | public | <code>final Map&lt;KlpSelectionTone, Color&gt; toneColors</code> |  | [lib/src/features/forms/selection/internal/klp_sliding_selection_style.dart:23](../../../../../../../lib/src/features/forms/selection/internal/klp_sliding_selection_style.dart#L23) |
| field <code>surfaceColor</code> | public | <code>final Color surfaceColor</code> |  | [lib/src/features/forms/selection/internal/klp_sliding_selection_style.dart:24](../../../../../../../lib/src/features/forms/selection/internal/klp_sliding_selection_style.dart#L24) |
| field <code>dividerColor</code> | public | <code>final Color dividerColor</code> |  | [lib/src/features/forms/selection/internal/klp_sliding_selection_style.dart:25](../../../../../../../lib/src/features/forms/selection/internal/klp_sliding_selection_style.dart#L25) |
| field <code>mutedColor</code> | public | <code>final Color mutedColor</code> |  | [lib/src/features/forms/selection/internal/klp_sliding_selection_style.dart:26](../../../../../../../lib/src/features/forms/selection/internal/klp_sliding_selection_style.dart#L26) |
| field <code>clearColor</code> | public | <code>final Color clearColor</code> |  | [lib/src/features/forms/selection/internal/klp_sliding_selection_style.dart:27](../../../../../../../lib/src/features/forms/selection/internal/klp_sliding_selection_style.dart#L27) |
| field <code>controlHeight</code> | public | <code>final double controlHeight</code> |  | [lib/src/features/forms/selection/internal/klp_sliding_selection_style.dart:28](../../../../../../../lib/src/features/forms/selection/internal/klp_sliding_selection_style.dart#L28) |
| field <code>segmentWidth</code> | public | <code>final double segmentWidth</code> |  | [lib/src/features/forms/selection/internal/klp_sliding_selection_style.dart:29](../../../../../../../lib/src/features/forms/selection/internal/klp_sliding_selection_style.dart#L29) |
| field <code>padding</code> | public | <code>final double padding</code> |  | [lib/src/features/forms/selection/internal/klp_sliding_selection_style.dart:30](../../../../../../../lib/src/features/forms/selection/internal/klp_sliding_selection_style.dart#L30) |
| field <code>borderWidth</code> | public | <code>final double borderWidth</code> |  | [lib/src/features/forms/selection/internal/klp_sliding_selection_style.dart:31](../../../../../../../lib/src/features/forms/selection/internal/klp_sliding_selection_style.dart#L31) |
| field <code>indicatorHeight</code> | public | <code>final double indicatorHeight</code> |  | [lib/src/features/forms/selection/internal/klp_sliding_selection_style.dart:32](../../../../../../../lib/src/features/forms/selection/internal/klp_sliding_selection_style.dart#L32) |
| field <code>controlRadius</code> | public | <code>final double controlRadius</code> |  | [lib/src/features/forms/selection/internal/klp_sliding_selection_style.dart:33](../../../../../../../lib/src/features/forms/selection/internal/klp_sliding_selection_style.dart#L33) |
| field <code>indicatorRadius</code> | public | <code>final double indicatorRadius</code> |  | [lib/src/features/forms/selection/internal/klp_sliding_selection_style.dart:34](../../../../../../../lib/src/features/forms/selection/internal/klp_sliding_selection_style.dart#L34) |
| field <code>statusFillOpacity</code> | public | <code>final double statusFillOpacity</code> |  | [lib/src/features/forms/selection/internal/klp_sliding_selection_style.dart:35](../../../../../../../lib/src/features/forms/selection/internal/klp_sliding_selection_style.dart#L35) |
| field <code>stateDuration</code> | public | <code>final Duration stateDuration</code> |  | [lib/src/features/forms/selection/internal/klp_sliding_selection_style.dart:36](../../../../../../../lib/src/features/forms/selection/internal/klp_sliding_selection_style.dart#L36) |
| field <code>styleDuration</code> | public | <code>final Duration styleDuration</code> |  | [lib/src/features/forms/selection/internal/klp_sliding_selection_style.dart:37](../../../../../../../lib/src/features/forms/selection/internal/klp_sliding_selection_style.dart#L37) |
| field <code>curve</code> | public | <code>final Curve curve</code> |  | [lib/src/features/forms/selection/internal/klp_sliding_selection_style.dart:38](../../../../../../../lib/src/features/forms/selection/internal/klp_sliding_selection_style.dart#L38) |
| method <code>totalWidth</code> | public | <code>double totalWidth(int optionCount)</code> |  | [lib/src/features/forms/selection/internal/klp_sliding_selection_style.dart:40](../../../../../../../lib/src/features/forms/selection/internal/klp_sliding_selection_style.dart#L40) |
| method <code>toneColor</code> | public | <code>Color toneColor(KlpSelectionTone tone)</code> |  | [lib/src/features/forms/selection/internal/klp_sliding_selection_style.dart:43](../../../../../../../lib/src/features/forms/selection/internal/klp_sliding_selection_style.dart#L43) |
| constructor <code>resolve</code> | public | <code>factory _KlpSlidingSelectionStyle.resolve(KlpTheme klp)</code> |  | [lib/src/features/forms/selection/internal/klp_sliding_selection_style.dart:45](../../../../../../../lib/src/features/forms/selection/internal/klp_sliding_selection_style.dart#L45) |

## 閱讀說明與限制

箭頭只表示來源明寫的靜態關係；import 不等於呼叫。未分析動態呼叫、欄位的實際物件擁有權、狀態轉移或渲染流程；型別未進行語意解析，繼承目標保留原始型別拼寫。public／private 依 Dart 名稱前綴判斷；public 宣告不代表已由 `lib/kallopis.dart` 匯出。

本頁由 `tool/architecture_atlas` 產生；編輯來源或生成工具後重新產生，避免手改本頁。
