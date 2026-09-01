import 'package:flutter/material.dart';
import 'package:kallopis/kallopis.dart';

import '../catalog_model.dart';

final workflowReviewPage = CatalogPageData(
	label: 'Workflow review',
	title: 'Finite workflow review',
	description: 'Finite states, review, and publication.',
	icon: KlpIcons.sparkles,
	specimens: [
		Specimen(name: 'KlpWorkflowStateSurface', note: 'Dedicated finite-state surface.', build: (context) => const KlpWorkflowStateSurface(state: KlpWorkflowState.ready, title: 'Proposal', message: 'Ready for review.', statusLabel: 'Ready')),
		Specimen(name: 'KlpWorkflowProgress', note: 'Named stages without fake time estimates.', build: (context) => const KlpWorkflowProgress(label: 'Publication', stages: [KlpWorkflowStageData(label: 'Validate', statusLabel: 'Done', complete: true), KlpWorkflowStageData(label: 'Publish', statusLabel: 'Active', complete: false, active: true)])),
		Specimen(name: 'KlpLiveRegion', note: 'Controlled accessibility announcement.', build: (context) => const KlpLiveRegion(message: 'Saved', child: KlpText('Saved'))),
		Specimen(name: 'KlpFocusBoundary', note: 'Restorable focus scope.', build: (context) => const KlpFocusBoundary(child: KlpText('Focus boundary'))),
		Specimen(name: 'KlpAttachmentTray', note: 'Scoped attachments.', build: (context) => const KlpAttachmentTray(attachments: [KlpAttachmentData(id: 'brief', label: 'Brief', detail: 'Document')], removeLabel: 'Remove')),
		Specimen(name: 'KlpPromptExamples', note: 'Fills draft without submitting.', build: (context) => KlpPromptExamples(examples: const ['Describe a checkout flow'], onSelected: (_) {})),
		Specimen(name: 'KlpPromptTextField', note: 'Enter submits and Shift+Enter creates a line.', build: (context) => KlpPromptTextField(controller: TextEditingController(), placeholder: 'Describe the product', onChanged: (_) {})),
		Specimen(name: 'KlpWorkflowComposer', note: 'Draft, attachments, examples, and actions.', build: (context) => KlpWorkflowComposer(controller: TextEditingController(), placeholder: 'Describe the product', sendLabel: 'Send', attachLabel: 'Attach', removeAttachmentLabel: 'Remove', onChanged: (_) {}, onSend: () {}, attachments: const [KlpAttachmentData(id: 'brief', label: 'Brief')], examples: const ['Create a dashboard'], onExampleSelected: (_) {})),
		Specimen(name: 'KlpDiscoveryQuestionCard', note: 'One finite discovery question.', build: (context) => KlpDiscoveryQuestionCard(question: 'Who is this for?', answer: '', onChanged: (_) {}, relatedPrompts: const ['Primary audience'], actions: [KlpButton(label: 'Next', onPressed: () {})])),
		Specimen(name: 'KlpRequirementSummary', note: 'Requirement ledger projection.', build: (context) => const KlpRequirementSummary(title: 'Requirements', confidenceLabel: 'High', requirements: [KlpRequirementData(id: 'audience', label: 'Audience', value: 'Operations team', sourceLabel: 'User', statusLabel: 'Confirmed', source: KlpRequirementSource.user, status: KlpRequirementStatus.confirmed)])),
		Specimen(name: 'KlpProposalReview', note: 'Separate typed confirm, reject, and revise actions.', build: (context) => KlpProposalReview(title: 'Proposal', summary: 'Create a project dashboard.', versionLabel: 'v1', statusLabel: 'Ready', affectedLabel: '1 artifact', changes: const [KlpProposalChangeData(path: 'screens/Home', kindLabel: 'Create', reason: 'Primary workspace', kind: KlpProposalChangeKind.create)], confirmLabel: 'Confirm', rejectLabel: 'Reject', reviseLabel: 'Revise', onConfirm: () {}, onReject: () {}, onRevise: () {})),
		Specimen(name: 'KlpPreviewTree', note: 'Proposal-only tree with distinct semantics.', build: (context) => const KlpPreviewTree(label: 'Proposed project', nodes: [KlpPreviewTreeNode(id: 'home', label: 'Home', accessibilityLabel: 'Proposed page Home', statusLabel: 'New')])) ,
		Specimen(name: 'KlpPublicationProgressOverlay', note: 'Stable preview during atomic publication.', build: (context) => KlpPublicationProgressOverlay(visible: true, progress: const KlpWorkflowProgress(stages: [KlpWorkflowStageData(label: 'Publish', statusLabel: 'Active', complete: false, active: true)]), child: SizedBox(height: context.klp.space.pageLarge * 3, child: const KlpText('Proposed project')))),
	],
);

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
