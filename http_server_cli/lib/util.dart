import 'dart:io';

bool isTrue(String val) {
  return val == 'true';
}

void log(bool isVerbose, String message) {
  if (isVerbose) {
    print(message);
  }
}

void error(String message) {
  stderr.writeln(message);
}

void onError(dynamic e, dynamic stackTrace) {
  print('Something wrong! $e $stackTrace');
}
