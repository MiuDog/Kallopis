# Kallopis

Kallopis 是 `-ist` 產品家族共用的跨框架 design system。核心目標為先建立框架無關的視覺語意、token 與通用元件組合規範，再由 Flutter、React 等框架庫落實；各框架庫位於本專案第一層子目錄。產品擁有畫面結構、導航與業務流程。

新目標與責任以 [跨框架核心目標](spec/multi-framework-design-system.md) 為準。共通視覺直接採用 [既有統整規範](docs/design-tokens/KALLOPIS-DESIGN-MAP.md)，按責任分章維護；docs 網頁已整合此來源，Flutter 套件位於第一層 `flutter/`，React 核心庫位於 `react/`。以下接入方式描述 Flutter 庫。

本機 Flutter consumer 的 path dependency 請指向 `D:/Projects/Kallopis/flutter`，或對應的 repository 相對路徑；套件名稱仍是 `kallopis`。根目錄不再是 Flutter package。安裝、分析、測試與 example 操作從 `flutter/` 執行；網站工具仍從 repository 根執行。本次未修改其他產品 repository 的 caller。

目前已實作的 Flutter 架構由 [KLP-0022](spec/decisions/KLP-0022-thin-design-system-boundary.md) 定義。舊 declarative framework、application host、runtime、renderer 與相容入口已移除。

## 框架入口

- [Flutter 產品使用](docs/ai/product-usage.md)：`flutter/` package 與 Widget 組合。
- [React 產品使用](docs/ai/react-usage.md)：`react/` 核心元件、四主題與展示。
- [通用視覺規範](docs/design-tokens/KALLOPIS-DESIGN-MAP.md)：唯一視覺來源與維護規則。
- [整合驗證](docs/architecture/multi-framework-verification.md)：已觀察證據及既有失敗。

## Flutter 使用入口

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
