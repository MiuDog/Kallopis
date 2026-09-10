# klp_gesture_region.dart：直接依賴與宣告架構

[回到目錄](README.md) · [來源檔案](../../../../../lib/src/foundation/interaction/klp_gesture_region.dart)

## 範圍

核心是 `lib/src/foundation/interaction/klp_gesture_region.dart`。主要視角為該檔案明寫的 import／export／part；輔助視角為本檔宣告及 extends／implements／with／on 關係。只展開一層外部邊界。

## 直接依賴圖

```mermaid
flowchart TD
	n0["klp_gesture_region.dart"]
	n1["package:flutter/widgets.dart"]
	n0 -->|"import"| n1
```

## 依賴證據

| 關係 | 原始 directive | 來源 |
|---|---|---|
| import | <code>import &#x27;package:flutter/widgets.dart&#x27;;</code> | [lib/src/foundation/interaction/klp_gesture_region.dart:1](../../../../../lib/src/foundation/interaction/klp_gesture_region.dart#L1) |

## 宣告關係圖

本組節點是本檔宣告；沒有箭頭的宣告未在此圖主張互相依賴。

```mermaid
classDiagram
	class n0["KlpGestureRegion"]
```

```mermaid
classDiagram
	class n0["KlpGestureRegion"]
	class n1["StatelessWidget"]
	n0 --|> n1 : extends
```


## 宣告與成員證據

成員包含 public 與 private；簽章取自來源，省略函式本體與欄位初始值。`(inferred)` 表示來源未明寫型別；建構子只顯示參數部分，不含初始化列表。

### KlpGestureRegion

ClassDeclaration · public · [lib/src/foundation/interaction/klp_gesture_region.dart:3](../../../../../lib/src/foundation/interaction/klp_gesture_region.dart#L3)

<code>class KlpGestureRegion extends StatelessWidget</code>

來源註解摘要：將產品事件接線隔離於 Kallopis 互動邊界內。

- `extends` → <code>StatelessWidget</code>：[lib/src/foundation/interaction/klp_gesture_region.dart:4](../../../../../lib/src/foundation/interaction/klp_gesture_region.dart#L4)

| 成員 | 可見性 | 簽章／型別 | 來源註解摘要 | 證據 |
|---|---|---|---|---|
| constructor <code>KlpGestureRegion</code> | public | <code>const KlpGestureRegion({ super.key, this.behavior, this.onTap, this.onDoubleTap, this.onSecondaryTap, this.onSecondaryTapDown, this.onPanStart, this.onPanUpdate, this.onPanEnd, required this.child, })</code> |  | [lib/src/foundation/interaction/klp_gesture_region.dart:5](../../../../../lib/src/foundation/interaction/klp_gesture_region.dart#L5) |
| field <code>behavior</code> | public | <code>final HitTestBehavior? behavior</code> |  | [lib/src/foundation/interaction/klp_gesture_region.dart:18](../../../../../lib/src/foundation/interaction/klp_gesture_region.dart#L18) |
| field <code>onTap</code> | public | <code>final GestureTapCallback? onTap</code> |  | [lib/src/foundation/interaction/klp_gesture_region.dart:19](../../../../../lib/src/foundation/interaction/klp_gesture_region.dart#L19) |
| field <code>onDoubleTap</code> | public | <code>final GestureTapCallback? onDoubleTap</code> |  | [lib/src/foundation/interaction/klp_gesture_region.dart:20](../../../../../lib/src/foundation/interaction/klp_gesture_region.dart#L20) |
| field <code>onSecondaryTap</code> | public | <code>final GestureTapCallback? onSecondaryTap</code> |  | [lib/src/foundation/interaction/klp_gesture_region.dart:21](../../../../../lib/src/foundation/interaction/klp_gesture_region.dart#L21) |
| field <code>onSecondaryTapDown</code> | public | <code>final GestureTapDownCallback? onSecondaryTapDown</code> |  | [lib/src/foundation/interaction/klp_gesture_region.dart:22](../../../../../lib/src/foundation/interaction/klp_gesture_region.dart#L22) |
| field <code>onPanStart</code> | public | <code>final GestureDragStartCallback? onPanStart</code> |  | [lib/src/foundation/interaction/klp_gesture_region.dart:23](../../../../../lib/src/foundation/interaction/klp_gesture_region.dart#L23) |
| field <code>onPanUpdate</code> | public | <code>final GestureDragUpdateCallback? onPanUpdate</code> |  | [lib/src/foundation/interaction/klp_gesture_region.dart:24](../../../../../lib/src/foundation/interaction/klp_gesture_region.dart#L24) |
| field <code>onPanEnd</code> | public | <code>final GestureDragEndCallback? onPanEnd</code> |  | [lib/src/foundation/interaction/klp_gesture_region.dart:25](../../../../../lib/src/foundation/interaction/klp_gesture_region.dart#L25) |
| field <code>child</code> | public | <code>final Widget child</code> |  | [lib/src/foundation/interaction/klp_gesture_region.dart:26](../../../../../lib/src/foundation/interaction/klp_gesture_region.dart#L26) |
| method <code>build</code> | public | <code>Widget build(BuildContext context)</code> |  | [lib/src/foundation/interaction/klp_gesture_region.dart:28](../../../../../lib/src/foundation/interaction/klp_gesture_region.dart#L28) |

## 閱讀說明與限制

箭頭只表示來源明寫的靜態關係；import 不等於呼叫。未分析動態呼叫、欄位的實際物件擁有權、狀態轉移或渲染流程；型別未進行語意解析，繼承目標保留原始型別拼寫。public／private 依 Dart 名稱前綴判斷；public 宣告不代表已由 `lib/kallopis.dart` 匯出。

本頁由 `tool/architecture_atlas` 產生；編輯來源或生成工具後重新產生，避免手改本頁。
