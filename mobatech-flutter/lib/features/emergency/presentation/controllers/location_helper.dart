import 'package:geolocator/geolocator.dart';
import 'package:mobatech_app/core/constants/strings/core_strings.dart';

class LocationHelper {
  static Future<String?> checkLocationServices() async {
    if (!await Geolocator.isLocationServiceEnabled()) {
      return CoreStrings.locationServiceDisabled;
    }
    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return CoreStrings.locationPermissionDenied;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      return CoreStrings.locationPermissionDeniedForever;
    }
    return null; // indicates success
  }
}
