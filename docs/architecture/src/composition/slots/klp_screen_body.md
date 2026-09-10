# klp_screen_body.dart：直接依賴與宣告架構

[回到目錄](README.md) · [來源檔案](../../../../../lib/src/composition/slots/klp_screen_body.dart)

## 範圍

核心是 `lib/src/composition/slots/klp_screen_body.dart`。主要視角為該檔案明寫的 import／export／part；輔助視角為本檔宣告及 extends／implements／with／on 關係。只展開一層外部邊界。

## 直接依賴圖

```mermaid
flowchart TD
	n0["klp_screen_body.dart"]
	n1["../nodes/klp_node.dart"]
	n0 -->|"import"| n1
```

## 依賴證據

| 關係 | 原始 directive | 來源 |
|---|---|---|
| import | <code>import &#x27;../nodes/klp_node.dart&#x27;;</code> | [lib/src/composition/slots/klp_screen_body.dart:1](../../../../../lib/src/composition/slots/klp_screen_body.dart#L1) |

## 宣告關係圖

本組節點是本檔宣告；沒有箭頭的宣告未在此圖主張互相依賴。

```mermaid
classDiagram
	class n0["KlpScreenBody"]
```

```mermaid
classDiagram
	class n0["KlpScreenBody"]
	class n1["KlpNode"]
	n0 ..|> n1 : implements
```


## 宣告與成員證據

成員包含 public 與 private；簽章取自來源，省略函式本體與欄位初始值。`(inferred)` 表示來源未明寫型別；建構子只顯示參數部分，不含初始化列表。

### KlpScreenBody

ClassDeclaration · public · [lib/src/composition/slots/klp_screen_body.dart:3](../../../../../lib/src/composition/slots/klp_screen_body.dart#L3)

<code>abstract interface class KlpScreenBody implements KlpNode</code>

來源註解摘要：畫面內容資格；功能自行宣告是否可放置於畫面根。

- `implements` → <code>KlpNode</code>：[lib/src/composition/slots/klp_screen_body.dart:4](../../../../../lib/src/composition/slots/klp_screen_body.dart#L4)

## 閱讀說明與限制

箭頭只表示來源明寫的靜態關係；import 不等於呼叫。未分析動態呼叫、欄位的實際物件擁有權、狀態轉移或渲染流程；型別未進行語意解析，繼承目標保留原始型別拼寫。public／private 依 Dart 名稱前綴判斷；public 宣告不代表已由 `lib/kallopis.dart` 匯出。

本頁由 `tool/architecture_atlas` 產生；編輯來源或生成工具後重新產生，避免手改本頁。
