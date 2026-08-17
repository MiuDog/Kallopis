import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../theme/pln_theme.dart';
import '../theme/pln_data_visualization_theme.dart';

@immutable
class DashChartSeries {
  const DashChartSeries({
    required this.id,
    required this.label,
    required this.values,
    this.colorIndex = 0,
    this.filled = false,
  });

  final String id;
  final String label;
  final List<double> values;
  final int colorIndex;
  final bool filled;
}

@immutable
class DashChartPoint {
  const DashChartPoint({
    required this.x,
    required this.y,
    this.id,
    this.label,
    this.size = 1,
    this.colorIndex = 0,
  });

  final String? id;
  final String? label;
  final double x;
  final double y;
  final double size;
  final int colorIndex;
}

@immutable
class DashChartSlice {
  const DashChartSlice({
    required this.id,
    required this.label,
    required this.value,
    this.colorIndex = 0,
  });

  final String id;
  final String label;
  final double value;
  final int colorIndex;
}

@immutable
class DashBoxPlotGroup {
  const DashBoxPlotGroup({
    required this.label,
    required this.values,
    this.colorIndex = 0,
  });

  final String label;
  final List<double> values;
  final int colorIndex;
}

@immutable
class DashHeatmapCell {
  const DashHeatmapCell({
    required this.row,
    required this.column,
    required this.value,
    this.label,
  });

  final int row;
  final int column;
  final double value;
  final String? label;
}

@immutable
class DashRegionValue {
  const DashRegionValue({
    required this.id,
    required this.label,
    required this.value,
  });

  final String id;
  final String label;
  final double value;
}

@immutable
class DashHierarchyNode {
  const DashHierarchyNode({
    required this.id,
    required this.label,
    required this.value,
    this.children = const [],
    this.colorIndex = 0,
  });

  final String id;
  final String label;
  final double value;
  final List<DashHierarchyNode> children;
  final int colorIndex;
}

@immutable
class DashWaterfallStep {
  const DashWaterfallStep({
    required this.label,
    required this.value,
    this.subtotal = false,
  });

  final String label;
  final double value;
  final bool subtotal;
}

@immutable
class DashCandle {
  const DashCandle({
    required this.open,
    required this.high,
    required this.low,
    required this.close,
    this.volume,
    this.label,
  });

  final double open;
  final double high;
  final double low;
  final double close;
  final double? volume;
  final String? label;
}

class DashColumnChart extends StatelessWidget {
  const DashColumnChart({
    super.key,
    required this.categories,
    required this.series,
    this.stacked = false,
    this.percent = false,
    this.horizontal = false,
    this.height = 220,
    this.onSelectCategory,
  });

  final List<String> categories;
  final List<DashChartSeries> series;
  final bool stacked;
  final bool percent;
  final bool horizontal;
  final double height;
  final ValueChanged<int>? onSelectCategory;

  @override
  Widget build(BuildContext context) {
    return _DashPaintedChart(
      mode: _DashChartMode.column,
      height: height,
      series: series,
      options: [stacked, percent, horizontal],
      semanticsLabel: _seriesSummary('Column chart', series, categories.length),
      onSelect: onSelectCategory,
    );
  }
}

class DashLineChart extends StatelessWidget {
  const DashLineChart({
    super.key,
    required this.categories,
    required this.series,
    this.smooth = false,
    this.showPoints = true,
    this.height = 220,
    this.onSelectPoint,
  });

  final List<String> categories;
  final List<DashChartSeries> series;
  final bool smooth;
  final bool showPoints;
  final double height;
  final ValueChanged<int>? onSelectPoint;

  @override
  Widget build(BuildContext context) {
    return _DashPaintedChart(
      mode: _DashChartMode.line,
      height: height,
      series: series,
      options: [smooth, showPoints],
      semanticsLabel: _seriesSummary('Line chart', series, categories.length),
      onSelect: onSelectPoint,
    );
  }
}

class DashComboChart extends StatelessWidget {
  const DashComboChart({
    super.key,
    required this.categories,
    required this.columnSeries,
    required this.lineSeries,
    this.height = 220,
    this.onSelectPoint,
  });

  final List<String> categories;
  final List<DashChartSeries> columnSeries;
  final List<DashChartSeries> lineSeries;
  final double height;
  final ValueChanged<int>? onSelectPoint;

  @override
  Widget build(BuildContext context) {
    return _DashPaintedChart(
      mode: _DashChartMode.combo,
      height: height,
      series: [...columnSeries, ...lineSeries],
      splitIndex: columnSeries.length,
      semanticsLabel:
          'Combo chart, ${categories.length} categories, '
          '${columnSeries.length} column and ${lineSeries.length} line series',
      onSelect: onSelectPoint,
    );
  }
}

class DashPieChart extends StatelessWidget {
  const DashPieChart({
    super.key,
    required this.slices,
    this.donut = false,
    this.height = 220,
    this.onSelectSlice,
  });

  final List<DashChartSlice> slices;
  final bool donut;
  final double height;
  final ValueChanged<String>? onSelectSlice;

  @override
  Widget build(BuildContext context) {
    return _DashPaintedChart(
      mode: _DashChartMode.pie,
      height: height,
      slices: slices,
      options: [donut],
      semanticsLabel: 'Pie chart, ${slices.length} slices',
      onSelect: onSelectSlice == null || slices.isEmpty
          ? null
          : (index) => onSelectSlice!(slices[index % slices.length].id),
    );
  }
}

class DashPieOfPieChart extends StatelessWidget {
  const DashPieOfPieChart({
    super.key,
    required this.slices,
    required this.secondarySliceIds,
    this.height = 220,
    this.onSelectSlice,
  });

  final List<DashChartSlice> slices;
  final Set<String> secondarySliceIds;
  final double height;
  final ValueChanged<String>? onSelectSlice;

  @override
  Widget build(BuildContext context) {
    final primary = slices
        .where((slice) => !secondarySliceIds.contains(slice.id))
        .toList();
    final secondary = slices
        .where((slice) => secondarySliceIds.contains(slice.id))
        .toList();
    final ordered = [...primary, ...secondary];

    return _DashPaintedChart(
      mode: _DashChartMode.pieOfPie,
      height: height,
      slices: ordered,
      splitIndex: primary.length,
      semanticsLabel:
          'Pie of pie chart, ${slices.length} slices, '
          '${secondarySliceIds.length} expanded',
      onSelect: onSelectSlice == null || ordered.isEmpty
          ? null
          : (index) => onSelectSlice!(ordered[index % ordered.length].id),
    );
  }
}

class DashScatterChart extends StatelessWidget {
  const DashScatterChart({
    super.key,
    required this.points,
    this.height = 220,
    this.onSelectPoint,
  });

  final List<DashChartPoint> points;
  final double height;
  final ValueChanged<int>? onSelectPoint;

  @override
  Widget build(BuildContext context) => _DashPaintedChart(
    mode: _DashChartMode.scatter,
    height: height,
    points: points,
    semanticsLabel: 'Scatter chart, ${points.length} points',
    onSelect: onSelectPoint,
  );
}

class DashScatterLineChart extends StatelessWidget {
  const DashScatterLineChart({
    super.key,
    required this.points,
    this.height = 220,
    this.onSelectPoint,
  });

