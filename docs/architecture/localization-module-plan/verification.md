# L10N-V1-r2 結案驗證

FND-V1-07、FEAT-V1-05、REND-V1-02、APP-V1-04 完成，全目標 41/50；其餘切片與最終稽核仍未完成。

三個 l10n 檔案作為同一 library 實體搬至 foundation，12 個 features 指令與 rendering 向下使用唯一來源；包含 form export 間接使用者的完整相依圖已無 application 邊。宣告式 WidgetsApp 實際安裝既有預設 delegate，Stable 根保留同型別，legacy consumer 覆寫順序不變。

原 70 個字串、savedLabel 私有函式與既有 constructor 用法保留。已重現的七段 BlockNote 錯誤原文納入七個可選欄位，參與 equality/hash 與 delegate reload；renderer 僅改取字串，重試／中斷／WebView 環境分支、已掛載 editor、controller 與 callback 不變。這項相容擴充已由 L10N-V1-r2 明確接替初版對新增 API 的限制，不建立第二來源。

| 證據 | 結果 |
| --- | --- |
| 六個最終保護檔 | 179 項通過，內含既有 frontend 155 項、discipline、原 App 契約、宿主 scope、Stable identity、70+7 字串與覆寫。 |
| 最終 module 契約 | 3 項通過，於狀態更新後執行；沒有再次重跑 frontend。 |
| 原 host 行為 | 初次混合執行的六項 host 案例全部通過；該次 legacy App 編譯失敗另列，未宣稱混合執行全 Green。 |
| 保留已掛載正文 | 1 項通過：retry／runtime notice 不卸載既有 editor。 |
| 局部分析 | 搬移契約／host library 與追加 error 文案範圍均無問題，exit 0。 |
| Source atlas | 1195 source、275 folder、3707 diagrams；1471 輸出檔逐位元 freshness 通過。 |
| Scope／測試保護 | 四個原 module 包＋兩個修復包全部 PASS；最終六檔完全符合作者 SHA256。 |

原基線兩類失敗都已修復，沒有放寬閘門：App 測試只移除四行已不存在的 showWindowHeader 參數，保留四項行為斷言；圖示 scanner 只修註解誤判，保留 Chinese 零違規及圖示最大15／最小13，實際圖示14。新的 AST 測試漏認非 const 建構由獨立作者修正，保留唯一分支與欄位綁定要求。初次失敗日誌與每次凍結記錄均保存於外置證據目錄。

未執行整套測試，未宣稱視覺／互動品質或 P9／正文權威閘門完成。精確命令、原始 Red、保留證明與結果見 [執行紀錄](execution.json)。原工作樹只回填有原始 hash 的精確差異，保留原 HEAD／index／其他未提交內容。
