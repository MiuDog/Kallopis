part of '../klp_menu.dart';

class _KlpMenuState extends State<KlpMenu> {
	int _highlightedIndex = -1;

	bool _isEnabled(int index) => widget.items[index].enabled;

	KeyEventResult _handleKey(FocusNode node, KeyEvent event) {
		if (event is! KeyDownEvent) return KeyEventResult.ignored;
		final count = widget.items.length;
		if (count == 0) return KeyEventResult.ignored;

		if (event.logicalKey == LogicalKeyboardKey.arrowDown) {
			setState(
				() => _highlightedIndex = KlpRovingIndex.move(
					current: _highlightedIndex,
					count: count,
					forward: true,
					isEnabled: _isEnabled,
				),
			);
			return KeyEventResult.handled;
		}
		if (event.logicalKey == LogicalKeyboardKey.arrowUp) {
			setState(
				() => _highlightedIndex = KlpRovingIndex.move(
					current: _highlightedIndex,
					count: count,
					forward: false,
					isEnabled: _isEnabled,
				),
			);
			return KeyEventResult.handled;
		}
		if (event.logicalKey == LogicalKeyboardKey.home) {
			setState(
				() => _highlightedIndex = KlpRovingIndex.first(
					count: count,
					isEnabled: _isEnabled,
				),
			);
			return KeyEventResult.handled;
		}
		if (event.logicalKey == LogicalKeyboardKey.end) {
			setState(
				() => _highlightedIndex = KlpRovingIndex.last(
					count: count,
					isEnabled: _isEnabled,
				),
			);
			return KeyEventResult.handled;
		}
		if (event.logicalKey == LogicalKeyboardKey.enter ||
				event.logicalKey == LogicalKeyboardKey.numpadEnter ||
				event.logicalKey == LogicalKeyboardKey.space) {
			if (_highlightedIndex >= 0 && _highlightedIndex < count) {
				final item = widget.items[_highlightedIndex];
				if (item.enabled) item.onPressed();
			}
			return KeyEventResult.handled;
		}
		if (event.logicalKey == LogicalKeyboardKey.escape) {
			widget.onEscape?.call();
			return KeyEventResult.handled;
		}

		return KeyEventResult.ignored;
	}

	@override
	Widget build(BuildContext context) {
		final tokens = context.klpColors;
		final items = widget.items;

		return KlpFocusRegion(
			autofocus: widget.autofocus,
			onKeyEvent: _handleKey,
			child: KlpSurface(
				key: const ValueKey('pln-menu-elevation'),
				tone: KlpSurfaceTone.overlay,
				radius: _KlpMenuMetrics.panelRadius(context),
				shadows: [
						BoxShadow(
							color: tokens.modalScrim.withValues(
								alpha: context.klp.surface.overlayShadowOpacity,
							),
							blurRadius: _KlpMenuMetrics.menuBlurRadius(context),
							spreadRadius: context.klp.surface.overlaySpread,
							offset: Offset(0, _KlpMenuMetrics.menuOffsetY(context)),
						),
				],
				child: KlpBox(
					width: _KlpMenuMetrics.width(context),
					child: KlpBox(
						insets: KlpBoxInsets.uniform(context.klp.space.tight),
						child: KlpColumn(
							mainAxisSize: MainAxisSize.min,
							crossAxisAlignment: CrossAxisAlignment.stretch,
							children: [
								KlpBox(
									height: _KlpMenuMetrics.headerHeight(context),
									child: KlpBox(
										insets: KlpBoxInsets.directional(
											start: _KlpMenuMetrics.horizontalPadding(context),
											end: _KlpMenuMetrics.horizontalPadding(context),
										),
										child: KlpAlign(
											alignment: Alignment.centerLeft,
											child: KlpText(
												widget.label,
												role: KlpMenuStyle.textRole,
												tone: KlpTextTone.muted,
											),
										),
									),
								),
								KlpBox(height: context.klp.space.tight),
								for (var index = 0; index < items.length; index++) ...[
									if (items[index].separatedBefore ||
											items[index].dashedSeparatorBefore)
										KlpBox(
											marginInsets: KlpBoxInsets.directional(
												top: context.klp.space.tight,
												bottom: context.klp.space.tight,
											),
											child: items[index].dashedSeparatorBefore
													? const KlpDashedDivider()
													: const KlpDivider(),
										),
									KlpMenuItem(
										key: items[index].key,
										data: items[index],
										keyboardHighlighted: index == _highlightedIndex,
									),
								],
							],
						),
					),
				),
			),
		);
	}
}
