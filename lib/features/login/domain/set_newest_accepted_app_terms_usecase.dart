import 'package:zachranobed/services/auth_service.dart';

class SetNewestAcceptedAppTermsUseCase {
  final AuthService authService;

  SetNewestAcceptedAppTermsUseCase(this.authService);

  Future<bool> setNewestAcceptedAppTerms() async {
    // FIXME: - Add newest app terms value fetch

    // FIXME: - Add user flag update call

    // FIXME: - Remove mock
    return Future.delayed(Duration(seconds: 1), () => true);
  }
}