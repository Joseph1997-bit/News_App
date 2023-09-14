import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:news_app_hadi_kachmar/consts/vars.dart';
import 'package:news_app_hadi_kachmar/inner_screens/search_screen.dart';
import 'package:news_app_hadi_kachmar/models/news_model.dart';
import 'package:news_app_hadi_kachmar/providers/news_provider.dart';

import 'package:news_app_hadi_kachmar/services/utils.dart';
import 'package:news_app_hadi_kachmar/widgets/articales_widget.dart';
import 'package:news_app_hadi_kachmar/widgets/drawer_widget.dart';
import 'package:news_app_hadi_kachmar/widgets/empty_screen.dart';
import 'package:news_app_hadi_kachmar/widgets/loding_widget.dart';
import 'package:news_app_hadi_kachmar/widgets/tabs.dart';
import 'package:news_app_hadi_kachmar/widgets/top_trending.dart';
import 'package:page_transition/page_transition.dart';

import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  //Enum degeri olusturup onu kullanarak tabs rengi boyutu ve iceri degistirebiliriz
  var newsType = NewsType.allNews;
  int currentPageIndex = 0;
  String sortBy = SortByEnum.relevancy.name;
/*  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    NewsApiServices.getAllNews();
    super.didChangeDependencies();
  }*/

  @override
  Widget build(BuildContext context) {
    final Color color = Utils(context).getColor;
    Size size = Utils(context).getScreenSize;
    final newsModelProvider = Provider.of<NewsProvider>(context);
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        iconTheme: IconThemeData(color: color),
        centerTitle: true,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title: Text(
          'News App',
          style: GoogleFonts.lobster(fontSize: 20, color: color),
        ),
        actions: [
          IconButton(
              splashRadius: 20,
              onPressed: () {
                //PageTransition paketi guzel bi sekilde sagdan sola yen ekrani acmak icin kullanilir
                Navigator.push(
                    context,
                    PageTransition(
                        type: PageTransitionType.rightToLeft,
                        child: const SearchScreen(),
                        inheritTheme: true,
                        ctx: context));
              },
              icon: const Icon(IconlyLight.search))
        ],
      ),
      drawer: const DrawerWidget(),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Row(
                children: [
                  TabsWidget(
                      title: 'All News',
                      color: newsType == NewsType.allNews
                          ? Theme.of(context).cardColor
                          : Colors.transparent,
                      function: () {
                        //eger ayni taba basarsak ekrani tekrar rebuild'tan kurtariyoruz
                        if (newsType == NewsType.allNews) {
                          return;
                        }
                        //All news taba basinca newsType degiskene deger atip o degeri kullanarak renk ve tab iceri degistirebiliriz
                        setState(() {
                          newsType = NewsType.allNews;
                        });
                      },
                      fontSize: newsType == NewsType.allNews ? 22 : 14),
                  const SizedBox(
                    width: 12,
                  ),
                  TabsWidget(
                      title: 'Top Trending',
                      color: newsType == NewsType.topTrending
                          ? Theme.of(context).cardColor
                          : Colors.transparent,
                      function: () {
                        //eger ayni taba basarsak ekrani tekrar rebuild'tan kurtariyoruz
                        if (newsType == NewsType.topTrending) {
                          return;
                        }
                        //All news taba basinca newsType degiskene deger atip o degeri kullanarak renk ve tab iceri degistirebiliriz
                        setState(() {
                          newsType = NewsType.topTrending;
                        });
                      },
                      fontSize: newsType == NewsType.topTrending ? 22 : 14),
                ],
              ),
            ),
            newsType == NewsType.allNews
                ? SizedBox(
                    height:
                        kBottomNavigationBarHeight, //ekranin altin kisminda bottomNavigationBar'a verilen height degeri burda kullanabiliriz
                    child: Row(
                      children: [
                        paginationButtons(
                            function: () {
                              if (currentPageIndex != 0) {
                                setState(() {
                                  currentPageIndex -= 1;
                                });
                              }
                            },
                            text: 'Prev'),
                        Expanded(
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 5.0),
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: 5,
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  //Container'e basinca sadece Container icinde SplashColor gozuksun diye Material kullandim
                                  child: Material(
                                    color: currentPageIndex == index
                                        ? Colors.blue
                                        : Theme.of(context).cardColor,
                                    child: InkWell(
                                      onTap: () {
                                        setState(() {
                                          currentPageIndex = index;
                                        });
                                      },
                                      child: Center(
                                          child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text('${index + 1}'),
                                      )),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                        paginationButtons(
                            function: () {
                              if (currentPageIndex != 4) {
                                setState(() {
                                  currentPageIndex += 1;
                                });
                              }
                            },
                            text: 'Next')
                      ],
                    ),
                  )
                : const SizedBox(),
            newsType == NewsType.allNews
                ? Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5.0),
                    child: Align(
                      alignment: Alignment.topRight,
                      child: Material(
                        color: Theme.of(context).cardColor,
                        child: DropdownButton(
                          onTap: () {},
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          value: sortBy,
                          items: dropDownItems,
                          onChanged: (value) {
                            setState(() {
                              sortBy = value!;
                            });
                          },
                        ),
                      ),
                    ),
                  )
                // LoadingWidget(newsType: newsType,)
                : const SizedBox(),
            FutureBuilder<List<NewsModel>>(
              //bu sayfa calisinca bu metodu kullanarak istek atip Api'den verileri alip kullanabiliriz
              future: newsType == NewsType.topTrending
                  ? newsModelProvider.fetchTopHeadlines()
                  : newsModelProvider.fetchAllNews(
                  page: currentPageIndex + 1, sortBy: sortBy),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return LoadingWidget(newsType: newsType);
                } else if (snapshot.hasError) {
                  return Expanded(
                      child: EmptyNewsWidget(
                          text: 'An Error occured ${snapshot.error}',
                          imagePath: 'assets/images/no_news.png'));
                } else if (snapshot.data == null) {
                  return const Expanded(
                      child: EmptyNewsWidget(
                          text: 'No News found',
                          imagePath: 'assets/images/no_news.png'));
                } else {
                  return newsType == NewsType.allNews
                      ? Expanded(
                          child: ListView.builder(
                            itemCount: snapshot.data!.length,
                            itemBuilder: (context, index) {
                              return ChangeNotifierProvider.value(
                                //getAllNews() kullanip istek atiktan sonra ve gelen veriler list olarak geleck cunku newsFromSnapshot metodu model'den list of snapshot donduryor
                                //bu listeyi sirayla kullanmak icin listenin indexi value'ye veriyoz snapshot.data![index].
                                value: snapshot.data![index],
                                child: ArticlesWidget(
                                    //   imageUrl: snapshot.data![index].urlToImage,
                                    // title: snapshot.data![index].title,
                                    // dateToShow: snapshot.data![index].dateToShow,
                                    // readingTime: snapshot.data![index].readingTimeText,
                                    // url: snapshot.data![index].url,

                                    ),
                              );
                            },
                          ),
                        )
                      : SizedBox(
                          height: size.height * 0.55,
                          child: Swiper(
                            itemCount: 5,
                            viewportFraction:
                                0.8, //sayfalari birbirine yakin gostermek icin
                            layout: SwiperLayout
                                .STACK, //fotolar ust uste gostermek icin
                            itemWidth: size.width *
                                0.9, //width degeri vermezsek layout ozelligi calismaz
                            autoplay: true,
                            autoplayDelay: 5000,
                            itemBuilder: (context, index) =>
                            ChangeNotifierProvider.value(
                              //getAllNews() kullanip istek atiktan sonra ve gelen veriler list olarak geleck cunku newsFromSnapshot metodu model'den list of snapshot donduryor
                              //bu listeyi sirayla kullanmak icin listenin indexi value'ye veriyoz snapshot.data![index].
                              value: snapshot.data![index],
                              child: TopTrendingWidget(
                              ),
                            )

                          ),
                        );
                }
              },
            )
            /*newsType == NewsType.allNews
                ? Expanded(
                  child: ListView.builder(

              itemBuilder: (context, index) {
                    return ArticlesWidget();
                  },),
                )
                : SizedBox(
                    height: size.height * 0.5,
                    child: Swiper(
                      itemCount: 5,
                      viewportFraction:
                          0.8, //sayfalari birbirine yakin gostermek icin
                      layout: SwiperLayout.STACK,//fotolar ust uste gostermek icin
                      itemWidth: size.width * 0.9,//width degeri vermezsek layout ozelligi calismaz
                      autoplay: true,
                      autoplayDelay: 5000,
                      itemBuilder: (context, index) => TopTrendingWidget(),
                    ),
                  )*/

            /*  Flexible(
              child: ListView.separated(
                itemCount: 20,
                separatorBuilder: (context, index) => const SizedBox(height: 15,),
                itemBuilder: (context, index) {
                return  ArticlesWidget();
              },),
            )*/
          ],
        ),
      ),
    );
  }

  List<DropdownMenuItem<String>> get dropDownItems {
    List<DropdownMenuItem<String>> newItme = [
      DropdownMenuItem(
        //her itemi secince hangi value/deger vercegini asagida belirliyoz
        value: SortByEnum.relevancy.name,
        child: Text(SortByEnum.relevancy.name),
      ),
      DropdownMenuItem(
        value: SortByEnum.publishedAt.name,
        child: Text(SortByEnum.publishedAt.name),
      ),
      DropdownMenuItem(
        value: SortByEnum.popularity.name,
        child: Text(SortByEnum.popularity.name),
      ),
    ];
    return newItme;
  }

  Widget paginationButtons({required Function function, required String text}) {
    return ElevatedButton(
      onPressed: () {
        function();
      },
      style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.all(6),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
          textStyle:
              const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
      child: Text(text),
    );
  }
}
