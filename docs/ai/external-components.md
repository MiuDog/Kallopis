# 外部元件作者指南

外部元件不是 Flutter widget。它由兩個分離的物件構成：實例描述資料、操作與資格；定義描述可用的 semantic token 與 Kallopis 封閉模板。本庫驗證兩者後才產生呈現結果。

## 1. 實作節點與容器資格

若元件要放進 rail，實作 `KlpRailItem`。若它含有子項，另實作 `KlpCompositeNode` 並以 `KlpSlot<C>` 和 `KlpChildren` 宣告唯一 children 結構。

```dart
final class ProductRailItem implements KlpRailItem, KlpCompositeNode {
  static const typeId = 'product.railItem';

  @override
  final String id;
  final String label;
  @override
  final KlpAction? action;

  const ProductRailItem({
    required this.id,
    required this.label,
    required this.action,
  });

  @override
  String get definitionId => typeId;

  @override
  String get accessibilityLabel => label;

  @override
  Iterable<KlpNode> get children => const [];
}
```

多重資格是允許的：一個節點可實作多個 Kallopis 介面。不相容的容器不會因為節點同時具有其他資格而放寬其 slot 型別。

有 children 的精確寫法請以 [demo rail item](../../example/lib/klp_runtime_demo/demo_rail_item.dart) 為基準：建立具泛型的 `KlpSlot<C>`，並在建構子一次建立 `KlpChildren([slot.assign(items)])`。同名 slot、遺漏、重複 assignment 與不合格 child 都由結構驗證拒絕。

## 2. 在定義期建立 semantic schema

每個元件 type 有自己的 owner id。semantic key 指向固定 primitive set 的某一格，不直接帶最終色彩或數值。文字模板需要完整六種文字 semantic；下列是可直接依資料欄位調整的結構。

```dart
KlpComponentDefinition<ProductRailItem> productRailItemDefinition() {
  final color = KlpSemanticKey(
    ProductRailItem.typeId,
    'labelColor',
    KlpStyleKind.color,
  );
  final family = KlpSemanticKey(
    ProductRailItem.typeId,
    'labelFamily',
    KlpStyleKind.fontFamily,
  );
  final size = KlpSemanticKey(
    ProductRailItem.typeId,
    'labelSize',
    KlpStyleKind.fontSize,
  );
  final weight = KlpSemanticKey(
    ProductRailItem.typeId,
    'labelWeight',
    KlpStyleKind.fontWeight,
  );
  final height = KlpSemanticKey(
    ProductRailItem.typeId,
    'labelHeight',
    KlpStyleKind.lineHeight,
  );
  final spacing = KlpSemanticKey(
    ProductRailItem.typeId,
    'labelSpacing',
    KlpStyleKind.letterSpacing,
  );
  final semantics = KlpSemanticSchema(ProductRailItem.typeId, [
    KlpSemanticToken(
      color,
      const KlpPrimitiveRef(KlpStyleKind.color, KlpPrimitiveIndex.i1),
    ),
    KlpSemanticToken(
      family,
      const KlpPrimitiveRef(KlpStyleKind.fontFamily, KlpPrimitiveIndex.i0),
    ),
    KlpSemanticToken(
      size,
      const KlpPrimitiveRef(KlpStyleKind.fontSize, KlpPrimitiveIndex.i2),
    ),
    KlpSemanticToken(
      weight,
      const KlpPrimitiveRef(KlpStyleKind.fontWeight, KlpPrimitiveIndex.i4),
    ),
    KlpSemanticToken(
      height,
      const KlpPrimitiveRef(KlpStyleKind.lineHeight, KlpPrimitiveIndex.i1),
    ),
    KlpSemanticToken(
      spacing,
      const KlpPrimitiveRef(
        KlpStyleKind.letterSpacing,
        KlpPrimitiveIndex.i3,
      ),
    ),
  ]);

  return KlpComponentDefinition(
    ProductRailItem.typeId,
    semantics: semantics,
    content: KlpTextTemplate<ProductRailItem>(
      text: (item) => item.label,
      semantics: KlpTextSemantics(
        color: color,
        fontFamily: family,
        fontSize: size,
        fontWeight: weight,
        lineHeight: height,
        letterSpacing: spacing,
      ),
    ),
    accessibilityLabel: (item) => item.accessibilityLabel,
  );
}
```

semantic token 在 definition 建立一次，不能由實例覆寫。完整巢狀模板與 child slot 用法以 [runtime demo definition](../../example/lib/klp_runtime_demo/demo_rail_definition.dart) 為基準。
## 3. 使用封閉 template

公開模板的責任如下：

| 模板 | 可描述的內容 |
|---|---|
| `KlpTextTemplate<T>` | 資料轉出的文字與文字 semantic key |
| `KlpLinearTemplate<T>` | 水平或垂直固定模板組合與間距 semantic key |
| `KlpSurfaceTemplate<T>` | 表面、圓角、內距 semantic key 與單一子模板 |
| `KlpChildrenTemplate<T, C>` | 已宣告 slot 的合格子節點排列 |

template 的 selector 只接收已驗證的節點資料並產出資料值。它不取得 style、context、widget 或 renderer。若需求無法由這四種受控模板表達，先在 Kallopis foundation 增加經審核的能力與 renderer 支援；不能在外部元件加入逃生 callback。

## 4. 註冊與使用

將每個外部 definition 放在 `KlpApplication.components`。同 type id 的重複定義、未註冊的節點、相依循環與未授權 semantic reference 都會在 Kallopis 的驗證／安裝流程被拒絕。

```dart
KlpApplication(
  title: 'Product',
  primitives: primitives,
  router: router,
  components: [productRailItemDefinition()],
);
```

實例層只傳入 `id`、業務資料、合格子節點與 `KlpAction`。容器所持有的選取、焦點、鍵盤與呈現風格不可重寫。

## 無障礙與未支援能力

`KlpScreen` 的 `accessibilityLabel` 是必填。實作 `KlpRailItem` 時必須提供非空 `accessibilityLabel`；一般自訂元件可在 `KlpComponentDefinition.accessibilityLabel` 以資料 selector 提供名稱。不要建立 Flutter `Semantics`。

表單 renderer、完整無障礙矩陣、可選動畫與跨平台環境策略仍在演進。需求落在這些能力時，先記錄所需語意、資料所有權與平台行為，再擴充 foundation；不要以 Flutter 元件作為暫時替代。
