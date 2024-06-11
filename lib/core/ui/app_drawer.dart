import 'dart:developer';
import 'dart:io';

import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:social_downloader/core/helpers/helper_functions.dart';
import 'package:social_downloader/core/images/images.dart';
import 'package:social_downloader/core/ui/dialogs.dart';
import 'package:social_downloader/core/ui/rounded_button.dart';
import 'package:social_downloader/core/utils/utils.dart';
import 'package:social_downloader/features/auth/auth_provider.dart';
import 'package:social_downloader/features/auth/login_screen.dart';
import 'package:social_downloader/features/auth/services/auth_service.dart';
import 'package:social_downloader/features/download_videos/download_instagram_screen.dart';
import 'package:social_downloader/features/download_videos/download_tik_tok_screen.dart';
import 'package:social_downloader/features/download_videos/download_twitter_screen.dart';

class AppDrawer extends StatelessWidget {
  AppDrawer({
    required this.username,
    required this.email,
    required this.parentContext,
    super.key});

  final _authService = AuthService();

  final BuildContext parentContext;
  final String username;
  final String email;

  final auth.FirebaseAuth _auth = auth.FirebaseAuth.instance;
  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {

    return SafeArea(
      child: Drawer(
        backgroundColor: Colors.white,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(30),
            bottomRight: Radius.circular(30),
          ),
        ),
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 40,
                    vertical: 40,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.7),
                  ),
                  alignment: Alignment.center,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CircleAvatar(
                        radius: 40,
                        backgroundColor: Colors.white,
                        child: Image.asset(
                          Images.logoWithoutAppName,
                        ),
                      ),

                      const SizedBox(height: 10),
                      Text(
                        username,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        email,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  right: 0,
                  top: 0,
                  child: IconButton(
                    icon: const Icon(Icons.close, color: Colors.white),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
              ],
            ),

            const SizedBox(height: 40),

            _buildNavDrawerItem(
              context,
              text: 'Download Tiktok Videos',
              icon: Images.tiktokImage,
              width: 50,
              height: 50,
              onTap: () {
                Navigator.pop(context);

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const DownloadTikTokScreen(),
                  ),
                );
              },
            ),

            _buildNavDrawerItem(
              context,
              text: 'Download Instagram Videos',
              icon: Images.instagramImage,
              width: 50,
              height: 50,
              padding: 6,
              onTap: () {
                Navigator.pop(context);

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const DownloadInstagramScreen(),
                  ),
                );
              },
            ),

            _buildNavDrawerItem(
              context,
              text: 'Download Twitter Videos',
              icon: Images.twitterImage,
              width: 50,
              height: 50,
              padding: 6,
              onTap: () {
                Navigator.pop(context);

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const DownloadTwitterScreen(),
                  ),
                );
              },
            ),

            const SizedBox(height: 40),

            const SizedBox(
              height: 40,
            ),

            //logout button
            Container(
              height: 56,
              margin: const EdgeInsets.symmetric(horizontal: 20),
              child: RoundedButton(
                backgroundColor: Colors.black,
                icon: Icons.logout,
                onPressed: () async {
                  bool result = await Dialogs.showLogoutDialog(context);

                  if (!result) {
                    return;
                  }

                  await HelperFunctions.saveUserLoggedInStatus(false);
                  await HelperFunctions.saveUsername("");
                  await HelperFunctions.saveUserEmail("");

                  _authService.signOut().whenComplete(() {
                    Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(
                        builder: (context) => const LoginScreen(),
                      ),
                      (route) => false,
                    );
                  });


                },
                text: 'Logout',
              ),
            ),
            const SizedBox(
              height: 16,
            ),

            //delete account button
            Container(
              height: 56,
              margin: const EdgeInsets.symmetric(horizontal: 20),
              child: RoundedButton(
                backgroundColor: Colors.red,
                icon: Icons.delete_outline,
                onPressed: () async {

                  Navigator.pop(context);
                  bool result = await Dialogs.showDeleteAccountDialog(context);

                  if (!result) {
                    return;
                  }

                  await _reAuthenticateAndDeleteUserAccount(parentContext);


                },
                text: 'Delete Account',
              ),
            ),

            const SizedBox(
              height: 20,
            ),

            const SizedBox(
              height: 24,
            ),
          ],
        ),
      ),
    );
  }

  ListTile _buildNavDrawerItem(
    BuildContext context, {
    required String text,
    required String icon,
    required double width,
    required double height,
    required VoidCallback onTap,
    double? padding,
  }) {
    return ListTile(
      leading: Container(
        width: width,
        height: height,
        padding: EdgeInsets.all(padding ?? 0),
        decoration: const BoxDecoration(
          //color: Colors.teal,
          borderRadius: BorderRadius.all(Radius.circular(8)),
        ),
        child: SvgPicture.asset(
          icon,
        ),
      ),
      title: Text(
        text,
        style: const TextStyle(
          fontSize: 14,
        ),
      ),
      onTap: onTap,
    );
  }

  Future<void> _deleteUserData(BuildContext context, String uid) async {
    try {
      // Deleting user data from FireStore
      await _fireStore.collection('users').doc(uid).delete();
    }
    on SocketException {
      Utils.showCustomSnackBar(context, 'Not connected to internet', ContentType.failure);
    }
    catch (e) {
      print("Error deleting user data: $e");
    }
  }

  Future<void> _reAuthenticateUser(BuildContext context, String email, String password) async {
    auth.User? user = auth.FirebaseAuth.instance.currentUser;
    if (user != null) {
      auth.AuthCredential credential = auth.EmailAuthProvider.credential(email: email, password: password);
      try {
        await user.reauthenticateWithCredential(credential);
      }
      on SocketException {
        Utils.showCustomSnackBar(context, 'Not connected to internet', ContentType.failure);
      }
      //on auth.FirebaseAuthException catch (e) {
        //log('Error re-authenticating user: ${e.message}');
        //Utils.showCustomSnackBar(context, e.message ?? 'Error re-authenticating user', ContentType.failure);
        //rethrow;
      //}
      catch (e) {
        throw Exception("Re-authentication failed: $e");
      }
    }
  }

  Future<void> _reAuthenticateAndDeleteUserAccount(BuildContext context) async {

    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    try {
      auth.User? user = _auth.currentUser;

      if (user != null) {

        String email = user.email!;
        String? password = await Dialogs.showPasswordInputDialog(context);

        print('user email: $email, password: $password');

        if(password == null || password.isEmpty) {
          return;
        }

        authProvider.showLoading();
        await _reAuthenticateUser(context, email, password ?? '');


        String uid = user.uid;
        // Delete user data from FireStore
        await _deleteUserData(context, uid);
        // Delete the user authentication record
        await user.delete();

        authProvider.hideLoading();

        await HelperFunctions.saveUserLoggedInStatus(false);
        await HelperFunctions.saveUsername("");
        await HelperFunctions.saveUserEmail("");

        Utils.showCustomSnackBar(
          context,
          'Account deleted successfully!',
          ContentType.success,
        );

        //navigate to login screen
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (context) => const LoginScreen(),
          ),
          (route) => false,
        );

      }
    }
    on auth.FirebaseAuthMultiFactorException catch(e) {
      authProvider.hideLoading();

      if(context.mounted) {
        Utils.showCustomSnackBar(
          context,
          e.code,
          ContentType.failure,
        );
      }
    }
    catch (e) {
      authProvider.hideLoading();


      e is auth.FirebaseAuthException ? log('Error deleting user account: ${e.message}') :
      log("Error deleting user account: $e");

      if(context.mounted) {
        Utils.showCustomSnackBar(
          context,
          'Error deleting account!',
          ContentType.failure,
        );
      }


    }
  }

}
