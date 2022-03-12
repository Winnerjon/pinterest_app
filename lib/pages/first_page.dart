import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pinterest_app/pages/home_page.dart';
import 'package:pinterest_app/pages/message_page.dart';
import 'package:pinterest_app/pages/profile_page.dart';
import 'package:pinterest_app/pages/search_page.dart';
import 'package:pinterest_app/services/db_service.dart';

class FirstPage extends StatefulWidget {
  static const String id = "/first_page";

  const FirstPage({Key? key}) : super(key: key);

  @override
  _FirstPageState createState() => _FirstPageState();
}

class _FirstPageState extends State<FirstPage> {
  List pageList = ["All"];
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: controllerPage(),
      floatingActionButton: itemBottomBar(),
    );
  }

  /// #controllerPage
  Widget controllerPage() {
    if(selectedIndex == 1){
      return SearchPage();
    }else if(selectedIndex == 2){
      return MessagePage();
    }else if(selectedIndex == 3){
      return ProfilePage();
    }
    return HomePage();
  }

  /// #bottom
  Widget itemBottomBar() {
    return Container(
      height: 54,
      width: 240,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(50),
        color: Color(0xffFFFFFF),
      ),
      child: Row(
        children: [
          Expanded(
            child: IconButton(
              onPressed: () {
                setState(() {
                  selectedIndex = 0;
                });
              },
              icon: Icon(
                CupertinoIcons.home,
                size: 27,
                color: (selectedIndex == 0) ? Colors.black : Colors.grey,
              ),
            ),
          ),
          Expanded(
            child: IconButton(
              onPressed: () {
                setState(() {
                  selectedIndex = 1;
                });
              },
              icon: Icon(
                CupertinoIcons.search,
                size: 30,
                color: (selectedIndex == 1) ? Colors.black : Colors.grey,
              ),
            ),
          ),
          Expanded(
            child: IconButton(
              onPressed: () {
                setState(() {
                  selectedIndex = 2;
                });
              },
              icon: Icon(
                CupertinoIcons.chat_bubble,
                size: 28,
                color: (selectedIndex == 2) ? Colors.black : Colors.grey,
              ),
            ),
          ),
          Expanded(
            child: IconButton(
              onPressed: () {
                setState(() {
                  selectedIndex = 3;
                });
              },
              icon: CircleAvatar(
                radius: 13,
                backgroundColor:
                (selectedIndex == 3) ? Colors.black : Colors.grey,
                child: DbService.loadUser().profileImage != null
                    ? CircleAvatar(
                  radius: 11,
                      child: Image.asset(
                  DbService.loadUser().profileImage!,
                  fit: BoxFit.cover,
                ),
                    )
                    : CircleAvatar(
                  radius: 11,
                  backgroundColor: Colors.grey.shade300,
                  child: Text(
                    DbService.loadUser().firstName.substring(0, 1),
                    style: TextStyle(
                        fontSize: 17, fontWeight: FontWeight.w900),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

}
