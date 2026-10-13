import { existsSync, mkdirSync, realpathSync, statSync, writeFileSync } from 'node:fs';
import path from 'node:path';
import { fileURLToPath, pathToFileURL } from 'node:url';
import { API, SignatureKind, SymbolFlags } from 'typescript/unstable/sync';
import { SyntaxKind } from 'typescript/unstable/ast';

/** 從真正公開入口解析元件；不掃描產品源碼，也不以命名前綴推定呈現能力。 */
export function extractReactComponents(entrypoint, packageRoot) {
	// 步驟1：限定可讀取的package及入口；來源不得跨越package ownership。
	if (typeof entrypoint !== 'string' || typeof packageRoot !== 'string' || !path.isAbsolute(entrypoint) || !path.isAbsolute(packageRoot)) throw new Error('Absolute entrypoint and package root required');
	if (!existsSync(packageRoot) || !statSync(packageRoot).isDirectory() || !existsSync(entrypoint) || !statSync(entrypoint).isFile() || !entrypoint.endsWith('.d.ts')) throw new Error('Missing declaration entrypoint or package root');
	const root = realpathSync(packageRoot);
	const entry = realpathSync(entrypoint);
	inside(root, entry);
	const reactRoot = realpathSync(path.join(root, 'node_modules', '@types', 'react'));
	const config = path.join(root, '.kallopis-reference-tsconfig.json');
	const configText = JSON.stringify({
		/* compilerOptions只供本次公開宣告檢查，避免inferred IDE略過d.ts錯誤；files限定入口。 */
		compilerOptions: {
			/* module／moduleResolution沿NodeNext；target／jsx對應目前React；strict檢查型別，
			 * skipLibCheck=false確保宣告錯誤阻止產物；noEmit禁止建立第二份程式庫。 */
			module: 'NodeNext', moduleResolution: 'NodeNext', target: 'ES2022', jsx: 'react-jsx', strict: true, skipLibCheck: false, noEmit: true
		},
		files: [entry]
	});
	function isConfig(file) { return path.resolve(file) === config; }
	function fileExists(file) { return isConfig(file) ? true : undefined; }
	function readFile(file) { return isConfig(file) ? configText : undefined; }

	// 步驟2：TS7原生API以虛擬config解析同一公開入口，不修改consumer或repository設定。
	const api = new API({
		/* cwd是解析根；fs僅投影本次config，其餘檔案沿真實filesystem。 */
		cwd: root,
		fs: { /* fileExists／readFile只覆寫本次虛擬config的存在與內容。 */ fileExists, readFile }
	});
	let snapshot;
	try {
		snapshot = api.updateSnapshot({ /* openProjects明確選擇本次宣告診斷範圍。 */ openProjects: [config] });
		const project = snapshot.getProject(config);
		if (!project) throw new Error('Could not open declaration project');

		const program = project.program;
		const diagnostics = [...program.getConfigFileParsingDiagnostics(), ...program.getProgramDiagnostics(), ...program.getGlobalDiagnostics(), ...program.getSyntacticDiagnostics(), ...program.getBindDiagnostics(), ...program.getSemanticDiagnostics()];
		if (diagnostics.length) throw new Error(`Declaration compilation failed: ${diagnostics.map(value => JSON.stringify(value.messageText)).join('; ')}`);

		const checker = project.checker;
		const source = program.getSourceFile(entry);
		const module = source && checker.getSymbolAtLocation(source);
		if (!module) throw new Error('Declaration entrypoint is not a module');

		// 步驟3：runtime export graph排除type-only邊，再以React declaration identity辨認return。
		const runtime = runtimeNames(source, checker);
		const components = [];
		for (const exported of checker.getExportsOfModule(module)) {
			if (!runtime.has(exported.name)) continue;

			const target = unalias(exported, checker);
			const declaration = target.valueDeclaration?.resolve();
			if (!declaration || ![SyntaxKind.FunctionDeclaration, SyntaxKind.VariableDeclaration].includes(declaration.kind)) continue;

			const type = checker.getTypeOfSymbol(target);
			const signatures = type ? checker.getSignaturesOfType(type, SignatureKind.Call) : [];
			const callable = signatures.map(value => value.declaration?.resolve()).find(value => value?.type && reactReturn(value.type, checker, reactRoot));
			if (!callable) continue;

			const local = inside(root, realpathSync(declaration.getSourceFile().fileName));
			components.push({
				/* id／name採公開export identity，alias不改原signature；source維持package ownership。
				 * signature保留原callable declaration；propsType保留首參數annotation供公開參數入口。 */
				id: `@kallopis/react#${exported.name}`, name: exported.name, source: local, signature: declaration.getText(), propsType: callable.parameters[0]?.type?.getText() ?? ''
			});
		}
		components.sort(compareComponents);
		if (new Set(components.map(value => value.id)).size !== components.length) throw new Error('Duplicate public component identity');

		return { /* schemaVersion是傳輸版；framework／entrypoint辨認公開package；components為排序後可呈現宣告。 */ schemaVersion: 1, framework: 'react', entrypoint: '@kallopis/react', components };
	}
	finally {
		snapshot?.dispose();
		api.close();
	}
}

function inside(root, file) {
	const local = path.relative(root, file);
	if (!local || local === '..' || local.startsWith(`..${path.sep}`) || path.isAbsolute(local)) throw new Error(`Declaration source outside package: ${file}`);

	return local.split(path.sep).join('/');
}

