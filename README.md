# Kallopis

Kallopis 是 `-ist` 產品家族共用的 Flutter design system 與元件庫。它提供 semantic theme、字型、圖示、可重用 Flutter 元件，以及元件內部的互動、無障礙與平台適應；產品擁有 application root、Widget tree、布局、導航與業務流程。

現行且唯一的架構由 [KLP-0022](spec/decisions/KLP-0022-thin-design-system-boundary.md) 定義。舊 declarative framework、application host、runtime、renderer 與相容入口已移除。

## 唯一使用入口

一般產品使用：

```dart
import 'package:flutter/material.dart';
import 'package:kallopis/kallopis_foundation.dart';
```

產品直接建立 `MaterialApp` 與 Flutter Widget tree，使用 `buildKlpTheme` 安裝主題，並以 Kallopis 公開元件及 `context.klp` semantic token 維持共用視覺。尚未穩定的直接 Flutter 元件可額外匯入 `kallopis_experimental.dart`。

## 責任邊界

- Kallopis 擁有 semantic theme、公開共用元件及其內部視覺與互動。
- Consumer 擁有畫面結構、導航、產品流程、業務狀態與產品專用 Widget。
- Consumer 不引用 `lib/src`、不建立第二份共用 theme，也不重建 declarative／compatibility 路徑。
- Krepis／provider 繼續擁有正文、selection、undo 與 persistence；UI 組合不轉移資料權威。
- Catalog 展示公開 Flutter 元件狀態並供人工視覺接受，不是產品 runtime。

## 文件

- [唯一產品使用指南](docs/ai/product-usage.md)
- [Single Architecture v1](docs/architecture/thin-design-system/architecture.md)
- [前端責任邊界](docs/architecture/frontend-boundaries.md)
- [風格規格](spec/style-v1.md)
