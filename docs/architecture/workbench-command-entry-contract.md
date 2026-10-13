# Workbench 命令呈現入口

WB-COMMAND-ENTRY-r1 READY，依[WB-09／10](../../spec/workbench-v1.md)與[命令核心](workbench-command-contract.md)。當前vertical slice交付原生registered toolbar及平面registered menu；context menu／palette的彈出、搜尋與焦點還原仍是同一已接受stage的接續能力，不以本slice冒充完整WB-09～11。

## 共同資料及狀態

`KlpCommandReference`只含commandId及可選kind(action或toggle，缺省action)，引用產品排列意圖；不保存label、handler、disabled或第二份context。kind只決定呈現的勾選/按下語意，不改registry條件與執行。ID須含非空白內容但原值保留；同一入口不可重複ID，非法kind拒絕。缺失或hidden命令不呈現，disabled/running命令保持呈現且不能執行；解除註冊、registry dispose及refresh通知後所有已掛載入口同步更新。條件錯誤沿core state診斷而不呈現失敗項。

所有入口收registry、`getContext()`、items、非空白label及必填`onResult(result)`。getContext在每次query與activation取目前產品值，不保存context。items順序為產品指定，不沿registry ID排序；metadata/keywords/icon/checked/running直接讀registry。onResult為產品的業務結果接點，不轉譯錯誤文案；callback自身錯誤交宿主error通道。激活只能呼叫registry.execute ID，不能複製handler或以本地狀態繞過gates。

UI pending只停用該命令；其他項目與入口可操作。產品value/error不freeze/clone。動作開始後切换getContext/onResult用最新callback收到結果；宿主卸載或替換registry後的舊結果不呼叫新owner。註冊token解除但host仍持相同registry時，已開始業務的原結果仍交同host。同ID新owner是否接收到UI結果不控制registry pending權威；UI只回傳原commandId/result，不改新owner狀態。

## 原生元件

兩端公開`KlpRegisteredCommandToolbar<C>`及`KlpRegisteredCommandMenu<C>`，React props與FlutterWidget採原生型別。label/onResult/getContext/items/registry共同；menu另需非空白emptyLabel，可選autoFocus（false）及onDismiss。className/id/style（React）或key（Flutter）只供原生宿主，不新增第二套theme。無separator/submenu/業務順序語言，產品可組合多個入口；未加入新的renderer、node或adapter。

Toolbar水平呈現，一般action無toggle語意，toggle反映registry checked。左右鍵／Home／End循環移動可用項，Enter／Space只激活一次。Menu垂直呈現label、可選description/icon與toggle勾選；方向上下鍵／Home／End循環可用項，Enter／Space只激活一次，Escape呼叫onDismiss。停用/執行中項保持呈現但不加入此庫既有command menu的可用索引；不是完整ARIA menubar或submenu系統。全部缺失/hidden時menu顯示產品emptyLabel，keyboard no-op。

React toolbar role toolbar、menu role menu；action menu row role menuitem，toggle role menuitemcheckbox並輸出aria-checked；toolbar toggle輸出aria-pressed。可用項roving tabIndex，disabled nativebutton停用；menu autoFocus掛載時聚焦第一可用項，沒有時聚焦root，預設不偷焦點。Flutter保持原生Focus/Semantics，重用既有CommandMenu/controls樣式，既有caller API不改。

風格只由現行semantic theme／pack resolver提供；hover與checked/selected同色。Label/description用既有文字role，menu/toolbar/icon尺寸、padding、radius、gap沿已確認recipe。有限宿主內保留原生scroll/wrap與內容裁切，style替換不改ID順序、指令權限、pending或保存資料。感官品質human-pending。

鍵盤參考[W3C keyboard interface](https://www.w3.org/WAI/ARIA/apg/practices/keyboard-interface/)及[menu patterns](https://www.w3.org/WAI/ARIA/apg/patterns/menubar/)，本slice明確保留既有Flutter command menu可用項索引契約，不宣稱完整menubar/assistive-tech認證。

## 必要證據與邊界

fresh獨立Test Author驗證兩入口共享registry/checked/pending、missing/hidden與解除同步、最新context和callback、disabled不能繞過、handler原error/value、stale unmount/registry replacement、items順序/驗證、keyboard/one activation/empty/menu autoFocus，publicconsumer/type/build。使用public元件與DOM/Widget層，不能檢查private hook或字型pixel。後續example/browser及網站專屬specimens不由synthetic checks替代。

目前React owner見react/architecture.md；Flutter owner見flutter/architecture.md，後續實作前固定其local module architecture及TestAuthor。原core/tests、Dock/layout/stylepack/config/其他產品元件唯讀；入口自己的新來源與semantic CSS可寫，不用此slice修改舊元件樣式或權威。
