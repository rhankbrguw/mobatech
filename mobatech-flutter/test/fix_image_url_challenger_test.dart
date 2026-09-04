import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:mobatech_app/core/network/dio_client.dart';

void main() {
  group('Challenger fixImageUrl tests', () {
    test('What if URI is an absolute localhost URL and base URL has a subpath?', () {
      dotenv.clean();
      dotenv.loadFromString(envString: 'API_BASE_URL=https://production.com/app/api');
      final result = fixImageUrl('http://localhost:8080/media/image.png');
      expect(result, 'https://production.com/app/media/image.png');
    });

    test('Regex for IP is too broad (999.999.999.999)', () {
      dotenv.clean();
      dotenv.loadFromString(envString: 'API_BASE_URL=https://production.com/api');
      final result = fixImageUrl('http://999.999.999.999:8080/media/image.png');
      // If regex is just \d{1,3}, this will be replaced.
      // Even though 999 is invalid IP, regex matches it.
      expect(result, 'https://production.com/media/image.png');
    });

    test('Regex for IP misses things like [::1]', () {
      dotenv.clean();
      dotenv.loadFromString(envString: 'API_BASE_URL=https://production.com/api');
      final result = fixImageUrl('http://[::1]:8080/media/image.png');
      expect(result, 'https://production.com/media/image.png');
    });
  });
}
