#ifndef FLUTTER_PLUGIN_FLUTTER_NOTIFICATION_SERVICE_PLUGIN_H_
#define FLUTTER_PLUGIN_FLUTTER_NOTIFICATION_SERVICE_PLUGIN_H_

#include <flutter/method_channel.h>
#include <flutter/plugin_registrar_windows.h>

#include <memory>

namespace flutter_notification_service {

class FlutterNotificationServicePlugin : public flutter::Plugin {
 public:
  static void RegisterWithRegistrar(flutter::PluginRegistrarWindows *registrar);

  FlutterNotificationServicePlugin();

  virtual ~FlutterNotificationServicePlugin();

  // Disallow copy and assign.
  FlutterNotificationServicePlugin(const FlutterNotificationServicePlugin&) = delete;
  FlutterNotificationServicePlugin& operator=(const FlutterNotificationServicePlugin&) = delete;

  // Called when a method is called on this plugin's channel from Dart.
  void HandleMethodCall(
      const flutter::MethodCall<flutter::EncodableValue> &method_call,
      std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result);
};

}  // namespace flutter_notification_service

#endif  // FLUTTER_PLUGIN_FLUTTER_NOTIFICATION_SERVICE_PLUGIN_H_
