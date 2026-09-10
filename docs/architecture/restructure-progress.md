# Kallopis 遷移進度

> 命名已定案：保留 Kallopis／kallopis，宣告式 API 使用 Klp 前綴及 kallopis_declarative.dart。資料夾與 GitHub 維持 Kallopis。以下批次屬於歷史紀錄，驗證原始檔名保留；各批次的當時限制不代表最新整合狀態。

最新狀態：Router 應用入口、初始 guard、保留頁、平台返回、中立 stack 還原與受控環境策略已接通；宣告式 API、檔名及引用已統一為 Klp／klp。中立還原後完整 root 為 `04:30 +1073: All tests passed!`，root analyze 為 `No issues found! (ran in 4.5s)`。元件清單與架構圖集已同步；這些證據不代表完整重構完成。

2026-09-10 已完成實體目錄重整：`lib/src` 僅保留 application、capabilities、composition、features、foundation、kernel、rendering、runtime 與 styling 九個架構根。既有 Flutter 實作按責任收納在 foundation 或 features，不以舊頂層目錄繼續存在；完整對照見 [目錄重整](directory-reorganization.md)。

本次改名前已保存 3,046 檔快照並逐檔比對 SHA-256；完成 210 項路徑搬移及 239 檔內容更新。公開入口為 `lib/kallopis_declarative.dart`，不保留舊命名相容別名。兩套入口沿 export／part 的可達來源交集為零；新舊同名型別依 Dart library 隔離，不以名稱前綴區分權限。一般英文識別字如 `headerSymmetric` 及歷史證據檔名保留。

命名驗證原始紀錄保存於 `D:/Projects/Kallopis-migration-baselines/klp-namespace-20260909-210457/verification/`：`klp-namespace-root-test.log`（exit 1）、`klp-namespace-inventory-recheck.log`（exit 0）、`klp-namespace-root-analyze.log`（4.7s，exit 0）、`klp-namespace-example-analyze.log`（2.4s，exit 0）。架構圖集為 1,016 Dart／261 目錄／3,135 圖，freshness 1,278 檔一致；元件清單生成與檢查通過，424 型別／166 widgets。清單工具仍以型別名稱建立部分索引，不能取代跨 library 的入口隔離驗證。

本批已完成宣告式 action 與導覽選取一致性：route input 只建立 `navigate`／`finish`／`back`，rail 只接收 `KlpAction`；guard 拒絕、根 back、失效 entry 與舊 frame 都不改選取。完整 root 首次執行至 `04:16 +1058 -2`，兩個失敗皆為新公開 action 檔案尚未 export 與 inventory 尚未重生；補齊正式 export、以既有 generator 更新清單後，完整 root 修後重跑 `04:10 +1061: All tests passed!`。root analyze `No issues found! (ran in 4.7s)`，example analyze `No issues found! (ran in 2.5s)`；公開入口、inventory、frontend boundary、route、rail 與 action 回歸組合亦通過。

本批另接通受控環境策略：應用宿主統一讀取既有平台來源與系統輔助功能偏好，關閉動畫會以根 `MediaQuery`／`TickerMode` 即時完成，且偏好切換不重裝選取 state。`KlpApplication` 不接受 environment，環境快照沒有公開建構子。編譯負例、宿主 Widget 測試及 root analyze 均已通過；完整矩陣見 [受控環境策略](controlled-environment-policy.md)。

本批接通 [受控導覽還原](controlled-navigation-restoration.md)：destination 可提供 typed `KlpRouteCodec<P>`，`KlpRouter` 以已註冊 destination identity 與 router id 還原不可變 stack，並在安裝前為每個 entry 執行 `beforeEnter`。`KlpApplication.onNavigationRestorationChanged` 只發布已提交的完整 stack，所有 route 未具 codec 時拒絕開啟 callback；callback 失敗不回滾已提交畫面。公開還原、Router session、navigation machine、navigation start 及公開 API 共 29 項回歸通過；完整 root `04:30 +1073: All tests passed!`，analyze `No issues found! (ran in 4.5s)`。平台 URL／deep link adapter、實際 app lifecycle persistence 與多頁 Windows 實機仍未驗收。

