part of 'newsfeed_cubit.dart';

enum NewsfeedStatus { loading, success, error }

@immutable
class NewsfeedState extends Equatable {
  final List<PostData>? posts;
  final NewsfeedStatus? status;
  final int? currentIndex;

  NewsfeedState({
    this.posts,
    this.currentIndex,
    this.status,
  });

  NewsfeedState copyWith({
    List<PostData>? posts,
    int? currentIndex,
    NewsfeedStatus? status,
  }) {
    return NewsfeedState(
      posts: posts ?? this.posts,
      status: status ?? this.status,
      currentIndex: currentIndex ?? this.currentIndex,
    );
  }

  @override
  List<Object?> get props => [
        posts,
        currentIndex,
        status,
      ];
}
