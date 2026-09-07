## 分析入口

此目錄呈現空白、錯誤、載入、權限與有限工作流狀態，並提供 live region 與焦點邊界。`KlpWorkflowState` 是輸入狀態分類；僅憑 enum 不可推論狀態轉移圖。此目錄目前沒有巢狀子目錄。

| 想回答的問題 | 精確符號與來源 |
| --- | --- |
| 工作流狀態與畫面入口在哪裡？ | `KlpWorkflowState`、`KlpWorkflowStateSurface`：lib/src/feedback/klp_finite_workflow.dart:12、31 |
| 載入與錯誤呈現由誰負責？ | `KlpLoadingState`、`KlpErrorState`：lib/src/feedback/klp_view_states.dart:11、46 |
| 無障礙通知與焦點生命週期從哪裡看？ | `KlpLiveRegion`、`KlpFocusBoundary`：lib/src/feedback/klp_finite_workflow.dart:147、163 |

重要依賴：`KlpWorkflowStateSurface` 的 build 在 `klp_finite_workflow.dart:69` 建構 `KlpSurface`，:95 將 `onAction` 交給 `KlpButton`。這是已查證的畫面組合與回呼轉交，沒有證明工作流本身由此執行。
