# klp_compact_switch_style.dart：直接依賴與宣告架構

[回到目錄](README.md) · [來源檔案](../../../../../../../lib/src/features/forms/toggle/internal/klp_compact_switch_style.dart)

## 範圍

核心是 `lib/src/features/forms/toggle/internal/klp_compact_switch_style.dart`。主要視角為該檔案明寫的 import／export／part；輔助視角為本檔宣告及 extends／implements／with／on 關係。只展開一層外部邊界。

## 直接依賴圖

```mermaid
flowchart TD
	n0["klp_compact_switch_style.dart"]
	n1["../klp_switch.dart"]
	n0 -->|"part of"| n1
```

## 依賴證據

| 關係 | 原始 directive | 來源 |
|---|---|---|
| part of | <code>part of &#x27;../klp_switch.dart&#x27;;</code> | [lib/src/features/forms/toggle/internal/klp_compact_switch_style.dart:1](../../../../../../../lib/src/features/forms/toggle/internal/klp_compact_switch_style.dart#L1) |

## 宣告關係圖

本組節點是本檔宣告；沒有箭頭的宣告未在此圖主張互相依賴。

```mermaid
classDiagram
	class n0["_KlpCompactSwitchStyle"]
```


## 宣告與成員證據

成員包含 public 與 private；簽章取自來源，省略函式本體與欄位初始值。`(inferred)` 表示來源未明寫型別；建構子只顯示參數部分，不含初始化列表。

### _KlpCompactSwitchStyle

ClassDeclaration · private · [lib/src/features/forms/toggle/internal/klp_compact_switch_style.dart:3](../../../../../../../lib/src/features/forms/toggle/internal/klp_compact_switch_style.dart#L3)

<code>class _KlpCompactSwitchStyle</code>


| 成員 | 可見性 | 簽章／型別 | 來源註解摘要 | 證據 |
|---|---|---|---|---|
| constructor <code>_</code> | private | <code>const _KlpCompactSwitchStyle._({ required this.trackWidth, required this.trackHeight, required this.thumb, required this.inset, required this.radius, required this.trackColor, required this.thumbColor, required this.alignment, required this.duration, required this.curve, })</code> |  | [lib/src/features/forms/toggle/internal/klp_compact_switch_style.dart:5](../../../../../../../lib/src/features/forms/toggle/internal/klp_compact_switch_style.dart#L5) |
| field <code>trackWidth</code> | public | <code>final double trackWidth</code> |  | [lib/src/features/forms/toggle/internal/klp_compact_switch_style.dart:18](../../../../../../../lib/src/features/forms/toggle/internal/klp_compact_switch_style.dart#L18) |
| field <code>trackHeight</code> | public | <code>final double trackHeight</code> |  | [lib/src/features/forms/toggle/internal/klp_compact_switch_style.dart:19](../../../../../../../lib/src/features/forms/toggle/internal/klp_compact_switch_style.dart#L19) |
| field <code>thumb</code> | public | <code>final double thumb</code> |  | [lib/src/features/forms/toggle/internal/klp_compact_switch_style.dart:20](../../../../../../../lib/src/features/forms/toggle/internal/klp_compact_switch_style.dart#L20) |
| field <code>inset</code> | public | <code>final double inset</code> |  | [lib/src/features/forms/toggle/internal/klp_compact_switch_style.dart:21](../../../../../../../lib/src/features/forms/toggle/internal/klp_compact_switch_style.dart#L21) |
| field <code>radius</code> | public | <code>final double radius</code> |  | [lib/src/features/forms/toggle/internal/klp_compact_switch_style.dart:22](../../../../../../../lib/src/features/forms/toggle/internal/klp_compact_switch_style.dart#L22) |
| field <code>trackColor</code> | public | <code>final Color trackColor</code> |  | [lib/src/features/forms/toggle/internal/klp_compact_switch_style.dart:23](../../../../../../../lib/src/features/forms/toggle/internal/klp_compact_switch_style.dart#L23) |
| field <code>thumbColor</code> | public | <code>final Color thumbColor</code> |  | [lib/src/features/forms/toggle/internal/klp_compact_switch_style.dart:24](../../../../../../../lib/src/features/forms/toggle/internal/klp_compact_switch_style.dart#L24) |
| field <code>alignment</code> | public | <code>final Alignment alignment</code> |  | [lib/src/features/forms/toggle/internal/klp_compact_switch_style.dart:25](../../../../../../../lib/src/features/forms/toggle/internal/klp_compact_switch_style.dart#L25) |
| field <code>duration</code> | public | <code>final Duration duration</code> |  | [lib/src/features/forms/toggle/internal/klp_compact_switch_style.dart:26](../../../../../../../lib/src/features/forms/toggle/internal/klp_compact_switch_style.dart#L26) |
| field <code>curve</code> | public | <code>final Curve curve</code> |  | [lib/src/features/forms/toggle/internal/klp_compact_switch_style.dart:27](../../../../../../../lib/src/features/forms/toggle/internal/klp_compact_switch_style.dart#L27) |
| constructor <code>resolve</code> | public | <code>factory _KlpCompactSwitchStyle.resolve(KlpTheme klp, {required bool value})</code> |  | [lib/src/features/forms/toggle/internal/klp_compact_switch_style.dart:29](../../../../../../../lib/src/features/forms/toggle/internal/klp_compact_switch_style.dart#L29) |

## 閱讀說明與限制

箭頭只表示來源明寫的靜態關係；import 不等於呼叫。未分析動態呼叫、欄位的實際物件擁有權、狀態轉移或渲染流程；型別未進行語意解析，繼承目標保留原始型別拼寫。public／private 依 Dart 名稱前綴判斷；public 宣告不代表已由 `lib/kallopis.dart` 匯出。

本頁由 `tool/architecture_atlas` 產生；編輯來源或生成工具後重新產生，避免手改本頁。
