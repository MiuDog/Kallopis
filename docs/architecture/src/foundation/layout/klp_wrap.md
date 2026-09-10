# klp_wrap.dart：直接依賴與宣告架構

[回到目錄](README.md) · [來源檔案](../../../../../lib/src/foundation/layout/klp_wrap.dart)

## 範圍

核心是 `lib/src/foundation/layout/klp_wrap.dart`。主要視角為該檔案明寫的 import／export／part；輔助視角為本檔宣告及 extends／implements／with／on 關係。只展開一層外部邊界。

## 直接依賴圖

```mermaid
flowchart TD
	n0["klp_wrap.dart"]
	n1["package:flutter/widgets.dart"]
	n2["klp_gap.dart"]
	n3["klp_space_size.dart"]
	n0 -->|"import"| n1
	n0 -->|"import"| n2
	n0 -->|"import"| n3
```

## 依賴證據

| 關係 | 原始 directive | 來源 |
|---|---|---|
| import | <code>import &#x27;package:flutter/widgets.dart&#x27;;</code> | [lib/src/foundation/layout/klp_wrap.dart:1](../../../../../lib/src/foundation/layout/klp_wrap.dart#L1) |
| import | <code>import &#x27;klp_gap.dart&#x27;;</code> | [lib/src/foundation/layout/klp_wrap.dart:3](../../../../../lib/src/foundation/layout/klp_wrap.dart#L3) |
| import | <code>import &#x27;klp_space_size.dart&#x27;;</code> | [lib/src/foundation/layout/klp_wrap.dart:4](../../../../../lib/src/foundation/layout/klp_wrap.dart#L4) |

## 宣告關係圖

本組節點是本檔宣告；沒有箭頭的宣告未在此圖主張互相依賴。

```mermaid
classDiagram
	class n0["KlpWrap"]
```

```mermaid
classDiagram
	class n0["KlpWrap"]
	class n1["StatelessWidget"]
	n0 --|> n1 : extends
```


## 宣告與成員證據

成員包含 public 與 private；簽章取自來源，省略函式本體與欄位初始值。`(inferred)` 表示來源未明寫型別；建構子只顯示參數部分，不含初始化列表。

### KlpWrap

ClassDeclaration · public · [lib/src/foundation/layout/klp_wrap.dart:6](../../../../../lib/src/foundation/layout/klp_wrap.dart#L6)

<code>class KlpWrap extends StatelessWidget</code>

來源註解摘要：可換行排版原語。間距僅接受 Kallopis 語意尺寸。

- `extends` → <code>StatelessWidget</code>：[lib/src/foundation/layout/klp_wrap.dart:7](../../../../../lib/src/foundation/layout/klp_wrap.dart#L7)

| 成員 | 可見性 | 簽章／型別 | 來源註解摘要 | 證據 |
|---|---|---|---|---|
| constructor <code>KlpWrap</code> | public | <code>const KlpWrap({ super.key, this.direction = Axis.horizontal, this.alignment = WrapAlignment.start, this.spacingSize, this.runAlignment = WrapAlignment.start, this.runSpacingSize, this.crossAxisAlignment = WrapCrossAlignment.start, this.textDirection, this.verticalDirection = VerticalDirection.down, this.clipBehavior = Clip.none, this.children = const &lt;Widget&gt;[], })</code> |  | [lib/src/foundation/layout/klp_wrap.dart:8](../../../../../lib/src/foundation/layout/klp_wrap.dart#L8) |
| field <code>direction</code> | public | <code>final Axis direction</code> |  | [lib/src/foundation/layout/klp_wrap.dart:22](../../../../../lib/src/foundation/layout/klp_wrap.dart#L22) |
| field <code>alignment</code> | public | <code>final WrapAlignment alignment</code> |  | [lib/src/foundation/layout/klp_wrap.dart:23](../../../../../lib/src/foundation/layout/klp_wrap.dart#L23) |
| field <code>spacingSize</code> | public | <code>final KlpSpaceSize? spacingSize</code> |  | [lib/src/foundation/layout/klp_wrap.dart:24](../../../../../lib/src/foundation/layout/klp_wrap.dart#L24) |
| field <code>runAlignment</code> | public | <code>final WrapAlignment runAlignment</code> |  | [lib/src/foundation/layout/klp_wrap.dart:25](../../../../../lib/src/foundation/layout/klp_wrap.dart#L25) |
| field <code>runSpacingSize</code> | public | <code>final KlpSpaceSize? runSpacingSize</code> |  | [lib/src/foundation/layout/klp_wrap.dart:26](../../../../../lib/src/foundation/layout/klp_wrap.dart#L26) |
| field <code>crossAxisAlignment</code> | public | <code>final WrapCrossAlignment crossAxisAlignment</code> |  | [lib/src/foundation/layout/klp_wrap.dart:27](../../../../../lib/src/foundation/layout/klp_wrap.dart#L27) |
| field <code>textDirection</code> | public | <code>final TextDirection? textDirection</code> |  | [lib/src/foundation/layout/klp_wrap.dart:28](../../../../../lib/src/foundation/layout/klp_wrap.dart#L28) |
| field <code>verticalDirection</code> | public | <code>final VerticalDirection verticalDirection</code> |  | [lib/src/foundation/layout/klp_wrap.dart:29](../../../../../lib/src/foundation/layout/klp_wrap.dart#L29) |
| field <code>clipBehavior</code> | public | <code>final Clip clipBehavior</code> |  | [lib/src/foundation/layout/klp_wrap.dart:30](../../../../../lib/src/foundation/layout/klp_wrap.dart#L30) |
| field <code>children</code> | public | <code>final List&lt;Widget&gt; children</code> |  | [lib/src/foundation/layout/klp_wrap.dart:31](../../../../../lib/src/foundation/layout/klp_wrap.dart#L31) |
| method <code>build</code> | public | <code>Widget build(BuildContext context)</code> |  | [lib/src/foundation/layout/klp_wrap.dart:33](../../../../../lib/src/foundation/layout/klp_wrap.dart#L33) |

## 閱讀說明與限制

箭頭只表示來源明寫的靜態關係；import 不等於呼叫。未分析動態呼叫、欄位的實際物件擁有權、狀態轉移或渲染流程；型別未進行語意解析，繼承目標保留原始型別拼寫。public／private 依 Dart 名稱前綴判斷；public 宣告不代表已由 `lib/kallopis.dart` 匯出。

本頁由 `tool/architecture_atlas` 產生；編輯來源或生成工具後重新產生，避免手改本頁。
