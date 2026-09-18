# Kallopis module architecture v1

Owning authority: repository architecture stewardship

Product stage: Iteration

Target release: module architecture and composable public-surface migration v1

Readiness: READY — automatic acceptance enabled by the user on 2026-09-14

Capability horizon:

- v1: every accepted source module has one current `architecture.md`; declarative consumers assemble only library-owned components through finite contracts; required tests contain deterministic code evidence only.
- P9 migration completion: remove superseded compatibility surfaces after downstream consumers have migrated and compatibility evidence permits removal.

## Goal and motivation

Make Kallopis understandable and bounded at module level. Every source module must publish its responsibility, dependency direction, invariants, public contracts and protected paths. Public UI capability must be composition-first: consumers select and assemble library-owned definitions through constrained slots and schemas instead of injecting arbitrary Flutter implementation. A semantic component must have one authoritative public source for the active declarative path. Repository tests prove contracts and behavior that code can determine; visual quality remains human acceptance evidence.

## Historical baseline before the v1 migration

This section records the pre-migration state only; it is not current truth. Current module contracts and the implementation progress below supersede these observations.

- `lib/src/` currently has nine first-level responsibility roots: `application`, `capabilities`, `composition`, `features`, `foundation`, `kernel`, `rendering`, `runtime`, and `styling`.
- The repository currently contains no `architecture.md` files.
- `lib/kallopis_declarative.dart` already exposes the emerging structure tree, constrained slots, registry, validation, primitives and selected workspace/editing features, but it still exports many source files directly.
- Legacy `kallopis_foundation.dart` remains a broad component source while `kallopis_experimental.dart` and the declarative entry expose overlapping responsibility families. KLP-0019 keeps legacy compatibility until its P9 removal gate.
- The current source import graph has six first-level cycles: `application` ↔ `features`, `application` ↔ `rendering`, `composition` ↔ `foundation`, `composition` ↔ `runtime`, `features` ↔ `foundation`, and `foundation` ↔ `styling`. Module contracts must label these as migration debt rather than describe the current graph as already layered.
- Required tests still include seven files using `matchesGoldenFile`, backed by 74 PNG golden assets across `test/` and `example/test/`.

## Implementation progress

Observed after the 2026-09-14 v1 implementation slice:

- The registry names exactly nine first-level source modules and every module owns a `PLAN READY` `architecture.md`; the deterministic module contract check passes three cases.
- `kallopis_declarative.dart` no longer exports consumer definition, registry or validated-compilation types, and `KlpApplication` accepts no component list.
- Application adapter assembly accepts no consumer input. CC-V1-r1 is complete: the internal runtime legacy component parameter/compiler seam is retired; the feature and application manifests match all 28 built-in identities. Package-internal composition constructors remain available to adapters and isolated tests.
- Catalog, workspace and runtime examples compose built-in nodes only. All three declarative consumer-boundary checks and scoped analyzer checks pass.
- The protected closed-catalog contract covers positive built-in composition and rejects definition/registry/validated-tree plus action-handler, template, semantic-authoring and incomplete rail public API paths.
- The built-in workspace action block now accepts a qualified semantic `KlpAction`, validates the installed handler and dispatches through placement/frame-lease ownership; focused application migration evidence passes 70 tests.
- Restoration observers are deduplicated by successfully delivered observer/canonical URI pairs, preventing adaptive host recompilation from publishing the same committed stack twice.
- Required tests contain no golden/screenshot matcher, and the 74 tracked PNG baselines are removed. Ignored `failures/` diagnostics from historical golden runs are not test inputs or acceptance baselines.

This progress closes the v1 consumer and test-policy surface. It does not claim the six recorded internal import cycles or the remaining package-internal compatibility seams are already removed.

## Requirement table

