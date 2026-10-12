import 'package:kallopis/src/features/forms/internal/klp_form_dependencies.dart';
import 'package:kallopis/src/foundation/interaction/klp_action_region.dart';

/// 表單中的一個可摺疊分組，帶標題、選填說明與一組欄位。
///
/// [collapsed] 與 [onToggle] 由呼叫端持有狀態——這個元件本身不記憶展開與否，
/// 純粹依 [collapsed] 決定要不要畫出 [children]。互動標題沿用本庫的
/// 焦點及鍵盤原語；[onToggle] 為 null 時保持靜態標題。
class KlpFormSection extends StatelessWidget {
	const KlpFormSection({
		super.key,
		required this.title,
		required this.children,
		this.description,
		this.collapsed = false,
		this.onToggle,
	});

	// 區段內容及說明由 consumer 擁有，字體沿用語意風格。
	final String title;
	final String? description;
	// 子內容與收合狀態保持受控，不自行改變產品資料。
	final List<Widget> children;
	final bool collapsed;
	// 有回呼才建立可操作標題，避免產生無效焦點入口。
	final VoidCallback? onToggle;

	@override
	Widget build(BuildContext context) {
		return KlpSurface(
			tone: KlpSurfaceTone.component,
			child: KlpBox(
				paddingSize: KlpSpaceSize.comfortable,
				child: KlpColumn(
					crossAxisAlignment: CrossAxisAlignment.stretch,
					children: [
						if (onToggle == null)
							KlpText(title, role: KlpTextRole.section)
						else
							KlpActionRegion(
								label: title,
								onPressed: onToggle,
								expanded: !collapsed,
								// 標題名稱由互動原語提供，避免裝飾文字重複報讀。
								builder: (context, style) => ExcludeSemantics(child: KlpText(title, role: KlpTextRole.section)),
							),
						if (description != null) ...[
							const KlpGap.heightSize(KlpSpaceSize.tight),
							KlpText(description!, role: KlpTextRole.caption, tone: KlpTextTone.muted),
						],
						if (!collapsed)
							for (final child in children) ...[
								const KlpGap.heightSize(KlpSpaceSize.base),
								child,
							],
					],
				),
			),
		);
	}
}
