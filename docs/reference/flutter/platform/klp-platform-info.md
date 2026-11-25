# KlpPlatformInfo

Flutter · Stable · 平台整合

## 主要職責

由 Kallopis 環境 scope 注入子樹的執行平台與自適應環境資訊。

## 公開入口

- `package:kallopis/kallopis_foundation.dart`

## 速成使用

前置：[平台接入](../quickstart.md)。以下為接入片段；必要資料由產品提供。

```dart
import 'package:kallopis/kallopis_foundation.dart';

// 由產品提供必要資料；可選參數沿用下表預設。
KlpPlatformInfo createExample(KlpAppPlatform platform) => KlpPlatformInfo(platform: platform);
```

<!-- reference-api:start -->

## 公開簽名

```dart
class KlpPlatformInfo
```

## 建構子 KlpPlatformInfo



```dart
const KlpPlatformInfo({
	required KlpAppPlatform platform,
	KlpDeviceClass deviceClass = KlpDeviceClass.desktop,
	KlpOrientation orientation = KlpOrientation.landscape,
	KlpDisplayMode displayMode = KlpDisplayMode.browser,
	String adaptiveMode = '',
})
```

| 參數／成員 | 型別 | 必填 | 預設值 | 說明 |
| --- | --- | --- | --- | --- |
| `platform` | `KlpAppPlatform` | 是 | — | 依公開型別提供此輸入。 |
| `deviceClass` | `KlpDeviceClass` | 否 | KlpDeviceClass.desktop | 依公開型別提供此輸入。 |
| `orientation` | `KlpOrientation` | 否 | KlpOrientation.landscape | 依公開型別提供此輸入。 |
| `displayMode` | `KlpDisplayMode` | 否 | KlpDisplayMode.browser | 依公開型別提供此輸入。 |
| `adaptiveMode` | `String` | 否 | '' | 依公開型別提供此輸入。 |


## 建構子 KlpPlatformInfo.current

初始環境解析：支援 Web 尺寸、模擬參數與原生平台。

```dart
KlpPlatformInfo.current({Size? viewportSize})
```

| 參數／成員 | 型別 | 必填 | 預設值 | 說明 |
| --- | --- | --- | --- | --- |
| `viewportSize` | `Size?` | 否 | null | 依公開型別提供此輸入。 |


## 成員與方法

### effectiveAdaptiveMode

```dart
String get effectiveAdaptiveMode
```



### isAndroid

```dart
bool get isAndroid
```



### isDesktop

```dart
bool get isDesktop
```



### isMobile

```dart
bool get isMobile
```



### isTablet

```dart
bool get isTablet
```



### isWindows

```dart
bool get isWindows
```



<!-- reference-api:end -->

## 使用限制與關聯

- 框架繼承成員：[Object](https://api.dart.dev/dart-core/Object-class.html)。
- [KlpAppPlatform](klp-app-platform.md)
- [語意與 token 規範](../../../design-tokens/KALLOPIS-DESIGN-MAP.md)。
- [宣告來源](../../../../flutter/lib/src/foundation/platform/klp_platform_info.dart)；來源位置不作為 consumer import。
- 來源識別：`package:kallopis/src/foundation/platform/klp_platform_info.dart`。
