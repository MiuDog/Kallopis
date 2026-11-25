# KlpDocumentReferenceLink

Flutter · Experimental · 內容元件

## 主要職責

指向另一個 canonical artifact 的可及性連結。

## 公開入口

- `package:kallopis/kallopis_experimental.dart`

## 速成使用

前置：[平台接入](../../quickstart.md)。以下為接入片段；必要資料由產品提供。

```dart
import 'package:kallopis/kallopis_experimental.dart';

// 由產品提供必要資料；可選參數沿用下表預設。
KlpDocumentReferenceLink createExample(String label, void Function()? onPressed) => KlpDocumentReferenceLink(label: label, onPressed: onPressed);
```

<!-- reference-api:start -->

## 公開簽名

```dart
class KlpDocumentReferenceLink extends StatelessWidget
```

## 建構子 KlpDocumentReferenceLink



```dart
const KlpDocumentReferenceLink({
	Key? key,
	required String label,
	required VoidCallback? onPressed,
	String? detail,
})
```

| 參數／成員 | 型別 | 必填 | 預設值 | 說明 |
| --- | --- | --- | --- | --- |
| `key` | `Key?` | 否 | null | 框架識別鍵。 |
| `label` | `String` | 是 | — | 顯示標籤。 |
| `onPressed` | `void Function()?` | 是 | — | 啟動時通知產品；nullable 回呼的停用規則依元件契約。 |
| `detail` | `String?` | 否 | null | 依公開型別提供此輸入。 |


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

- [語意與 token 規範](../../../../design-tokens/KALLOPIS-DESIGN-MAP.md)。
- [宣告來源](../../../../../flutter/lib/src/features/workspace/artifact/klp_artifact_workspace.dart)；來源位置不作為 consumer import。
- 來源識別：`package:kallopis/src/features/workspace/artifact/klp_artifact_workspace.dart`。
