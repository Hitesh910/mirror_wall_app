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
  PullToRefreshController? pullToRefresh;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    context.read<HomeProvider>().getLink1();
    context.read<HomeProvider>().getLink1().then(
      (value) {
        link2 = context.read<HomeProvider>().link.toString();
      },
    );
    context.read<HomeProvider>().onPogress();
    pullToRefresh = PullToRefreshController(
      onRefresh: () {
        checkInAppWebView!.reload();
      },
    );
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
        title: const Text("Mirror Wall"),
        actions: [
          PopupMenuButton(
            itemBuilder: (context) {
              return [
                PopupMenuItem(
                  onTap: () {
                    showDialogMain();
                  },
                  child: Text("Search Engine"),
                ),
                PopupMenuItem(
                    onTap: () {
                      showBookMark();
                    },
                    child: Text("Bookmarks"))
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
                    onLoadStop: (controller, url) {
                      pullToRefresh!.endRefreshing();
                    },
                    onLoadStart: (controller, url) {
                      checkInAppWebView = controller;
                    },
                    onProgressChanged: (controller, progress) {
                      double check = progress / 100;
                      providerR!.check(check);
                      if (progress == 100) {
                        pullToRefresh!.endRefreshing();
                      }
                    },
                    pullToRefreshController: pullToRefresh,
                    // pullToRefreshController: PullToRefreshController(
                    //   onRefresh: () {
                    //     //checkInAppWebView!.reload();
                    //     if (providerW!.isCheck == 1) {
                    //       //pullToRefresh!.isRefreshing();
                    //       pullToRefresh!.endRefreshing();
                    //     }
                    //     pullToRefresh!.isRefreshing();
                    //   },
                    // ),
                  ),
                ),
                SearchBar(
                  trailing: [
                    IconButton(
                        onPressed: () {
                          checkInAppWebView!
                              .loadUrl(urlRequest: URLRequest(url: WebUri(
                                  // "https://www.google.com/search?q=/"

                                  "${providerW!.searchLink}${txtSearch!.text}")));
                          txtSearch!.clear();
                        },
                        icon: Icon(Icons.search)),
                  ],
                  onTap: () {
                    // checkInAppWebView!.loadUrl(urlRequest: URLRequest(url: WebUri(
                    //     // "https://www.google.com/search?q=/"
                    //
                    //         "${providerW!.searchLink}${txtSearch!.text}")));
                    // txtSearch!.clear();
                  },
                  controller: txtSearch,
                  padding: WidgetStatePropertyAll(
                      EdgeInsets.symmetric(horizontal: 15)),
                  hintText: "Search",
                  // leading: Icon(Icons.search),
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
              var link = await checkInAppWebView!.getOriginalUrl();
              providerR!.setLink1(link.toString());
              providerR!.bookmarkSave.add(link.toString());
              // providerR!.addBookmark(link.toString());

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
                  providerR!.changeLink("https://www.google.com/search?q=/");
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
                  providerR!.changeLink(
                      "https://in.search.yahoo.com/search;_ylt=Awr1SdbQnn1mZuoQ_u66HAx.;_ylc=X1MDMjExNDcyMzAwMgRfcgMyBGZyAwRmcjIDcDpzLHY6c2ZwLG06c2ItdG9wBGdwcmlkAwRuX3JzbHQDMARuX3N1Z2cDMARvcmlnaW4DaW4uc2VhcmNoLnlhaG9vLmNvbQRwb3MDMARwcXN0cgMEcHFzdHJsAzAEcXN0cmwDNARxdWVyeQNnYW1lBHRfc3RtcAMxNzE5NTA5MDg5?p=");
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
                  providerR!.changeLink("https://duckduckgo.com/?t=h_&q=");
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
                  providerR!.changeLink("https://www.bing.com/search?q=");
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

  void showBookMark() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return BottomSheet(
          onClosing: () {},
          builder: (context) {
            return Expanded(
              child: ListView.builder(
                itemCount: providerW!.bookmarkSave.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    onTap: () {
                      checkInAppWebView!.
                      loadUrl(
                          urlRequest:
                              URLRequest(url: WebUri("${providerW!.bookmarkSave[index]}")));
                      Navigator.pop(context);
                    },
                    title: Text("${providerW!.bookmarkSave[index]}",style: TextStyle(overflow: TextOverflow.ellipsis),),
                  );
                },
              ),
            );
          },
        );
      },
    );
  }
}
