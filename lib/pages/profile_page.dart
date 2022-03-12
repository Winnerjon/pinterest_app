import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pinterest_app/pages/home_page.dart';
import 'package:pinterest_app/services/db_service.dart';

class ProfilePage extends StatefulWidget {
  static const String id = "/profile_page";

  const ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  File? _image;

  final _picker = ImagePicker();

  Future<void> _openImagePicker() async {
    final XFile? pickedImage = await _picker.pickImage(
        source: ImageSource.gallery);
    if (pickedImage != null) {
      setState(() {
        _image = File(pickedImage.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double x = MediaQuery
        .of(context)
        .size
        .width;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        toolbarHeight: 50,
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.share,
              color: Colors.black,
              size: 30,
            ),
          ),
          IconButton(
            onPressed: () {
              showModalBottomSheet(
                  isScrollControlled: true,
                  context: context,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                        topRight: Radius.circular(25),
                        topLeft: Radius.circular(25)),
                  ),
                  builder: (context) {
                    return _bottomSheet();
                  });
            },
            icon: Icon(
              Icons.more_horiz,
              color: Colors.black,
              size: 30,
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              SizedBox(
                height: 10,
              ),

              /// #profile image
              GestureDetector(
                onTap: (){
                  _openImagePicker();
                },
                child: _image != null ? Container(
                  height: 120,
                  width: 120,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(60),
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: FileImage(_image!,),
                    )
                  ),
                ) : CircleAvatar(
                  radius: 60,
                  backgroundColor: Colors.grey.shade300,
                  child: Text(
                    DbService.loadUser().firstName.substring(0, 1),
                    style: TextStyle(
                        fontSize: 45, fontWeight: FontWeight.w900),
                  ),
                ),
              ),

              SizedBox(
                height: 10,
              ),

              /// #profile name
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                // crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    "${DbService
                        .loadUser()
                        .firstName} ${DbService
                        .loadUser()
                        .lastName}",
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.w800),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                ],
              ),
              SizedBox(
                height: 15,
              ),

              /// #more profile
              Text(
                DbService
                    .loadUser()
                    .userName,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
              ),
              SizedBox(
                height: 15,
              ),

              /// #followers and following
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                      child: Text(
                        "${DbService
                            .loadUser()
                            .followers} followers",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w500),
                      )),
                  SizedBox(
                    width: 5,
                  ),
                  Icon(
                    Icons.circle,
                    color: Colors.black,
                    size: 5,
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  GestureDetector(
                      child: Text(
                        "${DbService
                            .loadUser()
                            .following} following",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w500),
                      )),
                ],
              ),
              SizedBox(
                height: 25,
              ),

              /// #profile search
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: 45,
                    width: x * 0.8,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25),
                      color: Colors.grey.shade300,
                    ),
                    child: TextField(
                      style: TextStyle(color: Colors.black, fontSize: 17),
                      cursorColor: Colors.black,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: "Search your Pins",
                        hintStyle: TextStyle(color: Colors.grey.shade800),
                        prefixIcon: Icon(
                          Icons.search_sharp,
                          color: Colors.grey.shade800,
                          size: 30,
                        ),
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: Icon(
                      Icons.add,
                      color: Colors.black,
                      size: 35,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 60,
              ),
              Text(
                "You haven't saved any ideas yet",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
              ),
              SizedBox(
                height: 20,
              ),
              MaterialButton(
                height: 60,
                minWidth: 100,
                color: Colors.grey.shade300,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Text(
                  "Find ideas",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                ),
                onPressed: () {
                  Navigator.pushReplacementNamed(context, HomePage.id);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _bottomSheet() {
    return BottomSheet(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topRight: Radius.circular(25), topLeft: Radius.circular(25)),
      ),
      onClosing: () {
        Navigator.pop(context);
      },
      builder: (context) {
        return Container(
          height: 250,
          padding: EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                height: 30,
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 15),
                alignment: Alignment.centerLeft,
                child: Text(
                  "Profile",
                  style: TextStyle(fontSize: 16),
                ),
              ),
              SizedBox(height: 10,),
              MaterialButton(
                height: 45,
                minWidth: MediaQuery
                    .of(context)
                    .size
                    .width,
                child: Container(
                    alignment: Alignment.bottomLeft,
                    child: Text(
                      "Setting",
                      style:
                      TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                    )),
                onPressed: () {
                  showModalBottomSheet(
                      isScrollControlled: true,
                      context: context,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                            topRight: Radius.circular(35),
                            topLeft: Radius.circular(35)),
                      ),
                      builder: (context) {
                        return settingBottomSheet();
                      });
                },
              ),
              MaterialButton(
                height: 45,
                minWidth: MediaQuery
                    .of(context)
                    .size
                    .width,
                child: Container(
                    alignment: Alignment.bottomLeft,
                    child: Text(
                      "Copy profile link",
                      style:
                      TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                    )),
                onPressed: () {},
              ),
              SizedBox(
                height: 20,
              ),
              MaterialButton(
                height: 50,
                color: Colors.grey.shade300,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Text(
                  "Close",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Widget settingBottomSheet() {
    return Container(
      height: MediaQuery
          .of(context)
          .size
          .height * 0.95,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AppBar(
              toolbarHeight: 60,
              centerTitle: true,
              backgroundColor: Colors.transparent,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(35),
                    topLeft: Radius.circular(35)),
              ),
              leading: IconButton(
                onPressed: () {
                  Navigator.pushNamed(context, ProfilePage.id);
                },
                icon: Icon(
                  CupertinoIcons.chevron_back,
                  size: 40,
                  color: Colors.black,
                ),
              ),
              title: Text(
                "Settings",
                style: TextStyle(color: Colors.black, fontSize: 16),
              ),
            ),
            Container(
                height: 40,
                alignment: Alignment.bottomLeft,
                padding: EdgeInsets.symmetric(horizontal: 15),
                child: Text(
                  "Personal information",
                  style: TextStyle(fontSize: 16),
                )),
            ListTile(
              onTap: () {},
              title: Text(
                "Account settings",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              trailing: Icon(
                CupertinoIcons.chevron_forward, color: Colors.black,),
            ),
            ListTile(
              onTap: () {},
              title: Text(
                "Permissions",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              trailing: Icon(
                CupertinoIcons.chevron_forward, color: Colors.black,),
            ),
            ListTile(
              onTap: () {},
              title: Text(
                "Notifications",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              trailing: Icon(
                CupertinoIcons.chevron_forward, color: Colors.black,),
            ),
            ListTile(
              onTap: () {},
              title: Text(
                "Privacy & data",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              trailing: Icon(
                CupertinoIcons.chevron_forward, color: Colors.black,),
            ),
            ListTile(
              onTap: () {},
              title: Text(
                "Public profile",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              trailing: Icon(
                CupertinoIcons.chevron_forward, color: Colors.black,),
            ),
            ListTile(
              onTap: () {},
              title: Text(
                "Home feed tuner",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              trailing: Icon(
                CupertinoIcons.chevron_forward, color: Colors.black,),
            ),
            Container(
              height: 30,
              alignment: Alignment.bottomLeft,
              padding: EdgeInsets.symmetric(horizontal: 15),
              child: Text("Actions", style: TextStyle(fontSize: 16),),
            ),
            ListTile(
              onTap: () {},
              title: Text(
                "Add account",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              trailing: Icon(
                CupertinoIcons.chevron_forward, color: Colors.black,),
            ),
            ListTile(
              onTap: () {},
              title: Text(
                "Log out",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              trailing: Icon(
                CupertinoIcons.chevron_forward, color: Colors.black,),
            ),
            Container(
              height: 30,
              alignment: Alignment.bottomLeft,
              padding: EdgeInsets.symmetric(horizontal: 15),
              child: Text("Support", style: TextStyle(fontSize: 16),),
            ),
            ListTile(
              onTap: () {},
              title: Text(
                "Get help",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              trailing: Icon(
                CupertinoIcons.arrow_up_right, color: Colors.black,),
            ),
            ListTile(
              onTap: () {},
              title: Text(
                "Terms & Privacy",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              trailing: Icon(
                CupertinoIcons.arrow_up_right, color: Colors.black,),
            ),
            ListTile(
              onTap: () {},
              title: Text(
                "About",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              trailing: Icon(
                CupertinoIcons.chevron_forward, color: Colors.black,),
            ),
          ],
        ),
      ),
    );
  }
}
