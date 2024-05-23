

import 'package:formz/formz.dart';

enum SlugError {empty, format}

class Slug extends FormzInput<String, SlugError>{

  static final RegExp emailRegExp = RegExp(
    r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
  );

  const Slug.pure() : super.pure('');

  const Slug.dirty(super.value) : super.dirty();

  String? get errorMessage{
    if (isValid || isPure) return null;

    if (displayError == SlugError.empty) return 'El campo no puede estar vacio';
    if (displayError == SlugError.format) return 'No es un formato correcto';


    return null;
  }

  @override
  SlugError? validator(String value) {
    if (value.isEmpty || value.trim().isEmpty) return SlugError.empty;
    if (value.contains("'") || value.contains(' ')) return SlugError.format;
    return null;
  }
}