import 'package:flutter/material.dart';

class OtpVerificationView extends StatefulWidget {
  final String generatedOtp;
  final VoidCallback onVerified;

  const OtpVerificationView({
    super.key,
    required this.generatedOtp,
    required this.onVerified,
  });

  @override
  State<OtpVerificationView> createState() => _OtpVerificationViewState();
}

class _OtpVerificationViewState extends State<OtpVerificationView> {
  final TextEditingController _otpController = TextEditingController();
  String? _error;

  void _verifyOtp() {
    if (_otpController.text == widget.generatedOtp) {
      widget.onVerified();
      Navigator.pop(context);
    } else {
      setState(() {
        _error = "Invalid OTP. Try again.";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("OTP Verification")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const Text("Enter the 6-digit OTP sent to your email"),
            const SizedBox(height: 20),
            TextField(
              controller: _otpController,
              keyboardType: TextInputType.number,
              maxLength: 6,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: "OTP Code",
              ),
            ),
            if (_error != null)
              Text(_error!, style: const TextStyle(color: Colors.red)),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _verifyOtp,
              child: const Text("Verify"),
            )
          ],
        ),
      ),
    );
  }
}