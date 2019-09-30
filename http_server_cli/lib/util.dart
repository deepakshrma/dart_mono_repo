import 'dart:io';

bool isTrue(String val) {
  return val == 'true';
}

void log(isVerbose, message) {
  if (isVerbose) print(message);
}

void error(String message) {
  stderr.writeln(message);
}