| ID | Target version | Priority | Requirement or decision | Observable acceptance | Status |
| --- | --- | --- | --- | --- | --- |
| ARCH-P1-01 | v1 | P1 | Define “module” as each of the nine first-level `lib/src/` responsibility roots. Nested folders remain internal responsibility areas unless PLAN proves an independent public contract, invariant owner and change reason. | A repository module registry names exactly the nine roots; every root has one `architecture.md`; no nested document is created without the promotion criteria. | accepted |
| ARCH-P1-02 | v1 | P1 | Every accepted module contract records purpose, non-goals, owned paths, public interfaces, responsibility map, dependency direction, invariants, lifecycle/error ownership, allowed and forbidden dependencies, current slices, evidence and protected paths. | A deterministic contract check finds every required section in all registered module contracts and rejects an unregistered or undocumented module root. | accepted |
| ARCH-P1-03 | v1 | P1 | Cross-module dependency direction is explicit and acyclic at the responsibility level. Renderer and runtime implementations do not become public authorities for semantic components or product data. | Module contracts agree on every cross-module interface; the existing architecture boundary check covers the resulting public dependency rules without allowlist expansion. | accepted |
| API-P1-01 | v1 | P1 | `kallopis_declarative.dart` is the sole component source for new declarative consumers. Stable legacy libraries remain compatibility-only until the existing P9 removal gate; they cannot be used to extend the declarative tree. | New consumer examples import only `kallopis_declarative.dart`; no declarative public contract accepts legacy Widget/component injection; legacy entries are marked compatibility-only. | accepted |
| API-P1-02 | v1 | P1 | Exposed components are primarily composable declarations organized by level: kernel; styling/capabilities; composition; foundation presentation contracts; internal runtime; features; internal rendering; application host. | Each public declarative symbol has one owning module and one level; dependencies point toward lower-level contracts or through an explicit inversion contract. | accepted |
| API-P1-03 | v1 | P1 | Extension is finite and library-owned. Consumers may compose registered definitions, fixed primitive schemas and qualified slot children, but may not inject arbitrary Widget, `BuildContext`, renderer callback, HTML/JS, painter, local style or mutable global registration. | Positive and negative public-contract checks accept supported composition and reject every forbidden injection path. | accepted |
| API-P1-04 | v1 | P1 | A semantic component has one authoritative public declaration in the active declarative surface. Aliases, duplicate component families and direct internal exports are either consolidated or recorded as compatibility shims with one removal owner. | Public-surface inventory maps each component identity to exactly one active declaration; any compatibility shim names its canonical source and removal gate. | accepted |
| TEST-P1-01 | v1 | P1 | Repository tests under both `test/` and `example/test/` no longer own visual correctness. Golden/screenshot comparison is removed from required automated tests and visual review becomes an explicit human-pending artifact when a task needs it. | Required test discovery contains no `matchesGoldenFile` or visual baseline gate; retired PNG baselines are removed or moved outside required test inputs; workflow documentation names human acceptance for sensory results. | accepted |
| TEST-P1-02 | v1 | P1 | Automated tests follow the installed skills: add or run tests only for an explicit request, actual regression, data-loss/transaction/undo/save risk, cross-language contract, or behavior humans cannot reliably determine. | Module contracts label Red/Yellow/Green state and acceptance evidence; no contract requires routine full-suite or visual verification. | accepted |
| TEST-P1-03 | v1 | P1 | Deterministic geometry, semantics, accessibility, state, lifecycle, error and public-boundary behavior remain testable even when their names contain “visual” or image-related domain data. | Test review classifies behavior by assertion purpose; only sensory pixel appearance is retired. | accepted |
| MIG-P1-01 | v1 | P1 | Existing data authority, BlockNote/Krepis boundary, theme/environment/l10n single sources and Stable/Experimental compatibility promises remain intact during the architecture migration. | All nine module contracts cite the applicable KLP-0019/KLP-0020 and frontend-boundary interfaces; affected boundary checks pass without a new exception. | accepted |
| DOC-P2-01 | later iteration | P2 | Promote a nested responsibility area to a module only after repeated independent planning proves its own public contract, invariants and change cadence. | Promotion updates the registry and both sides of every affected public contract before BUILD. | deferred |
| MIG-P3-01 | post-P9 | P3 | Remove legacy component barrels and compatibility aliases after downstream migration is complete. | No supported consumer imports the retired entry and release notes authorize the breaking removal. | deferred |

## Responsibility levels and public interfaces

