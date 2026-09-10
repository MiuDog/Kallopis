## 分析入口

此目錄包含一般 navigator、tabs、breadcrumb，以及 `explorer/`、`rail/`、`sidebar/` 三個獨立組件群。`KlpNavigator` 自己持有 widget state，不能僅憑名称視為 Flutter 或產品路由器。閱讀子目錄時保留 models、容器與 item 的分工，避免將所有導覽行為歸到單一 navigator。

| 想回答的問題 | 精確符號與來源 |
| --- | --- |
| 一般導覽的狀態入口在哪裡？ | `KlpNavigator`、`_KlpNavigatorState`：lib/src/features/navigation/widgets/klp_navigator.dart:16、49 |
| Explorer 與 Rail 各自從哪裡開始？ | `KlpExplorer`：lib/src/features/navigation/widgets/explorer/klp_explorer.dart:12；`KlpNavigationRail`：lib/src/features/navigation/widgets/rail/klp_navigation_rail.dart:13 |
| Sidebar 的版面外框在哪裡？ | `KlpSidebarFrame`：lib/src/features/navigation/widgets/sidebar/klp_sidebar_frame.dart:10 |

重要依賴：`klp_navigator.dart:10` 匯入自身 models，:5–6 匯入 pressable／state highlight，:7 匯入 surface。這些是靜態依賴，路由跳轉與事件先後需另外沿回呼驗證。
