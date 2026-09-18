# klp_bound_anchored_commands.dart：直接依賴與宣告架構

[回到目錄](README.md) · [來源檔案](../../../../../../lib/src/features/editing/presentation/klp_bound_anchored_commands.dart)

## 範圍

核心是 `lib/src/features/editing/presentation/klp_bound_anchored_commands.dart`。主要視角為該檔案明寫的 import／export／part；輔助視角為本檔宣告及 extends／implements／with／on 關係。只展開一層外部邊界。

## 直接依賴圖

```mermaid
flowchart TD
	n0["klp_bound_anchored_commands.dart"]
	n1["klp_editing_presentation.dart"]
	n0 -->|"part of"| n1
```

## 依賴證據

| 關係 | 原始 directive | 來源 |
|---|---|---|
| part of | <code>part of &#x27;klp_editing_presentation.dart&#x27;;</code> | [lib/src/features/editing/presentation/klp_bound_anchored_commands.dart:1](../../../../../../lib/src/features/editing/presentation/klp_bound_anchored_commands.dart#L1) |

## 宣告關係圖

本組節點是本檔宣告；沒有箭頭的宣告未在此圖主張互相依賴。

```mermaid
classDiagram
	class n0["KlpBoundAnchoredCommands"]
```


## 宣告與成員證據

成員包含 public 與 private；簽章取自來源，省略函式本體與欄位初始值。`(inferred)` 表示來源未明寫型別；建構子只顯示參數部分，不含初始化列表。

### KlpBoundAnchoredCommands

ClassDeclaration · public · [lib/src/features/editing/presentation/klp_bound_anchored_commands.dart:3](../../../../../../lib/src/features/editing/presentation/klp_bound_anchored_commands.dart#L3)

<code>final class KlpBoundAnchoredCommands</code>

來源註解摘要：已從 enclosing editor 繫結的定位命令能力。


| 成員 | 可見性 | 簽章／型別 | 來源註解摘要 | 證據 |
|---|---|---|---|---|
| field <code>id</code> | public | <code>final String id</code> |  | [lib/src/features/editing/presentation/klp_bound_anchored_commands.dart:5](../../../../../../lib/src/features/editing/presentation/klp_bound_anchored_commands.dart#L5) |
| field <code>actions</code> | public | <code>final KlpBoundAnchoredCommandActions actions</code> |  | [lib/src/features/editing/presentation/klp_bound_anchored_commands.dart:6](../../../../../../lib/src/features/editing/presentation/klp_bound_anchored_commands.dart#L6) |
| constructor <code>KlpBoundAnchoredCommands</code> | public | <code>const KlpBoundAnchoredCommands(this.id, this.actions)</code> |  | [lib/src/features/editing/presentation/klp_bound_anchored_commands.dart:8](../../../../../../lib/src/features/editing/presentation/klp_bound_anchored_commands.dart#L8) |

## 閱讀說明與限制

箭頭只表示來源明寫的靜態關係；import 不等於呼叫。未分析動態呼叫、欄位的實際物件擁有權、狀態轉移或渲染流程；型別未進行語意解析，繼承目標保留原始型別拼寫。public／private 依 Dart 名稱前綴判斷；public 宣告不代表已由 `lib/kallopis.dart` 匯出。

本頁由 `tool/architecture_atlas` 產生；編輯來源或生成工具後重新產生，避免手改本頁。
