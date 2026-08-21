# KLP-0.4.1 Workbench 等距修正版發布任務

## 任務資訊

- 狀態：實作與定點驗證完成，待完整 Verify 與 CI/CD
- 基準版本：`v0.4.0`，不得移動或覆寫
- 正式版本：`0.4.1`
- 預定 tag：`v0.4.1`
- 工作分支：`codex/fix-workbench-pane-gap-0.4.1`
- 第一消費者：`C:\Projects\Notist`

## 問題與目標

Notist 的外框已使用 `space.tight` 形成 4px 留白，但 `KlpWorkbenchShell` 的 resize handle
仍固定解析 `space.base`，造成 primary 與 stage 之間為 16px。0.4.1 必須讓欄間距接受消費端
theme token，同時維持未指定參數時的既有 16px 視覺。

## 不可變條件

1. 不移動 `v0.4.0`，修正只能發布為新 patch。
2. 不改 primitive、色票、圓角或預設 spacing 值。
3. `paneGap == null` 必須繼續解析 `context.klp.space.base`。
4. Notist 必須傳入 `context.klp.space.tight`，不得寫死數值 4。
5. 負值、NaN 與 infinity 必須在公開建構邊界拒絕。
6. 不以更新 golden 取代幾何測試；只有預期欄寬變更可更新受影響快照。

## 執行流程

1. 先新增因缺少 `paneGap` 而編譯失敗的 Kallopis widget test。
2. 新增 nullable `paneGap`，並將有效值傳入 primary／secondary resize handle。
3. Notist 使用 `klp.space.tight`，讓左、欄間、右、下四個距離相等。
4. 執行 Kallopis 完整 Verify 與 Notist analyze/test；必要 golden 必須人工比對。
5. 更新 0.4.1 版本、CHANGELOG、README 與兩個 lockfile。
6. 推送分支、建立 PR；branch、PR、main CI 全綠後才建立 annotated `v0.4.1`。
7. 等待 tag CI 與 GitHub Release 成功，再確認本機 main、tag 與 Notist path 解析一致。

## 驗收條件

- [x] 新測試在實作前因缺少 `paneGap` 穩定失敗。
- [x] Kallopis 定點測試確認 resize handle 寬度等於呼叫端 token。
- [x] Notist 幾何測試確認左、欄間、右、下皆等於 `space.tight`。
- [ ] Kallopis format、analyze、inventory、root test、example analyze/test 全數通過。
- [ ] Notist analyze 與完整 test 全數通過。
- [ ] branch、PR、main、tag CI 全數成功。
- [ ] `v0.4.1` GitHub Release 存在，且 tag 指向正式合併 commit。

## 回退

- 發布前若驗證失敗，移除 `paneGap` 與 Notist 接線並回到 `v0.4.0`。
- 發布後保留歷史 tag；任何新問題另發 patch，不移動 `v0.4.1`。
