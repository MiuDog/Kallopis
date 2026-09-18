# HOST-PORTS 守衛精確接替

Architecture Steward 接受：完整既有 CI 的實際失敗指出兩個舊守衛尚未跟隨既定契約；不改產品 API、公開相容性、測試設定或其他測試要求。

1. `frontend_architecture_boundary_test.dart` 的 platform dispatch 檢查改為：只有既有 Stable `KlpPlatformInfo.current` facade 與私有 `_KlpApplicationEnvironmentObserver.observe` 能採樣 Flutter platform；capabilities 唯一純解析、現行 host 不經 Stable provider、既有 adaptive dispatch 與 legacy app scope 限制保持。Import 的 show 名稱本身不是讀取行為，應使用 AST 或等價精確方法辨別。不得為整個 application 或 foundation 增加豁免；新增負向探針證明非授權來源仍被拒絕。其餘 frontend 測試原樣保留。
2. `consumer_contract_test.dart` 最後的 public-source coverage 檢查採已接受 KLP-0019 與 HOST-PORTS 公開可達性：精確七個根入口，受限 show/hide 和 package URI 正常解析；已公開來源及其 part 必須存在、part-of 對稱且 library/module 歸屬正確；公開 export 閉包不得暴露 internal、宿主 snapshot/port/adapter 或已退役 concrete picker；APP-CONTRACT 既有同 module 私有 owned parts 保留並查核其所有權，不以 private part 路徑當作公開 export。新 legacy root 只公開其 utility，既有宣告式正／負編譯守衛保持。`lib/src` 是否公開由根 export 決定，不能要求全部 non-internal 檔案匯出。至少以 missing export/part 與 private leak 反例驗證檢查器。原 consumer Widget/Material/theme 斷言原樣保留；不修改通用 public_library_graph helper 的舊測試語义。

E 獨立作者只寫第一個測試檔；P 獨立作者只寫第二個測試檔。各自先凍結 hash，所有更新由架構統籌者核對精確範圍後整合；不直接由 BUILD worker 改測試。原全套失敗紀錄保留，修正後重跑相同局部守衛。

公開性依 export 邊與同 library 宣告判定。APP-CONTRACT 原有私有 owned parts，以及 Stable／legacy 原已公開的 owned internal parts，不因此守衛退役；後者以原基準 f783f028 的 owner／公開宣告名稱精確集合或雜湊保護，新增、移除或移動未授權符號仍失敗，不對整個 module 豁免。外部 package URI 須依 package_config 與檔案 URI 正確解析，包含 Windows。
