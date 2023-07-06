import 'dart:convert';
import 'package:app_movil_iptv/data/services/api_exception.dart';
import 'package:app_movil_iptv/data/services/base_api_service.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class NetworkApiService extends BaseApiService {
  @override
  Future getResponse(String url, Map<String, dynamic>? parameters) async {
    dynamic responseJson;
    try {
      final response = await http.get(Uri.http(baseUrl, url, parameters));
      responseJson = returnResponse(response);
      return responseJson;
    } catch (e) {
      debugPrint("Error HTTP: $e");
      return null;
    }
  }
}

dynamic returnResponse(http.Response response) {
  switch (response.statusCode) {
    case 200:
      //var sdas = utf8.decode(response.bodyBytes);
      //dynamic responseJson = response.body;
      return utf8.decode(response.bodyBytes);
    case 400:
      throw BadRequestException(response.toString());
    case 401:
    case 403:
      throw UnauthorisedException(response.body.toString());
    case 404:
      throw UnauthorisedException(response.body.toString());
    case 500:
    default:
      throw FetchDataException(
          // ignore: prefer_adjacent_string_concatenation
          'Error occured while communication with server' +
              ' with status code : ${response.statusCode}');
  }
}
