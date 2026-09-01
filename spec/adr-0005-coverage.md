# ADR-0005 Kallopis coverage

This document records the product-neutral Kallopis surfaces used to implement the Designist
component inventory. Product components keep the names and feature ownership from ADR-0005;
Kallopis only supplies visual composition, accessibility, and finite-state vocabulary.

## Application shell and navigation

- `DesignistWorkbenchScaffold` composes `KlpWorkbenchShell`, `KlpWorkbenchWindowHeader`,
  `KlpStageFrame`, and `KlpPanelFrame`.
- `ProductSwitcher` and `WorkspaceDestinationRail` use `KlpTabs`, `KlpRailItem`, and
  `KlpSidebarNavigationButton`.
- `ProjectBreadcrumbs`, `WorkspacePane`, and `ResizablePaneDivider` use `KlpBreadcrumb`,
  `KlpRegion`, `KlpResizablePane`, and `KlpResizeHandle`.
- `GlobalCommandPalette` uses `KlpCommandMenu`.
- `GlobalStatusRegion` uses `KlpStatusBar`, `KlpLiveRegion`, and `KlpWorkflowStateSurface`.

## Project explorer

- Canonical nodes use `KlpExplorer`, `KlpFileExplorer`, and `KlpTree`.
- Proposal-only nodes use `KlpPreviewTreeNode` and `KlpPreviewTree`, so their model and semantic
  name cannot be confused with canonical navigation.
- Atomic publication uses `KlpPublicationProgressOverlay` and `KlpWorkflowProgress` while leaving
  the preview tree mounted.
- Header controls, empty states, filtering, and contextual commands use `KlpFilterBar`,
  `KlpEmptyState`, and `KlpContextMenu`.

## AI conversation, discovery, and requirements

- Conversation history uses `KlpMessageThread`, `KlpMessageBubble`, `KlpInlineNotice`, and
  `KlpLoadingState`; system notices remain separate from message bubbles.
- Composer responsibilities are split across `KlpWorkflowComposer`, `KlpPromptTextField`,
  `KlpAttachmentTray`, and `KlpPromptExamples`.
- Discovery uses `KlpDiscoveryQuestionCard`; finite navigation remains typed callbacks supplied by
  the product controller.
- Requirement entries use `KlpRequirementData` and `KlpRequirementSummary`, including distinct
  assumption, conflict, answer, and confirmation states.

## Proposal review and execution

- `KlpProposalReview` composes metadata, summary, ordered changes, issues, optional diff and
  dependency surfaces, and three independent confirm/reject/revise callbacks.
- A stale message disables confirmation without converting the action to chat text.
- Applying, applied, and failed states use `KlpWorkflowProgress` and
  `KlpWorkflowStateSurface`; callers supply real stage names and retry actions.

## Context and page hosts

- `KlpPanelFrame`, `KlpPanelHeader`, `KlpSection`, `KlpFormErrorSummary`, `KlpEmptyState`,
  `KlpLoadingState`, and `KlpErrorState` cover selection, property, validation, unsupported,
  loading, failure, and missing-page surfaces.
- Container headings must describe the selected object or state; they must not repeat “Inspector”.

## Canonical documents

- `KlpDocumentHeader`, `KlpDocumentSection`, `KlpDocumentField`,
  `KlpDocumentReferenceLink`, and `KlpDocumentEditActions` cover structured document pages.
- Comments use `KlpMessageThread`; scoped AI revision uses a typed `KlpButton` supplied to the
  section action slot.

## Tokens and component library

- `KlpTokenTable`, `KlpTokenDefinitionData`, `KlpReferencePicker`, `KlpTokenValidationBanner`,
  and caller-supplied dependency views cover token collections and graph validation.
- `KlpComponentLibraryGrid`, `KlpComponentDefinitionCard`, `KlpComponentStateSelector`,
  `KlpTree`, `KlpDataTable`, and `KlpAccessibilityContractPanel` cover previews, anatomy,
  variants, states, accessibility, and instance overrides.

## Screen and Flow editors

- `KlpCanvasViewport` inherits the Stage surface as required by the Designist design guideline.
- `KlpCanvasToolbar`, `KlpCanvasSelectionOverlay`, `KlpCanvasDropIntent`, and `KlpLayoutLens`
  cover insert, selection, resize handles, drop intent, anchor diagnostics, multi-selection,
  states, breakpoints, and Layout Lens composition.
- `KlpFlowNodeCard`, `KlpFlowValidationPanel`, and `KlpCanvasMinimap` cover node rendering,
  validation, risk/recovery surfaces, and large-canvas navigation. Connections and gestures remain
  document commands owned by the product controller.

## Shared feedback and accessibility

- Existing `KlpButton`, `KlpIconButton`, fields, selection controls, tabs, trees, badges,
  tooltips, dialogs, menus, empty states, progress, error summaries, and skeletons cover the shared
  primitive inventory without Designist aliases.
- `KlpLiveRegion` controls announcements and `KlpFocusBoundary` restores focus after dialogs,
  publication, and navigation.
- `KlpWorkflowState` and its dedicated surfaces cover every pending, empty, stale, failed, and
  completed state in the ADR state-to-surface matrix.
