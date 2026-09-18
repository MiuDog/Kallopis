# lib/src/rendering：平台渲染原語與呈現轉譯

[返回上層 (lib/src)](../README.md)

## 目錄職責

`lib/src/rendering` 是全庫唯一允許將宣告式不可變快照轉換為具體平台 Widget 的內部渲染層。它將由 `runtime` 產出的封閉 `KlpBoundTemplate` 映射為實際的 Flutter 渲染原語，同時集中處理鍵盤焦點、選取狀態、滑鼠互動與無障礙語意。

## 子目錄結構與職責

| 子目錄 | 核心職責 | 關鍵型別與實作 |
|---|---|---|
| `flutter/` | **Flutter 渲染轉譯與焦點處理**：將封閉 Bound 模板轉為 Flutter 原生 Widget，包含文字、線性排版、表面、選擇項操作、三區佈局（regions）、方向尺寸與保留頁面堆疊。 | `KlpFlutterRenderer`, `KlpFlutterChoice`, `KlpFlutterRegions`, `KlpFlutterRetainedStack` |

## 關鍵渲染機制

- **KlpFlutterChoice**：集中管理點擊、鍵盤（Enter / Space）與輔助技術語意操作，避免個別元件自行重複實作按鍵處理。
- **KlpFlutterRegions**：三區佈局原語，先保證兩側尺寸，再讓中央取得彈性空間；當視窗過窄時自動啟用滾動，且維持相同的樹拓撲以避免焦點丟失。
- **KlpFlutterRetainedStack**：多畫面路由堆疊的渲染原語。對非作用中的背景畫面使用 `Offstage`、`IgnorePointer`、`ExcludeSemantics` 與停用 `FocusScope` 進行徹底隔離，但保留 Widget 實例以在返回時秒級還原。

## 架構依賴與邊界約定

- **零上游業務外洩**：渲染層不辨識自訂商業元件（如 Rail、Note 等業務實體），只辨認通用的封閉 `KlpBoundTemplate`。
- **不可存取未解析 Token**：所有樣式值皆由 `bound` 物件直接提供已解析數值，渲染層絕對不自行建立第二份 Token 預設值。
- **不可逆流**：渲染層不得反向呼叫 runtime 編譯器或消費端未經租約檢驗的回呼。
