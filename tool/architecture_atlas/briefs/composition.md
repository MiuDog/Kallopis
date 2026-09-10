## 分析入口

Kallopis 純 Dart 結構契約。`nodes/klp_node.dart` 是宣告介面；`definitions/klp_definition.dart` 固定註冊型別資格與語意 owner；`registry/klp_registry.dart` 驗證依賴、風格引用與結構；`validation/` 保存不再讀取消費端 getter 的不可變快照。Foundation 展開及渲染由上層 runtime 與 renderer 負責。

`nodes/klp_composite_node.dart` 收窄唯一 children 輸入為 final `slots/klp_children.dart`。`KlpSlot<C>` 以物件身分、型別資格與數量限制描述插槽；assignment 只能由 slot 建立。定義保存 schema，實例必須完整且依序配置。

`validation/internal/klp_tree_capture.dart` 是 registry 與 runtime 共用的單次擷取流程：驗證 slot 身分、順序、覆蓋及資格後，公開快照只保存中立 metadata 與 `KlpValidatedSlot` 子項範圍；原始節點映射只供本次內部編譯。`slots/klp_screen_body.dart` 定義 screen child 資格；rail item 的專用資格仍由 rail 功能契約擁有。Screen、rail 與外部複合元件共用此驗證路徑。

放置快照唯一保存 `KlpPlacementId` 與完整子放置識別，local `id`／`childrenIds` 是衍生 getter。`nodes/internal/klp_scope_boundary.dart` 是本庫封閉的 scope 授權接點，capture 只對該型別延伸作用域；沒有消費端開 scope 的布林參數。不同 entry 可有相同 local id，同一 scope 仍禁止重複；來源索引直接使用結構化識別，不串接路徑字串。

依賴方向：registry 使用 definition、node、validation、styling 解析與 kernel 診斷；不依賴 Flutter、Klp 元件或可變全域 registry。語意依賴自動納入定義相依，未引用的錯誤用途也在註冊時拒絕。通用合格子插槽已接入應用流程，仍不代表完整容器能力已完成。
