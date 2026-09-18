# Explorer Catalog

入口：[example/lib/explorer_catalog.dart](../../example/lib/explorer_catalog.dart)。它使用正式 Explorer adapter、semantic resolver 與 renderer，示例資料不含 Planist 商業邏輯。

從 `example/` 執行：

```powershell
D:/flutter/bin/flutter.bat run -d web-server --web-hostname 127.0.0.1 --web-port 5873 -t lib/explorer_catalog.dart
```

開啟終端顯示的本機網址。Catalog 有深淺色、布局／命中框、拖放許可切換與事件紀錄，展示分類、可承載空節點、深層、長標題、受控多選、行內確認與右鍵輸入命令。寬視窗並列一般與窄欄，窄視窗展示單欄。

## 拖曳預覽

開啟「允許拖放」後，拖曳浮影包含原節點圖示與標題。放置指示為填滿既有列間隙的圓角長條：before 使用目標前方間隙，after 使用目標整個可見子樹後方間隙，inside 在該間隙以子層縮排表示加入子項末端。node 放置長條起點與預計插入層級的圖示對齊，inside 再增加一層節點縮排。長條高度等於 gap（目前 4px）、兩端半徑為高度一半，不推動原本的列。首尾無間隙時貼列內側邊界顯示。沒有許可、自我或循環位置不顯示線；離開或放下後清除。Catalog 只記錄事件，資料移動仍由 consumer 提交。

## 已接受基準

2026-09-15，使用者在最後一輪圖示與放置長條對齊修訂後明確回覆「通過，進入下一步」。接受範圍為本次 Explorer Catalog；不延伸為 Planist Sidebar 組裝或其他元件的外觀接受。

| 用途 | 已接受值／規則 |
| --- | --- |
| 節點列高／分類列高 | 各自 28；用途獨立 |
| 一般圖示／展開命中寬度 | 各自 20 |
| 分類箭頭 | 文字後方，圖示 12；命中範圍維持 20 × 分類列高 |
| 分類字級 | 12 |
| 縮排／列內距 | 各自 8 |
| 列間距 | 4 |
| 行內操作範圍 | 32 |
| 一般背景 | 透明，使用宿主表面 |
| 節點圖示對齊 | 同層固定起點；圖示左側預留箭頭欄，不隨子項有無改變 |

後續修改仍按「一般、hover、selected、focus、收合、長文字、深層、選單、命中範圍」展示候選。同值不表示彼此因果綁定；更新值由 KLP semantic owner 維護。此次接受依據是使用者回覆，不是 agent 檢視或程式測試。

`ExplorerPreview` 是庫內 Catalog 宿主，因嵌入既有 Widget 展示器而直接連接內部 runtime；不是公開 consumer 範本，不得複製其 internal imports。產品使用 [公開宣告 → 組裝](explorer-model.md)。

## EXP-V1-r3 已接受箭頭與遞迴收合修訂

節點與分類共用 12px 箭頭，命中寬度維持 20px；空分類顯示箭頭，可收合時可切換。Catalog 增加「空分類：仍可展開／收合」與「遞迴收合後代」切換。開啟後收合第一個分類再展開，可承載節點應維持收合；停用時保留後代展開狀態。不可收合分類保留向下指示，不提供切換按鈕。

使用者於 2026-09-15 檢視本輪 Web Catalog 後回覆「同意」，接受箭頭同尺寸、空分類箭頭與可選遞迴收合互動。本節更新上方基準的箭頭與收合行為；其餘已接受用途保持。驗證與啟動方式見 [修訂紀錄](../architecture/explorer-v1-plan/expansion-verification.md)。
