# 宣告式 Adaptive 平台策略

平台分流的唯一結構順序是 **`KlpScreen → KlpAdaptive → KlpPlatformStrategy.build`**。消費端提供純資料策略；Kallopis host 讀取平台環境後，runtime 只建立命中的策略樹，再執行 ID、slot、registry 與 installation 驗證。

策略不能 import Flutter、讀取平台、取得 `BuildContext` 或回傳 `Widget`。它只能依 `KlpAdaptiveContext` 回傳受控的 `KlpCompositeNode`。

```dart
final class WindowsHomeStrategy implements KlpPlatformStrategy {
  WindowsHomeStrategy(this.scope);

  final KlpId scope;

  @override
  KlpCompositeNode build(KlpAdaptiveContext context) {
    return KlpAppLayout(
      id: scope / 'windows.layout',
      child: buildWindowsColumns(scope),
    );
  }
}

KlpScreen(
  id: scope / 'screen',
  accessibilityLabel: '產品首頁',
  child: KlpAdaptive(
    id: scope / 'adaptive',
    fallback: buildTouchLayout(scope),
    strategies: {
      KlpAdaptivePlatform.windows: WindowsHomeStrategy(scope),
      KlpAdaptivePlatform.macos: MacosHomeStrategy(scope),
    },
  ),
)
```

`fallback` 是沒有命中平台策略時的完整受控子樹。`strategies` 內未命中的 `build` 絕不會被呼叫，也不會被驗證；因此策略可安全持有僅屬於該平台的資料組裝邏輯。策略輸出的 ID 仍必須在同一棵樹內唯一。

`KlpAdaptivePlatform.windows` 與 `desktop`、`tabletLandscape` 等 viewport mode 不相同：前者決定要執行哪個平台策略；`KlpAdaptiveContext.deviceClass`、`orientation` 與 `displayMode` 則讓已命中的策略在不讀取 Flutter 環境的前提下，選擇其資料布局。viewport mode 只描述已選平台內的響應式呈現，不能取代平台策略。
