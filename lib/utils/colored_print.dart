// 🌎 Project imports:

// Blue text
import 'package:flutter/foundation.dart';
import 'package:store_dashboard/utils/extensions/date_time_extensions.dart'
    show DateTimeFormattingExtensions;

String _cpNow() => DateTime.now().toFullDateTime();

const int _cpChunkSize = 800;

void _printAnsi(String colorCode, Object? msg) {
  if (!kDebugMode) return;

  final text = msg?.toString() ?? '';
  final lines = text.split('\n');
  for (final line in lines) {
    if (line.isEmpty) {
      debugPrint('$colorCode\x1B[0m');
      continue;
    }

    for (var i = 0; i < line.length; i += _cpChunkSize) {
      final end = (i + _cpChunkSize < line.length)
          ? i + _cpChunkSize
          : line.length;
      final chunk = line.substring(i, end);
      debugPrint('$colorCode$chunk\x1B[0m');
    }
  }
}

void logRequest(String tag, {Object? data}) {
  final msg = data == null
      ? '[${_cpNow()}] [REQ] $tag'
      : '[${_cpNow()}] [REQ] $tag\n$data';
  printY(msg);
}

void logSuccess(String tag, {Object? data}) {
  final msg = data == null
      ? '[${_cpNow()}] [OK] $tag'
      : '[${_cpNow()}] [OK] $tag\n$data';
  printG(msg);
}

void logFailure(String tag, Object error, {StackTrace? stackTrace}) {
  final msg = stackTrace == null
      ? '[${_cpNow()}] [ERR] $tag\n$error'
      : '[${_cpNow()}] [ERR] $tag\n$error\n$stackTrace';
  printR(msg);
}

// Green text
void printG(Object? msg) {
  _printAnsi('\x1B[32m', msg);
}

// Yellow text
void printY(Object? msg) {
  _printAnsi('\x1B[33m', msg);
}

// Red text
void printR(Object? msg) {
  _printAnsi('\x1B[31m', msg);
}

// white text
void printW(Object? msg) {
  _printAnsi('\x1B[37m', msg);
}

// black text
void printK(Object? msg) {
  _printAnsi('\x1B[30m', msg);
}

// Additional colors and bright variants
// Magenta text
void printM(Object? msg) {
  _printAnsi('\x1B[35m', msg);
}

// Light/Bright variants
void printLR(Object? msg) {
  _printAnsi('\x1B[91m', msg);
}

void printLG(Object? msg) {
  _printAnsi('\x1B[92m', msg);
}

void printLY(Object? msg) {
  _printAnsi('\x1B[93m', msg);
}

void printLB(Object? msg) {
  _printAnsi('\x1B[94m', msg);
}

void printLM(Object? msg) {
  _printAnsi('\x1B[95m', msg);
}

void printLC(Object? msg) {
  _printAnsi('\x1B[96m', msg);
}

void printLW(Object? msg) {
  _printAnsi('\x1B[97m', msg);
}

// Gray (bright black)
void printGray(Object? msg) {
  _printAnsi('\x1B[90m', msg);
}

void printO(Object? msg) {
  _printAnsi('\x1B[38;5;208m', msg);
}

void printP(Object? msg) {
  _printAnsi('\x1B[38;5;13m', msg);
}

void printPink(Object? msg) {
  _printAnsi('\x1B[38;5;205m', msg);
}
