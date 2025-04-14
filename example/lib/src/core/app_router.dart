// initialRoute: '/',
//       routes: {
//         '/': (context) => const SignUp(),
//         '/magic_link': (context) => const MagicLink(),
//         '/update_password': (context) => const UpdatePassword(),
//         '/phone_sign_in': (context) => const PhoneSignIn(),
//         '/phone_sign_up': (context) => const PhoneSignUp(),
//         '/verify_phone': (context) => const VerifyPhone(),
//         '/home': (context) => const Home(),
//       },

import 'dart:async';

import 'package:example/src/core/constants.dart';
import 'package:example/src/views/screens/home.dart';
import 'package:example/src/views/screens/magic_link.dart';
import 'package:example/src/views/screens/phone_sign_in.dart';
import 'package:example/src/views/screens/sign_in_up.dart';
import 'package:example/src/views/screens/splash.dart';
import 'package:example/src/views/screens/update_password.dart';
import 'package:example/src/views/screens/verify_phone.dart';
import 'package:flutter/foundation.dart';
import 'package:go_router/go_router.dart';

// define the app routes enum with the path for each screen
enum AppRoute {
  signInUp('/sign_in_up'),
  magicLink('/magic_link'),
  updatePassword('/update_password'),
  phoneSignIn('/phone_sign_in'),
  phoneSignUp('/phone_sign_up'),
  verifyPhone('/verify_phone'),
  home('/'),
  splash('/splash');

  const AppRoute(this.path);
  final String path;
}

// define the app router using GoRouter
final appRouter = GoRouter(
  initialLocation: AppRoute.splash.path,
  debugLogDiagnostics: true,
  redirect: (context, state) {
    // Check if the user is authenticated
    final user = supa.auth.currentUser;
    final isAuthenticated = user != null;

    // If the user is authenticated and trying to access the sign-in page, redirect to home
    if (isAuthenticated && (state.matchedLocation == AppRoute.signInUp.path || state.matchedLocation == AppRoute.splash.path)) {
      return AppRoute.home.path;
    }

    // If the user is not authenticated and trying to access the home page, redirect to sign-in
    if (!isAuthenticated && (state.matchedLocation == AppRoute.home.path || state.matchedLocation == AppRoute.splash.path)) {
      return AppRoute.signInUp.path;
    }

    return null;
  },
  refreshListenable: GoRouterRefreshStream(supa.auth.onAuthStateChange),
  routes: [
    // define the splash screen route
    GoRoute(
      path: AppRoute.splash.path,
      builder: (context, state) => const Splash(),
    ),

    GoRoute(
      name: AppRoute.signInUp.name,
      path: AppRoute.signInUp.path,
      builder: (context, state) => const SignInUp(),
    ),
    GoRoute(
      name: AppRoute.magicLink.name,
      path: AppRoute.magicLink.path,
      builder: (context, state) => const MagicLink(),
    ),
    GoRoute(
      name: AppRoute.updatePassword.name,
      path: AppRoute.updatePassword.path,
      builder: (context, state) => const UpdatePassword(),
    ),
    GoRoute(
      name: AppRoute.phoneSignIn.name,
      path: AppRoute.phoneSignIn.path,
      builder: (context, state) => const PhoneSignIn(),
    ),
    GoRoute(
      name: AppRoute.phoneSignUp.name,
      path: AppRoute.phoneSignUp.path,
      builder: (context, state) => const PhoneSignIn(),
    ),
    GoRoute(
      name: AppRoute.verifyPhone.name,
      path: AppRoute.verifyPhone.path,
      builder: (context, state) => const VerifyPhone(),
    ),
    GoRoute(
      name: AppRoute.home.name,
      path: AppRoute.home.path,
      builder: (context, state) => const Home(),
    ),
  ],
);

class GoRouterRefreshStream with ChangeNotifier {
  GoRouterRefreshStream(Stream stream) {
    _subscription = stream.listen((_) {
      notifyListeners();
    });
  }

  late final StreamSubscription _subscription;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
