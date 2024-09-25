part of 'login_bloc.dart';

abstract class LoginEffect {}

class NavigateToDebugScreen extends LoginEffect {}

class NavigateToHomeScreen extends LoginEffect {}

class NavigateToAppTermsScreen extends LoginEffect {}

class ShowProgressDialog extends LoginEffect {}

class HideProgressDialog extends LoginEffect {}

class ShowErrorSnackBar extends LoginEffect {}