  final List<DashChartPoint> points;
  final double height;
  final ValueChanged<int>? onSelectPoint;

  @override
  Widget build(BuildContext context) => _DashPaintedChart(
    mode: _DashChartMode.scatterLine,
    height: height,
    points: points,
    semanticsLabel: 'Scatter line chart, ${points.length} points',
    onSelect: onSelectPoint,
  );
}

class DashHistogramChart extends StatelessWidget {
  const DashHistogramChart({
    super.key,
    required this.values,
    this.binCount = 8,
    this.height = 220,
  });

  final List<double> values;
  final int binCount;
  final double height;

  @override
  Widget build(BuildContext context) => _DashPaintedChart(
    mode: _DashChartMode.histogram,
    height: height,
    values: values,
    count: binCount,
    semanticsLabel: 'Histogram, ${values.length} observations, $binCount bins',
  );
}

class DashBoxPlotChart extends StatelessWidget {
  const DashBoxPlotChart({super.key, required this.groups, this.height = 220});

  final List<DashBoxPlotGroup> groups;
  final double height;

  @override
  Widget build(BuildContext context) => _DashPaintedChart(
    mode: _DashChartMode.boxPlot,
    height: height,
    boxGroups: groups,
    semanticsLabel: 'Box plot chart, ${groups.length} groups',
  );
}

class DashFunnelChart extends StatelessWidget {
  const DashFunnelChart({
    super.key,
    required this.stages,
    this.height = 220,
    this.onSelectStage,
  });

  final List<DashChartSlice> stages;
  final double height;
  final ValueChanged<String>? onSelectStage;

  @override
  Widget build(BuildContext context) => _DashPaintedChart(
    mode: _DashChartMode.funnel,
    height: height,
    slices: stages,
    semanticsLabel: 'Funnel chart, ${stages.length} stages',
    onSelect: onSelectStage == null || stages.isEmpty
        ? null
        : (index) => onSelectStage!(stages[index % stages.length].id),
  );
}

class DashGaugeChart extends StatelessWidget {
  const DashGaugeChart({
    super.key,
    required this.value,
    required this.label,
    this.minimum = 0,
    this.maximum = 1,
    this.target,
    this.height = 220,
  });

  final double value;
  final String label;
  final double minimum;
  final double maximum;
  final double? target;
  final double height;

  @override
  Widget build(BuildContext context) => _DashPaintedChart(
    mode: _DashChartMode.gauge,
    height: height,
    values: [value, minimum, maximum, ?target],
    centerLabel: label,
    semanticsLabel: 'Gauge, $label',
  );
}

class DashHeatmapChart extends StatelessWidget {
  const DashHeatmapChart({
    super.key,
    required this.rows,
    required this.columns,
    required this.cells,
    this.height = 220,
    this.onSelectCell,
  });

  final List<String> rows;
  final List<String> columns;
  final List<DashHeatmapCell> cells;
  final double height;
  final ValueChanged<DashHeatmapCell>? onSelectCell;

  @override
  Widget build(BuildContext context) => _DashPaintedChart(
    mode: _DashChartMode.heatmap,
    height: height,
    heatCells: cells,
    rows: rows.length,
    columns: columns.length,
    semanticsLabel:
        'Heatmap, ${rows.length} rows, ${columns.length} columns, '
        '${cells.length} values',
    onSelect: onSelectCell == null || cells.isEmpty
        ? null
        : (index) => onSelectCell!(cells[index % cells.length]),
  );
}

class DashRadarChart extends StatelessWidget {
  const DashRadarChart({
    super.key,
    required this.axes,
    required this.series,
    this.height = 220,
  });

  final List<String> axes;
  final List<DashChartSeries> series;
  final double height;

  @override
  Widget build(BuildContext context) => _DashPaintedChart(
    mode: _DashChartMode.radar,
    height: height,
    series: series,
    count: axes.length,
    semanticsLabel: 'Radar chart, ${axes.length} axes, ${series.length} series',
  );
}

class DashPolarPlot extends StatelessWidget {
  const DashPolarPlot({
    super.key,
    required this.points,
    this.height = 220,
    this.onChange,
  });

  final List<DashChartPoint> points;
  final double height;
  final ValueChanged<DashChartPoint>? onChange;

  @override
  Widget build(BuildContext context) => _DashPaintedChart(
    mode: _DashChartMode.polar,
    height: height,
    points: points,
    semanticsLabel: 'Polar plot, ${points.length} points',
    onSelect: onChange == null || points.isEmpty
        ? null
        : (index) => onChange!(points[index % points.length]),
  );
}

class DashQuadrantPlot extends StatelessWidget {
  const DashQuadrantPlot({
    super.key,
    required this.points,
    this.xSplit = 0,
    this.ySplit = 0,
    this.height = 220,
    this.onSelectPoint,
  });

  final List<DashChartPoint> points;
  final double xSplit;
  final double ySplit;
  final double height;
  final ValueChanged<int>? onSelectPoint;

  @override
  Widget build(BuildContext context) => _DashPaintedChart(
    mode: _DashChartMode.quadrant,
    height: height,
    points: points,
    values: [xSplit, ySplit],
    semanticsLabel: 'Quadrant plot, ${points.length} points',
    onSelect: onSelectPoint,
  );
}

class DashRegionCartogram extends StatelessWidget {
  const DashRegionCartogram({
    super.key,
    required this.regions,
    this.columns = 6,
    this.height = 220,
    this.onSelectRegion,
  });

  final List<DashRegionValue> regions;
  final int columns;
  final double height;
  final ValueChanged<String>? onSelectRegion;

  @override
  Widget build(BuildContext context) => _DashPaintedChart(
    mode: _DashChartMode.cartogram,
    height: height,
    regions: regions,
    columns: columns,
    semanticsLabel: 'Region cartogram, ${regions.length} regions',
    onSelect: onSelectRegion == null || regions.isEmpty
        ? null
        : (index) => onSelectRegion!(regions[index % regions.length].id),
  );
}

class DashMapView extends StatelessWidget {
  const DashMapView({
    super.key,
    required this.markers,
    this.height = 220,
    this.onSelectMarker,
  });

  final List<DashChartPoint> markers;
  final double height;
  final ValueChanged<int>? onSelectMarker;

  @override
  Widget build(BuildContext context) => _DashPaintedChart(
    mode: _DashChartMode.map,
    height: height,
    points: markers,
    semanticsLabel: 'Map projection, ${markers.length} markers',
    onSelect: onSelectMarker,
  );
}

class DashSunburstChart extends StatelessWidget {
  const DashSunburstChart({
    super.key,
    required this.nodes,
    this.height = 220,
    this.onFocusNode,
  });

  final List<DashHierarchyNode> nodes;
  final double height;
  final ValueChanged<String>? onFocusNode;

  @override
  Widget build(BuildContext context) => _DashPaintedChart(
    mode: _DashChartMode.sunburst,
    height: height,
    nodes: nodes,
    semanticsLabel: 'Sunburst chart, ${_nodeCount(nodes)} nodes',
    onSelect: onFocusNode == null || nodes.isEmpty
        ? null
        : (index) => onFocusNode!(nodes[index % nodes.length].id),
  );
}

