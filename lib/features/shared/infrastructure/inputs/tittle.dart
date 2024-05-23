

import 'package:formz/formz.dart';

enum TittleError {empty, format}

class Tittle extends FormzInput<String, TittleError>{

  static final RegExp emailRegExp = RegExp(
    r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
  );

  const Tittle.pure() : super.pure('');

  const Tittle.dirty(super.value) : super.dirty();

  String? get errorMessage{
    if (isValid || isPure) return null;

    if (displayError == TittleError.empty) return 'El campo no puede estar vacio';

    return null;
  }

  @override
  TittleError? validator(String value) {
    if (value.isEmpty || value.trim().isEmpty) return TittleError.empty;
    return null;
  }
}