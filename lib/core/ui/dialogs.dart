import 'package:flutter/material.dart';

sealed class Dialogs {
  const Dialogs._();


  static Future<bool> showLogoutDialog(BuildContext context) {
    return _showConfirmDialog(
      context,
      title: 'Logout',
      message: 'Are you sure you want to logout?',
      confirmText: 'Logout',
    );
  }

  static Future<bool> showDeleteAccountDialog(BuildContext context) {
    return _showConfirmDialog(
      context,
      title: 'Delete Account',
      message: 'Are you sure you want to delete your account?',
      confirmText: 'Delete',
    );
  }

  static Future<bool> _showConfirmDialog(
      BuildContext context, {
        required String title,
        required String message,
        required String confirmText,
        bool isDelete = false,
      }) async {
    return await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            style: TextButton.styleFrom(
              foregroundColor: Colors.black,
            ),
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            style: TextButton.styleFrom(
              foregroundColor:
              isDelete ? Colors.red : Colors.black,
            ),
            onPressed: () => Navigator.pop(context, true),
            child: Text(
              confirmText,
            ),
          ),
        ],
      ),
    );
  }

}