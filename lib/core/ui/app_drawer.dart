import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:social_downloader/core/helpers/helper_functions.dart';
import 'package:social_downloader/core/images/images.dart';
import 'package:social_downloader/core/ui/dialogs.dart';
import 'package:social_downloader/core/ui/rounded_button.dart';
import 'package:social_downloader/features/auth/login_screen.dart';
import 'package:social_downloader/features/auth/services/auth_service.dart';
import 'package:social_downloader/features/download_videos/download_instagram_screen.dart';
import 'package:social_downloader/features/download_videos/download_tik_tok_screen.dart';
import 'package:social_downloader/features/download_videos/download_twitter_screen.dart';

class AppDrawer extends StatelessWidget {
  AppDrawer({super.key});

  final _authService = AuthService();

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
                  child: const Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CircleAvatar(
                        radius: 40,
                        backgroundColor: Colors.white,
                        child: const Text(
                          'SaveInsta',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        'Username',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'test@gmail.com',
                        style: TextStyle(
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
                onPressed: () {
                  Navigator.pop(context);
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
}
