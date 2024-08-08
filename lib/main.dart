import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hrms/AuthBloc.dart';
import 'package:hrms/DatabaseHelper.dart';
import 'package:hrms/LoginScreen.dart';
import 'package:hrms/ValidateOtpScreen.dart';

void main() {
  final DatabaseHelper databaseHelper = DatabaseHelper();

  runApp(MyApp(databaseHelper));
}

class MyApp extends StatelessWidget {
  final DatabaseHelper databaseHelper;

  MyApp(this.databaseHelper);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AuthBloc(databaseHelper),
      child: MaterialApp(
        title: 'Flutter Demo',
        initialRoute: '/',
        routes: {
          '/': (context) => LoginPage(),
          '/validateOtp': (context) => ValidateOtpPage(),
          '/dashboard': (context) => DashBoardPage(),
          '/register': (context) => RegisterPage(),
        },
      ),
    );
  }
}

// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:hrms/AuthBloc.dart';
// import 'package:hrms/DatabaseHelper.dart';

class RegisterPage extends StatelessWidget {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _designationController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final int phoneNo = ModalRoute.of(context)!.settings.arguments as int;

    // Set the phone number in the controller and disable it
    _phoneController.text = phoneNo.toString();

    return Scaffold(
      appBar: AppBar(
        title: Text('Register'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              controller: _phoneController,
              decoration: InputDecoration(labelText: 'Phone Number'),
              keyboardType: TextInputType.number,
              enabled: false, // Disable editing
            ),
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Name'),
            ),
            TextField(
              controller: _addressController,
              decoration: InputDecoration(labelText: 'Address'),
            ),
            TextField(
              controller: _designationController,
              decoration: InputDecoration(labelText: 'Designation'),
            ),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: 'Email'),
              keyboardType: TextInputType.emailAddress,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                final user = {
                  'userId': phoneNo,
                  'name': _nameController.text,
                  'address': _addressController.text,
                  'designation': _designationController.text,
                  'phone_no': phoneNo,
                  'email': _emailController.text,
                  'otp': null // OTP is not needed for this operation
                };

                final databaseHelper = DatabaseHelper();
                await databaseHelper.insertUser(user);

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Registration Successful!')),
                );

                // Navigate to the Dashboard page or any other page
                Navigator.pushReplacementNamed(context, '/dashboard');
              },
              child: Text('Register'),
            ),
          ],
        ),
      ),
    );
  }
}


class DashBoardPage extends StatelessWidget {
  const DashBoardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(child: Text("DashBoard"),);
  }
}

