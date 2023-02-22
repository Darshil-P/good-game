import 'package:flutter/material.dart';
import 'package:goodgame/services/auth_service.dart';
import 'package:goodgame/views/game_details_page.dart';
import 'package:goodgame/views/home_page.dart';
import 'package:goodgame/views/search_page.dart';
import 'package:goodgame/views/signin_page.dart';
import 'package:goodgame/views/signup_page.dart';
import 'package:goodgame/views/test_page.dart';
import 'package:goodgame/views/verifyotp_page.dart';

class RouteGenerator {
  static Route generateRoute(RouteSettings settings) {
    final args = settings.arguments;

    switch (settings.name) {
      case '/':
        if (signedIn()) {
          return MaterialPageRoute(builder: (_) => const UserHomePage());
        }
        return MaterialPageRoute(builder: (_) => const HomePage());
      case '/test':
        return MaterialPageRoute(builder: (_) => const TestPage());
      case '/signIn':
        return MaterialPageRoute(builder: (_) => const SignInPage());
      case '/signUp':
        return MaterialPageRoute(builder: (_) => const SignUpPage());
      case '/verifyOTP':
        return MaterialPageRoute(builder: (_) => VerifyOTPPage(args as List));
      case '/search':
        return MaterialPageRoute(builder: (_) => const SearchPage());
      case '/game':
        return MaterialPageRoute(
            builder: (_) => GameDetailsPage((args as List)[0]));
      default:
        return _errorRoute(settings.name);
    }
  }

  static Route<dynamic> _errorRoute(route) {
    return MaterialPageRoute(builder: (_) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Error'),
        ),
        body: Center(
          child: Text('Page "$route" Not Found'),
        ),
      );
    });
  }
}
