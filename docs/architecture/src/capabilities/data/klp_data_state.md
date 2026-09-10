# klp_data_state.dart：直接依賴與宣告架構

[回到目錄](README.md) · [來源檔案](../../../../../lib/src/capabilities/data/klp_data_state.dart)

## 範圍

核心是 `lib/src/capabilities/data/klp_data_state.dart`。主要視角為該檔案明寫的 import／export／part；輔助視角為本檔宣告及 extends／implements／with／on 關係。只展開一層外部邊界。

## 直接依賴圖

```mermaid
flowchart LR
	n0["klp_data_state.dart"]
	n1["klp_data_idle.dart"]
	n2["klp_data_loading.dart"]
	n3["klp_data_value.dart"]
	n4["klp_data_failure.dart"]
	n0 -->|"part"| n1
	n0 -->|"part"| n2
	n0 -->|"part"| n3
	n0 -->|"part"| n4
```

## 依賴證據

| 關係 | 原始 directive | 來源 |
|---|---|---|
| part | <code>part &#x27;klp_data_idle.dart&#x27;;</code> | [lib/src/capabilities/data/klp_data_state.dart:1](../../../../../lib/src/capabilities/data/klp_data_state.dart#L1) |
| part | <code>part &#x27;klp_data_loading.dart&#x27;;</code> | [lib/src/capabilities/data/klp_data_state.dart:2](../../../../../lib/src/capabilities/data/klp_data_state.dart#L2) |
| part | <code>part &#x27;klp_data_value.dart&#x27;;</code> | [lib/src/capabilities/data/klp_data_state.dart:3](../../../../../lib/src/capabilities/data/klp_data_state.dart#L3) |
| part | <code>part &#x27;klp_data_failure.dart&#x27;;</code> | [lib/src/capabilities/data/klp_data_state.dart:4](../../../../../lib/src/capabilities/data/klp_data_state.dart#L4) |

## 宣告關係圖

本組節點是本檔宣告；沒有箭頭的宣告未在此圖主張互相依賴。

```mermaid
classDiagram
	class n0["KlpDataState"]
```


## 宣告與成員證據

成員包含 public 與 private；簽章取自來源，省略函式本體與欄位初始值。`(inferred)` 表示來源未明寫型別；建構子只顯示參數部分，不含初始化列表。

### KlpDataState

ClassDeclaration · public · [lib/src/capabilities/data/klp_data_state.dart:6](../../../../../lib/src/capabilities/data/klp_data_state.dart#L6)

<code>sealed class KlpDataState&lt;T&gt;</code>

來源註解摘要：非同步資料的互斥階段；載入與失敗不保留上一份資料。 包裝不可變，但資料本身的不可變性由提供者負責。


| 成員 | 可見性 | 簽章／型別 | 來源註解摘要 | 證據 |
|---|---|---|---|---|
| constructor <code>KlpDataState</code> | public | <code>const KlpDataState()</code> |  | [lib/src/capabilities/data/klp_data_state.dart:10](../../../../../lib/src/capabilities/data/klp_data_state.dart#L10) |

## 閱讀說明與限制

箭頭只表示來源明寫的靜態關係；import 不等於呼叫。未分析動態呼叫、欄位的實際物件擁有權、狀態轉移或渲染流程；型別未進行語意解析，繼承目標保留原始型別拼寫。public／private 依 Dart 名稱前綴判斷；public 宣告不代表已由 `lib/kallopis.dart` 匯出。

本頁由 `tool/architecture_atlas` 產生；編輯來源或生成工具後重新產生，避免手改本頁。
