
import 'package:formz/formz.dart';

enum NameError {empty, length, format}

class Name extends FormzInput<String, NameError>{

  static final RegExp nameRegExp = RegExp('[a-zA-Z]');


  const Name.pure() : super.pure('');

  const Name.dirty(value) : super.dirty(value);

  String? get errorMessage {
    if (isPure || isValid) return null;

    if (displayError == NameError.empty) return 'El nombre no puede estar vacio';
    if (displayError == NameError.length) return 'El nombre es muy corto';
    if (displayError == NameError.format) return 'El nombre no es valido';

    return null;
  }

  @override
  NameError? validator(String value) {
    if (value.isEmpty || value.trim().isEmpty) return NameError.empty;
    if (value.length < 6) return NameError.length;
    if (!nameRegExp.hasMatch(value)) return NameError.format;

    return null;
  }



}