# klp_command_menu_state.dart：直接依賴與宣告架構

[回到目錄](README.md) · [來源檔案](../../../../../../../lib/src/features/actions/command_menu/internal/klp_command_menu_state.dart)

## 範圍

核心是 `lib/src/features/actions/command_menu/internal/klp_command_menu_state.dart`。主要視角為該檔案明寫的 import／export／part；輔助視角為本檔宣告及 extends／implements／with／on 關係。只展開一層外部邊界。

## 直接依賴圖

```mermaid
flowchart TD
	n0["klp_command_menu_state.dart"]
	n1["../klp_command_menu.dart"]
	n0 -->|"part of"| n1
```

## 依賴證據

| 關係 | 原始 directive | 來源 |
|---|---|---|
| part of | <code>part of &#x27;../klp_command_menu.dart&#x27;;</code> | [lib/src/features/actions/command_menu/internal/klp_command_menu_state.dart:1](../../../../../../../lib/src/features/actions/command_menu/internal/klp_command_menu_state.dart#L1) |

## 宣告關係圖

本組節點是本檔宣告；沒有箭頭的宣告未在此圖主張互相依賴。

```mermaid
classDiagram
	class n0["_KlpCommandMenuState"]
```

```mermaid
classDiagram
	class n0["_KlpCommandMenuState"]
	class n1["State&lt;KlpCommandMenu&gt;"]
	n0 --|> n1 : extends
```


## 宣告與成員證據

成員包含 public 與 private；簽章取自來源，省略函式本體與欄位初始值。`(inferred)` 表示來源未明寫型別；建構子只顯示參數部分，不含初始化列表。

### _KlpCommandMenuState

ClassDeclaration · private · [lib/src/features/actions/command_menu/internal/klp_command_menu_state.dart:3](../../../../../../../lib/src/features/actions/command_menu/internal/klp_command_menu_state.dart#L3)

<code>class _KlpCommandMenuState extends State&lt;KlpCommandMenu&gt;</code>

- `extends` → <code>State&lt;KlpCommandMenu&gt;</code>：[lib/src/features/actions/command_menu/internal/klp_command_menu_state.dart:3](../../../../../../../lib/src/features/actions/command_menu/internal/klp_command_menu_state.dart#L3)

| 成員 | 可見性 | 簽章／型別 | 來源註解摘要 | 證據 |
|---|---|---|---|---|
| field <code>_highlightedIndex</code> | private | <code>int _highlightedIndex</code> |  | [lib/src/features/actions/command_menu/internal/klp_command_menu_state.dart:4](../../../../../../../lib/src/features/actions/command_menu/internal/klp_command_menu_state.dart#L4) |
| getter <code>_flatItems</code> | private | <code>List&lt;KlpCommandItemData&gt; get _flatItems</code> |  | [lib/src/features/actions/command_menu/internal/klp_command_menu_state.dart:6](../../../../../../../lib/src/features/actions/command_menu/internal/klp_command_menu_state.dart#L6) |
| method <code>_isEnabled</code> | private | <code>bool _isEnabled(int index)</code> |  | [lib/src/features/actions/command_menu/internal/klp_command_menu_state.dart:10](../../../../../../../lib/src/features/actions/command_menu/internal/klp_command_menu_state.dart#L10) |
| method <code>_handleKey</code> | private | <code>KeyEventResult _handleKey(FocusNode node, KeyEvent event)</code> |  | [lib/src/features/actions/command_menu/internal/klp_command_menu_state.dart:12](../../../../../../../lib/src/features/actions/command_menu/internal/klp_command_menu_state.dart#L12) |
| method <code>build</code> | public | <code>Widget build(BuildContext context)</code> |  | [lib/src/features/actions/command_menu/internal/klp_command_menu_state.dart:74](../../../../../../../lib/src/features/actions/command_menu/internal/klp_command_menu_state.dart#L74) |

## 閱讀說明與限制

箭頭只表示來源明寫的靜態關係；import 不等於呼叫。未分析動態呼叫、欄位的實際物件擁有權、狀態轉移或渲染流程；型別未進行語意解析，繼承目標保留原始型別拼寫。public／private 依 Dart 名稱前綴判斷；public 宣告不代表已由 `lib/kallopis.dart` 匯出。

本頁由 `tool/architecture_atlas` 產生；編輯來源或生成工具後重新產生，避免手改本頁。
