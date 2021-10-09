import 'dart:collection';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:test_app_microsoft_data/Service/Bloc/bloc.dart';
import 'package:test_app_microsoft_data/Service/Model/account.dart';
import 'package:test_app_microsoft_data/Service/Repository/accounts_repository.dart';
import 'package:test_app_microsoft_data/Service/constants/constans.dart';

class AccountsBloc extends Bloc<AccountsEvent, AccountsState> {
  final AccountsRepository accountsRepository;

  AccountsBloc({required this.accountsRepository}) : super(AccountsLoading());

  @override
  Stream<AccountsState> mapEventToState(AccountsEvent event) async* {
    if (event is AccountsLoad) {
      yield AccountsLoading();

      try {
        final accounts = await accountsRepository.getAccounts();
        yield AccountsLoadSuccess(accounts!);
      } catch (_) {
        yield AccountsOperationFailure();
      }
    }
    if (event is AccountsFilter) {
      var accs =
          await _filterAccounts(accountsRepository.cachedAccounts, event);
      yield AccountsFiltredSuccess(accs);
    }
  }

  Future<List<Account>> _filterAccounts(
      List<Account> accounts, AccountsFilter filter) async {
    if (filter.searchQuerry.isEmpty && filter.filterParams.isEmpty) {
      return accountsRepository.cachedAccounts;
    }

    var cashed = List<Account>.from(accountsRepository.cachedAccounts);
    if (filter.filterParams.keys.isNotEmpty) {
      List<Account> filtered = _runFilterByParams(cashed, filter);
      return _runFilterByQerry(filtered, filter.searchQuerry);
    } else {
      return _runFilterByQerry(cashed, filter.searchQuerry);
    }
  }

  List<Account> _runFilterByQerry(List<Account> accs, String searchQuerry) {
    if (searchQuerry.isEmpty) return accs;
    if (int.tryParse(searchQuerry) != null) {
      return accs
          .where((element) => element.accounPhonetnumber
              .toString()
              .toLowerCase()
              .contains(searchQuerry.toLowerCase()))
          .toList();
    }
    return accs
        .where((element) =>
            element.name.toLowerCase().contains(searchQuerry.toLowerCase()))
        .toList();
  }

  // should simplify and do it more generic way
  List<Account> _runFilterByParams(
      List<Account> cashed, AccountsFilter filter) {
    // using hashSet cause may to be duplicates
    HashSet<Account> filtered = HashSet();
    List<Account> tmpList2 = [];
    bool isFilteredFiltred = false;

    // keyfield - one of Account model field
    for (var keyField in filter.filterParams.keys) {
      List<Account> tmpList = [];
      Map<String, bool> a = filter.filterParams[keyField] ?? {};
      // entry - value of keyfield is checked on UI or not
      for (MapEntry<String, bool> entryField in a.entries) {
        if (entryField.value) {
          // stateCode has priority if it checked all filtering will be on filtred by this field
          if (keyField == stateCodeField) {
            tmpList = cashed.where((account) {
              if (account[keyField]
                      .toLowerCase()
                      .compareTo(entryField.key.toLowerCase()) ==
                  0) {
                return true;
              }
              return false;
            }).toList();
            filtered.addAll(tmpList);
          } else {
            // if keyfield stateCode don't checked=true filtred var will be empty
            if (filtered.isEmpty) {
              tmpList = cashed.where((account) {
                if (account[keyField]
                        .toLowerCase()
                        .compareTo(entryField.key.toLowerCase()) ==
                    0) {
                  return true;
                }
                return false;
              }).toList();
            } else {
              isFilteredFiltred = true;
              // if filtred has items we are filtering all inside filtered
              tmpList = filtered.where((account) {
                if (account[keyField]
                        .toLowerCase()
                        .compareTo(entryField.key.toLowerCase()) ==
                    0) {
                  return true;
                }
                return false;
              }).toList();
            }
            tmpList2.addAll(tmpList);
          }
        }
      }
    }

    if (isFilteredFiltred) {
      return tmpList2;
    }
    
    filtered.addAll(tmpList2);
    return filtered.toList();
  }
}
