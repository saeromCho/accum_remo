import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:local_db_sqlite/ui/login/index.dart';
import 'package:local_db_sqlite/ui/memos/index.dart';
import 'package:local_db_sqlite/ui/register/index.dart';
import 'package:local_db_sqlite/utils/path.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  GoRouter get _router => GoRouter(
        initialLocation: '/login',
        debugLogDiagnostics: true,
        routes: [
          GoRoute(
            path: RemoPath.login.path,
            name: RemoPath.login.name,
            builder: (_, state) => const LoginScreen(),
            routes: [
              GoRoute(
                path: RemoPath.register.path,
                name: RemoPath.register.name,
                builder: (_, state) => const RegisterScreen(),
              ),
              GoRoute(
                path: RemoPath.memos.path,
                name: RemoPath.memos.name,
                builder: (_, state) => const MemosScreen(),
              ),
            ],
          ),
        ],
      );
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Remo',
      routerConfig: _router,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.blueGrey[900], // 예를 들어 어두운 남색 계열
        // colorScheme: ColorScheme.fromSeed(seedColor: Color(0xFF424242)),
        useMaterial3: true,
      ),
      // home: const MyHomePage(),
    );
  }
}