| Level | Owning module | Public responsibility | Must not own |
| --- | --- | --- | --- |
| L0 | `kernel` | Stable identity and contract diagnostics used by all higher levels. | Flutter rendering, styles, product data or component composition. |
| L1 | `styling` | Consumer: fixed primitive schema and library-owned preset. Library modules: semantic keys/references and resolution contracts. | Consumer semantic authoring, local defaults or widget rendering. |
| L1 | `capabilities` | Framework-neutral state, action, data, navigation and editing contracts. | Concrete UI, persistence authority or renderer lifecycle. |
| L2 | `composition` | Consumer: library-owned node qualifications and constrained slots. Library modules: unique tree, closed definitions/registry and structural validation. | Native Widget injection or feature-specific rendering. |
| L3 | `foundation` | Consumer: finite platform/adaptive/axis composition values. Library modules: rendering-neutral templates and prepared presentation contracts. | Consumer template authoring, product workflow or a second style/environment authority. |
| L4 | `runtime` | Package-internal compilation, adapter and installation contracts over validated declarations; no consumer exports. | Concrete feature families, public component identity or semantic style ownership. |
| L5 | `features` | Consumer: library-owned composable nodes and immutable data/events. Library modules: adapters and prepared feature inputs. | Product models, repository logic or arbitrary extension callbacks. |
| L6 | `rendering` | Private Flutter/WebView realization of prepared contracts. | Consumer-facing composition APIs or a second data/theme/environment/l10n source. |
| L7 | `application` | Consumer: final application/screen/router assembly. Library modules: host lifecycle over runtime, features and rendering. | Product navigation/data authority or reusable lower-level contracts. |

Cross-module requests use only the public contracts above. Internal types and patterns remain PLAN decisions for the owning module.

## Scope

In scope:

- Establish the repository module registry and all accepted module contracts.
- Audit and update declarative exports, component ownership, slot qualification and extension points needed to make the active public source unique and finite.
- Classify and retire required visual/golden testing while preserving deterministic behavior checks.
- Update directly affected architecture indexes, consumer documentation and examples.

Out of scope:

- A new visual design, aesthetic polish or agent judgment of visual quality.
- Product-specific Planist/Notist workflows or changes to Krepis/Designist repositories.
- Removing legacy Stable APIs before the accepted P9 compatibility gate.
- Creating speculative nested modules, future component families or a second composition system.

## Constraints and acceptance evidence

- KLP-0019 owns the unique declarative tree, constrained slots, fixed primitive schema and compatibility migration.
- KLP-0020 owns the BlockNote/Krepis/Kallopis authority split.
- `docs/architecture/frontend-boundaries.md` owns cross-repository authority and public-library stability.
- Architecture documents are protected PLAN artifacts. BUILD workers may read but not modify them unless a later Task Packet explicitly assigns Architecture Steward work.
- Deterministic completion evidence must cover the repository-wide scope: module registry completeness, contract structure, public export ownership, forbidden extension paths and required-test visual references. Narrow component tests cannot prove this program complete.

## Closed catalog completion contract — CC-V1-r1

Execution status (2026-09-14): COMP-V1-02, FND-V1-02, RUN-V1-03, FEAT-V1-02 and APP-V1-03 are complete. See the [integration evidence](../docs/architecture/closed-catalog-plan/verification.md). The following requirements remain the accepted contract; later slices do not reopen consumer registration.

Accepted PLAN refinement, 2026-09-14. This completes the existing API-P1-03/04 and ARCH-P1-03 requirements; it adds no public API. Execution packets and coordination are in [the paired plan](../docs/architecture/closed-catalog-plan/README.md).

