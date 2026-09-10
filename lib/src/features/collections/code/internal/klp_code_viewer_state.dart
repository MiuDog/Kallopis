part of '../klp_code_viewer.dart';

class _KlpCodeViewerState extends State<KlpCodeViewer> {
	late bool _wrapped;
	late bool _showLineNumbers;
	late bool _expanded;

	KlpCodeLanguageOption? get _currentLanguage {
		final language = widget.language?.trim().toLowerCase() ?? 'text';
		for (final option in widget.languageOptions) {
			if (option.id.toLowerCase() == language) return option;
		}
		return null;
	}

	String get _languageLabel {
		final language = widget.language?.trim();
		if (language != null && language.isNotEmpty) return language;

		return _currentLanguage?.id ?? 'text';
	}

	bool get _supportsView =>
			_currentLanguage?.supportsView == true && widget.onToggleView != null;

	@override
	void initState() {
		super.initState();
		_wrapped = widget.wrapped;
		_showLineNumbers = widget.showLineNumbers;
		_expanded = widget.expanded;
	}

	@override
	void didUpdateWidget(KlpCodeViewer oldWidget) {
		super.didUpdateWidget(oldWidget);
		if (oldWidget.wrapped != widget.wrapped) _wrapped = widget.wrapped;
		if (oldWidget.showLineNumbers != widget.showLineNumbers) {
			_showLineNumbers = widget.showLineNumbers;
		}
		if (oldWidget.expanded != widget.expanded) _expanded = widget.expanded;
	}

	@override
	Widget build(BuildContext context) {
		final style = _KlpCodeStyle.from(context);

		return _KlpCodeFrame(
			kind: _KlpCodeFrameKind.outer,
			style: style,
			child: KlpColumn(
				crossAxisAlignment: CrossAxisAlignment.stretch,
				children: [_buildHeader(style), _buildBody(style)],
			),
		);
	}

	Widget _buildHeader(_KlpCodeStyle style) {
		return _KlpCodeFrame(
			kind: _KlpCodeFrameKind.headerLeading,
			style: style,
			child: KlpRow(
				children: [
					_KlpTerminalMark(style: style),
					const KlpGap.widthSize(KlpSpaceSize.contentInline),
					_KlpCodeLanguageButton(
						key: const ValueKey('pln-code-language'),
						label: _languageLabel,
						enabled:
								widget.onLanguageChanged != null &&
								widget.languageOptions.isNotEmpty,
						onPressed: _openLanguageMenu,
						style: style,
					),
					const KlpSpacer(),
					if (widget.expandable)
						_KlpCodeActionButton(
							key: const ValueKey('pln-code-expand-toggle'),
							icon: _expanded ? KlpIcons.collapse : KlpIcons.maximize,
							label: _expanded
									? KlpLocalizations.of(context).codeViewerCollapseLabel
									: KlpLocalizations.of(context).codeViewerExpandLabel,
							selected: _expanded,
							onPressed: (_) => _toggleExpanded(),
							style: style,
						),
					if (_supportsView)
						_KlpCodeActionButton(
							key: const ValueKey('pln-code-view-toggle'),
							icon: KlpIcons.eye,
							label: widget.labels.toggleView,
							selected: widget.viewSelected,
							onPressed: (_) => widget.onToggleView?.call(),
							style: style,
						),
					_KlpCodeActionButton(
						key: const ValueKey('pln-code-copy'),
						icon: KlpIcons.clipboard,
						label: widget.labels.copy,
						onPressed: widget.onCopy == null
								? null
								: (_) => widget.onCopy?.call(),
						style: style,
					),
					_KlpCodeActionButton(
						key: const ValueKey('pln-code-menu'),
						icon: KlpIcons.menu,
						label: widget.labels.menu,
						onPressed: _openOptionsMenu,
						style: style,
					),
				],
			),
		);
	}

	Widget _buildBody(_KlpCodeStyle style) {
		return _KlpCodeViewport(
			kind: _KlpCodeViewportKind.viewer,
			style: style,
			limit: widget.viewportLimit,
			collapsed: widget.expandable && !_expanded,
			child: _resolveContent(),
		);
	}

	Widget _resolveContent() {
		if (widget.loading) {
			return const KlpText(
				'Loading...',
				role: KlpTextRole.code,
				tone: KlpTextTone.muted,
			);
		}
		if (widget.content != null) return widget.content!;

		return _KlpCodeLines(
			code: widget.code,
			startLine: widget.startLine,
			wrapped: _wrapped,
			showLineNumbers: _showLineNumbers,
		);
	}

	void _toggleExpanded() {
		setState(() => _expanded = !_expanded);
		widget.onToggleExpand?.call();
	}

	Future<void> _openLanguageMenu(BuildContext context) async {
		if (widget.onLanguageChanged == null || widget.languageOptions.isEmpty) {
			return;
		}

		final items = [
			for (var index = 0; index < widget.languageOptions.length; index++)
				KlpMenuItemData(
					key: ValueKey(
						'pln-code-language-${widget.languageOptions[index].id}',
					),
					label: widget.languageOptions[index].label,
					selected:
							widget.languageOptions[index].id ==
							(_currentLanguage?.id ?? widget.language),
					onPressed: () {},
				),
		];
		final selectedIndex = await _KlpCodeMenuPresenter.show(
			context,
			label: widget.labels.languageMenu,
			items: items,
			barrierLabel: widget.labels.menu,
		);
		if (selectedIndex == null || !mounted) return;

		widget.onLanguageChanged!(widget.languageOptions[selectedIndex].id);
	}

	Future<void> _openOptionsMenu(BuildContext context) async {
		final items = [
			KlpMenuItemData(
				key: const ValueKey('pln-code-menu-wrap'),
				label: widget.labels.wrap,
				toggleValue: _wrapped,
				onPressed: () {},
			),
			KlpMenuItemData(
				key: const ValueKey('pln-code-menu-line-numbers'),
				label: widget.labels.lineNumbers,
				toggleValue: _showLineNumbers,
				onPressed: () {},
			),
		];
		final selectedIndex = await _KlpCodeMenuPresenter.show(
			context,
			label: widget.labels.menu,
			items: items,
			barrierLabel: widget.labels.menu,
		);
		if (selectedIndex == null || !mounted) return;

		setState(() {
			if (selectedIndex == 0) _wrapped = !_wrapped;
			if (selectedIndex == 1) _showLineNumbers = !_showLineNumbers;
		});
		if (selectedIndex == 0) widget.onToggleWrap?.call();
		if (selectedIndex == 1) widget.onToggleLineNumbers?.call();
	}
}
