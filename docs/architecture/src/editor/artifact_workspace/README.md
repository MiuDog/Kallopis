# lib/src/editor/artifact_workspace：架構分析入口

[上一層](../README.md)

## 範圍

閱讀 `lib/src/editor/artifact_workspace` 的直接子目錄與 Dart 檔案。結構圖表示實際檔案包含關係；依賴圖表示本層檔案明寫的 directives。每個檔案頁另列直接依賴、宣告、欄位、方法、建構子及行號證據。

## 本層直接依賴圖

箭頭以本層 Dart 檔案明寫的 directive 彙總到目標所在目錄或外部套件邊界；不遞迴將子目錄依賴算入本層。相同目標的不同 directive 類型分開計數。

```mermaid
flowchart LR
	n0["lib/src/editor/artifact_workspace"]
	n1["lib/src/controls/button"]
	n2["lib/src/data/advanced"]
	n3["lib/src/data/badge"]
	n4["lib/src/data/preview_card"]
	n5["lib/src/feedback"]
	n6["lib/src/form"]
	n7["lib/src/navigation/tabs"]
	n8["lib/src/surface"]
	n9["lib/src/theme"]
	n10["lib/src/typography"]
	n11["package:flutter"]
	n0 -->|"import"| n1
	n0 -->|"import"| n2
	n0 -->|"import"| n3
	n0 -->|"import"| n4
	n0 -->|"import"| n5
	n0 -->|"import"| n6
	n0 -->|"import"| n7
	n0 -->|"import"| n8
	n0 -->|"import"| n9
	n0 -->|"import"| n10
	n0 -->|"import"| n11
```

| 目標邊界 | 關係 | directive 數 | 第一筆來源證據 |
|---|---|---|---|
| <code>lib/src/controls/button</code> | import | 1 | [lib/src/editor/artifact_workspace/klp_artifact_workspace.dart:3](../../../../../lib/src/editor/artifact_workspace/klp_artifact_workspace.dart#L3) |
| <code>lib/src/data/advanced</code> | import | 1 | [lib/src/editor/artifact_workspace/klp_artifact_workspace.dart:4](../../../../../lib/src/editor/artifact_workspace/klp_artifact_workspace.dart#L4) |
| <code>lib/src/data/badge</code> | import | 1 | [lib/src/editor/artifact_workspace/klp_artifact_workspace.dart:5](../../../../../lib/src/editor/artifact_workspace/klp_artifact_workspace.dart#L5) |
| <code>lib/src/data/preview_card</code> | import | 1 | [lib/src/editor/artifact_workspace/klp_artifact_workspace.dart:6](../../../../../lib/src/editor/artifact_workspace/klp_artifact_workspace.dart#L6) |
| <code>lib/src/feedback</code> | import | 2 | [lib/src/editor/artifact_workspace/klp_artifact_workspace.dart:7](../../../../../lib/src/editor/artifact_workspace/klp_artifact_workspace.dart#L7) |
| <code>lib/src/form</code> | import | 1 | [lib/src/editor/artifact_workspace/klp_artifact_workspace.dart:9](../../../../../lib/src/editor/artifact_workspace/klp_artifact_workspace.dart#L9) |
| <code>lib/src/navigation/tabs</code> | import | 1 | [lib/src/editor/artifact_workspace/klp_artifact_workspace.dart:10](../../../../../lib/src/editor/artifact_workspace/klp_artifact_workspace.dart#L10) |
| <code>lib/src/surface</code> | import | 1 | [lib/src/editor/artifact_workspace/klp_artifact_workspace.dart:11](../../../../../lib/src/editor/artifact_workspace/klp_artifact_workspace.dart#L11) |
| <code>lib/src/theme</code> | import | 1 | [lib/src/editor/artifact_workspace/klp_artifact_workspace.dart:12](../../../../../lib/src/editor/artifact_workspace/klp_artifact_workspace.dart#L12) |
| <code>lib/src/typography</code> | import | 1 | [lib/src/editor/artifact_workspace/klp_artifact_workspace.dart:13](../../../../../lib/src/editor/artifact_workspace/klp_artifact_workspace.dart#L13) |
| <code>package:flutter</code> | import | 1 | [lib/src/editor/artifact_workspace/klp_artifact_workspace.dart:1](../../../../../lib/src/editor/artifact_workspace/klp_artifact_workspace.dart#L1) |

## 目錄結構圖

```mermaid
flowchart TD
	n0["lib/src/editor/artifact_workspace"]
	n1["klp_artifact_workspace.dart"]
	n0 -->|"contains"| n1
```

## 子目錄

| 目錄 | 導航 | 來源證據 |
|---|---|---|
| 無 | 目前沒有下一層目錄 | — |

## 本層檔案

| 檔案 | 宣告 | 細節 | 來源證據 |
|---|---|---|---|
| `klp_artifact_workspace.dart` | KlpDocumentHeader, KlpDocumentSection, KlpDocumentField, KlpDocumentReferenceLink, KlpDocumentEditActions, KlpTokenDefinitionData, KlpTokenTable, KlpTokenValidationBanner, KlpComponentDefinitionData, KlpComponentDefinitionCard, KlpComponentLibraryGrid, KlpComponentStateSelector, KlpAccessibilityContractPanel | [架構與 API](klp_artifact_workspace.md) | [lib/src/editor/artifact_workspace/klp_artifact_workspace.dart:1](../../../../../lib/src/editor/artifact_workspace/klp_artifact_workspace.dart#L1) |

## 閱讀說明

箭頭只表示來源明寫的靜態關係；import 不等於呼叫。未分析動態呼叫、欄位的實際物件擁有權、狀態轉移或渲染流程；型別未進行語意解析，繼承目標保留原始型別拼寫。public／private 依 Dart 名稱前綴判斷；public 宣告不代表已由 `lib/kallopis.dart` 匯出。

本頁的目錄與檔案由來源清冊產生；`manifest.json` 位於本圖集根目錄，可核對 SHA-256 與覆蓋數。人工模組摘要存於 `tool/architecture_atlas/briefs/`，重新生成時保留。
