import 'dart:convert';
import 'dart:io';

import 'package:device_info/device_info.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:horizon/src/helper/custom_trace.dart';
import 'package:horizon/src/model/DeviceDetails.dart';
import 'package:horizon/src/model/Setting.dart';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

ValueNotifier<Setting> setting = new ValueNotifier(new Setting());
ValueNotifier<DeviceDetailsModel> detailsModel = new ValueNotifier(new DeviceDetailsModel(identifier: "unknown"));

final navigatorKey = GlobalKey<NavigatorState>();

Future<Setting> initSettings() async {
  Setting _setting;
  final String url = '${GlobalConfiguration().getValue('api_base_url')}settings';
  try {
    final response = await http.get(url, headers: {HttpHeaders.contentTypeHeader: 'application/json','x-access-token':'123456'});
    if (response.statusCode == 201) {
      print("correct");
      if (json.decode(response.body)['data'] != null) {
        // SharedPreferences.setMockInitialValues({});

        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('settings', json.encode(json.decode(response.body)['data']));
        _setting = Setting.fromJSON(json.decode(response.body)['data']);
        if (prefs.containsKey('language')) {
          _setting.mobileLanguage.value = Locale(prefs.get('language'), '');
        }
        _setting.brightness.value = prefs.getBool('isDark') ?? false ? Brightness.dark : Brightness.light;
        setting.value = _setting;
        // ignore: invalid_use_of_visible_for_testing_member, invalid_use_of_protected_member
        setting.notifyListeners();
      }
    } else {
      print(CustomTrace(StackTrace.current, message: response.body).toString());
    }
  } catch (e) {
    print(CustomTrace(StackTrace.current, message: url).toString());
    return Setting.fromJSON({});
  }
  return setting.value;
}


void setBrightness(Brightness brightness) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  if (brightness == Brightness.dark) {
    prefs.setBool("isDark", true);
    brightness = Brightness.dark;
  } else {
    prefs.setBool("isDark", false);
    brightness = Brightness.light;
  }
}



Future<dynamic> myBackgroundMessageHandler(Map<String, dynamic> message) {
  print("backlee: $message");
  if (message.containsKey('data')) {
    // Handle data message
    final dynamic data = message['data'];
  }

  if (message.containsKey('notification')) {
    // Handle notification message
    final dynamic notification = message['notification'];
  }
}

Future<DeviceDetailsModel>  getDeviceDetails() async {
  String deviceName;
  String deviceVersion;
  String identifier;
  final DeviceInfoPlugin deviceInfoPlugin = new DeviceInfoPlugin();
  DeviceDetailsModel detailsModel=new DeviceDetailsModel();
  try {
    if (Platform.isAndroid) {
      var build = await deviceInfoPlugin.androidInfo;
      deviceName = build.model;
      deviceVersion = build.version.toString();
      identifier = build.androidId;

      detailsModel.deviceName = deviceName;
      detailsModel.identifier = identifier;
      detailsModel.deviceVersion = deviceVersion;

      return detailsModel;

      //UUID for Android
    } else if (Platform.isIOS) {
      var data = await deviceInfoPlugin.iosInfo;
      deviceName = data.name;
      deviceVersion = data.systemVersion;
      identifier = data.identifierForVendor;
      detailsModel.deviceName = deviceName;
      detailsModel.identifier = identifier;
      detailsModel.deviceVersion = deviceVersion;

      return detailsModel;
      //UUID for iOS
    }
  } on PlatformException {
    print('Failed to get platform version');
  }
}
