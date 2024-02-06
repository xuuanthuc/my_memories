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
  final FavouriteData? favourite;

  NewsfeedItemState({
    this.status,
    this.comments,
    this.favourite,
  });

  NewsfeedItemState copyWith(
      {List<CommentData>? comments,
      CommentStatus? status,
      FavouriteData? favourite}) {
    return NewsfeedItemState(
      comments: comments ?? this.comments,
      status: status ?? this.status,
      favourite: favourite ?? this.favourite,
    );
  }

  @override
  List<Object?> get props => [
        comments,
        status,
        favourite,
      ];
}
