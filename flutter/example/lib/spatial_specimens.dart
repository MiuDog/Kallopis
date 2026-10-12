import 'package:flutter/widgets.dart';
import 'package:kallopis/kallopis_foundation.dart';

/* 每個名稱都渲染自身公開 target；Flex／Stack target 使用合法父層。 */
const spatialSpecimenNames = <String>['KlpAlign', 'KlpBox', 'KlpCenter', 'KlpColumn', 'KlpConstrainedBox', 'KlpDirectionalPositioned', 'KlpDivider', 'KlpExpanded', 'KlpFit', 'KlpFlexible', 'KlpGap', 'KlpLayoutBuilder', 'KlpPositioned', 'KlpRegion', 'KlpRotate', 'KlpRow', 'KlpScrollViewport', 'KlpSection', 'KlpSpacer', 'KlpStack', 'KlpTranslate', 'KlpWrap'];

class SpatialComponentSpecimen extends StatefulWidget {
	const SpatialComponentSpecimen({super.key, required this.name});
	/* 公開名稱選取專屬 fixture，不接受其他展示替代。 */
	final String name;
	@override
	State<SpatialComponentSpecimen> createState() => _SpatialComponentSpecimenState();
}

class _SpatialComponentSpecimenState extends State<SpatialComponentSpecimen> {
	/* 資料 owner 不因 theme 或宿主尺寸變更重建，epoch 才清除。 */
	final _draft = TextEditingController(text: '布局草稿：切換風格仍保留');
	final _scroll = ScrollController();
	static const _alignments = [Alignment.topLeft, Alignment.center, Alignment.bottomRight];
	static const _main = [MainAxisAlignment.start, MainAxisAlignment.center, MainAxisAlignment.end, MainAxisAlignment.spaceBetween];
	static const _cross = [CrossAxisAlignment.start, CrossAxisAlignment.center, CrossAxisAlignment.end, CrossAxisAlignment.stretch];
	static const _spaces = [KlpSpaceSize.tight, KlpSpaceSize.contentInline, KlpSpaceSize.section];
	int _primary = 0;
	int _secondary = 0;
	int _spacing = 0;
	int _tone = 0;
	int _changes = 0;
	int _scrollChanges = 0;
	bool _short = false;
	bool _wide = false;
	bool _enabled = false;
	bool _extra = false;
	bool _header = true;
	bool _footer = true;

	@override
	void initState() { super.initState(); _scroll.addListener(_onScroll); }
	@override
	void dispose() { _scroll.removeListener(_onScroll); _scroll.dispose(); _draft.dispose(); super.dispose(); }
	void _onScroll() { if (mounted) setState(() => _scrollChanges++); }
	void _onChange(String value) => setState(() => _changes++);
	void _toggleWide() => setState(() => _wide = !_wide);
	void _toggleEnabled() => setState(() => _enabled = !_enabled);
	void _toggleExtra() => setState(() => _extra = !_extra);
	void _cyclePrimary(int length) => setState(() => _primary = (_primary + 1) % length);
	void _cycleSecondary(int length) => setState(() => _secondary = (_secondary + 1) % length);
	void _cycleSpacing() => setState(() => _spacing = (_spacing + 1) % _spaces.length);
	Widget _control(String label, VoidCallback action) => KlpButton(label: label, onPressed: action);
	double get _extent => _wide ? 48 : 12;
	int get _flex => _wide ? 3 : 1;

