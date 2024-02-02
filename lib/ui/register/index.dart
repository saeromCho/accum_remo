import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:local_db_sqlite/db/db_helper.dart';
import 'package:local_db_sqlite/model/user.dart';
import 'package:local_db_sqlite/ui/common/text_field.dart';
import 'package:local_db_sqlite/utils/hash_util.dart';
import 'package:local_db_sqlite/utils/path.dart';
import 'package:local_db_sqlite/utils/ui_constant.dart';

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

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inverseSurface,
        iconTheme: const IconThemeData(color: Colors.white),
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
                const SizedBox(
                  height: 20,
                ),
                CommonTextField(
                  labelText: '아이디',
                  hintText: '아이디를 입력해주세요',
                  textController: idTextController,
                ),
                const SizedBox(
                  height: 20,
                ),
                CommonTextField(
                  labelText: '비밀번호',
                  hintText: '비밀번호를 입력해주세요.',
                  textController: passwordTextController,
                  isObscureText: true,
                ),
                const SizedBox(
                  height: 20,
                ),
                CommonTextField(
                  labelText: '닉네임',
                  hintText: '사용할 닉네임을 적어주세요.',
                  textController: nickNameTextController,
                ),
                const SizedBox(
                  height: 20,
                ),
                CommonTextField(
                  labelText: '나에 대해 말해줄래요?',
                  hintText: '조심스럽게라도 좋으니, 나에 대해 짤막한 글을 적어주세요.',
                  textController: shortenIntroducingTextController,
                ),
                const SizedBox(height: 20),
                _buildRegisterButton(
                    context,
                    idTextController,
                    passwordTextController,
                    nickNameTextController,
                    shortenIntroducingTextController),
              ],
            ),
          ),
        ),
      ),
    );
  }

  ElevatedButton _buildRegisterButton(
      BuildContext context,
      TextEditingController idTextController,
      TextEditingController passwordTextController,
      TextEditingController nickNameTextController,
      TextEditingController shortenIntroducingTextController) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      onPressed: () async {
        final userId = idTextController.value.text;
        final password = passwordTextController.value.text;
        final nickName = nickNameTextController.value.text;
        final shortenIntroducing = shortenIntroducingTextController.value.text;
        final now = DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now());
        final hashedPassword = HashUtil.generateSha256Hash(password);

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
          if (context.mounted) {
            context.goNamed(RemoPath.login.name);
          }
        } else {
          print('에러 났으니까 잠시만~');
        }
      },
      child: const Text('회원가입'),
    );
  }
}
