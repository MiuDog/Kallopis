part of '../klp_compound_field.dart';

class _KlpCompoundFieldOptionsPanel extends StatelessWidget {
  const _KlpCompoundFieldOptionsPanel({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final klp = context.klp;

    return Container(
      padding: EdgeInsets.all(klp.space.tight),
      decoration: BoxDecoration(
        color: klp.color.component,
        borderRadius: BorderRadius.circular(klp.shape.card),
      ),
      child: child,
    );
  }
}
