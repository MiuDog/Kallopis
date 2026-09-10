// GENERATED CODE - DO NOT MODIFY BY HAND.
// Source: spec/semantics/kallopis.semantic-manifest.json

import '../../catalog_model.dart';
import '../button_system_page.dart';
import '../docking_layout_page.dart';
import '../form_pages.dart';
import '../foundation_pages.dart';
import '../guideline_pages.dart';
import '../settings_pages.dart';
import '../token_pages.dart';
import '../workspace_agenda_page.dart';
import '../workspace_assets_page.dart';
import '../workspace_conversation_page.dart';
import '../workspace_pattern_pages.dart';
import '../workspace_shell_page.dart';

const String catalogSemanticManifestId = 'kallopis.default';
const int catalogSemanticSchemaVersion = 1;

/// Catalog groups follow the semantic layer order in the manifest.
final List<CatalogGroup> catalogGroups = [
  CatalogGroup(
    id: 'primitive',
    label: 'Primitives',
    description:
        'Internal raw scales and source values. Consumers do not use these directly.',
    pages: [neutralsPage, scalePage, radiiPage],
  ),
  CatalogGroup(
    id: 'foundation',
    label: 'Foundation semantics',
    description:
        'Shared roles that describe identity, surfaces, type, status, motion and elevation.',
    pages: [
      brandPage,
      colorModesPage,
      surfacesPage,
      semanticStatusPage,
      displayHeadingsPage,
      bodyCopyPage,
      monospacePage,
      elevationPage,
      compatibilityBuildingBlocksPage,
    ],
  ),
  CatalogGroup(
    id: 'component',
    label: 'Component recipes',
    description:
        'Resolved controls and content components built from foundation semantics.',
    pages: [
      actionsNavigationPage,
      buttonSystemPage,
      fileExplorerPage,
      dataDisplayPage,
      layoutInteractionPage,
      regionPlaceholderPage,
      viewStatesPage,
      formControlsPage,
      formAssemblyPage,
    ],
  ),
  CatalogGroup(
    id: 'pattern',
    label: 'Patterns',
    description:
        'Reusable compositions and workspace-level interaction arrangements.',
    pages: [
      blockLayoutPage,
      prosePage,
      strokeLanguagePage,
      settingsPage,
      workspaceShellPage,
      dockingLayoutPage,
      workspaceAgendaPage,
      workspaceConversationPage,
      workspaceAssetsPage,
      artifactWorkspacePage,
      canvasWorkspacePage,
    ],
  ),
];

/// Flattened page order shared by navigation and coverage checks.
final List<CatalogPageData> catalogPages = [
  for (final group in catalogGroups) ...group.pages,
];

/// Public widget names represented by the Catalog.
final Set<String> catalogedComponents = {
  for (final page in catalogPages)
    for (final specimen in page.specimens) specimen.name,
  for (final page in catalogPages) ...page.coveredComponents,
};
