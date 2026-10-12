# Kallopis Flutter 產品使用指南

Kallopis 的 Flutter 庫是 Flutter design system，不是 application framework。產品擁有 app root、導航、畫面結構、狀態與業務流程；Kallopis 擁有 semantic theme、公開共用元件，以及元件內部的視覺、互動、無障礙與平台適應。

## 匯入共通風格檔

`kallopis_theme.dart` 公開 `KlpStylePack` 及 `klpStyleParameters`。風格檔內容由產品讀取；`parse` 接受 JSON 字串或 object，檢查所有 canonical ID、四模式、引用、350 項型別及 catalog 尺寸限制。非法值會拒絕整包，不改目前 Theme。

```dart
final pack = KlpStylePack.parse(styleFileContent);
final theme = buildKlpThemeVariant(
	KlpThemeVariant.light,
	stylePack: pack,
);
```

把 `theme` 提供給 MaterialApp 或局部 `Theme`，公開元件仍讀 `context.klp`。不同 Theme 子樹可用不同 pack；`KlpStylePack.defaults()` 還原預設，`applyOverrides` 對既有 primitive／semantic ID 原子覆寫並回新 pack；`data`／`resolve`／參數 metadata 深度不可變。

`stylePack` 與既有 `style` 不可同時提供，顯式 `accent` 仍可覆寫。pack 擁有透明模式完整色彩，不再套用舊 `transparencyEnabled` 色彩轉換；產品擁有視窗透明設定。字型保持套件前綴，不自動下载外部資產；原生 duration 必須能無損轉微秒，否則以 semantic ID 診斷。350 項 native 欄位已映射；配方展開、全部元件視覺對齊及更完整布局保護仍在後續階段，並未因風格 parser 完成而宣稱完成。

## 1. 建立產品根節點

產品直接使用 `MaterialApp`，並安裝 Kallopis theme 與語系 delegate：

```dart
import 'package:flutter/material.dart';
import 'package:kallopis/kallopis_foundation.dart';

void main() {
	runApp(const ProductApp());
}

class ProductApp extends StatelessWidget {
	const ProductApp({super.key});

	@override
	Widget build(BuildContext context) {
		return MaterialApp(
			theme: buildKlpTheme(Brightness.light),
			darkTheme: buildKlpTheme(Brightness.dark),
			localizationsDelegates: const [KlpLocalizationsDelegate()],
			home: const ProductWorkspace(),
		);
	}
}
```

## 2. 組合產品畫面

產品使用 Flutter 的 `Row`、`Column`、`Stack`、`Expanded` 與自己的 Widget 組合畫面；共用視覺與互動使用 `kallopis_foundation.dart` 公開元件：

```dart
class ProductWorkspace extends StatelessWidget {
	const ProductWorkspace({super.key});

	@override
	Widget build(BuildContext context) {
		final space = context.klp.space;
		return KlpSurface(
			tone: KlpSurfaceTone.app,
			child: Padding(
				padding: EdgeInsets.all(space.base),
				child: Row(
					children: [
						const SizedBox(width: 280, child: ProductSidebar()),
						SizedBox(width: space.base),
						const Expanded(
							child: KlpStageFrame(
								content: Center(child: KlpText('Product content')),
							),
						),
					],
				),
			),
		);
	}
}
```

產品專用寬度、順序與流程留在產品；顏色、字級、間距、圓角與動效從 `context.klp` 取得，不建立第二份共用 theme，也不引用 `package:kallopis/src/...`。

## 3. 投影狀態與回傳事件

### Panel 的可選微立體

`KlpPanelFrame(elevation: KlpPanelElevation.raised, content: content)` 啟用原微立體效果；預設 `KlpPanelElevation.flat`。右下陰影與左上亮邊由共用配方及目前 semantic theme 決定，深色沿用低對比亮邊，不改變布局或內容裁切。此選項只適用 `KlpPanelFrame`，其他 frame 不會自動改變。Catalog 提供 flat／raised 展示；`example/lib/panel_relief_main.dart` 提供淺深色並排比較。

產品 controller 是唯一資料權威。Widget 接收目前值，使用 callback 把使用者操作送回 controller：

```dart
KlpFileExplorer(
	sections: controller.sections,
	selectedId: controller.selectedId,
	expandedSectionIds: controller.expandedSectionIds,
	expandedItemIds: controller.expandedItemIds,
	onItemSelected: controller.selectItem,
	onSectionToggle: controller.toggleSection,
	onItemToggle: controller.toggleItem,
)
```

Kallopis 元件可以持有 hover、focus、pressed 等內部暫態，但不接管產品資料、導航或保存流程。

## 4. 使用高階實驗元件

尚未穩定、但已證明跨產品重用的直接 Flutter 元件可從 `kallopis_experimental.dart` 匯入。產品專用 editor host、WebView bridge、packaged asset 與 session 接線不屬於 Kallopis；它們留在產品自己的 capability module，並可在內部使用 Kallopis theme 與公開共用元件。

例如 Planist 的 BlockNote 與 Canva host 分別由 Flow／Canva presentation 擁有，Workspace 只取得既有 session 並組裝 editor。正文、selection、undo 與 persistence 仍由 Krepis／provider 掌管。

## 5. 元件缺口處理

Kallopis 沒有某個產品畫面時，產品直接建立 Flutter Widget，並沿用 Kallopis semantic theme。只有同一能力已證明跨產品重用，才提升為 Kallopis 公開元件。

禁止建立 declarative node、application host、adapter／bound model、私有 renderer、相容 shim、feature flag 或第二條產品接入路徑。
# Flutter 套件位置

Kallopis repository 根目錄維護共通規範；Flutter package 位於 `flutter/`。Consumer 的 path dependency 需由 `Kallopis` 改指向 `Kallopis/flutter`；package 名稱、公開 imports 與字型 package ownership 不變。以下指南仍適用於公開 Flutter API，Flutter 指令請從 `flutter/` 執行。

## 通用有限尺寸計算

從 foundation 使用 KlpLinearItem／resolveKlpLinearLayout，給有限主軸尺寸、scope 的 semantic gutter、間距數量及 minimum／maximum／preferred／flex，結果提供不可變 extents、實際 gutter、unused 與 compressed。庫不儲存產品內容或布局。

先扣間距；空間不足時按 minimum 比例退化，極大間距最多占滿主軸；有空間時按 flex 分配並遵守 maximum，無可增長項目時保留 unused。完整規則見 [共通尺寸契約](../architecture/workbench-linear-contract.md)。目前 utility 已可使用，既有 Row／Column 的全面接入與風格下布局保護仍待下一階段。
