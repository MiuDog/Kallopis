# 應用與組裝模板

這些模板是目前可驗證的宣告式 consumer 寫法。程式中的資料型別、callback 與自訂節點可以替換；不要加入 Widget、Context、視覺參數或另一種 app root。

## 1. 準備完整 primitive set

`KlpPrimitiveSet` 需要每一個固定種類的八個值。它只能整套替換，不能局部覆寫或加入新欄位。正式風格尚未定案，因此請從產品自己的完整資料來源建立它；可參考可執行的 [demo primitives](../../example/lib/klp_runtime_demo/demo_primitives.dart)。

```dart
final primitives = productPrimitives();
```

## 2. 建立 destination、router 與 screen

每個目的地保留參數與結果型別。route 的 `screen` 只取得型別化資料與受控 navigation action；它不取得 context 或 style。

```dart
final home = KlpDestination<Object?, Object?>('product.home');

final router = KlpRouter(
  id: 'product.router',
  initial: home.location(null),
  routes: [
    KlpRoute<Object?, Object?>(
      home,
      screen: (input) => KlpScreen(
        id: 'product.home.screen',
        accessibilityLabel: 'Product home',
        child: productRail(input),
      ),
    ),
  ],
);
```

`KlpScreen.accessibilityLabel` 不可空白。單畫面 application 也必須使用 router；沒有另一個直接 child 入口。

需要導覽時，從 `KlpRouteInput` 建立 action：

```dart
final details = KlpDestination<int, int>('product.details');

KlpAction openDetails(KlpRouteInput<Object?, Object?> input) {
  return input.navigate(details.location(42), onResult: (value) {
    // 只更新產品資料，再以新的 KlpApplication 送入 source。
  });
}
```

詳細頁可用 `input.finish(result)` 回傳值，或 `input.back()` 取消。`beforeEnter` 與 `beforeLeave` 可在 `KlpRoute` 定義，並接收 `KlpNavigationTransition` 作為 guard 資料。

## 3. 用資格化容器組畫面

`KlpRail` 的三個區域只接受 `KlpRailItem`。自訂項目可同時實作更多資格介面，但不能傳入一般 `KlpNode`。

```dart
KlpRail productRail(KlpRouteInput<Object?, Object?> input) {
  return KlpRail(
    id: 'product.rail',
    top: [
      ProductRailItem(
        id: 'product.open',
        label: 'Open',
        action: input.navigate(details.location(42)),
      ),
    ],
    center: const [],
    bottom: const [],
  );
}
```

容器將自身 slot 轉成 `KlpChildren`，本庫再驗證每個 placement、重複 id 與樹狀結構。不要另外手動組 `KlpChildren` 來繞過容器 API。

## 4. 將資料宣告送給 Kallopis

consumer 維護的是 application 資料來源，不是 Flutter host。當資料或 callback 行為改變時，建立新的 `KlpApplication`，指定給 `KlpMutableState.value`。

```dart
late final KlpMutableState<KlpApplication> source;
var counter = 0;

KlpApplication declaration() {
  return KlpApplication(
    title: 'Product | $counter',
    primitives: primitives,
    router: router,
    components: [productRailItemDefinition()],
  );
}

void main() {
  source = KlpMutableState(declaration());
  runKlpApp(source.readOnly);
}
```

若 callback 修改資料，重新指定 `source.value = declaration()`。不得呼叫 renderer、安裝 controller 或保存第二份 route state。完整可執行範例是 [runtime demo](../../example/lib/klp_runtime_demo.dart)。

## 5. application 組裝檢查表

| 項目 | 應有結果 |
|---|---|
| 唯一 root | 一個 `KlpState<KlpApplication>` 與一次 `runKlpApp(source.readOnly)` |
| style | `KlpApplication.primitives` 是完整 `KlpPrimitiveSet` |
| navigation | router 的 initial destination 已註冊，所有 screen 有非空 accessibility label |
| extension | 每一個自訂 node type 都有一個註冊的 `KlpComponentDefinition` |
| children | 容器只取得其資格介面允許的節點 |
| update | callback 改資料後替換 application 宣告，不接觸 Flutter state |

目前 `KlpApplication` 已可選擇 `onNavigationRestorationChanged`。只有所有 route destination 都有 restoration codec 時才能使用它；codec 與 URI 形式見 [受控導覽還原設計](../architecture/controlled-navigation-restoration.md)。實際瀏覽器 history 和完整 stack URL 尚未完成，不能當成已交付能力。
