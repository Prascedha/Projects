// lib/screens/viewer_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart'; // For launching URLs

import 'package:flutter_application_1/models/certificate.dart';
import 'package:flutter_application_1/providers/app_state_provider.dart';
import 'package:flutter_application_1/screens/certificate_details_screen.dart'; // <--- Make sure this is imported

class ViewerScreen extends StatelessWidget {
  const ViewerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Certificates'), // Title from your desired design
        centerTitle: false, // Align left as in your design
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none), // Notification icon
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Notifications tapped')),
              );
            },
          ),
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: CircleAvatar(
              // User profile icon
              backgroundColor: Colors.grey[300],
              child: const Icon(Icons.person, color: Colors.grey),
            ),
          ),
        ],
        bottom: PreferredSize(
          // Search bar below AppBar
          preferredSize: const Size.fromHeight(60.0),
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search certificates...', // Hint text
                prefixIcon: const Icon(Icons.search), // Search icon
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.grey[200],
              ),
              onChanged: (query) {
                // TODO: Implement search functionality here
                print('Search query: $query');
              },
            ),
          ),
        ),
      ),
      body: Consumer<AppStateProvider>(
        builder: (context, appState, child) {
          final certificates = appState.certificates;

          if (certificates.isEmpty) {
            return const Center(
              child: Text('No certificates uploaded yet.'),
            );
          } else {
            return ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: certificates.length,
              itemBuilder: (context, index) {
                final certificate = certificates[index];
                return _CertificateListCard(certificate: certificate);
              },
            );
          }
        },
      ),
    );
  }
}

class _CertificateListCard extends StatelessWidget {
  final Certificate certificate;

  const _CertificateListCard({required this.certificate});

  @override
  Widget build(BuildContext context) {
    print(
        'DEBUG ViewerScreen: Building card for Certificate ID: ${certificate.id}');
    print('DEBUG ViewerScreen: Title: "${certificate.title}"');
    print('DEBUG ViewerScreen: Description: "${certificate.description}"');
    print('DEBUG ViewerScreen: Issuer: "${certificate.issuer}"');
    print('DEBUG ViewerScreen: Issue Date: "${certificate.issueDate}"');
    print('DEBUG ViewerScreen: Image URL: "${certificate.imageUrl}"');
    print('DEBUG ViewerScreen: Is Public: "${certificate.isPublic}"');

    return Card(
      margin: const EdgeInsets.only(bottom: 16.0),
      elevation: 2.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: InkWell(
        onTap: () {
          // <--- THIS IS THE CHANGE TO NAVIGATE TO DETAIL SCREEN
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  CertificateDetailScreen(certificate: certificate),
            ),
          );
        },
        borderRadius: BorderRadius.circular(12.0),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.description,
                          size: 18, color: Colors.grey),
                      const SizedBox(width: 8),
                      Text(
                        certificate.id,
                        style: const TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: certificate.isPublic
                          ? Colors.blue.shade100
                          : Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Text(
                      certificate.isPublic ? 'Public' : 'Private',
                      style: TextStyle(
                        fontSize: 12,
                        color: certificate.isPublic
                            ? Colors.blue.shade800
                            : Colors.grey.shade700,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8.0),
              Text(
                'Document Link:',
                style: TextStyle(fontSize: 12, color: Colors.grey[600]),
              ),
              GestureDetector(
                onTap: () async {
                  if (certificate.imageUrl.isNotEmpty &&
                      Uri.tryParse(certificate.imageUrl)?.hasAbsolutePath ==
                          true) {
                    final uri = Uri.parse(certificate.imageUrl);
                    if (await canLaunchUrl(uri)) {
                      await launchUrl(uri);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                            content: Text(
                                'Could not launch ${certificate.imageUrl}')),
                      );
                    }
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text('No valid document link provided.')),
                    );
                  }
                },
                child: Text(
                  certificate.imageUrl.isNotEmpty
                      ? certificate.imageUrl
                      : 'No link available',
                  style: TextStyle(
                    fontSize: 14.0,
                    color: certificate.imageUrl.isNotEmpty
                        ? Colors.blue
                        : Colors.grey,
                    decoration: certificate.imageUrl.isNotEmpty
                        ? TextDecoration.underline
                        : TextDecoration.none,
                  ),
                ),
              ),
              const SizedBox(height: 8.0),
              Text(
                'Description:',
                style: TextStyle(fontSize: 12, color: Colors.grey[600]),
              ),
              Text(
                certificate.description,
                style: const TextStyle(fontSize: 14.0),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 8.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Issued: ${DateFormat('yyyy-MM-dd').format(certificate.issueDate)}',
                    style: TextStyle(
                      fontSize: 12.0,
                      color: Colors.grey[600],
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      // <--- THIS IS THE CHANGE TO NAVIGATE TO DETAIL SCREEN
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              CertificateDetailScreen(certificate: certificate),
                        ),
                      );
                    },
                    child: Row(
                      children: const [
                        Text('View Details', style: TextStyle(fontSize: 12)),
                        Icon(Icons.arrow_right_alt, size: 16),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
