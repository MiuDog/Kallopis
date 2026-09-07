import 'dart:convert';
import 'dart:io';
import 'package:analyzer/dart/analysis/utilities.dart';
import 'package:analyzer/dart/ast/ast.dart';

String compact(String value) => value.replaceAll(RegExp(r'\s+'), ' ').trim();

void main(List<String> args) {

	// 依語法樹擷取宣告與直接關係，不推論執行期呼叫。
	final root = Directory(args[0]).absolute;
	final result = <Map<String, Object?>>[];
	final files = Directory('${root.path}/lib/src').listSync(recursive: true).whereType<File>().where((file) => file.path.endsWith('.dart')).toList()..sort((a, b) => a.path.compareTo(b.path));
	for (final file in files) {
		final source = file.readAsStringSync();
		final parsed = parseString(content: source, path: file.path, throwIfDiagnostics: false);
		if (parsed.errors.isNotEmpty) {
			throw StateError('${file.path}: ${parsed.errors}');
		}
		int line(AstNode node) => parsed.lineInfo.getLocation(node.offset).lineNumber;
		String summary(AnnotatedNode node) => node.documentationComment == null ? '' : compact(node.documentationComment!.tokens.map((token) => token.lexeme.replaceAll(RegExp(r'^///\s?|^/\*\*|\*/$'), '')).join(' '));
		String header(AstNode node) {
			var end = node.end;
			if (node is MethodDeclaration) {
				end = node.body.offset;
			}
			if (node is ConstructorDeclaration) {
				end = node.parameters.end;
			}
			if (node is FunctionDeclaration) {
				end = node.functionExpression.body.offset;
			}
			if (node is ClassDeclaration) {
				end = node.body.offset;
			}
			if (node is EnumDeclaration) {
				end = node.body.offset;
			}
			if (node is MixinDeclaration) {
				end = node.body.offset;
			}
			if (node is ExtensionDeclaration) {
				end = node.body.offset;
			}
			var start = node.offset;
			if (node is AnnotatedNode) {
				start = node.firstTokenAfterCommentAndMetadata.offset;
			}
			return compact(source.substring(start, end));
		}
		Map<String, Object?> member(AstNode node, String name, String kind, {String? signature}) => {'name': name, 'kind': kind, 'line': line(node), 'visibility': name.startsWith('_') ? 'private' : 'public', 'signature': signature ?? header(node), 'summary': node is AnnotatedNode ? summary(node) : ''};
		final declarations = <Map<String, Object?>>[];
		for (final declaration in parsed.unit.declarations) {
			final members = <Map<String, Object?>>[];
			final relations = <Map<String, Object?>>[];
			var name = '';
			var kind = declaration.runtimeType.toString().replaceAll('Impl', '');
			Iterable<ClassMember> children = [];
			void relation(String verb, AstNode target) => relations.add({'kind': verb, 'target': target.toSource(), 'line': line(target)});
			if (declaration is ClassDeclaration) {
				name = declaration.namePart.typeName.lexeme;
				children = declaration.body.childEntities.whereType<ClassMember>();
				if (declaration.extendsClause != null) {
					relation('extends', declaration.extendsClause!.superclass);
				}
				for (final item in declaration.implementsClause?.interfaces ?? <NamedType>[]) {
					relation('implements', item);
				}
				for (final item in declaration.withClause?.mixinTypes ?? <NamedType>[]) {
					relation('with', item);
				}
			}
			else if (declaration is EnumDeclaration) {
				name = declaration.namePart.typeName.lexeme;
				children = declaration.body.childEntities.whereType<ClassMember>();
				for (final item in declaration.body.childEntities.whereType<EnumConstantDeclaration>()) {
					members.add(member(item, item.name.lexeme, 'enum value', signature: item.name.lexeme));
				}
				for (final item in declaration.implementsClause?.interfaces ?? <NamedType>[]) {
					relation('implements', item);
				}
				for (final item in declaration.withClause?.mixinTypes ?? <NamedType>[]) {
					relation('with', item);
				}
			}
			else if (declaration is MixinDeclaration) {
				name = declaration.name.lexeme;
				children = declaration.body.childEntities.whereType<ClassMember>();
				for (final item in declaration.onClause?.superclassConstraints ?? <NamedType>[]) {
					relation('on', item);
				}
				for (final item in declaration.implementsClause?.interfaces ?? <NamedType>[]) {
					relation('implements', item);
				}
			}
			else if (declaration is ExtensionDeclaration) {
				name = declaration.name?.lexeme ?? '(unnamed extension)';
				children = declaration.body.childEntities.whereType<ClassMember>();
				if (declaration.onClause != null) {
					relation('on', declaration.onClause!.extendedType);
				}
			}
			else if (declaration is FunctionDeclaration) {
				name = declaration.name.lexeme;
			}
			else if (declaration is GenericTypeAlias) {
				name = declaration.name.lexeme;
			}
			else if (declaration is FunctionTypeAlias) {
				name = declaration.name.lexeme;
			}
			else if (declaration is TopLevelVariableDeclaration) {
				for (final variable in declaration.variables.variables) {
					final prefix = source.substring(declaration.firstTokenAfterCommentAndMetadata.offset, declaration.variables.variables.first.offset);
					final signature = '$prefix${declaration.variables.type == null ? '(inferred) ' : ''}${variable.name.lexeme}';
					declarations.add({...member(variable, variable.name.lexeme, 'top-level variable', signature: compact(signature)), 'summary': summary(declaration), 'members': [], 'relations': []});
				}
				continue;
			}
			else {
				throw StateError('Unhandled declaration ${declaration.runtimeType} in ${file.path}');
			}
			for (final child in children) {
				if (child is FieldDeclaration) {
					for (final variable in child.fields.variables) {
						final prefix = source.substring(child.firstTokenAfterCommentAndMetadata.offset, child.fields.variables.first.offset);
						final signature = '$prefix${child.fields.type == null ? '(inferred) ' : ''}${variable.name.lexeme}';
						members.add({...member(variable, variable.name.lexeme, 'field', signature: compact(signature)), 'summary': summary(child)});
					}
				}
				else if (child is MethodDeclaration) {
					members.add(member(child, child.name.lexeme, child.isGetter ? 'getter' : child.isSetter ? 'setter' : 'method'));
				}
				else if (child is ConstructorDeclaration) {
					members.add(member(child, child.name?.lexeme ?? name, 'constructor'));
				}
				else {
					throw StateError('Unhandled member ${child.runtimeType} in ${file.path}');
				}
			}
			declarations.add({...member(declaration, name, kind), 'members': members, 'relations': relations});
		}
		final directives = <Map<String, Object?>>[];
		for (final directive in parsed.unit.directives) {
			if (directive is UriBasedDirective) {
				final kind = directive is ImportDirective ? 'import' : directive is ExportDirective ? 'export' : 'part';
				directives.add({'kind': kind, 'target': directive.uri.stringValue, 'line': line(directive), 'signature': directive.toSource()});
				if (directive is NamespaceDirective) {
					for (final config in directive.configurations) {
						directives.add({'kind': '$kind conditional', 'target': config.uri.stringValue, 'line': line(config), 'signature': config.toSource()});
					}
				}
			}
			else if (directive is PartOfDirective) {
				directives.add({'kind': 'part of', 'target': directive.uri?.stringValue ?? directive.libraryName?.toSource(), 'line': line(directive), 'signature': directive.toSource()});
			}
		}
		result.add({'path': file.path.substring(root.path.length + 1).replaceAll('\\', '/'), 'declarations': declarations, 'directives': directives});
	}
	// 純資料中介檔供文件產生器與獨立驗收讀取。
	File(args[1]).writeAsStringSync(const JsonEncoder.withIndent('\t').convert(result));
	stdout.writeln('Extracted ${result.length} Dart files without syntax errors.');
}
