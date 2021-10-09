import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_app_microsoft_data/Service/Bloc/bloc.dart';
import 'package:test_app_microsoft_data/Service/Model/account.dart';
import 'package:test_app_microsoft_data/Service/Screen/screen_routes.dart';
import 'package:test_app_microsoft_data/Service/constants/constans.dart';

class AccountsMainScreen extends StatefulWidget {
  const AccountsMainScreen({Key? key}) : super(key: key);

  @override
  State<AccountsMainScreen> createState() => _AccountsMainScreenState();
}

class _AccountsMainScreenState extends State<AccountsMainScreen> {
  late final AccountsBloc _accountsBloc;
  bool isInited = false;
  final Map<String, bool> stateCodesStates = {};
  final Map<String, bool> provinceCodesStates = {};
  String _searchQuerry = "";
  bool isGrid = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    blocInitialize();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Row(
      children: [
        Expanded(child: Container()),
        Expanded(flex: 2, child: _buildContent()),
        Expanded(child: Container())
      ],
    ));
  }

  Widget _buildContent() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          children: [
            Expanded(child: _buildTop()),
          ],
        ),
        Expanded(
          child: Center(
            child: BlocBuilder<AccountsBloc, AccountsState>(
              builder: (_, state) {
                if (state is AccountsOperationFailure) {
                  return const Text('Could not do Service  operation');
                }
                if (state is AccountsLoadSuccess) {
                  codesInitialize();

                  return isGrid
                      ? _buildAccsGrid(state.accounts)
                      : _buildAccsList(state.accounts);
                }
                if (state is AccountsFiltredSuccess) {
                  return isGrid
                      ? _buildAccsGrid(state.filteredAccounts)
                      : _buildAccsList(state.filteredAccounts);
                }

                return const CircularProgressIndicator();
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTop() {
    return Row(
      children: [
        Expanded(
          flex: 4,
          child: TextField(
            onChanged: _onSearchQuerryChanged,
            decoration: const InputDecoration(
                labelText: 'Search', suffixIcon: Icon(Icons.search)),
          ),
        ),
        Expanded(
            flex: 1,
            child: Row(
              children: [
                Expanded(
                  child: IconButton(
                    icon: Wrap(
                      alignment: WrapAlignment.center,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: const [Icon(Icons.filter_list), Text('Filter')],
                    ),
                    onPressed: () => showFilterDialog(),
                  ),
                ),
              ],
            )),
        Expanded(
            flex: 1,
            child: Row(
              children: [
                Expanded(
                  child: IconButton(
                      icon: const Icon(Icons.list),
                      onPressed: () => setState(() {
                            isGrid = false;
                          })),
                ),
                Expanded(
                  child: IconButton(
                      icon: const Icon(Icons.grid_4x4),
                      onPressed: () => setState(() {
                            isGrid = true;
                          })),
                ),
              ],
            )),
      ],
    );
  }

  Widget _buildAccsList(List<Account> accounts) {
    return ListView.builder(
        itemCount: accounts.length,
        itemBuilder: (_, index) => InkWell(
              onTap: () => _navigateToDetails(accounts[index]),
              child: Card(
                child: Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: AspectRatio(
                        aspectRatio: 16 / 9,
                        child: Container(
                          height: 150,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                    Expanded(
                        flex: 5,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(accounts[index].name),
                              SizedBox(
                                height: 80,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    Text(
                                      'number: ${accounts[index].accounPhonetnumber.toString()}',
                                    ),
                                    Text('state: ${accounts[index].stateCode}'),
                                    Text(
                                        'province: ${accounts[index].stateOrProvince}')
                                  ],
                                ),
                              )
                            ],
                          ),
                        ))
                  ],
                ),
              ),
            ));
  }

  Widget _buildAccsGrid(List<Account> accountsList) {
    return GridView.builder(
        gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 200),
        itemCount: accountsList.length,
        itemBuilder: (contex, index) {
          return InkWell(
            onTap: () => _navigateToDetails(accountsList[index]),
            child: Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    color: Colors.blueGrey,
                    borderRadius: BorderRadius.circular(15)),
                child: Column(
                  children: [
                    Text('name: ${accountsList[index].name}'),
                    Text(
                        'number: ${accountsList[index].accounPhonetnumber.toString()}'),
                    Text('state: ${accountsList[index].stateCode}'),
                    Text('province: ${accountsList[index].stateOrProvince}')
                  ],
                )),
          );
        });
  }

  void showFilterDialog() {
    showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(
            builder: (context, setState) => Center(
              child: SizedBox(
                height: 500,
                width: 500,
                child: Scaffold(body: _buildDialogBody(context, setState)),
              ),
            ),
          );
        });
  }

  Widget _buildDialogBody(BuildContext context, StateSetter setState) {
    return ListView(children: [
      Row(
        children: [
          Expanded(child: _buildLeftSection(context, setState)),
          Expanded(child: _buildRightSection(context, setState))
        ],
      )
    ]);
  }

  Widget _buildLeftSection(BuildContext context, StateSetter setState) {
    return Column(
      children: [
        ...stateCodesStates.keys.map((e) => SizedBox(
              width: double.infinity,
              child: Row(
                children: [
                  Text(e),
                  Checkbox(
                      key: Key(e),
                      value: stateCodesStates[e],
                      onChanged: (val) =>
                          _onStateCodeCheckBoxChanged(val, e, setState))
                ],
              ),
            )),
      ],
    );
  }

  Widget _buildRightSection(BuildContext context, StateSetter setState) {
    return Column(
      children: [
        ...provinceCodesStates.keys.map((e) => SizedBox(
              width: double.infinity,
              child: Row(
                children: [
                  Text(e),
                  Checkbox(
                      key: Key(e),
                      value: provinceCodesStates[e],
                      onChanged: (val) =>
                          _onProvinceCheckBoxChanged(val, e, setState))
                ],
              ),
            ))
      ],
    );
  }

  void blocInitialize() {
    if (!isInited) {
      _accountsBloc = BlocProvider.of<AccountsBloc>(context);
      isInited = true;
    }
  }

  void codesInitialize() {
    stateCodesStates.clear();
    provinceCodesStates.clear();

    for (var key in _accountsBloc.accountsRepository.filterParams.keys) {
      var hashSetStateCodes =
          _accountsBloc.accountsRepository.filterParams[key] ?? HashSet();
      for (var code in hashSetStateCodes) {
        if (key.compareTo(stateCodeField) == 0) {
          stateCodesStates[code] = false;
        }
        if (key.compareTo(provinceCodeField) == 0) {
          provinceCodesStates[code] = false;
        }
      }
    }
  }

  void _onSearchQuerryChanged(String value) {
    setState(() {
      _searchQuerry = value;
    });
    _runFilterByNameNumber();
  }

  _runFilterByNameNumber() {
    if (stateCodesStates.values.where((element) => element).isEmpty &&
        provinceCodesStates.values.where((element) => element).isEmpty) {
      _accountsBloc.add(AccountsFilter(_searchQuerry));
    } else {
      _accountsBloc.add(AccountsFilter(_searchQuerry, filterParams: {
        stateCodeField: stateCodesStates,
        provinceCodeField: provinceCodesStates
      }));
    }
  }

  _onProvinceCheckBoxChanged(bool? val, String e, StateSetter setState) {
    setState(() {
      provinceCodesStates[e] = val ?? false;
    });
    _runFilterByNameNumber();
  }

  _onStateCodeCheckBoxChanged(bool? val, String e, StateSetter setState) {
    setState(() {
      stateCodesStates[e] = val ?? false;
    });
    _runFilterByNameNumber();
  }

  _navigateToDetails(Account account) {
    Navigator.of(context)
        .pushNamed(ServiceScreensRoutes.detailsRoute, arguments: account);
  }
}
