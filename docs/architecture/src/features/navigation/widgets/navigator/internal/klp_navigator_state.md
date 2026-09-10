# klp_navigator_state.dart：直接依賴與宣告架構

[回到目錄](README.md) · [來源檔案](../../../../../../../../lib/src/features/navigation/widgets/navigator/internal/klp_navigator_state.dart)

## 範圍

核心是 `lib/src/features/navigation/widgets/navigator/internal/klp_navigator_state.dart`。主要視角為該檔案明寫的 import／export／part；輔助視角為本檔宣告及 extends／implements／with／on 關係。只展開一層外部邊界。

## 直接依賴圖

```mermaid
flowchart TD
	n0["klp_navigator_state.dart"]
	n1["../klp_navigator.dart"]
	n0 -->|"part of"| n1
```

## 依賴證據

| 關係 | 原始 directive | 來源 |
|---|---|---|
| part of | <code>part of &#x27;../klp_navigator.dart&#x27;;</code> | [lib/src/features/navigation/widgets/navigator/internal/klp_navigator_state.dart:1](../../../../../../../../lib/src/features/navigation/widgets/navigator/internal/klp_navigator_state.dart#L1) |

## 宣告關係圖

本組節點是本檔宣告；沒有箭頭的宣告未在此圖主張互相依賴。

```mermaid
classDiagram
	class n0["_KlpNavigatorState"]
```

```mermaid
classDiagram
	class n0["_KlpNavigatorState"]
	class n1["State&lt;KlpNavigator&gt;"]
	n0 --|> n1 : extends
```


## 宣告與成員證據

成員包含 public 與 private；簽章取自來源，省略函式本體與欄位初始值。`(inferred)` 表示來源未明寫型別；建構子只顯示參數部分，不含初始化列表。

### _KlpNavigatorState

ClassDeclaration · private · [lib/src/features/navigation/widgets/navigator/internal/klp_navigator_state.dart:3](../../../../../../../../lib/src/features/navigation/widgets/navigator/internal/klp_navigator_state.dart#L3)

<code>class _KlpNavigatorState extends State&lt;KlpNavigator&gt;</code>

- `extends` → <code>State&lt;KlpNavigator&gt;</code>：[lib/src/features/navigation/widgets/navigator/internal/klp_navigator_state.dart:3](../../../../../../../../lib/src/features/navigation/widgets/navigator/internal/klp_navigator_state.dart#L3)

| 成員 | 可見性 | 簽章／型別 | 來源註解摘要 | 證據 |
|---|---|---|---|---|
| field <code>_expandedCategoryIds</code> | private | <code>late final Set&lt;String&gt; _expandedCategoryIds</code> |  | [lib/src/features/navigation/widgets/navigator/internal/klp_navigator_state.dart:4](../../../../../../../../lib/src/features/navigation/widgets/navigator/internal/klp_navigator_state.dart#L4) |
| field <code>_expandedElementIds</code> | private | <code>late final Set&lt;String&gt; _expandedElementIds</code> |  | [lib/src/features/navigation/widgets/navigator/internal/klp_navigator_state.dart:5](../../../../../../../../lib/src/features/navigation/widgets/navigator/internal/klp_navigator_state.dart#L5) |
| field <code>_selectedElementId</code> | private | <code>String? _selectedElementId</code> |  | [lib/src/features/navigation/widgets/navigator/internal/klp_navigator_state.dart:6](../../../../../../../../lib/src/features/navigation/widgets/navigator/internal/klp_navigator_state.dart#L6) |
| method <code>initState</code> | public | <code>void initState()</code> |  | [lib/src/features/navigation/widgets/navigator/internal/klp_navigator_state.dart:8](../../../../../../../../lib/src/features/navigation/widgets/navigator/internal/klp_navigator_state.dart#L8) |
| method <code>_initialExpandedCategories</code> | private | <code>Set&lt;String&gt; _initialExpandedCategories()</code> |  | [lib/src/features/navigation/widgets/navigator/internal/klp_navigator_state.dart:14](../../../../../../../../lib/src/features/navigation/widgets/navigator/internal/klp_navigator_state.dart#L14) |
| method <code>_initialExpandedElements</code> | private | <code>Set&lt;String&gt; _initialExpandedElements()</code> |  | [lib/src/features/navigation/widgets/navigator/internal/klp_navigator_state.dart:34](../../../../../../../../lib/src/features/navigation/widgets/navigator/internal/klp_navigator_state.dart#L34) |
| method <code>_initialSelectedElement</code> | private | <code>String? _initialSelectedElement()</code> |  | [lib/src/features/navigation/widgets/navigator/internal/klp_navigator_state.dart:61](../../../../../../../../lib/src/features/navigation/widgets/navigator/internal/klp_navigator_state.dart#L61) |
| method <code>_toggleCategory</code> | private | <code>void _toggleCategory(String id)</code> |  | [lib/src/features/navigation/widgets/navigator/internal/klp_navigator_state.dart:90](../../../../../../../../lib/src/features/navigation/widgets/navigator/internal/klp_navigator_state.dart#L90) |
| method <code>_toggleElement</code> | private | <code>void _toggleElement(String id)</code> |  | [lib/src/features/navigation/widgets/navigator/internal/klp_navigator_state.dart:101](../../../../../../../../lib/src/features/navigation/widgets/navigator/internal/klp_navigator_state.dart#L101) |
| method <code>_selectElement</code> | private | <code>void _selectElement(String id)</code> |  | [lib/src/features/navigation/widgets/navigator/internal/klp_navigator_state.dart:112](../../../../../../../../lib/src/features/navigation/widgets/navigator/internal/klp_navigator_state.dart#L112) |
| method <code>build</code> | public | <code>Widget build(BuildContext context)</code> |  | [lib/src/features/navigation/widgets/navigator/internal/klp_navigator_state.dart:121](../../../../../../../../lib/src/features/navigation/widgets/navigator/internal/klp_navigator_state.dart#L121) |

## 閱讀說明與限制

箭頭只表示來源明寫的靜態關係；import 不等於呼叫。未分析動態呼叫、欄位的實際物件擁有權、狀態轉移或渲染流程；型別未進行語意解析，繼承目標保留原始型別拼寫。public／private 依 Dart 名稱前綴判斷；public 宣告不代表已由 `lib/kallopis.dart` 匯出。

本頁由 `tool/architecture_atlas` 產生；編輯來源或生成工具後重新產生，避免手改本頁。
