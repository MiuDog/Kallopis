# Workspace 宣告式框架

## 通用錨定 popup（POP-V1-r1）

本 stage 依 [接受規格](../../../../spec/anchored-popup.md) 交付 `Workspace.AnchoredPopup`。Consumer 擁有 `open`、清單、回饋與業務操作；Kallopis 擁有 trigger 錨定、受限 panel、焦點、dismiss、命令呈現及 semantic style。它不擁有產品資料、導航、Stage／Explorer selection、持久化或 Planist 專用組裝。

### 公開契約

```dart
enum KlpAnchoredPopupChangeReason {
	trigger,
	outside,
	escape,
	anchorUnavailable,
}

enum KlpAnchoredPopupState { loading, ready, error, result }

final class KlpAnchoredPopupItem {
	final KlpId id;
	final String label;
	final String? subtitle;
	final KlpWorkspaceIcon? icon;
	final bool current;
	final bool enabled;
	final FutureOr<void> Function()? onPressed;
	final List<KlpWorkspaceCommand> commands;

	KlpAnchoredPopupItem({
		required this.id,
		required this.label,
		this.subtitle,
		this.icon,
		this.current = false,
		this.enabled = true,
		this.onPressed,
		this.commands = const [],
	});
}

final class KlpAnchoredPopup implements KlpCompositeNode {
	static const typeId = 'kallopis.anchored_popup';
	static final triggerSlot = KlpSlot<KlpWorkspaceBlock>(
		owner: typeId,
		name: 'trigger',
		min: 1,
		max: 1,
	);

	final KlpId id;
	final KlpWorkspaceBlock trigger;
	final bool open;
	final String accessibilityLabel;
	final String? title;
	final List<KlpAnchoredPopupItem>? items;
	final List<KlpWorkspaceCommand>? actions;
	final KlpAnchoredPopupState state;
	final String? message;
	final void Function(bool, KlpAnchoredPopupChangeReason) onOpenChanged;

	KlpAnchoredPopup({
		required this.id,
		required this.trigger,
		required this.open,
		required this.accessibilityLabel,
		this.title,
		this.items,
		this.actions,
		this.state = KlpAnchoredPopupState.ready,
		this.message,
		required this.onOpenChanged,
	});
}
```

`items`／`actions` 使用 nullable list 區分區段不存在與存在但為空；所有輸入 list 建立不可變快照。標題為可選；items、actions 或非 ready feedback 至少存在一項。`accessibilityLabel`、item label、非 null title/subtitle 不能空白；error/result 的 message 必須非空。Item 使用 `KlpId`，同一 popup 內重複 ID 拒絕而 label 可重複；主要操作僅在 `enabled && onPressed != null` 時有效。

Trigger 固定為一個 `KlpWorkspaceBlockKind.action`，且 `action`、`onPressed`、`actions` 皆空、`selected == false`；parent renderer 是其唯一 activation owner。開關只呼叫 `onOpenChanged`，不自行改 `open`，也不派送產品 action、導航或 selection。

### 內部責任與資料流

`KlpAnchoredPopupAdapter` 擁有唯一 `KlpDefinition<KlpAnchoredPopup>`、trigger slot 驗證、immutable bound projection 與 style resolution。`KlpBoundAnchoredPopup` 保存已解析 trigger、資料、事件及 geometry；`KlpFlutterAnchoredPopup` 只呈現 bound snapshot。依賴方向維持 composition／styling → workspace declaration／adapter → workspace presentation → Flutter rendering；application root 只安裝固定 adapter，consumer 沒有 registry extension。

Bound popup 欄位固定為：一個 `KlpBoundTemplate trigger`；open、accessibilityLabel、title、state index、message、open callback；nullable `List<KlpBoundAnchoredPopupItem>` 與 `List<KlpBoundWorkspaceCommand>`。Bound item 保存 `KlpId`、label、subtitle、icon index、current、enabled、nullable `FutureOr<void> Function()` 及 commands。Style 欄位為 surface、foreground、mutedForeground、interaction、shadow、destructive 六個 `KlpColor`，inset、gap、rowExtent、viewportInset、panelWidth、shadowOffset、shadowBlur 七個 `KlpDistance`，radius 與 `KlpBoundTextStyle`。

