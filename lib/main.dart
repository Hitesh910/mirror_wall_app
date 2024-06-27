import 'package:flutter/material.dart';
import 'package:mirror_wall_app/componet/provider/internet_provider.dart';
import 'package:mirror_wall_app/screen/home/provider/home_provider.dart';
import 'package:mirror_wall_app/utils/app_routes.dart';
import 'package:provider/provider.dart';

void main() {
  WidgetsFlutterBinding();
  runApp(MultiProvider(
    providers: [ChangeNotifierProvider.value(value: HomeProvider()),
    ChangeNotifierProvider.value(value: InternetProvider()..checkInternet())],
    child: MaterialApp(
      debugShowCheckedModeBanner: false,
      routes: app_routes,
    ),
  ));
}