class DashSurfaceChart extends StatelessWidget {
  const DashSurfaceChart({super.key, required this.values, this.height = 220});

  final List<List<double>> values;
  final double height;

  @override
  Widget build(BuildContext context) => _DashPaintedChart(
    mode: _DashChartMode.surface,
    height: height,
    matrix: values,
    semanticsLabel:
        'Surface chart, ${values.length} rows, '
        '${values.isEmpty ? 0 : values.first.length} columns',
  );
}

class DashTreemapChart extends StatelessWidget {
  const DashTreemapChart({
    super.key,
    required this.nodes,
    this.height = 220,
    this.onSelectNode,
  });

  final List<DashHierarchyNode> nodes;
  final double height;
  final ValueChanged<String>? onSelectNode;

  @override
  Widget build(BuildContext context) => _DashPaintedChart(
    mode: _DashChartMode.treemap,
    height: height,
    nodes: nodes,
    semanticsLabel: 'Treemap chart, ${_nodeCount(nodes)} nodes',
    onSelect: onSelectNode == null || nodes.isEmpty
        ? null
        : (index) => onSelectNode!(nodes[index % nodes.length].id),
  );
}

class DashWaterfallChart extends StatelessWidget {
  const DashWaterfallChart({super.key, required this.steps, this.height = 220});

  final List<DashWaterfallStep> steps;
  final double height;

  @override
  Widget build(BuildContext context) => _DashPaintedChart(
    mode: _DashChartMode.waterfall,
    height: height,
    steps: steps,
    semanticsLabel: 'Waterfall chart, ${steps.length} steps',
  );
}

class DashParetoChart extends StatelessWidget {
  const DashParetoChart({
    super.key,
    required this.categories,
    required this.values,
    this.height = 220,
  });

  final List<String> categories;
  final List<double> values;
  final double height;

  @override
  Widget build(BuildContext context) => _DashPaintedChart(
    mode: _DashChartMode.pareto,
    height: height,
    values: values,
    semanticsLabel: 'Pareto chart, ${categories.length} categories',
  );
}

class DashCandlestickChart extends StatelessWidget {
  const DashCandlestickChart({
    super.key,
    required this.candles,
    this.height = 220,
    this.onSelectCandle,
  });

  final List<DashCandle> candles;
  final double height;
  final ValueChanged<int>? onSelectCandle;

  @override
  Widget build(BuildContext context) => _DashPaintedChart(
    mode: _DashChartMode.candlestick,
    height: height,
    candles: candles,
    semanticsLabel: 'Candlestick chart, ${candles.length} intervals',
    onSelect: onSelectCandle,
  );
}

enum _DashChartMode {
  column,
  line,
  combo,
  pie,
  pieOfPie,
  scatter,
  scatterLine,
  histogram,
  boxPlot,
  funnel,
  gauge,
  heatmap,
  radar,
  polar,
  quadrant,
  cartogram,
  map,
  sunburst,
  surface,
  treemap,
  waterfall,
  pareto,
  candlestick,
}

class _DashPaintedChart extends StatelessWidget {
  const _DashPaintedChart({
    required this.mode,
    required this.height,
    required this.semanticsLabel,
    this.series = const [],
    this.points = const [],
    this.slices = const [],
    this.boxGroups = const [],
    this.heatCells = const [],
    this.regions = const [],
    this.nodes = const [],
    this.steps = const [],
    this.candles = const [],
    this.matrix = const [],
    this.values = const [],
    this.options = const [],
    this.count = 0,
    this.rows = 0,
    this.columns = 0,
    this.splitIndex = 0,
    this.centerLabel,
    this.onSelect,
  });

  final _DashChartMode mode;
  final double height;
  final String semanticsLabel;
  final List<DashChartSeries> series;
  final List<DashChartPoint> points;
  final List<DashChartSlice> slices;
  final List<DashBoxPlotGroup> boxGroups;
  final List<DashHeatmapCell> heatCells;
  final List<DashRegionValue> regions;
  final List<DashHierarchyNode> nodes;
  final List<DashWaterfallStep> steps;
  final List<DashCandle> candles;
  final List<List<double>> matrix;
  final List<double> values;
  final List<bool> options;
  final int count;
  final int rows;
  final int columns;
  final int splitIndex;
  final String? centerLabel;
  final ValueChanged<int>? onSelect;

  @override
  Widget build(BuildContext context) {
    final dataTokens = context.plnDataVisualizationTheme;
    final tokens = context.plnTheme;
    final labelStyle = Theme.of(
      context,
    ).textTheme.bodyMedium!.copyWith(color: dataTokens.value);
    final chart = SizedBox(
      height: height,
      child: CustomPaint(
        painter: _DashChartPainter(
          mode: mode,
          series: series,
          points: points,
          slices: slices,
          boxGroups: boxGroups,
          heatCells: heatCells,
          regions: regions,
          nodes: nodes,
          steps: steps,
          candles: candles,
          matrix: matrix,
          values: values,
          options: options,
          count: count,
          rows: rows,
          columns: columns,
          splitIndex: splitIndex,
          centerLabel: centerLabel,
          tokens: dataTokens,
          background: tokens.component,
          labelStyle: labelStyle,
        ),
      ),
    );

    return Semantics(
      image: true,
      button: onSelect != null,
      label: semanticsLabel,
      child: ExcludeSemantics(
        child: onSelect == null
            ? chart
            : GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTapDown: (details) {
                  final width = context.size?.width ?? 1;
                  final horizontal =
                      mode == _DashChartMode.column &&
                      options.length > 2 &&
                      options[2];
                  final estimate = math.max(
                    1,
                    points.isNotEmpty
                        ? points.length
                        : slices.isNotEmpty
                        ? slices.length
                        : series.isNotEmpty
                        ? series.first.values.length
                        : regions.length,
                  );
                  final position = horizontal
                      ? details.localPosition.dy / height
                      : details.localPosition.dx / width;
                  onSelect!(
                    (position * estimate).floor().clamp(0, estimate - 1),
                  );
                },
                child: chart,
              ),
      ),
    );
  }
}

class _DashChartPainter extends CustomPainter {
  const _DashChartPainter({
    required this.mode,
    required this.series,
    required this.points,
    required this.slices,
    required this.boxGroups,
    required this.heatCells,
    required this.regions,
    required this.nodes,
    required this.steps,
    required this.candles,
    required this.matrix,
    required this.values,
    required this.options,
    required this.count,
    required this.rows,
    required this.columns,
    required this.splitIndex,
    required this.centerLabel,
    required this.tokens,
    required this.background,
    required this.labelStyle,
  });

  final _DashChartMode mode;
  final List<DashChartSeries> series;
  final List<DashChartPoint> points;
  final List<DashChartSlice> slices;
  final List<DashBoxPlotGroup> boxGroups;
  final List<DashHeatmapCell> heatCells;
  final List<DashRegionValue> regions;
  final List<DashHierarchyNode> nodes;
  final List<DashWaterfallStep> steps;
  final List<DashCandle> candles;
  final List<List<double>> matrix;
  final List<double> values;
  final List<bool> options;
  final int count;
  final int rows;
  final int columns;
  final int splitIndex;
  final String? centerLabel;
  final PlnDataVisualizationTheme tokens;
  final Color background;
  final TextStyle labelStyle;

