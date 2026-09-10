# klp_input_frame.dart：直接依賴與宣告架構

[回到目錄](README.md) · [來源檔案](../../../../../../lib/src/features/forms/internal/klp_input_frame.dart)

## 範圍

核心是 `lib/src/features/forms/internal/klp_input_frame.dart`。主要視角為該檔案明寫的 import／export／part；輔助視角為本檔宣告及 extends／implements／with／on 關係。只展開一層外部邊界。

## 直接依賴圖

```mermaid
flowchart TD
	n0["klp_input_frame.dart"]
	n1["klp_form_dependencies.dart"]
	n2["klp_input_frame_state.dart"]
	n3["primitives/klp_input_frame_surface.dart"]
	n0 -->|"import"| n1
	n0 -->|"part"| n2
	n0 -->|"part"| n3
```

## 依賴證據

| 關係 | 原始 directive | 來源 |
|---|---|---|
| import | <code>import &#x27;klp_form_dependencies.dart&#x27;;</code> | [lib/src/features/forms/internal/klp_input_frame.dart:1](../../../../../../lib/src/features/forms/internal/klp_input_frame.dart#L1) |
| part | <code>part &#x27;klp_input_frame_state.dart&#x27;;</code> | [lib/src/features/forms/internal/klp_input_frame.dart:3](../../../../../../lib/src/features/forms/internal/klp_input_frame.dart#L3) |
| part | <code>part &#x27;primitives/klp_input_frame_surface.dart&#x27;;</code> | [lib/src/features/forms/internal/klp_input_frame.dart:4](../../../../../../lib/src/features/forms/internal/klp_input_frame.dart#L4) |

## 宣告關係圖

本組節點是本檔宣告；沒有箭頭的宣告未在此圖主張互相依賴。

```mermaid
classDiagram
	class n0["KlpInputFrame"]
```

```mermaid
classDiagram
	class n0["KlpInputFrame"]
	class n1["StatefulWidget"]
	n0 --|> n1 : extends
```


## 宣告與成員證據

成員包含 public 與 private；簽章取自來源，省略函式本體與欄位初始值。`(inferred)` 表示來源未明寫型別；建構子只顯示參數部分，不含初始化列表。

### KlpInputFrame

ClassDeclaration · public · [lib/src/features/forms/internal/klp_input_frame.dart:6](../../../../../../lib/src/features/forms/internal/klp_input_frame.dart#L6)

<code>class KlpInputFrame extends StatefulWidget</code>

來源註解摘要：Form recipe 共用的輸入外框，不屬於公開元件 API。

- `extends` → <code>StatefulWidget</code>：[lib/src/features/forms/internal/klp_input_frame.dart:7](../../../../../../lib/src/features/forms/internal/klp_input_frame.dart#L7)

| 成員 | 可見性 | 簽章／型別 | 來源註解摘要 | 證據 |
|---|---|---|---|---|
| field <code>label</code> | public | <code>final String label</code> |  | [lib/src/features/forms/internal/klp_input_frame.dart:8](../../../../../../lib/src/features/forms/internal/klp_input_frame.dart#L8) |
| field <code>child</code> | public | <code>final Widget child</code> |  | [lib/src/features/forms/internal/klp_input_frame.dart:9](../../../../../../lib/src/features/forms/internal/klp_input_frame.dart#L9) |
| field <code>enabled</code> | public | <code>final bool enabled</code> |  | [lib/src/features/forms/internal/klp_input_frame.dart:10](../../../../../../lib/src/features/forms/internal/klp_input_frame.dart#L10) |
| field <code>readOnly</code> | public | <code>final bool readOnly</code> |  | [lib/src/features/forms/internal/klp_input_frame.dart:11](../../../../../../lib/src/features/forms/internal/klp_input_frame.dart#L11) |
| field <code>error</code> | public | <code>final String? error</code> |  | [lib/src/features/forms/internal/klp_input_frame.dart:12](../../../../../../lib/src/features/forms/internal/klp_input_frame.dart#L12) |
| constructor <code>KlpInputFrame</code> | public | <code>const KlpInputFrame({ super.key, required this.label, required this.child, required this.enabled, required this.readOnly, this.error, })</code> |  | [lib/src/features/forms/internal/klp_input_frame.dart:14](../../../../../../lib/src/features/forms/internal/klp_input_frame.dart#L14) |
| method <code>createState</code> | public | <code>State&lt;KlpInputFrame&gt; createState()</code> |  | [lib/src/features/forms/internal/klp_input_frame.dart:23](../../../../../../lib/src/features/forms/internal/klp_input_frame.dart#L23) |

## 閱讀說明與限制

箭頭只表示來源明寫的靜態關係；import 不等於呼叫。未分析動態呼叫、欄位的實際物件擁有權、狀態轉移或渲染流程；型別未進行語意解析，繼承目標保留原始型別拼寫。public／private 依 Dart 名稱前綴判斷；public 宣告不代表已由 `lib/kallopis.dart` 匯出。

本頁由 `tool/architecture_atlas` 產生；編輯來源或生成工具後重新產生，避免手改本頁。
