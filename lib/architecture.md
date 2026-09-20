# Kallopis Public Flutter Surface

狀態：ACTIVE

## 責任

`lib/` 擁有 Kallopis 的公開 Flutter barrels，以及由它們可達的 theme、foundation 與
experimental 元件。公開 API 必須直接使用 Flutter，不得重新匯出 declarative runtime、
adapter、bound model、compiler 或 private renderer。

## 依賴方向

```text
kallopis_theme.dart
	← kallopis_foundation.dart
	← kallopis_experimental.dart
	← consumer
```

Foundation 可公開 stable theme、通用布局與元件；experimental 只公開尚未穩定的高階
compound component。兩者只能匯出 `lib/src` 內有明確 module owner 的 API。

## 不變條件

- Consumer 不匯入 `lib/src`。
- Foundation 新 export 必須通過公開入口 analyze。
- 新公開元件不得依賴產品 model 或第二套 UI runtime。
- Module 自己的 `architecture.md` 仍擁有行為與內部責任；本檔只擁有跨 module 公開可達性。
