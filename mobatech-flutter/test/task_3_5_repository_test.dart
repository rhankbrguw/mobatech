import 'package:flutter_test/flutter_test.dart';
import 'package:dio/dio.dart';
import 'package:mobatech_app/features/home/data/repositories/branch_repository.dart';
import 'package:mobatech_app/features/chatbot/data/chat_repository.dart';
import 'package:mobatech_app/features/pharmacy/data/prescription_repository.dart';

void main() {
  group('BranchRepository tests', () {
    test('getBranches returns list of branches on 200', () async {
      final dio = Dio(BaseOptions(baseUrl: 'http://localhost'));
      dio.interceptors.add(
        InterceptorsWrapper(
          onRequest: (options, handler) {
            return handler.resolve(
              Response(
                requestOptions: options,
                statusCode: 200,
                data: {
                  'data': [
                    {'id': 1, 'name': 'Branch 1', 'address': 'Addr 1'},
                    {'id': 2, 'name': 'Branch 2', 'address': 'Addr 2'},
                  ]
                },
              ),
            );
          },
        ),
      );

      final repo = BranchRepositoryImpl(dio);
      final branches = await repo.getBranches();
      expect(branches.length, 2);
      expect(branches[0].name, 'Branch 1');
    });
  });

  group('ChatRepository tests', () {
    test('deleteSession sends DELETE request', () async {
      late String lastPath;
      late String lastMethod;

      final dio = Dio(BaseOptions(baseUrl: 'http://localhost'));
      dio.interceptors.add(
        InterceptorsWrapper(
          onRequest: (options, handler) {
            lastPath = options.path;
            lastMethod = options.method;
            return handler.resolve(
              Response(
                requestOptions: options,
                statusCode: 200,
                data: {'success': true},
              ),
            );
          },
        ),
      );

      final repo = ChatRepository(dio);
      await repo.deleteSession(42);
      expect(lastPath, '/chat/sessions/42');
      expect(lastMethod, 'DELETE');
    });

    test('streamResponse sends POST stream request', () async {
      late String lastPath;
      late String lastMethod;
      late ResponseType lastResponseType;

      final dio = Dio(BaseOptions(baseUrl: 'http://localhost'));
      dio.interceptors.add(
        InterceptorsWrapper(
          onRequest: (options, handler) {
            lastPath = options.path;
            lastMethod = options.method;
            lastResponseType = options.responseType;
            return handler.resolve(
              Response(
                requestOptions: options,
                statusCode: 200,
                data: 'stream_mock',
              ),
            );
          },
        ),
      );

      final repo = ChatRepository(dio);
      final res = await repo.streamResponse(10, 'Hello');
      expect(lastPath, '/chat/sessions/10/stream');
      expect(lastMethod, 'POST');
      expect(lastResponseType, ResponseType.stream);
      expect(res.data, 'stream_mock');
    });
  });

  group('PrescriptionRepository tests', () {
    test('createPrescription sends POST to /pharmacy/prescriptions', () async {
      late String lastPath;
      late Map<String, dynamic> lastData;

      final dio = Dio(BaseOptions(baseUrl: 'http://localhost'));
      dio.interceptors.add(
        InterceptorsWrapper(
          onRequest: (options, handler) {
            lastPath = options.path;
            lastData = options.data as Map<String, dynamic>;
            return handler.resolve(
              Response(
                requestOptions: options,
                statusCode: 200,
                data: {'success': true},
              ),
            );
          },
        ),
      );

      final repo = PrescriptionRepository(dio);
      await repo.createPrescription(imageUrl: 'http://test.com/img.png', notes: 'Test notes');
      expect(lastPath, '/pharmacy/prescriptions');
      expect(lastData['image_url'], 'http://test.com/img.png');
      expect(lastData['notes'], 'Test notes');
    });
  });
}