後續接通單頁 platform URI 進入：`KlpRouteUri` 固定 `/{routerId}/{destinationId}?key=value`，宿主只對符合格式的 `RouteInformation` 建立單頁 restoration。導覽機器將其視為完整交易，依序執行目前頁 `beforeLeave` 與每個候選 entry 的 `beforeEnter`，成功才替換 stack；既有未完成 ticket 以 `restored` 取消。machine、URI、restoration 與 router session 18 項回歸通過，analyze `No issues found! (ran in 5.3s)`。瀏覽器 history 寫入、完整 stack URL 與多頁實機仍未驗收。

URI 宿主雙向同步亦已接通：具完整 codec 的 Router 每次提交後由 Kallopis 以 `SystemNavigator.routeInformationUpdated` 發送目前 URI；平台 URI 進入則用 `replace: true` 避免重複 history entry。兩個 session widget 測試覆蓋提交回報與 platform message 進入，43 項 navigation 回歸通過，analyze `No issues found! (ran in 5.4s)`。實際 web／原生 history、完整 stack URL 與多頁實機仍未驗收。

URI 現另支援完整 stack：Kallopis 自行回報 `/{routerId}?__klp_stack=<base64url-json>`，而外部單頁 deep link 保留既有可讀 path。payload 嚴格驗證版本、stack、destination 與字串參數；破損資料在進入 Router 前拒絕。完整 stack round-trip、破損拒絕與 router session 12 項回歸通過，analyze `No issues found! (ran in 4.8s)`；實際 browser／原生 history 與跨版本遷移尚未驗收。

宣告式 screen 現強制 `accessibilityLabel`，空白資料在建立時拒絕；準備後輸出封閉的 `KlpBoundScreen`，Flutter renderer 統一建立 `Semantics(namesRoute: true)`。消費端仍只注入本地化資料文字，不接收 Widget、語意 builder 或樣式欄位。screen 語意、route／slot 外部編譯契約、保留頁與 nested composite 共 38 項回歸通過，analyze `No issues found! (ran in 4.6s)`。

外部 `KlpComponentDefinition<T>` 現可在定義期提供可選 `accessibilityLabel` selector；泛型上轉仍經 definition 的保留型別方法呼叫，避免窄型別 selector 被視為 `KlpNode` callback。完成資料投影後才輸出封閉語意節點；空白 label 與 selector 例外各有明確 contract error／binding exception。component binding 與 router session 共 17 項回歸通過，analyze `No issues found! (ran in 4.6s)`。

宣告式公開 API 現以 analyzer AST 沿 `kallopis_declarative.dart` 的 export／part 可達來源檢查；公開宣告不得出現 `Widget`、`BuildContext`、`ThemeData`、`AnimationController` 或 `NavigatorState`。這與外部編譯負例共同防止以轉接型別重新開啟 renderer、context 或原生導覽出口。

尚未完成：完整風格演算法、完整平台／無障礙／減少動態策略、實際 browser history 與其他 features。多頁 Windows 實機互動尚未驗收；既有 example 視覺測試與格式閘門問題尚未解決，因此全量 Verify 及整體重構仍未完成。

第七批新增 [現況總覽](current-refactor-overview.md) 與 [導覽交易契約](navigation-transaction-prototype.md)，分開記錄現有能力與整合驗收要求。本批早期 Navigation 核心尚未接入應用公開流程；後續已接通初始 guard、保留畫面應用整合及平台返回。下方保留各階段當時的驗證結果。

