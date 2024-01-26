import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:my_memories/global/style/app_colors.dart';
import 'package:my_memories/global/style/app_images.dart';
import 'package:my_memories/src/di/dependencies.dart';
import 'package:my_memories/src/screens/root/bloc/bottom_sheet_cubit.dart';
import 'package:my_memories/src/screens/root/bloc/root_cubit.dart';

import 'create_post_sheet.dart';

class PrimaryBottomNavBar extends StatelessWidget {
  const PrimaryBottomNavBar({super.key});

  void _showCreatePost(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(10.0)),
      ),
      builder: (BuildContext context) {
        return BlocProvider(
          create: (context) => getIt.get<BottomSheetCubit>(),
          child: CreatePostSheet(),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        margin: EdgeInsets.all(20),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.5),
                borderRadius: BorderRadius.circular(20),
              ),
              padding: EdgeInsets.all(6),
              child: BlocBuilder<RootCubit, RootState>(
                builder: (context, state) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      PrimaryBottomNavBarItem(
                        iconSelected: AppImages.heart,
                        iconUnselected: AppImages.heartOutline,
                        value: state.currentPage == 0,
                        onPressItem: () {
                          context.read<RootCubit>().onPageChanged(0);
                        },
                      ),
                      PrimaryBottomNavBarItem(
                        iconSelected: AppImages.calendar,
                        iconUnselected: AppImages.calendarOutline,
                        value: state.currentPage == 1,
                        onPressItem: () {
                          context.read<RootCubit>().onPageChanged(1);
                        },
                      ),
                      PrimaryBottomNavBarItem(
                        iconSelected: AppImages.edit,
                        iconUnselected: AppImages.edit,
                        value: false,
                        onPressItem: () {
                          _showCreatePost(context);
                        },
                      ),
                      PrimaryBottomNavBarItem(
                        iconSelected: AppImages.setting,
                        iconUnselected: AppImages.settingOutline,
                        value: state.currentPage == 2,
                        onPressItem: () {
                          context.read<RootCubit>().onPageChanged(2);
                        },
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class PrimaryBottomNavBarItem extends StatelessWidget {
  final String iconSelected;
  final String iconUnselected;
  final bool value;
  final Function onPressItem;

  const PrimaryBottomNavBarItem({
    super.key,
    required this.iconSelected,
    required this.iconUnselected,
    required this.value,
    required this.onPressItem,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: SizedBox(
        height: 45,
        child: IconButton(
          onPressed: () => onPressItem(),
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(
              value ? AppColors.primary : Colors.transparent,
            ),
            shape: MaterialStateProperty.all(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
          ),
          icon: SvgPicture.asset(
            value ? iconSelected : iconUnselected,
            colorFilter: ColorFilter.mode(
              Colors.white,
              BlendMode.srcIn,
            ),
          ),
        ),
      ),
    );
  }
}
