# klp_resize_handle.dart：直接依賴與宣告架構

[回到目錄](README.md) · [來源檔案](../../../../../lib/src/foundation/layout/klp_resize_handle.dart)

## 範圍

核心是 `lib/src/foundation/layout/klp_resize_handle.dart`。主要視角為該檔案明寫的 import／export／part；輔助視角為本檔宣告及 extends／implements／with／on 關係。只展開一層外部邊界。

## 直接依賴圖

```mermaid
flowchart TD
	n0["klp_resize_handle.dart"]
	n1["package:flutter/widgets.dart"]
	n2["../../styling/legacy_theme/klp_theme.dart"]
	n0 -->|"import"| n1
	n0 -->|"import"| n2
```

## 依賴證據

| 關係 | 原始 directive | 來源 |
|---|---|---|
| import | <code>import &#x27;package:flutter/widgets.dart&#x27;;</code> | [lib/src/foundation/layout/klp_resize_handle.dart:1](../../../../../lib/src/foundation/layout/klp_resize_handle.dart#L1) |
| import | <code>import &#x27;../../styling/legacy_theme/klp_theme.dart&#x27;;</code> | [lib/src/foundation/layout/klp_resize_handle.dart:3](../../../../../lib/src/foundation/layout/klp_resize_handle.dart#L3) |

## 宣告關係圖

本組節點是本檔宣告；沒有箭頭的宣告未在此圖主張互相依賴。

```mermaid
classDiagram
	class n0["KlpResizeHandle"]
```

```mermaid
classDiagram
	class n0["KlpResizeHandle"]
	class n1["StatelessWidget"]
	n0 --|> n1 : extends
```


## 宣告與成員證據

成員包含 public 與 private；簽章取自來源，省略函式本體與欄位初始值。`(inferred)` 表示來源未明寫型別；建構子只顯示參數部分，不含初始化列表。

### KlpResizeHandle

ClassDeclaration · public · [lib/src/foundation/layout/klp_resize_handle.dart:5](../../../../../lib/src/foundation/layout/klp_resize_handle.dart#L5)

<code>class KlpResizeHandle extends StatelessWidget</code>

來源註解摘要：拖曳調整水平或垂直尺寸的把手。

- `extends` → <code>StatelessWidget</code>：[lib/src/foundation/layout/klp_resize_handle.dart:6](../../../../../lib/src/foundation/layout/klp_resize_handle.dart#L6)

| 成員 | 可見性 | 簽章／型別 | 來源註解摘要 | 證據 |
|---|---|---|---|---|
| constructor <code>KlpResizeHandle</code> | public | <code>const KlpResizeHandle({ super.key, required this.onDelta, this.axis = Axis.horizontal, this.onDragStart, this.onDragEnd, this.semanticLabel, this.width, this.height, this.enabled = true, })</code> |  | [lib/src/foundation/layout/klp_resize_handle.dart:7](../../../../../lib/src/foundation/layout/klp_resize_handle.dart#L7) |
| field <code>axis</code> | public | <code>final Axis axis</code> |  | [lib/src/foundation/layout/klp_resize_handle.dart:19](../../../../../lib/src/foundation/layout/klp_resize_handle.dart#L19) |
| field <code>onDelta</code> | public | <code>final ValueChanged&lt;double&gt; onDelta</code> |  | [lib/src/foundation/layout/klp_resize_handle.dart:20](../../../../../lib/src/foundation/layout/klp_resize_handle.dart#L20) |
| field <code>onDragStart</code> | public | <code>final VoidCallback? onDragStart</code> |  | [lib/src/foundation/layout/klp_resize_handle.dart:21](../../../../../lib/src/foundation/layout/klp_resize_handle.dart#L21) |
| field <code>onDragEnd</code> | public | <code>final VoidCallback? onDragEnd</code> |  | [lib/src/foundation/layout/klp_resize_handle.dart:22](../../../../../lib/src/foundation/layout/klp_resize_handle.dart#L22) |
| field <code>semanticLabel</code> | public | <code>final String? semanticLabel</code> |  | [lib/src/foundation/layout/klp_resize_handle.dart:23](../../../../../lib/src/foundation/layout/klp_resize_handle.dart#L23) |
| field <code>width</code> | public | <code>final double? width</code> |  | [lib/src/foundation/layout/klp_resize_handle.dart:24](../../../../../lib/src/foundation/layout/klp_resize_handle.dart#L24) |
| field <code>height</code> | public | <code>final double? height</code> |  | [lib/src/foundation/layout/klp_resize_handle.dart:25](../../../../../lib/src/foundation/layout/klp_resize_handle.dart#L25) |
| field <code>enabled</code> | public | <code>final bool enabled</code> |  | [lib/src/foundation/layout/klp_resize_handle.dart:26](../../../../../lib/src/foundation/layout/klp_resize_handle.dart#L26) |
| method <code>build</code> | public | <code>Widget build(BuildContext context)</code> |  | [lib/src/foundation/layout/klp_resize_handle.dart:28](../../../../../lib/src/foundation/layout/klp_resize_handle.dart#L28) |
| method <code>_resolveCursor</code> | private | <code>MouseCursor _resolveCursor(bool isHorizontal)</code> |  | [lib/src/foundation/layout/klp_resize_handle.dart:85](../../../../../lib/src/foundation/layout/klp_resize_handle.dart#L85) |

## 閱讀說明與限制

箭頭只表示來源明寫的靜態關係；import 不等於呼叫。未分析動態呼叫、欄位的實際物件擁有權、狀態轉移或渲染流程；型別未進行語意解析，繼承目標保留原始型別拼寫。public／private 依 Dart 名稱前綴判斷；public 宣告不代表已由 `lib/kallopis.dart` 匯出。

本頁由 `tool/architecture_atlas` 產生；編輯來源或生成工具後重新產生，避免手改本頁。
