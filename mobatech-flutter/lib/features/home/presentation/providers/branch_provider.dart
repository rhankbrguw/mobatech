import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/network/dio_client.dart';
import '../../data/models/branch.dart';
import '../../data/repositories/branch_repository.dart';

final branchRepositoryProvider = Provider<BranchRepository>((ref) {
  return BranchRepositoryImpl(ref.watch(dioProvider));
});

final branchProvider = FutureProvider<List<Branch>>((ref) async {
  final repository = ref.watch(branchRepositoryProvider);
  return repository.getBranches();
});
