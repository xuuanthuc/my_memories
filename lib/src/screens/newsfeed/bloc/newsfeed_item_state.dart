part of 'newsfeed_item_cubit.dart';

enum CommentStatus {
  loading,
  success,
  error,
}

@immutable
class NewsfeedItemState extends Equatable {
  final List<CommentData>? comments;
  final CommentStatus? status;

  NewsfeedItemState({
    this.status,
    this.comments,
  });

  NewsfeedItemState copyWith({
    List<CommentData>? comments,
    CommentStatus? status,
  }) {
    return NewsfeedItemState(
      comments: comments ?? this.comments,
      status: status ?? this.status,
    );
  }

  @override
  List<Object?> get props => [
        comments,
        status,
      ];
}
