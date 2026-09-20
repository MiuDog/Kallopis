# Anchored Popup Architecture

狀態：PLAN READY

目前階段：Direct Anchored Popup v1

規格：[通用錨定 Popup](../../../../../spec/anchored-popup.md)

## 目的與邊界

本 module 將受控 trigger、錨定 overlay、平面 items、commands 與 feedback 組成一個
直接 Flutter compound component。Consumer 持有 open、資料與產品操作；本 module 只持有
overlay controller、focus nodes、目前 child route 與命令輸入 controller 等呈現期資源。

## 責任配置

- `klp_anchored_popup.dart`：公開資料、受控 Widget 與 overlay lifecycle。
- `klp_workspace_command.dart`：公開命令／結果及可重用顯示入口。
- `internal/`：panel、item、position delegate 與 child-route owner。
- 既有 button、context menu、dialog、field、feedback、theme：只透過公開元件契約重用。

## 依賴方向

```text
KlpAnchoredPopup
	→ internal popup presentation／lifecycle
	→ KlpWorkspaceCommand flow
	→ public Kallopis controls／overlay primitives／semantic theme
	→ Flutter OverlayPortal／focus／semantics
```

不得依賴 application、composition、runtime、bound presentation、private renderer、Dock state
或產品 model。

## 不變條件

- `open`、items、actions、state 與 message 都由目前 Widget 輸入決定。
- overlay lifecycle 不產生第二份 open；request 只回報 consumer。
- trigger bounds 是唯一定位來源；consumer 不傳座標或 placement pixel。
- Popup 關閉或被移除時，module 只移除自己建立的 command route。
- 所有輸入／確認完成前不 invoke；invoke exception 轉為 failed result，未提供 result handler
  時交給 Flutter error reporting。
- item primary action 與 commands 都不自動關閉 parent popup。
- style、geometry、localization 只來自現行 Kallopis API。

## APR-S1：Direct popup 與 command flow

可觀察結果：consumer 可從 `kallopis_foundation.dart` 建立受控錨定 popup，顯示並更新
items／actions／feedback，執行需要輸入或確認的 async command，並接收結果。

允許寫入：

- `lib/src/features/workspace/anchored_popup/**`
- `lib/kallopis_foundation.dart`

驗收：公開入口與 module 局部 analyze；既有 popup／menu／keyboard tests；source scan 不含
舊 runtime。必要新 deterministic tests 由獨立 Test Author 擁有，本 BUILD 不修改 tests。

Milestones：

1. Command flow：資料驗證、輸入／確認、單次 async invoke、result 與 route ownership 完成。
2. Anchored overlay：受控 lifecycle、定位、外點／Escape、焦點、items／actions／feedback 完成。
3. Public integration：foundation export、局部測試與 scope check 完成。

估計：cold-start，參照歷史 anchored popup renderer 與現行 overlay controls；預期
24k–40k tokens、120–240 分鐘。超過 55k tokens 或 360 分鐘時停止檢查 overlay／focus
ownership 是否應拆成後續 slice。

PLAN READY：AP-01～AP-09 均映射至 APR-S1，沒有未決 P1 架構選擇。
