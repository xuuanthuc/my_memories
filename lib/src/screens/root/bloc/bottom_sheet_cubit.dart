import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:injectable/injectable.dart';
import 'package:meta/meta.dart';
import 'package:my_memories/global/flavor/app_flavor.dart';
import 'package:my_memories/src/models/response/post.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

part 'bottom_sheet_state.dart';

@injectable
class BottomSheetCubit extends Cubit<BottomSheetState> {
  BottomSheetCubit() : super(BottomSheetState());

  void pickImage() async {
    final ImagePicker picker = ImagePicker();
    final response = await picker.pickImage(source: ImageSource.gallery);
    if (response != null) {
      emit(state.copyWith(imagePicked: response));
    }
  }

  void clearImage() {
    emit(state.copyWith(imagePicked: XFile('')));
  }

  void uploadPost(String content) async {
    final db = FirebaseFirestore.instance;
    final storage = FirebaseStorage.instance.ref();
    try {
      if (state.status == BottomSheetStatus.loading) return;
      if (File(state.imagePicked?.path ?? '').path.isNotEmpty &&
          content.isNotEmpty) {
        emit(state.copyWith(status: BottomSheetStatus.loading));
        final imageRef = storage.child(
            "image/${DateTime.now().year}/${DateTime.now().month}/${DateTime.now().millisecondsSinceEpoch}/" +
                (state.imagePicked?.name ?? ''));
        await imageRef
            .putFile(File(state.imagePicked?.path ?? ''))
            .onError((error, stackTrace) {
          throw FirebaseException(plugin: 'Error');
        });
        final image = await imageRef.getDownloadURL();

        final post = PostData(
            image: image,
            body: content,
            time: DateTime.now().toIso8601String(),
            user: AppFlavor.appFlavor.name);

        await db.collection("newsfeed").doc().set(post.toJson()).onError(
          (e, stackTrace) {
            throw FirebaseException(plugin: 'Error');
          },
        );
        if (AppFlavor.appFlavor == Flavor.female) {
          db.collection("message").doc("male").set(post.toJson()).then((value) {
            sendMessage("male");
          });
        } else {
          db
              .collection("message")
              .doc("female")
              .set(post.toJson())
              .then((value) {
            sendMessage("female");
          });
        }

        emit(state.copyWith(status: BottomSheetStatus.success));
      } else {
        throw FirebaseException(plugin: 'Enter full information!');
      }
    } on FirebaseException catch (e) {
      emit(state.copyWith(
        status: BottomSheetStatus.error,
        errorMessage: e.plugin,
      ));
    }
  }

  void sendMessage(String document) async {
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
                "body": "AppFl đã gửi cho bạn một tin nhắn 💌",
                "title": "${AppFlavor.appFlavor == Flavor.female ? "Mặp" : "Cún"} ơi! Có tin nhắn mới nè 🌸"
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
