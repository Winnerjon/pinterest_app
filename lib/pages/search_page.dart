import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:pinterest_app/models/pinterest_model.dart';
import 'package:pinterest_app/pages/detail_page.dart';
import 'package:pinterest_app/services/dio_service.dart';
import 'package:share_plus/share_plus.dart';

class SearchPage extends StatefulWidget {
  static const String id = "/search_page";

  const SearchPage({Key? key}) : super(key: key);

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  var albomName = "Pinterest";
  List<PinterestUser> posts = [];
  int pageNumber = 0;
  bool typing = false;
  String search = "";

  void searchPost() async {
    if (search.isEmpty) {
      search == "All";
      searchController.text = " ";
    }
    pageNumber += 1;
    String? response = await DioNetwork.GET(
        DioNetwork.API_SEARCH, DioNetwork.paramsSearch(search, pageNumber));
    List<PinterestUser> newPosts = DioNetwork.parseSearchParse(response!);
    setState(() {
      if (pageNumber == 1) {
        posts = newPosts;
      } else {
        posts.addAll(newPosts);
      }
    });
  }

  void saveImage(String path) async {
    await GallerySaver.saveImage("$path.jpg",albumName: albomName);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        searchPost();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 65,
        elevation: 0,
        backgroundColor: Colors.white,
        actions: [
          buildAppBar(context),
        ],
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
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
      ),
    );
  }

  /// #appBar
  Widget buildAppBar(BuildContext context) {
    return Container(
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: Row(
          children: [
            Container(
              width: (5 * (MediaQuery.of(context).size.width - 30)) / 6,
              height: 40,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(19.5),
                color: Color(0xffEFEFEF),
              ),
              child: TextField(
                onTap: () {
                  setState(() {
                    typing = true;
                  });
                },
                onEditingComplete: () {
                  FocusScope.of(context).requestFocus(FocusNode());
                  setState(() {
                    if (search != searchController.text.trim()) pageNumber = 0;
                    search = searchController.text.trim();
                  });
                  searchPost();
                },
                controller: searchController,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: "Search your Pins",
                  hintStyle: TextStyle(
                      color: Color(0xff8E8E8E), fontWeight: FontWeight.normal),
                  prefixIcon: Icon(
                    Icons.search,
                    color: Color(0xff8E8E8E),
                  ),
                ),
              ),
            ),
            SizedBox(
              width: 10,
            ),
            Container(
              width: (MediaQuery.of(context).size.width - 30) / 6,
              alignment: Alignment.centerRight,
              child: GestureDetector(
                child: Text(
                  "Cancel",
                  style: TextStyle(fontSize: 18, color: Colors.black),
                ),
              ),
            ),
          ],
        ));
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
                    builder: (context) =>
                        DetailPage(list: posts[index],pageNumber: pageNumber,)));
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
                        )
                    ),
                  )),
              errorWidget: (context, url, error) => AspectRatio(
                  aspectRatio: posts[index].width! / posts[index].height!,
                  child: Container(
                    decoration: BoxDecoration(
                        image: DecorationImage(
                          fit: BoxFit.cover,
                          image: AssetImage("assets/images/locals/img.png"),
                        )
                    ),
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
                          )
                      ),
                    )),
                errorWidget: (context, url, error) => AspectRatio(
                    aspectRatio: posts[index].width! / posts[index].height!,
                    child: Container(
                      decoration: BoxDecoration(
                          image: DecorationImage(
                            fit: BoxFit.cover,
                            image: AssetImage("assets/images/locals/img.png"),
                          )
                      ),
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
