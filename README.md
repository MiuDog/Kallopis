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
| 1 primitive | `KlpScale`（數值階梯）、`KlpPalette`（**ink 11 階中性色梯**＋語意色） | **否**。它是設計語言的字彙表，不是設定項 |
| 2 semantic | `KlpThemeData`（色彩）、`KlpTypographyTheme`、`KlpSpacingTheme`、`KlpShapeTheme`、`KlpMotionTheme`、`KlpSurfaceTheme` | 是，皆為 `ThemeExtension` |
| 3 component | `KlpComponentTheme`，欄位全為 nullable，`null` 表示沿用 semantic | 是 |

元件一律透過 `context.klp` 取值，拿到的是已沿繼承樹解析的結果，不需要知道值來自哪一層。
任一層缺席時回退預設而非拋錯——庫被放進未設定 theme 的 app 仍能渲染。

### 換一套視覺風格

**庫只出貨 `modern` 一套，各層也只有一個 preset。** 要別的外觀是取它再逐層 `copyWith`：

```dart
final squared = KlpVisualStyle.modern.copyWith(
  name: 'squared',
  shape: KlpShapeTheme.standardShape.copyWith(control: 0, card: 0, panel: 0),
);

MaterialApp(
  theme: buildKlpTheme(Brightness.dark, style: squared),
  home: const MyApp(),
)
```

`KlpVisualStyle` 把七層綁成必須整組給定的物件，因此「只換其中三層」這種半套狀態無法表達。
庫**不預先替任何產品組好第二套外觀**——那會變成在替產品做風格決定。

只有一套 preset 的代價是沒有現成的對照組可以驗證「token 真的抵達畫面」。
因此 [`test/style_fixture.dart`](test/style_fixture.dart) 用各層的建構子就地組出一套極端值
作為**架構的驗收條件**：切換到它若需要改動任何元件程式碼，就代表該元件還在硬編碼風格。

## 分發（router）

`KlpRouter` 只負責分發：產品註冊自己的目的地，然後要求切換。**庫不知道有哪些頁、
不預設入口、不決定階層、不做轉場、不解析網址**——那些是產品外殼的決定。

```dart
final router = KlpRouter(
  routes: [
    KlpRoute(id: 'notes', builder: (_) => const NotesPage()),
    KlpRoute(id: 'search', builder: (_) => const SearchPage()),
  ],
  initialId: 'notes',
);

KlpRouterScope(router: router, child: const KlpRouterOutlet())
```

切換用 `context.klpRouter.go('search')`。**切到未註冊的 id 會拋錯，不會靜默停在原地。**

## 元件清單

有兩份，用途不同：

| 文件 | 由誰維護 | 回答什麼 |
|---|---|---|
| [`spec/component-inventory.md`](spec/component-inventory.md) | `dart run tool/inventory.dart` 從程式碼產生 | 有哪些型別、彼此怎麼組合、分層有沒有破 |
| [`example/lib/catalog/registry.dart`](example/lib/catalog/registry.dart) | 人工維護 | 每個元件屬於哪一類、長什麼樣 |

前者是**事實**（程式碼怎麼寫的），後者是**分類**（我們認為它屬於哪裡）。兩者都有閘門：
inventory 過期會失敗，registry 漏掉任何一個匯出的 widget 也會失敗。

元件目錄分為 6 組 19 頁：Colors、Type、Spacing、Guidelines、Foundation、Form。
124 個 widget 全部歸類完畢。

## 色彩：ink 色梯

所有表面、文字與線條都由 `ink50`–`ink950` 這 11 階推導，**沒有各自命名的中性色**
——`paper`／`chalk`／`dusk` 那種名字看不出彼此的明度關係，於是每次要新增一階都得重新猜。

權威格式是 **oklch**（等亮度感知，調整時可預測），hex 是 sRGB 的實作值。
**改值時改的是 oklch，hex 是換算結果**——反過來做會讓明度階梯逐漸走樣。

三條機械規則：

- 每個中性欄位都必須落在梯上。梯外的欄位在調整色梯時不會跟著變。
- **元件不得直接取用具體顏色**，一律經 `context.klp`。唯一的例外是
  `KlpPalette.transparent`（「沒有顏色」不是顏色）。
- **目錄不得印出色碼。** 色票顯示的是它落在梯上的哪一階，並且是**反查**出來的
  ——不在梯上的欄位會直接顯示「梯外」。

## 閘門

「不要硬編碼風格」寫在文件裡只是承諾，承諾不會擋下任何一次提交。以下是機械判準：

| 測試 | 擋什麼 |
|---|---|
| `test/token_discipline_test.dart` | 元件出現 `Color(0x…)`、`Duration(milliseconds:…)`、或直接參照 primitive 層 |
| 同上（棘輪） | 舊 static token 的引用數只能下降（目前 16），且降下去後忘記調低 baseline 也會失敗 |
| `test/visual_style_test.dart` | 出貨風格與測試用的對照風格，在字體／形狀／密度／動態／分層手法上必須全部不同 |
| `example/test/style_switch_golden_test.dart` | 兩套風格算出的圖必須不同——證明 token 真的抵達畫面，而不只是值不同 |
| `test/klp_region_placeholder_golden_test.dart` 等 | 渲染輸出與抽取來源逐像素相同 |
| `test/consumer_contract_test.dart` | 從**消費者的位置**驗證：只 import 公開 barrel、不自備任何鷹架，元件要能渲染、客製面要真的生效、barrel 不得漏匯出 |
| 同上（棘輪） | 未文件化的公開型別數量只能下降 |
| `test/router_test.dart` | 庫內不得出現具名路由；切到未註冊的目的地必須拋錯 |
| `test/inventory_test.dart` | 元件清單不得過期；分層違規數只能下降 |
| `test/color_discipline_test.dart` | 中性欄位必須在 ink 梯上；元件不得取用具體顏色；色梯明度嚴格遞減；文字三階與強調色的對比門檻 |
| `example/test/catalog_coverage_test.dart` | 每個匯出的 widget 都要被歸類、不得重複、不得殘留已刪除的名字；每一頁在明暗兩態下都要能渲染 |

## 建置與測試

Flutter 3.44.4 / Dart 3.12.2，於 `C:\development\flutter\bin`（**不在 PATH 上**）。

```
flutter analyze
flutter test
cd example && flutter test
```

元件目錄可實際執行（Windows）：

```
cd example && flutter run -d windows
```

## 已知欠債

- 舊 static token 的引用已從 515 降到 16，剩餘的全部是刻意保留：面板寬度與 responsive
  斷點（版面預設值，可由 widget 參數覆寫）、選單幾何（要在 build 前算彈出位置，取不到
  context）、視窗透明度、dense 變體的固定高度。棘輪測試維持列管，新增靜態引用視為回退。
- 無障礙 `Semantics` 覆蓋 76 個檔案中的 22 個。
- 186 個公開型別中，消費者最先碰到的 17 個已有 dartdoc，其餘以棘輪列管。
- `klp_advanced_data`（20 個布林參數）、`klp_foundation_extras`（11 個，且是 17 個類別的雜物袋）
  未通過抽層規則 4，需重構而非移除。
