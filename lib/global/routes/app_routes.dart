import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_memories/src/di/dependencies.dart';
import 'package:my_memories/src/screens/newsfeed/bloc/newsfeed_cubit.dart';
import 'package:my_memories/src/screens/root/bloc/root_cubit.dart';
import './../../src/screens/root/root_screen.dart';
import '../../src/screens/splash/splash_screen.dart';
import 'route_keys.dart';

class AppRoutes {
  static Route? onGenerateRoutes(RouteSettings settings) {
    String routeSettings = settings.name ?? '';
    switch (settings.name) {
      case RouteKey.splash:
        return _materialRoute(
          routeSettings,
          const SplashScreen(),
        );
      case RouteKey.root:
        return _materialRoute(
          routeSettings,
          MultiBlocProvider(
            providers: [
              BlocProvider(create: (context) => getIt.get<RootCubit>()),
              BlocProvider(create: (context) => getIt.get<NewsfeedCubit>()),
            ],
            child: const RootScreen(),
          ),
        );
      default:
        return null;
    }
  }

  static List<Route> onGenerateInitialRoute() {
    return [_materialRoute(RouteKey.splash, const SplashScreen())];
  }

  static Route<dynamic> _materialRoute(String routeSettings, Widget view) {
    return PageRouteBuilder(
      settings: RouteSettings(name: routeSettings),
      pageBuilder: (_, __, ___) => view,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(1, 0);
        const end = Offset.zero;
        const curve = Curves.ease;
        var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }
}
