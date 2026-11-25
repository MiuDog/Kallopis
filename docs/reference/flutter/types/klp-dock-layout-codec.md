# KlpDockLayoutCodec

Flutter · Stable · 資料與型別

## 主要職責

版本化資料邊界，不執行 storage 或替換受控布局。

## 公開入口

- `package:kallopis/kallopis_foundation.dart`

## 速成使用

前置：[平台接入](../quickstart.md)。以下為接入片段；必要資料由產品提供。

```dart
import 'package:kallopis/kallopis_foundation.dart';

// 由產品提供必要資料；可選參數沿用下表預設。
void acceptValue(KlpDockLayoutCodec value) {
	// 產品接收此抽象契約；請使用公開子型別或靜態方法。
}
```

<!-- reference-api:start -->

## 公開簽名

```dart
abstract final class KlpDockLayoutCodec
```

## 建構子 KlpDockLayoutCodec



```dart
KlpDockLayoutCodec()
```



## 成員與方法

### encode

```dart
static String encode(KlpDockLayoutData layout)
```

驗證完整布局後輸出 schemaVersion 1，不依清冊刪除資料。

| 參數／成員 | 型別 | 必填 | 預設值 | 說明 |
| --- | --- | --- | --- | --- |
| `layout` | `KlpDockLayoutData` | 是 | — | 依公開型別提供此輸入。 |


### restore

```dart
static KlpDockRestoreResult restore(String source, {required List<KlpDockPanelPolicy> panels})
```

先完整驗證再比對清冊；任何非法資料以 FormatException 拒絕。

| 參數／成員 | 型別 | 必填 | 預設值 | 說明 |
| --- | --- | --- | --- | --- |
| `source` | `String` | 是 | — | 依公開型別提供此輸入。 |
| `panels` | `List<KlpDockPanelPolicy>` | 是 | — | 依公開型別提供此輸入。 |


<!-- reference-api:end -->

## 使用限制與關聯

- [Dock 布局保存與載入](../../../guides/flutter/09-klp-dock-layout-codec.md)：跨元件使用流程。
- 框架繼承成員：[Object](https://api.dart.dev/dart-core/Object-class.html)。
- [KlpDockLayoutData](klp-dock-layout-data.md)
- [KlpDockPanelPolicy](klp-dock-panel-policy.md)
- [KlpDockRestoreResult](klp-dock-restore-result.md)
- [語意與 token 規範](../../../design-tokens/KALLOPIS-DESIGN-MAP.md)。
- [宣告來源](../../../../flutter/lib/src/features/workspace/shell/docking/klp_dock_layout_codec.dart)；來源位置不作為 consumer import。
- 來源識別：`package:kallopis/src/features/workspace/shell/docking/klp_dock_layout_codec.dart`。
