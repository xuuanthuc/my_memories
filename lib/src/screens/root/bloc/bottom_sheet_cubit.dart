import 'dart:io';

import 'package:bloc/bloc.dart';
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
          db
              .collection("message")
              .doc("male")
              .set(post.toJson())
              .then((value) => {
                    //send noti here
                  });
        } else {
          db
              .collection("message")
              .doc("female")
              .set(post.toJson())
              .then((value) => {
                    //send noti here
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
}
