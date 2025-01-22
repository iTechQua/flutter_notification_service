import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'flutter_notification_service_platform_interface.dart';

/// An implementation of [FlutterNotificationServicePlatform] that uses method channels.
class MethodChannelFlutterNotificationService extends FlutterNotificationServicePlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('flutter_notification_service');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}
