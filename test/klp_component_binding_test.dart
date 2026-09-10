import 'package:flutter_test/flutter_test.dart';
import 'package:kallopis/kallopis_declarative.dart';
import 'package:kallopis/src/foundation/binding/internal/klp_bound_template.dart';
import 'package:kallopis/src/foundation/binding/internal/klp_component_binding_exception.dart';
import 'package:kallopis/src/foundation/binding/internal/klp_component_compiler.dart';

import 'support/klp_component_test_definition.dart';
import 'support/klp_component_test_item.dart';
import 'support/klp_component_test_menu_item.dart';
import 'support/klp_component_test_other_node.dart';
import 'support/klp_test_primitives.dart';

void main() {
  test('style changes preserve placement and existing bound snapshots', () {
    var callbacks = 0;
    final item = KlpComponentTestItem(
      action: KlpCallbackAction(() => callbacks++),
    );
    expect(item, isA<KlpRailItem>());
    expect(item, isA<KlpComponentTestMenuItem>());
    final compiler = KlpComponentCompiler([klpComponentTestDefinition()]);
    final firstStyle = klpTestPrimitives();
    final secondStyle = klpTestPrimitives(alternate: true);
    final first = compiler.bind(item, firstStyle);
    final second = compiler.bind(item, secondStyle);
    expect(first.id, item.id);
    expect(second.id, first.id);
    expect(second.definitionId, first.definitionId);
    final firstSurface = first.content as KlpBoundSurface;
    final secondSurface = second.content as KlpBoundSurface;
    expect(firstSurface.background, same(firstStyle.colors[1]));
    expect(secondSurface.background, same(secondStyle.colors[1]));
    expect(firstSurface.radius, same(firstStyle.radii[1]));
    expect(secondSurface.radius, same(secondStyle.radii[1]));
    expect(firstSurface.inset, same(firstStyle.distances[1]));
    expect(secondSurface.inset, same(secondStyle.distances[1]));
    final firstRow = firstSurface.child as KlpBoundLinear;
    final secondRow = secondSurface.child as KlpBoundLinear;
    expect(firstRow.axis, KlpAxis.vertical);
    expect(firstRow.gap, same(firstStyle.distances[1]));
    expect(secondRow.gap, same(secondStyle.distances[1]));
    expect(() => firstRow.children.clear(), throwsUnsupportedError);
    final oldText = firstRow.children.first as KlpBoundText;
    final newText = secondRow.children.first as KlpBoundText;
    expect(oldText.text, 'First');
    expect(newText.text, oldText.text);
    expect(oldText.style.color, same(firstStyle.colors[1]));
    expect(newText.style.color, same(secondStyle.colors[1]));
    expect(oldText.style.fontFamily, same(firstStyle.fontFamilies[1]));
    expect(newText.style.fontFamily, same(secondStyle.fontFamilies[1]));
    expect(oldText.style.fontSize, same(firstStyle.fontSizes[1]));
    expect(newText.style.fontSize, same(secondStyle.fontSizes[1]));
    expect(oldText.style.fontWeight, same(firstStyle.fontWeights[1]));
    expect(newText.style.fontWeight, same(secondStyle.fontWeights[1]));
    expect(oldText.style.lineHeight, same(firstStyle.lineHeights[1]));
    expect(newText.style.lineHeight, same(secondStyle.lineHeights[1]));
    expect(oldText.style.letterSpacing, same(firstStyle.letterSpacings[1]));
    expect(newText.style.letterSpacing, same(secondStyle.letterSpacings[1]));
    expect(callbacks, 0);
    (item.action as KlpCallbackAction).callback();
    expect(callbacks, 1);
  });

  test('each text placement selects once and data creates a new snapshot', () {
    var calls = 0;
    final definition = klpComponentTestDefinition(
      select: (item) {
        calls++;
        return item.label;
      },
    );
    final compiler = KlpComponentCompiler([definition]);
    expect(calls, 0);
    final style = klpTestPrimitives();
    final first = compiler.bind(KlpComponentTestItem(), style);
    expect(calls, 2);
    final next = compiler.bind(KlpComponentTestItem(label: 'Updated'), style);
    expect(calls, 4);
    final oldRow = (first.content as KlpBoundSurface).child as KlpBoundLinear;
    final nextRow = (next.content as KlpBoundSurface).child as KlpBoundLinear;
    expect(oldRow.children.cast<KlpBoundText>().map((text) => text.text), [
      'First',
      'First',
    ]);
    expect(nextRow.children.cast<KlpBoundText>().map((text) => text.text), [
      'Updated',
      'Updated',
    ]);
    expect(next.id, first.id);
  });

  test('invalid node contracts fail before invoking selectors', () {
    var calls = 0;
    final compiler = KlpComponentCompiler([
      klpComponentTestDefinition(
        select: (item) {
          calls++;
          return item.label;
        },
      ),
    ]);
    final invalid = <(KlpNode, String)>[
      (KlpComponentTestOtherNode(), 'node_type_mismatch'),
      (KlpComponentTestItem(definitionId: 'missing'), 'unknown_component'),
      (KlpComponentTestItem(id: ' '), 'empty_id'),
      (
        KlpComponentTestItem(children: [KlpComponentTestItem(id: 'nested')]),
        'component_children_unsupported',
      ),
    ];
    for (final (node, code) in invalid) {
      expect(
        () => compiler.bind(node, klpTestPrimitives()),
        _contractFailure(code),
      );
    }
    expect(calls, 0);
  });

  test('nested narrower templates fail before any sibling selector runs', () {
    var calls = 0;
    final original = klpComponentTestDefinition();
    final surface =
        original.content as KlpSurfaceTemplate<KlpComponentTestItem>;
    final row = surface.child as KlpLinearTemplate<KlpComponentTestItem>;
    final text = row.children.first as KlpTextTemplate<KlpComponentTestItem>;
    final broadText = KlpTextTemplate<KlpNode>(
      text: (_) {
        calls++;
        return 'broad';
      },
      semantics: text.semantics,
    );
    final narrower = <KlpTemplate<KlpNode>>[
      text,
      KlpLinearTemplate<KlpComponentTestItem>(
        axis: row.axis,
        children: [],
        gap: row.gap,
      ),
      KlpSurfaceTemplate<KlpComponentTestItem>(
        child: text,
        background: surface.background,
        radius: surface.radius,
        inset: surface.inset,
      ),
    ];
    for (final template in narrower) {
      final content = KlpLinearTemplate<KlpNode>(
        axis: row.axis,
        children: [broadText, template],
        gap: row.gap,
      );
      final definition = KlpComponentDefinition<KlpNode>(
        'fixture',
        content: content,
        semantics: original.contract.semantics,
      );
      final compiler = KlpComponentCompiler([definition]);
      final failure = isA<KlpContractError>().having(
        (error) => error.code,
        'code',
        'template_type_mismatch',
      );
      expect(
        () => compiler.bind(KlpComponentTestOtherNode(), klpTestPrimitives()),
        throwsA(failure),
      );
      expect(calls, 0);
      compiler.bind(KlpComponentTestItem(), klpTestPrimitives());
      expect(calls, 1);
      calls = 0;
    }
  });

  test('direct invalid template references fail at compilation', () {
    var calls = 0;
    String select(KlpComponentTestItem item) {
      calls++;
      return item.label;
    }

    final foreign = KlpSemanticKey('shared', 'color', KlpStyleKind.color);
    final cases = <(KlpSemanticKey<KlpColor>, List<String>, bool, String)>[
      (foreign, ['shared'], false, 'private_semantic_reference'),
      (foreign, [], true, 'undeclared_semantic_dependency'),
      (
        KlpSemanticKey('fixture', 'radius', KlpStyleKind.color),
        [],
        true,
        'semantic_kind_mismatch',
      ),
      (
        KlpSemanticKey('fixture', 'missing', KlpStyleKind.color),
        [],
        true,
        'unknown_semantic',
      ),
    ];
    for (final (key, dependencies, public, code) in cases) {
      final component = klpComponentTestDefinition(
        select: select,
        textColor: key,
        dependencies: dependencies,
      );
      expect(
        () => KlpComponentCompiler(
          [component],
          sharedDefinitions: [_shared(foreign, public)],
        ),
        _contractFailure(code),
      );
    }
    expect(calls, 0);
  });

  test('declared public foreign template reference binds normally', () {
    final foreign = KlpSemanticKey('shared', 'color', KlpStyleKind.color);
    final component = klpComponentTestDefinition(
      textColor: foreign,
      dependencies: ['shared'],
    );
    final compiler = KlpComponentCompiler(
      [component],
      sharedDefinitions: [_shared(foreign, true)],
    );
    final primitives = klpTestPrimitives();
    final result = compiler.bind(KlpComponentTestItem(), primitives);
    final row = (result.content as KlpBoundSurface).child as KlpBoundLinear;
    expect(
      (row.children.first as KlpBoundText).style.color,
      same(primitives.colors[2]),
    );
  });

  test('selector errors preserve cause stack and placement template path', () {
    final cause = StateError('selector failure');
    final trace = StackTrace.fromString('original selector stack');
    final component = klpComponentTestDefinition(
      select: (_) => Error.throwWithStackTrace(cause, trace),
    );
    final compiler = KlpComponentCompiler([component]);
    final failure = isA<KlpComponentBindingException>()
        .having((error) => error.cause, 'cause', same(cause))
        .having((error) => error.stackTrace, 'stack', same(trace))
        .having((error) => error.placementId, 'placement', 'placement')
        .having(
          (error) => error.templatePath,
          'template',
          'content/child/children/0',
        );
    expect(
      () => compiler.bind(KlpComponentTestItem(), klpTestPrimitives()),
      throwsA(failure),
    );
  });

  test('component accessibility label rejects empty data after validation', () {
    final compiler = KlpComponentCompiler([
      klpComponentTestDefinition(accessibilityLabel: (_) => ' '),
    ]);
    expect(
      () => compiler.bind(KlpComponentTestItem(), klpTestPrimitives()),
      _contractFailure('invalid_component_accessibility_label'),
    );
  });

  test('component accessibility selector preserves its failure boundary', () {
    final cause = StateError('accessibility selector failure');
    final trace = StackTrace.fromString('accessibility selector stack');
    final compiler = KlpComponentCompiler([
      klpComponentTestDefinition(
        accessibilityLabel: (_) => Error.throwWithStackTrace(cause, trace),
      ),
    ]);
    final failure = isA<KlpComponentBindingException>()
        .having((error) => error.cause, 'cause', same(cause))
        .having((error) => error.stackTrace, 'stack', same(trace))
        .having(
          (error) => error.templatePath,
          'template',
          'accessibilityLabel',
        );
    expect(
      () => compiler.bind(KlpComponentTestItem(), klpTestPrimitives()),
      throwsA(failure),
    );
  });
}

Matcher _contractFailure(String code) => throwsA(
  isA<KlpContractError>().having((error) => error.code, 'code', code),
);

KlpDefinition<KlpNode> _shared(KlpSemanticKey<KlpColor> color, bool public) =>
    KlpDefinition(
      'shared',
      semantics: KlpSemanticSchema('shared', [
        KlpSemanticToken(
          color,
          const KlpPrimitiveRef(KlpStyleKind.color, KlpPrimitiveIndex.i2),
          isPublic: public,
        ),
      ]),
    );
