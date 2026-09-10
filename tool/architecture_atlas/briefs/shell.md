## 分析入口

此目錄提供工作台、window header、stage、panel 與狀態列的版面外殼；`KlpWorkbenchShell` 是主要組合入口。`docking/` 獨立持有 dock layout、models、header 與 panel；其 `internal/` 檔案是 layout 的 part。根層 `internal/` 另放 panel padding 與 header 支援，不能與 docking 內部單元混為一層。

| 想回答的問題 | 精確符號與來源 |
| --- | --- |
| 一般 shell 與 dock 模式從哪裡讀？ | `KlpWorkbenchShell`：lib/src/features/workspace/shell/klp_workbench_shell.dart:28 |
| Dock 的 state 與主要實作在哪裡？ | `KlpDockLayout`、`_KlpDockLayoutState`：lib/src/features/workspace/shell/docking/klp_dock_layout.dart:14、47 |
| 哪個 library 擁有 dock 的內部 part？ | part directives：lib/src/features/workspace/shell/docking/klp_dock_layout.dart:11、12 |

重要依賴：`klp_workbench_shell.dart:200` 實際建構 `KlpDockLayout`。同檔 :3–4 匯入 layout／theme；part 納入表示 library 所有權，不是執行時呼叫。此庫的 dock 能力不等於任何消費產品已啟用 split。
