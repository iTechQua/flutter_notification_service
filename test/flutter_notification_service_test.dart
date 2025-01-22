import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_notification_service/flutter_notification_service.dart';
import 'package:flutter_notification_service/flutter_notification_service_platform_interface.dart';
import 'package:flutter_notification_service/flutter_notification_service_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockFlutterNotificationServicePlatform
    with MockPlatformInterfaceMixin
    implements FlutterNotificationServicePlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final FlutterNotificationServicePlatform initialPlatform = FlutterNotificationServicePlatform.instance;

  test('$MethodChannelFlutterNotificationService is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelFlutterNotificationService>());
  });

  test('getPlatformVersion', () async {
    FlutterNotificationService flutterNotificationServicePlugin = FlutterNotificationService();
    MockFlutterNotificationServicePlatform fakePlatform = MockFlutterNotificationServicePlatform();
    FlutterNotificationServicePlatform.instance = fakePlatform;

    expect(await flutterNotificationServicePlugin.getPlatformVersion(), '42');
  });
}
