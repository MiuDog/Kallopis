## 分析入口

`structure/klp_application.dart` 是唯一 application library 及資料根：包含標題、完整 primitive 風格組、必填 `KlpRouter` 與外部元件定義。單畫面也透過路由映射產生 `KlpScreen`；screen child 必須具備 `KlpScreenBody` 資格。消費端以 `runKlpApp(KlpState<KlpApplication>)` 啟動，再更新同一份宣告資料；不提供 Widget、BuildContext、renderer 或功能 controller 接線。

`routing/klp_router.dart`、`klp_route.dart`、`klp_route_input.dart` 及 bootstrap／host／session 都是主 library 的 parts。`KlpRoute<P, R>` 的私有 mapper 只產生宣告資料；`KlpRouteInput<P, R>` 由私有建構子建立，只借用綁定 entry 的參數與 push／complete／cancel 操作。沒有公開 session、controller 或跨檔案使用的 input factory。

`bootstrap/internal/klp_application_adapters.dart` 集中註冊 screen、rail、scope、retained screens 與外部元件 adapter。私有 host 借用宣告來源並持有私有 application session；session 擁有 navigation machine 及唯一 `KlpTreeRuntime`。初始 guard 成功後才投影畫面；每次導覽或來源更新將全部 retained entries 一同轉成 scoped 樹，避免多個 runtime 的獨立提交。

`klp_application_session_commit.dart` 在整樹準備及安裝成功後採用新路由定義、政策與操作世代；失敗保留已提交畫面與舊操作。router id、初始位置或仍保留目的地的物件身分不能藉來源更新暗中替換。`klp_application_session_actions.dart` 同時檢查已提交世代、目前 entry 與 session 狀態，隱藏或過期輸入不能操作另一個畫面。

宿主以來源世代拒絕舊訂閱的延遲通知；來源替換、初始化失敗與卸載透過 kernel 的生命週期步驟執行器完成清理。個別取消失敗不阻止後續 runtime 釋放或新來源接線，多個錯誤保留各自的原因及堆疊。Widget 來源替換期間的失敗交由 Flutter 錯誤通道回報，讓已提交宿主仍能完成重建。

Router、初始政策、typed entry 結果與平台返回已接入應用程式碼，驗證證據以 [重構進度](../../restructure-progress.md) 為準。網址、深連結、還原、完整環境／語系／能力策略及正式預設風格仍待完成。此入口仍屬 Klp 實驗契約，不代表整庫遷移完成。詳細提交規則見 [導覽交易](../../navigation-transaction-prototype.md)。
