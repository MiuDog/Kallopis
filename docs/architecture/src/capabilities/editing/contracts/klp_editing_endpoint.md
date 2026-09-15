# klp_editing_endpoint.dart：直接依賴與宣告架構

[回到目錄](README.md) · [來源檔案](../../../../../../lib/src/capabilities/editing/contracts/klp_editing_endpoint.dart)

## 範圍

核心是 `lib/src/capabilities/editing/contracts/klp_editing_endpoint.dart`。主要視角為該檔案明寫的 import／export／part；輔助視角為本檔宣告及 extends／implements／with／on 關係。只展開一層外部邊界。

## 直接依賴圖

```mermaid
flowchart TD
	n0["klp_editing_endpoint.dart"]
```

## 依賴證據

| 關係 | 原始 directive | 來源 |
|---|---|---|
| 無 | 本檔未宣告 import／export／part | [lib/src/capabilities/editing/contracts/klp_editing_endpoint.dart:1](../../../../../../lib/src/capabilities/editing/contracts/klp_editing_endpoint.dart#L1) |

## 宣告關係圖

本組節點是本檔宣告；沒有箭頭的宣告未在此圖主張互相依賴。

```mermaid
classDiagram
	class n0["KlpEditingAffinity"]
	class n1["KlpEditingEndpoint"]
```


## 宣告與成員證據

成員包含 public 與 private；簽章取自來源，省略函式本體與欄位初始值。`(inferred)` 表示來源未明寫型別；建構子只顯示參數部分，不含初始化列表。

### KlpEditingAffinity

EnumDeclaration · public · [lib/src/capabilities/editing/contracts/klp_editing_endpoint.dart:1](../../../../../../lib/src/capabilities/editing/contracts/klp_editing_endpoint.dart#L1)

<code>enum KlpEditingAffinity</code>

來源註解摘要：文字端點在邊界上的親和方向；不決定排版或選取權威。


| 成員 | 可見性 | 簽章／型別 | 來源註解摘要 | 證據 |
|---|---|---|---|---|
| enum value <code>upstream</code> | public | <code>upstream</code> |  | [lib/src/capabilities/editing/contracts/klp_editing_endpoint.dart:2](../../../../../../lib/src/capabilities/editing/contracts/klp_editing_endpoint.dart#L2) |
| enum value <code>downstream</code> | public | <code>downstream</code> |  | [lib/src/capabilities/editing/contracts/klp_editing_endpoint.dart:2](../../../../../../lib/src/capabilities/editing/contracts/klp_editing_endpoint.dart#L2) |

### KlpEditingEndpoint

ClassDeclaration · public · [lib/src/capabilities/editing/contracts/klp_editing_endpoint.dart:4](../../../../../../lib/src/capabilities/editing/contracts/klp_editing_endpoint.dart#L4)

<code>final class KlpEditingEndpoint</code>

來源註解摘要：核心發布的穩定端點；字素位置不得與平台 byte 位移互換。


| 成員 | 可見性 | 簽章／型別 | 來源註解摘要 | 證據 |
|---|---|---|---|---|
| field <code>blockId</code> | public | <code>final String blockId</code> |  | [lib/src/capabilities/editing/contracts/klp_editing_endpoint.dart:7](../../../../../../lib/src/capabilities/editing/contracts/klp_editing_endpoint.dart#L7) |
| field <code>graphemeBoundary</code> | public | <code>final int graphemeBoundary</code> |  | [lib/src/capabilities/editing/contracts/klp_editing_endpoint.dart:8](../../../../../../lib/src/capabilities/editing/contracts/klp_editing_endpoint.dart#L8) |
| field <code>affinity</code> | public | <code>final KlpEditingAffinity affinity</code> |  | [lib/src/capabilities/editing/contracts/klp_editing_endpoint.dart:9](../../../../../../lib/src/capabilities/editing/contracts/klp_editing_endpoint.dart#L9) |
| constructor <code>KlpEditingEndpoint</code> | public | <code>KlpEditingEndpoint(this.blockId, this.graphemeBoundary, this.affinity)</code> |  | [lib/src/capabilities/editing/contracts/klp_editing_endpoint.dart:11](../../../../../../lib/src/capabilities/editing/contracts/klp_editing_endpoint.dart#L11) |
| method <code>==</code> | public | <code>bool operator ==(Object other)</code> |  | [lib/src/capabilities/editing/contracts/klp_editing_endpoint.dart:15](../../../../../../lib/src/capabilities/editing/contracts/klp_editing_endpoint.dart#L15) |
| getter <code>hashCode</code> | public | <code>int get hashCode</code> |  | [lib/src/capabilities/editing/contracts/klp_editing_endpoint.dart:18](../../../../../../lib/src/capabilities/editing/contracts/klp_editing_endpoint.dart#L18) |

## 閱讀說明與限制

箭頭只表示來源明寫的靜態關係；import 不等於呼叫。未分析動態呼叫、欄位的實際物件擁有權、狀態轉移或渲染流程；型別未進行語意解析，繼承目標保留原始型別拼寫。public／private 依 Dart 名稱前綴判斷；public 宣告不代表已由 `lib/kallopis.dart` 匯出。

本頁由 `tool/architecture_atlas` 產生；編輯來源或生成工具後重新產生，避免手改本頁。
