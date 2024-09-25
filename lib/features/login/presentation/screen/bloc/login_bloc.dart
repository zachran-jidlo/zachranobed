import 'dart:async';

import 'package:bloc_effects/bloc_effects.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zachranobed/common/domain/check_if_app_terms_should_be_shown_usecase.dart';
import 'package:zachranobed/common/logger/zo_logger.dart';
import 'package:zachranobed/features/login/domain/check_if_devtools_are_enabled_usecase.dart';
import 'package:zachranobed/notifiers/delivery_notifier.dart';
import 'package:zachranobed/notifiers/user_notifier.dart';
import 'package:zachranobed/services/auth_service.dart';

part 'login_effect.dart';

part 'login_event.dart';

part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> with Effects<LoginEffect> {
  final AuthService _authService;
  final CheckIfDevtoolsAreEnabledUseCase _checkIfDevtoolsAreEnabled;
  final CheckIfAppTermsShouldBeShownUseCase _checkIfAppTermsShouldBeShown;
  final UserNotifier _userNotifier;
  final DeliveryNotifier _deliveryNotifier;

  LoginBloc({
    required authService,
    required checkIfDevtoolsAreEnabled,
    required checkIfAppTermsShouldBeShown,
    required userNotifier,
    required deliveryNotifier,
  })  : _authService = authService,
        _checkIfDevtoolsAreEnabled = checkIfDevtoolsAreEnabled,
        _checkIfAppTermsShouldBeShown = checkIfAppTermsShouldBeShown,
        _userNotifier = userNotifier,
        _deliveryNotifier = deliveryNotifier,
        super(const LoginState()) {
    on<LoginEmailChanged>(_onEmailChanged);
    on<LoginPasswordChanged>(_onPasswordChanged);
    on<LoginSubmitted>(_onSubmitted);
    on<LoginImageLongPressed>(_onImageLongPressed);
  }

  void _onEmailChanged(
    LoginEmailChanged event,
    Emitter<LoginState> emit,
  ) async {
    emit(state.copyWith(email: event.email));
  }

  void _onPasswordChanged(
    LoginPasswordChanged event,
    Emitter<LoginState> emit,
  ) async {
    emit(state.copyWith(password: event.password));
  }

  Future<void> _onSubmitted(
    LoginSubmitted event,
    Emitter<LoginState> emit,
  ) async {
    emitEffect(ShowProgressDialog());

    final result = await _authService.signIn(state.email, state.password);
    if (result != null) {
      final user = await _authService.getUserData();

      _userNotifier.user = user;
      if (user != null) {
        _deliveryNotifier.init(user);
      }

      ZOLogger.logMessage("Přihlášen uživatel: ${user?.debugInfo}");

      final showAppTerms = await _checkIfAppTermsShouldBeShown.invoke();
      if (showAppTerms == true) {
        emitEffect(NavigateToAppTermsScreen());
      } else {
        emitEffect(NavigateToHomeScreen());
      }
    } else {
      emitEffect(HideProgressDialog());
      emitEffect(ShowErrorSnackBar());
    }
  }

  void _onImageLongPressed(
    LoginImageLongPressed event,
    Emitter<LoginState> emit,
  ) async {
    final areDevtoolsEnabled = _checkIfDevtoolsAreEnabled.invoke();
    if (areDevtoolsEnabled) {
      emitEffect(NavigateToDebugScreen());
    }
  }
}
