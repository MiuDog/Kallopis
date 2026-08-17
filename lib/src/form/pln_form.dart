import 'package:flutter/widgets.dart';

import '../controls/pln_button.dart';
import '../foundation/pln_metrics.dart';
import '../surface/pln_surface.dart';
import '../typography/pln_text.dart';

enum PlnFieldVisualState {
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

class PlnForm extends StatelessWidget {
  const PlnForm({
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
          const SizedBox(height: PlnSpace.md),
        ],
        for (var index = 0; index < sections.length; index++) ...[
          sections[index],
          if (index < sections.length - 1) const SizedBox(height: PlnSpace.lg),
        ],
        if (actions != null) ...[const SizedBox(height: PlnSpace.lg), actions!],
      ],
    );
  }
}

class PlnFormSection extends StatelessWidget {
  const PlnFormSection({
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
    return PlnSurface(
      tone: PlnSurfaceTone.component,
      padding: const EdgeInsets.all(PlnSpace.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: onToggle,
            child: PlnText(title, role: PlnTextRole.section),
          ),
          if (description != null) ...[
            const SizedBox(height: PlnSpace.xs),
            PlnText(
              description!,
              role: PlnTextRole.caption,
              tone: PlnTextTone.muted,
            ),
          ],
          if (!collapsed)
            for (final child in children) ...[
              const SizedBox(height: PlnSpace.md),
              child,
            ],
        ],
      ),
    );
  }
}

class PlnField extends StatelessWidget {
  const PlnField({
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
            Expanded(child: PlnFieldLabel(label: label)),
            if (requirement != null)
              PlnText(
                requirement!,
                role: PlnTextRole.caption,
                tone: PlnTextTone.faint,
              ),
          ],
        ),
        if (description != null) ...[
          const SizedBox(height: PlnSpace.xs),
          PlnFieldDescription(description: description!),
        ],
        const SizedBox(height: PlnSpace.xs),
        child,
        if (error != null) ...[
          const SizedBox(height: PlnSpace.xs),
          PlnFieldError(error: error!),
        ],
      ],
    );
  }
}

class PlnFieldLabel extends StatelessWidget {
  const PlnFieldLabel({super.key, required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return PlnText(label, role: PlnTextRole.caption);
  }
}

class PlnFieldDescription extends StatelessWidget {
  const PlnFieldDescription({super.key, required this.description});

  final String description;

  @override
  Widget build(BuildContext context) {
    return PlnText(
      description,
      role: PlnTextRole.caption,
      tone: PlnTextTone.muted,
    );
  }
}

class PlnFieldError extends StatelessWidget {
  const PlnFieldError({super.key, required this.error});

  final String error;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      liveRegion: true,
      child: PlnText(
        error,
        role: PlnTextRole.caption,
        tone: PlnTextTone.danger,
      ),
    );
  }
}

class PlnFormErrorSummary extends StatelessWidget {
  const PlnFormErrorSummary({
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
    return PlnSurface(
      tone: PlnSurfaceTone.component,
      padding: const EdgeInsets.all(PlnSpace.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          PlnText(
            title,
            role: PlnTextRole.bodyStrong,
            tone: PlnTextTone.danger,
          ),
          const SizedBox(height: PlnSpace.xs),
          for (final error in errors.entries)
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: onSelected == null ? null : () => onSelected!(error.key),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: PlnSpace.xs),
                child: PlnText(
                  error.value,
                  role: PlnTextRole.caption,
                  tone: PlnTextTone.danger,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class PlnFormActions extends StatelessWidget {
  const PlnFormActions({
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
      spacing: PlnSpace.sm,
      runSpacing: PlnSpace.sm,
      children: [
        if (resetLabel != null)
          PlnButton(
            label: resetLabel!,
            tone: PlnButtonTone.ghost,
            onPressed: submitting ? null : onReset,
          ),
        if (cancelLabel != null)
          PlnButton(
            label: cancelLabel!,
            onPressed: submitting ? null : onCancel,
          ),
        PlnButton(
          label: submitLabel,
          tone: PlnButtonTone.primary,
          onPressed: submitting ? null : onSubmit,
        ),
      ],
    );
  }
}

class PlnFieldGroup extends StatelessWidget {
  const PlnFieldGroup({
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
    return PlnField(
      label: legend,
      error: error,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: children,
      ),
    );
  }
}

class PlnConditionalFieldRegion extends StatelessWidget {
  const PlnConditionalFieldRegion({
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
