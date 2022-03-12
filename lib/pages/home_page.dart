import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:pinterest_app/models/pinterest_model.dart';
import 'package:pinterest_app/pages/detail_page.dart';
import 'package:pinterest_app/pages/message_page.dart';
import 'package:pinterest_app/pages/profile_page.dart';
import 'package:pinterest_app/pages/search_page.dart';
import 'package:pinterest_app/services/db_service.dart';
import 'package:pinterest_app/services/dio_service.dart';
import 'package:pinterest_app/services/http_service.dart';
import 'package:share_plus/share_plus.dart';

class HomePage extends StatefulWidget {
  static const String id = "/home_page";

  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List pageList = ["All"];
  int selectedIndex = 0;
  int pageNumber = 1;
  bool isLoadPage = false;
  static List links = [
    'https://telegram.me/share/url?url=',
    'https://telegram.me/share/url?url=',
    "sms:?body=",
    "mailto:?subject=Flutter&body="
  ];
  List<PinterestUser> posts = [];
  int newPostsLength = 0;
  final ScrollController _scrollController = ScrollController();
  final PageController _pageController = PageController();

  // void _apiPostList() {
  //   Network.GET(Network.API_LIST, Network.paramsEmpty()).then((response) => {
  //         Log.d(response!),
  //         _showResponse(response),
  //       });
  // }

  void _apiPostList() {
    DioNetwork.GET(DioNetwork.API_LIST, DioNetwork.paramsEmpty()).then((response) => {
      _showResponse(response! ),
    });
  }

  // void _showResponse(String response) {
  //   List<PinterestUser> list = Network.parseResponse(response);
  //   setState(() {
  //     isLoadPage = false;
  //     posts = list;
  //     newPostsLength = list.length;
  //   });
  // }

  void _showResponse(String response) {
    List<PinterestUser> list = DioNetwork.parseResponse(response);
    setState(() {
      isLoadPage = false;
      posts = list;
      newPostsLength = list.length;
    });
  }

  void fetchPosts() async {
    pageNumber = (posts.length ~/ newPostsLength + 1);
    String? response = await DioNetwork.GET(DioNetwork.API_LIST, DioNetwork.paramsPage(pageNumber));
    List<PinterestUser> newPosts = DioNetwork.parseResponse(response!);
    posts.addAll(newPosts);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _apiPostList();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        fetchPosts();
        setState(() {
          isLoadPage = true;
        });
      }
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        body: PageView(
          controller: _pageController,
          physics: NeverScrollableScrollPhysics(),
          onPageChanged: (index) {
            setState(() {
              selectedIndex = index;
            });
          },
          children: [
            _pageHome(),
            SearchPage(),
            MessagePage(),
            ProfilePage(),
          ],
        ),
        floatingActionButton: itemBottomBar(),
      ),
    );
  }

  /// #pageHome
  Widget _pageHome() {
    return Stack(
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // SizedBox(height: 40,),
            Container(
              height: 60,
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.symmetric(horizontal: 5),
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: pageList.length,
                itemBuilder: (context, index) {
                  return itemAppBarList(index);
                },
              ),
            ),
            posts.isNotEmpty
                ? Container(
                    height: MediaQuery.of(context).size.height - 99,
                    padding: EdgeInsets.only(left: 10, right: 10, top: 5),
                    child: MasonryGridView.count(
                      controller: _scrollController,
                      crossAxisCount: 2,
                      mainAxisSpacing: 4,
                      crossAxisSpacing: 10,
                      itemCount: posts.length,
                      itemBuilder: (context, index) {
                        return itemBodyList(index);
                      },
                    ),
                  )
                : Container(
                    height: MediaQuery.of(context).size.height - 99,
                    child: Center(
                      child: CircularProgressIndicator(
                        color: Colors.black,
                      ),
                    ),
                  ),
          ],
        ),
      ],
    );
  }

  /// #body
  Widget itemBodyList(index) {
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => DetailPage(
                        list: posts[index], pageNumber: pageNumber)));
          },
          child: ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: CachedNetworkImage(
              imageUrl: posts[index].urls!.regular!,
              placeholder: (context, url) => AspectRatio(
                  aspectRatio: posts[index].width! / posts[index].height!,
                  child: Container(
                    decoration: BoxDecoration(
                        image: DecorationImage(
                      fit: BoxFit.cover,
                      image: AssetImage("assets/images/locals/img_1.png"),
                    )),
                  )),
              errorWidget: (context, url, error) => AspectRatio(
                  aspectRatio: posts[index].width! / posts[index].height!,
                  child: Container(
                    decoration: BoxDecoration(
                        image: DecorationImage(
                      fit: BoxFit.cover,
                      image: AssetImage("assets/images/locals/img.png"),
                    )),
                  )),
            ),
          ),
        ),
        ListTile(
          contentPadding: EdgeInsets.zero,
          dense: true,
          horizontalTitleGap: 0,
          minVerticalPadding: 0,
          leading: SizedBox(
            height: 30,
            width: 30,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(50),
              child: CachedNetworkImage(
                imageUrl: posts[index].user!.profileImage!.large!,
                progressIndicatorBuilder: (context, url, downloadProgress) =>
                    Image(image: AssetImage("assets/images/locals/img_1.png")),
                errorWidget: (context, url, error) => Icon(Icons.error),
              ),
            ),
          ),
          title: Text(posts[index].user!.name!),
          trailing: InkWell(
            onTap: () {
              setState(() {
                Share.share("${posts[index].urls!.regular!}");
              });
            },
            child: Icon(Icons.more_horiz),
          ),
        ),
      ],
    );
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
                _pageController.jumpToPage(selectedIndex);
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
                _pageController.jumpToPage(selectedIndex);
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
                _pageController.jumpToPage(selectedIndex);
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
                _pageController.jumpToPage(selectedIndex);
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

  /// #appBar
  Widget itemAppBarList(int index) {
    return Container(
      height: 39,
      alignment: Alignment.center,
      padding: EdgeInsets.symmetric(
        horizontal: 16,
      ),
      margin: EdgeInsets.only(left: 5, right: 5, top: 15, bottom: 6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
        color: Colors.black,
      ),
      child: Text(
        pageList[index],
        style: TextStyle(color: Colors.white, fontSize: 18),
      ),
    );
  }
}
