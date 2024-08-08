import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:hrms/DatabaseHelper.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final DatabaseHelper _databaseHelper;

  AuthBloc(this._databaseHelper) : super(AuthInitial()) {
    on<GetOtpEvent>(_onGetOtp);
    on<ValidateOtpEvent>(_onValidateOtp);
  }

  void _onGetOtp(GetOtpEvent event, Emitter<AuthState> emit) async {
    final phoneNo = event.phoneNo;
    final otp = _generateOtp();

    // Save OTP in the database
    final user = await _databaseHelper.getUserByPhone(phoneNo);
    if (user != null) {
      // User exists, update OTP if needed
      await _databaseHelper.updateUserOtp(phoneNo, otp);
    } else {
      // New user, insert with OTP
      final newUser = {
        'phone_no': phoneNo,
        'otp': otp,
      };
      await _databaseHelper.insertUser(newUser);
    }

    emit(OtpGenerated(otp));
  }

  void _onValidateOtp(ValidateOtpEvent event, Emitter<AuthState> emit) async {
    final phoneNo = event.phoneNo;
    final otp = event.otp;

    final user = await _databaseHelper.getUserByPhone(phoneNo);
    if (user != null && user['otp'] == otp) {
      final userId = user['userId'] as int?;
      if (userId != null) {
        // User exists
        await _setLoginStatus(true);
        emit(OtpValidated(success: true, userExists: true));
      } else {
        // User does not exist
        emit(OtpValidated(success: true, userExists: false));
      }
    } else {
      emit(OtpValidated(success: false, userExists: false));
    }
  }

  Future<void> _setLoginStatus(bool status) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', status);
  }

  int _generateOtp() {
    return 1000 + (DateTime.now().millisecondsSinceEpoch % 9000).toInt();
  }
}

abstract class AuthEvent {}

class GetOtpEvent extends AuthEvent {
  final int phoneNo;

  GetOtpEvent(this.phoneNo);
}

class ValidateOtpEvent extends AuthEvent {
  final int phoneNo;
  final int otp;

  ValidateOtpEvent(this.phoneNo, this.otp);
}

abstract class AuthState {}

class AuthInitial extends AuthState {}

class OtpGenerated extends AuthState {
  final int otp;

  OtpGenerated(this.otp);
}

class OtpValidated extends AuthState {
  final bool success;
  final bool userExists;

  OtpValidated({required this.success, required this.userExists});
}
