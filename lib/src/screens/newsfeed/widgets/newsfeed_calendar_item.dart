import 'package:flutter/material.dart';
import 'package:my_memories/global/style/app_colors.dart';
import 'package:my_memories/src/models/response/post.dart';

import '../../../../global/utilities/format.dart';

class NewsfeedCalendarItem extends StatelessWidget {
  final PostData post;
  final bool onFocus;

  const NewsfeedCalendarItem({
    super.key,
    required this.post,
    required this.onFocus,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      padding: EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: onFocus ? AppColors.primary : Colors.transparent,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            Formatter.timeToString(
              Formatter.stringToTime(post.time),
              formatType: 'dd',
            ),
            style: TextStyle(
                color: onFocus ? Colors.white : Colors.black,
                fontWeight: FontWeight.w700,
                fontSize: 16),
          ),
          Text(
            Formatter.timeToString(
              Formatter.stringToTime(post.time),
              formatType: 'MMM',
            ),
            style: TextStyle(
              color: onFocus ? Colors.white : Colors.black,
              // fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 6),
          Container(
            height: 1,
            color: onFocus ? Colors.white : Colors.grey.shade700,
            width: 30,
          ),
          const SizedBox(height: 2),
          Text(
            Formatter.timeToString(
              Formatter.stringToTime(post.time),
              formatType: 'yyyy',
            ),
            style: TextStyle(
              color: onFocus ? Colors.white : Colors.grey.shade700,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }
}
