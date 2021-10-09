import 'dart:collection';

import 'package:test_app_microsoft_data/Service/Model/account.dart';
import 'package:test_app_microsoft_data/Service/Data_provider/data_provide.dart';
import 'package:test_app_microsoft_data/Service/constants/constans.dart';

class AccountsRepository {
  final AccountsDataProvider dataProvider;
  List<Account> _cachedAccounts = [];
  final HashSet<String> _uniqStateCodes = HashSet();
  final HashSet<String> _uniqProvinceCodes = HashSet();
  final Map<String, HashSet<String>> filterParams = {};

  AccountsRepository({required this.dataProvider});

  Future<List<Account>?> getAccounts() async {
    _cachedAccounts = await dataProvider.getAccounts() ?? [];
    _uniqStateCodes.clear();
    _uniqProvinceCodes.clear();
    for (var element in _cachedAccounts) {
      _uniqStateCodes.add(element.stateCode);
      _uniqProvinceCodes.add(element.stateOrProvince);
    }

    filterParams[stateCodeField] = _uniqStateCodes;
    filterParams[provinceCodeField] = _uniqProvinceCodes;

    return _cachedAccounts;
  }

  List<Account> get cachedAccounts => _cachedAccounts;
}
