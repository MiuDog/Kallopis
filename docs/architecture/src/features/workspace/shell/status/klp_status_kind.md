# klp_status_kind.dart：直接依賴與宣告架構

[回到目錄](README.md) · [來源檔案](../../../../../../../lib/src/features/workspace/shell/status/klp_status_kind.dart)

## 範圍

核心是 `lib/src/features/workspace/shell/status/klp_status_kind.dart`。主要視角為該檔案明寫的 import／export／part；輔助視角為本檔宣告及 extends／implements／with／on 關係。只展開一層外部邊界。

## 直接依賴圖

```mermaid
flowchart TD
	n0["klp_status_kind.dart"]
```

## 依賴證據

| 關係 | 原始 directive | 來源 |
|---|---|---|
| 無 | 本檔未宣告 import／export／part | [lib/src/features/workspace/shell/status/klp_status_kind.dart:1](../../../../../../../lib/src/features/workspace/shell/status/klp_status_kind.dart#L1) |

## 宣告關係圖

本組節點是本檔宣告；沒有箭頭的宣告未在此圖主張互相依賴。

```mermaid
classDiagram
	class n0["KlpStatusKind"]
```


## 宣告與成員證據

成員包含 public 與 private；簽章取自來源，省略函式本體與欄位初始值。`(inferred)` 表示來源未明寫型別；建構子只顯示參數部分，不含初始化列表。

### KlpStatusKind

EnumDeclaration · public · [lib/src/features/workspace/shell/status/klp_status_kind.dart:4](../../../../../../../lib/src/features/workspace/shell/status/klp_status_kind.dart#L4)

<code>enum KlpStatusKind</code>

來源註解摘要：狀態語意種類。所有種類統一以純色圓點呈現，種類只負責解析預設顏色。


| 成員 | 可見性 | 簽章／型別 | 來源註解摘要 | 證據 |
|---|---|---|---|---|
| enum value <code>dot</code> | public | <code>dot</code> |  | [lib/src/features/workspace/shell/status/klp_status_kind.dart:5](../../../../../../../lib/src/features/workspace/shell/status/klp_status_kind.dart#L5) |
| enum value <code>running</code> | public | <code>running</code> |  | [lib/src/features/workspace/shell/status/klp_status_kind.dart:5](../../../../../../../lib/src/features/workspace/shell/status/klp_status_kind.dart#L5) |
| enum value <code>splitDot</code> | public | <code>splitDot</code> |  | [lib/src/features/workspace/shell/status/klp_status_kind.dart:5](../../../../../../../lib/src/features/workspace/shell/status/klp_status_kind.dart#L5) |
| enum value <code>check</code> | public | <code>check</code> |  | [lib/src/features/workspace/shell/status/klp_status_kind.dart:5](../../../../../../../lib/src/features/workspace/shell/status/klp_status_kind.dart#L5) |
| enum value <code>cross</code> | public | <code>cross</code> |  | [lib/src/features/workspace/shell/status/klp_status_kind.dart:5](../../../../../../../lib/src/features/workspace/shell/status/klp_status_kind.dart#L5) |
| enum value <code>waiting</code> | public | <code>waiting</code> |  | [lib/src/features/workspace/shell/status/klp_status_kind.dart:5](../../../../../../../lib/src/features/workspace/shell/status/klp_status_kind.dart#L5) |
| enum value <code>circle</code> | public | <code>circle</code> |  | [lib/src/features/workspace/shell/status/klp_status_kind.dart:5](../../../../../../../lib/src/features/workspace/shell/status/klp_status_kind.dart#L5) |

## 閱讀說明與限制

箭頭只表示來源明寫的靜態關係；import 不等於呼叫。未分析動態呼叫、欄位的實際物件擁有權、狀態轉移或渲染流程；型別未進行語意解析，繼承目標保留原始型別拼寫。public／private 依 Dart 名稱前綴判斷；public 宣告不代表已由 `lib/kallopis.dart` 匯出。

本頁由 `tool/architecture_atlas` 產生；編輯來源或生成工具後重新產生，避免手改本頁。
