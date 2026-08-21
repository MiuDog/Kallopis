# KLP-0.3.0 JSON Theme 正式發布任務

## 任務資訊

- 狀態：待執行
- 工作分支：`codex/release-json-theme`
- 預定版本：`0.3.0`
- 預定 tag：`v0.3.0`
- GitHub：`https://github.com/MiuDog/Kallopis`
- 第一消費者：`C:\Projects\Notist`
- 最終驗收人：`/root`（只做獨立驗收，不再代做實作修正）

## 任務目標

將目前候選版收旂為可供本機與 GitHub tag 使用的 Kallopis `0.3.0`。元件的顏色、
邊界、圓角、間距、padding、字體、表面效果與動態不得寫死，必須經由 JSON theme
解碼後流入 `KlpVisualStyle` 與 `context.klp`。本任務不重設既有色彩或視覺風格。

## 權責邊界

### 執行者

- 修正、測試、更新文件、提交、推送、處理 CI 與 Notist 接入。
- 每個結論附機械證據；不得用「應該可以」代替結果。
- 不得回退任務開始前已存在的候選版修改。

### 最終驗收人

- 不修正執行者的失敗；只給出 `ACCEPT` 或 `REJECT`。
- 只接受可重現的本機輸出、GitHub CI 連結、commit SHA 與 tag/release 連結。
- 任一強制關卡失敗、中斷或無證據，一律 `REJECT`。

## 不可變條件

1. 使用者當下指示 > `AGENTS.md` > `README.md` > ADR。
2. 元件只能透過 `context.klp` 取得視覺值；不得直接參照 `KlpScale` 或 `KlpPalette`。
3. `KlpScale` 與 `KlpPalette` 的 primitive 值不可因此發布變更。
4. 同一個預設值只能在 theme 或 resolver 存在一次，不得在元件內再建 fallback。
5. 不得新增 allowlist、調高 baseline 或更新 golden 來讓失敗變綠。
6. 不發布到 pub.dev；`publish_to: none` 維持不變。
7. JSON 公開邊界只有 `KlpVisualStyleJson`；codec helper 留在 `lib/src/theme/internal/`。
8. 公開 Dart API 的相容性不得因內部檔案整理而破壞。
9. 已發布 tag 不得 force-push 或移動。

## 目前候選版快照

### 已完成但尚未最終驗證

- `pubspec.yaml` 已為 `0.3.0`，Flutter SDK 下限為 `3.38.0`。
- `KlpVisualStyleJson` 已實作 schema v1、overlay decode、path-aware error 與 round-trip 測試。
- colors、typography、spacing、shape、motion、surface、components、data
  visualization 與 geometry 皆已納入 JSON theme。
- 幾何常數已抽成 `KlpGeometryTheme`，元件已進行 token 接線。
- README、CHANGELOG、ADR、GitHub Actions、VS Code Verify 與 `tool/verify.ps1` 已建立。
- 最近一次已完成的定點證據：30 個 JSON/geometry/token/color 測試通過；
  `flutter analyze` 曾回報 `No issues found!`。這些不能取代最後 Verify。

### 當前未關閉項目

1. 最後一次定點測試遭中斷，不算通過證據。
2. `test/consumer_contract_test.dart` 已改為只要求公開檔案出現在 barrel，
   `internal/` 不可被匯出；尚待複驗。
3. JSON 解碼錯誤已改為英文開發者訊息，以避免 l10n 規則誤判；尚待複驗。
4. Notist 的 lockfile 尚未確認已解析到 `0.3.0`。
5. 尚未 commit、push、merge、tag 或建立 GitHub Release。
6. 既有 GitHub CLI 憑證曾被判定無效；執行者必須在發布前確認認證。

### Golden 基準

本任務此時的 PNG 快照是 **45 個 tracked 修改 + 2 個 untracked 新檔**。這些來自
既有候選版；後續 JSON/release 收尾不得增加、減少或重算任一 PNG。

## 執行流程

### WP1：關閉本機程式阻塞

1. 確認無殘留 Flutter/Dart 測試進程正在寫入工作區。
2. 格式化只限當次改動檔案，不全庫重寫。
3. 執行：

   ```powershell
   $env:Path = 'C:\development\flutter\bin;' + $env:Path
   flutter test test/consumer_contract_test.dart test/l10n_discipline_test.dart
   ```

4. 確認 `lib/src/theme/internal/` 檔案沒有從 `lib/kallopis.dart` 匯出。
5. 確認所有 JSON error 保留完整欄位 path，且 l10n 關卡通過。

**WP1 證據**：定點測試的 `All tests passed!` 與 exit code 0。

### WP2：單一完整 Verify

從 VS Code 執行唯一 `Verify` task，或在 repo root 執行等價指令：

```powershell
pwsh -NoProfile -ExecutionPolicy Bypass -File .\tool\verify.ps1
```

不可跳過或重排下列關卡：

