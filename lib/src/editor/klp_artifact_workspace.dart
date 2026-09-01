import 'package:flutter/material.dart';

import '../controls/klp_button.dart';
import '../data/klp_advanced_data.dart';
import '../data/klp_badge.dart';
import '../data/klp_preview_card.dart';
import '../feedback/klp_feedback_tone.dart';
import '../feedback/klp_inline_notice.dart';
import '../form/klp_form.dart';
import '../navigation/klp_tabs.dart';
import '../surface/klp_surface.dart';
import '../theme/klp_theme.dart';
import '../typography/klp_text.dart';

/// 結構化文件的標頭；修訂與狀態文字由產品提供。
class KlpDocumentHeader extends StatelessWidget {
	const KlpDocumentHeader({
		super.key,
		required this.title,
		required this.revisionLabel,
		required this.statusLabel,
		this.stale = false,
		this.actions = const [],
	});

	final String title;
	final String revisionLabel;
	final String statusLabel;
	final bool stale;
	final List<Widget> actions;

	@override
	Widget build(BuildContext context) => Row(
		children: [
			Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [KlpText(title, role: KlpTextRole.title), SizedBox(height: context.klp.space.tight), Wrap(spacing: context.klp.space.tight, children: [KlpBadge(label: revisionLabel, tone: stale ? KlpFeedbackTone.warning : KlpFeedbackTone.neutral), KlpBadge(label: statusLabel)])])),
		if (actions.isNotEmpty) Wrap(spacing: context.klp.space.tight, children: actions),
	],
	);
}

/// 文件的單一語意章節；可選的動作不改變章節資料所有權。
class KlpDocumentSection extends StatelessWidget {
	const KlpDocumentSection({super.key, required this.title, required this.child, this.description, this.actions = const []});

	final String title;
	final String? description;
	final Widget child;
	final List<Widget> actions;

	@override
	Widget build(BuildContext context) => Semantics(
		header: true,
		container: true,
		child: Column(
			crossAxisAlignment: CrossAxisAlignment.stretch,
			children: [
				Row(children: [Expanded(child: KlpText(title, role: KlpTextRole.bodyStrong)), if (actions.isNotEmpty) Wrap(spacing: context.klp.space.tight, children: actions)]),
				if (description != null) ...[SizedBox(height: context.klp.space.tight), KlpText(description!, role: KlpTextRole.sub, tone: KlpTextTone.muted)],
				SizedBox(height: context.klp.space.compact),
				child,
			],
		),
	);
}

/// 文件欄位的標籤、值、說明與驗證組合。
class KlpDocumentField extends StatelessWidget {
	const KlpDocumentField({super.key, required this.label, required this.value, this.help, this.error});

	final String label;
	final Widget value;
	final String? help;
	final String? error;

	@override
	Widget build(BuildContext context) => KlpField(label: label, description: help, error: error, child: value);
}

/// 指向另一個 canonical artifact 的可及性連結。
class KlpDocumentReferenceLink extends StatelessWidget {
	const KlpDocumentReferenceLink({super.key, required this.label, required this.onPressed, this.detail});

	final String label;
	final String? detail;
	final VoidCallback? onPressed;

	@override
	Widget build(BuildContext context) => Semantics(
		link: true,
		button: true,
		child: KlpButton(label: detail == null ? label : '$label · $detail', tone: KlpButtonTone.ghost, compact: true, onPressed: onPressed),
	);
}

/// 文件的進入編輯、儲存與取消動作組。
class KlpDocumentEditActions extends StatelessWidget {
	const KlpDocumentEditActions({
		super.key,
		required this.editing,
		required this.editLabel,
		required this.saveLabel,
		required this.cancelLabel,
		this.onEdit,
		this.onSave,
		this.onCancel,
	});

	final bool editing;
	final String editLabel;
	final String saveLabel;
	final String cancelLabel;
	final VoidCallback? onEdit;
	final VoidCallback? onSave;
	final VoidCallback? onCancel;

	@override
	Widget build(BuildContext context) => Wrap(
		spacing: context.klp.space.tight,
		children: editing
				? [KlpButton(label: saveLabel, onPressed: onSave), KlpButton(label: cancelLabel, tone: KlpButtonTone.ghost, onPressed: onCancel)]
				: [KlpButton(label: editLabel, onPressed: onEdit)],
	);
}

/// 一筆產品中立的 Token 呈現資料。
@immutable
class KlpTokenDefinitionData {
	const KlpTokenDefinitionData({required this.name, required this.typeLabel, required this.valueLabel, required this.statusLabel, this.referenceLabel, this.preview});

	final String name;
	final String typeLabel;
	final String valueLabel;
	final String statusLabel;
	final String? referenceLabel;
	final Widget? preview;
}

