# klp_optical_shift.dart：直接依賴與宣告架構

[回到目錄](README.md) · [來源檔案](../../../../../lib/src/foundation/content/klp_optical_shift.dart)

## 範圍

核心是 `lib/src/foundation/content/klp_optical_shift.dart`。主要視角為該檔案明寫的 import／export／part；輔助視角為本檔宣告及 extends／implements／with／on 關係。只展開一層外部邊界。

## 直接依賴圖

```mermaid
flowchart TD
	n0["klp_optical_shift.dart"]
	n1["klp_text_widget.dart"]
	n0 -->|"part of"| n1
```

## 依賴證據

| 關係 | 原始 directive | 來源 |
|---|---|---|
| part of | <code>part of &#x27;klp_text_widget.dart&#x27;;</code> | [lib/src/foundation/content/klp_optical_shift.dart:1](../../../../../lib/src/foundation/content/klp_optical_shift.dart#L1) |

## 宣告關係圖

本組節點是本檔宣告；沒有箭頭的宣告未在此圖主張互相依賴。

```mermaid
classDiagram
	class n0["_KlpOpticalShift"]
```

```mermaid
classDiagram
	class n0["_KlpOpticalShift"]
	class n1["SingleChildRenderObjectWidget"]
	n0 --|> n1 : extends
```


## 宣告與成員證據

成員包含 public 與 private；簽章取自來源，省略函式本體與欄位初始值。`(inferred)` 表示來源未明寫型別；建構子只顯示參數部分，不含初始化列表。

### _KlpOpticalShift

ClassDeclaration · private · [lib/src/foundation/content/klp_optical_shift.dart:3](../../../../../lib/src/foundation/content/klp_optical_shift.dart#L3)

<code>class _KlpOpticalShift extends SingleChildRenderObjectWidget</code>

來源註解摘要：套用文字光學基線位移，維持原始 baseline 計算。

- `extends` → <code>SingleChildRenderObjectWidget</code>：[lib/src/foundation/content/klp_optical_shift.dart:4](../../../../../lib/src/foundation/content/klp_optical_shift.dart#L4)

| 成員 | 可見性 | 簽章／型別 | 來源註解摘要 | 證據 |
|---|---|---|---|---|
| constructor <code>_KlpOpticalShift</code> | private | <code>const _KlpOpticalShift({required this.offsetY, required super.child})</code> |  | [lib/src/foundation/content/klp_optical_shift.dart:5](../../../../../lib/src/foundation/content/klp_optical_shift.dart#L5) |
| field <code>offsetY</code> | public | <code>final double offsetY</code> |  | [lib/src/foundation/content/klp_optical_shift.dart:7](../../../../../lib/src/foundation/content/klp_optical_shift.dart#L7) |
| method <code>createRenderObject</code> | public | <code>RenderObject createRenderObject(BuildContext context)</code> |  | [lib/src/foundation/content/klp_optical_shift.dart:9](../../../../../lib/src/foundation/content/klp_optical_shift.dart#L9) |
| method <code>updateRenderObject</code> | public | <code>void updateRenderObject( BuildContext context, _RenderKlpOpticalShift renderObject, )</code> |  | [lib/src/foundation/content/klp_optical_shift.dart:13](../../../../../lib/src/foundation/content/klp_optical_shift.dart#L13) |

## 閱讀說明與限制

箭頭只表示來源明寫的靜態關係；import 不等於呼叫。未分析動態呼叫、欄位的實際物件擁有權、狀態轉移或渲染流程；型別未進行語意解析，繼承目標保留原始型別拼寫。public／private 依 Dart 名稱前綴判斷；public 宣告不代表已由 `lib/kallopis.dart` 匯出。

本頁由 `tool/architecture_atlas` 產生；編輯來源或生成工具後重新產生，避免手改本頁。
