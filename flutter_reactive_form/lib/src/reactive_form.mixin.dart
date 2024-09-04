import 'dart:collection';

import 'form_field_control.dart';
import 'reactive_form.dart';
import 'typedef.dart';

mixin ReactiveFormMixin {
  late ReactiveForm _form;

  UnmodifiableMapView<String, dynamic> get formControl => _form.formControl;
  void initForm(ReactiveForm form) {
    _form = form;
  }

  void setFormControl(FormControl formControl) {
    _form.setFormControl(formControl);
  }

  void setDefaultMandatoryValidation(ValidationFunc func) {
    _form.setDefaultMandatoryValidation(func);
  }

  void setMandatoryValidationMap(
      Map<String, ValidationFunc> mandatoryValidationMap) {
    _form.setMandatoryValidationMap(mandatoryValidationMap);
  }

  void setFormatValidationMap(Map<String, ValidationFunc> formatValidationMap) {
    _form.setFormatValidationMap(formatValidationMap);
  }

  void setFieldData({required String fieldEnum, required dynamic data}) {
    _form.setFieldData(fieldEnum: fieldEnum, data: data);
  }

  T? getFieldData<T>({required String fieldEnum}) {
    return _form.getFieldData<T>(fieldEnum: fieldEnum);
  }

  FormFieldControl<T?>? getField<T>({required String fieldEnum}) {
    return _form.getField<T>(fieldEnum: fieldEnum);
  }

  bool isRequiredField(String fieldEnum) => _form.isRequiredField(fieldEnum);
  bool isEnabledField(String fieldEnum, {bool defaultValue = true}) =>
      _form.isEnabledField(fieldEnum, defaultValue: defaultValue);

  String validateFormatField(FormFieldControl fieldControl, {dynamic value}) {
    return _form.validateFormatField(fieldControl, value: value);
  }

  String validateRequiredField(FormFieldControl fieldControl, {dynamic value}) {
    return _form.validateRequiredField(fieldControl, value: value);
  }

  List<String> validateRequiredFields() => _form.validateRequiredFields();
  List<String> validateFormatFields() => _form.validateFormatFields();
  void enableField(String fieldEnum) => _form.enableField(fieldEnum);

  void disableField(String fieldEnum) => _form.disableField(fieldEnum);

  void markAsRequiredField(String fieldEnum) =>
      _form.markAsRequiredField(fieldEnum);

  void markAsOptionalField(String fieldEnum) =>
      _form.markAsOptionalField(fieldEnum);
}
