# Semantic composition layers

狀態：`SCL-TAX-r1` ACCEPTED；固定 254 項分類與層級已由使用者接受。Capability family 與 exact roles 的當前計畫為 [`SCL-FAM-r1`](../../../tool/catalog_family_mapping/architecture.md)；Runtime 公開面替換仍須等待 family 與 disposition／module ownership 完成，不得跳過 Catalog migration 閘門。

依據：[Catalog taxonomy](../../../spec/catalog-classification.md)、[KLP-0019](../../../spec/decisions/KLP-0019-declarative-framework-migration.md)、[KLP-0021](../../../spec/decisions/KLP-0021-productivity-component-ecosystem.md)、[composition module](../../../lib/src/composition/architecture.md)。

## 目的與範圍

本架構把「consumer 組合語意原子／功能群組，Kallopis 組合元件樹／視覺佈局」具體化為唯一公開結構順序：

```text
screen → layout → container → element
```

這是 consumer contract 的結構層級，不要求原始碼資料夾、renderer Widget tree 或 Flutter 內部實作採相同深度。任何一層的 Kallopis 私有 renderer 都可以使用 `Row`、`Column`、`Stack`、sliver、overlay 或其他平台容器；這些實作不會成為 public declaration 的 child 型別或參數。

目前 stage 只讓固定 254 項逐項取得可審閱的層級候選與理由。它不建立 public class、不指定 owning module、不決定 preserve／migrate／absorb／replace／retire，也不修改 coverage。

## 四層責任

| 層級 | Consumer 表達 | 可直接承載 | Kallopis 擁有 | 禁止 |
| --- | --- | --- | --- | --- |
| `screen` | 可導覽、具 accessibility 身分的畫面根資料。 | 恰好一個 root `layout`。 | 畫面宿主、safe area、overlay host、焦點與錯誤表面。 | 直接接 container／element、Widget、任意 children。 |
| `layout` | 選擇一個 Kallopis 定義的產品無關區域關係，並為具名 role 提供 container。 | 只有契約列出的 typed container roles。 | 實際 row／column／split／dock／responsive／overlay placement、尺寸與間距。 | raw axis／flex／gap／padding／alignment／座標、element、另一個 layout。 |
| `container` | 一項 semantic feature 或功能群組的 immutable projection、狀態、單一 intent 與必要時的受限 controller。 | 只有該能力 schema 列出的 element data。 | 群組內元件、chrome、interaction、empty/loading/error、keyboard／focus／a11y。 | layout、另一個 container、任意 KlpNode、item callback 或 renderer callback。 |
| `element` | 功能內最小的語意資料／動作描述，例如 action、field、destination、tab 或 item。 | 不承載 KLP 結構 child。 | 實際 control、文字、圖示、表面、命中區與狀態呈現。 | Widget、builder、style、幾何參數或任何 composition-qualified child。 |

`element` 可以包含領域資料階層，例如 tree item 的 children、table row 的 cells、document block 的 inline spans；這些值仍由同一 container schema 擷取，不具有 screen／layout／container／element 的結構放置資格，也不能成為第二棵 KLP composition tree。

## 合法邊與禁止邊

唯一合法結構邊：

```text
application/router → screen
screen → layout
layout → container
container → element data
```

所有跳層、逆向、同層或循環邊均非法。Screen 不直接承載 feature；layout 不直接承載 item；container 不巢狀另一個 container。需要多區域時，由同一 concrete layout 公布多個具名 container roles。需要多段功能內容時，由 container 的 feature-specific data schema 定義 section／group，不新增通用遞迴 `Group(children: ...)`。

Dialog、Drawer、Popover 等暫態表面不建立例外：root layout 可定義具名 overlay container roles，Kallopis 內部 overlay host 決定實際疊放。若 overlay 內需要表單，該 overlay layout role直接承載 form container；Dialog 的表面與 placement 是 layout／renderer 責任，不再包一層可任意組裝的 public container。

## 公開契約形狀

四層不是四個可任意 new 的萬用盒子。後續公開面必須遵守：