/// 可排序 Token 清單的表格呈現；排序狀態由呼叫端持有。
class KlpTokenTable extends StatelessWidget {
	const KlpTokenTable({
		super.key,
		required this.tokens,
		required this.nameLabel,
		required this.typeLabel,
		required this.valueLabel,
		required this.referenceLabel,
		required this.statusLabel,
	});

	final List<KlpTokenDefinitionData> tokens;
	final String nameLabel;
	final String typeLabel;
	final String valueLabel;
	final String referenceLabel;
	final String statusLabel;

	@override
	Widget build(BuildContext context) => KlpDataTable(
		columns: [KlpDataColumn(id: 'name', label: nameLabel), KlpDataColumn(id: 'type', label: typeLabel), KlpDataColumn(id: 'value', label: valueLabel), KlpDataColumn(id: 'reference', label: referenceLabel), KlpDataColumn(id: 'status', label: statusLabel)],
		rows: [
			for (final token in tokens)
				KlpDataRow(id: token.name, cells: {'name': KlpText(token.name, role: KlpTextRole.code), 'type': KlpText(token.typeLabel), 'value': Row(children: [if (token.preview != null) ...[token.preview!, SizedBox(width: context.klp.space.tight)], Flexible(child: KlpText(token.valueLabel))]), 'reference': KlpText(token.referenceLabel ?? ''), 'status': KlpBadge(label: token.statusLabel)}),
		],
	);
}

/// Token 圖形驗證結果，不自行推導循環或型別相容性。
class KlpTokenValidationBanner extends StatelessWidget {
	const KlpTokenValidationBanner({super.key, required this.title, required this.message, required this.valid});

	final String title;
	final String message;
	final bool valid;

	@override
	Widget build(BuildContext context) => KlpInlineNotice(title: title, message: message, tone: valid ? KlpFeedbackTone.success : KlpFeedbackTone.danger);
}

/// 一個元件定義的產品中立預覽資料。
@immutable
class KlpComponentDefinitionData {
	const KlpComponentDefinitionData({required this.id, required this.name, required this.statusLabel, required this.preview, this.description});

	final String id;
	final String name;
	final String statusLabel;
	final String? description;
	final Widget preview;
}

/// 元件定義卡，不持有元件文件或 instance override。
class KlpComponentDefinitionCard extends StatelessWidget {
	const KlpComponentDefinitionCard({super.key, required this.data, this.onPressed});

	final KlpComponentDefinitionData data;
	final VoidCallback? onPressed;

	@override
	Widget build(BuildContext context) => Semantics(
		button: onPressed != null,
		label: data.name,
		child: GestureDetector(
			behavior: HitTestBehavior.opaque,
			onTap: onPressed,
			child: KlpPreviewCard(
				title: data.name,
				preview: data.preview,
				metadata: [if (data.description != null) data.description!, data.statusLabel],
			),
		),
	);
}

/// 元件定義的響應式預覽網格。
class KlpComponentLibraryGrid extends StatelessWidget {
	const KlpComponentLibraryGrid({super.key, required this.components, this.onSelected});

	final List<KlpComponentDefinitionData> components;
	final ValueChanged<String>? onSelected;

	@override
	Widget build(BuildContext context) => LayoutBuilder(
		builder: (context, constraints) => Wrap(
			spacing: context.klp.space.base,
			runSpacing: context.klp.space.base,
			children: [
				for (final component in components)
					KlpComponentDefinitionCard(data: component, onPressed: onSelected == null ? null : () => onSelected!(component.id)),
			],
		),
	);
}

/// 元件的狀態切換器；狀態值與標籤皆由呼叫端定義。
class KlpComponentStateSelector extends StatelessWidget {
	const KlpComponentStateSelector({super.key, required this.labels, required this.selectedIndex, required this.onSelected});

	final List<String> labels;
	final int selectedIndex;
	final ValueChanged<int> onSelected;

	@override
	Widget build(BuildContext context) => KlpTabs(tabs: labels, selected: selectedIndex, onSelected: onSelected);
}

/// 元件可及性合約表面，內容由產品的元件定義投影而來。
class KlpAccessibilityContractPanel extends StatelessWidget {
	const KlpAccessibilityContractPanel({super.key, required this.title, required this.items});

	final String title;
	final Map<String, String> items;

	@override
	Widget build(BuildContext context) => KlpSurface(
		tone: KlpSurfaceTone.inset,
		padding: EdgeInsets.all(context.klp.space.base),
		child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [KlpText(title, role: KlpTextRole.bodyStrong), SizedBox(height: context.klp.space.compact), for (final item in items.entries) Padding(padding: EdgeInsets.only(bottom: context.klp.space.tight), child: Row(children: [Expanded(child: KlpText(item.key, tone: KlpTextTone.muted)), KlpText(item.value, role: KlpTextRole.code)]))]),
	);
}
