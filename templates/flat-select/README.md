# 平面下拉選擇器

複製 `FlatSelect.tsx` 與 `flat-select.css` 到 consumer，使用既有 `@kallopis/react` theme/styles。只提供呈現與標準鍵盤投影，不定義資產、模型、API、團隊或保存流程。

`FlatSelect` 接收 label、valueLabel、disabled、indicator 與 children(close)。選項透過 `FlatSelectOption` 投影既有 KlpButton；群組用 `FlatSelectGroup` 的低對比細虛線。選取是否成功由 consumer 判斷，再呼叫 close。不要將產品草稿、網路請求或路由放入模板。

開啟採瀏覽器 Popover top layer，依觸發欄位寬度與可用視窗空間定位，避免父 Panel 捲動裁切。關閉仍保持選項掛載，讓 consumer 的未保存排序繼續有效。外部點擊或 Escape 關閉，方向鍵／Home／End／文字前綴尋找選項；Alt方向鍵交給內部可排序清單。

觸發欄位沿用既有 field token；選單採平面 Panel，不增加陰影、工具列或說明列。實際視覺、鍵盤、Popover 邊界與拖曳仍待可用 browser 驗證；編譯成功不能取代此驗證。詳細函式及狀態見 [architecture.md](architecture.md)。
