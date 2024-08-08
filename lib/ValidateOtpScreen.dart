import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hrms/AuthBloc.dart';

class ValidateOtpPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final int phoneNo = ModalRoute.of(context)!.settings.arguments as int;
    final TextEditingController _otpController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: Text('Validate OTP'),
      ),
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is OtpValidated) {
            if (state.success) {
              if (state.userExists) {
                // Navigate to Dashboard
                Navigator.pushReplacementNamed(context, '/dashboard');
              } else {
                // Navigate to Register page
                Navigator.pushReplacementNamed(context, '/register');
              }
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('OTP Validated Successfully!')),
              );
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Invalid OTP. Please try again.')),
              );
            }
          }
        },
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              BlocBuilder<AuthBloc, AuthState>(
                builder: (context, state) {
                  String otpHint = 'Enter OTP';
                  if (state is OtpGenerated) {
                    otpHint = 'OTP: ${state.otp}';
                  }
                  return TextField(
                    controller: _otpController,
                    decoration: InputDecoration(
                      labelText: 'Enter OTP',
                      hintText: otpHint,
                    ),
                    keyboardType: TextInputType.number,
                  );
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  final otp = int.parse(_otpController.text);
                  BlocProvider.of<AuthBloc>(context).add(ValidateOtpEvent(phoneNo, otp));
                },
                child: Text('Validate OTP'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
