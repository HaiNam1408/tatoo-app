import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../../../common/utils/logger.dart';
import '../../../common/widgets/custom_date_picker.dart';
import '../../../core/infrastructure/datasources/remote/api/services/appointment/models/appointment_model.dart';
import '../domain/interfaces/appointment_repository_interface.dart';
import 'appointment_state.dart';

class AppointmentCubit extends Cubit<AppointmentState> {
  final IAppointmentRepository appointmentRepository;
  static DateTime initialDate = DateTime.now();
  late PageController pageController;

  AppointmentCubit(this.appointmentRepository)
      : super(AppointmentState(selectedDate: initialDate)) {
    final int initialPage = getWeeksBetween(
      _startDate,
      getStartOfWeek(initialDate),
    );
    pageController = PageController(initialPage: initialPage);
    fetchAppointments();
    fetchWeekAppointments();
  }

  static DateTime get _startDate => DateTime(2000, 1, 1);
  static DateTime get _endDate => DateTime(2100, 12, 31);

  DateTime getStartOfWeek(DateTime date) {
    return date.subtract(Duration(days: date.weekday - 1));
  }

  int getWeeksBetween(DateTime start, DateTime end) {
    final validStart = start.isBefore(_startDate) ? _startDate : start;
    final validEnd = end.isAfter(_endDate) ? _endDate : end;

    return (validEnd.difference(validStart).inDays / 7).round();
  }

  void scrollToSelectedDate() {
    if (state.selectedDate != null) {
      final firstDate = _startDate;
      final targetPage =
          getWeeksBetween(firstDate, getStartOfWeek(state.selectedDate!));
      pageController.animateToPage(
        targetPage,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void showDatePicker(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: CustomDatePicker(
            initialDate: state.selectedDate,
            onDateSelected: (DateTime date) {
              onDateChange(date);
              scrollToSelectedDate();
            },
          ),
        );
      },
    );
  }

  void onDateChange(DateTime date) {
    emit(state.copyWith(selectedDate: date));
    fetchAppointments();
  }

  void onTabChange(int index) {
    emit(state.copyWith(selectedTab: index));
  }

  void fetchAppointments() async {
    emit(state.copyWith(isLoadingDailyView: true));
    final result = await appointmentRepository.getAppointmentsByDate(
      state.selectedDate!.toIso8601String(),
      1,
      10,
    );
    result.fold((success) {
      emit(state.copyWith(dailyAppointments: success.data));
    }, (failure) {});
    emit(state.copyWith(isLoadingDailyView: false));
  }

  void fetchWeekAppointments() async {
    emit(state.copyWith(isLoadingWeeklyView: true));
    DateTime now = DateTime.now();
    DateTime startOfWeek = now.subtract(Duration(days: now.weekday - 1));
    String startDate = DateFormat('yyyy-MM-dd HH:mm:ss').format(startOfWeek);
    DateTime endOfWeek = now.add(Duration(days: 7 - now.weekday));
    String endDate = DateFormat('yyyy-MM-dd HH:mm:ss').format(endOfWeek);
    final result =
        await appointmentRepository.getAppointmentsByWeek([startDate, endDate]);
    result.fold((success) {
      emit(state.copyWith(weeklyAppointments: success.data));
    }, (failure) {});
    emit(state.copyWith(isLoadingWeeklyView: false));
  }

  void updateAppointmentStatus(int id, bool status) async {
    FormData formData = FormData.fromMap({
      'is_done': status,
    });
    final result =
        await appointmentRepository.updateStatusAppointment(id, formData);
    result.fold(
      (success) {
        List<AppointmentModel> newList =
            state.dailyAppointments.map((appointment) {
          if (appointment.id == id) {
            return appointment.copyWith(is_done: status);
          }
          return appointment;
        }).toList();

        emit(state.copyWith(dailyAppointments: newList));
      },
      (failure) {
        logger.d('Failed to update appointment status: ${failure.message}');
        // print('Failed to update appointment status: ${failure.message}');
      },
    );
  }

}
