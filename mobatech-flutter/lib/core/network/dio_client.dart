import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:mobatech_app/core/constants/config.dart';

String get baseUrl {
  String url = AppConfig.apiBaseUrl;
  if (!url.endsWith('/')) {
    url += '/';
  }
  return url;
}

String get baseMediaUrl {
  return baseUrl.replaceAll(RegExp(r'/api/?$'), '');
}

String fixImageUrl(String rawUrl) {
  if (rawUrl.isEmpty) return rawUrl;

  try {
    final uri = Uri.parse(rawUrl);

    if (uri.hasScheme) {
      final host = uri.host;
      final isIp = RegExp(r'^(\d{1,3}\.){3}\d{1,3}$').hasMatch(host) || host == '::1' || host == '[::1]';
      if (isIp || host == 'localhost') {
        final newPath = uri.path.startsWith('/') ? uri.path : '/${uri.path}';
        final query = uri.hasQuery ? '?${uri.query}' : '';
        final fragment = uri.hasFragment ? '#${uri.fragment}' : '';
        final base = baseMediaUrl.endsWith('/') ? baseMediaUrl.substring(0, baseMediaUrl.length - 1) : baseMediaUrl;
        return '$base$newPath$query$fragment';
      }
    } else {
      final safeBase = baseMediaUrl.endsWith('/') ? baseMediaUrl.substring(0, baseMediaUrl.length - 1) : baseMediaUrl;
      if (rawUrl.startsWith('/')) {
        return '$safeBase$rawUrl';
      }
      return '$safeBase/$rawUrl';
    }
  } catch (e) {
    // Silently ignore invalid urls
  }

  return rawUrl;
}

final dioProvider = Provider<Dio>((ref) {
  final options = BaseOptions(
    baseUrl: baseUrl,
    connectTimeout: const Duration(seconds: 60),
    receiveTimeout: const Duration(seconds: 60),
    headers: {'Content-Type': 'application/json', 'Accept': 'application/json'},
  );

  final dio = Dio(options);

  dio.interceptors.add(
    InterceptorsWrapper(
      onRequest: (options, handler) async {
        if (options.path.startsWith('/')) {
          options.path = options.path.substring(1);
        }
        const secureStorage = FlutterSecureStorage();
        final token = await secureStorage.read(key: 'jwt_token');
        if (token != null && token.isNotEmpty) {
          options.headers['Authorization'] = 'Bearer $token';
        }
        return handler.next(options);
      },
      onResponse: (response, handler) {
        // Extract payload from standard API response envelope.
        if (response.data != null && response.data is Map<String, dynamic>) {
          if (response.data['success'] == true &&
              response.data.containsKey('data')) {
            // PRESERVE META BEFORE STRIPPING
            if (response.data.containsKey('meta')) {
              response.extra['meta'] = response.data['meta'];
            }
            response.data = response.data['data'];
          }
        }
        return handler.next(response);
      },
    ),
  );

  return dio;
});
