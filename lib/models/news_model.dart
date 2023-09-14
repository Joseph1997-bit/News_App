import 'package:flutter/material.dart';
import 'package:news_app_hadi_kachmar/services/global_methods.dart';
import 'package:reading_time/reading_time.dart';

//bu sinifi kullanip icindeki degerleri list olakark ekranda provider ile gostermek icin ChangeNotifier eklememz gerekiyo
class NewsModel with ChangeNotifier {
  String newsId,
      sourceName,
      authorName,
      title,
      description,
      url,
      urlToImage,
      publishedAt,
      dateToShow,
      content,
      readingTimeText;

  NewsModel({
    required this.newsId,
    required this.sourceName,
    required this.authorName,
    required this.title,
    required this.description,
    required this.url,
    required this.urlToImage,
    required this.publishedAt,
    required this.content,
    required this.dateToShow,
    required this.readingTimeText,
  });

  factory NewsModel.fromJson(dynamic json) {
    String title = json["title"] ?? "";//eger gelen degerler null ise bos bi deger versin nullSafety hatasi almayalim diye
    String content = json["content"] ?? "";
    String description = json["description"] ?? "";

    String dateToShow = "";
    if (json["publishedAt"] != null) {
      dateToShow = GlobalMethods.formattedDateText(json["publishedAt"]);
    }
    return NewsModel(
      newsId: json["source"]["id"] ?? "",
      sourceName: json["source"]["name"] ?? "",
      authorName: json["author"] ?? "",
      title: title,
      description: description,
      url: json["url"] ?? "",
      urlToImage: json["urlToImage"] ??
          "https://techcrunch.com/wp-content/uploads/2022/01/locket-app.jpg?w=1390&crop=1",
      publishedAt: json["publishedAt"] ?? "",
      content: content,
      dateToShow: dateToShow,
      readingTimeText:readingTime(title + description + content).msg,
      //readingTime(title + description + content).msg
    );
  }

  //in here we are returning a list of NewModel Class to use in the app
  //The method processes each element of the input list and converts it into a list of NewsModel instances.
  static List<NewsModel> newsFromSnapshot(List newSnapshot) {
    return newSnapshot.map((json) {
      return NewsModel.fromJson(json);
    }).toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data["newsId"] = newsId;
    data["sourceName"] = sourceName;
    data["authorName"] = authorName;
    data["title"] = title;
    data["description"] = description;
    data["url"] = url;
    data["urlToImage"] = urlToImage;
    data["publishedAt"] = publishedAt;
    data["dateToShow"] = dateToShow;
    data["content"] = content;
    data["readingTimeText"] = readingTimeText;
    return data;
  }

// @override
// String toString() {
//   return "news {newid: $newsId}";
// }
}