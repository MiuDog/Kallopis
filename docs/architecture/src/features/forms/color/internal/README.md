# lib/src/features/forms/color/internal：架構分析入口

[上一層](../README.md)

## 範圍

閱讀 `lib/src/features/forms/color/internal` 的直接子目錄與 Dart 檔案。結構圖表示實際檔案包含關係；依賴圖表示本層檔案明寫的 directives。每個檔案頁另列直接依賴、宣告、欄位、方法、建構子及行號證據。

## 本層直接依賴圖

箭頭以本層 Dart 檔案明寫的 directive 彙總到目標所在目錄或外部套件邊界；不遞迴將子目錄依賴算入本層。相同目標的不同 directive 類型分開計數。

```mermaid
flowchart TD
	n0["lib/src/features/forms/color/internal"]
	n1["lib/src/features/forms/color"]
	n0 -->|"part of"| n1
```

| 目標邊界 | 關係 | directive 數 | 第一筆來源證據 |
|---|---|---|---|
| <code>lib/src/features/forms/color</code> | part of | 11 | [lib/src/features/forms/color/internal/klp_oklch_color_editor_style.dart:1](../../../../../../../lib/src/features/forms/color/internal/klp_oklch_color_editor_style.dart#L1) |

## 目錄結構圖

```mermaid
flowchart LR
	n0["lib/src/features/forms/color/internal"]
	n1["klp_oklch_color_editor_style.dart"]
	n2["klp_oklch_color_editor_widget.dart"]
	n3["klp_oklch_color_picker_content.dart"]
	n4["klp_oklch_color_picker_style.dart"]
	n5["klp_oklch_color_picker_widget.dart"]
	n6["klp_oklch_plane.dart"]
	n7["klp_oklch_plane_kind.dart"]
	n8["klp_oklch_plane_section.dart"]
	n9["klp_oklch_plane_state.dart"]
	n10["klp_oklch_plane_style.dart"]
	n11["klp_oklch_preview.dart"]
	n0 -->|"contains"| n1
	n0 -->|"contains"| n2
	n0 -->|"contains"| n3
	n0 -->|"contains"| n4
	n0 -->|"contains"| n5
	n0 -->|"contains"| n6
	n0 -->|"contains"| n7
	n0 -->|"contains"| n8
	n0 -->|"contains"| n9
	n0 -->|"contains"| n10
	n0 -->|"contains"| n11
```

## 子目錄

| 目錄 | 導航 | 來源證據 |
|---|---|---|
| 無 | 目前沒有下一層目錄 | — |

## 本層檔案

| 檔案 | 宣告 | 細節 | 來源證據 |
|---|---|---|---|
| `klp_oklch_color_editor_style.dart` | _KlpOklchColorEditorStyle | [架構與 API](klp_oklch_color_editor_style.md) | [lib/src/features/forms/color/internal/klp_oklch_color_editor_style.dart:1](../../../../../../../lib/src/features/forms/color/internal/klp_oklch_color_editor_style.dart#L1) |
| `klp_oklch_color_editor_widget.dart` | KlpOklchColorEditor | [架構與 API](klp_oklch_color_editor_widget.md) | [lib/src/features/forms/color/internal/klp_oklch_color_editor_widget.dart:1](../../../../../../../lib/src/features/forms/color/internal/klp_oklch_color_editor_widget.dart#L1) |
| `klp_oklch_color_picker_content.dart` | _KlpOklchColorPickerContent | [架構與 API](klp_oklch_color_picker_content.md) | [lib/src/features/forms/color/internal/klp_oklch_color_picker_content.dart:1](../../../../../../../lib/src/features/forms/color/internal/klp_oklch_color_picker_content.dart#L1) |
| `klp_oklch_color_picker_style.dart` | _KlpOklchColorPickerStyle | [架構與 API](klp_oklch_color_picker_style.md) | [lib/src/features/forms/color/internal/klp_oklch_color_picker_style.dart:1](../../../../../../../lib/src/features/forms/color/internal/klp_oklch_color_picker_style.dart#L1) |
| `klp_oklch_color_picker_widget.dart` | KlpOklchColorPicker | [架構與 API](klp_oklch_color_picker_widget.md) | [lib/src/features/forms/color/internal/klp_oklch_color_picker_widget.dart:1](../../../../../../../lib/src/features/forms/color/internal/klp_oklch_color_picker_widget.dart#L1) |
| `klp_oklch_plane.dart` | _OklchPlane | [架構與 API](klp_oklch_plane.md) | [lib/src/features/forms/color/internal/klp_oklch_plane.dart:1](../../../../../../../lib/src/features/forms/color/internal/klp_oklch_plane.dart#L1) |
| `klp_oklch_plane_kind.dart` | _OklchPlaneKind | [架構與 API](klp_oklch_plane_kind.md) | [lib/src/features/forms/color/internal/klp_oklch_plane_kind.dart:1](../../../../../../../lib/src/features/forms/color/internal/klp_oklch_plane_kind.dart#L1) |
| `klp_oklch_plane_section.dart` | _KlpOklchPlaneSection | [架構與 API](klp_oklch_plane_section.md) | [lib/src/features/forms/color/internal/klp_oklch_plane_section.dart:1](../../../../../../../lib/src/features/forms/color/internal/klp_oklch_plane_section.dart#L1) |
| `klp_oklch_plane_state.dart` | _OklchPlaneState | [架構與 API](klp_oklch_plane_state.md) | [lib/src/features/forms/color/internal/klp_oklch_plane_state.dart:1](../../../../../../../lib/src/features/forms/color/internal/klp_oklch_plane_state.dart#L1) |
| `klp_oklch_plane_style.dart` | _KlpOklchPlaneStyle | [架構與 API](klp_oklch_plane_style.md) | [lib/src/features/forms/color/internal/klp_oklch_plane_style.dart:1](../../../../../../../lib/src/features/forms/color/internal/klp_oklch_plane_style.dart#L1) |
| `klp_oklch_preview.dart` | _KlpOklchPreview | [架構與 API](klp_oklch_preview.md) | [lib/src/features/forms/color/internal/klp_oklch_preview.dart:1](../../../../../../../lib/src/features/forms/color/internal/klp_oklch_preview.dart#L1) |

## 閱讀說明

箭頭只表示來源明寫的靜態關係；import 不等於呼叫。未分析動態呼叫、欄位的實際物件擁有權、狀態轉移或渲染流程；型別未進行語意解析，繼承目標保留原始型別拼寫。public／private 依 Dart 名稱前綴判斷；public 宣告不代表已由 `lib/kallopis.dart` 匯出。

本頁的目錄與檔案由來源清冊產生；`manifest.json` 位於本圖集根目錄，可核對 SHA-256 與覆蓋數。人工模組摘要存於 `tool/architecture_atlas/briefs/`，重新生成時保留。
