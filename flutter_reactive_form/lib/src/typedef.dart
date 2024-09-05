import 'form_field_control.dart';

typedef ValidationFunc = String Function(dynamic v);
typedef FormGroup = Map<String, FormFieldControl>;
typedef FormDataChangeCallback = void Function(
    FormGroup form, FormFieldControl fieldChange);
