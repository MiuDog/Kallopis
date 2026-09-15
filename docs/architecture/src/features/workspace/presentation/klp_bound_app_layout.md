# klp_bound_app_layout.dart：直接依賴與宣告架構

[回到目錄](README.md) · [來源檔案](../../../../../../lib/src/features/workspace/presentation/klp_bound_app_layout.dart)

## 範圍

核心是 `lib/src/features/workspace/presentation/klp_bound_app_layout.dart`。主要視角為該檔案明寫的 import／export／part；輔助視角為本檔宣告及 extends／implements／with／on 關係。只展開一層外部邊界。

## 直接依賴圖

```mermaid
flowchart TD
	n0["klp_bound_app_layout.dart"]
	n1["klp_workspace_presentation.dart"]
	n0 -->|"part of"| n1
```

## 依賴證據

| 關係 | 原始 directive | 來源 |
|---|---|---|
| part of | <code>part of &#x27;klp_workspace_presentation.dart&#x27;;</code> | [lib/src/features/workspace/presentation/klp_bound_app_layout.dart:1](../../../../../../lib/src/features/workspace/presentation/klp_bound_app_layout.dart#L1) |

## 宣告關係圖

本組節點是本檔宣告；沒有箭頭的宣告未在此圖主張互相依賴。

```mermaid
classDiagram
	class n0["KlpBoundAppLayout"]
```

```mermaid
classDiagram
	class n0["KlpBoundAppLayout"]
	class n1["KlpBoundTemplate"]
	n0 --|> n1 : extends
```


## 宣告與成員證據

成員包含 public 與 private；簽章取自來源，省略函式本體與欄位初始值。`(inferred)` 表示來源未明寫型別；建構子只顯示參數部分，不含初始化列表。

### KlpBoundAppLayout

ClassDeclaration · public · [lib/src/features/workspace/presentation/klp_bound_app_layout.dart:3](../../../../../../lib/src/features/workspace/presentation/klp_bound_app_layout.dart#L3)

<code>final class KlpBoundAppLayout extends KlpBoundTemplate</code>

來源註解摘要：已解析 app layout 呈現資料；僅 renderer 可解讀其 kind。

- `extends` → <code>KlpBoundTemplate</code>：[lib/src/features/workspace/presentation/klp_bound_app_layout.dart:4](../../../../../../lib/src/features/workspace/presentation/klp_bound_app_layout.dart#L4)

| 成員 | 可見性 | 簽章／型別 | 來源註解摘要 | 證據 |
|---|---|---|---|---|
| field <code>kind</code> | public | <code>final int kind</code> |  | [lib/src/features/workspace/presentation/klp_bound_app_layout.dart:6](../../../../../../lib/src/features/workspace/presentation/klp_bound_app_layout.dart#L6) |
| field <code>inset</code> | public | <code>final KlpDistance inset</code> |  | [lib/src/features/workspace/presentation/klp_bound_app_layout.dart:7](../../../../../../lib/src/features/workspace/presentation/klp_bound_app_layout.dart#L7) |
| field <code>headerExtent</code> | public | <code>final KlpDistance? headerExtent</code> |  | [lib/src/features/workspace/presentation/klp_bound_app_layout.dart:8](../../../../../../lib/src/features/workspace/presentation/klp_bound_app_layout.dart#L8) |
| field <code>onHeaderDrag</code> | public | <code>final void Function()? onHeaderDrag</code> |  | [lib/src/features/workspace/presentation/klp_bound_app_layout.dart:9](../../../../../../lib/src/features/workspace/presentation/klp_bound_app_layout.dart#L9) |
| field <code>background</code> | public | <code>final KlpColor background</code> |  | [lib/src/features/workspace/presentation/klp_bound_app_layout.dart:10](../../../../../../lib/src/features/workspace/presentation/klp_bound_app_layout.dart#L10) |
| field <code>radius</code> | public | <code>final KlpRadius radius</code> |  | [lib/src/features/workspace/presentation/klp_bound_app_layout.dart:11](../../../../../../lib/src/features/workspace/presentation/klp_bound_app_layout.dart#L11) |
| field <code>flex</code> | public | <code>final int flex</code> |  | [lib/src/features/workspace/presentation/klp_bound_app_layout.dart:12](../../../../../../lib/src/features/workspace/presentation/klp_bound_app_layout.dart#L12) |
| field <code>laneExtent</code> | public | <code>final KlpDistance? laneExtent</code> |  | [lib/src/features/workspace/presentation/klp_bound_app_layout.dart:13](../../../../../../lib/src/features/workspace/presentation/klp_bound_app_layout.dart#L13) |
| field <code>bare</code> | public | <code>final bool bare</code> |  | [lib/src/features/workspace/presentation/klp_bound_app_layout.dart:14](../../../../../../lib/src/features/workspace/presentation/klp_bound_app_layout.dart#L14) |
| field <code>alignment</code> | public | <code>final int alignment</code> |  | [lib/src/features/workspace/presentation/klp_bound_app_layout.dart:15](../../../../../../lib/src/features/workspace/presentation/klp_bound_app_layout.dart#L15) |
| field <code>gapless</code> | public | <code>final bool gapless</code> |  | [lib/src/features/workspace/presentation/klp_bound_app_layout.dart:16](../../../../../../lib/src/features/workspace/presentation/klp_bound_app_layout.dart#L16) |
| field <code>children</code> | public | <code>final List&lt;KlpBoundTemplate&gt; children</code> |  | [lib/src/features/workspace/presentation/klp_bound_app_layout.dart:17](../../../../../../lib/src/features/workspace/presentation/klp_bound_app_layout.dart#L17) |
| constructor <code>KlpBoundAppLayout</code> | public | <code>KlpBoundAppLayout({required this.kind, required this.inset, this.headerExtent, this.onHeaderDrag, required this.background, required this.radius, required this.flex, required this.laneExtent, required this.bare, required this.alignment, required this.gapless, required Iterable&lt;KlpBoundTemplate&gt; children})</code> |  | [lib/src/features/workspace/presentation/klp_bound_app_layout.dart:19](../../../../../../lib/src/features/workspace/presentation/klp_bound_app_layout.dart#L19) |

## 閱讀說明與限制

箭頭只表示來源明寫的靜態關係；import 不等於呼叫。未分析動態呼叫、欄位的實際物件擁有權、狀態轉移或渲染流程；型別未進行語意解析，繼承目標保留原始型別拼寫。public／private 依 Dart 名稱前綴判斷；public 宣告不代表已由 `lib/kallopis.dart` 匯出。

本頁由 `tool/architecture_atlas` 產生；編輯來源或生成工具後重新產生，避免手改本頁。
