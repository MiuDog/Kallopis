## 分析入口

`controls/` 包含按鈕、文字輸入、選擇器、切換與 OKLCH 色彩編輯 UI；不同控件以各自的 value／callback 契約接收與回報資料。閱讀入口可先選 KlpButton、KlpTextField 或 KlpCombobox，再追蹤該控件的互動與樣式。`internal/` 目前放置按鈕樣式解析 KlpButtonStyle，與公開按鈕 widget 分檔。

| 想查的問題 | 符號與來源 |
| --- | --- |
| 按鈕外觀如何解析？ | KlpButtonStyle.resolve — `lib/src/foundation/interaction/controls/klp_button_style.dart:38` |
| 文字輸入的入口？ | KlpTextField — `lib/src/controls/klp_text_field.dart:12` |
| 可搜尋選項從哪查？ | KlpCombobox — `lib/src/controls/klp_combobox.dart:34` |
| 色彩平面與數值編輯如何分工？ | KlpOklchColorPicker — `lib/src/controls/klp_oklch_color_picker.dart:15`；KlpOklchColorEditor — `lib/src/controls/klp_oklch_color_editor.dart:11` |

重要關係：

- `KlpButton` → `KlpButtonStyle.resolve` → 主題 token：build 解析樣式，再建立 KlpPressable（`lib/src/controls/klp_button.dart:58`、`lib/src/controls/klp_button.dart:83`）。
- `klp_combobox.dart` → roving index、menu、text field：import 反映鍵盤索引、浮層與輸入元件的直接依賴（`lib/src/controls/klp_combobox.dart:4`）。
- 目錄層級有 `controls ↔ interaction` 雙向依賴：button 引入 pressable；filter bar 引入 button（`lib/src/controls/klp_button.dart:6`、`lib/src/foundation/interaction/klp_filter_bar.dart:3`）。這不是同一對檔案互相 import。

import 箭頭表示靜態依賴，不表示事件或執行先後。
