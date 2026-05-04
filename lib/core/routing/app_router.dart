import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';
import 'package:tadweer/core/routing/routes.dart';
import 'package:tadweer/features/auth/presentation/screens/email_verified_screen.dart';
import 'package:tadweer/features/auth/presentation/screens/forget_password_screen.dart';
import 'package:tadweer/features/auth/presentation/screens/login_screen.dart';
import 'package:tadweer/features/auth/presentation/screens/sign_up_screen.dart';
import 'package:tadweer/features/home/models/task_model.dart';
import 'package:tadweer/features/home/presentation/views/home_view.dart';
import 'package:tadweer/features/home/presentation/views/edit_task_view.dart';
import 'package:tadweer/features/onboarding/presentation/screens/on_boarding_screen.dart';
import 'package:tadweer/features/onboarding/presentation/screens/splash_screen.dart';
import 'package:tadweer/features/chatbot/presentation/chat_screen.dart';

abstract class AppRouter {
  static late final GoRouter router;

  static void initRouter() {
    router = GoRouter(
      initialLocation: Routes.splash,
      redirect: (context, state) {
        final user = FirebaseAuth.instance.currentUser;
        final bool isLoggedIn = user != null;

        final bool isAuthPath = state.matchedLocation == Routes.loginView ||
            state.matchedLocation == Routes.registerView ||
            state.matchedLocation == Routes.forgetpasssword;

        final bool isProtectedPath = state.matchedLocation == Routes.homeview ||
            state.matchedLocation == Routes.taskediting ||
            state.matchedLocation == Routes.chatbot;

        if (!isLoggedIn && isProtectedPath) {
          return Routes.loginView;
        }

        if (isLoggedIn && (isAuthPath || state.matchedLocation == Routes.splash)) {
          return Routes.homeview;
        }

        return null;
      },
      routes: [
        GoRoute(
          path: Routes.splash,
          builder: (context, state) => const SplashScreen(),
        ),
        GoRoute(
          path: Routes.onboarding,
          builder: (context, state) => const OnBoardingScreen(),
        ),
        GoRoute(
          path: Routes.loginView,
          builder: (context, state) => const LoginScreen(),
        ),
        GoRoute(
          path: Routes.forgetpasssword,
          builder: (context, state) => const ForgetPasswordScreen(),
        ),
        GoRoute(
          path: Routes.registerView,
          builder: (context, state) => const SignUpScreen(),
        ),
        GoRoute(
          path: Routes.emailVerifiedView,
          builder: (context, state) => const EmailVerifiedScreen(),
        ),
        GoRoute(
          path: Routes.homeview,
          builder: (context, state) => const HomeView(),
        ),
        GoRoute(
          path: Routes.taskediting,
          builder: (context, state) {
            final task = state.extra as TaskModel?;
            if (task == null) {
              return const HomeView();
            }
            return EditTaskScreen(task: task);
          },
        ),
        GoRoute(
          path: Routes.chatbot,
          builder: (context, state) {
            final tasks = state.extra as List<TaskModel>? ?? [];
            return ChatBotScreen(tasks: tasks);
          },
        ),
      ],
    );
  }
}