import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:local_db_sqlite/db/db_helper.dart';
import 'package:local_db_sqlite/model/memo.dart';

class MemosScreen extends StatefulWidget {
  const MemosScreen({super.key});

  @override
  State<MemosScreen> createState() => MemosScreenState();
}

class MemosScreenState extends State<MemosScreen> {
  List<Memo> memoList = [];

  @override
  void initState() {
    super.initState();
    loadData();
  }

  void loadData() async {
    var dbHelper = DBHelper();

    final fetchedData =
        await dbHelper.fetchMemos(); // 여기서 fetchData는 DB에서 데이터를 가져오는 함수
    setState(() {
      memoList = fetchedData;
    });
  }

  void _createMemo() {
    final now = DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now());
    final result = DBHelper().insertMemo(Memo(
        id: null,
        userId: 2,
        title: '첫 메모야.',
        content: '안녕..',
        password: null,
        createdAt: now,
        updatedAt: now,
        isPrivate: 0));
  }

  @override
  Widget build(BuildContext context) {
    final TextEditingController idTextController = TextEditingController();
    final TextEditingController passwordTextController =
        TextEditingController();
    final primaryColor = Colors.blueGrey.shade900;

    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inverseSurface,
          title: const Text(
            'Memo List in Remo.',
            style: TextStyle(color: Colors.white),
          ),
        ),
        body: memoList.isNotEmpty
            ? Column(
                children: [
                  Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            textAlign: TextAlign.left,
                            '너가 남긴 흔적들이야.',
                            style: TextStyle(
                                color: primaryColor,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 2),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          ListView.separated(
                            padding: EdgeInsets.zero,
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            separatorBuilder: (_, index) {
                              return SizedBox(
                                height: 2,
                              );
                            },
                            itemCount: memoList.length,
                            itemBuilder: (_, index) {
                              final Memo item = memoList[index];

                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(item.title!),
                                      Text(item.content!),
                                    ],
                                  ),
                                  Divider(),
                                ],
                              );
                            },
                          ),
                        ],
                      )),
                ],
              )
            : Stack(children: [
                Center(
                    child: Text(
                  '아직 너의 흔적이 없어. 한 번 남겨볼래?',
                  style: TextStyle(
                      color: primaryColor,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2),
                )),
                Positioned(
                  right: 20,
                  bottom: 40,
                  child: FloatingActionButton(
                    onPressed: _createMemo,
                    tooltip: '메모를 추가해봐',
                    child: const Icon(Icons.add),
                  ),
                )
              ]),
      ),
    );
  }
}
