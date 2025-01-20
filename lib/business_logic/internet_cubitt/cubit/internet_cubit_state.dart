part of 'internet_cubit_cubit.dart';

abstract class InternetState {}

class InternetLoading extends InternetState {}

class InternetIsConnected extends InternetState {
  final bool isConnected;
  InternetIsConnected(this.isConnected);
}

