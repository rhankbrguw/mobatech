import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/network/dio_client.dart';
import '../../data/models/branch.dart';

final branchProvider = FutureProvider<List<Branch>>((ref) async {
  final dio = ref.watch(dioProvider);
  final response = await dio.get('/branches');

  if (response.statusCode == 200) {
    final List<dynamic> data = response.data['data'] ?? [];
    return data.map((json) => Branch.fromJson(json)).toList();
  } else {
    throw Exception('Failed to load branches');
  }
});
