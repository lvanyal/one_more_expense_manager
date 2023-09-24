import 'package:copilot/dashboard/bloc/dashboard_state.dart';
import 'package:copilot/data/dashboard_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DashboardCubit extends Cubit<DashboardState> {
  DashboardCubit(
    this.dashboardRepository,
  ) : super(DashboardStateInitial()) {
    getDashboardData(DateTime.now());
  }

  final DashboardRepository dashboardRepository;

  void getDashboardData(DateTime selectedMonth) async {
    emit(DashboardStateLoading());
    try {
      final dashboardData =
          await dashboardRepository.getDashboardData(selectedMonth);
      emit(DashboardStateLoaded(dashboardData: dashboardData));
    } catch (e) {
      emit(DashboardStateError(e.toString()));
    }
  }

  void nextMonth() {
    final currentState = state;
    if (currentState is DashboardStateLoaded) {
      final newSelectedMonth = DateTime(
        currentState.dashboardData.selectedMonth.year,
        currentState.dashboardData.selectedMonth.month + 1,
      );
      getDashboardData(newSelectedMonth);
    }
  }

  void previousMonth() {
    final currentState = state;
    if (currentState is DashboardStateLoaded) {
      final newSelectedMonth = DateTime(
        currentState.dashboardData.selectedMonth.year,
        currentState.dashboardData.selectedMonth.month - 1,
      );
      getDashboardData(newSelectedMonth);
    }
  }
}
