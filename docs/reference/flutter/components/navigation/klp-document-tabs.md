# KlpDocumentTabs

Flutter · Stable · 導覽元件

## 主要職責

具修改狀態、釘選與關閉動作的受控文件分頁列。

本元件只回報操作意圖；選取、關閉與釘選結果必須由 consumer 更新 [tabs] 或
[selectedId] 後再傳回。

## 公開入口

- `package:kallopis/kallopis_foundation.dart`

## 速成使用

前置：[平台接入](../../quickstart.md)。以下為接入片段；必要資料由產品提供。

```dart
import 'package:kallopis/kallopis_foundation.dart';

// 由產品提供必要資料；可選參數沿用下表預設。
KlpDocumentTabs createExample(List<KlpDocumentTab> tabs) => KlpDocumentTabs(tabs: tabs);
```

<!-- reference-api:start -->

## 公開簽名

```dart
final class KlpDocumentTabs extends StatelessWidget
```

## 建構子 KlpDocumentTabs



```dart
KlpDocumentTabs({
	Key? key,
	required List<KlpDocumentTab> tabs,
	String? selectedId,
	ValueChanged<String>? onSelected,
	ValueChanged<String>? onClose,
	void Function(String, bool)? onPinnedChanged,
})
```

| 參數／成員 | 型別 | 必填 | 預設值 | 說明 |
| --- | --- | --- | --- | --- |
| `key` | `Key?` | 否 | null | 框架識別鍵。 |
| `tabs` | `List<KlpDocumentTab>` | 是 | — | 依公開型別提供此輸入。 |
| `selectedId` | `String?` | 否 | null | 產品持有的選取識別。 |
| `onSelected` | `void Function(String)?` | 否 | null | 將選取意圖交回產品。 |
| `onClose` | `void Function(String)?` | 否 | null | 依公開型別提供此輸入。 |
| `onPinnedChanged` | `void Function(String, bool)?` | 否 | null | 依公開型別提供此輸入。 |


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
- [KlpDocumentTab](../../types/klp-document-tab.md)
- [語意與 token 規範](../../../../design-tokens/KALLOPIS-DESIGN-MAP.md)。
- [宣告來源](../../../../../flutter/lib/src/features/navigation/widgets/tabs/klp_document_tabs.dart)；來源位置不作為 consumer import。
- 來源識別：`package:kallopis/src/features/navigation/widgets/tabs/klp_document_tabs.dart`。
