# CM-01 驗證與剩餘範圍

全面遷移：**未完成**。舊版刪除：**未執行**。

## 已交付程式

- 新 `KlpMenu`／`KlpMenuItem`：純 Dart 宣告、封閉 adapter、不可變 bound 資料、lease 事件保護、新 renderer 與公開入口。
- 幾何配方沿用舊 Menu；hover／selected 同色及既有新版圖示保持。不引用舊 Menu Widget，不建立另一份 theme。
- 新 Catalog 入口 `example/lib/catalog_menu_main.dart`；舊 Catalog 過期 appIcon 呼叫已修正，沒有刪減 specimen。
- 既有 `KlpWorkspaceToolbarAlignment` 補登公開 metadata；不是新增外觀或功能。

## 已觀察證據

| 檢查 | 結果 |
| --- | --- |
| 新 Menu 行為測試 | 6/6 通過；公開 application 真實掛載，指標／鍵盤、disabled、狀態、過期 callback |
| Application catalog 契約 | 11/11 通過；25 features、23 public、29 definitions、84 feature exports，包含既有漏登的 toolbar enum |
| 宣告式公開 API 隔離 | 1/1 通過 |
| 固定清冊與遷移證據檢查 | 7/7 通過；只證明記錄完整且誠實，不代表全庫完成 |
| 完成模式 | 未達成；251 項仍 pending，禁止 complete／全面刪除 |
| 局部 analyzer | 新宣告／adapter／recipe／renderer／specimen 無問題 |
| consumer 邊界檢查 | 新 specimen 通過 |
| Web debug build | `-t lib/catalog_menu_main.dart` 成功 |
| 瀏覽器操作 | 實際顯示面板；點擊 toggle 後標頭與指示更新；Home＋Enter 觸發第一個可執行項 |
| 感官／全平台驗收 | human-pending；未宣稱已經使用者接受或Windows原生已驗收 |

## 固定分母

32頁、211個specimen（210個有 builder，包含占位情況，不能等同210個完整互動）、43個間接covered元件，共254個唯一元件。清冊固定於起始 snapshot，不能靠刪除舊 Catalog 讓分母縮小。

目前2項有新程式與行為證據，1項既有Explorer保留，251項待逐項核對與遷移。已接受的其他新版能力仍保留；pending也可能是尚待建立對應的既有新版能力，不代表全部要重寫。

## 繼續工作

先核對其餘已接受新版元件的合法替代組裝與清冊對應，再依舊 Catalog 家族遷移。下一個選單工作是 ContextMenu／CommandMenu／Popup 的新資料式定位與觸發，接通目前仍依賴舊 Menu 的工作區命令；不可刪掉這些依賴或用新展示入口冒充它們已完成。

其餘家族仍屬本次完整目標：操作與回饋、表單／選擇與表單組裝、集合／資料、導覽／設定、工作區通用功能與基礎組裝替代。每項要有公開 API、真實 Catalog、資料／事件與驗證證據；全部完成後移除舊入口與專用實作，檢查所有呼叫端及必要的既有CI／發布閘門。

Test Author 擁有基準與測試。舊 registry 最終移除時，需由 Test Author 改成以固定基準對新版實際目錄檢查，保留同一254項分母與強制完成模式，不允許直接刪除完整性測試。