第七批首輪實作者驗證：導覽核心 17 例加前端邊界 154 例，`00:01 +171: All tests passed!`；focused analyze `No issues found! (ran in 2.4s)`，均 exit 0。原始紀錄為基線 `verification/symploki-navigation-core-{analyze,test}.log`，已回讀尾行。獨立審查正在補 complete／pop／重入案例；此首輪結果不替代獨立驗收與後續 scoped identity 遷移的回歸測試。

導覽核心獨立審查再新增七例，三個導覽測試檔共 24 例通過，analyze 無問題（4.8s），均 exit 0。涵蓋 complete 提交前後失敗、pending pop 取消、listener 重入、失效 guard、泛型擴寬與接點違約後 ticket 結束。紀錄保存於 `verification/symploki-navigation-review-tests.log` 與 `symploki-navigation-review-analyze.log`。其後開始 scoped identity／runtime／rail 遷移，不能把此結果視為後續變更已通過。

第七批 scope 與保留頁整合：`KlpPlacementId` 成為 snapshot、capture、runtime、installation 與 bound key 的唯一識別；local id 為衍生值，rail callback 維持 local String。只有本庫 `KlpScopeBoundary` 開啟範圍。祖先與子層操作 lease 取交集，隱藏頁資源保留但捕獲的回呼不可重新啟動；提交前準備失敗保留舊 lease。

新增封閉 `KlpBoundRetainedStack` 與 renderer，保留頁面的元素及焦點範圍，停用非目前頁的輸入、焦點、語意與 TickerMode。獨立呈現八例先通過；後補 constructor 三例與 notifier 斷言納入本次完整 root：`01:17 +1017: All tests passed!`，原始紀錄為 `verification/symploki-scoped-root-test.log`。TickerMode 證據只涵蓋有效模式與通知，未聲稱完整動畫已驗收。當批應用仍以單一 `KlpScreen` 啟動；Router 入口、初始 guard 與平台返回於後續接通，還原及實機多頁流程仍未驗收。

Scope／activation 另由未參與實作的審查者親跑 capture、activation、scoped runtime 三檔：`00:00 +14: All tests passed!`，exit 0；確認隔離、祖先禁用、過期回呼撤銷、失敗保留與資源釋放。原始紀錄為 `verification/symploki-scoped-independent-test.log`。本批完整 root analyze：`No issues found! (ran in 5.9s)`，exit 0，紀錄為 `verification/symploki-scoped-root-analyze.log`。

本批圖集更新為 1,006 Dart 檔、259 目錄、3,102 圖；freshness 1,266 檔逐位元相符，九份文件 read-back 通過，均 exit 0。相關人工摘要區分已實作 scope／保留頁與尚未整合的 Router；紀錄為 `verification/symploki-scoped-atlas-{generate,check,readback}.log`。圖集一致性不等同多頁實機呈現驗證。

目前：P0 已完成；P1 遷移界線已記錄；P2 結構／註冊、primitive／semantic 參照及 foundation 模板樣板與 P3 狀態／controller、非同步資料及內部放置資源交易已實作。第五批已接通單一應用資料入口、內部 runtime、rail 自動選取與 Flutter renderer，後續接通 Router 與宣告式 action。P2/P3/P4 均未整階段完成：完整風格演算法、平台策略及其他 features 尚待實作。完整重構尚未完成。

## 工作基準

2026-09-09 已將 git tracked 及非 ignored 未追蹤實際檔案複製到 `D:/Projects/Kallopis-migration-baselines/20260909-171524/workspace/`，共 2,616 檔，逐檔比對 SHA-256。相鄰 manifest.json、status.txt、head.txt 記錄內容雜湊、刪除狀態與 HEAD。忽略的 build/cache 不納入來源快照。沒有提交或清理原工作樹。

## 本批契約

範圍：純 Dart 結構描述、註冊／樹驗證、狀態來源與控制器生命週期。先驗證資料及所有權，不改畫面或重定義預設風格。

