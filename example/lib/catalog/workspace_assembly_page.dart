import 'package:flutter/material.dart';
import 'package:kallopis/kallopis.dart';

import '../catalog_model.dart';

final workspaceAssemblyPage = CatalogPageData(
	label: 'Workspace assembly',
	title: 'Reference workspace assemblies',
	description: 'Interactive compositions for AI, artifacts, libraries, and finite canvases.',
	icon: KlpIcons.grid,
	specimens: const [],
	tokenView: (context) => const _WorkspaceAssemblyPreview(),
);

class _WorkspaceAssemblyPreview extends StatefulWidget {
	const _WorkspaceAssemblyPreview();

	@override
	State<_WorkspaceAssemblyPreview> createState() => _WorkspaceAssemblyPreviewState();
}

class _WorkspaceAssemblyPreviewState extends State<_WorkspaceAssemblyPreview> {
	static const _tabs = ['AI setup', 'Docs', 'Tokens', 'Components', 'Screen'];

	// Catalog 只保存展示用草稿，不建立產品端的權威工作流狀態。
	final TextEditingController _promptController = TextEditingController(text: 'Create a Flutter commerce design system.');
	int _selected = 0;

	@override
	void dispose() {
		_promptController.dispose();
		super.dispose();
	}

	@override
	Widget build(BuildContext context) {
		return Column(
			crossAxisAlignment: CrossAxisAlignment.stretch,
			children: [
				KlpTabs(tabs: _tabs, selected: _selected, onSelected: _select),
				SizedBox(height: context.klp.space.section),
				_selectedContent(context),
			],
		);
	}

	Widget _selectedContent(BuildContext context) {
		return switch (_selected) {
			0 => _aiSetup(context),
			1 => _docs(context),
			2 => _tokens(context),
			3 => _components(context),
			_ => _screen(context),
		};
	}

	void _select(int value) => setState(() => _selected = value);

	Widget _aiSetup(BuildContext context) {
		return Column(
			crossAxisAlignment: CrossAxisAlignment.stretch,
			children: [
				KlpWorkflowComposer(
					controller: _promptController,
					placeholder: 'Describe the product, audience, and expected outputs',
					sendLabel: 'Send',
					attachLabel: 'Attach reference',
					removeAttachmentLabel: 'Remove attachment',
					onChanged: (_) {},
					onSend: () {},
					examples: const ['Mobile design system', 'Responsive dashboard'],
					onExampleSelected: _selectPrompt,
				),
				SizedBox(height: context.klp.space.section),
				KlpRequirementSummary(
					title: 'Requirements',
					confidenceLabel: '92% confidence',
					requirements: const [
						KlpRequirementData(
							id: 'audience',
							label: 'Audience',
							value: 'Product design and development teams',
							sourceLabel: 'User',
							statusLabel: 'Confirmed',
							source: KlpRequirementSource.user,
							status: KlpRequirementStatus.confirmed,
						),
						KlpRequirementData(
							id: 'brand',
							label: 'Brand direction',
							value: 'Clear, restrained, and professional',
							sourceLabel: 'Assumption',
							statusLabel: 'Review',
							source: KlpRequirementSource.assumption,
							status: KlpRequirementStatus.assumed,
						),
					],
				),
				SizedBox(height: context.klp.space.section),
				KlpProposalReview(
					title: 'Commerce design system',
					summary: 'Create foundations, reusable components, and the first complete screen.',
					versionLabel: 'Revision 3',
					statusLabel: 'Ready',
					affectedLabel: '4 proposed artifacts',
					changes: const [
						KlpProposalChangeData(
							path: 'Docs / Project positioning',
							kindLabel: 'Create',
							reason: 'Define the product and audience.',
							kind: KlpProposalChangeKind.create,
						),
						KlpProposalChangeData(
							path: 'Tokens / Foundation',
							kindLabel: 'Create',
							reason: 'Provide shared visual values.',
							kind: KlpProposalChangeKind.create,
						),
					],
					confirmLabel: 'Create project',
					rejectLabel: 'Reject',
					reviseLabel: 'Request revision',
					onConfirm: () {},
					onReject: () {},
					onRevise: () {},
				),
			],
		);
	}

