import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/doctor.dart';
import '../../data/models/doctor_schedule.dart';
import 'doctor_profile_card.dart';
import 'schedules_card.dart';
import 'symptoms_card.dart';
import 'booking_bottom_bar.dart';

class DoctorDetailContent extends StatelessWidget {
  final Doctor doctor;
  final AsyncValue<List<DoctorSchedule>> schedulesAsync;
  final int? selectedScheduleId;
  final ValueChanged<int?> onScheduleSelected;
  final TextEditingController symptomsController;
  final bool isBooking;
  final VoidCallback onBook;
  final Future<void> Function()? onRefresh;

  const DoctorDetailContent({
    super.key,
    required this.doctor,
    required this.schedulesAsync,
    required this.selectedScheduleId,
    required this.onScheduleSelected,
    required this.symptomsController,
    required this.isBooking,
    required this.onBook,
    this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 800),
              child: onRefresh == null
                  ? _buildScrollableContent()
                  : RefreshIndicator(
                      onRefresh: onRefresh!,
                      child: _buildScrollableContent(),
                    ),
            ),
          ),
        ),
        BookingBottomBar(isBooking: isBooking, onBook: onBook),
      ],
    );
  }

  Widget _buildScrollableContent() {
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(
        parent: BouncingScrollPhysics(),
      ),
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DoctorProfileCard(doctor: doctor),
          SchedulesCard(
            schedulesAsync: schedulesAsync,
            selectedScheduleId: selectedScheduleId,
            onScheduleSelected: onScheduleSelected,
          ),
          SymptomsCard(controller: symptomsController),
        ],
      ),
    );
  }
}
