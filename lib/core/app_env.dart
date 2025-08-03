import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class AppEnv {
  static String appAdId = "";
  static String unitAdId = "";

  static Future<void> load() async {
    await dotenv.load();
    appAdId = dotenv.env['APP_AD_ID']!;
    unitAdId = kDebugMode ? 'ca-app-pub-3940256099942544/9214589741' : dotenv.env['UNIT_AD_ID']!;
  }
}
