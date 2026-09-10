# klp_live_region.dart：直接依賴與宣告架構

[回到目錄](README.md) · [來源檔案](../../../../../lib/src/features/feedback/klp_live_region.dart)

## 範圍

核心是 `lib/src/features/feedback/klp_live_region.dart`。主要視角為該檔案明寫的 import／export／part；輔助視角為本檔宣告及 extends／implements／with／on 關係。只展開一層外部邊界。

## 直接依賴圖

```mermaid
flowchart TD
	n0["klp_live_region.dart"]
	n1["package:flutter/widgets.dart"]
	n2["../../foundation/layout/klp_box.dart"]
	n3["primitives/klp_live_region_frame.dart"]
	n0 -->|"import"| n1
	n0 -->|"import"| n2
	n0 -->|"part"| n3
```

## 依賴證據

| 關係 | 原始 directive | 來源 |
|---|---|---|
| import | <code>import &#x27;package:flutter/widgets.dart&#x27;;</code> | [lib/src/features/feedback/klp_live_region.dart:1](../../../../../lib/src/features/feedback/klp_live_region.dart#L1) |
| import | <code>import &#x27;../../foundation/layout/klp_box.dart&#x27;;</code> | [lib/src/features/feedback/klp_live_region.dart:3](../../../../../lib/src/features/feedback/klp_live_region.dart#L3) |
| part | <code>part &#x27;primitives/klp_live_region_frame.dart&#x27;;</code> | [lib/src/features/feedback/klp_live_region.dart:5](../../../../../lib/src/features/feedback/klp_live_region.dart#L5) |

## 宣告關係圖

本組節點是本檔宣告；沒有箭頭的宣告未在此圖主張互相依賴。

```mermaid
classDiagram
	class n0["KlpLiveRegion"]
```

```mermaid
classDiagram
	class n0["KlpLiveRegion"]
	class n1["StatelessWidget"]
	n0 --|> n1 : extends
```


## 宣告與成員證據

成員包含 public 與 private；簽章取自來源，省略函式本體與欄位初始值。`(inferred)` 表示來源未明寫型別；建構子只顯示參數部分，不含初始化列表。

### KlpLiveRegion

ClassDeclaration · public · [lib/src/features/feedback/klp_live_region.dart:7](../../../../../lib/src/features/feedback/klp_live_region.dart#L7)

<code>class KlpLiveRegion extends StatelessWidget</code>

來源註解摘要：控制重複公告的可及性 live region。

- `extends` → <code>StatelessWidget</code>：[lib/src/features/feedback/klp_live_region.dart:8](../../../../../lib/src/features/feedback/klp_live_region.dart#L8)

| 成員 | 可見性 | 簽章／型別 | 來源註解摘要 | 證據 |
|---|---|---|---|---|
| constructor <code>KlpLiveRegion</code> | public | <code>const KlpLiveRegion({super.key, required this.message, this.child = const KlpBox.shrink()})</code> |  | [lib/src/features/feedback/klp_live_region.dart:9](../../../../../lib/src/features/feedback/klp_live_region.dart#L9) |
| constructor <code>fromDescendants</code> | public | <code>const KlpLiveRegion.fromDescendants({super.key, required this.child})</code> |  | [lib/src/features/feedback/klp_live_region.dart:11](../../../../../lib/src/features/feedback/klp_live_region.dart#L11) |
| field <code>message</code> | public | <code>final String? message</code> |  | [lib/src/features/feedback/klp_live_region.dart:13](../../../../../lib/src/features/feedback/klp_live_region.dart#L13) |
| field <code>child</code> | public | <code>final Widget child</code> |  | [lib/src/features/feedback/klp_live_region.dart:14](../../../../../lib/src/features/feedback/klp_live_region.dart#L14) |
| method <code>build</code> | public | <code>Widget build(BuildContext context)</code> |  | [lib/src/features/feedback/klp_live_region.dart:16](../../../../../lib/src/features/feedback/klp_live_region.dart#L16) |

## 閱讀說明與限制

箭頭只表示來源明寫的靜態關係；import 不等於呼叫。未分析動態呼叫、欄位的實際物件擁有權、狀態轉移或渲染流程；型別未進行語意解析，繼承目標保留原始型別拼寫。public／private 依 Dart 名稱前綴判斷；public 宣告不代表已由 `lib/kallopis.dart` 匯出。

本頁由 `tool/architecture_atlas` 產生；編輯來源或生成工具後重新產生，避免手改本頁。
