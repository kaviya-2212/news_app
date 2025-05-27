import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:news_app/pages/bookmark.dart';
import 'package:news_app/pages/login.dart';
import 'package:news_app/pages/news.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  Future<bool> checkLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('isLoggedIn') ?? false;
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: FutureBuilder<bool>(
        future: checkLoggedIn(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }
          if (snapshot.data == true) {
            return const MyHomePage();
          } else {
            return LoginPage();
          }
        },
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(title: Text("News App")),
      body: Container(
        height: h,
        width: w,
        decoration: BoxDecoration(),
        child: Column(
          children: [
            Container(
              height: 50,
              width: w,
              // color: Colors.red,
              child: TabBar(
                controller: _tabController,
                tabs: [Tab(text: "News"), Tab(text: "Bookmarks")],
              ),
            ),
            Container(
              height: h / 1.2,
              width: w,
              color: Colors.yellow,
              child: TabBarView(
                controller: _tabController,
                children: [NewsPage(), BookmarkedNewsPage()],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
