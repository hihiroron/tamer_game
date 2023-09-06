import 'package:package_info_plus/package_info_plus.dart';

class PackageInfoService {
  PackageInfoService();
  late PackageInfo packageInfo;

  Future<void> init() async {
    packageInfo = await PackageInfo.fromPlatform();
  }

  String getVersion() => packageInfo.version;
}
