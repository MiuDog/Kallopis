## 分析入口

`diagnostics/klp_contract_error.dart` 在結構或註冊違約時回報穩定 code 與 message。

`identity/internal/klp_identifier.dart` 是 slot 與 semantic 識別字彙共用的格式判斷，避免兩份正則規則分岔；各呼叫者仍保有其診斷代碼及語境。這不是放置識別的正規化或全域 identity 管理器。

`identity/klp_placement_id.dart` 不可變地保存 scope 各段與 local id，提供值比較與雜湊。它是結構快照、安裝資源與呈現 key 的共用識別；斜線、空白及 Unicode 不會因字串前綴編碼而碰撞。

`lifecycle/internal/klp_frame_lease.dart` 管理已提交畫面的操作資格；撤銷後舊 callback 不能再啟動功能。`klp_run_lifecycle_actions.dart` 逐一執行生命週期步驟，即使個別步驟失敗也繼續後續清理；單一錯誤保留原始原因與堆疊，多個錯誤由 `klp_lifecycle_exception.dart` 完整保存。

Frame lease 可派生受限子 lease，有效性同時受本地啟用條件與整條父鏈限制；祖先撤銷或隱藏後，子 scope 無法重新取得操作資格。它只管理操作採納，不宣稱停止既有外部非同步 I/O。

這些內部工具供 runtime 及應用宿主管理提交與清理，不是公開的 consumer lifecycle hook。結構化放置識別已落地，完整能力生命週期與平台恢復模型仍待實作，不要把計畫目錄當作現有能力。
