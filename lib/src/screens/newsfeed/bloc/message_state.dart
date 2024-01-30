part of 'message_cubit.dart';

enum MessageStatus { loading, success, error }

@immutable
class MessageState extends Equatable {
  final MessageStatus? status;
  final PostData? message;

  MessageState({
    this.status,
    this.message,
  });

  MessageState copyWith({
    MessageStatus? status,
    PostData? message,
  }) {
    return MessageState(
      status: status ?? this.status,
      message: message,
    );
  }

  @override
  List<Object?> get props => [
        status,
        message,
      ];
}