新 API 暫不作 Stable 承諾；命名已定案，Router 應用入口已接通，完整 renderer、primitive schema 凍結、完整 semantic 演算法與所有 feature 遷移仍依計畫推進。隔離入口為 [kallopis_declarative.dart](../../lib/kallopis_declarative.dart)，沒有從舊視覺入口匯出。

## 首批實作內容

- KlpNode／KlpDefinition／KlpRegistry：固定型別資格、不可變註冊依賴、重複／未知識別／相依循環拒絕。
- KlpTreeValidation／KlpValidatedNode：取得一次 getter 快照，驗證結構循環及型別不符，之後不保存可變的外部節點。
- KlpState／KlpMutableState／KlpSubscription：借用唯讀 facade，資料擁有端控制更新及釋放；重入更新 FIFO，通知中訂閱變更安全。
- KlpStateController：借用 state，不複製值、不代為 dispose；禁止重複附接及釋放後操作。

通知事件參數依佇列派送，value 表示最新資料；重入更新時兩者可能不同。資料應不可變，相等值不通知。這些是目前純資料契約，不是畫面排程保證。

外部元件開發方向已再次確認：公開 foundation 的受控元件供宣告式組合，實作功能資格介面，風格仍由本庫掌握。首批的 typed rail fixture 只用來驗證多介面資格；不是正式 rail 或 foundation API。

## 證據

獨立審查代理親自執行：新增契約兩檔 `00:00 +17: All tests passed!`，exit 0；focused analyze `No issues found! (ran in 3.9s)`，exit 0；frontend boundary `00:06 +154: All tests passed!`，exit 0。未發現需修正的資料契約缺陷；不表示 renderer 或未實作能力通過驗證。

新增入口曾使舊 consumer coverage 失敗，已改為兩個隔離入口的來源聯集合蓋與交集拒絕。独立審查進一步找到 show／hide 匯出漏檢，已改用 analyzer AST（僅 dev dependency）。加入多行、show／hide、conditional、package URI 與 named part 案例；不排除 Klp 來源、不新增 allowlist。此完整性規則要求完整相對路徑匯出，restricted export 及非相對 URI 明確拒絕，不假裝完整解析所有外部套件。

修正後獨立審查親跑 consumer、style_source、Klp state、Klp composition：`00:04 +53: All tests passed!`，exit 0；五個受審檔案 analyze：`No issues found! (ran in 10.6s)`，exit 0。此結果也驗證 Klp 測試均可從新公開入口使用，沒有 private import 依賴。

圖集已依生成器更新，新增 kernel／composition／capabilities 人工摘要；freshness：`Freshness check passed: 1100 files match byte for byte.`，exit 0（879 Dart，220 目錄）。圖集描述現有首批能力，不宣稱規劃中的目錄已完成。

全量 Verify（symploki-first-checkpoint-final-verify.log）exit 1：root analyze `No issues found! (ran in 16.4s)`，example analyze `No issues found! (ran in 3.9s)`；格式、清單、root／example tests 未通過。Root `00:51 +686 -4: Some tests failed.` 包含原先 inventory／section／tag input 三個失敗及本批兩條診斷中文文字觸發 l10n。後者已改為英文開發者訊息，錯誤代碼與控制流程不變，且經獨立靜態審查。

最終串行重驗六檔（Klp composition／state、l10n、consumer、style_source、frontend）：`00:13 +209: All tests passed!`，exit 0。此為診斷修正與公開入口整合後的證據；未重跑全套 golden，也沒有將全庫標成通過。前次基線見 [查核紀錄](restructure-audit.md)，原先格式／清單／section／tag input／Catalog coverage／golden 差異仍需後續分類與處理。

最終 root analyze：`No issues found! (ran in 15.2s)`，exit 0。四份原始驗證紀錄已另存於 `D:/Projects/Kallopis-migration-baselines/20260909-171524/verification/`，不只保存在暫存目錄。

本批曾因多個測試程序同時複製 Flutter test cache 而出現 PathExistsException，已停止併行測試並改為串行重驗；未刪除整個 build 來掩蓋問題。

