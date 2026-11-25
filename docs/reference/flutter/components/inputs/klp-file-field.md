# KlpFileField

Flutter · Stable · 輸入元件

## 主要職責

簡易的檔案選擇欄位：一排已選檔案的預覽卡片，加一顆選擇檔案按鈕。

不處理實際的檔案選取或上傳邏輯——[onChoose] 只是回報「使用者按了選擇」，
開檔案對話框、讀取內容、上傳進度都由呼叫端接手；需要顯示上傳進度時請改用
[KlpFileDropzoneField]。

## 公開入口

- `package:kallopis/kallopis_foundation.dart`

## 速成使用

前置：[平台接入](../../quickstart.md)。以下為接入片段；必要資料由產品提供。

```dart
import 'package:kallopis/kallopis_foundation.dart';

// 由產品提供必要資料；可選參數沿用下表預設。
KlpFileField createExample(String label, List<KlpFileValue> files, String chooseLabel) => KlpFileField(label: label, files: files, chooseLabel: chooseLabel);
```

<!-- reference-api:start -->

## 公開簽名

```dart
class KlpFileField extends StatelessWidget
```

## 建構子 KlpFileField



```dart
const KlpFileField({
	Key? key,
	required String label,
	required List<KlpFileValue> files,
	required String chooseLabel,
	VoidCallback? onChoose,
	ValueChanged<String>? onRemove,
})
```

| 參數／成員 | 型別 | 必填 | 預設值 | 說明 |
| --- | --- | --- | --- | --- |
| `key` | `Key?` | 否 | null | 框架識別鍵。 |
| `label` | `String` | 是 | — | 顯示標籤。 |
| `files` | `List<KlpFileValue>` | 是 | — | 依公開型別提供此輸入。 |
| `chooseLabel` | `String` | 是 | — | 依公開型別提供此輸入。 |
| `onChoose` | `void Function()?` | 否 | null | 依公開型別提供此輸入。 |
| `onRemove` | `void Function(String)?` | 否 | null | 依公開型別提供此輸入。 |


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
- [KlpFileValue](../../types/klp-file-value.md)
- [語意與 token 規範](../../../../design-tokens/KALLOPIS-DESIGN-MAP.md)。
- [宣告來源](../../../../../flutter/lib/src/features/forms/structured/klp_file_field.dart)；來源位置不作為 consumer import。
- 來源識別：`package:kallopis/src/features/forms/structured/klp_file_field.dart`。
