import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:local_db_sqlite/db/db_helper.dart';
import 'package:local_db_sqlite/infra/storage_service.dart';
import 'package:local_db_sqlite/model/memo.dart';
import 'package:local_db_sqlite/ui/common/complete_memo_text_button.dart';
import 'package:local_db_sqlite/ui/common/logout_text_button.dart';
import 'package:local_db_sqlite/utils/formatter.dart';
import 'package:local_db_sqlite/utils/ui_constant.dart';

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

    int nonEmptyLineIndex = lines.indexWhere((line) => line.trim().isNotEmpty);

    if (nonEmptyLineIndex != -1) {
      title = lines.sublist(0, nonEmptyLineIndex + 1).join('\n');
      content = lines.sublist(nonEmptyLineIndex + 1).join('\n');
    } else {
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
    DateTime now = DateTime.now();
    String formattedDate = Formatter.formatDateTime(now);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inverseSurface,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          'Your Memo in Remo.',
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const CompleteMemoTextButton(),
              LogoutTextButton(
                  storageService: storageService, mounted: mounted),
            ],
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: _buildWriteMemoSection(formattedDate, primaryColor),
        ),
      ),
    );
  }

  Column _buildWriteMemoSection(String formattedDate, Color primaryColor) {
    return Column(
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
    );
  }
}
