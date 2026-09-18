import '../contracts/klp_editing_draw_command.dart';

/// 套件內共用的封閉作用域驗證，不成為 provider 公開入口。
List<KlpEditingDrawCommand> freezeKlpEditingDrawCommands(Iterable<KlpEditingDrawCommand> commands) {
	final frozen = List<KlpEditingDrawCommand>.unmodifiable(commands);
	final stack = <bool>[];
	for (final command in frozen) {
		switch (command) {
			case KlpEditingPushClip(): stack.add(true);
			case KlpEditingPushTransform(): stack.add(false);
			case KlpEditingPopClip():
				if (stack.isEmpty || !stack.removeLast()) throw ArgumentError('Unmatched editing clip');
			case KlpEditingPopTransform():
				if (stack.isEmpty || stack.removeLast()) throw ArgumentError('Unmatched editing transform');
			case KlpEditingDrawPath() || KlpEditingDrawRect(): break;
		}
	}
	if (stack.isNotEmpty) throw ArgumentError('Unclosed editing scope');
	return frozen;
}
