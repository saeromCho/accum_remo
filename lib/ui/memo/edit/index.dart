import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:local_db_sqlite/db/db_helper.dart';
import 'package:local_db_sqlite/model/memo.dart';
import 'package:local_db_sqlite/utils/formatter.dart';

class MemoEditScreen extends StatefulWidget {
  const MemoEditScreen({Key? key, required this.memoId}) : super(key: key);
  final String memoId;

  @override
  State<MemoEditScreen> createState() => _MemoEditScreenState();
}

class _MemoEditScreenState extends State<MemoEditScreen> {
  Memo? memoState;
  int? _currentMemoId;
  final memoController = TextEditingController();
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
    final primaryColor = Colors.blueGrey.shade900;
    DateTime now = DateTime.now();
    String formattedDate = Formatter.formatDateTime(now);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inverseSurface,
        iconTheme: IconThemeData(color: Colors.white),
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
              ),
              if (_currentMemoId != null)
                IconButton(
                    padding: EdgeInsets.zero,
                    onPressed: () {
                      _deleteMemo(_currentMemoId!, true);
                    },
                    icon: Icon(
                      CupertinoIcons.delete_simple,
                      color: Colors.white,
                    )

                    /// TODO: 삭제 버튼, 공유 버튼, 전체 복사 버튼
                    ),
            ],
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: memoState != null
              ? Column(
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
                )
              : CircularProgressIndicator(),
        ),
      ),
    );
  }
}
