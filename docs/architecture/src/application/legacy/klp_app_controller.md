# klp_app_controller.dart：直接依賴與宣告架構

[回到目錄](README.md) · [來源檔案](../../../../../lib/src/application/legacy/klp_app_controller.dart)

## 範圍

核心是 `lib/src/application/legacy/klp_app_controller.dart`。主要視角為該檔案明寫的 import／export／part；輔助視角為本檔宣告及 extends／implements／with／on 關係。只展開一層外部邊界。

## 直接依賴圖

```mermaid
flowchart TD
	n0["klp_app_controller.dart"]
	n1["package:flutter/material.dart"]
	n2["../../foundation/interaction/keybinding/klp_key_binding_controller.dart"]
	n0 -->|"import"| n1
	n0 -->|"import"| n2
```

## 依賴證據

| 關係 | 原始 directive | 來源 |
|---|---|---|
| import | <code>import &#x27;package:flutter/material.dart&#x27;;</code> | [lib/src/application/legacy/klp_app_controller.dart:1](../../../../../lib/src/application/legacy/klp_app_controller.dart#L1) |
| import | <code>import &#x27;../../foundation/interaction/keybinding/klp_key_binding_controller.dart&#x27;;</code> | [lib/src/application/legacy/klp_app_controller.dart:3](../../../../../lib/src/application/legacy/klp_app_controller.dart#L3) |

## 宣告關係圖

本組節點是本檔宣告；沒有箭頭的宣告未在此圖主張互相依賴。

```mermaid
classDiagram
	class n0["KlpAppController"]
```


## 宣告與成員證據

成員包含 public 與 private；簽章取自來源，省略函式本體與欄位初始值。`(inferred)` 表示來源未明寫型別；建構子只顯示參數部分，不含初始化列表。

### KlpAppController

ClassDeclaration · public · [lib/src/application/legacy/klp_app_controller.dart:5](../../../../../lib/src/application/legacy/klp_app_controller.dart#L5)

<code>abstract class KlpAppController</code>

來源註解摘要：Kallopis 應用程式對外提供的控制介面。


| 成員 | 可見性 | 簽章／型別 | 來源註解摘要 | 證據 |
|---|---|---|---|---|
| getter <code>brightness</code> | public | <code>Brightness get brightness</code> |  | [lib/src/application/legacy/klp_app_controller.dart:7](../../../../../lib/src/application/legacy/klp_app_controller.dart#L7) |
| getter <code>themeMode</code> | public | <code>ThemeMode get themeMode</code> |  | [lib/src/application/legacy/klp_app_controller.dart:8](../../../../../lib/src/application/legacy/klp_app_controller.dart#L8) |
| method <code>toggleBrightness</code> | public | <code>void toggleBrightness()</code> |  | [lib/src/application/legacy/klp_app_controller.dart:9](../../../../../lib/src/application/legacy/klp_app_controller.dart#L9) |
| method <code>setThemeMode</code> | public | <code>void setThemeMode(ThemeMode mode)</code> |  | [lib/src/application/legacy/klp_app_controller.dart:10](../../../../../lib/src/application/legacy/klp_app_controller.dart#L10) |
| getter <code>keyBindings</code> | public | <code>KlpKeyBindingController get keyBindings</code> |  | [lib/src/application/legacy/klp_app_controller.dart:11](../../../../../lib/src/application/legacy/klp_app_controller.dart#L11) |

## 閱讀說明與限制

箭頭只表示來源明寫的靜態關係；import 不等於呼叫。未分析動態呼叫、欄位的實際物件擁有權、狀態轉移或渲染流程；型別未進行語意解析，繼承目標保留原始型別拼寫。public／private 依 Dart 名稱前綴判斷；public 宣告不代表已由 `lib/kallopis.dart` 匯出。

本頁由 `tool/architecture_atlas` 產生；編輯來源或生成工具後重新產生，避免手改本頁。
