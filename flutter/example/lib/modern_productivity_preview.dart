import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kallopis/kallopis_foundation.dart';
import 'modern_productivity_starter.dart';

/// 真實公開模板的參數預覽；設定與 consumer 草稿分離。
class ModernProductivityPreview extends StatefulWidget {
	/* id：唯一模板路由，避免未知名稱退回其他展示。 */
	final String id;
	const ModernProductivityPreview({super.key, required this.id});
	@override
	State<ModernProductivityPreview> createState() => _ModernProductivityPreviewState();
}

class _ModernProductivityPreviewState extends State<ModernProductivityPreview> {
	/* _base／_pack：正式預設與最後有效局部風格；_overrides：可複製的 semantic 差異。
	 * _mode／_width：預覽環境；_widthInput：輸入文字；_feedback：操作結果。 */
	final _base = KlpStylePack.defaults();
	late KlpStylePack _pack = _base;
	Map<String, Object?> _overrides = {};
	KlpThemeVariant _mode = KlpThemeVariant.light;
	double? _width;
	final _widthInput = TextEditingController();
	String _feedback = '';
	/* _fields：可調語意與介面名稱，數值仍從正式 pack 取得。 */
	static const _fields = {
		'theme.spacing.chromeHeader': 'Header 最小高度',
		'theme.spacing.space2': '外距與欄間距',
		'theme.spacing.actionGap': '按鈕列間距',
		'theme.shape.panel': '側欄圓角',
		'theme.geometry.control.buttonHeight': '切換按鈕高度',
	};
	@override
	void dispose() { _widthInput.dispose(); super.dispose(); }
	void _setWidth(String value) {
		final width = double.tryParse(value);
		if (value.isNotEmpty && (width == null || !width.isFinite || width <= 0)) { setState(() => _feedback = '側欄寬度必須是有限正數；保留上一份設定。'); return; }
		setState(() { _width = width; _feedback = ''; });
	}
	void _setSemantic(String id, String? expression) {
		if (expression == null) return;
		final semantics = Map<String, Object?>.from((_overrides['semantics'] as Map<String, Object?>?) ?? {});
		final modes = Map<String, Object?>.from((semantics[id] as Map<String, Object?>?) ?? {});
		if (expression.isEmpty) { modes.remove(_mode.name); } else { modes[_mode.name] = expression; }
		if (modes.isEmpty) { semantics.remove(id); } else { semantics[id] = modes; }
		final next = <String, Object?>{'semantics': semantics};
		try {
			final pack = _base.applyOverrides(next);
			setState(() { _pack = pack; _overrides = next; _feedback = ''; });
		} catch (error) { setState(() => _feedback = '設定無效，保留上一份設定：$error'); }
	}
	void _reset() => setState(() { _pack = _base; _overrides = {}; _width = null; _widthInput.clear(); _feedback = '設定已還原；功能選取與草稿保持。'; });
	String _snippet() {
		final source = const JsonEncoder.withIndent('\t').convert(_overrides);
		return '// modern-productivity-layout v1 · kallopis 0.8.0\n'
			"import 'dart:convert';\nimport 'package:kallopis/kallopis_foundation.dart';\n"
			"final pack = KlpStylePack.defaults().applyOverrides(jsonDecode(r'''$source''') as Map<String, dynamic>);\n"
			'final theme = buildKlpThemeVariant(KlpThemeVariant.${_mode.name}, stylePack: pack);\n'
			'// 將 theme 提供給 MaterialApp；使用起始範例：\n'
			'ModernProductivityStarter(sidebarWidth: ${_width ?? 'null'});';
	}
	Future<void> _copy() async {
		try { await Clipboard.setData(ClipboardData(text: _snippet())); if (mounted) setState(() => _feedback = '設定已複製。'); }
		catch (_) { if (mounted) setState(() => _feedback = '無法自動複製，請手動選取下方文字。'); }
	}
	@override
	Widget build(BuildContext context) => MaterialApp(
		debugShowCheckedModeBanner: false,
		title: '現代風生產力佈局 · Flutter',
		theme: buildKlpThemeVariant(_mode, stylePack: _pack),
		home: Material(child: Builder(builder: _content)),
	);
	Widget _content(BuildContext context) {
		if (widget.id != 'modern-productivity-layout') return const Center(child: KlpText('未知或歧義的模板路由。'));
		final primitives = (_base.data['primitives'] as Map).entries.where((entry) => entry.value is num && (entry.value as num).isFinite && (entry.value as num) >= 0).toList()..sort((a, b) => (a.value as num).compareTo(b.value as num));
		final semantics = (_overrides['semantics'] as Map<String, Object?>?) ?? {};
		final space = context.klp.space;
		return SafeArea(child: LayoutBuilder(builder: (context, bounds) => Column(children: [
			SizedBox(height: bounds.maxHeight * .35, child: SingleChildScrollView(child: Padding(padding: EdgeInsets.all(space.contentInset), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
				const KlpText('現代風生產力佈局 · 即時調整'),
				Wrap(spacing: space.actionGap, runSpacing: space.actionGap, children: [for (final mode in KlpThemeVariant.values) KlpButton(label: mode.name, selected: mode == _mode, onPressed: () => setState(() => _mode = mode)), KlpButton(label: '還原設定', onPressed: _reset), KlpButton(label: '複製設定', onPressed: _copy)]),
				SizedBox(width: 240, child: TextField(controller: _widthInput, keyboardType: TextInputType.number, onChanged: _setWidth, decoration: const InputDecoration(labelText: '側欄寬度（空白使用預設）'))),
				Wrap(spacing: space.actionGap, runSpacing: space.actionGap, children: [for (final entry in _fields.entries) SizedBox(width: 240, child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
					KlpText(entry.value),
					DropdownButton<String>(
						isExpanded: true,
						value: (semantics[entry.key] as Map<String, Object?>?)?[_mode.name] as String? ?? '',
						items: [const DropdownMenuItem(value: '', child: Text('預設')), for (final primitive in primitives) DropdownMenuItem(value: 'p(${primitive.key})', child: Text('${primitive.value} · ${primitive.key}'))],
						onChanged: (value) => _setSemantic(entry.key, value),
					),
				]))]),
				KlpText(_feedback),
				SelectableText(_snippet()),
			])))),
			Expanded(child: ModernProductivityStarter(sidebarWidth: _width)),
		])));
	}
}
