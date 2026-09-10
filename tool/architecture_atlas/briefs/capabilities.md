## 分析入口

目前提供純資料 state、借用 controller 與非同步資料擁有者。`state/klp_mutable_state.dart` 由擁有端寫入，`readOnly` 回傳私有 facade；`state/klp_state.dart` 是借用介面，訂閱取消在 `klp_subscription.dart`。

`controllers/klp_state_controller.dart` 只管理附接，不複製來源值或釋放外部 state。訂閱支援重入更新、通知中取消與釋放。

`data/klp_async_data.dart` 透過共用 state 發布待命、載入、成功與失敗。generation 使晚到結果失效；cancel 不終止底層 I/O。資料操作錯誤成為失敗狀態，訂閱通知錯誤回報呼叫端；初始通知失敗時，僅復原仍屬於原請求的狀態。此能力尚未接到功能樹的自動安裝或 Flutter renderer。

`navigation/` 提供型別化 destination、location、outcome 與 guard；`navigation/internal/` 是候選堆疊、取消、提交與結果完成的純 Dart 核心。`KlpNavigationMachine.start` 執行初始 guard，允許同步或非同步政策，成功後才呼叫應用提交埠。提交結果與離開結果分開，接點違約不能被誤報為一般拒絕。Application session 已持有並接線此核心，消費端只取得 entry 綁定的 typed input；核心不依賴 Screen 或 Flutter。網址、深連結與還原仍待後續策略。參見 [導覽交易樣板](../../navigation-transaction-prototype.md)。
