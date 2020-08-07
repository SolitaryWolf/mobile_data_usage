import 'package:connectivity/connectivity.dart';

mixin NetworkUtil {
  Future<bool> isNetworkConnectionOk() async {
    bool isNetworkOk = true;
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile) {
      // I am connected to a mobile network.
    } else if (connectivityResult == ConnectivityResult.wifi) {
      // I am connected to a wifi network.
    } else {
      isNetworkOk = false;
    }

    return isNetworkOk;
  }
}