- `screen` constructor 只接受一個具 screen-layout 資格的具體 Kallopis layout。
- 每個 concrete layout 公布具名、具型別、具數量限制的 container roles；不得提供 `List<KlpContainer>` 萬用 children。
- 每個 container 是 semantic feature 邊界，採 declaration／immutable data／single feature intent／optional feature controller；constructor 不接任意 node。
- Element 是 container-owned immutable data。互動透過 container 的單一 intent 輸出，element 不保存 callback。
- 層級 qualification 只表示 Kallopis catalog 中已知 concrete declaration 的資格；consumer 實作同名 interface 不取得登錄或 renderer 權限。
- `KlpNode`、`KlpCompositeNode`、`KlpSlot`、`KlpChildren`、`KlpScreenBody` 等 generic tree authoring 型別最終不得由 declarative consumer barrel 可達；結構擷取改由 Kallopis-owned declarations 與內部 catalog metadata 完成。
- 公開 class 必須為 library-owned `final`／封閉資料型別；不得提供 consumer subclass、adapter、definition 或 renderer registration。

確切 Dart 名稱與每個 family 的 role 型別在分類接受後由 family PLAN 決定。本 stage 不先建立 `KlpLayout`、`KlpContainer` 或 `KlpElement` 萬用基類，避免在尚未知道 254 項 family 前固化錯誤抽象。

## 資料、事件與控制

```text
consumer product state
  → screen/layout declarations
  → container immutable projection
  → element data
  → Kallopis capture + validation
  → feature adapter + immutable bound record
  → private renderer
  → container-specific intent
  → consumer updates product state and redeclares
```

Screen 與 layout 只在其本身具有產品可觀察狀態時才定義自己的 projection／intent，例如可持久化的 pane state；純 responsive、hover、drag preview 與幾何仍由 Kallopis 擁有。一次性 focus／reveal 等命令只能由 owning container 的 feature-specific controller 提供，不建立跨層 controller 或全域 UI bus。

Consumer 可提供代表工作流程、優先級或閱讀順序的資料順序；axis、wrap、spacing、alignment 與 adaptive rearrangement 不是 consumer order，全部由 layout／container renderer 決定。

## 驗證與失敗

結構合法性以兩道證據保護：

1. Concrete constructor 使用 exact role types，使一般跨層組裝在編譯期不可表達。
2. Composition capture 以封閉 catalog 驗證 identity、實際層級、parent role、cardinality、順序、重複 placement 與 cycle，拒絕偽造 qualification 或動態錯配。

不得自動包裝、補預設 container、重排非法 child 或把未知 declaration 降級成空白。違規使用穩定 `KlpContractError` code，且完整 frame 驗證成功前不提交。預期資料狀態仍走 container projection；非預期 renderer／provider 錯誤仍由唯一 host diagnostic 擁有。

## 模組責任與相依

| Module | 本架構責任 |
| --- | --- |
| `application` | 擁有 application/router/screen root；screen 只接受 root layout。 |
| `composition` | 擁有結構層級 vocabulary、封閉 catalog metadata、capture 與合法邊驗證；不理解 feature data。 |
| `features` | 擁有 concrete layout、container、element data、intent/controller 及 adapter/bound contract。 |
| `runtime` | 只編譯已驗證結構與管理 frame/resource lease；不得修正層級。 |
| `rendering` | 私有地使用 Flutter/WebView 原生容器實現 bound records；不建立 public composition API。 |
| `styling` | 提供唯一 semantic visual resolution；不讓任何層接受 consumer style。 |

依賴方向維持既有 L0→L7。具體 feature 不下沉 composition；composition 只看 catalog-owned structural metadata。Application 組裝完整內建 catalog，但不重新定義層級規則。

## 現行差距

- `kallopis_declarative.dart` 仍匯出 `KlpNode`、`KlpCompositeNode`、slot／children 與 screen body authoring 型別。
- `LayoutRow`、`LayoutColumn`、`LayoutSpacer`、`flex`、`spacing`、alignment 與 frame style 仍讓 consumer 描述呈現。
- `KlpFrameGroup.content` 接受 `List<KlpNode>`，允許跨 feature、跨層與任意 node 組合。
- 多個舊 feature 把 item 建成 node 或保存 item-level callbacks，而非 container-owned element data／single intent。

上述都是 migration gap，不在 `SCL-TAX-r1` 直接修改。最終替換不得保留同義 compatibility shim；需先遷移 repo consumers、Catalog、tests、reference，再依固定 coverage 更新證據並刪除舊入口。

