## 分析入口

`app/` 由 `KlpApp` 組合環境 scope、App 控制 scope、MaterialApp、風格、語系、可選路由與視窗標頭；Panel Tree 內容由透明 Material 提供文字與互動祖先。`KlpEnvironmentScope` 只提供執行平台，`KlpAppController` 管理明暗模式，視覺 token 仍由 theme 模組解析。`KlpAdaptive` 只選平台分支，各分支回傳 `KlpPanelLayout`；此目錄無巢狀子目錄。

| 想查的問題 | 符號與來源 |
| --- | --- |
| App 與明暗控制的入口？ | KlpApp／KlpAppController — `lib/src/application/legacy/klp_app.dart:83`、`lib/src/application/legacy/klp_app.dart:17` |
| 平台如何注入與讀取？ | KlpEnvironmentScope／KlpEnvironmentContext.klpPlatform — `lib/src/application/legacy/klp_environment_scope.dart:6`、`lib/src/application/legacy/klp_environment_scope.dart:36` |
| 平台來源與分支在哪？ | KlpPlatformInfo.current／KlpAdaptive.build — `lib/src/application/legacy/klp_platform_info.dart:11`、`lib/src/application/legacy/klp_adaptive.dart:27` |
| 路由、Material 與主題如何組裝？ | _KlpAppState.build — `lib/src/application/legacy/klp_app.dart:243` |

重要關係：

- `_KlpAppState.build` → `KlpEnvironmentScope` → `KlpAppScope` → MaterialApp：平台環境與 App 控制分開注入；`buildKlpTheme` 建立目前明暗的視覺值（`lib/src/application/legacy/klp_app.dart:284`、`lib/src/application/legacy/klp_app.dart:295`）。
- `context.klpPlatform` → `KlpEnvironmentScope.of`：訂閱最近環境，缺席時拋錯；尺寸、safe area、縮放與語系仍讀當前子樹的 MediaQuery／Localizations，不在 scope 複製（`lib/src/application/legacy/klp_environment_scope.dart:16`、`lib/src/application/legacy/klp_environment_scope.dart:36`）。
- `KlpAdaptive.build` → 環境平台 → windows／android／other builder：未提供 other 時回退 windows；分支內用 LayoutBuilder 處理局部尺寸。舊 `KlpAppScope.platformOf` 僅保留相容回退（`lib/src/application/legacy/klp_adaptive.dart:27`、`lib/src/application/legacy/klp_app.dart:403`）。

閱讀時區分組裝呼叫與 import 依賴；import 箭頭不表示執行先後。
