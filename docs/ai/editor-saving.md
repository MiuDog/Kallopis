# 編輯器保存與重開（實驗）

本系統使用同一 editor source 的保存能力；Krepis 擁有文件格式、持久化與衝突判斷，Kallopis 只讀取作業投影並發出受控意圖。協定與正式 owner 保存／重開已通過獨立驗證；可見操作入口仍在實作，不能以此頁宣稱完整 K09 已交付。故障注入的證據限制見 [K09 契約](../architecture/editor-save-feedback-contract-plan.md#目前驗證證據)。

## 安裝與操作

產品組合根持有 `KrepisKallopisEditorOwner`，畫面仍只注入 `owner.source`。新文件使用 `openWindows` 並明確提供 `savePath`；既有文件使用 `openFileWindows(path: ...)`，其餘字型、文件身分、尺寸與標籤參數見 [可執行 Catalog 入口](../../example/editor_native/lib/main.dart)。載入在新 engine 首次發布前完成，失敗不會改成空白文件繼續顯示。

```dart
final content = KlpEditingContent(id: 'editor', source: owner.source);

// 由產品已授權的保存動作呼叫；不設定自動保存或關閉保存政策。
final reply = owner.save();
final state = owner.source.saveState.value;

// 重試必須仍是可重試的最新失敗，owner 會發出新作業。
if (state.retryAllowed) owner.retrySave();

// 僅釋放 owner；不隱含保存。
await owner.close();
```

此片段延用已建立的 `owner`；`content` 安裝到既有 Workspace 內容插槽。產品不得在畫面中新增 Flutter Widget、傳入 engine 或自行建立第二份文件保存狀態。

## 狀態與事件

`KlpEditingSaveSource` 從 `kallopis_editing_provider.dart` 提供 `saveState` 與 `submitSave`。狀態為 `KlpState<KlpEditingSaveProjection>`，借用端只能讀取／訂閱；解除訂閱不會取消已開始的檔案寫入。

| 欄位 | 意義 |
|---|---|
| `documentId/pageId/sessionId/generation` | 所屬來源，不能跨來源套用 |
| `stateRevision/jobId` | 投影順序／保存作業身分，不是文件版本 |
| `requestedContentRevision` | 此作業要求保存的內容版本 |
| `confirmedSavedContentRevision` | 最近確認已保存的內容版本；新文件可為 null |
| `phase` | `idle/saving/saved/failed` |
| `error/outcomeKnown/retryAllowed` | 失敗分類、是否確認結果、是否允許明確重試 |

`saved` 只證明對應版本保存成功。後續編輯不能沿用先前的成功狀態；不能以文字修改成功、關閉成功或舊保存時間當成最新內容已保存。

庫內呼叫 `submitSave` 時使用同一來源核發的 `sequence` 與當前 `expected` stamp。一般 `save` 禁帶重試欄位；`retry` 必須同時攜帶 `expectedStateRevision`、`failedJobId`，且仍符合最新失敗。不要自行計數或重送未知結果。

## 拒絕與生命週期

- 新文件的目的地若已存在，核心拒絕覆寫；已載入文件不能透過此接口另存到不同路徑。
- 活躍組字、來源忙碌、過期請求及關閉中的來源拒絕保存；保存不替使用者確認組字。
- 寫入後仍可能發生錯誤；`outcomeKnown == false` 不代表未寫入。此時禁止重試，也不能以一般保存繞過限制。
- 不得為核對保存而重新 load 活躍文件，因為這可能覆蓋未保存編輯。正式重開使用新的 owner。
- 路徑只由 owner 持有，不進入 Kallopis 呈現投影；不使用無衝突保護的 legacy save。

Catalog 的既有文件與新保存目的地參數見 [啟動方式](../../example/editor_native/README.md)。完整權威與驗收條件見 [K09 契約](../architecture/editor-save-feedback-contract-plan.md)。
