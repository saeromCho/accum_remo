import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:local_db_sqlite/infra/storage_service.dart';
import 'package:local_db_sqlite/utils/path.dart';

class LogoutTextButton extends StatelessWidget {
  const LogoutTextButton({
    super.key,
    required this.storageService,
    required this.mounted,
  });

  final StorageService storageService;
  final bool mounted;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () async {
        await storageService.clear();
        if (mounted) {
          context.goNamed(RemoPath.login.name);
        }
      },
      child: const Text(
        '로그아웃',
        style: TextStyle(
          color: Colors.white,
        ),
      ),
    );
  }
}
