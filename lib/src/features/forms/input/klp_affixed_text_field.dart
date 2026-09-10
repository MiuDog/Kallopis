import '../internal/klp_form_dependencies.dart';
import '../internal/klp_input_frame.dart';
import '../internal/primitives/klp_input_action.dart';
import '../internal/primitives/klp_input_editor.dart';
import '../internal/primitives/klp_input_segment_divider.dart';

/// 在文字輸入旁提供不可編輯前綴與尾端語意動作。
class KlpAffixedTextField extends StatelessWidget {
	final String label;
	final TextEditingController? controller;
	final String? initialValue;
	final String? placeholder;
	final String? prefixText;
	final KlpIconData? actionIcon;
	final String? actionLabel;
	final VoidCallback? onAction;
	final ValueChanged<String>? onChanged;
	final bool enabled;
	final bool readOnly;
	final String? error;

	const KlpAffixedTextField({
		super.key,
		required this.label,
		this.controller,
		this.initialValue,
		this.placeholder,
		this.prefixText,
		this.actionIcon,
		this.actionLabel,
		this.onAction,
		this.onChanged,
		this.enabled = true,
		this.readOnly = false,
		this.error,
	}) : assert(controller == null || initialValue == null),
		 assert(actionIcon == null || actionLabel != null);

	@override
	Widget build(BuildContext context) {
		return KlpInputFrame(
			label: label,
			enabled: enabled,
			readOnly: readOnly,
			error: error,
			child: KlpRow(
				children: [
					if (prefixText != null) ...[
						KlpBox(
							insets: KlpBoxInsets.directional(
								start: context.klp.space.controlInset,
								end: context.klp.space.controlInset,
							),
							child: KlpText(prefixText!, role: KlpTextRole.code, tone: KlpTextTone.muted),
						),
						const KlpInputSegmentDivider(),
					],
					KlpExpanded(
						child: KlpInputEditor(
							controller: controller,
							initialValue: initialValue,
							placeholder: placeholder,
							onChanged: onChanged,
							enabled: enabled,
							readOnly: readOnly,
						),
					),
					if (actionIcon != null) ...[
						const KlpInputSegmentDivider(),
						KlpInputAction(
							icon: actionIcon!,
							label: actionLabel!,
							onPressed: enabled ? onAction : null,
						),
					],
				],
			),
		);
	}
}
