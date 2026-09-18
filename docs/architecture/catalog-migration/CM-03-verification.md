# CM-03：選單彈出與關閉

已整合到主要工作樹；新增可選 triggerLabel，由庫管理入口與浮層。保留獨立面板、子選單層級、4px itemGap 及已接受的其他元件外觀。

實作採 OverlayPortal，跟隨入口布局、限制於 viewport，並隨節點卸載清除。外部點擊不穿透；Escape 關閉且通知事件，葉項執行一次後關閉，父項／停用不關閉，焦點返回入口。

隔離 snapshot：330edb415f203a82e09dd9f840fb1b294c25cee6。三個 module slice 與焦點修正 scope checker 通過；整合前六個產品／展示來源逐檔比對 snapshot，保留他人修改，主要分支未提交。

獨立測試：test/klp_declarative_menu_popup_test.dart，SHA256 2052572FAC45812D4934A2E0E9E172E5EC605868022A75401415F03B52728D38。初跑發現已有入口焦點時 autofocus 不會交接，造成 Escape 未關閉；改為面板安裝時主動接手焦點，相同9項測試全通過，未改測試要求。

局部 analyze 無問題。主要工作樹 popup 9 項、submenu 11 項、Menu 6 項及公開 API 1 項，共27/27通過。Web debug build 通過；實際瀏覽器確認入口下方彈出、4px間距、外部點擊關閉、焦點返回後Enter重新開啟、Escape關閉。預覽 http://127.0.0.1:8767/。外觀仍待人類接受；未宣稱 Windows 原生平台驗證。

剩餘範圍：工作區命令／編輯器的舊選單呼叫端仍需遷移接線，舊元件尚未刪除；254項固定清冊不變。

