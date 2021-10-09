import 'dart:collection';

import 'package:quiver/core.dart';
import 'package:test_app_microsoft_data/Service/constants/constans.dart';

class Account extends LinkedListEntry<Account> {
  final int accountid;
  final String name;
  final String? accounPhonetnumber;
  final String stateCode;
  final String stateOrProvince;

  Account(
      {required this.accountid,
      required this.name,
      this.accounPhonetnumber,
      required this.stateCode,
      required this.stateOrProvince});

  factory Account.fromJson(json) {
    int id = int.parse(json["accountid"]);
    return Account(
        accountid: id,
        name: json["name"],
        accounPhonetnumber: json['accountnumber'],
        stateCode: json[stateCodeField],
        stateOrProvince: json[provinceCodeField]);
  }

  String operator [](String key) {
    switch (key) {
      case stateCodeField:
        return stateCode;
      case provinceCodeField:
        return stateOrProvince;
    }

    return "";
  }

  @override
  String toString() {
    return 'name: $name accountNumber: $accounPhonetnumber stateCode: $stateCode provinceCode: $stateOrProvince id: $accountid';
  }

  @override
  bool operator ==(o) =>
      o is Account &&
      accountid == o.accountid &&
      name == o.name &&
      accounPhonetnumber == o.accounPhonetnumber &&
      stateCode.compareTo(o.stateCode) == 0;

  @override
  int get hashCode =>
      hash4(accountid.hashCode, name.hashCode, accounPhonetnumber.hashCode, stateCode.hashCode);
}
