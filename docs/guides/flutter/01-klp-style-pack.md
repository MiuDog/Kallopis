# 匯入共通風格檔

`kallopis_theme.dart` 公開 `KlpStylePack` 及 `klpStyleParameters`。風格檔內容由產品讀取；`parse` 接受 JSON 字串或 object，檢查所有 canonical ID、四模式、引用、350 項型別及 catalog 尺寸限制。非法值會拒絕整包，不改目前 Theme。

```dart
final pack = KlpStylePack.parse(styleFileContent);
final theme = buildKlpThemeVariant(
	KlpThemeVariant.light,
	stylePack: pack,
);
```

把 `theme` 提供給 MaterialApp 或局部 `Theme`，公開元件仍讀 `context.klp`。不同 Theme 子樹可用不同 pack；`KlpStylePack.defaults()` 還原預設，`applyOverrides` 對既有 primitive／semantic ID 原子覆寫並回新 pack；`data`／`resolve`／參數 metadata 深度不可變。

`stylePack` 與既有 `style` 不可同時提供，顯式 `accent` 仍可覆寫。pack 擁有透明模式完整色彩，不再套用舊 `transparencyEnabled` 色彩轉換；產品擁有視窗透明設定。字型保持套件前綴，不自動下载外部資產；原生 duration 必須能無損轉微秒，否則以 semantic ID 診斷。元件可用能力以當前 Reference 清冊為準；風格資料驗證不等於畫面視覺接受。

## API 查表

- [KlpStylePack](../../reference/flutter/styling/klp-style-pack.md)
- [KlpThemeVariant](../../reference/flutter/styling/klp-theme-variant.md)
- [buildKlpThemeVariant](../../reference/flutter/styling/build-klp-theme-variant.md)
