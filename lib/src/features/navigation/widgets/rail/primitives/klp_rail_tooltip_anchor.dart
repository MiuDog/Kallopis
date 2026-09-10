part of '../klp_rail_item.dart';

class _KlpRailTooltipAnchor extends StatefulWidget {
  const _KlpRailTooltipAnchor({required this.message, required this.child});

  final String message;
  final Widget child;

  @override
  State<_KlpRailTooltipAnchor> createState() => _KlpRailTooltipAnchorState();
}
