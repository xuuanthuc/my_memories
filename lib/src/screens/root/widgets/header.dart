import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:my_memories/global/flavor/app_flavor.dart';
import 'package:my_memories/src/screens/newsfeed/bloc/message_cubit.dart';

import '../../../../global/style/app_colors.dart';
import '../../../../global/style/app_images.dart';
import 'message_dialog.dart';

class NewsfeedHeader extends StatefulWidget {
  const NewsfeedHeader({super.key});

  @override
  State<NewsfeedHeader> createState() => _NewsfeedHeaderState();
}

class _NewsfeedHeaderState extends State<NewsfeedHeader>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    )..addStatusListener((status) {
        if (status == AnimationStatus.completed) _controller.reverse();
        if (status == AnimationStatus.dismissed) {
          _controller.forward();
        }
      });
    _controller.forward();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Row(
        children: [
          Expanded(
            child: Text(
              'Hi bé ${(AppFlavor.appFlavor == Flavor.female) ? "Cúnn" : "Mặp"} 🫶',
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 24,
              ),
            ),
          ),
          BlocBuilder<MessageCubit, MessageState>(
            builder: (context, state) {
              return IconButton(
                onPressed: () async {
                  await showDialog<void>(
                    context: context,
                    builder: (BuildContext context) {
                      return MessageDialog(
                        message: state.message,
                      );
                    },
                  ).then((value) {
                    context.read<MessageCubit>().deleteMessage();
                  });
                },
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(
                    Colors.transparent,
                  ),
                  padding: MaterialStateProperty.all(EdgeInsets.zero),
                ),
                icon: Container(
                  padding: EdgeInsets.all(5),
                  width: 50,
                  height: 50,
                  child: Stack(
                    children: [
                      Align(
                        alignment: Alignment.center,
                        child: SvgPicture.asset(
                          AppImages.letter,
                          height: 35,
                          width: 35,
                          colorFilter: ColorFilter.mode(
                            Colors.black,
                            BlendMode.srcIn,
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.topRight,
                        child: Opacity(
                          opacity: state.message != null ? 1 : 0,
                          child: RotationTransition(
                            turns: Tween(begin: -0.1, end: 0.1)
                                .animate(_controller),
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
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
