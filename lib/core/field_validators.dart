import 'package:flutter/material.dart';

abstract class FieldValidators {
  const FieldValidators._();

  static FormFieldValidator<String> multiple(List<FormFieldValidator<String>> validators) {
    return (value) {
      for (final validator in validators) {
        final result = validator(value);
        if (result != null) return result;
      }
      return null;
    };
  }

  static FormFieldValidator<String> isRequired() {
    return (value) {
      if (value?.isEmpty ?? true) return 'Campo obrigatório';
      return null;
    };
  }
}
