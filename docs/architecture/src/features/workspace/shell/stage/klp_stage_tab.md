# klp_stage_tab.dart：直接依賴與宣告架構

[回到目錄](README.md) · [來源檔案](../../../../../../../lib/src/features/workspace/shell/stage/klp_stage_tab.dart)

## 範圍

核心是 `lib/src/features/workspace/shell/stage/klp_stage_tab.dart`。主要視角為該檔案明寫的 import／export／part；輔助視角為本檔宣告及 extends／implements／with／on 關係。只展開一層外部邊界。

## 直接依賴圖

```mermaid
flowchart LR
	n0["klp_stage_tab.dart"]
	n1["package:flutter/material.dart"]
	n2["../../../../styling/legacy_theme/klp_theme.dart"]
	n3["../../../../foundation/content/klp_text.dart"]
	n4["primitives/klp_stage_tab_frame.dart"]
	n0 -->|"import"| n1
	n0 -->|"import"| n2
	n0 -->|"import"| n3
	n0 -->|"part"| n4
```

## 依賴證據

| 關係 | 原始 directive | 來源 |
|---|---|---|
| import | <code>import &#x27;package:flutter/material.dart&#x27;;</code> | [lib/src/features/workspace/shell/stage/klp_stage_tab.dart:1](../../../../../../../lib/src/features/workspace/shell/stage/klp_stage_tab.dart#L1) |
| import | <code>import &#x27;../../../../styling/legacy_theme/klp_theme.dart&#x27;;</code> | [lib/src/features/workspace/shell/stage/klp_stage_tab.dart:3](../../../../../../../lib/src/features/workspace/shell/stage/klp_stage_tab.dart#L3) |
| import | <code>import &#x27;../../../../foundation/content/klp_text.dart&#x27;;</code> | [lib/src/features/workspace/shell/stage/klp_stage_tab.dart:4](../../../../../../../lib/src/features/workspace/shell/stage/klp_stage_tab.dart#L4) |
| part | <code>part &#x27;primitives/klp_stage_tab_frame.dart&#x27;;</code> | [lib/src/features/workspace/shell/stage/klp_stage_tab.dart:6](../../../../../../../lib/src/features/workspace/shell/stage/klp_stage_tab.dart#L6) |

## 宣告關係圖

本組節點是本檔宣告；沒有箭頭的宣告未在此圖主張互相依賴。

```mermaid
classDiagram
	class n0["KlpStageTab"]
```

```mermaid
classDiagram
	class n0["KlpStageTab"]
	class n1["StatelessWidget"]
	n0 --|> n1 : extends
```


## 宣告與成員證據

成員包含 public 與 private；簽章取自來源，省略函式本體與欄位初始值。`(inferred)` 表示來源未明寫型別；建構子只顯示參數部分，不含初始化列表。

### KlpStageTab

ClassDeclaration · public · [lib/src/features/workspace/shell/stage/klp_stage_tab.dart:8](../../../../../../../lib/src/features/workspace/shell/stage/klp_stage_tab.dart#L8)

<code>class KlpStageTab extends StatelessWidget</code>

來源註解摘要：顯示目前 Stage 項目的單一檔案分頁。

- `extends` → <code>StatelessWidget</code>：[lib/src/features/workspace/shell/stage/klp_stage_tab.dart:9](../../../../../../../lib/src/features/workspace/shell/stage/klp_stage_tab.dart#L9)

| 成員 | 可見性 | 簽章／型別 | 來源註解摘要 | 證據 |
|---|---|---|---|---|
| constructor <code>KlpStageTab</code> | public | <code>const KlpStageTab({super.key, required this.label})</code> |  | [lib/src/features/workspace/shell/stage/klp_stage_tab.dart:10](../../../../../../../lib/src/features/workspace/shell/stage/klp_stage_tab.dart#L10) |
| field <code>label</code> | public | <code>final String label</code> |  | [lib/src/features/workspace/shell/stage/klp_stage_tab.dart:12](../../../../../../../lib/src/features/workspace/shell/stage/klp_stage_tab.dart#L12) |
| method <code>build</code> | public | <code>Widget build(BuildContext context)</code> |  | [lib/src/features/workspace/shell/stage/klp_stage_tab.dart:14](../../../../../../../lib/src/features/workspace/shell/stage/klp_stage_tab.dart#L14) |

## 閱讀說明與限制

箭頭只表示來源明寫的靜態關係；import 不等於呼叫。未分析動態呼叫、欄位的實際物件擁有權、狀態轉移或渲染流程；型別未進行語意解析，繼承目標保留原始型別拼寫。public／private 依 Dart 名稱前綴判斷；public 宣告不代表已由 `lib/kallopis.dart` 匯出。

本頁由 `tool/architecture_atlas` 產生；編輯來源或生成工具後重新產生，避免手改本頁。
