import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../foundation/pln_icon.dart';
import '../foundation/pln_metrics.dart';
import '../theme/pln_theme.dart';
import '../typography/pln_text.dart';

class PlnTextField extends StatelessWidget {
  const PlnTextField({
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
    final tokens = context.plnTheme;
    final hasError = error != null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (label != null) ...[
          PlnText(label!, role: PlnTextRole.caption),
          const SizedBox(height: PlnSpace.xs),
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
            fontSize: PlnTypography.body,
            height: PlnTypography.compactLineHeight,
          ),
          cursorColor: tokens.interaction,
          decoration: InputDecoration(
            isDense: true,
            hintText: placeholder,
            hintStyle: TextStyle(color: tokens.textFaint),
            prefixIcon: leadingIcon == null
                ? null
                : Padding(
                    padding: const EdgeInsets.all(PlnSpace.sm),
                    child: PlnIcon(leadingIcon!, color: tokens.textMuted),
                  ),
            prefixIconConstraints: const BoxConstraints(
              minWidth: PlnFormMetrics.fieldHeight,
              minHeight: PlnFormMetrics.fieldHeight,
            ),
            constraints: multiline
                ? null
                : const BoxConstraints.tightFor(
                    height: PlnFormMetrics.fieldHeight,
                  ),
            filled: true,
            fillColor: PlnFieldStyle.inputFill(tokens, error: hasError),
            contentPadding: PlnInsets.control,
          ),
        ),
        if (hasError || helper != null) ...[
          const SizedBox(height: PlnSpace.xs),
          PlnText(
            error ?? helper!,
            role: PlnTextRole.caption,
            tone: hasError ? PlnTextTone.danger : PlnTextTone.muted,
          ),
        ],
      ],
    );
  }
}
