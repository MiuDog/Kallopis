# Workbench 命令契約

WB-COMMAND-r1：READY。依已接受[WB-09～14／16](../../spec/workbench-v1.md)，本契約固定集中命令資料與生命週期，兩端使用同一規則；不是整個命令／快捷鍵stage完成。工具列、選單、context menu、palette與keybinding只能引用command ID並經registry執行，不能複製handler或繞過disabled。產品仍擁有context、內容、儲存及業務流程。

參考[VS Code commands](https://code.visualstudio.com/api/extension-guides/command)的共用執行入口及enablement，與[when context](https://code.visualstudio.com/api/references/when-clause-contexts)的條件概念；Kallopis使用原生predicate，不加入字串程式執行器。快捷鍵的chord／作用域／覆寫與焦點宿主在同一已接受stage另有自己的具體契約，不以core registry冒充完成。

## 公開資料

`KlpCommandDefinition<C>`：id、label必填含非空白內容的字串（trim只驗證，不修改原值或identity）；handler(context:C)必填，可同步或PromiseLike／FutureOr回傳產品值。description／category可選含非空白內容的字串，keywords可選列表且每項字串須含非空白內容；icon可選原生ReactNode／FlutterKlpIconData，只提供呈現metadata。isVisible(context)／isEnabled(context)／isChecked(context)可選原生pure boolean predicates，缺省true／true／false。React執行時拒絕非boolean結果。產品不在predicate中註冊、解除或執行命令。

註冊時複製自己的metadata及keywords，不freeze或改caller；icon、handler、predicate及context保持產品引用，不深複製正文。caller事後修改原metadata/keywords不改已註冊命令。不存在預設command、產品順序、路由或全域registry。

`KlpCommandState`為只讀snapshot：id/label/description/category/keywords/icon、visible/enabled/checked/running及conditionError。conditionError是null或擁有原error的記錄，不能用error是否undefined判斷失敗。condition error時visible/enabled/checked皆false，running保留該註冊者的狀態。enabled代表predicate結果；呈現入口需同時檢查visible、enabled及running，執行入口仍重新查詢。JS snapshot根及keywords/清冊列表freeze；Flutter使用final欄位及unmodifiable列表；不freeze產品值。

`KlpCommandExecutionResult`包含commandId與status：executed、missing、hidden、disabled、busy、disposed、error。executed保留handler原value；error保留原error及phase(condition或handler)，不以框架自行文案替換。React使用readonly discriminated union；Flutter使用對應enum（name相同）與immutable結果型別。這些結果不是保存JSON格式。

## Registry

React `KlpCommandRegistry<C>(onObserverError?)`；Flutter `KlpCommandRegistry<C>() extends ChangeNotifier`。React的可選observer error callback只處理subscription listener錯誤，缺省交宿主reportError／console.error；callback自身錯誤亦交宿主。Flutter沿ChangeNotifier的FlutterError通道。兩端handler／condition錯誤都只由execution/state結果交產品處理，不與observer錯誤混合。

| 方法／屬性 | 行為 |
| --- | --- |
| register(definition) → disposer | 原子驗證、拒絕重複ID；返回只解除自己token的idempotent函式。解除後重用相同ID不受舊disposer影響。 |
| getState(id, context) | 每次重新評估最新caller context；未知或disposed回null；condition error回診斷snapshot而不丟出。 |
| list(context) | 所有註冊者snapshot，包括hidden及condition error供診斷；依原id UTF-16字典順序，不能依註冊時序。 |
| execute(id, context) | Promise／Future typed結果；先檢查disposed/missing，再評估condition error/hidden/disabled/busy，通過才開始handler。 |
| subscribe(listener) → disposer | 每個owner獨立訂閱，返回idempotent解除；Flutter另保留原生Listenable。listener錯誤不破壞registry或strand running。 |
| refresh() | 產品外部條件改變的明確invalidating通知，不持有context或建立產品狀態鏡像。 |
| version / isDisposed | version初始0，註冊、解除、開始/結束pending、refresh、dispose各一次遞增並通知。重複disposer/dispose及無效執行不通知。 |
| dispose() | 一次關閉，清註冊者，以disposed狀態通知最後一次後清訂閱；register/subscribe/refresh之後明確StateError/Error。查詢仍合法。 |

id參數必須含非空白內容；非法定義、duplicate及metadata以React TypeError／Flutter ArgumentError拒絕。disposed mutation用Error／StateError。條件與handler回傳錯誤都可以查詢與處理，不因一個命令錯誤阻塞其他命令。

## 執行生命週期

pending以註冊token擁有，單一命令不重入；不同命令可並行。開始handler之前先設running並通知。condition查詢或observer通知導致解除／disposed時須再檢查token，不能執行過期handler；此時disposed回disposed，解除或被替換的token回missing。handler已開始後解除/重註冊/dispose不取消產品Promise或業務副作用；其結果仍正常完成，但不能清掉新註冊者的running或通知已卸載owner。只有目前同token的finally才解除running與通知。

產品為context權威，registry不保存或clonecontext。UI與keyboard宿主每次傳最新context；closure條件變動使用refresh或產品原生rebuild。所有呈現將對同一registry訂閱，避免toolbar/menu/palette出現不同disabled邏輯。沒有命令取消/transaction/undo權威，業務操作需要這些時由handler／產品擁有。

## 必要證據及stage邊界

兩端獨立deterministic checks：metadata/id驗證與duplicate原子性、自己disposer/ID重用、snapshot及caller隔離、最新context／三predicate、throw及React非法boolean、未知/hidden/disabled/busy不執行、sync/async成功與原error、不同命令並行、pending解除/同ID重註冊/dispose stale、observer錯誤不strand、通知/version/id排序/refresh與idempotentdispose、公開consumer/build入口。Test Author不能檢查private欄位或改既有tests。

React當前core owner為react/architecture.md；Flutter當前core owner為flutter/architecture.md，實作只新增actions command_registry並由stablefoundation匯出。既有KlpCommandMenu/KlpWorkspaceCommand/KeyBindingController不在core slice改寫；后續入口與shortcut接入保持既有caller相容性。完整WB-11～14、UI、展示及網站仍未交付，不能以這些checks宣稱stage全部完成。
