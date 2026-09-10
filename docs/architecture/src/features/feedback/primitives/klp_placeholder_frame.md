# klp_placeholder_frame.dart：直接依賴與宣告架構

[回到目錄](README.md) · [來源檔案](../../../../../../lib/src/features/feedback/primitives/klp_placeholder_frame.dart)

## 範圍

核心是 `lib/src/features/feedback/primitives/klp_placeholder_frame.dart`。主要視角為該檔案明寫的 import／export／part；輔助視角為本檔宣告及 extends／implements／with／on 關係。只展開一層外部邊界。

## 直接依賴圖

```mermaid
flowchart TD
	n0["klp_placeholder_frame.dart"]
	n1["../klp_region_placeholder.dart"]
	n0 -->|"part of"| n1
```

## 依賴證據

| 關係 | 原始 directive | 來源 |
|---|---|---|
| part of | <code>part of &#x27;../klp_region_placeholder.dart&#x27;;</code> | [lib/src/features/feedback/primitives/klp_placeholder_frame.dart:1](../../../../../../lib/src/features/feedback/primitives/klp_placeholder_frame.dart#L1) |

## 宣告關係圖

本組節點是本檔宣告；沒有箭頭的宣告未在此圖主張互相依賴。

```mermaid
classDiagram
	class n0["_KlpPlaceholderFrame"]
```

```mermaid
classDiagram
	class n0["_KlpPlaceholderFrame"]
	class n1["StatelessWidget"]
	n0 --|> n1 : extends
```


## 宣告與成員證據

成員包含 public 與 private；簽章取自來源，省略函式本體與欄位初始值。`(inferred)` 表示來源未明寫型別；建構子只顯示參數部分，不含初始化列表。

### _KlpPlaceholderFrame

ClassDeclaration · private · [lib/src/features/feedback/primitives/klp_placeholder_frame.dart:3](../../../../../../lib/src/features/feedback/primitives/klp_placeholder_frame.dart#L3)

<code>class _KlpPlaceholderFrame extends StatelessWidget</code>

來源註解摘要：將 Placeholder 的 Flutter 裁切與繪製限制在 feedback 基礎原語邊界。

- `extends` → <code>StatelessWidget</code>：[lib/src/features/feedback/primitives/klp_placeholder_frame.dart:4](../../../../../../lib/src/features/feedback/primitives/klp_placeholder_frame.dart#L4)

| 成員 | 可見性 | 簽章／型別 | 來源註解摘要 | 證據 |
|---|---|---|---|---|
| constructor <code>_KlpPlaceholderFrame</code> | private | <code>const _KlpPlaceholderFrame({ required this.radius, required this.borderColor, required this.borderWidth, required this.fillColor, required this.hatchColor, required this.hatched, required this.hatchBand, required this.hatchGap, required this.child, })</code> |  | [lib/src/features/feedback/primitives/klp_placeholder_frame.dart:5](../../../../../../lib/src/features/feedback/primitives/klp_placeholder_frame.dart#L5) |
| field <code>radius</code> | public | <code>final double radius</code> |  | [lib/src/features/feedback/primitives/klp_placeholder_frame.dart:17](../../../../../../lib/src/features/feedback/primitives/klp_placeholder_frame.dart#L17) |
| field <code>borderColor</code> | public | <code>final Color borderColor</code> |  | [lib/src/features/feedback/primitives/klp_placeholder_frame.dart:18](../../../../../../lib/src/features/feedback/primitives/klp_placeholder_frame.dart#L18) |
| field <code>borderWidth</code> | public | <code>final double borderWidth</code> |  | [lib/src/features/feedback/primitives/klp_placeholder_frame.dart:19](../../../../../../lib/src/features/feedback/primitives/klp_placeholder_frame.dart#L19) |
| field <code>fillColor</code> | public | <code>final Color fillColor</code> |  | [lib/src/features/feedback/primitives/klp_placeholder_frame.dart:20](../../../../../../lib/src/features/feedback/primitives/klp_placeholder_frame.dart#L20) |
| field <code>hatchColor</code> | public | <code>final Color hatchColor</code> |  | [lib/src/features/feedback/primitives/klp_placeholder_frame.dart:21](../../../../../../lib/src/features/feedback/primitives/klp_placeholder_frame.dart#L21) |
| field <code>hatched</code> | public | <code>final bool hatched</code> |  | [lib/src/features/feedback/primitives/klp_placeholder_frame.dart:22](../../../../../../lib/src/features/feedback/primitives/klp_placeholder_frame.dart#L22) |
| field <code>hatchBand</code> | public | <code>final double hatchBand</code> |  | [lib/src/features/feedback/primitives/klp_placeholder_frame.dart:23](../../../../../../lib/src/features/feedback/primitives/klp_placeholder_frame.dart#L23) |
| field <code>hatchGap</code> | public | <code>final double hatchGap</code> |  | [lib/src/features/feedback/primitives/klp_placeholder_frame.dart:24](../../../../../../lib/src/features/feedback/primitives/klp_placeholder_frame.dart#L24) |
| field <code>child</code> | public | <code>final Widget child</code> |  | [lib/src/features/feedback/primitives/klp_placeholder_frame.dart:25](../../../../../../lib/src/features/feedback/primitives/klp_placeholder_frame.dart#L25) |
| method <code>build</code> | public | <code>Widget build(BuildContext context)</code> |  | [lib/src/features/feedback/primitives/klp_placeholder_frame.dart:27](../../../../../../lib/src/features/feedback/primitives/klp_placeholder_frame.dart#L27) |

## 閱讀說明與限制

箭頭只表示來源明寫的靜態關係；import 不等於呼叫。未分析動態呼叫、欄位的實際物件擁有權、狀態轉移或渲染流程；型別未進行語意解析，繼承目標保留原始型別拼寫。public／private 依 Dart 名稱前綴判斷；public 宣告不代表已由 `lib/kallopis.dart` 匯出。

本頁由 `tool/architecture_atlas` 產生；編輯來源或生成工具後重新產生，避免手改本頁。
