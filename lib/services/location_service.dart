import 'package:geolocator/geolocator.dart';
import 'package:flutter/material.dart';

class LocationService {
  // Kiểm tra và yêu cầu quyền truy cập vị trí
  Future<bool> _handleLocationPermission(BuildContext context) async {
    bool serviceEnabled;
    LocationPermission permission;

    // Kiểm tra dịch vụ vị trí có bật hay không
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Location services are disabled. Please enable them.'),
      ));
      return false;
    }

    // Kiểm tra quyền truy cập vị trí
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Location permissions are denied.'),
        ));
        return false;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text(
            'Location permissions are permanently denied. Please enable them in settings.'),
      ));
      return false;
    }

    return true;
  }

  // Lấy vị trí hiện tại
  Future<Position?> getCurrentPosition(BuildContext context) async {
    final hasPermission = await _handleLocationPermission(context);

    if (!hasPermission) return null;

    try {
      return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
    } catch (e) {
      debugPrint('Error getting location: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not get location: $e')),
      );
      return null;
    }
  }
}
