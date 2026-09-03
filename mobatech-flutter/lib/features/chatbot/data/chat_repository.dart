import 'package:dio/dio.dart';

class ChatRepository {
  final Dio _dio;

  ChatRepository(this._dio);

  Future<List<dynamic>> getUserSessions() async {
    try {
      final response = await _dio.get('/chat/sessions');
      return response.data;
    } on DioException {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> createSession(String title) async {
    try {
      final response = await _dio.post(
        '/chat/sessions',
        data: {'title': title},
      );
      return response.data;
    } on DioException {
      rethrow;
    }
  }

  Future<void> renameSession(int sessionId, String title) async {
    try {
      await _dio.put('/chat/sessions/$sessionId', data: {'title': title});
    } on DioException {
      rethrow;
    }
  }

  Future<void> deleteSession(int sessionId) async {
    try {
      await _dio.delete('/chat/sessions/$sessionId');
    } on DioException {
      rethrow;
    }
  }

  Future<List<dynamic>> getSessionMessages(int sessionId) async {
    try {
      final response = await _dio.get('/chat/sessions/$sessionId/messages');
      return response.data;
    } on DioException {
      rethrow;
    }
  }

  Future<Response<dynamic>> streamResponse(
    int sessionId,
    String message,
  ) async {
    try {
      return await _dio.post(
        '/chat/sessions/$sessionId/stream',
        data: {'message': message},
        options: Options(
          responseType: ResponseType.stream,
          receiveTimeout: const Duration(minutes: 5),
        ),
      );
    } on DioException {
      rethrow;
    }
  }
}
