# HOST-PORTS-V1-r1 驗證

APP-V1-05／FEAT-V1-06 已完成 E 環境與 P 選檔配對。全 v1 為 50/50 切片；這是逐項契約完成狀態，不代表整套 CI 或發布閘門全綠。

- 純環境解析與平台／適應模式唯一宣告歸 capabilities；Stable foundation 保留原 const constructor、型別身分、欄位與 current(Size?) 採樣介面。原生與 Web query 優先序、600／1024 邊界、模擬模式、無效尺寸與手動 getter 行為保持。
- 唯一 application host 安裝私有環境 observer，沿用既有 WidgetsBindingObserver；同一次 builder snapshot 供 viewport 與 application environment 使用。原 init／source 無尺寸、postframe／metrics logical size 及 accessibility 不重裝資源行為保留。
- 新公開 KlpPickFileAction 透過既有 workspace action handler 執行；capability request 複製副檔名限制，application 是唯一 file_selector owner。每次啟動保留 action／callback／frame／lease／epoch／active entry；晚到成功只有原世代有效才回呼。取消與失效不回呼，平台及 callback 的原錯誤／堆疊回報一次；每次有效啟動各自獨立，不新增佇列或去重。
- 舊零宿主 KlpLocalFilePicker 移至 application/legacy，專用 kallopis_legacy_file_picker.dart 保留原 const/欄位/pick Future 行為。現行 declarative 只替換一個 export，其他五個既有根 library 不變。Feature 清冊只刪除 utility 一列，67→66；24 功能身分／28 總 ID／原順序保持。

## 已執行證據

- E 最終凍結檢查 53 PASS；原宿主基準 15 PASS。新 API 不存在時的編譯錯誤未冒充行為 Red。
- P 首次整合八份檢查 105 PASS；獨立作者補上同 frame 不同 action 逆序完成後，action 檔 13 PASS（包含新增案例）。原邊界基準 70 PASS，接受新公開契約後的原始守衛 21 PASS／8 有效失敗皆保留。
- APP-V1-07 原有導覽還原檢查補驗 5 PASS，完成先前獨立稽核缺少的執行收據。
- 六個模組 Task Packet、Steward 根入口及兩個局部 import 修復的實際 scope 全部 PASS；來源與新測試局部分析無問題。元件清單與 1489 份圖集新鮮度通過，參考網站 5 項檢查及產生／驗證通過。
- 全套 CI 發現 foundation-only 平台守衛與 non-internal 全部應匯出的舊假設，已由獨立作者依[精確接替契約](guard-supersession.md)修正並重跑。沒有放寬其他 frontend／consumer 斷言或公開負向要求。

完整命令、實際日誌 SHA、測試 hash 與 scope 見 [execution.json](execution.json)。先前各批原始失敗與修正收據均保留。參考網站驗證另回報 26 個既有來源連結警示，已保留 link-report，沒有靜默忽略。

## 完整 CI 結果與限制

實際執行 root／example 的既有 CI 指令。初次完整 root 測試為 1487 PASS／61 FAIL，example 為 1 PASS／4 FAIL。兩道過時守衛另有修正後局部收據；其餘失敗已由獨立稽核在原基準重現，包含舊 KlpApp 參數、既有 route/style/slot 契約與 popup／phase toggle 斷言。Import-root 額外三個當輪來源問題已改用 package 根路徑；剩餘 19 個舊來源與基準相同。未重跑未修改的完整失敗範圍，也未將原始全套結果重寫為 PASS。

根分析初次 97 筆中的 96 筆在基準相同舊來源重現；新增 E 測試的 TickerMode 棄用用法由原作者修正，最終相關來源／測試分析通過。Example 26 筆分析問題皆基準存在，部分為巢狀實驗套件尚未設定。格式檢查與使用者指定 tab 及既有格式不一致，保留原規則，不為通過而重排整個專案。既有 CI golden 說明已過時但未修改其執行閘門。

這些現存全套失敗仍是發布問題，沒有豁免、降低門檻或宣稱可發布。詳細證據在外部 ci-baseline-audit 與 root-test-baseline-audit；本次不修無關範例或重新開放已退役 API。

Windows 原生 dialog／WebView 與視覺、操作手感未執行，維持 human-pending。測試使用真實宿主與平台替身；無法直接觀察私有 handler bool、無 view 及瀏覽器 Uri.base 的限制記於作者收據。沒有新增公開測試掛鉤。Stable、KLP-0020 正文權威與完整 P9 移除条件保留。

原工作樹只回存預先雜湊且未變更的精確 paths，HEAD/index 與其他未提交變更保持；回存結果見外部 transfer-receipt.json。
