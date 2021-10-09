import 'package:equatable/equatable.dart';
import 'package:test_app_microsoft_data/Service/Model/account.dart';

abstract class AccountsEvent extends Equatable {
  const AccountsEvent();
}

class AccountsLoad extends AccountsEvent {
  const AccountsLoad();

  @override
  List<Account> get props => [];
}

class AccountsFilter extends AccountsEvent {
  final String searchQuerry;
  final Map<String, Map<String, bool>> filterParams;

  const AccountsFilter(this.searchQuerry, {this.filterParams = const {}});

  @override
  List<Object?> get props => [searchQuerry, filterParams];
}

class AccountsFilterLoad extends AccountsEvent {
  const AccountsFilterLoad();

  @override
  List<Object?> get props => [];
}
