import 'package:flutter/material.dart';
class InternetWidget extends StatelessWidget {
  const InternetWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Icon(Icons.wifi_find,size: 100,),
          Text(("Please check you Internet Connection"),style: TextStyle(fontSize: 20,fontWeight: FontWeight.w600),)
        ],
      ),
    );
  }
}
