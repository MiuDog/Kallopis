import 'package:kallopis/src/features/editing/presentation/klp_editing_presentation.dart';
import 'package:kallopis/src/features/editing/contracts/klp_editing_host_failure.dart';
import 'dart:async';
import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:krepis_canva/krepis_canva.dart';

import '../klp_viewport_capabilities.dart';

/// 固定載入本地 Excalidraw bundle；bridge 封包仍由 Krepis 驗證。
final class KlpFlutterCanvaEditing extends StatefulWidget {
	final KlpBoundCanvaEditing content;
	const KlpFlutterCanvaEditing({required this.content, super.key});

	@override
	State<KlpFlutterCanvaEditing> createState() => _KlpFlutterCanvaEditingState();
}

final class _KlpFlutterCanvaEditingState extends State<KlpFlutterCanvaEditing> {
	InAppWebViewController? _webView;
	Future<WebViewEnvironment?>? _environment;
	late final KrepisCanvaSessionController _session;
	late final KrepisCanvaBridgeChannel _channel;
	late KlpEditingHostFailureSink _failureSink;
	Future<void>? _opening;
	bool _attempted = false;
	bool _opened = false;
	bool _closed = false;
	bool _ownsSender = false;
	bool _environmentDisposalStarted = false;

	@override
	void initState() {
		super.initState();
		_session = widget.content.controller;
		_channel = _session.bridge as KrepisCanvaBridgeChannel;
	}

	@override
	void didChangeDependencies() {
		super.didChangeDependencies();
		final capabilities = KlpViewportCapabilities.of(context);
		if (capabilities == null) throw StateError('Canva renderer requires viewport capabilities');
		_failureSink = capabilities.onEditingHostFailure;
	}

	void _report(KlpEditingHostPhase phase, Object error, StackTrace stack) {
		_failureSink(KlpEditingHostFailure(origin: KlpEditingHostOrigin.canva, phase: phase, error: error, stackTrace: stack));
	}

	bool _live(InAppWebViewController controller) => !_closed && identical(controller, _webView);

	void _releaseSender() {
		if (!_ownsSender) return;
		_ownsSender = false;
		_channel.unbindPlatformSender();
	}

	@override
	Widget build(BuildContext context) {
		final capabilities = KlpViewportCapabilities.of(context);
		if (capabilities == null) throw StateError('Canva renderer requires viewport capabilities');
		final environment = _environment ??= _createEnvironment(capabilities.nativeWindows);
		return FutureBuilder<WebViewEnvironment?>(future: environment, builder: (context, snapshot) {
			if (snapshot.connectionState != ConnectionState.done) return const SizedBox.expand();
			if (snapshot.hasError) return const SizedBox.expand();
			return InAppWebView(
				webViewEnvironment: snapshot.data,
				initialFile: 'packages/kallopis/assets/canva_editor/index.html',
				initialSettings: InAppWebViewSettings(javaScriptEnabled: true, useShouldOverrideUrlLoading: true),
				onWebViewCreated: _createWebView,
				onLoadStop: (_, _) => unawaited(_open()),
				onReceivedError: (_, request, error) {
					if (_closed) return;
					_report(KlpEditingHostPhase.receive, error, StackTrace.current);
				},
				shouldOverrideUrlLoading: (_, action) async {
					if (_closed) return NavigationActionPolicy.CANCEL;
					final scheme = action.request.url?.scheme;
					return scheme == 'file' || scheme == 'data' || scheme == 'about' ? NavigationActionPolicy.ALLOW : NavigationActionPolicy.CANCEL;
				},
			);
		});
	}

	Future<WebViewEnvironment?> _createEnvironment(bool nativeWindows) async {
		try {
			if (!nativeWindows || _closed) return null;
			final version = await WebViewEnvironment.getAvailableVersion();
			if (_closed) return null;
			if (version == null) throw StateError('WebView2 Runtime 未安裝');
			return await WebViewEnvironment.create();
		}
		catch (error, stack) {
			_report(KlpEditingHostPhase.environmentCreate, error, stack);
			rethrow;
		}
	}

	void _createWebView(InAppWebViewController controller) {
		if (_closed) return;
		_webView = controller;
		controller.addJavaScriptHandler(handlerName: 'KallopisCanva', callback: _receive);
	}

	Future<void> _open() {
		final active = _opening;
		if (active != null) return active;
		if (_closed || _attempted) return Future<void>.value();
		_attempted = true;
		final future = _attemptOpen();
		_opening = future;
		return future.whenComplete(() {
			if (identical(_opening, future)) _opening = null;
		});
	}

	Future<void> _attemptOpen() async {
		final controller = _webView;
		if (_closed || controller == null) return;
		var phase = KlpEditingHostPhase.bridgeReady;
		try {
			await _waitForBridge(controller);
			if (!_live(controller)) return;
			phase = KlpEditingHostPhase.bind;
			await _channel.bindPlatformSender((command) => _send(controller, command), flushPending: false);
			_ownsSender = true;
			if (!_live(controller)) {
				_releaseSender();
				return;
			}
			phase = KlpEditingHostPhase.open;
			await _session.open();
			_opened = true;
			if (!_live(controller)) return;
			phase = KlpEditingHostPhase.flush;
			await _channel.flush();
		}
		catch (error, stack) {
			if (!_opened) _releaseSender();
			_report(phase, error, stack);
		}
	}

	Future<void> _waitForBridge(InAppWebViewController controller) async {
		for (var attempt = 0; attempt < 50; attempt++) {
			if (!_live(controller)) return;
			final ready = await controller.evaluateJavascript(source: "typeof window.kallopisCanva?.receive === 'function'");
			if (!_live(controller)) return;
			if (ready == true) return;
			await Future<void>.delayed(const Duration(milliseconds: 100));
			if (!_live(controller)) return;
		}
		throw TimeoutException('Canva web bridge was not registered');
	}

	Future<void> _send(InAppWebViewController controller, Map<String, Object?> command) async {
		if (!_live(controller)) throw StateError('Canva attachment is closed');
		await controller.evaluateJavascript(source: 'window.kallopisCanva.receive(${jsonEncode(command)});');
	}

	Future<Object?> _receive(List<dynamic> arguments) async {
		if (_closed) return null;
		try {
			if (arguments.length != 1 || arguments.single is! Map) throw const FormatException('Invalid Canva WebView message');
			_session.accept(Map<String, Object?>.from(arguments.single as Map));
			return null;
		}
		catch (error, stack) {
			_report(KlpEditingHostPhase.receive, error, stack);
			rethrow;
		}
	}

	Future<void> _disposeEnvironment(WebViewEnvironment? value) async {
		if (_environmentDisposalStarted || value == null) return;
		_environmentDisposalStarted = true;
		try { await value.dispose(); }
		catch (error, stack) { _report(KlpEditingHostPhase.dispose, error, stack); }
	}

	@override
	void dispose() {
		_closed = true;
		_releaseSender();
		_webView = null;
		final environment = _environment;
		// 建立失敗由建立操作回報；晚到的成功結果只釋放一次。
		if (environment != null) unawaited(environment.then(_disposeEnvironment, onError: (Object error, StackTrace stack) {}));
		super.dispose();
	}
}
