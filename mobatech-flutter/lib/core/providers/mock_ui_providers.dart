import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';


export 'mock_promos_provider.dart';

export '../../features/for_you/domain/models/for_you_article.dart';
export '../../features/for_you/presentation/providers/for_you_provider.dart';

class PharmacyOrderMock {
  final String title;
  final String status;
  final String date;

  PharmacyOrderMock(this.title, this.status, this.date);
}

final pharmacyHistoryProvider = FutureProvider<List<PharmacyOrderMock>>((
  ref,
) async {
  await Future.delayed(const Duration(milliseconds: 500));
  return [
    PharmacyOrderMock('Pesanan Obat #12345', 'Pending', '12-08-2023'),
    PharmacyOrderMock('Pesanan Obat #12346', 'Completed', '10-08-2023'),
  ];
});
