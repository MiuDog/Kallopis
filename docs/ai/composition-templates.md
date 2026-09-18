# 應用與組裝模板

這些模板是宣告式 consumer 寫法。程式中的資料與 callback 可以替換；節點型別必須來自 `kallopis_declarative.dart`，不要加入自訂 component、Widget、Context、視覺參數或另一種 app root。

## 1. 建立 destination、router 與 screen

每個目的地保留參數與結果型別。route 的 `screen` 只取得型別化資料與受控 navigation action；它不取得 context 或 style。

```dart
final home = KlpDestination<Object?, Object?>(KlpId.parse('product.home'));

final router = KlpRouter(
  id: KlpId.parse('product.router'),
  initial: home.location(null),
  routes: [
    KlpRoute<Object?, Object?>(
      home,
      screen: (input) => KlpScreen(
        id: KlpId.parse('product.home.screen'),
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
final details = KlpDestination<int, int>(KlpId.parse('product.details'));

KlpAction openDetails(KlpRouteInput<Object?, Object?> input) {
  return input.navigate(details.location(42), onResult: (value) {
    // 只更新產品資料，再以新的 KlpApplication 送入 source。
  });
}

KlpWorkspaceBlock(
	id: KlpId.parse('product.open-details'),
	kind: KlpWorkspaceBlockKind.action,
	title: 'Open details',
	action: openDetails(input),
)
```

詳細頁可用 `input.finish(result)` 回傳值，或 `input.back()` 取消。路由 action 必須放入支援 `KlpAction` 的庫擁有元件，由 runtime 的 action handler 派送；不能包成 consumer 自行執行的 callback。`KlpWorkspaceBlock.action` 與相容用的 `onPressed` 不可同時提供。`beforeEnter` 與 `beforeLeave` 可在 `KlpRoute` 定義，並接收 `KlpNavigationTransition` 作為 guard 資料。

## 2. 用受限容器組畫面

只使用 `kallopis_declarative.dart` 已公開的具體容器，例如 `KlpAppLayout`、`LayoutRow`、`LayoutColumn` 與 `KlpFrameGroups`。每個容器的具名插槽只接受相符資格的庫擁有節點；資格介面不是 consumer 建立新 component type 的擴充點。

容器將自身 slot 轉成 `KlpChildren`，本庫再驗證每個 placement、重複 id 與樹狀結構。不要另外手動組 `KlpChildren` 來繞過容器 API。

舊實驗 `KlpRail`／`KlpRailItem` 沒有可由目前公開目錄完整組裝的庫擁有 item，因此不屬於 consumer 入口。需要工作區導覽動作時使用 `KlpWorkspaceBlock`；需要其他容器能力時先提出庫內元件需求。

## 3. 將資料宣告送給 Kallopis

consumer 維護的是 application 資料來源，不是 Flutter host。當資料或 callback 行為改變時，建立新的 `KlpApplication`，指定給 `KlpMutableState.value`。

```dart
late final KlpMutableState<KlpApplication> source;
var counter = 0;

KlpApplication declaration() {
	return KlpApplication(
		title: 'Product | $counter',
		router: router,
	);
}

void main() {
  source = KlpMutableState(declaration());
  runKlpApp(source.readOnly);
}
```

若 callback 修改資料，重新指定 `source.value = declaration()`。不得呼叫 renderer、安裝 controller 或保存第二份 route state。完整可執行範例是 [runtime demo](../../example/lib/klp_runtime_demo.dart)。

## 4. application 組裝檢查表

| 項目 | 應有結果 |
|---|---|
| 唯一 root | 一個 `KlpState<KlpApplication>` 與一次 `runKlpApp(source.readOnly)` |
| appearance | consumer 沒有 primitive、preset、theme 或局部 style 輸入；宿主依平台環境選擇 Kallopis 內建外觀 |
| navigation | router 的 initial destination 已註冊，所有 screen 有非空 accessibility label |
| component source | 所有 node type 都由 `kallopis_declarative.dart` 公開，application 不接受外部註冊 |
| children | 容器只取得其資格介面允許的節點 |
| update | callback 改資料後替換 application 宣告，不接觸 Flutter state |

目前 `KlpApplication` 已可選擇 `onNavigationRestorationChanged`。只有所有 route destination 都有 restoration codec 時才能使用它；codec 與 URI 形式見 [受控導覽還原設計](../architecture/controlled-navigation-restoration.md)。實際瀏覽器 history 和完整 stack URL 尚未完成，不能當成已交付能力。
