import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:dio/dio.dart';
import '../../../../core/network/dio_client.dart';
import '../../../../core/utils/custom_snackbar.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../providers/pharmacy_provider.dart';
import '../widgets/shimmer_loading.dart';

class PrescriptionTabView extends ConsumerStatefulWidget {
  const PrescriptionTabView({super.key});

  @override
  ConsumerState<PrescriptionTabView> createState() => _PrescriptionTabViewState();
}

class _PrescriptionTabViewState extends ConsumerState<PrescriptionTabView> {
  bool _isUploading = false;

  Future<void> _uploadPrescription() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile == null) return;

    setState(() => _isUploading = true);
    try {
      final dio = ref.read(dioProvider);
      
      // 1. Upload file
      final formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(pickedFile.path),
      });
      final uploadRes = await dio.post('http://10.0.2.2:8080/api/upload', data: formData);
      final imageUrl = uploadRes.data['url'] as String;

      // 2. Submit Prescription
      await dio.post('/pharmacy/prescriptions', data: {
        'image_url': imageUrl,
        'notes': 'Resep dari pelanggan (Mobile)',
      });

      if (mounted) CustomSnackbar.showSuccess(context, 'E-Resep berhasil diunggah!');
      ref.invalidate(prescriptionsProvider);
    } catch (e) {
      if (mounted) CustomSnackbar.showError(context, 'Gagal mengunggah E-Resep');
    } finally {
      if (mounted) setState(() => _isUploading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final prescriptionsAsync = ref.watch(prescriptionsProvider);

    return prescriptionsAsync.when(
      data: (prescriptions) {
        return CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: ElevatedButton.icon(
                  onPressed: _isUploading ? null : _uploadPrescription,
                  icon: _isUploading 
                      ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.backgroundWhite))
                      : const Icon(Icons.upload_file),
                  label: Text(_isUploading ? 'Mengunggah...' : 'Unggah E-Resep Baru'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: AppColors.textWhite,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            ),
            if (prescriptions.isEmpty)
              const SliverFillRemaining(
                child: Center(child: Text(AppStrings.noPrescription)),
              )
            else
              SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final prescription = prescriptions[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.backgroundWhite,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.shadowColor,
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                'Resep #${prescription.id}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: AppColors.textDark,
                                ),
                              ),
                              const Spacer(),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: prescription.status == 'Pending' 
                                      ? AppColors.iconOrange.withValues(alpha: 0.1) 
                                      : AppColors.primaryLight,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  prescription.status,
                                  style: TextStyle(
                                    color: prescription.status == 'Pending' 
                                        ? AppColors.iconOrange 
                                        : AppColors.primary,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              GestureDetector(
                                onTap: () async {
                                  final confirm = await showDialog<bool>(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                      title: const Text('Hapus E-Resep'),
                                      content: const Text('Apakah Anda yakin ingin menghapus e-resep ini?'),
                                      actions: [
                                        TextButton(
                                          onPressed: () => Navigator.pop(context, false),
                                          child: const Text('Batal', style: TextStyle(color: AppColors.textGrey)),
                                        ),
                                        TextButton(
                                          onPressed: () => Navigator.pop(context, true),
                                          child: const Text('Hapus', style: TextStyle(color: Colors.red)),
                                        ),
                                      ],
                                    ),
                                  );
                                  if (confirm == true) {
                                    try {
                                      final repo = ref.read(prescriptionRepositoryProvider);
                                      await repo.deletePrescription(prescription.id);
                                      ref.invalidate(prescriptionsProvider);
                                      if (mounted) {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          const SnackBar(content: Text('E-Resep berhasil dihapus')),
                                        );
                                      }
                                    } catch (e) {
                                      if (mounted) {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          const SnackBar(content: Text('Gagal menghapus E-Resep')),
                                        );
                                      }
                                    }
                                  }
                                },
                                child: const Icon(Icons.delete_outline, color: Colors.red, size: 24),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Tanggal: ${prescription.createdAt.toLocal().toString().split(' ')[0]}',
                            style: const TextStyle(
                              color: AppColors.textGrey,
                              fontSize: 14,
                            ),
                          ),
                          const Divider(height: 24, color: AppColors.dividerGrey),
                          if (prescription.imageUrl.isNotEmpty)
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.network(
                                prescription.imageUrl.replaceAll('127.0.0.1', '10.0.2.2').replaceAll('localhost', '10.0.2.2'),
                                height: 150,
                                width: double.infinity,
                                fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) => const SizedBox(),
                              ),
                            ),
                          if (prescription.notes.isNotEmpty) ...[
                            const SizedBox(height: 12),
                            Text(
                              'Catatan:',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                                color: AppColors.textDark,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              prescription.notes,
                              style: const TextStyle(
                                color: AppColors.textGrey,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  );
                },
                childCount: prescriptions.length,
              ),
            ),
          ],
        );
      },
      loading: () => ListView.separated(
        padding: const EdgeInsets.all(16.0),
        itemCount: 3,
        separatorBuilder: (context, index) => const SizedBox(height: 16),
        itemBuilder: (context, index) => const ShimmerLoading(
          width: double.infinity,
          height: 180,
          borderRadius: 16,
        ),
      ),
      error: (err, stack) =>
          const Center(child: Text(AppStrings.errorLoadPrescriptions)),
    );
  }
}
