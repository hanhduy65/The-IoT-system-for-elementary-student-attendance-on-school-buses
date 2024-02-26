import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  //TODO: show notification
}

void _handleOpenedMessage(RemoteMessage mess) {
  print("${mess.data}");
}

void _handledMessage(RemoteMessage mess) {
  //TODO: show notification
}
void _onRenewToken(String token) {
  print("New Token: $token");
}

Future<String?> setupInteractedMessage() async {
  RemoteMessage? initMes = await FirebaseMessaging.instance.getInitialMessage();
  if (initMes != null) {
    _handleOpenedMessage(initMes);
  }
  FirebaseMessaging.onMessageOpenedApp.listen(_handleOpenedMessage);
  FirebaseMessaging.onMessage.listen(_handledMessage);
  FirebaseMessaging.instance.onTokenRefresh.listen(_onRenewToken);
  final fcmToken = await FirebaseMessaging.instance.getToken();
  print("Token FCM : $fcmToken");
  return fcmToken;
}
