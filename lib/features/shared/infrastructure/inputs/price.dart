


import 'package:formz/formz.dart';

enum PriceError {empty, value}

class Price extends FormzInput<double, PriceError>{

  static final RegExp emailRegExp = RegExp(
    r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
  );

  const Price.pure() : super.pure(0.0);

  const Price.dirty(super.value) : super.dirty();

  String? get errorMessage{
    if (isValid || isPure) return null;

    if (displayError == PriceError.empty) return 'El campo no puede estar vacio';
    if (displayError == PriceError.value) return 'El precio no puede ser menor a 0';


    return null;
  }

  @override
  PriceError? validator(double value) {
    if (value.toString().isEmpty || value.toString().trim().isEmpty) return PriceError.empty;
    if (value < 0) return PriceError.value;
    return null;
  }
}