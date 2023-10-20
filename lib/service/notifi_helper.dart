import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
// ignore: depend_on_referenced_packages
import 'package:timezone/timezone.dart' as tz;
// ignore: depend_on_referenced_packages
import 'package:timezone/data/latest.dart' as tz;
import 'package:to_do_list/service/navigation_service.dart';

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
    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onDidReceiveNotificationResponse: (detail) async {
      try {
        final navigasi = NavigationService.navigatorKey;
        await Future.delayed(const Duration(milliseconds: 10), () {
          if (detail.payload == null) {
            throw Exception();
          }
          final note = jsonDecode(detail.payload!) as Map<String, dynamic>;
          final newPayload = Note.fromJson(note);
          navigasi.currentState!.pushNamed('/test', arguments: newPayload);
        });
      } catch (e) {
        throw ();
      }
    });
  }

  Future<void> onSelectNotification(String payload) async {
    // Pindah ke halaman tertentu berdasarkan payload
  }
  scheduledNotification(int hour, int minute, Note note) async {
    final payload = jsonEncode(note.toJson());
    await flutterLocalNotificationsPlugin.zonedSchedule(
        note.id!.toInt(),
        '${note.title}',
        'Your Task  ${note.remind} Left',
        _convertTime(hour, minute - note.remind!, note),
        const NotificationDetails(
            android: AndroidNotificationDetails(
          'your channel id',
          'your channel name',
        )),
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.time,
        payload: payload);
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

  tz.TZDateTime _convertTime(int hour, int minute, Note note) {
    List<String>? datePart = note.dateTime?.split(" ")[0].split('-');
    final day = int.parse(datePart![2]);
    final month = int.parse(datePart[1]);

    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduleDate =
        tz.TZDateTime(tz.local, now.year, month, day, hour, minute);
    // if (scheduleDate.isBefore(now)) {
    //   scheduleDate = scheduleDate.add(const Duration(days: 1));
    // }
    return scheduleDate;
  }

  Future _comfigureLocalTimeZone() async {
    tz.initializeTimeZones();
    final String timeZone = await FlutterTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(timeZone));
  }
}
