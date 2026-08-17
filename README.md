# Kallopis

`-ist` 產品家族共用的 Flutter 視覺層。

Kallopis 提供 design token、theme、排版與無產品語意的共用元件。**它不知道任何產品在做什麼**
——不知道什麼是計畫、什麼是筆記、什麼是規格。

## 在生態系中的位置

```
Stoicheis（純 Dart）              Krepis（C++）
Screen AST／型別／schema           權威／文件模型／版面／undo／ink
序列化／migration／驗證／診斷        不知道 Schema 與 Designist
        ▲                                 ▲
        └────── Designist（產品）─────────┘
                      │
                      ▼
                  Kallopis（Flutter）
                  token／theme／排版／色彩／間距／圓角／motion
                  responsive primitives／無語意元件／catalog
                      ▲
                      └── Notist、Planist、其他 -ist
```

Kallopis 不依賴 Krepis，也不依賴 Stoicheis。三個庫皆非 `-ist` 命名——`-ist` 保留給產品，
命名層級的區分是防止產品語意漏進庫的第一道防線（Krepis `FND-0001 §7`）。

## 什麼會進這個庫

五條全過才進：

1. 至少兩個產品使用
2. 具有相同的產品語意
3. 互動與無障礙規則相同
4. API 能以 token 或 slot 客製，而不是大量布林參數
5. 不含產品資料模型或商業邏輯

只過部分規則的留在產品內。若未來兩個產品真的共享同一個領域概念，把它提升為**獨立
feature package**，而不是塞進視覺元件庫。

逐一元件的判定結果見 [`spec/component-classification.md`](spec/component-classification.md)。

### 拒絕清單

任務卡與計畫語意、專案與邀請協作、AI 對話介面、儀表板與資料庫視圖、導覽與入口決策、
任何與產品狀態直接綁定的元件。

## Token 架構

三層，由下往上解析：

| 層 | 內容 | 可否覆寫 |
|---|---|---|
| 1 primitive | `KlpScale`、`KlpPalette`——只有數值，沒有語意 | **否**。它是設計語言的字彙表，不是設定項 |
| 2 semantic | `KlpThemeData`（色彩）、`KlpTypographyTheme`、`KlpSpacingTheme`、`KlpShapeTheme`、`KlpMotionTheme`、`KlpSurfaceTheme` | 是，皆為 `ThemeExtension` |
| 3 component | `KlpComponentTheme`，欄位全為 nullable，`null` 表示沿用 semantic | 是 |

元件一律透過 `context.klp` 取值，拿到的是已沿繼承樹解析的結果，不需要知道值來自哪一層。
任一層缺席時回退預設而非拋錯——庫被放進未設定 theme 的 app 仍能渲染。

### 換一套視覺風格

`KlpVisualStyle` 把七層綁成必須整組給定的物件，因此「只換其中三層」這種半套狀態無法表達。

```dart
MaterialApp(
  theme: buildKlpTheme(Brightness.dark, style: KlpVisualStyle.terminal),
  home: const MyApp(),
)
```

內建 `modern`（比例字體／圓角／陰影分層／寬鬆密度／有過場）與 `terminal`（全域等寬／直角／
實線框分層／高密度／無過場）。消費者微調時取一個現成風格再 `copyWith` 單一層。

**`terminal` 同時是架構的驗收條件**：切換到它若需要改動任何元件程式碼，就代表該元件
還在硬編碼風格。

## 閘門

「不要硬編碼風格」寫在文件裡只是承諾，承諾不會擋下任何一次提交。以下是機械判準：

| 測試 | 擋什麼 |
|---|---|
| `test/token_discipline_test.dart` | 元件出現 `Color(0x…)`、`Duration(milliseconds:…)`、或直接參照 primitive 層 |
| 同上（棘輪） | 舊 static token 的引用數只能下降，且降下去後忘記調低 baseline 也會失敗 |
| `test/visual_style_test.dart` | 兩套風格在字體／形狀／密度／動態／分層手法上必須全部不同 |
| `example/test/style_switch_golden_test.dart` | 兩套風格算出的圖必須不同——證明 token 真的抵達畫面，而不只是值不同 |
| `test/klp_region_placeholder_golden_test.dart` 等 | 渲染輸出與抽取來源逐像素相同 |

## 建置與測試

Flutter 3.44.4 / Dart 3.12.2，於 `C:\development\flutter\bin`（**不在 PATH 上**）。

```
flutter analyze
flutter test
cd example && flutter test
```

## 已知欠債

- 元件層仍有 515 處引用 `KlpSpace`／`KlpRadius` 這類編譯期常數，值正確但**不隨 theme 改變**
  ——這是 terminal 風格下 toggle 仍是膠囊形的原因。以棘輪測試列管。
- 6 個檔案內嵌寫死的中文文案，應收斂為必填 label 參數或 `Klp*Labels` 物件
  （`KlpCodeViewerLabels` 已是這個形狀，可作為樣板）。
- `klp_advanced_data`（20 個布林參數）、`klp_foundation_extras`（11 個，且是 17 個類別的雜物袋）
  未通過抽層規則 4，需重構而非移除。
