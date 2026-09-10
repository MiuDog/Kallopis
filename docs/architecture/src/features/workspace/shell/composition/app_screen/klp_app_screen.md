# klp_app_screen.dart：直接依賴與宣告架構

[回到目錄](README.md) · [來源檔案](../../../../../../../../lib/src/features/workspace/shell/composition/app_screen/klp_app_screen.dart)

## 範圍

核心是 `lib/src/features/workspace/shell/composition/app_screen/klp_app_screen.dart`。主要視角為該檔案明寫的 import／export／part；輔助視角為本檔宣告及 extends／implements／with／on 關係。只展開一層外部邊界。

## 直接依賴圖

```mermaid
flowchart LR
	n0["klp_app_screen.dart"]
	n1["package:flutter/material.dart"]
	n2["../../../../../foundation/layout/klp_column.dart"]
	n3["../../../../../foundation/layout/klp_expanded.dart"]
	n4["../../../../../foundation/surface/klp_surface.dart"]
	n5["primitives/klp_app_screen_material_root.dart"]
	n0 -->|"import"| n1
	n0 -->|"import"| n2
	n0 -->|"import"| n3
	n0 -->|"import"| n4
	n0 -->|"part"| n5
```

## 依賴證據

| 關係 | 原始 directive | 來源 |
|---|---|---|
| import | <code>import &#x27;package:flutter/material.dart&#x27;;</code> | [lib/src/features/workspace/shell/composition/app_screen/klp_app_screen.dart:1](../../../../../../../../lib/src/features/workspace/shell/composition/app_screen/klp_app_screen.dart#L1) |
| import | <code>import &#x27;../../../../../foundation/layout/klp_column.dart&#x27;;</code> | [lib/src/features/workspace/shell/composition/app_screen/klp_app_screen.dart:3](../../../../../../../../lib/src/features/workspace/shell/composition/app_screen/klp_app_screen.dart#L3) |
| import | <code>import &#x27;../../../../../foundation/layout/klp_expanded.dart&#x27;;</code> | [lib/src/features/workspace/shell/composition/app_screen/klp_app_screen.dart:4](../../../../../../../../lib/src/features/workspace/shell/composition/app_screen/klp_app_screen.dart#L4) |
| import | <code>import &#x27;../../../../../foundation/surface/klp_surface.dart&#x27;;</code> | [lib/src/features/workspace/shell/composition/app_screen/klp_app_screen.dart:5](../../../../../../../../lib/src/features/workspace/shell/composition/app_screen/klp_app_screen.dart#L5) |
| part | <code>part &#x27;primitives/klp_app_screen_material_root.dart&#x27;;</code> | [lib/src/features/workspace/shell/composition/app_screen/klp_app_screen.dart:7](../../../../../../../../lib/src/features/workspace/shell/composition/app_screen/klp_app_screen.dart#L7) |

## 宣告關係圖

本組節點是本檔宣告；沒有箭頭的宣告未在此圖主張互相依賴。

```mermaid
classDiagram
	class n0["KlpAppScreen"]
```

```mermaid
classDiagram
	class n0["KlpAppScreen"]
	class n1["StatelessWidget"]
	n0 --|> n1 : extends
```


## 宣告與成員證據

成員包含 public 與 private；簽章取自來源，省略函式本體與欄位初始值。`(inferred)` 表示來源未明寫型別；建構子只顯示參數部分，不含初始化列表。

### KlpAppScreen

ClassDeclaration · public · [lib/src/features/workspace/shell/composition/app_screen/klp_app_screen.dart:9](../../../../../../../../lib/src/features/workspace/shell/composition/app_screen/klp_app_screen.dart#L9)

<code>class KlpAppScreen extends StatelessWidget</code>

來源註解摘要：應用程式最外層，提供 Material 祖先與 app 背景。

- `extends` → <code>StatelessWidget</code>：[lib/src/features/workspace/shell/composition/app_screen/klp_app_screen.dart:10](../../../../../../../../lib/src/features/workspace/shell/composition/app_screen/klp_app_screen.dart#L10)

| 成員 | 可見性 | 簽章／型別 | 來源註解摘要 | 證據 |
|---|---|---|---|---|
| constructor <code>KlpAppScreen</code> | public | <code>const KlpAppScreen({super.key, required this.child, this.windowHeader})</code> |  | [lib/src/features/workspace/shell/composition/app_screen/klp_app_screen.dart:11](../../../../../../../../lib/src/features/workspace/shell/composition/app_screen/klp_app_screen.dart#L11) |
| field <code>windowHeader</code> | public | <code>final Widget? windowHeader</code> |  | [lib/src/features/workspace/shell/composition/app_screen/klp_app_screen.dart:13](../../../../../../../../lib/src/features/workspace/shell/composition/app_screen/klp_app_screen.dart#L13) |
| field <code>child</code> | public | <code>final Widget child</code> |  | [lib/src/features/workspace/shell/composition/app_screen/klp_app_screen.dart:14](../../../../../../../../lib/src/features/workspace/shell/composition/app_screen/klp_app_screen.dart#L14) |
| method <code>build</code> | public | <code>Widget build(BuildContext context)</code> |  | [lib/src/features/workspace/shell/composition/app_screen/klp_app_screen.dart:16](../../../../../../../../lib/src/features/workspace/shell/composition/app_screen/klp_app_screen.dart#L16) |

## 閱讀說明與限制

箭頭只表示來源明寫的靜態關係；import 不等於呼叫。未分析動態呼叫、欄位的實際物件擁有權、狀態轉移或渲染流程；型別未進行語意解析，繼承目標保留原始型別拼寫。public／private 依 Dart 名稱前綴判斷；public 宣告不代表已由 `lib/kallopis.dart` 匯出。

本頁由 `tool/architecture_atlas` 產生；編輯來源或生成工具後重新產生，避免手改本頁。
