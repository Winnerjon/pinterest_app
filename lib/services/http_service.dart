import 'dart:convert';
import 'package:http/http.dart';
import 'package:pinterest_app/models/collections_model.dart';
import 'package:pinterest_app/models/pinterest_model.dart';

class Network {
  static bool isTester = true;

  static String SERVER_DEVELOPMENT = "api.unsplash.com";
  static String SERVER_PRODUCTION = "api.unsplash.com";

  static Map<String, String> getHeaders() {
    Map<String, String> headers = {
      'Content-Type': 'application/json; charset=UTF-8',
      'Accept-Version': 'v1',
      'Authorization': 'Client-ID zYGJr9DhtNKBrx-M5SL9b4QJe3j9kxXlYQtZVB10st8'
    };
    return headers;
  }

  static String getServer() {
    if (isTester) return SERVER_DEVELOPMENT;
    return SERVER_PRODUCTION;
  }

  /* Http Requests */

  static Future<String?> GET(String api, Map<String, dynamic> params) async {
    var uri = Uri.https(getServer(), api, params); // http or https
    var response = await get(uri, headers: getHeaders());
    if (response.statusCode == 200) return response.body;
    return null;
  }

  static Future<String?> POST(String api, Map<String, dynamic> params) async {
    var uri = Uri.https(getServer(), api); // http or https
    var response =
    await post(uri, headers: getHeaders(), body: jsonEncode(params));
    if (response.statusCode == 200 || response.statusCode == 201) {
      return response.body;
    }
    return null;
  }

  static Future<String?> MULTIPART(String api, String filePath, Map<String,String> params) async {
    var uri = Uri.https(getServer(), api);
    var request = MultipartRequest("POST", uri);

    request.headers.addAll(getHeaders());
    request.fields.addAll(params);
    request.files.add(await MultipartFile.fromPath("picture", filePath));

    var res = await request.send();
    return res.reasonPhrase;
  }

  static Future<String?> PUT(String api, Map<String, dynamic> params) async {
    var uri = Uri.https(getServer(), api); // http or https
    var response =
    await put(uri, headers: getHeaders(), body: jsonEncode(params));
    if (response.statusCode == 200) return response.body;
    return null;
  }

  static Future<String?> PATCH(String api, Map<String, dynamic> params) async {
    var uri = Uri.https(getServer(), api); // http or https
    var response =
    await patch(uri, headers: getHeaders(), body: jsonEncode(params));
    if (response.statusCode == 200) return response.body;
    return null;
  }

  static Future<String?> DELETE(String api, Map<String, dynamic> params) async {
    var uri = Uri.https(getServer(), api, params); // http or https
    var response = await delete(uri, headers: getHeaders());
    if (response.statusCode == 200) return response.body;
    return null;
  }

  /* Http Apis */
  static String API_LIST = "/photos";
  static String API_COLLECTIONS = "/collections";
  static String API_SEARCH = "/search/photos";
  static String API_ONE = "/photos/"; //{id}
  static String API_CREATE = "/photos";
  static String API_UPDATE = "/photos/"; //{id}
  static String API_DELETE = "/photos/"; //{id}

  /* Http Params */
  static Map<String, dynamic> paramsEmpty() {
    Map<String, String> params = {};
    return params;
  }

  static Map<String, dynamic> paramsPage(int pageNumber) {
    Map<String, String> params = {};
    params.addAll({
      "page":pageNumber.toString()
    });
    return params;
  }

  static Map<String, dynamic> paramsSearch(String search, int pageNumber) {
    Map<String, String> params = {};
    params.addAll({
      "page":pageNumber.toString(),
      "query":search
    });
    return params;
  }

  /* Http parsing */
  static List<PinterestUser> parseResponse(String response) {
    List json = jsonDecode(response);
    List<PinterestUser> photos = List<PinterestUser>.from(json.map((x) => PinterestUser.fromJson(x)));
    return photos;
  }

  static PinterestUser parseResponseOne(String response) {
    Map<String,dynamic> json = jsonDecode(response);
    PinterestUser photo = PinterestUser.fromJson(json);
    return photo;
  }

  static List<Collections> parseCollectionsResponse(String response) {
    List json = jsonDecode(response);
    List<Collections> collections = List<Collections>.from(json.map((x) => Collections.fromJson(x)));
    return collections;
  }

  static List<PinterestUser> parseSearchParse(String response) {
    Map<String, dynamic> json = jsonDecode(response);
    List<PinterestUser> photos = List<PinterestUser>.from(json["results"].map((x) => PinterestUser.fromJson(x)));
    return photos;
  }
}