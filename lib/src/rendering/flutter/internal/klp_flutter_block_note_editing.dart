import 'package:kallopis/src/foundation/localization/klp_localizations.dart';
import 'package:kallopis/src/features/editing/presentation/klp_editing_presentation.dart';
import 'package:kallopis/src/features/editing/contracts/klp_editing_host_failure.dart';
import 'dart:async';
import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:kallopis/src/features/overlays/klp_menu.dart';
import 'klp_flutter_menu.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:krepis_block_note/krepis_block_note.dart';
import 'package:kallopis/src/features/feedback/view_states/klp_view_states.dart';

import 'klp_block_note_load_error.dart';
import 'klp_block_note_web_session_loader.dart';
import '../klp_viewport_capabilities.dart';

/// 只載入 Kallopis 打包的固定 BlockNote 應用，所有 bridge 封包仍由 session controller 驗證。
final class KlpFlutterBlockNoteEditing extends StatefulWidget {
	final KlpBoundBlockNoteEditing content;
	const KlpFlutterBlockNoteEditing({required this.content, super.key});

	@override
	State<KlpFlutterBlockNoteEditing> createState() => _KlpFlutterBlockNoteEditingState();
}

final class _KlpFlutterBlockNoteEditingState extends State<KlpFlutterBlockNoteEditing> {
	InAppWebViewController? _webView;
	Future<WebViewEnvironment?>? _environment;
	late final KlpBlockNoteWebSessionLoader _loader;
	late final KlpBlockNoteSessionController _session;
	late final KlpBlockNoteBridgeChannel _channel;
	late KlpEditingHostFailureSink _failureSink;
	KlpEditingHostPhase _openPhase = KlpEditingHostPhase.bridgeReady;
	bool _closed = false;
	bool _ownsSender = false;
	bool _environmentDisposalStarted = false;

	@override
	void initState() {
		super.initState();
		_session = widget.content.controller;
		_channel = _session.bridge as KlpBlockNoteBridgeChannel;
		_loader = KlpBlockNoteWebSessionLoader(_attemptOpen, onFailure: (error, stack) => _report(_openPhase, error, stack));
	}

	@override
	void didChangeDependencies() {
		super.didChangeDependencies();
		final capabilities = KlpViewportCapabilities.of(context);
		if (capabilities == null) throw StateError('BlockNote renderer requires viewport capabilities');
		_failureSink = capabilities.onEditingHostFailure;
	}

	void _report(KlpEditingHostPhase phase, Object error, StackTrace stack) {
		_failureSink(KlpEditingHostFailure(origin: KlpEditingHostOrigin.blockNote, phase: phase, error: error, stackTrace: stack));
	}

	bool _live(InAppWebViewController controller) => !_closed && identical(controller, _webView);

	void _releaseSender() {
		if (!_ownsSender) return;
		_ownsSender = false;
		_channel.unbindPlatformSender();
	}

	@override
	Widget build(BuildContext context) {
		final l10n = KlpLocalizations.of(context);
		final capabilities = KlpViewportCapabilities.of(context);
		if (capabilities == null) throw StateError('BlockNote renderer requires viewport capabilities');
		final environment = _environment ??= _createEnvironment(capabilities.nativeWindows);
		return LayoutBuilder(builder: (context, constraints) {
			return KlpBlockNoteLoadSurface(
				loader: _loader,
				onRetry: () => unawaited(_retry()),
				child: FutureBuilder<WebViewEnvironment?>(future: environment, builder: (context, snapshot) {
					if (snapshot.connectionState != ConnectionState.done) return const SizedBox.expand();
					if (snapshot.hasError) return KlpErrorState(title: l10n.editorEnvironmentFailedTitle, message: l10n.editorEnvironmentFailedMessage);
					return _buildWebView(snapshot.data);
				}),
			);
		});
	}

