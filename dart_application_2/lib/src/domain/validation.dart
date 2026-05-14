
typedef ValidationErrors = List<String>;


String? requiredNonEmpty(String? value, String fieldName) {
  if (value == null || value.trim().isEmpty) {
    return '$fieldName: обязательное поле, не может быть пустым';
  }
  return null;
}

String? positiveInt(int? value, String fieldName) {
  if (value == null) {
    return '$fieldName: обязательное числовое поле';
  }
  if (value <= 0) {
    return '$fieldName: значение должно быть больше 0';
  }
  return null;
}


String? validDateTime(String? value, String fieldName) {
  if (value == null || value.trim().isEmpty) {
    return '$fieldName: обязательное поле даты/времени';
  }
  try {
    DateTime.parse(value.trim());
    return null;
  } catch (_) {
    return '$fieldName: некорректный формат даты/времени (пример: 2026-05-07 14:30)';
  }
}


String? validLikeTargetType(String? value) {
  if (value == null || value.trim().isEmpty) {
    return 'тип цели: обязательное поле (article или podcast)';
  }
  final v = value.trim().toLowerCase();
  if (v != 'article' && v != 'podcast') {
    return 'тип цели: введите "article" или "podcast"';
  }
  return null;
}
