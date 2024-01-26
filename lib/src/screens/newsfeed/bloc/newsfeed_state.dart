part of 'newsfeed_cubit.dart';

@immutable
class NewsfeedState extends Equatable {
  final List<PostData>? posts;
  final int? currentIndex;

  NewsfeedState({
    this.posts,
    this.currentIndex,
  });

  NewsfeedState copyWith({
    List<PostData>? posts,
    int? currentIndex,
  }) {
    return NewsfeedState(
      posts: posts ?? this.posts,
      currentIndex: currentIndex ?? this.currentIndex,
    );
  }

  @override
  List<Object?> get props => [
        posts,
        currentIndex,
      ];
}
