import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:kallopis/src/features/editing/contracts/klp_editing_host_failure.dart';
export 'package:kallopis/src/features/editing/contracts/klp_editing_host_failure.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kallopis/kallopis.dart';
import 'package:kallopis/src/foundation/binding/contracts/klp_bound_template.dart';
import 'package:kallopis/src/features/editing/presentation/klp_editing_presentation.dart';
import 'package:kallopis/src/features/editing/contracts/klp_block_note_editing_content.dart';
import 'package:kallopis/src/rendering/flutter/klp_flutter_renderer.dart';
import 'package:kallopis/src/rendering/flutter/klp_viewport_capabilities.dart';
import 'package:krepis_block_note/krepis_block_note.dart';
import 'package:krepis_canva/krepis_canva.dart';

/// 僅替換套件公開的平台工廠；實際 renderer、宿主及上游 channel 仍完整執行。
final class KlpWebPlatform extends InAppWebViewPlatform {
	final views = <KlpWebView>[];
	final environments = <KlpWebEnvironment>[];
	int environmentCreates = 0;
	Future<void> Function()? createEnvironment;
	Future<void> Function()? disposeEnvironment;
	Future<String?> Function()? availableVersion;

	@override
	PlatformInAppWebViewWidget createPlatformInAppWebViewWidget(PlatformInAppWebViewWidgetCreationParams params) => _WebWidget(this, params);
	@override
	PlatformWebViewEnvironment createPlatformWebViewEnvironmentStatic() => _EnvironmentFactory(this);
	@override
	PlatformWebViewEnvironment createPlatformWebViewEnvironment(PlatformWebViewEnvironmentCreationParams params) => _EnvironmentFactory(this);
}

final class _WebWidget extends PlatformInAppWebViewWidget {
	final KlpWebPlatform owner;
	_WebWidget(this.owner, super.params) : super.implementation();
	@override
	Widget build(BuildContext context) => _WebMount(platform: this);
	@override
	T controllerFromPlatform<T>(PlatformInAppWebViewController controller) => params.controllerFromPlatform!(controller) as T;
	@override
	void dispose() {}
}

final class _WebMount extends StatefulWidget {
	final _WebWidget platform;
	const _WebMount({required this.platform});
	@override
	State<_WebMount> createState() => _WebMountState();
}

final class _WebMountState extends State<_WebMount> {
	late final KlpWebView view;
	@override
	void initState() {
		super.initState();
		view = KlpWebView(widget.platform.params);
		widget.platform.owner.views.add(view);
		WidgetsBinding.instance.addPostFrameCallback((_) {
			if (mounted) view.params.onWebViewCreated?.call(view.controller);
		});
	}
	@override
	void didUpdateWidget(_WebMount oldWidget) {
		super.didUpdateWidget(oldWidget);
		view.params = widget.platform.params;
	}
	@override
	Widget build(BuildContext context) => const SizedBox.expand();
	@override
	void dispose() {
		view.disposals++;
		super.dispose();
	}
}

final class KlpWebView {
	PlatformInAppWebViewWidgetCreationParams params;
	late final KlpWebController platform = KlpWebController();
	late final dynamic controller = params.controllerFromPlatform!(platform);
	int disposals = 0;
	KlpWebView(this.params);
	void loadStop() => params.onLoadStop?.call(controller, WebUri('file:///editor/index.html'));
	Future<dynamic> receive(String handler, List<dynamic> args) async => await platform.handlers[handler]!(args);
	Future<NavigationActionPolicy?> navigate(String url) async => await params.shouldOverrideUrlLoading?.call(controller, NavigationAction(request: URLRequest(url: WebUri(url)), isForMainFrame: true));
}

