# KLP-0.4.0 頁面背景與 Windows 框架正式發布任務

## 任務資訊

- 狀態：發布候選版已通過本機驗證，待 GitHub CI/CD 與 tag 驗收
- 工作分支：`codex/fix-window-header-overflow-0.3.2`
- 正式版本：`0.4.0`
- 預定 tag：`v0.4.0`
- GitHub：`https://github.com/MiuDog/Kallopis`
- 第一消費者：`C:\Projects\Notist`
- 最終驗收人：`/root`；只依證據給出 `ACCEPT` 或 `REJECT`

## 目標

發布可供 Git tag 與本機 path dependency 使用的 Kallopis `0.4.0`。本版交付型別化頁面背景
recipe、受控背景編輯器、Windows 自訂視窗框架與統一互動狀態，並修正極窄啟動寬度下的
header RenderFlex overflow。所有視覺值仍由 theme、geometry 或 recipe 輸入解析，元件不得
藏入顏色、邊界、圓角、padding、字體或時長常數。

## 不可變條件

1. `KlpScale`、`KlpPalette` 與既有 primitive 值不得因發布而改動。
2. 元件的內建視覺只能讀取 `context.klp`；不得直接略過 theme 繼承樹。
3. 呼叫端明確提供的 recipe RGB 屬資料輸入；未提供時必須回到 semantic token。
4. 同一預設值只能有一個實作，不得在 theme 與元件各留一份 fallback。
5. 不新增 allowlist、不調高 baseline，也不得以無理由 golden 更新掩蓋失敗。
6. 維持 `publish_to: none`；本機消費採 path，遠端消費固定不可變 Git tag。
7. 已推送 tag 不得移動或 force-push；發布後問題必須以後續 patch 修正。
8. 任一完整驗證或 GitHub CI 失敗，即停止後續發布並判定 `REJECT`。

## 發布內容

### 公開能力

- `KlpPageBackgroundRecipe` 系列、viewport 與固定／縮放筆畫模式。
- 只接受 point／line 的受控 `KlpPageBackgroundEditor`，不接受任意 painter 或程式碼。
- 可覆寫的工作台 padding、Windows header geometry 與 app icon 尺寸契約。
- `KlpApp` 的正值最小視窗尺寸驗證，以及 Windows runner 的 resize／maximize 契約。

### 修正

- 內容寬度 148px 且同時有 app icon、標題與 action 時不再產生水平或垂直 overflow。
- 窄寬度優先完整保留最小化、最大化與關閉按鈕；空間不足時只裁切次要內容。
- 最大化狀態仍將 header 拖曳交給原生 Windows 行為。

## 執行工作包

### WP1：契約與回歸測試

1. 先以 156px 外寬、148px 內容寬建立會重現 overflow 的 widget test。
2. 以 layout delegate 先配置視窗控制區，再把剩餘寬度交給 identity／actions。
3. 保留正常寬度排列與 RTL 方向；不得用固定寬度猜測可用空間。
4. 驗證 window header、app 最小尺寸、runner 契約、page recipe 與 editor 測試。

**證據**：受影響測試 exit 0，且窄寬測試的 `tester.takeException()` 為 `null`。

### WP2：視覺與 token 紀律

1. 執行 color、token、interaction、consumer contract 與 inventory 關卡。
2. 只更新由已核准幾何或新頁面背景造成的 golden；逐張記錄原因。
3. 確認 JSON encode/decode 納入 additive geometry 與 `pagePattern`，且 round-trip 無損。
4. `git diff --check` 必須 exit 0；secret 掃描不得出現憑證或 token。

**證據**：所有 discipline 測試通過、inventory current、沒有 Required finding。

### WP3：單一完整 Verify

在 repo root 執行：

```powershell
pwsh -NoProfile -ExecutionPolicy Bypass -File .\tool\verify.ps1
```

必須依序通過格式、root analyze、inventory、root test、example analyze 與 example test。
任何修正後都要從第一步完整重跑，不得只引用較早的局部測試。

### WP4：Notist 本機接入

1. Notist 以最簡單的 path dependency 使用本庫：

   ```yaml
   kallopis:
     path: ../Kallopis
   ```

2. 執行 `flutter pub get`，確認 lockfile 解析為 `0.4.0`。
3. Notist 工作台的 4px 外框使用 `klp.space.tight`，不得把 16px 的 `base` 當同義 token。
4. 僅更新受新 header geometry 與最新 4px 版面契約影響的 golden，不改色票。
5. 執行 Notist `flutter analyze` 與完整 `flutter test`。

**證據**：analyze 零問題、13 項測試全過、lockfile 指向 `../Kallopis` 0.4.0。

### WP5：GitHub CI/CD 與正式發布

1. 建立發布 commit 並推送工作分支。
2. 等待 branch CI 成功後，以 PR 合併至 `main`。
3. 等待 `main` CI 成功，確認 release commit SHA。
4. 在該 SHA 建立 annotated `v0.4.0`，推送後等待 tag CI。
5. release job 必須核對 tag、`pubspec.yaml` 與 CHANGELOG 版本一致並建立 GitHub Release。
6. 將本機 Kallopis 同步到正式 release commit；Notist 再做一次 path 解析確認。

## 驗收條件

- [x] 148px header 回歸測試不再產生 RenderFlex overflow。
- [x] 正常寬度、RTL、拖曳與三個視窗控制按鈕測試通過。
- [x] 頁面背景 recipe、viewport、editor 與 JSON theme 測試通過。
- [x] Kallopis 完整 Verify：root 與 example analyze/test 全數 exit 0。
- [x] Notist 解析本機 `0.4.0`，analyze 與 13 項測試通過。
- [x] 變更不包含 secret、baseline 放寬或無理由的 golden 更新。
- [ ] 發布分支與 PR CI 成功。
- [ ] `main` CI 成功。
- [ ] `v0.4.0` tag CI 與 GitHub Release 成功。
- [ ] 本機 Kallopis 與 Notist 最終解析均指向正式 release commit。

## 證據與最終交付

最終驗收必須記錄完整 Verify 的輸出尾行、Notist analyze/test 尾行、release commit SHA、PR、
branch／main／tag CI 連結、GitHub Release 連結，以及 golden 更新原因。全部關卡完成才可將狀態
改為 `ACCEPT`。

## 風險與回退

- 窄 header 若再次失敗，保留視窗控制區並回退次要內容配置，不可縮小控制按鈕命中區。
- 未發布前可修正 branch 並重跑完整 Verify；不得在失敗狀態建立 tag。
- 已發布後保留 `v0.4.0`，另發 patch；不得替換歷史 tag。
- Notist 可暫時把 path dependency 固定回前一個可用 checkout，再執行 `flutter pub get`。
