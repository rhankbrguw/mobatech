import 'package:flutter_dotenv/flutter_dotenv.dart';

class AppConfig {
  static String get apiBaseUrl =>
      dotenv.env['API_BASE_URL'] ?? 'http://127.0.0.1:8080/api';
  static String get mapTileUrl => dotenv.env['MAP_TILE_URL'] ?? 'https://tile.openstreetmap.org/{z}/{x}/{y}.png';
  static String get gmapsSearchUrl => dotenv.env['GMAPS_SEARCH_URL'] ?? 'https://www.google.com/maps/search/?api=1&query=';
}
