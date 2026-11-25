import path from 'node:path';
import fs from 'node:fs';
import { pathToFileURL } from 'node:url';

/** 解析公開 export graph；來源型別同時提供 props 預設值，避免依賴過期 dist。 */
export async function extractReactApi(root) {
	const packageRoot = path.join(root, 'react');
	// 使用專案釘選的 TypeScript compiler API，不建立第二份 compiler 相依。
	const { API, SymbolFlags, SignatureKind } = await import(pathToFileURL(path.join(packageRoot, 'node_modules/typescript/dist/api/sync/api.js')));
	const { SyntaxKind } = await import(pathToFileURL(path.join(packageRoot, 'node_modules/typescript/dist/ast/index.js')));
	const config = path.join(packageRoot, 'tsconfig.json');
	const api = new API({ /* cwd：使用原平台設定解析公開來源。 */ cwd: packageRoot });
	let snapshot;
	try {
		snapshot = api.updateSnapshot({ /* openProjects：只讀本庫 tsconfig。 */ openProjects: [config] });
		const project = snapshot.getProject(config);
		const program = project.program;
		const diagnostics = [...program.getSyntacticDiagnostics(), ...program.getSemanticDiagnostics()];
		if (diagnostics.length) throw new Error(`React source diagnostics: ${diagnostics.map(item => JSON.stringify(item.messageText)).join('; ')}`);

		const checker = project.checker;
		const source = program.getSourceFile(path.join(packageRoot, 'src/index.ts'));
		const module = checker.getSymbolAtLocation(source);
		const declarations = [];
		const local = node => node.getSourceFile().fileName.replaceAll('\\', '/').startsWith(`${packageRoot.replaceAll('\\', '/')}/src/`);
		const text = node => node?.getText() ?? '';
		const documentation = symbol => checker.getDocumentationCommentOfSymbol(symbol) || '';
		const isPrivate = node => text(node.name).startsWith('#') || node.modifiers?.some(item => [SyntaxKind.PrivateKeyword, SyntaxKind.ProtectedKeyword].includes(item.kind));
		const signature = node => node.body ? node.getSourceFile().text.slice(node.getStart(), node.body.pos).trim() : text(node);
		const parameter = node => ({
			/* name／type：呼叫介面；required／defaultValue：語法定義；named：TS 位置參數。 */
			name: text(node.name), type: text(node.type) || 'unknown', required: !node.questionToken && !node.initializer && !node.dotDotDotToken,
			defaultValue: node.initializer ? text(node.initializer) : null, named: false,
		});
		function member(node) {
			const symbol = node.name && checker.getSymbolAtLocation(node.name);
			return {
				/* name／kind／signature：不抄方法 body；parameters／documentation：完整呼叫與說明。 */
				name: text(node.name) || 'constructor', kind: memberKind(node), signature: signature(node),
				parameters: Array.from(node.parameters ?? [], parameter), documentation: symbol ? documentation(symbol) : '',
			};
		}
		function memberKind(node) {
			if (node.kind === SyntaxKind.Constructor) return 'constructor';
			if (node.kind === SyntaxKind.GetAccessor) return 'getter';
			if (node.kind === SyntaxKind.SetAccessor) return 'setter';
			return node.parameters ? 'method' : 'field';
		}
		function reactElement(type) {
			if (!type) return false;
			if (type.getTypes()?.some(reactElement)) return true;

			const symbol = type.getSymbol();
			return ['Element', 'ReactElement'].includes(symbol?.name) && symbol.declarations.some(item => item.resolve()?.getSourceFile().fileName.replaceAll('\\', '/').includes('/@types/react/'));
		}
		function properties(type, defaults = new Map()) {
			if (!type) return [];

			return checker.getPropertiesOfType(type).flatMap(symbol => {
				const node = symbol.declarations.map(item => item.resolve()).find(item => item && (local(item) || defaults.has(symbol.name)));
				if (!node || isPrivate(node)) return [];

				return [{
					/* name／type／required 以 compiler 為準；defaultValue 僅讀當前函式的解構設定。 */
					name: symbol.name, type: checker.typeToString(checker.getTypeOfSymbol(symbol), node, 1), required: !(symbol.flags & SymbolFlags.Optional),
					defaultValue: defaults.get(symbol.name) ?? null, documentation: documentation(symbol),
				}];
			});
		}
		for (const exported of checker.getExportsOfModule(module)) {
			const symbol = exported.flags & SymbolFlags.Alias ? checker.getAliasedSymbol(exported) : exported;
			const nodes = symbol.declarations.map(item => item.resolve()).filter(item => item && local(item));
			if (!nodes.length) throw new Error(`Public declaration outside package: ${exported.name}`);

			const node = nodes.find(item => item.body) ?? nodes[0];
			let kind = 'variable';
			if (node.kind === SyntaxKind.ClassDeclaration) kind = 'class';
			else if (node.kind === SyntaxKind.InterfaceDeclaration) kind = 'interface';
			else if (node.kind === SyntaxKind.TypeAliasDeclaration) kind = 'type';
			else if (node.kind === SyntaxKind.FunctionDeclaration) kind = 'function';
			else if (node.kind === SyntaxKind.EnumDeclaration) kind = 'enum';
			const type = checker.getTypeOfSymbol(symbol);
			const calls = type ? checker.getSignaturesOfType(type, SignatureKind.Call) : [];
			const renderable = kind === 'function' && calls.some(call => reactElement(checker.getReturnTypeOfSignature(call)));
			const defaults = new Map();
			const first = node.parameters?.[0];
			for (const binding of first?.name?.elements ?? []) if (binding.initializer) defaults.set(text(binding.propertyName ?? binding.name), text(binding.initializer));
			let parameters = Array.from(node.parameters ?? [], parameter);
			if (renderable && first?.type) parameters = properties(checker.getTypeAtLocation(first.type), defaults);
			const members = Array.from(node.members ?? [], item => item).filter(item => !isPrivate(item)).map(member);
			if (kind === 'interface' || kind === 'type') {
				const declared = checker.getDeclaredTypeOfSymbol(symbol);
				for (const prop of properties(declared)) if (!members.some(item => item.name === prop.name)) members.push({ ...prop, kind: 'field', signature: `${prop.name}${prop.required ? '' : '?'}: ${prop.type}` });
			}
			let publicSignature = nodes.filter(item => !item.body).map(signature).join('\n') || signature(node);
			if (kind === 'function' && !node.type && calls.length) {
				const returned = checker.getReturnTypeOfSignature(calls[0]);
				if (returned) publicSignature += `: ${checker.typeToString(returned, node, 1)}`;
			}
			if (kind === 'class') publicSignature = signature(node).split('{')[0].trim();
			if (kind === 'variable') publicSignature = `export const ${exported.name}: ${text(node.type) || checker.typeToString(type, node, 1)};`;
			declarations.push({
				/* id：公開入口識別；source：可追溯來源；其餘欄位是平台無關文件投影契約。 */
				id: `@kallopis/react#${exported.name}`, name: exported.name, kind, renderable,
				source: path.relative(root, node.getSourceFile().fileName).replaceAll('\\', '/'), signature: publicSignature,
				documentation: documentation(symbol), parameters, members,
			});
		}
		return declarations.sort((left, right) => left.name.localeCompare(right.name, 'en'));
	}
	finally {
		snapshot?.dispose();
		api.close();
	}
}

if (process.argv[1] && path.resolve(process.argv[1]) === path.resolve(import.meta.filename)) {
	const root = path.resolve(import.meta.dirname, '../..');
	const declarations = await extractReactApi(root);
	// 清冊為本機產物，所有解析成功後才覆寫。
	fs.mkdirSync(path.join(root, 'build'), { recursive: true });
	fs.writeFileSync(path.join(root, 'build/react-reference-api.json'), `${JSON.stringify(declarations, null, '\t')}\n`);
	console.log(`Extracted ${declarations.length} React public declarations.`);
}
