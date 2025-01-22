#include "include/flutter_notification_service/flutter_notification_service_plugin_c_api.h"

#include <flutter/plugin_registrar_windows.h>

#include "flutter_notification_service_plugin.h"

void FlutterNotificationServicePluginCApiRegisterWithRegistrar(
    FlutterDesktopPluginRegistrarRef registrar) {
  flutter_notification_service::FlutterNotificationServicePlugin::RegisterWithRegistrar(
      flutter::PluginRegistrarManager::GetInstance()
          ->GetRegistrar<flutter::PluginRegistrarWindows>(registrar));
}
