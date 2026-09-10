# klp_geometric_spinner_state.dart：直接依賴與宣告架構

[回到目錄](README.md) · [來源檔案](../../../../lib/src/foundation/klp_geometric_spinner_state.dart)

## 範圍

核心是 `lib/src/foundation/klp_geometric_spinner_state.dart`。主要視角為該檔案明寫的 import／export／part；輔助視角為本檔宣告及 extends／implements／with／on 關係。只展開一層外部邊界。

## 直接依賴圖

```mermaid
flowchart TD
	n0["klp_geometric_spinner_state.dart"]
	n1["klp_geometric_spinner.dart"]
	n0 -->|"part of"| n1
```

## 依賴證據

| 關係 | 原始 directive | 來源 |
|---|---|---|
| part of | <code>part of &#x27;klp_geometric_spinner.dart&#x27;;</code> | [lib/src/foundation/klp_geometric_spinner_state.dart:1](../../../../lib/src/foundation/klp_geometric_spinner_state.dart#L1) |

## 宣告關係圖

本組節點是本檔宣告；沒有箭頭的宣告未在此圖主張互相依賴。

```mermaid
classDiagram
	class n0["_KlpGeometricSpinnerState"]
```

```mermaid
classDiagram
	class n0["_KlpGeometricSpinnerState"]
	class n1["State&lt;KlpGeometricSpinner&gt;"]
	class n2["SingleTickerProviderStateMixin"]
	n0 --|> n1 : extends
	n0 ..> n2 : with
```


## 宣告與成員證據

成員包含 public 與 private；簽章取自來源，省略函式本體與欄位初始值。`(inferred)` 表示來源未明寫型別；建構子只顯示參數部分，不含初始化列表。

### _KlpGeometricSpinnerState

ClassDeclaration · private · [lib/src/foundation/klp_geometric_spinner_state.dart:3](../../../../lib/src/foundation/klp_geometric_spinner_state.dart#L3)

<code>class _KlpGeometricSpinnerState extends State&lt;KlpGeometricSpinner&gt; with SingleTickerProviderStateMixin</code>

來源註解摘要：管理幾何載入圖示的循環動畫與 reduced-motion 狀態。

- `extends` → <code>State&lt;KlpGeometricSpinner&gt;</code>：[lib/src/foundation/klp_geometric_spinner_state.dart:4](../../../../lib/src/foundation/klp_geometric_spinner_state.dart#L4)
- `with` → <code>SingleTickerProviderStateMixin</code>：[lib/src/foundation/klp_geometric_spinner_state.dart:5](../../../../lib/src/foundation/klp_geometric_spinner_state.dart#L5)

| 成員 | 可見性 | 簽章／型別 | 來源註解摘要 | 證據 |
|---|---|---|---|---|
| field <code>_controller</code> | private | <code>late final AnimationController _controller</code> |  | [lib/src/foundation/klp_geometric_spinner_state.dart:6](../../../../lib/src/foundation/klp_geometric_spinner_state.dart#L6) |
| method <code>initState</code> | public | <code>void initState()</code> |  | [lib/src/foundation/klp_geometric_spinner_state.dart:8](../../../../lib/src/foundation/klp_geometric_spinner_state.dart#L8) |
| method <code>didChangeDependencies</code> | public | <code>void didChangeDependencies()</code> |  | [lib/src/foundation/klp_geometric_spinner_state.dart:14](../../../../lib/src/foundation/klp_geometric_spinner_state.dart#L14) |
| method <code>dispose</code> | public | <code>void dispose()</code> |  | [lib/src/foundation/klp_geometric_spinner_state.dart:25](../../../../lib/src/foundation/klp_geometric_spinner_state.dart#L25) |
| method <code>build</code> | public | <code>Widget build(BuildContext context)</code> |  | [lib/src/foundation/klp_geometric_spinner_state.dart:31](../../../../lib/src/foundation/klp_geometric_spinner_state.dart#L31) |

## 閱讀說明與限制

箭頭只表示來源明寫的靜態關係；import 不等於呼叫。未分析動態呼叫、欄位的實際物件擁有權、狀態轉移或渲染流程；型別未進行語意解析，繼承目標保留原始型別拼寫。public／private 依 Dart 名稱前綴判斷；public 宣告不代表已由 `lib/kallopis.dart` 匯出。

本頁由 `tool/architecture_atlas` 產生；編輯來源或生成工具後重新產生，避免手改本頁。
