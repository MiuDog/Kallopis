# Kallopis 架構入口

新核心目標以 [跨框架核心目標](../../spec/multi-framework-design-system.md) 為準：共通視覺語意、token 與組合規範先行，各框架庫依規範實作並位於第一層子目錄。共通視覺已採用 [正式規範](../design-tokens/KALLOPIS-DESIGN-MAP.md)；[docs 網站整合架構](../../tool/reference_site/architecture.md) 已整合正式章節；互動展示與 GUI 範例仍在 Workbench 階段執行。Flutter／React 已位於第一層子目錄。

目前已實作的 Flutter 依賴方向：產品 Flutter Widget tree → Kallopis 公開 Flutter 元件 → Kallopis semantic theme → Flutter。下列文件描述此實作與既有責任邊界。

- [Single Architecture v1](thin-design-system/architecture.md)：責任、依賴方向、切片與驗收。
- [Editor Host Ownership v1](editor-host-migration/architecture.md)：Note／Canva 宿主移交 Planist 的目錄、切片與發布閘門。
- [KLP-0022](../../spec/decisions/KLP-0022-thin-design-system-boundary.md)：唯一架構決策與發布閘門。
- [前端責任邊界](frontend-boundaries.md)：產品與 Kallopis 的所有權分界。
- [唯一產品使用指南](../ai/product-usage.md)：產品接入與資料投影方式。

Flutter 原始碼以 `flutter/lib/kallopis_theme.dart`、`flutter/lib/kallopis_foundation.dart` 與 `flutter/lib/kallopis_experimental.dart` 為公開邊界。`flutter/lib/src` 僅是實作，不是 consumer API。舊 application／composition／runtime／rendering 圖集與遷移計畫已刪除；需要歷史時查 Git。

跨框架責任見 [根架構](../../architecture.md)，React 使用見 [產品指南](../ai/react-usage.md)，實際驗證見 [整合紀錄](multi-framework-verification.md)。
