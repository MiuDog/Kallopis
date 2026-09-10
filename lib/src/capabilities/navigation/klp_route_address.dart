/// 可保存與傳遞的中立路由位置；平台網址由未來的 platform adapter 處理。
final class KlpRouteAddress {
  final String destinationId;
  final Map<String, String> parameters;

  KlpRouteAddress({
    required this.destinationId,
    Map<String, String> parameters = const {},
  }) : parameters = Map.unmodifiable(parameters) {
    if (destinationId.trim().isEmpty) {
      throw ArgumentError.value(
        destinationId,
        'destinationId',
        'Route address destination cannot be empty.',
      );
    }
    for (final key in this.parameters.keys) {
      if (key.trim().isEmpty) {
        throw ArgumentError.value(
          key,
          'parameters',
          'Route address parameter names cannot be empty.',
        );
      }
    }
  }
}
