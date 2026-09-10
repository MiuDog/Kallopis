# klp_modal_frame.dart：直接依賴與宣告架構

[回到目錄](README.md) · [來源檔案](../../../../../../lib/src/features/overlays/primitives/klp_modal_frame.dart)

## 範圍

核心是 `lib/src/features/overlays/primitives/klp_modal_frame.dart`。主要視角為該檔案明寫的 import／export／part；輔助視角為本檔宣告及 extends／implements／with／on 關係。只展開一層外部邊界。

## 直接依賴圖

```mermaid
flowchart TD
	n0["klp_modal_frame.dart"]
	n1["package:flutter/material.dart"]
	n2["../../../foundation/layout/klp_box_insets.dart"]
	n3["../../../styling/legacy_theme/klp_theme.dart"]
	n0 -->|"import"| n1
	n0 -->|"import"| n2
	n0 -->|"import"| n3
```

## 依賴證據

| 關係 | 原始 directive | 來源 |
|---|---|---|
| import | <code>import &#x27;package:flutter/material.dart&#x27;;</code> | [lib/src/features/overlays/primitives/klp_modal_frame.dart:1](../../../../../../lib/src/features/overlays/primitives/klp_modal_frame.dart#L1) |
| import | <code>import &#x27;../../../foundation/layout/klp_box_insets.dart&#x27;;</code> | [lib/src/features/overlays/primitives/klp_modal_frame.dart:3](../../../../../../lib/src/features/overlays/primitives/klp_modal_frame.dart#L3) |
| import | <code>import &#x27;../../../styling/legacy_theme/klp_theme.dart&#x27;;</code> | [lib/src/features/overlays/primitives/klp_modal_frame.dart:4](../../../../../../lib/src/features/overlays/primitives/klp_modal_frame.dart#L4) |

## 宣告關係圖

本組節點是本檔宣告；沒有箭頭的宣告未在此圖主張互相依賴。

```mermaid
classDiagram
	class n0["KlpModalFrame"]
```

```mermaid
classDiagram
	class n0["KlpModalFrame"]
	class n1["StatelessWidget"]
	n0 --|> n1 : extends
```


## 宣告與成員證據

成員包含 public 與 private；簽章取自來源，省略函式本體與欄位初始值。`(inferred)` 表示來源未明寫型別；建構子只顯示參數部分，不含初始化列表。

### KlpModalFrame

ClassDeclaration · public · [lib/src/features/overlays/primitives/klp_modal_frame.dart:6](../../../../../../lib/src/features/overlays/primitives/klp_modal_frame.dart#L6)

<code>class KlpModalFrame extends StatelessWidget</code>

來源註解摘要：透明 modal chrome 的基礎呈現原語；內容尺寸與產品語意由呼叫端提供。

- `extends` → <code>StatelessWidget</code>：[lib/src/features/overlays/primitives/klp_modal_frame.dart:7](../../../../../../lib/src/features/overlays/primitives/klp_modal_frame.dart#L7)

| 成員 | 可見性 | 簽章／型別 | 來源註解摘要 | 證據 |
|---|---|---|---|---|
| constructor <code>KlpModalFrame</code> | public | <code>const KlpModalFrame({super.key, required this.insets, required this.child})</code> |  | [lib/src/features/overlays/primitives/klp_modal_frame.dart:8](../../../../../../lib/src/features/overlays/primitives/klp_modal_frame.dart#L8) |
| field <code>insets</code> | public | <code>final KlpBoxInsets insets</code> |  | [lib/src/features/overlays/primitives/klp_modal_frame.dart:10](../../../../../../lib/src/features/overlays/primitives/klp_modal_frame.dart#L10) |
| field <code>child</code> | public | <code>final Widget child</code> |  | [lib/src/features/overlays/primitives/klp_modal_frame.dart:11](../../../../../../lib/src/features/overlays/primitives/klp_modal_frame.dart#L11) |
| method <code>build</code> | public | <code>Widget build(BuildContext context)</code> |  | [lib/src/features/overlays/primitives/klp_modal_frame.dart:13](../../../../../../lib/src/features/overlays/primitives/klp_modal_frame.dart#L13) |

## 閱讀說明與限制

箭頭只表示來源明寫的靜態關係；import 不等於呼叫。未分析動態呼叫、欄位的實際物件擁有權、狀態轉移或渲染流程；型別未進行語意解析，繼承目標保留原始型別拼寫。public／private 依 Dart 名稱前綴判斷；public 宣告不代表已由 `lib/kallopis.dart` 匯出。

本頁由 `tool/architecture_atlas` 產生；編輯來源或生成工具後重新產生，避免手改本頁。
