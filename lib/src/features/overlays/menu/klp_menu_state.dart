part of '../klp_menu.dart';

class _KlpMenuState extends State<KlpMenu> {
	int _highlightedIndex = -1;
	final _scrollController = ScrollController();
	final _itemKeys = <int, GlobalKey>{};
	String _query = '';
	late final _searchFocus = FocusNode(onKeyEvent: (node, event) {
		// 搜尋輸入保留文字的 Home／End／空白，只攔截清單導覽按鍵。
		if (event.logicalKey == LogicalKeyboardKey.home || event.logicalKey == LogicalKeyboardKey.end || event.logicalKey == LogicalKeyboardKey.space) return KeyEventResult.ignored;
		return _handleKey(node, event);
	});

	List<KlpMenuItemData> get _visibleItems {
		final query = _query.trim().toLowerCase();
		if (query.isEmpty) return widget.items;
		return widget.items.where((item) => '${item.label} ${item.description ?? ''} ${item.group ?? ''}'.toLowerCase().contains(query)).toList();
	}

	void _search(String value) {
		setState(() {
			_query = value;
			_highlightedIndex = _visibleItems.indexWhere((item) => item.enabled);
		});
		if (_scrollController.hasClients) _scrollController.jumpTo(0);
	}

	@override
	void dispose() {
		_scrollController.dispose();
		_searchFocus.dispose();
		super.dispose();
	}

	Widget _section(BuildContext context, String label) => SizedBox(
		height: _KlpMenuMetrics.headerHeight(context) + context.klp.space.tight,
		child: Padding(
			padding: EdgeInsets.symmetric(horizontal: _KlpMenuMetrics.horizontalPadding(context)),
			child: Align(alignment: Alignment.centerLeft, child: KlpText(label, role: KlpMenuStyle.textRole, tone: KlpTextTone.muted)),
		),
	);

	Widget _scrollableContent(BuildContext context, Widget content) {
		final thickness = context.klp.geometry.control.scrollbarThickness;
		final gutter = thickness + context.klp.space.tight;
		// 桌面平台只保留此處的捲動條；內容與捲動軌道各自占用空間。
		return ScrollConfiguration(behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false), child: Scrollbar(
			controller: _scrollController,
			thumbVisibility: true,
			thickness: thickness,
			child: SingleChildScrollView(controller: _scrollController, child: Padding(padding: EdgeInsets.only(right: gutter), child: content)),
		));
	}

	bool _isEnabled(int index) => _visibleItems[index].enabled;

	KeyEventResult _handleKey(FocusNode node, KeyEvent event) {
		if (event is! KeyDownEvent) return KeyEventResult.ignored;
		if (event.logicalKey == LogicalKeyboardKey.escape) {
			widget.onEscape?.call();
			return KeyEventResult.handled;
		}
		if (_searchFocus.hasFocus && (event.logicalKey == LogicalKeyboardKey.home || event.logicalKey == LogicalKeyboardKey.end || event.logicalKey == LogicalKeyboardKey.space)) return KeyEventResult.ignored;
		final count = _visibleItems.length;
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
				final item = _visibleItems[_highlightedIndex];
				if (item.enabled) item.onPressed();
			}
			return KeyEventResult.handled;
		}

		return KeyEventResult.ignored;
	}

	@override
	Widget build(BuildContext context) {
		final tokens = context.klpColors;
		final items = _visibleItems;
		final grouped = items.any((item) => item.group != null);
		if (widget.scrollable && _highlightedIndex >= 0) {
			WidgetsBinding.instance.addPostFrameCallback((_) {
				if (!mounted) return;
				final target = _itemKeys[_highlightedIndex]?.currentContext;
				if (target != null) Scrollable.ensureVisible(target);
			});
		}
		final content = Column(
			mainAxisSize: MainAxisSize.min,
			crossAxisAlignment: CrossAxisAlignment.stretch,
			children: [
				if (!grouped && !widget.searchable) _section(context, widget.label),
				if (items.isEmpty) _section(context, '沒有符合的元件'),
				for (var index = 0; index < items.length; index++) ...[
					if (items[index].group != null && (index == 0 || items[index - 1].group != items[index].group))
						_section(context, items[index].group!),
					if (items[index].separatedBefore || items[index].dashedSeparatorBefore)
						Padding(
							padding: EdgeInsets.symmetric(vertical: context.klp.space.tight),
							child: items[index].dashedSeparatorBefore ? const KlpDashedDivider() : const KlpDivider(),
						),
					KeyedSubtree(
						key: _itemKeys.putIfAbsent(index, GlobalKey.new),
						child: KlpMenuItem(key: items[index].key, data: items[index], keyboardHighlighted: index == _highlightedIndex),
					),
				],
			],
		);

		return KlpFocusRegion(
			autofocus: widget.autofocus && !widget.searchable,
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
					width: KlpMenuLayout.widthForItems(context, widget.items, scrollable: widget.scrollable),
					child: Padding(
						padding: EdgeInsets.all(context.klp.space.tight),
						child: widget.searchable ? Column(children: [
							KlpTextField(placeholder: widget.searchPlaceholder, leadingIcon: KlpIcons.search, autofocus: widget.autofocus, focusNode: _searchFocus, onChanged: _search),
							SizedBox(height: context.klp.space.tight),
							Expanded(child: _scrollableContent(context, content)),
						]) : widget.scrollable ? _scrollableContent(context, content) : content,
					),
				),
			),
		);
	}
}
