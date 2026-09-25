import 'package:dio/dio.dart';
import '../models/branch.dart';

abstract class BranchRepository {
  Future<List<Branch>> getBranches({int page = 1, int limit = 10});
}

class BranchRepositoryImpl implements BranchRepository {
  final Dio _dio;

  BranchRepositoryImpl(this._dio);

  @override
  Future<List<Branch>> getBranches({int page = 1, int limit = 10}) async {
    final response = await _dio.get(
      '/branches',
      queryParameters: {'page': page, 'limit': limit},
    );

    if (response.statusCode == 200) {
      final payload = response.data;
      final List<dynamic> data = payload is Map && payload.containsKey('data')
          ? payload['data']
          : (payload as List? ?? []);
      return data.map((json) => Branch.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load branches');
    }
  }
}
