import 'package:flutter/material.dart';
import '../models/student.dart';
import '../screens/home_screen.dart';
import '../screens/login_screen.dart';
import '../screens/register_screen.dart';
import '../screens/splash_screen.dart';
import '../screens/student_details_screen.dart';
import '../screens/student_form_screen.dart';
import '../screens/onboarding_screen.dart';

class AppRoutes 
{
  static const splash = '/';
  static const login = '/login';
  static const register = '/register';
  static const home = '/home';
  static const studentDetails = '/student-details';
  static const studentForm = '/student-form';
    static const onboarding = '/onboarding';

  static Route<dynamic> generateRoute(RouteSettings settings) 
  {
    switch (settings.name) 
    {
      case login:
        return _page(const LoginScreen());
      case onboarding:
        return _page(const OnboardingScreen());
      case register:
        return _page(const RegisterScreen());
      case home:
        return _page(const HomeScreen());
      case studentDetails:
        return _page(StudentDetailsScreen(
          studentId: settings.arguments as String,
        ));
      case studentForm:
        return _page(StudentFormScreen(
          student: settings.arguments as Student?,
        ));
      case splash:
      default:
        return _page(const SplashScreen());
    }
  }

  static MaterialPageRoute<dynamic> _page(Widget screen) 
  {
    return MaterialPageRoute(builder: (_) => screen);
  }
}
