import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:kallopis/kallopis_declarative.dart';

void main() {
  test('encodes and decodes one platform entry without Flutter routing types', () {
    final encoded = KlpRouteUri.encode(
      routerId: 'main',
      address: KlpRouteAddress(
        destinationId: 'detail',
        parameters: {'note': '7', 'tab': 'history'},
      ),
    );

    expect(encoded.toString(), '/main/detail?note=7&tab=history');
    final restoration = KlpRouteUri.decode(encoded);
    expect(restoration, isNotNull);
    expect(restoration!.routerId, 'main');
    expect(restoration.stack.single.destinationId, 'detail');
    expect(restoration.stack.single.parameters, {'note': '7', 'tab': 'history'});
  });

  test('leaves unsupported or ambiguous URI forms to the host platform', () {
    expect(KlpRouteUri.decode(Uri.parse('/main/detail?tag=a&tag=b')), isNull);
    expect(KlpRouteUri.decode(Uri.parse('/main/detail#section')), isNull);
    expect(KlpRouteUri.decode(Uri.parse('/main')), isNull);
  });

  test('round-trips a retained stack without colliding with route parameters', () {
    final encoded = KlpRouteUri.encodeRestoration(
      KlpNavigationRestoration(
        routerId: 'main',
        stack: [
          KlpRouteAddress(
            destinationId: 'home',
            parameters: {'filter': '__klp_stack'},
          ),
          KlpRouteAddress(
            destinationId: 'detail',
            parameters: {'note': '7'},
          ),
        ],
      ),
    );

    expect(encoded.path, '/main');
    final restoration = KlpRouteUri.decode(encoded);
    expect(restoration, isNotNull);
    expect(restoration!.stack.map((entry) => entry.destinationId), [
      'home',
      'detail',
    ]);
    expect(restoration.stack.first.parameters, {'filter': '__klp_stack'});
    expect(restoration.stack.last.parameters, {'note': '7'});
  });

  test('rejects malformed complete-stack payloads before router restoration', () {
    expect(
      KlpRouteUri.decode(Uri.parse('/main?__klp_stack=not-base64!')),
      isNull,
    );
    final invalid = base64UrlEncode(
      utf8.encode('{"version":1,"stack":[{"destination":"home"}]}'),
    ).replaceAll('=', '');
    expect(
      KlpRouteUri.decode(Uri.parse('/main?__klp_stack=$invalid')),
      isNull,
    );
  });
}
