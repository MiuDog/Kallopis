# KLP-0005：以 Semantic Manifest 統一預設風格與 Catalog 分類

- 狀態：Accepted
- 日期：2026-09-03
- 決策者：產品負責人
- 取代範圍：KLP-0001 中「消費產品可覆寫一般 semantic token」的敘述；KLP-0001 其餘 scope 與三層回退原則保留，並由本決策細化為四層。

## 情境

Kallopis 的預設風格將供 Designist、Notist 與後續產品共同使用。若 Catalog、元件 recipe 與消費產品各自維護分類或操作色，視覺規則會漂移，也無法區分產品品牌識別與跨產品一致的操作語意。

使用者建立的 Design System 屬於產品資料，不得繼承或污染 Kallopis 預設風格。

## 決策

`spec/semantics/kallopis.semantic-manifest.json` 是 Kallopis 預設風格語意與 Catalog 分類的機器可讀唯一真相來源，並以 `schemaVersion` 管理相容性。

語意固定為四層，順序不可交換：

1. `primitive`：內部原始尺度與來源值，不供消費產品直接使用。
2. `foundation`：品牌識別、surface、type、status、motion、depth 等共用角色。
3. `component`：由 foundation semantic 解析出的元件 recipe。
4. `pattern`：由元件組成的可重用操作與 workspace pattern。

消費產品只能覆寫 `color.identity.brand`。Primary、interaction、focus、selected、danger、warning、success 等操作與狀態語意由 Kallopis 固定並跨產品一致。

使用者建立的 Design System recipe 與本 manifest 完全隔離；兩者不得共享 token resolver、覆寫鏈或持久化資料。

Catalog 群組、順序與頁面註冊由 manifest 經 `tool/generate_catalog_registry.dart` 產生。顯示標籤可以演進，但 navigation 與工具應使用穩定 ID。

## 邊界

本決策只建立分類、政策與生成鏈。現有 Dart theme runtime 尚未由 manifest 產生；將實際色彩、間距與 component recipe 搬入 manifest，屬於下一階段風格細修與遷移。

Catalog page 仍擁有 specimen 內容與互動。manifest 只擁有 page 的分類、順序、來源檔與 symbol。

## 後果

- Catalog 不再手工維護平行分類清單。
- CI 可檢查 generated registry 是否過期。
- Designist 與 Notist 可更換品牌識別色，但不能分叉操作色。
- 使用者 Design System 的匯出與編輯不會意外套用 Kallopis 產品風格。
- manifest schema 或四層語意有破壞性變更時，必須提升 `schemaVersion` 並提供遷移說明。

## 2026-09-03 Primary 語意修訂

使用者進一步確認，Catalog OKLCH 所編輯的顏色必須直接改變整個 Catalog，且 primary 使用該主題色。

`brand` 與 `accent` 不合併：`brand` 是唯一可由產品設定的主題來源；`color.action.primary` 由 `color.identity.brand` 派生。Accent、一般 interaction 與 status 色仍由 Kallopis 固定。此修訂取代本決策中「primary 也完全不受 brand 影響」的舊解讀，不開放第二個覆寫入口。

## 2026-09-03 Primary 對比修訂

Primary 不使用半透明品牌 wash 與有色文字。背景直接使用 alpha 255 的主題色；將 computeLuminance() 乘以 255 後，0–127 使用 onDarkBackground 淺色字，128–255 使用 onLightBackground 深色字。Hover、focus 與 selected 可在此不透明背景上合成狀態色，但最終背景仍須不透明。

## 2026-09-03 Primary 切換點修訂

前景切換點由 128 修訂為 0xA0（160）：8-bit sRGB luma 低於 160 使用淺色字，160 以上使用深色字。luma 使用 0.299R + 0.587G + 0.114B；灰階 #999999 得 153，#A0A0A0 得 160，因此可精確落在指定切換點並合理處理非灰階品牌色。
## 後續 Runtime 與 AI 組裝契約

下一階段將由 manifest 定義可解析的 foundation semantic 與 component recipe。Kallopis 複合元件在內部建立受控的 InheritedWidget／InheritedTheme scope，子元件只讀取最近且合法的語意值；消費產品不逐層傳遞或覆寫操作風格。

Inherited scope 必須遵守以下限制：

- 只允許品牌識別入口改變 color.identity.brand。
- 操作色、狀態色、間距、形狀與 component recipe 不對消費產品開放任意覆寫。
- 使用者 Design System recipe 使用獨立 resolver 與 scope，不接入 Kallopis 預設風格繼承鏈。
- scope 的建立者、讀取者、fallback 與更新邊界必須記入元件繼承文件。

完成 runtime 遷移後，必須在 docs 提供面向其他 AI 的畫面組裝指南，包含 screen tree、pattern 選擇、元件輸入、事件回傳、資料注入、合法覆寫與禁止事項。
