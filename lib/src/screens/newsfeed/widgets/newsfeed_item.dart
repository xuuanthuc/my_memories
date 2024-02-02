import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:my_memories/global/style/app_colors.dart';
import 'package:my_memories/global/style/app_images.dart';
import 'package:my_memories/global/utilities/format.dart';
import 'package:my_memories/src/models/response/post.dart';
import 'package:my_memories/src/screens/newsfeed/bloc/newsfeed_cubit.dart';

class NewsfeedItem extends StatelessWidget {
  final PostData post;

  const NewsfeedItem({
    super.key,
    required this.post,
  });

  void _showSetting(BuildContext context) {
    showModalBottomSheet<bool>(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 100,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              InkWell(
                onTap: () {
                  Navigator.of(context).pop(true);
                },
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                  child: Row(
                    children: [
                      Icon(
                        CupertinoIcons.delete,
                        color: AppColors.primary,
                      ),
                      const SizedBox(width: 20),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Xoá bài viết này",
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            "Bài viết sẽ bị xoá và không thể khôi phục",
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        );
      },
    ).then((value) {
      if (value == true) {
        context.read<NewsfeedCubit>().deletePost(post);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: AppColors.primary,
            width: 1,
          ),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withOpacity(0.5),
              offset: Offset(4, 4),
            )
          ]),
      margin: EdgeInsets.all(10),
      padding: EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              GestureDetector(
                onTap: () => _showSetting(context),
                child: Container(
                  color: Colors.transparent,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 18,
                        height: 18,
                        child: SvgPicture.asset(
                          AppImages.calendarOutline,
                          colorFilter: ColorFilter.mode(
                            AppColors.primary,
                            BlendMode.srcIn,
                          ),
                        ),
                      ),
                      const SizedBox(width: 5),
                      Text(
                        Formatter.timeToString(
                          Formatter.stringToTime(post.time),
                          formatType: 'dd/MM/yyyy',
                        ),
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Spacer(),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    width: 80,
                    height: 1,
                    color: AppColors.primary,
                  ),
                  const SizedBox(height: 10),
                  Container(
                    width: 40,
                    height: 1,
                    color: AppColors.primary,
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          Visibility(
            visible: (post.image ?? '').isNotEmpty,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: CachedNetworkImage(
                imageUrl: post.image!,
                fit: BoxFit.fitWidth,
              ),
            ),
          ),
          const SizedBox(height: 15),
          Row(
            children: [
              SvgPicture.asset(
                AppImages.pen,
                colorFilter: ColorFilter.mode(
                  AppColors.primary,
                  BlendMode.srcIn,
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 80,
                    height: 1,
                    color: AppColors.primary,
                  ),
                  const SizedBox(height: 10),
                  Container(
                    width: 40,
                    height: 1,
                    color: AppColors.primary,
                  ),
                ],
              )
            ],
          ),
          const SizedBox(height: 5),
          Text(
            post.body ?? '',
          ),
          const SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(
                AppImages.flower,
                height: 15,
                width: 15,
                colorFilter: ColorFilter.mode(
                  AppColors.primary,
                  BlendMode.srcIn,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
