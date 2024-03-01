import 'dart:io';

import 'package:flutter/foundation.dart';

class PlatformInfo {
  static bool isDesktopOS() {
    return !kIsWeb && (Platform.isMacOS || Platform.isLinux || Platform.isWindows);
  }

  static bool isMobile() {
    return !kIsWeb && (Platform.isAndroid || Platform.isIOS);
  }
}
