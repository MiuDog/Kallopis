# KLP-0001：Kallopis 的範圍、token 架構，與「複製搬移」這個例外

## 狀態

Accepted

## 日期

提出：2026-08-18
接受：2026-08-18

## 背景

`-ist` 產品家族需要一套共用視覺層。來源是 Planist 的 `lib/design_system/`（82 檔、17,684 行）
——該目錄是整個 Planist repo 中唯一對外依賴為零的部分，只依賴 `dart:*`、`flutter` 與
`flutter_svg`。

同時，Planist 的基座抽取計畫（`tasks/substrate-extraction-plan-20260816.md` 第 114 行）已定下
移植原則：**「不搬程式碼，照規格重寫。」** 該原則的理由是避免把 `lib/product` 的 617 個
class 與五層 clean architecture 一併帶走。

## 決策

### 1. 範圍陳述

> Kallopis 提供 `-ist` 產品家族共用的 Flutter 視覺層：design token、theme、排版與**無產品
> 語意**的共用元件。它不知道任何產品在做什麼。

Kallopis 不依賴 Krepis，也不依賴 Stoicheis。三者平行。

### 2. 抽層判準（五條全過才進庫）

1. 至少兩個產品使用
2. 具有相同的產品語意
3. 互動與無障礙規則相同
4. API 能以 token 或 slot 客製，而不是大量布林參數
5. 不含產品資料模型或商業邏輯

若未來兩個產品真的共享同一個領域概念，把它提升為**獨立 feature package**，而不是塞進
視覺元件庫。

這比 Krepis `FND-0001 §4`（「一個刻意平凡的筆記 app 需不需要？」）更嚴格：後者只問需不
需要，本判準另外要求 API 形狀（規則 4）與語意一致性（規則 2、3）。

### 3. 拒絕清單

任務卡與計畫語意、專案與邀請協作、AI 對話介面、儀表板與資料庫視圖、時間軸、KPI 指標、
導覽與入口決策、與產品狀態直接綁定的元件。

逐一元件的判定與行數見 [`../component-classification.md`](../component-classification.md)。

#### 拒絕清單裡的「導覽」指的是決策，不是機制

`KlpRouter` 看起來像是踩到「導覽與入口決策」這條拒絕線，其實沒有。分界是：

| 屬於產品（拒絕） | 屬於庫（接受） |
|---|---|
| 有哪些頁、頁的階層、入口是哪一頁 | 「切換目前顯示哪一個」這個動作 |
| 路由 id 的命名與語意 | 登記簿的資料結構與查找 |
| 轉場動畫該怎麼演 | —— |
| 網址格式、深層連結 | —— |

庫不預設任何路由、不定義 `KlpRoute.data` 的結構、不做轉場、切到未註冊的 id 時
**拋錯而不是回退到某個預設頁**。`test/router_test.dart` 有一項機械檢查：庫內程式碼
不得出現 `home`／`settings`／`index` 這類具名路由字串。

一旦庫內出現「預設首頁」，它就開始替所有產品決定入口——那才是拒絕清單擋的東西。

### 4. Token 架構：三層繼承樹

| 層 | 內容 | 可否覆寫 | 理由 |
|---|---|---|---|
| primitive | `KlpScale`、`KlpPalette` | **否** | 它是設計語言的字彙表。消費者要調整外觀應該覆寫 semantic，而不是重新定義「4 是多少」 |
| semantic | 色彩／字體／間距／形狀／動態／表面，皆為 `ThemeExtension` | 是 | 這一層才是「風格」 |
| component | `KlpComponentTheme`，欄位全 nullable | 是 | `null` 表示沿用 semantic，因此這層是稀疏的 |

元件透過 `KlpTheme.of(context)` 取已解析的值，不需要知道值來自哪一層。任一層缺席時**回退
預設而非拋錯**——庫被放進未設定 theme 的 app 仍應能渲染，只是長成預設風格。

#### 為什麼 spacing 也必須進 ThemeExtension

把 spacing 留成 `const` 可以保住 widget 的 `const` 建構子，是實質的效能與人體工學優勢。
但目標是「只修改 theme 就能完全換一套視覺風格」，而終端機風與現代風**差異最大的一組
token 正是密度**。spacing 留在編譯期就等於該維度永遠換不掉，因此放棄 `const` 優勢。

#### 為什麼分層手法是 enum 而不是兩組參數

`KlpSurfaceSeparation` 只有 `shadow` 與 `outline` 兩個值，而不是獨立的 shadow 與 border 參數。
終端機用實線框界定區塊、現代風用柔和陰影浮起，兩者互斥。做成 enum 讓「陰影開著又畫滿
實線框」這種不會報錯但一定醜的組合**從型別上就無法表達**。

#### 為什麼風格是一個必須整組給定的物件

`KlpVisualStyle` 綁住七層。若風格散落在七個 `ThemeExtension` 各自設定，消費者遲早只換其中
三個——換出圓角是方的、動畫卻還在的半套風格。

### 5. 驗收條件

**庫只出貨一套風格。** 各層也只有一個 preset，庫不預先替任何產品組好第二套外觀
——那會變成在替產品做風格決定，而且第二套會立刻成為所有消費者的參考答案。

