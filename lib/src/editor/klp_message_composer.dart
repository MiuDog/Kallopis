import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../controls/klp_button.dart';
import '../foundation/klp_metrics.dart';
import '../theme/klp_theme.dart';
import '../typography/klp_text.dart';

class KlpMessageComposer extends StatefulWidget {
  const KlpMessageComposer({
    super.key,
    required this.placeholder,
    required this.sendLabel,
    required this.onSend,
    this.controller,
    this.onChanged,
    this.enabled = true,
  });

  final String placeholder;
  final String sendLabel;
  final ValueChanged<String>? onSend;
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;
  final bool enabled;

  @override
  State<KlpMessageComposer> createState() => _KlpMessageComposerState();
}

class _KlpMessageComposerState extends State<KlpMessageComposer> {
  late TextEditingController _controller;

  bool get _ownsController => widget.controller == null;

  bool get _canSend {
    return widget.enabled &&
        widget.onSend != null &&
        _controller.text.trim().isNotEmpty;
  }

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? TextEditingController();
  }

  @override
  void didUpdateWidget(covariant KlpMessageComposer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller == widget.controller) return;

    if (oldWidget.controller == null) _controller.dispose();
    _controller = widget.controller ?? TextEditingController();
  }

  @override
  void dispose() {
    if (_ownsController) _controller.dispose();
    super.dispose();
  }

  void _handleChanged(String value) {
    setState(() {});
    widget.onChanged?.call(value);
  }

  void _handleSend() {
    if (!_canSend) return;

    final message = _controller.text.trim();
    widget.onSend?.call(message);
    _controller.clear();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final tokens = context.plnTheme;

    return DecoratedBox(
      key: const ValueKey('pln-message-composer-frame'),
      decoration: BoxDecoration(
        color: tokens.component,
        borderRadius: BorderRadius.circular(KlpRadius.card),
      ),
      child: Padding(
        padding: const EdgeInsets.all(KlpSpace.sm),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: CallbackShortcuts(
                bindings: {
                  const SingleActivator(
                    LogicalKeyboardKey.enter,
                    control: true,
                  ): _handleSend,
                },
                child: TextField(
                  controller: _controller,
                  enabled: widget.enabled,
                  onChanged: _handleChanged,
                  minLines: 1,
                  maxLines: 4,
                  expands: false,
                  keyboardType: TextInputType.multiline,
                  textInputAction: TextInputAction.newline,
                  style: TextStyle(
                    color: tokens.text,
                    fontSize: KlpTypography.body,
                    height: KlpTypography.compactLineHeight,
                  ),
                  cursorColor: tokens.interaction,
                  decoration: InputDecoration(
                    isDense: true,
                    hintText: widget.placeholder,
                    hintStyle: TextStyle(color: tokens.textFaint),
                    contentPadding: EdgeInsets.zero,
                    border: KlpFieldStyle.border,
                    enabledBorder: KlpFieldStyle.border,
                    focusedBorder: KlpFieldStyle.border,
                  ),
                ),
              ),
            ),
            const SizedBox(height: KlpSpace.sm),
            Row(
              children: [
                const Expanded(
                  child: KlpText(
                    'Ctrl+Enter · send',
                    role: KlpTextRole.label,
                    tone: KlpTextTone.faint,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: KlpSpace.sm),
                KlpButton(
                  label: widget.sendLabel,
                  onPressed: _canSend ? _handleSend : null,
                  tone: KlpButtonTone.primary,
                  compact: true,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
