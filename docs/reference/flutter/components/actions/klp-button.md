# KlpButton

Flutter · Stable · 操作元件

## 主要職責

呈現文字操作按鈕，產品持有事件與選取狀態；語意、尺寸與互動外觀由目前 theme 解析。

## 公開入口

- `package:kallopis/kallopis_foundation.dart`

## 速成使用

前置：[平台接入](../../quickstart.md)。以下為接入片段；必要資料由產品提供。

```dart
import 'package:kallopis/kallopis_foundation.dart';

KlpButton(
	label: '儲存',
	onPressed: () {
		// 接入產品的儲存流程。
	},
)
```

<!-- reference-api:start -->

## 公開簽名

```dart
class KlpButton extends StatefulWidget
```

## 建構子 KlpButton



```dart
const KlpButton({
	Key? key,
	required String label,
	required VoidCallback? onPressed,
	KlpButtonTone tone = KlpButtonTone.primary,
	KlpControlSize? size,
	Widget? leading,
	Widget? trailing,
	bool compact = false,
	bool selected = false,
	VoidCallback? onLongPress,
})
```

| 參數／成員 | 型別 | 必填 | 預設值 | 說明 |
| --- | --- | --- | --- | --- |
| `key` | `Key?` | 否 | null | 框架識別鍵。 |
| `label` | `String` | 是 | — | 顯示標籤。 |
| `onPressed` | `void Function()?` | 是 | — | 啟動時通知產品；nullable 回呼的停用規則依元件契約。 |
| `tone` | `KlpButtonTone` | 否 | KlpButtonTone.primary | 選擇語意呈現。 |
| `size` | `KlpControlSize?` | 否 | null | 尺寸選擇。 |
| `leading` | `Widget?` | 否 | null | 前方內容。 |
| `trailing` | `Widget?` | 否 | null | 後方內容。 |
| `compact` | `bool` | 否 | false | 緊湊呈現選項。 |
| `selected` | `bool` | 否 | false | 由產品持有的選取狀態。 |
| `onLongPress` | `void Function()?` | 否 | null | 長按回呼。 |


## 成員與方法

### createState

```dart
State<KlpButton> createState()
```

由 Flutter 建立此元件的 State。

<!-- reference-api:end -->

## 使用限制與關聯

- `onPressed: null` 表示停用。
- `size` 優先於 `compact`；未指定 size 時，compact 使用 xs，否則使用 sm。
- `selected` 由產品更新；尺寸與顏色由目前 theme 解析，不固定為某組 px。
- [KlpIconButton](klp-icon-button.md)：圖示操作入口。
- 框架繼承成員：[StatefulWidget](https://api.flutter.dev/flutter/widgets/StatefulWidget-class.html)。
- [KlpButtonTone](../../types/klp-button-tone.md)
- [KlpControlSize](../../types/klp-control-size.md)
- [語意與 token 規範](../../../../design-tokens/KALLOPIS-DESIGN-MAP.md)。
- [宣告來源](../../../../../flutter/lib/src/features/actions/button/klp_button.dart)；來源位置不作為 consumer import。
- 來源識別：`package:kallopis/src/features/actions/button/klp_button.dart`。
