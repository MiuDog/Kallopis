# KlpPageChrome

Flutter · Experimental · 內容元件

## 主要職責

頁面頂部的識別區塊：麵包屑導覽、選填的狀態文字與協作者標記，以及頁面
大標題。

[breadcrumb] 以 `/` 串接顯示，不提供逐段可點擊的導覽——需要可點擊麵包屑
請改用 [KlpBreadcrumb]。[status] 與 [collaborator] 都是單一文字，若要顯示
多位協作者或多筆狀態，需自行組合字串或改用其他元件。

## 公開入口

- `package:kallopis/kallopis_experimental.dart`

## 速成使用

前置：[平台接入](../../quickstart.md)。以下為接入片段；必要資料由產品提供。

```dart
import 'package:kallopis/kallopis_experimental.dart';

// 由產品提供必要資料；可選參數沿用下表預設。
KlpPageChrome createExample(List<String> breadcrumb, String title) => KlpPageChrome(breadcrumb: breadcrumb, title: title);
```

<!-- reference-api:start -->

## 公開簽名

```dart
class KlpPageChrome extends StatelessWidget
```

## 建構子 KlpPageChrome



```dart
const KlpPageChrome({
	Key? key,
	required List<String> breadcrumb,
	required String title,
	String? status,
	String? collaborator,
})
```

| 參數／成員 | 型別 | 必填 | 預設值 | 說明 |
| --- | --- | --- | --- | --- |
| `key` | `Key?` | 否 | null | 框架識別鍵。 |
| `breadcrumb` | `List<String>` | 是 | — | 依公開型別提供此輸入。 |
| `title` | `String` | 是 | — | 依公開型別提供此輸入。 |
| `status` | `String?` | 否 | null | 依公開型別提供此輸入。 |
| `collaborator` | `String?` | 否 | null | 依公開型別提供此輸入。 |


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
- [宣告來源](../../../../../flutter/lib/src/features/workspace/page_chrome/klp_page_chrome.dart)；來源位置不作為 consumer import。
- 來源識別：`package:kallopis/src/features/workspace/page_chrome/klp_page_chrome.dart`。
