import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:news_app_hadi_kachmar/consts/vars.dart';
import 'package:news_app_hadi_kachmar/models/bookmarks_model.dart';
import 'package:news_app_hadi_kachmar/providers/bookmarks_provider.dart';
import 'package:news_app_hadi_kachmar/providers/news_provider.dart';
import 'package:news_app_hadi_kachmar/services/global_methods.dart';
import 'package:news_app_hadi_kachmar/services/utils.dart';
import 'package:news_app_hadi_kachmar/widgets/vertical_spacing.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';

class NewsDetailsScreen extends StatefulWidget {
  static const routeName = "/NewsDetailsScreen";
  const NewsDetailsScreen({Key? key}) : super(key: key);

  @override
  State<NewsDetailsScreen> createState() => _NewsDetailsScreenState();
}

class _NewsDetailsScreenState extends State<NewsDetailsScreen> {
  bool isInBookmark = false;
  String? publishedAt;
  dynamic currBookmark;

  @override
  void didChangeDependencies() {
    //publishedAt degeri haberin id'si olarak kullaniyoz ve ona ulasmak icin asagidaki kodu kullanmak zorundayiz
    final publishedAt = ModalRoute.of(context)!.settings.arguments as String;
    // getBookmarkList degiskeni BookmarksModel sinifindan bi list donduruyo
    final List<BookmarksModel> bookmarkList =
        Provider.of<BookmarksProvider>(context).getBookmarkList;
    if (bookmarkList.isEmpty) {
      return;
    }
    currBookmark = bookmarkList
        .where((element) => element.publishedAt == publishedAt)
        .toList();
    if (currBookmark.isEmpty) {
      isInBookmark = false;
    } else {
      isInBookmark = true;
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    //bu sayfa calisinca/acilinca asagidaki metotlar otomatik calisacktir
    final color = Utils(context).getColor;
    final newsProvider = Provider.of<NewsProvider>(context);
    final bookmarksProvider = Provider.of<BookmarksProvider>(context);
    final publishedAt = ModalRoute.of(context)!.settings.arguments as String;
    //herhangi bi habere tiklayinca publishedAt degeri alip findByDate metoduna atip veya kullanarak bu haber hakkinda detaylari alabiliriz
    final currentNews = newsProvider.findByDate(publishedAt: publishedAt);
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: color),
        elevation: 0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        centerTitle: true,
        title: Text(
          "By ${currentNews.authorName}",
          textAlign: TextAlign.center,
          style: TextStyle(color: color),
        ),
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  currentNews.title,
                  textAlign: TextAlign.justify,
                  style: titleTextStyle,
                ),
                const VerticalSpacing(25),
                Row(
                  children: [
                    Text(
                      currentNews.dateToShow,
                      style: smallTextStyle,
                    ),
                    const Spacer(),
                    Text(
                      currentNews.readingTimeText,
                      style: smallTextStyle,
                    ),
                  ],
                ),
                const VerticalSpacing(20),
              ],
            ),
          ),
          Stack(
            children: [
              //Haberin fotosuna basinca fotoyu buyutup detaylari gormek icin kullanilack
              SizedBox(
                width: double
                    .infinity, //haberin detayi acinca fotonun sag ve soldan tum ekrani kapsamak icin kullanilir
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 25),
                  //Haberin fotosu Animasyonlu bi sekilde acmak icin Hero
                  child: Hero(
                    //kullanilan her fotoya ayni id vermeiz gerekio oYuzden publishedAt degeri kullandik
                    tag: publishedAt,
                    child: FancyShimmerImage(
                        boxFit: BoxFit.fill,
                        errorWidget:
                            Image.asset('assets/images/empty_image.png'),
                        //   'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcROQAzfbepgvBIcpAvR1FjA6j-t5d2ytJUb1A&usqp=CAU',
                        imageUrl: currentNews.urlToImage),
                  ),
                ),
              ),
              //Paylasma ve gonderme iconlari fotonun alt sag tarafta koymak icin kullanilir
              Positioned(
                bottom: 0,
                right: 10,
                child: Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: Row(
                    children: [
                      //Asagidaki widget Fotunun ustundeki paylasma icon icin kullanilir
                      InkWell(
                        borderRadius: BorderRadius.circular(100),
                        highlightColor: Colors.white,
                        splashColor: Colors.white,
                        onTap: () async {
                          try {
                            await Share.share(currentNews.url,
                                subject: 'Look what I made!');
                          } catch (err) {
                            GlobalMethods.errorDialog(
                                errorMessage: err.toString(), context: context);
                          }
                        },
                        child: Card(
                          elevation: 10,
                          shape: const CircleBorder(),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Icon(
                              IconlyLight.send,
                              size: 28,
                              color: color,
                            ),
                          ),
                        ),
                      ),
                      //Asagidaki widget Haberin ustundeki kaydetme/favorilere ekleme iconu icin kullanilir
                      InkWell(
                        borderRadius: BorderRadius.circular(100),
                        highlightColor: Colors.white,
                        splashColor: Colors.white,
                        onTap: () async {
                          // bookmarksProvider.addToBookmark(newsModel: currentNews);
                          if (isInBookmark) {
                            await bookmarksProvider.deleteBookmark(
                                key: currBookmark[0].bookmarkKey);
                          } else {
                            await bookmarksProvider.addToBookmark(
                                newsModel: currentNews);
                          }
                          //haberleri bookMarks kismina ekledikten sonra ikon rengi hemen degismesi icin verileri tekrar aliyoz
                          await bookmarksProvider.fetchBookmarks();
                        },
                        child: Card(
                          elevation: 10,
                          shape: const CircleBorder(),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Icon(
                              isInBookmark == true
                                  ? IconlyBold.bookmark
                                  : IconlyLight.bookmark,
                              size: 28,
                              color: isInBookmark ? Colors.green : color,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
          const VerticalSpacing(20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const TextContent(
                  label: 'Description',
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
                const VerticalSpacing(10),
                TextContent(
                  label: currentNews.description,
                  fontSize: 18,
                  fontWeight: FontWeight.normal,
                ),
                const VerticalSpacing(
                  20,
                ),
                const TextContent(
                  label: 'Contents',
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
                const VerticalSpacing(
                  10,
                ),
                TextContent(
                  label: currentNews.content,
                  fontSize: 18,
                  fontWeight: FontWeight.normal,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class TextContent extends StatelessWidget {
  const TextContent({
    Key? key,
    required this.label,
    required this.fontSize,
    required this.fontWeight,
  }) : super(key: key);

  final String label;
  final double fontSize;
  final FontWeight fontWeight;
  @override
  Widget build(BuildContext context) {
    return SelectableText(
      label,
      textAlign: TextAlign.justify,
      style: GoogleFonts.roboto(fontSize: fontSize, fontWeight: fontWeight),
    );
  }
}
