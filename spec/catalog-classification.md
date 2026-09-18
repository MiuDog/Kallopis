# Catalog 分類與 module 歸屬前置規格

擁有語意：Catalog taxonomy（文件與遷移治理，不是 runtime module）
階段：DEFINE／0→1
目標階段：`CAT-TAX-01`
狀態：DEFINE READY；使用者於 2026-09-18 接受 18 個第一層分類、單一 primary／多個 secondary tags，以及資料／功能群組注入與語意原子受控組合邊界
能力地平線：固定 254 項先完成重新分類，再形成能力家族、公開處置與 module ownership；之後才恢復逐家族遷移。

## 目標與動機

Catalog 必須先回答 consumer「我要完成哪一類產品工作」，不能從舊頁面、class 名稱、目前資料夾或既有 module 反推分類。分類與 module ownership 是兩種不同資訊：分類服務發現與學習；module ownership 服務架構責任與依賴方向。

固定 254 項分母、既有 migration evidence 與已接受新版外觀保持不變。重新分類不代表新增 254 個新版 class，也不能讓 `merge`、改名或刪頁縮小分母。

## 需求與決策

| ID | 目標版本 | 優先級 | 需求或決策 | 可觀察驗收 | 狀態 |
| --- | --- | --- | --- | --- | --- |
| TAX-01 | CAT-TAX-01 | P1 | 分類依 consumer 產品意圖，不依現有資料夾、架構層或舊 Catalog 頁面。 | 每項分類理由能以「consumer 用它完成什麼」描述；移動原始碼不改變分類。 | accepted |
| TAX-02 | CAT-TAX-01 | P1 | 分類、能力家族、公開處置、module ownership 分階段決定。 | 逐項資料在分類接受前沒有正式 owner；module 欄位不能作為分類輸入。 | accepted |
| TAX-03 | CAT-TAX-01 | P1 | 採用本規格經 254 項壓力測試後提出的 18 個第一層分類。 | 254 項各有且只有一個 primary category；無法歸類者必須回到分類定義，不得用 `misc`。 | accepted |
| TAX-04 | CAT-TAX-01 | P1 | 跨用途項目採一個 primary category 加零至多個 secondary tags；primary 依主要 consumer 任務決定。 | 同一項不複製計數；secondary tag 不產生第二個 owner 或第二份公開 API。 | accepted |
| TAX-05 | CAT-TAX-01 | P1 | 每項另標記 catalog role，區分可直接選用能力與應被吸收的實作材料。 | 低階 layout／interaction／surface class 不會只因有 demo 就被當成新版公開元件承諾。 | accepted |
| TAX-06 | CAT-TAX-01 | P1 | 固定 254 項全部完成分類與理由後，才允許建立能力家族與 module ownership。 | 有機械檢查證明 254/254 皆具合法 primary category、role、consumer intent 與來源；owner 欄仍為空。 | accepted |
| TAX-07 | CAT-TAX-01 | P1 | 已完成的 `KlpMenu`、`KlpMenuItem` 與 `KlpExplorer` 證據保留，但也要納入新分類。 | coverage 維持 2 migrated、1 preserved、251 pending；重新分類不回退程式或視覺接受結果。 | accepted |
| TAX-08 | CAT-TAX-02 | P1 | 分類完成後，以能力家族的不變資料、事件、合法組裝與生命週期決定單一 owning module。 | 每個家族只有一個 owner；styling、rendering、application 等支援責任另外列出，不以多 owner 模糊權威。 | accepted |
| TAX-09 | CAT-TAX-02 | P1 | 公開處置只能在能力家族形成後決定為 preserve、migrate、absorb、replace 或 retire。 | 每個固定項目都有去向及新版公開對應；`absorb/replace/retire` 仍保留固定清冊證據。 | accepted |
| TAX-10 | CAT-TAX-03 | P1 | 所有分類、家族、處置與 module mapping 接受後，才恢復 Catalog migration BUILD。 | Task Packet 能引用已接受的 category、family、owner 與 public target，不再從同名 class 猜測責任。 | accepted |
| TAX-11 | CAT-TAX-01 | P1 | Consumer 注入語意資料、狀態、事件與定義好的功能性群組；Kallopis 擁有由這些輸入產生的具體元件樹、視覺佈局與風格。`Column`、`Row`、`Stack`、`Align`、`Gap`、`Spacer`、`Flex`、座標定位及幾何 transform 等基底排列材料一律為內部實作。 | Consumer 不需也不能以空間排列 primitive 或任意子元件建立畫面；宣告式公開入口最終不可達上述基底材料。 | accepted |
| TAX-12 | CAT-TAX-01 | P1 | 公開佈局容器只負責呈現已定義的功能性群組，且只能接受具名、具型別的群組資料／role；Kallopis 固定群組內部元件、數量限制、次序、巢狀、響應規則與視覺規範。不得接受任意節點清單、raw flex、gap、alignment、尺寸或座標。 | 每個保留的 layout contract 都能說明承載哪些功能群組與合法 role；consumer 不能透過它重建 Flutter 式 widget composition。 | accepted |
| TAX-13 | CAT-TAX-01 | P1 | 不普遍要求一份資料支援多種 view。某能力若確實提供替代呈現，才以封閉的語意 view 選項重用同一資料、識別、選取、動作與事件契約；若只提供一種 Kallopis 決定的呈現也完全合法。 | 沒有 view 切換的能力不因此不合格；有 view 切換時 consumer 只選語意選項，不重新組裝低階節點。 | accepted |
| TAX-14 | CAT-TAX-01 | P1 | 獨立公開能力由資料、功能群組、事件與互動不變條件判斷，不由畫面形狀或舊 class 名稱判斷。內部 renderer 可使用受風格約束的基底 layout；List、Grid、Tree、Table 等名稱須逐項判斷是語意能力、可選 view 或純 renderer。 | 每個公開 family 能指出自身資料／功能群組／事件契約；內部使用 `Column` 等不產生公開 API 或 customization escape hatch。 | accepted |
| TAX-15 | CAT-TAX-01 | P1 | 保留「語意原子」的受控組合能力：consumer 可依契約選用、排序及提供功能資料，但只能放入 Kallopis 定義的 typed group 與 layout role；不得組合視覺 primitive 或任意節點。 | Consumer 能由小型功能單位組成合法產品區域；非法父子、角色、數量與巢狀在型別層不可表達或於 capture 時拒絕，實際 axis、flex、spacing、wrapping 與 responsive layout 全由 Kallopis 決定。 | accepted |

