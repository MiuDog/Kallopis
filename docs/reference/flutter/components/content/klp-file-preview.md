# KlpFilePreview

Flutter · Stable · 內容元件

## 主要職責

檔案預覽卡片，呈現檔名、中繼資料、預覽內容與外部操作。

## 公開入口

- `package:kallopis/kallopis_foundation.dart`

## 速成使用

前置：[平台接入](../../quickstart.md)。以下為接入片段；必要資料由產品提供。

```dart
import 'package:kallopis/kallopis_foundation.dart';

// 由產品提供必要資料；可選參數沿用下表預設。
KlpFilePreview createExample(String name, String metadata) => KlpFilePreview(name: name, metadata: metadata);
```

<!-- reference-api:start -->

## 公開簽名

```dart
class KlpFilePreview extends StatelessWidget
```

## 建構子 KlpFilePreview



```dart
const KlpFilePreview({
	Key? key,
	required String name,
	required String metadata,
	KlpIconData icon = KlpIcons.box,
	Widget? preview,
	VoidCallback? onPressed,
	KlpFilePreviewState state = KlpFilePreviewState.ready,
	KlpFilePreviewSize size = KlpFilePreviewSize.standard,
	String? textContent,
	VoidCallback? onOpenExternal,
	VoidCallback? onDownload,
})
```

| 參數／成員 | 型別 | 必填 | 預設值 | 說明 |
| --- | --- | --- | --- | --- |
| `key` | `Key?` | 否 | null | 框架識別鍵。 |
| `name` | `String` | 是 | — | 依公開型別提供此輸入。 |
| `metadata` | `String` | 是 | — | 依公開型別提供此輸入。 |
| `icon` | `KlpIconData` | 否 | KlpIcons.box | 操作或內容圖示。 |
| `preview` | `Widget?` | 否 | null | 依公開型別提供此輸入。 |
| `onPressed` | `void Function()?` | 否 | null | 啟動時通知產品；nullable 回呼的停用規則依元件契約。 |
| `state` | `KlpFilePreviewState` | 否 | KlpFilePreviewState.ready | 依公開型別提供此輸入。 |
| `size` | `KlpFilePreviewSize` | 否 | KlpFilePreviewSize.standard | 尺寸選擇。 |
| `textContent` | `String?` | 否 | null | 依公開型別提供此輸入。 |
| `onOpenExternal` | `void Function()?` | 否 | null | 依公開型別提供此輸入。 |
| `onDownload` | `void Function()?` | 否 | null | 依公開型別提供此輸入。 |


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
- [KlpFilePreviewSize](../../types/klp-file-preview-size.md)
- [KlpFilePreviewState](../../types/klp-file-preview-state.md)
- [KlpIconData](../../types/klp-icon-data.md)
- [KlpIcons](../../types/klp-icons.md)
- [語意與 token 規範](../../../../design-tokens/KALLOPIS-DESIGN-MAP.md)。
- [宣告來源](../../../../../flutter/lib/src/features/collections/advanced/klp_advanced_data.dart)；來源位置不作為 consumer import。
- 來源識別：`package:kallopis/src/features/collections/advanced/klp_advanced_data.dart`。
