// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_appointment_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(UserAppointments)
final userAppointmentsProvider = UserAppointmentsProvider._();

final class UserAppointmentsProvider
    extends $AsyncNotifierProvider<UserAppointments, List<Appointment>> {
  UserAppointmentsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'userAppointmentsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$userAppointmentsHash();

  @$internal
  @override
  UserAppointments create() => UserAppointments();
}

String _$userAppointmentsHash() => r'ea41eac5419dd2f133983714fe8fba0321f25036';

abstract class _$UserAppointments extends $AsyncNotifier<List<Appointment>> {
  FutureOr<List<Appointment>> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref =
        this.ref as $Ref<AsyncValue<List<Appointment>>, List<Appointment>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<List<Appointment>>, List<Appointment>>,
              AsyncValue<List<Appointment>>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
