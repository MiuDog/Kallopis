# KlpPublicationProgressOverlay

Flutter · Stable · 狀態回饋

## 主要職責

長時間操作期間保持預覽內容穩定，並在其上呈現呼叫端提供的具名階段。

## 公開入口

- `package:kallopis/kallopis_foundation.dart`

## 速成使用

前置：[平台接入](../../quickstart.md)。以下為接入片段；必要資料由產品提供。

```dart
import 'package:flutter/material.dart';
import 'package:kallopis/kallopis_foundation.dart';

// 由產品提供必要資料；可選參數沿用下表預設。
KlpPublicationProgressOverlay createExample(Widget child, bool visible, KlpWorkflowProgress progress) => KlpPublicationProgressOverlay(visible: visible, progress: progress, child: child);
```

<!-- reference-api:start -->

## 公開簽名

```dart
class KlpPublicationProgressOverlay extends StatelessWidget
```

## 建構子 KlpPublicationProgressOverlay



```dart
const KlpPublicationProgressOverlay({
	Key? key,
	required Widget child,
	required bool visible,
	required KlpWorkflowProgress progress,
})
```

| 參數／成員 | 型別 | 必填 | 預設值 | 說明 |
| --- | --- | --- | --- | --- |
| `key` | `Key?` | 否 | null | 框架識別鍵。 |
| `child` | `Widget` | 是 | — | 產品提供的內容。 |
| `visible` | `bool` | 是 | — | 依公開型別提供此輸入。 |
| `progress` | `KlpWorkflowProgress` | 是 | — | 依公開型別提供此輸入。 |


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
- [KlpWorkflowProgress](klp-workflow-progress.md)
- [語意與 token 規範](../../../../design-tokens/KALLOPIS-DESIGN-MAP.md)。
- [宣告來源](../../../../../flutter/lib/src/features/navigation/widgets/preview_tree/klp_publication_progress_overlay.dart)；來源位置不作為 consumer import。
- 來源識別：`package:kallopis/src/features/navigation/widgets/preview_tree/klp_publication_progress_overlay.dart`。
