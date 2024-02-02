import 'package:flutter/material.dart';
import 'package:local_db_sqlite/db/db_helper.dart';
import 'package:local_db_sqlite/model/memo.dart';

class MemoDetailScreen extends StatefulWidget {
  const MemoDetailScreen({Key? key, required this.memoId}) : super(key: key);

  final String memoId;

  @override
  State<MemoDetailScreen> createState() => _MemoDetailScreenState();
}

class _MemoDetailScreenState extends State<MemoDetailScreen> {
  Memo? memo;

  @override
  void initState() {
    loadData();
    super.initState();
  }

  void loadData() async {
    var dbHelper = DBHelper();

    final fetchedMemo =
        await dbHelper.fetchMemo(memoId: int.parse(widget.memoId));

    if (fetchedMemo != null) {
      final memoObj = Memo.fromJson(fetchedMemo);

      setState(() {
        memo = memoObj;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inverseSurface,
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text(
          memo != null ? memo!.title : '',
          style: const TextStyle(color: Colors.white),
        ),
      ),
      body: memo != null
          ? Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Align(
                    alignment: Alignment.center,
                    child: Text(memo!.updatedAt),
                  ),
                  Text(
                    textAlign: TextAlign.left,
                    memo!.title,
                    style: const TextStyle(fontSize: 16, letterSpacing: 2),
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                  Text(
                    textAlign: TextAlign.left,
                    memo!.content != null ? memo!.content! : '',
                    style: const TextStyle(
                        // color: primaryColor,
                        fontSize: 16,
                        letterSpacing: 2),
                  ),
                ],
              ),
            )
          : const CircularProgressIndicator(),
    );
  }
}
