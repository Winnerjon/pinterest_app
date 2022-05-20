import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:pinterest_app/models/collections_model.dart';
import 'package:pinterest_app/services/dio_service.dart';

class MessagePage extends StatefulWidget {
  static const String id = "/message_page";

  const MessagePage({Key? key}) : super(key: key);

  @override
  _MessagePageState createState() => _MessagePageState();
}

class _MessagePageState extends State<MessagePage> {
  final PageController _pageController = PageController();
  late List<Collections> collections = [];
  bool isPage = true;
  bool isLoading = false;
  int selectedIndex = 0;

  void _apiCollections() {
    DioNetwork.GET(DioNetwork.API_COLLECTIONS, DioNetwork.paramsEmpty())
        .then((response) => {
              _showResponse(response!),
            });
  }

  void _showResponse(String response) {
    setState(() {
      collections = DioNetwork.parseCollectionsResponse(response);
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _apiCollections();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            DefaultTabController(
              length: 2,
              child: TabBar(
                labelPadding: EdgeInsets.zero,
                indicator: UnderlineTabIndicator(
                  borderSide: BorderSide(color: Colors.transparent),
                ),
                onTap: (index) {
                  setState(() {
                    selectedIndex = index;
                  });
                  _pageController.animateToPage(selectedIndex,
                      duration: const Duration(milliseconds: 10),
                      curve: Curves.linear);
                },
                padding: EdgeInsets.only(
                  top: 10,
                  left: MediaQuery.of(context).size.width * 0.23,
                  right: MediaQuery.of(context).size.width * 0.23,
                ),
                tabs: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(23),
                        color:
                            selectedIndex == 0 ? Colors.black : Colors.white),
                    child: Text(
                      "Updates",
                      style: TextStyle(
                          color:
                              selectedIndex == 0 ? Colors.white : Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(23),
                        color:
                            selectedIndex == 1 ? Colors.black : Colors.white),
                    child: Text(
                      "Messages",
                      style: TextStyle(
                          color:
                              selectedIndex == 1 ? Colors.white : Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: PageView(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() {
                    selectedIndex == index;
                  });
                },
                children: [
                  bodyUpdates(),
                  bodyMessages(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// #messages
  Widget bodyMessages() {
    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(
            height: 100,
          ),
          Text(
            "Share ideas with\nyour friends",
            style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          SizedBox(
            height: 20,
          ),
          Container(
            height: 50,
            width: MediaQuery.of(context).size.width * 0.9,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(25),
              color: Colors.grey.shade400,
            ),
            child: TextField(
              style: TextStyle(color: Colors.black, fontSize: 18),
              decoration: InputDecoration(
                border: InputBorder.none,
                prefixIcon: Icon(
                  CupertinoIcons.search,
                  color: Colors.black,
                ),
                hintText: "Search by name or email address",
                hintStyle: TextStyle(color: Colors.black87, fontSize: 17),
              ),
            ),
          ),
          SizedBox(
            height: 15,
          ),
          Container(
            height: 80,
            width: MediaQuery.of(context).size.width * 0.9,
            child: Row(
              children: [
                CircleAvatar(
                  radius: 25,
                  backgroundColor: Colors.red,
                  child: Icon(
                    Icons.people_alt,
                    color: Colors.white,
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                Text(
                  "Syns contacts",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// #updates
  Widget bodyUpdates() {
    return collections.isNotEmpty
        ? ListView.builder(
            itemCount: collections.length,
            padding: EdgeInsets.only(top: 10),
            itemBuilder: (context, index) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 5,
                        backgroundColor: Colors.orange,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        collections[index].title!,
                        style: TextStyle(fontSize: 18),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  SizedBox(
                    height: 180,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: GridView.custom(
                        padding: EdgeInsets.zero,
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        gridDelegate: SliverQuiltedGridDelegate(
                          crossAxisCount: 4,
                          mainAxisSpacing: 4,
                          crossAxisSpacing: 4,
                          repeatPattern: QuiltedGridRepeatPattern.inverted,
                          pattern: [
                            QuiltedGridTile(2, 2),
                            QuiltedGridTile(1, 1),
                            QuiltedGridTile(1, 1),
                            QuiltedGridTile(1, 2),
                          ],
                        ),
                        childrenDelegate: SliverChildBuilderDelegate(
                          (context, x) => CachedNetworkImage(
                            fit: BoxFit.cover,
                            imageUrl: collections[index]
                                .previewPhotos![x]
                                .urls!
                                .regular!,
                            placeholder: (context, url) => Container(
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  fit: BoxFit.cover,
                                  image: AssetImage(
                                      "assets/images/locals/img_1.png"),
                                ),
                              ),
                            ),
                          ),
                          childCount: 4,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  collections[index].coverPhoto!.description != null
                      ? Text(
                          collections[index].coverPhoto!.description!,
                          style: TextStyle(fontSize: 16),
                        )
                      : SizedBox.shrink(),
                  SizedBox(
                    height: 15,
                  ),
                ],
              );
            },
          )
        : Center(
            child: CircularProgressIndicator(
            color: Colors.black,
          ));
  }
}
