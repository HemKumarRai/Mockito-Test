import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/mockito.dart';
import 'package:test_test/app/app_constants.dart';
import 'package:test_test/data/services/api_service.dart';
import 'api_service.mocks.dart';

@GenerateMocks([http.Client])
void main() {
  late ApiService apiService;
  late MockClient mockClient;
  setUp(() {
    mockClient = MockClient();
    apiService = ApiService(client: mockClient);
  });
  group("Testing api_service", () {
    const testEndPoint = "/test.json";
    final body = {"key1": "valu1", "key2": "valu2", "key3": "valu3"};
    test(
      "get api response in Map<String,dynamic> response once api call successfully",
      () async {
        const String endPointUrl = "/test_data.json";
        const String responseBody = '''{
  "key1":"valu1",
  "key2":"valu2",
  "key3":"valu3"
}
''';
        final Uri expectedUri = Uri.parse(AppConstants.baseUrl + endPointUrl);
        when(
          mockClient.get(expectedUri),
        ).thenAnswer((_) async => http.Response(responseBody, 200));
        final result = await apiService.get(endPointUrl);
        expect(result, isA<Map<String, dynamic>>());
        expect(result["key1"], "valu1");
      },
    );

    test("Exception Test", () async {
      const endPontUrl = "/test.json";
      final expectedUri = Uri.parse(AppConstants.baseUrl + endPontUrl);
      when(
        mockClient.get(expectedUri),
      ).thenAnswer((_) async => http.Response("Not Found", 404));
      final resul = apiService.get(endPontUrl);
      expect(resul, throwsException);
    });

    test("Add New Product", () async {
      final url = Uri.parse(AppConstants.baseUrl + testEndPoint);
      final String responseBody = '{"name": "-N_some_id"}';
      when(
        mockClient.post(
          url,
          body: jsonEncode(body),
          headers: {'Content-Type': 'application/json'},
        ),
      ).thenAnswer((_) async => http.Response(responseBody, 200));
      final response = await apiService.post(testEndPoint, body);
      expect(response, isA<Map<String, dynamic>>());
      expect(response['name'], "-N_some_id");
    });
  });

  test("Exception Test during post", () {
    const testEndPoint = "/test.json";
    final url = Uri.parse(AppConstants.baseUrl + testEndPoint);
    final body = {"key1": "valu1", "key2": "valu2", "key3": "valu3"};
    when(
      mockClient.post(
        url,
        body: body,
        headers: {'Content-Type': 'application/json'},
      ),
    ).thenAnswer((_) async => http.Response("Not Found", 404));
    expect(apiService.post(testEndPoint, body), throwsException);
  });
}
