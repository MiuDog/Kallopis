part of '../klp_timeline.dart';

/// 時間軸上的一個事件。
///
/// [marker] 為 `null` 時使用預設圓點；需要客製標記（例如放圖示）時提供這個 slot，
/// 而不是加一堆布林參數去描述「這是哪一種標記」。[highlighted] 只改變預設圓點的
/// 顏色深淺，不表達產品語意（不是「成功」或「危險」那種狀態）。
@immutable
class KlpTimelineItemData {
	const KlpTimelineItemData({
		required this.title,
		this.time,
		this.content,
		this.marker,
		this.highlighted = false,
	});

	final String title;
	final String? time;
	final Widget? content;
	final Widget? marker;
	final bool highlighted;
}
