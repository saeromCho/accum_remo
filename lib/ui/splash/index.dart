import 'dart:async';

import 'package:after_layout/after_layout.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:local_db_sqlite/infra/storage_service.dart';
import 'package:local_db_sqlite/utils/path.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with AfterLayoutMixin {
  void appInitialize() async {
    /// secure_storage 내 userId 키값을 통해 값이 있으면 메모리스트 스크린으로 랜딩, 없으면 로그인 스크린으로 랜딩
    final storageService = StorageService();
    final userId = await storageService.getUserId();

    if (userId != null) {
      if (mounted) {
        context.goNamed(RemoPath.memos.name);
      }
    } else {
      if (mounted) {
        context.goNamed(RemoPath.login.name);
      }
    }
  }

  @override
  FutureOr<void> afterFirstLayout(BuildContext context) async {
    appInitialize();
  }

  @override
  Widget build(BuildContext context) {
    return const CircularProgressIndicator();
  }
}
