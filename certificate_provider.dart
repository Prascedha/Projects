// lib/providers/certificate_provider.dart
import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/certificate.dart';

class CertificateProvider with ChangeNotifier {
  final List<Certificate> _certificates = [
    // --- UPDATED DUMMY DATA ---
    Certificate(
      id: 'ABC-1001-2023',
      title: 'Advanced Project Management', // Added title
      description:
          'Certification of completion for Advanced Project Management in the Digital Age.',
      issuer: 'Global Learning Institute', // Added issuer
      issueDate: DateTime(2023, 1, 15), // Changed to DateTime
      imageUrl:
          'https://example.com/certs/abc1001.png', // Changed from documentLink
    ),
    Certificate(
      id: 'XYZ-0502-2023',
      title: 'Environmental Compliance', // Added title
      description:
          'Environmental Compliance Certificate for manufacturing facility upgrade.',
      issuer: 'Environmental Agency', // Added issuer
      issueDate: DateTime(2023, 3, 30), // Changed to DateTime
      imageUrl:
          'https://example.com/certs/xyz0502.pdf', // Changed from documentLink
    ),
    // You can add more dummy data here with the new fields
  ];

  List<Certificate> get certificates => _certificates;

  void addCertificate(Certificate certificate) {
    _certificates.add(certificate);
    notifyListeners();
  }
}
