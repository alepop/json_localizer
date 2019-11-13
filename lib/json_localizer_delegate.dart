import 'dart:convert';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:flutter/services.dart';
import 'package:json_localizer/utils.dart';

class JSONLocalizer {
  Locale locale;
  Map<String, dynamic> _sentences;

  JSONLocalizer(this.locale);

  _resolve(String path, dynamic obj) {
    List<String> keys = path.split('.');
    return keys.fold(obj, (acc, value) {
      if (acc[value] != null) {
        return acc[value];
      }
      return acc;
    });
  }

  Future<bool> load() async {
    String localePath = 'locales/${locale.languageCode}.json';
    String data = await rootBundle.loadString(localePath);
    Map<String, dynamic> _result = json.decode(data);
    _sentences = Map();
    _result.forEach((key, value) {
      this._sentences[key] = value;
    });
    return true;
  }

  String translate(String key, [Map<String, dynamic> args]) {
    String sentence = this._resolve(key, _sentences);
    if (args != null) {
      args.forEach((key, value) {
        sentence = sentence.replaceFirst('\$$key', value.toString());
      });
    }
    return sentence;
  }

  String pluralize(String key, int howMany, [Map<String, dynamic> args]) {
    Map<String, dynamic> sentence = this._resolve(key, _sentences);
    String result =
        Function.apply(Intl.plural, [howMany], symbolizeKeys(sentence));
    args ??= Map();
    args['howMany'] = howMany;
    args.forEach((key, value) {
      result = result.replaceFirst('\$$key', value.toString());
    });
    return result;
  }

  static JSONLocalizer of(BuildContext context) {
    return Localizations.of<JSONLocalizer>(context, JSONLocalizer);
  }

  static LocalizationsDelegate<JSONLocalizer> delegate =
      _JSONLocalizerDelegate();
}

class _JSONLocalizerDelegate extends LocalizationsDelegate<JSONLocalizer> {
  const _JSONLocalizerDelegate();
  @override
  bool isSupported(Locale locale) => locale != null;

  @override
  bool shouldReload(LocalizationsDelegate<JSONLocalizer> old) => false;

  @override
  Future<JSONLocalizer> load(Locale locale) async {
    JSONLocalizer localizations = JSONLocalizer(locale);
    await localizations.load();
    return localizations;
  }
}
