import 'package:flutter_test/flutter_test.dart';
import 'package:kallopis/src/features/editing/contracts/klp_editing_host_failure.dart';

void main() {
	test('host failure keeps exact origin phase error and stack through the sink', () {
		final error = Object();
		final stack = StackTrace.fromString('original-host-stack');
		final received = <KlpEditingHostFailure>[];
		KlpEditingHostFailureSink sink = received.add;
		for (final origin in KlpEditingHostOrigin.values) {
			for (final phase in KlpEditingHostPhase.values) {
				final failure = KlpEditingHostFailure(origin: origin, phase: phase, error: error, stackTrace: stack);
				sink(failure);
				expect(received.last, same(failure));
				expect(received.last.origin, origin);
				expect(received.last.phase, phase);
				expect(received.last.error, same(error));
				expect(received.last.stackTrace, same(stack));
			}
		}
		expect(KlpEditingHostOrigin.values.map((value) => value.name), ['textInput', 'blockNote', 'canva']);
		expect(KlpEditingHostPhase.values.map((value) => value.name), ['environmentCreate', 'bridgeReady', 'bind', 'configure', 'open', 'flush', 'receive', 'callback', 'input', 'interrupt', 'dispose']);
	});
}
