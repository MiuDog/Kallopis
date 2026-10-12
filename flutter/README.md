# Kallopis Flutter

Flutter 套件名稱與公開 Klp API 保持不變；套件根為本目錄。Consumer 指向 `D:/Projects/Kallopis/flutter`，並讀 [Flutter 產品使用指南](../docs/ai/product-usage.md)。共通視覺由 [正式規範](../docs/design-tokens/KALLOPIS-DESIGN-MAP.md) 擁有。

```sh
flutter pub get
flutter analyze --fatal-infos
flutter test
dart run tool/inventory.dart --check
```

範例位於 `example/`。Flutter 專用生成與驗證工具位於 `tool/`；共通 docs 網站工具仍在根 `tool/reference_site/`。目前既有測試失敗見 [整合驗證](../docs/architecture/multi-framework-verification.md)。

## 可替換的共通風格

從 `kallopis_theme.dart` 使用 `KlpStylePack`；`parse` 接受完整共通 JSON 字串或 object，`defaults()` 使用套件內生成的預設資料。所有模式、型別與尺寸限制在套用前完整驗證，失敗不改變原 pack。`klpStyleParameters` 公開 350 項參數的型別、單位、範圍及用途。

```dart
final pack = KlpStylePack.parse(styleFileContent);
final theme = buildKlpThemeVariant(
	KlpThemeVariant.light,
	stylePack: pack,
);
```

使用 `Theme(data: theme, child: ...)` 注入既有公開元件；不同 Theme 子樹可持有不同 pack。`applyOverrides` 僅接受既有 primitive 與 semantic ID，可覆寫部分模式；`resolve` 和 `data` 回傳深度不可變資料。`stylePack` 與既有 `style` 互斥，顯式 `accent` 保持覆寫權限。

風格檔擁有透明模式的完整色彩，`transparencyEnabled` 不會再對 pack 加透明度；產品另外設定宿主透明能力。字型保持 package ownership，不會自動下載外部字型。原生動畫時間需能無損表示成微秒，不能表示的值會以完整 semantic ID 拒絕；字重支援本專案 SDK 的 1–1000。配方原文目前保留，配方展開與更完整布局保護屬於後續階段。

更新共通資料後，在 repository 根執行 `node flutter/tool/generate_style_pack.mjs`；提交前用 `--check` 確认四模式與來源雜湊。套件 consumer 不依賴 repository 的 `styles/` 路徑。
