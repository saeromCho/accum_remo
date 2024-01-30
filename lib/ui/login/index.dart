import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:local_db_sqlite/db/db_helper.dart';
import 'package:local_db_sqlite/utils/hash_util.dart';
import 'package:local_db_sqlite/utils/path.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool isUserExisted = true;
  @override
  void initState() {
    super.initState();
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
                    hintStyle: TextStyle(fontSize: 14),
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
                    hintStyle: TextStyle(fontSize: 14),
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
                        '일치하는 로그인 정보가 없어요ㅠㅠ',
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
                  onPressed: () async {
                    final userId = idTextController.value.text;
                    final password = passwordTextController.value.text;

                    /// TODO: 비밀번호에 해시함수 적용한 값으로 보내고, 저장.
                    final hashedPassword =
                        HashUtil.generateSha256Hash(password);

                    /// 아이디와 비밀번호 값을 받아서 유저 디비 조회해서 있으면 다음 스크린으로 이동
                    final users = await DBHelper()
                        .fetchUser(userId: userId, password: hashedPassword);

                    if (users != null) {
                      setState(() {
                        isUserExisted = true;
                      });
                      context.goNamed(RemoPath.memos.name);
                    } else {
                      /// 없으면 없다는 메세지 밑에 간단하게 보여줘.
                      setState(() {
                        isUserExisted = false;
                      });
                    }
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
                    context.goNamed(RemoPath.register.name);
                  },
                ),
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
