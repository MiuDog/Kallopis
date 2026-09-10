# klp_tag_chip.dart：直接依賴與宣告架構

[回到目錄](README.md) · [來源檔案](../../../../../../lib/src/features/forms/selection/klp_tag_chip.dart)

## 範圍

核心是 `lib/src/features/forms/selection/klp_tag_chip.dart`。主要視角為該檔案明寫的 import／export／part；輔助視角為本檔宣告及 extends／implements／with／on 關係。只展開一層外部邊界。

## 直接依賴圖

```mermaid
flowchart TD
	n0["klp_tag_chip.dart"]
	n1["../internal/klp_form_dependencies.dart"]
	n2["primitives/klp_tag_chip_frame.dart"]
	n0 -->|"import"| n1
	n0 -->|"part"| n2
```

## 依賴證據

| 關係 | 原始 directive | 來源 |
|---|---|---|
| import | <code>import &#x27;../internal/klp_form_dependencies.dart&#x27;;</code> | [lib/src/features/forms/selection/klp_tag_chip.dart:1](../../../../../../lib/src/features/forms/selection/klp_tag_chip.dart#L1) |
| part | <code>part &#x27;primitives/klp_tag_chip_frame.dart&#x27;;</code> | [lib/src/features/forms/selection/klp_tag_chip.dart:3](../../../../../../lib/src/features/forms/selection/klp_tag_chip.dart#L3) |

## 宣告關係圖

本組節點是本檔宣告；沒有箭頭的宣告未在此圖主張互相依賴。

```mermaid
classDiagram
	class n0["KlpTagChip"]
```

```mermaid
classDiagram
	class n0["KlpTagChip"]
	class n1["StatelessWidget"]
	n0 --|> n1 : extends
```


## 宣告與成員證據

成員包含 public 與 private；簽章取自來源，省略函式本體與欄位初始值。`(inferred)` 表示來源未明寫型別；建構子只顯示參數部分，不含初始化列表。

### KlpTagChip

ClassDeclaration · public · [lib/src/features/forms/selection/klp_tag_chip.dart:5](../../../../../../lib/src/features/forms/selection/klp_tag_chip.dart#L5)

<code>class KlpTagChip extends StatelessWidget</code>

來源註解摘要：標籤膠囊元件。呈現單一標籤並支援移除操作。

- `extends` → <code>StatelessWidget</code>：[lib/src/features/forms/selection/klp_tag_chip.dart:6](../../../../../../lib/src/features/forms/selection/klp_tag_chip.dart#L6)

| 成員 | 可見性 | 簽章／型別 | 來源註解摘要 | 證據 |
|---|---|---|---|---|
| constructor <code>KlpTagChip</code> | public | <code>const KlpTagChip({super.key, required this.label, this.onRemove})</code> |  | [lib/src/features/forms/selection/klp_tag_chip.dart:7](../../../../../../lib/src/features/forms/selection/klp_tag_chip.dart#L7) |
| field <code>label</code> | public | <code>final String label</code> |  | [lib/src/features/forms/selection/klp_tag_chip.dart:9](../../../../../../lib/src/features/forms/selection/klp_tag_chip.dart#L9) |
| field <code>onRemove</code> | public | <code>final VoidCallback? onRemove</code> |  | [lib/src/features/forms/selection/klp_tag_chip.dart:10](../../../../../../lib/src/features/forms/selection/klp_tag_chip.dart#L10) |
| method <code>build</code> | public | <code>Widget build(BuildContext context)</code> |  | [lib/src/features/forms/selection/klp_tag_chip.dart:12](../../../../../../lib/src/features/forms/selection/klp_tag_chip.dart#L12) |

## 閱讀說明與限制

箭頭只表示來源明寫的靜態關係；import 不等於呼叫。未分析動態呼叫、欄位的實際物件擁有權、狀態轉移或渲染流程；型別未進行語意解析，繼承目標保留原始型別拼寫。public／private 依 Dart 名稱前綴判斷；public 宣告不代表已由 `lib/kallopis.dart` 匯出。

本頁由 `tool/architecture_atlas` 產生；編輯來源或生成工具後重新產生，避免手改本頁。
