---
name: kallopis-design-contract
description: 在 Kallopis 或其消費端實作、修正或審查 UI 版面與視覺時使用。改碼前先追清風格繼承樹、語意 token、呈現所有權與參考稿幾何權限，並維護使用者已確認的布局契約；不適用純資料、網路或無視覺影響的修改。
license: MIT
metadata:
  version: "0.1.0"
---

# Kallopis design contract

目標是讓視覺實作可追溯，而不是「看起來合理」。參考稿、Kallopis 語意與產品組裝是三種不同權限，不得互相代替。

## 必讀路由

每次觸發都先讀：

1. [風格繼承與實作前置檢查](references/style-preflight.md)。
2. [使用者布局契約](references/user-layout-contract.md)。

若當次任務修改了新的視覺領域，再讀該領域的 `docs/architecture/components/` 文件、相關 token 類別與已接受的 decision；不要為了安心讀完整文件庫。

## 改碼閘門

任何會改變尺寸、間距、位置、對齊、圖層、顏色、字體、圓角、動態或互動狀態的修改，在第一個檔案變更前必須完成：

1. 建立本次任務的「屬性權限表」：每項列出參考要求、目前實作來源、完整解析路徑、應修改的所有權層，以及是否仍有歧義。
2. 將屬性分成三類：
   - **精確幾何**：使用者或可量測設計稿指定的尺寸、距離、位置、對齊與圖層順序。不得取最接近的現有 token。
   - **Kallopis 語意**：使用者授權由設計系統決定的顏色、狀態或其他屬性。必須追到已解析 getter，不能只看到 `context.klp` 就假定語意正確。
   - **未確定**：來源無法量測、規則互相衝突或會導致兩種不同驗收結果。先向使用者確認，不得補值。
3. 在 commentary 用精簡文字回報已確認的繼承鏈、幾何權限與未確定項。未完成不得實作。

## 實作原則

- 參考稿要求精確幾何時，精確值仍應落在正確的 Kallopis semantic、geometry 或 component API；不要在產品端以 `EdgeInsets`、固定尺寸或局部 wrapper 建立平行規格。
- 現有 token 不符合參考稿時，修改或新增正確語意與測試；禁止以「語意較合理」為由改變已指定幾何。
- Kallopis 擁有可跨產品重用的呈現、元件狀態與組合規則；產品提供資料、狀態、事件與產品內容，只負責組裝。
- 元件只能讀 `KlpTheme` 已解析值。若 component token 可覆寫 semantic，先查 `KlpTheme` 對應 resolver，不能直接使用底層 primitive 或重做解析。
- 局部 surface 可能透過 `KlpTokenOverride` 改寫色彩；判讀實際顏色時必須沿 widget ancestor 檢查 override，不能只讀 app root theme。
- 變更圖層時，同時驗證 paint order、hit-test order 與 clip 邊界；只調 `Offset` 不算解決覆蓋問題。

## 從對話學習布局邏輯

把使用者的修正視為候選規則，但不要把單一畫面細節直接升級成全域偏好。

- 使用者明說「永遠」「之後都要」「Kallopis 應該」或同一規則跨任務重複出現時，將它加入 `references/user-layout-contract.md`。
- 每條規則記錄 scope、權限類型、來源與狀態。無法判定是單次例外或長期規則時，保留為本次任務條件並在有實質影響時詢問。
- 使用者的新指示可修正舊規則；保留修訂紀錄，不靜默改寫歷史意思。
- 不從使用者沉默、測試通過或 agent 自己的美感推導偏好。

## 驗收

- 幾何：以指定 viewport、DPI／縮放資訊與可量測來源逐項比較；只有截圖且缺比例時明標「無法保證像素等值」。
- 語意：至少用預設風格與 `test/style_fixture.dart` 的極端風格驗證 token 能抵達元件。
- 圖層：加入可觀察 paint／hit-test 順序的測試。
- Kallopis 修改依 `AGENTS.md` 執行 analyze、inventory、root tests 與 Catalog 驗證；不得用更新 golden 掩蓋未解釋的差異。
