# Workspace Block 能力審核

日期：2026-09-20

結論：舊 `KlpWorkspaceBlock` 不應恢復。它以一個 `kind` schema 同時承擔 action、文件、
搜尋、設定、collection、dialog 與 toolbar，這正是 KLP-0022 已移除的第二套 UI framework。
逐項比對後，仍屬 design system 的能力已有直接 Flutter owner；畫面組合則由 consumer 擁有。

## Block kind 對照

| 舊 kind | 現行直接 API | 判斷 |
| --- | --- | --- |
| `identity` | `KlpSidebarIdentityHeader`、`KlpWindowAppIcon`、`KlpAppWindowHeader` | 已覆蓋；identity 所在 shell 決定具體組合。 |
| `action` | `KlpButton`、`KlpIconButton`、`KlpListTile`、`KlpActionRegion` | 已覆蓋；不再用一個 block model 推測 action 外觀。 |
| `paper` | `KlpPageChrome`、`KlpDocumentHeader`、`KlpDocumentSection`、`KlpDocumentField` | 已覆蓋；高階文件組合由 experimental 入口提供。 |
| `sticky` | `KlpCard`、`KlpInlineNotice`、`KlpPreviewCard` | 已覆蓋；不恢復 `material: sage` 這類舊 renderer 分支。 |
| `search` | `KlpTextField`、`KlpFilterBar`、`KlpCommandMenu` | 已覆蓋；query 與 results 仍由 consumer 持有。 |
| `settings` | `KlpSettingsPage`、`KlpSettingsDialog`、settings navigation／content 系列 | 已覆蓋於 experimental；設定資料與路由由 consumer 擁有。 |
| `board` | `KlpMasonryGrid`、`KlpCard`、`KlpDataTable`、`KlpTree` | 已覆蓋；board 欄位與排序是產品組合。 |
| `cards` | `KlpCard`、`KlpMetricCard`、`KlpPreviewCard`、`KlpComponentLibraryGrid` | 已覆蓋；不再由 `items` 推測卡片種類。 |
| `dialog` | `KlpDialog`、`KlpModalFrame` 及各高階受控 dialog | 已覆蓋；route ownership 留給呼叫端或具名 compound component。 |
| `toolbar` | `KlpSelectionToolbar`、`KlpEditorToolbar`、`KlpStageTopBar`、`KlpIconButton` | 已覆蓋；一般工具列由 consumer 以 Flutter Row 組合具名 Kallopis actions。 |

## Content kind 對照

| 舊 content kind | 現行 owner |
| --- | --- |
| `text`／`heading`／`lead` | `KlpText` 的 semantic roles |
| `callout` | `KlpInlineNotice` |
| `divider` | `KlpDivider`／`KlpFrameGroupDivider` |
| `link` | `KlpDocumentReferenceLink` 或具名 `KlpButton`／`KlpListTile` action |
| `checklist` | `KlpCheckbox` 與 consumer-owned item data |
| `group` | Flutter Widget tree、`KlpFrameGroup` 及必要的 Kallopis layout primitives |

## 已補回的真實缺口

- `KlpDocumentTabs`：穩定 ID、dirty、pin、close、鍵盤與 accessibility。
- `KlpAnchoredPopup`／`KlpWorkspaceCommand`：錨定 overlay、受控 open、輸入／確認／結果。
- `KlpAppLayout.floatingAction`：呈現期拖曳位置與 viewport clamp。

這些能力無法只靠 consumer 排列現有 primitive 得到一致互動，因此由 Kallopis 擁有；它們
皆已改成直接 Flutter API，沒有恢復 node、adapter、bound model 或 renderer。

## 刻意不恢復

- `KlpWorkspaceBlockKind`、`KlpWorkspaceContentKind` 及以 enum 選 renderer 的總 schema。
- `lines`、`items`、`choices` 等跨領域萬用資料袋。
- product action dispatcher、產品 navigation、selection、storage 或業務狀態。
- 任意 consumer style／pixel；現行元件仍由 semantic theme 控制視覺。

因此本審核沒有新增第四批元件。若日後出現缺口，必須先證明是至少兩個產品共享的完整
視覺／互動能力，再建立具名元件；不得重新擴張 `WorkspaceBlock`。
