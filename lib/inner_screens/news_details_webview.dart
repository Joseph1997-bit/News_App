import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:news_app_hadi_kachmar/services/global_methods.dart';
import 'package:news_app_hadi_kachmar/widgets/vertical_spacing.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:share_plus/share_plus.dart';

class NewsDetailsWebView extends StatefulWidget {
  const NewsDetailsWebView({Key? key, required this.url}) : super(key: key);
final String url;
  @override
  State<NewsDetailsWebView> createState() => _NewsDetailsWebViewState();
}

class _NewsDetailsWebViewState extends State<NewsDetailsWebView> {
  double _progress = 0.0;
//  final url = 'https://techcrunch.com/events/tc-disrupt-2023/';
  WebViewController _webViewController = WebViewController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _webViewController.loadRequest(
      //https://techcrunch.com/events/tc-disrupt-2023/
        Uri.parse(widget.url));
    _webViewController.enableZoom(true);
    _webViewController.setNavigationDelegate(NavigationDelegate(
      onProgress: (progress) {
        setState(() {
          //progress degeri appBar altinda line olarak gozukecektir
          _progress = progress / 100;
        });
      },
    ));
    //asagidaki kodu eklemezsek webteki tum ekran uygulamada gozukmeyebilir
    _webViewController.setJavaScriptMode(JavaScriptMode.unrestricted);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      //bu widget ve kodu ekleyince uyglamada web sayfasinda baska sayfaya gidince ve geri icona basinca bi onceki sayfaya donecektir.Web sayfasindan direkt cikmayack
      onWillPop: () async {
        if (await _webViewController.canGoBack()) {
          _webViewController.goBack();
          // stay inside
          return false;
        } else {
          return true;
        }
      },
      child: Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title:  Text('Web Viewer ${widget.url}'),
            actions: [
              IconButton(
                  onPressed: () async {
                    _showModalSheetFct();
                  },
                  icon: const Icon(Icons.more_horiz))
            ],
          ),
          body: Column(
            children: [
              LinearProgressIndicator(
                value: _progress, // Set the progress value between 0.0 and 1.0
                backgroundColor: Colors
                    .white60, // Set the background color of the progress bar
                color: Colors
                    .blueAccent, // Set the progress color of the progress bar
              ),
              Expanded(
                //ayni uygulamada web sayfasi acmak icin kullanilir
                child: WebViewWidget(
                  controller: _webViewController,
                ),
              ),
            ],
          )),
    );
  }

  Future<void> _showModalSheetFct() async {
    await showModalBottomSheet(
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(15))),
      context: context,
      builder: (context) {
        return Container(
          decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(15))),
          child: Column(
            //mainAxisSize ozelligi BottomShet boyutu kucultmek icin kullandim
            mainAxisSize: MainAxisSize.min,
            children: [
              const VerticalSpacing(20),
              Container(
                height: 5,
                width: 50,
                decoration: BoxDecoration(
                    color: Colors.grey,
                    borderRadius: BorderRadius.circular(30)),
              ),
              const VerticalSpacing(20),
              const Text(
                'More option',
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20),
              ),
              const VerticalSpacing(20),
              const Divider(
                thickness: 2,
              ),
              const VerticalSpacing(20),
              ListTile(
                leading: const Icon(Icons.share),
                title: const Text('Share'),
                onTap: () async {
                  try {
                    await Share.share(
                        widget.url,
                        subject: 'Look what I made!');
                  } catch (err) {
                    GlobalMethods.errorDialog(
                        errorMessage: err.toString(), context: context);
                    //    log(err.toString());
                  }
                },
              ),
              ListTile(
                leading: const Icon(Icons.open_in_browser),
                title: const Text('Open in browser'),
                onTap: () async {
                  if (!await launchUrl(Uri.parse(widget.url))) {
                    throw 'Could not launch ${widget.url}}';
                  }
                },
              ),
              ListTile(
                leading: const Icon(Icons.refresh),
                title: const Text('Refresh'),
                onTap: () async {
                  try {
                    await _webViewController.reload();
                  } catch (err) {
                    log("error occured $err");
                  } finally {
                    Navigator.pop(context);
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
