import 'package:get/get.dart';
import 'package:silluatte/home.view.dart';


import '../main_view/sihilluatte_view.dart';
import 'app_route_names.dart';

class Routes {
  static List<GetPage> routes = [
    GetPage(
      name: AppRouteNames.home,
      page: () =>  HomeView(),
      preventDuplicates: true,
    ),
    // GetPage(
    //   name: AppRouteNames.sihilluatte,
    //   page: () =>   SihilluatteView(),
    //   preventDuplicates: true,
    // ),
  ];
}
