import 'package:analyzer/error/error.dart';
import 'package:flutter_test/flutter_test.dart';

import 'support/klp_external_compile_fixture.dart';

void main() {
  group('external route declaration contract', () {
    late KlpExternalCompileFixture fixture;
    const imports =
        "import 'dart:async';\nimport 'package:kallopis/kallopis_declarative.dart';\nimport 'package:flutter/widgets.dart';\n";
    const base = '''final destination = KlpDestination<int, String>('main');
KlpScreen screen(KlpRouteInput<int, String> input) => KlpScreen(id: 'screen', accessibilityLabel: 'Screen', child: KlpRail(id: 'rail'));
final configuredRoute = KlpRoute<int, String>(destination, screen: screen);
final configuredRouter = KlpRouter(id: 'router', initial: destination.location(1), routes: [configuredRoute]);
KlpApplication application(KlpPrimitiveSet primitives) => KlpApplication(title: 'App', primitives: primitives, router: configuredRouter);
void typedOperations(KlpRouteInput<int, String> input) {
	final int parameters = input.parameters;
	final KlpAction navigate = input.navigate(destination.location(parameters), onResult: (String value) {});
	final KlpAction finish = input.finish('saved');
	final KlpAction back = input.back();
}
''';
    final cases = <String, ({String source, String? code})>{
      'positive': (
        source: "final route = KlpRoute(destination, screen: screen);",
        code: null,
      ),
      'typed_actions': (
        source:
            "KlpAction navigate(KlpRouteInput<int, String> input) => input.navigate(destination.location(input.parameters), onResult: (String value) {});",
        code: null,
      ),
      'input_has_no_public_constructor': (
        source: 'final input = KlpRouteInput<int, String>();',
        code: 'new_with_undefined_constructor_default',
      ),
      'widget_mapper': (
        source:
            'final route = KlpRoute(destination, screen: (input) => const SizedBox());',
        code: 'return_of_invalid_type_from_closure',
      ),
      'wrong_input_type': (
        source:
            "final route = KlpRoute(destination, screen: (KlpRouteInput<String, String> input) => KlpScreen(id: 'screen', accessibilityLabel: 'Screen', child: KlpRail(id: 'rail')));",
        code: 'argument_type_not_assignable',
      ),
      'wrong_completion_type': (
        source:
            'void finish(KlpRouteInput<int, String> input) { input.finish(1); }',
        code: 'argument_type_not_assignable',
      ),
      'no_controller_injection': (
        source:
            'final route = KlpRoute(destination, screen: screen, controller: Object());',
        code: 'undefined_named_parameter',
      ),
      'no_mapper_style_injection': (
        source:
            'final route = KlpRoute(destination, screen: screen, style: Object());',
        code: 'undefined_named_parameter',
      ),
      'no_alternative_app_child': (
        source:
            'KlpApplication invalid(KlpPrimitiveSet primitives, KlpRouter router, KlpScreen child) => KlpApplication(title: "App", primitives: primitives, router: router, child: child);',
        code: 'undefined_named_parameter',
      ),
      'bootstrap_cannot_receive_widget': (
        source: 'void invalid() { runKlpApp(const SizedBox()); }',
        code: 'argument_type_not_assignable',
      ),
      'screen_cannot_receive_widget': (
        source:
            'final invalidScreen = KlpScreen(id: "screen", accessibilityLabel: "Screen", child: SizedBox());',
        code: 'argument_type_not_assignable',
      ),
      'no_environment_injection': (
        source:
            'KlpApplication invalid(KlpPrimitiveSet primitives) => KlpApplication(title: "App", primitives: primitives, router: configuredRouter, environment: Object());',
        code: 'undefined_named_parameter',
      ),
      'environment_has_no_public_constructor': (
        source: 'final environment = KlpApplicationEnvironment();',
        code: 'new_with_undefined_constructor_default',
      ),
      'mandatory_app_router': (
        source:
            'KlpApplication invalid(KlpPrimitiveSet primitives) => KlpApplication(title: "App", primitives: primitives);',
        code: 'missing_required_argument',
      ),
      'input_private_constructor_inaccessible': (
        source: 'final input = KlpRouteInput<int, String>._(1, Object());',
        code: 'new_with_undefined_constructor',
      ),
      'input_cannot_be_extended': (
        source:
            'abstract final class Escape extends KlpRouteInput<int, String> {}',
        code: 'final_class_extended_outside_of_library',
      ),
      'input_cannot_be_implemented': (
        source:
            'abstract final class Escape implements KlpRouteInput<int, String> {}',
        code: 'final_class_implemented_outside_of_library',
      ),
      'wrong_location_parameters': (
        source: 'final location = destination.location("wrong");',
        code: 'argument_type_not_assignable',
      ),
      'navigate_requires_typed_location': (
        source:
            'void invalid(KlpRouteInput<int, String> input) { input.navigate("main"); }',
        code: 'argument_type_not_assignable',
      ),
      'input_has_no_imperative_push': (
        source:
            'void invalid(KlpRouteInput<int, String> input) { input.push(destination.location(1)); }',
        code: 'undefined_method',
      ),
      'input_has_no_imperative_complete': (
        source:
            'void invalid(KlpRouteInput<int, String> input) { input.complete("done"); }',
        code: 'undefined_method',
      ),
      'input_has_no_imperative_cancel': (
        source:
            'void invalid(KlpRouteInput<int, String> input) { input.cancel(); }',
        code: 'undefined_method',
      ),
      'action_has_no_public_execute': (
        source: 'void invalid(KlpAction action) { action.execute(); }',
        code: 'undefined_method',
      ),
      'widget_cannot_replace_app_router': (
        source:
            'KlpApplication invalid(KlpPrimitiveSet primitives) => KlpApplication(title: "App", primitives: primitives, router: const SizedBox());',
        code: 'argument_type_not_assignable',
      ),
      'widget_cannot_be_router_route': (
        source:
            'final invalid = KlpRouter(id: "router", initial: destination.location(1), routes: [const SizedBox()]);',
        code: 'list_element_type_not_assignable',
      ),
      'router_has_no_raw_child': (
        source:
            'final invalid = KlpRouter(id: "router", initial: destination.location(1), routes: [configuredRoute], child: const SizedBox());',
        code: 'undefined_named_parameter',
      ),
      'route_mapper_cannot_receive_build_context': (
        source:
            'final invalid = KlpRoute<int, String>(destination, screen: (BuildContext context) => KlpScreen(id: "screen", accessibilityLabel: "Screen", child: KlpRail(id: "rail")));',
        code: 'argument_type_not_assignable',
      ),
      'route_has_no_context_parameter': (
        source:
            'final invalid = KlpRoute<int, String>(destination, screen: screen, context: Object());',
        code: 'undefined_named_parameter',
      ),
    };
    final targetLine = '\n'.allMatches('$imports$base').length + 1;

    setUpAll(() async {
      fixture = await KlpExternalCompileFixture.create({
        for (final entry in cases.entries)
          entry.key: '$imports$base${entry.value.source}\n',
      });
      addTearDown(fixture.dispose);
    });

    for (final entry in cases.entries) {
      test(entry.key, () async {
        final unit = await fixture.resolve(entry.key);
        final errors = unit.diagnostics
            .where(
              (diagnostic) =>
                  diagnostic.diagnosticCode.severity ==
                  DiagnosticSeverity.ERROR,
            )
            .toList();
        // 每個負例之前都有同一份合法應用控制組，不能用無關錯誤冒充拒絕證據。
        expect(
          errors.where(
            (error) =>
                unit.lineInfo.getLocation(error.offset).lineNumber < targetLine,
          ),
          isEmpty,
          reason: unit.diagnostics.join('\n'),
        );
        final code = entry.value.code;
        if (code == null) {
          expect(errors, isEmpty, reason: unit.diagnostics.join('\n'));
        } else {
          expect(
            errors.where(
              (error) =>
                  error.diagnosticCode.lowerCaseUniqueName == code &&
                  unit.lineInfo.getLocation(error.offset).lineNumber ==
                      targetLine,
            ),
            isNotEmpty,
            reason:
                '${entry.key}: $code at line $targetLine\n${unit.diagnostics.join('\n')}',
          );
        }
      });
    }
  });
}
