extension StringExt on String? {
  bool get isNull => this == null;
  bool get isNullOrEmpty => this == null || this!.isEmpty;
  String get hardcode => this!;
}
