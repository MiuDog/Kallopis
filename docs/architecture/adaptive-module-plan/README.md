# 自適應與平台值責任配對 AD-V1-r1

狀態：AD-V1-r1 已整合完成。承接 RC-V1-r1，完成 COMP-V1-03/04、RUN-V1-04、CAP-V1-04、FND-V1-06；application 僅同步 adapter 匯入與清冊，不宣稱 APP-V1-05/06 全部完成。

## 接受決策

精確路徑見 path-map.json。三個既有純 enum 實體歸屬 capabilities/environment，foundation 原路徑只 `export ... show` 同一型別，保留全部名稱、順序與身分；不增加環境權威或平台偵測。composition 策略直接讀 L1 值。兩個 adaptive 實作由 runtime 掌管：adapter 是具名組裝入口，prepared 實作放其 compilation/internal，composition 保留節點、策略與擷取。

公開 barrels 及 KlpAdaptive/KlpAdaptiveContext/策略函式簽名不變。application 零參數組裝與 28 身分不變，只修真正 adapter 來源。否決只搬實作卻保留 composition→foundation 邊：那不能滿足 COMP03/RUN04 的共同驗收；本輪配對既有 CAP04/FND06/COMP04，不削弱原條件。否決新增 enum 副本或別名包裝值，因為會破壞既有型別身分。

## 分工與保護

每個 module 的 write paths 由 path-map 固定，架構 Steward 同步本契約與五份 module architecture；各 BUILD 仍只寫自己 module。必要新邊界／舊新 enum 身分檢查由獨立 Test Author 撰寫；既有 adaptive、application catalog、scope/runtime、module 與 frontend 測試唯讀。沒有新使用者行為、UI、Krepis 或 P9 刪除。

## 驗收

composition Dart 不含 runtime/foundation import/export，capabilities 新環境值只含原 enum；舊 foundation 匯出與新值是同一型別。命中策略只呼叫一次，fallback 與 exactly-one-child 行為保留，真實 application 可編譯與提交且清冊來源一致。所有模組 scope gate 通過；原檔案非 directive token 等價或純 forwarding，public barrels 不變。

## 執行

由現況乾淨隔離快照開始，產品包置於 worktree 外，記 base revision／契約 hash；簽名與清冊配對到齊後才驗證。本輪估算 cold-start 各包 1,000–4,000 tokens、5–25分鐘；測試 2,000–6,000 tokens、10–40分鐘，沿用父模型及本機Flutter。M1 完成有限路徑遷移／保持身分；M2 scope＋共同行為證據，超過 1.5 倍或需要越界即回報。沒有provider token時不造數據。
