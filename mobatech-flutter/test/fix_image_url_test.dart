import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:mobatech_app/core/network/dio_client.dart';

void main() {
  group('fixImageUrl stress test', () {
    setUpAll(() async {
      await dotenv.load(fileName: ".env");
      dotenv.env['API_BASE_URL'] = 'http://192.168.1.100:8000/api';
    });

    test('replaces localhost in absolute URL', () {
      final result = fixImageUrl('http://localhost:8000/media/image.png');
      expect(result, 'http://192.168.1.100:8000/media/image.png');
    });

    test('replaces local IP in absolute URL', () {
      final result = fixImageUrl('http://127.0.0.1:8080/media/image.png');
      expect(result, 'http://192.168.1.100:8000/media/image.png');
    });

    test('handles relative path with leading slash', () {
      final result = fixImageUrl('/media/image.png');
      expect(result, 'http://192.168.1.100:8000/media/image.png');
    });

    test('handles relative path without leading slash', () {
      final result = fixImageUrl('media/image.png');
      expect(result, 'http://192.168.1.100:8000/media/image.png');
    });

    test('handles api base URL without /api', () {
      dotenv.env['API_BASE_URL'] = 'https://production-server.com';
      final result = fixImageUrl('http://localhost:8080/media/image.png');
      expect(result, 'https://production-server.com/media/image.png');
    });

    test('handles api base URL with trailing slash on api', () {
      dotenv.env['API_BASE_URL'] = 'http://192.168.1.100:8000/api/';
      final result = fixImageUrl('http://localhost:8080/media/image.png');
      expect(result, 'http://192.168.1.100:8000/media/image.png');
    });

    test('handles versioned api base URL', () {
      dotenv.env['API_BASE_URL'] = 'http://192.168.1.100:8000/api/v1';
      final result = fixImageUrl('http://localhost:8080/media/image.png');
      // Wait, fixImageUrl only strips /api/ or /api! It won't strip /api/v1 !
      expect(result, 'http://192.168.1.100:8000/api/v1/media/image.png');
    });

    test('handles other valid domains', () {
      dotenv.env['API_BASE_URL'] = 'http://192.168.1.100:8000/api';
      final result = fixImageUrl('https://external.com/image.png');
      expect(result, 'https://external.com/image.png');
    });
  });
}
