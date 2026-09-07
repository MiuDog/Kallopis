import 'package:flutter/material.dart';
import 'package:kallopis/kallopis.dart';

import '../catalog_model.dart';

final artifactWorkspacePage = CatalogPageData(
	label: 'Artifact workspace',
	title: 'Canonical artifacts',
	description: 'Documents, tokens, and component definitions.',
	icon: KlpIcons.box,
	specimens: [
		Specimen(name: 'KlpDocumentHeader', note: 'Document metadata and actions.', build: (context) => KlpDocumentHeader(title: 'Project brief', revisionLabel: 'r12', statusLabel: 'Current', actions: [KlpButton(label: 'Edit', onPressed: () {})])),
		Specimen(name: 'KlpDocumentSection', note: 'One semantic document section.', build: (context) => const KlpDocumentSection(title: 'Audience', description: 'Primary users and needs.', child: KlpText('Operations teams'))),
		Specimen(name: 'KlpDocumentField', note: 'Label, help, validation, and value.', build: (context) => const KlpDocumentField(label: 'Name', help: 'Canonical display name.', value: KlpText('Checkout'))),
		Specimen(name: 'KlpDocumentReferenceLink', note: 'Canonical artifact reference.', build: (context) => KlpDocumentReferenceLink(label: 'Home screen', detail: 'screens/Home', onPressed: () {})),
		Specimen(name: 'KlpDocumentEditActions', note: 'Finite edit, save, and cancel actions.', build: (context) => KlpDocumentEditActions(editing: true, editLabel: 'Edit', saveLabel: 'Save', cancelLabel: 'Cancel', onSave: () {}, onCancel: () {})),
		Specimen(name: 'KlpTokenTable', note: 'Token definitions and references.', build: (context) => KlpTokenTable(nameLabel: 'Name', typeLabel: 'Type', valueLabel: 'Value', referenceLabel: 'Reference', statusLabel: 'Status', tokens: const [KlpTokenDefinitionData(name: 'color.action', typeLabel: 'Color', valueLabel: 'brand.primary', referenceLabel: 'color.blue.600', statusLabel: 'Valid')])),
		Specimen(name: 'KlpTokenValidationBanner', note: 'Token graph validation result.', build: (context) => const KlpTokenValidationBanner(title: 'Token graph', message: 'All references resolve.', valid: true)),
		Specimen(name: 'KlpComponentDefinitionCard', note: 'One component definition preview.', build: (context) => const KlpComponentDefinitionCard(data: KlpComponentDefinitionData(id: 'button', name: 'Button', statusLabel: 'Ready', preview: Center(child: KlpText('Button'))))),
		Specimen(name: 'KlpComponentLibraryGrid', note: 'Responsive component definition collection.', build: (context) => const KlpComponentLibraryGrid(components: [KlpComponentDefinitionData(id: 'button', name: 'Button', statusLabel: 'Ready', preview: Center(child: KlpText('Button')))])),
		Specimen(name: 'KlpComponentStateSelector', note: 'Finite component state selection.', build: (context) => KlpComponentStateSelector(labels: const ['Default', 'Focus', 'Disabled'], selectedIndex: 0, onSelected: (_) {})),
		Specimen(name: 'KlpAccessibilityContractPanel', note: 'Role, keyboard, and focus contract.', build: (context) => const KlpAccessibilityContractPanel(title: 'Accessibility', items: {'Role': 'button', 'Keyboard': 'Enter / Space'})),
	],
);

final canvasWorkspacePage = CatalogPageData(
	label: 'Canvas workspace',
	title: 'Screen and Flow canvas chrome',
	description: 'Product-neutral canvas surfaces, diagnostics, validation, and navigation.',
	icon: KlpIcons.diagramProject,
	specimens: [
		Specimen(name: 'KlpCanvasViewport', note: 'Viewport inherits Stage surface.', build: (context) => SizedBox(height: context.klp.space.pageLarge * 2, child: const KlpCanvasViewport(child: Center(child: KlpText('Canvas'))))),
		Specimen(name: 'KlpCanvasToolbar', note: 'Finite canvas capabilities.', build: (context) => KlpCanvasToolbar(actions: [KlpButton(label: 'Insert', onPressed: () {}), KlpButton(label: 'Align', onPressed: () {})])),
		Specimen(name: 'KlpCanvasSelectionOverlay', note: 'Selection bounds and resize handles.', build: (context) => KlpCanvasSelectionOverlay(showHandles: true, child: Padding(padding: EdgeInsets.all(context.klp.space.base), child: const KlpText('Selected node')))),
		Specimen(name: 'KlpCanvasDropIntent', note: 'Typed drop intent announcement.', build: (context) => const KlpCanvasDropIntent(label: 'Insert after', child: KlpText('Drop target'))),
		Specimen(name: 'KlpLayoutLens', note: 'Layout relationship diagnostics.', build: (context) => const KlpLayoutLens(label: 'Layout lens', diagnostics: [KlpLayoutDiagnosticData(label: 'Width', value: 'Fill'), KlpLayoutDiagnosticData(label: 'Gap', value: '16')])) ,
		Specimen(name: 'KlpFlowNodeCard', note: 'Flow node projection.', build: (context) => const KlpFlowNodeCard(title: 'Confirm order', typeLabel: 'Decision', child: KlpText('Success / Failure'))),
		Specimen(name: 'KlpFlowValidationPanel', note: 'Flow risks, validation, and recovery.', build: (context) => const KlpFlowValidationPanel(title: 'Flow validation', issues: [('Failure path needs recovery', KlpFeedbackTone.warning)])),
		Specimen(name: 'KlpCanvasMinimap', note: 'Large-canvas overview.', build: (context) => const KlpCanvasMinimap(label: 'Flow minimap', child: KlpText('Overview'))),
	],
);
