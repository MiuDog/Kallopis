# klp_box_constraints.dart：直接依賴與宣告架構

[回到目錄](README.md) · [來源檔案](../../../../../lib/src/foundation/layout/klp_box_constraints.dart)

## 範圍

核心是 `lib/src/foundation/layout/klp_box_constraints.dart`。主要視角為該檔案明寫的 import／export／part；輔助視角為本檔宣告及 extends／implements／with／on 關係。只展開一層外部邊界。

## 直接依賴圖

```mermaid
flowchart TD
	n0["klp_box_constraints.dart"]
```

## 依賴證據

| 關係 | 原始 directive | 來源 |
|---|---|---|
| 無 | 本檔未宣告 import／export／part | [lib/src/foundation/layout/klp_box_constraints.dart:1](../../../../../lib/src/foundation/layout/klp_box_constraints.dart#L1) |

## 宣告關係圖

本組節點是本檔宣告；沒有箭頭的宣告未在此圖主張互相依賴。

```mermaid
classDiagram
	class n0["KlpBoxConstraints"]
```


## 宣告與成員證據

成員包含 public 與 private；簽章取自來源，省略函式本體與欄位初始值。`(inferred)` 表示來源未明寫型別；建構子只顯示參數部分，不含初始化列表。

### KlpBoxConstraints

ClassDeclaration · public · [lib/src/foundation/layout/klp_box_constraints.dart:1](../../../../../lib/src/foundation/layout/klp_box_constraints.dart#L1)

<code>class KlpBoxConstraints</code>

來源註解摘要：約束排版原語使用的型別化幾何介面。


| 成員 | 可見性 | 簽章／型別 | 來源註解摘要 | 證據 |
|---|---|---|---|---|
| constructor <code>KlpBoxConstraints</code> | public | <code>const KlpBoxConstraints({ this.minWidth = 0, this.maxWidth = double.infinity, this.minHeight = 0, this.maxHeight = double.infinity, })</code> |  | [lib/src/foundation/layout/klp_box_constraints.dart:3](../../../../../lib/src/foundation/layout/klp_box_constraints.dart#L3) |
| field <code>minWidth</code> | public | <code>final double minWidth</code> |  | [lib/src/foundation/layout/klp_box_constraints.dart:10](../../../../../lib/src/foundation/layout/klp_box_constraints.dart#L10) |
| field <code>maxWidth</code> | public | <code>final double maxWidth</code> |  | [lib/src/foundation/layout/klp_box_constraints.dart:11](../../../../../lib/src/foundation/layout/klp_box_constraints.dart#L11) |
| field <code>minHeight</code> | public | <code>final double minHeight</code> |  | [lib/src/foundation/layout/klp_box_constraints.dart:12](../../../../../lib/src/foundation/layout/klp_box_constraints.dart#L12) |
| field <code>maxHeight</code> | public | <code>final double maxHeight</code> |  | [lib/src/foundation/layout/klp_box_constraints.dart:13](../../../../../lib/src/foundation/layout/klp_box_constraints.dart#L13) |

## 閱讀說明與限制

箭頭只表示來源明寫的靜態關係；import 不等於呼叫。未分析動態呼叫、欄位的實際物件擁有權、狀態轉移或渲染流程；型別未進行語意解析，繼承目標保留原始型別拼寫。public／private 依 Dart 名稱前綴判斷；public 宣告不代表已由 `lib/kallopis.dart` 匯出。

本頁由 `tool/architecture_atlas` 產生；編輯來源或生成工具後重新產生，避免手改本頁。
