# klp_file_preview_body.dart：直接依賴與宣告架構

[回到目錄](README.md) · [來源檔案](../../../../../../../lib/src/features/collections/advanced/internal/klp_file_preview_body.dart)

## 範圍

核心是 `lib/src/features/collections/advanced/internal/klp_file_preview_body.dart`。主要視角為該檔案明寫的 import／export／part；輔助視角為本檔宣告及 extends／implements／with／on 關係。只展開一層外部邊界。

## 直接依賴圖

```mermaid
flowchart TD
	n0["klp_file_preview_body.dart"]
	n1["../klp_advanced_data.dart"]
	n0 -->|"part of"| n1
```

## 依賴證據

| 關係 | 原始 directive | 來源 |
|---|---|---|
| part of | <code>part of &#x27;../klp_advanced_data.dart&#x27;;</code> | [lib/src/features/collections/advanced/internal/klp_file_preview_body.dart:1](../../../../../../../lib/src/features/collections/advanced/internal/klp_file_preview_body.dart#L1) |

## 宣告關係圖

本組節點是本檔宣告；沒有箭頭的宣告未在此圖主張互相依賴。

```mermaid
classDiagram
	class n0["_KlpFilePreviewBody"]
```

```mermaid
classDiagram
	class n0["_KlpFilePreviewBody"]
	class n1["StatelessWidget"]
	n0 --|> n1 : extends
```


## 宣告與成員證據

成員包含 public 與 private；簽章取自來源，省略函式本體與欄位初始值。`(inferred)` 表示來源未明寫型別；建構子只顯示參數部分，不含初始化列表。

### _KlpFilePreviewBody

ClassDeclaration · private · [lib/src/features/collections/advanced/internal/klp_file_preview_body.dart:3](../../../../../../../lib/src/features/collections/advanced/internal/klp_file_preview_body.dart#L3)

<code>class _KlpFilePreviewBody extends StatelessWidget</code>

- `extends` → <code>StatelessWidget</code>：[lib/src/features/collections/advanced/internal/klp_file_preview_body.dart:3](../../../../../../../lib/src/features/collections/advanced/internal/klp_file_preview_body.dart#L3)

| 成員 | 可見性 | 簽章／型別 | 來源註解摘要 | 證據 |
|---|---|---|---|---|
| constructor <code>_KlpFilePreviewBody</code> | private | <code>const _KlpFilePreviewBody({ required this.state, required this.extension, required this.preview, required this.textContent, required this.labels, })</code> |  | [lib/src/features/collections/advanced/internal/klp_file_preview_body.dart:4](../../../../../../../lib/src/features/collections/advanced/internal/klp_file_preview_body.dart#L4) |
| field <code>state</code> | public | <code>final KlpFilePreviewState state</code> |  | [lib/src/features/collections/advanced/internal/klp_file_preview_body.dart:12](../../../../../../../lib/src/features/collections/advanced/internal/klp_file_preview_body.dart#L12) |
| field <code>extension</code> | public | <code>final String extension</code> |  | [lib/src/features/collections/advanced/internal/klp_file_preview_body.dart:13](../../../../../../../lib/src/features/collections/advanced/internal/klp_file_preview_body.dart#L13) |
| field <code>preview</code> | public | <code>final Widget? preview</code> |  | [lib/src/features/collections/advanced/internal/klp_file_preview_body.dart:14](../../../../../../../lib/src/features/collections/advanced/internal/klp_file_preview_body.dart#L14) |
| field <code>textContent</code> | public | <code>final String? textContent</code> |  | [lib/src/features/collections/advanced/internal/klp_file_preview_body.dart:15](../../../../../../../lib/src/features/collections/advanced/internal/klp_file_preview_body.dart#L15) |
| field <code>labels</code> | public | <code>final KlpLocalizations labels</code> |  | [lib/src/features/collections/advanced/internal/klp_file_preview_body.dart:16](../../../../../../../lib/src/features/collections/advanced/internal/klp_file_preview_body.dart#L16) |
| method <code>build</code> | public | <code>Widget build(BuildContext context)</code> |  | [lib/src/features/collections/advanced/internal/klp_file_preview_body.dart:18](../../../../../../../lib/src/features/collections/advanced/internal/klp_file_preview_body.dart#L18) |
| method <code>_readyBody</code> | private | <code>Widget _readyBody()</code> |  | [lib/src/features/collections/advanced/internal/klp_file_preview_body.dart:54](../../../../../../../lib/src/features/collections/advanced/internal/klp_file_preview_body.dart#L54) |

## 閱讀說明與限制

箭頭只表示來源明寫的靜態關係；import 不等於呼叫。未分析動態呼叫、欄位的實際物件擁有權、狀態轉移或渲染流程；型別未進行語意解析，繼承目標保留原始型別拼寫。public／private 依 Dart 名稱前綴判斷；public 宣告不代表已由 `lib/kallopis.dart` 匯出。

本頁由 `tool/architecture_atlas` 產生；編輯來源或生成工具後重新產生，避免手改本頁。