## 下一個工作段

使用者最新決定保留 Kallopis；P10 改為核對現有名稱與接線，不再執行 GitHub 倉庫或本機資料夾更名。

先補 P2 的受控 foundation 宣告與 semantic 參照，並以單一功能案例推進 P3/P4 安裝與 renderer；不擴大移植其他 features，也不把目前這批純資料驗證稱作架構穩定性驗收完成。正式預設風格重設仍留待重構後。

## 第二批：放置資源與非同步資料

- `runtime/installation/internal/` 先驗證整樹再配置資源；建立失敗保留舊樹並清理本次新增資源。相同位置及定義重用資源，移除節點反序釋放；提交後通知／清理錯誤保留完整診斷，且標示已提交。此機制仍為 private，不是消費端的第二個安裝入口。
- `capabilities/data/` 提供待命／載入／成功／失敗狀態、最新請求採納、取消及釋放；取消不終止底層 I/O。資料操作錯誤與通知錯誤分開處理。
- section／tag input 原測試把外殼自身的排版也算進內容元件，已將查找限定在受測元件後代，仍要求恰好一個，保留原事件與文字驗證；未修改畫面或 golden。

首輪四檔測試 `00:06 +24: All tests passed!`，exit 0；獨立新增通知復原五例 `00:00 +5: All tests passed!`，exit 0；root analyze `No issues found! (ran in 22.9s)`，exit 0。合併檢查 236 例通過，但指令誤列不存在的 `l10n_contract_test.dart`，故整體 exit 1；正確檔名為 `l10n_discipline_test.dart`，由本批獨立全量驗收補驗。這些不是全庫綠燈證據。

本批獨立審查追加「Loading 通知內再次 load，第二次 Loading 通知取消」的回歸案例，實測發現工作先於第二次載入通知啟動。已將所有發布集中在私有 helper，保存並復原巢狀發布狀態；重入 load 同步保留 generation，延至目前通知結束後才發布及啟動，再確認是否仍有效。一般 load 仍同步發布載入狀態。五個回歸案例涵蓋取消、通知錯誤歸屬、巢狀發布與完成通知內載入。

修後獨立親跑全部 Klp、frontend boundary、l10n discipline：`00:02 +204: All tests passed!`，exit 0；root analyze：`No issues found! (ran in 4.7s)`，exit 0。範圍內未發現其他可行動缺陷。

本批全量 Verify exit 1：root／example 相依、兩邊 analyze、inventory、catalog registry 六步通過；format、root tests、example tests 三步失敗。格式僅檢查未寫檔；root `00:52 +716 -1: Some tests failed.` 唯一失敗是上述修復前新增重入案例；example `24:14 +16 -63: Some tests failed.` 仍含 Catalog coverage 與 golden 尺寸差異。本批未改 golden，也未將修後的 focused 結果當成全量 Verify 通過。

修正後再跑完整 root suite（`flutter test --concurrency=1`）：`02:57 +721: All tests passed!`，exit 0。此結果取代本批修復前 root failure；範例失敗與格式衝突仍未解決。原始全量、修後獨立驗收、analyze 與最終 root 紀錄已保存於 `D:/Projects/Kallopis-migration-baselines/20260909-171524/verification/` 下的 `symploki-installation-*.log`。

元件清單已透過既有生成器重建並通過 `--check`。圖集新增 runtime 人工摘要、更新 capabilities 摘要，並修正 styles 摘要仍聲稱只有一檔的過時描述。程式修正後已再生成：890 Dart、224 目錄，freshness `Freshness check passed: 1115 files match byte for byte.`，exit 0。此為來源與圖集一致性，不是圖形視覺驗收。

## 第三批：固定原料與定義期語意參照

實際契約、所有權與未完成界線見 [風格資料樣板](styling-contract-prototype.md)。新增十一種封閉量值與固定八槽完整集合；只有原料及同型用途參照，沒有外部求值函式。八槽是試作界線，尚未凍結或證明足以涵蓋全庫。

