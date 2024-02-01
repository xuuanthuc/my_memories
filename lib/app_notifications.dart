import 'package:firebase_messaging/firebase_messaging.dart';

class AppNotificationOptions {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  void init() async {
    await _firebaseMessaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
  }
}
