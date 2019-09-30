import 'dart:async';
import 'dart:io';
import 'package:http_server/http_server.dart';

import 'package:http_server_cli/util.dart';

Directory _appHome = Directory.current;

void serveNotFound(HttpRequest request) {
  final String message = 'Not Found ${request.method} ${request.uri.path}';
  error(message);
  request.response.write(message);
  request.response.close();
}

Future<void> startServer({
  String port = '8080',
  String address = '0.0.0.0',
  String path = '.',
  String index = 'true',
  String errorPage = '',
  String list = 'true',
  bool verbose = true,
}) async {
  final VirtualDirectory staticFiles = VirtualDirectory(path);
  log(verbose, 'Staring VirtualDirectory $path');
  if (isTrue(list)) {
    staticFiles.allowDirectoryListing = true;
  }
  if (errorPage.toString().isNotEmpty) {
    staticFiles.errorPageHandler = (HttpRequest request) {
      log(verbose, 'Not Found: GET ${request.uri.path}');
      final Uri indexUri =
          Uri.file('${_appHome.path}/$path/').resolve(errorPage);
      final File indexFile = File(indexUri.toFilePath());
      log(verbose, 'serving page: $indexUri');
      if (indexFile.existsSync()) {
        log(verbose, 'serving page: $indexUri');
        staticFiles.serveFile(indexFile, request); /*3*/
      } else {
        serveNotFound(request);
      }
    };
  }

  runZoned(() {
    log(verbose, 'Binding on port: $port');
    HttpServer.bind(address, int.parse(port)).then((HttpServer server) {
      log(verbose, 'Server running on: http://$address:$port');
      server.listen(staticFiles.serveRequest);
    });
  }, onError: onError);
}
