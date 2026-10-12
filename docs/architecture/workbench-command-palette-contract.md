# Registered command palette

WB-COMMAND-PALETTE-r1 READY，依WB-09～11/14/15/16與[命令核心](workbench-command-contract.md)。本stage交付雙框架controlled modal palette；同registry查詢/執行，不重新註冊handler或把產品context保存進庫。工具列與平面menu已完成；anchor/context menu另有接續slice，不能以palette宣稱全Workbench完成。

## 公開原生入口

兩端`KlpRegisteredCommandPalette<C>`共同required registry/getContext/open/label/searchLabel/emptyLabel/onResult/onDismiss。open為產品受控bool；非空白label為dialog名稱、searchLabel為搜尋輸入名稱、emptyLabel為無可見結果文案。onDismiss只提出關閉意圖，產品更新open；理由`KlpCommandDismissReason` escape/outside/executed（React string union、Flutter enum同name）。onResult收到原core結果；搜尋結果不複製handler。React另className/id可選、Flutter key可選，沒有新theme/defaultcontext/儲存來源。React Props型別generic C=unknown。

closed不render overlay/query/getContext，不取得焦點；首次open重設query空字串。每次query與activation讀目前getContext，refresh/register/unregister/dispose同步重新投影。同open session內query在theme/尺寸/props更新後保留，registry replacement使舊結果失效並刷新清冊；close/unmount/reopen也隔離舊async結果。清冊disposed時合法空結果，不再訂閱。

## 搜尋與排序

只取registry.list(context)中visible=true的snapshots；disabled/running保持候選但不可選取/啟動。字串toLowerCase，不作locale/正規表示式或任意expression；query以Unicode空白分詞，去空token，trim。每詞必須在某一個完整field匹配，fields為label、id、category、description、各keyword；可分別匹配不同field，不在串接field邊界假造詞。

每個field以UTF-16 code units匹配：全相等score0；prefix 1；substring 2；依序subsequence 3；不存在為不匹配。每詞取所有field最小score，全部詞score求和。空query沿core ID UTF-16順序，非空query先score再原ID UTF-16順序；不用註冊時間、Intl.Collator或框架locale。中文完整/子字串與原Unicode保留；不提供transliteration/locale語言搜尋權威。相同query/context/core快照兩框架順序一致。

跨框架分詞精確集合沿ECMAScript WhiteSpace/LineTerminator：U+0009～000D、0020、00A0、1680、2000～200A、2028/2029、202F、205F、3000、FEFF；U+0085保留原字元不分詞。Flutter不可用不同runtime的廣義trim/空白集合改變候選；只有上述集合的邊界與連續字元分隔詞。

selected ID是本地候選焦點，不等於命令checked。初始第一個enabled且非running項；query/清冊變動保留仍可用的同ID，否則fallback第一可用。空結果顯示emptyLabel；全部disabled仍顯示且selection空。取消未開始業務；已開始Promise/Future不因UI關閉被取消。

## 鍵盤、原值結果與焦點

輸入框持原生DOM/Focus焦點；上下在可用候選頭尾循環，Enter對active ID執行一次，repeat Enter不執行。Home/End/左右保留文字游標原生語意，不另攔截；不新增全域shortcut。IME/composition期間不攔截方向/Enter/Escape或執行命令。Escape提出escape；點backdrop提出outside，點panel/候選不視為outside。Tab限制到本modal可用focus（React目前唯一input；Flutter由modal原生宿主），不把焦點留在背景。

click候選只dispatch ID且保留輸入焦點。disabled/running不能由keyboard/pointer繞過，激活仍重新query core gates。result完成交同session最新onResult；executed後在callback返回且same session仍open時提出executed dismiss。error/hidden/disabled/busy/missing/disposed不自動close，讓產品處理；onResult自身throw交原生error通道並保持可再次執行，不假造handler error、不自動dismiss。不同命令可並行，pending不是全palette鎖。

開啟時記錄先前焦點，native frame/DOM掛載後聚焦輸入；關閉或unmount時，只在焦點仍位於該palette或已因其卸載回原生空背景时，還原仍有效/可聚焦的先前focus。產品handler/callback刻意移至其他宿主後不搶回。原輸入文字/selection不由palette改動。registry replacement在同open session保持原return-focus owner，不把palette自身當還原目的。嵌套modal focus與原生route例外依框架宿主，browser/人類接受另記。

React dialog role/aria-modal/名稱，input combobox role、aria-controls唯一listbox、aria-expanded true、aria-activedescendant只指仍存在active option。候選role option、aria-selected投影本地active、aria-disabled投影可用狀態；metadata icon裝飾、label/description/category讀core。Flutter同原生Semantics/Focus與KlpTextField，不以ARIA名字映射private Widget結構。

## 風格與幾何

重用KlpTextField/KlpText/Icon/Button或現有原生pressable。背景scrim讀surface.scrimOpacity及既有色；panel overlay色/menuRadius/overlayShadow，最大寬沿geometry.layout.dialogMaximumWidth，viewport四邊沿overlayViewportInset。有限viewport先把inset限制到短邊一半，panel可用寬高有限非負，內部padding/field/item/icon/gap讀現有semantic；不足空間以scroll/clip退化，不能NaN/Inf/RenderFlexoverflow。不存viewport/style到commands/產品布局，不改ID順序/gates。hover/active同selectionWash。

React portal投到owner document.body，從同useKlp tokens投影scoped styleVariables與mode，不能在portal外重建default ThemeProvider導致自訂pack丟失。SSR open/closed都不輸出modal，client mount後呈現，不產生hydration差異。Flutter原生overlay保留當前theme/locale，無第二份權威。感官/browser證據待專屬example，不用synthetic checks取代。

參考：[VS Code command palette](https://code.visualstudio.com/docs/editing/getting-started/userinterface)、[W3C combobox](https://www.w3.org/WAI/ARIA/apg/patterns/combobox/)、[W3C modal dialog](https://www.w3.org/WAI/ARIA/apg/patterns/dialog-modal/)。明確範圍是command action候選，不宣稱完整assistive-tech認證。

## 必要證據

fresh TestAuthor public UI／native events：metadata所有field與多詞、substring/subsequence/排序/空feedback、visible/disabled/running/解除/dispose/latestcontext；方向與once Enter/IME/native游標；controlled open reset/query保留；原值error/latestcallback/callbackthrow；close/unmount/reopen/replacement stale；escape/outside/成功dismiss；focusrestore及產品外部focus保護；React SSR/hydration/publictypes；finite/theme scoped保護。核心/codeconfig/既有入口/其他module/tests皆readonly。
