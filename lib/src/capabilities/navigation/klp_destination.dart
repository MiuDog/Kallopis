import 'klp_location.dart';
import 'klp_route_address.dart';
import 'klp_route_codec.dart';

/// 目的地保留建立當時的型別驗證，不因泛型向上轉型而放寬。
final class KlpDestination<P, R> {
  final String id;
  final bool Function(Object?) _parameters;
  final bool Function(Object?) _result;
  final Map<String, String> Function(Object?)? _encode;
  final Object? Function(Map<String, String>)? _decode;

  KlpDestination(this.id, {KlpRouteCodec<P>? codec})
    : _parameters = ((value) => value is P),
      _result = ((value) => value is R),
      _encode = codec == null ? null : ((value) => codec.encode(value as P)),
      _decode = codec == null ? null : ((values) => codec.decode(values)) {
    if (id.isEmpty) {
      throw ArgumentError.value(
        id,
        'id',
        'Destination identity cannot be empty.',
      );
    }
  }

  bool acceptsParameters(Object? value) => _parameters(value);
  bool acceptsResult(Object? value) => _result(value);
  bool get supportsRestoration => _encode != null && _decode != null;

  KlpLocation<R> location(P parameters) {
    if (!acceptsParameters(parameters)) {
      throw ArgumentError.value(
        parameters,
        'parameters',
        'Invalid destination parameters.',
      );
    }

    return KlpLocation<R>(this, parameters);
  }

  KlpRouteAddress encodeAddress(Object? parameters) {
    if (!acceptsParameters(parameters)) {
      throw ArgumentError.value(
        parameters,
        'parameters',
        'Invalid destination parameters.',
      );
    }
    final encode = _encode;
    if (encode == null) {
      throw StateError('Destination $id does not define a restoration codec.');
    }

    return KlpRouteAddress(destinationId: id, parameters: encode(parameters));
  }

  KlpLocation<Object?> decodeAddress(KlpRouteAddress address) {
    if (address.destinationId != id) {
      throw ArgumentError.value(
        address.destinationId,
        'address',
        'Route address destination does not match this destination.',
      );
    }
    final decode = _decode;
    if (decode == null) {
      throw StateError('Destination $id does not define a restoration codec.');
    }
    final parameters = decode(address.parameters);
    if (!acceptsParameters(parameters)) {
      throw ArgumentError(
        'Restoration codec returned invalid destination parameters.',
      );
    }

    return KlpLocation<Object?>(this, parameters);
  }
}
