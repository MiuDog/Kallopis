# COMPAT-V1-r1 驗證

CAP-V1-03／FEAT-V1-07 已完成；全目標46/50，四項host/session/application切片與最終稽核仍active。

舊text/IME/block/list/undo／layout／pending-resync用途明確限相容維護與回退；保留provider、保存、身分、共用drawing／geometry及手寫／mode既有契約。全部44exports不變，沒有新增Deprecated警告或刪除舊正文。新BlockNote借用原Krepis controller/channel，不以共享presentation library的legacy DTO import誤判第二正文權威。

七個layout節點只增加final modifier，原建構、defaults、slots、members及其餘正文精確保留。資格interface仍合法；已知ID偽裝在真catalog被node_type_mismatch拒絕，保留前一個frame/resources。舊Stable Explorer/WindowControls仍在，P9完整下游遷移／無受支援舊匯入／相容證據／發布說明條件未縮減。

| 證據 | 結果 |
| --- | --- |
| 外部封閉與真catalog／相容 | 55項通過；7個合法建構、14個extends/implements精確封閉診斷、全部public component final、28/24/67清冊與完整P9。 |
| 新正文相容用途邊界 | 5項通過；真型別與操作邊界、共享library及正負控制。 |
| 既有layout／composition／BlockNote／provider | 37項通過；含原90個provider型別身分。 |
| Scope／preservation／analysis | 三個module scope PASS；只新增用途dartdoc或7個final，反向移除新增內容後逐byte還原；4個入口局部分析無問題。 |
| Atlas | 1196source、278folder、3713diagrams；1475files freshness逐byte通過。 |

獨立封閉測試在原baseline有15個真Red（14種合法外部擴充原可編譯＋7節點尚未final），其餘40項含全部29個既有測試已通過；新增斷言未取代舊要求。用途分類沒有新runtime行為，BlockNote已符合的邊界可記原baseline Green，不捏造Red。最終frontend/module檢查、原命令與hash見 [執行紀錄](execution.json)。未執行全庫或感官品質驗收。
