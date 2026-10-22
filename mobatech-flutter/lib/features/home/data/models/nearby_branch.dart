import 'branch.dart';

class NearbyBranch {
  final Branch branch;
  final double? distanceKm;

  const NearbyBranch({
    required this.branch,
    this.distanceKm,
  });

  String get formattedDistance {
    final dist = distanceKm;
    if (dist == null) return '';
    if (dist < 1.0) {
      final meters = (dist * 1000).round();
      return '$meters m';
    }
    return '${dist < 10 ? dist.toStringAsFixed(1) : dist.toStringAsFixed(0)} KM';
  }
}
