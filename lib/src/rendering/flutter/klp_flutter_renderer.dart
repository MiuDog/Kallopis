import 'package:kallopis/src/kernel/diagnostics/klp_contract_error.dart';
import 'package:kallopis/src/features/workspace/presentation/klp_workspace_presentation.dart';
import 'package:kallopis/src/features/editing/presentation/klp_editing_presentation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart' show DefaultMaterialLocalizations, PageRouteBuilder;
import 'package:kallopis/src/styling/presets/klp_paper_shadow_recipe.dart';

import 'package:kallopis/src/foundation/binding/contracts/klp_bound_template.dart';
import 'package:kallopis/src/foundation/platform/klp_id_scope.dart';
import 'package:kallopis/src/kernel/identity/klp_id.dart';
import 'package:kallopis/src/kernel/identity/klp_placement_id.dart';
import 'internal/klp_flutter_app_layout.dart';
import 'internal/klp_flutter_frame_groups.dart';
import 'internal/klp_flutter_choice.dart';
import 'internal/klp_flutter_editing.dart';
import 'internal/klp_flutter_block_note_editing.dart';
import 'internal/klp_flutter_canva_editing.dart';
import 'internal/klp_flutter_extent.dart';
import 'internal/klp_flutter_linear.dart';
import 'internal/klp_flutter_regions.dart';
import 'internal/klp_flutter_retained_stack.dart';
import 'internal/klp_flutter_values.dart';
import 'internal/klp_flutter_workspace_components.dart';
import 'internal/klp_flutter_workspace_block.dart';

/// 唯一封閉的 Flutter 呈現分派；不接受消費端 Widget 或 builder。
final class KlpFlutterRenderer extends StatelessWidget {
	final KlpBoundTemplate content;

	KlpFlutterRenderer({required this.content, Key? key})
		: super(key: key ?? _placementKey(content));

	static Key? _placementKey(KlpBoundTemplate content) => switch (content) {
		KlpBoundPlacement(:final id) => ValueKey(id),
		KlpBoundChoice(:final id) => ValueKey(id),
		_ => null,
	};

	@override
	Widget build(BuildContext context) {
		// 只消費已解析快照，不在畫面建構階段執行外部資料投影。
		return switch (content) {
			KlpBoundExplorer value => KlpFlutterExplorer(content: value),
			KlpBoundDocumentTabs value => KlpFlutterDocumentTabs(content: value),
			KlpBoundWindowControls value => KlpFlutterWindowControls(content: value),
			KlpBoundWorkspaceData() => const SizedBox.shrink(),
			KlpBoundWorkspaceContent() || KlpBoundWorkspaceContentBlock() => const SizedBox.shrink(),
			KlpBoundWorkspaceBlock value => KlpFlutterWorkspaceBlock(content: value),
			KlpBoundEditing value => KlpFlutterEditing(content: value),
			KlpBoundBlockNoteEditing value => KlpFlutterBlockNoteEditing(content: value, key: ObjectKey(value.controller)),
			KlpBoundCanvaEditing value => KlpFlutterCanvaEditing(content: value, key: ObjectKey(value.controller)),
			KlpBoundBlockControlsSlot() => const SizedBox.shrink(),
			KlpBoundAnchoredCommandsSlot() => const SizedBox.shrink(),
			KlpBoundModeToolbarSlot() => const SizedBox.shrink(),
			KlpBoundPlacement value => KlpIdScope(
				id: _scopeId(value.id),
				child: KlpFlutterRenderer(content: value.content),
			),
			KlpBoundText value => Text(
				value.text,
				style: klpFlutterTextStyle(value.style),
			),
			KlpBoundLinear value => KlpFlutterLinear(content: value),
			KlpBoundSurface value => _surface(value),
			KlpBoundChoice value => KlpFlutterChoice(content: value),
			KlpBoundRegions value => KlpFlutterRegions(content: value),
			KlpBoundAppLayout value => KlpFlutterAppLayout(content: value),
			KlpBoundFrameGroups value => KlpFlutterFrameGroups(content: value),
			KlpBoundFrameGroup value => KlpFlutterFrameGroup(content: value),
			KlpBoundExtent value => KlpFlutterExtent(content: value),
			KlpBoundRetainedStack value => KlpFlutterRetainedStack(content: value),
			KlpBoundScreen value => _KlpFlutterOverlayHost(child: Semantics(
				namesRoute: true,
				label: value.accessibilityLabel,
				child: KlpFlutterRenderer(content: value.child),
			)),
			KlpBoundAccessibility value => Semantics(
				container: true,
				label: value.label,
				child: KlpFlutterRenderer(content: value.child),
			),
			_ => throw KlpContractError('unsupported_prepared_template', 'Unsupported prepared template: ${content.runtimeType}'),
		};
	}

	Widget _surface(KlpBoundSurface value) {
		final radius = BorderRadius.circular(value.radius.value);
		final decoration = BoxDecoration(
			color: klpFlutterColor(value.background),
			borderRadius: radius,
		);
		final child = Padding(
			padding: EdgeInsets.all(value.inset.value),
			child: KlpFlutterRenderer(content: value.child),
		);
		final surface = ClipRRect(
			borderRadius: radius,
			child: DecoratedBox(decoration: decoration, child: child),
		);
		final shadow = value.shadow;
		if (shadow == null) return surface;
		final color = klpFlutterColor(shadow.color);
		final factor = KlpPaperShadowRecipe.factor(shadow.scale.value);

		// 陰影置於裁切之外，內容仍由原有圓角邊界裁切。
		return DecoratedBox(
			decoration: BoxDecoration(
				borderRadius: radius,
				boxShadow: [
					BoxShadow(color: color, offset: Offset(0, KlpPaperShadowRecipe.contactOffsetY * factor), blurRadius: KlpPaperShadowRecipe.contactBlur * factor),
					BoxShadow(color: color, offset: Offset(0, KlpPaperShadowRecipe.ambientOffsetY * factor), blurRadius: KlpPaperShadowRecipe.ambientBlur * factor),
				],
			),
			child: surface,
		);
	}

	KlpId _scopeId(KlpPlacementId placement) {
		final segments = <String>[
			for (final value in placement.scope) ...value.split('.'),
			...placement.localId.split('.'),
		];
		return KlpId.from(segments);
	}
}

/// 由完整畫面持有浮層，讓選單、對話框與拖曳回饋不受局部元件邊界裁切。
final class _KlpFlutterOverlayHost extends StatefulWidget {
	final Widget child;
	const _KlpFlutterOverlayHost({required this.child});
	@override
	State<_KlpFlutterOverlayHost> createState() => _KlpFlutterOverlayHostState();
}

final class _KlpFlutterOverlayHostState extends State<_KlpFlutterOverlayHost> {
	late final _content = ValueNotifier<Widget>(widget.child);
	@override
	void didUpdateWidget(_KlpFlutterOverlayHost oldWidget) {
		super.didUpdateWidget(oldWidget);
		_content.value = widget.child;
	}
	@override
	void dispose() {
		_content.dispose();
		super.dispose();
	}
	@override
	Widget build(BuildContext context) => Localizations.override(context: context, delegates: const [DefaultMaterialLocalizations.delegate], child: Navigator(onGenerateRoute: (_) => PageRouteBuilder(pageBuilder: (_, _, _) => ValueListenableBuilder<Widget>(valueListenable: _content, builder: (_, child, _) => child))));
}
