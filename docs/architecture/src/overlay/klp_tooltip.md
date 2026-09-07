# klp_tooltip.dart：直接依賴與宣告架構

[回到目錄](README.md) · [來源檔案](../../../../lib/src/overlay/klp_tooltip.dart)

## 範圍

核心是 `lib/src/overlay/klp_tooltip.dart`。主要視角為該檔案明寫的 import／export／part；輔助視角為本檔宣告及 extends／implements／with／on 關係。只展開一層外部邊界。

## 直接依賴圖

```mermaid
flowchart TD
	n0["klp_tooltip.dart"]
	n1["package:flutter/material.dart"]
	n2["../theme/klp_theme.dart"]
	n0 -->|"import"| n1
	n0 -->|"import"| n2
```

## 依賴證據

| 關係 | 原始 directive | 來源 |
|---|---|---|
| import | <code>import &#x27;package:flutter/material.dart&#x27;;</code> | [lib/src/overlay/klp_tooltip.dart:1](../../../../lib/src/overlay/klp_tooltip.dart#L1) |
| import | <code>import &#x27;../theme/klp_theme.dart&#x27;;</code> | [lib/src/overlay/klp_tooltip.dart:3](../../../../lib/src/overlay/klp_tooltip.dart#L3) |

## 宣告關係圖

本組節點是本檔宣告；沒有箭頭的宣告未在此圖主張互相依賴。

```mermaid
classDiagram
	class n0["KlpTooltip"]
	class n1["KlpTooltipSurface"]
```

```mermaid
classDiagram
	class n0["KlpTooltip"]
	class n1["StatelessWidget"]
	n0 --|> n1 : extends
```

```mermaid
classDiagram
	class n0["KlpTooltipSurface"]
	class n1["StatelessWidget"]
	n0 --|> n1 : extends
```


## 宣告與成員證據

成員包含 public 與 private；簽章取自來源，省略函式本體與欄位初始值。`(inferred)` 表示來源未明寫型別；建構子只顯示參數部分，不含初始化列表。

### KlpTooltip

ClassDeclaration · public · [lib/src/overlay/klp_tooltip.dart:5](../../../../lib/src/overlay/klp_tooltip.dart#L5)

<code>class KlpTooltip extends StatelessWidget</code>

- `extends` → <code>StatelessWidget</code>：[lib/src/overlay/klp_tooltip.dart:5](../../../../lib/src/overlay/klp_tooltip.dart#L5)

| 成員 | 可見性 | 簽章／型別 | 來源註解摘要 | 證據 |
|---|---|---|---|---|
| constructor <code>KlpTooltip</code> | public | <code>const KlpTooltip({super.key, required this.message, required this.child})</code> |  | [lib/src/overlay/klp_tooltip.dart:6](../../../../lib/src/overlay/klp_tooltip.dart#L6) |
| field <code>message</code> | public | <code>final String message</code> |  | [lib/src/overlay/klp_tooltip.dart:8](../../../../lib/src/overlay/klp_tooltip.dart#L8) |
| field <code>child</code> | public | <code>final Widget child</code> |  | [lib/src/overlay/klp_tooltip.dart:9](../../../../lib/src/overlay/klp_tooltip.dart#L9) |
| method <code>build</code> | public | <code>Widget build(BuildContext context)</code> |  | [lib/src/overlay/klp_tooltip.dart:11](../../../../lib/src/overlay/klp_tooltip.dart#L11) |

### KlpTooltipSurface

ClassDeclaration · public · [lib/src/overlay/klp_tooltip.dart:17](../../../../lib/src/overlay/klp_tooltip.dart#L17)

<code>class KlpTooltipSurface extends StatelessWidget</code>

- `extends` → <code>StatelessWidget</code>：[lib/src/overlay/klp_tooltip.dart:17](../../../../lib/src/overlay/klp_tooltip.dart#L17)

| 成員 | 可見性 | 簽章／型別 | 來源註解摘要 | 證據 |
|---|---|---|---|---|
| constructor <code>KlpTooltipSurface</code> | public | <code>const KlpTooltipSurface({super.key, required this.message, this.contentKey})</code> |  | [lib/src/overlay/klp_tooltip.dart:18](../../../../lib/src/overlay/klp_tooltip.dart#L18) |
| field <code>message</code> | public | <code>final String message</code> |  | [lib/src/overlay/klp_tooltip.dart:20](../../../../lib/src/overlay/klp_tooltip.dart#L20) |
| field <code>contentKey</code> | public | <code>final Key? contentKey</code> |  | [lib/src/overlay/klp_tooltip.dart:21](../../../../lib/src/overlay/klp_tooltip.dart#L21) |
| method <code>build</code> | public | <code>Widget build(BuildContext context)</code> |  | [lib/src/overlay/klp_tooltip.dart:23](../../../../lib/src/overlay/klp_tooltip.dart#L23) |

## 閱讀說明與限制

箭頭只表示來源明寫的靜態關係；import 不等於呼叫。未分析動態呼叫、欄位的實際物件擁有權、狀態轉移或渲染流程；型別未進行語意解析，繼承目標保留原始型別拼寫。public／private 依 Dart 名稱前綴判斷；public 宣告不代表已由 `lib/kallopis.dart` 匯出。

本頁由 `tool/architecture_atlas` 產生；編輯來源或生成工具後重新產生，避免手改本頁。
