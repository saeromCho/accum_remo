import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:local_db_sqlite/db/db_helper.dart';

class MemosScreen extends StatefulWidget {
  const MemosScreen({super.key});

  @override
  State<MemosScreen> createState() => MemosScreenState();
}

class MemosScreenState extends State<MemosScreen> {
  String? id;
  String? password;
  bool isUserExisted = true;
  @override
  void initState() {
    // TODO: implement initState

    super.initState();
  }

  void _createMemo() {
    DBHelper().database;
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
            'Remo.',
            style: TextStyle(color: Colors.white),
          ),
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  textAlign: TextAlign.left,
                  '너가 적고 싶은 걸 편하게 잔잔하게 적어봐',
                  style: TextStyle(
                      color: primaryColor,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2),
                ),
                SizedBox(
                  height: 20,
                ),
                TextField(
                  decoration: InputDecoration(
                    labelText: '아이디',
                    hintText: '아이디를 입력해주세요.',
                    labelStyle: TextStyle(color: primaryColor),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(8.0)),
                      borderSide: BorderSide(width: 1, color: primaryColor),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(8.0)),
                      borderSide: BorderSide(width: 1, color: primaryColor),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(8.0)),
                    ),
                  ),
                  controller: idTextController,
                ),
                SizedBox(
                  height: 20,
                ),
                TextField(
                  decoration: InputDecoration(
                    labelText: '비밀번호',
                    hintText: '비밀번호를 입력해주세요.',
                    labelStyle: TextStyle(color: primaryColor),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(8.0)),
                      borderSide: BorderSide(width: 1, color: primaryColor),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(8.0)),
                      borderSide: BorderSide(width: 1, color: primaryColor),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(8.0)),
                    ),
                  ),
                  controller: passwordTextController,
                  obscureText: true,
                ),
                if (!isUserExisted)
                  Column(
                    children: [
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        '로그인 정보가 잘못 되었어요.',
                        style: TextStyle(color: Colors.redAccent),
                      ),
                    ],
                  ),
                SizedBox(height: 20),
                ElevatedButton(
                  child: Text('로그인'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10), // 버튼 모서리 둥글기
                    ),
                  ),
                  onPressed: () {
                    print('아이디확인::${idTextController.value.text}');
                    print('비밀번호확인::${passwordTextController.value.text}');
                    context.goNamed('/memos');

                    /// TODO: 아이디와 비밀번호 값을 받아서 유저 디비 조회해서 있으면 다음 스크린으로 이동
                    /// 없으면 없다는 메세지 밑에 간단하게 보여줘.
                  },
                ),
                ElevatedButton(
                  child: Text('회원가입'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10), // 버튼 모서리 둥글기
                    ),
                  ),
                  onPressed: () {
                    /// TODO: 회원가입 스크린으로 이동
                  },
                )

                // const Text(
                //   'You have pushed the button this many times:',
                // ),
                // Text(
                //   '로메 데이터베이스 예제',
                //   style: Theme.of(context).textTheme.headlineMedium,
                // ),
                // TextButton(
                //     onPressed: () {
                //       DBHelper().insertUser(User(id: 1, name: 'romsi'));
                //     },
                //     child: const Text('romsi 유저 테이블에 추가')),
                // TextButton(
                //     onPressed: () {
                //       DBHelper().insertMemo(Memo(
                //           id: 1,
                //           userId: 1,
                //           content:
                //               '후.. 이제야 두번째 내용인데, 사실 테이블을 지우고 진행해서 첫번째 row insert 가 되어버렸다. Memo 모델의 id 는 auto increatement 라서 null 일수가 있다고 한다. 그래서 id 값을 nullable 로 해줬고 따로 id 값을 넣어주지 않아도 된다고 한다. 로 진행하다가 auto increatement 하지 않고 그냥 아무값이나 id 에 넣어주는 걸로 바꿨다. auto increatement면 널러블이어서 toJson 에 id 필드가 존재하면 안되는데 json serializable 사용을 해서는 toJson 에 id 값이 필수로 생성되어서 어쩔 수 없다..',
                //           writtenAt: DateFormat('yyyy-MM-dd HH:mm:ss')
                //               .format(DateTime.now())));
                //     },
                //     child: const Text('romsi 메모에 메모 내용 추가')),
                // TextButton(
                //     onPressed: () {
                //       DBHelper().fetchMemos();
                //     },
                //     child: const Text('모든 메모 리스트 가져오기')),
              ],
            ),
          ),
        ),
        // floatingActionButton: FloatingActionButton(
        //   onPressed: _createMemo,
        //   tooltip: 'Increment',
        //   child: const Icon(Icons.add),
        // ),
      ),
    );
  }
}
