# 定位命令系統（實驗）

供 consumer 與 AI 組裝編輯器命令能力。K03 的資料、同源插槽與命令操作機制已通過相關協定驗證。可見選單、開啟按鈕、鍵盤入口、Overlay 定位與焦點返回尚未交付，不應把安裝節點解讀成已有可操作選單。

## 前置需求

- 畫面只匯入 `package:kallopis/kallopis_declarative.dart`。
- `source` 是既有編輯器的唯一來源，另實作 `KlpAnchoredCommandSource`。提供者契約從 `package:kallopis/kallopis_editing_provider.dart` 匯入。
- 提供者發布的 `drawing.anchoredCommands` 必須與編輯投影具有相同 stamp、viewport 與同幀錨點。

## 組裝模板

在既有 Workspace 的內容位置安裝：

```dart
final editor = KlpEditingContent(
	id: 'editor',
	source: source,
	anchoredCommands: const KlpAnchoredCommands(id: 'editor.commands'),
);
```

`anchoredCommands` 只接受 `KlpCommandSlotChild`，最多一個；`KlpAnchoredCommands` 只帶結構 id。它從父編輯器繼承能力，不另外注入 source、執行 callback、座標、Widget 或 style。可與 [區塊控制](block-controls.md) 共存，仍共用同一來源。

## 提供者資料格式

| 型別 | 用途與約束 |
|---|---|
| `KlpCommandItem` | 穩定 id、label、availability，以及受限 tone、selected 與選用 caption／停用原因。selected 是領域資料，不能作為鍵盤高亮。 |
| `KlpCommandProjection` | stamp、候選 revision、typed anchor、emptyLabel 與不可變有序 items；重複 id 或不同版本錨點拒絕。 |
| `KlpCommandRequest` | commandId、commandRevision、expected stamp、anchor 與單次 sequence；確認時重新核對，不依陣列位置派送。 |
| `KlpCommandReply` | 明確 accepted／rejected 與最新編輯權威；未知結果不能偽裝為拒絕或成功。 |

`KlpAnchoredCommandSource` 提供 `issueCommandSequence()` 與 `submitAnchoredCommand(request, committedAtMs: ...)`。序號必須與文字、區塊操作共用；將命令映射到既有核心操作時，不得再消耗第二次相同序號。來源負責內容與原子驗證，本庫負責互動暫態及呈現。

## 生命週期契約

開啟前先取消未確認組字、保留已提交內容，等待中斷完成後取得新的錨點與候選。導覽與關閉是本庫暫態；確認才送一次命令。空清單或全部停用時沒有有效選取，也不派送操作。已關閉的選單不得因晚到回覆再執行一次；未知結果要求重新同步，不自動重送。

確認前若錨點從區塊 A 換成 B，即使命令 id 相同也拒絕該次舊意圖。關閉後才回報的未知交易仍保留重新同步要求。相關協定與 K01／K02 回歸、架構邊界合計 203 項測試通過；靜態分析、真實 DLL 命令檢查及 Windows debug 建置通過，未進行可見選單或實機 IME 驗收。

目前進度以 [K03 設計契約](../architecture/anchored-commands-contract-plan.md) 為準。slash、搜尋、分類與產品快捷鍵尚未定義，consumer 不應自行建立第二套入口繞過本庫。

## 排錯

| 現象 | 檢查 |
|---|---|
| 能安裝但沒有可見選單 | 目前尚未交付可見入口，不是加上原生 Widget 的理由。 |
| 錨點或投影建構失敗 | 檢查完整 stamp、viewport、有限幾何與候選 id 唯一性。 |
| 命令遭拒絕 | 使用新權威投影核對版本及 availability；不改送另一個命令。 |
| 確認結果未知 | 先 resync；不得推定保存成功或自動重試。 |
