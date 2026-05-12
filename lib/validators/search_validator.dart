final _lettersOnly = RegExp(r'^[a-zA-Z ]+$');

String? validateSearch(String? value) {
  if (value == null || value.trim().isEmpty) return 'Enter an ingredient name';
  if (value.trim().length < 2) return 'At least 2 characters required';
  if (!_lettersOnly.hasMatch(value.trim())) return 'Letters only';
  return null;
}