1. `dart format --output=none --set-exit-if-changed .`
2. `flutter analyze --fatal-infos`
3. `dart run tool/inventory.dart --check`
4. `flutter test`
5. `example/flutter analyze --fatal-infos`
6. `example/flutter test`

失敗時只修正 root cause，不可改 baseline、allowlist 或 golden。修正後必須從 Verify
第一步完整重跑。

**WP2 證據**：六個關卡的名稱、輸出尾行、exit code 與執行時間。

### WP3：發布前審查

1. 執行 `git diff --check`，必須 exit 0。
2. 確認實質程式檔沒有超過 200 行；codec 的分檔不得為了過關而暴露公開 API。
3. 搜尋 secrets、token、本機絕對憑證路徑與意外的 generated file。
4. 重新計數 PNG，結果必須維持 45 tracked + 2 untracked，檔名不變。
5. 複核 `pubspec.yaml` = `0.3.0`、CHANGELOG 有 `0.3.0`、CI 釘死 Flutter `3.44.4`。
6. 複核 README 同時提供 path dependency 與 Git tag dependency，不使用浮動 `main`。
7. 以新鮮上下文審查整份 diff；有 Required finding 就回到 WP1。

**WP3 證據**：審查結論、finding 清單、PNG 計數與 `git diff --check` exit 0。

### WP4：Notist 本機消費驗證

1. 先讀取 `C:\Projects\Notist\AGENTS.md`，遵循該 repo 規則。
2. 確認 Notist `pubspec.yaml` 使用最簡單的 path dependency：

   ```yaml
   dependencies:
     kallopis:
       path: ../Kallopis
   ```

3. 在 Notist 執行 `flutter pub get`，確認 lockfile/package config 解析為 Kallopis `0.3.0`。
4. 執行 Notist 規定的 analyze/test 或專案 Verify；不得替 Notist 定義新風格。

**WP4 證據**：path 解析結果、Notist 驗證輸出尾行與 exit code 0。

### WP5：GitHub 發布

1. 先確認 GitHub 認證可用，不可把憑證寫入 repo。
2. 只 stage 本候選版明確檔案；複核 staged diff 與 secrets。
3. 建立單一正式發布 commit，記錄 SHA。
4. 推送 `codex/release-json-theme`，等待 branch CI 所有 job 成功。
5. 經 PR 將 branch 合併到 `main`，再等待 `main` CI 成功。
6. 只有在 `main` CI 成功後，才在該 release commit 建立 annotated tag `v0.3.0`。
7. 推送 tag，等待 tag CI 與 `GitHub Release` job 成功。
8. 確認 GitHub Release 存在，tag、`pubspec.yaml` 與 CHANGELOG 版本一致。

任一 CI 失敗時停止後續發布。未推送的 tag 可刪除後重建；已推送的 tag 不得移動，
應以 patch 版修復。

**WP5 證據**：commit SHA、PR/merge 連結、branch/main/tag CI 連結、`v0.3.0`
與 GitHub Release 連結。

## 執行者交付格式

執行者完成後，必須一次提供：

1. 變更檔案與公開 API 摘要。
2. WP1–WP4 每個指令的 exit code 與輸出尾行。
3. PNG 基準比對結果。
4. 獨立 diff review 的 findings；無 finding 時明確寫 `No findings`。
5. commit SHA、PR、branch/main/tag CI 與 GitHub Release 連結。
6. Notist 實際解析到的 Kallopis 版本，以及 Notist 驗證結果。
7. 已知限制與回退方式。

## 最終驗收清單

最終驗收人依序核對：

- [ ] 所有 JSON 可序列化 token 可無損 round-trip。
- [ ] 局部 JSON overlay 只改指定欄位，未知欄位與錯誤型別會含 path 拒絕。
- [ ] 非整毫秒 Duration 不會被靜默截斷，`FontWeight(450)` 可 round-trip。
- [ ] JSON 非 `Cubic` curve 會明確拒絕，不進行近似。
- [ ] token/color/l10n/consumer contract 關卡全數通過。
- [ ] 完整 Verify 六步驟全數 exit 0。
- [ ] PNG 基準仍為 45 tracked + 2 untracked，沒有收尾期間新增視覺差異。
- [ ] Notist 以 `../Kallopis` 解析 `0.3.0` 且專案驗證通過。
- [ ] branch、main、tag CI 都成功。
- [ ] `v0.3.0` 指向正確 release commit，GitHub Release 已建立。
- [ ] 無認證、secret、不相關檔案或未說明的 allowlist/baseline 混入。

全部打勾後才可回報 `ACCEPT`；否則回報 `REJECT` 並列出可重現證據。

## 回退策略

- 本機：Notist 將 path dependency 回復到前一個可用 commit/tag，再執行 `flutter pub get`。
- GitHub：未發布前可修正 branch 並重跑 CI；已發布後保留 `v0.3.0`，以 `0.3.1`
  修復，不替換歷史 tag。
