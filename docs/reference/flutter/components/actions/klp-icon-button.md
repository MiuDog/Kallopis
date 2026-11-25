# KlpIconButton

Flutter · Stable · 操作元件

## 主要職責

只有圖示的按鈕；`label` 必填並作為無障礙標註。

## 公開入口

- `package:kallopis/kallopis_foundation.dart`

## 速成使用

前置：[平台接入](../../quickstart.md)。以下為接入片段；必要資料由產品提供。

```dart
import 'package:kallopis/kallopis_foundation.dart';

// 由產品提供必要資料；可選參數沿用下表預設。
KlpIconButton createExample(KlpIconData icon, String label, void Function()? onPressed) => KlpIconButton(icon: icon, label: label, onPressed: onPressed);
```

<!-- reference-api:start -->

## 公開簽名

```dart
class KlpIconButton extends StatefulWidget
```

## 建構子 KlpIconButton



```dart
const KlpIconButton({
	Key? key,
	required KlpIconData icon,
	required String label,
	required VoidCallback? onPressed,
	bool selected = false,
	int quarterTurns = 0,
	KlpIconButtonTone tone = KlpIconButtonTone.standalone,
	KlpIconButtonSize size = KlpIconButtonSize.standard,
})
```

| 參數／成員 | 型別 | 必填 | 預設值 | 說明 |
| --- | --- | --- | --- | --- |
| `key` | `Key?` | 否 | null | 框架識別鍵。 |
| `icon` | `KlpIconData` | 是 | — | 操作或內容圖示。 |
| `label` | `String` | 是 | — | 顯示標籤。 |
| `onPressed` | `void Function()?` | 是 | — | 啟動時通知產品；nullable 回呼的停用規則依元件契約。 |
| `selected` | `bool` | 否 | false | 由產品持有的選取狀態。 |
| `quarterTurns` | `int` | 否 | 0 | 依公開型別提供此輸入。 |
| `tone` | `KlpIconButtonTone` | 否 | KlpIconButtonTone.standalone | 選擇語意呈現。 |
| `size` | `KlpIconButtonSize` | 否 | KlpIconButtonSize.standard | 尺寸選擇。 |


## 成員與方法

### createState

```dart
State<KlpIconButton> createState()
```

由 Flutter 建立此元件的 State。

<!-- reference-api:end -->

## 使用限制與關聯

- 框架繼承成員：[StatefulWidget](https://api.flutter.dev/flutter/widgets/StatefulWidget-class.html)。
- [KlpIconButtonSize](../../types/klp-icon-button-size.md)
- [KlpIconButtonTone](../../types/klp-icon-button-tone.md)
- [KlpIconData](../../types/klp-icon-data.md)
- [語意與 token 規範](../../../../design-tokens/KALLOPIS-DESIGN-MAP.md)。
- [宣告來源](../../../../../flutter/lib/src/features/actions/button/klp_icon_button.dart)；來源位置不作為 consumer import。
- 來源識別：`package:kallopis/src/features/actions/button/klp_icon_button.dart`。
