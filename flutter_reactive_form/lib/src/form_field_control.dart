class FormFieldControl<T> {
  FormFieldControl({
    required this.fieldEnum,
    required this.name,
    required T data,
    bool isEnabled = true,
    bool isRequired = false,
  }) {
    _data = data;
    _isEnabled = isEnabled;
    _isRequired = isRequired;
  }
  final String fieldEnum;
  final String name;

  /// data
  T? _data;
  T? get data => _data;
  set data(T? value) => _data = value;

  /// enable - disable
  bool _isEnabled = true;
  bool get isEnabled => _isEnabled;
  set isEnabled(bool value) => _isEnabled = value;

  /// optional - mandatory
  bool _isRequired = false;

  bool get isRequired => _isRequired;
  set isRequired(bool value) => _isRequired = value;
}
