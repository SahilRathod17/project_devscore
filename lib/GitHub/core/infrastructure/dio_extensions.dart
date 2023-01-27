import 'dart:io';
import 'package:dio/dio.dart';

extension DioErrorX on DioError {
  bool get isNoConnection {
    return type == DioErrorType.other && error is SocketException;
  }
}