`KlpDefinition` 將 semantic owner 綁定定義 id，語意依賴自動納入定義相依；`KlpRegistry` 在掛載前驗證全量引用。缺漏、循環、私有跨 owner、未宣告依賴、同名假型別與重複註冊均拒絕。內部 resolver 可以同一用途圖解析兩套原料並保留舊結果；尚未接到 renderer 或功能狀態生命週期。

第一輪原料／語意／註冊／composition／consumer／style source／frontend／l10n：`00:09 +251: All tests passed!`，exit 0。另加入真正外部套件的負向解析測試：合法 public schema 作控制組；以精確診斷碼與違規行驗證 sealed／final、跨種類引用及缺漏／未知 constructor 欄位。

獨立首輪完整 root 為 `+770 -1`，唯一失敗為新增編譯測試的 SDK 路徑尾端斜線不符合 analyzer 正規化要求；測試工具改用實際目錄解析路徑，未改拒絕條件。修後外部編譯 50 例 `00:03 +50: All tests passed!`，exit 0。再親跑完整 root：`00:45 +820: All tests passed!`，exit 0；本批初次獨立 analyze `No issues found! (ran in 6.6s)`，exit 0。未修改畫面或 golden，未重跑範例既有視覺失敗，也未聲稱全量 Verify 已通過。

其後僅新增一個識別邊界測試：明確驗證定義／語意 ASCII 樣板及非法輸入，並驗證 placement id 仍允許非空 Unicode／分隔符。新增後局部 registry 六例 `00:00 +6: All tests passed!`，exit 0；再 analyze `No issues found! (ran in 4.5s)`，exit 0。820 全量尾行屬於新增此案例之前，沒有將兩次結果拼成未實跑的 821 全量證據。原始紀錄保存於同一基線資料夾的 `verification/symploki-styling-*.log`。

圖集新增 styling、更新 composition 摘要及依賴說明，生成 914 Dart、231 目錄、2,811 圖；freshness `Freshness check passed: 1146 files match byte for byte.`，exit 0。契約樣板與生成頁面連結 read-back 通過，沒有將此當成圖形視覺驗收。

## 第四批：外部元件模板與 rail 結構

實際使用界線見 [元件模板樣板](component-template-prototype.md)。新增定義期封閉文字／線性／表面模板，透過 typed semantic key 描述風格；實例只提供資料與 callback。內部 compiler 先驗證引用與資料資格，再產生不可變的呈現快照。模板直接使用 foreign token 時沿用同一套引用權限檢查，沒有獨立的較寬鬆規則。

`KlpRail` 的 top／center／bottom 僅接受 `KlpRailItem`，各自清單與 children 順序採快照。外部元件可同時具備其他資格。此為結構契約，沒有自動選取／焦點／排序或 renderer；可用畫面的唯一應用根尚未完成。

首輪資料投影測試發現 Dart 泛型上轉時，取出窄型別 selector 並當成廣型別函式會失敗。已將 selector 保存在私有欄位，經保留 T 檢查的方法派送；另先檢查整份模板對實例的資格，避免較晚的子模板失配。修後 binding／semantic／registry `00:01 +27: All tests passed!`，exit 0。獨立審查另補巢狀窄 text／空 linear／surface 三種回歸，確認任何 selector 前就拒絕不合格資料，相容資料正常。

外部編譯測試已集中共用隔離 fixture，保留既有 style 50 例與 rail 7 例的精確診斷。新增 template 契約曾揭露 SDK 與 dev analyzer 對 private named formal 支援不同；改成公開 text 參數委派私有 positional constructor，維持私有 selector 與公開用法，不忽略 lint 或放寬負向測試。修後 template 外部編譯 42 例全部通過。

