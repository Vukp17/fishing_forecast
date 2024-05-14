
import 'package:flutter/material.dart';


class LanguageProvider extends ChangeNotifier {
  Locale _currentLocale = Locale('sr', 'RS');

  Locale get currentLocale => _currentLocale;

  void changeLocale(Locale newLocale) {
    _currentLocale = newLocale;

    notifyListeners();
  }
}