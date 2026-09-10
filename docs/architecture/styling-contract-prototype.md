# 風格資料契約樣板

供維護新架構與開發外部元件介面的工程師閱讀。此頁描述已實作的純資料契約，不是正式預設風格或 Stable API；整體目標與剩餘工作仍以 [遷移計畫](restructure-migration-plan.md) 為準。

## 所有權

| 階段 | 輸入者 | 允許的內容 | 本庫檢查 |
|---|---|---|---|
| 根風格資料 | 消費端 | 一份完整 `KlpPrimitiveSet` | 固定種類、固定槽數、合法量值、不可變快照 |
| 元件定義 | 元件開發者 | `KlpSemanticSchema` 的用途名稱、同型參照與引用公開性 | owner 綁定定義、唯一名稱、型別與引用權限 |
| 元件實例 | 消費端 | 後续 foundation／feature 定義的資料與 callback | 本批尚未提供正式 foundation 實例 |
| 求值 | 本庫內部 | 原料與已驗證參照圖 | 封閉求值，不執行外部函式 |

`KlpDefinition.semantics.owner` 必須等於定義 id；語意依賴自動納入定義相依，不要求消費端在兩处重複接線。`KlpRegistry` 在接受完整定義集合時就驗證所有參照；尚未放入任何畫面節點，也能拒絕錯誤定義。

## 原料表達

[primitives](../../lib/src/styling/primitives/klp_primitive_set.dart) 必填十一類資料：顏色、距離、圓角半徑、描邊寬、字級、字重、行高倍率、字距、時長、字族與曲線控制點。每類暫用八個固定索引槽；沒有 `selected`、`surface`、`danger` 等用途或平台名稱。

- `KlpStyleValue` 是 sealed library，各實際值都是 final；`KlpStyleKind` 只由本庫提供固定實例。
- 集合先複製再驗證，不能在確認長度後另讀已變動的來源。
- 非有限數、非法通道值、非正字級／行高及未修整的空白字族等，以 release 仍生效的檢查拒絕；不依賴 assert。
- 色彩採整數 RGBA；字族是字族名稱及 fallback 順序；曲線是受驗證的三次貝茲控制點。沒有 Flutter 型別或求值 callback。

八槽是目前試作 schema 的固定界線，不是已證明能涵蓋全庫的結論。兩套測試原料用於確認整套替換及型別表達；在 rail 完整流程、字體資產及支援矩陣驗證前，不凍結為 v1。消費端不能自行加第九槽；若本庫後續調整 schema，需一併修改契約與遷移規則。

## 用途與參照

[KlpSemanticKey](../../lib/src/styling/semantics/klp_semantic_key.dart) 以 `(owner, name)` 識別用途，kind 表示量值種類。同名但不同 kind 仍是重複，不會成為兩個合法 token。

目前定義 id／semantic owner／name 採 ASCII 識別樣板 `[A-Za-z][A-Za-z0-9_.-]*`，拒絕空白與路徑分隔符；這是本批 experimental 契約的收窄，不是從使用者對命名的偏好推導。放置 id 仍維持原有非空規則，不受此識別樣板限制。正式 schema 凍結前需連同外部元件流程評估。

[KlpStyleRef](../../lib/src/styling/references/klp_style_ref.dart) 目前只有兩種封閉參照：

1. `KlpPrimitiveRef`：同型原料槽。
2. `KlpSemanticRef`：同型用途。跨 owner 時，必須直接宣告相依且目標 token 公開；公開只授權引用，不授權覆寫。

泛型可以提升為共同基底，因此 token 建構時仍檢查 kind。解析時再核對真正註冊目標的 kind，拒絕引用者另建同名但不同型別的假 key。識別使用結構化 pair；診斷路径不作查找 key。

## 本庫求值

[KlpSemanticResolver](../../lib/src/styling/resolution/internal/klp_semantic_resolver.dart) 與結果快照位於 internal，沒有從公開入口匯出。

處理順序為：建立 owner／token 索引 → 檢查 schema 相依 → 驗證 token 引用、型別及可見性 → 依引用順序編譯 → 從完整原料求值。

schema 相依與 token 引用各自檢查循環，即使尚未使用的相依也不能形成環。錯誤包含用途或相依路徑。求值只讀取原料或已求值的同型引用，不使用「最後註冊者覆蓋」或缺漏時補預設值的規則。

同一 resolver 可對兩套完整原料求值，產生獨立不可變結果；舊結果保持原值。此證據只涵蓋風格資料，不等於換風格時已驗證畫面狀態不重置。

## 尚未完成的界線

- renderer、正式 foundation／rail 組裝、容器與子項各屬性的實際使用權限仍待接上；命名空間驗證本身不能保證呈現所有權。
- 本庫尚未出貨新 builtin semantic schema，未建立預設色彩混合、對比、環境、無障礙或動態政策；目前求值僅原料引用與同型用途引用。
- 字體名稱的合法性不代表字體資產已安裝或可載入；renderer／資產註冊仍須處理。
- 完整原料目前透過具型別建構子注入，尚無 JSON 匯入格式；不得將不接受額外 constructor 參數的檢查當成已驗證 JSON schema。

驗證與原始紀錄索引見 [遷移進度](restructure-progress.md)。
