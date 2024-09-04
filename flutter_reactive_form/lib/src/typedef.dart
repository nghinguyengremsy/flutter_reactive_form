import 'form_field_control.dart';

typedef ValidationFunc = String Function(dynamic v);
typedef FormControl = Map<String, FormFieldControl>;
typedef FormDataChangeCallback = void Function(FormControl);
