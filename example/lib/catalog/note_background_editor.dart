import 'package:flutter/material.dart';
import 'package:kallopis/kallopis.dart';

/// Catalog 專用的執行期 recipe 控制面板。
class NoteBackgroundRuntimeEditor extends StatefulWidget {
  const NoteBackgroundRuntimeEditor({super.key});

  @override
  State<NoteBackgroundRuntimeEditor> createState() {
    return _NoteBackgroundRuntimeEditorState();
  }
}

class _NoteBackgroundRuntimeEditorState
    extends State<NoteBackgroundRuntimeEditor> {
  var _kind = 1;
  var _axis = 0;
  Color? _minorColor;
  Color? _majorColor;
  var _minorWidth = 1.0;
  var _majorWidth = 3.0;
  var _majorSpacing = 64.0;
  var _minorAxisCount = 3;
  var _zoom = 1.0;
  var _strokeBehavior = KlpPageBackgroundStrokeBehavior.fixed;

  @override
  Widget build(BuildContext context) {
    final klp = context.klp;
    final minorColor = _minorColor ?? klp.color.pagePattern;
    final majorColor = _majorColor ?? klp.color.pagePattern;
    final recipe = _buildRecipe(minorColor, majorColor);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        KlpSegmentedControl(
          key: const ValueKey('background-kind'),
          items: const ['Ruled', 'Dots', 'Grid'],
          selected: _kind,
          expanded: true,
          onSelected: (value) => setState(() => _kind = value),
        ),
        SizedBox(height: klp.space.groupGap),
        ClipRRect(
          borderRadius: BorderRadius.circular(klp.shape.card),
          child: KlpPageBackground.recipe(
            recipe: recipe,
            viewport: KlpPageBackgroundViewport(scale: _zoom),
            child: SizedBox(height: klp.space.pageLarge * 3),
          ),
        ),
        SizedBox(height: klp.space.groupGap),
        LayoutBuilder(
          builder: (context, constraints) {
            final panelWidth = constraints.maxWidth >= 720
                ? (constraints.maxWidth - klp.space.groupGap) / 2
                : constraints.maxWidth;
            return Wrap(
              spacing: klp.space.groupGap,
              runSpacing: klp.space.groupGap,
              children: [
                SizedBox(
                  width: panelWidth,
                  child: _buildColorPanel(context, minorColor, majorColor),
                ),
                SizedBox(width: panelWidth, child: _buildGeometryPanel()),
              ],
            );
          },
        ),
      ],
    );
  }

  Widget _buildColorPanel(
    BuildContext context,
    Color minorColor,
    Color majorColor,
  ) {
    final klp = context.klp;
    final selectedColor = _axis == 0 ? minorColor : majorColor;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (_kind > 0) ...[
          KlpSegmentedControl(
            key: const ValueKey('background-axis'),
            items: const ['次要軸', '主要軸'],
            selected: _axis,
            expanded: true,
            onSelected: (value) => setState(() => _axis = value),
          ),
          SizedBox(height: klp.space.itemGap),
        ],
        Row(
          children: [
            Expanded(
              child: KlpText(
                _kind == 0 ? '線條 RGBA' : '${_axis == 0 ? '次要軸' : '主要軸'} RGBA',
                role: KlpTextRole.bodyStrong,
              ),
            ),
            Container(
              key: const ValueKey('background-color-swatch'),
              width: klp.space.iconLarge,
              height: klp.space.iconLarge,
              decoration: BoxDecoration(
                color: selectedColor,
                borderRadius: BorderRadius.circular(klp.shape.control),
              ),
            ),
          ],
        ),
        SizedBox(height: klp.space.itemGap),
        _colorSlider('R', selectedColor.r, 0),
        _colorSlider('G', selectedColor.g, 1),
        _colorSlider('B', selectedColor.b, 2),
        _colorSlider('A', selectedColor.a, 3),
      ],
    );
  }

  Widget _colorSlider(String label, double value, int channel) {
    return KlpSlider(
      key: ValueKey('background-${label.toLowerCase()}'),
      label: label,
      value: value * 255,
      min: 0,
      max: 255,
      divisions: 255,
      displayValue: (value * 255).round().toString(),
      onChanged: (next) => _setColorChannel(channel, next.round()),
    );
  }

  Widget _buildGeometryPanel() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        KlpSegmentedControl(
          key: const ValueKey('background-stroke-behavior'),
          items: const ['恆定線寬', '跟隨縮放'],
          selected: _strokeBehavior == KlpPageBackgroundStrokeBehavior.fixed
              ? 0
              : 1,
          expanded: true,
          onSelected: (value) => setState(() {
            _strokeBehavior = value == 0
                ? KlpPageBackgroundStrokeBehavior.fixed
                : KlpPageBackgroundStrokeBehavior.scaled;
          }),
        ),
        KlpSlider(
          key: const ValueKey('background-axis-width'),
          label: _kind == 0 ? '線寬' : '${_axis == 0 ? '次要軸' : '主要軸'}寬度',
          value: _axis == 0 ? _minorWidth : _majorWidth,
          min: 1,
          max: 8,
          divisions: 7,
          displayValue:
              '${(_axis == 0 ? _minorWidth : _majorWidth).round()} px',
          onChanged: (value) => setState(() {
            if (_axis == 0 || _kind == 0) {
              _minorWidth = value;
            } else {
              _majorWidth = value;
            }
          }),
        ),
        KlpSlider(
          key: const ValueKey('background-major-spacing'),
          label: _kind == 0 ? '線條間距' : '主要軸間距',
          value: _majorSpacing,
          min: 24,
          max: 120,
          divisions: 12,
          displayValue: '${_majorSpacing.round()} px',
          onChanged: (value) => setState(() => _majorSpacing = value),
        ),
        if (_kind > 0)
          KlpSlider(
            key: const ValueKey('background-minor-count'),
            label: '內部分割',
            value: _minorAxisCount.toDouble(),
            min: 0,
            max: 8,
            divisions: 8,
            displayValue: '$_minorAxisCount',
            onChanged: (value) {
              setState(() => _minorAxisCount = value.round());
            },
          ),
        KlpSlider(
          key: const ValueKey('background-zoom'),
          label: 'Viewport zoom',
          value: _zoom,
          min: 0.5,
          max: 2,
          divisions: 6,
          displayValue: '${(_zoom * 100).round()}%',
          onChanged: (value) => setState(() => _zoom = value),
        ),
      ],
    );
  }

  KlpPageBackgroundRecipe _buildRecipe(Color minor, Color major) {
    final minorAxis = KlpPageBackgroundAxisStyle(
      color: minor,
      width: _minorWidth,
    );
    final majorAxis = KlpPageBackgroundAxisStyle(
      color: major,
      width: _majorWidth,
    );

    return switch (_kind) {
      0 => KlpRuledPageBackgroundRecipe(
        axis: minorAxis,
        spacing: _majorSpacing,
        strokeBehavior: _strokeBehavior,
      ),
      1 => KlpDotsPageBackgroundRecipe(
        minorAxis: minorAxis,
        majorAxis: majorAxis,
        majorSpacing: _majorSpacing,
        minorAxisCount: _minorAxisCount,
        strokeBehavior: _strokeBehavior,
      ),
      _ => KlpGridPageBackgroundRecipe(
        minorAxis: minorAxis,
        majorAxis: majorAxis,
        majorSpacing: _majorSpacing,
        minorAxisCount: _minorAxisCount,
        strokeBehavior: _strokeBehavior,
      ),
    };
  }

  void _setColorChannel(int channel, int value) {
    final fallback = context.klp.color.pagePattern;
    final current = _axis == 0
        ? (_minorColor ?? fallback)
        : (_majorColor ?? fallback);
    final channels = [
      (current.r * 255).round(),
      (current.g * 255).round(),
      (current.b * 255).round(),
      (current.a * 255).round(),
    ];
    channels[channel] = value;
    final changed = Color.fromARGB(
      channels[3],
      channels[0],
      channels[1],
      channels[2],
    );
    setState(() {
      if (_axis == 0 || _kind == 0) {
        _minorColor = changed;
      } else {
        _majorColor = changed;
      }
    });
  }
}

