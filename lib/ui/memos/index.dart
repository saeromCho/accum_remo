import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:local_db_sqlite/db/db_helper.dart';
import 'package:local_db_sqlite/infra/storage_service.dart';
import 'package:local_db_sqlite/model/memo.dart';
import 'package:local_db_sqlite/utils/formatter.dart';
import 'package:local_db_sqlite/utils/path.dart';

class MemosScreen extends StatefulWidget {
  const MemosScreen({super.key});

  @override
  State<MemosScreen> createState() => MemosScreenState();
}

class MemosScreenState extends State<MemosScreen> {
  List<Memo> memoList = [];
  final storageService = StorageService();

  @override
  void initState() {
    super.initState();
    loadData();
  }

  void loadData() async {
    var dbHelper = DBHelper();

    final fetchedData = await dbHelper.fetchMemos();
    setState(() {
      memoList = fetchedData;
    });
    print('체크::${await storageService.getUserId()}');
  }

  void _createMemo() {
    context.goNamed(RemoPath.memoWrite.name);
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = Colors.blueGrey.shade900;

    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inverseSurface,
          iconTheme: IconThemeData(color: Colors.white),
          title: const Text(
            'Memo List in Remo.',
            style: TextStyle(color: Colors.white),
          ),
          actions: [
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
        body: memoList.isNotEmpty
            ? ListView(children: [
                Column(
                  children: [
                    Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Stack(
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      textAlign: TextAlign.left,
                                      '너가 남긴 흔적들이야.',
                                      style: TextStyle(
                                          color: primaryColor,
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          letterSpacing: 2),
                                    ),
                                  ],
                                ),
                                Positioned(
                                  top: 0,
                                  bottom: 0,
                                  right: 0,
                                  child: Row(
                                    children: [
                                      IconButton(
                                          padding: EdgeInsets.zero,
                                          onPressed: loadData,
                                          icon: Icon(
                                              CupertinoIcons.refresh_circled)),
                                      IconButton(
                                        padding: EdgeInsets.zero,
                                        onPressed: _createMemo,
                                        icon: const Icon(
                                            CupertinoIcons.text_bubble),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
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

                                return GestureDetector(
                                  behavior: HitTestBehavior.translucent,
                                  onTap: () {
                                    context.goNamed(RemoPath.memoEdit.name,
                                        pathParameters: {
                                          'memoId': item.id.toString(),
                                        });
                                  },
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            item.title.split('\n').firstWhere(
                                                (element) => element.isNotEmpty,
                                                orElse: () => '새로운 메모'),
                                            maxLines: 1,
                                            softWrap: true,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 14),
                                          ),
                                          Row(
                                            children: [
                                              Text(Formatter
                                                  .formatDateTimeFromString(
                                                      item.updatedAt)),
                                              if (item.content != null)
                                                Row(
                                                  children: [
                                                    SizedBox(
                                                      width: 4,
                                                    ),
                                                    Text(
                                                      item.content!
                                                          .split('\n')
                                                          .firstWhere(
                                                              (element) => element
                                                                  .isNotEmpty,
                                                              orElse: () =>
                                                                  '추가 텍스트 없음'),
                                                    )
                                                  ],
                                                ),
                                            ],
                                          ),
                                        ],
                                      ),
                                      Divider(),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ],
                        )),
                  ],
                ),
              ])
            : Center(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '아직 너의 흔적이 없어. 한 번 남겨볼래?',
                      style: TextStyle(
                          color: primaryColor,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 2),
                    ),
                    IconButton(
                      padding: EdgeInsets.zero,
                      onPressed: _createMemo,
                      icon: const Icon(CupertinoIcons.text_bubble),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