- `composition` owns `KlpDefinition`, `KlpRegistry`, structural capture and validation. Their package-internal constructors remain necessary for library adapters and isolated contract fixtures; they stay absent from consumer barrels. Closing the catalog does not mean making Dart `lib/src` physically unimportable or moving feature enumeration into composition. `COMP-V1-02` records and verifies this construction boundary; no new registry type or constructor migration is required.
- `application` remains the only production composition root. `klpApplicationAdapters()` takes no arguments and returns the deterministic library adapter list. Preserve existing ordering and all existing internal entries, including rail. Catalog coverage includes structural/internal entries as well as public feature nodes; it does not expose previously hidden nodes.
- `runtime` keeps the existing package-internal `adapters` input. `RUN-V1-03` removes the `components` parameter from `KlpTreeRuntime.update`, `KlpPrepareContext.components`, their compiler construction/validation path, and `KlpComponentAdapter`. The registry is built solely from the supplied library adapters' contracts. Internal test adapters remain permitted for transaction fault injection; they do not become consumer extension points.
- `foundation` retires `KlpComponentDefinition`, `KlpComponentCompiler` and the definition-only `klpTemplateSlots` helper after their production callers and test dependencies have migrated. No replacement compiler or definition alias is introduced. Existing templates, bound/prepared values and their renderer users remain outside this retirement; do not perform unrelated dead-code or P9 cleanup.
- Remove application session's empty `components: const []` in its own `APP-V1-03` packet. Runtime, foundation and application code changes form one integration batch with the test migration. Intermediate API mismatch is integration-pending, not valid behavioral Red evidence or a releasable state. `RUN-V1-02` is not a prerequisite.
- Features owns a reviewable JSON inventory at `lib/src/features/catalog/component-ownership.json`; application owns `lib/src/application/bootstrap/internal/klp_application_catalog.json`. These are architecture evidence read by tests, not runtime registries, assets, generators or a second declaration authority. Source declarations/adapters remain authoritative. Neither metadata file is publicly exported or loaded by runtime.
- Feature inventory shape: `schema_version: 1`, `exports`, `components`, `compatibility`. Each `exports` row has `symbol`, `source_path`, `kind` (`node`, `qualification`, `data`, `event`, `utility`, or `reexport`) and `definition_ids`. Enumerate symbols reachable through feature export files, including their parts/reexports; qualifications/data/utilities may have no identity. Restricted external engine exports are classified as `reexport`, without inventing Kallopis component identities.
- Every `components` row has `definition_id`, `declaration_symbol`, `declaration_path`, `owner_module`, `level`, `visibility` (`public` or `internal`), `semantic_owner`, `qualifications`, `slots`, and `adapter`. Each slot has `name`, `owner`, `child_type`, `min`, `max` (null for unbounded). `adapter` has `symbol`, `source_path`, `factory`, `variant`; `variant` is null for a single adapter or the identity selector for a family. Factory names and variants describe existing construction, not executable callbacks. Each identity has exactly one declaration/adapter configuration; one declaration or adapter class may legitimately serve several identities. Feature rows use L5 and owner `features`.
- Each `compatibility` row identifies `legacy_symbol`, `legacy_path`, `canonical_symbol`, `canonical_path`, `removal_owner`, `removal_gate`. Record the existing `KlpExplorer`/`KlpWindowControls` name collisions; legacy entries never enter active components. P9 conditions remain unchanged.
- Application inventory shape: `schema_version: 1`, `feature_manifest` (the repository-relative feature inventory path), `structural_components` (the same component row shape, with actual declaration owner/level), and `assembly` (ordered rows of `adapter_symbol`, `adapter_path`, `factory`, `definition_ids`). Structural rows cover scope boundary, retained screens, screen and adaptive; their adapter owner may differ from declaration owner during existing migration debt. Feature identity rows are referenced, never duplicated as structural rows. Expand every `createAll()` family when comparing assembly identities.
- Catalog evidence checks exact identity-set equality between actual application adapters and the feature/structural union, rejects duplicates before set conversion, checks declaration/export and slot facts against source/contracts, and detects missing/extra/incorrect owner records. Include an intentionally duplicated record to demonstrate rejection. Do not infer identity count from exported file count or adapter class count. No reflection or production feature import into runtime/composition is introduced.
- Independent Test Author owns all necessary test/fixture migration and an old-case-to-current-behavior matrix. Preserve single capture, qualified child ordering, immutable results, style/resource reuse, rollback, committed failure, lease revocation, action qualification and semantic ownership checks wherever they protect surviving behavior. Cases solely asserting the retired external compiler API may retire with explicit mapping/reason; do not preserve them by copying the compiler into tests, weakening assertions or adding skips. Public negative compilation cases must fail at the intended forbidden usage while positive controls resolve cleanly; missing imports do not establish valid Red.
- No production change to styling, capabilities, rendering, public barrels, examples, Stable libraries, Krepis or Designist is assigned in this batch. Existing import-cycle work and `RUN-V1-02` retain their original slices. Any newly discovered production caller outside the packets returns to the Architecture Steward before write paths expand.

## Open questions

None. Reversible architecture defaults follow automatic acceptance; public compatibility, data authority and irreversible external effects still require explicit user direction.

## Runtime contract path migration — RC-V1-r1

