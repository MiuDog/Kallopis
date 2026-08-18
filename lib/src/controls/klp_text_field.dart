import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../foundation/klp_icon.dart';
import '../foundation/klp_metrics.dart';
import '../theme/klp_theme.dart';
import '../typography/klp_text.dart';

class KlpTextField extends StatelessWidget {
  const KlpTextField({
    super.key,
    this.label,
    this.placeholder,
    this.helper,
    this.error,
    this.leadingIcon,
    this.initialValue,
    this.maxLength,
    this.onChanged,
    this.onSubmitted,
    this.focusNode,
    this.autofocus = false,
    this.enabled = true,
    this.multiline = false,
  }) : assert(maxLength == null || maxLength > 0);

  final String? label;
  final String? placeholder;
  final String? helper;
  final String? error;
  final String? leadingIcon;
  final String? initialValue;
  final int? maxLength;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final FocusNode? focusNode;
  final bool autofocus;
  final bool enabled;
  final bool multiline;

  @override
  Widget build(BuildContext context) {
    final tokens = context.klpColors;
    final hasError = error != null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (label != null) ...[
          KlpText(label!, role: KlpTextRole.caption),
          SizedBox(height: context.klp.space.tight),
        ],
        TextFormField(
          initialValue: initialValue,
          focusNode: focusNode,
          autofocus: autofocus,
          enabled: enabled,
          inputFormatters: maxLength == null
              ? null
              : [LengthLimitingTextInputFormatter(maxLength)],
          onChanged: onChanged,
          onFieldSubmitted: onSubmitted,
          minLines: multiline ? 4 : 1,
          maxLines: multiline ? 8 : 1,
          style: TextStyle(
            color: tokens.text,
            fontSize: context.klp.type.body,
            height: context.klp.type.captionLeading,
          ),
          cursorColor: tokens.interaction,
          decoration: InputDecoration(
            isDense: true,
            hintText: placeholder,
            hintStyle: TextStyle(color: tokens.textFaint),
            prefixIcon: leadingIcon == null
                ? null
                : Padding(
                    padding: EdgeInsets.all(context.klp.space.compact),
                    child: KlpIcon(leadingIcon!, color: tokens.textMuted),
                  ),
            prefixIconConstraints: const BoxConstraints(
              minWidth: KlpFormMetrics.fieldHeight,
              minHeight: KlpFormMetrics.fieldHeight,
            ),
            constraints: multiline
                ? null
                : const BoxConstraints.tightFor(
                    height: KlpFormMetrics.fieldHeight,
                  ),
            filled: true,
            fillColor: KlpFieldStyle.inputFill(tokens, error: hasError),
            contentPadding: context.klp.space.controlInsets,
          ),
        ),
        if (hasError || helper != null) ...[
          SizedBox(height: context.klp.space.tight),
          KlpText(
            error ?? helper!,
            role: KlpTextRole.caption,
            tone: hasError ? KlpTextTone.danger : KlpTextTone.muted,
          ),
        ],
      ],
    );
  }
}
