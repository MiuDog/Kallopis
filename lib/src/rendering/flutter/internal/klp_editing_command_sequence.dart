/// K01 與 K02 共用的單一命令序號發行者。
final class KlpEditingCommandSequence {
	int _value = 0;
	final int Function()? _source;

	KlpEditingCommandSequence([this._source]);

	int next() => _source?.call() ?? ++_value;
}
