import 'package:flutter/cupertino.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
// ignore: depend_on_referenced_packages
import 'package:timezone/timezone.dart' as tz;
// ignore: depend_on_referenced_packages
import 'package:timezone/data/latest.dart' as tz;

import '../models/note.dart';

class NotifiHelper {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin(); //

  initializeNotification() async {
    // tz.initializeTimeZones();
    _comfigureLocalTimeZone();
    final String timezone = await FlutterTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(timezone));
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings("ic_launcher");

    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
    );
    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
    );
  }

  scheduledNotification(int hour, int minute, Note note) async {
    await flutterLocalNotificationsPlugin.zonedSchedule(
        note.id!.toInt(),
        '${note.title}',
        'Your Task Start About Right Now',
        _convertTime(hour, minute),
        const NotificationDetails(
            android: AndroidNotificationDetails(
          'your channel id',
          'your channel name',
        )),
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.time);
  }

  displayNotification({required String title, required String body}) async {
    debugPrint("doing test");
    var androidPlatformChannelSpecifics = const AndroidNotificationDetails(
        'your channel id', 'your channel name',
        importance: Importance.max, priority: Priority.high);
    var platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
    );
    await flutterLocalNotificationsPlugin.show(
      0,
      title,
      body,
      platformChannelSpecifics,
      payload: 'It could be anything you pass',
    );
  }

  tz.TZDateTime _convertTime(int hour, int minute) {
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduleDate =
        tz.TZDateTime(tz.local, now.year, now.month, now.day, hour, minute);
    if (scheduleDate.isBefore(now)) {
      scheduleDate = scheduleDate.add(const Duration(days: 1));
    }
    return scheduleDate;
  }

  Future _comfigureLocalTimeZone() async {
    tz.initializeTimeZones();
    final String timeZone = await FlutterTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(timeZone));
  }
}
