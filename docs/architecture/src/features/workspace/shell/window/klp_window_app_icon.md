# klp_window_app_icon.dart：直接依賴與宣告架構

[回到目錄](README.md) · [來源檔案](../../../../../../../lib/src/features/workspace/shell/window/klp_window_app_icon.dart)

## 範圍

核心是 `lib/src/features/workspace/shell/window/klp_window_app_icon.dart`。主要視角為該檔案明寫的 import／export／part；輔助視角為本檔宣告及 extends／implements／with／on 關係。只展開一層外部邊界。

## 直接依賴圖

```mermaid
flowchart LR
	n0["klp_window_app_icon.dart"]
	n1["package:flutter/material.dart"]
	n2["../../../../foundation/layout/klp_box.dart"]
	n3["../../../../foundation/layout/klp_center.dart"]
	n4["../../../../foundation/layout/klp_fit.dart"]
	n5["../../../../foundation/layout/klp_fit_mode.dart"]
	n0 -->|"import"| n1
	n0 -->|"import"| n2
	n0 -->|"import"| n3
	n0 -->|"import"| n4
	n0 -->|"import"| n5
```

## 依賴證據

| 關係 | 原始 directive | 來源 |
|---|---|---|
| import | <code>import &#x27;package:flutter/material.dart&#x27;;</code> | [lib/src/features/workspace/shell/window/klp_window_app_icon.dart:4](../../../../../../../lib/src/features/workspace/shell/window/klp_window_app_icon.dart#L4) |
| import | <code>import &#x27;../../../../foundation/layout/klp_box.dart&#x27;;</code> | [lib/src/features/workspace/shell/window/klp_window_app_icon.dart:6](../../../../../../../lib/src/features/workspace/shell/window/klp_window_app_icon.dart#L6) |
| import | <code>import &#x27;../../../../foundation/layout/klp_center.dart&#x27;;</code> | [lib/src/features/workspace/shell/window/klp_window_app_icon.dart:7](../../../../../../../lib/src/features/workspace/shell/window/klp_window_app_icon.dart#L7) |
| import | <code>import &#x27;../../../../foundation/layout/klp_fit.dart&#x27;;</code> | [lib/src/features/workspace/shell/window/klp_window_app_icon.dart:8](../../../../../../../lib/src/features/workspace/shell/window/klp_window_app_icon.dart#L8) |
| import | <code>import &#x27;../../../../foundation/layout/klp_fit_mode.dart&#x27;;</code> | [lib/src/features/workspace/shell/window/klp_window_app_icon.dart:9](../../../../../../../lib/src/features/workspace/shell/window/klp_window_app_icon.dart#L9) |

## 宣告關係圖

本組節點是本檔宣告；沒有箭頭的宣告未在此圖主張互相依賴。

```mermaid
classDiagram
	class n0["KlpWindowAppIcon"]
```

```mermaid
classDiagram
	class n0["KlpWindowAppIcon"]
	class n1["StatelessWidget"]
	n0 --|> n1 : extends
```


## 宣告與成員證據

成員包含 public 與 private；簽章取自來源，省略函式本體與欄位初始值。`(inferred)` 表示來源未明寫型別；建構子只顯示參數部分，不含初始化列表。

### KlpWindowAppIcon

ClassDeclaration · public · [lib/src/features/workspace/shell/window/klp_window_app_icon.dart:11](../../../../../../../lib/src/features/workspace/shell/window/klp_window_app_icon.dart#L11)

<code>class KlpWindowAppIcon extends StatelessWidget</code>

來源註解摘要：以視窗按鈕尺寸包裝消費端圖示，圖形本身維持 App icon 語意尺寸。

- `extends` → <code>StatelessWidget</code>：[lib/src/features/workspace/shell/window/klp_window_app_icon.dart:12](../../../../../../../lib/src/features/workspace/shell/window/klp_window_app_icon.dart#L12)

| 成員 | 可見性 | 簽章／型別 | 來源註解摘要 | 證據 |
|---|---|---|---|---|
| constructor <code>KlpWindowAppIcon</code> | public | <code>const KlpWindowAppIcon({ super.key, required this.controlExtent, required this.iconExtent, required this.child, })</code> |  | [lib/src/features/workspace/shell/window/klp_window_app_icon.dart:13](../../../../../../../lib/src/features/workspace/shell/window/klp_window_app_icon.dart#L13) |
| field <code>controlExtent</code> | public | <code>final double controlExtent</code> |  | [lib/src/features/workspace/shell/window/klp_window_app_icon.dart:20](../../../../../../../lib/src/features/workspace/shell/window/klp_window_app_icon.dart#L20) |
| field <code>iconExtent</code> | public | <code>final double iconExtent</code> |  | [lib/src/features/workspace/shell/window/klp_window_app_icon.dart:21](../../../../../../../lib/src/features/workspace/shell/window/klp_window_app_icon.dart#L21) |
| field <code>child</code> | public | <code>final Widget child</code> |  | [lib/src/features/workspace/shell/window/klp_window_app_icon.dart:22](../../../../../../../lib/src/features/workspace/shell/window/klp_window_app_icon.dart#L22) |
| method <code>build</code> | public | <code>Widget build(BuildContext context)</code> |  | [lib/src/features/workspace/shell/window/klp_window_app_icon.dart:24](../../../../../../../lib/src/features/workspace/shell/window/klp_window_app_icon.dart#L24) |

## 閱讀說明與限制

箭頭只表示來源明寫的靜態關係；import 不等於呼叫。未分析動態呼叫、欄位的實際物件擁有權、狀態轉移或渲染流程；型別未進行語意解析，繼承目標保留原始型別拼寫。public／private 依 Dart 名稱前綴判斷；public 宣告不代表已由 `lib/kallopis.dart` 匯出。

本頁由 `tool/architecture_atlas` 產生；編輯來源或生成工具後重新產生，避免手改本頁。
