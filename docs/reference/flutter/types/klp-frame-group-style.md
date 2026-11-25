# KlpFrameGroupStyle

Flutter · Stable · 資料與型別

## 主要職責

Frame 內容群組的封閉樣式；不接受原始色彩、距離或 Flutter padding。

## 公開入口

- `package:kallopis/kallopis_foundation.dart`

## 速成使用

前置：[平台接入](../quickstart.md)。以下為接入片段；必要資料由產品提供。

```dart
import 'package:kallopis/kallopis_foundation.dart';

// 由產品提供必要資料；可選參數沿用下表預設。
KlpFrameGroupStyle createExample() => KlpFrameGroupStyle();
```

<!-- reference-api:start -->

## 公開簽名

```dart
final class KlpFrameGroupStyle
```

## 建構子 KlpFrameGroupStyle



```dart
const KlpFrameGroupStyle({
	KlpFrameGroupPadding padding = KlpFrameGroupPadding.standard,
	KlpFrameGroupDivider divider = KlpFrameGroupDivider.invisible,
	KlpFrameGroupContentSpacing contentSpacing = KlpFrameGroupContentSpacing.none,
})
```

| 參數／成員 | 型別 | 必填 | 預設值 | 說明 |
| --- | --- | --- | --- | --- |
| `padding` | `KlpFrameGroupPadding` | 否 | KlpFrameGroupPadding.standard | 依公開型別提供此輸入。 |
| `divider` | `KlpFrameGroupDivider` | 否 | KlpFrameGroupDivider.invisible | 依公開型別提供此輸入。 |
| `contentSpacing` | `KlpFrameGroupContentSpacing` | 否 | KlpFrameGroupContentSpacing.none | 依公開型別提供此輸入。 |


## 成員與方法

### copyWith

```dart
KlpFrameGroupStyle copyWith({
	KlpFrameGroupPadding? padding,
	KlpFrameGroupDivider? divider,
	KlpFrameGroupContentSpacing? contentSpacing,
})
```



| 參數／成員 | 型別 | 必填 | 預設值 | 說明 |
| --- | --- | --- | --- | --- |
| `padding` | `KlpFrameGroupPadding?` | 否 | null | 依公開型別提供此輸入。 |
| `divider` | `KlpFrameGroupDivider?` | 否 | null | 依公開型別提供此輸入。 |
| `contentSpacing` | `KlpFrameGroupContentSpacing?` | 否 | null | 依公開型別提供此輸入。 |


### defaultHorizontal

```dart
static const KlpFrameGroupStyle defaultHorizontal
```



### noHorizontalPadding

```dart
static const KlpFrameGroupStyle noHorizontalPadding
```



<!-- reference-api:end -->

## 使用限制與關聯

- 框架繼承成員：[Object](https://api.dart.dev/dart-core/Object-class.html)。
- [KlpFrameGroupContentSpacing](klp-frame-group-content-spacing.md)
- [KlpFrameGroupDivider](klp-frame-group-divider.md)
- [KlpFrameGroupPadding](klp-frame-group-padding.md)
- [語意與 token 規範](../../../design-tokens/KALLOPIS-DESIGN-MAP.md)。
- [宣告來源](../../../../flutter/lib/src/features/workspace/layout/klp_frame_groups.dart)；來源位置不作為 consumer import。
- 來源識別：`package:kallopis/src/features/workspace/layout/klp_frame_groups.dart`。
