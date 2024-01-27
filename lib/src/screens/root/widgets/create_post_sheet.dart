import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:my_memories/global/style/app_colors.dart';
import 'package:my_memories/global/utilities/toast.dart';
import 'package:my_memories/src/screens/root/bloc/bottom_sheet_cubit.dart';

class CreatePostSheet extends StatefulWidget {
  const CreatePostSheet({super.key});

  @override
  State<CreatePostSheet> createState() => _CreatePostSheetState();
}

class _CreatePostSheetState extends State<CreatePostSheet> {
  final TextEditingController _controller = TextEditingController();

  void _showFullImage(File file) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return Stack(
          children: [
            Align(
              alignment: Alignment.center,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.file(file),
                ],
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 30),
                child: IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.close,
                        color: Colors.white,
                      ),
                      Text(
                        "Đóng",
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _errorUpload(String? message) {
    if (message != null) {
      appToast(context, message: message);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<BottomSheetCubit, BottomSheetState>(
      listener: (context, state) {
        if (state.status == BottomSheetStatus.error) {
          _errorUpload(state.errorMessage);
        } else if (state.status == BottomSheetStatus.success) {
          if (context.mounted) {
            appToast(context, message: 'Your post has been shared!');
            Navigator.of(context).pop();
          }
        }
      },
      child: Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Container(
          color: Colors.white,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: Icon(
                        CupertinoIcons.back,
                        color: AppColors.primary,
                      ),
                    ),
                    BlocBuilder<BottomSheetCubit, BottomSheetState>(
                      builder: (context, state) {
                        return Text(
                          state.status == BottomSheetStatus.loading
                              ? "Uploading..."
                              : "Create post",
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 16,
                          ),
                        );
                      },
                    ),
                    IconButton(
                      onPressed: () => context
                          .read<BottomSheetCubit>()
                          .uploadPost(_controller.text),
                      icon: Icon(
                        CupertinoIcons.paperplane_fill,
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: BlocBuilder<BottomSheetCubit, BottomSheetState>(
                  builder: (context, state) {
                    if (state.status == BottomSheetStatus.loading) {
                      return LinearProgressIndicator(color: AppColors.primary);
                    }
                    return SizedBox(height: 4);
                  },
                ),
              ),
              BlocBuilder<BottomSheetCubit, BottomSheetState>(
                builder: (context, state) {
                  if ((state.imagePicked ?? XFile('')).path != '') {
                    final file = File(state.imagePicked?.path ?? '');
                    return Container(
                      height: 200,
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Stack(
                        children: [
                          GestureDetector(
                            onTap: () {
                              _showFullImage(file);
                            },
                            child: Container(
                              height: 200,
                              width: double.infinity,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Image.file(
                                  file,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              context.read<BottomSheetCubit>().clearImage();
                            },
                            icon: Icon(
                              Icons.close,
                              color: Colors.white,
                            ),
                          )
                        ],
                      ),
                    );
                  }
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: GestureDetector(
                      onTap: () async {
                        context.read<BottomSheetCubit>().pickImage();
                      },
                      child: DottedBorder(
                        borderType: BorderType.RRect,
                        radius: Radius.circular(12),
                        padding: EdgeInsets.zero,
                        color: AppColors.primary,
                        child: Container(
                          width: double.infinity,
                          height: 200,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: AppColors.primary.withOpacity(0.1)),
                          child: Icon(
                            CupertinoIcons.photo,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
              Expanded(
                child: TextField(
                  textAlign: TextAlign.start,
                  controller: _controller,
                  maxLines: null,
                  expands: true,
                  autofocus: true,
                  textAlignVertical: TextAlignVertical.top,
                  decoration: InputDecoration(
                    hintText: 'What are you thinking?',
                    hintStyle: TextStyle(color: Colors.grey),
                    enabledBorder:
                        OutlineInputBorder(borderSide: BorderSide.none),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: EdgeInsets.all(20),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