最終獨立完整 root：`00:53 +884: All tests passed!`，exit 0；`flutter analyze`：`No issues found! (ran in 5.2s)`，exit 0。審查範圍內未發現未修復缺陷。未重跑 example、未進行 Windows 實機呈現；本批沒有 renderer，不把資料驗證當成畫面驗收。原始證據保存於基線相鄰 `verification/symploki-foundation-*.log`。

最終圖集依現有來源重建為 931 Dart、239 目錄、2,867 圖；freshness `Freshness check passed: 1171 files match byte for byte.`，exit 0。foundation 摘要區分新模板與舊 Klp 視覺元件，新增 features 摘要說明 rail 的實際界線；不手改自動生成頁面。新樣板與生成頁面 read-back 通過，並非圖形視覺驗收。

## 第五批：接通應用宣告與呈現

流程及權限見 [應用 runtime 樣板](application-runtime-prototype.md)。新增 `runKlpApp(KlpState<KlpApplication>)`，消費端注入完整宣告資料，由本庫持有宿主與功能資源。Screen 只接受合格內容；組合根集中註冊內建功能及外部受控模板，runtime 不依賴 rail 型別。

每次更新取得一次結構快照、統一解析語意，再準備所有資料；準備成功後才安裝。相同位置與定義重用資源，移除反序清理。提交時先撤銷舊畫面的操作資格，通知錯誤仍發布已提交的新畫面。Rail 選取與 controller 由本庫持有，renderer 只借用選取資料並管理自身焦點。

首輪 runtime 與相關既有測試 `00:00 +38: All tests passed!`，exit 0；rail 六例 `00:00 +6: All tests passed!`，exit 0；renderer 十例 `00:00 +10: All tests passed!`，exit 0。全庫 analyze 本次 `No issues found! (ran in 4.5s)`。這些結果尚非第五批完整獨立驗收，宿主測試與全量 root 仍待完成。

交叉審查已修正初次安裝前未訂閱來源造成的更新遺失，以及 tight 父限制使 rail 宣告寬度無效的問題。前者先訂閱並依序處理重入資料，後者由 generic extent 吸收父限制、依方向放置並限制可用尺寸。正式預設風格、全畫面 golden、Windows 實機呈現、完整無障礙／動畫／平台矩陣尚未驗收；沒有以元件測試冒充這些工作完成。

其後獨立審查重現兩個缺陷：風格替換跨越捲動門檻造成焦點重建，以及外部取消訂閱拋錯阻斷宿主清理。已固定區域祖先拓樸，清理逐步執行並彙整錯誤，來源世代隔離殘留舊事件。第二輪另確認 didUpdateWidget 直接拋錯會令 Flutter 摧毀宿主，已改由框架報告錯誤並完成重建。四個獨立回歸涵蓋門檻焦點、取消清理、来源替換與初始化雙重錯誤。

最終獨立完整 root：`01:09 +918: All tests passed!`，exit 0，包含 frontend architecture boundary；analyze：`No issues found! (ran in 5.3s)`，exit 0。原始紀錄保存於基線相鄰 `verification/symploki-application-root-test-final.log` 及 `symploki-application-analyze-final.log`。未重跑 example 既有失敗，也未聲稱格式或全量 Verify 通過。

新增公開 API 消費範例 [klp_runtime_demo.dart](../../example/lib/klp_runtime_demo.dart)：無 Flutter import、Widget 或 build；A／B 更新資料，C 替換整套 primitive。從 example 執行 `flutter run -d windows -t lib/klp_runtime_demo.dart`，16.8 秒完成 Windows debug build，成功啟動。實際觀察到三區 A／B／C；點擊 C、Enter 及 Space 皆觸發深淺整套切換，焦點維持 C，無障礙樹列出三個按鈕。視窗標題仍是 runner 的 kallopis_catalog，不能將 WidgetsApp 的應用標題更新當成原生視窗標題更新已完成。驗證後關閉示範，Flutter 程序 exit 0。

