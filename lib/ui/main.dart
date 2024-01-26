import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:local_db_sqlite/db/db_helper.dart';
import 'package:local_db_sqlite/model/memo.dart';
import 'package:local_db_sqlite/model/user.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
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
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Remo'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '로메 데이터베이스 예제',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            TextButton(
                onPressed: () {
                  DBHelper().insertUser(User(id: 1, name: 'romsi'));
                },
                child: Text('romsi 유저 테이블에 추가')),
            TextButton(
                onPressed: () {
                  DBHelper().insertMemo(Memo(
                      id: 1,
                      userId: 1,
                      content:
                          '후.. 이제야 두번째 내용인데, 사실 테이블을 지우고 진행해서 첫번째 row insert 가 되어버렸다. Memo 모델의 id 는 auto increatement 라서 null 일수가 있다고 한다. 그래서 id 값을 nullable 로 해줬고 따로 id 값을 넣어주지 않아도 된다고 한다. 로 진행하다가 auto increatement 하지 않고 그냥 아무값이나 id 에 넣어주는 걸로 바꿨다. auto increatement면 널러블이어서 toJson 에 id 필드가 존재하면 안되는데 json serializable 사용을 해서는 toJson 에 id 값이 필수로 생성되어서 어쩔 수 없다..',
                      writtenAt: DateFormat('yyyy-MM-dd HH:mm:ss')
                          .format(DateTime.now())));
                },
                child: Text('romsi 메모에 메모 내용 추가')),
            TextButton(
                onPressed: () {
                  DBHelper().fetchMemos();
                },
                child: Text('모든 메모 리스트 가져오기')),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _createMemo,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
