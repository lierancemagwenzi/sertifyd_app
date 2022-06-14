import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:horizon/src/helper/custom_trace.dart';

class Setting{

  String appName = '';
  double defaultTax;
  String defaultCurrency;
  String distanceUnit;
  bool currencyRight = false;
  int currencyDecimalDigits = 2;
int meeting_time;
  String mainColor;
  String mainDarkColor;
  String secondColor;
  String secondDarkColor;
  String accentColor;
  String accentDarkColor;
  String scaffoldDarkColor;
  String scaffoldColor;
  String googleMapsKey;
  String fcmKey;
  ValueNotifier<Locale> mobileLanguage = new ValueNotifier(Locale('en', ''));
  String appVersion;
  bool enableVersion = true;
String helpline;
String enable_images;
  ValueNotifier<Brightness> brightness = new ValueNotifier(Brightness.light);

  Setting();

  Setting.fromJSON(Map<String, dynamic> jsonMap) {
    try {
      appName = jsonMap['app_name'] ?? null;
      mainColor = jsonMap['main_color'] ?? null;
      mainDarkColor = jsonMap['main_dark_color'] ?? '';
      secondColor = jsonMap['second_color'] ?? '';
      secondDarkColor = jsonMap['second_dark_color'] ?? '';
      accentColor = jsonMap['accent_color'] ?? '';
      accentDarkColor = jsonMap['accent_dark_color'] ?? '';
      scaffoldDarkColor = jsonMap['scaffold_dark_color'] ?? '';
      scaffoldColor = jsonMap['scaffold_color'] ?? '';
      googleMapsKey = jsonMap['google_maps_key'] ?? null;
      fcmKey = jsonMap['fcm_key'] ?? null;

      helpline = jsonMap['helpline'] ?? null;
      enable_images = jsonMap['enable_images'] ?? null;
      meeting_time = jsonMap['meeting_time']!=null?int.tryParse(jsonMap['meeting_time'])!=null?int.tryParse(jsonMap['meeting_time']):20 : 20;
      mobileLanguage.value = Locale(jsonMap['mobile_language'] ?? "en", '');
      appVersion = jsonMap['app_version'] ?? '';
      distanceUnit = jsonMap['distance_unit'] ?? 'km';
      enableVersion = jsonMap['enable_version'] == null || jsonMap['enable_version'] == '0' ? false : true;
      defaultTax = double.tryParse(jsonMap['default_tax'] ?? '0') ?? 0.0; //double.parse(jsonMap['default_tax'].toString());
      defaultCurrency = jsonMap['default_currency'] ?? '';
      currencyDecimalDigits = int.tryParse(jsonMap['default_currency_decimal_digits'] ?? '2') ?? 2;
      currencyRight = jsonMap['currency_right'] == null || jsonMap['currency_right'] == '0' ? false : true;

    } catch (e) {
      print(CustomTrace(StackTrace.current, message: e));
    }
  }

}