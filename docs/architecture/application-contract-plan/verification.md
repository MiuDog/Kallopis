# APP-CONTRACT-V1-r1 驗證

APP-V1-06 complete。先前 RC-V1-r1 的 runtime 部分加上本批剩餘具名契約，完成完整 application 跨模組 internal 邊界。

- 25 個來源實體搬移、49 個搬移後來源／呼叫端／metadata 檔的反向轉換等價證據；七個模組的真實 Task Packet scope PASS。
- 僅調整指令、四項精確用途 dartdoc 與兩份清冊共 36 個來源路徑值。Root 公開 library 指令及順序未變，25 個來源未新增公開可達性；67 個 feature 匯出、24 個元件、28 個 application 身分及原組裝順序保持。
- 獨立遷移作者原基線 170 pass；28 個測試檔只改 42 個 import 與 3 個來源字串，4 個 fixture 正文保持；整合後同一 170 項 pass。
- 獨立全 application 邊界測試原基線有真實舊路徑 Red；包含 scanner 正負與空來源控制、25 實體／舊路徑移除、5 個 reciprocal navigation parts、public closure 與精確 metadata。整合結果見 execution.json。
- 既有兩份封閉／application 目錄檢查 55 pass；frontend/module/token 檢查 167 pass。最早目錄 run 因尚未套用作者的 fixture 路徑而載入失敗，套用凍結原樣遷移後原兩份主體已通過；未修改 assertions 或 baseline。
- 七模組 Dart analysis：無 error/warning，僅 Canva 三個既有 curly-braces info（32:7、40:11、121:7）；獨立作者在原始 source 基線確認同三項，exit 0。
- Atlas：1196 source files、283 folders、3720 diagrams；1480 檔 freshness 逐位元組相符。

原始 D:/Projects/Kallopis 的回存只使用預先雜湊且未改變的精確路徑；HEAD/index 保護與最終 transfer receipt 保存在外部 D:/Projects/Kallopis-v1-evidence/application-contracts。未替使用者 stage/commit 原樹。

尚餘 REND-V1-05、APP-V1-05、FEAT-V1-06 及最終全目標證據稽核；本批不宣告感官品質或宿主工作階段完成。
