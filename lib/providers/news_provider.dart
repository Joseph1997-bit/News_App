import 'package:flutter/material.dart';
import 'package:news_app_hadi_kachmar/models/news_model.dart';
import 'package:news_app_hadi_kachmar/services/news_api.dart';

class NewsProvider with ChangeNotifier {
  List<NewsModel> newsList = [];

  List<NewsModel> get getNewsList {
    return newsList;
  }

  Future<List<NewsModel>> fetchAllNews(
      {required int page, required String sortBy}) async {
    newsList = await NewsApiServices.getAllNews(page: page, sortBy: sortBy);
    return newsList;
  }
//tikladigmiz haberin tum bilgilerini alip ekranda gostermek icin NewsModel
  NewsModel findByDate({required String? publishedAt}) {
    //publishedAt degeri verinin id'si olarak kullanarak istedigmiz habere tiklayip onun bilgileri alip farkli islemler yapabiliriz
    return newsList
        .firstWhere((newsType) => newsType.publishedAt == publishedAt);
  }

  Future<List<NewsModel>> fetchTopHeadlines() async {
    newsList = await NewsApiServices.getTopHeadlines();
    return newsList;
  }
  Future<List<NewsModel>> searchNewsProvider({required String query}) async {
    newsList = await NewsApiServices.searchNews(query: query);
    return newsList;
  }

}
