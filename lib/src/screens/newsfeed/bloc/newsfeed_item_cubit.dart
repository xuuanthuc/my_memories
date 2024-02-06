import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import 'package:meta/meta.dart';
import 'package:my_memories/global/flavor/app_flavor.dart';
import 'package:my_memories/src/models/response/like.dart';
import 'package:my_memories/src/models/response/post.dart';

import '../../../models/response/comment.dart';

part 'newsfeed_item_state.dart';

@injectable
class NewsfeedItemCubit extends Cubit<NewsfeedItemState> {
  NewsfeedItemCubit() : super(NewsfeedItemState());

  void getComments(PostData post) async {
    try {
      emit(state.copyWith(status: CommentStatus.loading));
      final db = FirebaseFirestore.instance;
      List<CommentData>? comments = [];
      await db
          .collection("newsfeed")
          .doc(post.id)
          .collection("comments")
          .orderBy("time", descending: true)
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

  void getFavourite(PostData post) async {
    try {
      emit(state.copyWith(status: CommentStatus.loading));
      final db = FirebaseFirestore.instance;
      await db
          .collection("newsfeed")
          .doc(post.id)
          .collection("love")
          .doc("love")
          .get()
          .then(
        (documentSnapshot) {
          if (documentSnapshot.exists && documentSnapshot.data() != null) {
            final favourite =
                FavouriteData.fromJson(documentSnapshot.data() ?? {});
            emit(state.copyWith(
              status: CommentStatus.success,
              favourite: favourite,
            ));
          }
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
      if (AppFlavor.appFlavor == Flavor.female) {
        sendMessage("male", content ?? '', post);
      } else {
        sendMessage("female", content ?? '', post);
      }
    });
  }

  void sendFavourite(PostData post) {
    final db = FirebaseFirestore.instance
        .collection("newsfeed")
        .doc(post.id)
        .collection("love")
        .doc("love");

    if (AppFlavor.appFlavor == Flavor.male) {
      final liked = state.favourite?.male ?? false;
      final male = FavouriteData(male: !liked);
      db
          .set(
        male.toMaleJson(),
        SetOptions(merge: true),
      )
          .then((value) {
        if (liked == false) {
          sendFavouriteNotice("female", post);
        }
        emit(
          state.copyWith(
            favourite: FavouriteData(
              male: !liked,
              female: state.favourite?.female,
            ),
          ),
        );
      });
    } else {
      final liked = state.favourite?.female ?? false;
      final female = FavouriteData(female: !liked);
      db
          .set(
        female.toFemaleJson(),
        SetOptions(merge: true),
      )
          .then((value) {
        if (liked == false) {
          sendFavouriteNotice("male", post);
        }
        emit(
          state.copyWith(
            favourite: FavouriteData(
              male: state.favourite?.male,
              female: !liked,
            ),
          ),
        );
      });
    }
  }

  void sendMessage(String document, String content, PostData post) async {
    try {
      final db = FirebaseFirestore.instance;
      String? token;
      db.collection("fcmToken").doc(document).get().then((documentSnapshot) {
        if (documentSnapshot.exists && documentSnapshot.data() != null) {
          token = (documentSnapshot.data() ?? {})['token'];
          if (token == null) return;
          final dio = Dio(
            BaseOptions(
              headers: {
                "Content-Type": " application/json",
                "Authorization":
                    "key=AAAACI8I1P8:APA91bFsQEB0Vwxibjhyx2J1E_h3UaQ1J1nViI1ONVazxMQ5xUbhLNJ5PmwJXcZKm7yEAGWhJDGoXogHcuH9C22MMZ9xPFDVf0--a2tUaAmqRuS0MJQvnJ8z-go3a7MIWHTSIOmKfP8l"
              },
            ),
          );
          dio.post(
            'https://fcm.googleapis.com/fcm/send',
            data: {
              "to": token,
              "notification": {
                "body": content,
                "title":
                    "${AppFlavor.appFlavor == Flavor.female ? "Cún" : "Mặp"} đã hồi đáp về bài viết ${post.body}"
              },
            },
          );
        }
      });
    } catch (e) {
      print(e);
    }
  }

  void sendFavouriteNotice(String document, PostData post) async {
    try {
      final db = FirebaseFirestore.instance;
      String? token;
      db.collection("fcmToken").doc(document).get().then((documentSnapshot) {
        if (documentSnapshot.exists && documentSnapshot.data() != null) {
          token = (documentSnapshot.data() ?? {})['token'];
          if (token == null) return;
          final dio = Dio(
            BaseOptions(
              headers: {
                "Content-Type": " application/json",
                "Authorization":
                    "key=AAAACI8I1P8:APA91bFsQEB0Vwxibjhyx2J1E_h3UaQ1J1nViI1ONVazxMQ5xUbhLNJ5PmwJXcZKm7yEAGWhJDGoXogHcuH9C22MMZ9xPFDVf0--a2tUaAmqRuS0MJQvnJ8z-go3a7MIWHTSIOmKfP8l"
              },
            ),
          );
          dio.post(
            'https://fcm.googleapis.com/fcm/send',
            data: {
              "to": token,
              "notification": {
                "body":
                    "${AppFlavor.appFlavor == Flavor.female ? "Cún" : "Mặp"} đã chơm chơm ❤️",
                "title":
                    "${AppFlavor.appFlavor == Flavor.female ? "Cún" : "Mặp"} đã hồi đáp về bài viết ${post.body}"
              },
            },
          );
        }
      });
    } catch (e) {
      print(e);
    }
  }
}
