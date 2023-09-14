import 'dart:convert';
import 'dart:developer';

import 'package:flutter/cupertino.dart';

import 'package:http/http.dart' as http;
import 'package:news_app_hadi_kachmar/consts/api_const.dart';
import 'package:news_app_hadi_kachmar/models/bookmarks_model.dart';
import 'package:news_app_hadi_kachmar/models/news_model.dart';

import '../services/news_api.dart';

class BookmarksProvider with ChangeNotifier {
  //internet'ten bilgileri aldiktan sonra bu liste atip kullaacaz
  List<BookmarksModel> bookmarkList = [];

  List<BookmarksModel> get getBookmarkList {
    return bookmarkList;
  }

  Future<List<BookmarksModel>> fetchBookmarks() async {
    bookmarkList = await NewsApiServices.getBookmarks() ?? [];
    //We need to notify the state that there is something changed.yani yeni bi haber ekleyince veya silince ekranda gozukmesi lazim
    notifyListeners();
    return bookmarkList;
  }

  //tum metotlarda ayni Api linki kullanmamiz lazim verileri ayni yere atip cekmek icin BASEURL_FIREBASE
  Future<void> addToBookmark({required NewsModel newsModel}) async {
    try {
      var uri = Uri.https(BASEURL_FIREBASE, "bookmarks.json");//Firebase'te veritaban adi( bookmarks) verdikten sonra json kelimesi yazmamiz lazim
      //bu kodu kullanrak herhangi bi Api'a deger atip saklayabiliriz burda firebase'in api'si kullanarak post metodu ile deger atip saklayabiliriz
      var response = await http.post(uri,
          //bu sekilde herhangi bi habere tiklayinca tum bilgileri Firebase'in Apis'nde saklayabiliriz
          body: json.encode(
            newsModel.toJson(),
          ));
      notifyListeners();
      log('Response status: ${response.statusCode}');
      log('Response body: ${response.body}');
    } catch (error) {
      rethrow;
    }
  }

  Future<void> deleteBookmark({required String key}) async {
    try {
      var uri = Uri.https(BASEURL_FIREBASE, "bookmarks/$key.json");
      var response = await http.delete(uri);
      notifyListeners();
      log('Response status: ${response.statusCode}');
      log('Response body: ${response.body}');
    } catch (error) {
      rethrow;
    }
  }
}
