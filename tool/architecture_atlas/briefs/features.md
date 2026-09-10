## 分析入口

目前先實作 `navigation/rail/`：`contracts/KlpRail` 固定 top／center／bottom 三區，全部只接受 `KlpRailItem`；外部項目可同時實作其他資格介面。清單及展開順序在建構時封存，重複放置識別由 composition registry 拒絕。Rail 本身具備 `KlpScreenBody` 資格。

`internal/klp_rail_adapter.dart` 先解析本庫 semantic、驗證幾何及語意標籤並投影 callback；`klp_prepared_rail.dart` 將已準備資料降為選擇、線性排版、三區配置、表面與尺寸等基礎原語，沒有 Flutter 相依。`klp_rail_placement.dart` 擁有選取狀態及其借用 controller；移除選取項時清空選取，釋放時關閉自己建立的資源。操作接受後依序通知狀態、onSelected、onPressed，單一回呼失敗不吞掉其他通知。

焦點、鍵盤與輔助科技操作由通用 renderer 原語處理，feature 不另寫一份。目前尚未遷移原 rail 的排序、分隔線及完整平台行為，不能描述成全部 navigation rail 已完成。元件定義與內容投影參見 [模板樣板](../../component-template-prototype.md)。