## 公開語意邊界

分類名稱回答「consumer 要完成什麼」，不回答「畫面用什麼 Flutter 形狀排出來」。因此 `KlpColumn` 即使具有一致間距，也仍只是在描述垂直排列；它沒有功能群組語意，不得成為 consumer 的組裝工具。相同判準適用於其他 primitive、surface、interaction helper 與只描述呈現形狀的舊 class。

核心所有權規則是：consumer 擁有產品資料與要啟用的功能；Kallopis 擁有如何把資料與功能群組投影成具體元件樹。公開 API 可以讓 consumer 注入數層定義好的功能性群組，但每層都是封閉資料模型或具型別 role，不是 `KlpNode`、Widget、builder 或任意 children。佈局容器只安排這些群組，不把其內部組裝權交回 consumer。

功能群組也不能退化成 data 版本的 Widget tree。不得提供可任意遞迴的 `Group(children: ...)`、通用 axis／flex／spacing 或讓 consumer 自訂群組內元件清單；否則只是把 Flutter composition 換成另一套語法。群組應由各能力命名並限制內容，例如 header、navigation、content、actions 或 form section，實際允許哪些角色由該能力契約逐一規定。

採用三層受控組合，而不是零組合或自由組合：

1. 語意原子：action、field、navigation destination、data item 等資料與事件描述；可保留身分、是否啟用及語意順序。
2. 功能群組：action group、form section、navigation group 等能力專屬 schema；決定哪些原子可共同工作，不描述 Row／Column。
3. 語意 layout role：header、navigation、content、actions、sidebar 等產品無關位置；只承載契約允許的功能群組，由 Kallopis 投影成實際元件樹。

