import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'flutter_notification_service_method_channel.dart';

abstract class FlutterNotificationServicePlatform extends PlatformInterface {
  /// Constructs a FlutterNotificationServicePlatform.
  FlutterNotificationServicePlatform() : super(token: _token);

  static final Object _token = Object();

  static FlutterNotificationServicePlatform _instance = MethodChannelFlutterNotificationService();

  /// The default instance of [FlutterNotificationServicePlatform] to use.
  ///
  /// Defaults to [MethodChannelFlutterNotificationService].
  static FlutterNotificationServicePlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [FlutterNotificationServicePlatform] when
  /// they register themselves.
  static set instance(FlutterNotificationServicePlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
