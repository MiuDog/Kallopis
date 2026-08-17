# Kallopis — Agent 作業入口（AGENTS.md）

Kallopis 是 `-ist` 產品家族共用的 **Flutter 視覺層**：design token、theme、排版與無產品語意的
共用元件。公開入口是 `lib/kallopis.dart`，實作在 `lib/src/`，元件目錄在 `example/`，
決策在 `spec/decisions/`。

**範圍、抽層規則與拒絕清單見 [`README.md`](README.md)。**

本檔為通用入口（Codex 等工具原生讀取；CLAUDE.md / GEMINI.md 應指向本檔）。

## 硬規則

- 完成＝證據（`flutter analyze` 與 `flutter test` 的輸出尾行）；「應該可以」不是完成。
- **註解一律繁體中文**，identifier、測試名稱維持英文。
- 大檔（>200 行）先內容搜尋定位再分段讀，不整檔讀。
- 查不到的事實標「未查證」，嚴禁編造 API、路徑、來源。

### 本專案特有硬規則

- **元件不得寫死風格。** 顏色、間距、圓角、時長、字體一律取自 `context.klp`。
  這條由 `test/token_discipline_test.dart` 機械執行，不靠自律。
- **primitive 層不可被覆寫。** `KlpScale` 與 `KlpPalette` 是設計語言的字彙表，不是設定項。
  元件不得直接參照它們——那會跳過整個繼承樹，值正確但不隨 theme 改變。
- **component token 應該是稀疏的。** `KlpComponentTheme` 大量出現代表 semantic 層沒設計好。
- **新增元件前先過五條抽層規則**（README）。判準是：**Notist 這種刻意平凡的筆記 app
  需不需要？** 只有某個產品需要 → 留在該產品。
- **一條規則只能有一個實作。** 同一個值若在 theme 與元件各有一份預設，兩者必然靜默分岔
  ——改了 theme 卻沒改元件時不會報錯，只是沒生效。
- **加 allowlist／調高 baseline 等同於關掉閘門。** 若不得不加，必須在同一次提交寫明何時移除。

## 環境事實

實測於 2026-08-18，Windows 11 Home 26200，繁體中文語系。**只增不猜。**

| 項目 | 值 |
|---|---|
| Flutter | `3.44.4` stable，Dart `3.12.2` |
| 路徑 | `C:\development\flutter\bin` |
| **flutter 不在 PATH 上** | 須先 `$env:Path = "C:\development\flutter\bin;" + $env:Path` |
| 相依 | `flutter_svg ^2.2.1`（唯一的第三方相依） |

```
flutter analyze
flutter test
cd example && flutter test
```

golden 需要重算時用 `flutter test --update-goldens <path>`，**並在提交訊息說明為什麼視覺
應該改變**——golden 變更是唯一能證明「視覺跑掉了」的訊號，無說明的更新等於把它關掉。

### 已知陷阱

**隨套件散佈的字型與資產，少了 `packages/kallopis/` 前綴不會編譯失敗。**
字型會靜默 fallback 到系統預設，SVG 會到消費端 app 的資產路徑找。這是本庫唯一會
無聲退化的地方，因此字型家族名寫在 `KlpTypographyTheme`、圖示只在 `KlpIcon` 一處載入。

**元件讀 `KlpSpace.md` 而不是 `context.klp.space.base` 不會出錯。** 值是對的，只是不隨
theme 改變。這類錯誤沒有任何徵兆，只在換風格時表現為「某個元件沒跟著變」——
`example/test/style_switch_golden_test.dart` 的兩張圖是唯一能看出它的地方。

## 規則衝突時

使用者當下指示 > 本檔 > `README.md` 的抽層規則 > `spec/decisions/`。裁決不了就批次提問。
