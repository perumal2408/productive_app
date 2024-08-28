import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsScreen extends StatelessWidget {
  Future<void> _clearLocalStorage(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();

    // Show a confirmation message after clearing local storage
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Local storage cleared')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Settings')),
      body: ListView(
        children: [
          ListTile(
            leading: Icon(Icons.account_circle),
            title: Text('Account'),
            onTap: () {
              // Navigate to Account settings
            },
          ),
          ListTile(
            leading: Icon(Icons.notifications),
            title: Text('Notifications'),
            onTap: () {
              // Navigate to Notification settings
            },
          ),
          ListTile(
            leading: Icon(Icons.privacy_tip),
            title: Text('Privacy'),
            onTap: () {
              // Navigate to Privacy settings
            },
          ),
          ListTile(
            leading: Icon(Icons.help_outline),
            title: Text('Help & Feedback'),
            onTap: () {
              // Navigate to Help & Feedback
            },
          ),
          ListTile(
            leading: Icon(Icons.info_outline),
            title: Text('About'),
            onTap: () {
              // Navigate to About section
            },
          ),
          // Add the Clear Local Storage button
          ListTile(
            leading: Icon(Icons.delete_forever),
            title: Text('Clear Local Storage'),
            onTap: () async {
              bool? confirm = await showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text('Confirm'),
                    content: Text('Are you sure you want to clear all local storage data?'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(false),
                        child: Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(true),
                        child: Text('Clear'),
                      ),
                    ],
                  );
                },
              );

              if (confirm ?? false) {
                await _clearLocalStorage(context);
              }
            },
          ),
        ],
      ),
    );
  }
}