「順序」只有在代表工作流程、優先級或閱讀次序時由 consumer 提供；水平／垂直、間距、尺寸、換行、對齊與響應切換不是語意順序，仍由 Kallopis 擁有。如此保留功能原子性，而不讓公開 API 變成另一套 Flutter layout DSL。

公開候選必須通過下列順序：

1. 先證明它具有不依賴 class 名稱、Flutter widget 或幾何形狀的 consumer intent。
2. 若它是資料能力，公開資料身分、狀態、選取、動作、事件與定義好的功能群組；Kallopis 決定群組對應的內部元件及所有視覺值。
3. 若它是 layout，必須代表可獨立命名的產品無關區域或工作區關係，並只接受具名、具型別、數量受限的群組資料／role。
4. 若它只提供排列、裝飾、命中區、效能虛擬化或 renderer 技術，就標為 `implementation-material`，由語意能力在內部使用。

多 view 不是公開能力的必要條件。Tree 需要階層與展開不變條件、Table 需要欄位 schema、Timeline 需要時間關係、Canvas 需要空間座標與縮放模型；若差異改變資料、功能群組或事件契約，應建立不同語意 family。只有在同一能力確實要支援多種呈現時，List／Grid／Masonry 等才考慮成為封閉 view 選項；否則 Kallopis 可只提供單一核准呈現。

### 判定例

| 舊項目或形狀 | 判定方向 | 理由 |
| --- | --- | --- |
| `KlpColumn`、`KlpRow`、`KlpStack`、`KlpGap`、`KlpSpacer` | absorb 為內部材料 | 只描述排列方式，consumer intent 不成立。 |
| `KlpVirtualList`、`KlpVirtualGrid`、`KlpMasonryGrid` | 依資料／群組／事件契約判定 | 可能是獨立語意能力、同能力的可選 view 或純 renderer；不能只依形狀或舊 class 決定，也不強迫合併。 |
| `KlpTree`、`KlpDataTable` | 可形成不同語意 family | 階層展開與欄列 schema 具有不同資料及互動不變條件。 |
| Split、Dock、Panel、Region 類 | 逐項證明後才可公開 | 只有代表獨立工作區關係且只承載定義好的功能群組／typed roles 的項目可作公開 layout；任意 children 或 raw geometry 不合格。 |
| 內部 renderer 使用 `Column` | 允許 | Kallopis 仍掌管間距、響應、風格與合法組裝，consumer 不可達。 |

## 第一層分類提案

第一層只服務 consumer 導航，不等同 Dart library、資料夾或 module。每項仍可透過第二層能力家族縮小到具體用途。

