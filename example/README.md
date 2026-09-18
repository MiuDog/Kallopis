# Kallopis Catalog

以 VS Code 開啟 repository root，在執行與偵錯選 **Catalog — 新架構・淺色 (Windows Debug)**，按 F5。深色與 Profile 也有獨立啟動設定。

[完整開發指南與功能索引](../docs/ai/catalog.md) 說明啟動、目錄責任、元件接入、打包及新舊 API 界線。

| 入口 | 用途 |
|---|---|
| `lib/catalog_main.dart` | 新宣告式 Catalog，目前展示固定工作區 |
| `lib/main.dart` | 舊相容元件目錄，僅作遷移參考 |
| `lib/klp_runtime_demo.dart` | runtime 技術樣板 |
| `lib/klp_workspace_demo.dart` | 相容轉呼叫新 Catalog |
| `editor_native/lib/main.dart` | 可選的真實 Krepis DLL 唯讀編輯內容；需依子目錄 README 配置 |

命令列在本目錄執行：

```text
flutter run -d windows -t lib/catalog_main.dart
flutter run -d windows -t lib/catalog_main.dart --dart-define=CATALOG_DARK=true
flutter build windows --release -t lib/catalog_main.dart
```

不指定 target 的 `flutter run` 仍會開啟舊目錄。Release 交付整個 `build/windows/x64/runner/Release/`，不能只複製執行檔。

目前正式 Button／IconButton 公開節點及狀態展示頁尚未完成。不要將舊 Catalog 的元件誤認為已採用新的 A 密度與宣告式 API。
