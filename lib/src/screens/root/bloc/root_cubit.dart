import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import 'package:meta/meta.dart';

part 'root_state.dart';

@injectable
class RootCubit extends Cubit<RootState> {
  RootCubit() : super(RootState(currentPage: 0));

  void onPageChanged(int newPage) {
    emit(state.copyWith(newPage: newPage));
  }
}
