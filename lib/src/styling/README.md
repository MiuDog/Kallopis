# lib/src/styling：樣式原料、語意與解析契約

[返回上層 (lib/src)](../README.md)

## 目錄職責

`lib/src/styling` 負責 Kallopis 設計系統的核心樣式規則：固定結構的原料（Primitives）、強型別參照（References）、元件專屬語意用途（Semantics）以及庫內求值解析器（Resolution）。同時收納未遷移的舊有 ThemeExtension 實作（以 `legacy_*` 標記隔離）。

## 子目錄結構與職責

| 子目錄 | 核心職責 | 關鍵型別與實作 |
|---|---|---|
| `primitives/` | **固定結構設計原料 (Primitives)**：定義設計語言的原料字彙表（色彩、間距、圓角、時長、排版等固定 Schema）。不可單獨覆寫單一變數，只能在應用根進行整套替換。 | `KlpPalette`, `KlpPrimitives` 等基礎原料 |
| `references/` | **強型別風格參照 (References)**：提供封閉、同型別的樣式參照代碼，確保宣告期使用風格時具備編譯期型別安全。 | 強型別風格參照物件 |
| `semantics/` | **語意用途定義 (Semantics)**：定義各元件自訂的語意用途（如背景、前景、強調色），規範用途 owner、可見性（public / private）與使用權限。 | `KlpSemanticUsage`, 語意定義與相依規格 |
| `resolution/` | **樣式解析與求值 (Resolution)**：庫內私有解析器，驗證語意用途引用圖的合法性，並將語意宣告結合 Primitive 原料求出最終可渲染的數值快照。 | `internal/klp_styling_resolver.dart`, 樣式解析快照 |
| `presets/` | **預設風格主題配方**：內建風格預設值與舊版配方收納。 | 預設樣式組合 |
| `legacy_tokens/` | **舊版 Token 相容層**：舊有 Primitive Token 實作，僅供舊版向後相容。 | 舊版 Token 實作 |
| `legacy_theme/` | **舊版 Flutter 主題擴充**：舊有基於 `ThemeExtension` 的主題實作，非新宣告式路徑。 | 舊版 `KlpTheme` 等實作 |

## 架構依賴與邊界約定

- **Token Discipline（紀律約束）**：元件嚴禁寫死顏色、數值或字體；所有視覺樣式必須經由語意參照與 Primitive 原料解析而來。
- **不可個別覆寫**：Primitive 是設計語言的字彙表而非任意設定項，必須整套替換以確保視覺系統的一致性。
- **解析隔離**：`resolution/` 為庫內內部實作，不對外部消費端暴露，外界只能透過公開的語意宣告引用樣式。
