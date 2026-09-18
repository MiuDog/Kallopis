# Tests

## EXP-V1-r3 箭頭與後代收合

獨立 Test Author 擁有 test/klp_explorer_expansion_revision_test.dart；驗證公開集合提案、空分類、原子狀態及真實 renderer 的指標／鍵盤箭頭。既有測試唯讀，無 golden。


Status: PLAN READY

`test/` 擁有 Kallopis 公開契約、確定性互動、生命週期與模組邊界的可執行保護。測試只觀察公開行為或必要的套件內部邊界，不鏡像產品實作、不改寫需求，也不以 golden、像素差異或主觀視覺評分作為驗收。

Test Author 只能修改 Task Packet 指定的測試路徑；BUILD worker 可讀取並執行保護測試，但不得修改斷言、fixture、baseline、skip、測試設定或本檔。功能與 rendering 仍各自擁有產品程式，測試不成為 runtime 相依。

Sidebar v2 Explorer 的保護範圍由 `SIDEBAR-V2-EXPLORER-r1` 定義：可選取分支、不可選取結構列、內容選單專用模式，以及右鍵、選單鍵與 `Shift+F10` 的等價命令入口。感官品質保留人工驗收。
