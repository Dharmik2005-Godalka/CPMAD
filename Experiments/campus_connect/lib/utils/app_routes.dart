import 'package:flutter/material.dart';
import '../models/student.dart';
import '../screens/home_screen.dart';
import '../screens/login_screen.dart';
import '../screens/register_screen.dart';
import '../screens/splash_screen.dart';
import '../screens/student_details_screen.dart';
import '../screens/student_form_screen.dart';
import '../screens/onboarding_screen.dart';
import '../models/note.dart';
import '../screens/event_form_screen.dart';
import '../screens/note_editor_screen.dart';
import '../screens/event_details_screen.dart';

class AppRoutes 
{
  static const splash = '/';
  static const login = '/login';
  static const register = '/register';
  static const home = '/home';
  static const studentDetails = '/student-details';
  static const studentForm = '/student-form';
  static const onboarding = '/onboarding';
  static const eventForm = '/event-form';
  static const noteEditor = '/note-editor';
  static const eventDetails = '/event-details';

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
      case eventForm:
        return _page(const EventFormScreen());
      case noteEditor:
        return _page(NoteEditorScreen(note: settings.arguments as Note?));
      case eventDetails:
        return _fadeSlidePage(
          EventDetailsScreen(
            event: (settings.arguments as EventDetailsArgs).event,
            heroTag: (settings.arguments as EventDetailsArgs).heroTag,
          ),
          settings,
        );
      case splash:
      default:
        return _page(const SplashScreen());
    }
  }

  static MaterialPageRoute<dynamic> _page(Widget screen) 
  {
    return MaterialPageRoute(builder: (_) => screen);
  }

  static PageRouteBuilder<dynamic> _fadeSlidePage(
    Widget screen,
    RouteSettings settings,
  ) {
    return PageRouteBuilder(
      settings: settings,
      transitionDuration: const Duration(milliseconds: 450),
      pageBuilder: (context, animation, secondaryAnimation) => screen,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        final slide = Tween(
          begin: const Offset(0, 0.15),
          end: Offset.zero,
        ).chain(CurveTween(curve: Curves.easeOutCubic));

        return FadeTransition(
          opacity: animation,
          child: SlideTransition(position: animation.drive(slide), child: child),
        );
      },
    );
  }
}
