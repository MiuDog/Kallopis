import 'dart:convert';

import 'klp_navigation_restoration.dart';
import 'klp_route_address.dart';

/// Kallopis 路由的預設 URI 資料格式；支援單頁進入與本庫完整 stack 回報。
final class KlpRouteUri {
  static const String _stackParameter = '__klp_stack';

  static Uri encode({
    required String routerId,
    required KlpRouteAddress address,
  }) {
    _validateRouterId(routerId);
    _validateDestinationId(address.destinationId);
    return Uri(
      path: '/$routerId/${address.destinationId}',
      queryParameters: address.parameters.isEmpty ? null : address.parameters,
    );
  }

  /// 本庫回報的完整 stack 保留在單一受控欄位，避免和 route 參數混用。
  static Uri encodeRestoration(KlpNavigationRestoration restoration) {
    _validateRouterId(restoration.routerId);
    final stack = restoration.stack
        .map(
          (address) => <String, Object?>{
            'destination': address.destinationId,
            'parameters': address.parameters,
          },
        )
        .toList(growable: false);
    final payload = base64UrlEncode(
      utf8.encode(jsonEncode(<String, Object?>{'version': 1, 'stack': stack})),
    ).replaceAll('=', '');
    return Uri(
      path: '/${restoration.routerId}',
      queryParameters: {_stackParameter: payload},
    );
  }

  /// 無法辨識的 URI 交還平台，避免攔截宿主或其他框架的位址。
  static KlpNavigationRestoration? decode(Uri uri) {
    if (uri.scheme.isNotEmpty ||
        uri.host.isNotEmpty ||
        uri.fragment.isNotEmpty) {
      return null;
    }
    final segments = uri.pathSegments;
    if (segments.length == 1 && segments.single.isNotEmpty) {
      return _decodeRestoration(segments.single, uri.queryParametersAll);
    }
    if (segments.length != 2 || segments.any((segment) => segment.isEmpty)) {
      return null;
    }
    final parameters = <String, String>{};
    for (final entry in uri.queryParametersAll.entries) {
      if (entry.value.length != 1) {
        return null;
      }
      parameters[entry.key] = entry.value.single;
    }
    try {
      return KlpNavigationRestoration(
        routerId: segments.first,
        stack: [
          KlpRouteAddress(destinationId: segments.last, parameters: parameters),
        ],
      );
    } on ArgumentError {
      return null;
    }
  }

  static KlpNavigationRestoration? _decodeRestoration(
    String routerId,
    Map<String, List<String>> parameters,
  ) {
    final stack = parameters[_stackParameter];
    if (parameters.length != 1 || stack == null || stack.length != 1) {
      return null;
    }
    try {
      final payload = jsonDecode(
        utf8.decode(base64Url.decode(base64Url.normalize(stack.single))),
      );
      if (payload is! Map<Object?, Object?> ||
          payload['version'] != 1 ||
          payload['stack'] is! List<Object?>) {
        return null;
      }
      final addresses = <KlpRouteAddress>[];
      for (final entry in payload['stack']! as List<Object?>) {
        if (entry is! Map<Object?, Object?> ||
            entry['destination'] is! String ||
            entry['parameters'] is! Map<Object?, Object?>) {
          return null;
        }
        final values = <String, String>{};
        for (final parameter
            in (entry['parameters']! as Map<Object?, Object?>).entries) {
          if (parameter.key is! String || parameter.value is! String) {
            return null;
          }
          values[parameter.key as String] = parameter.value as String;
        }
        addresses.add(
          KlpRouteAddress(
            destinationId: entry['destination'] as String,
            parameters: values,
          ),
        );
      }
      return KlpNavigationRestoration(routerId: routerId, stack: addresses);
    } on FormatException {
      return null;
    } on ArgumentError {
      return null;
    }
  }

  static void _validateRouterId(String routerId) {
    if (routerId.trim().isEmpty || routerId.contains('/')) {
      throw ArgumentError.value(
        routerId,
        'routerId',
        'Router URI identity must be a non-empty path segment.',
      );
    }
  }

  static void _validateDestinationId(String destinationId) {
    if (destinationId.contains('/')) {
      throw ArgumentError.value(
        destinationId,
        'address.destinationId',
        'Route URI destination must be one path segment.',
      );
    }
  }
}
