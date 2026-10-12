part of '../klp_dock_header.dart';

/// 標頭捲動與 overflow menu 生命週期，不持有布局保存資料。
class _KlpDockHeaderState extends State<KlpDockHeader> {
	/// 原生橫向標頭 viewport 與同一份更多選單控制器。
	final ScrollController _scrollController = ScrollController();
	final KlpContextMenuController _menuController = KlpContextMenuController();

	@override
	void dispose() {
		_scrollController.dispose();
		super.dispose();
	}

	void _handlePointerSignal(PointerSignalEvent event) {
		if (event is! PointerScrollEvent || !_scrollController.hasClients) return;

		final position = _scrollController.position;
		final delta = event.scrollDelta.dy != 0
				? event.scrollDelta.dy
				: event.scrollDelta.dx;
		final nextOffset = (_scrollController.offset + delta)
				.clamp(position.minScrollExtent, position.maxScrollExtent)
				.toDouble();

		_scrollController.jumpTo(nextOffset);
	}

	@override
	Widget build(BuildContext context) {
		final moreActionsLabel = KlpLocalizations.of(context).dockMoreActionsLabel;
		return KlpBox(
			height: context.klp.space.chromeTab,
			child: KlpLayoutBuilder(
				builder: (context, constraints) {
					final actionSlotExtent = context.klp.space.iconButton;
					// 零圖示尺寸仍以現有標頭配額保留 more 的可操作槽。
					final fallbackExtent = constraints.maxHeight.clamp(0.0, constraints.maxWidth).toDouble();
					final totalSlots = actionSlotExtent > 0
							? (constraints.maxWidth / actionSlotExtent).clamp(0, widget.actions.length + 1).floor()
							: 0;
					final maxActionSlots = (totalSlots - 1).clamp(
						0,
						widget.actions.length,
					);
					final needsOverflow = widget.actions.length > maxActionSlots;
					final visibleCount = needsOverflow
							? (maxActionSlots - 1).clamp(0, widget.actions.length)
							: widget.actions.length;
					final visibleActions = widget.actions
							.take(visibleCount)
							.toList(growable: false);
					final overflowActions = widget.actions
							.skip(visibleCount)
							.toList(growable: false);
					final leading = _KlpDockHeaderViewport(
						controller: _scrollController,
						onPointerSignal: _handlePointerSignal,
						child: widget.leading,
					);
					return KlpPanelHeader(
						content: leading,
						dragRegionBuilder: widget.dragRegionBuilder,
						actions: [
							for (final action in visibleActions)
								KlpIconButton(
									icon: action.icon,
									label: action.label,
									onPressed: action.enabled ? action.onPressed : null,
									tone: KlpIconButtonTone.inline,
								),
							if (overflowActions.isNotEmpty)
								_KlpDockContextBuilder(
									builder: (buttonContext) => KlpContextMenu(
										controller: _menuController,
										label: moreActionsLabel,
										items: [
											for (final action in overflowActions)
												KlpMenuItemData(
													icon: action.icon,
													label: action.label,
													enabled: action.enabled,
													onPressed: action.onPressed,
												),
										],
										child: SizedBox(
											width: actionSlotExtent == 0 ? fallbackExtent : null,
											height: actionSlotExtent == 0 ? fallbackExtent : null,
											child: KlpIconButton(
												icon: KlpIcons.more,
												label: moreActionsLabel,
												tone: KlpIconButtonTone.inline,
												onPressed: () {
													final renderObject = buttonContext.findRenderObject();
													if (renderObject is! RenderBox) return;

													_menuController.openAt(
														renderObject.localToGlobal(
															Offset(0, renderObject.size.height),
													),
												);
											},
											),
										),
									),
								),
						],
					);
				},
			),
		);
	}
}