Semantic owner 是 `kallopis.anchored_popup`：surface／foreground／muted／interaction／shadow 分別引用 color i3／i1／i4／i5／i6；destructive 使用既有 `KlpWorkspaceMaterialRecipe.accent(surface)`。inset／gap／rowExtent／viewportInset 引用 distance i2／i1／i5／i2；adapter 由 rowExtent × 9 得 panelWidth、gap 得 shadowOffset、inset × 2 得 shadowBlur。radius 引用 radius i2，文字引用 font family i0、size i2、weight i3、line height i4、letter spacing i3。不得新增 preset、theme、consumer style 或 renderer 常值來源。

Flutter renderer 使用 SDK 的 `OverlayPortal.overlayChildLayoutBuilder`，從 child paint transform、child size 與 overlay size 取得目前 anchor，方向感知地先放下方起始側，空間不足翻至上方，再以 viewportInset 限制邊界；layout callback 使 trigger 移動時同步定位。外點 barrier、Escape 與 trigger toggle 只發關閉請求。Trigger 消失時立刻撤下可互動 overlay，並以 one-shot guard 發 `anchorUnavailable`。相同 placement 的 bound 更新保留 renderer state，讓 open panel 原地更新 loading／ready／error／result。

`KlpFlutterWorkspaceBlock` 只新增 package-private activation、focus、expanded 與 selected override，預設 null 時保持既有行為；popup parent 用它讓原本 `onPressed == null` 的 action trigger 具 popup 操作、expanded semantic 及 focus return。Panel 使用獨立 `FocusScopeNode` 的 closed-loop traversal；開啟後聚焦首個有效控制，無有效控制則聚焦 panel，關閉後回有效 trigger，否則交給既有 application focus fallback。

Item commands 直接使用 `showKlpCommandMenu`，panel actions 直接使用 `runKlpCommand`；兩者只取得同一 bound style。子命令 route 位於 popup 之上，關閉子命令不關 popup；子命令開啟時 Escape 先由它處理。任何方案若需要另一套表單、theme、registry extension、任意 child renderer 或 popup node 巢狀，均不屬本 stage。

### POP-V1-01 單一垂直切片

BUILD 只可修改：

- `lib/src/features/workspace/components/klp_anchored_popup.dart`
- `lib/src/features/workspace/components/adapters/klp_anchored_popup_adapter.dart`
- `lib/src/features/workspace/presentation/klp_bound_anchored_popup.dart`
- `lib/src/rendering/flutter/internal/klp_flutter_anchored_popup.dart`
- `lib/src/rendering/flutter/internal/klp_flutter_commands.dart`（r1a：僅可選的子 route 所有權／取消配對，既有 caller 不變）
- `lib/src/features/workspace/presentation/klp_workspace_presentation.dart`
- `lib/src/rendering/flutter/internal/klp_flutter_workspace_block.dart`
- `lib/src/rendering/flutter/klp_flutter_renderer.dart`
- `lib/src/application/bootstrap/internal/klp_application_adapters.dart`
- `lib/kallopis_declarative.dart`
- `lib/src/features/catalog/component-ownership.json`
- `lib/src/application/bootstrap/internal/klp_application_catalog.json`

`spec/`、本 `architecture.md`、所有 `test/`、fixture、baseline、tool 與其他 module 皆受保護。Test Author 另擁有 popup 行為測試及 catalog／prepared renderer／module boundary 接受基線；BUILD worker 只能讀取並執行，不得修改或弱化。

完成證據須覆蓋：公開 API 與 catalog 固定登錄；非法 trigger、空 panel、重複 item ID；受控 open 未回填不偷關閉；同 placement 四狀態更新；重名 item 不誤投；外點、兩層 Escape、焦點循環與回返；anchor 移動／翻轉／失效；開關期間產品 callback 為零；替換完整 primitives 後重新解析 semantic。Catalog 人類外觀與原生焦點手感保持 human-pending，不以 golden 或 AI 評分取代。

## 命令選單接入（2026-09-15）

使用者授權工作區與編輯器命令選單統一採既有 `KlpMenu`。`showKlpCommandMenu` 保留命令資料與過期檢查，底層改由 `klp_flutter_menu.dart` 共用 route 及庫內 theme 橋接；產品仍只使用公開宣告式命令 API。BlockNote Generic.Menu／格式選單及 slash 接 `KallopisMenu`，JS 不自畫選單；跨頁 generation 與正文快照限制過期提交。一般對話框及 emoji picker 維持原職責，未更動保存協定版本。

## EXP-V1-r3 箭頭與後代收合

