import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:tokokita/helpers/user_info.dart';

import 'app_exception.dart';

class Api {
  Future<dynamic> post(dynamic url, dynamic data) async {
    final token = await UserInfo().getToken();

    try {
      final response = await http.post(
        Uri.parse(url.toString()),
        body: data,
        headers: _headers(token),
      );

      return _returnResponse(response);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
  }

  Future<dynamic> get(dynamic url) async {
    final token = await UserInfo().getToken();

    try {
      final response = await http.get(
        Uri.parse(url.toString()),
        headers: _headers(token),
      );

      return _returnResponse(response);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
  }

  Future<dynamic> delete(dynamic url) async {
    final token = await UserInfo().getToken();

    try {
      final response = await http.delete(
        Uri.parse(url.toString()),
        headers: _headers(token),
      );

      return _returnResponse(response);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
  }

  // Digunakan untuk memperbarui data produk.
  Future<dynamic> put(dynamic url, dynamic data) async {
    final token = await UserInfo().getToken();

    try {
      final response = await http.put(
        Uri.parse(url.toString()),
        body: data,
        headers: _headers(token),
      );

      return _returnResponse(response);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
  }

  Map<String, String> _headers(String? token) {
    if (token == null || token.isEmpty) {
      return {};
    }

    return {HttpHeaders.authorizationHeader: 'Bearer $token'};
  }

  dynamic _returnResponse(http.Response response) {
    switch (response.statusCode) {
      case 200:
      case 201:
      case 202:
      case 204:
        return response;

      case 400:
        throw BadRequestException(response.body);

      case 401:
      case 403:
        throw UnauthorisedException(response.body);

      case 422:
        throw InvalidInputException(response.body);

      case 500:
      default:
        throw FetchDataException(
          'Error occurred while communicating with server '
          'with status code: ${response.statusCode}',
        );
    }
  }
}
