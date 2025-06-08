// lib/screens/certificate_detail_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/certificate.dart';
import 'package:provider/provider.dart'; // Import provider
import 'package:flutter_application_1/providers/app_state_provider.dart'; // Import AppStateProvider
// import 'package:url_launcher/url_launcher.dart'; // Uncomment if you add url_launcher

class CertificateDetailScreen extends StatelessWidget {
  final Certificate certificate;

  const CertificateDetailScreen({super.key, required this.certificate});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Certificate Details'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Card(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Icon(
                    Icons.description_outlined,
                    size: 60,
                    color: Colors.blue.shade700,
                  ),
                ),
                const SizedBox(height: 10),
                Center(
                  child: Text(
                    'Certificate Overview',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ),
                const Divider(height: 40, thickness: 1),
                _buildDetailRow(
                  context,
                  'Reference Number',
                  certificate.id,
                ),
                _buildDetailRow(
                  context,
                  'Issue Date',
                  certificate.issueDate.toLocal().toString().split(' ')[0],
                ),
                _buildDetailRow(
                  context,
                  'Expiry Date',
                  'N/A (add to model if needed)', // Keep placeholder or add expiryDate to model
                ),
                _buildDetailRow(context, 'Issued By', certificate.issuer),
                const SizedBox(height: 15),
                // Document Link section
                Text(
                  'Document Link',
                  style: Theme.of(
                    context,
                  ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                InkWell(
                  onTap: () {
                    if (certificate.imageUrl.isNotEmpty) {
                      // Implement URL launcher here (requires url_launcher package)
                      // Remember to add url_launcher to your pubspec.yaml
                      // Example:
                      // launchUrl(Uri.parse(certificate.imageUrl), mode: LaunchMode.externalApplication);

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            'Opening document: ${certificate.imageUrl}',
                          ),
                        ),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('No document link available.'),
                        ),
                      );
                    }
                  },
                  child: Row(
                    children: [
                      const Icon(Icons.link, size: 20, color: Colors.blue),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          certificate.imageUrl.isNotEmpty
                              ? 'View Document'
                              : 'No Document Available',
                          style: TextStyle(
                            color: certificate.imageUrl.isNotEmpty
                                ? Colors.blue
                                : Colors.grey,
                            decoration: certificate.imageUrl.isNotEmpty
                                ? TextDecoration.underline
                                : TextDecoration.none,
                            fontSize: 16,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Status',
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color:
                            Colors.green.shade100, // Assuming active if present
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        'Active', // Placeholder for Status (you might want to add a status field to Certificate model)
                        style: TextStyle(
                          color: Colors.green.shade700,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Publicly Accessible',
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    Consumer<AppStateProvider>(
                      // Use Consumer to listen for changes
                      builder: (context, appState, child) {
                        return Switch(
                          value: certificate
                              .isPublic, // Use the actual isPublic field
                          onChanged: (bool value) {
                            // Create a new Certificate object with the updated isPublic status
                            final updatedCert = Certificate(
                              id: certificate.id,
                              title: certificate.title,
                              description: certificate.description,
                              issuer: certificate.issuer,
                              issueDate: certificate.issueDate,
                              imageUrl: certificate.imageUrl,
                              isPublic: value, // Update the public status
                            );
                            // Call the update method in AppStateProvider
                            appState.updateCertificate(updatedCert);

                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  'Public accessibility changed to: $value',
                                ),
                              ),
                            );
                          },
                          activeColor: Colors.blue.shade700,
                        );
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Center(
                  child: Text(
                    '© 2023 Certificate Hub.',
                    style: Theme.of(
                      context,
                    ).textTheme.bodySmall?.copyWith(color: Colors.grey),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(BuildContext context, String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(
            context,
          ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        Text(value, style: Theme.of(context).textTheme.bodyLarge),
        const SizedBox(height: 15),
      ],
    );
  }
}
