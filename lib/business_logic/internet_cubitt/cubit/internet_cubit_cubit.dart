import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

part 'internet_cubit_state.dart';

class InternetCubit extends Cubit<InternetState> {
  final Connectivity connectivity;
  StreamSubscription<List<ConnectivityResult>>? subscription;
  InternetCubit({
    required this.connectivity,
  }) : super(InternetLoading()) {
    subscription = Connectivity()
        .onConnectivityChanged
        .listen((List<ConnectivityResult> result) {
      final isInternet = result.contains(ConnectivityResult.wifi) ||
          result.contains(ConnectivityResult.mobile);
      emitInternetConnection(isInternet);
    });
  }

  void emitInternetConnection(bool isConnected) =>
      emit(InternetIsConnected(isConnected));

  @override
  Future<void> close() {
    subscription?.cancel();
    return super.close();
  }
}