	void _selectPrompt(String value) {
		_promptController.value = TextEditingValue(
			text: value,
			selection: TextSelection.collapsed(offset: value.length),
		);
	}

	Widget _docs(BuildContext context) {
		return Column(
			crossAxisAlignment: CrossAxisAlignment.stretch,
			children: [
				KlpDocumentHeader(
					title: 'Project positioning',
					revisionLabel: 'Revision 12',
					statusLabel: 'Read only',
					actions: [
						KlpDocumentEditActions(
							editing: false,
							editLabel: 'Edit properties',
							saveLabel: 'Save',
							cancelLabel: 'Cancel',
							onEdit: () {},
						),
					],
				),
				SizedBox(height: context.klp.space.section),
				const KlpDocumentSection(
					title: 'Product direction',
					description: 'Canonical fields remain the single source of truth.',
					child: Column(
						crossAxisAlignment: CrossAxisAlignment.stretch,
						children: [
							KlpDocumentField(label: 'Audience', value: KlpText('Commerce product teams')),
							KlpDocumentField(label: 'Primary outcome', value: KlpText('A consistent checkout experience')),
						],
					),
				),
			],
		);
	}

	Widget _tokens(BuildContext context) {
		return Column(
			crossAxisAlignment: CrossAxisAlignment.stretch,
			children: [
				const KlpTokenValidationBanner(title: 'Token graph', message: 'All references resolve.', valid: true),
				SizedBox(height: context.klp.space.section),
				const KlpTokenTable(
					nameLabel: 'Name',
					typeLabel: 'Type',
					valueLabel: 'Value',
					referenceLabel: 'Reference',
					statusLabel: 'Status',
					tokens: [
						KlpTokenDefinitionData(name: 'color.action', typeLabel: 'Color', valueLabel: 'Brand action', referenceLabel: 'color.brand.primary', statusLabel: 'Canonical'),
						KlpTokenDefinitionData(name: 'spacing.control', typeLabel: 'Dimension', valueLabel: 'Control spacing', referenceLabel: 'spacing.base', statusLabel: 'Canonical'),
						KlpTokenDefinitionData(name: 'radius.control', typeLabel: 'Dimension', valueLabel: 'Control radius', referenceLabel: 'radius.medium', statusLabel: 'Canonical'),
					],
				),
			],
		);
	}

	Widget _components(BuildContext context) {
		return KlpComponentLibraryGrid(
			components: [
				KlpComponentDefinitionData(
					id: 'button.primary',
					name: 'Primary button',
					statusLabel: 'Ready',
					description: 'Default action component',
					preview: Center(child: KlpButton(label: 'Continue', onPressed: () {})),
				),
				KlpComponentDefinitionData(
					id: 'field.text',
					name: 'Text field',
					statusLabel: 'Ready',
					description: 'Single-line text input',
					preview: const Center(child: KlpText('Label\nValue')),
				),
			],
			onSelected: (_) {},
		);
	}

	Widget _screen(BuildContext context) {
		final space = context.klp.space;
		return SizedBox(
			height: space.pageLarge * 8,
			child: KlpCanvasViewport(
				panEnabled: false,
				scaleEnabled: false,
				child: Stack(
					children: [
						Center(
							child: KlpCanvasSelectionOverlay(
								showHandles: true,
								child: KlpSurface(
									tone: KlpSurfaceTone.raised,
									padding: EdgeInsets.all(space.pageLarge),
									child: const KlpText('Complete screen frame', role: KlpTextRole.section),
								),
							),
						),
						PositionedDirectional(
							start: space.base,
							top: space.base,
							child: KlpCanvasToolbar(
								actions: [
									KlpButton(label: 'Insert', onPressed: () {}),
									KlpButton(label: 'Align', onPressed: () {}),
								],
							),
						),
						PositionedDirectional(
							end: space.base,
							bottom: space.base,
							child: SizedBox(
								width: context.klp.geometry.layout.secondaryPaneWidth,
								child: const KlpLayoutLens(
									label: 'Layout lens',
									diagnostics: [
										KlpLayoutDiagnosticData(label: 'Width', value: '390'),
										KlpLayoutDiagnosticData(label: 'Height', value: '844'),
										KlpLayoutDiagnosticData(label: 'Layout', value: 'Free'),
									],
								),
							),
						),
					],
				),
			),
		);
	}
}
