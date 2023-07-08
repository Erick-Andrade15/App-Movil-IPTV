import 'package:http/http.dart' as http;

Future<bool> validateImage(String imageUrl) async {
  http.Response res;
  try {
    res = await http.get(Uri.parse(imageUrl));
    if (res.statusCode != 200) return false;
    return true; //checkIfImage(data['content-type']);
  } catch (e) {
    return false;
  }
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
