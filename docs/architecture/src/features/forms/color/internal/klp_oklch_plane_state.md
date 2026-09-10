# klp_oklch_plane_state.dart：直接依賴與宣告架構

[回到目錄](README.md) · [來源檔案](../../../../../../../lib/src/features/forms/color/internal/klp_oklch_plane_state.dart)

## 範圍

核心是 `lib/src/features/forms/color/internal/klp_oklch_plane_state.dart`。主要視角為該檔案明寫的 import／export／part；輔助視角為本檔宣告及 extends／implements／with／on 關係。只展開一層外部邊界。

## 直接依賴圖

```mermaid
flowchart TD
	n0["klp_oklch_plane_state.dart"]
	n1["../klp_oklch_color_picker.dart"]
	n0 -->|"part of"| n1
```

## 依賴證據

| 關係 | 原始 directive | 來源 |
|---|---|---|
| part of | <code>part of &#x27;../klp_oklch_color_picker.dart&#x27;;</code> | [lib/src/features/forms/color/internal/klp_oklch_plane_state.dart:1](../../../../../../../lib/src/features/forms/color/internal/klp_oklch_plane_state.dart#L1) |

## 宣告關係圖

本組節點是本檔宣告；沒有箭頭的宣告未在此圖主張互相依賴。

```mermaid
classDiagram
	class n0["_OklchPlaneState"]
```

```mermaid
classDiagram
	class n0["_OklchPlaneState"]
	class n1["State&lt;_OklchPlane&gt;"]
	n0 --|> n1 : extends
```


## 宣告與成員證據

成員包含 public 與 private；簽章取自來源，省略函式本體與欄位初始值。`(inferred)` 表示來源未明寫型別；建構子只顯示參數部分，不含初始化列表。

### _OklchPlaneState

ClassDeclaration · private · [lib/src/features/forms/color/internal/klp_oklch_plane_state.dart:3](../../../../../../../lib/src/features/forms/color/internal/klp_oklch_plane_state.dart#L3)

<code>class _OklchPlaneState extends State&lt;_OklchPlane&gt;</code>

- `extends` → <code>State&lt;_OklchPlane&gt;</code>：[lib/src/features/forms/color/internal/klp_oklch_plane_state.dart:3](../../../../../../../lib/src/features/forms/color/internal/klp_oklch_plane_state.dart#L3)

| 成員 | 可見性 | 簽章／型別 | 來源註解摘要 | 證據 |
|---|---|---|---|---|
| field <code>_keyboardStep</code> | private | <code>static const (inferred) _keyboardStep</code> |  | [lib/src/features/forms/color/internal/klp_oklch_plane_state.dart:4](../../../../../../../lib/src/features/forms/color/internal/klp_oklch_plane_state.dart#L4) |
| field <code>_focusNode</code> | private | <code>final FocusNode _focusNode</code> |  | [lib/src/features/forms/color/internal/klp_oklch_plane_state.dart:6](../../../../../../../lib/src/features/forms/color/internal/klp_oklch_plane_state.dart#L6) |
| getter <code>_maximumChroma</code> | private | <code>double get _maximumChroma</code> |  | [lib/src/features/forms/color/internal/klp_oklch_plane_state.dart:8](../../../../../../../lib/src/features/forms/color/internal/klp_oklch_plane_state.dart#L8) |
| getter <code>_normalizedHue</code> | private | <code>double get _normalizedHue</code> |  | [lib/src/features/forms/color/internal/klp_oklch_plane_state.dart:9](../../../../../../../lib/src/features/forms/color/internal/klp_oklch_plane_state.dart#L9) |
| getter <code>_semanticValue</code> | private | <code>String get _semanticValue</code> |  | [lib/src/features/forms/color/internal/klp_oklch_plane_state.dart:11](../../../../../../../lib/src/features/forms/color/internal/klp_oklch_plane_state.dart#L11) |
| getter <code>_normalizedPosition</code> | private | <code>Offset get _normalizedPosition</code> |  | [lib/src/features/forms/color/internal/klp_oklch_plane_state.dart:17](../../../../../../../lib/src/features/forms/color/internal/klp_oklch_plane_state.dart#L17) |
| method <code>dispose</code> | public | <code>void dispose()</code> |  | [lib/src/features/forms/color/internal/klp_oklch_plane_state.dart:34](../../../../../../../lib/src/features/forms/color/internal/klp_oklch_plane_state.dart#L34) |
| method <code>_handleKeyEvent</code> | private | <code>KeyEventResult _handleKeyEvent(FocusNode node, KeyEvent event)</code> |  | [lib/src/features/forms/color/internal/klp_oklch_plane_state.dart:40](../../../../../../../lib/src/features/forms/color/internal/klp_oklch_plane_state.dart#L40) |
| method <code>_updateFromPosition</code> | private | <code>void _updateFromPosition(Offset position, Size size)</code> |  | [lib/src/features/forms/color/internal/klp_oklch_plane_state.dart:71](../../../../../../../lib/src/features/forms/color/internal/klp_oklch_plane_state.dart#L71) |
| method <code>_emitNormalized</code> | private | <code>void _emitNormalized(Offset position)</code> |  | [lib/src/features/forms/color/internal/klp_oklch_plane_state.dart:78](../../../../../../../lib/src/features/forms/color/internal/klp_oklch_plane_state.dart#L78) |
| method <code>build</code> | public | <code>Widget build(BuildContext context)</code> |  | [lib/src/features/forms/color/internal/klp_oklch_plane_state.dart:99](../../../../../../../lib/src/features/forms/color/internal/klp_oklch_plane_state.dart#L99) |

## 閱讀說明與限制

箭頭只表示來源明寫的靜態關係；import 不等於呼叫。未分析動態呼叫、欄位的實際物件擁有權、狀態轉移或渲染流程；型別未進行語意解析，繼承目標保留原始型別拼寫。public／private 依 Dart 名稱前綴判斷；public 宣告不代表已由 `lib/kallopis.dart` 匯出。

本頁由 `tool/architecture_atlas` 產生；編輯來源或生成工具後重新產生，避免手改本頁。
