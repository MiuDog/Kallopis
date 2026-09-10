part of '../klp_accordion.dart';

/// [KlpAccordion] 裡的單一可摺疊項目。
///
/// [id] 在同一個 [KlpAccordion] 內須唯一，用來追蹤展開狀態；[child] 是展開後顯示的
/// 內容——它何時被建構、狀態如何保留由呼叫端決定，這裡不快取也不知道內容是什麼。
@immutable
class KlpAccordionItemData {
	const KlpAccordionItemData({
		required this.id,
		required this.title,
		required this.child,
		this.subtitle,
	});

	final String id;
	final String title;
	final String? subtitle;
	final Widget child;
}
