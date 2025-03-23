import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/email_subscription.dart';
import 'package:url_launcher/url_launcher.dart';

class EmailService {
  // Save subscription to SharedPreferences
  Future<bool> saveSubscription(EmailSubscription subscription) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final subscriptionsJson = prefs.getString('email_subscriptions') ?? '{}';
      final Map<String, dynamic> subscriptions = json.decode(subscriptionsJson);

      subscriptions[subscription.email] = subscription.toJson();

      await prefs.setString('email_subscriptions', json.encode(subscriptions));
      return true;
    } catch (e) {
      debugPrint('Error saving subscription: $e');
      return false;
    }
  }

  // Verify email
  Future<bool> verifyEmail(String email, String token) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final subscriptionsJson = prefs.getString('email_subscriptions') ?? '{}';
      final Map<String, dynamic> subscriptions = json.decode(subscriptionsJson);

      if (!subscriptions.containsKey(email)) {
        return false; // Email not found
      }

      final subscription = EmailSubscription.fromJson(subscriptions[email]);

      if (subscription.verificationToken != token) {
        return false; // Token mismatch
      }

      // Update subscription
      final updatedSubscription = subscription.copyWith(
        isVerified: true,
        verifiedAt: DateTime.now(),
      );

      subscriptions[email] = updatedSubscription.toJson();

      await prefs.setString('email_subscriptions', json.encode(subscriptions));
      return true;
    } catch (e) {
      debugPrint('Error verifying email: $e');
      return false;
    }
  }

  // Unsubscribe
  Future<bool> unsubscribe(String email) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final subscriptionsJson = prefs.getString('email_subscriptions') ?? '{}';
      final Map<String, dynamic> subscriptions = json.decode(subscriptionsJson);

      if (!subscriptions.containsKey(email)) {
        return false; // Email không tồn tại
      }

      subscriptions.remove(email);

      await prefs.setString('email_subscriptions', json.encode(subscriptions));
      return true;
    } catch (e) {
      debugPrint('Error unsubscribing: $e');
      return false;
    }
  }

  // Check if email is subscribed
  Future<EmailSubscription?> checkSubscription(String email) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final subscriptionsJson = prefs.getString('email_subscriptions') ?? '{}';
      final Map<String, dynamic> subscriptions = json.decode(subscriptionsJson);

      if (!subscriptions.containsKey(email)) {
        return null; // Email không tồn tại
      }

      return EmailSubscription.fromJson(subscriptions[email]);
    } catch (e) {
      debugPrint('Error checking subscription: $e');
      return null;
    }
  }

  // Get all subscriptions
  Future<List<EmailSubscription>> getAllSubscriptions() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final subscriptionsJson = prefs.getString('email_subscriptions') ?? '{}';
      final Map<String, dynamic> subscriptions = json.decode(subscriptionsJson);

      return subscriptions.values
          .map((data) => EmailSubscription.fromJson(data))
          .toList();
    } catch (e) {
      debugPrint('Error getting subscriptions: $e');
      return [];
    }
  }

  // Mô phỏng gửi email xác minh
  Future<bool> sendVerificationEmail(EmailSubscription subscription) async {
    try {
      // Trong ứng dụng thực tế, đây là nơi bạn sẽ gọi API để gửi email
      // Hiện tại, chúng ta sẽ mở trình duyệt với URL giả lập

      final verificationUrl =
          'https://weather-app.example.com/verify?email=${subscription.email}&token=${subscription.verificationToken}';

      // Trong ứng dụng thực tế, bạn sẽ không mở URL này
      // Thay vào đó, server của bạn sẽ gửi email có chứa URL này

      // Hiển thị URL này cho mục đích demo
      debugPrint('Verification URL: $verificationUrl');

      // Mô phỏng việc gửi email bằng cách mở URL
      if (await canLaunchUrl(Uri.parse(verificationUrl))) {
        await launchUrl(Uri.parse(verificationUrl));
      }

      return true;
    } catch (e) {
      debugPrint('Error sending verification email: $e');
      return false;
    }
  }
}
