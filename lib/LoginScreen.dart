import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hrms/AuthBloc.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is OtpGenerated) {
            if (kDebugMode) {
              print("----------------->${state.otp}");
            }
            Navigator.pushNamed(
              context,
              '/validateOtp',
              arguments:int.parse(_phoneController.text),
            );
          }
        },
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextField(
                controller: _phoneController,
                decoration: InputDecoration(labelText: 'Phone Number'),
                keyboardType: TextInputType.phone,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  final phoneNo = int.parse(_phoneController.text);
                  BlocProvider.of<AuthBloc>(context).add(GetOtpEvent(phoneNo));

                },
                child: Text('Get OTP'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
