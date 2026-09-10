## 分析入口

`interaction/` 包含按壓與長按、狀態高亮、roving index，以及拖放提示與篩選／選取工具列。KlpPressable 負責 hover、focus、selected 視覺與輸入處理，KlpRovingIndex 則提供不依賴 widget 的索引運算。此目錄無巢狀子目錄；filter bar 的組裝職責高於單純互動原語。

| 想查的問題 | 符號與來源 |
| --- | --- |
| 按壓和高亮入口？ | KlpPressable — `lib/src/foundation/interaction/klp_pressable.dart:8` |
| 長按門檻如何覆寫？ | KlpInteractionSettings.thresholdOf — `lib/src/foundation/interaction/klp_interaction_settings.dart:21` |
| 選項索引怎麼移動？ | KlpRovingIndex.move — `lib/src/foundation/interaction/klp_roving_index.dart:17` |
| 篩選與批次選取 UI？ | KlpFilterBar／KlpSelectionToolbar — `lib/src/foundation/interaction/klp_filter_bar.dart:29`、`lib/src/foundation/interaction/klp_filter_bar.dart:213` |

重要關係：

- `KlpPressable` → `context.klpLongPressThreshold`：didChangeDependencies 更新動畫控制器門檻（`lib/src/foundation/interaction/klp_pressable.dart:64`）；settings 優先使用區域覆寫，否則取 theme（`lib/src/foundation/interaction/klp_interaction_settings.dart:21`）。
- `KlpPressable.build` → `Listener`／`InkWell`：分別處理 pointer 與 tap／hover／focus，背景 wash 取自 theme（`lib/src/foundation/interaction/klp_pressable.dart:142`、`lib/src/foundation/interaction/klp_pressable.dart:152`）。
- `interaction ↔ controls` 為目錄層級雙向依賴：filter bar 引入 button，button 引入 pressable（`lib/src/foundation/interaction/klp_filter_bar.dart:3`、`lib/src/controls/klp_button.dart:6`）。

import 僅顯示靜態依賴；輸入事件的先後必須另看 callback 實作。
