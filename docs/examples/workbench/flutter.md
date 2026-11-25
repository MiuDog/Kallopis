# Flutter Workbench

狀態：draft；截圖待審閱。

實作來源：[gui_scenarios.dart](../../../flutter/example/lib/gui_scenarios.dart)。在 `flutter/example/` 執行 `flutter run -d chrome`，開啟網址加上 `?scenario=vscode`；其他既有場景為 `blockbench`、`blender`。

## 接線

`KlpCommandShortcutHost` 包覆命令工具列與工作區。`KlpDockLayout` 接收受控 layout，內部面板組合 Explorer、Panel、Surface 與輸入元件；產品把操作回呼交給 `applyKlpDockAction`，再提交回傳的 layout。

產品擁有 registry、keymap、文字控制器與草稿，建立者負責 dispose。保存與還原由公開 `KlpDockLayoutCodec` 轉換布局；正文不併入布局 JSON。

## 規範與查表

- [共通組裝圖與 token 選用](README.md)
- 間距由 `context.klp.space.contentInset`、`contentStackGap`、`actionGap` 取得。
- [Flutter Reference](../../reference/flutter/README.md)
- [布局與命令操作流程](../../ai/product-usage.md)
