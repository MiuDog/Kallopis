# Kallopis 原始碼模組登錄表

Status: Active（使用中）

依據：[模組架構 v1 規格](../../spec/module-architecture-v1.md)

## 目的

本檔是 `lib/src/` 模組根目錄的唯一登錄表。目錄必須列於本表且擁有 `architecture.md`，才視為模組。其他目錄皆是其最近一層已登錄模組的內部責任區。

## 已登錄模組

| 層級 | 模組 | 契約 | 模組責任 |
| --- | --- | --- | --- |
| L0 | `kernel` | [kernel/architecture.md](kernel/architecture.md) | 身份識別、契約診斷與不依賴框架的生命週期基礎單元。 |
| L1 | `styling` | [styling/architecture.md](styling/architecture.md) | 基礎樣式結構、語意風格契約與解析。 |
| L1 | `capabilities` | [capabilities/architecture.md](capabilities/architecture.md) | 不依賴框架的狀態、動作、資料、導覽與編輯契約。 |
| L2 | `composition` | [composition/architecture.md](composition/architecture.md) | 唯一結構樹、受限插槽、封閉元件目錄與驗證。 |
| L3 | `foundation` | [foundation/architecture.md](foundation/architecture.md) | 不依賴渲染器的範本、準備完成的呈現值，以及共用的平台／互動／版面契約。 |
| L4 | `runtime` | [runtime/architecture.md](runtime/architecture.md) | 通用編譯、轉接器與安裝契約。 |
| L5 | `features` | [features/architecture.md](features/architecture.md) | 本庫擁有的可組合功能定義、轉接器與呈現事件。 |
| L6 | `rendering` | [rendering/architecture.md](rendering/architecture.md) | 準備完成契約的私有 Flutter 與 WebView 實作。 |
| L7 | `application` | [application/architecture.md](application/architecture.md) | 最終應用程式與畫面組裝，以及宿主生命週期。 |

## 相依規則

相依必須指向較低層的契約。模組也可跨越明確的執行階段邊界傳送準備完成的資料，但雙方所屬模組契約都必須描述該邊界。禁止循環相依、為取得便利型別而匯入較高層實作，或存取其他模組的 `internal/` 目錄；唯一例外是既有相容路徑已明確記錄於雙方契約，並附有移除閘門。

`kallopis_declarative.dart` 是現行公開組裝來源。Stable 舊版函式庫在 KLP-0019 P9 前保留為相容介面，但不能擴充宣告式樹。無論 Dart 匯入是否可達，`lib/src` 都維持私有。

## 已觀察到的遷移欠債

原稽核六組第一層循環已依 AD／PRES／L10N／METRICS 配對消除。METRICS-V1-r1 全來源指令圖（含相對／條件／公開 library 路由）確認九模組無循環；最後的 styling 度量來源已向下歸位。詳細圖證據見 [驗證](../../docs/architecture/metrics-module-plan/verification.md)。具名 internal、相容分類與公開節點切片已由 LOWER／COMPAT／APP-CONTRACT 完成，renderer session 已由 REND-HOST 完成；HOST-PORTS 已完成環境與選檔宿主配對。

各所屬模組契約必須標明自己在循環中的一側、選定相依反轉或責任搬移的接點，並指定移除切片。任何契約都不得將永久循環列為例外。

## 模組升格規則

巢狀責任區只有在下列條件全部具備證據時，才能升格為模組：

1. 擁有跨越既有模組邊界使用的獨立公開契約。
2. 擁有目前上層模組無法一致維護的不變條件或生命週期。
3. 具有獨立的變更原因與節奏。
4. 架構統籌者在 BUILD 前更新本登錄表及所有受影響介面的雙方契約。

資料夾大小、檔案數量、熟悉的分層名稱或假設的未來重用情境，都不足以支持升格。

## 架構契約閘門

每個已登錄模組契約都必須包含：目的與非目標、目標階段與能力範圍、所屬路徑與公開介面、內部責任與相依方向、不變條件與錯誤／生命週期權責、相依規則、採用設計與否決的重要方案、目前階段切片、驗收證據、測試狀態及受保護路徑。

架構契約是受保護的 PLAN 產物。產品 BUILD 執行者可以讀取，但除非其任務包明確指派架構統籌工作，否則不得修改。

## 測試政策

儲存庫測試只提供確定性的程式證據。像素外觀、視覺品味、互動手感與美感驗收由人類負責，不是必要測試閘門。幾何、語意、無障礙、狀態、生命週期、錯誤及公開邊界，只要結果可確定，仍可測試。

