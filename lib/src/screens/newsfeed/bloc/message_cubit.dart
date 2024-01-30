import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import 'package:meta/meta.dart';
import 'package:my_memories/global/flavor/app_flavor.dart';
import '../../../models/response/post.dart';

part 'message_state.dart';

@injectable
class MessageCubit extends Cubit<MessageState> {
  MessageCubit() : super(MessageState());

  void getMessage() async {
    try {
      emit(state.copyWith(status: MessageStatus.loading));
      final db = FirebaseFirestore.instance;
      PostData? message;
      await db.collection("message").doc(AppFlavor.appFlavor.name).get().then(
        (documentSnapshot) {
          if (documentSnapshot.exists && documentSnapshot.data() != null) {
            message = PostData.fromJson(documentSnapshot.data() ?? {});
            emit(state.copyWith(
              message: message,
              status: MessageStatus.success,
            ));
          }
        },
        onError: (e) {
          throw FirebaseException(plugin: "Oops! Some thing wrong.");
        },
      );
    } on FirebaseException catch (_) {
      emit(state.copyWith(status: MessageStatus.error));
    }
  }

  void deleteMessage() async {
    try {
      if (state.message == null) return;
      emit(state.copyWith(status: MessageStatus.loading));
      final db = FirebaseFirestore.instance;
      await db
          .collection("message")
          .doc(AppFlavor.appFlavor.name)
          .delete()
          .then((value) {
        emit(state.copyWith(status: MessageStatus.success));
      });
    } on FirebaseException catch (_) {
      emit(state.copyWith(status: MessageStatus.error));
    }
  }
}
