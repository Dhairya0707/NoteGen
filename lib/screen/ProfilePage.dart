// ignore_for_file: avoid_print, use_build_context_synchronously

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:notegen/provider/theme_provider.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          _buildAppBar(context),
          SliverToBoxAdapter(
            child: _buildContent(context),
          ),
        ],
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return SliverAppBar.large(
      expandedHeight: 200,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        title: Text(
          'Settings & About',
          style: TextStyle(
            color: Theme.of(context).textTheme.titleLarge?.color,
            fontWeight: FontWeight.bold,
          ),
        ),
        background: Center(
          child: Icon(
            Icons.settings,
            size: 100,
            color: Theme.of(context).colorScheme.primary.withOpacity(0.2),
          ),
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildThemeSection(context),
          const Gap(24),
          _buildAppSection(context),
          const Gap(24),
          _buildDeveloperSection(context),
          const Gap(24),
          _buildSupportSection(context),
        ],
      ),
    );
  }

  Widget _buildThemeSection(BuildContext context) {
    return _buildSection(
      context: context,
      title: 'Appearance',
      icon: Icons.palette_outlined,
      children: [
        ListTile(
          title: const Text('Dark Mode'),
          leading: const Icon(Icons.dark_mode_outlined),
          trailing: Consumer<ThemeProvider>(
            builder: (context, themeProvider, child) {
              return Switch(
                value: themeProvider.themeMode == ThemeMode.dark,
                onChanged: (value) {
                  themeProvider.toggleTheme(value); // Toggle theme
                },
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildAppSection(BuildContext context) {
    return _buildSection(
      context: context,
      title: 'App Info',
      icon: Icons.info_outline,
      children: [
        const ListTile(
          leading: Icon(Icons.numbers),
          title: Text('Version'),
          subtitle: Text('1.0.0'),
        ),
        ListTile(
          leading: const Icon(Icons.description_outlined),
          title: const Text('Terms of Service'),
          trailing: const Icon(Icons.arrow_forward_ios, size: 16),
          onTap: () async {
            await _launchUrl(
                'https://docs.google.com/document/d/e/2PACX-1vSRAUj3S7FpJfv2WLp5Q3aw47_-azyMDHnQCKmr0LIRJtQPCfXCYmyGzfKQThqj5whVkUNc3AWJM9xS/pub');
          },
        ),
        ListTile(
          leading: const Icon(Icons.privacy_tip_outlined),
          title: const Text('Privacy Policy'),
          trailing: const Icon(Icons.arrow_forward_ios, size: 16),
          onTap: () async {
            await _launchUrl(
                "https://docs.google.com/document/d/e/2PACX-1vTr8oQ_Z9Nl7LIMLsGkUb9RXPUp1C2s9X_oiSNgwfy0diuPa4hDaU3UN1jXOsA9ScZut2VHLsMRFoYX/pub");
          },
        ),
      ],
    );
  }

  Widget _buildDeveloperSection(BuildContext context) {
    return _buildSection(
      context: context,
      title: 'Developer',
      icon: Icons.code,
      children: [
        ListTile(
          leading: const Icon(Icons.person_outline),
          title: const Text('About Developer'),
          trailing: const Icon(Icons.arrow_forward_ios, size: 16),
          onTap: () {
            _showDeveloperInfo(context);
          },
        ),
        ListTile(
          leading: const Icon(Icons.link),
          title: const Text('Portfolio'),
          trailing: const Icon(Icons.arrow_forward_ios, size: 16),
          onTap: () async {
            await _launchUrl('https://dhairyadarji.web.app/');
          },
        ),
        ListTile(
          leading: const Icon(Icons.business),
          title: const Text('LinkedIn Profile'),
          trailing: const Icon(Icons.arrow_forward_ios, size: 16),
          onTap: () async {
            await _launchUrl(
                'https://www.linkedin.com/in/dhairya-darji-072428284');
          },
        ),
      ],
    );
  }

  // Widget _buildSupportSection(BuildContext context) {
  //   return _buildSection(
  //     context: context,
  //     title: 'Support',
  //     icon: Icons.help_outline,
  //     children: [
  //       ListTile(
  //         leading: const Icon(Icons.bug_report_outlined),
  //         title: const Text('Report an Issue'),
  //         trailing: const Icon(Icons.arrow_forward_ios, size: 16),
  //         onTap: () async {
  //           // No repo yet.
  //           ScaffoldMessenger.of(context).showSnackBar(
  //             const SnackBar(content: Text('GitHub repo not available yet!')),
  //           );
  //         },
  //       ),
  //       ListTile(
  //         leading: const Icon(Icons.lightbulb_outline),
  //         title: const Text('Request a Feature'),
  //         trailing: const Icon(Icons.arrow_forward_ios, size: 16),
  //         onTap: () {
  //           _showFeatureRequestDialog(context);
  //         },
  //       ),
  //       ListTile(
  //         leading: const Icon(Icons.mail_outline),
  //         title: const Text('Contact Support'),
  //         trailing: const Icon(Icons.arrow_forward_ios, size: 16),
  //         onTap: () async {
  //           final Uri emailLaunchUri = Uri(
  //             scheme: 'mailto',
  //             path: 'dhairyadarji025@gmail.com',
  //             queryParameters: {
  //               'subject': 'Support for NoteGen App',
  //             },
  //           );
  //           await _launchUrl(emailLaunchUri.toString());
  //         },
  //       ),
  //     ],
  //   );
  // }

  Widget _buildSupportSection(BuildContext context) {
    return _buildSection(
      context: context,
      title: 'Support',
      icon: Icons.help_outline,
      children: [
        ListTile(
          leading: const Icon(Icons.bug_report_outlined),
          title: const Text('Report an Issue'),
          trailing: const Icon(Icons.arrow_forward_ios, size: 16),
          onTap: () {
            _showReportIssueDialog(context); // Show dialog for reporting issues
          },
        ),
        ListTile(
          leading: const Icon(Icons.lightbulb_outline),
          title: const Text('Request a Feature'),
          trailing: const Icon(Icons.arrow_forward_ios, size: 16),
          onTap: () {
            _showFeatureRequestDialog(context);
          },
        ),
        ListTile(
          leading: const Icon(Icons.mail_outline),
          title: const Text('Contact Support'),
          trailing: const Icon(Icons.arrow_forward_ios, size: 16),
          onTap: () async {
            final Uri emailLaunchUri = Uri(
              scheme: 'mailto',
              path: 'dhairyadarji025@gmail.com',
              queryParameters: {
                'subject': 'Support for NoteGen App',
              },
            );
            await _launchUrl(emailLaunchUri.toString());
          },
        ),
      ],
    );
  }

  void _showReportIssueDialog(BuildContext context) {
    final TextEditingController controller = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Report an Issue'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Please describe the issue you encountered. We appreciate your feedback!',
            ),
            const Gap(16),
            TextField(
              controller: controller,
              maxLines: 3,
              decoration: const InputDecoration(
                hintText: 'Enter your issue...',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () async {
              final issueDescription = controller.text;

              if (issueDescription.isNotEmpty) {
                final userIp = await _getUserIp(); // Get user's IP address
                const userAgent = 'FlutterApp/1.0 (Dhairya NoteGen)';
                const String url =
                    "https://script.google.com/macros/s/AKfycbxkPqSLFxilk2EXKD15Hpe4CIBEeqJ5ggysPJMiBL10993C_nkd4tEgX7eVudnwkzQS/exec";
                try {
                  final response = await http.post(Uri.parse(url),
                      headers: {
                        "Content-Type": "application/json",
                      },
                      body: jsonEncode({
                        "issueDescription": issueDescription,
                        "userIp": userIp,
                        "userAgent": userAgent
                      }));
                  print(userIp);
                  print(response.statusCode);
                  print(response.request);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('Issue reported successfully!')),
                  );
                } catch (e) {
                  print(e.toString());
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error: ${e.toString()}')),
                  );
                }
                Navigator.pop(context);
              }
            },
            child: const Text('Submit'),
          ),
        ],
      ),
    );
  }

  Widget _buildSection({
    required BuildContext context,
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, color: Theme.of(context).colorScheme.primary),
            const Gap(8),
            Text(
              title,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ],
        ),
        const Gap(16),
        Card(
          elevation: 0,
          color: Theme.of(context).colorScheme.primary.withOpacity(0.05),
          child: Column(
            children: children,
          ),
        ),
      ],
    );
  }

  Future<void> _launchUrl(String url) async {
    if (!await launchUrl(Uri.parse(url))) {
      throw Exception('Could not launch $url');
    }
  }

  void _showDeveloperInfo(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('About Developer'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const CircleAvatar(
              radius: 50,
              backgroundImage: AssetImage('assets/avtar.jpg'),
            ),
            const Gap(16),
            Text(
              'Dhairya Darji',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const Gap(8),
            const Text(
              'Flutter developer passionate about creating real-life solutions and AI-powered applications. Skilled in cross-platform app development, React, and Firebase.',
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showFeatureRequestDialog(BuildContext context) {
    final TextEditingController controller = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Request a Feature'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Describe the feature you\'d like to see in the app. We appreciate your feedback!',
            ),
            const Gap(16),
            TextField(
              controller: controller,
              maxLines: 3,
              decoration: const InputDecoration(
                hintText: 'Enter your feature request...',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () async {
              final featureRequest = controller.text;
              final userIp = await _getUserIp(); // Get user's IP address
              const userAgent = 'FlutterApp/1.0 (Dhairya NoteGen)';
              const String url =
                  "https://script.google.com/macros/s/AKfycbxkPqSLFxilk2EXKD15Hpe4CIBEeqJ5ggysPJMiBL10993C_nkd4tEgX7eVudnwkzQS/exec";
              if (featureRequest.isNotEmpty) {
                try {
                  final response = await http.post(Uri.parse(url),
                      headers: {
                        "Content-Type": "application/json",
                      },
                      body: jsonEncode({
                        "featureRequest": featureRequest,
                        "userIp": userIp,
                        "userAgent": userAgent
                      }));
                  print(userIp);
                  print(response.statusCode);
                  print(response.request);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content:
                            Text('Feature request submitted successfully!')),
                  );
                } catch (e) {
                  print(e.toString());
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error: ${e.toString()}')),
                  );
                }
                Navigator.pop(context);
              } else {}
            },
            child: const Text('Submit'),
          ),
        ],
      ),
    );
  }
}

Future<String> _getUserIp() async {
  try {
    final response =
        await http.get(Uri.parse('https://api.ipify.org?format=json'));
    if (response.statusCode == 200) {
      return jsonDecode(response.body)['ip'];
    } else {
      return 'Unknown IP'; // Fallback if API fails
    }
  } catch (e) {
    return 'Error fetching IP';
  }
}

Future<void> _submitFeatureRequest(
    BuildContext context, String featureRequest) async {
  const url =
      'https://script.google.com/macros/s/AKfycbwU8HkD06CaJ13K7O7zRESB2xLuReh6jhR_KOSKMIWxCFNmKVnckDSO_VwQdU3QQcaekA/exec'; // Replace with your Web App URL

  try {
    // final userIp = await _getUserIp(); // Get user's IP address
    // const userAgent = 'FlutterApp/1.0 (Dhairya NoteGen)';

    final response = await http.post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'featureRequest': "featureRequest",
        'userIp': "userIp",
        'userAgent': "userAgent",
      }),
    );

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Feature request submitted successfully!')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to submit feature request.')),
      );
    }
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Error: ${e.toString()}')),
    );
  }
}
