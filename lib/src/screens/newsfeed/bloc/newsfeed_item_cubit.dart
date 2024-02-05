import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import 'package:meta/meta.dart';
import 'package:my_memories/global/flavor/app_flavor.dart';
import 'package:my_memories/src/models/response/post.dart';

import '../../../models/response/comment.dart';

part 'newsfeed_item_state.dart';

@injectable
class NewsfeedItemCubit extends Cubit<NewsfeedItemState> {
  NewsfeedItemCubit() : super(NewsfeedItemState());

  void getComments(PostData post) async {
    try {
      emit(state.copyWith(status: CommentStatus.loading));
      await Future.delayed(Duration(seconds: 3));
      final db = FirebaseFirestore.instance;
      List<CommentData>? comments = [];
      await db
          .collection("newsfeed")
          .doc(post.id)
          .collection("comments")
          .get()
          .then(
        (querySnapshot) {
          for (var docSnapshot in querySnapshot.docs) {
            var comment = CommentData.fromJson(docSnapshot.data());
            comment.id = docSnapshot.id;
            comments.add(comment);
          }
          emit(state.copyWith(
            status: CommentStatus.success,
            comments: comments,
          ));
        },
        onError: (e) {
          throw FirebaseException(plugin: "Oops! Some thing wrong.");
        },
      );
    } on FirebaseException catch (_) {
      emit(state.copyWith(status: CommentStatus.error));
    }
  }

  void sendComment(PostData post, String? content) {
    if ((content ?? "").isEmpty) return;
    final comment = CommentData(
      user: AppFlavor.appFlavor.name,
      time: DateTime.now().toIso8601String(),
      content: content,
    );
    final db = FirebaseFirestore.instance;
    db
        .collection("newsfeed")
        .doc(post.id)
        .collection("comments")
        .doc()
        .set(comment.toJson())
        .then((value) {
      getComments(post);
    });
  }
}
