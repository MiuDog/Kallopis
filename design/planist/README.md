# Planist 產品畫面參考

狀態：使用者已核准此稿作為第一版元件化與 Planist 組裝基準。工具列的具體功能仍留待產品決策。

從 Kallopis 根目錄啟動 `python -m http.server 57931 --bind 127.0.0.1`，開啟 `/design/planist/`，或直接開啟 `index.html`。不需建置，字型引用本庫 assets。

## 最新 Planist 布局決策

- 左側按鈕列依序為「專案」「Planist AI」「待辦事項」「資產庫」。專案不再使用特殊區塊，四者共用按鈕格式；不提供「文件」按鈕，文件仍從 Explorer 開啟。
- 第一版按鈕高度為 32px、小間距為 4px。
- 按鈕區與 Explorer 之間僅保留 4px 高的透明 divider，移除兩端額外垂直 padding 與虛線。Explorer 的分類、資料夾、文件列共用按鈕的 32px 列高。
- Explorer「置頂／文件／收藏」相鄰分類之間同樣使用 4px 透明間隔，展開與收合皆維持此距離。
- 移除文件分頁標籤與其釘選操作。Stage 上方改為未來工具列；目前只保留位置提示，未臆造工具項目。此決策取代先前引用第一版產品計畫的書籤分頁設計；Explorer 置頂參考仍保留。
- 隱藏 Header 高度約束 `--header-height` 由側欄頂列、工具列與視窗控制列共用，目前 40px，不建立可見的全窗 Header。
- 搜尋放在側欄頂部右側，點選開啟搜尋面板；外觀設定同列。
- Sidebar 與 Stage 均無底部狀態列；Stage 自身無 header。
- 文件背景直接套在 Stage；正文不再是有背景、圓角與陰影的嵌套紙片。Frame 仍無邊框／無陰影，正文內距由內容擁有。
- 補充便利貼與相關文件移到 Stage 外的獨立右側欄，使用 Column 垂直排列，獨立捲動；不屬於 Flow 正文模型。此示例只在改造計畫文件顯示右側資料。
- 右側欄容器 padding 為 0；Column 只套一層水平 12px padding、垂直為 0。桌面第一張便利貼頂緣與 Stage 頂緣對齊，便利貼本身的文字內距獨立保留。

## 風格與內容

繼承 `spec/style-v1.md` 及本對話的 12px 群組決策：Frame 外距／欄距／圓角 12px、padding 0；群組水平 padding 12px；正文水平 30px、垂直 28px。控制無細框、內部分隔採虛線。明暗模式、暖灰／中性灰與便利貼微浮陰影可切換。材質配方已由 Kallopis 語意解析實作，primitive schema 維持固定八階。

第一版側欄 260px、右側欄 244px；HTML 窄視窗將右側欄排到 Stage 之後。桌面布局是目前主要驗收範圍。

Flow 範例包含正文、待辦與文件連結；Canva 範例包含可拖曳／鍵盤移動的便利貼、跟隨端點的連線與新增便利貼。待辦事項和資產庫提供代表画面，AI 保留後續版本入口。除了本輪明確取代的分頁等設計，其產品範圍參考 `D:/Projects/planist/docs/planning/craft-reference/FIRST-RELEASE.md`。

文字與位置僅在頁面記憶體暫存，重新整理重設；待辦彙整未連接正文、附件無實體檔案、Windows 控制只示意外觀。收藏示例目前開啟靈感牆，不再模擬批次開分頁；移除分頁後的收藏多文件呈現流程另待確認。

## 元件化與組裝

第一版已組裝於 Planist Flutter 專案，使用公開宣告式 API。側欄導覽、Explorer、工具列、Stage 與右側便利貼維持獨立結構；API 見 [工作區元件](../../docs/ai/workspace-components.md)。實際元件樹與檔案責任記錄於 `D:/Projects/planist/docs/planning/workspace-component-tree.md`。

從 Planist `frontend` 執行 `flutter run -d windows --dart-define=PLANIST_PREVIEW=true` 可開啟展示資料；省略此參數使用空資料正式入口。Flutter 展示支援文件開啟、搜尋、外觀切換與勾選待辦；Canva 目前提供卡片及新增操作，尚未移植此 HTML 的拖曳連線功能。正式正文編輯、保存與跨重啟恢復仍由產品後續接入。

HTML 保留為參考基準，Flutter 幾何與互動驗收記錄在 Planist 元件樹文件；不把設計稿的模擬行為當成產品功能已完成。
