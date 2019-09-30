import 'dart:async';
import 'dart:io';
import 'package:http_server/http_server.dart';

import 'package:http_server_cli/util.dart';

Directory _app_home = Directory.current;

void serveNotFound(HttpRequest request) {
  final message = 'Not Found ${request.method} ${request.uri.path}';
  error(message);
  request.response.write(message);
  request.response.close();
}

startServer(
    {port = "8080",
    address = "0.0.0.0",
    path: ".",
    index = "true",
    errorPage = "",
    list = "true",
    verbose}) async {
  var staticFiles = new VirtualDirectory(path);
  log(verbose, "Staring VirtualDirectory $path");
  if (isTrue(list)) {
    staticFiles.allowDirectoryListing = true;
  }
  if (errorPage.toString().isNotEmpty) {
    staticFiles.errorPageHandler = (request) /*2*/ {
      log(verbose, "Not Found: GET ${request.uri.path}");
      var indexUri = Uri.file("${_app_home.path}/$path/").resolve(errorPage);
      File indexFile = File(indexUri.toFilePath());
      log(verbose, "serving page: $indexUri");
      if (indexFile.existsSync()) {
        log(verbose, "serving page: $indexUri");
        staticFiles.serveFile(indexFile, request); /*3*/
      } else {
        serveNotFound(request);
      }
    };
  }

  runZoned(() {
    log(verbose, "Binding on port: $port");
    HttpServer.bind(address, int.parse(port)).then((server) {
      log(verbose, 'Server running on: http://$address:$port');
      server.listen(staticFiles.serveRequest);
    });
  }, onError: (e, stackTrace) => print('Something wrong! $e $stackTrace'));
}