代價是沒有現成的對照組。只有一套風格時，**沒有任何東西能發現元件退回硬編碼**：
值是對的、畫面是對的，只是換 theme 時它不會跟著變，而且沒有徵兆。

因此驗收條件改由測試承擔：`test/style_fixture.dart` 用各層的**建構子**就地組出一套
與出貨風格各維度全不同的極端值。切換到它若需要改動任何元件程式碼，就代表該元件還在
硬編碼風格。它刻意不依賴任何出貨的 preset，因此庫再怎麼精簡都不會讓這道閘門失效。

這道條件已經抓到一次真實缺口——`KlpText` 與 `buildKlpTheme` 仍讀舊的 `KlpTypography`
靜態常數，導致對照風格的字體沒變成等寬。修法是把 `toTextStyle` 的 `KlpTypographyTheme`
參數改為必填：忘記傳會是編譯錯誤，而不是靜默用錯字體。

### 6. 移植方式：複製搬移，這是對重寫原則的明列例外

`substrate-extraction-plan-20260816.md` 第 114 行要求「不搬程式碼，照規格重寫」。
**本庫是例外**，理由有三：

1. 該原則針對的病症（五層 clean architecture、617 個 class）在 design_system 不存在
   ——它零依賴、扁平、命名一致。
2. 視覺層恰恰是「規格不足以決定產出」的部分。間距、描邊、狀態色階這些決策活在程式碼裡，
   不在 `spec/ui/`。照規格重寫等於重做一次視覺決策，結果必然與現況不同。
3. 該計畫第 121 行把重寫成本當成「規格是否足以決定產出」的檢驗。用 design_system 做這個
   檢驗**無效**——它先天就該便宜。真正的檢驗對象是 `lib/product`。

此例外不擴及其他模組；`lib/product` 的重寫原則維持不動。

搬移的代價已由 golden 測試界定：`klp_region_placeholder_golden_test` 等測試通過，證明經過
抽取、改名、裁剪與 token 重構後渲染輸出與 Planist 逐像素相同。

### 7. 命名

- 庫名不使用 `-ist`（Krepis `FND-0001 §7`）。
- 符號前綴由庫名的子音骨架推導，對齊既有的 Planist → `Pln`：
  **Kallopis → `Klp`**。同族：Krepis → `Krp`、Stoicheis → `Stc`、Designist → `Dsg`。
- 各庫用各自的前綴，不共用生態系前綴。Designist 會同時 import Kallopis 與 Stoicheis，
  共用前綴會讓人看到符號時分不出來源；而且共用前綴等於在符號層拆掉 `FND-0001 §7`
  那道防線——防線的作用點正是符號層，每次有人新增 class 的時候。

## 這份決策關閉哪一道閘門

**「這段視覺程式碼該寫在哪裡、值該從哪裡拿」原本沒有可判定的答案。**

本決策之後有兩組機械判準：五條抽層規則（第 2 節）決定元件的去留，三層繼承樹（第 4 節）
決定值的來源。兩者都有測試執行，不靠自律：

- `test/token_discipline_test.dart`：元件不得出現 `Color(0x…)`、`Duration(milliseconds:…)`，
  不得直接參照 primitive 層；舊 static token 的引用數只能下降。
- `test/visual_style_test.dart`：兩套風格在每個維度上必須不同。
- `example/test/style_switch_golden_test.dart`：兩套風格算出的圖必須不同
  ——證明 token 真的抵達畫面，而不只是值不同。
- `test/consumer_contract_test.dart`：從**庫外**驗證。其餘測試都看得到 `lib/src/`，
  因此驗證不了「一個只 import 公開 barrel 的 app 能不能用」。這道缺口是實測出來的
  ——庫內測試全綠的狀態下，第一個真實消費者一放上 `KlpTextField` 就拋
  `No Material widget found`，而 `buildKlpTheme` 會靜默丟棄傳入的品牌色。
  **編譯過不等於畫得出來，庫內全綠不等於庫外能用。**

## 已知欠債（接受本決策時仍存在）

- 舊 static token 的引用已從 515 降到 16。剩餘者為版面預設值、選單幾何、視窗透明度與
  dense 變體高度——皆非風格，刻意保留。計數棘輪持續列管。
- 無障礙 `Semantics` 覆蓋 76 個檔案中的 22 個。
- 15 條分層違規，其中 12 條來自 `klp_foundation_extras.dart`——它被歸在 `foundation`
  卻依賴 `surface` 與 `typography`。這與「布林參數過多」得到的是同一個結論，
  但是從組合關係獨立推導出來的。見 `spec/component-inventory.md`。
- 186 個公開型別中僅 17 個有 dartdoc，以棘輪列管。
- `klp_advanced_data`（20 個布林參數）與 `klp_foundation_extras`（11 個，且是 17 個類別的
  雜物袋）未通過規則 4，需重構而非移除。

**只有一個實際消費者時，庫的介面有一部分是猜的。** 目前 Notist 尚未使用 Kallopis，
`example/` 的元件目錄是唯一的使用現場。這個風險與 `substrate-extraction-plan` 第 132 行
記錄的相同，未消失。
