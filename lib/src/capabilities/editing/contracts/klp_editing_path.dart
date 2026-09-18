/// 提供者路徑片段的幾何操作；不引入平台 Path 或筆刷。
enum KlpEditingPathOperation { move, line, quadratic, cubic, close }

/// 輪廓只包含幾何；座標單位由其繪製變換明確指定。
final class KlpEditingPathCommand {

	final KlpEditingPathOperation operation;
	final List<double> values;

	KlpEditingPathCommand(this.operation, Iterable<double> values) : values = List.unmodifiable(values) {
		final count = switch (operation) {
			KlpEditingPathOperation.move || KlpEditingPathOperation.line => 2,
			KlpEditingPathOperation.quadratic => 4,
			KlpEditingPathOperation.cubic => 6,
			KlpEditingPathOperation.close => 0,
		};
		if (this.values.length != count || !this.values.every((value) => value.isFinite)) throw ArgumentError('Invalid editing path coordinates');
	}
}

/// 不可變輪廓可供同一畫面中的多個字形位置共用。
final class KlpEditingPath {

	final List<KlpEditingPathCommand> commands;

	KlpEditingPath(Iterable<KlpEditingPathCommand> commands) : commands = List.unmodifiable(commands) {
		var hasContour = false;
		for (final command in this.commands) {
			if (command.operation == KlpEditingPathOperation.move) hasContour = true;
			if (!hasContour) throw ArgumentError('Editing path must begin with a move');
			if (command.operation == KlpEditingPathOperation.close) hasContour = false;
		}
	}
}
