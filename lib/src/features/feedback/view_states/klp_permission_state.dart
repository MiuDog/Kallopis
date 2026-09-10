part of 'klp_view_states.dart';

class KlpPermissionState extends StatelessWidget {
  const KlpPermissionState({
    super.key,
    required this.title,
    required this.message,
    this.icon,
    this.action,
  });

  final String title;
  final String message;
  final KlpIconData? icon;
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    return _KlpViewState(
      icon: icon,
      iconColor: context.klpColors.warning,
      title: title,
      message: message,
      action: action,
    );
  }
}
