## 分析入口

此目錄並非每個元件都負責開啟 overlay：`KlpPopover` 只是 surface 包裝，`KlpDialog` 是對話框內容。真正的 context menu 觸發、定位與 controller 掛載從 `KlpContextMenu` 閱讀。此目錄沒有巢狀子目錄。

| 想回答的問題 | 精確符號與來源 |
| --- | --- |
| 如何以控制器開啟或關閉 context menu？ | `KlpContextMenuController.openAt`、`close`：lib/src/features/overlays/klp_context_menu.dart:16、18 |
| 選單 host 與狀態在哪裡？ | `KlpContextMenu`、`_KlpContextMenuState`：lib/src/features/overlays/klp_context_menu.dart:41、64 |
| 哪些入口只提供視覺內容？ | `KlpPopover`：lib/src/features/overlays/klp_popover.dart:6；`KlpDialog`：lib/src/features/overlays/klp_dialog.dart:10 |

重要依賴：`KlpPopover.build` 在 `klp_popover.dart:13` 建構 `KlpSurface`。`klp_context_menu.dart:5` 匯入 menu 模組；:36–40 說明重用 `KlpMenu` 與 `KlpMenuLayout.resolvePosition`。`klp_dialog.dart:8` 明確將彈出方式留給呼叫端。
