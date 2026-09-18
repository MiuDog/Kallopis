# POP-V1-01 公開錨定 Popup 整合契約

Revision: POP-V1-r1b。公開整合完成。隔離實作為 r1a 的 12 個檔案；主目錄另在 `klp_flutter_menu.dart` 增加可選的 route-context 配對回呼，共 13 個產品檔案。這不開放整個 lib，也不改 Popup 公開 API。

產品需求以 [accepted spec](../spec/anchored-popup.md) 為準。公開型別、bound 欄位、語意映射、責任分層及生命週期以 [workspace POP-V1-r1](src/features/workspace/architecture.md) 為準。保留既有合法組裝及單一 primitive 權威。

## 固定整合增量

- 新增 KlpAnchoredPopup、KlpAnchoredPopupItem、KlpAnchoredPopupState、KlpAnchoredPopupChangeReason；單一 facade export。四項 export rows 按字母順序插在 KlpAnchoredCommands 之後。
- 公開 composite identity 為 kallopis.anchored_popup；唯一 trigger slot 為 KlpSlot<KlpWorkspaceBlock>，name trigger、min 1、max 1。feature catalog 的 popup row 插在 anchored commands 後。
- Application adapter KlpAnchoredPopupAdapter 放在 WorkspaceBlock 的完整 createAll 群組之後、AppLayout 之前；不移動其他 identity。
- 新增 KlpBoundAnchoredPopup 與唯一 renderer dispatch；WorkspaceBlock 只新增內部 activation/focus/expanded/selected override，預設保持既有行為。
- Renderer 以 OverlayPortal 取得實際 anchor bounds，受控開關、方向感知、翻轉及邊界限制。僅 consumer 回填變更 open；子命令沿用既有共用實作。
- `klp_flutter_commands.dart` 允許新增可選的內部 route 所有權／取消配對，既有 caller 預設行為不變。Popup 關閉、失效或退役時僅移除自己的子選單／輸入／確認 route，不可盲目 pop 其他路由；舊 command 回呼仍受 lease／generation 保護。
- 主目錄命令選單保留已接受的 `showKlpMenuItems`／KlpMenu 路徑。可選 `onRouteContext` 只提供給庫內 route owner 擷取自己的 ModalRoute；不將 Flutter context 或 route 開放給 consumer。
- 當前宣告的錨點暫時零尺寸或完全移出 viewport 時撤下可互動內容並只請求一次關閉；consumer 保持 open 時，錨點恢復可用即重新呈現。Consumer 明確移除整個宣告而退役 lease 時，禁止呼叫已退役回呼；不將這種移除視為當前宣告的 anchorUnavailable。

## 驗證與保護

Test Author 擁有 test/klp_anchored_popup_test.dart、test/klp_anchored_popup_layout_test.dart 與三份 catalog/prepared/module-boundary 測試。BUILD 不得修改任何測試、架構、spec、fixture 或相依設定。

必要驗證是公開 metadata、非法宣告拒絕、受控事件、原地更新、焦點循環返回、子命令分離、anchor 生命週期與位置，以及 scoped analyze。原架構 suite 四項既有失敗須與本次增量分別記錄，不改歷史 hash 以取得通過。外觀沿用已接受預設；實際呈現提供 artifact，人類操作手感仍由人類接受。
