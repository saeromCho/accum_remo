import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:local_db_sqlite/ui/login/index.dart';
import 'package:local_db_sqlite/ui/memo/detail/index.dart';
import 'package:local_db_sqlite/ui/memo/edit/index.dart';
import 'package:local_db_sqlite/ui/memo/write/index.dart';
import 'package:local_db_sqlite/ui/memos/index.dart';
import 'package:local_db_sqlite/ui/register/index.dart';
import 'package:local_db_sqlite/ui/splash/index.dart';
import 'package:local_db_sqlite/utils/path.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  GoRouter get _router => GoRouter(
        // initialLocation: RemoPath.login.name, //RemoPath.login.name,
        initialLocation: RemoPath.splash.name, //RemoPath.login.name,
        debugLogDiagnostics: true,
        routes: [
          GoRoute(
            path: RemoPath.splash.path,
            name: RemoPath.splash.name,
            builder: (_, state) => const SplashScreen(),
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
                ],
              ),

              /// FIXME: memo 리스트 스크린에 백버튼이 보여서 로그인 스크린과 동일한 뎁스로 뺐음. 원래 로그인 스크린 안에 존재했었음.
              GoRoute(
                path: RemoPath.memos.path,
                name: RemoPath.memos.name,
                builder: (_, state) => const MemosScreen(),
                routes: [
                  GoRoute(
                    path: RemoPath.memoWrite.path,
                    name: RemoPath.memoWrite.name,
                    builder: (_, state) => const MemoWriteScreen(),
                  ),
                  GoRoute(
                    path: '${RemoPath.memoDetail.path}/:memoId',
                    name: RemoPath.memoDetail.name,
                    builder: (_, state) => MemoDetailScreen(
                      memoId: state.pathParameters['memoId']!,
                    ),
                  ),
                  GoRoute(
                    path: '${RemoPath.memoEdit.path}/:memoId',
                    name: RemoPath.memoEdit.name,
                    builder: (_, state) => MemoEditScreen(
                      memoId: state.pathParameters['memoId']!,
                    ),
                  ),
                ],
              ),
            ],
          ),

          // GoRoute(
          //   path: RemoPath.login.path,
          //   name: RemoPath.login.name,
          //   builder: (_, state) => const LoginScreen(),
          //   routes: [
          //     GoRoute(
          //       path: RemoPath.register.path,
          //       name: RemoPath.register.name,
          //       builder: (_, state) => const RegisterScreen(),
          //     ),
          //   ],
          // ),
          //
          // /// FIXME: memo 리스트 스크린에 백버튼이 보여서 로그인 스크린과 동일한 뎁스로 뺐음. 원래 로그인 스크린 안에 존재했었음.
          // GoRoute(
          //   path: RemoPath.memos.path,
          //   name: RemoPath.memos.name,
          //   builder: (_, state) => const MemosScreen(),
          //   routes: [
          //     GoRoute(
          //       path: RemoPath.memoWrite.path,
          //       name: RemoPath.memoWrite.name,
          //       builder: (_, state) => const MemoWriteScreen(),
          //     ),
          //     GoRoute(
          //       path: '${RemoPath.memoDetail.path}/:memoId',
          //       name: RemoPath.memoDetail.name,
          //       builder: (_, state) => MemoDetailScreen(
          //         memoId: state.pathParameters['memoId']!,
          //       ),
          //     ),
          //     GoRoute(
          //       path: '${RemoPath.memoEdit.path}/:memoId',
          //       name: RemoPath.memoEdit.name,
          //       builder: (_, state) => MemoEditScreen(
          //         memoId: state.pathParameters['memoId']!,
          //       ),
          //     ),
          //   ],
          // ),
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