  static const _plotPadding = EdgeInsets.fromLTRB(22, 10, 10, 18);

  @override
  void paint(Canvas canvas, Size size) {
    if (size.isEmpty) return;
    final plot = _plotPadding.deflateRect(Offset.zero & size);

    switch (mode) {
      case _DashChartMode.column:
        _grid(canvas, plot);
        _columns(
          canvas,
          plot,
          series,
          stacked: _option(0, false),
          percent: _option(1, false),
          horizontal: _option(2, false),
        );
      case _DashChartMode.line:
        _grid(canvas, plot);
        _lines(canvas, plot, series, showPoints: _option(1, true));
      case _DashChartMode.combo:
        _grid(canvas, plot);
        _columns(canvas, plot, series.take(splitIndex).toList());
        _lines(canvas, plot, series.skip(splitIndex).toList());
      case _DashChartMode.pie:
        _pie(canvas, plot, slices, donut: _option(0, false));
      case _DashChartMode.pieOfPie:
        _pieOfPie(canvas, plot);
      case _DashChartMode.scatter:
        _grid(canvas, plot);
        _scatter(canvas, plot, connect: false);
      case _DashChartMode.scatterLine:
        _grid(canvas, plot);
        _scatter(canvas, plot, connect: true);
      case _DashChartMode.histogram:
        _grid(canvas, plot);
        _histogram(canvas, plot);
      case _DashChartMode.boxPlot:
        _grid(canvas, plot);
        _boxPlot(canvas, plot);
      case _DashChartMode.funnel:
        _funnel(canvas, plot);
      case _DashChartMode.gauge:
        _gauge(canvas, plot);
      case _DashChartMode.heatmap:
        _heatmap(canvas, plot, heatCells, rows, columns);
      case _DashChartMode.radar:
        _radar(canvas, plot);
      case _DashChartMode.polar:
        _polar(canvas, plot);
      case _DashChartMode.quadrant:
        _grid(canvas, plot);
        _quadrant(canvas, plot);
      case _DashChartMode.cartogram:
        _cartogram(canvas, plot);
      case _DashChartMode.map:
        _map(canvas, plot);
      case _DashChartMode.sunburst:
        _sunburst(canvas, plot);
      case _DashChartMode.surface:
        _surface(canvas, plot);
      case _DashChartMode.treemap:
        _treemap(canvas, plot);
      case _DashChartMode.waterfall:
        _grid(canvas, plot);
        _waterfall(canvas, plot);
      case _DashChartMode.pareto:
        _grid(canvas, plot);
        _pareto(canvas, plot);
      case _DashChartMode.candlestick:
        _grid(canvas, plot);
        _candlestick(canvas, plot);
    }
  }

  bool _option(int index, bool fallback) {
    return index < options.length ? options[index] : fallback;
  }

  void _grid(Canvas canvas, Rect plot) {
    final paint = Paint()
      ..color = tokens.grid
      ..strokeWidth = 1;
    for (var index = 0; index <= 4; index++) {
      final y = plot.top + plot.height * index / 4;
      canvas.drawLine(Offset(plot.left, y), Offset(plot.right, y), paint);
    }
    canvas.drawLine(
      plot.bottomLeft,
      plot.bottomRight,
      Paint()..color = tokens.axis,
    );
    canvas.drawLine(
      plot.topLeft,
      plot.bottomLeft,
      Paint()..color = tokens.axis,
    );
  }

  void _columns(
    Canvas canvas,
    Rect plot,
    List<DashChartSeries> source, {
    bool stacked = false,
    bool percent = false,
    bool horizontal = false,
  }) {
    if (source.isEmpty || source.every((item) => item.values.isEmpty)) return;
    final categories = source
        .map((item) => item.values.length)
        .fold(0, math.max);
    if (horizontal) {
      _horizontalColumns(
        canvas,
        plot,
        source,
        categories,
        stacked: stacked,
        percent: percent,
      );
      return;
    }
    if (stacked) {
      _stackedColumns(canvas, plot, source, categories, percent: percent);
      return;
    }
    final transformed = <double>[
      for (var seriesIndex = 0; seriesIndex < source.length; seriesIndex++)
        for (var index = 0; index < source[seriesIndex].values.length; index++)
          _columnValue(source, seriesIndex, index, percent: percent),
    ];
    final extent = _extent(transformed, includeZero: true);
    final groupWidth = plot.width / math.max(1, categories);
    final barWidth = groupWidth * 0.72 / math.max(1, source.length);
    for (var seriesIndex = 0; seriesIndex < source.length; seriesIndex++) {
      final item = source[seriesIndex];
      for (var index = 0; index < item.values.length; index++) {
        final value = _columnValue(
          source,
          seriesIndex,
          index,
          percent: percent,
        );
        final zero = _valueY(0, extent, plot);
        final valueY = _valueY(value, extent, plot);
        final left =
            plot.left +
            index * groupWidth +
            groupWidth * 0.14 +
            seriesIndex * barWidth;
        canvas.drawRRect(
          RRect.fromRectAndRadius(
            Rect.fromLTRB(
              left,
              math.min(zero, valueY),
              left + barWidth * 0.84,
              math.max(zero, valueY),
            ),
            const Radius.circular(2),
          ),
          Paint()..color = tokens.seriesColor(item.colorIndex),
        );
      }
    }
  }

  void _stackedColumns(
    Canvas canvas,
    Rect plot,
    List<DashChartSeries> source,
    int categories, {
    required bool percent,
  }) {
    final positiveTotals = List<double>.filled(categories, 0);
    final negativeTotals = List<double>.filled(categories, 0);
    for (var index = 0; index < categories; index++) {
      for (var seriesIndex = 0; seriesIndex < source.length; seriesIndex++) {
        final value = _columnValue(
          source,
          seriesIndex,
          index,
          percent: percent,
        );
        if (value >= 0) {
          positiveTotals[index] += value;
        } else {
          negativeTotals[index] += value;
        }
      }
    }
    final extent = _extent([
      ...positiveTotals,
      ...negativeTotals,
    ], includeZero: true);
    final groupWidth = plot.width / math.max(1, categories);
    final positive = List<double>.filled(categories, 0);
    final negative = List<double>.filled(categories, 0);
    for (var seriesIndex = 0; seriesIndex < source.length; seriesIndex++) {
      final item = source[seriesIndex];
      for (var index = 0; index < categories; index++) {
        final value = _columnValue(
          source,
          seriesIndex,
          index,
          percent: percent,
        );
        final from = value >= 0 ? positive[index] : negative[index];
        final to = from + value;
        if (value >= 0) {
          positive[index] = to;
        } else {
          negative[index] = to;
        }
        final left = plot.left + index * groupWidth + groupWidth * 0.14;
        canvas.drawRRect(
          RRect.fromRectAndRadius(
            Rect.fromLTRB(
              left,
              math.min(_valueY(from, extent, plot), _valueY(to, extent, plot)),
              left + groupWidth * 0.72,
              math.max(_valueY(from, extent, plot), _valueY(to, extent, plot)),
            ),
            const Radius.circular(2),
          ),
          Paint()..color = tokens.seriesColor(item.colorIndex),
        );
      }
    }
  }

