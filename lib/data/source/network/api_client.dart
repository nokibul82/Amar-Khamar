import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import '../../../utils/app_constants.dart';
import '../../../utils/services/localstorage/hive.dart';
import '../../../utils/services/localstorage/keys.dart';
import '../errors/api_error.dart';

class ApiClient {
  static String _BASE_URL = AppConstants.baseUrl;
  static const int _TIMEOUT_DURATION = 30; // 30 seconds

  static Map<String, String> _getHeaders() => <String, String>{
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer ${HiveHelp.read(Keys.token) ?? ''}',
      };

  static Future<http.Response> get({required String ENDPOINT_URL}) async {
    try {
      Request request =
          http.Request('GET', Uri.parse(_BASE_URL + ENDPOINT_URL));
      request.headers.addAll(_getHeaders());
      http.StreamedResponse streamedResponse =
          await request.send().timeout(Duration(seconds: _TIMEOUT_DURATION));

      Response response = await http.Response.fromStream(streamedResponse);
      return await ApiErrors.processResponse(
          response, _BASE_URL + ENDPOINT_URL);
    } catch (E) {
      return ApiErrors.handleException(E, _BASE_URL + ENDPOINT_URL);
    }
  }

  static Future<http.Response> post(
      {required String ENDPOINT_URL, Map<String, dynamic>? fields}) async {
    try {
      Request request =
          http.Request('POST', Uri.parse(_BASE_URL + ENDPOINT_URL));
      request.headers.addAll(_getHeaders());
      request.body = json.encode(fields);
      http.StreamedResponse streamedResponse =
          await request.send().timeout(Duration(seconds: _TIMEOUT_DURATION));
      Response response = await http.Response.fromStream(streamedResponse);
      print("response: ${response.statusCode}");
      return await ApiErrors.processResponse(
          response, _BASE_URL + ENDPOINT_URL);
    } catch (E) {
      return ApiErrors.handleException(E, _BASE_URL + ENDPOINT_URL);
    }
  }

  static Future<http.Response> patch({required String ENDPOINT_URL}) async {
    try {
      Request request =
          http.Request('PATCH', Uri.parse(_BASE_URL + ENDPOINT_URL));
      request.headers.addAll(_getHeaders());
      http.StreamedResponse streamedResponse =
          await request.send().timeout(Duration(seconds: _TIMEOUT_DURATION));
      Response response = await http.Response.fromStream(streamedResponse);
      return await ApiErrors.processResponse(
          response, _BASE_URL + ENDPOINT_URL);
    } catch (E) {
      return ApiErrors.handleException(E, _BASE_URL + ENDPOINT_URL);
    }
  }

  static Future<http.Response> put({required String ENDPOINT_URL}) async {
    try {
      Request request =
          http.Request('PUT', Uri.parse(_BASE_URL + ENDPOINT_URL));
      request.headers.addAll(_getHeaders());
      http.StreamedResponse streamedResponse =
          await request.send().timeout(Duration(seconds: _TIMEOUT_DURATION));
      Response response = await http.Response.fromStream(streamedResponse);
      return await ApiErrors.processResponse(
          response, _BASE_URL + ENDPOINT_URL);
    } catch (E) {
      return ApiErrors.handleException(E, _BASE_URL + ENDPOINT_URL);
    }
  }

  static Future<http.Response> postMultipart(
      {required String ENDPOINT_URL,
      Map<String, String>? fields,
      MultipartFile? files,
      Iterable<MultipartFile>? fileList}) async {
    try {
      MultipartRequest request =
          http.MultipartRequest('POST', Uri.parse(_BASE_URL + ENDPOINT_URL));
      request.headers.addAll(_getHeaders());
      if (fields != null) {
        request.fields.addAll(fields);
      }

      if (files != null) {
        request.files.add(files);
      }

      if (fileList != null && fileList.isNotEmpty) {
        request.files.addAll(fileList);
      }

      http.StreamedResponse streamedResponse =
          await request.send().timeout(Duration(seconds: _TIMEOUT_DURATION));
      Response response = await http.Response.fromStream(streamedResponse);
      return await ApiErrors.processResponse(
          response, _BASE_URL + ENDPOINT_URL);
    } catch (E) {
      return ApiErrors.handleException(E, _BASE_URL + ENDPOINT_URL);
    }
  }

  static Future<http.Response> delete({required String ENDPOINT_URL}) async {
    try {
      Request request =
          http.Request('DELETE', Uri.parse(_BASE_URL + ENDPOINT_URL));
      request.headers.addAll(_getHeaders());
      http.StreamedResponse streamedResponse =
          await request.send().timeout(Duration(seconds: _TIMEOUT_DURATION));
      Response response = await http.Response.fromStream(streamedResponse);
      return await ApiErrors.processResponse(
          response, _BASE_URL + ENDPOINT_URL);
    } catch (E) {
      return ApiErrors.handleException(E, _BASE_URL + ENDPOINT_URL);
    }
  }
}
