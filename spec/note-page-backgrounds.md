# 筆記頁面背景

## Outcome

讓 `-ist` 家族的文件、自由畫布與試算表頁面共用同一套可隨 Kallopis theme 切換的向量背景，
避免各產品各自硬編碼顏色、間距與線條。

## In scope / out of scope

- Kallopis 提供純底色、橫線、點陣、方格與受限 point／line recipe，以及承載產品內容的
  child slot。
- Catalog 增加「筆記」分組與「背景」頁，並在同頁呈現四種背景。
- Catalog 提供 RGB、主次軸、內部分割、主軸間距、viewport zoom、stroke behavior，以及
  point／line 編輯工具的執行期範例。
- Notist 以 Kallopis 背景組裝 Docs、Canva、Sheet 三種頁面；Docs 既有文字內容不重新設計。
- 不搬入 Planist／Krepis 的背景資料模型、JSON、捲動同步或商業邏輯。
- 不在 Notist 實作編輯入口、viewport 手勢、保存或 undo/redo。
- 不在 Notist 重複實作任何背景 painter 或視覺常數。

## User-visible behavior

- 純底色適合 Docs，橫線可呈現傳統筆記紙，點陣支援自由排列內容，方格支援表格定位。
- 背景永遠鋪滿元件邊界，child 疊在背景上方。
- 深色、淺色與自訂 Kallopis theme 下，背景會使用目前 theme 的 semantic token 重新著色與縮放。
- ruled、dots、grid 的預設圖樣色統一來自 `pagePattern`；recipe 可以在執行期覆寫 RGBA。
- dots 的預設圓點直徑使用 `shape.stroke`，避免相同圖樣色在暗色背景因覆蓋面積過小而難以辨識；
  ruled 與 grid 的預設線寬仍使用 `shape.hairline`。
- dots／grid 的主軸與次軸可分別設定顏色、寬度、主軸間距與兩主軸間的次軸數量。
- viewport 縮放永遠改變圖樣位置；線寬與點徑可選擇固定或隨縮放改變。
- 自訂背景只保存頁面座標下的 point 與 line；點連預設吸附座標格，按住 Shift 暫停吸附。

## Architecture constraints

- 公開元件位於 Kallopis `editor` 領域，不依賴任何產品資料模型。
- 元件只透過 `context.klp` 取得顏色、間距與線寬，不直接參照 primitive 或 static token。
- 所有 recipe 共用單一 renderer，不建立彼此重複的背景實作。
- `KlpPageBackgroundEditor` 是受控元件，只輸出新的 immutable recipe；選取與連線鏈是暫態
  互動狀態，不進入產品資料。
- Notist 只選擇樣式並提供 child，不擁有背景繪製規則。

## Failure and edge cases

- 零尺寸元件不繪圖也不拋例外。
- 任意有限尺寸皆可渲染；不足一個圖樣間距時仍保留底色。
- 背景不攔截 child 的手勢、焦點或語意。
- 非有限或非正的 scale／spacing／width、負數分割，以及無效 point／line 參照會在公開
  recipe 邊界被拒絕。
- 刪除 point 時一併刪除引用它的 line；刪除 line 不刪除端點。

## Acceptance criteria

1. Kallopis 公開匯出背景 widget、recipe、viewport 與受控 editor API。
2. 測試證明舊 `style:` API 仍可渲染四種樣式，且三種圖樣預設解析同一個 `pagePattern`。
3. 測試證明 dots 的預設點徑解析為 `shape.stroke`，且不改變 ruled／grid 的 `shape.hairline`。
4. Catalog 測試證明主次軸可獨立調整 RGBA，Alpha 會保留 RGB 並立即反映在背景。
5. 測試證明主次軸可獨立設定、內部分割公式正確，fixed/scaled 線寬行為不同。
6. editor 測試證明點連吸附、Shift、Escape、point 優先命中、選取及連帶刪除規則。
7. Catalog 導覽包含「筆記」分組，其「背景」頁可在明暗兩態完成渲染與互動。
8. Notist 的 Docs、Canva、Sheet 頁面維持既有 Kallopis 背景組裝。
9. Kallopis `Verify` 與 Notist 的 analyze/test 全數 exit 0。

## Verification evidence

- Kallopis `tool/verify.ps1`：格式 185 檔無變更；根套件與 example 均為
  `No issues found!`；元件清單為最新；根測試 `+219: All tests passed!`。Backgrounds
  RGBA 互動測試與明暗 golden 分別為 `+2: All tests passed!`；完整 example 測試被既有
  Layout & Interaction 視窗範例的 0.46% golden 差異阻擋，與背景 renderer 無依賴。
- Notist `flutter analyze --fatal-infos`：`No issues found!`。
- Notist Canva golden：`+1: All tests passed!`。完整測試被 Sheet 頁面視窗列的 0.06%
  golden 差異阻擋；差異不位於 grid 背景。
- Catalog 背景頁的明暗 golden 已人工檢視；全頁 golden 因共同導覽的元件計數改變而同步更新。
- Notist 只更新 Canva／Sheet 背景 golden；人工檢視確認內容與版面不變，差異只來自
  `pagePattern`。
