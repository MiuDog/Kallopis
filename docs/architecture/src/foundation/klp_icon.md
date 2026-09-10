# klp_icon.dart：直接依賴與宣告架構

[回到目錄](README.md) · [來源檔案](../../../../lib/src/foundation/klp_icon.dart)

## 範圍

核心是 `lib/src/foundation/klp_icon.dart`。主要視角為該檔案明寫的 import／export／part；輔助視角為本檔宣告及 extends／implements／with／on 關係。只展開一層外部邊界。

## 直接依賴圖

```mermaid
flowchart LR
	n0["klp_icon.dart"]
	n1["package:flutter/widgets.dart"]
	n2["../styling/legacy_theme/klp_theme.dart"]
	n3["klp_icon_data.dart"]
	n4["klp_icon_weight.dart"]
	n5["klp_icon_data.dart"]
	n6["klp_icon_weight.dart"]
	n0 -->|"import"| n1
	n0 -->|"import"| n2
	n0 -->|"import"| n3
	n0 -->|"import"| n4
	n0 -->|"export"| n5
	n0 -->|"export"| n6
```

## 依賴證據

| 關係 | 原始 directive | 來源 |
|---|---|---|
| import | <code>import &#x27;package:flutter/widgets.dart&#x27;;</code> | [lib/src/foundation/klp_icon.dart:1](../../../../lib/src/foundation/klp_icon.dart#L1) |
| import | <code>import &#x27;../styling/legacy_theme/klp_theme.dart&#x27;;</code> | [lib/src/foundation/klp_icon.dart:3](../../../../lib/src/foundation/klp_icon.dart#L3) |
| import | <code>import &#x27;klp_icon_data.dart&#x27;;</code> | [lib/src/foundation/klp_icon.dart:4](../../../../lib/src/foundation/klp_icon.dart#L4) |
| import | <code>import &#x27;klp_icon_weight.dart&#x27;;</code> | [lib/src/foundation/klp_icon.dart:5](../../../../lib/src/foundation/klp_icon.dart#L5) |
| export | <code>export &#x27;klp_icon_data.dart&#x27;;</code> | [lib/src/foundation/klp_icon.dart:7](../../../../lib/src/foundation/klp_icon.dart#L7) |
| export | <code>export &#x27;klp_icon_weight.dart&#x27;;</code> | [lib/src/foundation/klp_icon.dart:8](../../../../lib/src/foundation/klp_icon.dart#L8) |

## 宣告關係圖

本組節點是本檔宣告；沒有箭頭的宣告未在此圖主張互相依賴。

```mermaid
classDiagram
	class n0["KlpIcon"]
```

```mermaid
classDiagram
	class n0["KlpIcon"]
	class n1["StatelessWidget"]
	n0 --|> n1 : extends
```


## 宣告與成員證據

成員包含 public 與 private；簽章取自來源，省略函式本體與欄位初始值。`(inferred)` 表示來源未明寫型別；建構子只顯示參數部分，不含初始化列表。

### KlpIcon

ClassDeclaration · public · [lib/src/foundation/klp_icon.dart:10](../../../../lib/src/foundation/klp_icon.dart#L10)

<code>class KlpIcon extends StatelessWidget</code>

- `extends` → <code>StatelessWidget</code>：[lib/src/foundation/klp_icon.dart:10](../../../../lib/src/foundation/klp_icon.dart#L10)

| 成員 | 可見性 | 簽章／型別 | 來源註解摘要 | 證據 |
|---|---|---|---|---|
| constructor <code>KlpIcon</code> | public | <code>const KlpIcon( this.icon, { super.key, this.size, this.color, this.semanticLabel, this.weight = KlpIconWeight.regular, })</code> |  | [lib/src/foundation/klp_icon.dart:11](../../../../lib/src/foundation/klp_icon.dart#L11) |
| field <code>icon</code> | public | <code>final KlpIconData icon</code> |  | [lib/src/foundation/klp_icon.dart:20](../../../../lib/src/foundation/klp_icon.dart#L20) |
| field <code>size</code> | public | <code>final double? size</code> | `null` 表示沿用 theme 的圖示尺寸。 | [lib/src/foundation/klp_icon.dart:23](../../../../lib/src/foundation/klp_icon.dart#L23) |
| field <code>color</code> | public | <code>final Color? color</code> |  | [lib/src/foundation/klp_icon.dart:24](../../../../lib/src/foundation/klp_icon.dart#L24) |
| field <code>semanticLabel</code> | public | <code>final String? semanticLabel</code> |  | [lib/src/foundation/klp_icon.dart:25](../../../../lib/src/foundation/klp_icon.dart#L25) |
| field <code>weight</code> | public | <code>final KlpIconWeight weight</code> |  | [lib/src/foundation/klp_icon.dart:26](../../../../lib/src/foundation/klp_icon.dart#L26) |
| field <code>regularFontFamily</code> | public | <code>static const (inferred) regularFontFamily</code> | Regular Rounded 在 Flutter asset manifest 中登記的 family 名稱。 | [lib/src/foundation/klp_icon.dart:29](../../../../lib/src/foundation/klp_icon.dart#L29) |
| field <code>thinFontFamily</code> | public | <code>static const (inferred) thinFontFamily</code> | Thin Rounded 在 Flutter asset manifest 中登記的 family 名稱。 | [lib/src/foundation/klp_icon.dart:32](../../../../lib/src/foundation/klp_icon.dart#L32) |
| field <code>fontFamily</code> | public | <code>static const (inferred) fontFamily</code> | 向下相容的預設字型名稱。 | [lib/src/foundation/klp_icon.dart:35](../../../../lib/src/foundation/klp_icon.dart#L35) |
| method <code>build</code> | public | <code>Widget build(BuildContext context)</code> |  | [lib/src/foundation/klp_icon.dart:37](../../../../lib/src/foundation/klp_icon.dart#L37) |

## 閱讀說明與限制

箭頭只表示來源明寫的靜態關係；import 不等於呼叫。未分析動態呼叫、欄位的實際物件擁有權、狀態轉移或渲染流程；型別未進行語意解析，繼承目標保留原始型別拼寫。public／private 依 Dart 名稱前綴判斷；public 宣告不代表已由 `lib/kallopis.dart` 匯出。

本頁由 `tool/architecture_atlas` 產生；編輯來源或生成工具後重新產生，避免手改本頁。
