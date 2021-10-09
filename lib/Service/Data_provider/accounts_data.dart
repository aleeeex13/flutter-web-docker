import 'dart:math';
import 'package:dio/dio.dart';
import 'package:test_app_microsoft_data/Service/Model/account.dart';

class AccountsDataProvider {
  final Dio dioClient;
  static const String tenantId = "0b2143da-9706-4b05-b1bd-bfed79bec2c7";
  static const List<String> countryDict = ['ZZ', 'US', 'EN', 'RU', 'AU'];
  static const List<String> provinceDict = ['TX', 'NP', 'LU', 'BL', 'YA'];
  static final Random rndGen = Random(13);

  AccountsDataProvider(this.dioClient);

  Future<List<Account>?> getAccounts() async {
    List<Account> accountsGens = [];
    // final response = await Dio()
    //     .get('https:///johnbuisenes.onmicrosoft.com/api/data/v9.0/accounts')
    //     .onError((error, stackTrace) {
    //   print(error);
    //   print(stackTrace);;
    // });

    // try {

    //   // final response = await http.get(Uri.parse());
    //   final response = await Dio().get('https:///johnbuisenes.onmicrosoft.com/api/data/v9.0/accounts').onError((error, stackTrace) {
    //     print(error);
    //     print(stackTrace);
    //   });

    //   print(response.toString());
    //   // if (response.statusCode == 200) {
    //   //   final accounts = jsonDecode(response.body) as List;
    //   //   return accounts.map((account) => Account.fromJson(account)).toList();
    //   // } else {
    //   //   return null;
    //   // }
    // } catch (e) {
    //   print("Exception throuwn $e");
    //   print(e.toString());
    //   return null;
    // }

    for (int i = 0; i < 20000; i++) {
      String phonenumber = "8";
      for (int j = 0; j < 7; j++) {
        phonenumber += rndGen.nextInt(9).toString();
      }
      accountsGens.add(Account(
          accountid: i,
          name: "name: $i",
          accounPhonetnumber: phonenumber,
          stateCode: countryDict[rndGen.nextInt(countryDict.length)],
          stateOrProvince: provinceDict[rndGen.nextInt(provinceDict.length)]));
      // if (i % 15 == 0) await Future.delayed(const Duration(milliseconds: 1));
    }

    return accountsGens;
  }
}