function compareComponents(left, right) {
	if (left.name < right.name) return -1;
	if (left.name > right.name) return 1;

	return 0;
}

function unalias(symbol, checker) { return symbol.flags & SymbolFlags.Alias ? checker.getAliasedSymbol(symbol) : symbol; }

function typeOnly(node) {
	for (let current = node; current && current.kind !== SyntaxKind.SourceFile; current = current.parent) {
		if (current.isTypeOnly) return true;
	}
	return false;
}

function runtimeNames(source, checker, visited = new Set()) {
	if (visited.has(source.fileName)) return new Set();

	const next = new Set(visited).add(source.fileName);
	const names = new Set();
	for (const statement of source.statements) {
		// 直接的value宣告與re-export分別解析，不能把export type star混入runtime。
		if (statement.modifiers?.some(value => value.kind === SyntaxKind.ExportKeyword)) {
			const isDefault = statement.modifiers.some(value => value.kind === SyntaxKind.DefaultKeyword);
			if (isDefault) names.add('default');
			else if (statement.name?.text) names.add(statement.name.text);
			else if (statement.kind === SyntaxKind.VariableStatement) {
				for (const declaration of statement.declarationList.declarations) if (declaration.name.kind === SyntaxKind.Identifier) names.add(declaration.name.text);
			}
		}
		if (statement.kind === SyntaxKind.ExportAssignment && !statement.isExportEquals) names.add('default');
		if (statement.kind !== SyntaxKind.ExportDeclaration || statement.isTypeOnly) continue;

		let available;
		if (statement.moduleSpecifier) {
			const module = checker.getSymbolAtLocation(statement.moduleSpecifier);
			const target = module?.declarations.map(value => value.resolve()).find(value => value?.kind === SyntaxKind.SourceFile);
			available = target ? runtimeNames(target, checker, next) : new Set();
		}
		if (!statement.exportClause) {
			for (const name of available ?? []) if (name !== 'default') names.add(name);
			continue;
		}
		if (statement.exportClause.kind !== SyntaxKind.NamedExports) continue;

		for (const specifier of statement.exportClause.elements) {
			if (specifier.isTypeOnly) continue;

			const original = specifier.propertyName?.text ?? specifier.name.text;
			if (available) {
				if (available.has(original)) names.add(specifier.name.text);
			}
			else {
				const local = checker.resolveName(original, SymbolFlags.Value | SymbolFlags.Alias, statement);
				if (local && !local.declarations.some(value => typeOnly(value.resolve()))) names.add(specifier.name.text);
			}
		}
	}
	return names;
}

function reactReturn(node, checker, reactRoot) {
	if (node.kind === SyntaxKind.ParenthesizedType) return reactReturn(node.type, checker, reactRoot);
	if (node.kind === SyntaxKind.UnionType) {
		const values = node.types.filter(value => value.kind !== SyntaxKind.UndefinedKeyword && !(value.kind === SyntaxKind.LiteralType && value.literal.kind === SyntaxKind.NullKeyword));
		return values.length > 0 && values.every(value => reactReturn(value, checker, reactRoot));
	}
	if (![SyntaxKind.TypeReference, SyntaxKind.ImportType].includes(node.kind)) return false;

	const location = node.typeName ?? node.qualifier;
	const original = location && checker.getSymbolAtLocation(location);
	if (!original) return false;

	const symbol = unalias(original, checker);
	for (const handle of symbol.declarations) {
		const declaration = handle.resolve();
		if (!declaration) continue;

		const file = realpathSync(declaration.getSourceFile().fileName);
		const local = path.relative(reactRoot, file);
		const fromReact = local && local !== '..' && !local.startsWith(`..${path.sep}`) && !path.isAbsolute(local);
		if (fromReact && (['ReactNode', 'ReactElement'].includes(symbol.name) || symbol.name === 'Element' && symbol.getParent()?.name === 'JSX')) return true;
		if (declaration.kind === SyntaxKind.TypeAliasDeclaration && declaration.type !== node) {
			// 別名循環交給compiler拒絕；合法別名沿原annotation回到React權威。
			if (reactReturn(declaration.type, checker, reactRoot)) return true;
		}
	}
	return false;
}

function main() {
	const args = process.argv.slice(2);
	if (args.length && (args.length !== 2 || args[0] !== '--output')) throw new Error('Usage: reference-components.mjs [--output path]');

	const root = path.resolve(path.dirname(fileURLToPath(import.meta.url)), '..');
	const output = args.length ? path.resolve(args[1]) : path.join(root, 'build', 'reference-components.json');
	const inventory = extractReactComponents(path.join(root, 'dist', 'index.d.ts'), root);
	const content = `${JSON.stringify(inventory, null, '\t')}\n`;

	// 完整擷取與診斷成功後才寫產物，錯誤保留上一份JSON。
	mkdirSync(path.dirname(output), { recursive: true });
	writeFileSync(output, content);
	console.log(`Extracted ${inventory.components.length} public React components.`);
}

if (process.argv[1] && pathToFileURL(path.resolve(process.argv[1])).href === import.meta.url) {
	try { main(); }
	catch (error) { console.error(error instanceof Error ? error.message : String(error)); process.exitCode = 1; }
}
