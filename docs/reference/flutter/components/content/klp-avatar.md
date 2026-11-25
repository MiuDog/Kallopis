# KlpAvatar

Flutter · Stable · 內容元件

## 主要職責

以文字或圖片呈現無產品語意的身份識別圖像。

## 公開入口

- `package:kallopis/kallopis_foundation.dart`

## 速成使用

前置：[平台接入](../../quickstart.md)。以下為接入片段；必要資料由產品提供。

```dart
import 'package:kallopis/kallopis_foundation.dart';

// 由產品提供必要資料；可選參數沿用下表預設。
KlpAvatar createExample(String label) => KlpAvatar(label: label);
```

<!-- reference-api:start -->

## 公開簽名

```dart
class KlpAvatar extends StatelessWidget
```

## 建構子 KlpAvatar



```dart
const KlpAvatar({
	Key? key,
	required String label,
	ImageProvider<Object>? image,
	KlpAvatarSize size = KlpAvatarSize.standard,
	String? semanticLabel,
	KlpAvatarTone tone = KlpAvatarTone.neutral,
})
```

| 參數／成員 | 型別 | 必填 | 預設值 | 說明 |
| --- | --- | --- | --- | --- |
| `key` | `Key?` | 否 | null | 框架識別鍵。 |
| `label` | `String` | 是 | — | 顯示標籤。 |
| `image` | `ImageProvider<Object>?` | 否 | null | 依公開型別提供此輸入。 |
| `size` | `KlpAvatarSize` | 否 | KlpAvatarSize.standard | 尺寸選擇。 |
| `semanticLabel` | `String?` | 否 | null | 依公開型別提供此輸入。 |
| `tone` | `KlpAvatarTone` | 否 | KlpAvatarTone.neutral | 選擇語意呈現。 |


## 成員與方法

### build

```dart
Widget build(BuildContext context)
```

由 Flutter 依目前 context 建構畫面。

| 參數／成員 | 型別 | 必填 | 預設值 | 說明 |
| --- | --- | --- | --- | --- |
| `context` | `BuildContext` | 是 | — | 依公開型別提供此輸入。 |


<!-- reference-api:end -->

## 使用限制與關聯

- 框架繼承成員：[StatelessWidget](https://api.flutter.dev/flutter/widgets/StatelessWidget-class.html)。
- [KlpAvatarSize](../../types/klp-avatar-size.md)
- [KlpAvatarTone](../../types/klp-avatar-tone.md)
- [語意與 token 規範](../../../../design-tokens/KALLOPIS-DESIGN-MAP.md)。
- [宣告來源](../../../../../flutter/lib/src/features/collections/avatar/klp_avatar.dart)；來源位置不作為 consumer import。
- 來源識別：`package:kallopis/src/features/collections/avatar/klp_avatar.dart`。
