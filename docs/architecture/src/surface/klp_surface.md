# klp_surface.dart：直接依賴與宣告架構

[回到目錄](README.md) · [來源檔案](../../../../lib/src/surface/klp_surface.dart)

## 範圍

核心是 `lib/src/surface/klp_surface.dart`。主要視角為該檔案明寫的 import／export／part；輔助視角為本檔宣告及 extends／implements／with／on 關係。只展開一層外部邊界。

## 直接依賴圖

```mermaid
flowchart TD
	n0["klp_surface.dart"]
	n1["dart:ui"]
	n2["package:flutter/material.dart"]
	n3["../theme/klp_theme.dart"]
	n0 -->|"import"| n1
	n0 -->|"import"| n2
	n0 -->|"import"| n3
```

## 依賴證據

| 關係 | 原始 directive | 來源 |
|---|---|---|
| import | <code>import &#x27;dart:ui&#x27; show ImageFilter;</code> | [lib/src/surface/klp_surface.dart:1](../../../../lib/src/surface/klp_surface.dart#L1) |
| import | <code>import &#x27;package:flutter/material.dart&#x27;;</code> | [lib/src/surface/klp_surface.dart:2](../../../../lib/src/surface/klp_surface.dart#L2) |
| import | <code>import &#x27;../theme/klp_theme.dart&#x27;;</code> | [lib/src/surface/klp_surface.dart:4](../../../../lib/src/surface/klp_surface.dart#L4) |

## 宣告關係圖

本組節點是本檔宣告；沒有箭頭的宣告未在此圖主張互相依賴。

```mermaid
classDiagram
	class n0["KlpSurfaceTone"]
	class n1["KlpSurface"]
```

```mermaid
classDiagram
	class n0["KlpSurface"]
	class n1["StatelessWidget"]
	n0 --|> n1 : extends
```


## 宣告與成員證據

成員包含 public 與 private；簽章取自來源，省略函式本體與欄位初始值。`(inferred)` 表示來源未明寫型別；建構子只顯示參數部分，不含初始化列表。

### KlpSurfaceTone

