import 'package:flutter/material.dart';

import '../../../../foundation/layout/klp_layout.dart';
import '../../../../styling/legacy_theme/klp_theme.dart';
import '../panel/klp_panel_footer.dart';
import '../status/klp_status_bar.dart';
import '../status/klp_status_data.dart';
import 'klp_stage_header.dart';

part 'primitives/klp_stage_header_slot.dart';
part 'primitives/klp_stage_status_slot.dart';
part 'primitives/klp_stage_surface.dart';

/// 舞台區：選用的頂部 header、中央 content、底部選用的 status 列。
class KlpStageFrame extends StatelessWidget {
	const KlpStageFrame({
		super.key,
		this.header,
		required this.content,
		this.status,
	});

	/// 建立具備 Kallopis 標準識別列與狀態列的工作舞台。
	///
	/// 產品只提供語意資料與主要內容；header、status 的元件選擇、排列、間距與
	/// 響應式行為都留在 Kallopis。
	factory KlpStageFrame.workbench({
		Key? key,
		required String projectName,
		required String sectionLabel,
		required String title,
		required String typeLabel,
		required Widget content,
		KlpStatusBarData? status,
	}) {
		return KlpStageFrame(
			key: key,
			header: KlpStageHeader(
				projectName: projectName,
				sectionLabel: sectionLabel,
				title: title,
				typeLabel: typeLabel,
			),
			content: content,
			status: status == null ? null : KlpStatusBar(data: status),
		);
	}

	final Widget? header;
	final Widget content;
	final Widget? status;

	@override
	Widget build(BuildContext context) {
		return _KlpStageSurface(
			child: KlpColumn(
				crossAxisAlignment: CrossAxisAlignment.stretch,
				children: [
					KlpExpanded(
						child: KlpColumn(
							crossAxisAlignment: CrossAxisAlignment.stretch,
							children: [
								if (header != null) _KlpStageHeaderSlot(child: header!),
								KlpExpanded(child: content),
							],
						),
					),
					if (status != null)
						_KlpStageStatusSlot(
							child: KlpPanelFooter(child: status!),
						),
				],
			),
		);
	}
}
