import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:news_app_hadi_kachmar/inner_screens/bookmarks_screen.dart';
import 'package:news_app_hadi_kachmar/providers/theme_provider.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

class DrawerWidget extends StatefulWidget {
  const DrawerWidget({Key? key}) : super(key: key);

  @override
  State<DrawerWidget> createState() => _DrawerWidgetState();
}

class _DrawerWidgetState extends State<DrawerWidget> {
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Drawer(
      child: Material(
        color: Theme.of(context).scaffoldBackgroundColor,
        child: ListView(
          children: [
            DrawerHeader(
                decoration:
                    BoxDecoration(color: Theme.of(context).primaryColor),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Flexible(child: Image.asset('assets/images/newspaper.png')),
                    Flexible(
                        child: Text(
                      'News App',
                      style: GoogleFonts.lobster(fontSize: 20),
                    )),
                  ],
                )),
            listTile(
              title: 'Home',
              icon: IconlyBold.home,
              onTap: () {},
            ),
            listTile(
              title: 'BookMark',
              icon: IconlyBold.bookmark,
              onTap: () {
                //PageTransition paketi guzel bi sekilde sagdan sola yen ekrani acmak icin kullanilir
                Navigator.push(
                    context,
                    PageTransition(
                        type: PageTransitionType.rightToLeft,
                        child: BookmarkScreen(),
                        inheritTheme: true,
                        ctx: context));
              },
            ),
            Divider(
              thickness: 4,
            ),
            SwitchListTile(

                //SwitchListTile widget'ini kullanarak basta icon ve title ekleyebilirizx asagidaki gibi
                title: Text(
                  // //getDarkTheme degiskeni veya ona atilan degeri kullanarak title,renk ve icon degistirebiliriz
                  themeProvider.getDarkTheme ? 'Dark' : 'Light',
                  style: TextStyle(fontSize: 20),
                ),
                secondary: Icon(
                  themeProvider.getDarkTheme
                      ? Icons.dark_mode
                      : Icons.light_mode,
                  color: Theme.of(context).colorScheme.secondary,
                ),
                value: themeProvider
                    .getDarkTheme, //ThemeProvider sinifi ile getDark degerine ulasip Provider ozlligini kullanip rengi degistirebiliriz
                //switch iconu basip ondan gelen bool degeri kullanarak uygulamanin rengi degistirebiliriz
                onChanged: (bool value) {
                  setState(() {
                    themeProvider.setDarkTheme = value;
                  });
                }),
          ],
        ),
      ),
    );
  }

  ListTile listTile(
      {required String title, icon, required void Function()? onTap}) {
    return ListTile(
      onTap: onTap,
      leading: Icon(
        icon,
        color: Theme.of(context).colorScheme.secondary,
      ),
      title: Text(
        title,
        style: TextStyle(fontSize: 20),
      ),
    );
  }
}
