# KlpWorkspaceCommandShortcut

Flutter · Stable · 資料與型別

## 主要職責

可選快捷鍵語意；元件不從顯示文字推測命令用途。

## 公開入口

- `package:kallopis/kallopis_foundation.dart`

## 速成使用

前置：[平台接入](../quickstart.md)。以下為接入片段；必要資料由產品提供。

```dart
import 'package:kallopis/kallopis_foundation.dart';

final value = KlpWorkspaceCommandShortcut.delete;
```

<!-- reference-api:start -->

## 公開簽名

```dart
enum KlpWorkspaceCommandShortcut
```

## 建構子 KlpWorkspaceCommandShortcut



```dart
const KlpWorkspaceCommandShortcut()
```



## 成員與方法

### delete

```dart
static const KlpWorkspaceCommandShortcut delete
```



### rename

```dart
static const KlpWorkspaceCommandShortcut rename
```



<!-- reference-api:end -->

## 使用限制與關聯

- 框架繼承成員：[Enum](https://api.dart.dev/dart-core/Enum-class.html)。

- [語意與 token 規範](../../../design-tokens/KALLOPIS-DESIGN-MAP.md)。
- [宣告來源](../../../../flutter/lib/src/features/workspace/anchored_popup/klp_anchored_popup.dart)；來源位置不作為 consumer import。
- 來源識別：`package:kallopis/src/features/workspace/anchored_popup/klp_anchored_popup.dart`。
