import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:isolate';

import 'package:flutter/foundation.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:horizon/src/model/NotificationModel.dart';
import 'package:horizon/src/model/UploadItem.dart';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

Map<String, UploadItem> tasks = {};

bool initialized = false;


List<NotificationModel> notifications=[];


const String countKey = 'count';

/// The name associated with the UI isolate's [SendPort].
const String isolateName = 'isolate';

/// A port used to communicate from a background isolate to the UI isolate.
final ReceivePort port = ReceivePort();

/// Global [SharedPreferences] object.
SharedPreferences prefs;

FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

ValueNotifier<int> total_client_notifications = new ValueNotifier(0);
ValueNotifier<int> total_admin_notifications = new ValueNotifier(0);


showNotification(String body, String title, payload) async {
  var androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'your channel id', 'your channel name', 'your channel description',
      importance: Importance.Max, priority: Priority.High, ticker: 'ticker');
  var iOSPlatformChannelSpecifics = IOSNotificationDetails();
  var platformChannelSpecifics = NotificationDetails(
      androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
  await flutterLocalNotificationsPlugin
      .show(0, title, body, platformChannelSpecifics, payload: payload);
}


Future<int> log_activity(Map map) async {
  print("#adding log");
  final String url = '${GlobalConfiguration().getValue('api_base_url')}activity/log';
  final client = new http.Client();
  try{
    final response = await client.post(
      url,
      headers: {HttpHeaders.contentTypeHeader: 'application/json'},
      body: json.encode(map),
    );
    if(response.statusCode==201) {
      return 201;
    }
    else{
      return null;
    }
  }on TimeoutException catch (e) {
    return  null;
    print(' Timeout Error: $e');
  } on SocketException catch (e) {
    return  null;
    print(' Socket Error: $e');
  } on Error catch (e) {
    return  null;
    print(' General Error: $e');
  }

}
