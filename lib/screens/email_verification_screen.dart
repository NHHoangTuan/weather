import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/subscription_provider.dart';

class EmailVerificationScreen extends StatefulWidget {
  final String email;
  final String token;

  const EmailVerificationScreen({
    Key? key,
    required this.email,
    required this.token,
  }) : super(key: key);

  @override
  State<EmailVerificationScreen> createState() =>
      _EmailVerificationScreenState();
}

class _EmailVerificationScreenState extends State<EmailVerificationScreen> {
  bool _isVerifying = true;
  bool _isVerified = false;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _verifyEmail();
  }

  Future<void> _verifyEmail() async {
    try {
      final result = await context
          .read<SubscriptionProvider>()
          .verifyEmail(widget.email, widget.token);

      setState(() {
        _isVerifying = false;
        _isVerified = result;
        if (!result) {
          _errorMessage =
              'Verification failed. The link may be invalid or expired.';
        }
      });
    } catch (e) {
      setState(() {
        _isVerifying = false;
        _errorMessage = e.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Email Verification'),
        backgroundColor: Colors.blue[600],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Card(
            elevation: 4,
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (_isVerifying)
                    Column(
                      children: [
                        const CircularProgressIndicator(),
                        const SizedBox(height: 24),
                        const Text(
                          'Verifying your email...',
                          style: TextStyle(fontSize: 18),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    )
                  else if (_isVerified)
                    Column(
                      children: [
                        Icon(
                          Icons.check_circle,
                          size: 80,
                          color: Colors.green[700],
                        ),
                        const SizedBox(height: 24),
                        const Text(
                          'Email Verified!',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Your email ${widget.email} has been successfully verified. You will now receive daily weather forecasts.',
                          style: const TextStyle(fontSize: 16),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    )
                  else
                    Column(
                      children: [
                        Icon(
                          Icons.error,
                          size: 80,
                          color: Colors.red[700],
                        ),
                        const SizedBox(height: 24),
                        const Text(
                          'Verification Failed',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          _errorMessage,
                          style: const TextStyle(fontSize: 16),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () => Navigator.of(context).pop(),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue[700],
                        foregroundColor: Colors.white,
                      ),
                      child: const Text(
                        'Back to App',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
