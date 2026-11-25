# KlpSidebarIdentityHeader

Flutter · Stable · 內容元件

## 主要職責

Primary Sidebar 頂部的 workspace identity。

呼叫端提供圖示、名稱與選填尾端內容；Kallopis 統一負責圖示底面、文字層級、
間距與截斷行為。

## 公開入口

- `package:kallopis/kallopis_foundation.dart`

## 速成使用

前置：[平台接入](../../quickstart.md)。以下為接入片段；必要資料由產品提供。

```dart
import 'package:kallopis/kallopis_foundation.dart';

// 由產品提供必要資料；可選參數沿用下表預設。
KlpSidebarIdentityHeader createExample(KlpIconData icon, String title) => KlpSidebarIdentityHeader(icon: icon, title: title);
```

<!-- reference-api:start -->

## 公開簽名

```dart
class KlpSidebarIdentityHeader extends StatelessWidget
```

## 建構子 KlpSidebarIdentityHeader



```dart
const KlpSidebarIdentityHeader({
	Key? key,
	required KlpIconData icon,
	required String title,
	Widget? trailing,
	String? avatarLabel,
	String? avatarSemanticLabel,
	ImageProvider<Object>? avatarImage,
})
```

| 參數／成員 | 型別 | 必填 | 預設值 | 說明 |
| --- | --- | --- | --- | --- |
| `key` | `Key?` | 否 | null | 框架識別鍵。 |
| `icon` | `KlpIconData` | 是 | — | 操作或內容圖示。 |
| `title` | `String` | 是 | — | 依公開型別提供此輸入。 |
| `trailing` | `Widget?` | 否 | null | 後方內容。 |
| `avatarLabel` | `String?` | 否 | null | 尾端識別標記；尺寸由 Primary Sidebar 的預設密度決定。 |
| `avatarSemanticLabel` | `String?` | 否 | null | 依公開型別提供此輸入。 |
| `avatarImage` | `ImageProvider<Object>?` | 否 | null | 依公開型別提供此輸入。 |


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
- [KlpIconData](../../types/klp-icon-data.md)
- [語意與 token 規範](../../../../design-tokens/KALLOPIS-DESIGN-MAP.md)。
- [宣告來源](../../../../../flutter/lib/src/features/navigation/widgets/sidebar/klp_sidebar_identity_header.dart)；來源位置不作為 consumer import。
- 來源識別：`package:kallopis/src/features/navigation/widgets/sidebar/klp_sidebar_identity_header.dart`。
