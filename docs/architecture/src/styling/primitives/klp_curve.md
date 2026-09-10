# klp_curve.dart：直接依賴與宣告架構

[回到目錄](README.md) · [來源檔案](../../../../../lib/src/styling/primitives/klp_curve.dart)

## 範圍

核心是 `lib/src/styling/primitives/klp_curve.dart`。主要視角為該檔案明寫的 import／export／part；輔助視角為本檔宣告及 extends／implements／with／on 關係。只展開一層外部邊界。

## 直接依賴圖

```mermaid
flowchart TD
	n0["klp_curve.dart"]
	n1["klp_style_value.dart"]
	n0 -->|"part of"| n1
```

## 依賴證據

| 關係 | 原始 directive | 來源 |
|---|---|---|
| part of | <code>part of &#x27;klp_style_value.dart&#x27;;</code> | [lib/src/styling/primitives/klp_curve.dart:1](../../../../../lib/src/styling/primitives/klp_curve.dart#L1) |

## 宣告關係圖

本組節點是本檔宣告；沒有箭頭的宣告未在此圖主張互相依賴。

```mermaid
classDiagram
	class n0["KlpCurve"]
```

```mermaid
classDiagram
	class n0["KlpCurve"]
	class n1["KlpStyleValue"]
	n0 --|> n1 : extends
```


## 宣告與成員證據

成員包含 public 與 private；簽章取自來源，省略函式本體與欄位初始值。`(inferred)` 表示來源未明寫型別；建構子只顯示參數部分，不含初始化列表。

### KlpCurve

ClassDeclaration · public · [lib/src/styling/primitives/klp_curve.dart:3](../../../../../lib/src/styling/primitives/klp_curve.dart#L3)

<code>final class KlpCurve extends KlpStyleValue</code>

來源註解摘要：中立的三次貝茲曲線控制點，執行演算法仍由本庫掌握。

- `extends` → <code>KlpStyleValue</code>：[lib/src/styling/primitives/klp_curve.dart:4](../../../../../lib/src/styling/primitives/klp_curve.dart#L4)

| 成員 | 可見性 | 簽章／型別 | 來源註解摘要 | 證據 |
|---|---|---|---|---|
| field <code>x1</code> | public | <code>final double x1</code> |  | [lib/src/styling/primitives/klp_curve.dart:6](../../../../../lib/src/styling/primitives/klp_curve.dart#L6) |
| field <code>y1</code> | public | <code>final double y1</code> |  | [lib/src/styling/primitives/klp_curve.dart:7](../../../../../lib/src/styling/primitives/klp_curve.dart#L7) |
| field <code>x2</code> | public | <code>final double x2</code> |  | [lib/src/styling/primitives/klp_curve.dart:8](../../../../../lib/src/styling/primitives/klp_curve.dart#L8) |
| field <code>y2</code> | public | <code>final double y2</code> |  | [lib/src/styling/primitives/klp_curve.dart:9](../../../../../lib/src/styling/primitives/klp_curve.dart#L9) |
| constructor <code>KlpCurve</code> | public | <code>KlpCurve(this.x1, this.y1, this.x2, this.y2)</code> |  | [lib/src/styling/primitives/klp_curve.dart:11](../../../../../lib/src/styling/primitives/klp_curve.dart#L11) |
| method <code>_checkCoordinate</code> | private | <code>static void _checkCoordinate(double value, String path, {required bool horizontal})</code> |  | [lib/src/styling/primitives/klp_curve.dart:18](../../../../../lib/src/styling/primitives/klp_curve.dart#L18) |

## 閱讀說明與限制

箭頭只表示來源明寫的靜態關係；import 不等於呼叫。未分析動態呼叫、欄位的實際物件擁有權、狀態轉移或渲染流程；型別未進行語意解析，繼承目標保留原始型別拼寫。public／private 依 Dart 名稱前綴判斷；public 宣告不代表已由 `lib/kallopis.dart` 匯出。

本頁由 `tool/architecture_atlas` 產生；編輯來源或生成工具後重新產生，避免手改本頁。
