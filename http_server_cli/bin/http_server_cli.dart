import 'dart:io';
import 'package:args/args.dart';
import 'package:http_server_cli/server.dart';
import 'package:http_server_cli/util.dart';
ArgResults args;
const options = [
  ["port", "p", "8080", "Port to be used"],
  ["path", "P", ".", "Path to serve file"],
  ["dir", "d", "true", "List Directory"],
  ["index", "i", "true", "Index file to serve"],
  ["address", "a", "0.0.0.0", "Address to use"],
  ["ssl", "S", "false", "Enable https"],
  ["cert", "C", "config/cert.pem", "Path to ssl cert file"],
  ["not-found", "N", "", "Page Not Found Redirect"],
  ["key", "K", "config/key.pem", "Path to ssl key file"]
];
const flags = [
  ["silent", "s", false, "Run server on silent mode"],
  ["help", "h", false, "Show help"],
];

void main(List<String> arguments) {
  final parser = ArgParser();
  options.forEach((option) {
    parser.addOption(option[0],
        abbr: option[1], defaultsTo: option[2], help: option[3]);
  });
  flags.forEach((option) {
    parser.addFlag(option[0],
        abbr: option[1], defaultsTo: option[2], help: option[3]);
  });
  try {
    args = parser.parse(arguments);
    if(args["ssl"] == "true") {
      error("SSL: Coming soon");
      exit(1);
    }
    final lookingForHelp = args["help"];
    if(lookingForHelp) {
      print(parser.usage);
      exit(0);
    }
    startServer(
      port: args["port"],
      address: args["address"],
      index: args["index"],
      path: args["path"],
      list: args["dir"],
      errorPage: args["not-found"],
      verbose: !args["silent"] 
    );
  } catch (e) {
    print(parser.usage);
  }
}
