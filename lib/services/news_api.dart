import 'dart:developer';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:news_app_hadi_kachmar/consts/api_const.dart';
import 'package:news_app_hadi_kachmar/consts/http_exceptions.dart';
import 'package:news_app_hadi_kachmar/models/bookmarks_model.dart';
import 'package:news_app_hadi_kachmar/models/news_model.dart';

//https://newsapi.org/v2/everything?q=apple&from=2023-07-18&to=2023-07-18&sortBy=popularity&apiKey=99b98987780d45baafe73b1a0254b109
class NewsApiServices {
  static Future<List<NewsModel>> getAllNews(
      {required int page, required String sortBy}) async {
    try {
      var uri = Uri.https(BASEURL, "v2/everything", {
        "q": "bitcoin",
        "pageSize": "5",
        //   "domains": "techcrunch.com", //domains degeri belirleyince gelen haber/veri az olur
        "page": page.toString(),
        "sortBy": sortBy
        // "apiKEY": API_KEY
      });
      var response = await http.get(
        uri,
        headers: {"X-Api-key": API_KEY},
      );
      Map data = jsonDecode(response.body);
      List newsTempList = [];
      log('${response.statusCode}');
      if (data['code'] != null) {
        //olusturdugmuz Exception metoduna Api'dan gelen hata mesaj paramerete atarak ekranda hatayi yazdirabiliriz
        throw HttpExceptions(data['code']);
        //  throw data['message'];
      }
      for (var i in data["articles"]) {
        newsTempList.add(i);
        //  log(i.toString());
      }
      print(newsTempList[0]);
      print(newsTempList.length);
      //Api'den verileri alip listye ekleyip newsFromSnapshot metoduna atiyoruz
      return NewsModel.newsFromSnapshot(newsTempList);
    } catch (error) {
      throw error.toString();
    }
  }

  static Future<List<NewsModel>> getTopHeadlines() async {
    try {
      var uri = Uri.https(BASEURL, "v2/top-headlines",
          {'country': 'us', 'category': 'science'});
      var response = await http.get(
        uri,
        headers: {"X-Api-key": API_KEY},
      );
      log('Response status: ${response.statusCode}');
      // log('Response body: ${response.body}');
      Map data = jsonDecode(response.body);
      List newsTempList = [];

      if (data['code'] != null) {
        throw HttpException(data['code']);
        // throw data['message'];
      }
      for (var v in data["articles"]) {
        newsTempList.add(v);
        // log(v.toString());
        // print(data["articles"].length.toString());
      }
      return NewsModel.newsFromSnapshot(newsTempList);
    } catch (error) {
      throw error.toString();
    }
  }

  static Future<List<NewsModel>> searchNews({required String query}) async {
    try {
      var uri = Uri.https(BASEURL, "v2/everything", {
        "q": query, //q is a Keywords or a phrase to search for.

        "pageSize": "10",
        //  "domains": "techcrunch.com",
      });
      var response = await http.get(
        uri,
        headers: {"X-Api-key": API_KEY},
      );
      // log('Response status: ${response.statusCode}');
      // log('Response body: ${response.body}');
      Map data = jsonDecode(response.body);
      List newsTempList = [];

      if (data['code'] != null) {
        throw HttpException(data['code']);
        // throw data['message'];
      }
      for (var v in data["articles"]) {
        newsTempList.add(v);
        // log(v.toString());
        // print(data["articles"].length.toString());
      }
      return NewsModel.newsFromSnapshot(newsTempList);
    } catch (error) {
      throw error.toString();
    }
  }
  //bu metot ile firebase Ai'sinde sakladigimiz bilgi getirebiliriz
  static Future<List<BookmarksModel>?> getBookmarks() async {
    try {
      var uri = Uri.https(BASEURL_FIREBASE, "bookmarks.json");
      var response = await http.get(
        uri,
      );
      // log('Response status: ${response.statusCode}');
      // log('Response body: ${response.body}');

      Map data = jsonDecode(response.body);
      List allKeys = [];

      if (data['code'] != null) {
        throw HttpException(data['code']);
        // throw data['message'];
      }
      for (String key in data.keys) {
        allKeys.add(key);
      }
      log("allKeys $allKeys");
      //we can just add this data.keys istead of data for json oarameter
      return BookmarksModel.bookmarksFromSnapshot(json: data, allKeys: allKeys);
    } catch (error) {
      rethrow;
    }
  }

}
