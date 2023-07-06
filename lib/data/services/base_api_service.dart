abstract class BaseApiService {
  
  final String baseUrl = "panel.tured.live:8080";

  Future<dynamic> getResponse(String url, Map<String, dynamic>? parameters);
}
