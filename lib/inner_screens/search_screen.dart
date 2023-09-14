import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:news_app_hadi_kachmar/consts/vars.dart';
import 'package:news_app_hadi_kachmar/models/news_model.dart';
import 'package:news_app_hadi_kachmar/providers/news_provider.dart';
import 'package:news_app_hadi_kachmar/services/utils.dart';
import 'package:news_app_hadi_kachmar/widgets/articales_widget.dart';
import 'package:news_app_hadi_kachmar/widgets/empty_screen.dart';
import 'package:provider/provider.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  late final TextEditingController _searchTextController;
  late final FocusNode focusNode;
  List<NewsModel>? searchList = [];
  bool isSearching = false;
  @override
  void initState() {
    super.initState();
    //when this page opens we initialize these variables
    _searchTextController = TextEditingController();
    focusNode = FocusNode();
  }

  @override
  void dispose() {
    //if the screen destroyed we close/dispose these variables
    if (mounted) {
      _searchTextController.dispose();
      focusNode.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = Utils(context).getScreenSize;
    final Color color = Utils(context).getColor;
    final newsProvider = Provider.of<NewsProvider>(context);
    return SafeArea(
      child: GestureDetector(
        onTap: () {
          //ekrana basinca keyboardi kapatmak icin kullanilir
          FocusScope.of(context).unfocus();
        },
        child: Scaffold(
          body: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Row(
                  children: [
                    InkWell(
                        borderRadius: BorderRadius.circular(15),
                        onTap: () {
                          focusNode.unfocus();
                          Navigator.pop(context);
                        },
                        child: const Icon(IconlyLight.arrowLeft2, size: 25)),
                    //   SizedBox(width: size.width / 35),
                    Flexible(
                        child: TextField(
                      focusNode: focusNode,
                      controller: _searchTextController,
                      autofocus: true,
                      textInputAction: TextInputAction
                          .search, //Keyboarda'ta done isaret yerine search iconu koymak icin
                      keyboardType: TextInputType.text,
                      //bu ozellik onEditingComplete search ikonuna tiklayinca arama islemi baslayacaktir
                      onEditingComplete: () async {
                        searchList = await newsProvider.searchNewsProvider(
                            query: _searchTextController.text);
                        isSearching = true;
                        focusNode.unfocus();
                        setState(() {});
                      },
                      decoration: InputDecoration(
                          //suffix ozelligi kullandigim icin eger TextField secili degilse close iconu gozukmeyeck
                          suffix: GestureDetector(
                            onTap: () {
                              _searchTextController.clear();
                              focusNode.unfocus();
                              // searchList =[];
                              searchList!.clear();
                              setState(
                                  () {}); //metin alani temizledikten sonra degisiklikleri ekranda gormek icin setState cagirmamiz gerekyo
                            },
                            child: Icon(
                              Icons.close,
                              color: color,
                              size: 18,
                            ),
                          ),
                          hintText: "Search",
                          contentPadding:
                              const EdgeInsets.only(bottom: 8 / 5, left: 10),
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none),
                      style: TextStyle(color: color),
                    )),
                  ],
                ),
              ),
              //eger daha arama yapilmadiysa ve arama listesi bos ise arama secenekleri gostersin
              if (!isSearching && searchList!.isEmpty)
                Flexible(
                  child: GridView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    //   shrinkWrap: true,
                    padding: EdgeInsets.symmetric(vertical: 5, horizontal: 8),
                    itemCount: searchKeywords.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 4,
                      mainAxisSpacing: 15,
                      crossAxisSpacing: 15,
                      mainAxisExtent: 33,
                    ),
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () async {
                          setState(() {
                            //arama sayfasindaki kelimelere tiklayinca arama islemi baslatmak icin asagidaki kodu yazdik
                            _searchTextController.text = searchKeywords[index];
                          });
                          searchList = await newsProvider.searchNewsProvider(
                              query: _searchTextController.text);
                          isSearching = true;
                          focusNode.unfocus();
                        },
                        child: Container(
                          alignment: Alignment.center,
                          padding: EdgeInsets.all(5),
                          decoration: BoxDecoration(
                              border: Border.all(color: color),
                              borderRadius: BorderRadius.circular(30)),
                          child: FittedBox(child: Text(searchKeywords[index])),
                        ),
                      );
                    },
                  ),
                ),
              //arama yaptiktan sonra sonuc yoksa asagidaki mesaji goster
              if (isSearching && searchList!.isEmpty)
                const Expanded(
                  child: EmptyNewsWidget(
                    text: "Ops! No resuls found",
                    imagePath: 'assets/images/search.png',
                  ),
                ),
              //arama yaptiktan sonra sonuc varsa asagidaki kod sonuclari gosterecktir
              if (searchList != null && searchList!.isNotEmpty)
                Expanded(
                  child: ListView.builder(
                      itemCount: searchList!.length,
                      itemBuilder: (ctx, index) {
                        return ChangeNotifierProvider.value(
                          value: searchList![index],
                          child:  ArticlesWidget(),
                        );
                      }),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
