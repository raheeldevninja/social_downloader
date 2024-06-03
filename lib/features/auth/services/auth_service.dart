import 'package:firebase_auth/firebase_auth.dart';
import 'package:social_downloader/core/helpers/helper_functions.dart';
import 'package:social_downloader/features/auth/services/database_service.dart';

class AuthService {

  final FirebaseAuth _auth = FirebaseAuth.instance;

  //login
  Future signInUserWithEmailAndPassword(String email, String password) async {

    try {

      User? user = (await _auth.signInWithEmailAndPassword(email: email, password: password)).user;

      if(user != null) {
        return true;
      }

    }
    on FirebaseAuthException catch(e) {

      return e.message;
    }

  }

  //register
  Future registerUserWithEmailAndPassword(String fullName, String email, String password) async {

    try {

      User? user = (await _auth.createUserWithEmailAndPassword(email: email, password: password)).user;

      if(user != null) {
        await DatabaseService(uid: user.uid).saveUserData(fullName, email);
        return true;
      }

    }
    on FirebaseAuthException catch(e) {

      return e.message;
    }

  }

  //sign out
  Future signOut() async {

    try {

      await HelperFunctions.saveUserLoggedInStatus(false);
      await HelperFunctions.saveUsername("");
      await HelperFunctions.saveUserEmail("");

      await _auth.signOut();
    }
    catch(e) {

      return null;
    }

  }

}