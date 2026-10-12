part of '../klp_compound_field.dart';

class _KlpCompoundFieldOptionFrame extends StatelessWidget {
  const _KlpCompoundFieldOptionFrame({
    required this.enabled,
    required this.onTap,
    required this.child,
  });

  final bool enabled;
  final VoidCallback? onTap;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final klp = context.klp;

    return Material(
      type: MaterialType.transparency,
      child: InkWell(
        onTap: enabled ? onTap : null,
        overlayColor: WidgetStatePropertyAll(klp.color.clear),
        child: SizedBox(
          height: klp.fieldHeight,
          child: Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: klp.space.controlInset),
              child: child,
            ),
          ),
        ),
      ),
    );
  }
}