| ID | 分類 | Consumer 問題 | 包含範圍 | 不以此分類的情況 |
| --- | --- | --- | --- | --- |
| `CAT-APP` | 應用與工作區 | 如何建立 app、screen、window 與主要工作區？ | app root、screen、window chrome、workspace shell、主要 pane | 純排列工具進 `CAT-LAYOUT`；跨平台規則進 `CAT-SYSTEM` |
| `CAT-LAYOUT` | 布局與組成 | 如何安排區域、容器、分割、捲動與響應結構？ | row／column、frame、surface、split、resize、dock、region | 具明確業務意圖的完整 workspace view 不放這裡 |
| `CAT-NAV` | 導覽與探索 | 如何前往、切換或探索另一個位置／內容？ | tabs、rail、sidebar navigation、breadcrumb、pagination、Explorer 導覽用途 | 查詢、篩選與排序進 `CAT-SEARCH`；資料集合本身進 `CAT-DATA` |
| `CAT-ACTION` | 動作與命令 | 如何讓使用者觸發、選擇或批次執行操作？ | button、toolbar、command、menu action、selection action | 欄位值輸入進 `CAT-FORM`；暫態承載表面進 `CAT-OVERLAY` |
| `CAT-DATA` | 資料與集合 | 如何呈現、選取或瀏覽結構化資料？ | list、tree、table、grid、card、badge、avatar、metric | 查詢與排序進 `CAT-SEARCH`；時間規劃 view 進 `CAT-PLAN`；圖表進 `CAT-CHART` |
| `CAT-SEARCH` | 搜尋與篩選 | 如何查找、縮小、排序並定位資料或命令？ | search input、filter、sort、result navigation、command lookup | 導覽結構進 `CAT-NAV`；底層集合與 selection 進 `CAT-DATA` |
| `CAT-FORM` | 表單與輸入 | 如何輸入、編輯、驗證與提交結構化值？ | field、text／number／date input、selection、form assembly、picker | 文件正文編輯進 `CAT-DOC`；檔案生命週期進 `CAT-FILE` |
| `CAT-FEEDBACK` | 狀態與回饋 | 如何表達 loading、empty、error、permission、progress 與結果？ | view state、notice、toast、progress、skeleton、status | 不把單一控制的 hover／focus 拆成獨立項目 |
| `CAT-OVERLAY` | 浮層與暫態介面 | 如何在目前上下文上顯示暫態內容？ | dialog、popover、tooltip、context menu、drawer、modal、overlay host | 內部 surface primitive 只標 role，不自動成為公開能力 |
| `CAT-DOC` | 文件、內容與編輯 | 如何閱讀、編輯與組織筆記、長文、程式碼與引用？ | prose、rich text、document section、editor host、code/diff | 檔案選取與資產解析進 `CAT-FILE` |
| `CAT-PLAN` | 規劃與時間 | 如何處理日期、排程、任務、流程與時間軸？ | calendar、schedule、task、board、timeline、stepper、workflow | 一般集合控制仍進 `CAT-DATA` |
| `CAT-SETTINGS` | 設定與偏好 | 如何瀏覽、搜尋與修改 app 或工作區偏好？ | settings page、scope、navigation、field、action、theme preference | 泛用欄位仍進 `CAT-FORM`；視覺規格與 token 工具進 `CAT-VISUAL` |
| `CAT-FILE` | 檔案與資產 | 如何選取、預覽、解析、拖放或附加檔案資產？ | file field、dropzone、preview、asset resolution、file explorer 資產用途 | 一般樹狀導覽進 `CAT-NAV` |
| `CAT-COLLAB` | 溝通與協作 | 如何呈現訊息、討論、presence、mention 與協作狀態？ | conversation、thread、composer、presence、comment | session、權限、同步與身分權威仍由產品擁有 |
| `CAT-CANVAS` | 畫布、圖解與手寫 | 如何在空間畫布上選取、繪製、連接或手寫？ | infinite canvas、diagram、node、minimap、stroke、tool | 一般拖放只作 secondary system tag |
| `CAT-CHART` | 圖表與資料視覺化 | 如何把數值資料轉為可探索的視覺表達？ | chart、axis、legend、series、selection、zoom、a11y summary | metric card 屬 `CAT-DATA`，除非其主要任務是圖表探索 |
| `CAT-SYSTEM` | 無障礙、輸入與平台適應 | 如何保證鍵盤、焦點、語意、IME、pointer 與平台差異？ | accessibility、focus、key binding、drag/drop mechanics、adaptive platform、window host | 通常作 secondary tag；只有直接面向該任務的清冊項才作 primary |
| `CAT-VISUAL` | 視覺語言與體驗 | 如何理解品牌、token、文字、surface、狀態與動畫規範？ | token view、theme preview、色彩工具、visual contract artifact | consumer 不取得 style override；一般元件的外觀仍留在其主要功能分類 |

## 固定清冊壓力測試

現有舊對照把 254 項分成 25 個能力 ID；它只用來檢查新分類是否有缺口，不作分類權威。18 類能承接所有舊 ID，但下列群組證明不能直接整組搬運：

