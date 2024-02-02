import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:local_db_sqlite/db/db_helper.dart';
import 'package:local_db_sqlite/infra/storage_service.dart';
import 'package:local_db_sqlite/model/memo.dart';
import 'package:local_db_sqlite/ui/common/logout_text_button.dart';
import 'package:local_db_sqlite/utils/formatter.dart';
import 'package:local_db_sqlite/utils/path.dart';
import 'package:local_db_sqlite/utils/ui_constant.dart';

class MemosScreen extends StatefulWidget {
  const MemosScreen({super.key});

  @override
  State<MemosScreen> createState() => MemosScreenState();
}

class MemosScreenState extends State<MemosScreen> {
  List<Memo>? memoList;
  final storageService = StorageService();

  @override
  void initState() {
    super.initState();
    loadData();
  }

  void loadData() async {
    /// TODO: 유저 닉네임 보여주게끔 수정하기. 프로바이더 만들어서 관리필요.
    final dbHelper = DBHelper();
    final userId = await storageService.getUserId();

    final fetchedData = await dbHelper.fetchUserMemos(int.parse(userId!));
    setState(() {
      memoList = fetchedData;
    });
  }

  void _createMemo() {
    context.goNamed(RemoPath.memoWrite.name);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Theme.of(context).colorScheme.inverseSurface,
          iconTheme: const IconThemeData(color: Colors.white),
          title: const Text(
            'Memo List in Remo.',
            style: TextStyle(color: Colors.white),
          ),
          actions: [
            LogoutTextButton(storageService: storageService, mounted: mounted),
          ],
        ),
        body: memoList != null
            ? memoList!.isNotEmpty
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
                                    _buildTitle(),
                                    _buildActionButtons(),
                                  ],
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                _buildMemoList(context),
                              ],
                            )),
                      ],
                    ),
                  ])
                : _buildEmptyMemo(primaryColor)
            : const Center(child: CircularProgressIndicator()),
      ),
    );
  }

  ListView _buildMemoList(BuildContext context) {
    return ListView.separated(
      padding: EdgeInsets.zero,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      separatorBuilder: (_, index) {
        return const SizedBox(
          height: 2,
        );
      },
      itemCount: memoList!.length,
      itemBuilder: (_, index) {
        final Memo item = memoList![index];

        return GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () {
            context.goNamed(RemoPath.memoEdit.name, pathParameters: {
              'memoId': item.id.toString(),
            });
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildMemoTitle(item),
                  Row(
                    children: [
                      _buildMemoUpdatedAt(item),
                      if (item.content != null) _buildMemoContent(item),
                    ],
                  ),
                ],
              ),
              const Divider(),
            ],
          ),
        );
      },
    );
  }

  Row _buildTitle() {
    return Row(
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
    );
  }

  Positioned _buildActionButtons() {
    return Positioned(
      top: 0,
      bottom: 0,
      right: 0,
      child: Row(
        children: [
          IconButton(
              padding: EdgeInsets.zero,
              onPressed: loadData,
              icon: const Icon(CupertinoIcons.refresh_circled)),
          IconButton(
            padding: EdgeInsets.zero,
            onPressed: _createMemo,
            icon: const Icon(CupertinoIcons.text_bubble),
          ),
        ],
      ),
    );
  }

  Text _buildMemoTitle(Memo item) {
    return Text(
      item.title
          .split('\n')
          .firstWhere((element) => element.isNotEmpty, orElse: () => '새로운 메모'),
      maxLines: 1,
      softWrap: true,
      overflow: TextOverflow.ellipsis,
      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
    );
  }

  Text _buildMemoUpdatedAt(Memo item) {
    return Text(Formatter.formatDateTimeFromString(item.updatedAt));
  }

  Row _buildMemoContent(Memo item) {
    return Row(
      children: [
        const SizedBox(
          width: 4,
        ),
        Text(
          item.content!.split('\n').firstWhere((element) => element.isNotEmpty,
              orElse: () => '추가 텍스트 없음'),
        )
      ],
    );
  }

  Center _buildEmptyMemo(Color primaryColor) {
    return Center(
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
    );
  }
}
