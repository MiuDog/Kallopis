# klp_flutter_editing_painter.dart：直接依賴與宣告架構

[回到目錄](README.md) · [來源檔案](../../../../../../lib/src/rendering/flutter/internal/klp_flutter_editing_painter.dart)

## 範圍

核心是 `lib/src/rendering/flutter/internal/klp_flutter_editing_painter.dart`。主要視角為該檔案明寫的 import／export／part；輔助視角為本檔宣告及 extends／implements／with／on 關係。只展開一層外部邊界。

## 直接依賴圖

```mermaid
flowchart LR
	n0["klp_flutter_editing_painter.dart"]
	n1["dart:typed_data"]
	n2["package:flutter/rendering.dart"]
	n3["package:kallopis/src/capabilities/editing/contracts/klp_editing_draw_command.dart"]
	n4["package:kallopis/src/capabilities/editing/contracts/klp_editing_drawing.dart"]
	n5["package:kallopis/src/capabilities/editing/contracts/klp_editing_path.dart"]
	n6["package:kallopis/src/features/editing/presentation/klp_bound_editing_style.dart"]
	n7["klp_flutter_values.dart"]
	n0 -->|"import"| n1
	n0 -->|"import"| n2
	n0 -->|"import"| n3
	n0 -->|"import"| n4
	n0 -->|"import"| n5
	n0 -->|"import"| n6
	n0 -->|"import"| n7
```

## 依賴證據

| 關係 | 原始 directive | 來源 |
|---|---|---|
| import | <code>import &#x27;dart:typed_data&#x27;;</code> | [lib/src/rendering/flutter/internal/klp_flutter_editing_painter.dart:1](../../../../../../lib/src/rendering/flutter/internal/klp_flutter_editing_painter.dart#L1) |
| import | <code>import &#x27;package:flutter/rendering.dart&#x27;;</code> | [lib/src/rendering/flutter/internal/klp_flutter_editing_painter.dart:2](../../../../../../lib/src/rendering/flutter/internal/klp_flutter_editing_painter.dart#L2) |
| import | <code>import &#x27;package:kallopis/src/capabilities/editing/contracts/klp_editing_draw_command.dart&#x27;;</code> | [lib/src/rendering/flutter/internal/klp_flutter_editing_painter.dart:4](../../../../../../lib/src/rendering/flutter/internal/klp_flutter_editing_painter.dart#L4) |
| import | <code>import &#x27;package:kallopis/src/capabilities/editing/contracts/klp_editing_drawing.dart&#x27;;</code> | [lib/src/rendering/flutter/internal/klp_flutter_editing_painter.dart:5](../../../../../../lib/src/rendering/flutter/internal/klp_flutter_editing_painter.dart#L5) |
| import | <code>import &#x27;package:kallopis/src/capabilities/editing/contracts/klp_editing_path.dart&#x27;;</code> | [lib/src/rendering/flutter/internal/klp_flutter_editing_painter.dart:6](../../../../../../lib/src/rendering/flutter/internal/klp_flutter_editing_painter.dart#L6) |
| import | <code>import &#x27;package:kallopis/src/features/editing/presentation/klp_bound_editing_style.dart&#x27;;</code> | [lib/src/rendering/flutter/internal/klp_flutter_editing_painter.dart:7](../../../../../../lib/src/rendering/flutter/internal/klp_flutter_editing_painter.dart#L7) |
| import | <code>import &#x27;klp_flutter_values.dart&#x27;;</code> | [lib/src/rendering/flutter/internal/klp_flutter_editing_painter.dart:8](../../../../../../lib/src/rendering/flutter/internal/klp_flutter_editing_painter.dart#L8) |

## 宣告關係圖

本組節點是本檔宣告；沒有箭頭的宣告未在此圖主張互相依賴。

```mermaid
classDiagram
	class n0["KlpFlutterEditingPainter"]
```

```mermaid
classDiagram
	class n0["KlpFlutterEditingPainter"]
	class n1["CustomPainter"]
	n0 --|> n1 : extends
```


## 宣告與成員證據

成員包含 public 與 private；簽章取自來源，省略函式本體與欄位初始值。`(inferred)` 表示來源未明寫型別；建構子只顯示參數部分，不含初始化列表。

### KlpFlutterEditingPainter

ClassDeclaration · public · [lib/src/rendering/flutter/internal/klp_flutter_editing_painter.dart:10](../../../../../../lib/src/rendering/flutter/internal/klp_flutter_editing_painter.dart#L10)

<code>final class KlpFlutterEditingPainter extends CustomPainter</code>

來源註解摘要：重播核心幾何；不以 Flutter 字體測量建立第二份文字排版。

- `extends` → <code>CustomPainter</code>：[lib/src/rendering/flutter/internal/klp_flutter_editing_painter.dart:11](../../../../../../lib/src/rendering/flutter/internal/klp_flutter_editing_painter.dart#L11)

| 成員 | 可見性 | 簽章／型別 | 來源註解摘要 | 證據 |
|---|---|---|---|---|
| field <code>drawing</code> | public | <code>final KlpEditingDrawing drawing</code> |  | [lib/src/rendering/flutter/internal/klp_flutter_editing_painter.dart:13](../../../../../../lib/src/rendering/flutter/internal/klp_flutter_editing_painter.dart#L13) |
| field <code>style</code> | public | <code>final KlpBoundEditingStyle style</code> |  | [lib/src/rendering/flutter/internal/klp_flutter_editing_painter.dart:14](../../../../../../lib/src/rendering/flutter/internal/klp_flutter_editing_painter.dart#L14) |
| constructor <code>KlpFlutterEditingPainter</code> | public | <code>KlpFlutterEditingPainter(this.drawing, this.style)</code> |  | [lib/src/rendering/flutter/internal/klp_flutter_editing_painter.dart:16](../../../../../../lib/src/rendering/flutter/internal/klp_flutter_editing_painter.dart#L16) |
| method <code>paint</code> | public | <code>void paint(Canvas canvas, Size size)</code> |  | [lib/src/rendering/flutter/internal/klp_flutter_editing_painter.dart:18](../../../../../../lib/src/rendering/flutter/internal/klp_flutter_editing_painter.dart#L18) |
| method <code>_rect</code> | private | <code>Rect _rect(KlpEditingRect rect)</code> |  | [lib/src/rendering/flutter/internal/klp_flutter_editing_painter.dart:55](../../../../../../lib/src/rendering/flutter/internal/klp_flutter_editing_painter.dart#L55) |
| method <code>_path</code> | private | <code>Path _path(KlpEditingPath source)</code> |  | [lib/src/rendering/flutter/internal/klp_flutter_editing_painter.dart:57](../../../../../../lib/src/rendering/flutter/internal/klp_flutter_editing_painter.dart#L57) |
| method <code>shouldRepaint</code> | public | <code>bool shouldRepaint(KlpFlutterEditingPainter oldDelegate)</code> |  | [lib/src/rendering/flutter/internal/klp_flutter_editing_painter.dart:72](../../../../../../lib/src/rendering/flutter/internal/klp_flutter_editing_painter.dart#L72) |

## 閱讀說明與限制

箭頭只表示來源明寫的靜態關係；import 不等於呼叫。未分析動態呼叫、欄位的實際物件擁有權、狀態轉移或渲染流程；型別未進行語意解析，繼承目標保留原始型別拼寫。public／private 依 Dart 名稱前綴判斷；public 宣告不代表已由 `lib/kallopis.dart` 匯出。

本頁由 `tool/architecture_atlas` 產生；編輯來源或生成工具後重新產生，避免手改本頁。
