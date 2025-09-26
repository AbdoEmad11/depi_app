import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'cubits/auth_state.dart';
import 'screens/login_screen.dart';
import 'screens/home_screen.dart';
import 'cubits/auth_cubit.dart';
import 'cubits/characters_cubit.dart';
import 'services/auth_service.dart';
import 'services/api_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Color primaryBlue = Colors.blue;
    final Color scaffoldBlack = Colors.black;

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => AuthCubit(AuthService()),
        ),
        BlocProvider(
          create: (context) => CharactersCubit(ApiService()),
        ),
      ],
      child: MaterialApp(
        title: 'Flutter Auth App',
        theme: ThemeData.dark().copyWith(
          colorScheme: const ColorScheme.dark().copyWith(
            primary: Colors.blue,
            secondary: Colors.blueAccent,
          ),
          primaryColor: primaryBlue,
          scaffoldBackgroundColor: scaffoldBlack,
          appBarTheme: const AppBarTheme(
            backgroundColor: Colors.black,
            foregroundColor: Colors.white,
            elevation: 0,
          ),
          inputDecorationTheme: const InputDecorationTheme(
            filled: true,
            fillColor: Color(0xFF101010),
            hintStyle: TextStyle(color: Colors.white70),
          ),
          cardColor: const Color(0xFF101010),
          canvasColor: scaffoldBlack,
          dialogBackgroundColor: const Color(0xFF151515),
          snackBarTheme: const SnackBarThemeData(
            backgroundColor: Color(0xFF202020),
            contentTextStyle: TextStyle(color: Colors.white),
          ),
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: AuthWrapper(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}

class AuthWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) {
        if (state is AuthAuthenticated) {
          return HomeScreen();
        }
        return LoginScreen();
      },
    );
  }
}