	List<Widget> _controls() {
		final result = <Widget>[_control('展示高度：${_short ? 180 : 280}', () => setState(() => _short = !_short))];
		switch (widget.name) {
			case 'KlpAlign':
				result.add(_control('alignment：$_primary', () => _cyclePrimary(_alignments.length)));
				result.add(_control('shrinkWidth：$_enabled', _toggleEnabled));
			case 'KlpCenter':
				result.add(_control('widthFactor：${_wide ? 2 : 1}', _toggleWide));
				result.add(_control('heightFactor：${_enabled ? 2 : 1}', _toggleEnabled));
			case 'KlpBox':
				result.add(_control('width／height：${_wide ? '220／100' : '140／72'}', _toggleWide));
				result.add(_control('paddingSize／marginSize：${_spaces[_spacing].name}', _cycleSpacing));
				result.add(_control('tone：${KlpSurfaceTone.values[_tone].name}', () => setState(() => _tone = (_tone + 1) % KlpSurfaceTone.values.length)));
				result.add(_control('radius：${_enabled ? 0 : 'semantic'}', _toggleEnabled));
			case 'KlpRow':
			case 'KlpColumn':
				result.add(_control('mainAxisAlignment：${_main[_primary].name}', () => _cyclePrimary(_main.length)));
				result.add(_control('crossAxisAlignment：${_cross[_secondary].name}', () => _cycleSecondary(_cross.length)));
				result.add(_control('mainAxisSize：${_enabled ? 'min' : 'max'}', _toggleEnabled));
				result.add(_control('gap：$_extent', _toggleWide));
				result.add(_control('children：${_extra ? 3 : 2}', _toggleExtra));
			case 'KlpConstrainedBox':
				result.add(_control('constraints.maxWidth／maxHeight：${_wide ? '240／120' : '120／80'}', _toggleWide));
				result.add(_control('constraints.minimum：${_enabled ? 60 : 0}', _toggleEnabled));
			case 'KlpExpanded':
			case 'KlpSpacer':
				result.add(_control('flex：$_flex', _toggleWide));
			case 'KlpFlexible':
				result.add(_control('flex：$_flex', _toggleWide));
				result.add(_control('fit：${_enabled ? 'tight' : 'loose'}', _toggleEnabled));
			case 'KlpPositioned':
				result.add(_control('left／top：$_extent', _toggleWide));
				result.add(_control('width／height：${_enabled ? '140／90' : '100／64'}', _toggleEnabled));
			case 'KlpDirectionalPositioned':
				result.add(_control('position.start／top：$_extent', _toggleWide));
				result.add(_control('Directionality：${_enabled ? 'rtl' : 'ltr'}', _toggleEnabled));
			case 'KlpDivider':
				result.add(_control('vertical：$_enabled', _toggleEnabled));
			case 'KlpFit':
				result.add(_control('mode：${KlpFitMode.values[_primary].name}', () => _cyclePrimary(KlpFitMode.values.length)));
			case 'KlpGap':
				result.add(_control('constructor：${_enabled ? 'height' : 'width'}', _toggleEnabled));
				result.add(_control('extent：$_extent', _toggleWide));
				result.add(_control('semanticSize：${_extra ? _spaces[_spacing].name : 'null'}', _toggleExtra));
				if (_extra) result.add(_control('size：${_spaces[_spacing].name}', _cycleSpacing));
			case 'KlpLayoutBuilder':
				result.add(_control('builder文字：${_enabled ? '詳細' : '標準'}', _toggleEnabled));
			case 'KlpRotate':
				result.add(_control('turn：${KlpQuarterTurn.values[_primary].name}', () => _cyclePrimary(KlpQuarterTurn.values.length)));
			case 'KlpTranslate':
				result.add(_control('translation.horizontal：$_extent', _toggleWide));
				result.add(_control('translation.vertical：${_enabled ? 32 : 0}', _toggleEnabled));
			case 'KlpStack':
				result.add(_control('alignment：$_primary', () => _cyclePrimary(_alignments.length)));
				result.add(_control('fit：${_enabled ? 'expand' : 'loose'}', _toggleEnabled));
				result.add(_control('clipBehavior：${_wide ? 'none' : 'hardEdge'}', _toggleWide));
				result.add(_control('children：${_extra ? 3 : 2}', _toggleExtra));
			case 'KlpWrap':
				result.add(_control('direction：${_enabled ? 'vertical' : 'horizontal'}', _toggleEnabled));
				result.add(_control('alignment：${WrapAlignment.values[_primary].name}', () => _cyclePrimary(WrapAlignment.values.length)));
				result.add(_control('spacingSize／runSpacingSize：${_spaces[_spacing].name}', _cycleSpacing));
				result.add(_control('children：${_extra ? 8 : 4}', _toggleExtra));
			case 'KlpScrollViewport':
				result.add(_control('padding：${_enabled ? 'contentInset' : 'zero'}', _toggleEnabled));
				result.add(_control('捲至末尾', _scrollToEnd));
			case 'KlpRegion':
				result.add(_control('header：$_header', () => setState(() => _header = !_header)));
				result.add(_control('footer：$_footer', () => setState(() => _footer = !_footer)));
				result.add(_control('tone：${KlpSurfaceTone.values[_tone].name}', () => setState(() => _tone = (_tone + 1) % KlpSurfaceTone.values.length)));
				result.add(_control('padding：${_enabled ? 'contentInset' : 'zero'}', _toggleEnabled));
			case 'KlpSection':
				result.add(_control('label：$_enabled', _toggleEnabled));
				result.add(_control('trailing：$_extra', _toggleExtra));
		}
		return result;
	}

