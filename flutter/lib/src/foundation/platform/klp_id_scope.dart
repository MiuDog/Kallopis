import 'dart:async';

import 'package:flutter/widgets.dart';

import 'package:kallopis/src/kernel/identity/klp_id.dart';

/// 同時提供宣告期 Zone 與渲染期 Widget 樹的識別範圍。
final class KlpIdScope extends InheritedWidget {
	final KlpId id;

	const KlpIdScope({super.key, required this.id, required super.child});

	/// 在目前宣告流程建立可巢狀繼承的識別範圍。
	static R run<R>(KlpId scope, R Function() action) => runZoned<R>(
		action,
		zoneValues: {#kallopisKlpId: scope},
	);

	/// 取得目前宣告期 Zone 內的識別範圍。
	static KlpId? get current => KlpId.current;

	/// 訂閱最近的渲染期識別範圍；缺少祖先時明確拋錯。
	static KlpId of(BuildContext context) {
		final id = maybeOf(context);
		if (id == null) {
			throw StateError('這個 context 之上沒有 KlpIdScope。');
		}

		return id;
	}

	/// 訂閱最近的渲染期識別範圍；未注入時回傳 null。
	static KlpId? maybeOf(BuildContext context) => context
		.dependOnInheritedWidgetOfExactType<KlpIdScope>()
		?.id;

	/// 以目前渲染期範圍建立子識別碼。
	static KlpId childOf(BuildContext context, String leaf) => of(context).child(leaf);

	@override
	bool updateShouldNotify(KlpIdScope oldWidget) => id != oldWidget.id;
}
