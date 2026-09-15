# PRES-V1-r1 通用與功能呈現紀錄配對

Execution complete。已完成 FND-V1-03、FND-V1-04、FEAT-V1-04、REND-V1-03；其他切片維持原狀。沒有未決 P1 架構選擇。

PRES-V1-r1：KlpBoundTemplate 原名／constructor／路徑保留，改為不對 consumer 匯出的 abstract class 協定。11 個通用 part 留 foundation；15 editing part 與 editing style、15 workspace part 各移至 features 自有 presentation library，不跨模組 part，不由 foundation reexport。兩個 feature library 都只作唯讀呈現資料，保留上游 controller／engine／callback 身分與生命週期，不新增權威。renderer 保留原 26 concrete 類型的分支與非視覺標記，未知套件內實作明確拋 KlpContractError('unsupported_prepared_template', ...)；不提供註冊或 fallback。另將 button style 與 toolbar 三檔實體移至 features/actions；KlpSelectionAction 留 foundation，filter bar 移除 toolbar export，僅 root kallopis_foundation.dart 直接 export 新 toolbar 以保留 Stable。所有舊移動路徑刪除而不設 shim；公開符號／constructor／範本／catalog 28 ID 順序與效果不變。FND-V1-03 全 foundation 無 features/runtime/rendering/application 或 Krepis/Canva/BlockNote import/export/part 的原要求不得縮小。

35 個實體搬移、3 個 module 寫入集合及所有直接呼叫／測試路徑固定於 [path-map.json](path-map.json)。Architecture Steward 獨立掌管公開 barrel 的一行來源替換與受保護文件；一般 worker 不可改這些檔案。

選擇 package-only abstract 協定，因為 sealed 無法在別的 Dart library 實作；跨模組 part 仍會讓 foundation 擁有上層責任。否決全部移至 rendering、重建 controller／engine model、foundation 的相容轉匯出功能紀錄，與只通過 binding 局部稽核。

M1 完成每 module 移動及靜態等價／scope；M2 在配對整合後確認現有 rendering、editing 安裝／session、workspace、filter/button、目錄與新邊界測試。新風險是 sealed 變 abstract 後的 renderer 完整性與單一宣告身分，獨立 Test Author 保護 26 型別、未知型別拒絕、Stable toolbar 可達性，以及整個 foundation 的相依方向。

各 module 冷啟動估算 3k–8k token、15–50 分鐘；測試 4k–10k token、20–60 分鐘，參考 SEM 路徑遷移但本批另含 library ownership。沿用主模型、Flutter D:/flutter/bin；超過 1.5 倍或越界需回報證據。未提供實測 token 時不造數。契約允許的可逆選擇自動接受，無公開行為改變或新外部影響。

來源架構檢查發現 toolbar 元件頁仍指向舊來源。Architecture Steward 補齊該頁來源／所屬者並依既有生成器重建 docs/architecture/src 圖集；先記錄精確原檔 hash，保留同一測試斷言。這是搬移的文件完整性修復，不擴張 BUILD 模組範圍。

[結案驗證](verification.md) 與 [執行紀錄](execution.json) 保存證據；全目標仍 active。
