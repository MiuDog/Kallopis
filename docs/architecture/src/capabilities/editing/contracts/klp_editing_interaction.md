# klp_editing_interaction.dart：直接依賴與宣告架構

[回到目錄](README.md) · [來源檔案](../../../../../../lib/src/capabilities/editing/contracts/klp_editing_interaction.dart)

## 範圍

核心是 `lib/src/capabilities/editing/contracts/klp_editing_interaction.dart`。主要視角為該檔案明寫的 import／export／part；輔助視角為本檔宣告及 extends／implements／with／on 關係。只展開一層外部邊界。

## 直接依賴圖

```mermaid
flowchart TD
	n0["klp_editing_interaction.dart"]
```

## 依賴證據

| 關係 | 原始 directive | 來源 |
|---|---|---|
| 無 | 本檔未宣告 import／export／part | [lib/src/capabilities/editing/contracts/klp_editing_interaction.dart:1](../../../../../../lib/src/capabilities/editing/contracts/klp_editing_interaction.dart#L1) |

## 宣告關係圖

本組節點是本檔宣告；沒有箭頭的宣告未在此圖主張互相依賴。

```mermaid
classDiagram
	class n0["KlpEditingInteraction"]
	class n1["KlpEditingInteractionBinding"]
```


## 宣告與成員證據

成員包含 public 與 private；簽章取自來源，省略函式本體與欄位初始值。`(inferred)` 表示來源未明寫型別；建構子只顯示參數部分，不含初始化列表。

### KlpEditingInteraction

ClassDeclaration · public · [lib/src/capabilities/editing/contracts/klp_editing_interaction.dart:1](../../../../../../lib/src/capabilities/editing/contracts/klp_editing_interaction.dart#L1)

<code>abstract interface class KlpEditingInteraction</code>

來源註解摘要：Flutter host 的輸入生命週期；提供者關閉前必須等待中斷完成。


| 成員 | 可見性 | 簽章／型別 | 來源註解摘要 | 證據 |
|---|---|---|---|---|
| method <code>interrupt</code> | public | <code>Future&lt;void&gt; interrupt()</code> |  | [lib/src/capabilities/editing/contracts/klp_editing_interaction.dart:3](../../../../../../lib/src/capabilities/editing/contracts/klp_editing_interaction.dart#L3) |

### KlpEditingInteractionBinding

ClassDeclaration · public · [lib/src/capabilities/editing/contracts/klp_editing_interaction.dart:6](../../../../../../lib/src/capabilities/editing/contracts/klp_editing_interaction.dart#L6)

<code>abstract interface class KlpEditingInteractionBinding</code>

來源註解摘要：由 Flutter host 持有；關閉只解除本次綁定。


| 成員 | 可見性 | 簽章／型別 | 來源註解摘要 | 證據 |
|---|---|---|---|---|
| method <code>close</code> | public | <code>void close()</code> |  | [lib/src/capabilities/editing/contracts/klp_editing_interaction.dart:8](../../../../../../lib/src/capabilities/editing/contracts/klp_editing_interaction.dart#L8) |

## 閱讀說明與限制

箭頭只表示來源明寫的靜態關係；import 不等於呼叫。未分析動態呼叫、欄位的實際物件擁有權、狀態轉移或渲染流程；型別未進行語意解析，繼承目標保留原始型別拼寫。public／private 依 Dart 名稱前綴判斷；public 宣告不代表已由 `lib/kallopis.dart` 匯出。

本頁由 `tool/architecture_atlas` 產生；編輯來源或生成工具後重新產生，避免手改本頁。
