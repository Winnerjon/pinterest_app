import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:pinterest_app/models/pinterest_model.dart';
import 'package:pinterest_app/services/db_service.dart';
import 'package:pinterest_app/services/dio_service.dart';
import 'package:share_plus/share_plus.dart';

class DetailPage extends StatefulWidget {
  static const String id = "/detail_page";
  final int? pageNumber;
  final PinterestUser? list;

  const DetailPage({Key? key, this.list, this.pageNumber}) : super(key: key);

  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  var albomName = "Pinterest";
  List pageList = ["All"];
  int selectedIndex = 0;
  bool isLoadPage = false;
  List<PinterestUser> posts = [];
  int newPostsLength = 0;
  final ScrollController _scrollController = ScrollController();

  void _apiPostList() {
    DioNetwork.GET(
            DioNetwork.API_LIST, DioNetwork.paramsPage(widget.pageNumber!))
        .then((response) => {
              _showResponse(response!),
            });
  }

  void _showResponse(String response) {
    List<PinterestUser> list = DioNetwork.parseResponse(response);
    setState(() {
      isLoadPage = false;
      posts = list;
      newPostsLength = list.length;
    });
  }

  void fetchPosts() async {
    int pageNumber = (posts.length ~/ newPostsLength + 1) + widget.pageNumber!;
    if (kDebugMode) {
      print(pageNumber);
    }
    String? response = await DioNetwork.GET(
        DioNetwork.API_LIST, DioNetwork.paramsPage(pageNumber));
    List<PinterestUser> newPosts = DioNetwork.parseResponse(response!);
    posts.addAll(newPosts);
  }


  void saveImage(String path) async {
    await GallerySaver.saveImage("$path.jpg",albumName: albomName);
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
    return Scaffold(
      // extendBodyBehindAppBar: true,
      backgroundColor: Colors.black,
      appBar: AppBar(
        toolbarHeight: 0,
        backgroundColor: Colors.transparent,
      ),
      body: SingleChildScrollView(
        controller: _scrollController,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              child: ClipRRect(
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(30),
                    topLeft: Radius.circular(30)),
                child: CachedNetworkImage(
                  imageUrl: widget.list!.urls!.regular!,
                  progressIndicatorBuilder: (context, url, downloadProgress) =>
                      Image(
                          image: AssetImage("assets/images/locals/img_1.png")),
                  errorWidget: (context, url, error) => Icon(Icons.error),
                ),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30)),
                color: Colors.white,
              ),
              child: Column(
                children: [
                  ListTile(
                    leading: Container(
                      height: 50,
                      width: 50,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(25),
                        child: CachedNetworkImage(
                          imageUrl: widget.list!.user!.profileImage!.large!,
                          progressIndicatorBuilder:
                              (context, url, downloadProgress) => Image(
                                  image: AssetImage(
                                      "assets/images/locals/img_1.png")),
                          errorWidget: (context, url, error) =>
                              Icon(Icons.error),
                        ),
                      ),
                    ),
                    title: Text(
                      widget.list!.user!.name!,
                      style: TextStyle(fontWeight: FontWeight.w500),
                    ),
                    subtitle: Text(
                      "${widget.list!.user!.totalLikes.toString()} followers",
                      style: TextStyle(
                          fontWeight: FontWeight.w600, color: Colors.black),
                    ),
                    trailing: MaterialButton(
                      height: 45,
                      onPressed: () {},
                      color: Colors.grey,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(22.5),
                      ),
                      child: Text(
                        "Follow",
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                  ),
                  Container(
                    height: 70,
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: Row(
                      children: [
                        Expanded(
                          child: Container(
                            alignment: Alignment.centerLeft,
                            child: IconButton(
                              onPressed: () {},
                              icon: Icon(
                                CupertinoIcons.bubble_left_fill,
                                color: Colors.black,
                                size: 30,
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: MaterialButton(
                            height: 60,
                            color: Colors.grey.shade200,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            onPressed: () {},
                            child: Text(
                              "View",
                              style:
                                  TextStyle(color: Colors.black, fontSize: 18),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          child: MaterialButton(
                            height: 60,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            onPressed: () {},
                            color: Colors.red,
                            child: Text(
                              "Save",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 18),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            alignment: Alignment.centerRight,
                            child: IconButton(
                              onPressed: () {
                                setState(() {
                                  Share.share("${widget.list!.urls!.regular!}");
                                });
                              },
                              icon: Icon(
                                Icons.share,
                                color: Colors.black,
                                size: 30,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 2,
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                color: Colors.white,
              ),
              child: Column(
                children: [
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    "Comments",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    "Love this Pin? Let.Sancho know!",
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    height: 50,
                    width: MediaQuery.of(context).size.width,
                    padding: EdgeInsets.symmetric(horizontal: 15),
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: "Add a comment",
                        border: InputBorder.none,
                        icon: Container(
                          height: 40,
                          width: 40,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(25),
                            child: DbService.loadUser().profileImage != null
                                ? Image.asset(
                                    DbService.loadUser().profileImage!,
                                    fit: BoxFit.cover,
                                  )
                                : CircleAvatar(
                                    backgroundColor: Colors.grey.shade300,
                                    child: Text(
                                      DbService.loadUser()
                                          .firstName
                                          .substring(0, 1),
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w900),
                                    ),
                                  ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 2,
            ),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
              ),
              child: Column(
                children: [
                  Container(
                    height: 70,
                    width: double.infinity,
                    alignment: Alignment.center,
                    child: Text(
                      "More like this",
                      style:
                          TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                    ),
                  ),
                  MasonryGridView.count(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    crossAxisCount: 2,
                    mainAxisSpacing: 4,
                    crossAxisSpacing: 10,
                    itemCount: posts.length,
                    itemBuilder: (context, index) {
                      return itemBodyList(index);
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
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
                          list: posts[index],
                          pageNumber: (posts.length ~/ newPostsLength + 1) +
                              widget.pageNumber!,
                        )));
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
          title: Text(posts[index].user!.name!),
          trailing: PopupMenuButton<int>(
            icon: Icon(Icons.more_horiz),
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 1,
                child: Text("Download"),
                onTap: () {
                  saveImage(posts[index].urls!.regular!);
                },
              ),
              PopupMenuItem(
                onTap: () {
                  setState(() {
                    Share.share("${posts[index].urls!.regular!}");
                  });
                },
                value: 2,
                child: Text("Share"),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
