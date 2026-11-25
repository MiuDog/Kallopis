# KlpSaveStatusCard

Flutter · Experimental · 布局元件

## 主要職責

顯示最後儲存時間與一組相關狀態訊息的卡片，用於編輯器頁面告知使用者
目前的儲存／同步狀況。

[savedAt] 是已經格式化好的顯示文字（例如「2 分鐘前」），這個元件不處理
時間格式化或相對時間更新。

## 公開入口

- `package:kallopis/kallopis_experimental.dart`

## 速成使用

前置：[平台接入](../../quickstart.md)。以下為接入片段；必要資料由產品提供。

```dart
import 'package:kallopis/kallopis_experimental.dart';

// 由產品提供必要資料；可選參數沿用下表預設。
KlpSaveStatusCard createExample(String savedAt, List<KlpStatusMessageData> messages) => KlpSaveStatusCard(savedAt: savedAt, messages: messages);
```

<!-- reference-api:start -->

## 公開簽名

```dart
class KlpSaveStatusCard extends StatelessWidget
```

## 建構子 KlpSaveStatusCard



```dart
const KlpSaveStatusCard({
	Key? key,
	required String savedAt,
	required List<KlpStatusMessageData> messages,
})
```

| 參數／成員 | 型別 | 必填 | 預設值 | 說明 |
| --- | --- | --- | --- | --- |
| `key` | `Key?` | 否 | null | 框架識別鍵。 |
| `savedAt` | `String` | 是 | — | 依公開型別提供此輸入。 |
| `messages` | `List<KlpStatusMessageData>` | 是 | — | 依公開型別提供此輸入。 |


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
- [KlpStatusMessageData](../../types/klp-status-message-data.md)
- [語意與 token 規範](../../../../design-tokens/KALLOPIS-DESIGN-MAP.md)。
- [宣告來源](../../../../../flutter/lib/src/features/workspace/page_chrome/klp_page_chrome.dart)；來源位置不作為 consumer import。
- 來源識別：`package:kallopis/src/features/workspace/page_chrome/klp_page_chrome.dart`。
