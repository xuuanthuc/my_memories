import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:injectable/injectable.dart';
import 'package:meta/meta.dart';
import 'package:my_memories/global/flavor/app_flavor.dart';
import 'package:my_memories/src/models/response/post.dart';

part 'newsfeed_state.dart';

@injectable
class NewsfeedCubit extends Cubit<NewsfeedState> {
  NewsfeedCubit() : super(NewsfeedState(currentIndex: 0));

  void getNewsfeed() async {
    List<PostData> posts = [];
    try {
      emit(state.copyWith(status: NewsfeedStatus.loading));
      final db = FirebaseFirestore.instance;
      await db
          .collection("newsfeed")
          .orderBy("time", descending: true)
          .get()
          .then(
        (querySnapshot) {
          print("Successfully completed");
          for (var docSnapshot in querySnapshot.docs) {
            var post = PostData.fromJson(docSnapshot.data());
            post.id = docSnapshot.id;
            posts.add(post);
          }
        },
        onError: (e) {
          throw FirebaseException(plugin: "Oops! Some thing wrong.");
        },
      );
      emit(state.copyWith(posts: posts, status: NewsfeedStatus.success));
    } on FirebaseException catch (e) {
      emit(state.copyWith(status: NewsfeedStatus.error));
    }
  }

  void registerToken() async {
    final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
    final token = await _firebaseMessaging.getToken();
    final db = FirebaseFirestore.instance;
    db
        .collection("fcmToken")
        .doc(AppFlavor.appFlavor.name)
        .set({"token": token});
  }

  void onCurrentIndexChange(int index) {
    emit(state.copyWith(currentIndex: index));
  }
}
