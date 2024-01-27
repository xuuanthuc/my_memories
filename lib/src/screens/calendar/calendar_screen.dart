import 'dart:async';

import 'package:flutter/material.dart';
import 'package:jiffy/jiffy.dart';
import 'package:lottie/lottie.dart';
import 'package:my_memories/global/style/app_colors.dart';
import 'package:my_memories/global/style/app_images.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  @override
  void initState() {
    super.initState();
    _streamController.addStream(_stream);
  }

  final StreamController<int> _streamController = StreamController<int>();

  final Stream<int> _stream =
      Stream.periodic(Duration(seconds: 1), (value) => value);

  vehicleAge(DateTime doPurchase, DateTime doRenewel) {
    var dt1 = Jiffy.parseFromDateTime(doPurchase);
    var dt2 = Jiffy.parseFromDateTime(doRenewel);

    // int years = int.parse("${dt2.diff(dt1, unit: Unit.year)}");
    // dt1.add(years: years);
    //
    // int month = int.parse("${dt2.diff(dt1, unit: Unit.month)}");
    // dt1.add(months: month);

    var days = dt2.diff(dt1, unit: Unit.day);

    return "$days Days";
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Lottie.asset(AppImages.iLoveU),
        Column(
          children: [
            Text(
              vehicleAge(DateTime(2024, 1, 25), DateTime.now()),
              style: TextStyle(
                  fontSize: 50,
                  fontFamily: 'RubikMoonrocks',
                  color: AppColors.primary),
            ),
            Text(
              '27/01/2024',
              style: TextStyle(
                fontSize: 25,
                fontFamily: 'Chewy',
                color: AppColors.primary.withOpacity(0.8),
              ),
            ),
          ],
        ),
        Container(
          width: MediaQuery.sizeOf(context).width * 0.7,
          padding: const EdgeInsets.only(bottom: 100),
          child: Lottie.asset(AppImages.cat),
        ),
      ],
    );
  }
}
