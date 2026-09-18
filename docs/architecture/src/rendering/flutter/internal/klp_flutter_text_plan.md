# klp_flutter_text_plan.dart：直接依賴與宣告架構

[回到目錄](README.md) · [來源檔案](../../../../../../lib/src/rendering/flutter/internal/klp_flutter_text_plan.dart)

## 範圍

核心是 `lib/src/rendering/flutter/internal/klp_flutter_text_plan.dart`。主要視角為該檔案明寫的 import／export／part；輔助視角為本檔宣告及 extends／implements／with／on 關係。只展開一層外部邊界。

## 直接依賴圖

```mermaid
flowchart LR
	n0["klp_flutter_text_plan.dart"]
	n1["package:kallopis/src/capabilities/editing/contracts/klp_composition_text.dart"]
	n2["package:kallopis/src/capabilities/editing/contracts/klp_editing_intent.dart"]
	n3["package:kallopis/src/capabilities/editing/contracts/klp_text_offsets.dart"]
	n4["klp_flutter_text_delta.dart"]
	n0 -->|"import"| n1
	n0 -->|"import"| n2
	n0 -->|"import"| n3
	n0 -->|"import"| n4
```

## 依賴證據

| 關係 | 原始 directive | 來源 |
|---|---|---|
| import | <code>import &#x27;package:kallopis/src/capabilities/editing/contracts/klp_composition_text.dart&#x27;;</code> | [lib/src/rendering/flutter/internal/klp_flutter_text_plan.dart:1](../../../../../../lib/src/rendering/flutter/internal/klp_flutter_text_plan.dart#L1) |
| import | <code>import &#x27;package:kallopis/src/capabilities/editing/contracts/klp_editing_intent.dart&#x27;;</code> | [lib/src/rendering/flutter/internal/klp_flutter_text_plan.dart:2](../../../../../../lib/src/rendering/flutter/internal/klp_flutter_text_plan.dart#L2) |
| import | <code>import &#x27;package:kallopis/src/capabilities/editing/contracts/klp_text_offsets.dart&#x27;;</code> | [lib/src/rendering/flutter/internal/klp_flutter_text_plan.dart:3](../../../../../../lib/src/rendering/flutter/internal/klp_flutter_text_plan.dart#L3) |
| import | <code>import &#x27;klp_flutter_text_delta.dart&#x27;;</code> | [lib/src/rendering/flutter/internal/klp_flutter_text_plan.dart:4](../../../../../../lib/src/rendering/flutter/internal/klp_flutter_text_plan.dart#L4) |

## 宣告關係圖

本組節點是本檔宣告；沒有箭頭的宣告未在此圖主張互相依賴。

```mermaid
classDiagram
	class n0["KlpCompositionResolution"]
	class n1["KlpFlutterTextPlan"]
```


## 宣告與成員證據

成員包含 public 與 private；簽章取自來源，省略函式本體與欄位初始值。`(inferred)` 表示來源未明寫型別；建構子只顯示參數部分，不含初始化列表。

### KlpCompositionResolution

EnumDeclaration · public · [lib/src/rendering/flutter/internal/klp_flutter_text_plan.dart:6](../../../../../../lib/src/rendering/flutter/internal/klp_flutter_text_plan.dart#L6)

<code>enum KlpCompositionResolution</code>


| 成員 | 可見性 | 簽章／型別 | 來源註解摘要 | 證據 |
|---|---|---|---|---|
| enum value <code>commit</code> | public | <code>commit</code> |  | [lib/src/rendering/flutter/internal/klp_flutter_text_plan.dart:6](../../../../../../lib/src/rendering/flutter/internal/klp_flutter_text_plan.dart#L6) |
| enum value <code>cancel</code> | public | <code>cancel</code> |  | [lib/src/rendering/flutter/internal/klp_flutter_text_plan.dart:6](../../../../../../lib/src/rendering/flutter/internal/klp_flutter_text_plan.dart#L6) |

### KlpFlutterTextPlan

ClassDeclaration · public · [lib/src/rendering/flutter/internal/klp_flutter_text_plan.dart:8](../../../../../../lib/src/rendering/flutter/internal/klp_flutter_text_plan.dart#L8)

<code>final class KlpFlutterTextPlan</code>

來源註解摘要：單一平台事件所需的核心操作；每步都必須取得權威回覆才能繼續。


| 成員 | 可見性 | 簽章／型別 | 來源註解摘要 | 證據 |
|---|---|---|---|---|
| field <code>delta</code> | public | <code>final KlpFlutterTextDelta delta</code> |  | [lib/src/rendering/flutter/internal/klp_flutter_text_plan.dart:11](../../../../../../lib/src/rendering/flutter/internal/klp_flutter_text_plan.dart#L11) |
| field <code>edits</code> | public | <code>final List&lt;KlpEditingIntent&gt; edits</code> |  | [lib/src/rendering/flutter/internal/klp_flutter_text_plan.dart:12](../../../../../../lib/src/rendering/flutter/internal/klp_flutter_text_plan.dart#L12) |
| constructor <code>_</code> | private | <code>KlpFlutterTextPlan._(this.delta, Iterable&lt;KlpEditingIntent&gt; edits)</code> |  | [lib/src/rendering/flutter/internal/klp_flutter_text_plan.dart:14](../../../../../../lib/src/rendering/flutter/internal/klp_flutter_text_plan.dart#L14) |
| constructor <code>fromDelta</code> | public | <code>factory KlpFlutterTextPlan.fromDelta(KlpFlutterTextDelta delta, {KlpCompositionResolution? resolution})</code> |  | [lib/src/rendering/flutter/internal/klp_flutter_text_plan.dart:16](../../../../../../lib/src/rendering/flutter/internal/klp_flutter_text_plan.dart#L16) |
| method <code>_validateSurroundings</code> | private | <code>static void _validateSurroundings(KlpFlutterTextDelta delta, int oldStart, int oldEnd, int start, int end)</code> |  | [lib/src/rendering/flutter/internal/klp_flutter_text_plan.dart:62](../../../../../../lib/src/rendering/flutter/internal/klp_flutter_text_plan.dart#L62) |

## 閱讀說明與限制

箭頭只表示來源明寫的靜態關係；import 不等於呼叫。未分析動態呼叫、欄位的實際物件擁有權、狀態轉移或渲染流程；型別未進行語意解析，繼承目標保留原始型別拼寫。public／private 依 Dart 名稱前綴判斷；public 宣告不代表已由 `lib/kallopis.dart` 匯出。

本頁由 `tool/architecture_atlas` 產生；編輯來源或生成工具後重新產生，避免手改本頁。
