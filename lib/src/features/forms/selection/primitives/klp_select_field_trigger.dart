part of '../klp_select_field.dart';

class _KlpSelectFieldTrigger extends StatelessWidget {
  const _KlpSelectFieldTrigger({
    required this.fillState,
    required this.enabled,
    required this.readOnly,
    required this.expanded,
    required this.onTap,
    required this.onHoverChanged,
    required this.onFocusChanged,
    required this.child,
  });

  final KlpFieldFillState fillState;
  final bool enabled;
  final bool readOnly;
  final bool expanded;
  final VoidCallback? onTap;
  final ValueChanged<bool> onHoverChanged;
  final ValueChanged<bool> onFocusChanged;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final klp = context.klp;
    final fill = KlpFieldStyle.colorFor(
      klp.color,
      fillState,
      surface: klp.surface,
    );

    return MouseRegion(
      onEnter: (_) => onHoverChanged(true),
      onExit: (_) => onHoverChanged(false),
      child: Focus(
        onFocusChange: onFocusChanged,
        child: Semantics(
          button: true,
          enabled: enabled,
          readOnly: readOnly,
          expanded: expanded,
          child: Material(
            color: fill,
            borderRadius: BorderRadius.circular(klp.fieldRadius),
            clipBehavior: Clip.antiAlias,
            child: InkWell(
              onTap: onTap,
              overlayColor: WidgetStatePropertyAll(klp.color.clear),
              child: SizedBox(
                height: klp.fieldHeight,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: klp.fieldPaddingX),
                  child: child,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
