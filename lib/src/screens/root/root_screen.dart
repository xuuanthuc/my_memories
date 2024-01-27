import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_memories/global/style/app_colors.dart';
import 'package:my_memories/src/screens/calendar/calendar_screen.dart';
import 'package:my_memories/src/screens/menu/menu_screen.dart';
import 'package:my_memories/src/screens/newsfeed/bloc/newsfeed_cubit.dart';
import 'package:my_memories/src/screens/newsfeed/newsfeed_screen.dart';
import 'package:my_memories/src/screens/root/bloc/root_cubit.dart';
import 'package:my_memories/src/screens/root/widgets/bottom_nav_bar.dart';

import '../../../global/utilities/toast.dart';
import '../../global_bloc/connectivity/connectivity_bloc.dart';
import 'widgets/header.dart';

class RootScreen extends StatefulWidget {
  const RootScreen({Key? key}) : super(key: key);

  @override
  State<RootScreen> createState() => _RootScreenState();
}

class _RootScreenState extends State<RootScreen> {
  @override
  void initState() {
    super.initState();
    context.read<NewsfeedCubit>().getNewsfeed();
  }

  @override
  Widget build(BuildContext context) {
    final PageController _controller = PageController();
    return BlocListener<ConnectivityBloc, ConnectivityState>(
      listener: (context, state) {
        if (state is ConnectivityChangedState) {
          if (state.result == ConnectivityResult.none) {
            appToast(context, message: "No connection");
          }
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: AppColors.primary,
          toolbarHeight: 0,
          systemOverlayStyle: SystemUiOverlayStyle(
            statusBarColor: Colors.white,
            statusBarIconBrightness: Brightness.dark,
            statusBarBrightness: Brightness.dark,
          ),
        ),
        body: Stack(
          children: [
            Column(
              children: [
                NewsfeedHeader(),
                BlocListener<RootCubit, RootState>(
                  listener: (context, state) {
                    _controller.animateToPage(
                      state.currentPage,
                      duration: Duration(milliseconds: 400),
                      curve: Curves.ease,
                    );
                  },
                  child: Expanded(
                    child: PageView(
                      physics: NeverScrollableScrollPhysics(),
                      controller: _controller,
                      children: [
                        NewsfeedScreen(),
                        CalendarScreen(),
                        MenuScreen(),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            PrimaryBottomNavBar(),
          ],
        ),
      ),
    );
  }
}
