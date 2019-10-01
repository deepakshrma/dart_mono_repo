bool isTrue(String val) {
  return val == 'true';
}

void onError(dynamic e, dynamic stackTrace) {
  print('Something wrong! $e $stackTrace');
}

/// Log is simple util to print color message
mixin Log {
  /// log levels [0,1,2,3] debug<>info<>warn<>error<>fatal, default[0]
  static int level = 0;

  static String _time() {
    return DateTime.now().toIso8601String();
  }

  /// logging in debug

  static void d(String message) {
    if (level == 0) {
      print('\u{1B}[39m${_time()} $message\u{1B}[0m');
    }
  }

  /// logging in info, {forced} to print even log level is high

  static void i(String message, {bool forced = false}) {
    if (level <= 1 || forced) {
      print('\u{1B}[36m${_time()} $message\u{1B}[0m');
    }
  }

  /// logging in warn, {forced} to print even log level is high

  static void w(String message, {bool forced = false}) {
    if (level <= 2 || forced) {
      print('\u{1B}[33m${_time()} $message\u{1B}[0m');
    }
  }

  /// logging in error, {forced} to print even log level is high

  static void e(String message, {bool forced = false}) {
    if (level <= 3 || forced) {
      print('\u{1B}[31m${_time()} $message\u{1B}[0m');
    }
  }

  /// logging in fatal, {forced} to print even log level is high

  static void f(StackTrace ex) {
    print('\u{1B}[31m${_time()} $ex\u{1B}[0m');
  }
}
