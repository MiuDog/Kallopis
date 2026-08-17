import 'package:flutter/widgets.dart';

import '../controls/klp_button.dart';
import '../foundation/klp_metrics.dart';
import '../surface/klp_surface.dart';
import '../typography/klp_text.dart';

enum KlpFieldVisualState {
  pristine,
  dirty,
  touched,
  focused,
  validating,
  valid,
  invalid,
  disabled,
  readOnly,
  conflict,
}

class KlpForm extends StatelessWidget {
  const KlpForm({
    super.key,
    required this.sections,
    this.errorSummary,
    this.actions,
  });

  final List<Widget> sections;
  final Widget? errorSummary;
  final Widget? actions;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (errorSummary != null) ...[
          errorSummary!,
          const SizedBox(height: KlpSpace.md),
        ],
        for (var index = 0; index < sections.length; index++) ...[
          sections[index],
          if (index < sections.length - 1) const SizedBox(height: KlpSpace.lg),
        ],
        if (actions != null) ...[const SizedBox(height: KlpSpace.lg), actions!],
      ],
    );
  }
}

class KlpFormSection extends StatelessWidget {
  const KlpFormSection({
    super.key,
    required this.title,
    required this.children,
    this.description,
    this.collapsed = false,
    this.onToggle,
  });

  final String title;
  final String? description;
  final List<Widget> children;
  final bool collapsed;
  final VoidCallback? onToggle;

  @override
  Widget build(BuildContext context) {
    return KlpSurface(
      tone: KlpSurfaceTone.component,
      padding: const EdgeInsets.all(KlpSpace.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: onToggle,
            child: KlpText(title, role: KlpTextRole.section),
          ),
          if (description != null) ...[
            const SizedBox(height: KlpSpace.xs),
            KlpText(
              description!,
              role: KlpTextRole.caption,
              tone: KlpTextTone.muted,
            ),
          ],
          if (!collapsed)
            for (final child in children) ...[
              const SizedBox(height: KlpSpace.md),
              child,
            ],
        ],
      ),
    );
  }
}

class KlpField extends StatelessWidget {
  const KlpField({
    super.key,
    required this.label,
    required this.child,
    this.description,
    this.error,
    this.requirement,
  });

  final String label;
  final String? description;
  final String? error;
  final String? requirement;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Expanded(child: KlpFieldLabel(label: label)),
            if (requirement != null)
              KlpText(
                requirement!,
                role: KlpTextRole.caption,
                tone: KlpTextTone.faint,
              ),
          ],
        ),
        if (description != null) ...[
          const SizedBox(height: KlpSpace.xs),
          KlpFieldDescription(description: description!),
        ],
        const SizedBox(height: KlpSpace.xs),
        child,
        if (error != null) ...[
          const SizedBox(height: KlpSpace.xs),
          KlpFieldError(error: error!),
        ],
      ],
    );
  }
}

class KlpFieldLabel extends StatelessWidget {
  const KlpFieldLabel({super.key, required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return KlpText(label, role: KlpTextRole.caption);
  }
}

class KlpFieldDescription extends StatelessWidget {
  const KlpFieldDescription({super.key, required this.description});

  final String description;

  @override
  Widget build(BuildContext context) {
    return KlpText(
      description,
      role: KlpTextRole.caption,
      tone: KlpTextTone.muted,
    );
  }
}

class KlpFieldError extends StatelessWidget {
  const KlpFieldError({super.key, required this.error});

  final String error;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      liveRegion: true,
      child: KlpText(
        error,
        role: KlpTextRole.caption,
        tone: KlpTextTone.danger,
      ),
    );
  }
}

class KlpFormErrorSummary extends StatelessWidget {
  const KlpFormErrorSummary({
    super.key,
    required this.title,
    required this.errors,
    this.onSelected,
  });

  final String title;
  final Map<String, String> errors;
  final ValueChanged<String>? onSelected;

  @override
  Widget build(BuildContext context) {
    return KlpSurface(
      tone: KlpSurfaceTone.component,
      padding: const EdgeInsets.all(KlpSpace.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          KlpText(
            title,
            role: KlpTextRole.bodyStrong,
            tone: KlpTextTone.danger,
          ),
          const SizedBox(height: KlpSpace.xs),
          for (final error in errors.entries)
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: onSelected == null ? null : () => onSelected!(error.key),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: KlpSpace.xs),
                child: KlpText(
                  error.value,
                  role: KlpTextRole.caption,
                  tone: KlpTextTone.danger,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class KlpFormActions extends StatelessWidget {
  const KlpFormActions({
    super.key,
    required this.submitLabel,
    required this.onSubmit,
    this.cancelLabel,
    this.onCancel,
    this.resetLabel,
    this.onReset,
    this.submitting = false,
  });

  final String submitLabel;
  final VoidCallback? onSubmit;
  final String? cancelLabel;
  final VoidCallback? onCancel;
  final String? resetLabel;
  final VoidCallback? onReset;
  final bool submitting;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      alignment: WrapAlignment.end,
      spacing: KlpSpace.sm,
      runSpacing: KlpSpace.sm,
      children: [
        if (resetLabel != null)
          KlpButton(
            label: resetLabel!,
            tone: KlpButtonTone.ghost,
            onPressed: submitting ? null : onReset,
          ),
        if (cancelLabel != null)
          KlpButton(
            label: cancelLabel!,
            onPressed: submitting ? null : onCancel,
          ),
        KlpButton(
          label: submitLabel,
          tone: KlpButtonTone.primary,
          onPressed: submitting ? null : onSubmit,
        ),
      ],
    );
  }
}

class KlpFieldGroup extends StatelessWidget {
  const KlpFieldGroup({
    super.key,
    required this.legend,
    required this.children,
    this.error,
  });

  final String legend;
  final List<Widget> children;
  final String? error;

  @override
  Widget build(BuildContext context) {
    return KlpField(
      label: legend,
      error: error,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: children,
      ),
    );
  }
}

class KlpConditionalFieldRegion extends StatelessWidget {
  const KlpConditionalFieldRegion({
    super.key,
    required this.visible,
    required this.child,
  });

  final bool visible;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return AnimatedSize(
      duration: const Duration(milliseconds: 140),
      child: visible ? child : const SizedBox.shrink(),
    );
  }
}