Execution complete: RUN-V1-02 and FEAT-V1-03 are complete; APP-V1-06 remains in progress after its runtime portion, and composition adaptive ownership remains unchanged. See the [verification record](../docs/architecture/runtime-contract-plan/verification.md).

Accepted 2026-09-14: complete RUN-V1-02 and FEAT-V1-03, plus the runtime portion of APP-V1-06 and a composition import-only companion. The exact 11 source/destination moves and caller set are fixed in [path-map.json](../docs/architecture/runtime-contract-plan/path-map.json).

Eight reusable runtime contracts/values/policies move physically to `runtime/contracts/`; `KlpTreeRuntime` and `KlpScopeBoundaryAdapter` become named package-only compilation entries, and `KlpDefaultPlacement` a named installation entry. `KlpInstallation` retains its internal transaction implementation. No new interfaces, old-path forwarding, consumer exports, identity changes or algorithm changes are authorized. Cross-directory directives use package-root URIs.

Features/application must stop importing runtime internal paths; the two existing composition adaptive implementations receive import-only updates without moving their ownership. Application catalog runtime source_path follows the real moved adapter. The known four relative workspace adapter imports are corrected in the features packet. APP-V1-06 remains partial for its other-module contracts; COMP-V1-03/RUN-V1-04 and styling/l10n remain separate.

Independent tests protect the cross-module/public boundary and migrate existing fixture imports with assertions intact. Verify actual catalog identity union, transaction/resource/lease behavior and application callers; preserve all public barrels and test settings. All changes use disjoint module packets on clean isolated bases. See [paired plan](../docs/architecture/runtime-contract-plan/README.md).

## Adaptive ownership completion — AD-V1-r1

Execution: COMP-V1-03/04, RUN-V1-04, CAP-V1-04 and FND-V1-06 complete. Composition now has no runtime/foundation imports; public names and enum identity are preserved.

Accepted: pair COMP-V1-03/04, RUN-V1-04, CAP-V1-04 and FND-V1-06 so composition has no runtime/foundation imports. Exact paths and acceptance are in [adaptive plan](../docs/architecture/adaptive-module-plan/README.md). Move the two adaptive runtime implementations physically; keep node/strategy/capture in composition. Move the three pure platform enums to capabilities/environment, retaining foundation `export ... show` compatibility with identical type/value identity. No host behavior, public API, defaults, catalog identity, enum values or algorithm changes. Application only follows the adapter source in its import and catalog. All module writes are separate packets; independent tests protect boundaries and old/new type identity. APP-V1-05/06 and other remaining slices stay open.

## Semantic graph contracts — SEM-V1-r1

Execution complete: STYLE-V1-03/COMP-V1-05/RUN-V1-05 passed paired verification; see [evidence](../docs/architecture/semantic-module-plan/verification.md).

Accepted: STYLE-V1-03/COMP-V1-05/RUN-V1-05 move the existing resolver and immutable resolution to named package-only paths; add validateKlpSemanticGraph(schemas) as a void validation entry delegating to the unchanged resolver constructor. Composition uses only that validation operation; runtime retains existing evaluation. Features and test imports follow the exact [path map](../docs/architecture/semantic-module-plan/path-map.json). No consumer exports, algorithms, defaults, schema identities or error behavior change. All module writes remain separate; independent tests protect source boundaries and graph errors.

## Prepared ownership — PRES-V1-r1

Execution complete: FND-V1-03/04, FEAT-V1-04, REND-V1-03 meet the full foundation boundary and paired behavior evidence; see [verification](../docs/architecture/presentation-module-plan/verification.md).

Accepted 2026-09-14; see [paired plan](../docs/architecture/presentation-module-plan/README.md). PRES-V1-r1：KlpBoundTemplate 原名／constructor 保留，路徑由 LOWER-V1-r1 具名契約接替，改為不對 consumer 匯出的 abstract class 協定。11 個通用 part 留 foundation；15 editing part 與 editing style、15 workspace part 各移至 features 自有 presentation library，不跨模組 part，不由 foundation reexport。兩個 feature library 都只作唯讀呈現資料，保留上游 controller／engine／callback 身分與生命週期，不新增權威。renderer 保留原 26 concrete 類型的分支與非視覺標記，未知套件內實作明確拋 KlpContractError('unsupported_prepared_template', ...)；不提供註冊或 fallback。另將 button style 與 toolbar 三檔實體移至 features/actions；KlpSelectionAction 留 foundation，filter bar 移除 toolbar export，僅 root kallopis_foundation.dart 直接 export 新 toolbar 以保留 Stable。所有舊移動路徑刪除而不設 shim；公開符號／constructor／範本／catalog 28 ID 順序與效果不變。FND-V1-03 全 foundation 無 features/runtime/rendering/application 或 Krepis/Canva/BlockNote import/export/part 的原要求不得縮小。

