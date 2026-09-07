# klp_visual_style_json_effects.dart：直接依賴與宣告架構

[回到目錄](README.md) · [來源檔案](../../../../../lib/src/theme/internal/klp_visual_style_json_effects.dart)

## 範圍

核心是 `lib/src/theme/internal/klp_visual_style_json_effects.dart`。主要視角為該檔案明寫的 import／export／part；輔助視角為本檔宣告及 extends／implements／with／on 關係。只展開一層外部邊界。

## 直接依賴圖

```mermaid
flowchart LR
	n0["klp_visual_style_json_effects.dart"]
	n1["../klp_motion_theme.dart"]
	n2["../klp_shape_theme.dart"]
	n3["klp_visual_style_json_helpers.dart"]
	n4["klp_visual_style_json_validation.dart"]
	n0 -->|"import"| n1
	n0 -->|"import"| n2
	n0 -->|"import"| n3
	n0 -->|"import"| n4
```

## 依賴證據

| 關係 | 原始 directive | 來源 |
|---|---|---|
| import | <code>import &#x27;../klp_motion_theme.dart&#x27;;</code> | [lib/src/theme/internal/klp_visual_style_json_effects.dart:1](../../../../../lib/src/theme/internal/klp_visual_style_json_effects.dart#L1) |
| import | <code>import &#x27;../klp_shape_theme.dart&#x27;;</code> | [lib/src/theme/internal/klp_visual_style_json_effects.dart:2](../../../../../lib/src/theme/internal/klp_visual_style_json_effects.dart#L2) |
| import | <code>import &#x27;klp_visual_style_json_helpers.dart&#x27;;</code> | [lib/src/theme/internal/klp_visual_style_json_effects.dart:3](../../../../../lib/src/theme/internal/klp_visual_style_json_effects.dart#L3) |
| import | <code>import &#x27;klp_visual_style_json_validation.dart&#x27;;</code> | [lib/src/theme/internal/klp_visual_style_json_effects.dart:4](../../../../../lib/src/theme/internal/klp_visual_style_json_effects.dart#L4) |

## 宣告關係圖

本檔沒有 class／enum／mixin／extension 宣告；頂層函式、變數與 typedef 見下表。

## 宣告與成員證據

成員包含 public 與 private；簽章取自來源，省略函式本體與欄位初始值。`(inferred)` 表示來源未明寫型別；建構子只顯示參數部分，不含初始化列表。

### _shapeKeys

top-level variable · private · [lib/src/theme/internal/klp_visual_style_json_effects.dart:6](../../../../../lib/src/theme/internal/klp_visual_style_json_effects.dart#L6)

<code>const (inferred) _shapeKeys</code>


### _motionKeys

top-level variable · private · [lib/src/theme/internal/klp_visual_style_json_effects.dart:21](../../../../../lib/src/theme/internal/klp_visual_style_json_effects.dart#L21)

<code>const (inferred) _motionKeys</code>


### decodeShape

FunctionDeclaration · public · [lib/src/theme/internal/klp_visual_style_json_effects.dart:36](../../../../../lib/src/theme/internal/klp_visual_style_json_effects.dart#L36)

<code>KlpShapeTheme decodeShape(KlpJsonMap json, KlpShapeTheme base)</code>


### encodeShape

FunctionDeclaration · public · [lib/src/theme/internal/klp_visual_style_json_effects.dart:58](../../../../../lib/src/theme/internal/klp_visual_style_json_effects.dart#L58)

<code>KlpJsonMap encodeShape(KlpShapeTheme v)</code>


### decodeMotion

FunctionDeclaration · public · [lib/src/theme/internal/klp_visual_style_json_effects.dart:74](../../../../../lib/src/theme/internal/klp_visual_style_json_effects.dart#L74)

<code>KlpMotionTheme decodeMotion(KlpJsonMap json, KlpMotionTheme base)</code>


### encodeMotion

FunctionDeclaration · public · [lib/src/theme/internal/klp_visual_style_json_effects.dart:113](../../../../../lib/src/theme/internal/klp_visual_style_json_effects.dart#L113)

<code>KlpJsonMap encodeMotion(KlpMotionTheme v)</code>


## 閱讀說明與限制

箭頭只表示來源明寫的靜態關係；import 不等於呼叫。未分析動態呼叫、欄位的實際物件擁有權、狀態轉移或渲染流程；型別未進行語意解析，繼承目標保留原始型別拼寫。public／private 依 Dart 名稱前綴判斷；public 宣告不代表已由 `lib/kallopis.dart` 匯出。

本頁由 `tool/architecture_atlas` 產生；編輯來源或生成工具後重新產生，避免手改本頁。
