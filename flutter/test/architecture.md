# Tests

## CAT-TAX-01 分類資料契約

獨立 Test Author 擁有 `test/catalog_classification_contract_test.dart`；只讀已接受的 taxonomy spec 與固定 legacy baseline，驗證分類資料的 254 項集合、封閉欄位、合法 category／role、intent、secondary 與禁止 owner/module/disposition。它不判斷分類語意品質、不修改 baseline，也不替人類接受分類。

## EXP-V1-r3 箭頭與後代收合

獨立 Test Author 擁有 test/klp_explorer_expansion_revision_test.dart；驗證公開集合提案、空分類、原子狀態及真實 renderer 的指標／鍵盤箭頭。既有測試唯讀，無 golden。


Status: PLAN READY

`test/` 擁有 Kallopis 公開契約、確定性互動、生命週期與模組邊界的可執行保護。測試只觀察公開行為或必要的套件內部邊界，不鏡像產品實作、不改寫需求，也不以 golden、像素差異或主觀視覺評分作為驗收。

Test Author 只能修改 Task Packet 指定的測試路徑；BUILD worker 可讀取並執行保護測試，但不得修改斷言、fixture、baseline、skip、測試設定或本檔。功能與 rendering 仍各自擁有產品程式，測試不成為 runtime 相依。

Sidebar v2 Explorer 的保護範圍由 `SIDEBAR-V2-EXPLORER-r1` 定義：可選取分支、不可選取結構列、內容選單專用模式，以及右鍵、選單鍵與 `Shift+F10` 的等價命令入口。感官品質保留人工驗收。

## FLUTTER-MASONRY-EMPTY-r1

獨立Test Author唯一寫test/masonry_empty_test.dart，依Flutter package公開契約保護空children不拋例外及nonempty→empty→nonempty恢復；只讀公開入口/契約與既有測試慣例，不讀產品實作、不修改其他tests/config/architecture。Red及hash交回後為protected，BUILD不得修改。

FLUTTER-MASONRY-EMPTY-1驗證：test316aaa67的SHA256為051E261E93503E9E12E2A46CDD5D8E2FAAE94DA4510BAFC98CAF873FBCC04829；實作前兩個behavior Red，source b3cff636後原command兩checks Green，protected檔未修改。