## Presentation localization — L10N-V1-r1

Execution complete: FND-V1-07, FEAT-V1-05, REND-V1-02, APP-V1-04 meet full downward dependencies and actual host localization installation. See [verification](../docs/architecture/localization-module-plan/verification.md).

Accepted 2026-09-14: L10N-V1-r1：三個既有 application/localization 檔案作為同一 library 實體搬至 foundation/localization；保留型別、constructor、全部預設字串、savedLabel 私有函式、delegate load/shouldReload/isSupported、fallback 與 equality。這仍是既有 Flutter 呈現契約，不另建純 Dart 模型或第二來源。12 個 features 指令（含1 export）及1個 rendering import 精確向下遷移，全部 features/rendering 不得再依賴 application（含相對／條件／export／公開 barrel 旁路）；無其他host前置。application legacy只更新URI並保留consumer delegates在前的順序；宣告式 KlpApplication 的 WidgetsApp 必須安裝 const KlpLocalizationsDelegate()，不新增locale/override/public API。Stable kallopis_foundation.dart 只改export來源，其他公開符號/可達性/畫面字串/預設環境不變；舊src路徑刪除無shim。 See [paired plan](../docs/architecture/localization-module-plan/README.md).

### L10N-V1-r2 有證據修復

L10N-V1-r2 修復已重現的舊 discipline 失敗：BlockNote 兩個 renderer 檔的七段原始使用者文案納入既有 KlpLocalizations，七個可選 String constructor 欄位及對應 final 欄位預設完全沿用原文，加入 equality/hashCode 使覆寫可觸發delegate reload。這是相容的既有字串契約補齊，接替 r1「不加 public API」在這七個可選欄位的限制；其餘70既有字串、constructor用法、預設畫面、重試與中斷／WebView生命週期不變，不建第二來源。renderer的錯誤Widget只由 KlpLocalizations.of(context) 取字串，不改branch/controller/callback。獨立作者修 discipline scanner 的註解誤判：兩個 metric card 的單引號箭頭範例是註解而非 literal，必須加入synthetic正負控制，只忽略comments、不忽略真字串，保留Chinese零及icon上限15和下限13，不增加豁免。

## Named lower contracts — LOWER-V1-r1

Execution complete for CAP-V1-02 / REND-V1-04 and seven paired module scopes; public identities and behavior preserved. See [verification](../docs/architecture/lower-contract-plan/verification.md).

LOWER-V1-r1：CAP-V1-02 與 REND-V1-04 配對，71 個既有檔案實體移至具名路徑；全部名稱、constructor、預設值、演算法、狀態與 callback 身分不變。Provider 42 個 editing export 與 9 個 part 移至 editing/contracts，根入口原 44 個 export 的符號可達性不變。draw_command_validation 留 internal，不新增公開；block_drop_preview 仍非公開，drop_target 與 editing_submission 為 editing/ 下具名套件內入口，保留整體演算法及狀態。Foundation 15 個通用 binding 檔案含 11 part 移至 binding/contracts，維持同 library、abstract KlpBoundTemplate 與非 consumer 公開協定；此條明確接替 PRES-V1-r1 的「路徑保留」，其名稱、constructor、模組責任與原行為仍保留。Styling 的 paper_shadow_recipe 與 control_density 移至各自具名入口，值與唯一來源不變。所有直接呼叫端與測試 URI 配對更新，不留 shim、不新增 export。完整 rendering 的 import/export/part/part-of/conditional 指令不得跨到任何其他模組 internal；不能只檢查 capabilities/foundation。維持 26 renderer 分支、28 catalog ID、未知類型拒絕、同模組 reciprocal part、Stable 與 provider 可達性。編輯 pending/resync、save job/confirmed revision、手寫生命週期與上游正文／undo 權威不變。CAP-V1-03 舊正文分類、FND-V1-05 metrics、host 與剩餘 APP-V1-06 不藉此宣告完成。

