import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:local_db_sqlite/db/db_helper.dart';
import 'package:local_db_sqlite/model/user.dart';
import 'package:local_db_sqlite/utils/hash_util.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TextEditingController idTextController = TextEditingController();
    final TextEditingController passwordTextController =
        TextEditingController();
    final TextEditingController nickNameTextController =
        TextEditingController();
    final TextEditingController shortenIntroducingTextController =
        TextEditingController();

    final primaryColor = Colors.blueGrey.shade900;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inverseSurface,
        title: const Text(
          'Register in Remo.',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  textAlign: TextAlign.left,
                  '로그인할 때 적으실 아이디와 비밀번호를 설정해주세요.',
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
                SizedBox(
                  height: 20,
                ),
                TextField(
                  decoration: InputDecoration(
                    labelText: '닉네임',
                    hintText: '사용할 닉네임을 적어주세요.',
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
                  controller: nickNameTextController,
                ),
                SizedBox(
                  height: 20,
                ),
                TextField(
                  decoration: InputDecoration(
                    labelText: '나에 대해 말해줄래요?',
                    hintText: '조심스럽게라도 좋으니, 나에 대해 짤막한 글을 적어주세요.',
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
                  controller: shortenIntroducingTextController,
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  child: Text('회원가입'),
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
                    final nickName = nickNameTextController.value.text;
                    final shortenIntroducing =
                        shortenIntroducingTextController.value.text;
                    final now = DateFormat('yyyy-MM-dd HH:mm:ss')
                        .format(DateTime.now());
                    final hashedPassword =
                        HashUtil.generateSha256Hash(password);

                    final result = await DBHelper().insertUser(User(
                        id: null,
                        userId: userId,
                        password: hashedPassword,
                        nickName: nickName,
                        shortenIntroducing: shortenIntroducing,
                        createdAt: now,
                        updatedAt: now));

                    if (result) {
                      print('정상적으로 회원가입이 되었으니 팝업 띄워주고 메모 스크린으로 이동~');
                      // context.goNamed(RemoPath.memos.name);
                    } else {
                      print('에러 났으니까 잠시만~');
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: _createMemo,
      //   tooltip: 'Increment',
      //   child: const Icon(Icons.add),
      // ),
    );
  }
}
