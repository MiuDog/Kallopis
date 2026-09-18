# L10N-V1-r2 唯一呈現在地化契約配對

Execution complete。已完成 FND-V1-07／FEAT-V1-05／REND-V1-02／APP-V1-04。沒有未決 P1；全部原驗收保留。

L10N-V1-r1：三個既有 application/localization 檔案作為同一 library 實體搬至 foundation/localization；保留型別、constructor、全部預設字串、savedLabel 私有函式、delegate load/shouldReload/isSupported、fallback 與 equality。這仍是既有 Flutter 呈現契約，不另建純 Dart 模型或第二來源。12 個 features 指令（含1 export）及1個 rendering import 精確向下遷移，全部 features/rendering 不得再依賴 application（含相對／條件／export／公開 barrel 旁路）；無其他host前置。application legacy只更新URI並保留consumer delegates在前的順序；宣告式 KlpApplication 的 WidgetsApp 必須安裝 const KlpLocalizationsDelegate()，不新增locale/override/public API。Stable kallopis_foundation.dart 只改export來源，其他公開符號/可達性/畫面字串/預設環境不變；舊src路徑刪除無shim。

精確路徑見 [path-map.json](path-map.json)。四個 module 各自獨立 BUILD 包，Steward 擁有 Stable 根 export 一行與來源圖集更新；其他包不能寫 root public、架構、測試或設定。必須先配對全部13條上層相依，不能只驗一個檔或只測 fallback。拒絕 foundation 的第二字串模型／複製默認值、只改URI卻不安裝宿主，以及暫時 application forwarding shim。

獨立 Test Author 取得完整邊界 Red 和宿主未安裝的真正 runtime Red；現有 discipline exclusions 只替換唯一來源路徑，frontend 既有掃描目錄精確更新，不能增加豁免。保留舊 app override/host互動測試，新測驗defaults/delegate/fallback、Stable identity與實際 Localizations scope。

估算以 SEM/PRES 路徑搬移為參考（仍屬 cold-start）：每 module 1k–4k token／5–25分鐘，Test Author 3k–7k／15–45分鐘。M1 精確遷移／scope／等價；M2 配對的host／字串與全module邊界Green。超出1.5倍或越界需回報有證據blocker。沿用主模型與 D:/flutter/bin，沒有provider token實測不造數。

### L10N-V1-r2 有證據修復

L10N-V1-r2 修復已重現的舊 discipline 失敗：BlockNote 兩個 renderer 檔的七段原始使用者文案納入既有 KlpLocalizations，七個可選 String constructor 欄位及對應 final 欄位預設完全沿用原文，加入 equality/hashCode 使覆寫可觸發delegate reload。這是相容的既有字串契約補齊，接替 r1「不加 public API」在這七個可選欄位的限制；其餘70既有字串、constructor用法、預設畫面、重試與中斷／WebView生命週期不變，不建第二來源。renderer的錯誤Widget只由 KlpLocalizations.of(context) 取字串，不改branch/controller/callback。獨立作者修 discipline scanner 的註解誤判：兩個 metric card 的單引號箭頭範例是註解而非 literal，必須加入synthetic正負控制，只忽略comments、不忽略真字串，保留Chinese零及icon上限15和下限13，不增加豁免。

[驗證](verification.md) 與 [執行紀錄](execution.json) 保存獨立證據；全目標仍 active。
