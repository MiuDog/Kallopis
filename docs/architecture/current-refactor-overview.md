# Kallopis 重構架構現況

本頁給專案擁有者與接手者閱讀：先理解目前已接通的責任分層，再辨認尚未完成的架構。這是現況索引；規劃以 [遷移計畫](restructure-migration-plan.md) 為準，歷次驗證以 [進度紀錄](restructure-progress.md) 為準。

Router 應用入口、typed input、初始 guard、平台返回、保留頁交易、中立 stack 還原、單頁 platform URI 雙向同步、具名畫面語意及受控環境策略已接通；環境策略後完整 root 1,064 例通過，root／example analyze 無問題。Windows build 通過，多頁實機互動與實際瀏覽器 history 未驗收。品牌已確定保留 Kallopis，宣告式 API 統一 Klp 前綴，從 `kallopis_declarative.dart` 隔離匯出。舊 Flutter 實作仍存在，但已依責任收納在新架構根下；尚未宣告 Stable。完整驗證證據見進度紀錄。

## 已存在的目錄與責任

以下是實際目錄。目錄存在不等於該層已完成；`legacy` 或 `widgets` 子目錄保存尚未轉換的 Flutter 實作，不能視為新宣告式 API。

```text
lib/
├── kallopis*.dart                  舊公開入口，仍保留
├── kallopis_declarative.dart      新架構隔離試作入口
└── src/
	├── application/
	│   ├── bootstrap/             runKlpApp、內部宿主與 adapter 組合
	│   ├── legacy/                舊 KlpApp 組合根
	│   ├── localization/          語系接線
	│   └── structure/             KlpApplication、KlpScreen
    ├── kernel/
    │   ├── diagnostics/           契約錯誤
    │   ├── identity/              識別規則
    │   └── lifecycle/             清理與錯誤收集
    ├── composition/
    │   ├── definitions/           元件定義與相依
    │   ├── nodes/                 節點與複合節點介面
    │   ├── slots/                 合格子項、插槽與唯一 children 結構
    │   ├── registry/              註冊與引用驗證
    │   └── validation/            整樹驗證及不可變快照
	├── styling/
	│   ├── legacy_theme/          舊 Flutter ThemeExtension 實作
	│   ├── legacy_tokens/         舊 primitive 實作
	│   ├── presets/legacy/        舊預設 recipe
    │   ├── primitives/            固定結構、整套替換的原料
    │   ├── references/            有型別的風格參照
    │   ├── semantics/             自訂元件用途定義與引用權限
    │   └── resolution/            庫內解析
	├── foundation/
	│   ├── content/               舊文字呈現實作
	│   ├── interaction/           共用互動與鍵盤實作
	│   ├── layout/                舊布局實作
	│   ├── surface/               表面與裝飾呈現實作
    │   ├── definitions/           外部元件定義
    │   ├── templates/             封閉文字、線性、表面、子插槽模板
    │   └── binding/               模板準備與封閉呈現資料
    ├── capabilities/
    │   ├── state/                 唯讀來源與可變資料擁有端
    │   ├── controllers/           借用狀態的控制器基礎
    │   ├── data/                  非同步資料與取消／世代判定
    │   └── navigation/            已接入 Router、stack 還原與單頁 platform URI 雙向同步；實際 history 與完整 stack URL 待完成
	├── features/
	│   ├── actions/               按鈕、命令與操作列
	│   ├── collections/           資料與集合呈現
	│   ├── feedback/              回饋與 workflow 呈現
	│   ├── forms/                 表單與輸入功能
	│   ├── infinite_canvas/       畫布候選實作
	│   ├── navigation/            Rail、新宣告與既有可見導覽
	│   ├── overlays/              覆層功能
	│   └── workspace/             Shell、settings 與工作區組合
    ├── runtime/
    │   ├── compilation/           整樹準備、adapter、呈現快照
    │   └── installation/          資源建立、重用、提交與釋放
    └── rendering/
        └── flutter/              庫內 Flutter 呈現與焦點生命週期
```

## 目前實際走通的流程

`KlpState<KlpApplication>` → `runKlpApp` → 結構快照與註冊／資格驗證 → 模板與語意解析 → 資源安裝交易 → 封閉呈現快照 → 庫內 Flutter renderer。

