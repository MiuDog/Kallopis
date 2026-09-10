# Kallopis 已確認架構方向

狀態：confirmed direction，2026-09-09；implementation in progress。使用者要求重構後再重定義正式預設風格與新增／修改元件，本批不建立新視覺期待。

唯一規劃來源：[架構與遷移計畫](../../../../../docs/architecture/restructure-migration-plan.md)。此頁記錄新方向在設計知識樹的適用入口，不複製全部規格。

新方向修訂：消費端只以一套總體結構樹注入資料／callback／合法子項；外部元件以本庫公開 foundation 組合並實作指定資格介面，基礎元件仍掌管風格與渲染。無 build(Context)、raw Widget 或局部 style 逃生口。Primitive schema 固定整套替換；自訂 semantic 參照屬於定義階段，本庫控制求值。Features 允許笔記等通用功能，不因只有一個產品使用而拒絕。

本庫負責註冊解析、預設 state/controller、平台策略與安裝／卸載。仍需實作與驗證，不能用方向確認冒充機制已完成。Krepis 資料權威未移轉；原視覺規則在 Klp 舊實作保留到各批遷移。與此頁衝突的舊組合及風格輸入規則，只適用舊 Klp API，不作新 Klp API 的例外出口。

首條實際流程的三種架構、屬性權限與驗收界線見 [應用 runtime 樣板](../../../../../docs/architecture/application-runtime-prototype.md)。其 primitive 映射屬於架構試作，不是使用者已確認的新預設外觀。元件生命週期驗證不凍結整體 screen 布局。

外部複合元件沿用同一條資料、風格及安裝權威；[合格子插槽樣板](../../../../../docs/architecture/component-slots-prototype.md) 記錄單一 children 快照、型別／數量／身分驗證及三種架構。這是既有可擴充元件要求的實作，不新增消費端 renderer 或局部風格出口。

Router 與保留畫面的實作契約見 [導覽交易樣板](../../../../../docs/architecture/navigation-transaction-prototype.md)。目前進行可見性、焦點、語意與資源生命週期整合；沿用既有畫面內容與風格解析，不建立新的正式外觀期待，且不以局部核心測試當成完整 Router 已完成。

命名界線：品牌已確定保留 Kallopis，宣告式 API 使用 Klp 前綴與 kallopis_declarative.dart。新舊 API 依公開 library 可達性區分，不依 Klp 前綴；既有資料夾與 GitHub 倉庫不改名。