final class KlpWebController extends PlatformInAppWebViewController {
	final handlers = <String, JavaScriptHandlerCallback>{};
	final commands = <Map<String, Object?>>[];
	int readinessCalls = 0;
	Future<dynamic> Function()? readiness;
	Future<void> Function(Map<String, Object?>)? send;
	KlpWebController() : super.implementation(const PlatformInAppWebViewControllerCreationParams(id: 'test'));
	@override
	void addJavaScriptHandler({required String handlerName, required JavaScriptHandlerCallback callback}) => handlers[handlerName] = callback;
	@override
	Future<dynamic> evaluateJavascript({required String source, ContentWorld? contentWorld}) async {
		if (source.startsWith('typeof ')) {
			readinessCalls++;
			return readiness == null ? true : await readiness!();
		}
		final command = Map<String, Object?>.from(jsonDecode(source.substring(source.indexOf('(') + 1, source.lastIndexOf(')'))) as Map);
		commands.add(command);
		await send?.call(command);
		return null;
	}
}

final class _EnvironmentFactory extends PlatformWebViewEnvironment {
	final KlpWebPlatform owner;
	_EnvironmentFactory(this.owner) : super.implementation(const PlatformWebViewEnvironmentCreationParams());
	@override
	Future<String?> getAvailableVersion({String? browserExecutableFolder}) async => owner.availableVersion == null ? 'test-runtime' : await owner.availableVersion!();
	@override
	Future<PlatformWebViewEnvironment> create({WebViewEnvironmentSettings? settings}) async {
		owner.environmentCreates++;
		await owner.createEnvironment?.call();
		final environment = KlpWebEnvironment(owner);
		owner.environments.add(environment);
		return environment;
	}
}

final class KlpWebEnvironment extends PlatformWebViewEnvironment {
	final KlpWebPlatform owner;
	int disposals = 0;
	KlpWebEnvironment(this.owner) : super.implementation(const PlatformWebViewEnvironmentCreationParams());
	@override
	String get id => 'test-environment';
	@override
	Future<void> dispose() async {
		disposals++;
		await owner.disposeEnvironment?.call();
	}
}

enum KlpWebKind { blockNote, canva }

final class KlpWebSession {
	final KlpWebKind kind;
	late final dynamic channel;
	late final dynamic controller;
	int saves = 0;
	KlpWebSession(this.kind, String id) {
		if (kind == KlpWebKind.blockNote) {
			channel = KlpBlockNoteBridgeChannel();
			controller = KlpBlockNoteSessionController(documentId: id, sessionId: id, initialDocument: KlpBlockNoteDocument(schemaVersion: 1, blockNoteVersion: '0.54.2', blocks: const []), bridge: channel, persist: (_) async { saves++; });
		} else {
			channel = KrepisCanvaBridgeChannel();
			controller = KrepisCanvaSessionController(documentId: id, sessionId: id, initialDocument: KrepisCanvaDocument.empty(), bridge: channel, persist: (_) async { saves++; });
		}
	}
	KlpBoundTemplate content({Future<void> Function()? onOpened, Future<void> Function(String)? onOpenAsset, Future<KlpResolvedAsset> Function(String)? resolveAsset, Future<void> Function(String, String, String)? onOpenReference}) => kind == KlpWebKind.blockNote
		? KlpBoundBlockNoteEditing(controller, background: '#ffffff', text: '#000000', fontFamily: 'Test', fontSize: 14, onOpened: onOpened, onOpenAsset: onOpenAsset, resolveAsset: resolveAsset, onOpenReference: onOpenReference)
		: KlpBoundCanvaEditing(controller);
}

void failOnWebError(KlpEditingHostFailure failure) => fail('Unexpected ${failure.origin}/${failure.phase}: ${failure.error}');

Widget klpWebHost(List<KlpBoundTemplate> contents, {bool nativeWindows = false, KlpEditingHostFailureSink onFailure = failOnWebError}) => MaterialApp(
	theme: buildKlpTheme(Brightness.light),
	home: KlpViewportCapabilities(onEditingHostFailure: onFailure, desktop: true, nativeWindows: nativeWindows, backHandlers: const [], child: Row(children: [
		for (var i = 0; i < contents.length; i++) Expanded(key: ValueKey(i), child: KlpFlutterRenderer(content: contents[i])),
	])),
);

Future<void> settleWeb(WidgetTester tester) async {
	await tester.pump();
	await tester.pump();
}
