import 'package:flutter/widgets.dart';
import 'package:kallopis/kallopis_foundation.dart';

/* 公開布局元件只以自己的實際 constructor 進 registry。 */
const layoutUtilitySpecimenNames = <String>['KlpAdaptive', 'KlpDeviceAdaptive', 'KlpEnvironmentScope', 'KlpMasonryGrid', 'KlpVirtualGrid', 'KlpVirtualList', 'KlpResizablePane', 'KlpResizeHandle', 'KlpSlidingDrawerLayout', 'KlpSplitLayout'];

class LayoutUtilityComponentSpecimen extends StatefulWidget {

	/* name：當次target；環境切換保留自己的consumer State。 */
	final String name;
	const LayoutUtilityComponentSpecimen({super.key, required this.name});
	@override
	State<LayoutUtilityComponentSpecimen> createState() => _LayoutUtilityComponentSpecimenState();
}

class _LayoutUtilityComponentSpecimenState extends State<LayoutUtilityComponentSpecimen> {

	/*
	 * _label／_draft：自己的資料內容及唯一editable child；_scroll：VirtualList公開controller。
	 * _progress：SlidingDrawer公開受控進度；_platform／_scopePlatform：explicit/null及scope平台。
	 * _sample：public factory的viewportSize採樣；_factory：scope來源；_optional：可選用platform builders。
	 * _count／_selected：集合資料及consumer選取；_minimum／_columns／_spacing／_aspect：grid props。
	 * _wide：pane/drawer尺寸；_vertical／_enabled／_handleSize／_dragCallbacks：原handle props。
	 * _extent／_limit：consumer拖曳尺寸及實際host上限；_tracking／_center／_divider：drawer/split props。
	 * _leading／_trailing／_gap：split公開enum，trailing0代表null。
	 * _rootCalls／_starts／_ends／_childCalls／_inputs／_edits：原delta/drag、child及控制文字分離。
	 * _result：最後原回呼結果，不將controller跳尾或props控制當元件回呼。
	 */
	final _label = TextEditingController(text: '布局資料');
	final _draft = TextEditingController(text: '布局 child 草稿');
	final _scroll = ScrollController();
	final _progress = ValueNotifier<double>(0);
	int _platform = 0;
	int _scopePlatform = KlpAppPlatform.values.indexOf(KlpAppPlatform.windows);
	int _sample = 0;
	bool _factory = false;
	bool _optional = true;
	int _count = 12;
	int _selected = -1;
	bool _minimum = false;
	int _columns = 0;
	bool _spacing = false;
	bool _aspect = false;
	bool _wide = false;
	bool _vertical = false;
	bool _enabled = true;
	bool _handleSize = false;
	bool _dragCallbacks = true;
	double _extent = 120;
	double _limit = 240;
	bool _tracking = false;
	bool _center = false;
	bool _divider = false;
	int _leading = 0;
	int _trailing = 0;
	int _gap = KlpSpaceSize.values.indexOf(KlpSpaceSize.base);
	int _rootCalls = 0;
	int _starts = 0;
	int _ends = 0;
	int _childCalls = 0;
	int _inputs = 0;
	int _edits = 0;
	String _result = '尚未觸發原回呼';

	double get _sampleWidth => [1400.0, 900.0, 440.0][_sample];
	KlpPlatformInfo get _sampleInfo => KlpPlatformInfo.current(viewportSize: Size(_sampleWidth, 800));
	@override
	void dispose() { _label.dispose(); _draft.dispose(); _scroll.dispose(); _progress.dispose(); super.dispose(); }
	void _edit(String value) => setState(() => _edits++);
	void _input(String value) => setState(() => _inputs++);
	void _childAction(String label) => setState(() { _childCalls++; _result = 'child：$label'; });
	void _itemAction(int index) => setState(() { _selected = index; _childCalls++; _result = 'item：$index'; });
	void _countChange() => setState(() { _count = {12: 60, 60: 0, 0: 12}[_count]!; if (_selected >= _count) _selected = -1; });
	void _delta(double delta) => setState(() { _extent = (_extent + delta).clamp(40, _limit); _rootCalls++; _result = 'onDelta：${delta.toStringAsFixed(1)}'; });
	void _dragStart() => setState(() { _starts++; _result = 'onDragStart'; });
	void _dragEnd() => setState(() { _ends++; _result = 'onDragEnd'; });
	void _jumpEnd() { if (_scroll.hasClients) _scroll.jumpTo(_scroll.position.maxScrollExtent); }
	void _progressChange() => setState(() => _progress.value = (_progress.value + .5) % 1.5);
	Widget _control(String label, VoidCallback callback) => KlpButton(label: label, onPressed: callback);
	Widget _sampleControl() => _control('factory viewportSize：$_sampleWidth', () => setState(() => _sample = (_sample + 1) % 3));
	Widget _scopeControl() => _control('scope platform：${KlpAppPlatform.values[_scopePlatform].name}', () => setState(() => _scopePlatform = (_scopePlatform + 1) % KlpAppPlatform.values.length));
	Widget _countControl() => _control('itemCount／children：$_count', _countChange);