See [paired plan](../docs/architecture/lower-contract-plan/README.md).

## Legacy metrics authority — METRICS-V1-r1

Execution complete: FND-V1-05 and paired styling, full nine-module dependency graph acyclic. METRICS-V1-r1：FND-V1-05 配對 styling，14 個原 library／part 檔整體歸 lib/src/styling/legacy_metrics/，13 個 abstract final metrics 類型與全部 static 常數／list／Duration／字型 package 名稱、順序與型別完全保留。原 foundation/klp_metrics.dart 僅留單一相容 export 指向新唯一 library，13 個舊 part 刪除。此 export 是原切片明定 P9 前相容入口，非第二實作；根 Stable kallopis_foundation.dart 保持原 export，所有公開 barrel 可達性／型別身分不變。兩個 styling legacy_theme source 改用新下層權威；完整 styling 不得再 import/export/part 到 foundation，包含條件／相對／named part／barrel 旁路，不禁止正常同模組 private helper。part 與 part-of 仍在同 library/module。沒有第二 theme／environment／l10n 或新增 consumer API；只移動權責不重設預設值。

See [paired plan](../docs/architecture/metrics-module-plan/README.md).

### METRICS-DOC-r1 documentation recovery

METRICS-DOC-r1 修復：原工作樹與本批皆重現 token_discipline 未文件化型別 95 > 45。保留原 baseline 45 與其他全部斷言不動；補 50 個既有 provider 與 workspace／prepared／asset 契約型別的繁體中文 dartdoc（25 capabilities、25 features）。每項說明真實用途及不擁有的責任；prepared 仍為套件內部呈現值，不誤宣稱 consumer API。只插入 declaration 前的 /// 行，移除新增行後逐 byte 還原原 source。禁止改 modifier、member、constructor、export、值或分支。本批 degree migration 的純正文等價證據須與這項單獨 comments-only 修復分列；不藉此完成 CAP-V1-03 或 FEAT-V1-07。原 token 閘門及局部分析驗證即可，不新增或修改測試。

## Compatibility roles and closed feature nodes — COMPAT-V1-r1

Execution complete for CAP-V1-03 / FEAT-V1-07; original public construction and authority contracts preserved.

COMPAT-V1-r1／CAP-V1-03：用途分類以符號及用途為準。舊 text/IME intent、request/reply、block/list/undo 操作、layout／hit testing／text window 與 pending-resync submission 僅作既有資料相容、必要維護與回退；新 BlockNote 不使用其即時正文操作建立第二交易／undo／正文權威。保留全部42 editing exports＋9 parts與root44exports、base provider snapshot/stream、save job/confirmed revision/unknown outcome、stamp identity、共用drawing／geometry／anchor／command資料與handwriting/mode合約；不將共享Projection/Endpoint一概棄用，不新增Deprecated警告、刪除export或停用舊路徑。手寫及Spatial未定案不在本片決定。新正文content/adapter/bound/renderer只借用原Krepis BlockNote controller/channel，正文／排版／選取／undo由上游掌管。共享presentation library為其他legacy parts匯入DTO合法；驗收依BlockNote typed members/操作，不把共享名稱解析誤當第二權威。

COMPAT-V1-r1／FEAT-V1-07：關閉清冊中仍開放的七個layout節點對外extends/implements，精確改為final class；原constructor/default/member/body/slots/definition IDs與合法建構保持。KlpLayoutNode等qualification仍可表達資料資格，不能取得註冊權或冒用已知catalog identity。真catalog必須以node_type_mismatch拒絕已知ID偽裝並保留前一個committed frame/resources。完整24feature components（23公開＋1rail）、28總ID、67exports與ownership/presentation分工不變。舊Stable Explorer/WindowControls與新declarative canonical維持不同library面向；P9完整條件為下游完成遷移、無受支援舊入口匯入、相容證據及發布說明允許破壞性移除。仍有舊caller，不執行P9刪除。

See [classification and packet boundaries](../docs/architecture/compatibility-module-plan/README.md).

## Application named contracts — APP-CONTRACT-V1-r1

APP-V1-06 complete. Implementation and independent evidence: [verification](../docs/architecture/application-contract-plan/verification.md).

