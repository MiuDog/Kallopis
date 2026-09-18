# 編輯內容系統（實驗）

本頁供組裝畫面的 AI 使用。`KlpEditingContent` 提供受限的編輯幾何呈現與來源訂閱，並依來源能力安裝重排與輸入接點。Windows 平台輸入正在驗證；手寫、完整筆記操作與實機驗收尚未完成，不得將此節點描述成完整筆記編輯器。

## API 與安裝

產品只匯入 `package:kallopis/kallopis_declarative.dart`。`KlpEditingContent` 接受 `id` 與已初始化的 `source`，實作 `KlpWorkspaceContent` 資格，放入 Workspace 合法內容插槽。內建 adapter 隨 application bootstrap 註冊，產品不手動註冊 renderer 或 mount。

以下是既有 Workspace 的組裝片段；`source` 由應用開啟流程取得，`leftContent`、`rightContent` 是既有合格側欄內容：

```dart
final workspace = KlpWorkspace(
	id: 'workspace',
	title: '筆記',
	left: leftContent,
	stage: KlpEditingContent(id: 'editor', source: source),
	right: rightContent,
);
```

外層 Screen／Router／Application 依 [共用組裝模板](composition-templates.md)。不能以 `Widget`、自訂 Painter、文字測量、局部 style 或自行畫游標補足尚未接入的功能。

## 資料與生命週期

來源介面及發布格式見 [編輯提供者契約](editing-provider.md)。Krepis 提供者先呼叫 `read()`，確認取得真實快照後才將 source 注入結構樹。產品節點不直接開啟 DLL 或配置原生記憶體。

安裝端訂閱來源、維持最後一致快照，並管理自己的輸入連線。來源與核心 engine 仍由提供者擁有；可編輯來源關閉前必須等待本庫中斷輸入，取消尚未確認的組字並保留已提交內容，才可釋放核心。非法版本更新不能替換已顯示快照，錯誤交給訂閱所在 zone；來源錯誤不能被描述成保存成功。

| 來源能力 | 本庫安裝行為 |
| --- | --- |
| `KlpEditingSource` | 呈現固定幾何並訂閱更新。 |
| `KlpEditingLayoutSource` | 加入實際尺寸與本庫完整解析風格的重排要求，可保持唯讀。 |
| `KlpEditableSource` | 再加入鍵盤／IME、點擊定位與中斷生命週期接點。 |

同一來源可另實作 `KlpBlockControlSource`，由 `blockControls` 插槽啟用 [區塊控制機制](block-controls.md)。控制節點不再注入另一個 source；文字與區塊命令共用來源的 `issueCommandSequence()`。目前區塊的可見與鍵盤／讀屏入口尚未交付。

## 目前限制

定位命令另使用 `anchoredCommands` 受限插槽與父來源的 `KlpAnchoredCommandSource`，見 [定位命令組裝模板](anchored-commands.md)。操作機制已通過相關協定驗證，尚未提供可見選單或開啟入口。

模式切換與垂直導覽使用 `modeToolbar` 及同源 `KlpEditorModeSource`，見 [模式與導覽模板](editor-modes.md)。相關協定已驗證，尚無可見切換入口；目前 Dart binding 建立原生 engine 需 ABI 1.28（模式所需 Flow 高度接口於 1.26 加入）。

- 可重排來源由本庫回報尺寸與風格；呈現使用重排後的 viewport 幾何，不能縮放舊 frame 假裝完成新寬度排版。
- 文字、筆跡、游標與選取色彩由庫內語意決定，現有四色映射屬候選，並非完整視覺定型。
- 目前 Krepis 轉接只接受套件 Noto Sans TC、字重 400、無額外 fallback 與零字距；不支援的字型設定明確拒絕。這是提供者的目前支援邊界，不是 consumer 可繞過的局部風格輸入。
- 平台輸入接線尚在驗證；完整切頁／模式、捲動、手寫、跨區塊操作與無障礙文字導覽，不能由上述接點推定已完成。
- 已提供獨立的 [真實核心 Windows Catalog 入口](../../example/editor_native/README.md)，沿用原 Catalog 組裝並載入套件 Noto Sans TC。需要配置本機 Krepis checkout 與 DLL；執行證據見該入口文件。Windows 正常退出已確認會等待 owner 完成並以 exit code 0 結束；組字中的關閉、Windows 真實 IME 與正式視覺驗收尚未完成。

完整實作範圍及進度見 [筆記元件計畫](../architecture/note-components-plan.md)。
