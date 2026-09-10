# klp_terminal_mark.dart：直接依賴與宣告架構

[回到目錄](README.md) · [來源檔案](../../../../../../../lib/src/features/collections/code/internal/klp_terminal_mark.dart)

## 範圍

核心是 `lib/src/features/collections/code/internal/klp_terminal_mark.dart`。主要視角為該檔案明寫的 import／export／part；輔助視角為本檔宣告及 extends／implements／with／on 關係。只展開一層外部邊界。

## 直接依賴圖

```mermaid
flowchart TD
	n0["klp_terminal_mark.dart"]
	n1["../klp_code_viewer.dart"]
	n0 -->|"part of"| n1
```

## 依賴證據

| 關係 | 原始 directive | 來源 |
|---|---|---|
| part of | <code>part of &#x27;../klp_code_viewer.dart&#x27;;</code> | [lib/src/features/collections/code/internal/klp_terminal_mark.dart:1](../../../../../../../lib/src/features/collections/code/internal/klp_terminal_mark.dart#L1) |

## 宣告關係圖

本組節點是本檔宣告；沒有箭頭的宣告未在此圖主張互相依賴。

```mermaid
classDiagram
	class n0["_KlpTerminalMark"]
```

```mermaid
classDiagram
	class n0["_KlpTerminalMark"]
	class n1["StatelessWidget"]
	n0 --|> n1 : extends
```


## 宣告與成員證據

成員包含 public 與 private；簽章取自來源，省略函式本體與欄位初始值。`(inferred)` 表示來源未明寫型別；建構子只顯示參數部分，不含初始化列表。

### _KlpTerminalMark

ClassDeclaration · private · [lib/src/features/collections/code/internal/klp_terminal_mark.dart:3](../../../../../../../lib/src/features/collections/code/internal/klp_terminal_mark.dart#L3)

<code>class _KlpTerminalMark extends StatelessWidget</code>

- `extends` → <code>StatelessWidget</code>：[lib/src/features/collections/code/internal/klp_terminal_mark.dart:3](../../../../../../../lib/src/features/collections/code/internal/klp_terminal_mark.dart#L3)

| 成員 | 可見性 | 簽章／型別 | 來源註解摘要 | 證據 |
|---|---|---|---|---|
| constructor <code>_KlpTerminalMark</code> | private | <code>const _KlpTerminalMark({required this.style})</code> |  | [lib/src/features/collections/code/internal/klp_terminal_mark.dart:4](../../../../../../../lib/src/features/collections/code/internal/klp_terminal_mark.dart#L4) |
| field <code>style</code> | public | <code>final _KlpCodeStyle style</code> |  | [lib/src/features/collections/code/internal/klp_terminal_mark.dart:6](../../../../../../../lib/src/features/collections/code/internal/klp_terminal_mark.dart#L6) |
| method <code>build</code> | public | <code>Widget build(BuildContext context)</code> |  | [lib/src/features/collections/code/internal/klp_terminal_mark.dart:8](../../../../../../../lib/src/features/collections/code/internal/klp_terminal_mark.dart#L8) |

## 閱讀說明與限制

箭頭只表示來源明寫的靜態關係；import 不等於呼叫。未分析動態呼叫、欄位的實際物件擁有權、狀態轉移或渲染流程；型別未進行語意解析，繼承目標保留原始型別拼寫。public／private 依 Dart 名稱前綴判斷；public 宣告不代表已由 `lib/kallopis.dart` 匯出。

本頁由 `tool/architecture_atlas` 產生；編輯來源或生成工具後重新產生，避免手改本頁。
