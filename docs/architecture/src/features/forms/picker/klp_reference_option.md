# klp_reference_option.dart：直接依賴與宣告架構

[回到目錄](README.md) · [來源檔案](../../../../../../lib/src/features/forms/picker/klp_reference_option.dart)

## 範圍

核心是 `lib/src/features/forms/picker/klp_reference_option.dart`。主要視角為該檔案明寫的 import／export／part；輔助視角為本檔宣告及 extends／implements／with／on 關係。只展開一層外部邊界。

## 直接依賴圖

```mermaid
flowchart TD
	n0["klp_reference_option.dart"]
	n1["package:flutter/foundation.dart"]
	n0 -->|"import"| n1
```

## 依賴證據

| 關係 | 原始 directive | 來源 |
|---|---|---|
| import | <code>import &#x27;package:flutter/foundation.dart&#x27;;</code> | [lib/src/features/forms/picker/klp_reference_option.dart:1](../../../../../../lib/src/features/forms/picker/klp_reference_option.dart#L1) |

## 宣告關係圖

本組節點是本檔宣告；沒有箭頭的宣告未在此圖主張互相依賴。

```mermaid
classDiagram
	class n0["KlpReferenceOption"]
```


## 宣告與成員證據

成員包含 public 與 private；簽章取自來源，省略函式本體與欄位初始值。`(inferred)` 表示來源未明寫型別；建構子只顯示參數部分，不含初始化列表。

### KlpReferenceOption

ClassDeclaration · public · [lib/src/features/forms/picker/klp_reference_option.dart:3](../../../../../../lib/src/features/forms/picker/klp_reference_option.dart#L3)

<code>class KlpReferenceOption</code>

來源註解摘要：參照選擇器投影的一筆中性選項資料。


| 成員 | 可見性 | 簽章／型別 | 來源註解摘要 | 證據 |
|---|---|---|---|---|
| constructor <code>KlpReferenceOption</code> | public | <code>const KlpReferenceOption({ required this.id, required this.label, this.kind, this.metadata, this.disabled = false, })</code> |  | [lib/src/features/forms/picker/klp_reference_option.dart:6](../../../../../../lib/src/features/forms/picker/klp_reference_option.dart#L6) |
| field <code>id</code> | public | <code>final String id</code> |  | [lib/src/features/forms/picker/klp_reference_option.dart:14](../../../../../../lib/src/features/forms/picker/klp_reference_option.dart#L14) |
| field <code>label</code> | public | <code>final String label</code> |  | [lib/src/features/forms/picker/klp_reference_option.dart:15](../../../../../../lib/src/features/forms/picker/klp_reference_option.dart#L15) |
| field <code>kind</code> | public | <code>final String? kind</code> |  | [lib/src/features/forms/picker/klp_reference_option.dart:16](../../../../../../lib/src/features/forms/picker/klp_reference_option.dart#L16) |
| field <code>metadata</code> | public | <code>final String? metadata</code> |  | [lib/src/features/forms/picker/klp_reference_option.dart:17](../../../../../../lib/src/features/forms/picker/klp_reference_option.dart#L17) |
| field <code>disabled</code> | public | <code>final bool disabled</code> |  | [lib/src/features/forms/picker/klp_reference_option.dart:18](../../../../../../lib/src/features/forms/picker/klp_reference_option.dart#L18) |

## 閱讀說明與限制

箭頭只表示來源明寫的靜態關係；import 不等於呼叫。未分析動態呼叫、欄位的實際物件擁有權、狀態轉移或渲染流程；型別未進行語意解析，繼承目標保留原始型別拼寫。public／private 依 Dart 名稱前綴判斷；public 宣告不代表已由 `lib/kallopis.dart` 匯出。

本頁由 `tool/architecture_atlas` 產生；編輯來源或生成工具後重新產生，避免手改本頁。
