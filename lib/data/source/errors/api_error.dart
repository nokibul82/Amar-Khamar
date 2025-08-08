import 'dart:async';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../../../utils/services/helpers.dart';

class ApiErrors {
  static Future<http.Response> processResponse(
      http.Response response, dynamic URL) async {
    if (response.headers['content-type']?.contains('application/json') ??
        false) {
      if (response.statusCode == 200) {
        return response;
      }
       else if (response.statusCode == 404) {
        print("=========>>>ERROR WITH $URL<<<<=======${response.body}");
        throw HttpException(
            'Resource not found. Please check the URL. ${response.statusCode}');
      }
       else {
        throw HttpException(
            'HTTP error with status code: ${response.statusCode}');
      }
    } else {
      if (response.statusCode == 404) {
        print("=========>>>ERROR WITH $URL<<<<=======${response.body}");
        throw HttpException(
            'Resource not found. Please check the URL. ${response.statusCode}');
      } else if (response.statusCode == 429) {
        throw FormatException(
            'Too many requests with status code: ${response.statusCode}');
      } else if (response.statusCode == 500) {
        print("=========>>>ERROR WITH $URL<<<<=======${response.body}");
        throw FormatException(
            'Internal server error with status code: ${response.statusCode}');
      } else {
        print("=========>>>ERROR WITH $URL<<<<=======${response.body}");
        throw FormatException(
            'Bad response format with status code: ${response.statusCode}');
      }
    }
  }

  static http.Response handleException(dynamic E, dynamic URL) {
    if (E is TimeoutException) {
      return _handleError('Request timed out. Please try again.', 408, URL);
    } else if (E is SocketException) {
      return _handleError(
          'No Internet connection. Please try again.', 500, URL);
    } else if (E is HttpException) {
      return _handleError(E.message, 500, URL);
    } else if (E is FormatException) {
      return _handleError(E.message, 400, URL);
    } else if (E is http.ClientException) {
      return _handleError('Client error occurred.', 400, URL);
    } else {
      return _handleError('An unexpected error occurred.', 500, URL);
    }
  }

  static http.Response _handleError(
      String message, int statusCode, dynamic URL) {
    print(
        "==========>>>>>>>>>>>>>>>>>ERROR WITH $URL<<<<<<<<<<<<<<<<<<<==========");
    Helpers.showSnackBar(msg: message);
    return http.Response(message, statusCode);
  }
}
