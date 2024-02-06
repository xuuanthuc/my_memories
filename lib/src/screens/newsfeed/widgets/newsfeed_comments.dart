import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:my_memories/global/style/app_images.dart';
import 'package:my_memories/global/utilities/format.dart';
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
    context.read<NewsfeedItemCubit>().getFavourite(widget.post);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      minChildSize: 0.6,
      maxChildSize: 0.95,
      expand: false,
      initialChildSize: 0.90,
      builder: (BuildContext context, ScrollController scrollController) {
        return BlocListener<NewsfeedItemCubit, NewsfeedItemState>(
          listener: (context, state) {
            if (state.status == CommentStatus.loading) {
              _textEditingController.clear();
            }
          },
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(10),
              ),
            ),
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
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    children: [
                      BlocBuilder<NewsfeedItemCubit, NewsfeedItemState>(
                        builder: (context, state) {
                          final style = TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade600,
                          );
                          if (state.favourite?.male == true &&
                              state.favourite?.female == true) {
                            if (AppFlavor.appFlavor == Flavor.female) {
                              return Text(
                                "Bạn và Mặp đã chơm chơm",
                                style: style,
                              );
                            } else {
                              return Text(
                                "Bạn và Cún đã chơm chơm",
                                style: style,
                              );
                            }
                          } else if (state.favourite?.female == true) {
                            if (AppFlavor.appFlavor == Flavor.female) {
                              return Text(
                                "Bạn đã chơm chơm",
                                style: style,
                              );
                            } else {
                              return Text(
                                "Cún đã chơm chơm",
                                style: style,
                              );
                            }
                          } else if (state.favourite?.male == true) {
                            if (AppFlavor.appFlavor == Flavor.female) {
                              return Text(
                                "Mặp đã chơm chơm",
                                style: style,
                              );
                            } else {
                              return Text(
                                "Bạn đã chơm chơm",
                                style: style,
                              );
                            }
                          } else {
                            return Container();
                          }
                        },
                      ),
                      Spacer(),
                      IconButton(
                        onPressed: () {
                          context
                              .read<NewsfeedItemCubit>()
                              .sendFavourite(widget.post);
                        },
                        icon: Row(
                          children: [
                            BlocBuilder<NewsfeedItemCubit, NewsfeedItemState>(
                              builder: (context, state) {
                                if (AppFlavor.appFlavor == Flavor.female) {
                                  if (state.favourite?.female == true) {
                                    return SvgPicture.asset(
                                      AppImages.heart,
                                      colorFilter: ColorFilter.mode(
                                        AppColors.primary,
                                        BlendMode.srcIn,
                                      ),
                                    );
                                  } else {
                                    return SvgPicture.asset(
                                      AppImages.heartOutline,
                                      colorFilter: ColorFilter.mode(
                                        AppColors.primary,
                                        BlendMode.srcIn,
                                      ),
                                    );
                                  }
                                } else {
                                  if (state.favourite?.male == true) {
                                    return SvgPicture.asset(
                                      AppImages.heart,
                                      colorFilter: ColorFilter.mode(
                                        AppColors.primary,
                                        BlendMode.srcIn,
                                      ),
                                    );
                                  } else {
                                    return SvgPicture.asset(
                                      AppImages.heartOutline,
                                      colorFilter: ColorFilter.mode(
                                        AppColors.primary,
                                        BlendMode.srcIn,
                                      ),
                                    );
                                  }
                                }
                              },
                            ),
                            const SizedBox(width: 10),
                            Text("Chơm"),
                          ],
                        ),
                      ),
                    ],
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
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              CupertinoIcons.conversation_bubble,
                              color: Colors.grey.shade200,
                              size: 100,
                            ),
                            const SizedBox(height: 20),
                            Text(
                              'Chưa có tin nhắn nào',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              'Hãy viết gì đó nhé 🌸',
                              style: TextStyle(
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        );
                      }
                      return ListView.builder(
                        controller: scrollController,
                        itemCount: state.comments?.length ?? 0,
                        itemBuilder: (BuildContext context, int index) {
                          final comment = (state.comments ?? [])[index];
                          return Container(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 20,
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    height: 40,
                                    width: 40,
                                    decoration: BoxDecoration(
                                      color: comment.user == Flavor.female.name
                                          ? Colors.white
                                          : AppColors.primary,
                                      borderRadius: BorderRadius.circular(50),
                                      border: Border.all(
                                        color: AppColors.primary,
                                        width: 2,
                                      ),
                                    ),
                                    padding: EdgeInsets.all(8),
                                    child: SvgPicture.asset(
                                      comment.user == Flavor.female.name
                                          ? AppImages.foot
                                          : AppImages.footOutline,
                                      colorFilter: ColorFilter.mode(
                                        comment.user == Flavor.female.name
                                            ? AppColors.primary
                                            : Colors.white,
                                        BlendMode.srcIn,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 15),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Text(
                                              comment.user == Flavor.female.name
                                                  ? "Cún"
                                                  : "Mặp",
                                              style: TextStyle(
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                            // Spacer(),
                                            const SizedBox(width: 10),
                                            Text(
                                              Formatter.timeAgoSinceDate(
                                                comment.time ?? '',
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 10),
                                        Text(
                                          comment.content ?? '',
                                          style: TextStyle(
                                            fontSize: 15,
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
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
                          decoration: InputDecoration(
                            hintText:
                                "Gửi hồi đáp cho ${AppFlavor.appFlavor == Flavor.female ? "Mặp" : "Cún"}",
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
                              spreadRadius: 2,
                            )
                          ],
                        ),
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
          ),
        );
      },
    );
  }
}
