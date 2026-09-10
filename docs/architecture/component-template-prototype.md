# 外部元件定義與內容投影樣板

這份文件說明 [風格資料契約](styling-contract-prototype.md) 如何接到外部元件內容。讀者是開發本庫與外部元件的工程師；此頁描述目前 experimental 實作，搭配 [應用接入流程](application-runtime-prototype.md) 與 [合格子插槽](component-slots-prototype.md) 閱讀，不代表全庫遷移已完成。

## 定義與實例分開

| 物件 | 責任 | 可注入內容 |
|---|---|---|
| `KlpComponentDefinition<T>` | 元件作者定義一次 | 型別契約、semantic schema、受控模板 |
| `KlpTemplate<T>` | 定義期組合 foundation | 文字、線性排版、表面、合格子插槽，以及型別化 semantic key |
| `T extends KlpNode` | 每次放置的實例 | 識別、資料、callback 與功能資格 |
| `KlpCompositeNode` | 外部複合元件實例 | 唯一 `KlpChildren` 插槽配置，不另提供子項 selector |
| `KlpRail` | 三區容器結構 | top／center／bottom 的 `KlpRailItem` 清單與選取 callback |
| 內部 compiler | 驗證並投影 | 已驗證定義、實例、完整原料；輸出不可變呈現快照 |

元件作者不需要 `Widget build(Context)`；[定義](../../lib/src/foundation/definitions/klp_component_definition.dart) 的 content 只能是本庫模板，不能是 Widget 或回傳 Widget 的函式。模板不放在實例欄位，因此實例沒有調整顏色、間距、字體或模板的輸入。

定義可選擇 `accessibilityLabel` 資料 selector。它和文字 selector 一樣只接收已驗證的 T 並回傳非空 String；compiler 在資料準備期執行一次，錯誤會保留 placement 與 `accessibilityLabel` 路徑。完成後 renderer 只接收封閉語意結果並建立 semantics container，消費端不能注入 Widget、BuildContext、語意 builder 或局部樣式。

目前公開模板有四種：

- `KlpTextTemplate`：文字資料 selector 與完整文字 semantic 參照。
- `KlpLinearTemplate`：水平／垂直組合、固定子模板與間距參照。
- `KlpSurfaceTemplate`：背景、圓角、內距參照及單一子模板。
- `KlpChildrenTemplate<T, C>`：定義期 `KlpSlot<C>`、排列方向與 semantic 間距；實例以 `slot.assign(items)` 填入合格子項。

它們是封閉 library 的 final 變體，不能被外部實作成自訂渲染器。文字 selector 只接受元件資料，回傳 String；它屬於資料投影，沒有 Context 或風格求值參數。任意 Dart 函式的純度無法由型別系統完全證明，不能將此 API 當成執行不受信任程式碼的沙箱。

## 風格所有權仍由本庫檢查

模板只接受 semantic key，不能直接放 primitive 值、最終 Color 或 raw double。直接使用另一個 owner 的 token，也必須符合「明確相依且目標公開」；不因跳過 alias token 就跳過權限檢查。

[引用解析器](../../lib/src/styling/resolution/internal/klp_semantic_resolver.dart) 的共用規則同時處理 token alias 與模板使用，核對真正註冊的目標 kind、owner 及公開性。元件定義建立完成後，內部 compiler 在執行任何資料 selector 前先驗證所有模板參照。

rail adapter 已將本庫選取狀態、選取背景、焦點線及操作資格組成內部選項呈現，項目內容由其自身定義投影。Flutter renderer 只讀已解析結果；父容器不接受消費端傳入的選取／焦點風格。完整互動狀態、環境及動畫策略仍待遷移。

## 呈現快照

[KlpComponentCompiler](../../lib/src/foundation/binding/internal/klp_component_compiler.dart) 只供本庫內部接線，沒有公開匯出。流程是：完整定義及用途圖驗證 → 一次結構擷取 → 檢查實例、子模板與插槽範圍 → 完整風格求值 → 資料 selector 投影為 `KlpPreparedComponent` → 資源安裝 → 嵌入已完成子呈現，產生 `KlpBoundComponent`。`prepareCaptured` 使用已擷取資料，renderer 不接收尚未填入的子插槽。

模板的泛型提升不代表它能接受更廣的資料。文字 selector 保存在模板的私有欄位，透過保留型別檢查的方法呼叫；compiler 在任何 selector 前先檢查所有子模板，避免較晚才發現其中一個模板只接受另一種資料。

結果保留放置 id、定義 id、文字值及封閉的已解析結構；不保存消費端 selector 供 renderer 稍後執行。後續資料或整套原料改變時可產生新快照，既有快照不變。selector 失敗包含放置、模板路徑、原始錯誤及 stack trace。

沒有子插槽的模板仍拒絕非空實例 children。複合模板的 schema 由模板遍歷自動產生；每個 slot 必須恰好出現一次，實例的所有 assignment 依 schema 順序完整提供。不能偽造同名 slot、重複配置或靜默漏掉子項。具體介面與錯誤邊界見 [合格子插槽](component-slots-prototype.md)。

## Rail 的型別邊界

[KlpRailItem](../../lib/src/features/navigation/rail/contracts/klp_rail_item.dart) 是可由外部實作的資格介面，提供無障礙名稱與可為空的操作 callback。元件可以同時符合其他介面。

[KlpRail](../../lib/src/features/navigation/rail/contracts/klp_rail.dart) 的三區各自只接受 `List<KlpRailItem>`，一般 `KlpNode` 或 Flutter Widget 不符合資格。建構時封存三區清單及展開順序；重複放置 id 與結構循環由 registry 檢查。

三區現在使用與外部複合元件相同的 `KlpChildren`／slot 驗證。callback 不在建構時執行；安裝後由本庫持有選取狀態，renderer 支援滑鼠、Enter／Space、焦點及語意操作。空白無障礙名稱在資料準備期拒絕。跨群組拖曳排序及完整無障礙支援矩陣仍未完成。

## 應用接入與剩餘範圍

公開接入是 `runKlpApp(KlpState<KlpApplication> source)`。`KlpApplication` 保存 title、完整 primitives、必填 `KlpRouter router` 與自訂 components；單畫面也由路由 mapper 產生 `KlpScreen`，不保留另一個 child 入口。本庫合併 builtin 定義、拒絕覆蓋並自動安裝資源。消費端只更新來源資料，無須呼叫 internal compiler 或建立 Widget 宿主。

已完成呈現以 `KlpBoundPlacement` 保存位置識別，支援同層重排及風格更新時延續 Flutter element；任意跨父容器移動的焦點保留未查證。Router entry 操作與保留頁已接入程式碼，驗證狀態見 [導覽交易](navigation-transaction-prototype.md) 與進度紀錄。網址／深連結／還原、環境策略、能力支援矩陣、其他功能遷移及正式預設風格仍待完成。

本批沒有重新定義正式預設視覺。驗收證據與剩餘範圍見 [遷移進度](restructure-progress.md)。
