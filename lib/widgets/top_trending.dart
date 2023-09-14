import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:news_app_hadi_kachmar/inner_screens/blog_details.dart';
import 'package:news_app_hadi_kachmar/inner_screens/news_details_webview.dart';
import 'package:news_app_hadi_kachmar/models/news_model.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

import '../services/utils.dart';

class TopTrendingWidget extends StatelessWidget {
  const TopTrendingWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = Utils(context).getScreenSize;
    final Color color = Utils(context).getColor;
    final newsModelProvider = Provider.of<NewsModel>(context);
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Material(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12.0),
        child: InkWell(
          onTap: () {
            Navigator.pushNamed(context, NewsDetailsScreen.routeName,
                arguments: newsModelProvider.publishedAt);
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //Top Trendig sayfasinda buyuk foto icin kullandim
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: FancyShimmerImage(
                  boxFit: BoxFit.fill,
                  errorWidget: Image.asset('assets/images/empty_image.png'),
                  //  'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcROQAzfbepgvBIcpAvR1FjA6j-t5d2ytJUb1A&usqp=CAU',
                  imageUrl: newsModelProvider.urlToImage,
                  height: size.height * 0.33,
                  width: double.infinity,
                ),
              ),
              //haberlerin title icin
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  newsModelProvider.title,
                  maxLines: 3,
                  overflow:TextOverflow.ellipsis ,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 20),
                ),
              ),
              //Haberin basligi altindaki icon ve zaman/tarih icin kullandim
              Row(
                children: [
                  IconButton(
                      splashRadius: 15,
                      onPressed: () {
                        Navigator.push(
                          context,
                          PageTransition(
                              type: PageTransitionType.rightToLeft,
                              child: NewsDetailsWebView(
                                  url: newsModelProvider.url),
                              inheritTheme: true,
                              ctx: context),
                        );
                      },
                      icon: Icon(
                        Icons.link,
                        color: color,
                      )),
                  const Spacer(),
                  SelectableText(
                    newsModelProvider.dateToShow,
                    style: GoogleFonts.montserrat(fontSize: 15),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
