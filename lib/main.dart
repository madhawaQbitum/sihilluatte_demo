import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:silluatte/utils/app_route_names.dart';


import 'utils/routes.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {

    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      initialBinding: BindingsBuilder(() {

      }),
      getPages: Routes.routes,
      title: 'MES - silhouette',
      initialRoute:AppRouteNames.home,
    );;
  }
}


