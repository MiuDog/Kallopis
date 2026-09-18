# Menu：新版宣告與組裝

## 用途與可用狀態

`kallopis_declarative.dart` 的 `KlpMenu` 是真正的宣告式選單面板；`KlpMenuItem` 是它的封閉資料項目。CM-01 已接通 runtime 與 renderer，程式行為驗證通過；人類外觀接受待定。舊 Menu 仍供未遷移家族使用，不代表全库遷移完成。

## 如何宣告

完整互動規格見[選單完整互動遷移](../../spec/menu-interaction-migration.md)。CM-02 已接通子選單展開／返回，CM-03 已提供由庫管理的彈出定位與關閉；工作區舊選單呼叫端尚待另行接線。

- Menu：`id`、`label`、`items`；可提供 `autofocus`（預設 true）、`onEscape`。
- 提供非空 `triggerLabel` 時，庫呈現選單入口並管理浮層；不提供時保留獨立面板。使用端不傳入座標、Widget 或開關控制器。
- Item：`id`、`label`；可提供 `KlpWorkspaceIcon` 圖示、`shortcut` 顯示文字、`toggleValue`、`selected`、`enabled`、`destructive`、實線／虛線前置分隔與 `onPressed`。
- `children` 提供不可變子項目清單；非空即為子選單父項，不能同時提供 `onPressed`。整棵項目樹的 id 必須唯一。`hasSubmenu` 保留舊指示用途，新增子選單使用 `children`。
- `shortcut` 是顯示資料，不自行註冊系統快捷鍵。

可執行完整範例：[`menu_specimen.dart`](../../example/lib/catalog_declarative/menu_specimen.dart)。

## 如何組裝

`KlpMenu` 放在 `KlpFrameGroup.content`；群組經 `KlpFrameGroups` 放入 `KlpAppFrame`。它只接受 `KlpMenuItem` 清單，項目不接受子節點、Widget、builder、局部尺寸／style，也不能作為獨立 runtime 節點放入 FrameGroup。

選單入口仍使用同一受限組裝位置，浮層由 renderer 安裝於根 Overlay，隨節點移除而清理。這不開放任意 overlay／popover 組裝。工作區命令的既有浮層仍待遷移接線，不能以新面板存在宣稱所有選單呼叫端已替換。

## 如何更新

consumer 擁有 selected／toggleValue 及動作結果；事件後更新 `KlpMutableState<KlpApplication>`，以同一 destination、節點 id 保留工作階段身分。hover／pressed／鍵盤高亮由 renderer 暫存，不寫入 consumer 選取資料。舊 frame 的事件在新資料提交後失效。

點擊父項或 Enter／Space／向右鍵進入子選單；點擊帶返回箭頭的標頭或向左鍵返回，恢復父項高亮。Escape 仍通知根 `onEscape`。一次只呈現目前層級；資料更新後保留仍有效的路徑，父項移除、停用或清空時截斷到有效上層。子選單路徑由庫管理，所有深層操作均受 frame lease 保護。

## 布局與視覺保證

浮層以入口為錨點，優先向下，空間不足改向上或限制在視窗內；視窗改變時重新布局。長內容沿用可捲動面板。入口可點擊或以 Enter／Space／向下鍵開啟，焦點移入選單；外部點擊只關閉不穿透，Escape 關閉並通知 `onEscape`，有效葉項操作後關閉，停用與父項導覽不關閉。關閉後焦點返回入口。

相鄰選項間保留獨立的 `itemGap` 語意間距，預設 4px；根選單與子選單共用。已有分隔線的項目保留分隔線上下留白，不再疊加列間距。

舊選單的 200 寬、28 標頭／列高、4 內距、8 水平 inset／gap、14 圖示、7 面板圓角與6項目圓角，經本庫 `KlpMenuRecipe` 按對應已解析原料換算。字型保留 package ownership；hover／selected 使用同一互動色，已接受的圖示呈現沿用 Lucide renderer。

有限高度由捲動承載，键盤高亮移動會帶入可見範圍。未宣稱所有文字縮放及平台皆經人類接受。

## 不合法或未提供的用法

空白標籤、重複 item id、同時選兩種分隔均拒絕。停用項目不呼叫 consumer。選單沒有資料儲存、業務刪除或自動變更 toggle 的權威。

## Catalog 與證據

在 `example` 執行 `D:/flutter/bin/flutter.bat run -d windows -t lib/catalog_menu_main.dart`；深色加 `--dart-define=CATALOG_DARK=true`。Web 可用相同入口。

[`klp_declarative_menu_test.dart`](../../test/klp_declarative_menu_test.dart) 的6項檢查涵蓋資料／拒絕／不可變、指標、鍵盤、disabled、hover／selected、舊frame callback。整體遷移狀態與刪除條件見[固定清冊](../architecture/catalog-migration/README.md)。
