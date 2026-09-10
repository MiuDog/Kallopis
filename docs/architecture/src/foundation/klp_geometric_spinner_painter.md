# klp_geometric_spinner_painter.dart：直接依賴與宣告架構

[回到目錄](README.md) · [來源檔案](../../../../lib/src/foundation/klp_geometric_spinner_painter.dart)

## 範圍

核心是 `lib/src/foundation/klp_geometric_spinner_painter.dart`。主要視角為該檔案明寫的 import／export／part；輔助視角為本檔宣告及 extends／implements／with／on 關係。只展開一層外部邊界。

## 直接依賴圖

```mermaid
flowchart TD
	n0["klp_geometric_spinner_painter.dart"]
	n1["klp_geometric_spinner.dart"]
	n0 -->|"part of"| n1
```

## 依賴證據

| 關係 | 原始 directive | 來源 |
|---|---|---|
| part of | <code>part of &#x27;klp_geometric_spinner.dart&#x27;;</code> | [lib/src/foundation/klp_geometric_spinner_painter.dart:1](../../../../lib/src/foundation/klp_geometric_spinner_painter.dart#L1) |

## 宣告關係圖

本組節點是本檔宣告；沒有箭頭的宣告未在此圖主張互相依賴。

```mermaid
classDiagram
	class n0["_GeometricSpinnerPainter"]
```

```mermaid
classDiagram
	class n0["_GeometricSpinnerPainter"]
	class n1["CustomPainter"]
	n0 --|> n1 : extends
```


## 宣告與成員證據

成員包含 public 與 private；簽章取自來源，省略函式本體與欄位初始值。`(inferred)` 表示來源未明寫型別；建構子只顯示參數部分，不含初始化列表。

### _GeometricSpinnerPainter

ClassDeclaration · private · [lib/src/foundation/klp_geometric_spinner_painter.dart:3](../../../../lib/src/foundation/klp_geometric_spinner_painter.dart#L3)

<code>class _GeometricSpinnerPainter extends CustomPainter</code>

來源註解摘要：繪製四個繞中心旋轉並交替色彩的幾何方塊。

- `extends` → <code>CustomPainter</code>：[lib/src/foundation/klp_geometric_spinner_painter.dart:4](../../../../lib/src/foundation/klp_geometric_spinner_painter.dart#L4)

| 成員 | 可見性 | 簽章／型別 | 來源註解摘要 | 證據 |
|---|---|---|---|---|
| constructor <code>_GeometricSpinnerPainter</code> | private | <code>const _GeometricSpinnerPainter({ required this.progress, required this.primaryColor, required this.contrastColor, required this.squareFactor, required this.orbitFactor, required this.cornerFactor, })</code> |  | [lib/src/foundation/klp_geometric_spinner_painter.dart:5](../../../../lib/src/foundation/klp_geometric_spinner_painter.dart#L5) |
| field <code>progress</code> | public | <code>final double progress</code> |  | [lib/src/foundation/klp_geometric_spinner_painter.dart:14](../../../../lib/src/foundation/klp_geometric_spinner_painter.dart#L14) |
| field <code>primaryColor</code> | public | <code>final Color primaryColor</code> |  | [lib/src/foundation/klp_geometric_spinner_painter.dart:15](../../../../lib/src/foundation/klp_geometric_spinner_painter.dart#L15) |
| field <code>contrastColor</code> | public | <code>final Color contrastColor</code> |  | [lib/src/foundation/klp_geometric_spinner_painter.dart:16](../../../../lib/src/foundation/klp_geometric_spinner_painter.dart#L16) |
| field <code>squareFactor</code> | public | <code>final double squareFactor</code> |  | [lib/src/foundation/klp_geometric_spinner_painter.dart:17](../../../../lib/src/foundation/klp_geometric_spinner_painter.dart#L17) |
| field <code>orbitFactor</code> | public | <code>final double orbitFactor</code> |  | [lib/src/foundation/klp_geometric_spinner_painter.dart:18](../../../../lib/src/foundation/klp_geometric_spinner_painter.dart#L18) |
| field <code>cornerFactor</code> | public | <code>final double cornerFactor</code> |  | [lib/src/foundation/klp_geometric_spinner_painter.dart:19](../../../../lib/src/foundation/klp_geometric_spinner_painter.dart#L19) |
| method <code>paint</code> | public | <code>void paint(Canvas canvas, Size size)</code> |  | [lib/src/foundation/klp_geometric_spinner_painter.dart:21](../../../../lib/src/foundation/klp_geometric_spinner_painter.dart#L21) |
| method <code>shouldRepaint</code> | public | <code>bool shouldRepaint(covariant _GeometricSpinnerPainter oldDelegate)</code> |  | [lib/src/foundation/klp_geometric_spinner_painter.dart:47](../../../../lib/src/foundation/klp_geometric_spinner_painter.dart#L47) |

## 閱讀說明與限制

箭頭只表示來源明寫的靜態關係；import 不等於呼叫。未分析動態呼叫、欄位的實際物件擁有權、狀態轉移或渲染流程；型別未進行語意解析，繼承目標保留原始型別拼寫。public／private 依 Dart 名稱前綴判斷；public 宣告不代表已由 `lib/kallopis.dart` 匯出。

本頁由 `tool/architecture_atlas` 產生；編輯來源或生成工具後重新產生，避免手改本頁。