依 EXP-17～19，PLAN／BUILD 已完成，局部驗證通過；EXP-V1-r3 Catalog 外觀與互動已由使用者於 2026-09-15 回覆「同意」接受。分類一律顯示箭頭，可收合空分類可切換；一般節點仍需有子項。兩種箭頭使用 disclosureIconExtent（distance i3，12px），命中及一般圖示保持 20px。KlpExplorerData.expandedIdsAfter(KlpId id, bool expanded, {bool collapseDescendants = false}) 回傳該項所屬樹的不可變完整展開集合，不提交資料；遞迴模式移除所有後代含隱藏後代，其他樹與選取不變。未知項或不可切換項拋 explorer_invalid_expansion。既有 onExpandedChanged(id, bool) 保持。 本 slice 寫 explorer/klp_explorer.dart、explorer/klp_explorer_snapshot.dart、explorer/internal/klp_explorer_capture.dart、explorer/internal/klp_explorer_adapter.dart、presentation/klp_bound_explorer.dart。快照集中 canToggleExpansion 資格；adapter 傳遞共用箭頭語意。測試與本檔受保護。


## 透明工具列契約修正（2026-09-15）

工具列新增 `toolbarAlignment: KlpWorkspaceToolbarAlignment.start/end`；預設 start，end 將項目排列在可用寬度尾端，保留 items 次序。此選項經 adapter／bound 傳到 renderer，消費端不提供原始幾何或 Flutter alignment。

依使用者明確授權修正既有 `KlpWorkspaceBlockKind.toolbar`：保持 items／事件 API，移除膠囊表面及內外距；整列高度與正方形按鈕邊長均取既有 header 語意（預設 32px）。此為既有種類的呈現契約修正，所有宣告式 toolbar 消費者一併適用，不新增產品專用元件或樣式參數。`KlpFrameGroup` 可包住 toolbar 及其他 FrameGroup；外層提供一次 standard 水平內距，內層選 none，前置 sectionGap 提供 8px。產品自行決定工具項目與排列。

局部證據：既有 icon toolbar 渲染測試通過，確認 32×32 命中區、選取、點擊回呼及 tooltip；Planist 設定頁 renderer 測試通過並產生接入截圖。視覺接受仍由使用者判定。

## Explorer 契約 v1（EXP-V1-r2）

已完成直接替換，見 [配對契約](../../../../docs/architecture/explorer-v1-plan/README.md) 及 [公開 API](../../../../docs/ai/explorer-model.md)。`explorer/` 擁有資料 interface、有限能力、完整快照、封閉結構與獨立 semantic adapter；presentation 保存不可變綁定，rendering 獨立呈現樹與共享命令。舊 components/Explorer 與 Widget Explorer 已移除，不留 shim。Explorer Catalog 外觀已由使用者接受，最新基準為 EXP-V1-r3。

## 尚未接入的頁面來源

KBF-PAIR-r2 的 page-reference 需求保持 pending，尚無公開 `pageReferences` API。本次替換使 KP-W1 的舊檔案邊界與 onMove/canMove 假設失效；必須按 EXP-V1-r2 重新 PLAN 配對後才 BUILD。需求見 [共通配對](../../../../docs/architecture/blocknote-flow-pairing.md)，不從名稱／圖示猜正文来源，不改 Krepis 的資料權威。

修訂 FRAME-8-R1；本輪 READY 依據為 [8px／微立體契約](../../../../spec/frame-relief-8px.md)。

本輪所有權是 `layout/`（公開 app layout、frame、groups 與 adapter）、`components/adapters/klp_workspace_block_adapter.dart`（既有 gap 語意）及 `presentation/`（不可變 bound 資料）。其他 workspace 功能保留既有契約。

公開新增 `KlpAppFrameSurface.flat/raised`，由 `KlpAppFrame.surface` 選擇，預設 flat 保留原有使用者行為。Frame 保持零內容 padding、12px 圓角；bare 角色不繪製表面。間距三組語意改為 distance i2。Styling 擁有微立體配方，adapter 從 resolved surface／shadow／compactGap 產生 bound 陰影、亮邊與尺度，不把 primitive 或產品特例交給 renderer。

依賴方向：composition／styling → features adapter → features presentation → rendering。禁止 consumer style callback、Flutter Widget 與局部像素覆寫。

目前單一切片完成上述公開選項、語意與 bound 接線；獨立 test owner 擁有 `test/klp_app_frame_style_test.dart`、`test/klp_frame_groups_test.dart`。驗證 default flat、raised 外部陰影不改 child bounds、深色亮邊 alpha 降低與完整 preset 替換後重新解析。視覺品質 human-pending。
