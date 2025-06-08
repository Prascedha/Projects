// lib/models/certificate.dart
import 'dart:convert';

class Certificate {
  final String id;
  final String title;
  final String description;
  final String issuer;
  final DateTime issueDate;
  final String imageUrl;
  final bool isPublic;

  Certificate({
    required this.id,
    required this.title,
    required this.description,
    required this.issuer,
    required this.issueDate,
    this.imageUrl = '',
    this.isPublic = true,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'issuer': issuer,
      'issueDate': issueDate.toIso8601String(),
      'imageUrl': imageUrl,
      'isPublic': isPublic,
    };
  }

  // Create a Certificate object from a JSON map
  factory Certificate.fromJson(Map<String, dynamic> json) {
    return Certificate(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      issuer: json['issuer'] as String,
      issueDate: DateTime.parse(
        json['issueDate'] as String,
      ), // Convert String back to DateTime
      imageUrl: json['imageUrl'] as String? ??
          '', // Handle potential null for imageUrl
      isPublic: json['isPublic'] as bool? ??
          true, // Handle potential null for isPublic
    );
  }
}
