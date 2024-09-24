import 'dart:collection';
import 'extensions.dart';
import 'form_field_control.dart';
import 'typedef.dart';

class ReactiveForm {
  ReactiveForm({
    required this.onChanged,
    FormGroup? formGroup,
  }) {
    if (formGroup != null) {
      setFormGroup(formGroup);
    }
  }
  final FormDataChangeCallback onChanged;

  Map<String, ValidationFunc> _formatValidationMap = {};
  Map<String, ValidationFunc> _mandatoryValidationMap = {};
  ValidationFunc _defaultMandatoryValidation = (v) {
    if (v == null) {
      return "This field is required";
    }
    if (v is String? && v.isNullOrEmpty) {
      return "This field is required";
    }
    return null;
  };
  late FormGroup _formGroup;
  UnmodifiableMapView<String, dynamic> get formGroup =>
      UnmodifiableMapView<String, dynamic>(_formGroup);
  void setDefaultMandatoryValidation(ValidationFunc func) {
    _defaultMandatoryValidation = func;
  }

  void setFormatValidationMap(Map<String, ValidationFunc> formatValidationMap) {
    _formatValidationMap =
        Map<String, ValidationFunc>.from(formatValidationMap);
  }

  void setMandatoryValidationMap(
      Map<String, ValidationFunc> mandatoryValidationMap) {
    _mandatoryValidationMap =
        Map<String, ValidationFunc>.from(mandatoryValidationMap);
  }

  void setFormGroup(FormGroup formGroup) {
    _formGroup = Map<String, FormFieldControl>.from(formGroup);
  }

  void setFieldData({required String fieldEnum, required dynamic data}) {
    final fieldControl = _formGroup[fieldEnum];
    assert(fieldControl != null, "The field $fieldEnum must be created before");
    fieldControl?.data = data;
    onChanged.call(_formGroup, fieldControl!);
  }

  T? getFieldData<T>({required String fieldEnum}) {
    return _formGroup[fieldEnum]?.data as T?;
  }

  FormFieldControl<T?>? getField<T>({required String fieldEnum}) {
    return _formGroup[fieldEnum] as FormFieldControl<T?>?;
  }

  bool isRequiredField(String fieldEnum, {bool defaultValue = false}) {
    return _formGroup[fieldEnum]?.isRequired ?? defaultValue;
  }

  bool isEnabledField(String fieldEnum, {bool defaultValue = true}) {
    return _formGroup[fieldEnum]?.isEnabled ?? defaultValue;
  }

  List<String> validateFormatFields() {
    final errors = <String>[];
    for (final requiredField in _formatValidationMap.keys) {
      final fieldControl = getField(fieldEnum: requiredField);
      if (fieldControl == null) {
        continue;
      }
      final error = validateFormatField(fieldControl);
      if (error != null && error.isNotEmpty) {
        // debugPrint(
        //     "[Form][Validation][Format][${fieldData.fieldEnum}][error] $error");
        errors.add(error);
      }
    }

    return errors;
  }

  List<String> validateRequiredFields() {
    final errors = <String>[];
    final requiredFields =
        _formGroup.values.where((e) => e.isRequired).toList();
    for (final fieldControl in requiredFields) {
      final error = validateRequiredField(fieldControl);

      if (error != null && error.isNotEmpty) {
        // debugPrint(
        //     "[Form][Validation][Mandatory][${fieldData.fieldEnum}][error] $error");
        errors.add(fieldControl.name);
      }
    }

    return errors;
  }

  String? validateFormatField(FormFieldControl fieldControl, {dynamic value}) {
    final data = value ?? fieldControl.data;
    final validationFnc = _formatValidationMap[fieldControl.fieldEnum];
    final error = validationFnc?.call(data);
    return error;
  }

  String? validateRequiredField(FormFieldControl fieldData, {dynamic value}) {
    final data = value ?? fieldData.data;
    final validationFnc = _mandatoryValidationMap[fieldData.fieldEnum] ??
        _defaultMandatoryValidation;
    final error = validationFnc.call(data);
    return error;
  }

  void enableField(String fieldEnum) {
    final fieldControl = _formGroup[fieldEnum];
    fieldControl?.isEnabled = true;
  }

  void disableField(String fieldEnum) {
    final fieldControl = _formGroup[fieldEnum];
    fieldControl?.isEnabled = false;
  }

  void markAsRequiredField(String fieldEnum) {
    final fieldControl = _formGroup[fieldEnum];
    fieldControl?.isRequired = true;
  }

  void markAsOptionalField(String fieldEnum) {
    final fieldControl = _formGroup[fieldEnum];
    fieldControl?.isRequired = false;
  }
}
