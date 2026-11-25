# KlpDecorativePalette

Flutter · Stable · 資料與型別

## 主要職責

裝飾用顏色：**不屬於設計語言**，因此不會隨主題改變。

這些顏色出現在「畫一張示意圖」的場合——主題預覽磚要模擬桌布與視窗紅綠燈，那是插圖，
不是介面。它們刻意與 `KlpPalette` 分開：混在一起會讓人誤以為可以拿來上色元件，
而元件用了它們就會在換主題時原地不動。

## 公開入口

- `package:kallopis/kallopis_foundation.dart`

## 速成使用

前置：[平台接入](../quickstart.md)。以下為接入片段；必要資料由產品提供。

```dart
import 'package:kallopis/kallopis_foundation.dart';

// 由產品提供必要資料；可選參數沿用下表預設。
final value = KlpDecorativePalette.previewWallpaper;
```

<!-- reference-api:start -->

## 公開簽名

```dart
abstract final class KlpDecorativePalette
```

## 建構子 KlpDecorativePalette



```dart
KlpDecorativePalette()
```



## 成員與方法

### previewWallpaper

```dart
static const List<Color> previewWallpaper
```

主題預覽磚模擬的桌布漸層。

### previewWallpaperStops

```dart
static const List<double> previewWallpaperStops
```



### windowTrafficLights

```dart
static const List<Color> windowTrafficLights
```

視窗控制鈕的紅、黃、綠。這是對桌面平台既有慣例的複述，不是本設計系統的色彩選擇。

<!-- reference-api:end -->

## 使用限制與關聯

- 框架繼承成員：[Object](https://api.dart.dev/dart-core/Object-class.html)。

- [語意與 token 規範](../../../design-tokens/KALLOPIS-DESIGN-MAP.md)。
- [宣告來源](../../../../flutter/lib/src/foundation/klp_palette.dart)；來源位置不作為 consumer import。
- 來源識別：`package:kallopis/src/foundation/klp_palette.dart`。
