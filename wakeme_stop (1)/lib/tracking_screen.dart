import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class TrackingScreen extends StatefulWidget {
  final double destLat;
  final double destLng;

  const TrackingScreen({
    super.key,
    required this.destLat,
    required this.destLng,
  });

  @override
  State<TrackingScreen> createState() => _TrackingScreenState();
}

class _TrackingScreenState extends State<TrackingScreen> {
  Position? currentPosition;
  double distance = 0;
  Timer? timer;

  final FlutterLocalNotificationsPlugin notifications =
      FlutterLocalNotificationsPlugin();

  @override
  void initState() {
    super.initState();
    initLocation();
    initNotifications();
  }

  void initNotifications() async {
    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    const settings = InitializationSettings(android: android);
    await notifications.initialize(settings);
  }

  void showAlert() async {
    const android = AndroidNotificationDetails(
      'alert_channel',
      'Alert',
      importance: Importance.max,
      priority: Priority.high,
    );

    await notifications.show(
      0,
      'Wake Up!',
      'You are near your destination!',
      NotificationDetails(android: android),
    );
  }

  void initLocation() async {
    await Geolocator.requestPermission();

    timer = Timer.periodic(const Duration(seconds: 5), (timer) async {
      Position pos = await Geolocator.getCurrentPosition();
      double d = Geolocator.distanceBetween(
        pos.latitude,
        pos.longitude,
        widget.destLat,
        widget.destLng,
      );

      setState(() {
        currentPosition = pos;
        distance = d;
      });

      if (d < 500) {
        showAlert();
        timer.cancel();
      }
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Tracking")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Distance remaining: ${distance.toStringAsFixed(2)} meters"),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                timer?.cancel();
                Navigator.pop(context);
              },
              child: const Text("Stop"),
            )
          ],
        ),
      ),
    );
  }
}
