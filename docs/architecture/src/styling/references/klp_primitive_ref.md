# klp_primitive_ref.dart：直接依賴與宣告架構

[回到目錄](README.md) · [來源檔案](../../../../../lib/src/styling/references/klp_primitive_ref.dart)

## 範圍

核心是 `lib/src/styling/references/klp_primitive_ref.dart`。主要視角為該檔案明寫的 import／export／part；輔助視角為本檔宣告及 extends／implements／with／on 關係。只展開一層外部邊界。

## 直接依賴圖

```mermaid
flowchart TD
	n0["klp_primitive_ref.dart"]
	n1["klp_style_ref.dart"]
	n0 -->|"part of"| n1
```

## 依賴證據

| 關係 | 原始 directive | 來源 |
|---|---|---|
| part of | <code>part of &#x27;klp_style_ref.dart&#x27;;</code> | [lib/src/styling/references/klp_primitive_ref.dart:1](../../../../../lib/src/styling/references/klp_primitive_ref.dart#L1) |

## 宣告關係圖

本組節點是本檔宣告；沒有箭頭的宣告未在此圖主張互相依賴。

```mermaid
classDiagram
	class n0["KlpPrimitiveRef"]
```

```mermaid
classDiagram
	class n0["KlpPrimitiveRef"]
	class n1["KlpStyleRef&lt;T&gt;"]
	n0 --|> n1 : extends
```


## 宣告與成員證據

成員包含 public 與 private；簽章取自來源，省略函式本體與欄位初始值。`(inferred)` 表示來源未明寫型別；建構子只顯示參數部分，不含初始化列表。

### KlpPrimitiveRef

ClassDeclaration · public · [lib/src/styling/references/klp_primitive_ref.dart:3](../../../../../lib/src/styling/references/klp_primitive_ref.dart#L3)

<code>final class KlpPrimitiveRef&lt;T extends KlpStyleValue&gt; extends KlpStyleRef&lt;T&gt;</code>

來源註解摘要：定義期選擇固定原料欄位，不保存元件實例的外觀值。

- `extends` → <code>KlpStyleRef&lt;T&gt;</code>：[lib/src/styling/references/klp_primitive_ref.dart:4](../../../../../lib/src/styling/references/klp_primitive_ref.dart#L4)

| 成員 | 可見性 | 簽章／型別 | 來源註解摘要 | 證據 |
|---|---|---|---|---|
| field <code>kind</code> | public | <code>final KlpStyleKind&lt;T&gt; kind</code> |  | [lib/src/styling/references/klp_primitive_ref.dart:7](../../../../../lib/src/styling/references/klp_primitive_ref.dart#L7) |
| field <code>index</code> | public | <code>final KlpPrimitiveIndex index</code> |  | [lib/src/styling/references/klp_primitive_ref.dart:8](../../../../../lib/src/styling/references/klp_primitive_ref.dart#L8) |
| constructor <code>KlpPrimitiveRef</code> | public | <code>const KlpPrimitiveRef(this.kind, this.index)</code> |  | [lib/src/styling/references/klp_primitive_ref.dart:10](../../../../../lib/src/styling/references/klp_primitive_ref.dart#L10) |

## 閱讀說明與限制

箭頭只表示來源明寫的靜態關係；import 不等於呼叫。未分析動態呼叫、欄位的實際物件擁有權、狀態轉移或渲染流程；型別未進行語意解析，繼承目標保留原始型別拼寫。public／private 依 Dart 名稱前綴判斷；public 宣告不代表已由 `lib/kallopis.dart` 匯出。

本頁由 `tool/architecture_atlas` 產生；編輯來源或生成工具後重新產生，避免手改本頁。
