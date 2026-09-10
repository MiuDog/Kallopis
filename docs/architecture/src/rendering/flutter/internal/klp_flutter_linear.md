# klp_flutter_linear.dart：直接依賴與宣告架構

[回到目錄](README.md) · [來源檔案](../../../../../../lib/src/rendering/flutter/internal/klp_flutter_linear.dart)

## 範圍

核心是 `lib/src/rendering/flutter/internal/klp_flutter_linear.dart`。主要視角為該檔案明寫的 import／export／part；輔助視角為本檔宣告及 extends／implements／with／on 關係。只展開一層外部邊界。

## 直接依賴圖

```mermaid
flowchart LR
	n0["klp_flutter_linear.dart"]
	n1["package:flutter/widgets.dart"]
	n2["../../../foundation/binding/internal/klp_bound_template.dart"]
	n3["klp_flutter_renderer.dart"]
	n4["klp_flutter_values.dart"]
	n0 -->|"import"| n1
	n0 -->|"import"| n2
	n0 -->|"import"| n3
	n0 -->|"import"| n4
```

## 依賴證據

| 關係 | 原始 directive | 來源 |
|---|---|---|
| import | <code>import &#x27;package:flutter/widgets.dart&#x27;;</code> | [lib/src/rendering/flutter/internal/klp_flutter_linear.dart:1](../../../../../../lib/src/rendering/flutter/internal/klp_flutter_linear.dart#L1) |
| import | <code>import &#x27;../../../foundation/binding/internal/klp_bound_template.dart&#x27;;</code> | [lib/src/rendering/flutter/internal/klp_flutter_linear.dart:3](../../../../../../lib/src/rendering/flutter/internal/klp_flutter_linear.dart#L3) |
| import | <code>import &#x27;klp_flutter_renderer.dart&#x27;;</code> | [lib/src/rendering/flutter/internal/klp_flutter_linear.dart:4](../../../../../../lib/src/rendering/flutter/internal/klp_flutter_linear.dart#L4) |
| import | <code>import &#x27;klp_flutter_values.dart&#x27;;</code> | [lib/src/rendering/flutter/internal/klp_flutter_linear.dart:5](../../../../../../lib/src/rendering/flutter/internal/klp_flutter_linear.dart#L5) |

## 宣告關係圖

本組節點是本檔宣告；沒有箭頭的宣告未在此圖主張互相依賴。

```mermaid
classDiagram
	class n0["KlpFlutterLinear"]
```

```mermaid
classDiagram
	class n0["KlpFlutterLinear"]
	class n1["StatelessWidget"]
	n0 --|> n1 : extends
```


## 宣告與成員證據

成員包含 public 與 private；簽章取自來源，省略函式本體與欄位初始值。`(inferred)` 表示來源未明寫型別；建構子只顯示參數部分，不含初始化列表。

### KlpFlutterLinear

ClassDeclaration · public · [lib/src/rendering/flutter/internal/klp_flutter_linear.dart:7](../../../../../../lib/src/rendering/flutter/internal/klp_flutter_linear.dart#L7)

<code>final class KlpFlutterLinear extends StatelessWidget</code>

來源註解摘要：線性內容沿主要方向保留自然尺寸，受限時由本庫提供捲動。

- `extends` → <code>StatelessWidget</code>：[lib/src/rendering/flutter/internal/klp_flutter_linear.dart:8](../../../../../../lib/src/rendering/flutter/internal/klp_flutter_linear.dart#L8)

| 成員 | 可見性 | 簽章／型別 | 來源註解摘要 | 證據 |
|---|---|---|---|---|
| field <code>content</code> | public | <code>final KlpBoundLinear content</code> |  | [lib/src/rendering/flutter/internal/klp_flutter_linear.dart:9](../../../../../../lib/src/rendering/flutter/internal/klp_flutter_linear.dart#L9) |
| constructor <code>KlpFlutterLinear</code> | public | <code>const KlpFlutterLinear({required this.content, super.key})</code> |  | [lib/src/rendering/flutter/internal/klp_flutter_linear.dart:11](../../../../../../lib/src/rendering/flutter/internal/klp_flutter_linear.dart#L11) |
| method <code>build</code> | public | <code>Widget build(BuildContext context)</code> |  | [lib/src/rendering/flutter/internal/klp_flutter_linear.dart:13](../../../../../../lib/src/rendering/flutter/internal/klp_flutter_linear.dart#L13) |

## 閱讀說明與限制

箭頭只表示來源明寫的靜態關係；import 不等於呼叫。未分析動態呼叫、欄位的實際物件擁有權、狀態轉移或渲染流程；型別未進行語意解析，繼承目標保留原始型別拼寫。public／private 依 Dart 名稱前綴判斷；public 宣告不代表已由 `lib/kallopis.dart` 匯出。

本頁由 `tool/architecture_atlas` 產生；編輯來源或生成工具後重新產生，避免手改本頁。
