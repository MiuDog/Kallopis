# klp_navigation_rail_widget.dart：直接依賴與宣告架構

[回到目錄](README.md) · [來源檔案](../../../../../../../../lib/src/features/navigation/widgets/rail/internal/klp_navigation_rail_widget.dart)

## 範圍

核心是 `lib/src/features/navigation/widgets/rail/internal/klp_navigation_rail_widget.dart`。主要視角為該檔案明寫的 import／export／part；輔助視角為本檔宣告及 extends／implements／with／on 關係。只展開一層外部邊界。

## 直接依賴圖

```mermaid
flowchart TD
	n0["klp_navigation_rail_widget.dart"]
	n1["../klp_navigation_rail.dart"]
	n0 -->|"part of"| n1
```

## 依賴證據

| 關係 | 原始 directive | 來源 |
|---|---|---|
| part of | <code>part of &#x27;../klp_navigation_rail.dart&#x27;;</code> | [lib/src/features/navigation/widgets/rail/internal/klp_navigation_rail_widget.dart:1](../../../../../../../../lib/src/features/navigation/widgets/rail/internal/klp_navigation_rail_widget.dart#L1) |

## 宣告關係圖

本組節點是本檔宣告；沒有箭頭的宣告未在此圖主張互相依賴。

```mermaid
classDiagram
	class n0["KlpNavigationRail"]
```

```mermaid
classDiagram
	class n0["KlpNavigationRail"]
	class n1["StatefulWidget"]
	n0 --|> n1 : extends
```


## 宣告與成員證據

成員包含 public 與 private；簽章取自來源，省略函式本體與欄位初始值。`(inferred)` 表示來源未明寫型別；建構子只顯示參數部分，不含初始化列表。

### KlpNavigationRail

ClassDeclaration · public · [lib/src/features/navigation/widgets/rail/internal/klp_navigation_rail_widget.dart:3](../../../../../../../../lib/src/features/navigation/widgets/rail/internal/klp_navigation_rail_widget.dart#L3)

<code>class KlpNavigationRail extends StatefulWidget</code>

來源註解摘要：Workbench 的主要圖示導覽軌。 分組模式只接受 [KlpRailItemGroup]；群組之間自動加入分隔線，項目只能在 原群組內排序。

- `extends` → <code>StatefulWidget</code>：[lib/src/features/navigation/widgets/rail/internal/klp_navigation_rail_widget.dart:7](../../../../../../../../lib/src/features/navigation/widgets/rail/internal/klp_navigation_rail_widget.dart#L7)

| 成員 | 可見性 | 簽章／型別 | 來源註解摘要 | 證據 |
|---|---|---|---|---|
| constructor <code>KlpNavigationRail</code> | public | <code>const KlpNavigationRail({ super.key, required this.top, required this.center, required this.bottom, })</code> |  | [lib/src/features/navigation/widgets/rail/internal/klp_navigation_rail_widget.dart:8](../../../../../../../../lib/src/features/navigation/widgets/rail/internal/klp_navigation_rail_widget.dart#L8) |
| field <code>top</code> | public | <code>final KlpRailItemGroup top</code> |  | [lib/src/features/navigation/widgets/rail/internal/klp_navigation_rail_widget.dart:15](../../../../../../../../lib/src/features/navigation/widgets/rail/internal/klp_navigation_rail_widget.dart#L15) |
| field <code>center</code> | public | <code>final KlpRailItemGroup center</code> |  | [lib/src/features/navigation/widgets/rail/internal/klp_navigation_rail_widget.dart:16](../../../../../../../../lib/src/features/navigation/widgets/rail/internal/klp_navigation_rail_widget.dart#L16) |
| field <code>bottom</code> | public | <code>final KlpRailItemGroup bottom</code> |  | [lib/src/features/navigation/widgets/rail/internal/klp_navigation_rail_widget.dart:17](../../../../../../../../lib/src/features/navigation/widgets/rail/internal/klp_navigation_rail_widget.dart#L17) |
| method <code>createState</code> | public | <code>State&lt;KlpNavigationRail&gt; createState()</code> |  | [lib/src/features/navigation/widgets/rail/internal/klp_navigation_rail_widget.dart:19](../../../../../../../../lib/src/features/navigation/widgets/rail/internal/klp_navigation_rail_widget.dart#L19) |

## 閱讀說明與限制

箭頭只表示來源明寫的靜態關係；import 不等於呼叫。未分析動態呼叫、欄位的實際物件擁有權、狀態轉移或渲染流程；型別未進行語意解析，繼承目標保留原始型別拼寫。public／private 依 Dart 名稱前綴判斷；public 宣告不代表已由 `lib/kallopis.dart` 匯出。

本頁由 `tool/architecture_atlas` 產生；編輯來源或生成工具後重新產生，避免手改本頁。
