# klp_flutter_text_delta.dart：直接依賴與宣告架構

[回到目錄](README.md) · [來源檔案](../../../../../../lib/src/rendering/flutter/internal/klp_flutter_text_delta.dart)

## 範圍

核心是 `lib/src/rendering/flutter/internal/klp_flutter_text_delta.dart`。主要視角為該檔案明寫的 import／export／part；輔助視角為本檔宣告及 extends／implements／with／on 關係。只展開一層外部邊界。

## 直接依賴圖

```mermaid
flowchart TD
	n0["klp_flutter_text_delta.dart"]
	n1["package:flutter/services.dart"]
	n2["package:kallopis/src/capabilities/editing/contracts/klp_editing_text_window.dart"]
	n3["package:kallopis/src/capabilities/editing/contracts/klp_text_offsets.dart"]
	n0 -->|"import"| n1
	n0 -->|"import"| n2
	n0 -->|"import"| n3
```

## 依賴證據

| 關係 | 原始 directive | 來源 |
|---|---|---|
| import | <code>import &#x27;package:flutter/services.dart&#x27;;</code> | [lib/src/rendering/flutter/internal/klp_flutter_text_delta.dart:1](../../../../../../lib/src/rendering/flutter/internal/klp_flutter_text_delta.dart#L1) |
| import | <code>import &#x27;package:kallopis/src/capabilities/editing/contracts/klp_editing_text_window.dart&#x27;;</code> | [lib/src/rendering/flutter/internal/klp_flutter_text_delta.dart:3](../../../../../../lib/src/rendering/flutter/internal/klp_flutter_text_delta.dart#L3) |
| import | <code>import &#x27;package:kallopis/src/capabilities/editing/contracts/klp_text_offsets.dart&#x27;;</code> | [lib/src/rendering/flutter/internal/klp_flutter_text_delta.dart:4](../../../../../../lib/src/rendering/flutter/internal/klp_flutter_text_delta.dart#L4) |

## 宣告關係圖

本組節點是本檔宣告；沒有箭頭的宣告未在此圖主張互相依賴。

```mermaid
classDiagram
	class n0["KlpFlutterTextDelta"]
```


## 宣告與成員證據

成員包含 public 與 private；簽章取自來源，省略函式本體與欄位初始值。`(inferred)` 表示來源未明寫型別；建構子只顯示參數部分，不含初始化列表。

### KlpInputReplacement

GenericTypeAlias · public · [lib/src/rendering/flutter/internal/klp_flutter_text_delta.dart:6](../../../../../../lib/src/rendering/flutter/internal/klp_flutter_text_delta.dart#L6)

<code>typedef KlpInputReplacement = ({int startUtf8, int endUtf8, String text});</code>


### KlpFlutterTextDelta

ClassDeclaration · public · [lib/src/rendering/flutter/internal/klp_flutter_text_delta.dart:8](../../../../../../lib/src/rendering/flutter/internal/klp_flutter_text_delta.dart#L8)

<code>final class KlpFlutterTextDelta</code>

來源註解摘要：平台要求的更新，並非權威投影；所有結果位移均相對更新後的視窗文字。 不從組字範圍消失推定提交、取消或保存。


| 成員 | 可見性 | 簽章／型別 | 來源註解摘要 | 證據 |
|---|---|---|---|---|
| field <code>before</code> | public | <code>final KlpEditingTextWindow before</code> |  | [lib/src/rendering/flutter/internal/klp_flutter_text_delta.dart:12](../../../../../../lib/src/rendering/flutter/internal/klp_flutter_text_delta.dart#L12) |
| field <code>replacement</code> | public | <code>final KlpInputReplacement? replacement</code> |  | [lib/src/rendering/flutter/internal/klp_flutter_text_delta.dart:13](../../../../../../lib/src/rendering/flutter/internal/klp_flutter_text_delta.dart#L13) |
| field <code>requested</code> | public | <code>final KlpTextOffsets requested</code> |  | [lib/src/rendering/flutter/internal/klp_flutter_text_delta.dart:14](../../../../../../lib/src/rendering/flutter/internal/klp_flutter_text_delta.dart#L14) |
| field <code>anchorUtf8</code> | public | <code>final int? anchorUtf8</code> |  | [lib/src/rendering/flutter/internal/klp_flutter_text_delta.dart:15](../../../../../../lib/src/rendering/flutter/internal/klp_flutter_text_delta.dart#L15) |
| field <code>focusUtf8</code> | public | <code>final int? focusUtf8</code> |  | [lib/src/rendering/flutter/internal/klp_flutter_text_delta.dart:16](../../../../../../lib/src/rendering/flutter/internal/klp_flutter_text_delta.dart#L16) |
| field <code>composingStartUtf8</code> | public | <code>final int? composingStartUtf8</code> |  | [lib/src/rendering/flutter/internal/klp_flutter_text_delta.dart:17](../../../../../../lib/src/rendering/flutter/internal/klp_flutter_text_delta.dart#L17) |
| field <code>composingEndUtf8</code> | public | <code>final int? composingEndUtf8</code> |  | [lib/src/rendering/flutter/internal/klp_flutter_text_delta.dart:18](../../../../../../lib/src/rendering/flutter/internal/klp_flutter_text_delta.dart#L18) |
| constructor <code>_</code> | private | <code>KlpFlutterTextDelta._({ required this.before, required this.replacement, required this.requested, required this.anchorUtf8, required this.focusUtf8, required this.composingStartUtf8, required this.composingEndUtf8, })</code> |  | [lib/src/rendering/flutter/internal/klp_flutter_text_delta.dart:20](../../../../../../lib/src/rendering/flutter/internal/klp_flutter_text_delta.dart#L20) |
| constructor <code>decode</code> | public | <code>factory KlpFlutterTextDelta.decode(KlpEditingTextWindow before, TextEditingDelta delta)</code> |  | [lib/src/rendering/flutter/internal/klp_flutter_text_delta.dart:30](../../../../../../lib/src/rendering/flutter/internal/klp_flutter_text_delta.dart#L30) |

## 閱讀說明與限制

箭頭只表示來源明寫的靜態關係；import 不等於呼叫。未分析動態呼叫、欄位的實際物件擁有權、狀態轉移或渲染流程；型別未進行語意解析，繼承目標保留原始型別拼寫。public／private 依 Dart 名稱前綴判斷；public 宣告不代表已由 `lib/kallopis.dart` 匯出。

本頁由 `tool/architecture_atlas` 產生；編輯來源或生成工具後重新產生，避免手改本頁。