APP-CONTRACT-V1-r1：APP-V1-06 剩餘完整 application foreign-internal 邊以25個既有來源實體歸具名路徑收尾。Kernel三個lifecycle來源、capabilities導航machine/兩exception及五part、composition scope boundary、十一features adapters、rendering renderer/viewport入口依精確map搬移。Renderer沒有parts；其餘平台實作保留同模組internal，具名入口的正常implementation imports不是consumer公開或跨模組穿透。Navigation五part隨原owner同library移動，狀態機／transaction／commit／lease／錯誤／回收body與callback身分不變。不得以轉匯出barrel遮住其他模組internal，不留舊shim；所有root公開library export指令與順序保持，25來源仍不公開。所有directcallers與36個catalog metadata字串同步原ID/factory/variant/順序，只替換路徑。features67exports／24component、application28ID保持。四個原未附文件的adapter只新增精確用途dartdoc以維持token baseline45，其餘非directive正文僅准行首tab正規化；去除這四新增註解後正文等價。不在這批實作R1/R2 lifecycle、filepicker或環境；後續使用新的rendering具名入口。

See [paired plan](../docs/architecture/application-contract-plan/README.md).

## Renderer host lifecycle — REND-HOST-V1-r1

REND-V1-05 complete. R1/R2 independent evidence: [verification](../docs/architecture/rendering-host-plan/verification.md).

REND-HOST-V1-r1 接受 REND-V1-05 的兩個實作里程碑。R1：features 純 Dart typed failure 經既有 viewport sink 由 application 安裝，原始 error/stack 與 origin/phase 送既有 recovery；renderer local input/binding 以捕捉身分且冪等的 detach 在所有 interrupt 結果後 finally 釋放。R2：兩 WebView 使用 controller identity key 與固定 attachment，依上游既有 bind 排他規則只解除自己成功取得的 sender；每個 await 後檢驗存活。BlockNote 開啟成功立即標記，後續 flush/callback 失敗不得重播初始文件；Canva 去重且不新增自動重試或 UI。環境 late result/dispose 只有一次清理及回報。借用的 provider/controller 不 close/save，不新增正文、theme、environment、l10n 或全域 registry 權威。細部已接受 API、失敗歸屬與驗收由同版 path-map 決策定義。R1 只代表部分完成，R1/R2 與整合證據全部通過才完成 REND-V1-05。

完整可執行契約見 [配對計畫](../docs/architecture/rendering-host-plan/README.md) 與該計畫的 path-map。

## Host environment and file selection — HOST-PORTS-V1-r1

APP-V1-05／FEAT-V1-06 complete。E/P 已整合並完成獨立驗證；[執行證據與既有 CI 限制](../docs/architecture/host-ports-plan/verification.md)。

HOST-PORTS-V1-r1 接受 APP-V1-05／FEAT-V1-06 的 E 環境與 P 檔案選取配對。Capabilities 持有純環境解析及既有 KlpAppPlatform／KlpAdaptiveMode 唯一宣告，Stable foundation 原 facade、型別與 current(Size?) 行為保留；application 唯一既有 host 採樣並安裝，不增加 observer、store 或預設。P 接替已接受的 concrete picker 宣告式面：公開 L1 KlpPickFileAction，port/result 套件內部；application 唯一 plugin adapter，既有 action handler 用原 frame/lease/epoch/entry 在 await 前後檢驗。有效 selected 才回呼一次，cancel/stale/failed 為 false，平台或 callback error 原物件／stack 由 host 一次回報。舊零 host picker 搬 application/legacy 並由專用 legacy root 保留 const/欄位/pick Future 成功取消與原 error 傳播；不作現行宿主 fallback。公開 roots 6→7，僅 declarative 一增一刪及新 legacy，feature exports 67→66，24 components/28 IDs/順序保持。原 R1/APP06 root/hash/closure/catalog 基準依 path-map 精確增減由獨立作者更新，不 blanket resnapshot 或放寬原守衛。E 單獨不完成 APP05；E/P 與完整證據通過才 APP05/FEAT06 complete。

現行規格由 [具體配對](../docs/architecture/host-ports-plan/README.md) 的 API/lease/query/public delta 固定，明確接替先前6root/67feature基準中受本片影響的項目，其餘相容與權威不變。
