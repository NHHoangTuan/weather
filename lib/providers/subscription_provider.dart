import 'package:flutter/material.dart';
import '../models/email_subscription.dart';
import '../services/email_service.dart';

enum SubscriptionStatus { initial, loading, success, error }

class SubscriptionProvider extends ChangeNotifier {
  final EmailService _emailService = EmailService();

  SubscriptionStatus _status = SubscriptionStatus.initial;
  String _errorMessage = '';
  List<EmailSubscription> _subscriptions = [];

  SubscriptionStatus get status => _status;
  String get errorMessage => _errorMessage;
  List<EmailSubscription> get subscriptions => _subscriptions;

  // Đăng ký nhận dự báo thời tiết
  Future<bool> subscribe(String email, String location) async {
    _status = SubscriptionStatus.loading;
    notifyListeners();

    try {
      // Kiểm tra xem email đã đăng ký chưa
      final existingSubscription = await _emailService.checkSubscription(email);

      if (existingSubscription != null) {
        if (existingSubscription.isVerified) {
          _errorMessage = 'Email này đã được đăng ký rồi';
          _status = SubscriptionStatus.error;
          notifyListeners();
          return false;
        } else {
          // Email chưa xác minh, gửi lại email xác minh
          await _emailService.sendVerificationEmail(existingSubscription);
          _status = SubscriptionStatus.success;
          notifyListeners();
          return true;
        }
      }

      // Tạo đăng ký mới
      final subscription = EmailSubscription.create(email, location);

      // Lưu đăng ký
      final saved = await _emailService.saveSubscription(subscription);

      if (!saved) {
        _errorMessage = 'Không thể lưu đăng ký';
        _status = SubscriptionStatus.error;
        notifyListeners();
        return false;
      }

      // Gửi email xác minh
      await _emailService.sendVerificationEmail(subscription);

      await loadSubscriptions();

      _status = SubscriptionStatus.success;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      _status = SubscriptionStatus.error;
      notifyListeners();
      return false;
    }
  }

  // Hủy đăng ký
  Future<bool> unsubscribe(String email) async {
    _status = SubscriptionStatus.loading;
    notifyListeners();

    try {
      // Kiểm tra xem email đã đăng ký chưa
      final existingSubscription = await _emailService.checkSubscription(email);

      if (existingSubscription == null) {
        _errorMessage = 'Email này chưa được đăng ký';
        _status = SubscriptionStatus.error;
        notifyListeners();
        return false;
      }

      // Hủy đăng ký
      final unsubscribed = await _emailService.unsubscribe(email);

      if (!unsubscribed) {
        _errorMessage = 'Không thể hủy đăng ký';
        _status = SubscriptionStatus.error;
        notifyListeners();
        return false;
      }

      await loadSubscriptions();

      _status = SubscriptionStatus.success;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      _status = SubscriptionStatus.error;
      notifyListeners();
      return false;
    }
  }

  // Xác minh email
  Future<bool> verifyEmail(String email, String token) async {
    _status = SubscriptionStatus.loading;
    notifyListeners();

    try {
      // Xác minh email
      final verified = await _emailService.verifyEmail(email, token);

      if (!verified) {
        _errorMessage = 'Không thể xác minh email';
        _status = SubscriptionStatus.error;
        notifyListeners();
        return false;
      }

      await loadSubscriptions();

      _status = SubscriptionStatus.success;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      _status = SubscriptionStatus.error;
      notifyListeners();
      return false;
    }
  }

  // Tải danh sách đăng ký
  Future<void> loadSubscriptions() async {
    try {
      _subscriptions = await _emailService.getAllSubscriptions();
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
    }
  }
}
