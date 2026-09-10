# klp_search_navigator.dart：直接依賴與宣告架構

[回到目錄](README.md) · [來源檔案](../../../../../../lib/src/features/actions/editor/klp_search_navigator.dart)

## 範圍

核心是 `lib/src/features/actions/editor/klp_search_navigator.dart`。主要視角為該檔案明寫的 import／export／part；輔助視角為本檔宣告及 extends／implements／with／on 關係。只展開一層外部邊界。

## 直接依賴圖

```mermaid
flowchart TD
	n0["klp_search_navigator.dart"]
	n1["klp_editor_action_bars.dart"]
	n0 -->|"part of"| n1
```

## 依賴證據

| 關係 | 原始 directive | 來源 |
|---|---|---|
| part of | <code>part of &#x27;klp_editor_action_bars.dart&#x27;;</code> | [lib/src/features/actions/editor/klp_search_navigator.dart:1](../../../../../../lib/src/features/actions/editor/klp_search_navigator.dart#L1) |

## 宣告關係圖

本組節點是本檔宣告；沒有箭頭的宣告未在此圖主張互相依賴。

```mermaid
classDiagram
	class n0["KlpSearchNavigator"]
```

```mermaid
classDiagram
	class n0["KlpSearchNavigator"]
	class n1["StatelessWidget"]
	n0 --|> n1 : extends
```


## 宣告與成員證據

成員包含 public 與 private；簽章取自來源，省略函式本體與欄位初始值。`(inferred)` 表示來源未明寫型別；建構子只顯示參數部分，不含初始化列表。

### KlpSearchNavigator

ClassDeclaration · public · [lib/src/features/actions/editor/klp_search_navigator.dart:3](../../../../../../lib/src/features/actions/editor/klp_search_navigator.dart#L3)

<code>class KlpSearchNavigator extends StatelessWidget</code>

來源註解摘要：呈現搜尋輸入、結果位置與前後導覽動作。

- `extends` → <code>StatelessWidget</code>：[lib/src/features/actions/editor/klp_search_navigator.dart:4](../../../../../../lib/src/features/actions/editor/klp_search_navigator.dart#L4)

| 成員 | 可見性 | 簽章／型別 | 來源註解摘要 | 證據 |
|---|---|---|---|---|
| constructor <code>KlpSearchNavigator</code> | public | <code>const KlpSearchNavigator({ super.key, required this.initialQuery, required this.current, required this.total, required this.onPrevious, required this.onNext, required this.onClose, this.onQueryChanged, })</code> |  | [lib/src/features/actions/editor/klp_search_navigator.dart:5](../../../../../../lib/src/features/actions/editor/klp_search_navigator.dart#L5) |
| field <code>initialQuery</code> | public | <code>final String initialQuery</code> |  | [lib/src/features/actions/editor/klp_search_navigator.dart:16](../../../../../../lib/src/features/actions/editor/klp_search_navigator.dart#L16) |
| field <code>current</code> | public | <code>final int current</code> |  | [lib/src/features/actions/editor/klp_search_navigator.dart:17](../../../../../../lib/src/features/actions/editor/klp_search_navigator.dart#L17) |
| field <code>total</code> | public | <code>final int total</code> |  | [lib/src/features/actions/editor/klp_search_navigator.dart:18](../../../../../../lib/src/features/actions/editor/klp_search_navigator.dart#L18) |
| field <code>onPrevious</code> | public | <code>final VoidCallback? onPrevious</code> |  | [lib/src/features/actions/editor/klp_search_navigator.dart:19](../../../../../../lib/src/features/actions/editor/klp_search_navigator.dart#L19) |
| field <code>onNext</code> | public | <code>final VoidCallback? onNext</code> |  | [lib/src/features/actions/editor/klp_search_navigator.dart:20](../../../../../../lib/src/features/actions/editor/klp_search_navigator.dart#L20) |
| field <code>onClose</code> | public | <code>final VoidCallback? onClose</code> |  | [lib/src/features/actions/editor/klp_search_navigator.dart:21](../../../../../../lib/src/features/actions/editor/klp_search_navigator.dart#L21) |
| field <code>onQueryChanged</code> | public | <code>final ValueChanged&lt;String&gt;? onQueryChanged</code> |  | [lib/src/features/actions/editor/klp_search_navigator.dart:22](../../../../../../lib/src/features/actions/editor/klp_search_navigator.dart#L22) |
| method <code>build</code> | public | <code>Widget build(BuildContext context)</code> |  | [lib/src/features/actions/editor/klp_search_navigator.dart:24](../../../../../../lib/src/features/actions/editor/klp_search_navigator.dart#L24) |

## 閱讀說明與限制

箭頭只表示來源明寫的靜態關係；import 不等於呼叫。未分析動態呼叫、欄位的實際物件擁有權、狀態轉移或渲染流程；型別未進行語意解析，繼承目標保留原始型別拼寫。public／private 依 Dart 名稱前綴判斷；public 宣告不代表已由 `lib/kallopis.dart` 匯出。

本頁由 `tool/architecture_atlas` 產生；編輯來源或生成工具後重新產生，避免手改本頁。
