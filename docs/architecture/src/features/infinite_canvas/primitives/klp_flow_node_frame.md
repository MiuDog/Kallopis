# klp_flow_node_frame.dart：直接依賴與宣告架構

[回到目錄](README.md) · [來源檔案](../../../../../../lib/src/features/infinite_canvas/primitives/klp_flow_node_frame.dart)

## 範圍

核心是 `lib/src/features/infinite_canvas/primitives/klp_flow_node_frame.dart`。主要視角為該檔案明寫的 import／export／part；輔助視角為本檔宣告及 extends／implements／with／on 關係。只展開一層外部邊界。

## 直接依賴圖

```mermaid
flowchart TD
	n0["klp_flow_node_frame.dart"]
	n1["../klp_canvas_workspace.dart"]
	n0 -->|"part of"| n1
```

## 依賴證據

| 關係 | 原始 directive | 來源 |
|---|---|---|
| part of | <code>part of &#x27;../klp_canvas_workspace.dart&#x27;;</code> | [lib/src/features/infinite_canvas/primitives/klp_flow_node_frame.dart:1](../../../../../../lib/src/features/infinite_canvas/primitives/klp_flow_node_frame.dart#L1) |

## 宣告關係圖

本組節點是本檔宣告；沒有箭頭的宣告未在此圖主張互相依賴。

```mermaid
classDiagram
	class n0["_KlpFlowNodeFrame"]
```

```mermaid
classDiagram
	class n0["_KlpFlowNodeFrame"]
	class n1["StatelessWidget"]
	n0 --|> n1 : extends
```


## 宣告與成員證據

成員包含 public 與 private；簽章取自來源，省略函式本體與欄位初始值。`(inferred)` 表示來源未明寫型別；建構子只顯示參數部分，不含初始化列表。

### _KlpFlowNodeFrame

ClassDeclaration · private · [lib/src/features/infinite_canvas/primitives/klp_flow_node_frame.dart:3](../../../../../../lib/src/features/infinite_canvas/primitives/klp_flow_node_frame.dart#L3)

<code>class _KlpFlowNodeFrame extends StatelessWidget</code>

- `extends` → <code>StatelessWidget</code>：[lib/src/features/infinite_canvas/primitives/klp_flow_node_frame.dart:3](../../../../../../lib/src/features/infinite_canvas/primitives/klp_flow_node_frame.dart#L3)

| 成員 | 可見性 | 簽章／型別 | 來源註解摘要 | 證據 |
|---|---|---|---|---|
| constructor <code>_KlpFlowNodeFrame</code> | private | <code>const _KlpFlowNodeFrame({ required this.selected, required this.onPressed, required this.child, })</code> |  | [lib/src/features/infinite_canvas/primitives/klp_flow_node_frame.dart:4](../../../../../../lib/src/features/infinite_canvas/primitives/klp_flow_node_frame.dart#L4) |
| field <code>selected</code> | public | <code>final bool selected</code> |  | [lib/src/features/infinite_canvas/primitives/klp_flow_node_frame.dart:10](../../../../../../lib/src/features/infinite_canvas/primitives/klp_flow_node_frame.dart#L10) |
| field <code>onPressed</code> | public | <code>final VoidCallback? onPressed</code> |  | [lib/src/features/infinite_canvas/primitives/klp_flow_node_frame.dart:11](../../../../../../lib/src/features/infinite_canvas/primitives/klp_flow_node_frame.dart#L11) |
| field <code>child</code> | public | <code>final Widget child</code> |  | [lib/src/features/infinite_canvas/primitives/klp_flow_node_frame.dart:12](../../../../../../lib/src/features/infinite_canvas/primitives/klp_flow_node_frame.dart#L12) |
| method <code>build</code> | public | <code>Widget build(BuildContext context)</code> |  | [lib/src/features/infinite_canvas/primitives/klp_flow_node_frame.dart:14](../../../../../../lib/src/features/infinite_canvas/primitives/klp_flow_node_frame.dart#L14) |

## 閱讀說明與限制

箭頭只表示來源明寫的靜態關係；import 不等於呼叫。未分析動態呼叫、欄位的實際物件擁有權、狀態轉移或渲染流程；型別未進行語意解析，繼承目標保留原始型別拼寫。public／private 依 Dart 名稱前綴判斷；public 宣告不代表已由 `lib/kallopis.dart` 匯出。

本頁由 `tool/architecture_atlas` 產生；編輯來源或生成工具後重新產生，避免手改本頁。