	void _scrollToEnd() { if (_scroll.hasClients) _scroll.animateTo(_scroll.position.maxScrollExtent, duration: const Duration(milliseconds: 200), curve: Curves.linear); }
	Widget _measure(BuildContext context, BoxConstraints constraints) => KlpText('實際約束 ${constraints.maxWidth.toStringAsFixed(1)} × ${constraints.maxHeight.toStringAsFixed(1)}', role: KlpTextRole.code);
	Widget _tile(String label) => SizedBox(width: 80, height: 44, child: KlpSurface(child: KlpText(label, maxLines: 1)));
	List<Widget> _tiles(int count) => [for (var i = 0; i < count; i++) _tile('項目 ${i + 1}')];
	List<Widget> _flexTiles(int count) => [for (var i = 0; i < count; i++) Flexible(child: _tile('項目 ${i + 1}'))];
	Widget _sample() => LayoutBuilder(builder: _sampleBody);
	Widget _fixedSample() => SizedBox(width: 120, height: 80, child: _sample());
	Widget _sampleBody(BuildContext context, BoxConstraints constraints) => KlpSurface(child: SingleChildScrollView(child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [KlpText(_draft.text, maxLines: 1), _measure(context, constraints)])));
	Widget _builderBody(BuildContext context, BoxConstraints constraints) => Column(crossAxisAlignment: CrossAxisAlignment.start, children: [KlpText(_enabled ? '詳細 builder：${_draft.text}' : 'builder：${_draft.text}'), _measure(context, constraints)]);

	Widget _target(BuildContext context) {
		final padding = _enabled ? EdgeInsets.all(context.klp.space.contentInset) : EdgeInsets.zero;
		switch (widget.name) {
			case 'KlpAlign': return Align(alignment: Alignment.topLeft, child: KlpAlign(alignment: _alignments[_primary], shrinkWidth: _enabled, child: _fixedSample()));
			case 'KlpCenter': return Align(alignment: Alignment.topLeft, child: KlpCenter(widthFactor: _wide ? 2 : 1, heightFactor: _enabled ? 2 : 1, child: _fixedSample()));
			case 'KlpBox':
				final box = KlpBox(
					width: _wide ? 220 : 140,
					height: _wide ? 100 : 72,
					paddingSize: _spaces[_spacing],
					marginSize: _spaces[_spacing],
					tone: KlpSurfaceTone.values[_tone],
					radius: _enabled ? 0 : null,
					child: _sample(),
				);
				return Align(alignment: Alignment.topLeft, child: box);
			case 'KlpRow': return KlpRow(mainAxisAlignment: _main[_primary], crossAxisAlignment: _cross[_secondary], mainAxisSize: _enabled ? MainAxisSize.min : MainAxisSize.max, gap: _extent, children: _flexTiles(_extra ? 3 : 2));
			case 'KlpColumn': return KlpColumn(mainAxisAlignment: _main[_primary], crossAxisAlignment: _cross[_secondary], mainAxisSize: _enabled ? MainAxisSize.min : MainAxisSize.max, gap: _extent, children: _flexTiles(_extra ? 3 : 2));
			case 'KlpConstrainedBox': return Align(alignment: Alignment.topLeft, child: KlpConstrainedBox(constraints: KlpBoxConstraints(minWidth: _enabled ? 60 : 0, minHeight: _enabled ? 60 : 0, maxWidth: _wide ? 240 : 120, maxHeight: _wide ? 120 : 80), child: _sample()));
			case 'KlpExpanded': return Row(children: [KlpExpanded(flex: _flex, child: _sample()), Expanded(child: _tile('伴槽'))]);
			case 'KlpFlexible': return Row(children: [KlpFlexible(flex: _flex, fit: _enabled ? FlexFit.tight : FlexFit.loose, child: _sample()), Expanded(child: _tile('伴槽'))]);
			case 'KlpSpacer': return Row(children: [_tile('起點'), KlpSpacer(flex: _flex), const Spacer(), _tile('終點')]);
			case 'KlpPositioned': return Stack(children: [KlpPositioned(left: _extent, top: _extent, width: _enabled ? 140 : 100, height: _enabled ? 90 : 64, child: _sample())]);
			case 'KlpDirectionalPositioned': return Directionality(textDirection: _enabled ? TextDirection.rtl : TextDirection.ltr, child: Stack(children: [KlpDirectionalPositioned(position: KlpDirectionalPosition(start: _extent, top: _extent, width: 120, height: 80), child: _sample())]));
			case 'KlpDivider':
				if (_enabled) return Row(children: [Expanded(child: _sample()), const KlpDivider(vertical: true), Expanded(child: _tile('伴槽'))]);
				return Column(children: [Expanded(child: _sample()), const KlpDivider(), Expanded(child: _tile('伴槽'))]);
			case 'KlpFit': return KlpFit(mode: KlpFitMode.values[_primary], child: _tile('固定80×44'));
			case 'KlpGap':
				if (_enabled) return Column(children: [_tile('上方'), _extra ? KlpGap.heightSize(_spaces[_spacing]) : KlpGap.height(_extent), _tile('下方')]);
				return Row(children: [_tile('左側'), _extra ? KlpGap.widthSize(_spaces[_spacing]) : KlpGap.width(_extent), _tile('右側')]);
			case 'KlpLayoutBuilder': return KlpLayoutBuilder(builder: _builderBody);
			case 'KlpRotate': return Center(child: KlpRotate(turn: KlpQuarterTurn.values[_primary], child: _tile('80×44')));
			case 'KlpTranslate': return Align(alignment: Alignment.topLeft, child: KlpTranslate(translation: KlpTranslation(horizontal: _extent, vertical: _enabled ? 32 : 0), child: _tile('位移')));
			case 'KlpStack': return KlpStack(alignment: _alignments[_primary], fit: _enabled ? StackFit.expand : StackFit.loose, clipBehavior: _wide ? Clip.none : Clip.hardEdge, children: _tiles(_extra ? 3 : 2));
			case 'KlpWrap': return KlpWrap(direction: _enabled ? Axis.vertical : Axis.horizontal, alignment: WrapAlignment.values[_primary], spacingSize: _spaces[_spacing], runSpacingSize: _spaces[_spacing], children: _tiles(_extra ? 8 : 4));
			case 'KlpScrollViewport': return KlpScrollViewport(controller: _scroll, padding: padding, child: Column(children: [for (var i = 0; i < 24; i++) _tile('內容 ${i + 1}') ]));
			case 'KlpRegion': return KlpRegion(header: _header ? const KlpText('header') : null, footer: _footer ? const KlpText('footer') : null, tone: KlpSurfaceTone.values[_tone], padding: padding, content: _sample());
			case 'KlpSection': return KlpSection(title: _draft.text, label: _enabled ? 'label' : null, trailing: _extra ? const KlpBadge(label: 'trailing') : null, child: _sample());
			default: return const KlpText('未知的布局 target');
		}
	}

	String _usage() {
		switch (widget.name) {
			case 'KlpExpanded': return 'Row(children: [KlpExpanded(flex: $_flex, child: content), Expanded(child: companion)])';
			case 'KlpFlexible': return 'Row(children: [KlpFlexible(flex: $_flex, fit: FlexFit.${_enabled ? 'tight' : 'loose'}, child: content), Expanded(child: companion)])';
			case 'KlpSpacer': return 'Row(children: [start, KlpSpacer(flex: $_flex), Spacer(), end])';
			case 'KlpPositioned': return 'Stack(children: [KlpPositioned(left: $_extent, top: $_extent, width: ${_enabled ? 140 : 100}, height: ${_enabled ? 90 : 64}, child: content)])';
			case 'KlpDirectionalPositioned': return 'Stack(children: [KlpDirectionalPositioned(position: KlpDirectionalPosition(start: $_extent, top: $_extent, width: 120, height: 80), child: content)])';
			case 'KlpDivider': return 'KlpDivider(vertical: $_enabled) // 合法 Row／Column 宿主';
			case 'KlpLayoutBuilder': return 'KlpLayoutBuilder(builder: (context, constraints) => content(constraints))';
			case 'KlpGap':
				if (_extra) return 'KlpGap.${_enabled ? 'heightSize' : 'widthSize'}(KlpSpaceSize.${_spaces[_spacing].name})';
				return 'KlpGap.${_enabled ? 'height' : 'width'}($_extent)';
			case 'KlpRotate': return 'KlpRotate(turn: KlpQuarterTurn.${KlpQuarterTurn.values[_primary].name}, child: content)';
			case 'KlpTranslate': return 'KlpTranslate(translation: KlpTranslation(horizontal: $_extent, vertical: ${_enabled ? 32 : 0}), child: content)';
			case 'KlpFit': return 'KlpFit(mode: KlpFitMode.${KlpFitMode.values[_primary].name}, child: content)';
			case 'KlpAlign': return 'KlpAlign(alignment: ${_alignments[_primary]}, shrinkWidth: $_enabled, child: content)';
			case 'KlpCenter': return 'KlpCenter(widthFactor: ${_wide ? 2 : 1}, heightFactor: ${_enabled ? 2 : 1}, child: content)';
			case 'KlpBox': return 'KlpBox(width: ${_wide ? 220 : 140}, height: ${_wide ? 100 : 72}, paddingSize: KlpSpaceSize.${_spaces[_spacing].name}, marginSize: KlpSpaceSize.${_spaces[_spacing].name}, tone: KlpSurfaceTone.${KlpSurfaceTone.values[_tone].name}, radius: ${_enabled ? '0' : 'null'}, child: content)';
			case 'KlpConstrainedBox': return 'KlpConstrainedBox(constraints: KlpBoxConstraints(minWidth: ${_enabled ? 60 : 0}, minHeight: ${_enabled ? 60 : 0}, maxWidth: ${_wide ? 240 : 120}, maxHeight: ${_wide ? 120 : 80}), child: content)';
			case 'KlpRow':
			case 'KlpColumn': return '${widget.name}(mainAxisAlignment: MainAxisAlignment.${_main[_primary].name}, crossAxisAlignment: CrossAxisAlignment.${_cross[_secondary].name}, mainAxisSize: MainAxisSize.${_enabled ? 'min' : 'max'}, gap: $_extent, children: items)';
			case 'KlpStack': return 'KlpStack(alignment: ${_alignments[_primary]}, fit: StackFit.${_enabled ? 'expand' : 'loose'}, clipBehavior: Clip.${_wide ? 'none' : 'hardEdge'}, children: items)';
			case 'KlpWrap': return 'KlpWrap(direction: Axis.${_enabled ? 'vertical' : 'horizontal'}, alignment: WrapAlignment.${WrapAlignment.values[_primary].name}, spacingSize: KlpSpaceSize.${_spaces[_spacing].name}, runSpacingSize: KlpSpaceSize.${_spaces[_spacing].name}, children: items)';
			case 'KlpScrollViewport': return 'KlpScrollViewport(controller: controller, padding: ${_enabled ? 'EdgeInsets.all(context.klp.space.contentInset)' : 'EdgeInsets.zero'}, child: content)';
			case 'KlpRegion': return 'KlpRegion(header: ${_header ? 'header' : 'null'}, footer: ${_footer ? 'footer' : 'null'}, tone: KlpSurfaceTone.${KlpSurfaceTone.values[_tone].name}, padding: ${_enabled ? 'EdgeInsets.all(context.klp.space.contentInset)' : 'EdgeInsets.zero'}, content: content)';
			case 'KlpSection': return 'KlpSection(title: title, label: ${_enabled ? 'label' : 'null'}, trailing: ${_extra ? 'badge' : 'null'}, child: content)';
			default: return '未知 target';
		}
	}

	@override
	Widget build(BuildContext context) {
		final space = context.klp.space;
		final controls = Wrap(spacing: space.actionGap, runSpacing: space.actionGap, children: _controls());
		final viewport = ClipRect(child: SizedBox(height: _short ? 180 : 280, width: double.infinity, child: _target(context)));
		final status = KlpText('輸入回呼 $_changes 次 · 捲動回呼 $_scrollChanges 次 · offset ${_scroll.hasClients ? _scroll.offset.toStringAsFixed(1) : '0.0'}', role: KlpTextRole.code);
		return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [controls, SizedBox(height: space.contentStackGap), viewport, SizedBox(height: space.contentStackGap), KlpTextField(controller: _draft, onChanged: _onChange), status, KlpText(_usage(), role: KlpTextRole.code)]);
	}
}
