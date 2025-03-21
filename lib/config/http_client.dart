import 'package:http/http.dart' as http;

const String baseUrl = 'http://localhost:3000/';

Future<http.Response> fetchData(String endpoint) async {
  final response = await http.get(Uri.parse('$baseUrl$endpoint'));
  return response;
}