  void _horizontalColumns(
    Canvas canvas,
    Rect plot,
    List<DashChartSeries> source,
    int categories, {
    required bool stacked,
    required bool percent,
  }) {
    final positiveTotals = List<double>.filled(categories, 0);
    final negativeTotals = List<double>.filled(categories, 0);
    final transformed = <double>[];
    for (var index = 0; index < categories; index++) {
      for (var seriesIndex = 0; seriesIndex < source.length; seriesIndex++) {
        final value = _columnValue(
          source,
          seriesIndex,
          index,
          percent: percent,
        );
        transformed.add(value);
        if (value >= 0) {
          positiveTotals[index] += value;
        } else {
          negativeTotals[index] += value;
        }
      }
    }
    final extent = _extent(
      stacked ? [...positiveTotals, ...negativeTotals] : transformed,
      includeZero: true,
    );
    final groupHeight = plot.height / math.max(1, categories);
    final barHeight = stacked
        ? groupHeight * 0.72
        : groupHeight * 0.72 / math.max(1, source.length);
    final positive = List<double>.filled(categories, 0);
    final negative = List<double>.filled(categories, 0);
    for (var seriesIndex = 0; seriesIndex < source.length; seriesIndex++) {
      final item = source[seriesIndex];
      for (var index = 0; index < categories; index++) {
        final value = _columnValue(
          source,
          seriesIndex,
          index,
          percent: percent,
        );
        final from = stacked
            ? value >= 0
                  ? positive[index]
                  : negative[index]
            : 0.0;
        final to = from + value;
        if (stacked) {
          if (value >= 0) {
            positive[index] = to;
          } else {
            negative[index] = to;
          }
        }
        final top =
            plot.top +
            index * groupHeight +
            groupHeight * 0.14 +
            (stacked ? 0 : seriesIndex * barHeight);
        canvas.drawRRect(
          RRect.fromRectAndRadius(
            Rect.fromLTRB(
              math.min(_valueX(from, extent, plot), _valueX(to, extent, plot)),
              top,
              math.max(_valueX(from, extent, plot), _valueX(to, extent, plot)),
              top + barHeight * (stacked ? 1 : 0.84),
            ),
            const Radius.circular(2),
          ),
          Paint()..color = tokens.seriesColor(item.colorIndex),
        );
      }
    }
  }

  double _columnValue(
    List<DashChartSeries> source,
    int seriesIndex,
    int categoryIndex, {
    required bool percent,
  }) {
    final item = source[seriesIndex];
    if (categoryIndex >= item.values.length) return 0;
    final value = item.values[categoryIndex];
    if (!percent) return value;
    final total = source.fold<double>(0, (sum, series) {
      return sum +
          (categoryIndex < series.values.length
              ? series.values[categoryIndex].abs()
              : 0);
    });
    return total == 0 ? 0 : value / total;
  }

  void _lines(
    Canvas canvas,
    Rect plot,
    List<DashChartSeries> source, {
    bool showPoints = true,
  }) {
    if (source.isEmpty || source.every((item) => item.values.isEmpty)) return;
    final all = source.expand((item) => item.values).toList();
    final extent = _extent(all);
    for (final item in source) {
      if (item.values.isEmpty) continue;
      final path = Path();
      for (var index = 0; index < item.values.length; index++) {
        final point = Offset(
          item.values.length == 1
              ? plot.center.dx
              : plot.left + plot.width * index / (item.values.length - 1),
          _valueY(item.values[index], extent, plot),
        );
        index == 0
            ? path.moveTo(point.dx, point.dy)
            : path.lineTo(point.dx, point.dy);
        if (showPoints) {
          canvas.drawCircle(
            point,
            2.5,
            Paint()..color = tokens.seriesColor(item.colorIndex),
          );
        }
      }
      if (item.filled) {
        final area = Path.from(path)
          ..lineTo(plot.right, plot.bottom)
          ..lineTo(plot.left, plot.bottom)
          ..close();
        canvas.drawPath(
          area,
          Paint()..color = tokens.seriesWashColor(item.colorIndex),
        );
      }
      canvas.drawPath(
        path,
        Paint()
          ..color = tokens.seriesColor(item.colorIndex)
          ..strokeWidth = 1.8
          ..style = PaintingStyle.stroke
          ..strokeJoin = StrokeJoin.round,
      );
    }
  }

