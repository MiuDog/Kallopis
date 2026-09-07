# KLP-0007：Navigator 三模型組合

- 狀態：Accepted
- 日期：2026-09-03

## 決策

`KlpNavigator` 是 Sidebar 內容導覽的共用呈現元件，視覺以 Kallopis Catalog 目前
目錄為準。它只公開三種具體注入模型：

- `KlpNavigatorCategory`：可折疊項目列表。
- `KlpNavigatorElement`：可選取並可遞迴巢狀的節點，也可直接放在根層。
- `KlpNavigatorComponent`：搜尋框、虛線分隔線、按鈕列表等任意 Widget 插槽。

Category 與 Element 沿用目前 Catalog 的高度、縮排、字體、圖示與互動狀態；
Component 不由 Navigator 強制高度。展開、選取與事件透過 Navigator 私有
InheritedWidget 傳給內部節點。

既有 `KlpExplorer` 保留 API 相容性，但其資料會轉成 Navigator 模型後再呈現，避免
Catalog 與產品 Sidebar 形成兩套視覺實作。

## 邊界

- 產品擁有 ID、label、icon、badge、資料、受控狀態與事件。
- Kallopis 擁有列高、縮排、surface、字體、hover、selected 與折疊呈現。
- Component child 擁有自己的高度、padding、狀態與事件。
- Navigator 不取代 Rail、Tab、Dock 或純檔案內容元件。

## 閘門

- 新增 Navigator 內容只能建立上述三種具體模型。
- Catalog 必須展示 KlpNavigator 與三種模型的組合。
- 元件清單與風格語意生成器必須包含 KlpNavigator。
