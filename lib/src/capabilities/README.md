# lib/src/capabilities：領域能力、狀態與資料契約

[返回上層 (lib/src)](../README.md)

## 目錄職責

`lib/src/capabilities` 封裝與特定 UI 渲染無關的中立領域能力（Capabilities）：包含狀態的借用與擁有、非同步資料生命週期、型別化路由導覽狀態機、文字與筆記編輯資料契約，以及控制器抽象。

## 子目錄結構與職責

| 子目錄 | 核心職責 | 關鍵型別與實作 |
|---|---|---|
| `state/` | **狀態核心契約 (State)**：區分「擁有端（可寫）」與「借用端（唯讀）」；提供 `KlpMutableState` 與唯讀的 `KlpState` 介面，並以 `KlpSubscription` 管理安全訂閱。 | `KlpState`, `KlpMutableState`, `KlpSubscription` |
| `controllers/` | **借用型控制器 (Controllers)**：提供只借用外部 state、不複製狀態且不私自持有外部資源釋放權限的控制器基底。 | `KlpStateController` |
| `data/` | **非同步資料與取消世代 (Data)**：管理非同步載入、成功與失敗狀態；使用世代判定（Generation）讓晚到的無效請求自動失效，具備取消保護機制。 | `KlpAsyncData` |
| `navigation/` | **導覽狀態機 (Navigation)**：型別化路由核心，包含導覽狀態機 `KlpNavigationMachine`、Guard 守衛檢查、堆疊候選、單頁 URI 同步與提交埠。 | `KlpNavigationMachine`, `KlpLocation`, `KlpDestination`, `KlpGuard` |
| `editing/` | **文字與筆記編輯能力 (Editing)**：筆記元件計畫核心，包含多語言 UTF-8/UTF-16 偏移對齊、組字輸入分段 `KlpCompositionSegment`、版本時間戳 `KlpEditingStamp` 與區塊轉換意圖。 | `KlpCompositionText`, `KlpEditingStamp`, `KlpBlockIntent`, `KlpTextOffsets` |
| `actions/` | **操作與意圖模型 (Actions)**：定義動作意圖、鍵盤快捷對應與操作契約。 | 操作模型 |
| `layout/` | **能力層佈局計算**：非 UI 排版的中立幾何計算與約束模型。 | 排版度量計算 |

## 架構依賴與邊界約定

- **中立性**：此目錄純粹由純 Dart 撰寫，嚴禁依賴 `KlpScreen`、Flutter Widget 或 BuildContext。
- **所有權單一來源**：狀態的擁有者（Owner）負責寫入與生命週期，元件與控制器僅能取得 `readOnly` 的 `KlpState`，嚴禁多點私自維護同步副 state。
- **世代安全**：非同步操作及導覽跳轉均受世代編號（Generation / Stamp）保護，防止非同步回傳覆蓋最新使用者操作。
