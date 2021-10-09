import 'package:equatable/equatable.dart';
import 'package:test_app_microsoft_data/Service/Model/account.dart';

class AccountsState extends Equatable {
  const AccountsState();

  @override
  List<Account> get props => [];
}

class AccountsLoading extends AccountsState {}

class AccountsLoadSuccess extends AccountsState {
  final List<Account> accounts;

  const AccountsLoadSuccess([this.accounts = const []]);

  @override
  List<Account> get props => accounts;
}

class AccountsOperationFailure extends AccountsState {}

class AccountsFiltredSuccess extends AccountsState {
  final List<Account> filteredAccounts;

  const AccountsFiltredSuccess([this.filteredAccounts = const []]);

  @override
  List<Account> get props => filteredAccounts;
}