  void _pie(
    Canvas canvas,
    Rect plot,
    List<DashChartSlice> source, {
    required bool donut,
  }) {
    final positive = source.where((item) => item.value > 0).toList();
    final total = positive.fold<double>(0, (sum, item) => sum + item.value);
    if (total <= 0) return;
    final center = plot.center;
    final radius = math.min(plot.width, plot.height) * 0.4;
    var angle = -math.pi / 2;
    for (final item in positive) {
      final sweep = math.pi * 2 * item.value / total;
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        angle,
        sweep,
        true,
        Paint()..color = tokens.seriesColor(item.colorIndex),
      );
      angle += sweep;
    }
    if (donut) {
      canvas.drawCircle(center, radius * 0.53, Paint()..color = background);
    }
  }

  void _pieOfPie(Canvas canvas, Rect plot) {
    final left = Rect.fromLTWH(
      plot.left,
      plot.top,
      plot.width * 0.58,
      plot.height,
    );
    final right = Rect.fromLTWH(
      plot.left + plot.width * 0.66,
      plot.top + plot.height * 0.2,
      plot.width * 0.34,
      plot.height * 0.6,
    );
    final primary = slices.take(splitIndex).toList();
    final secondary = slices.skip(splitIndex).toList();
    final expandedValue = secondary.fold<double>(
      0,
      (sum, slice) => sum + math.max(0, slice.value),
    );
    _pie(canvas, left, [
      ...primary,
      if (expandedValue > 0)
        DashChartSlice(
          id: 'expanded',
          label: 'Expanded',
          value: expandedValue,
          colorIndex: secondary.first.colorIndex,
        ),
    ], donut: false);
    if (secondary.isNotEmpty) {
      _pie(canvas, right, secondary, donut: false);
      canvas.drawLine(
        left.centerRight,
        right.centerLeft,
        Paint()..color = tokens.axis,
      );
    }
  }

  void _scatter(Canvas canvas, Rect plot, {required bool connect}) {
    if (points.isEmpty) return;
    final xExtent = _extent(points.map((point) => point.x).toList());
    final yExtent = _extent(points.map((point) => point.y).toList());
    final offsets = <Offset>[];
    for (final point in points) {
      final offset = Offset(
        _valueX(point.x, xExtent, plot),
        _valueY(point.y, yExtent, plot),
      );
      offsets.add(offset);
      canvas.drawCircle(
        offset,
        3 + point.size.clamp(0, 12),
        Paint()
          ..color = tokens
              .seriesColor(point.colorIndex)
              .withValues(alpha: 0.78),
      );
    }
    if (connect && offsets.length > 1) {
      final sorted = [...offsets]..sort((a, b) => a.dx.compareTo(b.dx));
      final path = Path()..moveTo(sorted.first.dx, sorted.first.dy);
      for (final point in sorted.skip(1)) {
        path.lineTo(point.dx, point.dy);
      }
      canvas.drawPath(
        path,
        Paint()
          ..color = tokens.seriesColor(0)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.5,
      );
    }
  }

  void _histogram(Canvas canvas, Rect plot) {
    if (values.isEmpty) return;
    final bins = math.max(1, count);
    final extent = _extent(values);
    final counts = List<int>.filled(bins, 0);
    for (final value in values) {
      final ratio =
          (value - extent.$1) / math.max(0.000001, extent.$2 - extent.$1);
      counts[(ratio * bins).floor().clamp(0, bins - 1)]++;
    }
    final maxCount = counts.fold<int>(1, math.max);
    final width = plot.width / bins;
    for (var index = 0; index < bins; index++) {
      final height = plot.height * counts[index] / maxCount;
      canvas.drawRect(
        Rect.fromLTWH(
          plot.left + index * width + 1,
          plot.bottom - height,
          math.max(1, width - 2),
          height,
        ),
        Paint()..color = tokens.seriesColor(0),
      );
    }
  }

  void _boxPlot(Canvas canvas, Rect plot) {
    final all = boxGroups.expand((group) => group.values).toList();
    if (all.isEmpty) return;
    final extent = _extent(all);
    final groupWidth = plot.width / math.max(1, boxGroups.length);
    for (var index = 0; index < boxGroups.length; index++) {
      final values = [...boxGroups[index].values]..sort();
      if (values.isEmpty) continue;
      final x = plot.left + groupWidth * (index + 0.5);
      final low = _valueY(values.first, extent, plot);
      final high = _valueY(values.last, extent, plot);
      final q1 = _valueY(_quantile(values, 0.25), extent, plot);
      final median = _valueY(_quantile(values, 0.5), extent, plot);
      final q3 = _valueY(_quantile(values, 0.75), extent, plot);
      final color = tokens.seriesColor(boxGroups[index].colorIndex);
      canvas.drawLine(Offset(x, high), Offset(x, low), Paint()..color = color);
      final box = Rect.fromLTRB(
        x - groupWidth * 0.22,
        math.min(q1, q3),
        x + groupWidth * 0.22,
        math.max(q1, q3),
      );
      canvas.drawRect(
        box,
        Paint()..color = tokens.seriesWashColor(boxGroups[index].colorIndex),
      );
      canvas.drawRect(
        box,
        Paint()
          ..color = color
          ..style = PaintingStyle.stroke,
      );
      canvas.drawLine(
        Offset(box.left, median),
        Offset(box.right, median),
        Paint()..color = color,
      );
    }
  }

  void _funnel(Canvas canvas, Rect plot) {
    if (slices.isEmpty) return;
    final maxValue = slices
        .map((item) => item.value.abs())
        .fold<double>(1, math.max);
    final itemHeight = plot.height / slices.length;
    for (var index = 0; index < slices.length; index++) {
      final width =
          plot.width * (slices[index].value.abs() / maxValue).clamp(0.08, 1);
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromCenter(
            center: Offset(
              plot.center.dx,
              plot.top + itemHeight * (index + 0.5),
            ),
            width: width,
            height: itemHeight * 0.78,
          ),
          const Radius.circular(3),
        ),
        Paint()..color = tokens.seriesColor(slices[index].colorIndex),
      );
    }
  }

  void _gauge(Canvas canvas, Rect plot) {
    if (values.length < 3) return;
    final minimum = values[1];
    final maximum = values[2];
    final ratio =
        ((values[0] - minimum) / math.max(0.000001, maximum - minimum)).clamp(
          0,
          1,
        );
    final center = Offset(plot.center.dx, plot.bottom * 0.78);
    final radius = math.min(plot.width * 0.42, plot.height * 0.72);
    final rect = Rect.fromCircle(center: center, radius: radius);
    final base = Paint()
      ..color = tokens.grid
      ..style = PaintingStyle.stroke
      ..strokeWidth = 12
      ..strokeCap = StrokeCap.round;
    canvas.drawArc(rect, math.pi, math.pi, false, base);
    canvas.drawArc(
      rect,
      math.pi,
      math.pi * ratio,
      false,
      Paint()
        ..color = tokens.seriesColor(0)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 12
        ..strokeCap = StrokeCap.round,
    );
    final angle = math.pi + math.pi * ratio;
    canvas.drawLine(
      center,
      center + Offset(math.cos(angle), math.sin(angle)) * radius * 0.78,
      Paint()
        ..color = tokens.value
        ..strokeWidth = 2,
    );
    if (values.length > 3) {
      final targetRatio =
          ((values[3] - minimum) / math.max(0.000001, maximum - minimum)).clamp(
            0,
            1,
          );
      final targetAngle = math.pi + math.pi * targetRatio;
      final direction = Offset(math.cos(targetAngle), math.sin(targetAngle));
      canvas.drawLine(
        center + direction * radius * 0.86,
        center + direction * radius * 1.02,
        Paint()
          ..color = tokens.value
          ..strokeWidth = 2,
      );
    }
    if (centerLabel != null) {
      _label(canvas, centerLabel!, Offset(center.dx, center.dy + 12));
    }
  }

  void _heatmap(
    Canvas canvas,
    Rect plot,
    List<DashHeatmapCell> source,
    int rowCount,
    int columnCount,
  ) {
    if (rowCount <= 0 || columnCount <= 0) return;
    final extent = _extent(source.map((cell) => cell.value).toList());
    final width = plot.width / columnCount;
    final height = plot.height / rowCount;
    for (final cell in source) {
      if (cell.row < 0 ||
          cell.row >= rowCount ||
          cell.column < 0 ||
          cell.column >= columnCount) {
        continue;
      }
      final ratio =
          (cell.value - extent.$1) / math.max(0.000001, extent.$2 - extent.$1);
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(
            plot.left + cell.column * width + 1,
            plot.top + cell.row * height + 1,
            math.max(1, width - 2),
            math.max(1, height - 2),
          ),
          const Radius.circular(2),
        ),
        Paint()
          ..color = Color.lerp(
            tokens.seriesWashColor(0),
            tokens.seriesColor(0),
            ratio,
          )!,
      );
    }
  }

  void _radar(Canvas canvas, Rect plot) {
    final axes = math.max(3, count);
    final center = plot.center;
    final radius = math.min(plot.width, plot.height) * 0.4;
    for (var ring = 1; ring <= 4; ring++) {
      final path = _polygon(center, radius * ring / 4, axes);
      canvas.drawPath(
        path,
        Paint()
          ..color = tokens.grid
          ..style = PaintingStyle.stroke,
      );
    }
    for (var index = 0; index < axes; index++) {
      final angle = -math.pi / 2 + math.pi * 2 * index / axes;
      canvas.drawLine(
        center,
        center + Offset(math.cos(angle), math.sin(angle)) * radius,
        Paint()..color = tokens.axis,
      );
    }
    for (final item in series) {
      if (item.values.isEmpty) continue;
      final maxValue = item.values
          .map((value) => value.abs())
          .fold<double>(1, math.max);
      final path = Path();
      for (var index = 0; index < axes; index++) {
        final value = index < item.values.length
            ? item.values[index].abs() / maxValue
            : 0.0;
        final angle = -math.pi / 2 + math.pi * 2 * index / axes;
        final point =
            center + Offset(math.cos(angle), math.sin(angle)) * radius * value;
        index == 0
            ? path.moveTo(point.dx, point.dy)
            : path.lineTo(point.dx, point.dy);
      }
      path.close();
      canvas.drawPath(
        path,
        Paint()..color = tokens.seriesWashColor(item.colorIndex),
      );
      canvas.drawPath(
        path,
        Paint()
          ..color = tokens.seriesColor(item.colorIndex)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.5,
      );
    }
  }

  void _polar(Canvas canvas, Rect plot) {
    final center = plot.center;
    final radius = math.min(plot.width, plot.height) * 0.42;
    for (var ring = 1; ring <= 3; ring++) {
      canvas.drawCircle(
        center,
        radius * ring / 3,
        Paint()
          ..color = tokens.grid
          ..style = PaintingStyle.stroke,
      );
    }
    for (final point in points) {
      final angle = point.x;
      final distance = point.y.clamp(0, 1) * radius;
      canvas.drawCircle(
        center + Offset(math.cos(angle), math.sin(angle)) * distance,
        3 + point.size,
        Paint()..color = tokens.seriesColor(point.colorIndex),
      );
    }
  }

  void _quadrant(Canvas canvas, Rect plot) {
    if (points.isEmpty) return;
    final xExtent = _extent([
      ...points.map((point) => point.x),
      if (values.isNotEmpty) values[0],
    ]);
    final yExtent = _extent([
      ...points.map((point) => point.y),
      if (values.length > 1) values[1],
    ]);
    final splitX = _valueX(values.isEmpty ? 0 : values[0], xExtent, plot);
    final splitY = _valueY(values.length < 2 ? 0 : values[1], yExtent, plot);
    canvas.drawLine(
      Offset(splitX, plot.top),
      Offset(splitX, plot.bottom),
      Paint()
        ..color = tokens.axis
        ..strokeWidth = 1.5,
    );
    canvas.drawLine(
      Offset(plot.left, splitY),
      Offset(plot.right, splitY),
      Paint()
        ..color = tokens.axis
        ..strokeWidth = 1.5,
    );
    _scatter(canvas, plot, connect: false);
  }

  void _cartogram(Canvas canvas, Rect plot) {
    if (regions.isEmpty) return;
    final columnCount = math.max(1, columns);
    final rowCount = (regions.length / columnCount).ceil();
    final extent = _extent(regions.map((region) => region.value).toList());
    final cellWidth = plot.width / columnCount;
    final cellHeight = plot.height / math.max(1, rowCount);
    for (var index = 0; index < regions.length; index++) {
      final region = regions[index];
      final ratio =
          (region.value - extent.$1) /
          math.max(0.000001, extent.$2 - extent.$1);
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(
            plot.left + index % columnCount * cellWidth + 2,
            plot.top + index ~/ columnCount * cellHeight + 2,
            math.max(1, cellWidth - 4),
            math.max(1, cellHeight - 4),
          ),
          const Radius.circular(3),
        ),
        Paint()
          ..color = Color.lerp(
            tokens.seriesWashColor(0),
            tokens.seriesColor(0),
            ratio,
          )!,
      );
    }
  }

  void _map(Canvas canvas, Rect plot) {
    final path = Path()
      ..moveTo(plot.left + plot.width * 0.08, plot.top + plot.height * 0.58)
      ..quadraticBezierTo(
        plot.left + plot.width * 0.32,
        plot.top + plot.height * 0.18,
        plot.left + plot.width * 0.5,
        plot.top + plot.height * 0.45,
      )
      ..quadraticBezierTo(
        plot.left + plot.width * 0.72,
        plot.top + plot.height * 0.78,
        plot.right - plot.width * 0.06,
        plot.top + plot.height * 0.32,
      )
      ..lineTo(plot.right - plot.width * 0.1, plot.bottom - plot.height * 0.08)
      ..lineTo(plot.left + plot.width * 0.18, plot.bottom - plot.height * 0.12)
      ..close();
    canvas.drawPath(path, Paint()..color = tokens.seriesWashColor(1));
    canvas.drawPath(
      path,
      Paint()
        ..color = tokens.axis
        ..style = PaintingStyle.stroke,
    );
    for (final point in points) {
      final x = plot.left + ((point.x + 180) / 360).clamp(0, 1) * plot.width;
      final y = plot.bottom - ((point.y + 90) / 180).clamp(0, 1) * plot.height;
      canvas.drawCircle(
        Offset(x, y),
        3 + point.size,
        Paint()..color = tokens.seriesColor(point.colorIndex),
      );
    }
  }

  void _sunburst(Canvas canvas, Rect plot) {
    final center = plot.center;
    final radius = math.min(plot.width, plot.height) * 0.42;
    final total = nodes.fold<double>(
      0,
      (sum, node) => sum + math.max(0, node.value),
    );
    if (total <= 0) return;
    var start = -math.pi / 2;
    for (final node in nodes) {
      final sweep = math.pi * 2 * math.max(0, node.value) / total;
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        start,
        sweep,
        false,
        Paint()
          ..color = tokens.seriesColor(node.colorIndex)
          ..style = PaintingStyle.stroke
          ..strokeWidth = radius * 0.32,
      );
      if (node.children.isNotEmpty) {
        final childTotal = node.children.fold<double>(
          0,
          (sum, child) => sum + math.max(0, child.value),
        );
        var childStart = start;
        for (final child in node.children) {
          final childSweep = childTotal <= 0
              ? 0.0
              : sweep * child.value / childTotal;
          canvas.drawArc(
            Rect.fromCircle(center: center, radius: radius * 0.6),
            childStart,
            childSweep,
            false,
            Paint()
              ..color = tokens.seriesColor(child.colorIndex)
              ..style = PaintingStyle.stroke
              ..strokeWidth = radius * 0.2,
          );
          childStart += childSweep;
        }
      }
      start += sweep;
    }
  }

  void _surface(Canvas canvas, Rect plot) {
    if (matrix.isEmpty || matrix.every((row) => row.isEmpty)) return;
    final all = matrix.expand((row) => row).toList();
    final extent = _extent(all);
    final rowCount = matrix.length;
    final columnCount = matrix.map((row) => row.length).fold<int>(0, math.max);
    final width = plot.width / math.max(1, columnCount);
    final height = plot.height / rowCount;
    for (var row = 0; row < matrix.length; row++) {
      for (var column = 0; column < matrix[row].length; column++) {
        final ratio =
            (matrix[row][column] - extent.$1) /
            math.max(0.000001, extent.$2 - extent.$1);
        final lift = ratio * height * 0.45;
        final cell = Rect.fromLTWH(
          plot.left + column * width,
          plot.top + row * height - lift,
          width + 1,
          height + lift + 1,
        );
        canvas.drawRect(
          cell,
          Paint()
            ..color = Color.lerp(
              tokens.seriesWashColor(2),
              tokens.seriesColor(2),
              ratio,
            )!,
        );
        canvas.drawRect(
          cell,
          Paint()
            ..color = tokens.grid
            ..style = PaintingStyle.stroke,
        );
      }
    }
  }

  void _treemap(Canvas canvas, Rect plot) {
    if (nodes.isEmpty) return;
    final total = nodes.fold<double>(
      0,
      (sum, node) => sum + math.max(0, node.value),
    );
    if (total <= 0) return;
    var left = plot.left;
    for (var index = 0; index < nodes.length; index++) {
      final width = index == nodes.length - 1
          ? plot.right - left
          : plot.width * nodes[index].value / total;
      final rect = Rect.fromLTWH(
        left + 1,
        plot.top + 1,
        math.max(1, width - 2),
        math.max(1, plot.height - 2),
      );
      canvas.drawRRect(
        RRect.fromRectAndRadius(rect, const Radius.circular(3)),
        Paint()
          ..color = tokens
              .seriesColor(nodes[index].colorIndex)
              .withValues(alpha: 0.74),
      );
      left += width;
    }
  }

  void _waterfall(Canvas canvas, Rect plot) {
    if (steps.isEmpty) return;
    final balances = <double>[0];
    for (final step in steps) {
      balances.add(step.subtotal ? step.value : balances.last + step.value);
    }
    final extent = _extent(balances, includeZero: true);
    final width = plot.width / steps.length;
    for (var index = 0; index < steps.length; index++) {
      final from = steps[index].subtotal ? 0.0 : balances[index];
      final to = balances[index + 1];
      final top = _valueY(math.max(from, to), extent, plot);
      final bottom = _valueY(math.min(from, to), extent, plot);
      final color = steps[index].subtotal
          ? tokens.value
          : steps[index].value >= 0
          ? tokens.marketUp
          : tokens.marketDown;
      canvas.drawRect(
        Rect.fromLTRB(
          plot.left + index * width + width * 0.18,
          top,
          plot.left + (index + 1) * width - width * 0.18,
          bottom,
        ),
        Paint()..color = color,
      );
      if (index < steps.length - 1) {
        canvas.drawLine(
          Offset(
            plot.left + (index + 1) * width - width * 0.18,
            _valueY(to, extent, plot),
          ),
          Offset(
            plot.left + (index + 1) * width + width * 0.18,
            _valueY(to, extent, plot),
          ),
          Paint()..color = tokens.axis,
        );
      }
    }
  }

  void _pareto(Canvas canvas, Rect plot) {
    if (values.isEmpty) return;
    final sorted = [...values]..sort((a, b) => b.compareTo(a));
    _columns(canvas, plot, [
      DashChartSeries(id: 'pareto', label: 'Pareto', values: sorted),
    ]);
    final total = sorted.fold<double>(
      0,
      (sum, value) => sum + math.max(0, value),
    );
    if (total <= 0) return;
    var cumulative = 0.0;
    final path = Path();
    for (var index = 0; index < sorted.length; index++) {
      cumulative += math.max(0, sorted[index]);
      final point = Offset(
        plot.left + plot.width * (index + 0.5) / sorted.length,
        plot.bottom - plot.height * cumulative / total,
      );
      index == 0
          ? path.moveTo(point.dx, point.dy)
          : path.lineTo(point.dx, point.dy);
    }
    canvas.drawPath(
      path,
      Paint()
        ..color = tokens.seriesColor(1)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.8,
    );
  }

  void _candlestick(Canvas canvas, Rect plot) {
    if (candles.isEmpty) return;
    final extent = _extent(
      candles.expand((candle) => [candle.high, candle.low]).toList(),
    );
    final width = plot.width / candles.length;
    for (var index = 0; index < candles.length; index++) {
      final candle = candles[index];
      final x = plot.left + width * (index + 0.5);
      final color = candle.close >= candle.open
          ? tokens.marketUp
          : tokens.marketDown;
      canvas.drawLine(
        Offset(x, _valueY(candle.high, extent, plot)),
        Offset(x, _valueY(candle.low, extent, plot)),
        Paint()..color = color,
      );
      final open = _valueY(candle.open, extent, plot);
      final close = _valueY(candle.close, extent, plot);
      canvas.drawRect(
        Rect.fromLTRB(
          x - width * 0.25,
          math.min(open, close),
          x + width * 0.25,
          math.max(open + 1, close),
        ),
        Paint()..color = color,
      );
    }
  }

  Path _polygon(Offset center, double radius, int sides) {
    final path = Path();
    for (var index = 0; index < sides; index++) {
      final angle = -math.pi / 2 + math.pi * 2 * index / sides;
      final point = center + Offset(math.cos(angle), math.sin(angle)) * radius;
      index == 0
          ? path.moveTo(point.dx, point.dy)
          : path.lineTo(point.dx, point.dy);
    }
    return path..close();
  }

  void _label(Canvas canvas, String text, Offset center) {
    final painter = TextPainter(
      text: TextSpan(text: text, style: labelStyle),
      textDirection: TextDirection.ltr,
    )..layout();
    painter.paint(
      canvas,
      center - Offset(painter.width / 2, painter.height / 2),
    );
  }

  (double, double) _extent(List<double> source, {bool includeZero = false}) {
    if (source.isEmpty) return (0, 1);
    var minimum = source.reduce(math.min);
    var maximum = source.reduce(math.max);
    if (includeZero) {
      minimum = math.min(0, minimum);
      maximum = math.max(0, maximum);
    }
    if (minimum == maximum) {
      minimum -= 1;
      maximum += 1;
    }
    return (minimum, maximum);
  }

  double _valueX(double value, (double, double) extent, Rect plot) {
    return plot.left +
        (value - extent.$1) / (extent.$2 - extent.$1) * plot.width;
  }

  double _valueY(double value, (double, double) extent, Rect plot) {
    return plot.bottom -
        (value - extent.$1) / (extent.$2 - extent.$1) * plot.height;
  }

  double _quantile(List<double> source, double percentile) {
    if (source.length == 1) return source.first;
    final position = (source.length - 1) * percentile;
    final lower = position.floor();
    final upper = position.ceil();
    if (lower == upper) return source[lower];
    return source[lower] + (source[upper] - source[lower]) * (position - lower);
  }

  @override
  bool shouldRepaint(covariant _DashChartPainter oldDelegate) {
    return oldDelegate.mode != mode ||
        oldDelegate.series != series ||
        oldDelegate.points != points ||
        oldDelegate.slices != slices ||
        oldDelegate.boxGroups != boxGroups ||
        oldDelegate.heatCells != heatCells ||
        oldDelegate.regions != regions ||
        oldDelegate.nodes != nodes ||
        oldDelegate.steps != steps ||
        oldDelegate.candles != candles ||
        oldDelegate.matrix != matrix ||
        oldDelegate.values != values ||
        oldDelegate.options != options ||
        oldDelegate.count != count ||
        oldDelegate.rows != rows ||
        oldDelegate.columns != columns ||
        oldDelegate.splitIndex != splitIndex ||
        oldDelegate.centerLabel != centerLabel ||
        oldDelegate.tokens != tokens ||
        oldDelegate.background != background ||
        oldDelegate.labelStyle != labelStyle;
  }
}

String _seriesSummary(String chart, List<DashChartSeries> series, int marks) {
  return '$chart, ${series.length} series, $marks categories';
}

int _nodeCount(List<DashHierarchyNode> nodes) {
  return nodes.fold<int>(
    0,
    (count, node) => count + 1 + _nodeCount(node.children),
  );
}
