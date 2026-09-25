import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:mobatech_app/core/network/dio_client.dart';

void main() {
  group('fixImageUrl stress test', () {
    setUpAll(() async {
      await dotenv.load(fileName: ".env");
    });

    test('avoids double slash when base URL has trailing slash but no /api', () {
      dotenv.env['API_BASE_URL'] = 'https://mycompany.com/mobatech/';
      final result = fixImageUrl('/media/image.png');
      expect(result, 'https://mycompany.com/mobatech/media/image.png');
    });
  });
}
