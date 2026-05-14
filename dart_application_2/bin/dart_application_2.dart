import 'package:dart_application_2/dart_application_2.dart';

void main(List<String> arguments) {
  final db = AppDatabase.inApp();
  try {
    runMenu(db);
  } finally {
    db.close();
  }
}
