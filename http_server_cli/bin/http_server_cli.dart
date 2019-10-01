// ignore_for_file: always_specify_types

import 'dart:io';
import 'package:args/args.dart';

import 'package:http_server_cli/server.dart';
import 'package:http_server_cli/util.dart';

/// List of options available
const List<List<String>> options = [
  ['port', 'p', '8080', 'Port to be used'],
  ['path', 'P', '.', 'Path to serve file'],
  ['address', 'a', '0.0.0.0', 'Address to use'],
  ['ssl', 'S', 'false', 'Enable https'],
  ['cert', 'C', 'config/cert.pem', 'Path to ssl cert file'],
  ['not-found', 'N', '404.html', 'Page Not Found Redirect'],
  ['key', 'K', 'config/key.pem', 'Path to ssl key file']
];

/// List of flags available
const List<List<String>> flags = [
  ['dir', 'd', 'true', 'List Directory'],
  ['index', 'i', 'true', 'Index file to serve'],
  ['silent', 's', 'false', 'Run server on silent mode'],
  ['help', 'h', 'false', 'Show help'],
];

void main(List<String> arguments) {
  ArgResults args;
  final ArgParser parser = ArgParser();
  for (List<String> option in options) {
    parser.addOption(option[0],
        abbr: option[1], defaultsTo: option[2], help: option[3]);
  }
  for (List<String> option in flags) {
    parser.addFlag(option[0],
        abbr: option[1], defaultsTo: isTrue(option[2]), help: option[3]);
  }

  try {
    args = parser.parse(arguments);
    if (args['ssl'] == 'true') {
      Log.e('SSL: Coming soon');
      exit(1);
    }
    final bool lookingForHelp = args['help'];
    if (lookingForHelp) {
      Log.i(parser.usage, forced: true);
      exit(0);
    }
    final bool verbose = !args['silent'];

    /// Set the log level
    Log.level = verbose ? 0 : 3;
    Server.start(
      port: args['port'],
      address: args['address'],
      index: args['index'],
      path: args['path'],
      list: args['dir'],
      errorPage: args['not-found'],
    );
  } catch (e) {
    Log.w(e);
    Log.i(parser.usage, forced: true);
  }
}
