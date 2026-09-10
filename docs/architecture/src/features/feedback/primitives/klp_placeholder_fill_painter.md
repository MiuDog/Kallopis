# klp_placeholder_fill_painter.dart：直接依賴與宣告架構

[回到目錄](README.md) · [來源檔案](../../../../../../lib/src/features/feedback/primitives/klp_placeholder_fill_painter.dart)

## 範圍

核心是 `lib/src/features/feedback/primitives/klp_placeholder_fill_painter.dart`。主要視角為該檔案明寫的 import／export／part；輔助視角為本檔宣告及 extends／implements／with／on 關係。只展開一層外部邊界。

## 直接依賴圖

```mermaid
flowchart TD
	n0["klp_placeholder_fill_painter.dart"]
	n1["../klp_region_placeholder.dart"]
	n0 -->|"part of"| n1
```

## 依賴證據

| 關係 | 原始 directive | 來源 |
|---|---|---|
| part of | <code>part of &#x27;../klp_region_placeholder.dart&#x27;;</code> | [lib/src/features/feedback/primitives/klp_placeholder_fill_painter.dart:1](../../../../../../lib/src/features/feedback/primitives/klp_placeholder_fill_painter.dart#L1) |

## 宣告關係圖

本組節點是本檔宣告；沒有箭頭的宣告未在此圖主張互相依賴。

```mermaid
classDiagram
	class n0["_KlpPlaceholderFillPainter"]
```

```mermaid
classDiagram
	class n0["_KlpPlaceholderFillPainter"]
	class n1["CustomPainter"]
	n0 --|> n1 : extends
```


## 宣告與成員證據

成員包含 public 與 private；簽章取自來源，省略函式本體與欄位初始值。`(inferred)` 表示來源未明寫型別；建構子只顯示參數部分，不含初始化列表。

### _KlpPlaceholderFillPainter

ClassDeclaration · private · [lib/src/features/feedback/primitives/klp_placeholder_fill_painter.dart:3](../../../../../../lib/src/features/feedback/primitives/klp_placeholder_fill_painter.dart#L3)

<code>class _KlpPlaceholderFillPainter extends CustomPainter</code>

來源註解摘要：繪製 Placeholder 的底色與斜線填充。

- `extends` → <code>CustomPainter</code>：[lib/src/features/feedback/primitives/klp_placeholder_fill_painter.dart:4](../../../../../../lib/src/features/feedback/primitives/klp_placeholder_fill_painter.dart#L4)

| 成員 | 可見性 | 簽章／型別 | 來源註解摘要 | 證據 |
|---|---|---|---|---|
| constructor <code>_KlpPlaceholderFillPainter</code> | private | <code>const _KlpPlaceholderFillPainter({ required this.fillColor, required this.hatchColor, required this.hatched, required this.hatchBand, required this.hatchGap, })</code> |  | [lib/src/features/feedback/primitives/klp_placeholder_fill_painter.dart:5](../../../../../../lib/src/features/feedback/primitives/klp_placeholder_fill_painter.dart#L5) |
| field <code>fillColor</code> | public | <code>final Color fillColor</code> |  | [lib/src/features/feedback/primitives/klp_placeholder_fill_painter.dart:13](../../../../../../lib/src/features/feedback/primitives/klp_placeholder_fill_painter.dart#L13) |
| field <code>hatchColor</code> | public | <code>final Color hatchColor</code> |  | [lib/src/features/feedback/primitives/klp_placeholder_fill_painter.dart:14](../../../../../../lib/src/features/feedback/primitives/klp_placeholder_fill_painter.dart#L14) |
| field <code>hatched</code> | public | <code>final bool hatched</code> |  | [lib/src/features/feedback/primitives/klp_placeholder_fill_painter.dart:15](../../../../../../lib/src/features/feedback/primitives/klp_placeholder_fill_painter.dart#L15) |
| field <code>hatchBand</code> | public | <code>final double hatchBand</code> |  | [lib/src/features/feedback/primitives/klp_placeholder_fill_painter.dart:16](../../../../../../lib/src/features/feedback/primitives/klp_placeholder_fill_painter.dart#L16) |
| field <code>hatchGap</code> | public | <code>final double hatchGap</code> |  | [lib/src/features/feedback/primitives/klp_placeholder_fill_painter.dart:17](../../../../../../lib/src/features/feedback/primitives/klp_placeholder_fill_painter.dart#L17) |
| method <code>paint</code> | public | <code>void paint(Canvas canvas, Size size)</code> |  | [lib/src/features/feedback/primitives/klp_placeholder_fill_painter.dart:19](../../../../../../lib/src/features/feedback/primitives/klp_placeholder_fill_painter.dart#L19) |
| method <code>shouldRepaint</code> | public | <code>bool shouldRepaint(covariant _KlpPlaceholderFillPainter oldDelegate)</code> |  | [lib/src/features/feedback/primitives/klp_placeholder_fill_painter.dart:49](../../../../../../lib/src/features/feedback/primitives/klp_placeholder_fill_painter.dart#L49) |

## 閱讀說明與限制

箭頭只表示來源明寫的靜態關係；import 不等於呼叫。未分析動態呼叫、欄位的實際物件擁有權、狀態轉移或渲染流程；型別未進行語意解析，繼承目標保留原始型別拼寫。public／private 依 Dart 名稱前綴判斷；public 宣告不代表已由 `lib/kallopis.dart` 匯出。

本頁由 `tool/architecture_atlas` 產生；編輯來源或生成工具後重新產生，避免手改本頁。
