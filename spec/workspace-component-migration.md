# 工作區元件宣告式遷移

使用者要求更新元件程式碼，使既有 Explorer、文件分頁與視窗控制對齊新版架構。沿用舊能力與已確認風格 v1.0.0；保留舊入口相容，新 consumer 僅使用 kallopis_declarative.dart。

## 實作邊界

- Explorer 提供檔案／資料夾階層、展開與選取。資料、selectedId、expandedIds 由 consumer 持有，操作回報 id 與新意圖；元件不讀檔案系統或自行保存資料。
- 文件分頁呈現標題、選取、dirty 與可關閉狀態，提供選取及關閉通知。關閉不擅自刪除、保存或切換產品文件；本次不新增未經需求確認的拖曳重排與保存策略。
- 視窗控制接受最大化狀態及最小化／切換最大化／關閉 callback。宿主負責原生通道及狀態投影；本次不宣稱所有 OS runner 皆已驗證。
- 公開節點、資格與插槽進入唯一結構樹，由 application 註冊 adapter，經既有編譯／安裝和 semantic resolver 交給封閉 renderer。不可從新入口匯出舊 Widget，也不可藉 ThemeData adapter 繞回舊風格。
- 顏色、間距、圓角與控制尺度沿 semantic 解析；renderer 只消費已解析值。選取、展開及 dirty 的資料 authority 不移轉到 renderer。

## 驗收

透過實際 application adapters、runtime 與 Flutter renderer 驗證新公開節點能呈現與互動；consumer 重建前展開／關閉不自行改資料；更換原料時文字跟隨；視窗按鈕可鍵盤操作。既有宣告式公開入口與前端架構邊界檢查維持，不增加 allowlist。資料樹沿現有驗證拒絕重複 ID。未做新的視覺定型，不新增 golden。
