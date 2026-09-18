import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kallopis/src/capabilities/editing/contracts/klp_editing_drawing.dart';
import 'package:kallopis/src/capabilities/editing/contracts/klp_editing_interaction.dart';
import 'package:kallopis/src/capabilities/editing/contracts/klp_editing_layout.dart';
import 'package:kallopis/src/capabilities/editing/contracts/klp_editing_point_request.dart';
import 'package:kallopis/src/capabilities/editing/contracts/klp_editing_projection.dart';
import 'package:kallopis/src/capabilities/editing/contracts/klp_editing_reply.dart';
import 'package:kallopis/src/capabilities/editing/contracts/klp_editing_request.dart';
import 'package:kallopis/src/capabilities/editing/contracts/klp_editing_stamp.dart';
import 'package:kallopis/src/capabilities/editing/contracts/klp_editing_text_window.dart';
import 'package:kallopis/src/capabilities/state/klp_mutable_state.dart';
import 'package:kallopis/src/features/editing/contracts/klp_editing_host_failure.dart';
import 'package:kallopis/src/features/editing/presentation/klp_bound_editing_style.dart';
import 'package:kallopis/src/features/editing/presentation/klp_editing_presentation.dart';
import 'package:kallopis/src/foundation/binding/contracts/klp_bound_control_style.dart';
import 'package:kallopis/src/rendering/flutter/internal/klp_flutter_editing.dart';
import 'package:kallopis/src/styling/primitives/klp_style_value.dart';
import 'package:kallopis/src/styling/semantics/klp_control_density.dart';

import 'klp_editing_fixture.dart';
import 'klp_renderer_fixture.dart';

/// 來源只回覆指定權威投影；測試不重新實作文字交易或宿主生命週期。
final class KlpLifecycleSource implements KlpBoundEditingActions {

	final String id;
	late final KlpMutableState<KlpEditingDrawing> drawing;
	final bindings = <KlpLifecycleBinding>[];
	final requests = <KlpEditingRequest>[];
	final List<KlpEditingHostFailure> failures;
	FutureOr<KlpEditingReply> Function(KlpEditingRequest)? onSubmit;
	int pointCalls = 0;
	int providerCloses = 0;
	int providerSaves = 0;
	int _sequence = 0;

	KlpLifecycleSource(this.id, {bool composing = true, List<KlpEditingHostFailure>? failures}) : failures = failures ?? [] {
		drawing = KlpMutableState(KlpEditingDrawing(projection: frame(composing: composing), width: 800, height: 600, commands: const []));
	}

	KlpEditingProjection frame({int revision = 0, int contentRevision = 0, bool composing = false, String text = 'ab', int caret = 1}) => editingFixture(KlpEditingTextWindow(
		stamp: KlpEditingStamp(documentId: id, pageId: 'page', generation: 0, projectionRevision: revision, contentRevision: contentRevision, compositionRevision: revision, layoutRevision: 0, environmentId: 'test'),
		blockId: 'block',
		sourceStartUtf8: 0,
		text: text,
		anchorUtf8: caret,
		focusUtf8: caret,
		composingStartUtf8: composing ? 0 : null,
		composingEndUtf8: composing ? 1 : null,
	));

	KlpBoundEditing get content => KlpBoundEditing(drawing.readOnly, _style(), null, this, null, null, null, null);

	@override
	int issueCommandSequence() => ++_sequence;

	@override
	KlpEditingDrawing layout(KlpEditingLayout layout) => drawing.value;

	@override
	Future<KlpEditingReply> submit(KlpEditingRequest request, {required int committedAtMs}) async {
		requests.add(request);
		return onSubmit == null ? KlpEditingReply(KlpEditingDecision.accepted, frame(revision: requests.length)) : await onSubmit!(request);
	}

	@override
	Future<KlpEditingReply> selectPoint(KlpEditingPointRequest request) async {
		pointCalls++;
		return KlpEditingReply(KlpEditingDecision.accepted, drawing.value.projection);
	}

	@override
	KlpEditingInteractionBinding bindInteraction(KlpEditingInteraction interaction) {
		final binding = KlpLifecycleBinding(interaction);
		bindings.add(binding);
		return binding;
	}

	void close() => providerCloses++;
	void save() => providerSaves++;
	void disposeFixture() => drawing.dispose();
}

/// 記錄每次真正解除呼叫，重複呼叫不由假物件冪等化而被掩蓋。
final class KlpLifecycleBinding implements KlpEditingInteractionBinding {

	final KlpEditingInteraction interaction;
	int closes = 0;
	Object? closeError;
	StackTrace? closeStack;

	KlpLifecycleBinding(this.interaction);

	@override
	void close() {
		closes++;
		if (closeError != null) Error.throwWithStackTrace(closeError!, closeStack!);
	}
}

Future<void> mountKlpLifecycle(WidgetTester tester, KlpLifecycleSource source) async {
	// 真正 renderer 分支建立元件；由既有焦點介面啟動平台文字輸入。
	await tester.pumpWidget(klpLifecycleHost(source));
	final focus = tester.widgetList<Focus>(find.descendant(of: find.byType(KlpFlutterEditing), matching: find.byType(Focus))).singleWhere((widget) => widget.focusNode != null).focusNode!;
	focus.requestFocus();
	await tester.pump();
	expect(tester.testTextInput.hasAnyClients, isTrue);
}

Widget klpLifecycleHost(KlpLifecycleSource source) => klpRendererHost(source.content, onEditingHostFailure: source.failures.add);

DeltaTextInputClient klpLifecycleClient(WidgetTester tester) => tester.state(find.byType(KlpFlutterEditing)) as DeltaTextInputClient;

const klpLifecycleInsert = TextEditingDeltaInsertion(oldText: 'ab', textInserted: 'x', insertionOffset: 0, selection: TextSelection.collapsed(offset: 1), composing: TextRange.empty);

KlpBoundEditingStyle _style() {
	// 任意有效測試風格不成為產品預設值。
	final text = klpRendererText('fixture').style;
	final color = KlpColor(25, 25, 25);
	return KlpBoundEditingStyle(
		text: color,
		ink: color,
		caret: color,
		selection: color,
		fontFamily: text.fontFamily,
		fontWeight: text.fontWeight,
		fontSize: text.fontSize,
		lineHeight: text.lineHeight,
		letterSpacing: text.letterSpacing,
		horizontalPadding: KlpDistance(1),
		verticalPadding: KlpDistance(1),
		blockSpacing: KlpDistance(1),
		overscan: KlpDistance(1),
		listIndent: KlpDistance(1),
		markerGap: KlpDistance(1),
		marker: color,
		minimumBodyEm: 1,
		dragAutoScrollEdge: KlpDistance(1),
		dragAutoScrollStep: KlpDistance(1),
		dragAutoScrollInterval: KlpDuration(10),
		control: KlpBoundControlStyle(density: KlpControlDensity(KlpDistance(32)), radius: KlpRadius(1), background: color, focus: color, text: text),
	);
}
