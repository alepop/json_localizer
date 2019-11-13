import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:json_localizer/json_localizer.dart';

// Locales for tests defined in folder: /build/unit_test_assets/locales

void main() {
  JSONLocalizer localizer;
  setUpAll(() async {
    localizer = await JSONLocalizer.delegate.load(Locale('en'));
  });
  testWidgets("JSONLocalizer should pick phrase from json file",
      (WidgetTester tester) async {
    expect(localizer.translate("title"), "Hello world");
  });

  testWidgets("JSONLocalizer should replace anchors in strings",
      (WidgetTester tester) async {
    expect(localizer.translate("hello", {"name": "Alice"}), "Hello Alice");
  });

  testWidgets("JSONLocalizer should pluralize strings",
      (WidgetTester tester) async {
    expect(localizer.pluralize("email", 2), "There are 2 emails");
  });

  testWidgets(
      "JSONLocalizer should pluralize strings with additional parrameters",
      (WidgetTester tester) async {
    expect(localizer.pluralize("email", 1, {"userName": "Alice"}),
        "There is 1 email for Alice");
  });

  testWidgets(
      "JSONLocalizer should pick phrase from json file with another locale",
      (WidgetTester tester) async {
    final Locale locale = Locale('ru');
    final JSONLocalizer localizer = await JSONLocalizer.delegate.load(locale);
    expect(localizer.translate("title"), "Привет мир");
  });
}
