// lib/widgets/certificate_card.dart
import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/certificate.dart';

class CertificateCard extends StatelessWidget {
  final Certificate certificate;

  // No longer a default, expect it from the model
  // The 'isPublic' in the model itself should determine this.
  // The card should reflect the model's state.

  const CertificateCard({
    super.key,
    required this.certificate,
  });

  @override
  Widget build(BuildContext context) {
    // Determine the color based on the actual certificate.isPublic property
    bool isPublic = certificate.isPublic; // Directly use the model's property

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 0),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.document_scanner_outlined,
                    color: Colors.blue.shade700),
                const SizedBox(width: 8),
                Text(
                  certificate.id,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const Spacer(),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    // Use actual isPublic from the certificate model
                    color: isPublic
                        ? Colors.blue.shade100
                        : Colors.purple.shade100,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Text(
                    // Use actual isPublic from the certificate model
                    isPublic ? 'Public' : 'Private',
                    style: TextStyle(
                      fontSize: 12,
                      // Use actual isPublic from the certificate model
                      color: isPublic
                          ? Colors.blue.shade700
                          : Colors.purple.shade700,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            // Display Title
            Text(
              'Title:',
              style: TextStyle(fontSize: 13, color: Colors.grey[600]),
            ),
            Text(
              certificate.title, // Use new title field
              style: const TextStyle(
                  fontSize: 14,
                  color: Colors.black87,
                  fontWeight: FontWeight.w500),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 5),
            // Display Issuer
            Text(
              'Issuer:',
              style: TextStyle(fontSize: 13, color: Colors.grey[600]),
            ),
            Text(
              certificate.issuer, // Use new issuer field
              style: const TextStyle(fontSize: 14, color: Colors.black87),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 10),
            // Display Document Link (now imageUrl)
            Text(
              'Document Link:',
              style: TextStyle(fontSize: 13, color: Colors.grey[600]),
            ),
            GestureDetector(
              onTap: () {
                // Handle opening document link (e.g., using url_launcher package)
                print(
                    'Opening document link: ${certificate.imageUrl}'); // Use imageUrl
              },
              child: Text(
                certificate.imageUrl, // Use imageUrl
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.blue,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Description:',
              style: TextStyle(fontSize: 13, color: Colors.grey[600]),
            ),
            Text(
              certificate.description,
              style: const TextStyle(fontSize: 14, color: Colors.black87),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Issued: ${certificate.issueDate.toIso8601String().split('T')[0]}', // Format DateTime for display
                  style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                ),
                TextButton.icon(
                  onPressed: () {
                    print('View Details for ${certificate.id} tapped');
                  },
                  icon: Icon(Icons.arrow_forward,
                      size: 16, color: Colors.blue.shade700),
                  label: Text(
                    'View Details',
                    style: TextStyle(color: Colors.blue.shade700),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
