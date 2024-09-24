<!--
This README describes the package. If you publish this package to pub.dev,
this README's contents appear on the landing page for your package.

For information about how to write a good package README, see the guide for
[writing package pages](https://dart.dev/guides/libraries/writing-package-pages).

For general information about developing packages, see the Dart guide for
[creating packages](https://dart.dev/guides/libraries/create-library-packages)
and the Flutter guide for
[developing packages and plugins](https://flutter.dev/developing-packages).
-->

<!-- ## Features -->

## Minimum Requirements

- Dart SDK: >=2.18.6 <4.0.0
- Flutter: >=1.17.0

## Installation and Usage

Once you're familiar with Flutter you may install this package adding `flutter_reactive_form` to the dependencies list
of the `pubspec.yaml` file as follow:

```yaml
dependencies:
  flutter:
    sdk: flutter

  flutter_reactive_form: ^0.0.1
```

Then run the command `flutter packages get` on the console.

## Creating a form

A _form_ is composed by _multiple field controls_.

To declare a form with the fields _name_ and _birthday_ is as simple as:
 - _name_ have a default value.
 - _birthday_ is **null** by default.

```dart
final form = ReactiveForm(
    onChanged: (formData, fieldChanged) {
        /// Handle the change.
    },
    formGroup:{
        "name": FormFieldControl<String>(
          fieldEnum: "name",
          name: "Name",
          isRequired: true,
          isEnabled: true,
          data: "Nghi",
        ),
        "birthday": FormFieldControl<DateTime?>(
          fieldEnum: "birthday",
          name: "Birthday",
          isRequired: true,
          isEnabled: true,
          data: null,
        ),
    },
);
```

## How to get/set Form's data

You can get the value of a field:

```dart
String get name => _reactiveForm.getFieldData<String>(fieldEnum: 'name');
DateTime? get birthday => _reactiveForm.getFieldData<DateTime>(fieldEnum: 'birthday');

```


To set value to fields:

```dart
_reactiveForm.setFieldData(fieldEnum: 'name', data: "Kate");
```

## Validations

Set up your validations as follows:

```dart
_reactiveForm.setFormatValidationMap({
    'birthday': (birthday) {
      if (birthday == null || birthday.isAfter(DateTime.now())) {
         return "The time is invalid";
       }
       return '';
    },  
});
```
To validate a field:
```dart
final fieldControl = _reactiveForm.getField(fieldEnum: 'name');
final error = _reactiveForm.validateFormatField(fieldControl!);
```
To validate a form:
```dart
final errors = _reactiveForm.validateFormatFields();
```
## Using mixin
There're available functions in **ReactiveFormMixin** that interface with the form internally:
```dart
class ProfileFormController with ReactiveFormMixin {
  /// You can call it in state.initState()
  void init() {
    final form = ReactiveForm(
      onChanged: (formData, fieldChanged) {
        /// Handle the change.
      },
      formGroup: {
        "name": FormFieldControl<String>(
          fieldEnum: "name",
          name: "Name",
          isRequired: true,
          isEnabled: true,
          data: "Nghi",
        ),
        "birthday": FormFieldControl<DateTime?>(
          fieldEnum: "birthday",
          name: "Birthday",
          isRequired: true,
          isEnabled: true,
          data: null,
        ),
      },
    );
    initForm(form);
    setFormatValidationMap({
      'birthday': (birthday) {
        if (birthday == null || birthday.isAfter(DateTime.now())) {
          return "The time is invalid";
        }
        return '';
      },
    });
  }

  /// Interact with UI
  String? getName() {
    return getFieldData<String>(fieldEnum: 'name');
  }

  DateTime? getBirthday() {
    return getFieldData<DateTime>(fieldEnum: 'birthday')!;
  }

  void setName(String name) {
    setFieldData(fieldEnum: 'name', data: name);
  }

  void setBirthday(DateTime birthday) {
    setFieldData(fieldEnum: 'birthday', data: birthday);
  }
  ///
}
```