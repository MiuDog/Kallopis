part of '../../structure/klp_application.dart';

/// 宿主不公開匯出，消費端不能在外側插入 Widget 或替換渲染。
final class _KlpApplicationHost extends StatefulWidget {

	final KlpState<KlpApplication> source;

	const _KlpApplicationHost({required this.source});

	@override
	State<_KlpApplicationHost> createState() => _KlpApplicationHostState();
}
