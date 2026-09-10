part of 'klp_localizations.dart';

/// 將 Kallopis 字串集合註冊到 Flutter localization scope。
class KlpLocalizationsDelegate extends LocalizationsDelegate<KlpLocalizations> {
	const KlpLocalizationsDelegate([this.overrides = const KlpLocalizations()]);

	final KlpLocalizations overrides;

	@override
	bool isSupported(Locale locale) => true;

	@override
	Future<KlpLocalizations> load(Locale locale) => SynchronousFuture(overrides);

	@override
	bool shouldReload(KlpLocalizationsDelegate old) => overrides != old.overrides;
}
