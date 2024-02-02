import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:local_db_sqlite/db/db_helper.dart';
import 'package:local_db_sqlite/infra/storage_service.dart';
import 'package:local_db_sqlite/model/memo.dart';
import 'package:local_db_sqlite/ui/common/complete_memo_text_button.dart';
import 'package:local_db_sqlite/ui/common/logout_text_button.dart';
import 'package:local_db_sqlite/utils/formatter.dart';
import 'package:local_db_sqlite/utils/ui_constant.dart';

class MemoEditScreen extends StatefulWidget {
  const MemoEditScreen({Key? key, required this.memoId}) : super(key: key);
  final String memoId;

  @override
  State<MemoEditScreen> createState() => _MemoEditScreenState();
}

class _MemoEditScreenState extends State<MemoEditScreen> {
  final storageService = StorageService();
  final memoController = TextEditingController();
  Memo? memoState;
  int? _currentMemoId;
  String? _createdAt;

  @override
  void initState() {
    super.initState();
    _currentMemoId = int.parse(widget.memoId);
    loadData();
  }

  void loadData() async {
    var dbHelper = DBHelper();

    final fetchedMemo =
        await dbHelper.fetchMemo(memoId: int.parse(widget.memoId));

    if (fetchedMemo != null) {
      final memoObj = Memo.fromJson(fetchedMemo);

      setState(() {
        memoState = memoObj;
      });
      memoController.text = '${memoObj.title}${memoObj.content}';
    }
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
        id: int.parse(widget.memoId),
        userId: 2,
        title: title,
        content: content,
        password: null,
        createdAt: memoState!.createdAt,
        updatedAt: now,
        isPrivate: 0,
      );

      if (_currentMemoId == null) {
        _currentMemoId = await DBHelper().insertMemo(memo);
        setState(() {
          _currentMemoId = _currentMemoId;
        });
        _createdAt = memo.createdAt;
      } else {
        memo = memo.copyWith(createdAt: _createdAt);
        await DBHelper().updateMemo(memo);
      }
    } else {
      _deleteMemo(int.parse(widget.memoId), false);

      setState(() {
        _currentMemoId = null;
      });
    }
  }

  _deleteMemo(int memoId, bool isBackScreen) async {
    await DBHelper().deleteMemo(int.parse(widget.memoId));
    if (isBackScreen) {
      context.pop();
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
        title: Text(
          memoState != null
              ? memoState!.title.split('\n').firstWhere(
                    (element) => element.isNotEmpty,
                    orElse: () => '새로운 메모',
                  )
              : '',
          style: const TextStyle(color: Colors.white),
        ),
        actions: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const CompleteMemoTextButton(),
              if (_currentMemoId != null) _buildDeleteMemoButton(),
              LogoutTextButton(
                  storageService: storageService, mounted: mounted),
            ],
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: memoState != null
              ? _buildEditMemoSection(formattedDate, primaryColor)
              : const CircularProgressIndicator(),
        ),
      ),
    );
  }

  Column _buildEditMemoSection(String formattedDate, Color primaryColor) {
    return Column(
      children: [
        Align(
          alignment: Alignment.center,
          child: Text(formattedDate),
        ),
        TextField(
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

  IconButton _buildDeleteMemoButton() {
    return IconButton(
        padding: EdgeInsets.zero,
        onPressed: () {
          _deleteMemo(_currentMemoId!, true);
        },
        icon: const Icon(
          CupertinoIcons.delete_simple,
          color: Colors.white,
        ));
  }
}
