import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:mobatech_app/core/network/dio_client.dart';

void main() {
  group('fixImageUrl stress test', () {
    setUpAll(() async {
      await dotenv.load(fileName: ".env");
    });

    test('preserves subfolder when rewriting absolute local URL', () {
      dotenv.env['API_BASE_URL'] = 'https://mycompany.com/mobatech/api';
      final result = fixImageUrl('http://127.0.0.1:8000/media/image.png');
      expect(result, 'https://mycompany.com/mobatech/media/image.png');
    });

    test('preserves subfolder when rewriting relative URL', () {
      dotenv.env['API_BASE_URL'] = 'https://mycompany.com/mobatech/api';
      final result = fixImageUrl('/media/image.png');
      expect(result, 'https://mycompany.com/mobatech/media/image.png');
    });
  });
}
