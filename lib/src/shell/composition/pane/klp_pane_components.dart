import 'package:flutter/material.dart';

import '../../../foundation/klp_icon.dart';
import '../../../foundation/klp_icons.dart';
import '../../../l10n/klp_localizations.dart';
import '../../../theme/klp_theme.dart';

/// 可由產品呈現的內容狀態。
enum KlpContentState { loading, ready, empty, error, permission }

/// 依可用寬度切換 Pane 呈現的協調器。
class KlpResponsivePaneCoordinator extends StatelessWidget {
	const KlpResponsivePaneCoordinator({
		super.key,
		required this.wide,
		required this.compact,
		this.breakpoint = 960,
	});

	final Widget wide;
	final Widget compact;
	final double breakpoint;

	@override
	Widget build(BuildContext context) {
		return LayoutBuilder(
			builder: (context, constraints) =>
				constraints.maxWidth >= breakpoint ? wide : compact,
		);
	}
}

/// Pane 的收合互動控制。
class KlpPaneCollapseControl extends StatefulWidget {
	const KlpPaneCollapseControl({
		super.key,
		this.icon,
		this.label,
		required this.collapsed,
		required this.onToggle,
	});

	final KlpIconData? icon;
	final String? label;
	final bool collapsed;
	final VoidCallback? onToggle;

	@override
	State<KlpPaneCollapseControl> createState() => _KlpPaneCollapseControlState();
}

class _KlpPaneCollapseControlState extends State<KlpPaneCollapseControl> {
	bool _hovered = false;

	@override
	Widget build(BuildContext context) {
		final klp = context.klp;
		final tokens = context.klpColors;
		final effectiveIcon = widget.icon ?? KlpIcons.panelLeft;
		final effectiveLabel =
			widget.label ?? KlpLocalizations.of(context).panelToggleLabel;
		final button = DecoratedBox(
			decoration: BoxDecoration(
				color: _hovered ? klp.selectionWash : tokens.clear,
				borderRadius: BorderRadius.circular(klp.shape.control),
			),
			child: SizedBox.square(
				dimension: klp.space.controlHeightSmall,
				child: Center(
					child: KlpIcon(
						effectiveIcon,
						size: klp.space.iconBase,
						color: widget.collapsed ? tokens.textFaint : tokens.textMuted,
					),
				),
			),
		);

		return MouseRegion(
			onEnter: (_) => setState(() => _hovered = true),
			onExit: (_) => setState(() => _hovered = false),
			child: GestureDetector(
				behavior: HitTestBehavior.opaque,
				onTap: widget.onToggle,
				child: Semantics(
					button: true,
					label: effectiveLabel,
					expanded: !widget.collapsed,
					child: button,
				),
			),
		);
	}
}