測試依目前工作流程 skill 選擇。任何模組契約都不要求例行執行完整測試套件。

## 遷移狀態

| 模組 | 契約狀態 |
| --- | --- |
| `kernel` | v1 已規劃並稽核。 |
| `styling` | 現行 v1 切片已完成，SEM-V1-r1 已提供具名語意驗證／解析契約；METRICS 已消除 styling 對 foundation 的反向相依，Stable 相容 API 的 P9 移除閘門保持。 |
| `foundation` | v1 已規劃並稽核；已封閉公開元件自訂入口並完成 FND-V1-02 編譯器退役；PRES-V1-r1 已完成 FND-V1-03/04，無上層或引擎相依；FND-V1-07 已完成唯一 l10n；FND-V1-05 已完成舊度量唯一來源及相容 export。 |
| `capabilities` | v1 已規劃並稽核；CAP-V1-04 已接收三個純平台 enum；CAP-V1-02 提供者具名契約與 CAP-V1-03 舊正文用途分類已完成。 |
| `composition` | v1 已規劃並稽核；已完成 COMP-V1-02 封閉目錄建構邊界；COMP-V1-03/04 已完成自適應實作與平台值權責遷移；COMP-V1-05 已完成 styling 驗證介面，現行 v1 切片已完成。 |
| `application` | v1 已規劃並稽核；已移除消費端元件輸入，完成 APP-V1-03 的內建組裝與權責清冊；APP-V1-06 具名契約及 APP-V1-04 唯一 l10n 已完成；APP-V1-05 環境與選檔宿主埠已完成。 |
| `features` | v1 已規劃並稽核；已完成 FEAT-V1-02 的 67 個匯出／24 個功能身分權責清冊；FEAT-V1-03 的 runtime 路徑及 FEAT-V1-04 功能 presentation 已配對整合；FEAT-V1-05 已完成 l10n 下移；FEAT-V1-07 公開節點封閉已完成；FEAT-V1-06 選檔宿主配對已完成，現行清冊 66 個匯出／24 個功能身分。 |
| `runtime` | v1 已規劃並稽核；執行階段未公開匯出，已完成 RUN-V1-03 舊版元件輸入退役；RUN-V1-02 已完成套件內契約與具名入口搬移；RUN-V1-04 已接手自適應實作；RUN-V1-05 已完成 styling 具名解析路徑，現行 v1 切片已完成。 |
| `rendering` | v1 已規劃並稽核；REND-V1-03 已使用功能自有呈現紀錄，保留 26 型別分派；REND-V1-02 已完成在地化；REND-V1-04 具名下層契約與 REND-V1-05 renderer 局部 session 生命週期已完成。 |

v1 儲存庫閘門目前已有全部九份契約文件、公開禁止擴充路徑的編譯證據，並已完成視覺測試退役。上述剩餘切片用於清除實作欠債，不代表允許重新開放消費端元件註冊或恢復必要視覺基準。

下一輪工作的統籌目錄見 [全模組下一切片](../../docs/architecture/module-next-slices.md)；各模組契約仍是切片狀態與責任邊界的依據。

LOWER-V1-r1 已完成 CAP-V1-02／REND-V1-04：具名 provider、bound 與 styling 契約已配對全部直接呼叫端；不改 module DAG。FND-V1-05 的 styling↔foundation 循環已由 METRICS-V1-r1 消除，APP-V1-06 其餘 internal 邊已由 APP-CONTRACT-V1-r1 完成。

COMPAT-V1-r1 已完成 CAP-V1-03／FEAT-V1-07：provider用途分類與七個layout節點封閉通過獨立檢查，全部catalog身分及Stable相容移除閘門保持。APP-CONTRACT-V1-r1 已完成 APP-V1-06；REND-HOST-V1-r1 亦完成 REND-V1-05；HOST-PORTS-V1-r1 已完成 APP-V1-05／FEAT-V1-06。

REND-HOST-V1-r1 完成時，renderer 文字／WebView 局部生命週期及 application 錯誤轉送使 v1 達到當時的 48/50；該批歷史證據見[驗證](../../docs/architecture/rendering-host-plan/verification.md)。

HOST-PORTS-V1-r1 完成最後環境／選檔配對，全 v1 50/50。完整 CI 既存失敗、獨立逐項稽核與限制見[最終驗證](../../docs/architecture/host-ports-plan/verification.md)。
