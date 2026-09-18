# klp_editing_layout.dart：直接依賴與宣告架構

[回到目錄](README.md) · [來源檔案](../../../../../../lib/src/capabilities/editing/contracts/klp_editing_layout.dart)

## 範圍

核心是 `lib/src/capabilities/editing/contracts/klp_editing_layout.dart`。主要視角為該檔案明寫的 import／export／part；輔助視角為本檔宣告及 extends／implements／with／on 關係。只展開一層外部邊界。

## 直接依賴圖

```mermaid
flowchart TD
	n0["klp_editing_layout.dart"]
	n1["klp_editing_style.dart"]
	n2["klp_editing_viewport.dart"]
	n0 -->|"import"| n1
	n0 -->|"import"| n2
```

## 依賴證據

| 關係 | 原始 directive | 來源 |
|---|---|---|
| import | <code>import &#x27;klp_editing_style.dart&#x27;;</code> | [lib/src/capabilities/editing/contracts/klp_editing_layout.dart:1](../../../../../../lib/src/capabilities/editing/contracts/klp_editing_layout.dart#L1) |
| import | <code>import &#x27;klp_editing_viewport.dart&#x27;;</code> | [lib/src/capabilities/editing/contracts/klp_editing_layout.dart:2](../../../../../../lib/src/capabilities/editing/contracts/klp_editing_layout.dart#L2) |

## 宣告關係圖

本組節點是本檔宣告；沒有箭頭的宣告未在此圖主張互相依賴。

```mermaid
classDiagram
	class n0["KlpEditingLayout"]
```


## 宣告與成員證據

成員包含 public 與 private；簽章取自來源，省略函式本體與欄位初始值。`(inferred)` 表示來源未明寫型別；建構子只顯示參數部分，不含初始化列表。

### KlpEditingLayout

ClassDeclaration · public · [lib/src/capabilities/editing/contracts/klp_editing_layout.dart:4](../../../../../../lib/src/capabilities/editing/contracts/klp_editing_layout.dart#L4)

<code>final class KlpEditingLayout</code>

來源註解摘要：一次完整重排要求；尺寸與風格不可分批套用。


| 成員 | 可見性 | 簽章／型別 | 來源註解摘要 | 證據 |
|---|---|---|---|---|
| field <code>viewport</code> | public | <code>final KlpEditingViewport viewport</code> |  | [lib/src/capabilities/editing/contracts/klp_editing_layout.dart:6](../../../../../../lib/src/capabilities/editing/contracts/klp_editing_layout.dart#L6) |
| field <code>style</code> | public | <code>final KlpEditingStyle style</code> |  | [lib/src/capabilities/editing/contracts/klp_editing_layout.dart:7](../../../../../../lib/src/capabilities/editing/contracts/klp_editing_layout.dart#L7) |
| constructor <code>KlpEditingLayout</code> | public | <code>const KlpEditingLayout({required this.viewport, required this.style})</code> |  | [lib/src/capabilities/editing/contracts/klp_editing_layout.dart:9](../../../../../../lib/src/capabilities/editing/contracts/klp_editing_layout.dart#L9) |
| method <code>validate</code> | public | <code>void validate()</code> |  | [lib/src/capabilities/editing/contracts/klp_editing_layout.dart:11](../../../../../../lib/src/capabilities/editing/contracts/klp_editing_layout.dart#L11) |

## 閱讀說明與限制

箭頭只表示來源明寫的靜態關係；import 不等於呼叫。未分析動態呼叫、欄位的實際物件擁有權、狀態轉移或渲染流程；型別未進行語意解析，繼承目標保留原始型別拼寫。public／private 依 Dart 名稱前綴判斷；public 宣告不代表已由 `lib/kallopis.dart` 匯出。

本頁由 `tool/architecture_atlas` 產生；編輯來源或生成工具後重新產生，避免手改本頁。
