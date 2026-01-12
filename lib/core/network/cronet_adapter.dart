import 'dart:async';
import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:cronet_http/cronet_http.dart';
import 'package:http/http.dart' as http;

/// A simple adapter to usage cronet_http with Dio.
/// Note: This is a basic implementation for GET requests primarily used for fetching feed.
class CronetAdapter implements HttpClientAdapter {
  final http.Client _client;

  CronetAdapter() : _client = CronetClient.defaultCronetEngine();

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    final uri = options.uri;
    final request = http.Request(options.method, uri);
    
    // Copy headers
    options.headers.forEach((k, v) {
      request.headers[k] = v.toString();
    });

    // Handle body if present (simplified)
    if (options.data != null) {
      // In a real adapter, we'd handle various body types. 
      // For this specific task of "fetch data", we assume simple JSON or params.
      if (options.data is String) {
        request.body = options.data;
      }
      // Add other types if needed
    }

    final http.StreamedResponse response = await _client.send(request);
    
    return ResponseBody(
      response.stream.cast<Uint8List>(),
      response.statusCode,
      headers: Map.fromEntries(
        response.headers.entries.map((e) => MapEntry(e.key, [e.value])),
      ),
      statusMessage: response.reasonPhrase,
      isRedirect: response.isRedirect,
    );
  }

  @override
  void close({bool force = false}) {
    _client.close();
  }
}
