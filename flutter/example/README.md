# Kallopis Catalog

Catalog 直接使用 Flutter 與 Kallopis 公開元件展示可接受的視覺與互動狀態，不承擔產品 runtime 或遷移清冊責任。

在 repository root 執行：

```text
D:/flutter/bin/flutter.bat run -d windows --target example/lib/main.dart
```

入口只有 `example/lib/main.dart`。新增展示頁時使用 `kallopis_foundation.dart` 或 `kallopis_experimental.dart` 的公開 Flutter Widget，不得引用 `lib/src`。
