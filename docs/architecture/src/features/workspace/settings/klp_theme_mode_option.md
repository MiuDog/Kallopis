# klp_theme_mode_option.dart：直接依賴與宣告架構

[回到目錄](README.md) · [來源檔案](../../../../../../lib/src/features/workspace/settings/klp_theme_mode_option.dart)

## 範圍

核心是 `lib/src/features/workspace/settings/klp_theme_mode_option.dart`。主要視角為該檔案明寫的 import／export／part；輔助視角為本檔宣告及 extends／implements／with／on 關係。只展開一層外部邊界。

## 直接依賴圖

```mermaid
flowchart TD
	n0["klp_theme_mode_option.dart"]
	n1["package:flutter/foundation.dart"]
	n2["../shell/theme/klp_theme_preview_tile.dart"]
	n0 -->|"import"| n1
	n0 -->|"import"| n2
```

## 依賴證據

| 關係 | 原始 directive | 來源 |
|---|---|---|
| import | <code>import &#x27;package:flutter/foundation.dart&#x27;;</code> | [lib/src/features/workspace/settings/klp_theme_mode_option.dart:1](../../../../../../lib/src/features/workspace/settings/klp_theme_mode_option.dart#L1) |
| import | <code>import &#x27;../shell/theme/klp_theme_preview_tile.dart&#x27;;</code> | [lib/src/features/workspace/settings/klp_theme_mode_option.dart:3](../../../../../../lib/src/features/workspace/settings/klp_theme_mode_option.dart#L3) |

## 宣告關係圖

本組節點是本檔宣告；沒有箭頭的宣告未在此圖主張互相依賴。

```mermaid
classDiagram
	class n0["KlpThemeModeOption"]
```


## 宣告與成員證據

成員包含 public 與 private；簽章取自來源，省略函式本體與欄位初始值。`(inferred)` 表示來源未明寫型別；建構子只顯示參數部分，不含初始化列表。

### KlpThemeModeOption

ClassDeclaration · public · [lib/src/features/workspace/settings/klp_theme_mode_option.dart:5](../../../../../../lib/src/features/workspace/settings/klp_theme_mode_option.dart#L5)

<code>class KlpThemeModeOption</code>

來源註解摘要：顏色模式預覽的文案與可用狀態。


| 成員 | 可見性 | 簽章／型別 | 來源註解摘要 | 證據 |
|---|---|---|---|---|
| constructor <code>KlpThemeModeOption</code> | public | <code>const KlpThemeModeOption({ required this.mode, required this.label, required this.description, this.enabled = true, })</code> |  | [lib/src/features/workspace/settings/klp_theme_mode_option.dart:8](../../../../../../lib/src/features/workspace/settings/klp_theme_mode_option.dart#L8) |
| field <code>mode</code> | public | <code>final KlpThemePreviewMode mode</code> |  | [lib/src/features/workspace/settings/klp_theme_mode_option.dart:15](../../../../../../lib/src/features/workspace/settings/klp_theme_mode_option.dart#L15) |
| field <code>label</code> | public | <code>final String label</code> |  | [lib/src/features/workspace/settings/klp_theme_mode_option.dart:16](../../../../../../lib/src/features/workspace/settings/klp_theme_mode_option.dart#L16) |
| field <code>description</code> | public | <code>final String description</code> |  | [lib/src/features/workspace/settings/klp_theme_mode_option.dart:17](../../../../../../lib/src/features/workspace/settings/klp_theme_mode_option.dart#L17) |
| field <code>enabled</code> | public | <code>final bool enabled</code> |  | [lib/src/features/workspace/settings/klp_theme_mode_option.dart:18](../../../../../../lib/src/features/workspace/settings/klp_theme_mode_option.dart#L18) |

## 閱讀說明與限制

箭頭只表示來源明寫的靜態關係；import 不等於呼叫。未分析動態呼叫、欄位的實際物件擁有權、狀態轉移或渲染流程；型別未進行語意解析，繼承目標保留原始型別拼寫。public／private 依 Dart 名稱前綴判斷；public 宣告不代表已由 `lib/kallopis.dart` 匯出。

本頁由 `tool/architecture_atlas` 產生；編輯來源或生成工具後重新產生，避免手改本頁。
