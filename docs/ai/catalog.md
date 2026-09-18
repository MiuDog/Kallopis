# Catalog 開發與驗收入口

## 舊元件遷移進度

固定清冊共254項，逐項狀態見 [Catalog 遷移](../architecture/catalog-migration/README.md)。CM-01 新 `KlpMenu`／`KlpMenuItem` 有獨立真實展示：在 `example` 執行 `D:/flutter/bin/flutter.bat run -d windows -t lib/catalog_menu_main.dart`，深色加 `--dart-define=CATALOG_DARK=true`；其 [API 與限制](menu-model.md) 不等同於 ContextMenu／CommandMenu 與所有工作區命令已接線。舊版保留到全部對應完成再刪除。

在 `example` 執行 `D:/flutter/bin/flutter.bat test --no-pub test/catalog_migration_inventory_test.dart --dart-define=CATALOG_MIGRATION_REQUIRE_COMPLETE=true` 才是強制完成檢查；目前預期失敗。一般清冊檢查通過只代表沒有漏列或偽造已完成記錄。

從 repository root 用 VS Code 開啟專案。安裝推薦的 Dart／Flutter 擴充套件，在「執行與偵錯」選 **Catalog — 新架構・淺色 (Windows Debug)**，按 F5。深色選另一個 Debug 設定；停止目前執行後再切換，避免 Windows 建置檔被占用。

本機 2026-09-10 查證：Flutter 3.44.2／Dart 3.12.2 位於 `D:/flutter`，Windows C++ Build Tools 可用。若 VS Code 找不到 SDK，使用 Flutter: Change SDK 選擇本機 Flutter 目錄。不要照搬舊文件的 C:/Projects 或 C:/development 路徑。

Windows 新 Catalog 的右上角提供最小化、最大化／還原與關閉；標題空白區可拖動，雙擊切換最大化。沿用 `example/windows/runner/flutter_window.cpp` 的 `kallopis/window` 通道。其他消費端要使用同樣的原生控制，runner 必須接入此通道；它不是只加入 Dart 套件就會自動安裝的原生 plugin。Web 不顯示視窗按鈕。

Header 預設高度收緊為 32，視窗按鈕直接沿用舊 Catalog 的 `KlpWindowControls`：24／圖示 12，包含提示與關閉互動色；一般側欄控制仍為 32／16。行動端與窄視窗保留至少 48 的觸控槽；文字放大時 Header 可增高。

## 入口與狀態

| 入口 | 用途 | 狀態 |
|---|---|---|
| `example/lib/catalog_main.dart` | 新 Catalog；Debug、Profile、Release 共用 | 目前收納固定工作區樣板 |
| `example/lib/catalog_declarative/catalog_application.dart` | app、內建 catalog、router 與 screen 組合根 | 只使用宣告式公開 API |
| `example/lib/workspace_demo/` | 工作區 specimen 的資料與定義 | 沿用 A、Noto Sans TC、14／18；正文 16／24 |
| `example/lib/klp_workspace_demo.dart` | 舊樣板命令的相容入口 | 轉呼叫同一 Catalog，不維護第二份畫面 |
| `example/lib/main.dart`、`example/lib/catalog/` | 舊相容 API 元件目錄 | 可獨立執行作遷移參考，不代表新 API 已完成 |
| `example/lib/klp_runtime_demo.dart` | 宣告式 runtime 技術樣板 | 保留獨立入口，不當作正式元件展示 |

直接執行未指定 target 的 `flutter run` 仍會啟動舊 `main.dart`。開發新元件務必選新 Catalog 設定或指定 `-t lib/catalog_main.dart`。

```text
example/lib/
├─ catalog_main.dart                  新 Catalog 啟動入口
├─ catalog_declarative/
│  └─ catalog_application.dart        單一 app／內建 catalog／路由組合根
├─ workspace_demo/                   已存在的工作區 specimen
├─ klp_workspace_demo.dart            相容轉呼叫
├─ klp_runtime_demo.dart              runtime 技術樣板
├─ main.dart                         舊 Catalog 入口
└─ catalog/                          舊元件頁與生成 registry
```

## 元件接入順序

| 系統 | 新 Catalog 狀態 | 下一步 |
|---|---|---|
| Workspace | 可操作樣板 | 保留三欄、拉伸、收合與手機全畫面側欄 |
| Button／IconButton | 僅有 Workspace 內部控制呈現；正式公開節點與展示頁待實作 | 建立資料／callback 宣告、狀態呈現及 specimen |
| Input／Selection | 尚未具備可展示的新 renderer | 完成庫內能力後再加入 |
| List／Menu | CM-01 新選單面板及項目已接入獨立真實 Catalog；List、ContextMenu、CommandMenu及工作區命令接線仍待遷移 | 依固定清冊逐項接入，不把面板完成視為整個家族完成 |

新增 specimen 時，元件實作放 Kallopis `lib/src`，Catalog 只注入資料、callback 與受控模板。不得 import 舊 widget 補洞，不提供 consumer 的局部 style／font／padding 參數。每頁須標示實際 API、狀態、已採用語意與可執行範例；未完成狀態不得用靜態文字冒充操作。

舊 registry 由 `spec/semantics/kallopis.semantic-manifest.json` 產生，生成器是 `tool/generate_catalog_registry.dart`。它不自動代表新宣告式能力，不能直接把舊 registry 掛到新 app。

## 命令列與打包

以下在 `example` 目錄執行，Flutter 須在 PATH，或以本機 SDK 的 flutter.bat 完整路徑替代：

```text
flutter run -d windows -t lib/catalog_main.dart
flutter run -d windows -t lib/catalog_main.dart --dart-define=CATALOG_DARK=true
flutter run -d windows --profile -t lib/catalog_main.dart
flutter build windows --release -t lib/catalog_main.dart
```

Debug 適合偵錯與 Hot Reload；改啟動期組合根、Kallopis 內建 catalog 或 dart-define 後需 Hot Restart／重新啟動。Profile 用於效能觀察；Release 用於階段交付。這三者共用相同入口，不能各自建立元件規格。

Release 輸出在 `example/build/windows/x64/runner/Release/`，分享整個資料夾（exe、DLL、data），不要只複製 exe。不要自動強制終止所有同名 Catalog；遇到檔案占用，先停止自己開啟的偵錯工作階段。

啟動設定欄位依據 [Dart Code 官方文件](https://dartcode.org/docs/launch-configuration/)。

## 檢查邊界

宣告式視窗控制元件由 Kallopis renderer 提供動作與無障礙語意；Tooltip 並非目前公開契約。消費端不得注入 Overlay、Navigator 或另一套視窗控制實作。主機更新與卸載的可判定生命週期由應用／runtime 測試負責，感官呈現由人工驗收。

在 repository root 執行，三處都須通過：

```text
dart run tool/verify_declarative_consumer.dart example/lib/catalog_main.dart
dart run tool/verify_declarative_consumer.dart example/lib/catalog_declarative
dart run tool/verify_declarative_consumer.dart example/lib/workspace_demo
```

整體畫面尚未定型；本輪使用分析、純邏輯／架構檢查與建置驗證，不新增或更新全畫面 golden。建置成功不代表原生互動、觸控或 VS Code 實際 F5 已驗收。
