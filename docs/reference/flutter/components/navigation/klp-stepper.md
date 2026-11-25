# KlpStepper

Flutter · Stable · 導覽元件

## 主要職責

步驟流程指示。依 [currentIndex] 把 [steps] 分成已完成／進行中／未開始三態。

純顯示元件——不持有互動狀態，也不處理點擊；切換到下一步是呼叫端更新
[currentIndex] 後重建的結果。[direction] 決定排列方向。

## 公開入口

- `package:kallopis/kallopis_foundation.dart`

## 速成使用

前置：[平台接入](../../quickstart.md)。以下為接入片段；必要資料由產品提供。

```dart
import 'package:kallopis/kallopis_foundation.dart';

// 由產品提供必要資料；可選參數沿用下表預設。
KlpStepper createExample(List<KlpStepData> steps, int currentIndex) => KlpStepper(steps: steps, currentIndex: currentIndex);
```

<!-- reference-api:start -->

## 公開簽名

```dart
class KlpStepper extends StatelessWidget
```

## 建構子 KlpStepper



```dart
const KlpStepper({
	Key? key,
	required List<KlpStepData> steps,
	required int currentIndex,
	KlpStepperDirection direction = KlpStepperDirection.horizontal,
})
```

| 參數／成員 | 型別 | 必填 | 預設值 | 說明 |
| --- | --- | --- | --- | --- |
| `key` | `Key?` | 否 | null | 框架識別鍵。 |
| `steps` | `List<KlpStepData>` | 是 | — | 依公開型別提供此輸入。 |
| `currentIndex` | `int` | 是 | — | 依公開型別提供此輸入。 |
| `direction` | `KlpStepperDirection` | 否 | KlpStepperDirection.horizontal | 依公開型別提供此輸入。 |


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
- [KlpStepData](../../types/klp-step-data.md)
- [KlpStepperDirection](../../types/klp-stepper-direction.md)
- [語意與 token 規範](../../../../design-tokens/KALLOPIS-DESIGN-MAP.md)。
- [宣告來源](../../../../../flutter/lib/src/features/collections/stepper/klp_stepper.dart)；來源位置不作為 consumer import。
- 來源識別：`package:kallopis/src/features/collections/stepper/klp_stepper.dart`。
