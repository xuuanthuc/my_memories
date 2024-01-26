import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../global/style/app_colors.dart';
import '../../../../global/style/app_images.dart';

class NewsfeedHeader extends StatelessWidget {
  const NewsfeedHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Row(
        children: [
          Expanded(
            child: Text(
              'Hi Xuuan!',
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 24,
              ),
            ),
          ),
          IconButton(
            onPressed: () {},
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
                    child: Visibility(
                      visible: true,
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
          ),
        ],
      ),
    );
  }
}
