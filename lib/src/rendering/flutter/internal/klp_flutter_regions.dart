import 'package:flutter/widgets.dart';

import '../../../foundation/binding/internal/klp_bound_template.dart';
import 'klp_flutter_renderer.dart';
import 'klp_flutter_values.dart';

/// 邊側配置與狹小空間退化規則由同一原語管理。
final class KlpFlutterRegions extends StatelessWidget {

	final KlpBoundRegions content;

	const KlpFlutterRegions({required this.content, super.key});

	@override
	Widget build(BuildContext context) => LayoutBuilder(builder: _layout);

	Widget _layout(BuildContext context, BoxConstraints constraints) {
		final axis = klpFlutterAxis(content.axis);
		final maximum = axis == Axis.vertical ? constraints.maxHeight : constraints.maxWidth;
		final required = content.leadingExtent.value + content.trailingExtent.value + content.minimumBodyExtent.value;
		final leading = KlpFlutterRenderer(content: content.leading);
		final body = KlpFlutterRenderer(content: content.body);
		final trailing = KlpFlutterRenderer(content: content.trailing);

		// 門檻只切換限制，不替換祖先拓樸；換風格與縮放時保留焦點及訂閱。
		final fits = maximum.isFinite && maximum >= required;
		final bodyExtent = fits ? maximum - content.leadingExtent.value - content.trailingExtent.value : null;
		final children = <Widget>[
			_extent(axis, fits ? content.leadingExtent.value : null, _scroll(axis, leading)),
			_extent(axis, bodyExtent, _scroll(axis, body)),
			_extent(axis, fits ? content.trailingExtent.value : null, _scroll(axis, trailing)),
		];
		final flow = Flex(direction: axis, mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: children);

		// 不足時解除各區域主方向限制，由同一外層捲動器保持全部內容可達。
		return _scroll(axis, _extent(axis, fits ? maximum : null, flow));
	}

	Widget _scroll(Axis axis, Widget child) => SingleChildScrollView(scrollDirection: axis, primary: false, child: child);

	Widget _extent(Axis axis, double? extent, Widget child) => SizedBox(width: axis == Axis.horizontal ? extent : null, height: axis == Axis.vertical ? extent : null, child: child);
}
