# KlpEnvironmentScope

Flutter · Stable · 內容元件

## 主要職責

注入執行平台；視窗尺寸、語系與互動狀態仍由各自的來源提供。

## 公開入口

- `package:kallopis/kallopis_foundation.dart`

## 速成使用

前置：[平台接入](../../quickstart.md)。以下為接入片段；必要資料由產品提供。

```dart
import 'package:flutter/material.dart';
import 'package:kallopis/kallopis_foundation.dart';

// 由產品提供必要資料；可選參數沿用下表預設。
KlpEnvironmentScope createExample(KlpPlatformInfo platform, Widget child) => KlpEnvironmentScope(platform: platform, child: child);
```

<!-- reference-api:start -->

## 公開簽名

```dart
class KlpEnvironmentScope extends InheritedWidget
```

## 建構子 KlpEnvironmentScope



```dart
const KlpEnvironmentScope({
	Key? key,
	required KlpPlatformInfo platform,
	required Widget child,
})
```

| 參數／成員 | 型別 | 必填 | 預設值 | 說明 |
| --- | --- | --- | --- | --- |
| `key` | `Key?` | 否 | null | 框架識別鍵。 |
| `platform` | `KlpPlatformInfo` | 是 | — | 依公開型別提供此輸入。 |
| `child` | `Widget` | 是 | — | 產品提供的內容。 |


## 成員與方法

### maybeOf

```dart
static KlpPlatformInfo? maybeOf(BuildContext context)
```

訂閱最近的平台環境；未注入時回傳 null。

| 參數／成員 | 型別 | 必填 | 預設值 | 說明 |
| --- | --- | --- | --- | --- |
| `context` | `BuildContext` | 是 | — | 依公開型別提供此輸入。 |


### of

```dart
static KlpPlatformInfo of(BuildContext context)
```

訂閱最近的平台環境，缺少祖先時明確拋錯。

| 參數／成員 | 型別 | 必填 | 預設值 | 說明 |
| --- | --- | --- | --- | --- |
| `context` | `BuildContext` | 是 | — | 依公開型別提供此輸入。 |


### updateShouldNotify

```dart
bool updateShouldNotify(KlpEnvironmentScope oldWidget)
```



| 參數／成員 | 型別 | 必填 | 預設值 | 說明 |
| --- | --- | --- | --- | --- |
| `oldWidget` | `KlpEnvironmentScope` | 是 | — | 依公開型別提供此輸入。 |


<!-- reference-api:end -->

## 使用限制與關聯

- 框架繼承成員：[InheritedWidget](https://api.flutter.dev/flutter/widgets/InheritedWidget-class.html)。
- [KlpPlatformInfo](../../platform/klp-platform-info.md)
- [語意與 token 規範](../../../../design-tokens/KALLOPIS-DESIGN-MAP.md)。
- [宣告來源](../../../../../flutter/lib/src/foundation/platform/klp_environment_scope.dart)；來源位置不作為 consumer import。
- 來源識別：`package:kallopis/src/foundation/platform/klp_environment_scope.dart`。