/// Catalog 專用的 point／line 背景編輯範例。
class NoteBackgroundCustomEditor extends StatefulWidget {
  const NoteBackgroundCustomEditor({super.key});

  @override
  State<NoteBackgroundCustomEditor> createState() {
    return _NoteBackgroundCustomEditorState();
  }
}

class _NoteBackgroundCustomEditorState
    extends State<NoteBackgroundCustomEditor> {
  var _tool = KlpPageBackgroundEditorTool.connect;
  var _recipe = KlpCustomPageBackgroundRecipe(
    snapSpacing: 20,
    pointStyle: KlpPageBackgroundAxisStyle(width: 5),
    lineStyle: KlpPageBackgroundAxisStyle(width: 2),
  );

  @override
  Widget build(BuildContext context) {
    final klp = context.klp;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Wrap(
          spacing: klp.space.itemGap,
          runSpacing: klp.space.itemGap,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            KlpSegmentedControl(
              key: const ValueKey('background-editor-tool'),
              items: const ['點連', '選取', '刪除'],
              selected: _tool.index,
              onSelected: (value) {
                setState(
                  () => _tool = KlpPageBackgroundEditorTool.values[value],
                );
              },
            ),
            KlpButton(
              label: '清除背景',
              tone: KlpButtonTone.ghost,
              compact: true,
              onPressed: _recipe.points.isEmpty
                  ? null
                  : () {
                      setState(() {
                        _recipe = _recipe.copyWith(
                          points: const [],
                          lines: const [],
                        );
                      });
                    },
            ),
          ],
        ),
        SizedBox(height: klp.space.itemGap),
        const KlpText(
          '點擊建立節點並連線；按住 Shift 可暫停座標吸附。切換工具會結束目前連線。',
          role: KlpTextRole.sub,
          tone: KlpTextTone.muted,
        ),
        SizedBox(height: klp.space.groupGap),
        ClipRRect(
          borderRadius: BorderRadius.circular(klp.shape.card),
          child: SizedBox(
            height: klp.space.pageLarge * 4,
            child: KlpPageBackgroundEditor(
              recipe: _recipe,
              tool: _tool,
              onChanged: (value) => setState(() => _recipe = value),
            ),
          ),
        ),
      ],
    );
  }
}
