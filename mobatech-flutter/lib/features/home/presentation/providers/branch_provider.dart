import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import '../../../../core/network/dio_client.dart';
import '../../../emergency/presentation/controllers/location_helper.dart';
import '../../data/models/branch.dart';
import '../../data/models/nearby_branch.dart';
import '../../data/repositories/branch_repository.dart';

export '../../data/models/nearby_branch.dart';

final branchRepositoryProvider = Provider<BranchRepository>((ref) {
  return BranchRepositoryImpl(ref.watch(dioProvider));
});

final branchProvider = FutureProvider<List<Branch>>((ref) async {
  final repository = ref.watch(branchRepositoryProvider);
  return repository.getBranches();
});

Future<Position?> _fetchUserPosition() async {
  try {
    final hasPermission = await LocationHelper.checkLocationServices() == null;
    if (!hasPermission) return null;
    final lastPos = await Geolocator.getLastKnownPosition();
    if (lastPos != null) return lastPos;
    return await Geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.medium,
        timeLimit: Duration(seconds: 3),
      ),
    );
  } catch (_) {
    return null;
  }
}

List<NearbyBranch> _calculateNearbyBranches(
  List<Branch> branches,
  Position? pos,
) {
  final list = branches.map((branch) {
    double? distKm;
    if (pos != null && branch.latitude != 0 && branch.longitude != 0) {
      final meters = Geolocator.distanceBetween(
        pos.latitude,
        pos.longitude,
        branch.latitude,
        branch.longitude,
      );
      distKm = meters / 1000.0;
    }
    return NearbyBranch(branch: branch, distanceKm: distKm);
  }).toList();

  if (pos != null) {
    list.sort((a, b) {
      if (a.distanceKm == null && b.distanceKm == null) return 0;
      if (a.distanceKm == null) return 1;
      if (b.distanceKm == null) return -1;
      return a.distanceKm!.compareTo(b.distanceKm!);
    });
  }
  return list;
}

final nearbyBranchesProvider = FutureProvider<List<NearbyBranch>>((ref) async {
  final repository = ref.watch(branchRepositoryProvider);
  final branches = await repository.getBranches();
  final userPos = await _fetchUserPosition();
  return _calculateNearbyBranches(branches, userPos);
});
