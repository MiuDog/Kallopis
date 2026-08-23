# Kallopis

[![Flutter](https://img.shields.io/badge/Flutter-3.44.4-02569B?logo=flutter)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-3.12.2-0175C2?logo=dart)](https://dart.dev)
[![CI Status](https://img.shields.io/badge/CI-Passing-brightgreen.svg)](https://github.com/MiuDog/Kallopis)
[![License](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)

**Kallopis** 是專為 `-ist` 產品家族（Notist、Planist 等現代跨平台應用）打造的 **Flutter 視覺層與設計系統（Design System）**。

它提供高精度的 Design Token、多層級主題架構、排版規範與無產品語意污染的通用視覺元件。**Kallopis 對業務邏輯完全無知**——它不包含資料模型、排程或特定產品概念，只專注於構建極致穩定、高度可維護且表現一致的現代 UI 介面。

---

## 核心設計哲學

### 1. 嚴格的 Token 紀律（Strict Token Discipline）
所有元件**嚴禁硬編碼視覺風格**。顏色、間距、圓角、時長與字體一律由 `context.klp` 統一解析與派發。此規則由 CI 閘門（[`test/token_discipline_test.dart`](test/token_discipline_test.dart)）機械執行，杜絕視覺漂移。

### 2. 基於 OKLCH 的 11 階 Ink 中性色梯（Predictable Ink Scale）
所有表面、文字與描邊皆由 `ink50` 至 `ink950` 的 11 階色梯推導，使用感知等亮度的 **oklch** 作為權威色彩格式，確保在明暗主題切換時色彩明度階梯嚴格遞減且完全可預期。

### 3. 原子性主題翻轉（Atomic Theme Transition）
深淺色與視覺風格在切換時**原子性同步翻轉**，消除因動畫過場造成的混合中間態，確保所有介面元件同步響應。

### 4. 角色導向排版體系（Semantic-First Typography）
以功能角色（`KlpTextRole`）為核心，搭載 IBM Plex Mono（等寬代碼與標籤）與 IBM Plex Sans TC（通用長文與 UI），在全平台上保持一致的渲染節奏。

### 5. 零語意洩漏與清晰分層（Pure Layer Isolation）
嚴格遵循「抽層五原則」，拒絕任何與特定產品綁定的業務模型，確保視覺層的高內聚與零副作用。

---

## 快速開始

### 1. 安裝與依賴

Kallopis **不發布到 pub.dev**（`publish_to: none`）。Notist 與同一台機器上的專案
以 path dependency 引入；改動會立即生效，是本機開發的主要方式：

```yaml
dependencies:
  flutter:
    sdk: flutter
  kallopis:
    path: ../Kallopis
```

需要在其他機器重現某個正式版本時，改用固定 Git tag，不要依賴會移動的
`main`：

```yaml
dependencies:
  kallopis:
    git:
      url: https://github.com/MiuDog/Kallopis.git
      ref: v0.5.1
```

然後 `flutter pub get`，接著只要一個 import：

```dart
import 'package:kallopis/kallopis.dart';
```

**字型與圖示會自動跟過來**，消費端不需要在自己的 `pubspec.yaml` 宣告任何資產。
這一點經過實測：從 `flutter create` 的空白專案加上上面兩段設定後直接建置執行，
IBM Plex 字型與 svg 圖示都正常渲染，沒有任何額外設定。

### 2. 一行啟動（`KlpApp`）

使用 `KlpApp` 作為應用根節點，自動配置明暗主題、字型渲染環境與視窗祖先：

```dart
import 'package:flutter/material.dart';
import 'package:kallopis/kallopis.dart';

void main() {
  runApp(
    const KlpApp(
      home: WorkbenchPage(),
    ),
  );
}
```

### 3. 明暗切換與主題風格

在子樹中透過 Context 隨時切換明暗模式：

```dart
KlpApp.of(context).toggleBrightness();
```

若需套用自訂視覺風格或品牌色，可利用 `buildKlpTheme`：

```dart
final customStyle = KlpVisualStyle.defaultStyle.copyWith(
  name: 'sharp',
  shape: KlpShapeTheme.standardShape.copyWith(control: 0, card: 0),
);

MaterialApp(
  theme: buildKlpTheme(Brightness.dark, style: customStyle),
  themeAnimationDuration: Duration.zero,
  home: const WorkbenchPage(),
);
```

外部設定檔統一通過 `KlpVisualStyleJson` 進入 theme。解碼後的元件仍只從
`context.klp` 讀取已解析的視覺值：

```dart
final style = KlpVisualStyleJson.decode(
  jsonTheme,
  base: KlpVisualStyle.forBrightness(Brightness.dark),
);

MaterialApp(
  theme: buildKlpTheme(Brightness.dark, style: style),
  home: const WorkbenchPage(),
);
```

JSON 可完整描述顏色、字體、間距、邊界、圓角、動態、表面效果與稀疏的
component token。局部 JSON 會沿用指定 base style 的其餘值；型別、範圍或欄位名稱
不合法時，`FormatException` 會指出完整 JSON 路徑。`encode` 固定輸出
`schemaVersion: 1`；局部設定可省略版本，明示不支援的版本則會被拒絕。
Flutter 公開 API 仍接受任意 `Curve`；JSON 只接受可無損表示的 `Cubic`，其他 curve
在 encode 時會明確失敗，不會被近似或靜默替換。
公開 theme model 可使用任意 Flutter `Curve`；JSON 為了可攜與無損只支援四點
cubic，encode 遇到其他 curve 會以完整欄位路徑拒絕。

---

## 架構全景

### 三層 Token 繼承架構

```
┌─────────────────────────────────────────────────────────────┐
│ 1. Primitive 層（語彙表，不可直接被元件覆寫）              │
│    KlpScale (數值階梯) ｜ KlpPalette (11階 Ink 與語意色)    │
└──────────────────────────────┬──────────────────────────────┘
                               ▼
┌─────────────────────────────────────────────────────────────┐
│ 2. Semantic 層（設計語意，ThemeExtension 派發）             │
│    Colors ｜ Typography ｜ Spacing ｜ Shape ｜ Motion ｜ Surface │
│    Geometry ｜ Data visualization                             │
└──────────────────────────────┬──────────────────────────────┘
                               ▼
┌─────────────────────────────────────────────────────────────┐
│ 3. Component Token 層（元件級客製，預設繼承 Semantic）       │
│    KlpComponentTheme (按鈕、欄位、選單、卡片、徽章的稀疏覆寫) │
└─────────────────────────────────────────────────────────────┘
```

### 領域元件分類導覽

Kallopis 將視覺元件解構為 15 個正交的專業領域，完整元件樹架構請參閱 [**全元件樹架構文件庫 (`docs/architecture/components/`)**](docs/architecture/components/README.md)：

| 領域 | 職責與代表元件 | 元件樹文件 |
|---|---|---|
| **`app`** | 應用程式進入點、根容器與明暗狀態管理 (`KlpApp`) | [查看架構](docs/architecture/components/app/klp_app.md) |
| **`shell`** | 桌面工作台外殼、多欄收合面板、視窗標題列 (`KlpWorkbenchShell`, `KlpPanelFrame`) | [查看架構](docs/architecture/components/shell/klp_workbench_shell.md) |
| **`controls`** | 按鈕、輸入框、開關、滑桿、分段選擇器 (`KlpButton`, `KlpTextField`, `KlpSelect`) | [查看架構](docs/architecture/components/controls/klp_button.md) |
| **`form`** | 結構化表單、欄位群組、驗證摘要、複合編輯器 (`KlpForm`, `KlpSelectField`, `KlpCodeField`) | [查看架構](docs/architecture/components/form/klp_form.md) |
| **`data`** | 虛擬化表格、鍵值對清單、JSON 樹、代碼檢視器 (`KlpDataTable`, `KlpCodeViewer`, `KlpJsonTree`) | [查看架構](docs/architecture/components/data/klp_data_table.md) |
| **`feedback`** | Toast 短暫通知、內嵌警告、載入狀態、區域佔位骨架 (`KlpToast`, `KlpInlineNotice`, `KlpEmptyState`) | [查看架構](docs/architecture/components/feedback/klp_toast.md) |
| **`overlay`** | 模態對話框、快顯選單、浮動提示 (`KlpDialog`, `KlpMenu`, `KlpTooltip`) | [查看架構](docs/architecture/components/overlay/klp_dialog.md) |
| **`navigation`** | 標籤分頁列、麵包屑、分頁器、側邊圖示軌 (`KlpTabs`, `KlpBreadcrumb`, `KlpRailItem`) | [查看架構](docs/architecture/components/navigation/klp_tabs.md) |
| **`editor`** | 命令選單、編輯器工具列、頁面外框、實體挑選器 (`KlpCommandMenu`, `KlpPageChrome`, `KlpEntityPicker`) | [查看架構](docs/architecture/components/editor/klp_command_menu.md) |
| **`surface`** | 表面容器、虛線描邊框、內容分割線 (`KlpSurface`, `KlpStrokeFrame`, `KlpDashedBorder`) | [查看架構](docs/architecture/components/surface/klp_surface.md) |
| **`layout`** | 可調整寬度面板、分割佈局、虛擬清單與網格 (`KlpSplitLayout`, `KlpResizablePane`, `KlpVirtualList`) | [查看架構](docs/architecture/components/layout/klp_split_layout.md) |
| **`interaction`** | 按壓狀態處理、過濾列、長按靈敏度覆寫 (`KlpPressable`, `KlpFilterBar`, `KlpShortcutHint`) | [查看架構](docs/architecture/components/interaction/klp_pressable.md) |
| **`foundation`** | 圖示系統、色盤定義、幾何指示器 (`KlpIcon`, `KlpIcons`, `KlpGeometricSpinner`) | [查看架構](docs/architecture/components/foundation/klp_icon.md) |
| **`typography`** | 語意角色文字渲染 (`KlpText`) | [查看架構](docs/architecture/components/typography/klp_text.md) |
| **`routing`** | 輕量化目的地分發與 Outlet 渲染 (`KlpRouter`, `KlpRouterOutlet`, `KlpRouterScope`) | [查看架構](docs/architecture/components/routing/klp_router_outlet.md) |

---

## 品質保證與工程紀律

Kallopis 將設計承諾轉化為由 CI 自動運行的**機械檢驗閘門**：

- **Token 紀律檢查**（[`test/token_discipline_test.dart`](test/token_discipline_test.dart)）：禁止任何元件寫死顏色或數值。
- **色彩明度階梯驗證**（[`test/color_discipline_test.dart`](test/color_discipline_test.dart)）：確保 Ink 色梯在 oklch 空間下嚴格單調遞減。
- **視覺回歸測試**（[`test/klp_region_placeholder_golden_test.dart`](test/klp_region_placeholder_golden_test.dart) 等）：Golden 像素級比對，防止樣式非預期跑版。
- **元件庫完整性測試**（[`test/consumer_contract_test.dart`](test/consumer_contract_test.dart)）：從消費者端驗證公開 API 與匯出邊界。
- **元件清單即時性**（[`test/inventory_test.dart`](test/inventory_test.dart)）：確保 `spec/component-inventory.md` 與程式碼實作即時對齊，防範分層違規。

---

## 元件型錄展示（Interactive Catalog）

Kallopis 提供獨立的 Catalog 應用程式供本機即時預覽、互動除錯與主題測試：

```bash
# 啟動 Windows 桌面端元件型錄
cd example
flutter run -d windows
```

亦可執行完整驗證測試：

```bash
# 執行分析與單元/契約測試
flutter analyze
flutter test
cd example && flutter test
```

---

## 授權條款

本專案採用 [MIT 授權條款](LICENSE)。
