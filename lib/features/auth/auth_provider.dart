import 'package:flutter/cupertino.dart';

class AuthProvider extends ChangeNotifier {

  bool isLoading = false;

  bool get getIsLoading => isLoading;



  showLoading() {
    isLoading = true;
    notifyListeners();
  }

  hideLoading() {
    isLoading = false;
    notifyListeners();
  }


}