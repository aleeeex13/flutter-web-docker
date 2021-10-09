import 'package:flutter/material.dart';
import 'package:test_app_microsoft_data/Service/Model/account.dart';
import 'package:test_app_microsoft_data/Service/Screen/screen_routes.dart';

class AccountDetailsScreen extends StatelessWidget {
  static const routeName = ServiceScreensRoutes.detailsRoute;

  const AccountDetailsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Account account =
        ModalRoute.of(context)!.settings.arguments as Account;
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
        Expanded(
          flex: 2,
          child: AspectRatio(
            aspectRatio: 16 / 9,
            child: Container(
              height: 400,
              color: Colors.grey,
            ),
          ),
        ),
        Expanded(
            flex: 4,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(account.name),
                SizedBox(
                  height: 80,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text(
                        account.accounPhonetnumber.toString(),
                      ),
                      Text(account.stateCode),
                      Text(account.stateOrProvince)
                    ],
                  ),
                )
              ],
            ))
          ],
        ),
      ),
    );
  }
}
