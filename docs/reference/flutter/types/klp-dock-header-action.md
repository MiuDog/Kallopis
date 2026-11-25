# KlpDockHeaderAction

Flutter · Stable · 資料與型別

## 主要職責

Dock Header 右側的產品動作描述。

## 公開入口

- `package:kallopis/kallopis_foundation.dart`

## 速成使用

前置：[平台接入](../quickstart.md)。以下為接入片段；必要資料由產品提供。

```dart
import 'package:kallopis/kallopis_foundation.dart';

// 由產品提供必要資料；可選參數沿用下表預設。
KlpDockHeaderAction createExample(KlpIconData icon, String label, void Function() onPressed) => KlpDockHeaderAction(icon: icon, label: label, onPressed: onPressed);
```

<!-- reference-api:start -->

## 公開簽名

```dart
class KlpDockHeaderAction
```

## 建構子 KlpDockHeaderAction



```dart
const KlpDockHeaderAction({
	required KlpIconData icon,
	required String label,
	required VoidCallback onPressed,
	bool enabled = true,
})
```

| 參數／成員 | 型別 | 必填 | 預設值 | 說明 |
| --- | --- | --- | --- | --- |
| `icon` | `KlpIconData` | 是 | — | 操作或內容圖示。 |
| `label` | `String` | 是 | — | 顯示標籤。 |
| `onPressed` | `void Function()` | 是 | — | 啟動時通知產品；nullable 回呼的停用規則依元件契約。 |
| `enabled` | `bool` | 否 | true | 依公開型別提供此輸入。 |


<!-- reference-api:end -->

## 使用限制與關聯

- 框架繼承成員：[Object](https://api.dart.dev/dart-core/Object-class.html)。
- [KlpIconData](klp-icon-data.md)
- [語意與 token 規範](../../../design-tokens/KALLOPIS-DESIGN-MAP.md)。
- [宣告來源](../../../../flutter/lib/src/features/workspace/shell/docking/klp_dock_panel.dart)；來源位置不作為 consumer import。
- 來源識別：`package:kallopis/src/features/workspace/shell/docking/klp_dock_panel.dart`。
