# Flutter Modern productivity

狀態：draft；截圖待審閱。

[可複製 starter](../../../flutter/example/lib/modern_productivity_starter.dart) 在公開 `KlpModernProductivityLayout` 內提供兩個產品面板。選取與兩個 TextEditingController 由 starter 擁有並釋放；Header／Stage 是產品內容。

在 `flutter/example/` 執行 `flutter run -d chrome`，開啟網址加上 `?template=modern-productivity-layout`。預覽控制區用來調整設定，不屬於產品畫面。

間距取 `context.klp.space.contentInset`。若 Header 內容不支援 intrinsic 量測，依既有契約提供有明確高度的宿主；不要複製布局元件內部樣式。

- [組裝圖、狀態與 token 選用](README.md)
- [Flutter Reference](../../reference/flutter/README.md)
- [設定複製及版本限制](../../templates/modern-productivity-layout.md)
