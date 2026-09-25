import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:mobatech_app/core/network/dio_client.dart';

void main() {
  group('fixImageUrl stress test', () {
    setUpAll(() async {
      await dotenv.load(fileName: ".env");
    });

    test('replaces port correctly for https', () {
      dotenv.env['API_BASE_URL'] = 'https://production.com/api';
      final result = fixImageUrl('http://localhost:8000/media/image.png');
      expect(result, 'https://production.com/media/image.png');
    });

    test('replaces port correctly for implicit http port', () {
      dotenv.env['API_BASE_URL'] = 'http://production.com/api';
      final result = fixImageUrl('http://localhost:8000/media/image.png');
      expect(result, 'http://production.com/media/image.png');
    });
  });
}
