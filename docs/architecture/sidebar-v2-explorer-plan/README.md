# Sidebar v2 Explorer 配對契約

狀態：PLAN READY  
版本：`SIDEBAR-V2-EXPLORER-r1`  
接受來源：Planist `docs/planning/sidebar-v2-spec.md` 與使用者於 2026-09-15 授權的相關 Kallopis 修改。

## 目的與非目標

本切片只補足 Planist Sidebar v2 使用 Explorer 所需的通用宣告式能力：可選取且可展開的分支項目、不可選取但可展開的結構項目，以及不顯示尾端按鈕的內容選單觸發政策。

本切片不建立 Planist 頁面模型，不調整既有色彩、尺寸、間距、字體、圓角、陰影、動畫或其他元件；不處理專案 popup、Sidebar header 或 Planist 組裝。

## 公開契約

- `KlpExplorerItemKind.branch` 表示可擁有 children、仍可被選取的通用分支項目；預設圖示維持一般文件，不冒充 folder。
- `KlpExplorerItem.selectable` 由 consumer 控制項目是否能進入單選／多選與 `onSelected`；預設為 `true`，category 仍固定不可選取。
- `KlpExplorerCommandPresentation.contextMenuOnly` 隱藏行尾命令按鈕，但保留相同 commands 的右鍵、選單鍵及 `Shift+F10` 入口；預設模式維持既有按鈕與內容選單行為。
- 展開、選取及命令仍只通知 consumer；Kallopis 不保存產品狀態或執行資料操作。

## 責任與相依方向

- Features 擁有純 Dart 節點、列舉、轉接與已準備資料。
- Rendering 只解讀已準備資料並提供 Flutter 指標／鍵盤互動。
- Consumer 以唯一項目 ID 投影來源列身分，掌管 selected、expanded 與 commands。
- Styling 與既有 semantic primitives 完全不變。

## 不變條件

- `file` 仍禁止 children；`folder` 行為與預設外觀保持相容。
- `branch` 可 inside drop，且列標題啟用選取、disclosure 只啟用展開。
- `selectable: false` 的項目不進入 selected 集合；點擊標題只切換展開。
- `contextMenuOnly` 不移除 commands，也不改命令輸入、確認、取消或錯誤流程。
- 任何模式都不新增局部 style、硬編碼新幾何或修改其他 renderer。

## 選擇與否決方案

採用新增明確的 `branch` kind 與封閉的 command presentation enum，使 consumer 表達語意而不注入 Widget 或 style。

否決把頁面偽裝成 `folder`：這會讓預設圖示與語意把產品頁面呈現為資料夾。否決直接全域移除命令按鈕：這會破壞既有 consumer；改以預設相容的封閉政策選項處理。

## 目前切片與驗收

| 切片 | 產出 | 驗收證據 | 狀態 |
| --- | --- | --- | --- |
| `SIDEBAR-V2-EXPLORER-T1` | 公開 Explorer 契約、features 配對與 renderer 互動 | 獨立測試先證明缺少 branch／不可選取結構列／context-only 與 Shift+F10，再由相同局部測試轉綠；既有 Explorer 互動測試保持通過 | READY |

冷啟動估算：8,000–16,000 模型 token、60–150 分鐘；無可比較的既有 Sidebar v2 任務。里程碑為 T1.1 契約 Red、T1.2 features 配對、T1.3 renderer Green。累計超過 24,000 token 或 210 分鐘時進行異常檢查。

## 受保護路徑

- `lib/src/features/architecture.md`
- `lib/src/rendering/architecture.md`
- 本頁與 Task Packet
- Test Author 交付的 `test/klp_sidebar_v2_explorer_contract_test.dart`
- 所有 styling、golden、fixture、build 設定及非 Explorer 元件
