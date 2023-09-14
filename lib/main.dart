//Packages
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:news_app_hadi_kachmar/inner_screens/blog_details.dart';
import 'package:news_app_hadi_kachmar/providers/bookmarks_provider.dart';
import 'package:news_app_hadi_kachmar/providers/news_provider.dart';
import 'package:news_app_hadi_kachmar/providers/theme_provider.dart';
//Providers
import 'package:provider/provider.dart';

//Screens
import 'screens/home_screen.dart';

//Consts
import 'consts/theme_data.dart';

// This will always work for lock screen Orientation.
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
  runApp( MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  //Need it to access the theme Provider
  ThemeProvider themeChangeProvider = ThemeProvider();


  @override
  void initState() {
    getCurrentAppTheme();
    super.initState();
  }

  //Fetch the current theme
  void getCurrentAppTheme() async {
    //memorey'da saklanan bool degeri getTheme()'dan alip set metoduna atip renk turu ayarlamak icin
    themeChangeProvider.setDarkTheme =
        await themeChangeProvider.darkThemePreferences.getTheme();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      //Provider siniflari kullanmak icin widget agacin en ustte koymamiz gerekiyo yoksa hata verir
      providers: [
        ChangeNotifierProvider(create: (_) {
          //Notify about theme changes
          return themeChangeProvider;
        }),
        ChangeNotifierProvider(create: (_) {
          //Notify about theme changes
          return NewsProvider();
        }),
        ChangeNotifierProvider(create: (_) {
          //Notify about theme changes
          return BookmarksProvider();
        }),
      ],
      child: //Consumer widget'in turu ThemeProvider oldugu icin themeChangeProvider kullanip getDakr degiskenin degerine ulasip renk degistirebilirz
          Consumer<ThemeProvider>(builder: (context, themeChangeProvider, ch) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'News App - Flutter&API Course',
          //Styles sinifina ulasip themeData fonkisyonu kullanip uygulamanin renkleri ayarlamak icin.ve bu sinif ThemeData turu dondurdugu icin herhangi bi hata cikmaz
          theme: Styles.themeData(themeChangeProvider.getDarkTheme, context),
          home: const HomeScreen(),
          routes: {
            NewsDetailsScreen.routeName: (ctx) => const NewsDetailsScreen(),
          },
        );
      }),
    );
  }
}
