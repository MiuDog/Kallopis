# Workbench 官方參考與能力差異

查核日期：2026-10-12。這份文件記錄參考證據，不是視覺或 API 權威；本庫需求由 [Workbench v1](../../spec/workbench-v1.md) 擁有，外觀由既有通用視覺規範擁有。

## 官方參考

| 參考 | 已查核的能力 | Kallopis 採用方向 |
| --- | --- | --- |
| [VS Code 布局](https://code.visualstudio.com/docs/configure/custom-layout) | 編輯器群組可組成多列、多欄，拖曳分隔線調整尺寸；支援分頁及原生浮動視窗。 | 採用單一宿主內的群組、分割、分頁與調整尺寸；原生浮動視窗不納入 v1。 |
| [VS Code 命令](https://code.visualstudio.com/api/extension-guides/command)、[context 條件](https://code.visualstudio.com/api/references/when-clause-contexts) | 註冊命令處理函式；命令可由面板、選單、快捷鍵觸發，context 控制適用性。 | 共用命令 ID 與狀態，使工具列、選單、面板、快捷鍵使用相同命令。條件使用框架原生資料及函式，不引入 VS Code 擴充套件執行環境。 |
| [VS Code 快捷鍵](https://code.visualstudio.com/docs/configure/keybindings) | 平台對應、連續組合鍵、條件規則、修改／移除／還原與同鍵衝突查詢。 | 支援 chord、焦點作用域、重綁與衝突診斷；產品擁有設定儲存位置。 |
| [Blockbench Panel](https://web.blockbench.net/docs/classes/generated_interface_panels.Panel.html) | 公開 API 包含附加 panel、選擇 tab、調整大小、折疊、位置自訂與重設；也提供浮動 panel 能力。 | 沿用 panel registry、受控位置、tabs、收合與重設；不照搬其應用程式資料模型。 |
| [Blockbench Action](https://web.blockbench.net/docs/classes/generated_interface_actions.Action.html)、[Keybind](https://web.blockbench.net/docs/classes/generated_interface_keyboard.Keybind.html) | Action 帶有條件、分類、選單／工具列及 keybind；Keybind 提供錄製、設定、保存及 conflict 狀態。 | 命令 metadata 接入多個入口，提供快捷鍵錄製與診斷；保存透過 consumer callback。 |
| [Visual Studio 視窗布局](https://learn.microsoft.com/en-us/visualstudio/ide/customizing-window-layouts-in-visual-studio?view=visualstudio) | 工具視窗可停靠、浮動，支援自訂布局的保存與套用。 | 提供布局匯出、還原及重設；命名方案與跨裝置同步由產品決定。 |
| [Qt QMainWindow](https://doc.qt.io/qt-6/qmainwindow.html) | 提供 resizeDocks、tabifiedDockWidgets、saveState、restoreState。 | 作為停靠尺寸與布局保存的框架參考；本庫自行定義版本化契約，不相容其二進位格式。 |

表中的「採用方向」是本專案推論與決策，不代表上游 API 或布局算法已移植。研究以官方文件可觀察行為為依據；未將各軟體原始碼或內部算法視為已完成審核。

## 已存在的本庫能力

| 能力 | Flutter 現況 | React 現況 | v1 工作方向 |
| --- | --- | --- | --- |
| 一般遞迴布局 | 已有 AppLayout Row／Column／Pane；KLP-0024 規定其 divider 不可拖曳。 | 核心 Frame／Workspace 組合，尚無同等一般布局。 | 對齊幾何契約；一般布局與 Dock 保持不同公開語意。 |
| 停靠互動 | 已有 DockLayout、固定 Left／Right／Bottom area、panel、group、tabs、拖放、resize、collapse。 | 尚無 Dock 公開能力。 | 先驗證並沿用 Flutter，再交付 React 對等能力。 |
| 分頁與浮層 | 已有 DocumentTabs、AnchoredPopup、menu／context menu。 | 已有核心按鈕、輸入等基礎元件。 | 沿用可重用元件，補齊雙框架互動與合法組合。 |
| 命令 | 已有 WorkspaceCommand 輸入／非同步結果流程。 | 尚無命令 registry。 | 不把單一命令對話流程誤認為命令 registry；補齊註冊、查詢與共用狀態。 |
| 快捷鍵 | 已有 KeyBindingController、Host、app／page／region／component 作用域及註冊 disposer。 | 尚無快捷鍵 registry。 | 補齊 chord、重綁與衝突處理，保留既有入口。 |
| 保存還原 | Dock layout 已是受控資料；完整版本化保存契約尚待驗收。 | 尚無布局保存契約。 | 庫負責編碼、驗證與還原結果，產品負責儲存。 |
| 視覺 | 直接元件使用 semantic theme。 | 已從正式規範生成 token。 | 使用同一份正式語意與配方，保持 hover／selected 同色。 |

現況依公開入口及直接相關程式／審核文件判讀；「已有」不代表本次重新執行所有互動或測試。既有驗證與繼承失敗仍以 [整合紀錄](../architecture/multi-framework-verification.md) 為準。

## 必須延續的邊界

- [KLP-0024](../../spec/decisions/KLP-0024-workbench-and-dock-layout-boundary.md)：一般布局與 Dock 分離；固定 Stage 與三個停靠區；不引入跨視窗拖放或浮動 panel。
- [直接能力審核](../architecture/thin-design-system/direct-workspace-capability-audit.md)：沿用直接元件，不恢復 node、adapter、bound model 或 renderer。
- [前端責任](../architecture/frontend-boundaries.md)：產品掌管內容、路由、業務狀態及保存策略；本庫掌管通用呈現及互動。
- [通用視覺規範](../design-tokens/KALLOPIS-DESIGN-MAP.md)：正式章節是唯一資料權威，不另建 workbench theme 或套用參考軟體的外觀。