	List<Widget> _controls() {
		switch (widget.name) {
			case 'KlpAdaptive': return [_control('platform explicit：${_platform == 0 ? 'null' : KlpAppPlatform.values[_platform - 1].name}', () => setState(() => _platform = (_platform + 1) % (KlpAppPlatform.values.length + 1))), _scopeControl(), _control('optional builders：$_optional', () => setState(() => _optional = !_optional))];
			case 'KlpDeviceAdaptive': return [_control('device source：${['desktop DTO', 'current(900)', 'current(440)'][_sample]}', () => setState(() => _sample = (_sample + 1) % 3))];
			case 'KlpEnvironmentScope': return [_control('source factory：$_factory', () => setState(() => _factory = !_factory)), _factory ? _sampleControl() : _scopeControl()];
			case 'KlpMasonryGrid': return [_countControl(), _control('minimumColumnWidth：${_minimum ? 240 : 'null'}', () => setState(() => _minimum = !_minimum))];
			case 'KlpVirtualGrid': return [_countControl(), _control('minimumItemWidth：${_minimum ? 240 : 160}', () => setState(() => _minimum = !_minimum)), _control('crossAxisCount：${_columns == 0 ? 'null' : _columns}', () => setState(() => _columns = (_columns + 1) % 4)), _control('spacing override：$_spacing', () => setState(() => _spacing = !_spacing)), _control('childAspectRatio：${_aspect ? 2.0 : 1.0}', () => setState(() => _aspect = !_aspect))];
			case 'KlpVirtualList': return [_countControl(), _control('padding override：$_spacing', () => setState(() => _spacing = !_spacing)), _control('consumer controller 跳尾', _jumpEnd)];
			case 'KlpResizablePane': return [_control('width：${_wide ? 240 : 160}', () => setState(() => _wide = !_wide))];
			case 'KlpResizeHandle': return [_control('axis：${_vertical ? 'vertical' : 'horizontal'}', () => setState(() => _vertical = !_vertical)), _control('enabled：$_enabled', () => setState(() => _enabled = !_enabled)), _control('width／height override：$_handleSize', () => setState(() => _handleSize = !_handleSize)), _control('drag callbacks：$_dragCallbacks', () => setState(() => _dragCallbacks = !_dragCallbacks))];
			case 'KlpSlidingDrawerLayout': return [_control('progress：${_progress.value}', _progressChange), _control('tracking：$_tracking', () => setState(() => _tracking = !_tracking)), _control('drawerExtent：${_wide ? 180 : 120}', () => setState(() => _wide = !_wide))];
			case 'KlpSplitLayout': return [_control('center：$_center', () => setState(() => _center = !_center)), _control('leadingSize：${KlpSplitPaneSize.values[_leading].name}', () => setState(() => _leading = 1 - _leading)), _control('trailingSize：${_trailing == 0 ? 'null' : KlpSplitPaneSize.values[_trailing - 1].name}', () => setState(() => _trailing = (_trailing + 1) % 3)), _control('gapSize：${KlpSpaceSize.values[_gap].name}', () => setState(() => _gap = (_gap + 1) % KlpSpaceSize.values.length)), _control('showDashedDivider：$_divider', () => setState(() => _divider = !_divider))];
			default: return const [];
		}
	}

