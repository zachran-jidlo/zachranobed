part of 'login_bloc.dart';

abstract class LoginEvent {}

class LoginEmailChanged extends LoginEvent {
  final String? email;

  LoginEmailChanged({this.email});
}

class LoginPasswordChanged extends LoginEvent {
  final String? password;

  LoginPasswordChanged({this.password});
}

class LoginSubmitted extends LoginEvent {}

class LoginImageLongPressed extends LoginEvent {}