桌面截圖及無障礙樹保存在 `D:/Projects/Kallopis-migration-baselines/20260909-171524/verification/symploki-application-windows-{light,dark}.jpg` 與 `symploki-application-windows-accessibility.txt`。這是首條流程的 Windows 實跑證據，不是正式預設風格或完整平台矩陣驗收。操作時曾遇到已失效 UIA index，重新觀察後改用當次截圖座標完成，不以失敗工具動作聲稱成功。

最終圖集 965 Dart、253 目錄、2,981 圖；freshness `Freshness check passed: 1219 files match byte for byte.`，exit 0。七個人工摘要 read-back 通過。後續優先處理外部複合元件的合格子插槽、路由及環境策略，再擴大 features 遷移；目前外部模板仍只支援無實例子項的內容。

## 第六批：外部複合元件的合格子插槽

[合格子插槽樣板](component-slots-prototype.md) 已接上實作。新增 `KlpSlot<C>`、封閉 assignment、`KlpChildren`、`KlpCompositeNode` 與驗證範圍；`KlpChildrenTemplate` 由定義期模板推導 schema，實例只提供一次完整 children。screen／rail 使用相同機制，內部 adapter 從擷取快照取得群組資訊。

定義及安裝拒絕錯誤 owner、重複 slot、假同名 slot、數量／順序／資格不符、缺漏或多餘配置。封閉 immutable 集合避免另一份子樹或子項 selector 成為第二來源。識別格式與 semantic 共用 kernel 規則，未複製相同正規表示式。

內部準備樹先完成資料與風格，materialize 僅插入已完成子內容，不把佔位送進 renderer。通用 runtime 為所有放置加入完成的識別包裝；同層重排不以索引重建子元件。另將外部模板資格提升為全樹 preflight，避免較晚型別失配發生在較早文字投影之後。任意外部 getter／selector 的純度仍非語言沙箱保證。

首輪 composition／rail／結構 33 例通過，外部編譯 23 例通過，binding／模板／放置識別／rail adapter 58 例通過。獨立三個公開啟動案例驗證三層巢狀呈現、每次投影一次、同層重排與完整原料替換保留焦點及選取；錯誤插槽更新保留原畫面、資源與操作，且不執行額外 selector。

最終獨立完整 root：`01:04 +960: All tests passed!`，exit 0；analyze：`No issues found! (ran in 4.8s)`，exit 0。紀錄已存入基線相鄰 `verification/symploki-slots-root-test-final.log` 與 `symploki-slots-analyze-final.log`。未重跑 example 的既有基線失敗，不宣稱全量 Verify 或完整重構通過。跨父容器移動的焦點保留未查證，完整 router、環境／能力策略與其他 features 仍待完成。

公開 API 桌面示範已改成真正複合元件：`DemoRailItem` 透過合格 counter 插槽組合獨立 `DemoCounter`，兩者各有定義，child id 不隨計數或風格改變。未修改 primitive，沒有新增 runtime 特例。示範 targeted analyze 無問題；Windows debug build 11.0 秒成功。實際點擊 A 後三個計數由 0 變 1，點擊 C 後變 2 並切換淺色，Enter 再變 3 並切回深色；焦點維持 C，重新讀取的無障礙樹標示 A／B／C 的最新計數 3。驗證後由 Flutter 正常結束，`Application finished.`，exit 0。

本批桌面證據位於基線相鄰 `verification/symploki-slots-windows-{light,dark}.jpg` 與 `symploki-slots-windows-accessibility.txt`。這是複合資料注入、繼承既有風格與互動的 Windows 實跑，並非正式視覺或完整平台矩陣驗收。

圖集已更新為 980 Dart、256 目錄、3,025 圖；freshness `Freshness check passed: 1237 files match byte for byte.`，exit 0。七份文件 read-back 通過，模板文件已移除過時的無應用根／無 rail 呈現敘述。該批之後推進 screen router、環境與能力策略；完整 features 遷移仍待完成，名稱已由最新決策確定為 Kallopis。