本批應用已改為必填 `KlpApplication.router`，移除單獨的 child 入口；型別化路由 mapper 產生 `KlpScreen`，本庫 session 將保留 entries 組為同一棵樹，已有自動化整合驗證，多頁實機互動未驗收。相同位置及定義可重用資源；準備失敗保留舊畫面，提交新畫面後撤銷舊操作。交易區分提交前失敗與提交後通知／清理錯誤。

外部元件作者在定義期組合受控 foundation 模板、宣告 semantic 參照與子插槽。使用元件時提供資料、合格子項及 callback；不提供 Flutter Widget、Context builder 或實例風格覆寫。型別資格與註冊驗證共同拒絕非法組合。這些限制適用新公開 API，尚未代表舊入口與所有消費專案已封閉。

宣告式 consumer 的 CI 執行 `dart run tool/verify_declarative_consumer.dart example/lib/klp_runtime_demo.dart`。工具以 analyzer AST 拒絕 Flutter、`dart:ui`、`kallopis/src` 與相容入口；產品可用同一指令改檢查自己的單一來源檔或目錄。舊 Catalog 仍是 legacy Flutter consumer，不可用此工具作為宣告式範例。

## 完成程度與剩餘界線

| 領域 | 已驗證內容 | 尚未完成 |
|---|---|---|
| 結構組裝 | 註冊、相依、泛型資格、插槽、巢狀外部元件 | 全庫元件資格與遷移 |
| 風格 | 固定 primitive 結構、整套替換、typed semantic 引用與解析 | schema 凍結、完整平台／狀態／對比演算法、正式預設外觀 |
| 基礎層 | 文字、線性、表面、子插槽模板 | 完整基礎元件及排版能力 |
| 狀態與資料 | 唯讀借用、通知、非同步取消與生命週期 | 各功能自動安裝與領域資料接合的完整契約 |
| 應用與功能 | 單一 screen、rail、外部複合元件、資源自動管理、typed stack 還原、單頁 URI 雙向同步、具名 route semantics；Form 非視覺契約已定義 | 實際瀏覽器 history／完整 stack URL、Form renderer 與筆記／畫布／節點等功能；見[受控 Form 樣板](controlled-form-prototype.md)、[受控導覽還原](controlled-navigation-restoration.md) |
| 無障礙與動畫 | rail 的鍵盤、焦點及語意標籤局部驗證；宿主統一接收系統偏好，關閉動畫不重裝 state | 全域無障礙、減少動態演算法與逐平台元件驗收；見[受控環境策略](controlled-environment-policy.md) |
| 穩定性 | 命名收斂前 root 1,064 例通過，analyze 無問題；先前單頁 Windows 實際操作 | 完整 Verify 尚未通過；example coverage／golden、格式規則衝突待處理，多頁實機尚未驗證 |

目前可確認核心組裝流程已有可操作證據；不能據此宣稱整體架構已穩定。下一個整合關卡是 Router 在 guard 取消、畫面保留與資源提交時仍維持同一套所有權與安裝流程。

第七批的識別調整將 `KlpPlacementId` 分成 scope 各段與 local id，capture／runtime／installation 共用完整識別；callback 仍回傳 local id。只有 internal `KlpScopeBoundary` 可開啟範圍。`KlpBoundRetainedStack` 與 Flutter 呈現器已透過局部測試驗證保留非目前頁的元素，操作資格另由 runtime lease 控制。這些已由 Router session 統一接入應用入口，尚未宣告 Stable。

## 深入閱讀

- [應用與 runtime](application-runtime-prototype.md)：實際安裝流程及生命週期。
- [導覽交易契約](navigation-transaction-prototype.md)：開發中的 Router、取消與保留畫面驗收規格。
- [受控導覽還原](controlled-navigation-restoration.md)：typed codec、堆疊資料與 callback 邊界。
- [外部元件模板](component-template-prototype.md)、[合格子插槽](component-slots-prototype.md)：擴充與組合方式。
- [風格契約](styling-contract-prototype.md)：原料、語意與解析權限。
- [來源圖集](src/README.md)：查目前宣告與依賴，不以 import 圖推斷執行順序。
- [完整遷移計畫](restructure-migration-plan.md)、[驗證與進度](restructure-progress.md)：目標與完成證據分開閱讀。
