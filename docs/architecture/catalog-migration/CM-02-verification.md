# CM-02 短期任務：子選單展開與返回

已整合到主要工作樹。範圍為不可變 children、遞迴唯一 ID／租約、同面板前進返回與資料更新後路徑重綁、可操作 Catalog。保留既有 Menu 風格與 hover／selected 同色。

完整選單仍未完成：彈出定位、視窗邊界調整、外部點擊關閉與工作區入口接線留待下一短期任務；本次未刪除舊元件，254項固定清冊不變。

隔離 snapshot：999f82cfe13d1fc50abc1e52d7c5f2112ae8ae3e。整合前逐檔比較主要工作樹與 snapshot 的 Git blob，五個產品／展示來源未被其他修改覆蓋。主分支未提交。

features、rendering、Catalog 各自 scope checker 通過。局部 Dart analyze 無問題。獨立 Test Author 的新增測試位於 test/klp_declarative_submenu_test.dart；視覺品質仍待人類接受。主要工作樹執行新版 submenu 11 項加既有 Menu 6 項，共 17/17 通過。測試 hash：E60EC78AA00B25A057737591FB576CB8246A46CCF440C2C1E6A5234AF74686D6。

本短期任務採兩個里程碑：資料及導覽、局部測試及展示；不在本輪擴大其他元件行為。


最終證據：主要工作樹17/17測試通過；局部 analyze 無問題；Web debug build 通過。實際瀏覽器確認「更多操作 → 匯出格式」兩層展開、點擊標頭返回、向左鍵回到根並恢复父項高亮。發現返回圖示資產不存在後，改為旋轉既有 chevron-right 並重新 build／畫面驗證，未新增圖示風格。預覽：http://127.0.0.1:8766/。Windows 原生與其他尺度尚未驗證。

本輪約20分鐘，落於15–35分鐘估算；未取得工具提供的精確token用量，不填造數字。完整選單的其餘行為仍列未完成。
