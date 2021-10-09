export 'package:test_app_microsoft_data/Service/Screen/accounts_main_screen.dart';
import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:test_app_microsoft_data/Service/Bloc/accounts_event.dart';
import 'package:test_app_microsoft_data/Service/Bloc/accountss_bloc.dart';
import 'package:test_app_microsoft_data/Service/Data_provider/data_provide.dart';
import 'package:test_app_microsoft_data/Service/Repository/repository.dart';
import 'package:test_app_microsoft_data/Service/Screen/screens.dart';

import 'Screen/screen_routes.dart';

class Service extends StatelessWidget {
  const Service({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider(
              create: (context) => AccountsBloc(
                  accountsRepository: AccountsRepository(
                      dataProvider: AccountsDataProvider(Dio())))
                ..add(const AccountsLoad()))
        ],
        child: MaterialApp(
            theme: ThemeData(primaryColor: Colors.grey),
            routes: ServiceScreensRoutes.routes,
            home: AccountsMainScreen(key: key)));
  }
}