| 舊群組 | 代表項目 | 新分類時必須拆分的原因 |
| --- | --- | --- |
| `OVR-MENU` | `KlpMenu`、`KlpMenuItem` | 主要任務是選擇／執行動作，建議 primary 為 `CAT-ACTION`；浮層只作 secondary tag。 |
| `SEARCH-FILTER` | `KlpFilterBar`、`KlpSearchNavigator`、`KlpSettingsSearchField`、`KlpSortControl` | 前三者分別可能服務資料、全域尋找或設定；新增 `CAT-SEARCH` 讓主要查詢任務有一致入口，設定專用項仍可歸 `CAT-SETTINGS`。 |
| `WKS-BLOCKS` | 九個 `KlpSettings*` 項目 | 舊名把設定功能誤當 workspace block；其 consumer 任務其實是設定與偏好，因此新增 `CAT-SETTINGS`。 |
| `WKS-WINDOW` | `KlpWindowControls`、`KlpWindowHeaderMacLayout` | 前者是 app/window 任務；平台 layout 多半是 implementation material 或 system contract，不能因同一舊群組得到相同公開處置。 |
| `FORM-SELECTION` | `KlpDateField`、`KlpOklchColorEditor`、`KlpThemeModePicker` | 日期值輸入、視覺設計工具、使用者偏好雖都有 selection UI，consumer 任務不同。 |
| `STYLE-EXPERIENCE` | `KlpIcon`、`KlpText`、`KlpThemePreviewTile`、`KlpDashedBorder` | 一般內容能力、Catalog artifact 與低階視覺材料必須靠 role 分開，不能全部承諾為可自訂 style API。 |
| `ACCESS-INPUT` | `KlpShortcutHint`、`KlpFocusBoundary`、`KlpDragPreview` | 可見提示、系統契約與 implementation material 需分別判斷 primary 與 role；多數跨切面性質只作 secondary tag。 |

這個檢查也支持單一 primary：若讓每項同時屬於多個第一層分類，Menu、日期欄位、檔案 Explorer、theme picker 與 window controls 都會重複出現在多處，無法維持 254 項的一對一審核，也會再次把分類誤當多 module ownership。

### 25 個舊能力群組的覆蓋投影

下表覆蓋舊對照中的全部 254 項。`直接`只表示群組意圖大致單一，仍須逐項寫 consumer intent；`拆分`表示不能整組搬入同一分類。候選分類不等於正式 assignment。

| 舊能力 ID | 項數 | 候選分類 | 結果 |
| --- | ---: | --- | --- |
| `ACCESS-INPUT` | 15 | `CAT-SYSTEM`、個別 `CAT-ACTION` | 拆分 |
| `ACT-CONTROLS` | 10 | `CAT-ACTION` | 直接 |
| `APP-ADAPT` | 1 | `CAT-SYSTEM` | 直接 |
| `APP-NAV` | 1 | `CAT-NAV` | 直接 |
| `APP-ROOT` | 1 | `CAT-APP` | 直接 |
| `CANVAS-DRAWING` | 7 | `CAT-CANVAS` | 直接 |
| `COMM-COLLAB` | 5 | `CAT-COLLAB` | 直接 |
| `DATA-COLLECTIONS` | 15 | `CAT-DATA`、個別 `CAT-DOC` | 拆分 |
| `FEEDBACK-STATES` | 17 | `CAT-FEEDBACK` | 直接 |
| `FILE-ASSET` | 8 | `CAT-FILE` | 直接 |
| `FORM-INPUT` | 24 | `CAT-FORM`、個別 `CAT-FILE` | 拆分 |
| `FORM-SELECTION` | 21 | `CAT-FORM`、`CAT-VISUAL`、`CAT-SETTINGS` | 拆分 |
| `LAY-WORKSPACE` | 39 | `CAT-LAYOUT`、個別 `CAT-APP` | 拆分 |
| `NAV-SHELL` | 15 | `CAT-NAV` | 直接 |
| `NOTE-CONTENT` | 12 | `CAT-DOC` | 直接 |
| `OVERLAY-SURFACES` | 11 | `CAT-OVERLAY` | 直接 |
| `OVR-MENU` | 2 | `CAT-ACTION`，secondary `CAT-OVERLAY` | 直接但更換主分類 |
| `PLAN-VIEWS` | 8 | `CAT-PLAN` | 直接 |
| `SEARCH-FILTER` | 4 | `CAT-SEARCH`、個別 `CAT-SETTINGS` | 拆分 |
| `STYLE-EXPERIENCE` | 19 | `CAT-VISUAL`、`CAT-LAYOUT`、`CAT-DOC`、`CAT-SETTINGS` | 拆分 |
| `VIS-CHARTS` | 1 | `CAT-CHART` | 直接 |
| `WKS-BLOCKS` | 9 | `CAT-SETTINGS` | 直接但修正舊語意 |
| `WKS-EXPLORER` | 1 | `CAT-NAV`，secondary `CAT-FILE` | 直接 |
| `WKS-TABS` | 2 | `CAT-NAV`，secondary `CAT-DOC` | 直接 |
| `WKS-WINDOW` | 6 | `CAT-APP`、`CAT-SYSTEM` | 拆分 |
| **合計** | **254** | 18 類皆有可達路徑 | 無遺漏；正式分類仍待 TAX-03／04 接受 |

