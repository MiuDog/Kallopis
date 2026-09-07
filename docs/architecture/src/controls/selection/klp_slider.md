# klp_slider.dart：直接依賴與宣告架構

[回到目錄](README.md) · [來源檔案](../../../../../lib/src/controls/selection/klp_slider.dart)

## 範圍

核心是 `lib/src/controls/selection/klp_slider.dart`。主要視角為該檔案明寫的 import／export／part；輔助視角為本檔宣告及 extends／implements／with／on 關係。只展開一層外部邊界。

## 直接依賴圖

```mermaid
flowchart TD
	n0["klp_slider.dart"]
	n1["package:flutter/material.dart"]
	n2["../../theme/klp_theme.dart"]
	n3["../../typography/klp_text.dart"]
	n0 -->|"import"| n1
	n0 -->|"import"| n2
	n0 -->|"import"| n3
```

## 依賴證據

| 關係 | 原始 directive | 來源 |
|---|---|---|
| import | <code>import &#x27;package:flutter/material.dart&#x27;;</code> | [lib/src/controls/selection/klp_slider.dart:1](../../../../../lib/src/controls/selection/klp_slider.dart#L1) |
| import | <code>import &#x27;../../theme/klp_theme.dart&#x27;;</code> | [lib/src/controls/selection/klp_slider.dart:3](../../../../../lib/src/controls/selection/klp_slider.dart#L3) |
| import | <code>import &#x27;../../typography/klp_text.dart&#x27;;</code> | [lib/src/controls/selection/klp_slider.dart:4](../../../../../lib/src/controls/selection/klp_slider.dart#L4) |

## 宣告關係圖

本組節點是本檔宣告；沒有箭頭的宣告未在此圖主張互相依賴。

```mermaid
classDiagram
	class n0["KlpSlider"]
```

```mermaid
classDiagram
	class n0["KlpSlider"]
	class n1["StatelessWidget"]
	n0 --|> n1 : extends
```


## 宣告與成員證據

成員包含 public 與 private；簽章取自來源，省略函式本體與欄位初始值。`(inferred)` 表示來源未明寫型別；建構子只顯示參數部分，不含初始化列表。

### KlpSlider

ClassDeclaration · public · [lib/src/controls/selection/klp_slider.dart:6](../../../../../lib/src/controls/selection/klp_slider.dart#L6)

<code>class KlpSlider extends StatelessWidget</code>

- `extends` → <code>StatelessWidget</code>：[lib/src/controls/selection/klp_slider.dart:6](../../../../../lib/src/controls/selection/klp_slider.dart#L6)

| 成員 | 可見性 | 簽章／型別 | 來源註解摘要 | 證據 |
|---|---|---|---|---|
| constructor <code>KlpSlider</code> | public | <code>const KlpSlider({ super.key, required this.label, required this.value, required this.onChanged, this.min = 0.0, this.max = 1.0, this.divisions, this.displayValue, this.marks, })</code> |  | [lib/src/controls/selection/klp_slider.dart:7](../../../../../lib/src/controls/selection/klp_slider.dart#L7) |
| field <code>label</code> | public | <code>final String label</code> |  | [lib/src/controls/selection/klp_slider.dart:19](../../../../../lib/src/controls/selection/klp_slider.dart#L19) |
| field <code>value</code> | public | <code>final double value</code> |  | [lib/src/controls/selection/klp_slider.dart:20](../../../../../lib/src/controls/selection/klp_slider.dart#L20) |
| field <code>onChanged</code> | public | <code>final ValueChanged&lt;double&gt;? onChanged</code> |  | [lib/src/controls/selection/klp_slider.dart:21](../../../../../lib/src/controls/selection/klp_slider.dart#L21) |
| field <code>min</code> | public | <code>final double min</code> |  | [lib/src/controls/selection/klp_slider.dart:22](../../../../../lib/src/controls/selection/klp_slider.dart#L22) |
| field <code>max</code> | public | <code>final double max</code> |  | [lib/src/controls/selection/klp_slider.dart:23](../../../../../lib/src/controls/selection/klp_slider.dart#L23) |
| field <code>divisions</code> | public | <code>final int? divisions</code> |  | [lib/src/controls/selection/klp_slider.dart:24](../../../../../lib/src/controls/selection/klp_slider.dart#L24) |
| field <code>displayValue</code> | public | <code>final String? displayValue</code> |  | [lib/src/controls/selection/klp_slider.dart:25](../../../../../lib/src/controls/selection/klp_slider.dart#L25) |
| field <code>marks</code> | public | <code>final List&lt;String&gt;? marks</code> |  | [lib/src/controls/selection/klp_slider.dart:26](../../../../../lib/src/controls/selection/klp_slider.dart#L26) |
| method <code>build</code> | public | <code>Widget build(BuildContext context)</code> |  | [lib/src/controls/selection/klp_slider.dart:28](../../../../../lib/src/controls/selection/klp_slider.dart#L28) |

## 閱讀說明與限制

箭頭只表示來源明寫的靜態關係；import 不等於呼叫。未分析動態呼叫、欄位的實際物件擁有權、狀態轉移或渲染流程；型別未進行語意解析，繼承目標保留原始型別拼寫。public／private 依 Dart 名稱前綴判斷；public 宣告不代表已由 `lib/kallopis.dart` 匯出。

本頁由 `tool/architecture_atlas` 產生；編輯來源或生成工具後重新產生，避免手改本頁。