	Widget _pane(String label, {bool editable = false}) => LayoutBuilder(builder: (context, bounds) => SingleChildScrollView(child: KlpSurface(child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [KlpText('$label：${_label.text}'), KlpText('實際寬度：${bounds.maxWidth.toStringAsFixed(1)}'), if (editable) KlpTextField(controller: _draft, onChanged: _input), KlpButton(label: '$label child 動作', onPressed: () => _childAction(label))]))));
	Widget _branch(String label) => _pane('branch $label', editable: true);
	Widget _adaptive() => KlpEnvironmentScope(platform: KlpPlatformInfo(platform: KlpAppPlatform.values[_scopePlatform]), child: KlpAdaptive(platform: _platform == 0 ? null : KlpAppPlatform.values[_platform - 1], windows: (context) => _branch('windows'), android: (context) => _branch('android'), macos: _optional ? (context) => _branch('macos') : null, linux: _optional ? (context) => _branch('linux') : null, ios: _optional ? (context) => _branch('ios') : null, other: _optional ? (context) => _branch('other') : null));
	Widget _environment() => KlpEnvironmentScope(platform: _factory ? _sampleInfo : KlpPlatformInfo(platform: KlpAppPlatform.values[_scopePlatform]), child: Builder(builder: (context) {
		final info = KlpEnvironmentScope.of(context);
		return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [KlpText('實際 environment：${info.platform.name}/${info.deviceClass.name}/${info.orientation.name}/${info.displayMode.name}/${info.effectiveAdaptiveMode}'), Expanded(child: _pane('scope', editable: true))]);
	}));
	Widget _item(BuildContext context, int index) => LayoutBuilder(builder: (context, bounds) => SingleChildScrollView(child: KlpSurface(child: Column(mainAxisSize: MainAxisSize.min, children: [KlpText('${_label.text} item $index'), KlpText('實際cell寬：${bounds.maxWidth.toStringAsFixed(1)}'), KlpButton(label: 'item $index 動作', selected: _selected == index, onPressed: () => _itemAction(index))]))));
	Widget _resize() => LayoutBuilder(builder: (context, bounds) {
		_limit = (_vertical ? bounds.maxHeight : bounds.maxWidth) - 72;
		final extent = _extent.clamp(40, _limit).toDouble();
		final handle = SizedBox(width: _vertical ? null : 32, height: _vertical ? 32 : null, child: KlpResizeHandle(onDelta: _delta, axis: _vertical ? Axis.vertical : Axis.horizontal, enabled: _enabled, onDragStart: _dragCallbacks ? _dragStart : null, onDragEnd: _dragCallbacks ? _dragEnd : null, semanticLabel: _label.text, width: _handleSize ? (_vertical ? 140 : 24) : null, height: _handleSize ? (_vertical ? 24 : 140) : null));
		if (_vertical) return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [SizedBox(height: extent, child: _pane('resize', editable: true)), handle, Expanded(child: _pane('remaining'))]);
		return Row(crossAxisAlignment: CrossAxisAlignment.stretch, children: [SizedBox(width: extent, child: _pane('resize', editable: true)), handle, Expanded(child: _pane('remaining'))]);
	});
	Widget _target(BuildContext context) {
		switch (widget.name) {
			case 'KlpAdaptive': return _adaptive();
			case 'KlpDeviceAdaptive': return KlpEnvironmentScope(platform: _sample == 0 ? const KlpPlatformInfo(platform: KlpAppPlatform.windows) : _sampleInfo, child: KlpDeviceAdaptive(desktop: (context) => _branch('desktop'), tablet: (context) => _branch('tablet'), phone: (context) => _branch('phone')));
			case 'KlpEnvironmentScope': return _environment();
			case 'KlpMasonryGrid': return SingleChildScrollView(child: KlpMasonryGrid(minimumColumnWidth: _minimum ? 240 : null, children: [for (var i = 0; i < _count; i++) SizedBox(height: i.isEven ? 100 : 160, child: _item(context, i))]));
			case 'KlpVirtualGrid': return KlpVirtualGrid(itemCount: _count, itemBuilder: _item, minimumItemWidth: _minimum ? 240 : 160, crossAxisCount: _columns == 0 ? null : _columns, spacing: _spacing ? context.klp.space.actionGap * 2 : null, childAspectRatio: _aspect ? 2 : 1);
			case 'KlpVirtualList': return KlpVirtualList(itemCount: _count, itemBuilder: _item, controller: _scroll, padding: _spacing ? EdgeInsets.all(context.klp.space.contentInset * 2) : null);
			case 'KlpResizablePane': return Row(children: [KlpResizablePane(width: _wide ? 240 : 160, child: _pane('pane', editable: true)), Expanded(child: _pane('remaining'))]);
			case 'KlpResizeHandle': return _resize();
			case 'KlpSlidingDrawerLayout': return KlpSlidingDrawerLayout(progress: _progress, tracking: _tracking, drawerExtent: _wide ? 180 : 120, stage: _pane('stage', editable: true), drawer: _pane('drawer'));
			case 'KlpSplitLayout': return SingleChildScrollView(scrollDirection: Axis.horizontal, child: SizedBox(width: 760, height: 280, child: KlpSplitLayout(leading: _pane('leading', editable: true), trailing: _pane('trailing'), center: _center ? _pane('center') : null, leadingSize: KlpSplitPaneSize.values[_leading], trailingSize: _trailing == 0 ? null : KlpSplitPaneSize.values[_trailing - 1], gapSize: KlpSpaceSize.values[_gap], showDashedDivider: _divider)));
			default: return KlpText('未知布局展示：${widget.name}');
		}
	}
	String _usage() {
		switch (widget.name) {
			case 'KlpAdaptive': return 'KlpAdaptive(windows: windows, android: android, platform: platform, macos: macos, linux: linux, ios: ios, other: other)';
			case 'KlpDeviceAdaptive': return 'KlpDeviceAdaptive(desktop: desktop, tablet: tablet, phone: phone)';
			case 'KlpEnvironmentScope': return 'KlpEnvironmentScope(platform: KlpPlatformInfo, child: child)';
			case 'KlpMasonryGrid': return 'KlpMasonryGrid(children: children, minimumColumnWidth: minimumColumnWidth)';
			case 'KlpVirtualGrid': return 'KlpVirtualGrid(itemCount: itemCount, itemBuilder: itemBuilder, minimumItemWidth: minimumItemWidth, crossAxisCount: crossAxisCount, spacing: spacing, childAspectRatio: childAspectRatio)';
			case 'KlpVirtualList': return 'KlpVirtualList(itemCount: itemCount, itemBuilder: itemBuilder, controller: controller, padding: padding)';
			case 'KlpResizablePane': return 'KlpResizablePane(width: width, child: child)';
			case 'KlpResizeHandle': return 'KlpResizeHandle(onDelta: onDelta, axis: axis, onDragStart: onDragStart, onDragEnd: onDragEnd, semanticLabel: semanticLabel, width: width, height: height, enabled: enabled)';
			case 'KlpSlidingDrawerLayout': return 'KlpSlidingDrawerLayout(progress: progress, tracking: tracking, drawerExtent: drawerExtent, stage: stage, drawer: drawer)';
			case 'KlpSplitLayout': return 'KlpSplitLayout(leading: leading, trailing: trailing, center: center, leadingSize: leadingSize, trailingSize: trailingSize, gapSize: gapSize, showDashedDivider: showDashedDivider)';
			default: return '';
		}
	}

	@override
	Widget build(BuildContext context) => Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
		Wrap(spacing: context.klp.space.actionGap, runSpacing: context.klp.space.actionGap, children: _controls()),
		KlpTextField(controller: _label, placeholder: '自己的公開資料／semanticLabel／child文字', onChanged: _edit),
		SizedBox(height: 280, child: _target(context)),
		KlpText('delta 回呼：$_rootCalls；start：$_starts；end：$_ends；child 動作：$_childCalls；child 輸入：$_inputs；控制文字：$_edits'),
		KlpText('consumer extent：${_extent.toStringAsFixed(1)}；selected item：$_selected；最後回呼結果：$_result'),
		if (['KlpAdaptive', 'KlpDeviceAdaptive', 'KlpEnvironmentScope'].contains(widget.name)) const KlpText('factory viewportSize 是環境採樣；platform 分支不等於視窗尺寸分支。'),
		if (widget.name == 'KlpSplitLayout') const KlpText('760 展示畫布可水平捲動；此宿主不證明庫的窄視窗分割算法。'),
		KlpText(_usage(), role: KlpTextRole.code),
	]);
}
