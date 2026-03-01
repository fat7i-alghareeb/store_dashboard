import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:store_dashboard/utils/colored_print.dart';

class LoggingHttpClient extends http.BaseClient {
  LoggingHttpClient(this._inner);

  final http.Client _inner;

  static int _requestCounter = 0;
  static const int _maxLoggedBodyChars = 4000;
  static const bool _prettyPrintJson = true;
  static const String _divider =
      '======================================================================';
  static const String _subDivider =
      '----------------------------------------------------------------------';

  String _nextRequestId() {
    _requestCounter = (_requestCounter + 1) & 0xFFFFFF;
    return _requestCounter.toRadixString(16).toUpperCase().padLeft(6, '0');
  }

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) async {
    final requestId = _nextRequestId();
    final startedAt = DateTime.now();
    final headers = _sanitizeHeaders(request.headers);
    final requestBody = _extractRequestBody(request);
    final requestBodyForLog = _formatRequestBodyForLog(
      requestBody,
      contentType: request.headers['content-type'],
    );

    printGray(_divider);
    printY(_requestSummaryLine(requestId, request));
    logRequest(
      '#$requestId HTTP ${request.method} ${request.url}',
      data: {'headers': headers, 'body': ?requestBodyForLog},
    );

    printGray(_subDivider);

    try {
      final response = await _inner.send(request);
      final bytes = await response.stream.toBytes();
      final durationMs = DateTime.now().difference(startedAt).inMilliseconds;

      final responseBody = _decodeBodySafely(
        bytes,
        contentType: response.headers['content-type'],
      );

      final formattedBody = _formatResponseBodyForLog(
        responseBody,
        contentType: response.headers['content-type'],
        byteLength: bytes.length,
      );

      final sanitizedResponseHeaders = _sanitizeHeaders(response.headers);

      final tag = '#$requestId HTTP ${request.method} ${request.url}';
      final data = {
        'statusCode': response.statusCode,
        'durationMs': durationMs,
        'headers': sanitizedResponseHeaders,
        'body': formattedBody,
      };

      if (response.statusCode >= 200 && response.statusCode < 300) {
        printG(
          _responseSummaryLine(
            requestId,
            request,
            statusCode: response.statusCode,
            durationMs: durationMs,
            byteLength: bytes.length,
          ),
        );
        logSuccess(tag, data: data);
      } else {
        printR(
          _responseSummaryLine(
            requestId,
            request,
            statusCode: response.statusCode,
            durationMs: durationMs,
            byteLength: bytes.length,
          ),
        );
        logFailure(tag, data);
      }

      printGray(_divider);

      return http.StreamedResponse(
        http.ByteStream.fromBytes(bytes),
        response.statusCode,
        contentLength: bytes.length,
        request: response.request,
        headers: response.headers,
        isRedirect: response.isRedirect,
        persistentConnection: response.persistentConnection,
        reasonPhrase: response.reasonPhrase,
      );
    } catch (e, s) {
      logFailure(
        '#$requestId HTTP ${request.method} ${request.url}',
        e,
        stackTrace: s,
      );
      printGray(_divider);
      rethrow;
    }
  }

  String? _extractRequestBody(http.BaseRequest request) {
    if (request is http.Request) {
      return request.body;
    }

    if (request is http.MultipartRequest) {
      return {
        'fields': request.fields,
        'files': request.files
            .map(
              (f) => {
                'field': f.field,
                'filename': f.filename,
                'length': f.length,
                'contentType': f.contentType.toString(),
              },
            )
            .toList(growable: false),
      }.toString();
    }

    return null;
  }

  String _decodeBodySafely(List<int> bytes, {required String? contentType}) {
    if (bytes.isEmpty) return '';

    try {
      final charset = _extractCharset(contentType);
      if (charset != null && charset.toLowerCase() != 'utf-8') {
        return utf8.decode(bytes, allowMalformed: true);
      }
      return utf8.decode(bytes, allowMalformed: true);
    } catch (_) {
      return base64Encode(bytes);
    }
  }

  String? _formatRequestBodyForLog(
    String? body, {
    required String? contentType,
  }) {
    if (body == null) return null;
    if (!_isTextContentType(contentType)) {
      return '<non-text request body content-type=${contentType ?? 'unknown'}>';
    }
    return _truncate(body);
  }

  String _formatResponseBodyForLog(
    String body, {
    required String? contentType,
    required int byteLength,
  }) {
    if (!_isTextContentType(contentType)) {
      return '<binary body: $byteLength bytes, content-type=${contentType ?? 'unknown'}>';
    }

    var output = body;

    if (_prettyPrintJson &&
        _looksLikeJson(contentType: contentType, body: body)) {
      final pretty = _tryPrettyPrintJson(body);
      if (pretty != null) {
        output = pretty;
      }
    }

    return _truncate(output);
  }

  bool _isTextContentType(String? contentType) {
    if (contentType == null) return true;
    final ct = contentType.toLowerCase();
    if (ct.startsWith('text/')) return true;
    if (ct.contains('application/json')) return true;
    if (ct.contains('application/xml')) return true;
    if (ct.contains('application/x-www-form-urlencoded')) return true;
    if (ct.contains('application/graphql')) return true;
    return false;
  }

  bool _looksLikeJson({required String? contentType, required String body}) {
    final ct = contentType?.toLowerCase() ?? '';
    if (ct.contains('application/json')) return true;

    final trimmed = body.trimLeft();
    return trimmed.startsWith('{') || trimmed.startsWith('[');
  }

  String? _tryPrettyPrintJson(String raw) {
    try {
      final decoded = jsonDecode(raw);
      const encoder = JsonEncoder.withIndent('  ');
      return encoder.convert(decoded);
    } catch (_) {
      return null;
    }
  }

  String _truncate(String text) {
    if (text.length <= _maxLoggedBodyChars) return text;
    final head = text.substring(0, _maxLoggedBodyChars);
    return '$head\n... [TRUNCATED ${text.length - _maxLoggedBodyChars} chars]';
  }

  String _requestSummaryLine(String requestId, http.BaseRequest request) {
    final url = request.url;
    final path = url.hasQuery ? '${url.path}?${url.query}' : url.path;
    return '#$requestId → ${request.method} ${url.scheme}://${url.host}$path';
  }

  String _responseSummaryLine(
    String requestId,
    http.BaseRequest request, {
    required int statusCode,
    required int durationMs,
    required int byteLength,
  }) {
    final url = request.url;
    final path = url.hasQuery ? '${url.path}?${url.query}' : url.path;
    return '#$requestId ← $statusCode ${request.method} ${url.scheme}://${url.host}$path (${durationMs}ms, ${byteLength}b)';
  }

  String? _extractCharset(String? contentType) {
    if (contentType == null) return null;

    final parts = contentType.split(';');
    for (final part in parts) {
      final trimmed = part.trim();
      if (trimmed.toLowerCase().startsWith('charset=')) {
        return trimmed.substring('charset='.length);
      }
    }
    return null;
  }

  Map<String, String> _sanitizeHeaders(Map<String, String> headers) {
    final sanitized = <String, String>{};
    for (final entry in headers.entries) {
      final keyLower = entry.key.toLowerCase();
      if (keyLower == 'authorization' || keyLower == 'apikey') {
        sanitized[entry.key] = '***';
      } else {
        sanitized[entry.key] = entry.value;
      }
    }
    return sanitized;
  }
}
