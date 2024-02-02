import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:local_db_sqlite/db/db_helper.dart';
import 'package:local_db_sqlite/infra/storage_service.dart';
import 'package:local_db_sqlite/model/memo.dart';
import 'package:local_db_sqlite/utils/formatter.dart';
import 'package:local_db_sqlite/utils/path.dart';

class MemoWriteScreen extends StatefulWidget {
  const MemoWriteScreen({super.key});

  @override
  State<MemoWriteScreen> createState() => MemoWriteScreenState();
}

class MemoWriteScreenState extends State<MemoWriteScreen> {
  final storageService = StorageService();
  final memoController = TextEditingController();
  int? _currentMemoId;
  String? _createdAt; // createdAt 값을 저장할 필드

  @override
  void initState() {
    super.initState();
    _currentMemoId = null;
  }

  void _onMemoChanged(String value) async {
    List<String> lines = value.split('\n');
    String title = '';
    String content = '';

    // 첫 번째 비어 있지 않은 줄의 인덱스를 찾습니다.
    int nonEmptyLineIndex = lines.indexWhere((line) => line.trim().isNotEmpty);

    if (nonEmptyLineIndex != -1) {
      // 첫 번째 비어 있지 않은 줄이 있으면 그 줄까지를 title로 설정합니다.
      title = lines.sublist(0, nonEmptyLineIndex + 1).join('\n');
      // 나머지 줄을 content로 설정합니다.
      content = lines.sublist(nonEmptyLineIndex + 1).join('\n');
    } else {
      // 모든 줄이 비어 있으면 title은 전체 값을 content는 빈 문자열로 설정합니다.
      title = value;
      content = '';
    }

    if (title.isNotEmpty) {
      final now = DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now());
      Memo memo = Memo(
        id: _currentMemoId,
        userId: 2,
        title: title,
        content: content,
        password: null,
        createdAt: now,
        updatedAt: now,
        isPrivate: 0,
      );

      if (_currentMemoId == null) {
        _currentMemoId = await DBHelper().insertMemo(memo);
        _createdAt = memo.createdAt;
      } else {
        memo = memo.copyWith(createdAt: _createdAt);
        await DBHelper().updateMemo(memo);
      }
    } else {
      if (_currentMemoId != null) {
        await DBHelper().deleteMemo(_currentMemoId!);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = Colors.blueGrey.shade900;
    DateTime now = DateTime.now();
    String formattedDate = Formatter.formatDateTime(now);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inverseSurface,
        iconTheme: IconThemeData(color: Colors.white),
        title: const Text(
          'Your Memo in Remo.',
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              TextButton(
                onPressed: () {
                  FocusScope.of(context).unfocus();
                },
                child: const Text(
                  '완료',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                /// TODO: 삭제 버튼, 공유 버튼, 전체 복사 버튼
              ),
              TextButton(
                  onPressed: () async {
                    await storageService.clear();
                    if (mounted) {
                      context.goNamed(RemoPath.login.name);
                    }
                  },
                  child: Text(
                    '로그아웃',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  )),
            ],
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              Align(
                alignment: Alignment.center,
                child: Text(formattedDate),
              ),
              TextField(
                autofocus: true,
                cursorOpacityAnimates: true,
                cursorHeight: 20,
                cursorColor: primaryColor,
                showCursor: true,
                keyboardType: TextInputType.multiline,
                maxLines: null,
                decoration: const InputDecoration(
                  hintText:
                      '너가 요즘에 하고 싶었던 또는\n적고 싶었던 말이 있니.\n마음 속에는 있는데 꺼내기는 쉽지 않았던 내용들을'
                      '\n천천히 적어볼래',
                  border: InputBorder.none,
                ),
                controller: memoController,
                onChanged: _onMemoChanged,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
