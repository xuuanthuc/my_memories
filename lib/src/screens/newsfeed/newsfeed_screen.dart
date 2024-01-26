import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:my_memories/global/style/app_colors.dart';
import 'package:my_memories/src/screens/newsfeed/bloc/newsfeed_cubit.dart';
import 'package:my_memories/src/screens/newsfeed/widgets/newsfeed_calendar_item.dart';
import 'package:my_memories/src/screens/newsfeed/widgets/newsfeed_item.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
import 'package:scrollview_observer/scrollview_observer.dart';

import '../../../global/style/app_images.dart';

class NewsfeedScreen extends StatefulWidget {
  const NewsfeedScreen({super.key});

  @override
  State<NewsfeedScreen> createState() => _NewsfeedScreenState();
}

class _NewsfeedScreenState extends State<NewsfeedScreen> {
  final AutoScrollController _newsfeedController = AutoScrollController();
  final AutoScrollController _calendarController = AutoScrollController();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NewsfeedCubit, NewsfeedState>(
      builder: (context, state) {
        return Column(
          children: [
            Container(
              height: 120,
              child: Stack(
                children: [
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      height: 110,
                      margin: EdgeInsets.symmetric(horizontal: 10),
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: AppColors.primary, width: 1),
                        color: AppColors.primary.withOpacity(0.1),
                      ),
                      child: BlocBuilder<NewsfeedCubit, NewsfeedState>(
                        builder: (context, state) {
                          if ((state.posts ?? []).isEmpty) {
                            return Container();
                          }
                          return ListView.separated(
                            controller: _calendarController,
                            separatorBuilder: (_, __) => SizedBox(width: 10),
                            scrollDirection: Axis.horizontal,
                            itemCount: state.posts?.length ?? 0,
                            itemBuilder: (context, index) {
                              return AutoScrollTag(
                                key: ValueKey(index),
                                controller: _calendarController,
                                index: index,
                                child: GestureDetector(
                                  onTap: () {
                                    _newsfeedController.scrollToIndex(
                                      index,
                                      preferPosition: AutoScrollPosition.begin,
                                      duration: Duration(milliseconds: 500),
                                    );
                                  },
                                  child: NewsfeedCalendarItem(
                                    post: (state.posts ?? [])[index],
                                    onFocus: state.currentIndex == index,
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      ),
                    ),
                  ),
                  RotationTransition(
                    turns: AlwaysStoppedAnimation(325 / 360),
                    child: Padding(
                      padding: const EdgeInsets.all(4),
                      child: SvgPicture.asset(
                        AppImages.heart,
                        height: 20,
                        width: 20,
                        colorFilter: ColorFilter.mode(
                          AppColors.primary,
                          BlendMode.srcIn,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: BlocBuilder<NewsfeedCubit, NewsfeedState>(
                buildWhen: (prev, cur) => prev.posts != cur.posts,
                builder: (context, state) {
                  if ((state.posts ?? []).isEmpty) {
                    return Container();
                  }
                  return ListViewObserver(
                    onObserve: (resultModel) {
                      _calendarController.scrollToIndex(
                        resultModel.firstChild?.index ?? 0,
                        preferPosition: AutoScrollPosition.begin,
                        duration: Duration(milliseconds: 500),
                      );
                      context.read<NewsfeedCubit>().onCurrentIndexChange(
                            resultModel.firstChild?.index ?? 0,
                          );
                    },
                    child: ListView.builder(
                      controller: _newsfeedController,
                      itemCount: state.posts?.length,
                      itemBuilder: (context, index) {
                        return AutoScrollTag(
                          key: ValueKey(index),
                          controller: _newsfeedController,
                          index: index,
                          child: NewsfeedItem(
                            post: (state.posts ?? [])[index],
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}
