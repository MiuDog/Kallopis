# 手寫暫態資料系統（實驗）

本頁描述提供者的暫態快照與發布 API，資料協定已通過獨立驗證。它與已提交 drawing 分開記錄筆劃進度，但仍屬於同一編輯來源。正式落筆目標解析、平台取樣、預覽渲染與手寫工具尚未接入。

## 組裝入口

consumer 沿用既有 [編輯器模板](editor.md)，不新增手寫 source 或自由繪製節點：

```dart
final editor = KlpEditingContent(
	id: 'editor',
	source: source,
);
```

畫面從 `package:kallopis/kallopis_declarative.dart` 匯入。以下型別從 `package:kallopis/kallopis_editing_provider.dart` 匯入，供提供者實作使用；實作此資料能力不會自動啟用手寫模式。

## 快照格式

| 型別／欄位 | 契約 |
|---|---|
| `KlpHandwritingStateSource` | 繼承 `KlpEditingSource`，額外提供 `inkState` 與非同步 broadcast `inkStates`。 |
| `KlpHandwritingCaptureIdentity` | `id` 是來源核發的不透明身分；`generation` 必須單調，可使用開始筆劃時的共用 editor 命令序號。 |
| `KlpHandwritingState.drawing` | 該 capture 凍結的原 drawing reference；append 不建立同 stamp 的另一份 drawing。 |
| `phase` | capturing、overloaded、committed、canceled 或 unknown；未知結果不能當成提交或取消完成。 |
| `acceptedBatchSequence`／`previewRevision` | 核心接受的批次收據與預覽版本，各有用途，不能拿 editor 命令序號取代。 |
| `sampleCapacity`／`bufferedSampleCount`／`remainingSampleCapacity` | 由核心結果轉接；不在 Kallopis 另寫一套容量預設。 |
| `previewCommands` | 不可變的既有封閉幾何，僅允許 `ink` 用途，裁切與變換必須正確配對。 |

預覽使用既有 `KlpEditingDrawPath`、矩形、clip 及 transform 資料，不接受 Flutter `Path`、`Widget`、painter callback 或顏色參數。實際 `ink` 色彩仍由本庫語意解析。

## 提供者接線片段

提供者可持有一個 `KlpHandwritingStatePublisher`，將自己的目前 drawing getter 交給它；這是原有來源內部的資料發布工具。以下片段加入既有來源類別，不是另一個 consumer source：

```dart
late final _ink = KlpHandwritingStatePublisher(() => drawing);

@override
KlpHandwritingState? get inkState => _ink.state;

@override
Stream<KlpHandwritingState?> get inkStates => _ink.states;
```

核心結果映射成完整 `KlpHandwritingState` 後呼叫 `_ink.publish(state)`；拒絕更新不得改 current 或發事件。終態清除預覽，提供者完成核心結果確認與資源釋放後，再以 `_ink.clear(capture)` 清除暫態紀錄。來源擁有 `_ink.close()` 的生命週期；這個方法只關閉發布器，不代替核心 capture 的取消或釋放。

## 驗證與未完成項目

獨立驗證涵蓋手寫資料、既有 drawing 回歸及架構邊界：`+164: All tests passed!`，exit 0；靜態分析為 `No issues found!`。核心 ABI 1.27 與 Dart 綁定的原生／真 DLL 證據見 [手寫工程契約](../architecture/handwriting-input-contract-plan.md)。筆跡附著區塊或整頁、缺通道編碼與筆劃中斷政策尚未決定，不能以空 anchor 或猜測壓力值接上正式 begin。
