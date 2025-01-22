library flutter_notification_service;

export 'src/notification_service.dart';
import 'flutter_notification_service_platform_interface.dart';

class FlutterNotificationService {
  Future<String?> getPlatformVersion() {
    return FlutterNotificationServicePlatform.instance.getPlatformVersion();
  }
}
