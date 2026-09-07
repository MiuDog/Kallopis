## 分析入口

此目錄目前只有 `IstWorkbenchScreen`，將應用程式畫面、分組 Rail 與 Dock shell 組裝成工作台。呼叫端提供 window header、stage、panel 清單、layout 與 layout 更新回呼；此入口的組合不等同 Notist 的產品路由規格。此目錄沒有巢狀子目錄。

| 想回答的問題 | 精確符號與來源 |
| --- | --- |
| 工作台的組合入口在哪裡？ | `IstWorkbenchScreen`：lib/src/ist/ist_workbench_screen.dart:16 |
| 受控布局與事件由誰提供？ | `layout`、`onLayoutChanged`：lib/src/ist/ist_workbench_screen.dart:24、25 |
| 實際建構哪些外部區域？ | `IstWorkbenchScreen.build`：lib/src/ist/ist_workbench_screen.dart:46 |

重要依賴：同檔 build 實際建構 `KlpAppScreen`、`KlpNavigationRail.grouped`、`KlpWorkbenchShell.dock`；證據從 :49 起。dock 型別的靜態來源是 :5–6，Rail 的匯入在 :2–3；不要將 import 順序畫成執行時序。