EnumDeclaration · public · [lib/src/surface/klp_surface.dart:6](../../../../lib/src/surface/klp_surface.dart#L6)

<code>enum KlpSurfaceTone</code>

來源註解摘要：表面在階層中的位置。由淺到深：`base` → `inset` → `muted`，另有 `component` （控制項底色）、`overlay`（浮層）、`raised`（次級內容區）、`stage`（舞台區）、 `accent` / `accentSoft`（強調色表面）與 `transparent`。


| 成員 | 可見性 | 簽章／型別 | 來源註解摘要 | 證據 |
|---|---|---|---|---|
| enum value <code>base</code> | public | <code>base</code> |  | [lib/src/surface/klp_surface.dart:10](../../../../lib/src/surface/klp_surface.dart#L10) |
| enum value <code>inset</code> | public | <code>inset</code> |  | [lib/src/surface/klp_surface.dart:11](../../../../lib/src/surface/klp_surface.dart#L11) |
| enum value <code>muted</code> | public | <code>muted</code> |  | [lib/src/surface/klp_surface.dart:12](../../../../lib/src/surface/klp_surface.dart#L12) |
| enum value <code>component</code> | public | <code>component</code> |  | [lib/src/surface/klp_surface.dart:13](../../../../lib/src/surface/klp_surface.dart#L13) |
| enum value <code>overlay</code> | public | <code>overlay</code> |  | [lib/src/surface/klp_surface.dart:14](../../../../lib/src/surface/klp_surface.dart#L14) |
| enum value <code>raised</code> | public | <code>raised</code> |  | [lib/src/surface/klp_surface.dart:15](../../../../lib/src/surface/klp_surface.dart#L15) |
| enum value <code>stage</code> | public | <code>stage</code> |  | [lib/src/surface/klp_surface.dart:16](../../../../lib/src/surface/klp_surface.dart#L16) |
| enum value <code>accent</code> | public | <code>accent</code> |  | [lib/src/surface/klp_surface.dart:17](../../../../lib/src/surface/klp_surface.dart#L17) |
| enum value <code>accentSoft</code> | public | <code>accentSoft</code> |  | [lib/src/surface/klp_surface.dart:18](../../../../lib/src/surface/klp_surface.dart#L18) |
| enum value <code>transparent</code> | public | <code>transparent</code> |  | [lib/src/surface/klp_surface.dart:19](../../../../lib/src/surface/klp_surface.dart#L19) |

### KlpSurface

ClassDeclaration · public · [lib/src/surface/klp_surface.dart:22](../../../../lib/src/surface/klp_surface.dart#L22)

<code>class KlpSurface extends StatelessWidget</code>

來源註解摘要：有底色的容器，是所有區塊的基底。`tone` 指定它在表面階層中的位置， 支援邊框、微漸層、外發光與霧化透明（毛玻璃）等多種原生 Box 視覺效果。 文字顏色依據背景顏色階梯（500 以下為深色文字，600 以上為淺色文字）自適應渲染。

- `extends` → <code>StatelessWidget</code>：[lib/src/surface/klp_surface.dart:25](../../../../lib/src/surface/klp_surface.dart#L25)

| 成員 | 可見性 | 簽章／型別 | 來源註解摘要 | 證據 |
|---|---|---|---|---|
| constructor <code>KlpSurface</code> | public | <code>const KlpSurface({ super.key, required this.child, this.tone = KlpSurfaceTone.base, this.radius, this.padding, this.border, this.gradient, this.shadows, this.frosted = false, this.blurSigma, })</code> |  | [lib/src/surface/klp_surface.dart:26](../../../../lib/src/surface/klp_surface.dart#L26) |
| field <code>child</code> | public | <code>final Widget child</code> |  | [lib/src/surface/klp_surface.dart:39](../../../../lib/src/surface/klp_surface.dart#L39) |
| field <code>tone</code> | public | <code>final KlpSurfaceTone tone</code> |  | [lib/src/surface/klp_surface.dart:40](../../../../lib/src/surface/klp_surface.dart#L40) |
| field <code>radius</code> | public | <code>final double? radius</code> | `null` 表示沿用 theme 的卡片圓角。指定值只用於刻意偏離的場合。 | [lib/src/surface/klp_surface.dart:43](../../../../lib/src/surface/klp_surface.dart#L43) |
| field <code>padding</code> | public | <code>final EdgeInsetsGeometry? padding</code> |  | [lib/src/surface/klp_surface.dart:44](../../../../lib/src/surface/klp_surface.dart#L44) |
| field <code>border</code> | public | <code>final BoxBorder? border</code> | 自訂外邊框或方向性邊線。 | [lib/src/surface/klp_surface.dart:47](../../../../lib/src/surface/klp_surface.dart#L47) |
| field <code>gradient</code> | public | <code>final Gradient? gradient</code> | 背景微漸層效果。 | [lib/src/surface/klp_surface.dart:50](../../../../lib/src/surface/klp_surface.dart#L50) |
| field <code>shadows</code> | public | <code>final List&lt;BoxShadow&gt;? shadows</code> | 投影、內發光或外發光光暈效果。 | [lib/src/surface/klp_surface.dart:53](../../../../lib/src/surface/klp_surface.dart#L53) |
| field <code>frosted</code> | public | <code>final bool frosted</code> | 是否啟用毛玻璃（BackdropFilter 霧化透明）效果。 | [lib/src/surface/klp_surface.dart:56](../../../../lib/src/surface/klp_surface.dart#L56) |
| field <code>blurSigma</code> | public | <code>final double? blurSigma</code> | 霧化透明之高斯模糊強度 (sigma)。預設為 12.0。 | [lib/src/surface/klp_surface.dart:59](../../../../lib/src/surface/klp_surface.dart#L59) |
| method <code>build</code> | public | <code>Widget build(BuildContext context)</code> |  | [lib/src/surface/klp_surface.dart:61](../../../../lib/src/surface/klp_surface.dart#L61) |

## 閱讀說明與限制

箭頭只表示來源明寫的靜態關係；import 不等於呼叫。未分析動態呼叫、欄位的實際物件擁有權、狀態轉移或渲染流程；型別未進行語意解析，繼承目標保留原始型別拼寫。public／private 依 Dart 名稱前綴判斷；public 宣告不代表已由 `lib/kallopis.dart` 匯出。

本頁由 `tool/architecture_atlas` 產生；編輯來源或生成工具後重新產生，避免手改本頁。
