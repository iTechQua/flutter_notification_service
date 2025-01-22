<div align="center">
<a href="https://pub.dev/packages/flutter_notification_service/"><img src="https://img.shields.io/pub/v/flutter_notification_service.svg" /></a>
<a href="https://opensource.org/licenses/MIT" target="_blank"><img src="https://img.shields.io/badge/License-MIT-yellow.svg"/></a>
<a href="https://opensource.org/licenses/Apache-2.0" target="_blank"><img src="https://badges.frapsoft.com/os/v1/open-source.svg?v=102"/></a>
<a href="https://github.com/iTechQua/flutter_notification_service/issues" target="_blank"><img alt="GitHub: bhoominn" src="https://img.shields.io/github/issues-raw/iTechQua/flutter_notification_service?style=flat" /></a>
<img src="https://img.shields.io/github/last-commit/iTechQua/flutter_notification_service" />

<a href="https://discord.com/channels/854023838136533063/854023838576672839" target="_blank"><img src="https://img.shields.io/discord/854023838136533063" /></a>
<a href="https://github.com/iTechQua"><img alt="GitHub: bhoominn" src="https://img.shields.io/github/followers/iTechQua?label=Follow&style=social" /></a>
<a href="https://github.com/iTechQua/flutter_notification_service"><img src="https://img.shields.io/github/stars/iTechQua/flutter_notification_service?style=social" /></a>

<a href="https://saythanks.io/to/iTechQua" target="_blank"><img src="https://img.shields.io/badge/Say%20Thanks-!-1EAEDB.svg"/></a>
<a href="https://github.com/sponsors/iTechQua"><img src="https://img.shields.io/github/sponsors/iTechQua" /></a>

<a href="https://www.buymeacoffee.com/iTechQua"><img src="https://img.buymeacoffee.com/button-api/?text=Buy me a coffee&emoji=&slug=bhoominn&button_colour=5F7FFF&font_colour=ffffff&font_family=Cookie&outline_colour=000000&coffee_colour=FFDD00"></a>

</div>

## Show some love and like to support the project

### Say Thanks Here
<a href="https://saythanks.io/to/iTechQua" target="_blank"><img src="https://img.shields.io/badge/Say%20Thanks-!-1EAEDB.svg"/></a>

### Follow Me on Twitter
<a href="https://x.com/iTechQua" target="_blank"><img src="https://img.shields.io/twitter/follow/iTechQua?color=1DA1F2&label=Followers&logo=twitter" /></a>

## Platform Support

| Android | iOS | MacOS  | Web | Linux | Windows |
| :-----: | :-: | :---:  | :-: | :---: | :-----: |
|   ✔️    | ✔️  |  ✔️   | ✔️  |  ✔️   |   ✔️   |

## Installation

*** follow `flutter_local_notifications` installation setup ***
Add this package to `pubspec.yaml` as follows:

```console
$ flutter pub add flutter_notification_service
```

Import package

```dart
import 'package:flutter_notification_service/flutter_notification_service.dart';
```

Initialize flutter_notification_service in main.dart file for initializing Shared Preferences and other variables.
Also you can assign your Chat GPT key here.

## Contents
- [Flutter Notification Service](#flutter-notification-services)

```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(MyApp());
}
```

## Flutter notification services
```dart
/// Pass your audio file 'notification_music.mp3' in res/raw folder and 'app_icon.png' in res/drawable folder inside android/app/src/main then implement below code where you need local notification
late NotificationService _notificationService;
// Create a custom notification configuration (optional)
final NotificationConfig _customConfig = NotificationConfig(
  androidAppIcon: 'app_icon', // Custom app icon
  assetAppIcon: 'icons/app_icon.png', // Custom asset app icon
  androidChannelId: 'my_app_channel',
  androidChannelName: 'My App Notifications',
  androidChannelDescription: 'Notifications for my awesome app',
  notificationSoundResource: 'notification_sound', // Custom sound
);

@override
void initState() {
  super.initState();

  _initializeNotifications();
}

Future<void> _initializeNotifications() async {
  // Initialize notification service with custom config and handlers
  _notificationService = NotificationService(config: _customConfig)
    ..initialize(
      onNotificationTap: _handleNotificationTap,
      onForegroundMessage: _handleForegroundMessage,
      onMessageOpenedApp: _handleMessageOpenedApp,
    );

  // Check if notifications are enabled
  _notificationsEnabled = _notificationService.isNotificationPermissionGranted;

  // Get FCM token
  _fcmToken = _notificationService.fcmToken;
  setState(() {});
}

// Handle local notification tap
void _handleNotificationTap(NotificationResponse response) {
  if (kDebugMode) {
    print('Notification tapped');
    print('Payload: ${response.payload}');
    print('Action ID: ${response.actionId}');
  }

  if (response.payload != null) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => NotificationDetailsPage(
          payload: response.payload!,
        ),
      ),
    );
  }
}

// Handle FCM foreground message
void _handleForegroundMessage(RemoteMessage message) {
  if (kDebugMode) {
    print('Received foreground message:');
    print('Title: ${message.notification?.title}');
    print('Body: ${message.notification?.body}');
    print('Data: ${message.data}');
  }
}

// Handle FCM message when app is opened from notification
void _handleMessageOpenedApp(RemoteMessage message) {
  if (kDebugMode) {
    print('App opened from notification:');
    print('Title: ${message.notification?.title}');
    print('Body: ${message.notification?.body}');
    print('Data: ${message.data}');
  }

  // Navigate based on the message data
  if (message.data['screen'] != null) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => NotificationDetailsPage(
          payload: message.data.toString(),
        ),
      ),
    );
  }
}

// Subscribe to FCM topic
Future<void> _subscribeToTopic(String topic) async {
  await _notificationService.subscribeToTopic(topic);
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text('Subscribed to topic: $topic')),
  );
}

// Unsubscribe from FCM topic
Future<void> _unsubscribeFromTopic(String topic) async {
  await _notificationService.unsubscribeFromTopic(topic);
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text('Unsubscribed from topic: $topic')),
  );
}

// Example of a notification with Android actions
Future<void> showNotificationWithActions() async {
  // Create a notification config with Android actions
  final config = NotificationConfig(
    androidActionCategories: [
      const NotificationCategory(
        identifier: 'custom_android_category',
        actions: [
          NotificationAction(
                  id: 'custom_action_1',
                  title: 'Custom Action 1',
                  iconPath: 'icons/coworker.png'
          ),
          NotificationAction(
                  id: 'custom_action_2',
                  title: 'Custom Action 2',
                  iconPath: 'icons/coworker.png'
          ),
        ],
      ),
    ],
  );

  // Initialize the NotificationService with this config
  final notificationService = NotificationService(config: config);

  // Explicitly process actions
  await notificationService.initialize();

  // Show the notification with actions
  notificationService.showNotification(
    title: 'Interactive Notification',
    body: 'This notification has multiple actions',
    // Optional: Add extra customization
    color: Colors.blue,
    enableLights: true,
    ledColor: Colors.green,
    ledOnMs: 1000, // LED on duration in milliseconds
    ledOffMs: 500, // LED off duration in milliseconds
  );
}

```

## Features and bugs

Please file feature requests and bugs at the [issue tracker][tracker].

[tracker]: https://github.com/iTechQua/flutter_notification_service/issues

## ⭐ If you like the package, a star to the repo will mean a lot.

## You can also contribute by adding new widgets or helpful methods.

## If you want to give suggestion, please contact me via email - bhoominn@gmail.com

## Thank you ❤
