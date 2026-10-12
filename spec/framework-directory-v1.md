# Framework Directory v1

日期：2026-10-11；擁有 module：repository integration；stage：Iteration；需求 READY。

使用者指定所有框架庫位於第一層子目錄，並要求完成整體目標。採用 `flutter/`、`react/`，根目錄維護共通規範、docs 網站與 repository 整合。

| ID | 版本 | 優先級 | 需求 | 驗收 | 狀態 |
| --- | --- | --- | --- | --- | --- |
| FD-01 | v1 | P1 | Flutter 套件整體移入 `flutter/` | `lib`、`assets`、`test`、`example`、pubspec／lock／analysis options 與 Flutter 專用工具同屬框架；根目錄不再是 Flutter 套件 | accepted |
| FD-02 | v1 | P1 | 既有變更與公開契約保留 | 搬移前後內容可追溯；套件名稱 kallopis、Klp 型別及 package 資產 ownership 不變；不新增相容 runtime 或根套件 shim | accepted |
| FD-03 | v1 | P1 | 工具、CI、編輯器及文件接入新路徑 | Flutter 分析、example、既有測試及 inventory gate 在新位置執行；docs 網站仍由根工具產生；抽取工具指向新公開來源 | accepted |
| FD-04 | v1 | P1 | 文件明示 consumer 的 path dependency 變化 | 指向 repository 的 consumer 改用 `Kallopis/flutter`；本目標不授權修改其他產品 repo，不宣稱外部產品已遷移 | accepted |

本次為明確接受的框架目錄搬移，不重新設計 Flutter 元件。資料與 editor owner 不變。根目錄的共通視覺與規範不移入 Flutter；框架 metadata 及 generated artifacts 依其 ownership 設置。

已依本契約實作；來源保留對照與驗證結果見 [整合紀錄](../docs/architecture/multi-framework-verification.md)。
