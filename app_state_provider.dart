// lib/providers/app_state_provider.dart
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert'; // Import for jsonEncode/jsonDecode
import 'package:flutter_application_1/models/certificate.dart'; // Import your Certificate model

class AppStateProvider with ChangeNotifier {
  String? _userType; // 'uploader' or 'viewer'
  List<Certificate> _certificates = []; // This will hold your certificates

  // Public getter for user type
  String? get userType => _userType;

  // Public getter for certificates (returns an unmodifiable list)
  List<Certificate> get certificates => List.unmodifiable(_certificates);

  AppStateProvider() {
    print('DEBUG AppStateProvider: Initializing AppStateProvider.');
    _loadUserType();
    _loadCertificates(); // Load certificates when the provider is created
  }

  // --- User Type Management ---
  Future<void> _loadUserType() async {
    final prefs = await SharedPreferences.getInstance();
    _userType = prefs.getString('userType');
    print(
        'DEBUG AppStateProvider: User type loaded from SharedPreferences: "$_userType"'); // Debug print
    notifyListeners();
  }

  Future<void> setUserType(String type) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('userType', type);
    _userType = type;
    print(
        'DEBUG AppStateProvider: User type set to: "$_userType" and saved to SharedPreferences'); // Debug print
    notifyListeners();
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('userType');
    _userType = null;
    print(
        'DEBUG AppStateProvider: User logged out. User type removed from SharedPreferences.'); // Debug print
    // Optionally clear certificates on logout if users don't share them
    // _certificates = []; // Uncomment if you want certificates to be cleared on logout
    notifyListeners();
  }

  // --- Certificate Management ---

  Future<void> _loadCertificates() async {
    final prefs = await SharedPreferences.getInstance();
    final String? certificatesJson = prefs.getString('certificates');
    if (certificatesJson != null) {
      final List<dynamic> jsonList = jsonDecode(certificatesJson);
      _certificates = jsonList
          .map((json) => Certificate.fromJson(json as Map<String, dynamic>))
          .toList();
      print(
          'DEBUG AppStateProvider: Certificates loaded from SharedPreferences: ${_certificates.length} certificates.'); // Debug print
    } else {
      print(
          'DEBUG AppStateProvider: No certificates found in SharedPreferences.'); // Debug print
    }
    notifyListeners(); // Notify after loading certificates
  }

  Future<void> _saveCertificates() async {
    final prefs = await SharedPreferences.getInstance();
    final String certificatesJson =
        jsonEncode(_certificates.map((cert) => cert.toJson()).toList());
    await prefs.setString('certificates', certificatesJson);
    print(
        'DEBUG AppStateProvider: Certificates saved to SharedPreferences: ${_certificates.length} certificates.'); // Debug print
  }

  void addCertificate(Certificate certificate) {
    _certificates.add(certificate);
    _saveCertificates(); // Save changes
    print(
        'DEBUG AppStateProvider: Added new certificate: ${certificate.id}'); // Debug print
    notifyListeners(); // Notify widgets listening to this provider
  }

  void updateCertificate(Certificate updatedCertificate) {
    final index =
        _certificates.indexWhere((cert) => cert.id == updatedCertificate.id);
    if (index != -1) {
      _certificates[index] = updatedCertificate;
      _saveCertificates(); // Save changes
      print(
          'DEBUG AppStateProvider: Updated certificate: ${updatedCertificate.id}'); // Debug print
      notifyListeners(); // Notify widgets
    }
  }

  void deleteCertificate(String certificateId) {
    _certificates.removeWhere((cert) => cert.id == certificateId);
    _saveCertificates(); // Save changes
    print(
        'DEBUG AppStateProvider: Deleted certificate: $certificateId'); // Debug print
    notifyListeners(); // Notify widgets
  }
}
