# klp_input_frame_surface.dart：直接依賴與宣告架構

[回到目錄](README.md) · [來源檔案](../../../../../../../lib/src/features/forms/internal/primitives/klp_input_frame_surface.dart)

## 範圍

核心是 `lib/src/features/forms/internal/primitives/klp_input_frame_surface.dart`。主要視角為該檔案明寫的 import／export／part；輔助視角為本檔宣告及 extends／implements／with／on 關係。只展開一層外部邊界。

## 直接依賴圖

```mermaid
flowchart TD
	n0["klp_input_frame_surface.dart"]
	n1["../klp_input_frame.dart"]
	n0 -->|"part of"| n1
```

## 依賴證據

| 關係 | 原始 directive | 來源 |
|---|---|---|
| part of | <code>part of &#x27;../klp_input_frame.dart&#x27;;</code> | [lib/src/features/forms/internal/primitives/klp_input_frame_surface.dart:1](../../../../../../../lib/src/features/forms/internal/primitives/klp_input_frame_surface.dart#L1) |

## 宣告關係圖

本組節點是本檔宣告；沒有箭頭的宣告未在此圖主張互相依賴。

```mermaid
classDiagram
	class n0["_KlpInputFrameSurface"]
```

```mermaid
classDiagram
	class n0["_KlpInputFrameSurface"]
	class n1["StatelessWidget"]
	n0 --|> n1 : extends
```


## 宣告與成員證據

成員包含 public 與 private；簽章取自來源，省略函式本體與欄位初始值。`(inferred)` 表示來源未明寫型別；建構子只顯示參數部分，不含初始化列表。

### _KlpInputFrameSurface

ClassDeclaration · private · [lib/src/features/forms/internal/primitives/klp_input_frame_surface.dart:3](../../../../../../../lib/src/features/forms/internal/primitives/klp_input_frame_surface.dart#L3)

<code>class _KlpInputFrameSurface extends StatelessWidget</code>

來源註解摘要：將 Flutter hover、focus、語意與 surface 限制在輸入框 primitive。

- `extends` → <code>StatelessWidget</code>：[lib/src/features/forms/internal/primitives/klp_input_frame_surface.dart:4](../../../../../../../lib/src/features/forms/internal/primitives/klp_input_frame_surface.dart#L4)

| 成員 | 可見性 | 簽章／型別 | 來源註解摘要 | 證據 |
|---|---|---|---|---|
| constructor <code>_KlpInputFrameSurface</code> | private | <code>const _KlpInputFrameSurface({ required this.enabled, required this.readOnly, required this.hasError, required this.hovered, required this.focused, required this.onHovered, required this.onFocused, required this.child, })</code> |  | [lib/src/features/forms/internal/primitives/klp_input_frame_surface.dart:5](../../../../../../../lib/src/features/forms/internal/primitives/klp_input_frame_surface.dart#L5) |
| field <code>enabled</code> | public | <code>final bool enabled</code> |  | [lib/src/features/forms/internal/primitives/klp_input_frame_surface.dart:16](../../../../../../../lib/src/features/forms/internal/primitives/klp_input_frame_surface.dart#L16) |
| field <code>readOnly</code> | public | <code>final bool readOnly</code> |  | [lib/src/features/forms/internal/primitives/klp_input_frame_surface.dart:17](../../../../../../../lib/src/features/forms/internal/primitives/klp_input_frame_surface.dart#L17) |
| field <code>hasError</code> | public | <code>final bool hasError</code> |  | [lib/src/features/forms/internal/primitives/klp_input_frame_surface.dart:18](../../../../../../../lib/src/features/forms/internal/primitives/klp_input_frame_surface.dart#L18) |
| field <code>hovered</code> | public | <code>final bool hovered</code> |  | [lib/src/features/forms/internal/primitives/klp_input_frame_surface.dart:19](../../../../../../../lib/src/features/forms/internal/primitives/klp_input_frame_surface.dart#L19) |
| field <code>focused</code> | public | <code>final bool focused</code> |  | [lib/src/features/forms/internal/primitives/klp_input_frame_surface.dart:20](../../../../../../../lib/src/features/forms/internal/primitives/klp_input_frame_surface.dart#L20) |
| field <code>onHovered</code> | public | <code>final ValueChanged&lt;bool&gt; onHovered</code> |  | [lib/src/features/forms/internal/primitives/klp_input_frame_surface.dart:21](../../../../../../../lib/src/features/forms/internal/primitives/klp_input_frame_surface.dart#L21) |
| field <code>onFocused</code> | public | <code>final ValueChanged&lt;bool&gt; onFocused</code> |  | [lib/src/features/forms/internal/primitives/klp_input_frame_surface.dart:22](../../../../../../../lib/src/features/forms/internal/primitives/klp_input_frame_surface.dart#L22) |
| field <code>child</code> | public | <code>final Widget child</code> |  | [lib/src/features/forms/internal/primitives/klp_input_frame_surface.dart:23](../../../../../../../lib/src/features/forms/internal/primitives/klp_input_frame_surface.dart#L23) |
| method <code>build</code> | public | <code>Widget build(BuildContext context)</code> |  | [lib/src/features/forms/internal/primitives/klp_input_frame_surface.dart:25](../../../../../../../lib/src/features/forms/internal/primitives/klp_input_frame_surface.dart#L25) |

## 閱讀說明與限制

箭頭只表示來源明寫的靜態關係；import 不等於呼叫。未分析動態呼叫、欄位的實際物件擁有權、狀態轉移或渲染流程；型別未進行語意解析，繼承目標保留原始型別拼寫。public／private 依 Dart 名稱前綴判斷；public 宣告不代表已由 `lib/kallopis.dart` 匯出。

本頁由 `tool/architecture_atlas` 產生；編輯來源或生成工具後重新產生，避免手改本頁。
