

import 'package:formz/formz.dart';

enum StockError {empty, format, value}

class Stock extends FormzInput<int, StockError>{

  static final RegExp emailRegExp = RegExp(
    r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
  );

  const Stock.pure() : super.pure(0);

  const Stock.dirty(super.value) : super.dirty();

  String? get errorMessage{
    if (isValid || isPure) return null;

    if (displayError == StockError.empty) return 'El campo no puede estar vacio';
    if (displayError == StockError.value) return 'No puede ser menor a 0';

    return null;
  }

  @override
  StockError? validator(int value) {
    if (value.toString().isEmpty || value.toString().trim().isEmpty) return StockError.empty;
    if (value < 0) return StockError.value;
    return null;
  }
}