	Widget _buildWebView(WebViewEnvironment? environment) {
		return InAppWebView(
			webViewEnvironment: environment,
			initialFile: 'packages/kallopis/assets/blocknote_editor/index.html',
			initialSettings: InAppWebViewSettings(javaScriptEnabled: true, useShouldOverrideUrlLoading: true),
			onWebViewCreated: _createWebView,
			onLoadStop: (_, url) {
				unawaited(_open());
			},
			onReceivedError: (_, request, error) {
				if (_closed) return;
				debugPrint('BlockNote WebView error: ${request.url} ${error.description}');
				_loader.reportFailure(error);
				_report(KlpEditingHostPhase.receive, error, StackTrace.current);
				if (mounted) setState(() {});
			},
			onConsoleMessage: (_, message) {
				if (message.messageLevel == ConsoleMessageLevel.ERROR) debugPrint('BlockNote console error: ${message.message}');
			},
			shouldOverrideUrlLoading: (_, action) async {
				if (_closed) return NavigationActionPolicy.CANCEL;
				final scheme = action.request.url?.scheme;
				if (scheme == 'asset') {
					final assetId = action.request.url?.host;
					if (assetId != null) {
						try { await widget.content.onOpenAsset?.call(assetId); }
						catch (error, stack) {
							_report(KlpEditingHostPhase.callback, error, stack);
							rethrow;
						}
					}
					return NavigationActionPolicy.CANCEL;
				}
				return scheme == 'file' || scheme == 'data' || scheme == 'about' ? NavigationActionPolicy.ALLOW : NavigationActionPolicy.CANCEL;
			},
		);
	}

