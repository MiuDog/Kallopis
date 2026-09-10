# klp_contract_error.dart：直接依賴與宣告架構

[回到目錄](README.md) · [來源檔案](../../../../../lib/src/kernel/diagnostics/klp_contract_error.dart)

## 範圍

核心是 `lib/src/kernel/diagnostics/klp_contract_error.dart`。主要視角為該檔案明寫的 import／export／part；輔助視角為本檔宣告及 extends／implements／with／on 關係。只展開一層外部邊界。

## 直接依賴圖

```mermaid
flowchart TD
	n0["klp_contract_error.dart"]
```

## 依賴證據

| 關係 | 原始 directive | 來源 |
|---|---|---|
| 無 | 本檔未宣告 import／export／part | [lib/src/kernel/diagnostics/klp_contract_error.dart:1](../../../../../lib/src/kernel/diagnostics/klp_contract_error.dart#L1) |

## 宣告關係圖

本組節點是本檔宣告；沒有箭頭的宣告未在此圖主張互相依賴。

```mermaid
classDiagram
	class n0["KlpContractError"]
```

```mermaid
classDiagram
	class n0["KlpContractError"]
	class n1["Exception"]
	n0 ..|> n1 : implements
```


## 宣告與成員證據

成員包含 public 與 private；簽章取自來源，省略函式本體與欄位初始值。`(inferred)` 表示來源未明寫型別；建構子只顯示參數部分，不含初始化列表。

### KlpContractError

ClassDeclaration · public · [lib/src/kernel/diagnostics/klp_contract_error.dart:1](../../../../../lib/src/kernel/diagnostics/klp_contract_error.dart#L1)

<code>final class KlpContractError implements Exception</code>

來源註解摘要：宣告或註冊違反契約時的可辨識錯誤。

- `implements` → <code>Exception</code>：[lib/src/kernel/diagnostics/klp_contract_error.dart:2](../../../../../lib/src/kernel/diagnostics/klp_contract_error.dart#L2)

| 成員 | 可見性 | 簽章／型別 | 來源註解摘要 | 證據 |
|---|---|---|---|---|
| field <code>code</code> | public | <code>final String code</code> |  | [lib/src/kernel/diagnostics/klp_contract_error.dart:4](../../../../../lib/src/kernel/diagnostics/klp_contract_error.dart#L4) |
| field <code>message</code> | public | <code>final String message</code> |  | [lib/src/kernel/diagnostics/klp_contract_error.dart:5](../../../../../lib/src/kernel/diagnostics/klp_contract_error.dart#L5) |
| constructor <code>KlpContractError</code> | public | <code>const KlpContractError(this.code, this.message)</code> |  | [lib/src/kernel/diagnostics/klp_contract_error.dart:7](../../../../../lib/src/kernel/diagnostics/klp_contract_error.dart#L7) |
| method <code>toString</code> | public | <code>String toString()</code> |  | [lib/src/kernel/diagnostics/klp_contract_error.dart:9](../../../../../lib/src/kernel/diagnostics/klp_contract_error.dart#L9) |

## 閱讀說明與限制

箭頭只表示來源明寫的靜態關係；import 不等於呼叫。未分析動態呼叫、欄位的實際物件擁有權、狀態轉移或渲染流程；型別未進行語意解析，繼承目標保留原始型別拼寫。public／private 依 Dart 名稱前綴判斷；public 宣告不代表已由 `lib/kallopis.dart` 匯出。

本頁由 `tool/architecture_atlas` 產生；編輯來源或生成工具後重新產生，避免手改本頁。
