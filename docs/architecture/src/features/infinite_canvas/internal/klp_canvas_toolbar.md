# klp_canvas_toolbar.dart：直接依賴與宣告架構

[回到目錄](README.md) · [來源檔案](../../../../../../lib/src/features/infinite_canvas/internal/klp_canvas_toolbar.dart)

## 範圍

核心是 `lib/src/features/infinite_canvas/internal/klp_canvas_toolbar.dart`。主要視角為該檔案明寫的 import／export／part；輔助視角為本檔宣告及 extends／implements／with／on 關係。只展開一層外部邊界。

## 直接依賴圖

```mermaid
flowchart TD
	n0["klp_canvas_toolbar.dart"]
	n1["../klp_canvas_workspace.dart"]
	n0 -->|"part of"| n1
```

## 依賴證據

| 關係 | 原始 directive | 來源 |
|---|---|---|
| part of | <code>part of &#x27;../klp_canvas_workspace.dart&#x27;;</code> | [lib/src/features/infinite_canvas/internal/klp_canvas_toolbar.dart:1](../../../../../../lib/src/features/infinite_canvas/internal/klp_canvas_toolbar.dart#L1) |

## 宣告關係圖

本組節點是本檔宣告；沒有箭頭的宣告未在此圖主張互相依賴。

```mermaid
classDiagram
	class n0["KlpCanvasToolbar"]
```

```mermaid
classDiagram
	class n0["KlpCanvasToolbar"]
	class n1["StatelessWidget"]
	n0 --|> n1 : extends
```


## 宣告與成員證據

成員包含 public 與 private；簽章取自來源，省略函式本體與欄位初始值。`(inferred)` 表示來源未明寫型別；建構子只顯示參數部分，不含初始化列表。

### KlpCanvasToolbar

ClassDeclaration · public · [lib/src/features/infinite_canvas/internal/klp_canvas_toolbar.dart:3](../../../../../../lib/src/features/infinite_canvas/internal/klp_canvas_toolbar.dart#L3)

<code>class KlpCanvasToolbar extends StatelessWidget</code>

來源註解摘要：畫布上的有限動作工具列；動作能力由呼叫端決定。

- `extends` → <code>StatelessWidget</code>：[lib/src/features/infinite_canvas/internal/klp_canvas_toolbar.dart:4](../../../../../../lib/src/features/infinite_canvas/internal/klp_canvas_toolbar.dart#L4)

| 成員 | 可見性 | 簽章／型別 | 來源註解摘要 | 證據 |
|---|---|---|---|---|
| constructor <code>KlpCanvasToolbar</code> | public | <code>const KlpCanvasToolbar({super.key, required this.actions})</code> |  | [lib/src/features/infinite_canvas/internal/klp_canvas_toolbar.dart:5](../../../../../../lib/src/features/infinite_canvas/internal/klp_canvas_toolbar.dart#L5) |
| field <code>actions</code> | public | <code>final List&lt;Widget&gt; actions</code> |  | [lib/src/features/infinite_canvas/internal/klp_canvas_toolbar.dart:7](../../../../../../lib/src/features/infinite_canvas/internal/klp_canvas_toolbar.dart#L7) |
| method <code>build</code> | public | <code>Widget build(BuildContext context)</code> |  | [lib/src/features/infinite_canvas/internal/klp_canvas_toolbar.dart:9](../../../../../../lib/src/features/infinite_canvas/internal/klp_canvas_toolbar.dart#L9) |

## 閱讀說明與限制

箭頭只表示來源明寫的靜態關係；import 不等於呼叫。未分析動態呼叫、欄位的實際物件擁有權、狀態轉移或渲染流程；型別未進行語意解析，繼承目標保留原始型別拼寫。public／private 依 Dart 名稱前綴判斷；public 宣告不代表已由 `lib/kallopis.dart` 匯出。

本頁由 `tool/architecture_atlas` 產生；編輯來源或生成工具後重新產生，避免手改本頁。
