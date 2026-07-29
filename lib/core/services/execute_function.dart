import 'dart:convert';
import 'dart:developer';

import 'package:appwrite/appwrite.dart';

extension AppwriteFunctionExecution on Functions {
  Future<Map<String, dynamic>> execute({
    required String functionId,
    Map<String, dynamic> body = const {},
  }) async {
    try {
      final response = await createExecution(
        functionId: functionId,
        body: json.encode(body),
      );
      if (response.responseStatusCode == 200) {
        log(response.responseBody);
        return jsonDecode(response.responseBody) as Map<String, dynamic>;
      }
      throw Exception(
        '${response.responseStatusCode}: ${response.responseBody}',
      );
    } on AppwriteException catch (error) {
      throw Exception('ERROR $error');
    }
  }
}
