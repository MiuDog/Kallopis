import 'klp_destination.dart';

/// 位置保留實際目的地物件；同名的新物件不能冒用既有註冊。
final class KlpLocation<R> {

	final KlpDestination<Object?, R> destination;
	final Object? parameters;

	KlpLocation(this.destination, this.parameters) {
		if (!destination.acceptsParameters(parameters)) throw ArgumentError.value(parameters, 'parameters', 'Invalid destination parameters.');
	}
}
