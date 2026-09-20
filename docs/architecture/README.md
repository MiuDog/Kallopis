# Kallopis 架構入口

現行架構只有一條依賴方向：產品 Flutter Widget tree → Kallopis 公開 Flutter 元件 → Kallopis semantic theme → Flutter。

- [Single Architecture v1](thin-design-system/architecture.md)：責任、依賴方向、切片與驗收。
- [Editor Host Ownership v1](editor-host-migration/architecture.md)：Note／Canva 宿主移交 Planist 的目錄、切片與發布閘門。
- [KLP-0022](../../spec/decisions/KLP-0022-thin-design-system-boundary.md)：唯一架構決策與發布閘門。
- [前端責任邊界](frontend-boundaries.md)：產品與 Kallopis 的所有權分界。
- [唯一產品使用指南](../ai/product-usage.md)：產品接入與資料投影方式。

原始碼以 `lib/kallopis_theme.dart`、`lib/kallopis_foundation.dart` 與 `lib/kallopis_experimental.dart` 為公開邊界。`lib/src` 僅是實作，不是 consumer API。舊 application／composition／runtime／rendering 圖集與遷移計畫已刪除；需要歷史時查 Git。