投影結果顯示 17 個舊群組可大致直接轉入，8 個必須逐項拆分；因此不能用舊能力 ID 批次生成正式分類。18 類沒有出現需要 `misc` 的舊群組，也沒有要求先知道 module 才能分類的項目。

## Catalog role

role 與分類正交，每個固定項目必須擇一：

| Role | 定義 | 後續含義 |
| --- | --- | --- |
| `consumer-capability` | consumer 直接以語意資料、功能群組、狀態與事件選用的能力；名稱描述資料／任務，不描述 renderer 形狀。 | 可進入 preserve 或 migrate 評估；view 選項只在該能力需要時提供。 |
| `composition-part` | 只在某個封閉能力內合法出現的具名、具型別功能群組或角色。 | 可保留公開資料型別，但不能獨立宣稱完整 feature，也不能接受任意節點或幾何參數。 |
| `system-contract` | 平台、無障礙、視覺或互動契約的直接展示。 | 通常由跨切面 module 支援，不代表 consumer 可自訂。 |
| `implementation-material` | 舊版低階 Widget、layout、surface、interaction building block，或只描述呈現／virtualization 策略而沒有獨立資料、群組與事件契約的 class。 | 原則上 absorb；若要成為公開能力須另有資料／事件或封閉功能群組證據。 |
| `catalog-artifact` | 只用於說明 token、規格或元件狀態的 Catalog 工具。 | 不自動進入 consumer API；文件與測試仍可保留。 |

## 分類流程與失敗行為

1. 從固定 baseline 讀取名稱、舊頁面與來源，只作識別證據。
2. 為每項寫一句不含 class、資料夾或 module 名稱的 consumer intent。
3. 依 intent 指派一個 primary category、可選 secondary tags 與一個 role；先用 TAX-11～15 排除非語意 primitive、自由視覺組合與純 renderer 實作。
4. 無法唯一分類時標記 `needs-definition`，回到分類或 intent 決策；禁止 `misc`、依舊頁沿用或先填 module。
5. 254 項全部通過分類檢查並由使用者接受後，才群組成 capability families；以共同資料、功能群組與事件契約決定 family，不以是否能切換 view 作為必要條件。
6. capability family 接受後才決定公開處置；最後才依資料／事件／組裝／生命週期權威映射 owning module。

同一項只能在固定分母計數一次。secondary tags 只支援搜尋與交叉入口，不複製頁面、不產生第二份 API，也不決定 owner。

## 範圍

本階段包含分類定義、role 定義、254 項分類資料格式與接受方式。不包含逐項新版 API、module 內部架構、renderer、Catalog specimen、視覺候選或舊 API 刪除。

## 接受證據

- 機械檢查固定 baseline 254 項與分類記錄一對一、無遺漏、無額外項目、無重複 primary。
- primary category 與 role 只允許本規格列舉值；每項 consumer intent 非空，且正式分類檔不含 owner/module 欄位。
- 人類審閱時必須能從 intent／role 辨別語意能力、封閉功能群組與純呈現材料；List／Grid／Masonry 等不得僅因舊 class 名稱承諾公開或強制合併。
- 人類審核分類定義及跨用途規則；程式檢查不代替其語意接受。
- coverage 與已完成程式證據在分類階段不得改動。

## DEFINE 閘門

`TAX-01`～`TAX-15` 全部 accepted，沒有 open P1。既有 proposed 分類必須依 TAX-11～15 重新審核 role 與 intent，再產生新版人類審閱輸出；仍不會同時決定 module。
