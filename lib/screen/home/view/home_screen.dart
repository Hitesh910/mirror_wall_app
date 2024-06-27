import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:mirror_wall_app/componet/provider/internet_provider.dart';
import 'package:mirror_wall_app/componet/view/internet_widget.dart';
import 'package:provider/provider.dart';

import '../provider/home_provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  HomeProvider? providerR;
  HomeProvider? providerW;
  InAppWebViewController? checkInAppWebView;
  TextEditingController? txtSearch = TextEditingController();
  String? link2;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    context.read<HomeProvider>().getLink1();
    context.read<HomeProvider>().getLink1().then((value) {
      link2 = context.read<HomeProvider>().link.toString();
    },);
    //print(link2);
    // print(context.read<HomeProvider>().getLink1().then((value) {
    //   link2 = context.read<HomeProvider>().link!;
    // },));
  }

  @override
  Widget build(BuildContext context) {
    providerR = context.read<HomeProvider>();
    providerW = context.watch<HomeProvider>();
    //InappWebViewController? checkInappWebView;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Goverment Service"),
        actions: [
          PopupMenuButton(
            itemBuilder: (context) {
            return  [
                PopupMenuItem(
                  onTap: () {
                    showDialogMain();
                  },
                  child: Text("Search Engine"),
                ),
              PopupMenuItem(onTap: () {
                showBookMark();
              },child: Text("Bookmarks"))
              ];
            },
          )
        ],
      ),
      body: context.watch<InternetProvider>().isInternet
          ? Column(
              children: [
                providerW!.isCheck < 1.0
                    ? LinearProgressIndicator(
                        value: providerW!.isCheck,
                      )
                    : Container(),
                Expanded(
                  child: InAppWebView(
                    initialUrlRequest:
                        URLRequest(url: WebUri("https://www.google.co.in/")),
                    onLoadStop: (controller, url) {},
                    onLoadStart: (controller, url) {
                      checkInAppWebView = controller;
                    },
                    onProgressChanged: (controller, progress) {
                      double check = progress / 100;
                      providerR!.check(check);
                    },
                  ),
                ),
                SearchBar(
                  onTap: () {
                    checkInAppWebView!.loadUrl(urlRequest: URLRequest(url: WebUri("https://www.google.com/search?q=/${txtSearch!.text}")));
                  },
                  controller: txtSearch,
                  padding: WidgetStatePropertyAll(
                      EdgeInsets.symmetric(horizontal: 15)),
                  hintText: "Search",
                  leading: Icon(Icons.search),
                )
              ],
            )
          : const InternetWidget(),
      bottomNavigationBar: BottomNavigationBar(items: [
        BottomNavigationBarItem(
          label: "Home",
          icon: IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.home,
              color: Colors.black,
              size: 35,
            ),
          ),
        ),
        BottomNavigationBarItem(
          label: "Bookmark",
          icon: IconButton(
            onPressed: () async {
              var  link = await checkInAppWebView!.getOriginalUrl();
               providerR!.setLink1(link.toString());
              print(link!.toString());
            },
            icon: const Icon(
              Icons.bookmark_add_outlined,
              color: Colors.black,
              size: 35,
            ),
          ),
        ),
        BottomNavigationBarItem(
          label: "Back",
          icon: IconButton(
            onPressed: () {
              checkInAppWebView!.goBack();
            },
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.black,
              size: 35,
            ),
          ),
        ),
        BottomNavigationBarItem(
          label: "Forward",
          icon: IconButton(
            onPressed: () {
              checkInAppWebView!.goForward();
            },
            icon: const Icon(
              Icons.arrow_forward,
              color: Colors.black,
              size: 35,
            ),
          ),
        ),
        BottomNavigationBarItem(
          label: "Refresh",
          icon: IconButton(
            onPressed: () {
              checkInAppWebView!.reload();
            },
            icon: const Icon(
              Icons.refresh,
              color: Colors.black,
              size: 35,
            ),
          ),
        )
      ]),
    );
  }

  void showDialogMain() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              RadioListTile(
                value: "Google",
                groupValue: providerW!.isChoice,
                onChanged: (value) {
                  providerR!.choice(value);
                  checkInAppWebView!.loadUrl(
                      urlRequest: URLRequest(
                          url: WebUri("https://www.google.co.in/new")));
                  Navigator.pop(context);
                },
                title: const Text("Google"),
              ),
              RadioListTile(
                value: "Yahoo",
                groupValue: providerW!.isChoice,
                onChanged: (value) {
                  providerW!.choice(value);
                  checkInAppWebView!.loadUrl(
                      urlRequest: URLRequest(
                          url: WebUri("https://in.search.yahoo.com/")));
                  Navigator.pop(context);
                },
                title: const Text("Yahoo"),
              ),
              RadioListTile(
                value: "DuckDuckGo",
                groupValue: providerW!.isChoice,
                onChanged: (value) {
                  providerR!.choice(value);
                  checkInAppWebView!.loadUrl(
                      urlRequest:
                          URLRequest(url: WebUri("https://duckduckgo.com/")));
                  Navigator.pop(context);
                },
                title: const Text("DuckDuckGo"),
              ),
              RadioListTile(
                value: "Bing",
                groupValue: providerW!.isChoice,
                onChanged: (value) {
                  providerR!.choice(value);
                  checkInAppWebView!.loadUrl(
                      urlRequest:
                          URLRequest(url: WebUri("https://www.bing.com/")));
                  Navigator.pop(context);
                },
                title: const Text("Bing"),
              )
            ],
          ),
        );
      },
    );
  }

  void showBookMark()
  {
    showModalBottomSheet(context: context, builder: (context) {
    return  BottomSheet(onClosing: () {

      }, builder: (context) {
       return Container(
         child: Column(
           children: [
             Text("${link2.toString()}")
           ],
         ),
       );
      },);
    },);
  }
}
