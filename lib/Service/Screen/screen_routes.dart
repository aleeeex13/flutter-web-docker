import 'package:flutter/material.dart';
import 'package:test_app_microsoft_data/Service/Screen/screens.dart';

class ServiceScreensRoutes {

  ServiceScreensRoutes._();

  static const String mainRoute = "/main";
  static const String detailsRoute = "/details";

  static final routes = <String, WidgetBuilder>{
    mainRoute: (BuildContext context) => const AccountsMainScreen(),
    detailsRoute: (BuildContext context) => const AccountDetailsScreen(),
  };
}
