import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:pinterest_app/pages/detail_page.dart';
import 'package:pinterest_app/pages/home_page.dart';
import 'package:pinterest_app/pages/message_page.dart';
import 'package:pinterest_app/pages/profile_page.dart';
import 'package:pinterest_app/pages/search_page.dart';
import 'package:pinterest_app/pages/splesh_page.dart';
import 'package:pinterest_app/services/db_service.dart';

void main() async {
  await Hive.initFlutter();
  await Hive.openBox(DbService.DBName);
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: Hive.box(DbService.DBName).listenable(),
      builder: (BuildContext context, box, Widget? child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Flutter Demo',
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          home: const SpleshPage(),
          routes: {
            SpleshPage.id: (context) => const SpleshPage(),
            HomePage.id: (context) => const HomePage(),
            ProfilePage.id: (context) => const ProfilePage(),
            SearchPage.id: (context) => const SearchPage(),
            DetailPage.id: (context) => DetailPage(),
            MessagePage.id: (context) => const MessagePage(),
          },
        );
      }
    );
  }
}
