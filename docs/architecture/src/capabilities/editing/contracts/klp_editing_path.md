# klp_editing_path.dart：直接依賴與宣告架構

[回到目錄](README.md) · [來源檔案](../../../../../../lib/src/capabilities/editing/contracts/klp_editing_path.dart)

## 範圍

核心是 `lib/src/capabilities/editing/contracts/klp_editing_path.dart`。主要視角為該檔案明寫的 import／export／part；輔助視角為本檔宣告及 extends／implements／with／on 關係。只展開一層外部邊界。

## 直接依賴圖

```mermaid
flowchart TD
	n0["klp_editing_path.dart"]
```

## 依賴證據

| 關係 | 原始 directive | 來源 |
|---|---|---|
| 無 | 本檔未宣告 import／export／part | [lib/src/capabilities/editing/contracts/klp_editing_path.dart:1](../../../../../../lib/src/capabilities/editing/contracts/klp_editing_path.dart#L1) |

## 宣告關係圖

本組節點是本檔宣告；沒有箭頭的宣告未在此圖主張互相依賴。

```mermaid
classDiagram
	class n0["KlpEditingPathOperation"]
	class n1["KlpEditingPathCommand"]
	class n2["KlpEditingPath"]
```


## 宣告與成員證據

成員包含 public 與 private；簽章取自來源，省略函式本體與欄位初始值。`(inferred)` 表示來源未明寫型別；建構子只顯示參數部分，不含初始化列表。

### KlpEditingPathOperation

EnumDeclaration · public · [lib/src/capabilities/editing/contracts/klp_editing_path.dart:1](../../../../../../lib/src/capabilities/editing/contracts/klp_editing_path.dart#L1)

<code>enum KlpEditingPathOperation</code>

來源註解摘要：提供者路徑片段的幾何操作；不引入平台 Path 或筆刷。


| 成員 | 可見性 | 簽章／型別 | 來源註解摘要 | 證據 |
|---|---|---|---|---|
| enum value <code>move</code> | public | <code>move</code> |  | [lib/src/capabilities/editing/contracts/klp_editing_path.dart:2](../../../../../../lib/src/capabilities/editing/contracts/klp_editing_path.dart#L2) |
| enum value <code>line</code> | public | <code>line</code> |  | [lib/src/capabilities/editing/contracts/klp_editing_path.dart:2](../../../../../../lib/src/capabilities/editing/contracts/klp_editing_path.dart#L2) |
| enum value <code>quadratic</code> | public | <code>quadratic</code> |  | [lib/src/capabilities/editing/contracts/klp_editing_path.dart:2](../../../../../../lib/src/capabilities/editing/contracts/klp_editing_path.dart#L2) |
| enum value <code>cubic</code> | public | <code>cubic</code> |  | [lib/src/capabilities/editing/contracts/klp_editing_path.dart:2](../../../../../../lib/src/capabilities/editing/contracts/klp_editing_path.dart#L2) |
| enum value <code>close</code> | public | <code>close</code> |  | [lib/src/capabilities/editing/contracts/klp_editing_path.dart:2](../../../../../../lib/src/capabilities/editing/contracts/klp_editing_path.dart#L2) |

### KlpEditingPathCommand

ClassDeclaration · public · [lib/src/capabilities/editing/contracts/klp_editing_path.dart:4](../../../../../../lib/src/capabilities/editing/contracts/klp_editing_path.dart#L4)

<code>final class KlpEditingPathCommand</code>

來源註解摘要：輪廓只包含幾何；座標單位由其繪製變換明確指定。


| 成員 | 可見性 | 簽章／型別 | 來源註解摘要 | 證據 |
|---|---|---|---|---|
| field <code>operation</code> | public | <code>final KlpEditingPathOperation operation</code> |  | [lib/src/capabilities/editing/contracts/klp_editing_path.dart:7](../../../../../../lib/src/capabilities/editing/contracts/klp_editing_path.dart#L7) |
| field <code>values</code> | public | <code>final List&lt;double&gt; values</code> |  | [lib/src/capabilities/editing/contracts/klp_editing_path.dart:8](../../../../../../lib/src/capabilities/editing/contracts/klp_editing_path.dart#L8) |
| constructor <code>KlpEditingPathCommand</code> | public | <code>KlpEditingPathCommand(this.operation, Iterable&lt;double&gt; values)</code> |  | [lib/src/capabilities/editing/contracts/klp_editing_path.dart:10](../../../../../../lib/src/capabilities/editing/contracts/klp_editing_path.dart#L10) |

### KlpEditingPath

ClassDeclaration · public · [lib/src/capabilities/editing/contracts/klp_editing_path.dart:21](../../../../../../lib/src/capabilities/editing/contracts/klp_editing_path.dart#L21)

<code>final class KlpEditingPath</code>

來源註解摘要：不可變輪廓可供同一畫面中的多個字形位置共用。


| 成員 | 可見性 | 簽章／型別 | 來源註解摘要 | 證據 |
|---|---|---|---|---|
| field <code>commands</code> | public | <code>final List&lt;KlpEditingPathCommand&gt; commands</code> |  | [lib/src/capabilities/editing/contracts/klp_editing_path.dart:24](../../../../../../lib/src/capabilities/editing/contracts/klp_editing_path.dart#L24) |
| constructor <code>KlpEditingPath</code> | public | <code>KlpEditingPath(Iterable&lt;KlpEditingPathCommand&gt; commands)</code> |  | [lib/src/capabilities/editing/contracts/klp_editing_path.dart:26](../../../../../../lib/src/capabilities/editing/contracts/klp_editing_path.dart#L26) |

## 閱讀說明與限制

箭頭只表示來源明寫的靜態關係；import 不等於呼叫。未分析動態呼叫、欄位的實際物件擁有權、狀態轉移或渲染流程；型別未進行語意解析，繼承目標保留原始型別拼寫。public／private 依 Dart 名稱前綴判斷；public 宣告不代表已由 `lib/kallopis.dart` 匯出。

本頁由 `tool/architecture_atlas` 產生；編輯來源或生成工具後重新產生，避免手改本頁。