	Future<WebViewEnvironment?> _createEnvironment(bool nativeWindows) async {
		try {
			if (!nativeWindows || _closed) return null;
			final version = await WebViewEnvironment.getAvailableVersion();
			if (_closed) return null;
			if (version == null) throw StateError('WebView2 Runtime 未安裝');
			// Windows plugin 要求先建立對應的 WebView2 environment。
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
		controller.addJavaScriptHandler(handlerName: 'KallopisBlockNote', callback: _receive);
		controller.addJavaScriptHandler(handlerName: 'KallopisMenu', callback: _showEditorMenu);
		controller.addJavaScriptHandler(handlerName: 'KallopisBlockNoteAsset', callback: _resolveAsset);
		controller.addJavaScriptHandler(handlerName: 'KallopisBlockNoteOpenAsset', callback: _openAsset);
		controller.addJavaScriptHandler(handlerName: 'KallopisBlockNoteOpenReference', callback: _openReference);
	}

	Future<int?> _showEditorMenu(List<dynamic> arguments) async {
		if (_closed || !mounted || arguments.length != 1 || arguments.single is! Map) return null;

		final request = arguments.single as Map;
		final entries = request['items'];
		if (entries is! List || entries.isEmpty || request['x'] is! num || request['y'] is! num) return null;

		final box = context.findRenderObject()! as RenderBox;
		final anchor = box.localToGlobal(Offset((request['x'] as num).toDouble(), (request['y'] as num).toDouble()));
		Color color(String value) {
			final rgb = int.parse(value.substring(1, 7), radix: 16);
			final alpha = value.length == 9 ? int.parse(value.substring(7, 9), radix: 16) : 255;
			return Color((alpha << 24) | rgb);
		}
		// WebView 只傳選單資料與位置；真正選單仍由庫內 KlpMenu 呈現。
		final selected = await showKlpMenuItems(
			context: context,
			anchor: anchor,
			surface: color(widget.content.background),
			foreground: color(widget.content.text),
			fontFamily: widget.content.fontFamily,
			label: '區塊',
			searchable: request['searchable'] == true,
			items: [for (final entry in entries) KlpMenuItemData(label: (entry as Map)['title'] as String, shortcut: entry['shortcut'] as String?, description: entry['description'] as String?, group: entry['group'] as String?, iconSvg: entry['iconSvg'] as String?, enabled: entry['enabled'] != false, selected: entry['selected'] == true, onPressed: () {})],
		);
		return !_closed && mounted ? selected : null;
	}


	Future<void> _openReference(List<dynamic> arguments) async {
		if (_closed) return;
		try {
			if (arguments.length != 1 || arguments.single is! Map) throw const FormatException('Invalid BlockNote reference request');
			final value = Map<String, Object?>.from(arguments.single as Map);
			final referenceId = value['referenceId'];
			final sourceDocumentId = value['sourceDocumentId'];
			final sourceBlockId = value['sourceBlockId'];
			if (referenceId is! String || sourceDocumentId is! String || sourceBlockId is! String) throw const FormatException('Invalid BlockNote reference identity');
			final opener = widget.content.onOpenReference;
			if (opener == null) throw StateError('BlockNote reference opener is unavailable');
			await opener(referenceId, sourceDocumentId, sourceBlockId);
		}
		catch (error, stack) {
			_report(KlpEditingHostPhase.callback, error, stack);
			rethrow;
		}
	}

	Future<void> _openAsset(List<dynamic> arguments) async {
		if (_closed) return;
		try {
			if (arguments.length != 1 || arguments.single is! String) throw const FormatException('Invalid BlockNote open-asset request');
			final opener = widget.content.onOpenAsset;
			if (opener == null) throw StateError('BlockNote asset opener is unavailable');
			await opener(arguments.single as String);
		}
		catch (error, stack) {
			_report(KlpEditingHostPhase.callback, error, stack);
			rethrow;
		}
	}

	Future<Map<String, Object?>> _resolveAsset(List<dynamic> arguments) async {
		if (_closed) throw StateError('BlockNote attachment is closed');
		try {
			if (arguments.length != 1 || arguments.single is! String) throw const FormatException('Invalid BlockNote asset request');
			final resolver = widget.content.resolveAsset;
			if (resolver == null) throw StateError('BlockNote asset resolver is unavailable');
			final asset = await resolver(arguments.single as String);
			return {'mediaType': asset.mediaType, 'base64': base64Encode(asset.bytes)};
		}
		catch (error, stack) {
			_report(KlpEditingHostPhase.callback, error, stack);
			rethrow;
		}
	}

	Future<void> _open() async {
		if (_closed) return;
		await _loader.open();
		if (mounted) setState(() {});
	}

	Future<void> _retry() async {
		if (_closed) return;
		await _loader.retry();
		if (mounted) setState(() {});
	}

	Future<void> _attemptOpen() async {
		final controller = _webView;
		if (_closed || controller == null) return;
		var opened = false;
		try {
			_openPhase = KlpEditingHostPhase.bridgeReady;
			await _waitForBridge(controller);
			if (!_live(controller)) return;
			_openPhase = KlpEditingHostPhase.bind;
			await _channel.bindPlatformSender((command) => _send(controller, command), flushPending: false);
			_ownsSender = true;
			if (!_live(controller)) {
				_releaseSender();
				return;
			}
			_openPhase = KlpEditingHostPhase.configure;
			await _send(controller, {
				'protocolVersion': KlpBlockNoteSessionController.protocolVersion,
				'type': 'configure',
				'sessionId': _session.sessionId,
				'requestId': 1,
				'revision': _session.revision,
				'appearance': {
					'background': widget.content.background,
					'text': widget.content.text,
					'fontFamily': widget.content.fontFamily,
					'fontSize': widget.content.fontSize,
				},
			});
			if (!_live(controller)) return;
			_openPhase = KlpEditingHostPhase.open;
			await _session.open();
			opened = true;
			_loader.markOpened();
			if (!_live(controller)) return;
			_openPhase = KlpEditingHostPhase.flush;
			await _channel.flush();
			if (!_live(controller)) return;
			_openPhase = KlpEditingHostPhase.callback;
			await widget.content.onOpened?.call();
		}
		catch (_) {
			if (!opened) _releaseSender();
			rethrow;
		}
	}

	Future<void> _waitForBridge(InAppWebViewController controller) async {
		for (var attempt = 0; attempt < 50; attempt++) {
			if (!_live(controller)) return;
			final ready = await controller.evaluateJavascript(source: "typeof window.kallopisBlockNote?.receive === 'function'");
			if (!_live(controller)) return;
			if (ready == true) return;
			await Future<void>.delayed(const Duration(milliseconds: 100));
			if (!_live(controller)) return;
		}
		throw TimeoutException('BlockNote web bridge was not registered');
	}

	Future<void> _send(InAppWebViewController controller, Map<String, Object?> command) async {
		if (!_live(controller)) throw StateError('BlockNote attachment is closed');
		final source = 'window.kallopisBlockNote.receive(${jsonEncode(command)});';

		// 固定呼叫已打包應用的單一封閉入口，不接受 consumer script。
		await controller.evaluateJavascript(source: source);
	}

	Future<Object?> _receive(List<dynamic> arguments) async {
		if (_closed) return null;
		try {
			if (arguments.length != 1 || arguments.single is! Map) throw const FormatException('Invalid BlockNote WebView message');
			final message = Map<String, Object?>.from(arguments.single as Map);
			_session.accept(message);
			if (mounted) setState(() {});
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
		// 建立失敗已由建立操作回報；此處只處理成功結果的唯一釋放。
		if (environment != null) unawaited(environment.then(_disposeEnvironment, onError: (Object error, StackTrace stack) {}));
		super.dispose();
	}
}
