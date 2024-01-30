import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:my_memories/global/flavor/app_flavor.dart';
import 'package:my_memories/global/style/app_images.dart';
import 'package:my_memories/src/models/response/post.dart';
import '../../../../global/style/app_colors.dart';

class MessageDialog extends StatelessWidget {
  final PostData? message;

  const MessageDialog({
    super.key,
    this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.transparent,
      insetPadding: const EdgeInsets.all(10),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(15),
        ),
      ),
      child: Container(
        padding: EdgeInsets.all(10),
        child: DottedBorder(
          borderType: BorderType.RRect,
          radius: Radius.circular(12),
          padding: EdgeInsets.zero,
          color: AppColors.primary,
          child: (message != null && AppFlavor.appFlavor.name != message?.user)
              ? Container(
                  padding: EdgeInsets.all(10),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          SizedBox(
                            width: MediaQuery.sizeOf(context).width,
                          ),
                          Container(
                            width: MediaQuery.sizeOf(context).width * 0.7,
                            child: Lottie.asset(AppImages.heartMessage),
                          ),
                          const SizedBox(height: 15),
                          Text(
                            message?.body ?? '',
                          ),
                          const SizedBox(height: 15),
                          Visibility(
                            visible: (message?.image ?? '').isNotEmpty,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.network(
                                message?.image ?? '',
                                fit: BoxFit.fitWidth,
                              ),
                            ),
                          ),
                          const SizedBox(height: 15),
                          IconButton(
                            onPressed: () => Navigator.of(context).pop(),
                            icon: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.close,
                                  color: AppColors.primary,
                                ),
                                Text(
                                  "Đóng",
                                  style: TextStyle(
                                    color: AppColors.primary,
                                  ),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              : Container(
                  padding: EdgeInsets.all(30).copyWith(bottom: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        width: MediaQuery.sizeOf(context).width,
                        height: 15,
                      ),
                      Text(
                        "Chưa có tin nhắn nào gửi đến ${(AppFlavor.appFlavor == Flavor.female) ? "Cún" : "Mặp"}! Hãy đợi ${(AppFlavor.appFlavor == Flavor.female) ? "Mặp" : "Cún"} gửi tin nhắn nhé ",
                        textAlign: TextAlign.center,
                      ),
                      Lottie.asset(AppImages.empty),
                      IconButton(
                        onPressed: () => Navigator.of(context).pop(),
                        icon: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.close,
                              color: AppColors.primary,
                            ),
                            Text(
                              "Đóng",
                              style: TextStyle(
                                color: AppColors.primary,
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
        ),
      ),
    );
  }
}
