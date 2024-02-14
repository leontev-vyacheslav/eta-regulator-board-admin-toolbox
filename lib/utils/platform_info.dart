import 'dart:io';

class PlatformInfo {
  static final bool isDesktopOS = Platform.isMacOS || Platform.isLinux || Platform.isWindows;
}
