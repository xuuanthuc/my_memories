part of 'bottom_sheet_cubit.dart';

enum BottomSheetStatus { loading, success, error }

@immutable
class BottomSheetState extends Equatable {
  final BottomSheetStatus? status;
  final XFile? imagePicked;
  final String? errorMessage;

  BottomSheetState({
    this.status,
    this.imagePicked,
    this.errorMessage,
  });

  BottomSheetState copyWith({
    BottomSheetStatus? status,
    String? errorMessage,
    XFile? imagePicked,
  }) {
    return BottomSheetState(
      status: status ?? this.status,
      imagePicked: imagePicked ?? this.imagePicked,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        status,
        imagePicked,
        errorMessage,
      ];
}
