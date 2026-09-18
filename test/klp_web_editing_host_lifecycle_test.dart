import 'dart:async';
import 'package:flutter/widgets.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kallopis/src/rendering/flutter/internal/klp_flutter_block_note_editing.dart';
import 'package:kallopis/src/rendering/flutter/internal/klp_flutter_canva_editing.dart';

import 'support/klp_web_editing_platform_fixture.dart';
import 'support/load_test_fonts.dart';

void main() {
	setUpAll(loadKlpTestFonts);
	late KlpWebPlatform platform;
	late InAppWebViewPlatform? original;
	setUp(() {
		original = InAppWebViewPlatform.instance;
		platform = KlpWebPlatform();
		InAppWebViewPlatform.instance = platform;
	});
	tearDown(() { InAppWebViewPlatform.instance = original ?? KlpWebPlatform(); });

	for (final kind in KlpWebKind.values) {
		testWidgets('$kind renderer retains same controller State and replaces different controller', (tester) async {
			final first = KlpWebSession(kind, 'first');
			final second = KlpWebSession(kind, 'second');
			final type = kind == KlpWebKind.blockNote ? KlpFlutterBlockNoteEditing : KlpFlutterCanvaEditing;
			await tester.pumpWidget(klpWebHost([first.content()]));
			await settleWeb(tester);
			final originalState = tester.state(find.byType(type));
			final view = platform.views.single;
			view.loadStop();
			await settleWeb(tester);
			expect(view.platform.commands.where((c) => c['type'] == 'open'), hasLength(1));
			await tester.pumpWidget(klpWebHost([first.content(onOpened: () async {})]));
			await settleWeb(tester);
			expect(tester.state(find.byType(type)), same(originalState));
			expect(platform.views, hasLength(1));
			await tester.pumpWidget(klpWebHost([second.content()]));
			await settleWeb(tester);
			expect(tester.state(find.byType(type)), isNot(same(originalState)), reason: 'A replacement controller needs a fresh attachment');
			expect(view.disposals, 1);
			expect(platform.views, hasLength(2));
			platform.views.last.loadStop();
			await settleWeb(tester);
			expect(platform.views.last.platform.commands.where((c) => c['type'] == 'open'), hasLength(1));
			await tester.pumpWidget(const SizedBox.shrink());
			await settleWeb(tester);
			expect((first.saves, second.saves), (0, 0));
		});
	}

	for (final kind in KlpWebKind.values) {
		testWidgets('$kind duplicate load stops share one initial open', (tester) async {
			final session = KlpWebSession(kind, 'dedupe');
			await tester.pumpWidget(klpWebHost([session.content()]));
			await settleWeb(tester);
			final view = platform.views.single;
			final gate = Completer<void>();
			view.platform.send = (command) async { if (command['type'] == 'open') await gate.future; };
			view.loadStop();
			view.loadStop();
			await settleWeb(tester);
			expect(view.platform.commands.where((c) => c['type'] == 'open'), hasLength(1));
			gate.complete();
			await settleWeb(tester);
			view.loadStop();
			await settleWeb(tester);
			expect(view.platform.commands.where((c) => c['type'] == 'open'), hasLength(1));
			expect(session.saves, 0);
		});

		testWidgets('$kind loser attachment never unbinds the existing winner', (tester) async {
			final failures = <KlpEditingHostFailure>[];
			final session = KlpWebSession(kind, 'shared');
			await tester.pumpWidget(klpWebHost([session.content(), session.content()], onFailure: failures.add));
			await settleWeb(tester);
			final winner = platform.views.first;
			final loser = platform.views.last;
			winner.loadStop();
			await settleWeb(tester);
			loser.loadStop();
			await settleWeb(tester);
			expect(failures, hasLength(1));
			expect(failures.single.phase, KlpEditingHostPhase.bind);
			expect(failures.single.origin.name, kind.name);
			await tester.pumpWidget(klpWebHost([session.content()], onFailure: failures.add));
			await settleWeb(tester);
			await session.channel.send({'type': 'probe-winner'});
			expect(winner.platform.commands.last['type'], 'probe-winner');
			expect(loser.platform.commands, isEmpty);
			await tester.pumpWidget(const SizedBox.shrink());
			await settleWeb(tester);
			final successor = <Map<String, Object?>>[];
			await session.channel.bindPlatformSender((Map<String, Object?> command) async { successor.add(command); });
			await session.channel.send({'type': 'probe-successor'});
			expect(successor.single['type'], 'probe-successor');
			expect(failures, hasLength(1));
			expect(session.saves, 0);
			session.channel.unbindPlatformSender();
		});

		for (final boundary in ['bridge', 'delay', if (kind == KlpWebKind.blockNote) 'configure', 'open', 'flush']) {
			testWidgets('$kind detach at $boundary prevents subsequent side effects', (tester) async {
				final failures = <KlpEditingHostFailure>[];
				final session = KlpWebSession(kind, 'old-$boundary');
				final replacement = KlpWebSession(kind, 'new-$boundary');
				var callbacks = 0;
				if (boundary == 'flush') await session.channel.send({'type': 'queued-before-open'});
				await tester.pumpWidget(klpWebHost([session.content(onOpened: () async { callbacks++; })], onFailure: failures.add));
				await settleWeb(tester);
				final old = platform.views.single;
				final gate = Completer<void>();
				var reached = false;
				if (boundary == 'bridge') old.platform.readiness = () async { reached = true; await gate.future; return true; };
				if (boundary == 'delay') old.platform.readiness = () async { reached = true; return false; };
				old.platform.send = (command) async {
					if (command['type'] == boundary || (boundary == 'flush' && command['type'] == 'queued-before-open')) {
						reached = true;
						await gate.future;
					}
				};
				old.loadStop();
				await settleWeb(tester);
				expect(reached, isTrue, reason: 'The real plugin boundary must be awaiting before replacement');
				final before = old.platform.commands.length;
				final checksBefore = old.platform.readinessCalls;
				await tester.pumpWidget(klpWebHost([replacement.content()], onFailure: failures.add));
				await settleWeb(tester);
				final current = platform.views.last;
				current.loadStop();
				await settleWeb(tester);
				final successor = <Map<String, Object?>>[];
				await session.channel.bindPlatformSender((Map<String, Object?> command) async { successor.add(command); });
				gate.complete();
				await tester.pump(const Duration(milliseconds: 200));
				await settleWeb(tester);
				expect(old.platform.commands, hasLength(before));
				expect(old.platform.readinessCalls, checksBefore);
				expect(callbacks, 0);
				expect(current.platform.commands.where((c) => c['type'] == 'open'), hasLength(1));
				await session.channel.send({'type': 'probe-after-late-old-result'});
				expect(successor.last['type'], 'probe-after-late-old-result', reason: 'A late old completion must not release a newer sender');
				expect(failures, isEmpty);
				expect((session.saves, replacement.saves), (0, 0));
				session.channel.unbindPlatformSender();
			});
		}

		testWidgets('$kind late environment success disposes once and reports original disposal failure once', (tester) async {
			final gate = Completer<void>();
			final error = StateError('environment dispose failed');
			final stack = StackTrace.fromString('environment disposal original');
			final failures = <KlpEditingHostFailure>[];
			platform.createEnvironment = () => gate.future;
			platform.disposeEnvironment = () async { Error.throwWithStackTrace(error, stack); };
			await tester.pumpWidget(klpWebHost([KlpWebSession(kind, 'environment').content()], nativeWindows: true, onFailure: failures.add));
			await settleWeb(tester);
			await tester.pumpWidget(const SizedBox.shrink());
			gate.complete();
			await settleWeb(tester);
			expect(platform.views, isEmpty);
			expect(platform.environments.single.disposals, 1);
			expect(failures, hasLength(1));
			expect(failures.single.phase, KlpEditingHostPhase.dispose);
			expect(failures.single.origin.name, kind.name);
			expect(failures.single.error, same(error));
			expect(failures.single.stackTrace, same(stack));
		});

		for (final late in [false, true]) {
			testWidgets('$kind environment creation error reports once with late=$late', (tester) async {
				final gate = Completer<void>();
				final error = StateError('environment creation failed');
				final stack = StackTrace.fromString('environment creation original');
				final failures = <KlpEditingHostFailure>[];
				platform.createEnvironment = () => gate.future;
				await tester.pumpWidget(klpWebHost([KlpWebSession(kind, 'creation').content()], nativeWindows: true, onFailure: failures.add));
				await settleWeb(tester);
				if (late) await tester.pumpWidget(const SizedBox.shrink());
				gate.completeError(error, stack);
				await settleWeb(tester);
				if (!late) await tester.pumpWidget(const SizedBox.shrink());
				await settleWeb(tester);
				expect(failures, hasLength(1));
				expect(failures.single.phase, KlpEditingHostPhase.environmentCreate);
				expect(failures.single.origin.name, kind.name);
				expect(failures.single.error, same(error));
				expect(failures.single.stackTrace, same(stack));
				expect(platform.environments, isEmpty);
			});
		}

		testWidgets('$kind malformed receive rethrows original error and reports once', (tester) async {
			final failures = <KlpEditingHostFailure>[];
			await tester.pumpWidget(klpWebHost([KlpWebSession(kind, 'receive').content()], onFailure: failures.add));
			await settleWeb(tester);
			final view = platform.views.single;
			Object? caught;
			StackTrace? caughtStack;
			try { await view.receive(kind == KlpWebKind.blockNote ? 'KallopisBlockNote' : 'KallopisCanva', []); }
			catch (error, stack) { caught = error; caughtStack = stack; }
			expect(caught, isFormatException);
			expect(failures, hasLength(1));
			expect(failures.single.error, same(caught));
			expect(failures.single.stackTrace, same(caughtStack));
			expect(failures.single.phase, KlpEditingHostPhase.receive);
			for (final url in ['file:///editor', 'data:text/plain,test', 'about:blank']) {
				expect(await view.navigate(url), NavigationActionPolicy.ALLOW);
			}
			expect(await view.navigate('https://external.example/'), NavigationActionPolicy.CANCEL);
			expect(failures, hasLength(1));
		});
	}
	for (final kind in KlpWebKind.values) {
		testWidgets('$kind initial open failure retains retry policy and original failure', (tester) async {
			final failures = <KlpEditingHostFailure>[];
			final error = StateError('open transmission failed');
			final stack = StackTrace.fromString('original open transmission');
			final session = KlpWebSession(kind, 'failed-open');
			await tester.pumpWidget(klpWebHost([session.content()], onFailure: failures.add));
			await settleWeb(tester);
			final view = platform.views.single;
			view.platform.send = (command) async { if (command['type'] == 'open') Error.throwWithStackTrace(error, stack); };
			view.loadStop();
			await settleWeb(tester);
			expect(failures, hasLength(1));
			expect(failures.single.phase, KlpEditingHostPhase.open);
			expect(failures.single.error, same(error));
			expect(failures.single.stackTrace, same(stack));
			view.platform.send = null;
			if (kind == KlpWebKind.blockNote) {
				expect(find.text('重試'), findsOneWidget);
				await tester.tap(find.text('重試'));
				await settleWeb(tester);
				expect(find.text('重試'), findsNothing);
			} else {
				expect(find.text('重試'), findsNothing);
			}
			view.loadStop();
			view.loadStop();
			await settleWeb(tester);
			expect(view.platform.commands.where((c) => c['type'] == 'open'), hasLength(kind == KlpWebKind.blockNote ? 2 : 1));
			expect(failures, hasLength(1));
		});
	}

	for (final boundary in ['flush', 'callback']) {
		testWidgets('BlockNote $boundary failure after accepted open never replays document or releases save sender', (tester) async {
			final failures = <KlpEditingHostFailure>[];
			final error = StateError('post-open $boundary failure');
			final stack = StackTrace.fromString('original post-open $boundary');
			final session = KlpWebSession(KlpWebKind.blockNote, 'post-open-$boundary');
			var callbacks = 0;
			if (boundary == 'flush') await session.channel.send({'type': 'queued-flush'});
			await tester.pumpWidget(klpWebHost([session.content(onOpened: () async {
				callbacks++;
				if (boundary == 'callback') Error.throwWithStackTrace(error, stack);
			})], onFailure: failures.add));
			await settleWeb(tester);
			final originalState = tester.state(find.byType(KlpFlutterBlockNoteEditing));
			final view = platform.views.single;
			view.platform.send = (command) async { if (command['type'] == 'queued-flush') Error.throwWithStackTrace(error, stack); };
			view.loadStop();
			await settleWeb(tester);
			expect(failures, hasLength(1));
			expect(failures.single.phase.name, boundary);
			expect(failures.single.error, same(error));
			expect(failures.single.stackTrace, same(stack));
			expect(find.text('重試'), findsNothing);
			expect(find.text('編輯器已中斷。請保留此視窗並嘗試儲存；尚未儲存內容不會自動重載。'), findsOneWidget);
			view.loadStop();
			await settleWeb(tester);
			expect(view.platform.commands.where((c) => c['type'] == 'configure'), hasLength(1));
			expect(view.platform.commands.where((c) => c['type'] == 'open'), hasLength(1));
			expect(tester.state(find.byType(KlpFlutterBlockNoteEditing)), same(originalState));
			expect(view.disposals, 0);
			await session.channel.send({'type': 'snapshot-save-route'});
			expect(view.platform.commands.last['type'], 'snapshot-save-route');
			expect(callbacks, boundary == 'flush' ? 0 : 1);
			expect(failures, hasLength(1));
			expect(session.saves, 0);
		});
	}

	testWidgets('BlockNote detached pending callback settles once without unbinding a successor', (tester) async {
		final failures = <KlpEditingHostFailure>[];
		final session = KlpWebSession(KlpWebKind.blockNote, 'pending-callback');
		final gate = Completer<void>();
		final error = StateError('late callback');
		final stack = StackTrace.fromString('late callback original');
		var callbacks = 0;
		await tester.pumpWidget(klpWebHost([session.content(onOpened: () async { callbacks++; await gate.future; })], onFailure: failures.add));
		await settleWeb(tester);
		final view = platform.views.single;
		view.loadStop();
		await settleWeb(tester);
		expect(callbacks, 1);
		await tester.pumpWidget(const SizedBox.shrink());
		final commands = <Map<String, Object?>>[];
		await session.channel.bindPlatformSender((Map<String, Object?> command) async { commands.add(command); });
		gate.completeError(error, stack);
		await settleWeb(tester);
		await session.channel.send({'type': 'successor-after-callback'});
		expect(commands.single['type'], 'successor-after-callback');
		expect(failures, hasLength(1));
		expect(failures.single.phase, KlpEditingHostPhase.callback);
		expect(failures.single.error, same(error));
		expect(failures.single.stackTrace, same(stack));
		expect(callbacks, 1);
		session.channel.unbindPlatformSender();
	});

	for (final handler in ['KallopisBlockNoteAsset', 'KallopisBlockNoteOpenAsset', 'KallopisBlockNoteOpenReference']) {
		testWidgets('BlockNote $handler preserves callback rejection and reports original once', (tester) async {
			final failures = <KlpEditingHostFailure>[];
			final error = StateError('consumer callback failure');
			final stack = StackTrace.fromString('consumer original');
			final session = KlpWebSession(KlpWebKind.blockNote, handler);
			await tester.pumpWidget(klpWebHost([session.content(
				resolveAsset: (_) async { Error.throwWithStackTrace(error, stack); },
				onOpenAsset: (_) async { Error.throwWithStackTrace(error, stack); },
				onOpenReference: (_, _, _) async { Error.throwWithStackTrace(error, stack); },
			)], onFailure: failures.add));
			await settleWeb(tester);
			final view = platform.views.single;
			final args = handler == 'KallopisBlockNoteOpenReference' ? [{'referenceId': 'r', 'sourceDocumentId': 'd', 'sourceBlockId': 'b'}] : ['asset'];
			Object? caught;
			StackTrace? caughtStack;
			try { await view.receive(handler, args); }
			catch (value, trace) { caught = value; caughtStack = trace; }
			expect(caught, same(error));
			expect(caughtStack, same(stack));
			expect(failures, hasLength(1));
			expect(failures.single.error, same(error));
			expect(failures.single.stackTrace, same(stack));
			expect(failures.single.phase, KlpEditingHostPhase.callback);
			try { await view.receive(handler, []); } catch (_) {}
			expect(failures, hasLength(2));
			expect(failures.last.error, isFormatException);
			expect(failures.last.phase, KlpEditingHostPhase.callback);
		});
	}

	testWidgets('BlockNote asset navigation preserves cancel and console remains diagnostic', (tester) async {
		final failures = <KlpEditingHostFailure>[];
		final opened = <String>[];
		await tester.pumpWidget(klpWebHost([KlpWebSession(KlpWebKind.blockNote, 'navigation').content(onOpenAsset: (id) async { opened.add(id); })], onFailure: failures.add));
		await settleWeb(tester);
		final view = platform.views.single;
		expect(await view.navigate('asset://asset-one'), NavigationActionPolicy.CANCEL);
		expect(opened, ['asset-one']);
		view.params.onConsoleMessage?.call(view.controller, ConsoleMessage(message: 'diagnostic only', messageLevel: ConsoleMessageLevel.ERROR));
		expect(failures, isEmpty);
		final pageError = WebResourceError(type: WebResourceErrorType.UNKNOWN, description: 'native page error');
		view.params.onReceivedError?.call(view.controller, WebResourceRequest(url: WebUri('file:///editor'), isForMainFrame: true), pageError);
		await settleWeb(tester);
		expect(failures, hasLength(1));
		expect(failures.single.error, same(pageError));
		expect(failures.single.origin, KlpEditingHostOrigin.blockNote);
	});

	for (final kind in KlpWebKind.values) {
		testWidgets('$kind detach while checking runtime does not create an environment', (tester) async {
			final gate = Completer<String?>();
			final failures = <KlpEditingHostFailure>[];
			platform.availableVersion = () => gate.future;
			await tester.pumpWidget(klpWebHost([KlpWebSession(kind, 'version-check').content()], nativeWindows: true, onFailure: failures.add));
			await settleWeb(tester);
			await tester.pumpWidget(const SizedBox.shrink());
			gate.complete('runtime-late');
			await settleWeb(tester);
			expect(platform.environmentCreates, 0);
			expect(platform.views, isEmpty);
			expect(failures, isEmpty);
		});
	}
}
