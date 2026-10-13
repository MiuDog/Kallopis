# Single Architecture v1

狀態：IMPLEMENTED（2026-09-20）。宣告式架構與產品 editor host 均已移出 Kallopis。

規格：[KLP-0022](../../../spec/decisions/KLP-0022-thin-design-system-boundary.md)。

## 目的與非目標

Kallopis 只保留直接 Flutter design system。所有產品從自己的 Flutter root 安裝 Kallopis theme、使用公開 Flutter 元件組合畫面，並自行持有導航、狀態與流程。

本階段不重設外觀、不搬移 Krepis／provider 資料權威、不建立替代 declarative schema，也不以 deprecated、shim 或 feature flag 保留舊路徑。

## 唯一依賴方向

```text
Product state／navigation／workflow
	↓ projection／callback
Product-owned Flutter Widget tree
	↓ public Widget API
Kallopis foundation／experimental components
	↓ semantic tokens
Kallopis theme
	↓
Flutter
```

禁止 product → `lib/src`、product → declarative node／adapter／bound／renderer，以及 Kallopis component → product model。

## 責任與路徑

| Owner | 責任 | 現行公開入口 | 禁止保留 |
| --- | --- | --- | --- |
| Kallopis theme | semantic colors、type、space、shape、motion、surface、component recipe | `lib/kallopis_theme.dart` | product-specific theme、第二份 token source |
| Kallopis components | 可重用 Flutter Widget、元件內部互動、a11y、平台差異 | `lib/kallopis_foundation.dart`、`lib/kallopis_experimental.dart` | declarative node、adapter、bound record、private renderer |
| Planist modules | 每項能力的 domain、application 與 presentation | `frontend/lib/modules/<capability>/**` | 跨能力 presentation import、反向層級依賴、Kallopis private imports |
| Planist shared | 至少兩個 module 使用的產品共用能力 | `frontend/lib/shared/**` | 單一 module 專用 Widget、第二份 theme |
| Catalog | 公開 Flutter 元件狀態展示與人工接受 | `example/lib/**` | declarative Catalog specimen、固定 254 coverage gate |

## 不變條件

- Planist controller、Krepis session、正文、undo、dirty 與 persistence owner 不變。
- 公開元件只從 Kallopis semantic theme 解析共用外觀。
- 已接受的 Explorer、Frame、icon、按鈕列及 hover／selected 視覺不回退。
- 舊架構移除後不得新增同義 bridge 或「暫時」host。
- 歷史只存在 Git；current tree 不保存 superseded 計畫副本。

## 已完成 slices

### SA-1：Planist Flutter root 與直接畫面

將 `PlnApplication` 改為產品狀態／專案協調 owner，透過 `ChangeNotifier` 或等價 Flutter listenable 驅動畫面；`main.dart` 直接掛載 `MaterialApp` 與 Kallopis theme。工作區、側欄、內容、Explorer、文件分頁、視窗控制、設定與專案操作改用公開 Flutter/Kallopis Widget。

結果：`frontend/lib` 零 declarative import；產品最高層級 widget smoke test 可建立 app；Krepis 與正文資料權威未搬移。

### SA-2：Kallopis 舊 runtime 移除

在 SA-1 不再需要舊 caller 後，刪除 declarative public library、legacy file-picker root，以及只服務 node／composition／runtime／bound renderer／application host 的來源。仍被新版公開元件使用的底層值、資料 owner 或平台 helper 保留在其真正 owner，不因原目錄名稱機械刪除。

結果：三個新版 public barrels 可分析；source、test、example 零 declarative import；舊 application、composition、runtime、rendering 與 declarative-only feature paths 已刪除。

### SA-3：測試、Catalog、工具與文件收斂

刪除只驗證舊 runtime 的測試、宣告式範例、固定 Catalog migration、舊計畫、暫存 Task Packet、失效生成頁與無 caller 的 ownership manifest。仍有產品價值的行為由直接 Widget 測試覆蓋；唯一產品使用指南使用真實 public API。

### SA-4：整合驗證

序列執行 Kallopis public API analyze、直接 Widget 局部 tests、Planist analyze 與最高層級 smoke test。視覺與互動手感標記 human-pending，不以 deterministic test 代替。

## 受保護內容

- Krepis repositories 及其資料格式。
- Planist persistence／project switching／session registry 的資料權威。
- Kallopis semantic theme 值與已接受視覺 baseline，除非直接失去唯一 owner。
- 與舊 declarative runtime 無關的使用者未提交變更。

## 里程碑結果

| 里程碑 | 結果 | 證據 |
| --- | --- | --- |
| M1 | Planist 直接使用 Flutter 與 Kallopis 公開 Widget | production import scan、Planist analyze、single architecture smoke test |
| M2 | Kallopis 舊 runtime 與專用 caller移除 | symbol／import scan、public barrels analyze |
| M3 | 文件、Catalog、工具與測試收斂 | inventory、discipline tests、完整 Kallopis test suite、唯一使用指南 |

SA-01～SA-11 均已實作；editor host ownership 證據見 [Editor Host Ownership v1](../editor-host-migration/architecture.md)，整體機械驗證見 [verification.md](verification.md)。

舊 `KlpWorkspaceBlock` 的逐 kind 能力去向與不恢復理由見
[Workspace Block 能力審核](workspace-block-audit.md)。

薄型架構切換前後所有直接 workspace public family 的逐項去向見
[Direct Workspace 能力差異審核](direct-workspace-capability-audit.md)。
