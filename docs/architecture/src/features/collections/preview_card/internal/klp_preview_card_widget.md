# klp_preview_card_widget.dart：直接依賴與宣告架構

[回到目錄](README.md) · [來源檔案](../../../../../../../lib/src/features/collections/preview_card/internal/klp_preview_card_widget.dart)

## 範圍

核心是 `lib/src/features/collections/preview_card/internal/klp_preview_card_widget.dart`。主要視角為該檔案明寫的 import／export／part；輔助視角為本檔宣告及 extends／implements／with／on 關係。只展開一層外部邊界。

## 直接依賴圖

```mermaid
flowchart TD
	n0["klp_preview_card_widget.dart"]
	n1["../klp_preview_card.dart"]
	n0 -->|"part of"| n1
```

## 依賴證據

| 關係 | 原始 directive | 來源 |
|---|---|---|
| part of | <code>part of &#x27;../klp_preview_card.dart&#x27;;</code> | [lib/src/features/collections/preview_card/internal/klp_preview_card_widget.dart:1](../../../../../../../lib/src/features/collections/preview_card/internal/klp_preview_card_widget.dart#L1) |

## 宣告關係圖

本組節點是本檔宣告；沒有箭頭的宣告未在此圖主張互相依賴。

```mermaid
classDiagram
	class n0["KlpPreviewCard"]
```

```mermaid
classDiagram
	class n0["KlpPreviewCard"]
	class n1["StatelessWidget"]
	n0 --|> n1 : extends
```


## 宣告與成員證據

成員包含 public 與 private；簽章取自來源，省略函式本體與欄位初始值。`(inferred)` 表示來源未明寫型別；建構子只顯示參數部分，不含初始化列表。

### KlpPreviewCard

ClassDeclaration · public · [lib/src/features/collections/preview_card/internal/klp_preview_card_widget.dart:3](../../../../../../../lib/src/features/collections/preview_card/internal/klp_preview_card_widget.dart#L3)

<code>class KlpPreviewCard extends StatelessWidget</code>

來源註解摘要：預覽內容、標題與中繼資訊的通用卡片。

- `extends` → <code>StatelessWidget</code>：[lib/src/features/collections/preview_card/internal/klp_preview_card_widget.dart:4](../../../../../../../lib/src/features/collections/preview_card/internal/klp_preview_card_widget.dart#L4)

| 成員 | 可見性 | 簽章／型別 | 來源註解摘要 | 證據 |
|---|---|---|---|---|
| constructor <code>KlpPreviewCard</code> | public | <code>const KlpPreviewCard({ super.key, required this.title, required this.preview, this.metadata = const [], this.previewSize = KlpPreviewCardSize.large, })</code> |  | [lib/src/features/collections/preview_card/internal/klp_preview_card_widget.dart:5](../../../../../../../lib/src/features/collections/preview_card/internal/klp_preview_card_widget.dart#L5) |
| field <code>title</code> | public | <code>final String title</code> |  | [lib/src/features/collections/preview_card/internal/klp_preview_card_widget.dart:13](../../../../../../../lib/src/features/collections/preview_card/internal/klp_preview_card_widget.dart#L13) |
| field <code>preview</code> | public | <code>final Widget preview</code> |  | [lib/src/features/collections/preview_card/internal/klp_preview_card_widget.dart:14](../../../../../../../lib/src/features/collections/preview_card/internal/klp_preview_card_widget.dart#L14) |
| field <code>metadata</code> | public | <code>final List&lt;String&gt; metadata</code> |  | [lib/src/features/collections/preview_card/internal/klp_preview_card_widget.dart:15](../../../../../../../lib/src/features/collections/preview_card/internal/klp_preview_card_widget.dart#L15) |
| field <code>previewSize</code> | public | <code>final KlpPreviewCardSize previewSize</code> |  | [lib/src/features/collections/preview_card/internal/klp_preview_card_widget.dart:16](../../../../../../../lib/src/features/collections/preview_card/internal/klp_preview_card_widget.dart#L16) |
| method <code>build</code> | public | <code>Widget build(BuildContext context)</code> |  | [lib/src/features/collections/preview_card/internal/klp_preview_card_widget.dart:18](../../../../../../../lib/src/features/collections/preview_card/internal/klp_preview_card_widget.dart#L18) |

## 閱讀說明與限制

箭頭只表示來源明寫的靜態關係；import 不等於呼叫。未分析動態呼叫、欄位的實際物件擁有權、狀態轉移或渲染流程；型別未進行語意解析，繼承目標保留原始型別拼寫。public／private 依 Dart 名稱前綴判斷；public 宣告不代表已由 `lib/kallopis.dart` 匯出。

本頁由 `tool/architecture_atlas` 產生；編輯來源或生成工具後重新產生，避免手改本頁。
