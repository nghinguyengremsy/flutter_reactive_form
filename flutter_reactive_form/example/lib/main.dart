// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_reactive_form/flutter_reactive_form.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

enum ProfileFieldEnum {
  fullName("Full Name"),
  email("Email"),
  gender("Gender");

  final String label;
  const ProfileFieldEnum(this.label);
}

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final profileController = ProfileController();
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: ProfileScreen(controller: profileController),
    );
  }
}

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({
    Key? key,
    required this.controller,
  }) : super(key: key);
  final ProfileController controller;

  @override
  _ProfileScreenState createState() => _ProfileScreenState(controller);
}

class _ProfileScreenState extends StateMVC<ProfileScreen> {
  _ProfileScreenState(ProfileController controller) : super(controller) {
    _controller = controller;
  }
  late ProfileController _controller;

  @override
  void initState() {
    super.initState();
    _controller.onInit();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Profile')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _controller.formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              TextFormField(
                controller: _controller.fullNameController,
                decoration:
                    InputDecoration(labelText: ProfileFieldEnum.fullName.label),
                onChanged: _controller.onFullNameChanged,
                validator: _controller.validateFullName,
              ),
              TextFormField(
                controller: _controller.emailController,
                decoration:
                    InputDecoration(labelText: ProfileFieldEnum.email.label),
                onChanged: _controller.onEmailNameChanged,
                validator: _controller.validateEmail,
              ),
              DropdownButtonFormField<String>(
                decoration:
                    InputDecoration(labelText: ProfileFieldEnum.gender.label),
                value: _controller.getFieldData(
                    fieldEnum: ProfileFieldEnum.gender.name),
                items: ['Male', 'Female'].map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: _controller.onGenderChanged,
                validator: _controller.validateGender,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: ElevatedButton(
                  onPressed: _controller.create,
                  child: Text('Create'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.onDispose();
    super.dispose();
  }
}

class ProfileController extends ControllerMVC with ReactiveFormMixin {
  final formKey = GlobalKey<FormState>();
  late final TextEditingController fullNameController;
  late final TextEditingController emailController;
  void onInit() {
    /// TODO: Init your text for textfields.
    String initialFullName = '';
    String initialLastName = '';
    String initialGender = 'Male';

    fullNameController = TextEditingController(text: initialFullName);
    emailController = TextEditingController(text: initialLastName);
    final form = ReactiveForm(
      onChanged: (formData, fieldChanged) {
        /// Handle the change.
      },
      formGroup: {
        ProfileFieldEnum.fullName.name: FormFieldControl<String?>(
          fieldEnum: ProfileFieldEnum.fullName.name,
          name: ProfileFieldEnum.fullName.label,
          isRequired: true,
          isEnabled: true,
          data: initialFullName, // initial value.
        ),
        ProfileFieldEnum.email.name: FormFieldControl<String?>(
          fieldEnum: ProfileFieldEnum.email.name,
          name: ProfileFieldEnum.email.label,
          isRequired: true,
          isEnabled: true,
          data: initialLastName, // initial value.
        ),
        ProfileFieldEnum.gender.name: FormFieldControl<String?>(
          fieldEnum: ProfileFieldEnum.gender.name,
          name: ProfileFieldEnum.gender.label,
          isRequired: true,
          isEnabled: true,
          data: initialGender, // initial value.
        ),
      },
    );
    form.setFormatValidationMap({
      ProfileFieldEnum.fullName.name: (value) {
        assert(value is String?, " The value must be string.");
        final fullname = value as String?;
        if (fullname == null || fullname.isEmpty) {
          return "Please enter your full name";
        }
        return null;
      },
      ProfileFieldEnum.email.name: (value) {
        assert(value is String?, " The value must be string.");
        final email = value as String?;
        if (email == null || email.isEmpty) {
          return "Please enter an email";
        } else if (!(value?.contains('@') ?? false)) {
          return 'Email must contain the "@" character';
        }
        return null;
      },
      ProfileFieldEnum.gender.name: (value) {
        assert(value is String?, " The value must be string.");
        final gender = value as String?;
        if (gender == null || gender.isEmpty) {
          return "Please choose Gender";
        }
        return null;
      },
    });
    initForm(form);
  }

  void onFullNameChanged(String? value) {
    setFieldData(fieldEnum: ProfileFieldEnum.fullName.name, data: value);
  }

  void onEmailNameChanged(String? value) {
    setFieldData(fieldEnum: ProfileFieldEnum.email.name, data: value);
  }

  void onGenderChanged(String? value) {
    setFieldData(fieldEnum: ProfileFieldEnum.gender.name, data: value);
    refresh();
  }

  String? validateFullName(String? value) {
    final fullNameControl =
        getField(fieldEnum: ProfileFieldEnum.fullName.name)!;
    return validateFormatField(fullNameControl, value: value);
  }

  String? validateEmail(String? value) {
    final emailControl = getField(fieldEnum: ProfileFieldEnum.email.name)!;
    return validateFormatField(emailControl, value: value);
  }

  String? validateGender(String? value) {
    final genderControl = getField(fieldEnum: ProfileFieldEnum.gender.name)!;
    return validateFormatField(genderControl, value: value);
  }

  void create() {
    if (formKey.currentState!.validate()) {
      // Logic after validation succeeds
      final fullName =
          getFieldData<String>(fieldEnum: ProfileFieldEnum.fullName.name);
      final email =
          getFieldData<String>(fieldEnum: ProfileFieldEnum.email.name);
      final gender =
          getFieldData<String>(fieldEnum: ProfileFieldEnum.gender.name);
      print("fullName: $fullName, email: $email, gender: $gender");
      // Perform Profile (e.g., API call)
    }
  }

  void onDispose() {
    fullNameController.dispose();
    emailController.dispose();
  }
}
