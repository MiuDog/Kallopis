import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:kallopis/src/features/actions/button/klp_icon_button.dart';
import 'package:kallopis/src/foundation/content/klp_text.dart';
import 'package:kallopis/src/foundation/interaction/klp_focus_region.dart';
import 'package:kallopis/src/foundation/interaction/klp_roving_index.dart';
import 'package:kallopis/src/foundation/klp_icons.dart';
import 'package:kallopis/src/foundation/localization/klp_localizations.dart';
import 'package:kallopis/src/styling/legacy_theme/klp_theme.dart';

/// 一份文件分頁的不可變顯示資料；文件生命週期仍由 consumer 擁有。
final class KlpDocumentTab {
	KlpDocumentTab({
		required this.id,
		required this.label,
		this.dirty = false,
		this.closable = true,
		this.pinned = false,
	}) {
		if (id.trim().isEmpty) throw ArgumentError.value(id, 'id', 'Document tab id must not be empty.');
		if (label.trim().isEmpty) throw ArgumentError.value(label, 'label', 'Document tab label must not be empty.');
	}

	final String id;
	final String label;
	final bool dirty;
	final bool closable;
	final bool pinned;
}

/// 具修改狀態、釘選與關閉動作的受控文件分頁列。
///
/// 本元件只回報操作意圖；選取、關閉與釘選結果必須由 consumer 更新 [tabs] 或
/// [selectedId] 後再傳回。
final class KlpDocumentTabs extends StatelessWidget {
	KlpDocumentTabs({
		super.key,
		required List<KlpDocumentTab> tabs,
		this.selectedId,
		this.onSelected,
		this.onClose,
		this.onPinnedChanged,
	}) : tabs = List.unmodifiable(tabs) {
		final ids = <String>{};
		for (final tab in tabs) {
			if (!ids.add(tab.id)) throw ArgumentError.value(tab.id, 'tabs', 'Document tab ids must be unique.');
		}
	}

	final List<KlpDocumentTab> tabs;
	final String? selectedId;
	final ValueChanged<String>? onSelected;
	final ValueChanged<String>? onClose;
	final void Function(String id, bool pinned)? onPinnedChanged;

	KeyEventResult _handleKey(FocusNode node, KeyEvent event) {
		if (event is! KeyDownEvent || tabs.isEmpty || onSelected == null) return KeyEventResult.ignored;

		final forward = switch (event.logicalKey) {
			LogicalKeyboardKey.arrowRight => true,
			LogicalKeyboardKey.arrowLeft => false,
			_ => null,
		};
		if (forward == null) return KeyEventResult.ignored;

		final current = tabs.indexWhere((tab) => tab.id == selectedId);
		final next = KlpRovingIndex.move(current: current, count: tabs.length, forward: forward);
		onSelected!(tabs[next].id);
		return KeyEventResult.handled;
	}

	@override
	Widget build(BuildContext context) {
		final klp = context.klp;
		return KlpFocusRegion(
			onKeyEvent: _handleKey,
			child: ColoredBox(
				color: context.klpColors.surfaceInset,
				child: SizedBox(
					height: klp.space.chromeTab,
					child: ListView.separated(
						scrollDirection: Axis.horizontal,
						padding: EdgeInsets.symmetric(horizontal: klp.space.space2),
						itemCount: tabs.length,
						separatorBuilder: (context, index) => SizedBox(width: klp.space.space2),
						itemBuilder: (context, index) => _DocumentTab(
							tab: tabs[index],
							selected: tabs[index].id == selectedId,
							onSelected: onSelected,
							onClose: onClose,
							onPinnedChanged: onPinnedChanged,
						),
					),
				),
			),
		);
	}
}

final class _DocumentTab extends StatelessWidget {
	const _DocumentTab({
		required this.tab,
		required this.selected,
		required this.onSelected,
		required this.onClose,
		required this.onPinnedChanged,
	});

	final KlpDocumentTab tab;
	final bool selected;
	final ValueChanged<String>? onSelected;
	final ValueChanged<String>? onClose;
	final void Function(String id, bool pinned)? onPinnedChanged;

	@override
	Widget build(BuildContext context) {
		final klp = context.klp;
		final strings = KlpLocalizations.of(context);
		final semanticLabel = tab.dirty ? '${tab.label}, ${strings.documentTabModifiedLabel}' : tab.label;
		return Material(
			color: selected ? context.klpColors.surfaceMuted : context.klpColors.surfaceInset,
			borderRadius: BorderRadius.circular(klp.shape.control),
			clipBehavior: Clip.antiAlias,
			child: Row(
				mainAxisSize: MainAxisSize.min,
				children: [
					Semantics(
						button: true,
						selected: selected,
						enabled: onSelected != null,
						label: semanticLabel,
						excludeSemantics: true,
						child: InkWell(
							onTap: onSelected == null ? null : () => onSelected!(tab.id),
							child: SizedBox(
								height: klp.space.chromeTab,
								child: Padding(
									padding: EdgeInsets.symmetric(horizontal: klp.space.space2),
									child: Row(
										mainAxisSize: MainAxisSize.min,
										children: [
											KlpText(tab.label, role: KlpTextRole.body, tone: selected ? KlpTextTone.primary : KlpTextTone.muted),
											if (tab.dirty) const KlpText(' •', role: KlpTextRole.body, tone: KlpTextTone.muted),
										],
									),
								),
							),
						),
					),
					KlpIconButton(
						icon: KlpIcons.bookmark,
						label: '${tab.pinned ? strings.documentTabUnpinLabel : strings.documentTabPinLabel} ${tab.label}',
						onPressed: onPinnedChanged == null ? null : () => onPinnedChanged!(tab.id, !tab.pinned),
						selected: tab.pinned,
						tone: KlpIconButtonTone.inline,
					),
					if (tab.closable)
						KlpIconButton(
							icon: KlpIcons.close,
							label: '${strings.documentTabCloseLabel} ${tab.label}',
							onPressed: onClose == null ? null : () => onClose!(tab.id),
							tone: KlpIconButtonTone.inline,
						),
				],
			),
		);
	}
}
