part of 'klp_editing_presentation.dart';

/// 已從 enclosing editor 繫結的定位命令能力。
final class KlpBoundAnchoredCommands {
	final String id;
	final KlpBoundAnchoredCommandActions actions;

	const KlpBoundAnchoredCommands(this.id, this.actions);
}
