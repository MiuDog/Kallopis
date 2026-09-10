part of '../klp_navigation_rail.dart';

/// Workbench 的主要圖示導覽軌。
///
/// 分組模式只接受 [KlpRailItemGroup]；群組之間自動加入分隔線，項目只能在
/// 原群組內排序。
class KlpNavigationRail extends StatefulWidget {
	const KlpNavigationRail({
		super.key,
		required this.top,
		required this.center,
		required this.bottom,
	});

	final KlpRailItemGroup top;
	final KlpRailItemGroup center;
	final KlpRailItemGroup bottom;

	@override
	State<KlpNavigationRail> createState() => _KlpNavigationRailState();
}
