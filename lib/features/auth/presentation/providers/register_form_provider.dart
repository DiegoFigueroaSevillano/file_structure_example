
//1 CREAR EL STATE

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:formz/formz.dart';
import 'package:teslo_shop/features/auth/presentation/providers/login_form_provider.dart';
import 'package:teslo_shop/features/shared/infrastructure/inputs/email.dart';
import 'package:teslo_shop/features/shared/infrastructure/inputs/name.dart';
import 'package:teslo_shop/features/shared/infrastructure/inputs/password.dart';

class RegisterFormState {

  final bool isPosting;
  final bool isFormPosted;
  final bool isValid;
  final Name name;
  final Email email;
  final Password password;
  final Password validatePassword;

  RegisterFormState({
    this.isPosting = false,
    this.isFormPosted = false,
    this.isValid = false,
    this.name = const Name.pure(),
    this.email = const Email.pure(),
    this.password = const Password.pure(),
    this.validatePassword = const Password.pure()
  });

  @override
  String toString() {
    return 'RegisterFormState{isPosting: $isPosting, isFormPosted: $isFormPosted, isValid: $isValid, name: $name, email: $email, password: $password, validatePassword: $validatePassword}';
  }

  RegisterFormState copyWith({
    bool? isPosting,
    bool? isFormPosted,
    bool? isValid,
    Name? name,
    Email? email,
    Password? password,
    Password? validatePassword,
  }) {
    return RegisterFormState(
      isPosting: isPosting ?? this.isPosting,
      isFormPosted: isFormPosted ?? this.isFormPosted,
      isValid: isValid ?? this.isValid,
      name: name ?? this.name,
      email: email ?? this.email,
      password: password ?? this.password,
      validatePassword: validatePassword ?? this.validatePassword,
    );
  }
}

class RegisterFormNotifier extends StateNotifier<RegisterFormState> {
  RegisterFormNotifier() : super(RegisterFormState());

  onNameChange(String value){
    final newName = Name.dirty(value);
    state = state.copyWith(
      name: newName,
      isValid: Formz.validate([newName, state.email, state.password, state.validatePassword])
    );
  }

  onEmailChange(String value){
    final newEmail = Email.dirty(value);
    state = state.copyWith(
        email: newEmail,
        isValid: Formz.validate([state.name, newEmail, state.password, state.validatePassword])
    );
  }

  onPasswordChange(String value){
    final newPassword = Password.dirty(value);
    state = state.copyWith(
        password: newPassword,
        isValid: Formz.validate([state.name, newPassword, state.email, state.validatePassword])
    );
  }

  onValidatePasswordChange(String value){
    final newValidatePassword = Password.dirty(value);
    state = state.copyWith(
        password: newValidatePassword,
        isValid: Formz.validate([state.name, newValidatePassword, state.email, state.password])
    );
  }

  onFormSubmit() {
    _touchEveryField();
    if (!state.isValid) return;
    print(state);
  }

  _touchEveryField() {
    final email = Email.dirty(state.email.value);
    final password = Password.dirty(state.password.value);
    final name = Name.dirty(state.name.value);
    final validatePassword = Password.dirty(state.password.value);

    state = state.copyWith(
        isFormPosted: true,
        name: name,
        validatePassword: validatePassword,
        email: email,
        password: password,
        isValid: Formz.validate([email, password, name, validatePassword])
    );
  }
}

final RegisterProvider = StateNotifierProvider<RegisterFormNotifier, RegisterFormState>((ref) {
  return RegisterFormNotifier();
});
