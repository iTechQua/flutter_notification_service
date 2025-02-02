import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_notification_service/flutter_notification_service.dart';

class NotificationHomePage extends StatefulWidget {
  const NotificationHomePage({Key? key}) : super(key: key);

  @override
  State<NotificationHomePage> createState() => _NotificationHomePageState();
}

class _NotificationHomePageState extends State<NotificationHomePage> {
  late NotificationService _notificationService;
  String? _fcmToken;
  bool _notificationsEnabled = false;

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notification Service'),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [  // FCM Token Display
              if (_fcmToken != null)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'FCM Token: ${_fcmToken!.substring(0, 20)}...',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ),

              // FCM Topic Subscription
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: () => _subscribeToTopic('news'),
                      child: const Text('Subscribe to News'),
                    ),
                    ElevatedButton(
                      onPressed: () => _unsubscribeFromTopic('news'),
                      child: const Text('Unsubscribe from News'),
                    ),
                  ],
                ),
              ),

              // Request Permission Button (for iOS)
              if (Platform.isIOS)
                ElevatedButton(
                  onPressed: () async {
                    final granted = await _notificationService.requestFCMPermission();
                    setState(() {
                      _notificationsEnabled = granted;
                    });
                  },
                  child: const Text('Request FCM Permission'),
                ),


              // Delete FCM Token
              ElevatedButton(
                onPressed: () async {
                  await _notificationService.deleteFCMToken();
                  setState(() {
                    _fcmToken = null;
                  });
                },
                child: const Text('Delete FCM Token'),
              ),
              ElevatedButton(
                onPressed: () {
                  _notificationService.showNotification(
                      title: 'Instant Notification',
                      body: 'This is an instant notification.',
                      payload: 'meeting_id_12345'
                  );
                },
                child: const Text('Show Instant Notification'),
              ),
              ElevatedButton(
                onPressed: () {
                  final scheduledTime = DateTime.now().add(const Duration(seconds: 10));
                  _notificationService.showNotification(
                      title: 'Scheduled Notification',
                      body: 'This notification is scheduled 10 seconds later.',
                      scheduledTime: scheduledTime,
                      payload: 'meeting_id_123456'
                  );
                },
                child: const Text('Show Scheduled Notification'),
              ),
              ElevatedButton(
                onPressed: () {
                  _notificationService.showNotification(
                    title: 'Notification with Sound',
                    body: 'This notification has sound.',
                  );
                },
                child: const Text('Show Notification with Sound'),
              ),
              ElevatedButton(
                onPressed: () {
                  showNotificationWithActions();
                },
                child: const Text('Show Notification with Action'),
              ),
              ElevatedButton(
                onPressed: () {
                  _notificationService.showNotification(
                    title: 'Notification without Sound',
                    body: 'This notification is silent.',
                    withSound: false,
                  );
                },
                child: const Text('Show Silent Notification'),
              ),
              ElevatedButton(
                onPressed: () {
                  _notificationService.showNotification(
                    title: 'Notification with Image',
                    body: 'This notification displays an image.',
                    imagePath: 'https://img.freepik.com/premium-vector/abstract-colorful-bird-logo-design_650075-1526.jpg',
                  );
                },
                child: const Text('Show Notification with Image'),
              ),
              ElevatedButton(
                onPressed: () {
                  final scheduledTime = DateTime.now().add(const Duration(minutes: 1));
                  _notificationService.showNotification(
                    title: 'Scheduled Notification with Sound',
                    body: 'This notification is scheduled with sound.',
                    scheduledTime: scheduledTime,
                  );
                },
                child: const Text('Scheduled Notification with Sound'),
              ),
              ElevatedButton(
                onPressed: () {
                  final scheduledTime = DateTime.now().add(const Duration(seconds: 20));
                  _notificationService.showNotification(
                    title: 'Scheduled Notification without Sound',
                    body: 'This notification is scheduled without sound.',
                    scheduledTime: scheduledTime,
                    withSound: false,
                  );
                },
                child: const Text('Scheduled Silent Notification'),
              ),
              ElevatedButton(
                onPressed: () {
                  final scheduledTime = DateTime.now().add(const Duration(seconds: 30));
                  _notificationService.showNotification(
                    title: 'Scheduled Notification with Image',
                    body: 'This notification is scheduled with an image.',
                    scheduledTime: scheduledTime,
                    imagePath: 'https://img.freepik.com/premium-vector/dancing-fish-logo-designs_94202-134.jpg',
                  );
                },
                child: const Text('Scheduled Notification with Image'),
              ),
              ElevatedButton(
                onPressed: () {
                  _notificationService.showNotification(
                    title: 'Immediate Notification with Sound and Image',
                    body: 'This notification has sound and displays an image.',
                    imagePath: 'https://static.vecteezy.com/system/resources/thumbnails/047/656/219/small_2x/abstract-logo-design-for-any-corporate-brand-business-company-vector.jpg',
                  );
                },
                child: const Text('Instant Notification with Sound and Image'),
              ),
              ElevatedButton(
                onPressed: () {
                  final scheduledTime = DateTime.now().add(const Duration(seconds: 45));
                  _notificationService.showNotification(
                    title: 'Scheduled Full Feature Notification',
                    body: 'Scheduled notification with sound and image.',
                    scheduledTime: scheduledTime,
                    imagePath: 'https://img.freepik.com/premium-vector/animals-pets-logo-template_1286368-88398.jpg',
                  );
                },
                child: const Text('Scheduled Full Feature Notification'),
              ),
              ElevatedButton(
                onPressed: () {
                  _notificationService.showNotification(
                    title: 'Quick Alert',
                    body: 'This is a quick alert notification.',
                  );
                },
                child: const Text('Quick Alert Notification'),
              ),
              ElevatedButton(
                onPressed: () {
                  _notificationService.showNotification(
                    title: 'Low Priority Notification',
                    body: 'This notification is of low priority.',
                  );
                },
                child: const Text('Low Priority Notification'),
              ),
              ElevatedButton(
                onPressed: () {
                  final scheduledTime = DateTime.now().add(const Duration(seconds: 15));
                  _notificationService.showNotification(
                    title: 'Reminder',
                    body: 'This is a scheduled reminder.',
                    scheduledTime: scheduledTime,
                  );
                },
                child: const Text('Reminder Notification'),
              ),
              ElevatedButton(
                onPressed: () {
                  _notificationService.showNotification(
                    title: 'Task Completed',
                    body: 'Your task has been completed successfully.',
                  );
                },
                child: const Text('Task Completion Notification'),
              ),
              ElevatedButton(
                onPressed: () {
                  _notificationService.showNotification(
                    title: 'Meeting Alert',
                    body: 'You have a meeting scheduled at 3 PM.',
                  );
                },
                child: const Text('Meeting Notification'),
              ),
              ElevatedButton(
                onPressed: () {
                  _notificationService.showNotification(
                    title: 'Weather Update',
                    body: 'Rain is expected tomorrow.',
                  );
                },
                child: const Text('Weather Notification'),
              ),
              ElevatedButton(
                onPressed: () {
                  _notificationService.showNotification(
                    title: 'Promotion Alert',
                    body: 'Check out our latest discounts!',
                  );
                },
                child: const Text('Promotion Notification'),
              ),
              ElevatedButton(
                onPressed: () {
                  _notificationService.cancelAllNotifications();
                },
                child: const Text('Cancel All Notifications'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


class NotificationDetailsPage extends StatelessWidget {
  final String payload;

  const NotificationDetailsPage({Key? key, required this.payload}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notification Details'),
      ),
      body: Center(
        child: Text('Notification Payload: $payload'),
      ),
    );
  }
}
