import '../../../core/infrastructure/datasources/remote/api/services/appointment/models/appointment_model.dart';
import '../infrastructure/models/weekly_appointment_model.dart';

class AppointmentState {
  final bool isLoadingDailyView;
  final bool isLoadingWeeklyView;
  final String? error;
  final DateTime? selectedDate;
  final int selectedTab;
  final List<AppointmentModel> dailyAppointments;
  final List<WeeklyAppointmentModel> weeklyAppointments;

  List<AppointmentModel> get mockDailyAppointments => List.generate(
        6,
        (index) => AppointmentModel(
          id: index + 1,
          title: 'Haircut Session Appointment',
          content: 'Haircut appointment with stylist A.',
          time_start: '09:00',
          time_end: '10:00',
          is_important: false,
        ),
      );

  List<WeeklyAppointmentModel> get mockWeeklyAppointments => List.generate(
        6,
        (index) => WeeklyAppointmentModel(
          date: 'T2, 16/10',
          data: mockDailyAppointments.sublist(0, 3),
        ),
      );
  
  const AppointmentState({
    this.isLoadingDailyView = false,
    this.isLoadingWeeklyView = false,
    this.error,
    this.selectedDate,
    this.selectedTab = 0,
    this.dailyAppointments = const [],
    this.weeklyAppointments = const [],
  });

  AppointmentState copyWith({
    bool? isLoadingDailyView,
    bool? isLoadingWeeklyView,
    String? error,
    DateTime? selectedDate,
    int? selectedTab,
    List<AppointmentModel>? dailyAppointments,
    List<WeeklyAppointmentModel>? weeklyAppointments,
  }) {
    return AppointmentState(
      isLoadingDailyView: isLoadingDailyView ?? this.isLoadingDailyView,
      isLoadingWeeklyView: isLoadingWeeklyView ?? this.isLoadingWeeklyView,
      error: error ?? this.error,
      selectedDate: selectedDate ?? this.selectedDate,
      selectedTab: selectedTab ?? this.selectedTab,
      dailyAppointments: dailyAppointments ?? this.dailyAppointments,
      weeklyAppointments: weeklyAppointments ?? this.weeklyAppointments,
    );
  }
}
