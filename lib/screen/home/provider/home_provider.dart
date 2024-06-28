import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';

import '../../../utils/helper/shared_helper.dart';
import '../model/data_model.dart';
class HomeProvider with ChangeNotifier
{
  String? isChoice = "Google";
  double isCheck = 0;
  SharedHelper share = SharedHelper();
  String? link;
  String? searchLink = "https://www.google.com/search?q=/";
  List<String> bookmarkSave = [];
  bool isProgress = true;
  String? eLink = "https://www.google.com";
    // List<DataModel> dataOption = [
    //   DataModel(image: )
    // ];

  List<DataModel> dataOption = [
    DataModel(title: "Google",link: "https://www.google.co.in/"),
    DataModel(title: "Yahoo",link: "https://in.search.yahoo.com/"),
    DataModel(title: "Duckduckgo",link: "https://duckduckgo.com/"),
    DataModel(title: "Bing",link: "https://www.bing.com/")
  ];

  void choice(choice)
  {
    isChoice = choice;
    notifyListeners();
  }

  void check(double value)
  {
    isCheck = value;
    notifyListeners();
  }

  void setLink1(String link)
  {
    // getLink1();
    bookmarkSave.add(link);
    share.setLink(bookmarkSave);
    getLink1();
    notifyListeners();
    print(link);
  }

  Future<void> getLink1()
  async {
      var link = await share.getLink();

    // if(await share.getLink() == null)
    //   {
    //     bookmarkSave = [];
    //   }
    // else
    //   {
    //     bookmarkSave = (await share.getLink());
    //   }

    if(link!= null)
      {
        bookmarkSave = link;
      }
    notifyListeners();
    print(link);
  }

  void changeLink(String enLink,String link)
  {
    eLink = enLink;
    searchLink = link;
    notifyListeners();
  }

  // void addBookmark(String link)
  // {
  //   bookmarkSave[i] = link;
  //   notifyListeners();
  // }

    void onPogress()
    {
      Connectivity().onConnectivityChanged.listen((event) {
        if(event.contains(ConnectivityResult.none))
        {
          isProgress = false;
        }
        else
          {
            isProgress = true;
          }

        notifyListeners();
      },);
    }

    void deleteLink(int index)
    {
      bookmarkSave.removeAt(index);
      share.setLink(bookmarkSave);
      // share.getLink();

      // share.getLink();
      notifyListeners();
    }
}