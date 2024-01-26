part of 'root_cubit.dart';

@immutable
class RootState extends Equatable {
  final int currentPage;

  RootState({required this.currentPage});

  RootState copyWith({
    int? newPage,
  }) {
    return RootState(
      currentPage: newPage ?? this.currentPage,
    );
  }

  @override
  List<Object?> get props => [
        currentPage,
      ];
}
