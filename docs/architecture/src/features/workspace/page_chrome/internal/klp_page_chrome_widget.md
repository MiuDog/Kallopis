# klp_page_chrome_widget.dart：直接依賴與宣告架構

[回到目錄](README.md) · [來源檔案](../../../../../../../lib/src/features/workspace/page_chrome/internal/klp_page_chrome_widget.dart)

## 範圍

核心是 `lib/src/features/workspace/page_chrome/internal/klp_page_chrome_widget.dart`。主要視角為該檔案明寫的 import／export／part；輔助視角為本檔宣告及 extends／implements／with／on 關係。只展開一層外部邊界。

## 直接依賴圖

```mermaid
flowchart TD
	n0["klp_page_chrome_widget.dart"]
	n1["../klp_page_chrome.dart"]
	n0 -->|"part of"| n1
```

## 依賴證據

| 關係 | 原始 directive | 來源 |
|---|---|---|
| part of | <code>part of &#x27;../klp_page_chrome.dart&#x27;;</code> | [lib/src/features/workspace/page_chrome/internal/klp_page_chrome_widget.dart:1](../../../../../../../lib/src/features/workspace/page_chrome/internal/klp_page_chrome_widget.dart#L1) |

## 宣告關係圖

本組節點是本檔宣告；沒有箭頭的宣告未在此圖主張互相依賴。

```mermaid
classDiagram
	class n0["KlpPageChrome"]
```

```mermaid
classDiagram
	class n0["KlpPageChrome"]
	class n1["StatelessWidget"]
	n0 --|> n1 : extends
```


## 宣告與成員證據

成員包含 public 與 private；簽章取自來源，省略函式本體與欄位初始值。`(inferred)` 表示來源未明寫型別；建構子只顯示參數部分，不含初始化列表。

### KlpPageChrome

ClassDeclaration · public · [lib/src/features/workspace/page_chrome/internal/klp_page_chrome_widget.dart:3](../../../../../../../lib/src/features/workspace/page_chrome/internal/klp_page_chrome_widget.dart#L3)

<code>class KlpPageChrome extends StatelessWidget</code>

來源註解摘要：頁面頂部的識別區塊：麵包屑導覽、選填的狀態文字與協作者標記，以及頁面 大標題。 [breadcrumb] 以 `/` 串接顯示，不提供逐段可點擊的導覽——需要可點擊麵包屑 請改用 [KlpBreadcrumb]。[status] 與 [collaborator] 都是單一文字，若要顯示 多位協作者或多筆狀態，需自行組合字串或改用其他元件。

- `extends` → <code>StatelessWidget</code>：[lib/src/features/workspace/page_chrome/internal/klp_page_chrome_widget.dart:9](../../../../../../../lib/src/features/workspace/page_chrome/internal/klp_page_chrome_widget.dart#L9)

| 成員 | 可見性 | 簽章／型別 | 來源註解摘要 | 證據 |
|---|---|---|---|---|
| constructor <code>KlpPageChrome</code> | public | <code>const KlpPageChrome({ super.key, required this.breadcrumb, required this.title, this.status, this.collaborator, })</code> |  | [lib/src/features/workspace/page_chrome/internal/klp_page_chrome_widget.dart:10](../../../../../../../lib/src/features/workspace/page_chrome/internal/klp_page_chrome_widget.dart#L10) |
| field <code>breadcrumb</code> | public | <code>final List&lt;String&gt; breadcrumb</code> |  | [lib/src/features/workspace/page_chrome/internal/klp_page_chrome_widget.dart:18](../../../../../../../lib/src/features/workspace/page_chrome/internal/klp_page_chrome_widget.dart#L18) |
| field <code>title</code> | public | <code>final String title</code> |  | [lib/src/features/workspace/page_chrome/internal/klp_page_chrome_widget.dart:19](../../../../../../../lib/src/features/workspace/page_chrome/internal/klp_page_chrome_widget.dart#L19) |
| field <code>status</code> | public | <code>final String? status</code> |  | [lib/src/features/workspace/page_chrome/internal/klp_page_chrome_widget.dart:20](../../../../../../../lib/src/features/workspace/page_chrome/internal/klp_page_chrome_widget.dart#L20) |
| field <code>collaborator</code> | public | <code>final String? collaborator</code> |  | [lib/src/features/workspace/page_chrome/internal/klp_page_chrome_widget.dart:21](../../../../../../../lib/src/features/workspace/page_chrome/internal/klp_page_chrome_widget.dart#L21) |
| method <code>build</code> | public | <code>Widget build(BuildContext context)</code> |  | [lib/src/features/workspace/page_chrome/internal/klp_page_chrome_widget.dart:23](../../../../../../../lib/src/features/workspace/page_chrome/internal/klp_page_chrome_widget.dart#L23) |

## 閱讀說明與限制

箭頭只表示來源明寫的靜態關係；import 不等於呼叫。未分析動態呼叫、欄位的實際物件擁有權、狀態轉移或渲染流程；型別未進行語意解析，繼承目標保留原始型別拼寫。public／private 依 Dart 名稱前綴判斷；public 宣告不代表已由 `lib/kallopis.dart` 匯出。

本頁由 `tool/architecture_atlas` 產生；編輯來源或生成工具後重新產生，避免手改本頁。
