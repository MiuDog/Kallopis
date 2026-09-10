## 分析入口

此目錄組成設定頁、導覽 pane、內容 pane、欄位與主題模式選擇的視覺介面。`internal/klp_settings_scope.dart` 持有 pane scope，與外部傳入 selectedIndex 的 scope switcher 是不同角色。資料持久化或設定服務不應由這些畫面名稱推論。

| 想回答的問題 | 精確符號與來源 |
| --- | --- |
| 設定頁布局的入口在哪裡？ | `KlpSettingsPage`：lib/src/features/workspace/settings/klp_settings_layout.dart:48 |
| 導覽與內容區域如何分開？ | `KlpSettingsNavigationPane`、`KlpSettingsContentPane`：lib/src/features/workspace/settings/klp_settings_layout.dart:139、186 |
| scope UI 與內部繼承元件在哪裡？ | `KlpSettingsScopeSwitcher`：lib/src/features/workspace/settings/klp_settings_navigation.dart:23；`KlpSettingsPaneScope`：lib/src/features/workspace/settings/internal/klp_settings_scope.dart:3 |

重要依賴：`klp_settings_navigation.dart:52` 將 press 回呼轉為 `onSelected(index)`；:40 建構 `KlpSurface`。`klp_settings_layout.dart:5` 匯入 layout 模組，這是靜態依賴，不能據此宣稱資料更新或保存流程。
