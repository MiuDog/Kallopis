import 'package:flutter/widgets.dart';
import 'package:kallopis/kallopis.dart';

/// 讓 Catalog 內的編輯頁把主題色更新交還給 app root。
class CatalogThemeScope extends InheritedWidget {
	const CatalogThemeScope({
		super.key,
		required this.value,
		required this.onChanged,
		required super.child,
	});

	final KlpOklchColor value;
	final ValueChanged<KlpOklchColor> onChanged;

	static CatalogThemeScope of(BuildContext context) {
		final scope = context.dependOnInheritedWidgetOfExactType<CatalogThemeScope>();
		assert(scope != null, 'CatalogThemeScope is missing above this Catalog page.');
		return scope!;
	}

	@override
	bool updateShouldNotify(CatalogThemeScope oldWidget) => value != oldWidget.value;
}
