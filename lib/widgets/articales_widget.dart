import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:news_app_hadi_kachmar/consts/vars.dart';
import 'package:news_app_hadi_kachmar/inner_screens/blog_details.dart';
import 'package:news_app_hadi_kachmar/inner_screens/news_details_webview.dart';
import 'package:news_app_hadi_kachmar/models/bookmarks_model.dart';
import 'package:news_app_hadi_kachmar/models/news_model.dart';
import 'package:news_app_hadi_kachmar/providers/news_provider.dart';
import 'package:news_app_hadi_kachmar/services/utils.dart';
import 'package:news_app_hadi_kachmar/widgets/vertical_spacing.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

class ArticlesWidget extends StatelessWidget {
  ArticlesWidget({this.isBookmark = false});
  final bool isBookmark;
//  final String imageUrl,title,url,dateToShow,readingTime;
  @override
  Widget build(BuildContext context) {
    Size size = Utils(context).getScreenSize;
    //verileri NewsModel sinifi kullanarak cekip listeye dondurup burada sirayla yazdirabiliriz
    dynamic newsModelProvider = isBookmark==true
        ? Provider.of<BookmarksModel>(context)
        : Provider.of<NewsModel>(context);
    return Material(
      color: Theme.of(context).cardColor,
      child: InkWell(
        //ekrandaki haberin fotosuna tiklayinca Haberin Detay ekrani acilacaktir.
        onTap: () {
          Navigator.pushNamed(context, NewsDetailsScreen.routeName,
              arguments: newsModelProvider.publishedAt);
          //herhangi bi habere tiklayinca publishedAt degeri alip findByDate kullanarak bu haber hakkinda detaylari alabiliriz
        },
        child: Stack(
          children: [
            //fotonu ust soldaki mavi rengi temsil ediyo
            Container(
              height: 60,
              width: 60,
              color: Theme.of(context).colorScheme.secondary,
            ),
            //fotonu alt sagdaki mavi rengi temsil ediyo
            Positioned(
              right: 0,
              bottom: 0,
              child: Container(
                height: 60,
                width: 60,
                color: Theme.of(context).colorScheme.secondary,
              ),
            ),
            //Fotoyu gosteren widget
            Container(
              color: Theme.of(context).cardColor,
              padding: const EdgeInsets.all(10),
              margin: const EdgeInsets.all(10),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Hero(
                      //kullanilan her fotoya ayni id vermeiz gerekio oYuzden publishedAt degeri kullandik
                      tag: newsModelProvider.publishedAt,
                      child: FancyShimmerImage(
                          height: size.height * 0.12,
                          width: size.height * 0.12,
                          boxFit: BoxFit.fill,
                          errorWidget:
                              Image.asset('assets/images/empty_image.png'),
                          //https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSSuCr8z97IrxP3eBdVDMVaoQOD8LentflFSqdRrsmKwdjJKZJg5FWg0NDjpCvfZY7vDpk&usqp=CAU
                          imageUrl: newsModelProvider.urlToImage),
                    ),
                  ),
                  const SizedBox(
                    width: 15,
                  ),
                  //Expanded widgeti verince title/text degeri cok uzun olunca OverFlow hatasi cikmaz ve bi sonraki satira gider
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          newsModelProvider.title,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.justify,
                          maxLines: 2,
                          style: smallTextStyle,
                        ),
                        const VerticalSpacing(5),

                        Align(
                          alignment: Alignment.topRight,
                          child: Text(
                            '🕒 ${newsModelProvider.readingTimeText}',
                            style: smallTextStyle,
                            maxLines: 1,
                          ),
                        ),
                        //this widget make the widgets smaller when it becomes big to fit the place in it
                        FittedBox(
                          child: Row(
                            children: [
                              IconButton(
                                  onPressed: () {
                                    //PageTransition paketi guzel bi sekilde sagdan sola yen ekrani acmak icin kullanilir
                                    Navigator.push(
                                        context,
                                        PageTransition(
                                            type:
                                                PageTransitionType.rightToLeft,
                                            child: NewsDetailsWebView(
                                                url: newsModelProvider.url),
                                            inheritTheme: true,
                                            ctx: context));
                                  },
                                  icon: const Icon(Icons.link)),
                              Text(newsModelProvider.dateToShow)
                            ],
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
