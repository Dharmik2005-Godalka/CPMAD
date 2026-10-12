import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import '../models/info_item.dart';

class DeviceInfoService {
  static final DeviceInfoPlugin _plugin = DeviceInfoPlugin();

  static Future<List<InfoItem>> getDeviceInfo() async {
    try {
      if (kIsWeb) {
        final info = await _plugin.webBrowserInfo;
        return [
          InfoItem('Platform', 'Web'),
          InfoItem('Browser', info.browserName.name),
          InfoItem('Vendor', info.vendor ?? '-'),
          InfoItem('System', info.platform ?? '-'),
          InfoItem('Language', info.language ?? '-'),
          InfoItem('CPU cores', info.hardwareConcurrency?.toString() ?? '-'),
        ];
      }

      switch (defaultTargetPlatform) {
        case TargetPlatform.android:
          final info = await _plugin.androidInfo;
          return [
            InfoItem('Platform', 'Android'),
            InfoItem('Brand', info.brand),
            InfoItem('Manufacturer', info.manufacturer),
            InfoItem('Model', info.model),
            InfoItem('Android version', info.version.release),
            InfoItem('SDK level', info.version.sdkInt.toString()),
            InfoItem('Hardware', info.hardware),
            InfoItem('Physical device', info.isPhysicalDevice ? 'Yes' : 'No'),
          ];

        case TargetPlatform.iOS:
          final info = await _plugin.iosInfo;
          return [
            InfoItem('Platform', 'iOS'),
            InfoItem('Device name', info.name),
            InfoItem('Model', info.model),
            InfoItem('System', info.systemName),
            InfoItem('Version', info.systemVersion),
            InfoItem('Physical device', info.isPhysicalDevice ? 'Yes' : 'No'),
          ];

        case TargetPlatform.windows:
          final info = await _plugin.windowsInfo;
          return [
            InfoItem('Platform', 'Windows'),
            InfoItem('Computer name', info.computerName),
            InfoItem('Product', info.productName),
            InfoItem('Build number', info.buildNumber.toString()),
            InfoItem('CPU cores', info.numberOfCores.toString()),
            InfoItem('Memory', '${info.systemMemoryInMegabytes} MB'),
          ];

        default:
          return [InfoItem('Platform', defaultTargetPlatform.name)];
      }
    } catch (_) {
      throw Exception('Could not read the device information.');
    }
  }
}