## 已完成 stage：`SCL-TAX-r1`

本 stage 只擴充固定分類資料，使每個 legacy item 除 category／role 外，再有：

- `compositionLevel`：`screen`、`layout`、`container`、`element`、`internal`、`none` 之一。
- `compositionRationale`：說明 consumer 注入的資料／功能、合法直接 parent，或為何沒有 public composition level。

`compositionLevel` 是 public-layer candidate，不是 disposition 或 module owner。`internal` 表示只可作 Kallopis implementation；`none` 表示 Catalog artifact 或不參與 runtime composition 的 system contract。

機械一致性：

- `consumer-capability` 必須是 `screen`／`layout`／`container`／`element`。
- `composition-part` 必須是 `container`／`element`；若只是視覺 helper，role 應改為 `implementation-material`。
- `implementation-material` 必須是 `internal`。
- `catalog-artifact` 必須是 `none`。
- `system-contract` 可為 `container`／`element`／`none`，但 rationale 必須說明它是否為 consumer 可提供的語意資料。

### Ordered slices

| Slice | Owner／write paths | 成果 | 驗收 |
| --- | --- | --- | --- |
| `SCL-TAX-T` | Independent Test Author；`test/catalog_classification_contract_test.dart` | 將 schema v2、兩個新欄位、enum、role-level consistency 與 forbidden architecture fields 固定為真實 Red。 | Red 必須來自現有 classification 缺欄位，不是 harness／dependency failure；原 254 集合與 category 斷言保留。 |
| `SCL-TAX-D` | Taxonomy data；`tool/catalog_classification/classification.json` | 逐項重審 254 筆 intent、role、compositionLevel、rationale，維持 proposed。 | 254/254 schema Green；raw layout、arbitrary group、view-only class 不因名稱取得 public level。 |
| `SCL-TAX-V` | Tooling；`tool/catalog_classification/verify.dart`、`render_review.dart`、`review.md` | Verifier 與人類 review 顯示層級、理由及各層統計。 | verifier Green；review 重建無 diff；`--require-accepted` 仍因 proposed 正確失敗。 |
| `SCL-TAX-A` | Taxonomy owner；只更新 classification review status／acceptedAt／specRevision | 人類已於 2026-09-18 接受 254 項分類與層級。 | `--require-accepted` Green，coverage 仍為 2 migrated／1 preserved／251 pending。 |

估算採已完成 TAX-T／D／V 為 historical basis，使用目前模型、本機 Dart／Flutter、無網路下載：

- `SCL-TAX-T`：3k–7k tokens／20–50 分；M1 schema Red（2k／20 分），M2 consistency cases（3k–7k／20–50 分）；超過 10k／75 分或 Red 來自既存 compile pollution即異常。
- `SCL-TAX-D`：14k–32k tokens／100–240 分；M1 layout／primitive／surface 高風險項（8k–16k／60–120 分），M2 全 254 語意複核（14k–32k／100–240 分）；超過 44k／300 分或需新增第七個 level 即回 PLAN／DEFINE。
- `SCL-TAX-V`：4k–9k tokens／30–70 分；M1 verifier（2k–5k／20–40 分），M2 review 與 deterministic hash（4k–9k／30–70 分）；超過 12k／90 分即異常。

每個 milestone 完成後才回報 checkpoint。Test-owned path、spec、module architecture、baseline、coverage、runtime source、Catalog specimen 與 reference site在本 stage 全部受保護。

## 後續 horizon（未授權 BUILD）

分類接受後依序進入：[能力 family 與 exact roles](../../../tool/catalog_family_mapping/architecture.md) → disposition／module ownership → 一個端到端 pilot family → 按 family 遷移固定 254 項 → 移除舊 public/adapter/renderer → 重新產生正式 Reference → 254/254 evidence 與最後 push。後續不得一次建立 254 個同名 public class，也不得在 family contract 未接受前批次改 source。

## Stage closure

`SCL-TAX-r1` 的全部 P1 已映射至資料欄位、獨立測試、逐項重審、deterministic review 與人類接受，stage 已封閉。下一個 PLAN 必須只處理 capability family 與 exact roles；Runtime migration 明確 gated，不因分類接受而獲得 BUILD 授權。
