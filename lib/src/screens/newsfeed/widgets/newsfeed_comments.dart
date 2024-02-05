import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_memories/src/models/response/post.dart';
import 'package:my_memories/src/screens/newsfeed/bloc/newsfeed_item_cubit.dart';

import '../../../../global/flavor/app_flavor.dart';
import '../../../../global/style/app_colors.dart';

class NewsfeedCommentsBottomSheet extends StatefulWidget {
  final PostData post;

  const NewsfeedCommentsBottomSheet({
    super.key,
    required this.post,
  });

  @override
  State<NewsfeedCommentsBottomSheet> createState() =>
      _NewsfeedCommentsBottomSheetState();
}

class _NewsfeedCommentsBottomSheetState
    extends State<NewsfeedCommentsBottomSheet> {
  final TextEditingController _textEditingController = TextEditingController();

  @override
  void initState() {
    context.read<NewsfeedItemCubit>().getComments(widget.post);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      minChildSize: 0.6,
      maxChildSize: 0.9,
      expand: false,
      initialChildSize: 0.9,
      builder: (BuildContext context, ScrollController scrollController) {
        return Container(
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(10))),
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Column(
            children: [
              Container(
                height: 30,
                padding: EdgeInsets.only(top: 10),
                child: Center(
                  child: Container(
                    height: 5,
                    width: 50,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade700,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
              Divider(
                color: Colors.grey.shade200,
              ),
              Expanded(
                child: BlocBuilder<NewsfeedItemCubit, NewsfeedItemState>(
                  builder: (context, state) {
                    if (state.status == CommentStatus.loading) {
                      return Center(
                        child: CircularProgressIndicator(
                          color: AppColors.primary,
                        ),
                      );
                    } else if (state.comments == null ||
                        (state.comments ?? []).isEmpty) {
                      return Text('Empty');
                    }
                    return ListView.builder(
                      controller: scrollController,
                      itemCount: state.comments?.length ?? 0,
                      itemBuilder: (BuildContext context, int index) {
                        return ListTile(
                          title: Text('Item $index'),
                        );
                      },
                    );
                  },
                ),
              ),
              Divider(
                color: Colors.grey.shade200,
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _textEditingController,
                        autofocus: true,
                        // onEditingComplete: () => goToHome(),
                        decoration: InputDecoration(
                          hintText:
                              "Gửi một bình luận cho ${AppFlavor.appFlavor == Flavor.female ? "Mặp" : "Cún"}",
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(35),
                            borderSide: BorderSide.none,
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(35),
                            borderSide: BorderSide.none,
                          ),
                          filled: true,
                          fillColor: Colors.grey.shade100,
                          isDense: true,
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 10,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          boxShadow: [
                            BoxShadow(
                                color: Colors.grey.shade300,
                                offset: Offset(4, 4),
                                blurRadius: 10,
                                spreadRadius: 2)
                          ]),
                      child: IconButton(
                        onPressed: () {
                          context.read<NewsfeedItemCubit>().sendComment(
                                widget.post,
                                _textEditingController.text,
                              );
                        },
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(
                            AppColors.primary,
                          ),
                          padding: MaterialStateProperty.all(
                            EdgeInsets.all(4),
                          ),
                        ),
                        icon: Icon(
                          CupertinoIcons.paperplane_fill,
                          color: Colors.white,
                          size: 18,
                        ),
                      ),
                    )
                  ],
                ),
              ),
              const SizedBox(height: 5),
            ],
          ),
        );
      },
    );
  }
}
