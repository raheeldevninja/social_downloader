import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_downloader/features/view_model/download_save_provider.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({
    required this.title,
    this.shouldShowBack = true,
    super.key});

  final String title;
  final bool shouldShowBack;

  @override
  Widget build(BuildContext context) {

    final downloadSaveProvider = Provider.of<DownloadSaveProvider>(context);

    return AppBar(
      backgroundColor: Colors.black,
      iconTheme: const IconThemeData(
        color: Colors.white,
      ),
      leadingWidth: shouldShowBack ? 40 : 0,
      leading: shouldShowBack ? IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () {

          if(downloadSaveProvider.isLoading || downloadSaveProvider.isDownloading) {
            return;
          }
          Navigator.pop(context);

        },
      ) : const SizedBox(),
      title: Text(
        title,
        style: const TextStyle(
          color: Colors.white,
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(56);

}
