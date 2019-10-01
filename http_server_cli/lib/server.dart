import 'dart:async';
import 'dart:io';
import 'package:http_server/http_server.dart';

import 'package:http_server_cli/util.dart';

Directory _appHome = Directory.current;

/// Server
class Server {
  factory Server() {
    throw 'Server can\'t be initiat';
  }

  /// _serveNotFound to send Page Not Found
  static void _serveNotFound(HttpRequest request) {
    final String message =
        'Page Not Found ${request.method} ${request.uri.path}';
    Log.w(message);
    request.response.write(message);
    request.response.close();
  }

  /// start server with named parameter
  /// Default values are
  /// port = '8080',
  /// address = '0.0.0.0',
  /// path = '.',
  /// index = 'true',
  /// errorPage = '',
  /// list = 'true',
  static Future<void> start({
    String port,
    String address,
    String path,
    String errorPage,
    bool index,
    bool list,
  }) async {
    final VirtualDirectory staticFiles = VirtualDirectory(path);
    Log.i('Staring VirtualDirectory $path');
    if (list) {
      staticFiles.allowDirectoryListing = true;
    }
    if (errorPage.toString().isNotEmpty) {
      staticFiles.errorPageHandler = (HttpRequest request) {
        Log.i('Not Found: GET ${request.uri.path}');
        final Uri indexUri =
            Uri.file('${_appHome.path}/$path/').resolve(errorPage);
        final File indexFile = File(indexUri.toFilePath());
        Log.i('serving page: $indexUri');
        if (indexFile.existsSync()) {
          Log.i('serving page: $indexUri');
          staticFiles.serveFile(indexFile, request); /*3*/
        } else {
          _serveNotFound(request);
        }
      };
    }
    runZoned(() {
      Log.i('Binding on port: $port');
      HttpServer.bind(address, int.parse(port)).then((HttpServer server) {
        Log.i('Server running on: http://$address:$port');
        server.listen(staticFiles.serveRequest);
      });
    }, onError: onError);
  }
}
