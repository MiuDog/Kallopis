# 待決變更提示

狀態：使用者已要求的具名呈現模板，2026-10-18。風格權威：[工作台配方](../../docs/design-tokens/recipes.md#工作台風格與消費者邊界2026-10-18-使用者已確認)。

複製 PendingChangesBanner.tsx 與 pending-changes.css 到consumer，在已有Kallopis Provider的Stage定位宿主中渲染。visible／attention／busy／error由consumer提供；onSave／onDiscard只回呼。不包含髒資料判斷、路由攔截、API或持久化。

元件以平面Frame呈現，低對比虛線及spacing token。宿主需position:relative；提示絕對定位於其底部，不改變工作台兩區組成。參數與呼叫鏈見[architecture](architecture.md)。
