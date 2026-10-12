# Kallopis Flutter

Flutter 套件名稱與公開 Klp API 保持不變；套件根為本目錄。Consumer 指向 `D:/Projects/Kallopis/flutter`，並讀 [Flutter 產品使用指南](../docs/ai/product-usage.md)。共通視覺由 [正式規範](../docs/design-tokens/KALLOPIS-DESIGN-MAP.md) 擁有。

```sh
flutter pub get
flutter analyze --fatal-infos
flutter test
dart run tool/inventory.dart --check
```

範例位於 `example/`。Flutter 專用生成與驗證工具位於 `tool/`；共通 docs 網站工具仍在根 `tool/reference_site/`。目前既有測試失敗見 [整合驗證](../docs/architecture/multi-framework-verification.md)。
