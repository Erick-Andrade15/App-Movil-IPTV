import 'package:http/http.dart' as http;

Future<bool> validateImage(String imageUrl) async {
  http.Response res;
  try {
    res = await http.head(Uri.parse(imageUrl));
  } catch (e) {
    return false;
  }
  if (res.statusCode != 200) return false;
  Map<String, dynamic> data = res.headers;
  return checkIfImage(data['content-type']);
}

bool checkIfImage(String contentType) {
  final validImageTypes = [
    'image/jpeg',
    'image/png',
    'image/gif',
    'image/bmp',
    'image/webp',
    'image/svg+xml',
    'image/x-icon',
  ];

  return validImageTypes.contains(contentType);
}
