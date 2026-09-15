# klp_flutter_text_input_batch.dart：直接依賴與宣告架構

[回到目錄](README.md) · [來源檔案](../../../../../../lib/src/rendering/flutter/internal/klp_flutter_text_input_batch.dart)

## 範圍

核心是 `lib/src/rendering/flutter/internal/klp_flutter_text_input_batch.dart`。主要視角為該檔案明寫的 import／export／part；輔助視角為本檔宣告及 extends／implements／with／on 關係。只展開一層外部邊界。

## 直接依賴圖

```mermaid
flowchart LR
	n0["klp_flutter_text_input_batch.dart"]
	n1["package:flutter/services.dart"]
	n2["klp_flutter_text_delta.dart"]
	n3["klp_flutter_text_input_result.dart"]
	n4["klp_flutter_text_input_session.dart"]
	n5["klp_flutter_text_plan.dart"]
	n0 -->|"import"| n1
	n0 -->|"import"| n2
	n0 -->|"import"| n3
	n0 -->|"import"| n4
	n0 -->|"import"| n5
```

## 依賴證據

| 關係 | 原始 directive | 來源 |
|---|---|---|
| import | <code>import &#x27;package:flutter/services.dart&#x27;;</code> | [lib/src/rendering/flutter/internal/klp_flutter_text_input_batch.dart:1](../../../../../../lib/src/rendering/flutter/internal/klp_flutter_text_input_batch.dart#L1) |
| import | <code>import &#x27;klp_flutter_text_delta.dart&#x27;;</code> | [lib/src/rendering/flutter/internal/klp_flutter_text_input_batch.dart:3](../../../../../../lib/src/rendering/flutter/internal/klp_flutter_text_input_batch.dart#L3) |
| import | <code>import &#x27;klp_flutter_text_input_result.dart&#x27;;</code> | [lib/src/rendering/flutter/internal/klp_flutter_text_input_batch.dart:4](../../../../../../lib/src/rendering/flutter/internal/klp_flutter_text_input_batch.dart#L4) |
| import | <code>import &#x27;klp_flutter_text_input_session.dart&#x27;;</code> | [lib/src/rendering/flutter/internal/klp_flutter_text_input_batch.dart:5](../../../../../../lib/src/rendering/flutter/internal/klp_flutter_text_input_batch.dart#L5) |
| import | <code>import &#x27;klp_flutter_text_plan.dart&#x27;;</code> | [lib/src/rendering/flutter/internal/klp_flutter_text_input_batch.dart:6](../../../../../../lib/src/rendering/flutter/internal/klp_flutter_text_input_batch.dart#L6) |

## 宣告關係圖

本組節點是本檔宣告；沒有箭頭的宣告未在此圖主張互相依賴。

```mermaid
classDiagram
	class n0["KlpFlutterTextInputBatch"]
```


## 宣告與成員證據

成員包含 public 與 private；簽章取自來源，省略函式本體與欄位初始值。`(inferred)` 表示來源未明寫型別；建構子只顯示參數部分，不含初始化列表。

### KlpFlutterTextInputBatch

ClassDeclaration · public · [lib/src/rendering/flutter/internal/klp_flutter_text_input_batch.dart:8](../../../../../../lib/src/rendering/flutter/internal/klp_flutter_text_input_batch.dart#L8)

<code>final class KlpFlutterTextInputBatch</code>

來源註解摘要：單一平台 callback 的 delta 序列；每步等待權威並改用最新 window。


| 成員 | 可見性 | 簽章／型別 | 來源註解摘要 | 證據 |
|---|---|---|---|---|
| field <code>_session</code> | private | <code>final KlpFlutterTextInputSession _session</code> |  | [lib/src/rendering/flutter/internal/klp_flutter_text_input_batch.dart:10](../../../../../../lib/src/rendering/flutter/internal/klp_flutter_text_input_batch.dart#L10) |
| field <code>_busy</code> | private | <code>bool _busy</code> |  | [lib/src/rendering/flutter/internal/klp_flutter_text_input_batch.dart:11](../../../../../../lib/src/rendering/flutter/internal/klp_flutter_text_input_batch.dart#L11) |
| constructor <code>KlpFlutterTextInputBatch</code> | public | <code>KlpFlutterTextInputBatch(this._session)</code> |  | [lib/src/rendering/flutter/internal/klp_flutter_text_input_batch.dart:13](../../../../../../lib/src/rendering/flutter/internal/klp_flutter_text_input_batch.dart#L13) |
| method <code>submit</code> | public | <code>Future&lt;KlpFlutterTextInputResult?&gt; submit( List&lt;TextEditingDelta&gt; deltas, { required bool Function() interrupted, void Function(KlpFlutterTextInputResult result)? onStep, })</code> |  | [lib/src/rendering/flutter/internal/klp_flutter_text_input_batch.dart:15](../../../../../../lib/src/rendering/flutter/internal/klp_flutter_text_input_batch.dart#L15) |

## 閱讀說明與限制

箭頭只表示來源明寫的靜態關係；import 不等於呼叫。未分析動態呼叫、欄位的實際物件擁有權、狀態轉移或渲染流程；型別未進行語意解析，繼承目標保留原始型別拼寫。public／private 依 Dart 名稱前綴判斷；public 宣告不代表已由 `lib/kallopis.dart` 匯出。

本頁由 `tool/architecture_atlas` 產生；編輯來源或生成工具後重新產生，避免手改本頁。
