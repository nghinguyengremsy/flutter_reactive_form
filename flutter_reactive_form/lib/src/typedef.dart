import 'form_field_control.dart';

typedef ValidationFunc<T> = String? Function(T v);
typedef FormGroup = Map<String, FormFieldControl>;
typedef FormDataChangeCallback = void Function(
    FormGroup form, FormFieldControl fieldChange);
